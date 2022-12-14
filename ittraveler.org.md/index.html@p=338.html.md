# Установка и настройка Radius сервера на Ubuntu с веб интерфейсом.                	  
***Дата: 14.04.2015 Автор Admin***

В данной статье будет рассмотрено как установить Radius сервер FreeRadius с веб интерфейсом Daloradius
Перед установкой обновите все пакеты в системе
```
apt-get update
```
apt-get update
```
apt-get upgrade
```
apt-get upgrade
Установим Apache2 и PHP
```
apt-get install apache2
```
apt-get install apache2
```
apt-get install php5 libapache2-mod-php5 php5-mysql php5-gd php-pear php-db
```
apt-get install php5 libapache2-mod-php5 php5-mysql php5-gd php-pear php-db
Модули php5-gd php-pear php-db необходимы для работы веб интерфейса Daloradius
Устанавливаем Mysql сервер
```
apt-get install mysql-server
```
apt-get install mysql-server
Устанавливаем FreeRadius
```
apt-get install freeradius
```
apt-get install freeradius
Подключаемся к серверу Mysql
```
#mysql -u root -p
```
#mysql -u root -p
Далее создаем базу данных radius
```
#mysql&gt; create database radius;
```
#mysql&gt; create database radius;
Назначим полные права пользователю radius
```
#mysql&gt; grant all on radius.* to radius@localhost identified by "P@$$w0rd";
```
#mysql&gt; grant all on radius.* to radius@localhost identified by "P@$$w0rd";
Отключаемся от Mysql
```
#mysql&gt; exit
```
#mysql&gt; exit
Устанавливаем пакет freeradius-mysql
```
apt-get install freeradius-mysql
```
apt-get install freeradius-mysql
Импортируем таблицы в базу данных radius
```
#mysql -u root -p radius &lt; /etc/freeradius/sql/mysql/schema.sql
```
#mysql -u root -p radius &lt; /etc/freeradius/sql/mysql/schema.sql
```
#mysql -u root -p radius &lt; /etc/freeradius/sql/mysql/nas.sql
```
#mysql -u root -p radius &lt; /etc/freeradius/sql/mysql/nas.sql
Для проверки добавим тестовые значения в таблицу radcheck
```
#mysql -u root -p
```
#mysql -u root -p
```
#mysql&gt; use radius;
```
#mysql&gt; use radius;
```
#mysql&gt; INSERT INTO radcheck (UserName, Attribute, Value) VALUES ('sqltest', 'Password', 'testpwd');
```
#mysql&gt; INSERT INTO radcheck (UserName, Attribute, Value) VALUES ('sqltest', 'Password', 'testpwd');
```
#mysql&gt; exit
```
#mysql&gt; exit
(adsbygoogle = window.adsbygoogle || []).push({});
Открываем файл настроек Freeradius для MySQL
Расположение файла &#8212; /etc/freeradius/sql.conf
Редактируем строки до такого вида:
```
database = mysql
login = radius
password = thepassword
readclients = yes
```
database = mysqllogin = radiuspassword = thepasswordreadclients = yes
Далее открываем файл сайта Freeradius
Расположение файла &#8212; /etc/freeradius/sites-enabled/default
Приводим следующие строки к виду:
```
Uncomment sql on authorize{}
# See “Authorization Queries” in sql.conf
sql
...
Uncomment sql on accounting{}
# See “Accounting queries” in sql.conf
sql
...
Uncomment sql on session{}
# See “Simultaneous Use Checking Queries” in sql.conf
sql
...
Uncomment sql on post-auth{}
# See “Authentication Logging Queries” in sql.conf
sql
...
```
Uncomment sql on authorize{}# See “Authorization Queries” in sql.confsql...Uncomment sql on accounting{}# See “Accounting queries” in sql.confsql...Uncomment sql on session{}# See “Simultaneous Use Checking Queries” in sql.confsql...Uncomment sql on post-auth{}# See “Authentication Logging Queries” in sql.confsql...
(adsbygoogle = window.adsbygoogle || []).push({});
Далее правим основной конфигурационный файл Freeradius и включаем поддержку Mysql
Расположение файла &#8212; /etc/freeradius/radiusd.conf
```
#Uncomment #$INCLUDE sql.conf
$INCLUDE sql.conf
```
#Uncomment #$INCLUDE sql.conf$INCLUDE sql.conf
Теперь протестируем настройки сервера.
Откройте 2 ssh окна терминала.
В первом окне остановим сервис Freeradius
```
service freeradius stop
```
service freeradius stop
И запустим сервис в режиме debug
```
freeradius -X - debug mode
```
freeradius -X - debug mode
Теперь открываем второе окно терминала и вводим запрос
```
radtest sqltest testpwd localhost 18128 testing123
```
radtest sqltest testpwd localhost 18128 testing123
Если вывод команды такой:
```
Sending Access-Request of id 68 to 127.0.0.1 port 1812
User-Name = "sqltest"
User-Password = "testpwd"
NAS-IP-Address = 127.0.1.1
NAS-Port = 18128
rad_recv: Access-Accept packet from host 127.0.0.1 port 1812, id=68, length=20
```
Sending Access-Request of id 68 to 127.0.0.1 port 1812User-Name = "sqltest"User-Password = "testpwd"NAS-IP-Address = 127.0.1.1NAS-Port = 18128rad_recv: Access-Accept packet from host 127.0.0.1 port 1812, id=68, length=20
То все впорядке.
Теперь нужно добавить Radius клиентов в файл /etc/freeradius/clients.conf
Пример добавления:
```
client 192.168.1.0/16 {
secret = secretpass
shortname = testclient
nastype= testdevice
}
```
client 192.168.1.0/16 {&nbsp;secret = secretpassshortname = testclientnastype= testdevice}
Установим веб интерфейс DaloRadius
Скачиваем последнюю версию ПО
```
wget http://downloads.sourceforge.net/project/daloradius/daloradius/daloradius0.9-9/daloradius-0.9-9.tar.gz
```
wget http://downloads.sourceforge.net/project/daloradius/daloradius/daloradius0.9-9/daloradius-0.9-9.tar.gz
Распаковываем в текущий каталог
```
tar xvfz daloradius-0.9-9.tar.gz
```
tar xvfz daloradius-0.9-9.tar.gz
Переносим в папку /var/www/
```
mv daloradius-0.9-9 /var/www/daloradius
```
mv daloradius-0.9-9 /var/www/daloradius
Импортируем таблицы в базу данных radius
```
cd /var/www/daloradius/contrib/db
```
cd /var/www/daloradius/contrib/db
```
mysql -u root -p radius &lt; mysql-daloradius.sql
```
mysql -u root -p radius &lt; mysql-daloradius.sql
Далее правим конфиг веб интерфейса
Расположение файла &#8212; /var/www/daloradius/library/daloradius.conf.php
Редактируем строку $configValues[&#8216;CONFIG_DB_PASS&#8217;] = &#187;;
В нее вводим наш пароль к БД
Должно получится так :
```
$configValues['CONFIG_DB_PASS'] = 'Пароль от root к Mysql';
```
$configValues['CONFIG_DB_PASS'] = 'Пароль от root к Mysql';
Если хотите использователь пользователя отличного от root измените строку
```
$configValues['CONFIG_DB_USER'] = 'root';
```
$configValues['CONFIG_DB_USER'] = 'root';
Теперь веб интерфейс доступен по адресу http://serveraddress/daloradius
Если вместо  веб интерфейса вы видите ошибку 404, откройте файл /etc/apache2/sites-available/000-default.conf
измените строку DocumentRoot /var/www/html на DocumentRoot /var/www
Стандартные логин и пароль к daloradius:
Логин &#8212; Administrator
Пароль &#8212; radius
Данные о пользователе можно изменить через меню интерфейса, как это сделать показано на скриншоте:
Related posts:Перенос виртуальной машины из Hyper-V в Proxmox (KVM)Настройка работы прокси сервера SQUID через сторонний прокси сервер.Установка и настройка веб сервера Apache 2
 Linux, Web, Сети 
 Метки: Radius  
                        
Комментарии
        
Алексей
  
25.06.2015 в 07:25 - 
Ответить                                
Приветствую автора статьи! У меня появился один вопрос! сделал все как написано, все вроде получилось но веб интерфейс не открывается даже в localhost пишет Not Found
The requested URL /daloradius was not found on this server.
Apache/2.4.7 (Ubuntu) Server at 10.1.0.90 Port 80
В линуксе не очень силен если честно!  в чем может быть проблема?
        
Admin
  
25.06.2015 в 09:39 - 
Ответить                                
Добрый день! 
На какой версии ubuntu установлен daloradius?
Веб интерфейс расположен в папке /var/www/daloradius/ ?
Если да, то все должно работать, попробуйте добавить следующие строки в файл /etc/apache2/apache2.conf
Options FollowSymLinks
AllowOverride all
Require all granted
Если в браузере ввести ip сервера, у вас открывается страница приветствия apache?
        
Даниил
  
13.07.2015 в 15:31 - 
Ответить                                
Здравствуйте воспроизводил данную инструкцию на Ubuntu Server 14.04, приветственную страницу Apache2 вижу, веб интерфейс расположен в папке /var/www/daloradius, но при запуске веб интерфейса daloradius  то бишь ссылки http:/serveraddress.com/daloradius
выдаёт ошибку
( Not Found
The requested URL /daloradius was not found on this server.
Additionally, a 404 Not Found error was encountered while trying to use an ErrorDocument to handle the request.)
может есть какой нюанс?
        
Admin
  
27.07.2015 в 14:53 - 
Ответить                                
Добрый день! Добавил ответ в статью.
        
Вадим
  
24.07.2015 в 01:53 - 
Ответить                                
Добрый день.
Делаю все как у Вас написано, но ситуация как у Алексея:
&#171;The requested URL /daloradius was not found on this server.
Apache/2.4.7 (Ubuntu) Server at  *.*.*.* Port 80&#187;
Делал как Вы сказали добавил строчки
&#171;Options FollowSymLinks
AllowOverride all
Require all granted&#187;
Просто перестала появляться страница, что страница не найдена!
Страница &#171;АПАЧА&#187; появляется!
        
Admin
  
27.07.2015 в 14:53 - 
Ответить                                
Добрый день! Извиняюсь за долгий ответ.
Если вместо  веб интерфейса вы видите ошибку 404, откройте файл /etc/apache2/sites-available/000-default.conf
измените строку DocumentRoot /var/www/html на DocumentRoot /var/www
Добавил в статью.
        
Даниил
  
02.09.2015 в 13:28 - 
Ответить                                
Хочу сказать вам спасибо за статью, очень помогла, вот только правда запутался в этой строке (http://serveraddress/daloradius), ведь место слова serveraddress &#8212; надо указать свой IP адрес сервера!  Еще раз спасибо!
        
Роман
  
05.01.2016 в 12:20 - 
Ответить                                
У меня Радиус не хочет видеть/принимать пользователей, которые прописаны в mysql базе.
Если прописываю пользователя в файл users, то без проблем проходит, а из базы нет.
Радиус базу видит, данные считывает, но любому пользователю, который прописан в базе, отвечает:
rad_recv: Access-Reject packet from host 127.0.0.1 port 1812, id=241, length=20
root@ATMOSPHERE-NET:~# radtest sqltest testpwd 127.0.0.1 1812 testing123
Sending Access-Request of id 236 to 127.0.0.1 port 1812
User-Name = &#171;sqltest&#187;
User-Password = &#171;testpwd&#187;
NAS-IP-Address = 127.0.0.1
NAS-Port = 1812
rad_recv: Access-Reject packet from host 127.0.0.1 port 1812, id=236, length=20
В базе логин и пароль прописаны:
mysql&gt; select * from radcheck where UserName=&#8217;sqltest&#8217;;
+&#8212;-+&#8212;&#8212;&#8212;-+&#8212;&#8212;&#8212;&#8212;+&#8212;-+&#8212;&#8212;&#8212;+
| id | username | attribute | op | value |
+&#8212;-+&#8212;&#8212;&#8212;-+&#8212;&#8212;&#8212;&#8212;+&#8212;-+&#8212;&#8212;&#8212;+
| 1 | sqltest | Password | == | testpwd |
+&#8212;-+&#8212;&#8212;&#8212;-+&#8212;&#8212;&#8212;&#8212;+&#8212;-+&#8212;&#8212;&#8212;+
4 rows in set (0.07 sec)
Пробовал так:
mysql&gt; select * from radcheck where UserName=&#8217;wifiuser&#8217;;
+&#8212;-+&#8212;&#8212;&#8212;-+&#8212;&#8212;&#8212;&#8212;+&#8212;-+&#8212;&#8212;&#8212;+
| id | username | attribute | op | value |
+&#8212;-+&#8212;&#8212;&#8212;-+&#8212;&#8212;&#8212;&#8212;+&#8212;-+&#8212;&#8212;&#8212;+
| 1 | wifiuser | User-Password | == | wifipass |
+&#8212;-+&#8212;&#8212;&#8212;-+&#8212;&#8212;&#8212;&#8212;+&#8212;-+&#8212;&#8212;&#8212;+
4 rows in set (0.07 sec)
root@ATMOSPHERE-NET:~# radtest wifiuser wifipass 127.0.0.1 18128 testing123
Sending Access-Request of id 144 to 127.0.0.1 port 1812
User-Name = &#171;wifiuser&#187;
User-Password = &#171;wifipass&#187;
NAS-IP-Address = 127.0.0.1
NAS-Port = 18128
rad_recv: Access-Reject packet from host 127.0.0.1 port 1812, id=144, length=20
Причем, если прописать пользователей в файл, неважно с == либо как у меня с :=, то все работает без проблем. Именно из базы не хочет принимать пользователей, хотя при запуске, считывает данные из базы.
        
Роман
  
05.01.2016 в 12:20 - 
Ответить                                
Что не так я настроил?
        
Admin
  
09.02.2016 в 08:58 - 
Ответить                                
А вы уверены что есть коннект к базе? Проверьте права на mysql.
Как ошибка звучит?
        
Admin
  
09.02.2016 в 09:39 - 
Ответить                                
Попробуйте ещё почитать оф. документацию, может помочь &#8212;http://wiki.freeradius.org/guide/SQL-HOWTO
        
Serge
  
14.01.2016 в 07:39 - 
Ответить                                
Огромное спасибо автору! Все доступно, понятно. Удачи в написании статей.
        
red
  
28.01.2016 в 16:54 - 
Ответить                                
Огромная благодарность за пошаговую инструкцию, очень помогла! Спасибо!
        
vitalik
  
10.10.2016 в 11:53 - 
Ответить                                
Добрый день!
Sending Access-Request of id 164 to 127.0.0.1 port 1812
User-Name = &#171;sqltest&#187;
User-Password = &#171;testpwd&#187;
NAS-IP-Address = 127.0.1.1
NAS-Port = 18128
radclient: no response from server for ID 164 socket 3
Что не так я настроил?
        
Admin
  
24.04.2017 в 12:22 - 
Ответить                                
Проверьте не включен ли firewall, возможно у вас из-за этого сервер не доступен. Еще можете просканировать сервер через nmap, сразу станет понятно есть ли между ними связь и какие порты доступны.
        
melrog
  
28.04.2017 в 14:53 - 
Ответить                                
Добрый день, при вводе команды mysql -u root -p radius &lt; /etc/freeradius/sql/mysql/schema.sql     говорит, что отказано в доступе, пробовал с sudo, пробовал в ключ -p прописывать пароль (-pПАРОЛЬ), однако все равно говорит, что отказано в доступе, в чем может быть проблема? Заранее благдарю за ответ
        
Admin
  
05.05.2017 в 17:47 - 
Ответить                                
Похоже вы где-то не правильно вводите пароль пользователя root для mysql . Вы точно все правильно вводите?
        
hel
  
26.09.2018 в 14:47 - 
Ответить                                
Бывают ошибки при обращении к БД.
Вот, надо выполнить в мускуле.
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,&#8217;ONLY_FULL_GROUP_BY&#8217;,&#187;));
Добавить комментарий Отменить ответВаш адрес email не будет опубликован.Комментарий Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-1890562251101921"
data-ad-slot="9117958896"
data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
  
Все права защищены. IT Traveler 2022 
                            
jQuery(document).ready(function($){
$("a[rel*=lightbox]").colorbox({initialWidth:"30%",initialHeight:"30%",maxWidth:"90%",maxHeight:"90%",opacity:0.8,current:" {current}  {total}",previous:"",close:"Закрыть"});
});
(function (d, w, c) {
(w[c] = w[c] || []).push(function() {
try {
w.yaCounter27780774 = new Ya.Metrika({
id:27780774,
clickmap:true,
trackLinks:true,
accurateTrackBounce:true,
webvisor:true,
trackHash:true
});
} catch(e) { }
});
var n = d.getElementsByTagName("script")[0],
s = d.createElement("script"),
f = function () { n.parentNode.insertBefore(s, n); };
s.type = "text/javascript";
s.async = true;
s.src = "https://mc.yandex.ru/metrika/watch.js";
if (w.opera == "[object Opera]") {
d.addEventListener("DOMContentLoaded", f, false);
} else { f(); }
})(document, window, "yandex_metrika_callbacks");
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-58126221-1', 'auto');
ga('send', 'pageview');
