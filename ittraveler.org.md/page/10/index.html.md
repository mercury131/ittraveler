#  Настройка сети в организации. Часть 2   
***В данной статье мы продолжим настройку нашей сети. В этом выпуске мы настроим: DHCP, ACL и добавим сеть WIFI. [...] ***

 23.01.2015 
 Cisco, Сети 
        
	
 
 Настройка сети в организации. Часть 1. 
В данном цикле статей, я расскажу как настроить сеть на оборудовании Cisco в средней организации.
Давайте рассмотрим пример, у нас средняя компания, человек на 100-500. Что нам нужно?
Настроить маршрутизаторы и коммутаторы, VLAN, разделить сети, настроить туннель VPN между филиалами, DHCP, ACL, NAT, подключиться к ISP провайдеру, изолировать некоторые сети (DMZ), маршрутизацию (Static, OSPF, ERGRP), агрегацию каналов (Etherchannel). [...] 
 21.01.2015 
 Cisco, Сети 
        
	
 
 Автоматическая активация пользователей Lync через Powershell 
В данной статье я расскажу как сделать автоматическую активацию пользователей Lync через Powershell.  [...] 
 13.01.2015 
 PowerShell, Windows 
        
	
 
 Поиск старых почтовых ящиков в Exchange 2010 
В данной статье я расскажу как с помощью Powershell найти старые почтовые ящики Exchange и отправить уведомление на Email. [...] 
 31.12.2014 
 Active Directory, Exchange, PowerShell 
        
	
 
 Экспорт почтовых ящиков Exchange 2010 через Powershell и PST 
В данной статье я расскажу как с помощью скрипта экспортировать несколько почтовых ящиков в PST.
 [...] 
 31.12.2014 
 Exchange, PowerShell, Windows, Windows Server 
        
	
 
 Автоматизация создания адресных книг в Office 365 через Powershell Часть 3. 
В данной статья я расскажу как автоматизировать процесс добавления новых пользователей в политику адресных книг Office 365.
 [...] 
 31.12.2014 
 Active Directory, Exchange, Office 365, PowerShell, Windows, Windows Server 
        
	
 
 Автоматизация создания адресных книг в Office 365 через Powershell Часть 2 
В данной статье мы рассмотрим как удалять неактуальные адресные книги в Office 365.
 [...] 
 31.12.2014 
 Active Directory, Exchange, Office 365, PowerShell 
        
	
 
 Автоматизация создания адресных книг в Office 365 через Powershell Часть 1. 
В данном цикле статей я покажу как автоматизировать процесс создания, удаления, актуализации адресных книг в Office 365.
Имеем следующую схему:
1) Пользователи синхронизируются из локальной AD, каждый пользователь находится в своей OU с названием его компании, и состоит в 2-х группах (по 2-е группы на каждую компанию)
2) Нам нужно автоматизировать процесс создания индивидуальных адресных книг для каждой компании (OU).
 [...] 
 31.12.2014 
 Active Directory, Office 365, PowerShell 
        
	
 
 Добавление почтовых контактов в Office 365 через Powershell и CSV 
Если вам нужно добавить большое кол-во почтовых контактов в Office 365 или Exchange Online, да еще и в группу рассылки их включить, прошу под кат) [...] 
 30.12.2014 
 Exchange, Office 365, PowerShell, Windows, Windows Server 
        
	
 
 Автоматическая активация лицензий Office 365 
Если вам нужно автоматически активировать лицензии пользователей Office 365, то данный скрипт будет вам полезен. [...] 
 30.12.2014 
 Office 365, PowerShell 
        
Поиск
Найти:
Рубрики		
Active Directory
Asterisk
Bash
Cisco
Cloud
Debian
Exchange
GLPI Service Desk
Linux
Office 365
PowerShell
Puppet
Ubuntu
Web
Web/Cloud
Windows
Windows Server
Без рубрики
Виртуализация
Сети
Реклама			
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-1890562251101921"
data-ad-slot="9117958896"
data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Облако тегов
Active Directory
adrestore
Apache2
Cisco
Cluster
DNS
Exchange
Exchange online
File-Server
Get-ADObject
GLPI
GPO
ldp.exe
Linix
Linux
LVM
Lync
MSSQL
Mysql
Nginx
NTDSUTIL
Office 365
openssh
powercli
Powershell
proxmox
Puppet
ssh
Ubuntu
UPN
vmware
vsphere
webserver
Windows Server
XenServer
Аудит
Блокировка учетной записи
Виртуализация
Обновление схемы
Прокси
Резервное копирование
Репликация
веб сервера
восстановление удаленных данных
удаление контроллера домена
            
« Назад«1&hellip;8910111213»Вперед »  
Все права защищены. IT Traveler 2019 
                            
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
