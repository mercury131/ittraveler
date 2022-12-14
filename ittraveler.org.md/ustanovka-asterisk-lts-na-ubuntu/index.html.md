# Установка Asterisk LTS на Ubuntu.                	  
***Дата: 06.05.2015 Автор Admin***

Рассмотрим установку Asterisk LTS на Ubuntu.
Создаем временный каталог для файлов Asterisk и переходим в него
ZSH
```
mkdir /root/asteriskDIR
```
mkdir /root/asteriskDIR
```
cd /root/asteriskDIR
```
cd /root/asteriskDIR
&nbsp;
Скачиваем LTS версию Asterisk с оф сайта.
```
wget http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-1.8.15-current.tar.gz
```
wget http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-1.8.15-current.tar.gz
&nbsp;
Устанавливаем необходимые компоненты для сборки Asterisk
```
apt-get install libncurses5-dev openssl libssl-dev zlib1g zlib1g-dev mpg123 linux-headers-`uname -r` build-essential mysql-server libmysqlclient15-dev php5 php5-cli php5-mysql php5-gd php-pear apache2 curl sox bison flex cpp g++ gcc make libauthen-pam-perl libio-pty-perl libnet-ssleay-perl libxml2 libxml2-dev libtiff4 libtiff4-dev libaudiofile-dev subversion libsqlite3-dev
```
apt-get install libncurses5-dev openssl libssl-dev zlib1g zlib1g-dev mpg123 linux-headers-`uname -r` build-essential mysql-server libmysqlclient15-dev php5 php5-cli php5-mysql php5-gd php-pear apache2 curl sox bison flex cpp g++ gcc make libauthen-pam-perl libio-pty-perl libnet-ssleay-perl libxml2 libxml2-dev libtiff4 libtiff4-dev libaudiofile-dev subversion libsqlite3-dev
&nbsp;
Скачиваем модуль dadhi для Asterisk
```
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
```
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
&nbsp;
Распаковываем модуль
```
tar xzvf ./dahdi-linux-complete-current.tar.gz
```
tar xzvf ./dahdi-linux-complete-current.tar.gz
&nbsp;
Переходим в каталог с модулем
```
cd dahdi-linux-complete-2.9.1.1+2.9.1
```
cd dahdi-linux-complete-2.9.1.1+2.9.1
&nbsp;
Устанавливаем модуль
```
sudo make all
```
sudo make all
```
sudo make install
```
sudo make install
```
sudo make config
```
sudo make config
&nbsp;
Переходим в каталог с временными файлами Asterisk
```
cd /root/asteriskDIR
```
cd /root/asteriskDIR
&nbsp;
Скачиваем библиотеку LIB PRI
```
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz
```
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz
&nbsp;
Распаковываем библиотеку
```
tar xzvf ./libpri-1.4-current.tar.gz
```
tar xzvf ./libpri-1.4-current.tar.gz
&nbsp;
Переходим в каталог с библиотекой
```
cd ./libpri-1.4.14/
```
cd ./libpri-1.4.14/
&nbsp;
Устанавливаем библиотеку
```
sudo make
```
sudo make
```
sudo make install
```
sudo make install
&nbsp;
Переходим в каталог с временными файлами Asterisk
```
cd /root/asteriskDIR
```
cd /root/asteriskDIR
&nbsp;
Скачиваем модуль SpanDSP
```
wget http://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6pre21.tgz
```
wget http://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6pre21.tgz
&nbsp;
Распаковываем модуль
```
tar xzvf ./spandsp-0.0.6pre21.tgz
```
tar xzvf ./spandsp-0.0.6pre21.tgz
&nbsp;
Переходим в каталог с модулем
```
cd ./spandsp-0.0.6/
```
cd ./spandsp-0.0.6/
&nbsp;
Устанавливаем модуль
```
./configure
```
./configure
```
sudo make
```
sudo make
```
sudo make install
```
sudo make install
&nbsp;
Переходим в каталог с временными файлами Asterisk
```
cd /root/asteriskDIR
```
cd /root/asteriskDIR
&nbsp;
Распаковываем скачанный Asterisk
```
tar xzvf ./certified-asterisk-1.8.15-current.tar.gz
```
tar xzvf ./certified-asterisk-1.8.15-current.tar.gz
&nbsp;
Переходим в каталог с распакованным астериском
```
cd ./certified-asterisk-1.8.15-cert5/
```
cd ./certified-asterisk-1.8.15-cert5/
&nbsp;
Запускаем конфигурацию
```
./configure
```
./configure
&nbsp;
Запускаем выбор компонентов
```
sudo make menuselect
```
sudo make menuselect
&nbsp;
Если вы делаете установку по ssh, то предварительно должны убедиться, что размер терминала больше, чем 80×25.
Здесь необходимо включить нужные модули для компиляции. К примеру, в разделе Add-ons мы должны включить модули format_mp3, app_mysql, cdr_mysql, т.к. дальше планируется установка панели управления FreePBX.
В разделе Core Sound Packages включаем CORE-SOUNDS-EN-ALAW, CORE-SOUNDS-EN-GSM, CORE-SOUNDS-EN-G729, CORE-SOUNDS-RU-ALAW, CORE-SOUNDS-RU-GSM, CORE-SOUNDS-RU-G729.
Далее в разделе Music On Hold File Packages включаем модуль MOH-OPSOUND-WAV просто для того, чтоб он установился.
После установки эти мелодии можно будет заменить на свои. Последний раздел Extras Sound Packages.
Тут опять же включаем модули для выбранных кодеков ALAW, GSM и G729. Из корневого раздела нажимаем Esc и видим, что нам предложили три варианта выхода. Жмем S для сохранения сделанных изменений.
&nbsp;
Добавляем в файл ~/.subversion/servers  в секцию global следующие строки (Если используется прокси, если прокси не используется пропускаем этот шаг):
ZSH
```
http-proxy-host=localhost
http-proxy-port=3128
```
http-proxy-host=localhost&nbsp;http-proxy-port=3128
&nbsp;
Запускаем скрипт
```
contrib/scripts/get_mp3_source.sh
```
contrib/scripts/get_mp3_source.sh
&nbsp;
Запускаем установку Asterisk
```
sudo make install
```
sudo make install
```
sudo make samples
```
sudo make samples
```
sudo make config
```
sudo make config
&nbsp;
Запускаем Asterisk
```
sudo /etc/init.d/asterisk start
```
sudo /etc/init.d/asterisk start
&nbsp;
Создаем пользователей для Asterisk и раздаем им права
```
sudo adduser --system --group --home /var/lib/asterisk --no-create-home --gecos "Asterisk PBX" asterisk
```
sudo adduser --system --group --home /var/lib/asterisk --no-create-home --gecos "Asterisk PBX" asterisk
```
sudo adduser asterisk dialout
```
sudo adduser asterisk dialout
```
sudo adduser asterisk audio
```
sudo adduser asterisk audio
```
sudo adduser www-data asterisk
```
sudo adduser www-data asterisk
```
sudo mkdir -p /var/run/asterisk
```
sudo mkdir -p /var/run/asterisk
&nbsp;
Изменим права на каталоги Asterisk.
```
sudo chown -R asterisk:asterisk /var/lib/asterisk
sudo chown -R asterisk:asterisk /var/log/asterisk
sudo chown -R asterisk:asterisk /var/run/asterisk
sudo chown -R asterisk:asterisk /var/spool/asterisk
sudo chown -R asterisk:asterisk /usr/lib/asterisk
sudo chown -R asterisk:asterisk /dev/dahdi
sudo chmod -R u=rwX,g=rX,o= /var/lib/asterisk
sudo chmod -R u=rwX,g=rX,o= /var/log/asterisk
sudo chmod -R u=rwX,g=rX,o= /var/run/asterisk
sudo chmod -R u=rwX,g=rX,o= /var/spool/asterisk
sudo chmod -R u=rwX,g=rX,o= /usr/lib/asterisk
sudo chmod -R u=rwX,g=rX,o= /dev/dahdi
sudo chown -R root:asterisk /etc/asterisk
sudo chmod -R u=rwX,g=rX,o= /etc/asterisk
```
sudo chown -R asterisk:asterisk /var/lib/asterisk&nbsp;sudo chown -R asterisk:asterisk /var/log/asterisk&nbsp;sudo chown -R asterisk:asterisk /var/run/asterisk&nbsp;sudo chown -R asterisk:asterisk /var/spool/asterisk&nbsp;sudo chown -R asterisk:asterisk /usr/lib/asterisk&nbsp;sudo chown -R asterisk:asterisk /dev/dahdi&nbsp;sudo chmod -R u=rwX,g=rX,o= /var/lib/asterisk&nbsp;sudo chmod -R u=rwX,g=rX,o= /var/log/asterisk&nbsp;sudo chmod -R u=rwX,g=rX,o= /var/run/asterisk&nbsp;sudo chmod -R u=rwX,g=rX,o= /var/spool/asterisk&nbsp;sudo chmod -R u=rwX,g=rX,o= /usr/lib/asterisk&nbsp;sudo chmod -R u=rwX,g=rX,o= /dev/dahdi&nbsp;sudo chown -R root:asterisk /etc/asterisk&nbsp;sudo chmod -R u=rwX,g=rX,o= /etc/asterisk
&nbsp;
В файле /etc/default/asterisk раскомментируем две строчки.
```
AST_USER=«asterisk»
AST_GROUP=«dialout»
```
AST_USER=«asterisk»&nbsp;AST_GROUP=«dialout»
&nbsp;
Это нужно для корректного запуска служб Asterisk
Перезапускаем Asterisk
```
sudo /etc/init.d/asterisk restart
```
sudo /etc/init.d/asterisk restart
&nbsp;
Переходим в каталог с временными файлами Asterisk
```
cd /root/asteriskDIR
```
cd /root/asteriskDIR
&nbsp;
Установка FreePBX
Устанавливаем такие необходимые компоненты как веб сервер Apache2 , сервер баз данных Mysql, PHP, и библиотеки для них
```
sudo apt-get install libxml2 libxml2-dev libtiff4 libtiff4-dev lame apache2 mysql-server mysql-client php5 php-pear php5-mysql php5-gd openssl libssl-dev linux-source-3.2.0 perl bison libncurses5-dev libaudiofile-dev curl sox libcpan-mini-perl
```
sudo apt-get install libxml2 libxml2-dev libtiff4 libtiff4-dev lame apache2 mysql-server mysql-client php5 php-pear php5-mysql php5-gd openssl libssl-dev linux-source-3.2.0 perl bison libncurses5-dev libaudiofile-dev curl sox libcpan-mini-perl
&nbsp;
Скачиваем панель администрирования FreePBX
```
wget http://mirror.freepbx.org/freepbx-2.11.0.25.tgz
```
wget http://mirror.freepbx.org/freepbx-2.11.0.25.tgz
&nbsp;
Распаковываем панель администрирования
```
tar xzvf ./freepbx-2.11.0.25.tgz
```
tar xzvf ./freepbx-2.11.0.25.tgz
&nbsp;
Переходим в распакованный каталог
```
cd ./freepbx/
```
cd ./freepbx/
&nbsp;
Подключаемся к серверу Mysql и создаем базы данных
```
mysql -u root –p
```
mysql -u root –p
&nbsp;
Далее вводим root пароль
Создаем базы и раздаем привилегии пользователям
MySQL
```
mysql&gt; create database asterisk;
```
mysql&gt; create database asterisk;
MySQL
```
mysql&gt; create database asteriskcdrdb;
```
mysql&gt; create database asteriskcdrdb;
MySQL
```
mysql&gt; GRANT ALL PRIVILEGES ON asterisk.* TO asteriskuser@localhost IDENTIFIED BY 'asterpass';
```
mysql&gt; GRANT ALL PRIVILEGES ON asterisk.* TO asteriskuser@localhost IDENTIFIED BY 'asterpass';
MySQL
```
mysql&gt; GRANT ALL PRIVILEGES ON asteriskcdrdb.* TO asteriskuser@localhost IDENTIFIED BY 'asterpass';
```
mysql&gt; GRANT ALL PRIVILEGES ON asteriskcdrdb.* TO asteriskuser@localhost IDENTIFIED BY 'asterpass';
MySQL
```
mysql&gt; flush privileges;
```
mysql&gt; flush privileges;
MySQL
```
mysql&gt; \q
```
mysql&gt; \q
&nbsp;
Импортируем базу данных freepbx
MySQL
```
mysql -u root -p asterisk &lt; SQL/newinstall.sql
```
mysql -u root -p asterisk &lt; SQL/newinstall.sql
MySQL
```
mysql -u root -p asteriskcdrdb &lt; SQL/cdr_mysql_table.sql
```
mysql -u root -p asteriskcdrdb &lt; SQL/cdr_mysql_table.sql
&nbsp;
Далее изменяем пользователя из под которого запускается веб сервер Apache2
Редактируем файл /etc/apache2/envvars
Правим переменные APACHE_RUN_USER и APACHE_RUN_GROUP.
В нашем случае переменные должны выглядеть так:
```
export APACHE_RUN_USER=asterisk
export APACHE_RUN_GROUP=asterisk
```
export APACHE_RUN_USER=asterisk&nbsp;export APACHE_RUN_GROUP=asterisk
&nbsp;
Теперь Apache2 запускается под пользователем Asterisk
Удаляем каталог
```
rm -r  /var/lock/apache2
```
rm -r&nbsp;&nbsp;/var/lock/apache2
&nbsp;
Перезапускаем Apache2
```
sudo service apache2 restart
```
sudo service apache2 restart
&nbsp;
Проверяем под каким пользователем запущен Apache2
```
ps aux|grep apache
```
ps aux|grep apache
&nbsp;
Изменяем настройки PHP
Редактируем файл /etc/php5/apache2/php.ini и правим лимиты
```
upload_max_filesize=100M
memory_limit = 512M
```
upload_max_filesize=100M&nbsp;memory_limit = 512M
&nbsp;
Перезапускаем веб сервер Apache 2
```
sudo service apache2 restart
```
sudo service apache2 restart
&nbsp;
Если в нашей системе мы используем прокси сервер, то выполняем следующий шаг, если нет, то пропускаем.
```
pear config-set http_proxy http://localhost:3128
```
pear config-set http_proxy http://localhost:3128
&nbsp;
Конфигурируем  базу данных с помощью Pear
```
sudo pear install DB
```
sudo pear install DB
&nbsp;
Создаем каталог для сайта FreePBX
```
mkdir /var/www/pbx
```
mkdir /var/www/pbx
&nbsp;
Назначаем пароль для учетной записи Asterisk
```
passwd asterisk
```
passwd asterisk
&nbsp;
Устанавливаем FreePBX
```
./install_amp
```
./install_amp
&nbsp;
Далее отвечаем на вопросы FreePBX.
Нужно будет ввести логин и пароль для пользователя Asterisk
Пароль root от Mysql
Указать каталог с вебсайтом FreeBPX (/var/www/pbx)
В вопросах про местоположение файлов Asterisk нужно указывать стандартное значение, которое будет указано в вопросе.
 Asterisk 
 Метки: Asterisk, Ubuntu  
                        
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
