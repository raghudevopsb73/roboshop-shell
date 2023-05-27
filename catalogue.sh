component=catalogue
color="\e[36m"
nocolor="\e[0m"

echo -e "${color} Configuring NodeJS Repos ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>/tmp/roboshop.log

echo -e "${color} Install NodeJS${nocolor}"
yum install nodejs -y  &>>/tmp/roboshop.log

echo -e "${color} Add Application User${nocolor}"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "${color} Create Application Directory ${nocolor}"
rm -rf /app  &>>/tmp/roboshop.log
mkdir /app

echo -e "${color} Download Application Content${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip  &>>/tmp/roboshop.log
cd /app

echo -e "${color} Extract Application Content${nocolor}"
unzip /tmp/$component.zip  &>>/tmp/roboshop.log
cd /app

echo -e "${color} Install NodeJS Dependencies${nocolor}"
npm install  &>>/tmp/roboshop.log

echo -e "${color} Setup SystemD Service  ${nocolor}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>/tmp/roboshop.log

echo -e "${color} Start $component Service ${nocolor}"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable $component  &>>/tmp/roboshop.log
systemctl restart $component  &>>/tmp/roboshop.log

echo -e "${color} Copy MongoDB Repo file ${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>/tmp/roboshop.log

echo -e "${color} Install MongoDB Client ${nocolor}"
yum install mongodb-org-shell -y  &>>/tmp/roboshop.log

echo -e "${color} Load Schema ${nocolor}"
mongo --host mongodb-dev.devopsb73.store </app/schema/$component.js  &>>/tmp/roboshop.log