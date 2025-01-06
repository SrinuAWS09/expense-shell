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

mkdir -p /var/log/expense-logs
echo "Script started here:$TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf install nginx -y  &>>$LOG_FILE_NAME
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOG_FILE_NAME
VALIDATE $? "Enable nginx"

systemctl start nginx &>>$LOG_FILE_NAME
VALIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE_NAME
VALIDATE $? "Removed the html data"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "Downloading latest data"
cd /usr/share/nginx/html &>>$LOG_FILE_NAME
VALIDATE $? "Moving to HTML directory"

unzip /tmp/frontend.zip &>>$LOG_FILE_NAME
VALIDATE $? "Unzip the frontend files"

systemctl restart nginx &>>$LOG_FILE_NAME
VALIDATE $? "Restart the niginx services"

