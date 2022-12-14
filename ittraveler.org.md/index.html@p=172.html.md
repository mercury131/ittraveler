# Автоматизация создания адресных книг в Office 365 через Powershell Часть 2                	  
***Дата: 31.12.2014 Автор Admin***

В данной статье мы рассмотрим как удалять неактуальные адресные книги в Office 365.
Алгоритм скрипта будет такой:
1) Подключаемся к Office 365
2) Синхронизируем локальную AD с Office 365
3) Выгружаем в CSV список групп Office 365 (выгружаем все группы кроме стандартных)
4) Отключаемся от Office 365
5) Импортируем CSV и проверяем существуют ли группы в локальной Active Directory
6) Создаем список групп которые не существуют в локальной Active Directory
7) Подключаемся к Office 365
8) Отключаем неактуальные политики адресных книг
9) Удаляем неактуальные политики адресных книг, адресные листы, GAL, Offline address book
Теперь сам скрипт:
```
#Delete OLD Sessions
Remove-PSSession $Session
$AdminUsername = "LOGIN@test.com"
$AdminPassword = "PASS"
#Set Vars
$CSVpatch = "C:\PowerShell_Scripts\TEMP_CSV.csv"
$ADgroupTEMP = "C:\PowerShell_Scripts\TEMP_123.txt"
#Connect to Office 365
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Import-Module MSOnline
Connect-MSOLService -Credential $cred
#Sync Local AD with Office 365 
Import-Module DirSync
Start-OnlineCoexistenceSync
#Export Office 365 Groups to CSV
Get-AddressList |  Where-Object {$_.Name -ne "All Contacts" -and $_.Name -ne "All Distribution Lists" -and $_.Name -ne "All Rooms" -and $_.Name -ne "All Users" -and $_.Name -ne "All Groups" -and $_.Name -ne "Offline Global Address List" -and $_.Name -notlike "*.res*"} | select Name | export-csv  -Encoding UTF8 -NoTypeInformation -Delimiter ";"  $CSVpatch
Remove-PSSession $Session
Remove-Item $ADgroupTEMP
Import-Csv $CSVpatch -Delimiter ";"| % {
$ADgroup = $_.Name; # Set the Name
$Group = Get-ADGroup -LDAPFilter "(sAMAccountName=$ADgroup)"
If ($Group -eq $Null) 
{
"Group does not exist in AD"
$ADgroup &amp;gt;&amp;gt; $ADgroupTEMP
}
Else 
{
"Group found in AD"
}
}
$ADgroup=Get-Content C:\PowerShell_Scripts\TEMP_123.txt
foreach($Group in $ADgroup){
#Delete OLD Sessions
Remove-PSSession $Session
#Connect to Office 365
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Import-Module MSOnline
Connect-MSOLService -Credential $cred
#Disable Address book policy from mailboxes (if enabled)
Get-Mailbox -resultsize unlimited | where {$_.AddressBookPolicy -eq "$Group.Abp"} | Set-Mailbox -AddressBookPolicy $NULL
#Remove Address Book Policy
Remove-AddressBookPolicy "$Group.Abp" -confirm:$false
#Remove Offline Address Book
Remove-OfflineAddressBook "$Group.Oab" -confirm:$false
#Remove GAL
Remove-GlobalAddressList "$Group.gal" -confirm:$false
#Remove address lists
Remove-AddressList -Identity "$Group.res" -Recursive -confirm:$false
Remove-AddressList -Identity "$Group" -Recursive -confirm:$false
}
remove-item $CSVpatch
Remove-Item $ADgroupTEMP
```
#Delete OLD Sessions&nbsp;Remove-PSSession $Session&nbsp;$AdminUsername = "LOGIN@test.com"$AdminPassword = "PASS"&nbsp;#Set Vars&nbsp;$CSVpatch = "C:\PowerShell_Scripts\TEMP_CSV.csv"$ADgroupTEMP = "C:\PowerShell_Scripts\TEMP_123.txt"&nbsp;#Connect to Office 365$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword&nbsp;$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection&nbsp;Import-PSSession $Session&nbsp;Import-Module MSOnline&nbsp;Connect-MSOLService -Credential $cred&nbsp;#Sync Local AD with Office 365 &nbsp;Import-Module DirSync&nbsp;Start-OnlineCoexistenceSync&nbsp;#Export Office 365 Groups to CSV&nbsp;Get-AddressList |&nbsp;&nbsp;Where-Object {$_.Name -ne "All Contacts" -and $_.Name -ne "All Distribution Lists" -and $_.Name -ne "All Rooms" -and $_.Name -ne "All Users" -and $_.Name -ne "All Groups" -and $_.Name -ne "Offline Global Address List" -and $_.Name -notlike "*.res*"} | select Name | export-csv&nbsp;&nbsp;-Encoding UTF8 -NoTypeInformation -Delimiter ";"&nbsp;&nbsp;$CSVpatch&nbsp;Remove-PSSession $SessionRemove-Item $ADgroupTEMP&nbsp;Import-Csv $CSVpatch -Delimiter ";"| % {&nbsp;$ADgroup = $_.Name; # Set the Name&nbsp;$Group = Get-ADGroup -LDAPFilter "(sAMAccountName=$ADgroup)"&nbsp;If ($Group -eq $Null) &nbsp;{"Group does not exist in AD"$ADgroup &amp;gt;&amp;gt; $ADgroupTEMP}&nbsp;Else &nbsp;{"Group found in AD"}}&nbsp;$ADgroup=Get-Content C:\PowerShell_Scripts\TEMP_123.txt&nbsp;foreach($Group in $ADgroup){&nbsp;#Delete OLD Sessions&nbsp;Remove-PSSession $Session&nbsp;#Connect to Office 365$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword&nbsp;$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection&nbsp;Import-PSSession $Session&nbsp;Import-Module MSOnline&nbsp;Connect-MSOLService -Credential $cred&nbsp;#Disable Address book policy from mailboxes (if enabled)&nbsp;Get-Mailbox -resultsize unlimited | where {$_.AddressBookPolicy -eq "$Group.Abp"} | Set-Mailbox -AddressBookPolicy $NULL&nbsp;#Remove Address Book Policy&nbsp;Remove-AddressBookPolicy "$Group.Abp" -confirm:$false&nbsp;#Remove Offline Address Book&nbsp;Remove-OfflineAddressBook "$Group.Oab" -confirm:$false&nbsp;#Remove GAL&nbsp;Remove-GlobalAddressList "$Group.gal" -confirm:$false&nbsp;#Remove address lists&nbsp;Remove-AddressList -Identity "$Group.res" -Recursive -confirm:$false&nbsp;Remove-AddressList -Identity "$Group" -Recursive -confirm:$false&nbsp;}&nbsp;remove-item $CSVpatchRemove-Item $ADgroupTEMP
В следующей статье я расскажу как через скрипт powershell актуализировать адресные книги Office 365.
Не забывайте в скриптах указывать свои пути и переменные, иначе ничего не заработает!
&nbsp;
&nbsp;
Related posts:Сброс пароля администратора Active DirectoryВыполняем команды внутри гостевых ОС через PowerCLIУдаляем неисправный контроллер домена при помощи утилиты NTDSUTIL
 Active Directory, Exchange, Office 365, PowerShell 
 Метки: Active Directory, Exchange online, Office 365, Powershell  
                        
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
