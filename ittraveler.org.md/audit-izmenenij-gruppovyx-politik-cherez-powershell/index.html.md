# Аудит изменений групповых политик через PowerShell                	  
***Дата: 07.08.2015 Автор Admin***

Если в вашей компании больше чем один системный администратор, то рано или поздно вы столкнетесь с проблемой аудита GPO.
В данной статье мы разберем как получить уведомление на почту об измененных групповых политиках.
В решении данной проблемы мы будем использовать скрипт, который будет искать изменения в GPO за указанное кол-во дней, создавать отчет GPO и отправлять письмо системному администратору.
Теперь сам скрипт:
PowerShell
```
#Указываем почтовый сервер
$mailserver="mailserver"
#Путь где будут храниться отчеты по GPO
$reportPatch="\yourdir1"
# кол-во дней за которые идет поиск
$days='10'
# Почтовый домен
$mail_domain="domain.com"
# получатели
$sendto="admin@domain.com"
# тема письма
$theme="Аудит изменений в GPO"
# временный текстовый файл в котором формируется тело письма
$tmp="\yourdirtmp\body.txt"
# Путь где хранятся временный zip архив с отчетами
$zippatch='\yourdirtmp3'
# полный путь к zip архиву для отправки по почте
$Attachment="$zippatch\GPOreport.zip"
# Удаляем старое вложение
Remove-Item $Attachment
# Импортируем модуль GroupPolicy
Import-Module GroupPolicy
# Добавляем заголовок в тему письма
echo "Изменены следующие групповые политики:" &gt; $tmp
# Загружаем список измененных GPO
$changed_GPO = (Get-GPO -all | ? {$_.ModificationTime -gt (get-date).adddays(—$days)}).DisplayName
foreach ($gpos in $changed_GPO)
{
# Создаем отчеты GPO
Get-GPOReport -Name "$gpos" -ReportType HTML -Path $reportPatch\$gpos.html
}
# Добавляем в тело письма список измененных GPO
$gpo_modif=Get-GPO -all | ? {$_.ModificationTime -gt (get-date).adddays(—$days)} | select DisplayName, ModificationTime | ft -AutoSize &gt;&gt; $tmp
# Преобразуем тело письма
$body=Get-Content $tmp | Out-String 
# Архивируем полученные отчеты в zip
function ZipFiles( $zipfilename, $sourcedir )
{
Add-Type -Assembly System.IO.Compression.FileSystem
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,
$zipfilename, $compressionLevel, $false)
}
ZipFiles $zippatch\GPOreport.zip $reportPatch\
# Отправляем письмо администратору
Send-MailMessage -From GPO-notification@$mail_domain -To $sendto -Encoding ([System.Text.Encoding]::UTF8) -Subject $theme -Body $body -SmtpServer $mailserver -Attachment "$Attachment"
```
#Указываем почтовый сервер$mailserver="mailserver"#Путь где будут храниться отчеты по GPO$reportPatch="\yourdir1"# кол-во дней за которые идет поиск$days='10'# Почтовый домен$mail_domain="domain.com"# получатели$sendto="admin@domain.com"# тема письма$theme="Аудит изменений в GPO"# временный текстовый файл в котором формируется тело письма$tmp="\yourdirtmp\body.txt"# Путь где хранятся временный zip архив с отчетами$zippatch='\yourdirtmp3'# полный путь к zip архиву для отправки по почте$Attachment="$zippatch\GPOreport.zip"&nbsp;&nbsp;# Удаляем старое вложение&nbsp;Remove-Item $Attachment&nbsp;# Импортируем модуль GroupPolicy&nbsp;Import-Module GroupPolicy&nbsp;# Добавляем заголовок в тему письма&nbsp;echo "Изменены следующие групповые политики:" &gt; $tmp&nbsp;&nbsp;# Загружаем список измененных GPO&nbsp;$changed_GPO = (Get-GPO -all | ? {$_.ModificationTime -gt (get-date).adddays(—$days)}).DisplayName&nbsp;foreach ($gpos in $changed_GPO)&nbsp;{&nbsp;# Создаем отчеты GPO&nbsp;Get-GPOReport -Name "$gpos" -ReportType HTML -Path $reportPatch\$gpos.html&nbsp;&nbsp;}# Добавляем в тело письма список измененных GPO$gpo_modif=Get-GPO -all | ? {$_.ModificationTime -gt (get-date).adddays(—$days)} | select DisplayName, ModificationTime | ft -AutoSize &gt;&gt; $tmp&nbsp;# Преобразуем тело письма$body=Get-Content $tmp | Out-String &nbsp;# Архивируем полученные отчеты в zip&nbsp;function ZipFiles( $zipfilename, $sourcedir ){&nbsp;&nbsp; Add-Type -Assembly System.IO.Compression.FileSystem&nbsp;&nbsp; $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal&nbsp;&nbsp; [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$zipfilename, $compressionLevel, $false)}&nbsp;ZipFiles $zippatch\GPOreport.zip $reportPatch\&nbsp;# Отправляем письмо администратору&nbsp;Send-MailMessage -From GPO-notification@$mail_domain -To $sendto -Encoding ([System.Text.Encoding]::UTF8) -Subject $theme -Body $body -SmtpServer $mailserver -Attachment "$Attachment"
Измените переменные и скрипт будет работать.
Удачного аудита GPO =)
