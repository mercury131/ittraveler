#                 	Аудит DNS серверов на Windows Server 2008 R2 через Powershell                	  
***            ***

			
            
		
    
	
    	  Дата: 27.02.2015 Автор Admin  
	В данной статье я расскажу как с помощью Powershell проводить аудит DNS серверов на Windows Server 2008 R2.
В средних и крупных организациях, где более одного системного администратора, важно контролировать изменения DNS. Особенно это актуально для статических записей.
Для реализации данной задачи нам понадобятся 2 Powershell скрипта.
Первый скрипт будет собирать данные по статическим записям DNS, и хранить их 2-е недели.
Выглядеть он будет так:
# Указываем сервер DNS
$ServerName = "DC.domain.local"

# Указываем DNS зоны
$ContainerName = "domain.local"
$ContainerName1 = "dev.local"
$ContainerName2 = "domain.com"
$ContainerName3 = "site.ru"

# Указываем путь где будем хранить данные
$comparaPath1 = "C:\Powershell_Scripts\DNS-DHCP-Compare\DNScomp.txt"

Remove-Item $comparaPath1

# Получаем данные через WMI и сохраняем
Get-WMIObject -Computer $ServerName -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" ` -Filter "ContainerName='$ContainerName' AND TimeStamp=0" | Select-Object OwnerName,IPAddress, @{n="TimeStamp";e={"Static"}} | ft -AutoSize &gt; $comparaPath1
Get-WMIObject -Computer $ServerName -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" ` -Filter "ContainerName='$ContainerName1' AND TimeStamp=0" | Select-Object OwnerName,IPAddress, @{n="TimeStamp";e={"Static"}} | ft -AutoSize &gt;&gt; $comparaPath1
Get-WMIObject -Computer $ServerName -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" ` -Filter "ContainerName='$ContainerName2' AND TimeStamp=0" | Select-Object OwnerName,IPAddress, @{n="TimeStamp";e={"Static"}} | ft -AutoSize &gt;&gt; $comparaPath1
Get-WMIObject -Computer $ServerName -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" ` -Filter "ContainerName='$ContainerName3' AND TimeStamp=0" | Select-Object OwnerName,IPAddress, @{n="TimeStamp";e={"Static"}} | ft -AutoSize &gt;&gt; $comparaPath1

# Пример какие еще типы записей можно использовать
&lt;# other records types are:
MicrosoftDNS_AType – Address or Host records
MicrosoftDNS_CNAMEType – Alias records
MicrosoftDNS_MXType – Mail Exchanger records
MicrosoftDNS_NSType – Name Server records
MicrosoftDNS_SRVType – Service records
MicrosoftDNS_PTRType – Pointer records (Reverse Lookup zone)
#&gt;
Теперь нам понадобится второй скрипт, который будет сравнивать данные и показывать изменения в статических записях DNS. Выполняться скрипт будет каждую неделю.
Скрипт будет выглядеть так:

# Указываем сервер DNS
$ServerName = "DC.domain.local"

# Указываем DNS зоны
$ContainerName = "domain.local"
$ContainerName1 = "dev.local"
$ContainerName2 = "domain.com"
$ContainerName3 = "site.ru"

# Указываем пути где будем хранить данные
$comparaPath1 = "C:\Powershell_Scripts\DNS-DHCP-Compare\DNScomp.txt"
$comparaPath2 = "C:\Powershell_Scripts\DNS-DHCP-Compare\DNScomp1.txt"

$Outcompare = "C:\Powershell_Scripts\DNS-DHCP-Compare"
$DnsLog = "C:\Powershell_Scripts\DNS-DHCP-Compare\DNS_LOG.txt"

Remove-Item $comparaPath2

Remove-Item $DnsLog

# Получаем данные через WMI и сохраняем
Get-WMIObject -Computer $ServerName -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" ` -Filter "ContainerName='$ContainerName' AND TimeStamp=0" | Select-Object OwnerName,IPAddress, @{n="TimeStamp";e={"Static"}} | ft -AutoSize &gt; $comparaPath2
Get-WMIObject -Computer $ServerName -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" ` -Filter "ContainerName='$ContainerName1' AND TimeStamp=0" | Select-Object OwnerName,IPAddress, @{n="TimeStamp";e={"Static"}} | ft -AutoSize &gt;&gt; $comparaPath2
Get-WMIObject -Computer $ServerName -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" ` -Filter "ContainerName='$ContainerName2' AND TimeStamp=0" | Select-Object OwnerName,IPAddress, @{n="TimeStamp";e={"Static"}} | ft -AutoSize &gt;&gt; $comparaPath2
Get-WMIObject -Computer $ServerName -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_AType" ` -Filter "ContainerName='$ContainerName3' AND TimeStamp=0" | Select-Object OwnerName,IPAddress, @{n="TimeStamp";e={"Static"}} | ft -AutoSize &gt;&gt; $comparaPath2

#Сохраняем конфиги в переменные
$conf1 = get-content  $comparaPath1

$conf2 = get-content  $comparaPath2

# устанавливаем дату
$Date = (Get-Date -format "MM-dd-yyyy")

