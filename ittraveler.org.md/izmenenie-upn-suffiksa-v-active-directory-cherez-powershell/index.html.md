#                 	Изменение UPN суффикса в Active Directory через Powershell                	  
***            ***

			
            
		
    
	
    	  Дата: 12.03.2015 Автор Admin  
	В данной статье я расскажу как изменить UPN суффикс пользователей в домене Active Directory через Powershell.
Представьте ситуацию, у вас в домене более 1000 человек, и вам нужно поменять UPN суффикс каждому из них. Для решения этой задачи нам подойдет следующий скрипт:

# Импортируем модуль Active Directory
Import-Module ActiveDirectory

# Фильтруем пользователей по UPN и OU и меняем всем пользователям суффикс
Get-ADUser -Filter {UserPrincipalName -like "*@domain.local"} -SearchBase "OU=TEST,OU=TestOU,OU=domain,DC=domain,DC=local" |
ForEach-Object {
    $UPN = $_.UserPrincipalName.Replace("domain.local","domain.ru")
    Set-ADUser $_ -UserPrincipalName $UPN
}


&nbsp;
Related posts:Восстановление объектов Active Directory: сборник сценариевУдаление Lync Server 2013Как узнать WWN (World Wide Name)  в Windows Server 2012R2
        
             Active Directory, PowerShell, Windows, Windows Server 
             Метки: Active Directory, Powershell, UPN  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
