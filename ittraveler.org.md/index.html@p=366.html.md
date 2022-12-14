# Автоматический перенос старых перемещаемых профилей в архив с помощью Powershell.                	  
***Дата: 05.05.2015 Автор Admin***

Думаю многие системные администраторы использующие перемещаемые профили или folder redirection, сталкивались с проблемой старых профилей уволенных сотрудников.
Ведь не всегда можно проследить перенесли профиль в архив или нет.
Для решения данной проблемы предлагаю использовать следующий скрипт:
В переменных укажите путь к перемещаемым профилям.
В скрипте ниже пути к папкам folder redirection содержат username пользователя, по нему ведется поиск старого профиля в Active Directory.
Если профиля нет в Active Directory, старый профиль с папками folder redirection перемещается в архив.
Если вас интересует перенос старых перемещаемых профилей измените переменные $move1 = $($User.Name) на $move1 = &#171;$User.DOMAIN.V2&#187; , где DOMAIN.V2 префикс перемещаемого профиля Вашего домена.
PowerShell
```
# Select source folders
$Path1 = "F:\fileshare\UsersFolders\ProfilesIva"
$Path2 = "F:\fileshare\UsersFolders\Profiles"
$Path3 = "F:\fileshare\UsersFolders\ProfilesYar"
$DestinationFolder = "\\archivesrv\OLDusers\OLD"
$ScriptFolder = "D:\Powershell_Scripts\MoveFolders-No-Users"
# Generate short data prefix
$shortdate = get-date -format "dd.MM.yyyy"
## Start checking folders from first region
# Find folder names in $Path1
$userProfile = Get-ChildItem -Path $Path1
$unknownList = @()
# Try to find Active Directory usernames from user folders
foreach($user in $userProfile){
#Try to find user in Active Directory
$ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}
#Test to see if the user exists
If($ADUser)
{
#User Exists
#Write-host "$($User.Name) Exists"
}
Else
{
# Create new variable with username (Only Deleted users from Active Directory)
$move1 = $($User.Name)
# Move find folders to $DestinationFolder
Copy-Item $Path1\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt
Remove-Item $Path1\$move1 -Recurse -Force
}
}
#Further we will repeat previos commands with next region ($Path2 and $Path3)
##Next Region ($Path2)
$userProfile = Get-ChildItem -Path $Path2
$unknownList = @()
foreach($user in $userProfile){
$ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}
If($ADUser)
{
#User Exists
}
Else
{
$move1 = $($User.Name)
Copy-Item $Path2\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt
Remove-Item $Path2\$move1 -Recurse -Force
}
}
##Next Region ($Path3)
$userProfile = Get-ChildItem -Path $Path3
$unknownList = @()
foreach($user in $userProfile){
$ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}
If($ADUser)
{
#User Exists
}
Else
{
$move1 = $($User.Name)
Copy-Item $Path3\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt
Remove-Item $Path3\$move1 -Recurse -Force
}
}
# Generate Email Body
echo "Отчет по профилям удаленных сотрудников:" &gt; $ScriptFolder\Body1.txt
echo " " &gt;&gt; $ScriptFolder\Body1.txt
echo " " &gt;&gt; $ScriptFolder\Body1.txt
echo " " &gt;&gt; $ScriptFolder\Body1.txt
$body = Get-Content $ScriptFolder\Body1.txt  
$body2 = Get-Content $ScriptFolder\Reports.txt | Out-String
# Send Email message
Send-MailMessage -From admin@domain.local -To admins@domain.local -Subject "Отчет по старым перемещаемым профилям" -attachment $ScriptFolder\Reports.txt -Encoding ([System.Text.Encoding]::UTF8) -Body $body$body2  -SmtpServer mailserver.domain.local
# Remove old Items
Remove-Item $ScriptFolder\Reports.txt
Remove-Item $ScriptFolder\Body1.txt
```
# Select source folders$Path1 = "F:\fileshare\UsersFolders\ProfilesIva"$Path2 = "F:\fileshare\UsersFolders\Profiles"$Path3 = "F:\fileshare\UsersFolders\ProfilesYar"$DestinationFolder = "\\archivesrv\OLDusers\OLD"$ScriptFolder = "D:\Powershell_Scripts\MoveFolders-No-Users"&nbsp;# Generate short data prefix$shortdate = get-date -format "dd.MM.yyyy"&nbsp;## Start checking folders from first region&nbsp;# Find folder names in $Path1$userProfile = Get-ChildItem -Path $Path1$unknownList = @()# Try to find Active Directory usernames from user foldersforeach($user in $userProfile){&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Try to find user in Active Directory&nbsp;&nbsp;&nbsp;&nbsp;$ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Test to see if the user exists&nbsp;&nbsp;&nbsp;&nbsp;If($ADUser)&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#User Exists&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Write-host "$($User.Name) Exists"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;&nbsp;&nbsp;&nbsp;Else&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Create new variable with username (Only Deleted users from Active Directory)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$move1 = $($User.Name)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Move find folders to $DestinationFolder&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Copy-Item $Path1\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Remove-Item $Path1\$move1 -Recurse -Force&nbsp;&nbsp;&nbsp;&nbsp;}}&nbsp;#Further we will repeat previos commands with next region ($Path2 and $Path3)&nbsp;##Next Region ($Path2)&nbsp;$userProfile = Get-ChildItem -Path $Path2$unknownList = @()foreach($user in $userProfile){&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If($ADUser)&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#User Exists&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;&nbsp;&nbsp;&nbsp;Else&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$move1 = $($User.Name)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Copy-Item $Path2\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Remove-Item $Path2\$move1 -Recurse -Force&nbsp;&nbsp;&nbsp;&nbsp;}}&nbsp;##Next Region ($Path3)&nbsp;$userProfile = Get-ChildItem -Path $Path3$unknownList = @()foreach($user in $userProfile){&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If($ADUser)&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#User Exists&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;&nbsp;&nbsp;&nbsp;Else&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$move1 = $($User.Name)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Copy-Item $Path3\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Remove-Item $Path3\$move1 -Recurse -Force&nbsp;&nbsp;&nbsp;&nbsp;}}&nbsp;# Generate Email Bodyecho "Отчет по профилям удаленных сотрудников:" &gt; $ScriptFolder\Body1.txtecho " " &gt;&gt; $ScriptFolder\Body1.txtecho " " &gt;&gt; $ScriptFolder\Body1.txtecho " " &gt;&gt; $ScriptFolder\Body1.txt&nbsp;$body = Get-Content $ScriptFolder\Body1.txt&nbsp;&nbsp;&nbsp;$body2 = Get-Content $ScriptFolder\Reports.txt | Out-String&nbsp;# Send Email message&nbsp;Send-MailMessage -From admin@domain.local -To admins@domain.local -Subject "Отчет по старым перемещаемым профилям" -attachment $ScriptFolder\Reports.txt -Encoding ([System.Text.Encoding]::UTF8) -Body $body$body2&nbsp;&nbsp;-SmtpServer mailserver.domain.local# Remove old ItemsRemove-Item $ScriptFolder\Reports.txtRemove-Item $ScriptFolder\Body1.txt
&nbsp;
После выполнения данный скрипт отправит отчет о перенесенных профилях.
Для автоматизации добавьте данный скрипт в планировщик задач.
Related posts:Изменение UPN суффикса в Active Directory через PowershellАудит изменений групповых политик через PowerShellУправление репликацией Active Directory
 Active Directory, PowerShell, Windows Server 
 Метки: Active Directory, Powershell, Перемещаемые профили  
                        
Комментарии
        
Maksim
  
22.01.2019 в 18:04 - 
Ответить                                
Отличный скрипт, который обленчил работу и помог кое что сделать, однако возник вопрос.
Если нужно добавить исключение, ну вот 1 профиль который нельзя удалять, как это описать в данном скрипте ?
        
Admin
  
23.01.2019 в 11:04 - 
Ответить                                
Добрый день!
Рад что мой скрипт Вам пригодился.
По поводу вашего вопроса.
Замените строку
If($ADUser)
на
If($ADUser -or $ADUser -eq "UserName")
где UserName &#8212; название вашего профиля. Обратите внимание что регистр важен, имя должно в точности совпадать.
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
