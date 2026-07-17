#!/bin/bash
set -euxo pipefail

########################################
# Update OS
########################################
dnf update -y

########################################
# Install NGINX
########################################
dnf install -y nginx

systemctl enable nginx
systemctl start nginx

########################################
# Install CloudWatch Agent
########################################
dnf install -y amazon-cloudwatch-agent

mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {

    "namespace": "CWAgent",

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
        "totalcpu": true,
        "metrics_collection_interval": 60
      },

      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
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
          "devtmpfs",
          "tmpfs"
        ],
        "metrics_collection_interval": 60
      },

      "swap": {
        "measurement": [
          "swap_used_percent"
        ],
        "metrics_collection_interval": 60
      },

      "diskio": {
        "measurement": [
          "reads",
          "writes"
        ],
        "metrics_collection_interval": 60
      },

      "net": {
        "measurement": [
          "bytes_sent",
          "bytes_recv"
        ],
        "metrics_collection_interval": 60
      }

    }
  }
}
EOF

########################################
# Enable CloudWatch Agent
########################################
systemctl enable amazon-cloudwatch-agent

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
-s

########################################
# Create NGINX Welcome Page
########################################
cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
<title>Enterprise Terraform Infrastructure</title>
<style>
body{
    font-family:Arial;
    text-align:center;
    margin-top:80px;
}
table{
    margin:auto;
    border-collapse:collapse;
}
td{
    padding:10px 20px;
    border:1px solid #ddd;
}
</style>
</head>

<body>

<h1>🚀 Enterprise Terraform Infrastructure</h1>

<h2>NGINX Installed Successfully</h2>

<table>

<tr>
<td><strong>Project</strong></td>
<td>${project_name}</td>
</tr>

<tr>
<td><strong>Environment</strong></td>
<td>${environment}</td>
</tr>

<tr>
<td><strong>Hostname</strong></td>
<td>$(hostname)</td>
</tr>

<tr>
<td><strong>Date</strong></td>
<td>$(date)</td>
</tr>

<tr>
<td><strong>Managed By</strong></td>
<td>Terraform</td>
</tr>

</table>

</body>
</html>
EOF