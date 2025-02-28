#                 	Установка и настройка веб сервера Nginx                	  
***            ***

			
            
		
    
	
    	  Дата: 17.06.2015 Автор Admin  
	Рассмотрим установку веб сервера Nginx, ssl, и настройку сайтов.
Обновим все пакеты:
apt-get update
apt-get upgrade
Удалим кэш пакетов и ненужные пакеты:
apt-get clean
apt-get autoclean
apt-get autoremove
Установим часовой пояс.
dpkg-reconfigure tzdata
Установим NTP.
apt-get install ntp
Установим Openssh сервер (если он не установлен).
apt-get install openssh-server
Устанавливаем веб сервер Nginx.
apt-get install nginx
Устанавливаем Mysql сервер.
apt-get install mysql-server
Настраиваем безопасность Mysql.
mysql_secure_installation
Устанавливаем PHP.
apt-get install php5-fpm php5-mysql
Устанавливаем значения firewall.
ufw allow OpenSSH
ufw allow 80/tcp
ufw limit OpenSSH
ufw enable
Установка веб сервера завершена.
Перейдем к настройке.
Открываем файл /etc/php5/fpm/php.ini и меняем значение cgi.fix_pathinfo=1 на 0
Должно получиться так:
cgi.fix_pathinfo=0
Далее открываем файл /etc/php5/fpm/pool.d/www.conf и добавляем в него строку:
listen = /var/run/php5-fpm.sock
Перезапускаем PHP.
service php5-fpm restart
Настроим первый сайт на 80-м порту.
Создадим папку с сайтами (если не хотим использовать папку /var/www).
mkdir /hosting
Рассмотрим пример установки CMS WordPress.
Скачиваем последнюю версию WordPress.
wget http://wordpress.org/latest.tar.gz
Распаковываем.
tar -xzvf latest.tar.gz
Теперь создадим пользователя в БД Mysql для нового сайта.
Подключаемся к Mysql.
mysql -u root -p
Создаем БД с именем wordpress.
CREATE DATABASE wordpress;
Создаем пользователя wordpressuser.
CREATE USER wordpressuser@localhost;
Устанавливаем пароль созданному пользователю.
SET PASSWORD FOR wordpressuser@localhost= PASSWORD("password");
Устанавливаем права пользователю на администрирование созданной ранее БД.
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'password';
Перезагружаем привилегии Mysql.
FLUSH PRIVILEGES;
Выходим из консоли Mysql.
exit
Теперь подготовим CMS WordPress для работы с БД.
Копируем конфиг WordPress.
cp ~/wordpress/wp-config-sample.php ~/wordpress/wp-config.php
Открываем файл /wordpress/wp-config.php и редактируем следующие поля:
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpressuser');

/** MySQL database password */
define('DB_PASSWORD', 'password');
Создаем папку с сайтом.
mkdir /hosting/wordpress
Копируем сайт.
cp -r ~/wordpress/* /hosting/wordpress
Назначаем права на каталог с сайтами веб серверу.
chown -R www-data /hosting/
Создаем A запись в DNS с именем сайта (в моем примере &#8212; wordpress.test.com).
Перейдем к настройке конфигов сайта.
Удаляем дефолтные конфиги.
rm -f /etc/nginx/sites-available/*
rm -f /etc/nginx/sites-enabled/*
Создаем конфиг для нового сайта.
touch /etc/nginx/sites-available/wordpress
Открываем созданный файл и приводим к виду:
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
В данном конфиге:
Директива listen 80; указывает на  каком порту работает сайт
Директива root указывает корневую директорию сайта
Директива index указывает индексные файлы сайта
Директива server_name указывает dns имя сайта
Секция :
location / {
try_files $uri $uri/ /index.php?q=$uri&amp;$args;
}
используется для перманентных ссылок в wordpress
Директива error_page указывает на расположение страниц с ошибками
Директива location ~ \.php$ указывает расположение php5-fpm
Сохраняем конфиг.
Включаем сайт командой.
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress
Перезапускаем Nginx.
service nginx restart
Готово! Теперь сайт доступен по адресу &#8212; http://wordpress.test.com
Перейдем к настройке SSL.
Создадим папку для SSL сертификатов в каталоге Nginx.
mkdir /etc/nginx/ssl
Теперь создадим SSL сертификат командой.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
Далее вводим данные по нашему сертификату.
Теперь настроим сайт с WordPress на использование SSL.
Открываем конфиг /etc/nginx/sites-available/wordpress
И приводим к виду:
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
В данном конфиге:
Директива rewrite описывает правило перенаправления с http на https
Директива listen 443 ssl; указывает что сайт работает по протоколу ssl на 443 порту
Директивы ssl_certificate и ssl_certificate_key указывают путь к файлам сертификата.
Открываем порт на firewall.
ufw allow 443/tcp
Перезагружаем конфиги Nginx.
service nginx reload
Теперь при открытии url http://wordpress.test.com будет срабатывать перенаправление на https://wordpress.test.com
На этом настройка SSL завершена.
Удачной установки! =)
Related posts:Настройка дисковых квот в UbuntuУстановка и настройка Radius сервера на Ubuntu с веб интерфейсом.Восстановление ZFS пула при статусе FAULTED
        
             Linux, Ubuntu, Web, Web/Cloud 
             Метки: Linux, Nginx, веб сервера  
        
            
        
    
                        
                    
                    
                
        
                
	
		
		Добавить комментарий Отменить ответВаш адрес email не будет опубликован. Обязательные поля помечены *Комментарий * Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
	
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
			
        
        
		
        
           
    
    
  
	
    
		
        
             
			
                
                    
                                                  Все права защищены. IT Traveler 2025 
                         
                        
																														                    
                    
				
                
                
    
			
		                            
	
	
                
                
			
                
		
        
	
    
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
