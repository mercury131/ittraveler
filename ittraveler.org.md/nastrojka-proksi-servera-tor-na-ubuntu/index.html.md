#                 	Настройка прокси сервера Tor на Ubuntu.                	  
***            ***

			
            
		
    
	
    	  Дата: 12.05.2015 Автор Admin  
	В данной статье мы рассмотрим установку и настройку прокси сервера Tor на Ubuntu.
Устанавливаем Tor
apt-get install tor
Устанавливаем прокси сервер privoxy
apt-get install tor privoxy
Далее открываем конфиг privoxy расположенный по адресу:
/etc/privoxy/config
И добавляем в конфиг строку:
forward-socks4a / localhost:9050
Внимание знак &#171;.&#187; (точка) обязателен!
Этой записью мы перенаправляем трафик прокси на сеть Tor.
Запускаем сервисы
service tor start
service privoxy start
Готово! Прокси сервер работает на порту 8118.
Если Вы хотите изменить порт или ip адрес для прокси, измените в конфиге (/etc/privoxy/config) строку:
listen-address 192.168.1.55:8118
Где 192.168.1.55 ваш ip адрес, а 8118 ваш порт.
Остается только настроить в браузере адрес прокси сервера и порт 8118
Related posts:ZFS перенос корневого пула с ОС на новый диск, меньшего размера.Настраиваем аудит сервера Ubuntu через AIDEУстановка и настройка веб сервера Nginx
        
             Linux, Ubuntu, Сети 
             Метки: TOR, Ubuntu, Прокси, Сети  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
