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

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing mysql server"
systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Enableing my sql server" 
 systemctl start mysqld &>>$LOG_FILE_NAME
 VALIDATE $? "star the mysql server" 
 mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE_NAME
 VALIDATE $? "Setting Root password"
