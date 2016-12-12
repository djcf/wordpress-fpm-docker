DROP USER '$db_user'@'%';
CREATE USER '$db_user'@'%' IDENTIFIED BY '$db_password';
CREATE DATABASE $db_name;
ASSIGN ALL ON $db_name.* to '$db_user'@'%';