# Настройка связки веб серверов Nginx + Apache                	  
***Дата: 19.06.2015 Автор Admin***

В данной связке мы будем использовать 2 веб сервера, nginx будет обрабатывать статический контент, а динамический передавать Apache.
Обновим все пакеты:
```
apt-get update
```
apt-get update
```
apt-get upgrade
```
apt-get upgrade
Удалим кэш пакетов и ненужные пакеты:
```
apt-get clean
```
apt-get clean
```
apt-get autoclean
```
apt-get autoclean
```
apt-get autoremove
```
apt-get autoremove
Установим часовой пояс.
```
dpkg-reconfigure tzdata
```
dpkg-reconfigure tzdata
Установим NTP.
```
apt-get install ntp
```
apt-get install ntp
Установим Openssh сервер (если он не установлен).
```
apt-get install openssh-server
```
apt-get install openssh-server
Устанавливаем веб сервер Apache2.
```
apt-get install apache2
```
apt-get install apache2
Устанавливаем PHP.
```
apt-get install php5 libapache2-mod-php5 php5-mysql
```
apt-get install php5 libapache2-mod-php5 php5-mysql
Устанавливаем Mysql сервер.
```
apt-get install mysql-server
```
apt-get install mysql-server
Настраиваем безопасность Mysql.
```
mysql_secure_installation
```
mysql_secure_installation
Устанавливаем значения firewall.
```
ufw allow OpenSSH
```
ufw allow OpenSSH
```
ufw allow Apache
```
ufw allow Apache
```
ufw limit OpenSSH
```
ufw limit OpenSSH
```
ufw enable
```
ufw enable
Т.к. Apache будет нашим backend, настроим его на работу на localhost.
Открываем файл /etc/apache2/ports.conf
И редактируем директиву Listen, должно получиться так:
```
Listen 127.0.0.1:80
```
Listen 127.0.0.1:80
Сохраняем файл.
Создадим папку с сайтами (если не хотим использовать папку /var/www).
```
mkdir /hosting
```
mkdir /hosting
Далее откроем доступ к папке с сайтами, для этого редактируем файл /etc/apache2/apache2.conf и вносим в него следующие строки:
```
&lt;Directory /hosting&gt;
Options FollowSymLinks
AllowOverride all
Require all granted
&lt;/Directory&gt;
```
&lt;Directory /hosting&gt;Options FollowSymLinksAllowOverride allRequire all granted&lt;/Directory&gt;
Сохраняем файл.
Включаем необходимые для работы модули Apache2.
```
a2enmod rewrite
```
a2enmod rewrite
```
a2enmod ssl
```
a2enmod ssl
Для корректного отображения ip адресов в логах установим модуль rpaf.
```
apt-get install libapache2-mod-rpaf
```
apt-get install libapache2-mod-rpaf
Включаем модуль.
```
a2enmod rpaf
```
a2enmod rpaf
Так же вы можете отключить лишние модули, например вот так отключается модуль status.
```
a2dismod status
```
a2dismod status
Перезапускаем Apache2.
```
service apache2 restart
```
service apache2 restart
Перейдем к настройке сайтов (виртуальных хостов).
Удаляем дефолтные сайты.
```
rm -f /etc/apache2/sites-available/*.*
```
rm -f /etc/apache2/sites-available/*.*
```
rm -f /etc/apache2/sites-enabled/*.*
```
rm -f /etc/apache2/sites-enabled/*.*
Создадим конфиг для нового сайта.
```
touch /etc/apache2/sites-available/newsite.conf
```
touch /etc/apache2/sites-available/newsite.conf
Ниже пример конфига сайта:
```
&lt;VirtualHost *:80&gt;
ServerName newsite.test.com
ServerAlias newsite.test.local
DocumentRoot /hosting/newsite
CustomLog /var/log/apache2/newsite.access.log combined
ErrorLog /var/log/apache2/newsite.error.log
&lt;/VirtualHost&gt;
```
&lt;VirtualHost *:80&gt;ServerName newsite.test.comServerAlias newsite.test.localDocumentRoot /hosting/newsiteCustomLog /var/log/apache2/newsite.access.log combinedErrorLog /var/log/apache2/newsite.error.log&lt;/VirtualHost&gt;
В данном примере:
Сайт работает на 80-м порту
Сайт доступен по DNS адресам newsite.test.com и newsite.test.local
Сайт расположен в директории – /hosting/newsite
Создаем каталог с новым сайтом.
```
mkdir /hosting/newsite
```
mkdir /hosting/newsite
Раздаем права на каталог с сайтами
```
chown -R www-data /hosting/
```
chown -R www-data /hosting/
Включаем сайт:
```
a2ensite newsite.conf
```
a2ensite newsite.conf
Перезагрузим конфиги apache2
```
service apache2 reload
```
service apache2 reload
Теперь добавьте DNS записи А с именем вашего сайта и ip адресом сервера.
В моем случае DNS имя newsite.test.com
Теперь установим Nginx, он будет frontend.
```
apt-get install nginx
```
apt-get install nginx
Удаляем дефолтные конфиги.
```
rm -f /etc/nginx/sites-available/*
```
rm -f /etc/nginx/sites-available/*
```
rm -f /etc/nginx/sites-enabled/*
```
rm -f /etc/nginx/sites-enabled/*
Создадим конфиг для сайта newsite
```
touch /etc/nginx/sites-available/newsite.conf
```
touch /etc/nginx/sites-available/newsite.conf
Приводим конфиг к виду:
```
server {
listen ip_adress:80;
server_name newsite.test.com;
charset utf-8;
access_log off;
error_log /var/log/nginx/site.error.log;
location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js)$ {
root /hosting/newsite;
expires 7d;
}
location ~ /\.ht {
deny all;
}
location / {
root /hosting/newsite;
proxy_set_header Host $host;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_pass http://127.0.0.1/;
proxy_set_header Accept-Encoding "";
}
}
```
server {listen ip_adress:80;server_name newsite.test.com;charset utf-8;access_log off;error_log /var/log/nginx/site.error.log;&nbsp;location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js)$ {root /hosting/newsite;expires 7d;}&nbsp;location ~ /\.ht {deny all;}&nbsp;location / {root /hosting/newsite;proxy_set_header Host $host;proxy_set_header X-Forwarded-For $remote_addr;proxy_pass http://127.0.0.1/;proxy_set_header Accept-Encoding "";}}
&nbsp;
В данном конфиге:
Директива listen ip_adress:80 указывает на каком порту и ip работает сайт
Директива root указывает корневую директорию сайта
Директива index указывает индексные файлы сайта
Директива server_name указывает dns имя сайта
Директива:
```
location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js
```
location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js
Указывает тип статических файлов
Директива expires указывает сколько дней хранить статический контент.
Директива:
```
location ~ /\.ht {
deny all;
```
location ~ /\.ht {deny all;
Запрещает Nginx отдавать файлы начинающиеся с .ht
Директива:
```
proxy_set_header Host $host;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_pass http://127.0.0.1/;
proxy_set_header Accept-Encoding "";
```
proxy_set_header Host $host;proxy_set_header X-Forwarded-For $remote_addr;proxy_pass http://127.0.0.1/;proxy_set_header Accept-Encoding "";
Указывает что Nginx работает как обратный прокси и передает запросы на localhost.
Включаем сайт командой.
```
ln -s /etc/nginx/sites-available/newsite.conf /etc/nginx/sites-enabled/newsite.conf
```
ln -s /etc/nginx/sites-available/newsite.conf /etc/nginx/sites-enabled/newsite.conf
Перезапускаем Nginx.
```
service nginx restart
```
service nginx restart
Теперь в качестве примера установим CMS WordPress
Скачиваем последнюю версию WordPress.
```
wget http://wordpress.org/latest.tar.gz
```
wget http://wordpress.org/latest.tar.gz
Распаковываем.
```
tar -xzvf latest.tar.gz
```
tar -xzvf latest.tar.gz
Теперь создадим пользователя в БД Mysql для нового сайта.
Подключаемся к Mysql.
```
mysql -u root -p
```
mysql -u root -p
Создаем БД с именем wordpress.
```
CREATE DATABASE wordpress;
```
CREATE DATABASE wordpress;
Создаем пользователя wordpressuser.
```
CREATE USER wordpressuser@localhost;
```
CREATE USER wordpressuser@localhost;
Устанавливаем пароль созданному пользователю.
```
SET PASSWORD FOR wordpressuser@localhost= PASSWORD("password");
```
SET PASSWORD FOR wordpressuser@localhost= PASSWORD("password");
Устанавливаем права пользователю на администрирование созданной ранее БД.
```
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'password';
```
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'password';
Перезагружаем привилегии Mysql.
```
FLUSH PRIVILEGES;
```
FLUSH PRIVILEGES;
Выходим из консоли Mysql.
```
exit
```
exit
Теперь подготовим CMS WordPress для работы с БД.
Копируем конфиг WordPress.
```
cp ~/wordpress/wp-config-sample.php ~/wordpress/wp-config.php
```
cp ~/wordpress/wp-config-sample.php ~/wordpress/wp-config.php
Открываем файл /wordpress/wp-config.php и редактируем следующие поля:
```
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');
/** MySQL database username */
define('DB_USER', 'wordpressuser');
/** MySQL database password */
define('DB_PASSWORD', 'password');
```
// ** MySQL settings - You can get this info from your web host ** ///** The name of the database for WordPress */define('DB_NAME', 'wordpress');/** MySQL database username */define('DB_USER', 'wordpressuser');/** MySQL database password */define('DB_PASSWORD', 'password');
Копируем сайт.
```
cp -r ~/wordpress/* /hosting/newsite
```
cp -r ~/wordpress/* /hosting/newsite
Назначаем права на каталог с сайтами веб серверу.
```
chown -R www-data /hosting/newsite
```
chown -R www-data /hosting/newsite
Теперь сайт доступен по адресу http://newsite.test.com
Теперь рассмотрим настройку ssl для нашего сайта.
Создадим папку для SSL сертификатов в каталоге Nginx.
```
mkdir /etc/nginx/ssl
```
mkdir /etc/nginx/ssl
Открываем файл /etc/apache2/ports.conf
Редактируем директиву Listen, должно получиться так:
Вместо
```
Listen *:443
```
Listen *:443
Пишем:
```
Listen 127.0.0.1:443
```
Listen 127.0.0.1:443
Открываем порт на firewall.
```
ufw allow 443/tcp
```
ufw allow 443/tcp
Теперь создадим SSL сертификат командой.
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
Теперь открываем конфиг сайта /etc/nginx/sites-available/newsite.conf
И приводим его к виду:
```
server {
listen ip_address:80;
server_name newsite.test.com;
charset utf-8;
access_log off;
location / {
rewrite ^(.*)$ https://newsite.test.com$1 permanent;
}
}
server {
listen ip_address:443 ssl;
server_name newsite.test.com;
ssl_certificate /etc/nginx/ssl/nginx.crt;
ssl_certificate_key /etc/nginx/ssl/nginx.key;
charset utf-8;
access_log off;
error_log /var/log/nginx/site.error.log;
location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js)$ {
root /hosting/newsite;
expires 7d;
}
location ~ /\.ht {
deny all;
}
location / {
proxy_pass http://127.0.0.1:80/;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
}
```
server {listen ip_address:80;server_name newsite.test.com;charset utf-8;access_log off;location / {rewrite ^(.*)$ https://newsite.test.com$1 permanent;}}&nbsp;&nbsp;&nbsp;server {listen ip_address:443 ssl;server_name newsite.test.com;ssl_certificate /etc/nginx/ssl/nginx.crt;ssl_certificate_key /etc/nginx/ssl/nginx.key;charset utf-8;access_log off;error_log /var/log/nginx/site.error.log;&nbsp;location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js)$ {root /hosting/newsite;expires 7d;}&nbsp;location ~ /\.ht {deny all;}&nbsp;location / {proxy_pass http://127.0.0.1:80/;proxy_set_header Host $host;proxy_set_header X-Real-IP $remote_addr;proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;}}
Сохраняем конфиг.
В данном конфиге добавилась вторая секция server и появились настройки ssl.
Директива rewrite описывает правило перенаправления с http на https
Директива listen 443 ssl; указывает что сайт работает по протоколу ssl на 443 порту
Директивы ssl_certificate и ssl_certificate_key указывают путь к файлам сертификата.
Теперь при переходе на http://newsite.test.com нас будет переадресовывать на https://newsite.test.com
В данной схеме Nginx берет на себя работу по созданию https сессий.
Удачной установки! =)
Related posts:Настройка ZFS в ProxmoxУстановка и настройка AnsibleНастройка дисковых квот в Ubuntu
 Linux, Ubuntu, Web, Web/Cloud 
 Метки: Apache2, Nginx, веб сервера  
                        
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
