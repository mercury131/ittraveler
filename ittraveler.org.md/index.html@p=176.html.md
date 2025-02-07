#                 	Автоматизация создания адресных книг в Office 365 через Powershell Часть 3.                	  
***            ***

			
            
		
    
	
    	  Дата: 31.12.2014 Автор Admin  
	В данной статья я расскажу как автоматизировать процесс добавления новых пользователей в политику адресных книг Office 365.
Вкратце зачем это нужно. Если вы создали нового пользователя и включили его в группы Active Directory, по которым идет фильтрация адресных книг, это еще не значит что новый пользователь будет видеть только свою адресную книгу. Проблема в том что он будет видеть все соседние адресные книги, но при этом будет членом только своей адресной книги.
Как это исправить? Я предлагаю сделать это следующим образом.
Нам понадобятся 3 Powershell скрипта.
1-й скрипт будет &#171;шаблоном&#187;. В нем мы будем подключаться к Office 365. Назовем его MainShedule.ps1
2-й скрипт будет создаваться скриптом из этой статьи, данный скрипт будет в самый конец нашего будущего скрипта добавлять актуальные строки применения политики адресных книг.
3-й получившийся скрипт будет применять политики для всех новых пользователей. Его просто нужно добавить в планировщик задач. Назовем его Add-AddressBookPolicy-Via-ADgroup.ps1
Итак начнем.
Первый скрипт:
$AdminUsername = "LOGIN@test.com"
$AdminPassword = "PASS"

Import-Module DirSync

Start-OnlineCoexistenceSync

Start-Sleep 300

Start-OnlineCoexistenceSync

$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection

Import-PSSession $Session

Import-Module MSOnline

Connect-MSOLService -Credential $cred

####Shedule Tasks###

Соответственно в следующем скрипте, который мы формируем при создании новых адресных книг, мы будем добавлять строки под этой частью кода:
####Shedule Tasks###
Далее после формирования скрипта при создании новых адресных книг, мы должны получить следующий скрипт:
$AdminUsername = "LOGIN@test.com"
$AdminPassword = "PASS"

Import-Module DirSync

Start-OnlineCoexistenceSync

Start-Sleep 300

Start-OnlineCoexistenceSync

$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection

Import-PSSession $Session

Import-Module MSOnline

Connect-MSOLService -Credential $cred

####Shedule Tasks###

Get-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId dbb4332f-32f5-4c42-bd81-8ec73daee619).objectid} | Set-Mailbox -AddressBookPolicy GD-YOUR.Abp
Get-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId dbb4378f-3235-4c42-bd81-8ec73d247319).objectid} | Set-Mailbox -AddressBookPolicy GD-YOUR_2.Abp


Как видите, добавляются строки типа:
Get-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId dbb4332f-32f5-4c42-bd81-8ec73daee619).objectid} | Set-Mailbox -AddressBookPolicy GD-YOUR.Abp
Get-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId dbb4378f-3235-4c42-bd81-8ec73d247319).objectid} | Set-Mailbox -AddressBookPolicy GD-YOUR_2.Abp
Но есть одна проблема. Данный при создании новых адресных книг, эти строки будут дублироваться, и это замедлит выполнение скрипта.
Предлагаю решить проблему так &#8212; мы просто удалим все существующие дубли из скрипта.
Поможет нам в этом 4-й скрипт.
Что мы сделаем:
1) Подключимся к Office 365
2) Выгрузим актуальный список групп
3) Сохраним это в файл
4) Удалим дубли
5) Сделаем Backup старого файла Add-AddressBookPolicy-Via-ADgroup.ps1
6) Создадим новый файл Add-AddressBookPolicy-Via-ADgroup.ps1 без дублей строк.
Сам скрипт:
#Delete OLD Session
Remove-PSSession $Session

#Set Vars

$TEMP01 = "C:\PowerShell_Scripts\TEMP001.csv"

$TEMP02 = "C:\PowerShell_Scripts\TEMP002.txt"

remove-item $TEMP01

remove-item $TEMP02

$AdminUsername = "LOGIN@test.com"
$AdminPassword = "PASS"

$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername,$SecurePassword

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection

Import-PSSession $Session

Import-Module MSOnline

