# Установка и настройка веб сервера Apache 2                	  
***Дата: 16.06.2015 Автор Admin***

В данной статье мы рассмотрим установку и настройку веб сервера Apache 2 на Ubuntu server 14.04 LTS.
Также будет рассмотрена настройка сайтов на 80 и 443 портах и создание ssl сертификатов.
Перейдем к установке веб сервера.
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
Установка веб сервера завершена.
Перейдем к настройке.
Настроим первый сайт на 80-м порту.
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
Создадим новый конфиг.
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
Сайт расположен в директории &#8212; /hosting/newsite
Создаем каталог с новым сайтом.
```
mkdir /hosting/newsite
```
mkdir /hosting/newsite
Выставляем права на каталог с сайтами.
```
chown -R www-data /hosting/
```
chown -R www-data /hosting/
Создадим тестовую страницу.
```
touch /hosting/newsite/index.html
```
touch /hosting/newsite/index.html
```
echo "Test site page" &gt;&gt; /hosting/newsite/index.html
```
echo "Test site page" &gt;&gt; /hosting/newsite/index.html
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
Теперь сайт доступен по адресу http://newsite.test.com
Рассмотрим настройку SSl.
Создадим ssl сертификат.
Вводим команду ниже, вводим пароль и отвечаем на вопросы.
```
openssl req -new -x509 -days 30 -keyout server.key.orig -out server.pem
```
openssl req -new -x509 -days 30 -keyout server.key.orig -out server.pem
Снимаем пароль с сертификата, иначе Apache будет спрашивать пароль каждый раз при загрузке.
```
openssl rsa -in server.key.orig -out server.key
```
openssl rsa -in server.key.orig -out server.key
Если вам нужно создать сертификат, который будет подписываться в стороннем центре сертификации, то выполните следующий запрос:
```
openssl req -new -inform DER -sha1 -newkey rsa:2048 -nodes -keyout server.key -out request.der
```
openssl req -new -inform DER -sha1 -newkey rsa:2048 -nodes -keyout server.key -out request.der
Далее подпишите содержимое request.der
Далее конвертируем полученный подписанный сертификат:
```
openssl x509 -in cert.cer -inform DER -out server.pem
```
openssl x509 -in cert.cer -inform DER -out server.pem
Копируем полученные файлы в /etc/ssl
```
cp server.pem /etc/ssl/certs/
```
cp server.pem /etc/ssl/certs/
```
cp server.key /etc/ssl/private/
```
cp server.key /etc/ssl/private/
Устанавливаем права на чтение только администратору.
```
chmod 0600 /etc/ssl/private/server.key
```
chmod 0600 /etc/ssl/private/server.key
Теперь рассмотрим конфиг сайта с настроенным ssl и редиректом с 80 порта на 443:
```
&lt;VirtualHost *:80&gt;
DocumentRoot /hosting/newsite
ServerName newsite.test.com
ServerAlias newsite.test.com
ErrorLog /var/log/apache2/newsite-error.log
&lt;Location /&gt;
RewriteEngine on
RewriteCond %{HTTPS} off
RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R]
&lt;/Location&gt;
&lt;/VirtualHost&gt;
&lt;VirtualHost *:443&gt;
DocumentRoot /hosting/newsite
ServerName newsite.test.com
ServerAlias newsite.test.com
ErrorLog /var/log/apache2/newsite-ssl-error.log
CustomLog /var/log/apache2/newsite-ssl-access.log combined
SSLEngine On
SSLProtocol all -SSLv2
SSLCertificateFile /etc/ssl/certs/server.pem
SSLCertificateKeyFile /etc/ssl/private/server.key
&lt;/VirtualHost&gt;
```
&lt;VirtualHost *:80&gt;DocumentRoot /hosting/newsiteServerName newsite.test.comServerAlias newsite.test.comErrorLog /var/log/apache2/newsite-error.log&lt;Location /&gt;RewriteEngine onRewriteCond %{HTTPS} offRewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R]&lt;/Location&gt;&lt;/VirtualHost&gt;&lt;VirtualHost *:443&gt;DocumentRoot /hosting/newsiteServerName newsite.test.comServerAlias newsite.test.comErrorLog /var/log/apache2/newsite-ssl-error.logCustomLog /var/log/apache2/newsite-ssl-access.log combinedSSLEngine OnSSLProtocol all -SSLv2SSLCertificateFile /etc/ssl/certs/server.pemSSLCertificateKeyFile /etc/ssl/private/server.key&nbsp;&lt;/VirtualHost&gt;
Измените предыдущий конфиг на конфиг с ssl.
Протокол работы ssl указывается тут:
```
SSLProtocol all -SSLv2
```
SSLProtocol all -SSLv2
Пути к сертификатам указываются тут:
```
SSLCertificateFile /etc/ssl/certs/server.pem
SSLCertificateKeyFile /etc/ssl/private/server.key
```
SSLCertificateFile /etc/ssl/certs/server.pemSSLCertificateKeyFile /etc/ssl/private/server.key
Перезапускаем Apache2.
```
service apache2 reload
```
service apache2 reload
Добавляем разрешающее правило в Firewall.
```
ufw allow 443/tcp
```
ufw allow 443/tcp
Теперь перейдя по ссылке http://newsite.test.com Вы будете перенаправлены на https://newsite.test.com
Удачной установки!
