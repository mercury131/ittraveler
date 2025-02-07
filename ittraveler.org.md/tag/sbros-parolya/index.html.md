#                 	 Сброс пароля администратора Active Directory   
***            	***

                
			
	
		
    
	В этой статье мы рассмотрим сценарий сброса пароля администратора домена Active Direcotory.  Эта возможность может понадобиться в случаях утраты прав доменного администратора вследствие, например, «забывчивости» или намеренного саботажа увольняющегося админа, атаки злоумышленников или других форс мажорных обстоятельствах.   Для успешного сброса пароля администратора домена необходимо иметь физический или удаленный (ILO, iDRAC или консоль vSphere, в случае использования виртуального DC) доступ к  консоли сервера. В данном примере мы будем сбрасывать пароль администратора на контроллере домене с ОС Windows Server 2012. В том случае, если в сети несколько контроллеров домена, рекомендуется выполнять процедуру на сервере PDC (primary domain controller) с ролью FSMO (flexible single-master operations). [...] 
        
             30.12.2014 
             Active Directory, Windows, Windows Server 
        
            
        
	
        
                
            
			
		
		        
	        
        
        
    
        
    
	
        
            
            
            
				Архивы
			
					Февраль 2025
	Октябрь 2019
	Сентябрь 2019
	Июнь 2019
	Март 2019
	Декабрь 2018
	Август 2018
	Июль 2018
	Июнь 2018
	Май 2017
	Апрель 2017
	Июнь 2016
	Май 2016
	Октябрь 2015
	Август 2015
	Июль 2015
	Июнь 2015
	Май 2015
	Апрель 2015
	Март 2015
	Февраль 2015
	Январь 2015
	Декабрь 2014
			
			Календарь
	Февраль 2025
	
	
		Пн
		Вт
		Ср
		Чт
		Пт
		Сб
		Вс
	
	
	
	
		&nbsp;12
	
	
		3456789
	
	
		10111213141516
	
	
		17181920212223
	
	
		2425262728
		&nbsp;
	
	
	
		&laquo; Окт
		&nbsp;
		&nbsp;
	Рубрики
			
					Active Directory
	Asterisk
	Bash
	Cisco
	Cloud
	Debian
	Exchange
	GLPI Service Desk
	Linux
	Office 365
	PowerShell
	Puppet
	Ubuntu
	Web
	Web/Cloud
	Windows
	Windows Server
	Без рубрики
	Виртуализация
	Сети
			
			                 
            
            
        
    
	           
    
    
  
	
    
		
        
             
			
                
                    
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
