#                 	 Автоматизация создания адресных книг в Office 365 через Powershell Часть 3.   
***            	***

                
			
	
		
    
	В данной статья я расскажу как автоматизировать процесс добавления новых пользователей в политику адресных книг Office 365.
 [...] 
        
             31.12.2014 
             Active Directory, Exchange, Office 365, PowerShell, Windows, Windows Server 
        
            
        
	
        
                
            
			
		
		
            
    
							
            	
                 
                	 Автоматизация создания адресных книг в Office 365 через Powershell Часть 2 
                	
                
			
	
		
    
	В данной статье мы рассмотрим как удалять неактуальные адресные книги в Office 365.
 [...] 
        
             31.12.2014 
             Active Directory, Exchange, Office 365, PowerShell 
        
            
        
	
        
                
            
			
		
		
            
    
							
            	
                 
                	 Автоматизация создания адресных книг в Office 365 через Powershell Часть 1. 
                	
                
			
	
		
    
	В данном цикле статей я покажу как автоматизировать процесс создания, удаления, актуализации адресных книг в Office 365.
Имеем следующую схему:
1) Пользователи синхронизируются из локальной AD, каждый пользователь находится в своей OU с названием его компании, и состоит в 2-х группах (по 2-е группы на каждую компанию)
2) Нам нужно автоматизировать процесс создания индивидуальных адресных книг для каждой компании (OU).
 [...] 
        
             31.12.2014 
             Active Directory, Office 365, PowerShell 
        
            
        
	
        
                
            
			
		
		
            
    
							
            	
                 
                	 Добавление почтовых контактов в Office 365 через Powershell и CSV 
                	
                
			
	
		
    
	Если вам нужно добавить большое кол-во почтовых контактов в Office 365 или Exchange Online, да еще и в группу рассылки их включить, прошу под кат) [...] 
        
             30.12.2014 
             Exchange, Office 365, PowerShell, Windows, Windows Server 
        
            
        
	
        
                
            
			
		
		
            
    
							
            	
                 
                	 Автоматическая активация лицензий Office 365 
                	
                
			
	
		
    
	Если вам нужно автоматически активировать лицензии пользователей Office 365, то данный скрипт будет вам полезен. [...] 
        
             30.12.2014 
             Office 365, PowerShell 
        
            
        
	
        
                
            
			
		
		
            
    
							
            	
                 
                	 Подключение к Office 365 через Powershell и зашифрованный пароль 
                	
                
			
	
		
    
	В данной статье я покажу как с помощью Powershell можно подключиться к Office 365, не храня пароль в открытом виде в скрипте. [...] 
        
             30.12.2014 
             Office 365, PowerShell, Windows, Windows Server 
        
            
        
	
        
                
            
			
		
		
            
    
							
            	
                 
                	 Создание индивидуальных адресных книг в Office 365 и Exchange online 
                	
                
			
	
		
    
	Один раз мне поставили задачу разграничить адресные книги пользователям Office 365.
Смысл был в том, что каждый пользователь должен видеть только адресную книгу своей компании, чужих пользователей и их адресные книги он видеть не должен.
В моем случае пользователи синхронизировались из локальной Active Directory в Office 365, поэтому было решено фильтровать пользователей по группам AD, и с помощью групп разграничивать адресные книги.
Далее скрипт как это сделать. [...] 
        
             30.12.2014 
             Active Directory, Office 365, PowerShell, Windows, Windows Server 
        
            
        
	
        
                
            
			
		
		
            
    
							
            	
                 
                	 Принудительная синхронизация Office 365 и локальной Active Directory 
                	
                
			
	
		
    
	Для принудительной синхронизации Office 365 и локальной Active Directory мы будем использовать Powershell.
Открываем Powershell от имени администратора, и вводим следующие команды: [...] 
        
             30.12.2014 
             Active Directory, Office 365, PowerShell, Windows, Windows Server 
        
            
        
	
        
                
            
			
		
		        
	        
        
        
    
        
    
	
        
            
            
            
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
