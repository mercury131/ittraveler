#                 	Поиск старых почтовых ящиков в Exchange 2010                	  
***            ***

			
            
		
    
	
    	  Дата: 31.12.2014 Автор Admin  
	В данной статье я расскажу как с помощью Powershell найти старые почтовые ящики Exchange и отправить уведомление на Email.
Для решения этой задачи мы напишем скрипт, который будет делать следующее:
1) Импортирует модуль Exchange
2) импортирует модуль Active Directory
3) Найдет пользователей которые не заходили в систему 120 дней
4) Проверит у кого из них есть почтовый ящик
5) Полученный результат отправит нам на почту.
Теперь сам скрипт:
# Импорт модуля Exchange
add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

# Импорт модуля ActiveDirectory
import-module ActiveDirectory

#Удаляем старые файлы inactive.txt и .\mailbox.txt
remove-item .\inactive.txt

remove-item .\mailbox.txt

#Поиск пользователей которые не заходили в систему 120 дней
(get-aduser -filter * -properties lastlogondate | Where-Object {$_.enabled -eq "true"-and $_.lastlogondate -lt (get-date).adddays(-120)}).SamAccountName &gt; .\inactive.txt

$userlist = Get-Content .\inactive.txt

#Проверяем есть ли у них почтовый ящик
foreach ($user in $userlist)

{
$Mailbox = get-mailbox -identity $user

if ($mailbox) {

$user &gt;&gt; .\mailbox.txt
}}

$files = Get-Content .\mailbox.txt

#Формируем тело письма
$body = Get-Content .\mailbox.txt | Sort |  Out-String
$body1 = echo The old mailboxes not found  |  Out-String

#Отправляем письма
if ($files -ne $null)
{
   Send-MailMessage -From admin-notification@domain.local -To sysadmin@domain.local -Encoding ([System.Text.Encoding]::UTF8) -attachment .\mailbox.txt -Subject "Обнаружены старые почтовые ящики" -Body $body  -SmtpServer EXCHANGE-Server.domain.local
}
else
{
   Send-MailMessage -From admin-notification@domain.local -To sysadmin@domain.local -Encoding ([System.Text.Encoding]::UTF8) -Subject "Cтарые почтовые ящики не обнаружены" -Body $body1 -BodyAsHtml -SmtpServer EXCHANGE-Server.domain.local
}
&nbsp;
Related posts:Автоматическая активация пользователей Lync через PowershellПолучаем MD5 файла или переменной в PowershellУстановка и настройка Ansible
        
             Active Directory, Exchange, PowerShell 
             Метки: Active Directory, Exchange, Powershell  
        
            
        
    
                        
                    
                    
                
        
                
	
    	
        
        	Комментарии
        
		
		 
    
    
        
                    
         
        
            
            
                
                Айрат
                  
                24.01.2016 в 16:13 - 
                Ответить                                
                
            
    
                      
            помогите найти электронный ящик
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                09.02.2016 в 08:54 - 
                Ответить                                
                
            
    
                      
            Извините, я не занимаюсь поиском почтовых ящиков)
          
        
        
        
    
    
	
    
	
		
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
