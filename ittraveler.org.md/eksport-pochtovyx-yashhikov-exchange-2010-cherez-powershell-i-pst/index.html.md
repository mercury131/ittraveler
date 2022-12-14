# Экспорт почтовых ящиков Exchange 2010 через Powershell и PST                	  
***Дата: 31.12.2014 Автор Admin***

В данной статье я расскажу как с помощью скрипта экспортировать несколько почтовых ящиков в PST.
Для выполнения этой задачи нам понадобится заполненный CSV файл и Powershell скрипт.
Шапка CSV файла будет такой:
```
id;
```
id;
Далее мы будем использовать вот такой скрипт:
PowerShell
```
$exchange&amp;nbsp;=&amp;nbsp;New-PSSession&amp;nbsp;-ConfigurationName&amp;nbsp;Microsoft.Exchange&amp;nbsp;-ConnectionUri&amp;nbsp;http://YOUR-EXCHANGE-SERVER/powershell&amp;nbsp;-Authentication&amp;nbsp;Kerberos
Import-PSSession&amp;nbsp;$exchange&amp;nbsp;
Get-PSSession #Список открытых сессий
Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false
$CSVpath = "C:\users.csv"
Import-Csv $CSVpath -Delimiter ";"| % {
$username = $_.id; # Set the user
New-Item -ItemType directory -Path \\YOUR_FILE-SERVER\RemoveUsers\$username
New-MailboxExportRequest -Mailbox $username -FilePath \\YOUR_FILE-SERVER\RemoveUsers\$username\$username.pst
}
Remove-PSSession $exchange
```
$exchange&amp;nbsp;=&amp;nbsp;New-PSSession&amp;nbsp;-ConfigurationName&amp;nbsp;Microsoft.Exchange&amp;nbsp;-ConnectionUri&amp;nbsp;http://YOUR-EXCHANGE-SERVER/powershell&amp;nbsp;-Authentication&amp;nbsp;KerberosImport-PSSession&amp;nbsp;$exchange&amp;nbsp;Get-PSSession #Список открытых сессий&nbsp;Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false$CSVpath = "C:\users.csv"Import-Csv $CSVpath -Delimiter ";"| % {$username = $_.id; # Set the userNew-Item -ItemType directory -Path \\YOUR_FILE-SERVER\RemoveUsers\$usernameNew-MailboxExportRequest -Mailbox $username -FilePath \\YOUR_FILE-SERVER\RemoveUsers\$username\$username.pst&nbsp;}&nbsp;Remove-PSSession $exchange
Не забывайте подставлять свои значения в скрипты!
Теперь можно отключить ненужные учетные записи с помощью командлета
```
Disable-Mailbox $username -Confirm:$False
```
Disable-Mailbox $username -Confirm:$False
Или скрипта
```
$exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://YOUR-EXCHANGE-SERVER/powershell -Authentication Kerberos
Import-PSSession $exchange 
Get-PSSession #Список открытых сессий
Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false
$CSVpath = "C:\users.csv"
Import-Csv $CSVpath -Delimiter ";"| % {
$username = $_.id; # Set the user
Disable-Mailbox $username -Confirm:$False
}
Remove-PSSession $exchange
```
$exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://YOUR-EXCHANGE-SERVER/powershell -Authentication KerberosImport-PSSession $exchange Get-PSSession #Список открытых сессий&nbsp;Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false$CSVpath = "C:\users.csv"Import-Csv $CSVpath -Delimiter ";"| % {$username = $_.id; # Set the user&nbsp;Disable-Mailbox $username -Confirm:$False}&nbsp;Remove-PSSession $exchange
Просмотреть статус экспорта можно командой:
```
Get-MailboxExportRequest
```
Get-MailboxExportRequest
После экспорта не забываем удалить выполненные запросы на экспорт. Делается это так:
```
Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false
```
Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false
&nbsp;
Related posts:Аудит DNS серверов на Windows Server 2008 R2 через PowershellОбновление Lync 2013 до Skype for BusinessWindows WSL подключение к сетевым шарам
 Exchange, PowerShell, Windows, Windows Server 
 Метки: Exchange, Powershell  
                        
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
