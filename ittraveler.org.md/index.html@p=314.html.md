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
