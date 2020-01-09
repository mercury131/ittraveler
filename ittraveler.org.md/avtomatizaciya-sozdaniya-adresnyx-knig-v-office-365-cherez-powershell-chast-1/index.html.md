# Автоматизация создания адресных книг в Office 365 через Powershell Часть 1.                	  
***Дата: 31.12.2014 Автор Admin***

В данном цикле статей я покажу как автоматизировать процесс создания, удаления, актуализации адресных книг в Office 365.
Имеем следующую схему:
1) Пользователи синхронизируются из локальной AD, каждый пользователь находится в своей OU с названием его компании, и состоит в 2-х группах (по 2-е группы на каждую компанию)
2) Нам нужно автоматизировать процесс создания индивидуальных адресных книг для каждой компании (OU).
Итак, нам нужно:
1) Создавать новые адресные книги
2) Удалять неактуальные адресные книги
3) Добавлять новым пользователям политику адресных книг их компании.
4) Сделать так, чтобы каждая компания видела только свою адресную книгу.
В этой статье я покажу как создавать адресные книги автоматически.
Алгоритм скрипта будет таким:
1) Создаем CSV файл, в который будут записываться группы AD (те 2-е группы в каждой компании)
2) Будем добавлять не все группы подряд, а только группы с заметкой (в свойствах группы) test.com
3) Подключаемся к Office 365
4) Синхронизируем локальную AD с Office 365
5) Импортируем CSV и на его основе создаем адресные книги (для каждой группы своя адресная книга)
6) Т.к. пользователи уже входят в эти группы, они автоматически станут членами адресной книги
7) Применяем политику адресных книг на пользователей
8) Создаем Powershell скрипт, который будет применять новым пользователям политику адресных книг.
Сам скрипт:
```
#Delete OLD Sessions 
Remove-PSSession $Session
$AdminUsername = "LOGIN@test.com"
$AdminPassword = "PASS"
$CSVpatch = "C:\PowerShell_Scripts\123.csv"
#Add Groups with Attribute Info to CSV
Remove-Item $CSVpatch
Get-ADGroup -Filter {info -eq 'test.com'} -SearchBase "OU=Office365_Sync,DC=test,DC=local" -Properties Name, Description | select Name, Description | export-csv  -Encoding UTF8 -NoTypeInformation -Delimiter ";"  $CSVpatch 
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
Import-Csv $CSVpatch -Delimiter ";"| % {
$ADgroup = $_.Name; # Set the Name
$DisplayName = $_.Description; # Set the Description
#set group DN
$dn = (Get-DistributionGroup $ADgroup).distinguishedName
#Create New Resourse address list
New-AddressList -Name "$ADgroup.res" -RecipientFilter "RecipientDisplayType -eq 'ConferenceRoomMailbox' -and memberOfGroup -eq '$dn'" -DisplayName "$DisplayName Ресурсы"
#Create New Address List
New-AddressList -Name "$ADgroup" -DisplayName "$DisplayName" -RecipientFilter "{(RecipientType -eq 'UserMailbox' -or RecipientType -eq 'MailUniversalDistributionGroup') -and memberOfGroup -eq '$dn'}"
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
#Add shedule task to automate script
echo " `n" &amp;gt;&amp;gt; C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1
$ObjectID= $ObjectID.Trim()
Remove-Item C:\PowerShell_Scripts\TEMPshedule.ps1
Get-Content C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1 &amp;gt; C:\PowerShell_Scripts\TEMPshedule.ps1
Remove-Item C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1
mv C:\PowerShell_Scripts\TEMPshedule.ps1 C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1
$_='$_'
echo "Get-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId $ObjectID).objectid} | Set-Mailbox -AddressBookPolicy $ADgroup.Abp" &amp;gt;&amp;gt; C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1
Remove-Item C:\PowerShell_Scripts\TEMPshedule.ps1
#Remove Temp File
Remove-Item C:\Users\$username\TEMP
}
Remove-PSSession $Session
Remove-Item $CSVpatch
```
#Delete OLD Sessions &nbsp;Remove-PSSession $Session&nbsp;$AdminUsername = "LOGIN@test.com"$AdminPassword = "PASS"&nbsp;$CSVpatch = "C:\PowerShell_Scripts\123.csv"&nbsp;#Add Groups with Attribute Info to CSV&nbsp;Remove-Item $CSVpatch&nbsp;Get-ADGroup -Filter {info -eq 'test.com'} -SearchBase "OU=Office365_Sync,DC=test,DC=local" -Properties Name, Description | select Name, Description | export-csv&nbsp;&nbsp;-Encoding UTF8 -NoTypeInformation -Delimiter ";"&nbsp;&nbsp;$CSVpatch &nbsp;#Connect to Office 365$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword&nbsp;$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection&nbsp;Import-PSSession $Session&nbsp;Import-Module MSOnline&nbsp;Connect-MSOLService -Credential $cred&nbsp;#Sync Local AD with Office 365 &nbsp;Import-Module DirSync&nbsp;Start-OnlineCoexistenceSync&nbsp;Import-Csv $CSVpatch -Delimiter ";"| % {&nbsp;$ADgroup = $_.Name; # Set the Name$DisplayName = $_.Description; # Set the Description&nbsp;#set group DN$dn = (Get-DistributionGroup $ADgroup).distinguishedName&nbsp;#Create New Resourse address listNew-AddressList -Name "$ADgroup.res" -RecipientFilter "RecipientDisplayType -eq 'ConferenceRoomMailbox' -and memberOfGroup -eq '$dn'" -DisplayName "$DisplayName Ресурсы"&nbsp;#Create New Address ListNew-AddressList -Name "$ADgroup" -DisplayName "$DisplayName" -RecipientFilter "{(RecipientType -eq 'UserMailbox' -or RecipientType -eq 'MailUniversalDistributionGroup') -and memberOfGroup -eq '$dn'}"&nbsp;#Create New GALNew-GlobalAddressList -Name "$ADgroup.gal" -RecipientFilter "MemberOfGroup -eq '$dn'"&nbsp;#Create Offline Address BookNew-OfflineAddressBook -Name "$ADgroup.Oab" -AddressLists "$ADgroup.gal"&nbsp;#Create Address Book Policy&nbsp;New-AddressBookPolicy -Name "$ADgroup.Abp" -AddressLists "$ADgroup" -OfflineAddressBook "\$ADgroup.Oab" -GlobalAddressList "\$ADgroup.gal" -RoomList "\$ADgroup.res"&nbsp;#Set Username Variable$username=[Environment]::UserName&nbsp;#Delete Temp fileRemove-Item C:\Users\$username\TEMP&nbsp;#Get Object ID from AD cloud groupGet-MsolGroup | Where-Object {$_.DisplayName -eq "$ADgroup"} | select ObjectId | Out-File -FilePath C:\Users\$username\TEMP$ObjectID=(Get-Content C:\Users\$username\TEMP)[3]echo $ObjectID#Select New Address Book Policy to users in AD GroupGet-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId $ObjectID).objectid} | Set-Mailbox -AddressBookPolicy "$ADgroup.Abp"&nbsp;#Add shedule task to automate script&nbsp;echo " `n" &amp;gt;&amp;gt; C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1$ObjectID= $ObjectID.Trim()&nbsp;Remove-Item C:\PowerShell_Scripts\TEMPshedule.ps1Get-Content C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1 &amp;gt; C:\PowerShell_Scripts\TEMPshedule.ps1Remove-Item C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1mv C:\PowerShell_Scripts\TEMPshedule.ps1 C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1$_='$_'echo "Get-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId $ObjectID).objectid} | Set-Mailbox -AddressBookPolicy $ADgroup.Abp" &amp;gt;&amp;gt; C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1&nbsp;Remove-Item C:\PowerShell_Scripts\TEMPshedule.ps1&nbsp;#Remove Temp FileRemove-Item C:\Users\$username\TEMP&nbsp;}&nbsp;Remove-PSSession $SessionRemove-Item $CSVpatch
В следующей статье мы рассмотрим как удалять неактуальные адресные книги.
Не забывайте в скриптах указывать свои пути и переменные, иначе ничего не заработает!
