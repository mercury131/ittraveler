# Экспорт почтовых ящиков Exchange 2010 через Powershell и PST                	  
***Дата: 31.12.2014 Автор Admin***

В данной статье я расскажу как с помощью скрипта экспортировать несколько почтовых ящиков в PST.
Для выполнения этой задачи нам понадобится заполненный CSV файл и Powershell скрипт.
Шапка CSV файла будет такой:
```
id;
```
id;
Далее мы будем использовать вот такой скрипт:
PowerShell
```
$exchange&amp;nbsp;=&amp;nbsp;New-PSSession&amp;nbsp;-ConfigurationName&amp;nbsp;Microsoft.Exchange&amp;nbsp;-ConnectionUri&amp;nbsp;http://YOUR-EXCHANGE-SERVER/powershell&amp;nbsp;-Authentication&amp;nbsp;Kerberos
Import-PSSession&amp;nbsp;$exchange&amp;nbsp;
Get-PSSession #Список открытых сессий
Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false
$CSVpath = "C:\users.csv"
Import-Csv $CSVpath -Delimiter ";"| % {
$username = $_.id; # Set the user
New-Item -ItemType directory -Path \\YOUR_FILE-SERVER\RemoveUsers\$username
New-MailboxExportRequest -Mailbox $username -FilePath \\YOUR_FILE-SERVER\RemoveUsers\$username\$username.pst
}
Remove-PSSession $exchange
```
$exchange&amp;nbsp;=&amp;nbsp;New-PSSession&amp;nbsp;-ConfigurationName&amp;nbsp;Microsoft.Exchange&amp;nbsp;-ConnectionUri&amp;nbsp;http://YOUR-EXCHANGE-SERVER/powershell&amp;nbsp;-Authentication&amp;nbsp;KerberosImport-PSSession&amp;nbsp;$exchange&amp;nbsp;Get-PSSession #Список открытых сессий&nbsp;Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false$CSVpath = "C:\users.csv"Import-Csv $CSVpath -Delimiter ";"| % {$username = $_.id; # Set the userNew-Item -ItemType directory -Path \\YOUR_FILE-SERVER\RemoveUsers\$usernameNew-MailboxExportRequest -Mailbox $username -FilePath \\YOUR_FILE-SERVER\RemoveUsers\$username\$username.pst&nbsp;}&nbsp;Remove-PSSession $exchange
Не забывайте подставлять свои значения в скрипты!
Теперь можно отключить ненужные учетные записи с помощью командлета
```
Disable-Mailbox $username -Confirm:$False
```
Disable-Mailbox $username -Confirm:$False
Или скрипта
```
$exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://YOUR-EXCHANGE-SERVER/powershell -Authentication Kerberos
Import-PSSession $exchange 
Get-PSSession #Список открытых сессий
Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false
$CSVpath = "C:\users.csv"
Import-Csv $CSVpath -Delimiter ";"| % {
$username = $_.id; # Set the user
Disable-Mailbox $username -Confirm:$False
}
Remove-PSSession $exchange
```
$exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://YOUR-EXCHANGE-SERVER/powershell -Authentication KerberosImport-PSSession $exchange Get-PSSession #Список открытых сессий&nbsp;Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false$CSVpath = "C:\users.csv"Import-Csv $CSVpath -Delimiter ";"| % {$username = $_.id; # Set the user&nbsp;Disable-Mailbox $username -Confirm:$False}&nbsp;Remove-PSSession $exchange
Просмотреть статус экспорта можно командой:
```
Get-MailboxExportRequest
```
Get-MailboxExportRequest
После экспорта не забываем удалить выполненные запросы на экспорт. Делается это так:
```
Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false
```
Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false
&nbsp;
