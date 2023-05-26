echo -e "\e[33m Disable MySQL Default Version \e[0m"
yum module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[33m Install MySQL Community Server \e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log

echo -e "\e[33m Start MySQL Service \e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl restart mysqld &>>/tmp/roboshop.log

echo -e "\e[33m Setup MySQL Password \e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log
