#                 	Создание индивидуальных адресных книг в Office 365 и Exchange online                	  
***            ***

			
            
		
    
	
    	  Дата: 30.12.2014 Автор Admin  
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

New-AddressBookPolicy -Name "$ADgroup.Abp" -AddressLists "$ADgroup" -OfflineAddressBook "$ADgroup.Oab" -GlobalAddressList "$ADgroup.gal" -RoomList "$ADgroup.res"

#Set Username Variable
$username=[Environment]::UserName

#Delete Temp file
Remove-Item C:\Users$username\TEMP

#Get Object ID from AD cloud group
Get-MsolGroup | Where-Object {$_.DisplayName -eq "$ADgroup"} | select ObjectId | Out-File -FilePath C:\Users$username\TEMP
$ObjectID=(Get-Content C:\Users$username\TEMP)[3]
echo $ObjectID
#Select New Address Book Policy to users in AD Group
Get-Mailbox -ResultSize unlimited | Where-Object {$_.ExternalDirectoryObjectId -in (Get-MsolGroupMember -GroupObjectId $ObjectID).objectid} | Set-Mailbox -AddressBookPolicy "$ADgroup.Abp"

&nbsp;
Related posts:Переход на репликацию SYSVOL по DFSУстановка и настройка Scale-Out File Server + Storage Spaces DirectСброс пароля администратора Active Directory
        
             Active Directory, Office 365, PowerShell, Windows, Windows Server 
             Метки: Exchange online, Powershell, Адресные книги в Office 365  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
