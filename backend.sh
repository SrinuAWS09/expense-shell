#!/bin/bash

NO=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f2)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOG_FOLDER/$LOG_FILE-$TIMESTAMP.log"
echo "script started at : $TIMESTAMP" &>>$LOG_FILE_NAME

VALIDATE(){
    if [ $1 -ne 0 ]
        then
            echo -e "ERROR: Installation is $R failed $N...$2"
            exit 1
        else 
            echo -e " Installation $G success $N.. $2"
        fi
}
CHECK_ROOT(){

if [ $NO -ne 0 ]
then
    echo "ERROR: This is not root user"
    exit 1
fi
}

echo "Script started here:$TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf module disable nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "disable nodejs"
dnf module enable nodejs:20 -y &>>$LOG_FILE_NAME
VALIDATE $? "enable nodejs"
dnf install nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "Install nodejs"

id expense &>>$LOG_FILE_NAME
if [ $? -ne 0 ]
then 
   useradd expense &>>$LOG_FILE_NAME
   VALIDATE $? "user is adding"
else 
   echo "User is already there"
fi

mkdir -p /app &>>$LOG_FILE_NAME
VALIDATE $? " Creating Directory"
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
cd /app
unzip /tmp/backend.zip &>>$LOG_FILE_NAME
VALIDATE $? "Unzip files"
cd /app
npm install &>>$LOG_FILE_NAME
VALIDATE $? "NPM installed"
cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOG_FILE_NAME
VALIDATE $? "Copied"
systemctl daemon-reload &>>$LOG_FILE_NAME
VALIDATE $? "Daemon is reloaded"
systemctl start backend &>>$LOG_FILE_NAME
VALIDATE $? "stated backend"
systemctl enable backend &>>$LOG_FILE_NAME
VALIDATE $? "enabled backend"
dnf install mysql -y &>>$LOG_FILE_NAME
VALIDATE $? "Installed mysql "
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE_NAME
VALIDATE $? "mysql validation"
systemctl restart backend &>>$LOG_FILE_NAME
VALIDATE $? "restart backend"