Connect-MSOLService -Credential $cred

#Export Office 365 Groups to CSV

Get-MsolGroup | Where-Object {$_.GroupType -eq "MailEnabledSecurity"} | select DisplayName | Export-Csv -NoTypeInformation -Path $TEMP01 -Delimiter ";"    

Remove-PSSession $Session

Remove-Item C:\PowerShell_Scripts\TempShedule.ps1

Copy-Item C:\PowerShell_Scripts\Backup\MainShedule.ps1 C:\PowerShell_Scripts\TempShedule.ps1

remove-item $TEMP02

Import-Csv $TEMP01 -Delimiter ";"| % {
$Rules = $_.DisplayName; # Set the user

echo $Rules

Get-Content -Path "C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1" | Where {$_ -Match "$Rules"} &gt;&gt; $TEMP02

echo " " &gt;&gt; $TEMP02

}

$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('dd-MM-yyyy_')

#echo $CurrentDate

Get-Content $TEMP02 | Add-Content C:\PowerShell_Scripts\TempShedule.ps1

$hash = @{}      # define a new empty hash table

gc C:\PowerShell_Scripts\TempShedule.ps1 | % {

if ($hash.$_ -eq $null) {  

$_
};

$hash.$_ = 1

} &gt; C:\PowerShell_Scripts\TempShedule-01.ps1 

Remove-Item C:\PowerShell_Scripts\TempShedule.ps1

Move-Item -Force C:\PowerShell_Scripts\TempShedule-01.ps1 C:\PowerShell_Scripts\TempShedule.ps1

Move-Item -Force C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1 C:\PowerShell_Scripts\Backup\Tasks\Add-AddressBookPolicy-Via-ADgroup_"$CurrentDate".ps1

Move-Item -Force C:\PowerShell_Scripts\TempShedule.ps1 C:\PowerShell_Scripts\Add-AddressBookPolicy-Via-ADgroup.ps1

remove-item $TEMP01

remove-item $TEMP02

remove-item C:\PowerShell_Scripts\TempShedule.ps1

Теперь нужно просто периодически выполнять этот скрипт через планировщик =)
Вот и все. Таким образом можно автоматизировать процесс создания адресных книг в Office 365.
Не забывайте в скриптах указывать свои пути и переменные, иначе ничего не заработает!
Удачи)
Related posts:Автоматическая активация лицензий Office 365Установка RSAT на Windows 10 1809Автоматизируем бэкап баз данных MSSQL Express
        
             Active Directory, Exchange, Office 365, PowerShell, Windows, Windows Server 
             Метки: Active Directory, Exchange online, Office 365, Powershell  
        
            
        
    
                        
                    
                    
                
        
                
	
		
		Добавить комментарий Отменить ответВаш адрес email не будет опубликован. Обязательные поля помечены *Комментарий * Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
	
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
			
        
        
		
        
           
    
    
  
	
    
		
        
             
			
                
                    
                                                  Все права защищены. IT Traveler 2025 
                         
                        
																														                    
                    
				
                
                
    
			
		                            
	
	
                
                
			
                
		
        
	
    
jQuery(document).ready(function($){
  $("a[rel*=lightbox]").colorbox({initialWidth:"30%",initialHeight:"30%",maxWidth:"90%",maxHeight:"90%",opacity:0.8,current:" {current}  {total}",previous:"",close:"Закрыть"});
});
  
    (function (d, w, c) {
        (w[c] = w[c] || []).push(function() {
            try {
                w.yaCounter27780774 = new Ya.Metrika({
                    id:27780774,
                    clickmap:true,
                    trackLinks:true,
                    accurateTrackBounce:true,
                    webvisor:true,
                    trackHash:true
                });
            } catch(e) { }
        });
        var n = d.getElementsByTagName("script")[0],
            s = d.createElement("script"),
            f = function () { n.parentNode.insertBefore(s, n); };
        s.type = "text/javascript";
        s.async = true;
        s.src = "https://mc.yandex.ru/metrika/watch.js";
        if (w.opera == "[object Opera]") {
            d.addEventListener("DOMContentLoaded", f, false);
        } else { f(); }
    })(document, window, "yandex_metrika_callbacks");
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-58126221-1', 'auto');
  ga('send', 'pageview');
