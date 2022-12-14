# Аудит изменений групповых политик через PowerShell                	  
***Дата: 07.08.2015 Автор Admin***

Если в вашей компании больше чем один системный администратор, то рано или поздно вы столкнетесь с проблемой аудита GPO.
В данной статье мы разберем как получить уведомление на почту об измененных групповых политиках.
В решении данной проблемы мы будем использовать скрипт, который будет искать изменения в GPO за указанное кол-во дней, создавать отчет GPO и отправлять письмо системному администратору.
Теперь сам скрипт:
PowerShell
```
#Указываем почтовый сервер
$mailserver="mailserver"
#Путь где будут храниться отчеты по GPO
$reportPatch="\yourdir1"
# кол-во дней за которые идет поиск
$days='10'
# Почтовый домен
$mail_domain="domain.com"
# получатели
$sendto="admin@domain.com"
# тема письма
$theme="Аудит изменений в GPO"
# временный текстовый файл в котором формируется тело письма
$tmp="\yourdirtmp\body.txt"
# Путь где хранятся временный zip архив с отчетами
$zippatch='\yourdirtmp3'
# полный путь к zip архиву для отправки по почте
$Attachment="$zippatch\GPOreport.zip"
# Удаляем старое вложение
Remove-Item $Attachment
# Импортируем модуль GroupPolicy
Import-Module GroupPolicy
# Добавляем заголовок в тему письма
echo "Изменены следующие групповые политики:" &gt; $tmp
# Загружаем список измененных GPO
$changed_GPO = (Get-GPO -all | ? {$_.ModificationTime -gt (get-date).adddays(—$days)}).DisplayName
foreach ($gpos in $changed_GPO)
{
# Создаем отчеты GPO
Get-GPOReport -Name "$gpos" -ReportType HTML -Path $reportPatch\$gpos.html
}
# Добавляем в тело письма список измененных GPO
$gpo_modif=Get-GPO -all | ? {$_.ModificationTime -gt (get-date).adddays(—$days)} | select DisplayName, ModificationTime | ft -AutoSize &gt;&gt; $tmp
# Преобразуем тело письма
$body=Get-Content $tmp | Out-String 
# Архивируем полученные отчеты в zip
function ZipFiles( $zipfilename, $sourcedir )
{
Add-Type -Assembly System.IO.Compression.FileSystem
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,
$zipfilename, $compressionLevel, $false)
}
ZipFiles $zippatch\GPOreport.zip $reportPatch\
# Отправляем письмо администратору
Send-MailMessage -From GPO-notification@$mail_domain -To $sendto -Encoding ([System.Text.Encoding]::UTF8) -Subject $theme -Body $body -SmtpServer $mailserver -Attachment "$Attachment"
```
#Указываем почтовый сервер$mailserver="mailserver"#Путь где будут храниться отчеты по GPO$reportPatch="\yourdir1"# кол-во дней за которые идет поиск$days='10'# Почтовый домен$mail_domain="domain.com"# получатели$sendto="admin@domain.com"# тема письма$theme="Аудит изменений в GPO"# временный текстовый файл в котором формируется тело письма$tmp="\yourdirtmp\body.txt"# Путь где хранятся временный zip архив с отчетами$zippatch='\yourdirtmp3'# полный путь к zip архиву для отправки по почте$Attachment="$zippatch\GPOreport.zip"&nbsp;&nbsp;# Удаляем старое вложение&nbsp;Remove-Item $Attachment&nbsp;# Импортируем модуль GroupPolicy&nbsp;Import-Module GroupPolicy&nbsp;# Добавляем заголовок в тему письма&nbsp;echo "Изменены следующие групповые политики:" &gt; $tmp&nbsp;&nbsp;# Загружаем список измененных GPO&nbsp;$changed_GPO = (Get-GPO -all | ? {$_.ModificationTime -gt (get-date).adddays(—$days)}).DisplayName&nbsp;foreach ($gpos in $changed_GPO)&nbsp;{&nbsp;# Создаем отчеты GPO&nbsp;Get-GPOReport -Name "$gpos" -ReportType HTML -Path $reportPatch\$gpos.html&nbsp;&nbsp;}# Добавляем в тело письма список измененных GPO$gpo_modif=Get-GPO -all | ? {$_.ModificationTime -gt (get-date).adddays(—$days)} | select DisplayName, ModificationTime | ft -AutoSize &gt;&gt; $tmp&nbsp;# Преобразуем тело письма$body=Get-Content $tmp | Out-String &nbsp;# Архивируем полученные отчеты в zip&nbsp;function ZipFiles( $zipfilename, $sourcedir ){&nbsp;&nbsp; Add-Type -Assembly System.IO.Compression.FileSystem&nbsp;&nbsp; $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal&nbsp;&nbsp; [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$zipfilename, $compressionLevel, $false)}&nbsp;ZipFiles $zippatch\GPOreport.zip $reportPatch\&nbsp;# Отправляем письмо администратору&nbsp;Send-MailMessage -From GPO-notification@$mail_domain -To $sendto -Encoding ([System.Text.Encoding]::UTF8) -Subject $theme -Body $body -SmtpServer $mailserver -Attachment "$Attachment"
Измените переменные и скрипт будет работать.
Удачного аудита GPO =)
Related posts:Быстрое восстановление удаленных данных из Active Directory с помощью Active Directory Object Restor...Аудит незаполненных полей в Active Directory через PowershellИзменение UPN суффикса в Active Directory через Powershell
 Active Directory, PowerShell 
 Метки: Active Directory, GPO, Powershell  
                        
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
