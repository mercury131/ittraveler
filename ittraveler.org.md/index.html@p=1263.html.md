# Установка и настройка кластера MongoDB (replication set)                	  
***Дата: 15.09.2019 Автор Admin***

В этой статье мы рассмотрим как установить и настроить кластер MongoDB (replication set), создать базы, пользователей, включить авторизацию по ключу.
 
Установка MongoDB делается следующим образом:
 на Ubuntu:
Импортируем публичный ключ
```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
Создаем list файл с данными репозитория
Создаем /etc/apt/sources.list.d/mongodb-org-4.0.list
```
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
```
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
Устанавливаем MongoDB
```
sudo apt-get update
sudo apt-get install -y mongodb-org
```
sudo apt-get update&nbsp;sudo apt-get install -y mongodb-org
на CentOS:
Создаем файл с данными по репозиторию /etc/yum.repos.d/mongodb-org-4.0.repo
```
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
```
[mongodb-org-4.0]&nbsp;name=MongoDB Repository&nbsp;baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/&nbsp;&nbsp;gpgcheck=1&nbsp;enabled=1&nbsp;gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
Устанавливаем MongoDB
```
sudo yum install -y mongodb-org
```
sudo yum install -y mongodb-org
Для установки на Windows ставим KB2999226 и скачиваем и устанавливаем msi с MongoDB Download Center (https://www.mongodb.com/download&#8212;center/community?jmp=docs)
 
После установки открываем конфиг MongoDB, в /etc на Linux или в каталоге C:\Program Files\MongoDB\Server\4.0\bin\ на Windows
 в конфиге настраиваем сетевые интерфейсы, добавьте ip адрес сервера
 
```
# network interfaces
net:
  port: 27017
  bindIp: localhost,192.168.1.10
```
# network interfaces&nbsp;net:&nbsp;  port: 27017&nbsp;  bindIp: localhost,192.168.1.10
Перезапустите сервис MongoDB
Далее создадим ключ для авторизации между нодами MongoDB, сделать это можно через openssl
```
 openssl rand -base64 756 &gt; &lt;path-to-keyfile&gt;
```
 openssl rand -base64 756 &gt; &lt;path-to-keyfile&gt;
Создаем супер пользователя, для этого запускаем  консоль mongo и выполняем:
```
db.createUser(
  {
    user: "mongo-root",
    pwd: "Password",
    roles: [ { role: "root", db: "admin" } ]
  }
)
```
db.createUser(&nbsp;  {&nbsp;    user: "mongo-root",&nbsp;    pwd: "Password",&nbsp;    roles: [ { role: "root", db: "admin" } ]&nbsp;  }&nbsp;)
&nbsp;
Теперь создадим пользователя с правами администратора
```
db.createUser({user:"mongoadmin", pwd:"password",roles:["userAdminAnyDatabase","dbAdmin"]})
```
db.createUser({user:"mongoadmin", pwd:"password",roles:["userAdminAnyDatabase","dbAdmin"]})
Далее редактируем конфиг следующим образом, добавляем или редактируем секции:
```
#включаем авторизацию по ключам
security:
  keyFile: C:\Program Files\MongoDB\Server\4.0\bin\mongo.key
  authorization: enabled
#указываем replication set
replication:
   replSetName: "rs0"
```
#включаем авторизацию по ключам&nbsp;security:&nbsp;  keyFile: C:\Program Files\MongoDB\Server\4.0\bin\mongo.key&nbsp;  authorization: enabled&nbsp;&nbsp;&nbsp;&nbsp;#указываем replication set&nbsp;replication:&nbsp;   replSetName: "rs0"
&nbsp;
Сохраняем конфиг, копируем ключ по пути указанному в keyFile и перезапускаем сервис MongoDB
Выполнить эти действия нужно на всех серверах MongoDB
Теперь подключаемся к консоли MongoDB и авторизуемся на одной из нод:
```
mongo
```
mongo
```
db.auth("mongo-root", "Password")
```
db.auth("mongo-root", "Password")
Далее добавляем все ноды в кластер:
```
rs.initiate( {
   _id : "rs0",
   members: [
      { _id: 0, host: "mongo-1.local:27017" },
      { _id: 1, host: "mongo-2.local:27017" },
      { _id: 2, host: "mongo-3.local:27017" }
   ]
})
```
rs.initiate( {&nbsp;   _id : "rs0",&nbsp;   members: [&nbsp;      { _id: 0, host: "mongo-1.local:27017" },&nbsp;      { _id: 1, host: "mongo-2.local:27017" },&nbsp;      { _id: 2, host: "mongo-3.local:27017" }&nbsp;   ]&nbsp;})
&nbsp;
Изменить приоритет серверов можно следующим образом:
 получаем текущий конфиг:
```
 conf = rs.conf()
```
 conf = rs.conf()
Выставляем приоритеты:
```
conf['members'][0].priority = 7
conf['members'][1].priority = 5
conf['members'][2].priority = 1
```
conf['members'][0].priority = 7&nbsp;conf['members'][1].priority = 5&nbsp;conf['members'][2].priority = 1
Применяем изменения:
```
rs.reconfig(conf)
```
rs.reconfig(conf)
Проверяем что изменения были применены:
```
rs.conf()['members']
```
rs.conf()['members']
Настройка кластера на этом завершена, перейдем к настройке БД.
Подключаемся к MongoDB
```
 mongo
```
 mongo
&nbsp;
Создаем базу
```
use new_database
```
use new_database
Добавим в нее тестовую запись
```
 db.new_collection2.insert({ some_key: "some_value" })
```
 db.new_collection2.insert({ some_key: "some_value" })
Чтобы очистить все данные в БД выполните следующие команды:
```
 use new_database;
db.dropDatabase();
```
 use new_database;&nbsp;db.dropDatabase();
Посмотрим данные в бд
```
 show collections
```
 show collections
Создадим пользователя для БД
```
 db.createUser(
  {
    user: "dbadmin",
    pwd: "password",
    roles: [ { role: "readWrite", db: "new_database" } ]
  }
)
```
 db.createUser(&nbsp;  {&nbsp;    user: "dbadmin",&nbsp;    pwd: "password",&nbsp;    roles: [ { role: "readWrite", db: "new_database" } ]&nbsp;  }&nbsp;)
&nbsp;
Посмотреть список пользователей можно командой:
```
 db.getUsers()
```
 db.getUsers()
Посмотреть список созданных БД можно командой
```
 show dbs
```
 show dbs
Для импорта/ экспорта БД используйте следующие команды:
```
 mongorestore --archive=test.20150715.archive --db test
```
 mongorestore --archive=test.20150715.archive --db test
Для экспорта:
```
mongodump --archive=test.20150715.archive --db test
```
mongodump --archive=test.20150715.archive --db test
Если нужно использовать логин / пароль или подключаться к внешнему серверу добавьте параметры:
```
--host mongodb1.example.net --port 37017 --username user --password "pass"
```
--host mongodb1.example.net --port 37017 --username user --password "pass"
На этом основная настройка завершена.
 
Ну и напоследок, для повышения уровня безопасности MongoDB, не выставляйте ее наружу, тщательно настраивайте правила на ваших firewall, в идеале чтобы к кластеру могли подключаться только клиенты и сами ноды кластера.
