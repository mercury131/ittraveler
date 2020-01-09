# Установка и настройка веб сервера Nginx                	  
***Дата: 17.06.2015 Автор Admin***

Рассмотрим установку веб сервера Nginx, ssl, и настройку сайтов.
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
Устанавливаем веб сервер Nginx.
```
apt-get install nginx
```
apt-get install nginx
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
Устанавливаем PHP.
```
apt-get install php5-fpm php5-mysql
```
apt-get install php5-fpm php5-mysql
Устанавливаем значения firewall.
```
ufw allow OpenSSH
```
ufw allow OpenSSH
```
ufw allow 80/tcp
```
ufw allow 80/tcp
```
ufw limit OpenSSH
```
ufw limit OpenSSH
```
ufw enable
```
ufw enable
Установка веб сервера завершена.
Перейдем к настройке.
Открываем файл /etc/php5/fpm/php.ini и меняем значение cgi.fix_pathinfo=1 на 0
Должно получиться так:
```
cgi.fix_pathinfo=0
```
cgi.fix_pathinfo=0
Далее открываем файл /etc/php5/fpm/pool.d/www.conf и добавляем в него строку:
```
listen = /var/run/php5-fpm.sock
```
listen = /var/run/php5-fpm.sock
Перезапускаем PHP.
```
service php5-fpm restart
```
service php5-fpm restart
Настроим первый сайт на 80-м порту.
Создадим папку с сайтами (если не хотим использовать папку /var/www).
```
mkdir /hosting
```
mkdir /hosting
Рассмотрим пример установки CMS WordPress.
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
// ** MySQL settings - You can get this info from your web host ** ///** The name of the database for WordPress */define('DB_NAME', 'wordpress');&nbsp;/** MySQL database username */define('DB_USER', 'wordpressuser');&nbsp;/** MySQL database password */define('DB_PASSWORD', 'password');
Создаем папку с сайтом.
```
mkdir /hosting/wordpress
```
mkdir /hosting/wordpress
Копируем сайт.
```
cp -r ~/wordpress/* /hosting/wordpress
```
cp -r ~/wordpress/* /hosting/wordpress
Назначаем права на каталог с сайтами веб серверу.
```
chown -R www-data /hosting/
```
chown -R www-data /hosting/
Создаем A запись в DNS с именем сайта (в моем примере &#8212; wordpress.test.com).
Перейдем к настройке конфигов сайта.
Удаляем дефолтные конфиги.
```
rm -f /etc/nginx/sites-available/*
```
rm -f /etc/nginx/sites-available/*
```
rm -f /etc/nginx/sites-enabled/*
```
rm -f /etc/nginx/sites-enabled/*
Создаем конфиг для нового сайта.
```
touch /etc/nginx/sites-available/wordpress
```
touch /etc/nginx/sites-available/wordpress
Открываем созданный файл и приводим к виду:
```
server {
listen 80;
root /hosting/wordpress;
index index.php index.html index.htm;
server_name wordpress.test.com;
location / {
try_files $uri $uri/ /index.php?q=$uri&amp;$args;
}
error_page 404 /404.html;
error_page 500 502 503 504 /50x.html;
location = /50x.html {
root /usr/share/nginx/www;
}
location ~ \.php$ {
try_files $uri =404;
fastcgi_pass unix:/var/run/php5-fpm.sock;
fastcgi_index index.php;
include fastcgi_params;
}
}
```
server {listen 80;&nbsp;&nbsp;root /hosting/wordpress;index index.php index.html index.htm;&nbsp;server_name wordpress.test.com;&nbsp;location / {try_files $uri $uri/ /index.php?q=$uri&amp;$args;}&nbsp;error_page 404 /404.html;&nbsp;error_page 500 502 503 504 /50x.html;location = /50x.html {root /usr/share/nginx/www;}&nbsp;&nbsp;location ~ \.php$ {try_files $uri =404;fastcgi_pass unix:/var/run/php5-fpm.sock;fastcgi_index index.php;include fastcgi_params;}&nbsp;}
В данном конфиге:
Директива listen 80; указывает на  каком порту работает сайт
Директива root указывает корневую директорию сайта
Директива index указывает индексные файлы сайта
Директива server_name указывает dns имя сайта
Секция :
```
location / {
try_files $uri $uri/ /index.php?q=$uri&amp;$args;
}
```
location / {try_files $uri $uri/ /index.php?q=$uri&amp;$args;}
используется для перманентных ссылок в wordpress
Директива error_page указывает на расположение страниц с ошибками
Директива location ~ \.php$ указывает расположение php5-fpm
Сохраняем конфиг.
Включаем сайт командой.
```
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress
```
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress
Перезапускаем Nginx.
```
service nginx restart
```
service nginx restart
Готово! Теперь сайт доступен по адресу &#8212; http://wordpress.test.com
Перейдем к настройке SSL.
Создадим папку для SSL сертификатов в каталоге Nginx.
```
mkdir /etc/nginx/ssl
```
mkdir /etc/nginx/ssl
Теперь создадим SSL сертификат командой.
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
Далее вводим данные по нашему сертификату.
Теперь настроим сайт с WordPress на использование SSL.
Открываем конфиг /etc/nginx/sites-available/wordpress
И приводим к виду:
```
server {
listen 80;
server_name wordpress.test.com;
location / {
rewrite ^(.*)$ https://wordpress.test.com$1 permanent;
}
listen 443 ssl;
root /hosting/wordpress;
index index.php index.html index.htm;
server_name wordpress.test.com;
ssl_certificate /etc/nginx/ssl/nginx.crt;
ssl_certificate_key /etc/nginx/ssl/nginx.key;
location / {
try_files $uri $uri/ /index.php?q=$uri&amp;$args;
}
error_page 404 /404.html;
error_page 500 502 503 504 /50x.html;
location = /50x.html {
root /usr/share/nginx/www;
}
location ~ \.php$ {
try_files $uri =404;
fastcgi_pass unix:/var/run/php5-fpm.sock;
fastcgi_index index.php;
include fastcgi_params;
}
}
```
server {listen 80;server_name wordpress.test.com;location / {rewrite ^(.*)$ https://wordpress.test.com$1 permanent;}listen 443 ssl;&nbsp;&nbsp;root /hosting/wordpress;index index.php index.html index.htm;&nbsp;server_name wordpress.test.com;ssl_certificate /etc/nginx/ssl/nginx.crt;ssl_certificate_key /etc/nginx/ssl/nginx.key;&nbsp;location / {try_files $uri $uri/ /index.php?q=$uri&amp;$args;}&nbsp;error_page 404 /404.html;&nbsp;error_page 500 502 503 504 /50x.html;location = /50x.html {root /usr/share/nginx/www;}&nbsp;&nbsp;location ~ \.php$ {try_files $uri =404;fastcgi_pass unix:/var/run/php5-fpm.sock;fastcgi_index index.php;include fastcgi_params;}&nbsp;}
В данном конфиге:
Директива rewrite описывает правило перенаправления с http на https
Директива listen 443 ssl; указывает что сайт работает по протоколу ssl на 443 порту
Директивы ssl_certificate и ssl_certificate_key указывают путь к файлам сертификата.
Открываем порт на firewall.
```
ufw allow 443/tcp
```
ufw allow 443/tcp
Перезагружаем конфиги Nginx.
```
service nginx reload
```
service nginx reload
Теперь при открытии url http://wordpress.test.com будет срабатывать перенаправление на https://wordpress.test.com
На этом настройка SSL завершена.
Удачной установки! =)
