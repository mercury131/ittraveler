#                 	Поиск старых почтовых ящиков в Exchange 2010                	  
***            ***

			
            
		

    




	
    	  Дата: 31.12.2014 Автор Admin  
	В данной статье я расскажу как с помощью Powershell найти старые почтовые ящики Exchange и отправить уведомление на Email.
Для решения этой задачи мы напишем скрипт, который будет делать следующее:
1) Импортирует модуль Exchange
2) импортирует модуль Active Directory
3) Найдет пользователей которые не заходили в систему 120 дней
4) Проверит у кого из них есть почтовый ящик
5) Полученный результат отправит нам на почту.
Теперь сам скрипт:

		
		
			
			PowerShell
			
```
# Импорт модуля Exchange
add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

# Импорт модуля ActiveDirectory
import-module ActiveDirectory

#Удаляем старые файлы inactive.txt и .\mailbox.txt
remove-item .\inactive.txt

remove-item .\mailbox.txt

#Поиск пользователей которые не заходили в систему 120 дней
(get-aduser -filter * -properties lastlogondate | Where-Object {$_.enabled -eq "true"-and $_.lastlogondate -lt (get-date).adddays(-120)}).SamAccountName &gt; .\inactive.txt

$userlist = Get-Content .\inactive.txt

#Проверяем есть ли у них почтовый ящик
foreach ($user in $userlist)

{
$Mailbox = get-mailbox -identity $user

if ($mailbox) {

$user &gt;&gt; .\mailbox.txt
}}

$files = Get-Content .\mailbox.txt

#Формируем тело письма
$body = Get-Content .\mailbox.txt | Sort |  Out-String
$body1 = echo The old mailboxes not found  |  Out-String

#Отправляем письма
if ($files -ne $null)
{
   Send-MailMessage -From admin-notification@domain.local -To sysadmin@domain.local -Encoding ([System.Text.Encoding]::UTF8) -attachment .\mailbox.txt -Subject "Обнаружены старые почтовые ящики" -Body $body  -SmtpServer EXCHANGE-Server.domain.local
}
else
{
   Send-MailMessage -From admin-notification@domain.local -To sysadmin@domain.local -Encoding ([System.Text.Encoding]::UTF8) -Subject "Cтарые почтовые ящики не обнаружены" -Body $body1 -BodyAsHtml -SmtpServer EXCHANGE-Server.domain.local
}
```
			
				
					
				
					123456789101112131415161718192021222324252627282930313233343536373839404142
				
						# Импорт модуля Exchangeadd-pssnapin Microsoft.Exchange.Management.PowerShell.E2010&nbsp;# Импорт модуля ActiveDirectoryimport-module ActiveDirectory&nbsp;#Удаляем старые файлы inactive.txt и .\mailbox.txtremove-item .\inactive.txt&nbsp;remove-item .\mailbox.txt&nbsp;#Поиск пользователей которые не заходили в систему 120 дней(get-aduser -filter * -properties lastlogondate | Where-Object {$_.enabled -eq "true"-and $_.lastlogondate -lt (get-date).adddays(-120)}).SamAccountName &gt; .\inactive.txt&nbsp;$userlist = Get-Content .\inactive.txt&nbsp;#Проверяем есть ли у них почтовый ящикforeach ($user in $userlist)&nbsp;{$Mailbox = get-mailbox -identity $user&nbsp;if ($mailbox) {&nbsp;$user &gt;&gt; .\mailbox.txt}}&nbsp;$files = Get-Content .\mailbox.txt&nbsp;#Формируем тело письма$body = Get-Content .\mailbox.txt | Sort |&nbsp;&nbsp;Out-String$body1 = echo The old mailboxes not found&nbsp;&nbsp;|&nbsp;&nbsp;Out-String&nbsp;#Отправляем письмаif ($files -ne $null){&nbsp;&nbsp; Send-MailMessage -From admin-notification@domain.local -To sysadmin@domain.local -Encoding ([System.Text.Encoding]::UTF8) -attachment .\mailbox.txt -Subject "Обнаружены старые почтовые ящики" -Body $body&nbsp;&nbsp;-SmtpServer EXCHANGE-Server.domain.local}else{&nbsp;&nbsp; Send-MailMessage -From admin-notification@domain.local -To sysadmin@domain.local -Encoding ([System.Text.Encoding]::UTF8) -Subject "Cтарые почтовые ящики не обнаружены" -Body $body1 -BodyAsHtml -SmtpServer EXCHANGE-Server.domain.local}
					
				
			
		

&nbsp;
