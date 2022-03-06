#!/bin/bash
# ---------------------------------
# EC2 user data
# Autoscaling startup scripts.
# ---------------------------------
APP_NAME=all-done-note-server
BUCKET_NAME=all-done-note-dev-deploy-bucket-ocxvsa
CWD=/home/ec2-user

# Log output setting
LOGFILE="/var/log/initialize.log"
exec > "${LOGFILE}"
exec 2>&1

# Change current work directory
cd ${CWD}

# Get latest resources.

aws s3 cp s3://${BUCKET_NAME}/install-middleware.sh /home/ec2-user
aws s3 cp s3://${BUCKET_NAME}/${APP_NAME}.service /home/ec2-user
aws s3 cp s3://${BUCKET_NAME}/${APP_NAME}.zip ${CWD}
mkdir -p middleware
cp install-middleware.sh middleware
cp ${APP_NAME}.service middleware
sudo sh install-middleware.sh
sudo cp ./${APP_NAME}.service /etc/systemd/system/
sudo systemctl daemon-reload
# Decompress zip
rm -rf ${CWD}/${APP_NAME}
unzip "${CWD}/${APP_NAME}.zip" -d "${CWD}"
# Move to application directory
sudo mv ${APP_NAME}/ /opt/


#start app
sudo systemctl enable all-done-note-server
sudo systemctl start all-done-note-server
