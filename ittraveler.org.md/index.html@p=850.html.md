#                 	Мониторинг срока действия сертификатов Lets Encrypt                	  
***            ***

			
            
		
    
	
    	  Дата: 05.05.2017 Автор Admin  
	Я думаю многие из вас пользуются бесплатными сертификатами Lets Encrypt, но многие ли мониторят срок их действия?
Подкатом я покажу простой bash скрипт, который будет заниматься мониторингом сроков действия сертификатов.
Для настройки оповещений первым делом настройте ssmtp , т.к его мы будем использовать для отправки писем. Как это сделать написано в этой статье.
Теперь сам скрипт мониторинга:
#!/bin/bash

SERVER="yourServerName"
EMAIL='your@email.com'
FROM='yourServer@email.com'
ALERTMESSAGE='/tmp/ALERTMESSAGE_cert.tmp'

if /usr/bin/openssl x509 -checkend 86400 -noout -in /etc/letsencrypt/live/yourDOMAIN/fullchain.pem
then
  echo "Certificate is good for another day!"

else

echo "To: $EMAIL" &gt; $ALERTMESSAGE
echo "From: $FROM" &gt;&gt; $ALERTMESSAGE
echo "Subject: SSL Cert Renew!" &gt;&gt; $ALERTMESSAGE
echo "" &gt;&gt; $ALERTMESSAGE
echo "Certificate has expired or will do so within 24 hours!" &gt;&gt; $ALERTMESSAGE
echo "Start LetsEncrypt" &gt;&gt; $ALERTMESSAGE
/opt/letsencrypt/letsencrypt-auto renew &gt;&gt; $ALERTMESSAGE

/usr/sbin/ssmtp $EMAIL &lt; $ALERTMESSAGE

service nginx reload
fi
В данном скрипте замените следующие строки:
SERVER=&#187;yourServerName&#187; &#8212; Имя сервера (можно указать любое)
EMAIL=&#8217;your@email.com&#8217; &#8212; Ваш Email
FROM=&#8217;yourServer@email.com&#8217; &#8212; Email SSMTP
/etc/letsencrypt/live/yourDOMAIN/fullchain.pem &#8212; в этой строке вместо yourDOMAIN укажите ваш домен, на который выдан сертификат
service nginx reload &#8212; эта строка перезагружает конфиг вебсервера nginx, если у вас другой вебсервер замените эту строку
Теперь командой chmod +x sslmonitoring.sh сделайте скрипт исполняемым (где sslmonitoring.sh имя скрипта)
Далее просто добавьте скрипт в cron , командой crontab -e
0 1 * * * /path_to_script/sslmonitoring.sh
Данный скрипт будет запускаться раз в сутки в час ночи.
Если сертификат закончится через 24 часа, то он запустит клиент letsencrypt и обновит сертификат , после чего перезапустит веб сервер.
Related posts:Установка и настройка хостинг панели VestaCP c поддержкой разных версий PHPНастройка ZFS в ProxmoxНастройка отправки PHP Mail через Gmail
        
             Bash, Linux, Web, Web/Cloud, Без рубрики 
             Метки: letsencrypt, ssl monitoring, мониторинг сертификатов  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
