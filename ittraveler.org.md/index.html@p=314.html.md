# Аудит незаполненных полей в Active Directory через Powershell                	  
***Дата: 06.03.2015 Автор Admin***

В данной статье я расскажу как проводить аудит полей Active Directory через Powershell.Думаю многие системные администраторы сталкивались с проблемой, когда техническая поддержка забывает заполнять обязательные поля в Active Directory. Например номер телефона или отдел.
Для решения этих проблем предлагаю использовать PowerShell, нам поможет данный скрипт:
```
# Импортируем модуль Active Directory
import-module ActiveDirectory
# Указываем в каком подразделении проверять пользователей
$base = "OU=Moscow,OU=Users,DC=domain,DC=local"
# Указываем какие свойства должны быть заполнены
$properties = "telephoneNumber","enabled","displayName","company","department","title"
# Начинаем проверку и формируем тело письма
$body = Get-ADUser -Filter * -SearchBase $base -Properties $properties | Where-Object {$_.Enabled -eq "True"} | Foreach {
$user = $_
if($miss = $properties | Where {!$user."$_"}) {
"{0} - {1}" -f ($miss -join ","),$user.name
}
else {
# Если раскомментировать эту строку, по в список будут попадать пользователи с заполненными полями
#"verify - {0}" -f $user.name
}
} | Sort |  Out-String
$body2 = echo Актуализировать незаполненные пользовательские поля в Active Directory. список незаполненных полей ниже
$body3 = echo .   список: | Out-String      
# Отправляем сообщения
Send-MailMessage -From admin-notification@domain.local -To admin@domain.local -Encoding ([System.Text.Encoding]::UTF8) -Subject "Аудит незаполненных полей в Active Directory " -Body $body2$body3$Body -SmtpServer YourMailServer.domain.local
```
# Импортируем модуль Active Directoryimport-module ActiveDirectory&nbsp;# Указываем в каком подразделении проверять пользователей$base = "OU=Moscow,OU=Users,DC=domain,DC=local"&nbsp;# Указываем какие свойства должны быть заполнены$properties = "telephoneNumber","enabled","displayName","company","department","title"&nbsp;# Начинаем проверку и формируем тело письма$body = Get-ADUser -Filter * -SearchBase $base -Properties $properties | Where-Object {$_.Enabled -eq "True"} | Foreach { $user = $_ if($miss = $properties | Where {!$user."$_"}) {&nbsp;&nbsp;"{0} - {1}" -f ($miss -join ","),$user.name } else {&nbsp;&nbsp;# Если раскомментировать эту строку, по в список будут попадать пользователи с заполненными полями&nbsp;&nbsp;#"verify - {0}" -f $user.name }&nbsp;} | Sort |&nbsp;&nbsp;Out-String&nbsp;$body2 = echo Актуализировать незаполненные пользовательские поля в Active Directory. список незаполненных полей ниже$body3 = echo .&nbsp;&nbsp; список: | Out-String&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Отправляем сообщенияSend-MailMessage -From admin-notification@domain.local -To admin@domain.local -Encoding ([System.Text.Encoding]::UTF8) -Subject "Аудит незаполненных полей в Active Directory " -Body $body2$body3$Body -SmtpServer YourMailServer.domain.local
После выполнения данного скрипта, администратору придет письмо, со списком пользователей у которых не заполнены поля Active Directory.
Тело письма будет выглядеть так:
telephoneNumber &#8212; Stager36
telephoneNumber &#8212; Stager37
telephoneNumber &#8212; Stager38
telephoneNumber &#8212; Stager39
telephoneNumber &#8212; Stager40
Далее остается установить скрипт в планировщик задач.
В своей организации я отправляю письмо в helpdesk систему GLPI, далее система автоматически назначает специалиста, но это уже тема для другой статьи =)
Related posts:Установка и настройка Scale-Out File Server + Storage Spaces DirectИзменение UPN суффикса в Active Directory через PowershellНовые компьютеры не появляются на WSUS сервере
 Active Directory, PowerShell, Windows, Windows Server 
   
                        
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
