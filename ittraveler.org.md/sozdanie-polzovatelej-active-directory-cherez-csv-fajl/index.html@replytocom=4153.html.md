#                 	Создание пользователей Active Directory через CSV файл                	  
***            ***

			
            
		

    




	
    	  Дата: 30.12.2014 Автор Admin  
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
			
				
					
				
					1
				
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
			
				
					
				
					123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100101102103104105106107108109110111112113114115116117118119120121122123124125126127128129130131132133134135136137138139140141142143144145146147148149150151152153154155156157158159160161162163164165166167168169170171172173174175176177178179180181182183184185186187188189190191192193194195196197198199200201202203204205206207208209210211212213214215216217218219220221222223224225226227228229230231232233234235236237238239240241242243244245246247248249250251252253254255256257258259260261262263264265266267268269
				
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
			
				
					
				
					123456789101112131415161718192021
				
						#Задаем переменные&nbsp;$CSVpatch = "C:\PowerShell_Scripts\365.csv"&nbsp;&nbsp;Import-Csv $CSVpatch -Delimiter ";" | % {&nbsp;&nbsp;$Firstname = $_.Firstname; # Set the user$Lastname = $_.Lastname; # Set the user$Login = $_.Login; # Set the user$Password = $_.Password; # Set the user$Position = $_.Position; # Set the user$Company = $_.Company; # Set the user$Number = $_.Number; # Set the user&nbsp;$Displayname = "$Lastname $Firstname"&nbsp;New-ADUser -SamAccountName "$Login" -name "$Displayname" -GivenName "$Firstname" -Surname "$Lastname" -PasswordNeverExpires $true -UserPrincipalName "$Login@domain.local" -DisplayName "$Displayname" -EmailAddress "$Login@domain.ru" -Title "$Position" -enable $True -AccountPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force) -company "$Company"&nbsp;}
					
				
			
		

&nbsp;
