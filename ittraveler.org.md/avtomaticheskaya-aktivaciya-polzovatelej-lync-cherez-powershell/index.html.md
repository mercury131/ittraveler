# Автоматическая активация пользователей Lync через Powershell                	  
***Дата: 13.01.2015 Автор Admin***

В данной статье я расскажу как сделать автоматическую активацию пользователей Lync через Powershell. 
Согласитесь ведь активация каждого пользователя в панели администрирования Lync может занять много времени, плюс это рутина.
Предлагаю автоматизировать данный процесс следующим образом:
1) Будем активировать только пользователей из определенной группы Active Directory
2) Активировать будем в автоматическом режиме, каждые 15 минут.
Для решения данной задачи нам поможет следующий скрипт:
```
# Задаем по какой группе искать пользователей
$users = (Get-ADGroupMember GD-Lync-Users | select name) 
foreach ($user in $users) {
# Включаем пользователей в Lync
Enable-CsUser -Identity $user -RegistrarPool "Your-Lync-Server" -SipAddressType SamAccountName -SipDomain SIP-Domain.local
}
# Определяем каких пользователей отключать
$Disableusers = Get-ADUser -Filter * -SearchBase "DC=Domain,DC=local" -properties memberOf | Where-Object {$_.MemberOf -notcontains "CN=GD-Lync-Users,OU=Lync,OU=Groups,DC=Domain,DC=local"} 
# Отображаем только имя пользователя
$Disableusers = $Disableusers.name 
foreach ($user in $Disableusers) {
# Отключаем пользователей которые не состоят в группе GD-Lync-Users
Disable-CsUser -Identity "$user"
}
```
# Задаем по какой группе искать пользователей&nbsp;$users = (Get-ADGroupMember GD-Lync-Users | select name) &nbsp;foreach ($user in $users) {&nbsp;# Включаем пользователей в Lync&nbsp;Enable-CsUser -Identity $user -RegistrarPool "Your-Lync-Server" -SipAddressType SamAccountName -SipDomain SIP-Domain.local&nbsp;}&nbsp;# Определяем каких пользователей отключать$Disableusers = Get-ADUser -Filter * -SearchBase "DC=Domain,DC=local" -properties memberOf | Where-Object {$_.MemberOf -notcontains "CN=GD-Lync-Users,OU=Lync,OU=Groups,DC=Domain,DC=local"} &nbsp;# Отображаем только имя пользователя$Disableusers = $Disableusers.name &nbsp;foreach ($user in $Disableusers) {&nbsp;# Отключаем пользователей которые не состоят в группе GD-Lync-Users&nbsp;Disable-CsUser -Identity "$user"&nbsp;}
Обратите внимание что для работы данного скрипта должны быть установлены модули Lync и Active Directory
Остается только добавить данный скрипт в планировщик задач.
Теперь вам не придется добавлять пользователей вручную =)
