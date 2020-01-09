# Добавление почтовых контактов в Office 365 через Powershell и CSV                	  
***Дата: 30.12.2014 Автор Admin***

Если вам нужно добавить большое кол-во почтовых контактов в Office 365 или Exchange Online, да еще и в группу рассылки их включить, прошу под кат)Первое что нам нужно сделать, это заполнить CSV файл со следующей шапкой:
```
FirstName;LastName;Email
```
FirstName;LastName;Email
Далее пишем вот такой скрипт:
```
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Import-Module MSOnline
Connect-MSOLService -Credential $cred
#Задаем переменные
$CSVpatch = "C:\PowerShell_Scripts\office365contact.csv"
Import-Csv $CSVpatch -Delimiter ";" | % {
$FirstName = $_.FirstName; # Set the FirstName
$LastName = $_.LastName; # Set the LastName
$Email = $_.Email; # Set the email
$namealias = $Email.Replace("@","")
$namealias = $namealias.Replace(".","")
New-MailContact -Name $LastName -DisplayName $LastName -ExternalEmailAddress $Email -FirstName $FirstName -LastName $LastName -Alias $namealias
Set-MailContact -Identity $Email -HiddenFromAddressListsEnabled $true
Add-DistributionGroupMember -Identity "YOUR_Distribution_Group@domain.com" -Member $Email
}
```
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection&nbsp;Import-PSSession $Session&nbsp;Import-Module MSOnline&nbsp;Connect-MSOLService -Credential $cred&nbsp;#Задаем переменные&nbsp;$CSVpatch = "C:\PowerShell_Scripts\office365contact.csv"&nbsp;Import-Csv $CSVpatch -Delimiter ";" | % {$FirstName = $_.FirstName; # Set the FirstName$LastName = $_.LastName; # Set the LastName$Email = $_.Email; # Set the email&nbsp;$namealias = $Email.Replace("@","")&nbsp;$namealias = $namealias.Replace(".","")&nbsp;New-MailContact -Name $LastName -DisplayName $LastName -ExternalEmailAddress $Email -FirstName $FirstName -LastName $LastName -Alias $namealias&nbsp;Set-MailContact -Identity $Email -HiddenFromAddressListsEnabled $true&nbsp;Add-DistributionGroupMember -Identity "YOUR_Distribution_Group@domain.com" -Member $Email&nbsp;}
&nbsp;
