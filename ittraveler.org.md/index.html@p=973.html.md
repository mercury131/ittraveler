#                 	Настройка работы прокси сервера SQUID через сторонний прокси сервер.                	  
***            ***

			
            
		
    
	
    	  Дата: 25.06.2018 Автор Admin  
	Иногда в тестовых средах вы по каким-то причинам не можете использовать прокси сервер с авторизацией по логину и паролю, и прямого доступа в интернет у вас нет.
В таком случае вам поможет промежуточный прокси сервер на базе Squid, который будет использовать основной прокси сервер для доступа в интернет.
Далее я расскажу как все это настроить.
Устанавливать squid я буду на ubuntu server 16.04.
Обновим список пакетов и проапдейтим систему
apt-get update
apt-get upgrade
установим squid
apt-get install squid3
Сделаем бэкап конфига
cp /etc/squid/squid.conf /etc/squid/squid.conf.old
Теперь откроем файл /etc/squid/squid.conf и отредактируем его следующим образом:
http_access allow all
http_port 80

coredump_dir /var/spool/squid3
refresh_pattern ^ftp:       1440    20% 10080
refresh_pattern ^gopher:    1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%  0
refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
refresh_pattern .       0   20% 4320

cache_peer YOUR-PROXY-SERVER-DNS-NAME parent 3128 0 no-query default login=YOUR-LOGIN:YOUR-PASS
never_direct allow all
via off
forwarded_for off

request_header_access From deny all
request_header_access Server deny all
request_header_access WWW-Authenticate deny all
request_header_access Link deny all
request_header_access Cache-Control deny all
request_header_access Proxy-Connection deny all
request_header_access X-Cache deny all
request_header_access X-Cache-Lookup deny all
request_header_access Via deny all
request_header_access X-Forwarded-For deny all
request_header_access Pragma deny all
request_header_access Keep-Alive deny all

acl test_net src 192.168.1.0/19

http_access allow test_net

http_access allow localhost
http_access deny all
Вместо YOUR-PROXY-SERVER-DNS-NAME введите dns имя вашего прокси сервера
Вместо YOUR-LOGIN:YOUR-PASS укажите ваши логин и пароль к прокси
Вместо test_net укажите название своей сети
Вместо 192.168.1.0/19 укажите свою подсеть.
Сохраните конфиг.
Теперь откройте доступ к серверу из вашей подсети командой:
ufw allow from 192.168.1.0/19
Перезапустите прокси сервер squid
service squid restart
Готово, настройка сервера завершена.
Доступ к данному прокси серверу есть только из вашей подсети и прокси сервер доступен без авторизации.
Related posts:Настройка сети в организации. Часть 1.Установка и настройка хостинг панели VestaCP c поддержкой разных версий PHPНастройка сети в организации. Часть 2
        
             Ubuntu, Сети 
             Метки: Linux, squid, Ubuntu, Прокси  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
