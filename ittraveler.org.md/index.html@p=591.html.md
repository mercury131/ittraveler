#                 	Установка и настройка веб сервера Apache 2                	  
***            ***

			
            
		
    
	
    	  Дата: 16.06.2015 Автор Admin  
	В данной статье мы рассмотрим установку и настройку веб сервера Apache 2 на Ubuntu server 14.04 LTS.
Также будет рассмотрена настройка сайтов на 80 и 443 портах и создание ssl сертификатов.
Перейдем к установке веб сервера.
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
Устанавливаем веб сервер Apache2.
apt-get install apache2
Устанавливаем PHP.
apt-get install php5 libapache2-mod-php5 php5-mysql
Устанавливаем Mysql сервер.
apt-get install mysql-server
Настраиваем безопасность Mysql.
mysql_secure_installation
Устанавливаем значения firewall.
ufw allow OpenSSH
ufw allow Apache
ufw limit OpenSSH
ufw enable
Установка веб сервера завершена.
Перейдем к настройке.
Настроим первый сайт на 80-м порту.
Создадим папку с сайтами (если не хотим использовать папку /var/www).
mkdir /hosting
Далее откроем доступ к папке с сайтами, для этого редактируем файл /etc/apache2/apache2.conf и вносим в него следующие строки:
&lt;Directory /hosting&gt;
Options FollowSymLinks
AllowOverride all
Require all granted
&lt;/Directory&gt;
Сохраняем файл.
Включаем необходимые для работы модули Apache2.
a2enmod rewrite
a2enmod ssl
Так же вы можете отключить лишние модули, например вот так отключается модуль status.
a2dismod status
Перезапускаем Apache2.
service apache2 restart
Перейдем к настройке сайтов (виртуальных хостов).
Удаляем дефолтные сайты.
rm -f /etc/apache2/sites-available/*.*
rm -f /etc/apache2/sites-enabled/*.*
Создадим новый конфиг.
touch /etc/apache2/sites-available/newsite.conf
Ниже пример конфига сайта:
&lt;VirtualHost *:80&gt;
ServerName newsite.test.com
ServerAlias newsite.test.local
DocumentRoot /hosting/newsite
CustomLog /var/log/apache2/newsite.access.log combined
ErrorLog /var/log/apache2/newsite.error.log
&lt;/VirtualHost&gt;
В данном примере:
Сайт работает на 80-м порту
Сайт доступен по DNS адресам newsite.test.com и newsite.test.local
Сайт расположен в директории &#8212; /hosting/newsite
Создаем каталог с новым сайтом.
mkdir /hosting/newsite
Выставляем права на каталог с сайтами.
chown -R www-data /hosting/
Создадим тестовую страницу.
touch /hosting/newsite/index.html
echo "Test site page" &gt;&gt; /hosting/newsite/index.html
Включаем сайт:
a2ensite newsite.conf
Перезагрузим конфиги apache2
service apache2 reload
Теперь добавьте DNS записи А с именем вашего сайта и ip адресом сервера.
В моем случае DNS имя newsite.test.com
Теперь сайт доступен по адресу http://newsite.test.com
Рассмотрим настройку SSl.
Создадим ssl сертификат.
Вводим команду ниже, вводим пароль и отвечаем на вопросы.
openssl req -new -x509 -days 30 -keyout server.key.orig -out server.pem
Снимаем пароль с сертификата, иначе Apache будет спрашивать пароль каждый раз при загрузке.
openssl rsa -in server.key.orig -out server.key
Если вам нужно создать сертификат, который будет подписываться в стороннем центре сертификации, то выполните следующий запрос:
openssl req -new -inform DER -sha1 -newkey rsa:2048 -nodes -keyout server.key -out request.der
Далее подпишите содержимое request.der
Далее конвертируем полученный подписанный сертификат:
openssl x509 -in cert.cer -inform DER -out server.pem
Копируем полученные файлы в /etc/ssl
cp server.pem /etc/ssl/certs/
cp server.key /etc/ssl/private/
Устанавливаем права на чтение только администратору.
chmod 0600 /etc/ssl/private/server.key
Теперь рассмотрим конфиг сайта с настроенным ssl и редиректом с 80 порта на 443:
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
Измените предыдущий конфиг на конфиг с ssl.
Протокол работы ssl указывается тут:
SSLProtocol all -SSLv2
Пути к сертификатам указываются тут:
SSLCertificateFile /etc/ssl/certs/server.pem
SSLCertificateKeyFile /etc/ssl/private/server.key
Перезапускаем Apache2.
service apache2 reload
Добавляем разрешающее правило в Firewall.
ufw allow 443/tcp
Теперь перейдя по ссылке http://newsite.test.com Вы будете перенаправлены на https://newsite.test.com
Удачной установки!
Related posts:Создание шаблонов Zabbix для Windows.Настройка отправки PHP Mail через GmailНастройка Mysql репликации Master - Master
        
             Linux, Ubuntu, Web, Web/Cloud 
             Метки: Apache2, Linux, веб сервера  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
