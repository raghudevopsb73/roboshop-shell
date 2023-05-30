source common.sh

echo -e " ${color}  Configure Erlang repos  ${nocolor} "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?

echo -e " ${color}  Configure RabbitMQ Repos  ${nocolor} "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?

echo -e " ${color}  Install RabbitMQ Server  ${nocolor} "
yum install rabbitmq-server -y &>>/tmp/roboshop.log
stat_check $?

echo -e " ${color}  Start RabbitMQ Service  ${nocolor} "
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl restart rabbitmq-server &>>/tmp/roboshop.log
stat_check $?

echo -e " ${color}  Add RabbitMQ Application User ${nocolor} "
rabbitmqctl add_user roboshop $1 &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log
stat_check $?

