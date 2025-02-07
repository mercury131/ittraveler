#                 	Автоматическая активация лицензий Office 365                	  
***            ***

			
            
		
    
	
    	  Дата: 30.12.2014 Автор Admin  
	Если вам нужно автоматически активировать лицензии пользователей Office 365, то данный скрипт будет вам полезен.Для начала вам нужно понять какой тип лицензий нужно активировать, для этого введите следующую команду в Powershell Office 365
Get-MSOLAccountSku
После выполнения этой команды вы увидите тип используемых вами лицензий
Полученную информацию нужно будет подставить в следующий скрипт:
#Change these variables to match your environment
$AccountSkuId = "YOUR_Account:YOUR_STANDARDPACK"
$UsageLocation = "RU"
$AdminUsername = "LOGIN"
$AdminPassword = "PASS"

$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword

Connect-MSOLService -Credential $cred

$LicenseOptions = New-MsolLicenseOptions -AccountSkuId $AccountSkuId
$UnlicencedUsers = Get-MSOLUser -UnlicensedUsersOnly -All

$UnlicencedUsers | ForEach-Object {
	Set-MsolUser -UserPrincipalName $_.UserPrincipalName -UsageLocation $UsageLocation
	Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -AddLicenses $AccountSkuId -LicenseOptions $LicenseOptions
}
Теперь можно добавить этот скрипт в планировщик, и новые пользователи будет получать лицензии автоматически =)
Related posts:Экспорт почтовых ящиков Exchange 2010 через Powershell и PSTАвтоматизация создания адресных книг в Office 365 через Powershell Часть 3.Автоматический аудит компьютеров в Active Directory через powershell.
        
             Office 365, PowerShell 
             Метки: Office 365, Powershell, Лицензии  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
