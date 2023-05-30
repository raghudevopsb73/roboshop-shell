source common.sh
component=payment

roboshop_app_password=$1
if [ -z "$roboshop_app_password" ]; then
  echo roboshop_app_password is missing
  exit 1
fi

python
