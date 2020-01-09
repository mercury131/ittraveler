#                 	Автоматический перенос старых перемещаемых профилей в архив с помощью Powershell.                	  
***            ***

			
            
		

    




	
    	  Дата: 05.05.2015 Автор Admin  
	Думаю многие системные администраторы использующие перемещаемые профили или folder redirection, сталкивались с проблемой старых профилей уволенных сотрудников.
Ведь не всегда можно проследить перенесли профиль в архив или нет.
Для решения данной проблемы предлагаю использовать следующий скрипт:
В переменных укажите путь к перемещаемым профилям.
В скрипте ниже пути к папкам folder redirection содержат username пользователя, по нему ведется поиск старого профиля в Active Directory.
Если профиля нет в Active Directory, старый профиль с папками folder redirection перемещается в архив.
Если вас интересует перенос старых перемещаемых профилей измените переменные $move1 = $($User.Name) на $move1 = &#171;$User.DOMAIN.V2&#187; , где DOMAIN.V2 префикс перемещаемого профиля Вашего домена.

		
		
			
			PowerShell
			
```
# Select source folders
$Path1 = "F:\fileshare\UsersFolders\ProfilesIva"
$Path2 = "F:\fileshare\UsersFolders\Profiles"
$Path3 = "F:\fileshare\UsersFolders\ProfilesYar"
$DestinationFolder = "\\archivesrv\OLDusers\OLD"
$ScriptFolder = "D:\Powershell_Scripts\MoveFolders-No-Users"

# Generate short data prefix
$shortdate = get-date -format "dd.MM.yyyy"

## Start checking folders from first region

# Find folder names in $Path1
$userProfile = Get-ChildItem -Path $Path1
$unknownList = @()
# Try to find Active Directory usernames from user folders
foreach($user in $userProfile){

    #Try to find user in Active Directory
    $ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}

    #Test to see if the user exists
    If($ADUser)
    {
        #User Exists
        #Write-host "$($User.Name) Exists"

    }
    Else
    {

        # Create new variable with username (Only Deleted users from Active Directory)
        $move1 = $($User.Name)
        # Move find folders to $DestinationFolder
        Copy-Item $Path1\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt
        Remove-Item $Path1\$move1 -Recurse -Force
    }
}

#Further we will repeat previos commands with next region ($Path2 and $Path3)

##Next Region ($Path2)

$userProfile = Get-ChildItem -Path $Path2
$unknownList = @()
foreach($user in $userProfile){

    $ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}

    If($ADUser)
    {
        #User Exists

    }
    Else
    {

        $move1 = $($User.Name)
        Copy-Item $Path2\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt
        Remove-Item $Path2\$move1 -Recurse -Force
    }
}

##Next Region ($Path3)

$userProfile = Get-ChildItem -Path $Path3
$unknownList = @()
foreach($user in $userProfile){

    $ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}

    If($ADUser)
    {
        #User Exists

    }
    Else
    {

        $move1 = $($User.Name)
        Copy-Item $Path3\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt
        Remove-Item $Path3\$move1 -Recurse -Force
    }
}

# Generate Email Body
echo "Отчет по профилям удаленных сотрудников:" &gt; $ScriptFolder\Body1.txt
echo " " &gt;&gt; $ScriptFolder\Body1.txt
echo " " &gt;&gt; $ScriptFolder\Body1.txt
echo " " &gt;&gt; $ScriptFolder\Body1.txt

$body = Get-Content $ScriptFolder\Body1.txt  

$body2 = Get-Content $ScriptFolder\Reports.txt | Out-String

# Send Email message

Send-MailMessage -From admin@domain.local -To admins@domain.local -Subject "Отчет по старым перемещаемым профилям" -attachment $ScriptFolder\Reports.txt -Encoding ([System.Text.Encoding]::UTF8) -Body $body$body2  -SmtpServer mailserver.domain.local
# Remove old Items
Remove-Item $ScriptFolder\Reports.txt
Remove-Item $ScriptFolder\Body1.txt
```
			
				
					
				
					123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100101
				
						# Select source folders$Path1 = "F:\fileshare\UsersFolders\ProfilesIva"$Path2 = "F:\fileshare\UsersFolders\Profiles"$Path3 = "F:\fileshare\UsersFolders\ProfilesYar"$DestinationFolder = "\\archivesrv\OLDusers\OLD"$ScriptFolder = "D:\Powershell_Scripts\MoveFolders-No-Users"&nbsp;# Generate short data prefix$shortdate = get-date -format "dd.MM.yyyy"&nbsp;## Start checking folders from first region&nbsp;# Find folder names in $Path1$userProfile = Get-ChildItem -Path $Path1$unknownList = @()# Try to find Active Directory usernames from user foldersforeach($user in $userProfile){&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Try to find user in Active Directory&nbsp;&nbsp;&nbsp;&nbsp;$ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Test to see if the user exists&nbsp;&nbsp;&nbsp;&nbsp;If($ADUser)&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#User Exists&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Write-host "$($User.Name) Exists"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;&nbsp;&nbsp;&nbsp;Else&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Create new variable with username (Only Deleted users from Active Directory)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$move1 = $($User.Name)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Move find folders to $DestinationFolder&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Copy-Item $Path1\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Remove-Item $Path1\$move1 -Recurse -Force&nbsp;&nbsp;&nbsp;&nbsp;}}&nbsp;#Further we will repeat previos commands with next region ($Path2 and $Path3)&nbsp;##Next Region ($Path2)&nbsp;$userProfile = Get-ChildItem -Path $Path2$unknownList = @()foreach($user in $userProfile){&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If($ADUser)&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#User Exists&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;&nbsp;&nbsp;&nbsp;Else&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$move1 = $($User.Name)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Copy-Item $Path2\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Remove-Item $Path2\$move1 -Recurse -Force&nbsp;&nbsp;&nbsp;&nbsp;}}&nbsp;##Next Region ($Path3)&nbsp;$userProfile = Get-ChildItem -Path $Path3$unknownList = @()foreach($user in $userProfile){&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ADUser = Get-ADUser -Filter {SamAccountName -eq $User.Name}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If($ADUser)&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#User Exists&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;&nbsp;&nbsp;&nbsp;Else&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$move1 = $($User.Name)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Copy-Item $Path3\$move1 $DestinationFolder\$move1-$shortdate -Verbose -Recurse -Erroraction SilentlyContinue *&gt;&gt; $ScriptFolder\Reports.txt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Remove-Item $Path3\$move1 -Recurse -Force&nbsp;&nbsp;&nbsp;&nbsp;}}&nbsp;# Generate Email Bodyecho "Отчет по профилям удаленных сотрудников:" &gt; $ScriptFolder\Body1.txtecho " " &gt;&gt; $ScriptFolder\Body1.txtecho " " &gt;&gt; $ScriptFolder\Body1.txtecho " " &gt;&gt; $ScriptFolder\Body1.txt&nbsp;$body = Get-Content $ScriptFolder\Body1.txt&nbsp;&nbsp;&nbsp;$body2 = Get-Content $ScriptFolder\Reports.txt | Out-String&nbsp;# Send Email message&nbsp;Send-MailMessage -From admin@domain.local -To admins@domain.local -Subject "Отчет по старым перемещаемым профилям" -attachment $ScriptFolder\Reports.txt -Encoding ([System.Text.Encoding]::UTF8) -Body $body$body2&nbsp;&nbsp;-SmtpServer mailserver.domain.local# Remove old ItemsRemove-Item $ScriptFolder\Reports.txtRemove-Item $ScriptFolder\Body1.txt
					
				
			
		

&nbsp;
После выполнения данный скрипт отправит отчет о перенесенных профилях.
Для автоматизации добавьте данный скрипт в планировщик задач.
