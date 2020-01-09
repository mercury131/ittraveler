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
