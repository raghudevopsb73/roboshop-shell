echo -e "\e[33mCopy MongoDB Repo file \e[0m"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo
echo -e "\e[33mInstalling MongoDB Server\e[0m"
yum install mongodb-org -y
## Modify the config file
echo -e "\e[33mStart MongoDB Service\e[0m"
systemctl enable mongod
systemctl restart mongod
