# Подключение к Office 365 через Powershell и зашифрованный пароль                	  
***Дата: 30.12.2014 Автор Admin***

В данной статье я покажу как с помощью Powershell можно подключиться к Office 365, не храня пароль в открытом виде в скрипте.
Первым делом шифруем наш пароль, для этого вводим команду:
```
read-host -prompt "Enter password to be encrypted in mypassword.txt " -assecurestring | convertfrom-securestring | out-file C:\Путь к файлу.txt
```
read-host -prompt "Enter password to be encrypted in mypassword.txt " -assecurestring | convertfrom-securestring | out-file C:\Путь к файлу.txt
Теперь стыкуем зашифрованный пароль со скриптом подключения к Office 365
```
$pass = cat C:\Путь к файлу.txt | convertto-securestring
$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist "LOGIN",$pass
Import-Module MSOnline
$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Authentication Basic -AllowRedirection -Credential $mycred
Import-PSSession $O365Session
Connect-MsolService -Credential $mycred
```
$pass = cat C:\Путь к файлу.txt | convertto-securestring&nbsp;$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist "LOGIN",$pass&nbsp;Import-Module MSOnline&nbsp;$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Authentication Basic -AllowRedirection -Credential $mycred&nbsp;Import-PSSession $O365Session&nbsp;Connect-MsolService -Credential $mycred
Теперь вы можете подключиться к Office 365 не указывая свой пароль в открытом виде.
&nbsp;
Related posts:Автоматический аудит компьютеров в Active Directory через powershell.Настройка HA кластера Hyper-VУправление репликацией Active Directory
 Office 365, PowerShell, Windows, Windows Server 
 Метки: Office 365, Powershell  
                        
Добавить комментарий Отменить ответВаш адрес email не будет опубликован.Комментарий Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-1890562251101921"
data-ad-slot="9117958896"
data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
  
Все права защищены. IT Traveler 2022 
                            
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
