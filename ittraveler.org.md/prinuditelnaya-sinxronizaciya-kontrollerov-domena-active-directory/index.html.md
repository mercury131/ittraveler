#                 	Принудительная синхронизация контроллеров домена Active Directory                	  
***            ***

			
            
		
    
	
    	  Дата: 30.12.2014 Автор Admin  
	Очень часто возникает необходимость быстро синхронизировать информацию на всех контроллерах домена.
Но если у вас большая сеть, несколько сайтов, или просто настроено долгое время репликации, ожидание синхронизации может быть очень долгим.
Процедура синхронизации в Active Directory полностью автоматическая, каждый контроллер домена тянет на себя новые и измененные данные.
Значит, чтобы изменения, внесенные на контроллере dc01, попали на dc02, требуется, чтобы dc02 был партнером по репликации с dc01 и затем запросил эти изменения у dc01.
В нашем случае мы должны запустить принудительную репликацию, и заставить dc2 применить изменения с dc1.
Тут нам поможет команда repadmin
Далее запускаем команду:
repadmin /syncall dc01
repadmin /syncall dc02
После этого информация на контроллерах домена будет синхронизирована.
Related posts:Сброс настроек GPO на стандартныеПоиск старых почтовых ящиков в Exchange 2010Отключение Skype UI в Lync 2013
        
             Active Directory, Windows 
             Метки: Active Directory, Windows Server  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
