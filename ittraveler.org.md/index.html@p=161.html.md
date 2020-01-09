# Подключение к Office 365 через Powershell и зашифрованный пароль                	  
***Дата: 30.12.2014 Автор Admin***

В данной статье я покажу как с помощью Powershell можно подключиться к Office 365, не храня пароль в открытом виде в скрипте.
Первым делом шифруем наш пароль, для этого вводим команду:
```
read-host -prompt "Enter password to be encrypted in mypassword.txt " -assecurestring | convertfrom-securestring | out-file C:\Путь к файлу.txt
```
read-host -prompt "Enter password to be encrypted in mypassword.txt " -assecurestring | convertfrom-securestring | out-file C:\Путь к файлу.txt
Теперь стыкуем зашифрованный пароль со скриптом подключения к Office 365
```
$pass = cat C:\Путь к файлу.txt | convertto-securestring
$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist "LOGIN",$pass
Import-Module MSOnline
$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Authentication Basic -AllowRedirection -Credential $mycred
Import-PSSession $O365Session
Connect-MsolService -Credential $mycred
```
$pass = cat C:\Путь к файлу.txt | convertto-securestring&nbsp;$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist "LOGIN",$pass&nbsp;Import-Module MSOnline&nbsp;$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Authentication Basic -AllowRedirection -Credential $mycred&nbsp;Import-PSSession $O365Session&nbsp;Connect-MsolService -Credential $mycred
Теперь вы можете подключиться к Office 365 не указывая свой пароль в открытом виде.
&nbsp;
