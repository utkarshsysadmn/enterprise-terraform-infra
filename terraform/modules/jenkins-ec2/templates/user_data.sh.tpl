#!/bin/bash
set -euxo pipefail

############################################################
# Update System
############################################################
dnf update -y

############################################################
# Install Required Packages
############################################################
dnf install -y \
    git \
    wget \
    unzip \
    nginx \
    java-21-amazon-corretto \
    amazon-cloudwatch-agent

############################################################
# Enable NGINX
############################################################
systemctl enable nginx
systemctl start nginx

############################################################
# Install Terraform
############################################################
cd /tmp

wget https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_linux_amd64.zip

unzip terraform_1.13.0_linux_amd64.zip

mv terraform /usr/local/bin/

chmod +x /usr/local/bin/terraform

terraform version

############################################################
# Install AWS CLI v2
############################################################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip

unzip awscliv2.zip

./aws/install

aws --version

############################################################
# Install Jenkins Repository
############################################################
wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

############################################################
# Install Jenkins
############################################################
dnf install -y jenkins

systemctl daemon-reload

systemctl enable jenkins

systemctl start jenkins

############################################################
# Configure NGINX Reverse Proxy
############################################################
cat > /etc/nginx/conf.d/jenkins.conf <<EOF

server {

    listen 80;

    server_name _;

    client_max_body_size 100M;

    location / {

        proxy_pass http://127.0.0.1:8080;

        proxy_http_version 1.1;

        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        proxy_read_timeout 90;

    }

}

EOF

nginx -t

systemctl restart nginx

############################################################
# Configure CloudWatch Agent
############################################################
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },

  "metrics": {

    "namespace": "Jenkins",

    "append_dimensions": {

      "InstanceId": "$${aws:InstanceId}",
      "InstanceType": "$${aws:InstanceType}",
      "ImageId": "$${aws:ImageId}"

    },

    "metrics_collected": {

      "cpu": {

        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_user",
          "cpu_usage_system"
        ],

        "totalcpu": true

      },

      "mem": {

        "measurement": [
          "mem_used_percent"
        ]

      },

      "disk": {

        "measurement": [
          "used_percent"
        ],

        "resources": [
          "*"
        ],

        "ignore_file_system_types": [
          "sysfs",
          "tmpfs",
          "devtmpfs"
        ]

      },

      "swap": {

        "measurement": [
          "swap_used_percent"
        ]

      }

    }

  }

}
EOF

systemctl enable amazon-cloudwatch-agent

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
-s

############################################################
# Welcome Page
############################################################
cat > /home/ec2-user/JENKINS_INFO.txt <<EOF

============================================

Enterprise Jenkins Server

============================================

Project      : ${project_name}
Environment  : ${environment}

Hostname     : $(hostname)

Date         : $(date)

Jenkins URL

http://PUBLIC-IP

Initial Password

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Terraform

terraform version

AWS CLI

aws --version

============================================

EOF