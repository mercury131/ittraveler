#                 	Mysql Перенос баз данных на другой диск                	  
***            ***

			
            
		
    
	
    	  Дата: 31.08.2015 Автор Admin  
	Представим ситуацию когда вам нужно хранить базы данных Mysql на отдельном диске, а не на системном. 
Предположим диск для хранения БД уже подключен и смонтирован в каталог &#8212; /database
Теперь перейдем к настройке.
Останавливаем службу mysql
service mysql stop
Далее копируем каталог с существующими БД на новый диск
sudo cp -R -p /var/lib/mysql /database/mysql
Теперь открываем файл &#8212; /etc/mysql/my.cnf
В нем меняем значение параметра &#8212; datadir , оно должно соответствовать пути к новому диску.
Далее меняем значения AppArmor
Открываем файл &#8212; /etc/apparmor.d/usr.sbin.mysqld
Меняем все значения &#8212; /var/lib/mysql на /database/mysql
Перезапускаем AppArmor
service apparmor reload
Запускаем Mysql
service mysql start
Готово! Теперь БД будет храниться на новом диске.
&nbsp;
Related posts:Настройка Mysql репликации Master - MasterLVM переезд с диска на диск в виртуальной среде.Балансировка нагрузки веб серверов IIS с Windows аутентификацией через Haproxy
        
             Bash, Linux, Ubuntu 
             Метки: Mysql, Ubuntu  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