Remove-Item $Outcompare\DNS-Report-$Date.txt

# Сравниваем данные из первого скрипта с данными второго
Compare-Object $conf1 $conf2 -IncludeEqual | sort SideIndicator -Descending | ft -AutoSize &gt;$Outcompare\DNS-Report-$Date.txt

# Получаем лог последней автоматической очистки DNS
Get-EventLog -ComputerName DC 'DNS Server' -Newest 10 | Where-Object {$_.eventid -eq 2501} | ft Message -AutoSize -Wrap &gt; $DnsLog
Get-EventLog -ComputerName DC 'DNS Server' -Newest 10 | Where-Object {$_.eventid -eq 2501} | ft @{Name='Время последнего запуска'; e={ ($_.TimeGenerated)}} -AutoSize -Wrap &gt;&gt; $DnsLog

# Пишем дополнительную строку в лог
echo 'Отчет по изменениям в DNS во вложенном файле' &gt;&gt; $DnsLog

# формируем строки для тела письма
get-content $DnsLog | select -Skip 1 | set-content "$DnsLog-temp"
move "$DnsLog-temp" $DnsLog -Force

get-content $DnsLog | select -Skip 1 | set-content "$DnsLog-temp"
move "$DnsLog-temp" $DnsLog -Force

get-content $DnsLog | select -Skip 1 | set-content "$DnsLog-temp"
move "$DnsLog-temp" $DnsLog -Force

# Создаем тело письма

$body1 = Get-Content $DnsLog | Out-String

# Отправляем уведомление на Email
Send-MailMessage -From admin@domain.local -To sysadminmail@domain.local -Attachments $Outcompare\DNS-Report-$Date.txt -Subject "Отчет по DNS серверам"  -Encoding ([System.Text.Encoding]::UTF8) -Body $body1  -SmtpServer mailserver.domain.local

Remove-Item $Outcompare\DNS-Report-$Date.txt
Теперь осталось добавить эти 2 скрипта в планировщик задач.
Соответственно первый скрипт выполняется раз в 2-е недели, а второй каждую неделю.
Второй скрипт будет отправлять уведомление на email со следующим содержанием:
Тема письма &#8212; Отчет по DNS серверам
Тело письма (пример) :
DNS-сервер завершил цикл очистки.
 Просмотрено зон = 31,
 Просмотрено узлов = 1395,
 Очищено узлов = 0,
 Очищено записей = 0.
Цикл продолжался 0 секунд.
Следующий цикл очистки запланирован через 168 часов.
Если при выполнении цикла очистки произошла ошибка, код ошибки содержится в дан
 ных события.
 DNS-сервер завершил цикл очистки.
 Просмотрено зон = 31,
 Просмотрено узлов = 1395,
 Очищено узлов = 1,
 Очищено записей = 1.
Цикл продолжался 0 секунд.
Следующий цикл очистки запланирован через 168 часов.
Если при выполнении цикла очистки произошла ошибка, код ошибки содержится в дан
 ных события.
 DNS-сервер завершил цикл очистки.
 Просмотрено зон = 31,
 Просмотрено узлов = 1393,
 Очищено узлов = 0,
 Очищено записей = 0.
Цикл продолжался 0 секунд.
Следующий цикл очистки запланирован через 168 часов.
Если при выполнении цикла очистки произошла ошибка, код ошибки содержится в дан
 ных события.
 DNS-сервер завершил цикл очистки.
 Просмотрено зон = 31,
 Просмотрено узлов = 1385,
 Очищено узлов = 3,
 Очищено записей = 3.
Цикл продолжался 0 секунд.
Следующий цикл очистки запланирован через 168 часов.
Если при выполнении цикла очистки произошла ошибка, код ошибки содержится в дан
 ных события.
 DNS-сервер завершил цикл очистки.
 Просмотрено зон = 30,
 Просмотрено узлов = 1420,
 Очищено узлов = 0,
 Очищено записей = 0.
Цикл продолжался 0 секунд.
Следующий цикл очистки запланирован через 168 часов.
Если при выполнении цикла очистки произошла ошибка, код ошибки содержится в дан
 ных события.
Время последнего запуска
 &#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;
 19.02.2015 23:01:53
 12.02.2015 23:00:26
 05.02.2015 22:59:17
 29.01.2015 22:57:54
 22.01.2015 22:57:14
Отчет по изменениям в DNS во вложенном файле
&nbsp;
Во вложении будет файл со следующим содержимым:
InputObject SideIndicator
----------- -------------
site1.local     10.13.1.1 Static =&gt;
site1.dev.local 10.14.1.1 Static ==
site1.ru        10.12.1.1 Static &lt;=
Знак =&gt; означает что запись была добавлена.
Знак &lt;= означает что запись была удалена.
На этом все. Желаю удачной настройки! =)
&nbsp;
Related posts:Сброс настроек GPO на стандартныеПеренос виртуальной машины из Hyper-V в Proxmox (KVM)Добавление почтовых контактов в Office 365 через Powershell и CSV
        
             Active Directory, PowerShell, Windows, Windows Server 
             Метки: DNS, Powershell  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
