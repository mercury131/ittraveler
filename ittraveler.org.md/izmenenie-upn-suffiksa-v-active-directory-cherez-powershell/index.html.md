# Изменение UPN суффикса в Active Directory через Powershell                	  
***Дата: 12.03.2015 Автор Admin***

В данной статье я расскажу как изменить UPN суффикс пользователей в домене Active Directory через Powershell.
Представьте ситуацию, у вас в домене более 1000 человек, и вам нужно поменять UPN суффикс каждому из них. Для решения этой задачи нам подойдет следующий скрипт:
```
# Импортируем модуль Active Directory
Import-Module ActiveDirectory
# Фильтруем пользователей по UPN и OU и меняем всем пользователям суффикс
Get-ADUser -Filter {UserPrincipalName -like "*@domain.local"} -SearchBase "OU=TEST,OU=TestOU,OU=domain,DC=domain,DC=local" |
ForEach-Object {
$UPN = $_.UserPrincipalName.Replace("domain.local","domain.ru")
Set-ADUser $_ -UserPrincipalName $UPN
}
```
# Импортируем модуль Active DirectoryImport-Module ActiveDirectory&nbsp;# Фильтруем пользователей по UPN и OU и меняем всем пользователям суффиксGet-ADUser -Filter {UserPrincipalName -like "*@domain.local"} -SearchBase "OU=TEST,OU=TestOU,OU=domain,DC=domain,DC=local" |ForEach-Object {&nbsp;&nbsp;&nbsp;&nbsp;$UPN = $_.UserPrincipalName.Replace("domain.local","domain.ru")&nbsp;&nbsp;&nbsp;&nbsp;Set-ADUser $_ -UserPrincipalName $UPN}
&nbsp;
