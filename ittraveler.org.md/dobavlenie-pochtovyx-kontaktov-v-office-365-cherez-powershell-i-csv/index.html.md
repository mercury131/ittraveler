# Добавление почтовых контактов в Office 365 через Powershell и CSV                	  
***Дата: 30.12.2014 Автор Admin***

Если вам нужно добавить большое кол-во почтовых контактов в Office 365 или Exchange Online, да еще и в группу рассылки их включить, прошу под кат)Первое что нам нужно сделать, это заполнить CSV файл со следующей шапкой:
```
FirstName;LastName;Email
```
FirstName;LastName;Email
Далее пишем вот такой скрипт:
```
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Import-Module MSOnline
Connect-MSOLService -Credential $cred
#Задаем переменные
$CSVpatch = "C:\PowerShell_Scripts\office365contact.csv"
Import-Csv $CSVpatch -Delimiter ";" | % {
$FirstName = $_.FirstName; # Set the FirstName
$LastName = $_.LastName; # Set the LastName
$Email = $_.Email; # Set the email
$namealias = $Email.Replace("@","")
$namealias = $namealias.Replace(".","")
New-MailContact -Name $LastName -DisplayName $LastName -ExternalEmailAddress $Email -FirstName $FirstName -LastName $LastName -Alias $namealias
Set-MailContact -Identity $Email -HiddenFromAddressListsEnabled $true
Add-DistributionGroupMember -Identity "YOUR_Distribution_Group@domain.com" -Member $Email
}
```
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection&nbsp;Import-PSSession $Session&nbsp;Import-Module MSOnline&nbsp;Connect-MSOLService -Credential $cred&nbsp;#Задаем переменные&nbsp;$CSVpatch = "C:\PowerShell_Scripts\office365contact.csv"&nbsp;Import-Csv $CSVpatch -Delimiter ";" | % {$FirstName = $_.FirstName; # Set the FirstName$LastName = $_.LastName; # Set the LastName$Email = $_.Email; # Set the email&nbsp;$namealias = $Email.Replace("@","")&nbsp;$namealias = $namealias.Replace(".","")&nbsp;New-MailContact -Name $LastName -DisplayName $LastName -ExternalEmailAddress $Email -FirstName $FirstName -LastName $LastName -Alias $namealias&nbsp;Set-MailContact -Identity $Email -HiddenFromAddressListsEnabled $true&nbsp;Add-DistributionGroupMember -Identity "YOUR_Distribution_Group@domain.com" -Member $Email&nbsp;}
&nbsp;
Related posts:Принудительная синхронизация Office 365 и локальной Active DirectoryПеренос виртуальной машины из Hyper-V в Proxmox (KVM)Автоматическая активация пользователей Lync через Powershell
 Exchange, Office 365, PowerShell, Windows, Windows Server 
 Метки: Exchange online, Office 365, Powershell  
                        
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
