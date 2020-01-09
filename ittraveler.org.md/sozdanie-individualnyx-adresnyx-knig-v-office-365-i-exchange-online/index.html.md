# Создание индивидуальных адресных книг в Office 365 и Exchange online                	  
***Дата: 30.12.2014 Автор Admin***

Один раз мне поставили задачу разграничить адресные книги пользователям Office 365.
Смысл был в том, что каждый пользователь должен видеть только адресную книгу своей компании, чужих пользователей и их адресные книги он видеть не должен.
В моем случае пользователи синхронизировались из локальной Active Directory в Office 365, поэтому было решено фильтровать пользователей по группам AD, и с помощью групп разграничивать адресные книги.
Далее скрипт как это сделать.Алгоритм скрипта:
1) Вводим название группы AD (группа должна быть создана)
2) Вводим название адресной книги (название латиницей)
3) Далее подключаемся к Office 365
4) Синхронизируем локальную AD с Office 365
5) Создаем AddressList ресурсов
6) Создаем AddressList получателей
7) Создаем GlobalAddressList
8) Создаем OfflineAddressBook
9) Создаем AddressBookPolicy
10)Применяем политику адресных книг на пользователей
Сам скрипт:
```
#Set Variables
$ADgroup = Read-Host "Введите имя группы AD по которой будет проходить фильтрация"
$DisplayName = Read-Host "Введите отображаемое имя адресной книги"
$AdminUsername = "LOGIN"
$AdminPassword = "PASS"
echo $ADgroup
#Connect to Office 365
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Import-Module MSOnline
Connect-MSOLService -Credential $cred
#Sync Local AD with Office 365 
Import-Module DirSync
Start-OnlineCoexistenceSync
#Waiting Sync
echo "Ожидание синхронизации"
#Create new Address List, GAL,Policy,Offline Book
#set group DN
$dn = (Get-DistributionGroup $ADgroup).distinguishedName
#Create New Resourse address list
New-AddressList -Name "$ADgroup.res" -RecipientFilter "RecipientDisplayType -eq 'ConferenceRoomMailbox' -and memberOfGroup -eq '$dn'" -DisplayName "$DisplayName Ресурсы"
#Create New Address List
New-AddressList -Name "$ADgroup" -RecipientFilter "RecipientType -eq 'UserMailbox' -or RecipientType -eq 'MailUniversalDistributionGroup' -and memberOfGroup -eq '$dn'" -DisplayName "$DisplayName"
#Create New GAL
New-GlobalAddressList -Name "$ADgroup.gal" -RecipientFilter "MemberOfGroup -eq '$dn'"
#Create Offline Address Book
New-OfflineAddressBook -Name "$ADgroup.Oab" -AddressLists "$ADgroup.gal"
#Create Address Book Policy
New-AddressBookPolicy -Name "$ADgroup.Abp" -AddressLists "$ADgroup" -OfflineAddressBook "\$ADgroup.Oab" -GlobalAddressList "\$ADgroup.gal" -RoomList "\$ADgroup.res"
#Set Username Variable
$username=[Environment]::UserName
#Delete Temp file
Remove-Item C:\Users\$username\TEMP
#Get Object ID from AD cloud group
Get-MsolGroup | Where-Object {$_.DisplayName -eq "$ADgroup"} | select ObjectId | Out-File -FilePath C:\Users\$username\TEMP
$ObjectID=(Get-Content C:\Users\$username\TEMP)[3]
echo $ObjectID
#Select New Address Book Policy to users in AD Group
Get-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId $ObjectID).objectid} | Set-Mailbox -AddressBookPolicy "$ADgroup.Abp"
```
#Set Variables$ADgroup = Read-Host "Введите имя группы AD по которой будет проходить фильтрация"$DisplayName = Read-Host "Введите отображаемое имя адресной книги"$AdminUsername = "LOGIN"$AdminPassword = "PASS"echo $ADgroup&nbsp;#Connect to Office 365$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword&nbsp;$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection&nbsp;Import-PSSession $Session&nbsp;Import-Module MSOnline&nbsp;Connect-MSOLService -Credential $cred&nbsp;#Sync Local AD with Office 365 &nbsp;Import-Module DirSync&nbsp;Start-OnlineCoexistenceSync&nbsp;#Waiting Syncecho "Ожидание синхронизации"&nbsp;#Create new Address List, GAL,Policy,Offline Book&nbsp;#set group DN$dn = (Get-DistributionGroup $ADgroup).distinguishedName&nbsp;#Create New Resourse address listNew-AddressList -Name "$ADgroup.res" -RecipientFilter "RecipientDisplayType -eq 'ConferenceRoomMailbox' -and memberOfGroup -eq '$dn'" -DisplayName "$DisplayName Ресурсы"&nbsp;#Create New Address ListNew-AddressList -Name "$ADgroup" -RecipientFilter "RecipientType -eq 'UserMailbox' -or RecipientType -eq 'MailUniversalDistributionGroup' -and memberOfGroup -eq '$dn'" -DisplayName "$DisplayName"&nbsp;#Create New GALNew-GlobalAddressList -Name "$ADgroup.gal" -RecipientFilter "MemberOfGroup -eq '$dn'"&nbsp;#Create Offline Address BookNew-OfflineAddressBook -Name "$ADgroup.Oab" -AddressLists "$ADgroup.gal"&nbsp;#Create Address Book Policy&nbsp;New-AddressBookPolicy -Name "$ADgroup.Abp" -AddressLists "$ADgroup" -OfflineAddressBook "\$ADgroup.Oab" -GlobalAddressList "\$ADgroup.gal" -RoomList "\$ADgroup.res"&nbsp;#Set Username Variable$username=[Environment]::UserName&nbsp;#Delete Temp fileRemove-Item C:\Users\$username\TEMP&nbsp;#Get Object ID from AD cloud groupGet-MsolGroup | Where-Object {$_.DisplayName -eq "$ADgroup"} | select ObjectId | Out-File -FilePath C:\Users\$username\TEMP$ObjectID=(Get-Content C:\Users\$username\TEMP)[3]echo $ObjectID#Select New Address Book Policy to users in AD GroupGet-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId $ObjectID).objectid} | Set-Mailbox -AddressBookPolicy "$ADgroup.Abp"
&nbsp;
