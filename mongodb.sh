echo -e "\e[33mCopy MongoDB Repo file \e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo   &>>/tmp/roboshop.log

echo -e "\e[33mInstalling MongoDB Server\e[0m"
yum install mongodb-org -y  &>>/tmp/roboshop.log

echo -e "\e[33mUpdate MongoDB Listen Address\e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

echo -e "\e[33mStart MongoDB Service\e[0m"
systemctl enable mongod  &>>/tmp/roboshop.log
systemctl restart mongod  &>>/tmp/roboshop.log
