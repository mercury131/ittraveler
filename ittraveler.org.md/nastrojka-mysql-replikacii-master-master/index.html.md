# Настройка Mysql репликации Master &#8212; Master                	  
***Дата: 23.06.2015 Автор Admin***

Рассмотрим настройку репликации Mysql.
Обновляем пакеты на каждом из серверов:
```
apt-get update
```
apt-get update
```
apt-get upgrade
```
apt-get upgrade
Установим Mysql сервер и клиент, сделать это нужно на двух серверах.
```
apt-get install mysql-server mysql-client
```
apt-get install mysql-server mysql-client
Открываем файл /etc/mysql/my.cnf
Изменяем в конфиге следующие строки:
```
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = example_DB
# bind-address = 127.0.0.1
```
server-id = 1log_bin = /var/log/mysql/mysql-bin.logbinlog_do_db = example_DB# bind-address = 127.0.0.1
В данном конфиге:
server-id &#8212; номер id mysql сервера
log_bin &#8212; путь к бинарному логу, в него пишутся изменения
binlog_do_db &#8212; название БД, которую мы будем реплицировать
# bind-address &#8212; строка закоментирована, т.к. сервер должен работать не только на localhost
Перезапускаем mysql сервер
```
service mysql restart
```
service mysql restart
Перейдем к настройке репликации.
Подключаемся к Mysql.
```
mysql -u root -p
```
mysql -u root -p
Создадим пользователя replicator
```
create user 'replicator'@'%' identified by 'password';
```
create user 'replicator'@'%' identified by 'password';
Создаем базу данных, которую мы будем реплицировать.
```
create database example_DB;
```
create database example_DB;
Назначим права пользователю
```
grant replication slave on *.* to 'replicator'@'%';
```
grant replication slave on *.* to 'replicator'@'%';
Проверить статус репликации можно командой:
```
show master status;
```
show master status;
Запоминаем параметры File (mysql-bin.000001) и Position (107). Эти параметры нам понадобятся на втором сервере.
Отключаемся от консоли mysql
```
exit
```
exit
Переходим на второй mysql сервер и правим конфиг файл /etc/mysql/my.cnf
Конфиг файл второго сервера будет отличаться только id
```
server-id = 2
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = example_DB
# bind-address = 127.0.0.1
```
server-id = 2log_bin = /var/log/mysql/mysql-bin.logbinlog_do_db = example_DB# bind-address = 127.0.0.1
Перезапускаем mysql на втором сервере
```
service mysql restart
```
service mysql restart
Повторяем операцию по созданию пользователя.
```
mysql -u root –p
```
mysql -u root –p
```
create user 'replicator'@'%' identified by 'password';
```
create user 'replicator'@'%' identified by 'password';
Создаем базу данных, которую мы будем реплицировать.
```
create database example_DB;
```
create database example_DB;
Назначим права пользователю.
```
grant replication slave on *.* to 'replicator'@'%';
```
grant replication slave on *.* to 'replicator'@'%';
Запускаем процесс репликации
```
slave stop;
```
slave stop;
Параметры MASTER_LOG_FILE и MASTER_LOG_POS берем с первого сервера (вывод команды show master status;)
```
CHANGE MASTER TO MASTER_HOST = 'ip address first mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 107;
```
CHANGE MASTER TO MASTER_HOST = 'ip address first mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 107;
```
slave start;
```
slave start;
Теперь посмотрим статус репликации:
```
SHOW MASTER STATUS;
```
SHOW MASTER STATUS;
```
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000004 | 107      | example_DB   |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
```
+------------------+----------+--------------+------------------+| File&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Position | Binlog_Do_DB | Binlog_Ignore_DB |+------------------+----------+--------------+------------------+| mysql-bin.000004 | 107&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| example_DB&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|+------------------+----------+--------------+------------------+1 row in set (0.00 sec)
Запоминаем название файла и параметр позиции, эти данные понадобятся нам при включении репликации на первом сервере.
Теперь вернемся на первый сервер и включим репликацию на нем:
```
slave stop;
```
slave stop;
Меняем параметры MASTER_LOG_FILE и MASTER_LOG_POS полученные ранее из команды SHOW MASTER STATUS;
```
CHANGE MASTER TO MASTER_HOST = 'ip address second mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000004', MASTER_LOG_POS = 107;
```
CHANGE MASTER TO MASTER_HOST = 'ip address second mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000004', MASTER_LOG_POS = 107;
```
slave start;
```
slave start;
Теперь репликация работает на двух серверах.
Проведем тестирование, выполним на первом сервере команду в консоли mysql:
```
create table example_DB.test_table2 (`id` varchar(10));
```
create table example_DB.test_table2 (`id` varchar(10));
Теперь выполним команду на втором сервере:
```
show tables in example_DB;
```
show tables in example_DB;
Вывод должен быть с созданной таблицей
```
+----------------------+
| Tables_in_example_DB |
+----------------------+
| test_table           |
+----------------------+
1 row in set (0.00 sec)
```
+----------------------+| Tables_in_example_DB |+----------------------+| test_table&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |+----------------------+1 row in set (0.00 sec)
Как видите репликация работает, таблица создалась.
