#                 	Настройка отказоустойчивого веб сервера на базе nginx и apache.                	  
***            ***

			
            
		

    




	
    	  Дата: 23.06.2015 Автор Admin  
	Рассмотрим настройку отказоустойчивых веб серверов.
В данном примере мы будем использовать nginx для балансировки нагрузки, а связку nginx + apache будем использовать как веб сервера.
Теперь рассмотрим данную реализацию подробнее. Мы можем использовать две схемы отказоустойчивости, это схема 1:
В данной схеме точкой отказа является балансировщик, но если вы не располагаете большим количеством серверов, данная схема подойдет.
Если вас интересует полная отказоустойчивость, то вам подойдет вторая схема:
В данной схеме задублирован каждый узел.
В рамках этой статьи мы рассмотрим реализацию схемы №1, как реализовать схему 2 я расскажу в конце статьи.
Теперь рассмотрим подробнее схему 1.
Нам понадобится:
1) Настроить DNS записи типа A на адрес балансировщика Nginx
2) Настроить балансировку нагрузки на сервере nginx
3) Настроить веб сервера на связке Nginx + Apache, где Nginx отдает статический контент, а Apache динамический
4) Настроить репликацию Mysql (тип Master-Master)
5) Настроить распределенную файловую систему GlusterFS для хранения сайтов
Перейдем к пункту 2, настроим балансировщик на базе Nginx.
Обновляем все пакеты:

		
		
			
			
			
```
apt-get update
```
			
				
					
				
					1
				
						apt-get update
					
				
			
		



		
		
			
			
			
```
apt-get upgrade
```
			
				
					
				
					1
				
						apt-get upgrade
					
				
			
		

Удалим кэш пакетов и ненужные пакеты:

		
		
			
			
			
```
apt-get clean
```
			
				
					
				
					1
				
						apt-get clean
					
				
			
		



		
		
			
			
			
```
apt-get autoclean
```
			
				
					
				
					1
				
						apt-get autoclean
					
				
			
		



		
		
			
			
			
```
apt-get autoremove
```
			
				
					
				
					1
				
						apt-get autoremove
					
				
			
		

Устанавливаем веб сервер Nginx.

		
		
			
			
			
```
apt-get install nginx
```
			
				
					
				
					1
				
						apt-get install nginx
					
				
			
		

