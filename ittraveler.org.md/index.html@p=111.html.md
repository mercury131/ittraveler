# Создание пользователей Active Directory через CSV файл                	  
***Дата: 30.12.2014 Автор Admin***

Иногда бывает нужно создать в Active Directory кучу пользователей.
Создавать все это добро вручную долго и муторно, а если для каждой группы пользователей нужна своя OU? Или названия компаний для каждого свое?
Ниже я покажу скрипт, который создает пользователей из CSV файла.
Алгоритм следующий:
1) Создаем OU с названием компании пользователя
2) Создаем группы для пользователя и включаем его в них (мы создадим глобальную группу и универсальную)
3) Переводим названия созданных групп в AD в транслит
4) Добавляем пользователей в другие (общие) группы AD
Шапка CSV файла будет такой:
```
Lastname;Firstname;Login;Password;Position;Company;Number
```
Lastname;Firstname;Login;Password;Position;Company;Number
Сам скрипт:
```
#Задаем переменные
$CSVpatch = "C:\PowerShell_Scripts\365.csv"
$CSVcopy = "C:\PowerShell_Scripts\36502.csv"
$CSVwithADgroups = "C:\PowerShell_Scripts\365ADG.csv"
$TMPcompany = "C:\PowerShell_Scripts\temp.txt"
$TMPListcompany = "C:\PowerShell_Scripts\TMPListcompany.txt"
$TMPListcompanyreplased = "C:\PowerShell_Scripts\TMPListcompanyreplased.txt"
$TMPcompanyTranslit = "C:\PowerShell_Scripts\translit.txt"
$TMPcompanyTranslitCSV = "C:\PowerShell_Scripts\translit.csv"
$TMPfile = "C:\PowerShell_Scripts\tmpfile.txt"
$AllinoneCSV = "C:\PowerShell_Scripts\allinonetranslit.csv"
# Создаем новый OU по названием компаний
Import-Csv $CSVpatch -Delimiter ";" | % {
$Company = $_.Company; # Set the user
NEW-ADOrganizationalUnit "$Company" –path "OU=Users,OU=Office365_Sync,DC=test,DC=local"
}
# Удаляем временные файлы
remove-item $CSVcopy
remove-item $CSVwithADgroups
remove-item $TMPcompany
remove-item $TMPListcompany
remove-item $TMPListcompanyreplased
remove-item $TMPcompanyTranslit
remove-item $TMPcompanyTranslitCSV
remove-item $AllinoneCSV
# Обрабатываем и преобразуем названия компаний (копируем столбец с компаниями и удаляем пробелы)
Import-Csv $CSVpatch -Delimiter ";" | % {
$Company = $_.Company; # Set the user
$Company &amp;amp;gt;&amp;amp;gt; $TMPcompany
}
$hash = @{} # define a new empty hash table
gc $TMPcompany | % {
if ($hash.$_ -eq $null) {
$_
};
$hash.$_ = 1
} &amp;amp;gt; $TMPfile #$TMPListcompany
(Get-Content $TMPcompany) -replace " ","-" | Set-Content $TMPListcompanyreplased
# Преобразуем в транслит название компаний
remove-item $TMPcompanyTranslit
function global:Translit
{
param([string]$inString)
$Translit = @{
[char]'а' = "a"
[char]'А' = "A"
[char]'б' = "b"
[char]'Б' = "B"
[char]'в' = "v"
[char]'В' = "V"
[char]'г' = "g"
[char]'Г' = "G"
[char]'д' = "d"
[char]'Д' = "D"
[char]'е' = "e"
[char]'Е' = "E"
[char]'ё' = "yo"
[char]'Ё' = "Yo"
[char]'ж' = "zh"
[char]'Ж' = "Zh"
[char]'з' = "z"
[char]'З' = "Z"
[char]'и' = "i"
[char]'И' = "I"
[char]'й' = "j"
[char]'Й' = "J"
[char]'к' = "k"
[char]'К' = "K"
[char]'л' = "l"
[char]'Л' = "L"
[char]'м' = "m"
[char]'М' = "M"
[char]'н' = "n"
[char]'Н' = "N"
[char]'о' = "o"
[char]'О' = "O"
[char]'п' = "p"
[char]'П' = "P"
[char]'р' = "r"
[char]'Р' = "R"
[char]'с' = "s"
[char]'С' = "S"
[char]'т' = "t"
[char]'Т' = "T"
[char]'у' = "u"
[char]'У' = "U"
[char]'ф' = "f"
[char]'Ф' = "F"
[char]'х' = "h"
[char]'Х' = "H"
[char]'ц' = "c"
[char]'Ц' = "C"
[char]'ч' = "ch"
[char]'Ч' = "Ch"
[char]'ш' = "sh"
[char]'Ш' = "Sh"
[char]'щ' = "sch"
[char]'Щ' = "Sch"
[char]'ъ' = ""
[char]'Ъ' = ""
[char]'ы' = "y"
[char]'Ы' = "Y"
[char]'ь' = ""
[char]'Ь' = ""
[char]'э' = "e"
[char]'Э' = "E"
[char]'ю' = "yu"
[char]'Ю' = "Yu"
[char]'я' = "ya"
[char]'Я' = "Ya"
}
$outCHR=""
foreach ($CHR in $inCHR = $inString.ToCharArray())
{
if ($Translit[$CHR] -cne $Null )
{$outCHR += $Translit[$CHR]}
else
{$outCHR += $CHR}
}
Write-Output $outCHR
}
Get-Content $TMPListcompanyreplased | ForEach-Object {Translit($_)} &amp;amp;gt; $TMPcompanyTranslit
##Создаем группы в AD
Copy-Item $CSVpatch $CSVcopy
function Insert-Content {
param ( [String]$Path )
process {
$( ,$_; Get-Content $Path -ea SilentlyContinue) | Out-File $Path
}
}
'ADgroup' | Insert-Content $TMPcompanyTranslit
import-csv $TMPcompanyTranslit -delimiter ';' | export-csv -NoTypeInformation -UseCulture $TMPcompanyTranslitCSV
(Get-Content $TMPcompanyTranslitCSV) -replace '"' | Set-Content $TMPcompanyTranslitCSV
$csv1 = @(gc $CSVcopy)
$csv2 = @(gc $TMPcompanyTranslitCSV)
$csv3 = @()
for ($i=0; $i -lt $csv1.Count; $i++) {
$csv3 += $csv1[$i] + ';' + $csv2[$i]
}
$csv3 | Out-File $AllinoneCSV
Import-Csv $AllinoneCSV -Delimiter ";"| % {
$Company = $_.Company; # Set the user
$OU = "OU=$Company,OU=test,OU=Office365_Sync,DC=test,DC=local"
$ADgroup = $_.ADgroup; # Set the user
#echo $OU
#echo $ADgroup
}
clear
Import-Csv $AllinoneCSV -Delimiter ";"| % {
$Firstname = $_.Firstname; # Set the user
$Lastname = $_.Lastname; # Set the user
$Login = $_.Login; # Set the user
$Password = $_.Password; # Set the user
$Position = $_.Position; # Set the user
$Company = $_.Company; # Set the user
$Number = $_.Number; # Set the user
$OU = "OU=$Company,OU=test,OU=Office365_Sync,DC=test,DC=local"
$ADgroup = $_.ADgroup; # Set the user
echo $ADgroup
$Displayname = "$Lastname $Firstname"
New-ADUser -SamAccountName "$Login" -name "$Displayname" -GivenName "$Firstname" -Surname "$Lastname" -PasswordNeverExpires $true -UserPrincipalName "$Login@domain.ru" -DisplayName "$Displayname" -EmailAddress "$Login@domain.ru" -Title "$Position" -enable $True -AccountPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force) -Path "$OU" -company "$Company" -OtherAttributes @{'preferredLanguage'="RU"}
New-ADGroup -SamAccountName "GD-$ADgroup" -name "GD-$ADgroup" -GroupScope 1 -GroupCategory security -description "$Company" -OtherAttributes @{'info'="domain.ru"} -Path "$OU"
Set-ADGroup "GD-$ADgroup" -Replace @{mail="GD-$ADgroup@domain.ru"}
New-ADGroup -SamAccountName "$ADgroup" -name "$ADgroup" -GroupScope 2 -GroupCategory distribution -description "$ADgroup"-OtherAttributes @{'mail'="$ADgroup@domain.ru"} -Path "$OU"
}
Start-Sleep -Seconds 20
clear
Import-Csv $AllinoneCSV -Delimiter ";"| % {
$Company = $_.Company; # Set the user
$OU = "OU=$Company,OU=test,OU=Office365_Sync,DC=test,DC=local"
$OU
$users = Get-ADUser -Filter * -SearchBase "$OU"
#$users
$groups1 = Get-ADGroup -Filter * -SearchBase "$OU" | Where-Object {$_.SamAccountName -notlike "GD-*"}
$groups2 = Get-ADGroup -Filter * -SearchBase "$OU" | Where-Object {$_.SamAccountName -like "GD-*"}
Add-ADGroupMember "$groups1" -Member $users
Add-ADGroupMember "$groups2" -Member $users
Add-ADGroupMember "GD-TS-Users-Termsrv05-Region" -Member $users
Add-ADGroupMember "GD-All-test-Users" -Member $users
}
remove-item $CSVcopy
remove-item $CSVwithADgroups
remove-item $TMPcompany
remove-item $TMPListcompany
remove-item $TMPListcompanyreplased
remove-item $TMPcompanyTranslit
remove-item $TMPcompanyTranslitCSV
remove-item $AllinoneCSV
remove-item $TMPfile
```
#Задаем переменные&nbsp;$CSVpatch = "C:\PowerShell_Scripts\365.csv"&nbsp;$CSVcopy = "C:\PowerShell_Scripts\36502.csv"&nbsp;$CSVwithADgroups = "C:\PowerShell_Scripts\365ADG.csv"&nbsp;$TMPcompany = "C:\PowerShell_Scripts\temp.txt"&nbsp;$TMPListcompany = "C:\PowerShell_Scripts\TMPListcompany.txt"&nbsp;$TMPListcompanyreplased = "C:\PowerShell_Scripts\TMPListcompanyreplased.txt"&nbsp;$TMPcompanyTranslit = "C:\PowerShell_Scripts\translit.txt"&nbsp;$TMPcompanyTranslitCSV = "C:\PowerShell_Scripts\translit.csv"&nbsp;$TMPfile = "C:\PowerShell_Scripts\tmpfile.txt"&nbsp;$AllinoneCSV = "C:\PowerShell_Scripts\allinonetranslit.csv"&nbsp;# Создаем новый OU по названием компаний&nbsp;Import-Csv $CSVpatch -Delimiter ";" | % {&nbsp;$Company = $_.Company; # Set the user&nbsp;NEW-ADOrganizationalUnit "$Company" –path "OU=Users,OU=Office365_Sync,DC=test,DC=local"}&nbsp;# Удаляем временные файлы&nbsp;remove-item $CSVcopy&nbsp;remove-item $CSVwithADgroups&nbsp;remove-item $TMPcompany&nbsp;remove-item $TMPListcompany&nbsp;remove-item $TMPListcompanyreplased&nbsp;remove-item $TMPcompanyTranslit&nbsp;remove-item $TMPcompanyTranslitCSV&nbsp;remove-item $AllinoneCSV&nbsp;# Обрабатываем и преобразуем названия компаний (копируем столбец с компаниями и удаляем пробелы)&nbsp;Import-Csv $CSVpatch -Delimiter ";" | % {&nbsp;$Company = $_.Company; # Set the user&nbsp;$Company &amp;amp;gt;&amp;amp;gt; $TMPcompany&nbsp;}&nbsp;$hash = @{} # define a new empty hash table&nbsp;gc $TMPcompany | % {&nbsp;if ($hash.$_ -eq $null) {&nbsp;$_};&nbsp;$hash.$_ = 1&nbsp;} &amp;amp;gt; $TMPfile #$TMPListcompany&nbsp;(Get-Content $TMPcompany) -replace " ","-" | Set-Content $TMPListcompanyreplased&nbsp;# Преобразуем в транслит название компаний&nbsp;remove-item $TMPcompanyTranslit&nbsp;function global:Translit{param([string]$inString)$Translit = @{[char]'а' = "a"[char]'А' = "A"[char]'б' = "b"[char]'Б' = "B"[char]'в' = "v"[char]'В' = "V"[char]'г' = "g"[char]'Г' = "G"[char]'д' = "d"[char]'Д' = "D"[char]'е' = "e"[char]'Е' = "E"[char]'ё' = "yo"[char]'Ё' = "Yo"[char]'ж' = "zh"[char]'Ж' = "Zh"[char]'з' = "z"[char]'З' = "Z"[char]'и' = "i"[char]'И' = "I"[char]'й' = "j"[char]'Й' = "J"[char]'к' = "k"[char]'К' = "K"[char]'л' = "l"[char]'Л' = "L"[char]'м' = "m"[char]'М' = "M"[char]'н' = "n"[char]'Н' = "N"[char]'о' = "o"[char]'О' = "O"[char]'п' = "p"[char]'П' = "P"[char]'р' = "r"[char]'Р' = "R"[char]'с' = "s"[char]'С' = "S"[char]'т' = "t"[char]'Т' = "T"[char]'у' = "u"[char]'У' = "U"[char]'ф' = "f"[char]'Ф' = "F"[char]'х' = "h"[char]'Х' = "H"[char]'ц' = "c"[char]'Ц' = "C"[char]'ч' = "ch"[char]'Ч' = "Ch"[char]'ш' = "sh"[char]'Ш' = "Sh"[char]'щ' = "sch"[char]'Щ' = "Sch"[char]'ъ' = ""[char]'Ъ' = ""[char]'ы' = "y"[char]'Ы' = "Y"[char]'ь' = ""[char]'Ь' = ""[char]'э' = "e"[char]'Э' = "E"[char]'ю' = "yu"[char]'Ю' = "Yu"[char]'я' = "ya"[char]'Я' = "Ya"}$outCHR=""foreach ($CHR in $inCHR = $inString.ToCharArray()){if ($Translit[$CHR] -cne $Null ){$outCHR += $Translit[$CHR]}else{$outCHR += $CHR}}Write-Output $outCHR}&nbsp;Get-Content $TMPListcompanyreplased | ForEach-Object {Translit($_)} &amp;amp;gt; $TMPcompanyTranslit&nbsp;##Создаем группы в AD&nbsp;Copy-Item $CSVpatch $CSVcopy&nbsp;function Insert-Content {param ( [String]$Path )process {$( ,$_; Get-Content $Path -ea SilentlyContinue) | Out-File $Path}}&nbsp;'ADgroup' | Insert-Content $TMPcompanyTranslit&nbsp;import-csv $TMPcompanyTranslit -delimiter ';' | export-csv -NoTypeInformation -UseCulture $TMPcompanyTranslitCSV&nbsp;(Get-Content $TMPcompanyTranslitCSV) -replace '"' | Set-Content $TMPcompanyTranslitCSV&nbsp;$csv1 = @(gc $CSVcopy)$csv2 = @(gc $TMPcompanyTranslitCSV)$csv3 = @()for ($i=0; $i -lt $csv1.Count; $i++) {$csv3 += $csv1[$i] + ';' + $csv2[$i]}&nbsp;$csv3 | Out-File $AllinoneCSV&nbsp;Import-Csv $AllinoneCSV -Delimiter ";"| % {&nbsp;$Company = $_.Company; # Set the user$OU = "OU=$Company,OU=test,OU=Office365_Sync,DC=test,DC=local"&nbsp;$ADgroup = $_.ADgroup; # Set the user&nbsp;#echo $OU&nbsp;#echo $ADgroup}&nbsp;clear&nbsp;Import-Csv $AllinoneCSV -Delimiter ";"| % {&nbsp;$Firstname = $_.Firstname; # Set the user$Lastname = $_.Lastname; # Set the user$Login = $_.Login; # Set the user$Password = $_.Password; # Set the user$Position = $_.Position; # Set the user$Company = $_.Company; # Set the user$Number = $_.Number; # Set the user$OU = "OU=$Company,OU=test,OU=Office365_Sync,DC=test,DC=local"$ADgroup = $_.ADgroup; # Set the user&nbsp;echo $ADgroup$Displayname = "$Lastname $Firstname"&nbsp;New-ADUser -SamAccountName "$Login" -name "$Displayname" -GivenName "$Firstname" -Surname "$Lastname" -PasswordNeverExpires $true -UserPrincipalName "$Login@domain.ru" -DisplayName "$Displayname" -EmailAddress "$Login@domain.ru" -Title "$Position" -enable $True -AccountPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force) -Path "$OU" -company "$Company" -OtherAttributes @{'preferredLanguage'="RU"}&nbsp;New-ADGroup -SamAccountName "GD-$ADgroup" -name "GD-$ADgroup" -GroupScope 1 -GroupCategory security -description "$Company" -OtherAttributes @{'info'="domain.ru"} -Path "$OU"&nbsp;Set-ADGroup "GD-$ADgroup" -Replace @{mail="GD-$ADgroup@domain.ru"}&nbsp;New-ADGroup -SamAccountName "$ADgroup" -name "$ADgroup" -GroupScope 2 -GroupCategory distribution -description "$ADgroup"-OtherAttributes @{'mail'="$ADgroup@domain.ru"} -Path "$OU"&nbsp;}&nbsp;Start-Sleep -Seconds 20&nbsp;clear&nbsp;Import-Csv $AllinoneCSV -Delimiter ";"| % {$Company = $_.Company; # Set the user$OU = "OU=$Company,OU=test,OU=Office365_Sync,DC=test,DC=local"&nbsp;$OU&nbsp;$users = Get-ADUser -Filter * -SearchBase "$OU"#$users&nbsp;$groups1 = Get-ADGroup -Filter * -SearchBase "$OU" | Where-Object {$_.SamAccountName -notlike "GD-*"}$groups2 = Get-ADGroup -Filter * -SearchBase "$OU" | Where-Object {$_.SamAccountName -like "GD-*"}&nbsp;Add-ADGroupMember "$groups1" -Member $usersAdd-ADGroupMember "$groups2" -Member $users&nbsp;Add-ADGroupMember "GD-TS-Users-Termsrv05-Region" -Member $users&nbsp;Add-ADGroupMember "GD-All-test-Users" -Member $users&nbsp;}&nbsp;remove-item $CSVcopy&nbsp;remove-item $CSVwithADgroups&nbsp;remove-item $TMPcompany&nbsp;remove-item $TMPListcompany&nbsp;remove-item $TMPListcompanyreplased&nbsp;remove-item $TMPcompanyTranslit&nbsp;remove-item $TMPcompanyTranslitCSV&nbsp;remove-item $AllinoneCSV&nbsp;remove-item $TMPfile
Если вам нужно просто создать много учетных записей в Active Directory, то вам подойдет следующий скрипт:
PowerShell
```
#Задаем переменные
$CSVpatch = "C:\PowerShell_Scripts\365.csv"
Import-Csv $CSVpatch -Delimiter ";" | % {
$Firstname = $_.Firstname; # Set the user
$Lastname = $_.Lastname; # Set the user
$Login = $_.Login; # Set the user
$Password = $_.Password; # Set the user
$Position = $_.Position; # Set the user
$Company = $_.Company; # Set the user
$Number = $_.Number; # Set the user
$Displayname = "$Lastname $Firstname"
New-ADUser -SamAccountName "$Login" -name "$Displayname" -GivenName "$Firstname" -Surname "$Lastname" -PasswordNeverExpires $true -UserPrincipalName "$Login@domain.local" -DisplayName "$Displayname" -EmailAddress "$Login@domain.ru" -Title "$Position" -enable $True -AccountPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force) -company "$Company"
}
```
#Задаем переменные&nbsp;$CSVpatch = "C:\PowerShell_Scripts\365.csv"&nbsp;&nbsp;Import-Csv $CSVpatch -Delimiter ";" | % {&nbsp;&nbsp;$Firstname = $_.Firstname; # Set the user$Lastname = $_.Lastname; # Set the user$Login = $_.Login; # Set the user$Password = $_.Password; # Set the user$Position = $_.Position; # Set the user$Company = $_.Company; # Set the user$Number = $_.Number; # Set the user&nbsp;$Displayname = "$Lastname $Firstname"&nbsp;New-ADUser -SamAccountName "$Login" -name "$Displayname" -GivenName "$Firstname" -Surname "$Lastname" -PasswordNeverExpires $true -UserPrincipalName "$Login@domain.local" -DisplayName "$Displayname" -EmailAddress "$Login@domain.ru" -Title "$Position" -enable $True -AccountPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force) -company "$Company"&nbsp;}
&nbsp;
Related posts:Принудительная синхронизация Office 365 и локальной Active DirectoryУстановка RSAT на Windows 10 1809Установка и настройка Ansible
 Active Directory, PowerShell, Windows, Windows Server 
 Метки: Active Directory, Powershell  
                        
Комментарии
        
Алексей
  
28.09.2016 в 13:50 - 
Ответить                                
Советую воспользоваться утилитой &#171;Active Directory Bulk Operations&#187;. Программа позволяет пакетно создавать и редактировать учетные записи пользователей, а так же копировать учетные записи с сохранением членства в группах и полной иерархией организационных единиц в другой домен! Скачать можно тут: http://www.sysadminsoft.ru/active-directory-bulk-operations
        
Admin
  
24.04.2017 в 12:08 - 
Ответить                                
Спасибо за информацию, не знал о такой утилите, так все через powershell и оснастки обычно делаю)
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
