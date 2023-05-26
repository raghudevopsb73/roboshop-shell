echo -e "\e[33mConfiguring NodeJS Repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>/tmp/roboshop.log

echo -e "\e[33m Install NodeJS\e[0m"
yum install nodejs -y  &>>/tmp/roboshop.log

echo -e "\e[33m Add Application User\e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[33m Create Application Directory \e[0m"
rm -rf /app  &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[33m Download Application Content\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[33m Extract Application Content\e[0m"
unzip /tmp/cart.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[33m Install NodeJS Dependencies\e[0m"
npm install  &>>/tmp/roboshop.log

echo -e "\e[33m Setup SystemD Service  \e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service  &>>/tmp/roboshop.log

echo -e "\e[33m Start Cart Service \e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable cart  &>>/tmp/roboshop.log
systemctl restart cart  &>>/tmp/roboshop.log

