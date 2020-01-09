# Автоматический аудит компьютеров в Active Directory через powershell.                	  
***Дата: 10.06.2015 Автор Admin***

В данной статье мы рассмотрим как автоматически проводить аудит компьютеров в Active Directory.
Я думаю многие системные администраторы ломали голову как вести учет за каким ПК какой пользователь работает, особенно если имена ПК статичны.
Для решения данной проблемы воспользуемся PowerShell.
Алгоритм данного скрипта будет таким:
1) Делаем выборку по всем пк, которые попадают под фильтр
2) Проверяем какой пользователь в настоящий момент работает за ПК
3) Переводим полученные данные в удобный формат
4) Записываем данные в отчет
5) Добавляем в описание компьютера имя пользователя
Внимание, данный скрипт подойдет тем администраторам, у которых рабочие места пользователей статичны.
Если в вашей организации пользователи постоянно пересаживаются с места на место, такой подход будет неудобен.
Перейдем к скрипту:
PowerShell
```
# Объявляем переменные
# область поиска
$OU="DC=domain,DC=local"
# Указываем Домен
$domain='DOMAIN'
# Указываем путь к отчету
$reportPatch="C:\PC_audit.csv"
#Импортируем модуль ActiveDirectory 
Import-Module ActiveDirectory
Remove-Item C:\PC_audit.csv
# Отбираем ПК по фильтру
Get-ADComputer -Filter * -SearchBase $OU  |
ForEach-Object {
#Переводим в переменную только имя ПК
$computer=($_).Name
# Узнаем какой пользователь работает на данном ПК и удаляем приставку с названием домена. 
$list=(gwmi win32_computersystem -comp $computer | select USername).USername -replace $domain
# Удаляем спец символы из полученного вывода
$list=[System.Text.RegularExpressions.Regex]::Replace("$list($7&amp;","[^1-9a-zA-Z_]"," ");
# Удаляем пробелы из полученного вывода
$list=$list -replace '\s',''
# Находим пользователя в ActiveDirectory по samaccountname и переводим в вывод Имя Фамилия
$list=(Get-ADUser $list).Name
# Выводим полученный результат на экран - ПК - Имя Фамилия
echo "$computer - $list"
# Записываем полученные данные в отчет
$result=(echo"$computer - $list")
$result=$result -replace '\s','' 
$result &gt;&gt; $reportPatch
# Добавляем Имя и Фамилию пользователя в описание ПК в Active Directory
Get-ADComputer $computer | Set-ADComputer -Description $list
}
```
# Объявляем переменные&nbsp;# область поиска$OU="DC=domain,DC=local"&nbsp;# Указываем Домен&nbsp;$domain='DOMAIN'&nbsp;# Указываем путь к отчету&nbsp;$reportPatch="C:\PC_audit.csv"&nbsp;#Импортируем модуль ActiveDirectory Import-Module ActiveDirectoryRemove-Item C:\PC_audit.csv&nbsp;# Отбираем ПК по фильтруGet-ADComputer -Filter * -SearchBase $OU&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;ForEach-Object {&nbsp;#Переводим в переменную только имя ПК$computer=($_).Name&nbsp;# Узнаем какой пользователь работает на данном ПК и удаляем приставку с названием домена. $list=(gwmi win32_computersystem -comp $computer | select USername).USername -replace $domain&nbsp;# Удаляем спец символы из полученного вывода$list=[System.Text.RegularExpressions.Regex]::Replace("$list($7&amp;","[^1-9a-zA-Z_]"," ");&nbsp;# Удаляем пробелы из полученного вывода$list=$list -replace '\s',''&nbsp;# Находим пользователя в ActiveDirectory по samaccountname и переводим в вывод Имя Фамилия$list=(Get-ADUser $list).Name&nbsp;# Выводим полученный результат на экран - ПК - Имя Фамилияecho "$computer - $list"&nbsp;# Записываем полученные данные в отчет$result=(echo"$computer - $list")$result=$result -replace '\s','' &nbsp;$result &gt;&gt; $reportPatch&nbsp; &nbsp;# Добавляем Имя и Фамилию пользователя в описание ПК в Active DirectoryGet-ADComputer $computer | Set-ADComputer -Description $list&nbsp;}
(adsbygoogle = window.adsbygoogle || []).push({});
Если при выполнении скрипта будет ошибка:
gwmi : Сервер RPC недоступен.
Это означает что ПК выключен или на нем отключен WMI.
Теперь добавьте данный скрипт в планировщик задач, и запускайте за час до конца рабочего дня.
Скрипт актуализирует информацию о пользователях на работающих ПК.
Удачной установки =)