Удаляем дефолтные конфиги.

		
		
			
			
			
```
rm -f /etc/nginx/sites-available/*
```
			
				
					
				
					1
				
						rm -f /etc/nginx/sites-available/*
					
				
			
		



		
		
			
			
			
```
rm -f /etc/nginx/sites-enabled/*
```
			
				
					
				
					1
				
						rm -f /etc/nginx/sites-enabled/*
					
				
			
		

Создаем конфиг для нового сайта.

		
		
			
			
			
```
touch /etc/nginx/sites-available/newsite
```
			
				
					
				
					1
				
						touch /etc/nginx/sites-available/newsite
					
				
			
		

Приводим данный конфиг к виду:

		
		
			
			
			
```
upstream http {
ip_hash;
server 192.168.10.10:80 max_fails=2 fail_timeout=2s;
server 192.168.10.20:80 max_fails=2 fail_timeout=2s;
server 192.168.10.30:80 max_fails=2 fail_timeout=2s;
}

server {

server_name newsite.test.com;
listen 80;

location / {
proxy_read_timeout 1200;
proxy_connect_timeout 1200;
proxy_pass http://http/;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
}
```
			
				
					
				
					123456789101112131415161718192021
				
						upstream http {ip_hash;server 192.168.10.10:80 max_fails=2 fail_timeout=2s;server 192.168.10.20:80 max_fails=2 fail_timeout=2s;server 192.168.10.30:80 max_fails=2 fail_timeout=2s;}&nbsp;server {&nbsp;server_name newsite.test.com;listen 80;&nbsp;location / {proxy_read_timeout 1200;proxy_connect_timeout 1200;proxy_pass http://http/;proxy_set_header Host $host;proxy_set_header X-Real-IP $remote_addr;proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;}}
					
				
			
		

В данном конфиге:
В секции upstream http описываются метод балансировки и адреса веб серверов на которые распределяется нагрузка
Параметр max_fails указывает максимальное число неудачных соединений с сервером
Параметр fail_timeout указывает максимальное время ожидания при обрыве связи с сервером
В секции server описывается адрес сайта и порт на котором работает сайт
В секции location указываются параметры проксирования, параметр proxy_pass указывает какую директиву из конфига использовать.
Если вы настраиваете хост https , то конфиг будет выглядеть так:

		
		
			
			
			
```
upstream https {

server 192.168.10.10:80 max_fails=2 fail_timeout=2s;
server 192.168.10.20:80 max_fails=2 fail_timeout=2s;
server 192.168.10.30:80 max_fails=2 fail_timeout=2s;
}

server {

server_name newsite.test.com;
listen 443;
ssl on;
ssl_certificate /etc/nginx/SSL/hostname.pem;
ssl_certificate_key /etc/nginx/SSL/server.key;

location / {
proxy_read_timeout 1200;
proxy_connect_timeout 1200;
proxy_pass http://http/;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header HTTPS on;
}
}
```
			
				
					
				
					12345678910111213141516171819202122232425
				
						upstream https {&nbsp;server 192.168.10.10:80 max_fails=2 fail_timeout=2s;server 192.168.10.20:80 max_fails=2 fail_timeout=2s;server 192.168.10.30:80 max_fails=2 fail_timeout=2s;}&nbsp;server {&nbsp;server_name newsite.test.com;listen 443;ssl on;ssl_certificate /etc/nginx/SSL/hostname.pem;ssl_certificate_key /etc/nginx/SSL/server.key;&nbsp;location / {proxy_read_timeout 1200;proxy_connect_timeout 1200;proxy_pass http://http/;proxy_set_header Host $host;proxy_set_header X-Real-IP $remote_addr;proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;proxy_set_header HTTPS on;}}
					
				
			
		

(adsbygoogle = window.adsbygoogle || []).push({});
В таком случае ssl сессии будет поднимать балансировщик, а не конечный веб сервер.
Сохраняем конфиг и включаем сайт (в примере используется конфиг без ssl).

		
		
			
			
			
```
ln -s /etc/nginx/sites-available/newsite /etc/nginx/sites-enabled/newsite
```
			
				
					
				
					1
				
						ln -s /etc/nginx/sites-available/newsite /etc/nginx/sites-enabled/newsite
					
				
			
		

Перезапускаем Nginx.

		
		
			
			
			
```
service nginx restart
```
			
				
					
				
					1
				
						service nginx restart
					
				
			
		

На этом настройка балансировщика завершена.
Перейдем к настройке вебсервера номер 1.
Обновляем все пакеты:

		
		
			
			
			
```
apt-get update
```
			
				
					
				
					1
				
						apt-get update
					
				
			
		



		
		
			
			
			
```
apt-get upgrade
```
			
				
					
				
					1
				
						apt-get upgrade
					
				
			
		

Удалим кэш пакетов и ненужные пакеты:

		
		
			
			
			
```
apt-get clean
```
			
				
					
				
					1
				
						apt-get clean
					
				
			
		



		
		
			
			
			
```
apt-get autoclean
```
			
				
					
				
					1
				
						apt-get autoclean
					
				
			
		



		
		
			
			
			
```
apt-get autoremove
```
			
				
					
				
					1
				
						apt-get autoremove
					
				
			
		

Установим часовой пояс.

		
		
			
			
			
```
dpkg-reconfigure tzdata
```
			
				
					
				
					1
				
						dpkg-reconfigure tzdata
					
				
			
		

Установим NTP.

		
		
			
			
			
```
apt-get install ntp
```
			
				
					
				
					1
				
						apt-get install ntp
					
				
			
		

Устанавливаем веб сервер Apache2.

		
		
			
			
			
```
apt-get install apache2
```
			
				
					
				
					1
				
						apt-get install apache2
					
				
			
		

Устанавливаем PHP.

		
		
			
			
			
```
apt-get install php5 libapache2-mod-php5 php5-mysql
```
			
				
					
				
					1
				
						apt-get install php5 libapache2-mod-php5 php5-mysql
					
				
			
		

Устанавливаем Mysql сервер.

		
		
			
			
			
```
apt-get install mysql-server mysql-client
```
			
				
					
				
					1
				
						apt-get install mysql-server mysql-client
					
				
			
		

Настраиваем безопасность Mysql.

		
		
			
			
			
```
mysql_secure_installation
```
			
				
					
				
					1
				
						mysql_secure_installation
					
				
			
		

Устанавливаем значения firewall.

		
		
			
			
			
```
ufw allow OpenSSH
```
			
				
					
				
					1
				
						ufw allow OpenSSH
					
				
			
		



		
		
			
			
			
```
ufw allow Apache
```
			
				
					
				
					1
				
						ufw allow Apache
					
				
			
		



		
		
			
			
			
```
ufw allow 3306/tcp
```
			
				
					
				
					1
				
						ufw allow 3306/tcp
					
				
			
		



		
		
			
			
			
```
ufw limit OpenSSH
```
			
				
					
				
					1
				
						ufw limit OpenSSH
					
				
			
		



		
		
			
			
			
```
ufw enable
```
			
				
					
				
					1
				
						ufw enable
					
				
			
		

Т.к. Apache будет нашим backend, настроим его на работу на localhost.
Открываем файл /etc/apache2/ports.conf
И редактируем директиву Listen, должно получиться так:

		
		
			
			
			
```
Listen 127.0.0.1:80
```
			
				
					
				
					1
				
						Listen 127.0.0.1:80
					
				
			
		

Включаем необходимые для работы модули Apache2.

		
		
			
			
			
```
a2enmod rewrite
```
			
				
					
				
					1
				
						a2enmod rewrite
					
				
			
		



		
		
			
			
			
```
a2enmod ssl
```
			
				
					
				
					1
				
						a2enmod ssl
					
				
			
		

Для корректного отображения ip адресов в логах установим модуль rpaf.

		
		
			
			
			
```
apt-get install libapache2-mod-rpaf
```
			
				
					
				
					1
				
						apt-get install libapache2-mod-rpaf
					
				
			
		



		
		
			
			
			
```
a2enmod rpaf
```
			
				
					
				
					1
				
						a2enmod rpaf
					
				
			
		

Так же вы можете отключить лишние модули, например вот так отключается модуль status.

		
		
			
			
			
```
a2dismod status
```
			
				
					
				
					1
				
						a2dismod status
					
				
			
		

Удаляем дефолтные сайты.

		
		
			
			
			
```
rm -f /etc/apache2/sites-available/*.*
```
			
				
					
				
					1
				
						rm -f /etc/apache2/sites-available/*.*
					
				
			
		



		
		
			
			
			
```
rm -f /etc/apache2/sites-enabled/*.*
```
			
				
					
				
					1
				
						rm -f /etc/apache2/sites-enabled/*.*
					
				
			
		

Перезапускаем Apache2.

		
		
			
			
			
```
service apache2 restart
```
			
				
					
				
					1
				
						service apache2 restart
					
				
			
		

Теперь установим Nginx, он будет frontend.

		
		
			
			
			
```
apt-get install nginx
```
			
				
					
				
					1
				
						apt-get install nginx
					
				
			
		

Удаляем дефолтные конфиги.

		
		
			
			
			
```
rm -f /etc/nginx/sites-available/*
```
			
				
					
				
					1
				
						rm -f /etc/nginx/sites-available/*
					
				
			
		



		
		
			
			
			
```
rm -f /etc/nginx/sites-enabled/*
```
			
				
					
				
					1
				
						rm -f /etc/nginx/sites-enabled/*
					
				
			
		

Повторяем данные операции на втором веб сервере.
Теперь перейдем к настройке распределенной файловой системе GlusterFS.
Данная фс нужна для хранения и репликации файлов сайтов между веб серверами.
На каждом из веб серверов создадим правила Firewall.

		
		
			
			
			
```
ufw allow 24007:24010/tcp
```
			
				
					
				
					1
				
						ufw allow 24007:24010/tcp
					
				
			
		



		
		
			
			
			
```
ufw allow 49152:49153/tcp
```
			
				
					
				
					1
				
						ufw allow 49152:49153/tcp
					
				
			
		



		
		
			
			
			
```
ufw allow 38465:38467/tcp
```
			
				
					
				
					1
				
						ufw allow 38465:38467/tcp
					
				
			
		



		
		
			
			
			
```
ufw allow 111/tcp
```
			
				
					
				
					1
				
						ufw allow 111/tcp
					
				
			
		



		
		
			
			
			
```
ufw allow 111/udp
```
			
				
					
				
					1
				
						ufw allow 111/udp
					
				
			
		

На каждом из веб серверов открываем файл /etc/hosts и прописываем полные адреса веб серверов.
Должно получиться примерно так:

		
		
			
			
			
```
127.0.0.1 localhost hostname
127.0.0.1 webserver1.test.com webserver1
second_ip webserver2.test.com webserver2
```
			
				
					
				
					123
				
						127.0.0.1 localhost hostname127.0.0.1 webserver1.test.com webserver1second_ip webserver2.test.com webserver2
					
				
			
		

Обратите внимание, что имя сервера на котором идет настройка указывается на 127.0.0.1, dns имя второго веб сервера указывается на его внешний ip.
Устанавливаем Gluster FS (выполняем это действие на каждом из серверов).

		
		
			
			
			
```
apt-get install glusterfs-server
```
			
				
					
				
					1
				
						apt-get install glusterfs-server
					
				
			
		

Теперь переходим на первый веб сервер и выполняем команду.

		
		
			
			
			
```
gluster peer probe webserver2.test.com
```
			
				
					
				
					1
				
						gluster peer probe webserver2.test.com
					
				
			
		

Где webserver2.test.com, dns имя второго веб сервера.
Проверяем объединились ли сервера в кластер.

		
		
			
			
			
```
gluster peer status
```
			
				
					
				
					1
				
						gluster peer status
					
				
			
		

Как видите сервера в кластере.

		
		
			
			
			
```
State: Peer in Cluster (Connected)
```
			
				
					
				
					1
				
						State: Peer in Cluster (Connected)
					
				
			
		

Теперь создадим кластерное хранилище с именем volume1,

		
		
			
			
			
```
gluster volume create volume1 replica 2 transport tcp webserver1.test.com:/gluster-storage webserver2.test.com:/gluster-storage force
```
			
				
					
				
					1
				
						gluster volume create volume1 replica 2 transport tcp webserver1.test.com:/gluster-storage webserver2.test.com:/gluster-storage force
					
				
			
		

В данной команде:
volume1 &#8212; название хранилища
replica 2 &#8212; количество серверов реплик
webserver1.test.com:/gluster-storage -В данном случае webserver1.test.com имя сервера gluster, а /gluster-storage путь к папке в которой будут храниться изменения в фс Gluster
Вывод команды должне быть таким:

		
		
			
			
			
```
volume create: volume1: success: please start the volume to access data
```
			
				
					
				
					1
				
						volume create: volume1: success: please start the volume to access data
					
				
			
		

Теперь включаем созданное хранилище.

		
		
			
			
			
```
gluster volume start volume1
```
			
				
					
				
					1
				
						gluster volume start volume1
					
				
			
		

Вывод команды должен быть таким:

		
		
			
			
			
```
volume start: volume1: success
```
			
				
					
				
					1
				
						volume start: volume1: success
					
				
			
		

Теперь установим клиентскую часть, для подключения созданной фс.
Выполните данные действия на каждом веб сервере:
Устанавливаем необходимые компоненты.

		
		
			
			
			
```
apt-get install glusterfs-client
```
			
				
					
				
					1
				
						apt-get install glusterfs-client
					
				
			
		

Создаем директорию для монтирования (Выполняем на каждом веб сервере).

		
		
			
			
			
```
mkdir /storage-pool
```
			
				
					
				
					1
				
						mkdir /storage-pool
					
				
			
		

Редактируем файл /etc/fstab и добавляем в него строку с параметрами подключения (Выполняем на каждом веб сервере):

		
		
			
			
			
```
webserver1:/volume1 /storage-pool glusterfs defaults,_netdev,backupvolfile-server=webserver2 0 0
```
			
				
					
				
					1
				
						webserver1:/volume1 /storage-pool glusterfs defaults,_netdev,backupvolfile-server=webserver2 0 0
					
				
			
		

В данной строке указываются следующие параметры:
webserver1:/volume1 &#8212; Адрес сервера к которому идет подключение (желательно указывать серверу самого себя) и название хранилища.
/storage-pool &#8212; папка, куда будет смонтирована фс.
backupvolfile-server &#8212; адрес резервного сервера.
Монтируем общее хранилище(Выполняем на каждом веб сервере).

		
		
			
			
			
```
mount /storage-pool
```
			
				
					
				
					1
				
						mount /storage-pool
					
				
			
		

Теперь на каждом веб сервере настроим список ip, которым можно подключать хранилище.
Сделать это можно командой:

		
		
			
			
			
```
gluster volume set volume1 auth.allow gluster_client1_ip,gluster_client2_ip
```
			
				
					
				
					1
				
						gluster volume set volume1 auth.allow gluster_client1_ip,gluster_client2_ip
					
				
			
		

Где вместо gluster_client1_ip,gluster_client2_ip вводятся ip адреса веб серверов.
Теперь создадим папку с сайтами.

		
		
			
			
			
```
mkdir /storage-pool/hosting
```
			
				
					
				
					1
				
						mkdir /storage-pool/hosting
					
				
			
		

Далее откроем доступ к папке с сайтами, для этого редактируем файл /etc/apache2/apache2.conf и вносим в него следующие строки (Делаем это на каждом веб сервере):

		
		
			
			
			
```
&lt;Directory /storage-pool/hosting&gt;
Options FollowSymLinks
AllowOverride all
Require all granted
&lt;/Directory&gt;
```
			
				
					
				
					12345
				
						&lt;Directory /storage-pool/hosting&gt;Options FollowSymLinksAllowOverride allRequire all granted&lt;/Directory&gt;
					
				
			
		

Создадим конфиг для нового сайта. (Делаем на каждом веб сервере)

		
		
			
			
			
```
touch /etc/apache2/sites-available/newsite.conf
```
			
				
					
				
					1
				
						touch /etc/apache2/sites-available/newsite.conf
					
				
			
		

Открываем конфиг в вводим следующее:

		
		
			
			
			
```
&lt;VirtualHost *:80&gt;
ServerName newsite.test.com
DocumentRoot /storage-pool/hosting/newsite
CustomLog /var/log/apache2/newsite.access.log combined
ErrorLog /var/log/apache2/newsite.error.log
&lt;/VirtualHost&gt;
```
			
				
					
				
					123456
				
						&lt;VirtualHost *:80&gt;ServerName newsite.test.comDocumentRoot /storage-pool/hosting/newsiteCustomLog /var/log/apache2/newsite.access.log combinedErrorLog /var/log/apache2/newsite.error.log&lt;/VirtualHost&gt;
					
				
			
		

В данном примере:
Сайт работает на 80-м порту
Сайт доступен по DNS адресам newsite.test.com
Сайт расположен в директории – /storage-pool/hosting/newsite
&nbsp;
(adsbygoogle = window.adsbygoogle || []).push({});
Создаем каталог с новым сайтом.

		
		
			
			
			
```
mkdir /storage-pool/hosting/newsite
```
			
				
					
				
					1
				
						mkdir /storage-pool/hosting/newsite
					
				
			
		

Включаем сайт (Делаем на каждом веб сервере):

		
		
			
			
			
```
a2ensite newsite.conf
```
			
				
					
				
					1
				
						a2ensite newsite.conf
					
				
			
		

Перезагрузим конфиги apache2 (Делаем на каждом веб сервере).

		
		
			
			
			
```
service apache2 reload
```
			
				
					
				
					1
				
						service apache2 reload
					
				
			
		

Создадим конфиг сайта newsite для Nginx (Делаем на каждом веб сервере).

		
		
			
			
			
```
touch /etc/nginx/sites-available/newsite.conf
```
			
				
					
				
					1
				
						touch /etc/nginx/sites-available/newsite.conf
					
				
			
		

Открываем конфиг в вводим следующее:

		
		
			
			
			
```
server {
listen ip_adress:80;
server_name newsite.test.com;
charset utf-8;
access_log off;
error_log /var/log/nginx/site.error.log;

location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js)$ {
root /storage-pool/hosting/newsite;
expires 7d;
}

location ~ /\.ht {
deny all;
}

location / {
root /storage-pool/hosting/newsite;
proxy_set_header Host $host;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_pass http://127.0.0.1/;
proxy_set_header Accept-Encoding "";
}
}
```
			
				
					
				
					123456789101112131415161718192021222324
				
						server {listen ip_adress:80;server_name newsite.test.com;charset utf-8;access_log off;error_log /var/log/nginx/site.error.log;&nbsp;location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js)$ {root /storage-pool/hosting/newsite;expires 7d;}&nbsp;location ~ /\.ht {deny all;}&nbsp;location / {root /storage-pool/hosting/newsite;proxy_set_header Host $host;proxy_set_header X-Forwarded-For $remote_addr;proxy_pass http://127.0.0.1/;proxy_set_header Accept-Encoding "";}}
					
				
			
		

&nbsp;
В данном конфиге:
Директива listen ip_adress:80 указывает на каком порту и ip работает сайт
Директива root указывает корневую директорию сайта
Директива server_name указывает dns имя сайта
Директива:

		
		
			
			
			
```
location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js
```
			
				
					
				
					1
				
						location ~* \.(txt|jpg|jpeg|gif|png|bmp|swf|ico|css|js
					
				
			
		

Указывает тип статических файлов.
Директива expires указывает сколько дней хранить статический контент.
Директива:

		
		
			
			
			
```
location ~ /\.ht {
deny all;
```
			
				
					
				
					12
				
						location ~ /\.ht {deny all;
					
				
			
		

Запрещает Nginx отдавать файлы начинающиеся с .ht
Директива:

		
		
			
			
			
```
proxy_set_header Host $host;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_pass http://127.0.0.1/;
proxy_set_header Accept-Encoding "";
```
			
				
					
				
					1234
				
						proxy_set_header Host $host;proxy_set_header X-Forwarded-For $remote_addr;proxy_pass http://127.0.0.1/;proxy_set_header Accept-Encoding "";
					
				
			
		

Указывает что Nginx работает как обратный прокси и передает запросы на localhost.
&nbsp;
Включаем сайт командой. (Делаем на каждом веб сервере).

		
		
			
			
			
```
ln -s /etc/nginx/sites-available/newsite.conf /etc/nginx/sites-enabled/newsite.conf
```
			
				
					
				
					1
				
						ln -s /etc/nginx/sites-available/newsite.conf /etc/nginx/sites-enabled/newsite.conf
					
				
			
		

Перезапускаем Nginx. (Делаем на каждом веб сервере).

		
		
			
			
			
```
service nginx restart
```
			
				
					
				
					1
				
						service nginx restart
					
				
			
		

Теперь в качестве примера установим CMS WordPress.
Скачиваем последнюю версию WordPress.

		
		
			
			
			
```
wget http://wordpress.org/latest.tar.gz
```
			
				
					
				
					1
				
						wget http://wordpress.org/latest.tar.gz
					
				
			
		

Разархивируем архив с CMS.

		
		
			
			
			
```
tar -xzvf latest.tar.gz
```
			
				
					
				
					1
				
						tar -xzvf latest.tar.gz
					
				
			
		

Копируем сайт.

		
		
			
			
			
```
cp -r ~/wordpress/* /storage-pool/hosting/newsite
```
			
				
					
				
					1
				
						cp -r ~/wordpress/* /storage-pool/hosting/newsite
					
				
			
		

Теперь перейдем к настройке Mysql репликации.
Переходим на первый веб сервер и открываем файл /etc/mysql/my.cnf.
Изменяем в конфиге следующие строки:

		
		
			
			
			
```
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = example_DB
# bind-address = 127.0.0.1
```
			
				
					
				
					1234
				
						server-id = 1log_bin = /var/log/mysql/mysql-bin.logbinlog_do_db = example_DB# bind-address = 127.0.0.1
					
				
			
		

В данном конфиге:
server-id – номер id mysql сервера
log_bin – путь к бинарному логу, в него пишутся изменения
binlog_do_db – название БД, которую мы будем реплицировать
# bind-address – строка закоментирована, т.к. сервер должен работать не только на localhost
Перезапускаем mysql сервер.

		
		
			
			
			
```
service mysql restart
```
			
				
					
				
					1
				
						service mysql restart
					
				
			
		

Перейдем к настройке репликации.
Подключаемся к Mysql.

		
		
			
			
			
```
mysql -u root -p
```
			
				
					
				
					1
				
						mysql -u root -p
					
				
			
		

Создадим пользователя replicator.

		
		
			
			
			
```
create user 'replicator'@'%' identified by 'password';
```
			
				
					
				
					1
				
						create user 'replicator'@'%' identified by 'password';
					
				
			
		

Создаем базу данных, которую мы будем реплицировать.

		
		
			
			
			
```
create database example_DB;
```
			
				
					
				
					1
				
						create database example_DB;
					
				
			
		

Назначим права пользователю.

		
		
			
			
			
```
grant replication slave on *.* to 'replicator'@'%';
```
			
				
					
				
					1
				
						grant replication slave on *.* to 'replicator'@'%';
					
				
			
		

Проверить статус репликации можно командой:

		
		
			
			
			
```
show master status;
```
			
				
					
				
					1
				
						show master status;
					
				
			
		

Запоминаем параметры File (mysql-bin.000001) и Position (107). Эти параметры нам понадобятся на втором веб сервере.
Отключаемся от консоли mysql.

		
		
			
			
			
```
exit
```
			
				
					
				
					1
				
						exit
					
				
			
		

Переходим на второй веб сервер и правим конфиг файл /etc/mysql/my.cnf
Конфиг файл второго сервера будет отличаться только id.

		
		
			
			
			
```
server-id = 2
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = example_DB
# bind-address = 127.0.0.1
```
			
				
					
				
					1234
				
						server-id = 2log_bin = /var/log/mysql/mysql-bin.logbinlog_do_db = example_DB# bind-address = 127.0.0.1
					
				
			
		

Перезапускаем mysql на втором сервере.

		
		
			
			
			
```
service mysql restart
```
			
				
					
				
					1
				
						service mysql restart
					
				
			
		

Повторяем операции по созданию пользователя.

		
		
			
			
			
```
mysql -u root -p
```
			
				
					
				
					1
				
						mysql -u root -p
					
				
			
		



		
		
			
			
			
```
create user 'replicator'@'%' identified by 'password';
```
			
				
					
				
					1
				
						create user 'replicator'@'%' identified by 'password';
					
				
			
		

Создаем базу данных, которую мы будем реплицировать.

		
		
			
			
			
```
create database example_DB;
```
			
				
					
				
					1
				
						create database example_DB;
					
				
			
		

Назначим права пользователю.

		
		
			
			
			
```
grant replication slave on *.* to 'replicator'@'%';
```
			
				
					
				
					1
				
						grant replication slave on *.* to 'replicator'@'%';
					
				
			
		

Запускаем процесс репликации.

		
		
			
			
			
```
slave stop;
```
			
				
					
				
					1
				
						slave stop;
					
				
			
		

Параметры MASTER_LOG_FILE и MASTER_LOG_POS берем с первого сервера (вывод команды show master status;).

		
		
			
			
			
```
CHANGE MASTER TO MASTER_HOST = 'ip address first mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 107;
```
			
				
					
				
					1
				
						CHANGE MASTER TO MASTER_HOST = 'ip address first mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 107;
					
				
			
		



		
		
			
			
			
```
slave start;
```
			
				
					
				
					1
				
						slave start;
					
				
			
		

Теперь посмотрим статус репликации:

		
		
			
			
			
```
SHOW MASTER STATUS;
```
			
				
					
				
					1
				
						SHOW MASTER STATUS;
					
				
			
		



		
		
			
			
			
```
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000004 | 107      | example_DB   |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
```
			
				
					
				
					123456
				
						+------------------+----------+--------------+------------------+| File&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Position | Binlog_Do_DB | Binlog_Ignore_DB |+------------------+----------+--------------+------------------+| mysql-bin.000004 | 107&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| example_DB&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|+------------------+----------+--------------+------------------+1 row in set (0.00 sec)
					
				
			
		

&nbsp;
(adsbygoogle = window.adsbygoogle || []).push({});
Запоминаем название файла и параметр позиции, эти данные понадобятся нам при включении репликации на первом сервере.
Теперь вернемся на первый сервер и включим репликацию на нем:

		
		
			
			
			
```
slave stop;
```
			
				
					
				
					1
				
						slave stop;
					
				
			
		

Меняем параметры MASTER_LOG_FILE и MASTER_LOG_POS полученные ранее из команды SHOW MASTER STATUS;

		
		
			
			
			
```
CHANGE MASTER TO MASTER_HOST = 'ip address second mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000004', MASTER_LOG_POS = 107;
```
			
				
					
				
					1
				
						CHANGE MASTER TO MASTER_HOST = 'ip address second mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000004', MASTER_LOG_POS = 107;
					
				
			
		



		
		
			
			
			
```
slave start;
```
			
				
					
				
					1
				
						slave start;
					
				
			
		

Теперь репликация работает на двух серверах.
Откроем консоль mysql и выполним команды:

		
		
			
			
			
```
mysql -u root -p
```
			
				
					
				
					1
				
						mysql -u root -p
					
				
			
		



		
		
			
			
			
```
CREATE USER wordpressuser@localhost;
```
			
				
					
				
					1
				
						CREATE USER wordpressuser@localhost;
					
				
			
		



		
		
			
			
			
```
SET PASSWORD FOR wordpressuser@localhost= PASSWORD("password");
```
			
				
					
				
					1
				
						SET PASSWORD FOR wordpressuser@localhost= PASSWORD("password");
					
				
			
		



		
		
			
			
			
```
GRANT ALL PRIVILEGES ON example_DB.* TO wordpressuser@localhost IDENTIFIED BY 'password';
```
			
				
					
				
					1
				
						GRANT ALL PRIVILEGES ON example_DB.* TO wordpressuser@localhost IDENTIFIED BY 'password';
					
				
			
		



		
		
			
			
			
```
FLUSH PRIVILEGES;
```
			
				
					
				
					1
				
						FLUSH PRIVILEGES;
					
				
			
		



		
		
			
			
			
```
exit
```
			
				
					
				
					1
				
						exit
					
				
			
		

Данными командами мы создали пользователя mysql для подключения из CMS WordPress к базе данных example_DB.
Теперь настроим CSM WordPress для работы с базой данных.
Копируем конфиг WordPress.

		
		
			
			
			
```
cp /storage-pool/hosting/newsite/wp-config-sample.php /storage-pool/hosting/newsite/wp-config.php
```
			
				
					
				
					1
				
						cp /storage-pool/hosting/newsite/wp-config-sample.php /storage-pool/hosting/newsite/wp-config.php
					
				
			
		

Открываем файл wp-config.php и редактируем следующие поля:

		
		
			
			
			
```
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'example_DB');
/** MySQL database username */
define('DB_USER', 'wordpressuser');
/** MySQL database password */
define('DB_PASSWORD', 'password');
```
			
				
					
				
					1234567
				
						// ** MySQL settings - You can get this info from your web host ** ///** The name of the database for WordPress */define('DB_NAME', 'example_DB');/** MySQL database username */define('DB_USER', 'wordpressuser');/** MySQL database password */define('DB_PASSWORD', 'password');
					
				
			
		

Теперь настроим права на папку с сайтами.

		
		
			
			
			
```
chown -R www-data /storage-pool/hosting/
```
			
				
					
				
					1
				
						chown -R www-data /storage-pool/hosting/
					
				
			
		

Теперь CSM wordpress сможет работать с базой данных.
На этом настройка схемы №1 окончена. При падении одного из веб серверов сайт http://newsite.test.com будет оставаться доступным.
Для реализации схемы №2 вам нужно добавить еще один балансировщик Nginx и создать в DNS две A записи вашего сайта, каждая из которых должна указывать на ip адрес одного из балансировщиков.
На этом реализация отказоустойчивого веб сервера завершена) Удачной настройки)
