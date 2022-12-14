# Создание email рассылки через Powershell                	  
***Дата: 12.03.2015 Автор Admin***

В данной статье мы рассмотрим как создать простую email рассылку через Powershell.
Для создания рассылки мы будем использовать следующий код:
PowerShell
```
# Путь к файлу CSV со списком Email
$CSVpatch = "C:\PS\address.csv"
# Импортируем CSV
Import-Csv $CSVpatch -Delimiter ";" | % {
$email = $_.address; # Set the email
# Показываем какой Email в данный момент отправляем
echo $email
# Формируем тело письма
$body= (Get-Content C:\PS\message2.txt | out-string )
Send-MailMessage -From Noreply@domain.ru -To $email -Subject "Тема письма" -Body $Body -Encoding ([System.Text.Encoding]::UTF8) -SmtpServer YourMailServer
# Ждем 10 секунд перед отправкой следующего email
sleep 10
}
```
# Путь к файлу CSV со списком Email$CSVpatch = "C:\PS\address.csv"&nbsp;# Импортируем CSVImport-Csv $CSVpatch -Delimiter ";" | % {$email = $_.address; # Set the email&nbsp;# Показываем какой Email в данный момент отправляемecho $email&nbsp;# Формируем тело письма$body= (Get-Content C:\PS\message2.txt | out-string )&nbsp;Send-MailMessage -From Noreply@domain.ru -To $email -Subject "Тема письма" -Body $Body -Encoding ([System.Text.Encoding]::UTF8) -SmtpServer YourMailServer&nbsp;# Ждем 10 секунд перед отправкой следующего emailsleep 10}
&nbsp;
CSV файл выглядит так:
```
address;
email@mail.com
email2@mail.com
```
address;email@mail.comemail2@mail.com
Email вводятся построчно.
Данный скрипт берет список адресов (Email) из CSV файла (переменная $CSVpatch)
Далее скрипт формирует тело письма из txt файла message2.txt (переменная $body)
Далее скрипт отправляет письмо на каждый email (не на все сразу) с интервалом 10 секунд.
Related posts:Получаем MD5 файла или переменной в PowershellУдаление Lync Server 2013Включение корзины Active Directory
 PowerShell, Windows, Windows Server 
 Метки: Email рассылка, Powershell  
                        
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
