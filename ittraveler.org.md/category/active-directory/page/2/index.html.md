#  Аудит DNS серверов на Windows Server 2008 R2 через Powershell   
***В данной статье я расскажу как с помощью Powershell проводить аудит DNS серверов на Windows Server 2008 R2. [...] ***

 27.02.2015 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Настройка Kerberos авторизации в Apache2 
В данной статье мы рассмотрим настройку автоматической Kerberos авторизации в Apache2.  [...] 
 20.02.2015 
 Active Directory, Web, Web/Cloud 
        
	
 
 Настройка отказоустойчивого файлового сервера на Windows Server 2012 R2 
В данной статье я расскажу как настроить отказоустойчивый файловый сервер на Windows Server 2012 R2 в домене Active Directory  [...] 
 06.02.2015 
 Active Directory, Windows, Windows Server 
        
	
 
 Поиск старых почтовых ящиков в Exchange 2010 
В данной статье я расскажу как с помощью Powershell найти старые почтовые ящики Exchange и отправить уведомление на Email. [...] 
 31.12.2014 
 Active Directory, Exchange, PowerShell 
        
	
 
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
        
	
 
 Создание индивидуальных адресных книг в Office 365 и Exchange online 
Один раз мне поставили задачу разграничить адресные книги пользователям Office 365.
Смысл был в том, что каждый пользователь должен видеть только адресную книгу своей компании, чужих пользователей и их адресные книги он видеть не должен.
В моем случае пользователи синхронизировались из локальной Active Directory в Office 365, поэтому было решено фильтровать пользователей по группам AD, и с помощью групп разграничивать адресные книги.
Далее скрипт как это сделать. [...] 
 30.12.2014 
 Active Directory, Office 365, PowerShell, Windows, Windows Server 
        
	
 
 Создание пользователей Active Directory через CSV файл 
Иногда бывает нужно создать в Active Directory кучу пользователей.
Создавать все это добро вручную долго и муторно, а если для каждой группы пользователей нужна своя OU? Или названия компаний для каждого свое?
Ниже я покажу скрипт, который создает пользователей из CSV файла.
Алгоритм следующий:
1) Создаем OU с названием компании пользователя [...] 
 30.12.2014 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Принудительная синхронизация Office 365 и локальной Active Directory 
Для принудительной синхронизации Office 365 и локальной Active Directory мы будем использовать Powershell.
Открываем Powershell от имени администратора, и вводим следующие команды: [...] 
 30.12.2014 
 Active Directory, Office 365, PowerShell, Windows, Windows Server 
        
Архивы
Октябрь 2019
Сентябрь 2019
Июнь 2019
Март 2019
Декабрь 2018
Август 2018
Июль 2018
Июнь 2018
Май 2017
Апрель 2017
Июнь 2016
Май 2016
Октябрь 2015
Август 2015
Июль 2015
Июнь 2015
Май 2015
Апрель 2015
Март 2015
Февраль 2015
Январь 2015
Декабрь 2014
Календарь
Январь 2022
Пн
Вт
Ср
Чт
Пт
Сб
Вс
&nbsp;12
&nbsp;
&laquo; Окт
&nbsp;
&nbsp;
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
                 
« Назад«1234»Вперед »  
Все права защищены. IT Traveler 2022 
                            
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
