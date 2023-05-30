color="\e[35m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"
user_id=$(id -u)
if [ $user_id -ne 0 ]; then
  echo Script should be running with sudo
  exit 1
fi

stat_check() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    exit 1
  fi
}

app_presetup() {
  echo -e "${color} Add Application User${nocolor}"
  id roboshop &>>$log_file
  if [ $? -eq 1 ]; then
    useradd roboshop  &>>$log_file
  fi
  stat_check $?

  echo -e "${color} Create Application Directory ${nocolor}"
  rm -rf /app   &>>$log_file
  mkdir /app
  stat_check $?

  echo -e "${color} Download Application Content ${nocolor}"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>$log_file
  stat_check $?

  echo -e "${color} Extract Application Content${nocolor}"
  cd ${app_path}
  unzip /tmp/$component.zip  &>>$log_file
  stat_check $?
}

systemd_setup() {
  echo -e "${color} Setup SystemD Service  ${nocolor}"
  cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>$log_file
  sed -i -e "s/roboshop_app_password/$roboshop_app_password/"  /etc/systemd/system/$component.service
  stat_check $?

  echo -e "${color} Start $component Service ${nocolor}"
  systemctl daemon-reload  &>>$log_file
  systemctl enable $component  &>>$log_file
  systemctl restart $component  &>>$log_file
  stat_check $?
}

nodejs() {
  echo -e "${color} Configuring NodeJS Repos ${nocolor}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>$log_file
  stat_check $?

  echo -e "${color} Install NodeJS${nocolor}"
  yum install nodejs -y  &>>$log_file
  stat_check $?

  app_presetup

  echo -e "${color} Install NodeJS Dependencies${nocolor}"
  npm install  &>>$log_file
  stat_check $?

  systemd_setup
}

mongo_schema_setup() {
  echo -e "${color} Copy MongoDB Repo file ${nocolor}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>$log_file
  stat_check $?

  echo -e "${color} Install MongoDB Client ${nocolor}"
  yum install mongodb-org-shell -y  &>>$log_file
  stat_check $?

  echo -e "${color} Load Schema ${nocolor}"
  mongo --host mongodb-dev.devopsb73.store <${app_path}/schema/$component.js  &>>$log_file
  stat_check $?
}

mysql_schema_setup() {
  echo -e "${color} Install MySQL Client ${nocolor}"
  yum install mysql -y  &>>$log_file
  stat_check $?

  echo -e "${color} Load Schema ${nocolor}"
  mysql -h mysql-dev.devopsb73.store -uroot -p${mysql_root_password} </app/schema/${component}.sql   &>>$log_file
  stat_check $?
}

maven() {
  echo -e "${color} Install Maven ${nocolor}"
  yum install maven -y  &>>$log_file
  stat_check $?

  app_presetup
  
  echo -e "${color} Download Maven Dependencies ${nocolor}"
  mvn clean package  &>>$log_file
  mv target/${component}-1.0.jar ${component}.jar  &>>$log_file
  stat_check $?
  
  mysql_schema_setup
  systemd_setup

}

python() {
  echo -e "${color} Install Python ${nocolor}"
  yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
  stat_check $?

  app_presetup

  echo -e "${color} Install Application Dependencies ${nocolor}"
  cd /app
  pip3.6 install -r requirements.txt &>>/tmp/roboshop.log
  stat_check $?

  systemd_setup
}
