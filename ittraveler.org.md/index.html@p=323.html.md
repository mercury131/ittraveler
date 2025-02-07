#                 	Назначение служб для сертификатов Exchange через Powershell.                	  
***            ***

			
            
		
    
	
    	  Дата: 12.03.2015 Автор Admin  
	В данной статье я расскажу как назначить службы сертификату Exchange через Powershell.Первое что мы сделаем, это выведем список текущих сертификатов
Get-ExchangeCertificate
В данном списке найдите сертификат которому вы будете назначать службу, и скопируйте его значение Thumbprint.
Теперь назначим службу выбранному сертификату
Enable-ExchangeCertificate -Server 'ExchangeServer' -Services 'SMTP' -Thumbprint 'EDF57B5F9D81F1EC329BFB77ADD4465B426A40FB'
Так же можно назначить сертификат на все службы
Enable-ExchangeCertificate -Server 'EXCH-H-868' -Services 'IMAP, POP, IIS, SMTP' -Thumbprint 'EDF57B5F9D81F1EC329BFB77ADD4465B426A40FB'
Related posts:Изменение UPN суффикса в Active Directory через PowershellАудит изменений групповых политик через PowerShellВыполняем команды внутри гостевых ОС через PowerCLI
        
             Active Directory, Exchange, PowerShell, Windows, Windows Server 
             Метки: Exchange, Powershell  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
