# Автоматическая активация лицензий Office 365                	  
***Дата: 30.12.2014 Автор Admin***

Если вам нужно автоматически активировать лицензии пользователей Office 365, то данный скрипт будет вам полезен.Для начала вам нужно понять какой тип лицензий нужно активировать, для этого введите следующую команду в Powershell Office 365
```
Get-MSOLAccountSku
```
Get-MSOLAccountSku
После выполнения этой команды вы увидите тип используемых вами лицензий
Полученную информацию нужно будет подставить в следующий скрипт:
```
#Change these variables to match your environment
$AccountSkuId = "YOUR_Account:YOUR_STANDARDPACK"
$UsageLocation = "RU"
$AdminUsername = "LOGIN"
$AdminPassword = "PASS"
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword
Connect-MSOLService -Credential $cred
$LicenseOptions = New-MsolLicenseOptions -AccountSkuId $AccountSkuId
$UnlicencedUsers = Get-MSOLUser -UnlicensedUsersOnly -All
$UnlicencedUsers | ForEach-Object {
Set-MsolUser -UserPrincipalName $_.UserPrincipalName -UsageLocation $UsageLocation
Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -AddLicenses $AccountSkuId -LicenseOptions $LicenseOptions
}
```
#Change these variables to match your environment$AccountSkuId = "YOUR_Account:YOUR_STANDARDPACK"$UsageLocation = "RU"$AdminUsername = "LOGIN"$AdminPassword = "PASS"&nbsp;$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword&nbsp;Connect-MSOLService -Credential $cred&nbsp;$LicenseOptions = New-MsolLicenseOptions -AccountSkuId $AccountSkuId$UnlicencedUsers = Get-MSOLUser -UnlicensedUsersOnly -All&nbsp;$UnlicencedUsers | ForEach-Object {	Set-MsolUser -UserPrincipalName $_.UserPrincipalName -UsageLocation $UsageLocation	Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -AddLicenses $AccountSkuId -LicenseOptions $LicenseOptions}
Теперь можно добавить этот скрипт в планировщик, и новые пользователи будет получать лицензии автоматически =)
