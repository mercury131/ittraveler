#  Установка и настройка Scale-Out File Server + Storage Spaces Direct   
***В рамках этой статьи мы настроим отказоустойчивый файловый кластер, данные которого будут находится на пуле Storage Spaces direct.***

Итак, нам понадобится 2-а сервера на базе Windows server 2016 введенные в домен active directory [...] 
 24.06.2018 
 Windows, Windows Server, Без рубрики 
        
	
 
 Сброс настроек GPO на стандартные 
Иногда, после вывода машины из домена Active Directory нужно сбросить все примененные ранее настройки GPO на стандартные. Давайте рассмотрим на примере Windows 10 как легко это сделать. [...] 
 12.05.2017 
 Windows, Windows Server 
        
	
 
 Обновление Lync 2013 до Skype for Business 
Я думаю многие захотели обновиться с Lync 2013 до Skype for Business. Давайте рассмотрим как это сделать.
 [...] 
 28.08.2015 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Установка и настройка Lync 2013 
Если вам нужно развернуть в своей инфраструктуре Lync 2013, прошу под кат.
 [...] 
 27.07.2015 
 PowerShell, Windows, Windows Server 
        
	
 
 Удаление Lync Server 2013 
Если вам нужно удалить MS Lync 2013 , и почистить инфраструктуру Active Directory от следов Lync 2013, прошу под кат.
 [...] 
 27.07.2015 
 PowerShell, Windows, Windows Server 
        
	
 
 Создание шаблонов Zabbix для Windows. 
Недавно мне понадобилось мониторить некоторые службы и порты на ОС Windows Server 2012 R2 .
Давайте рассмотрим пример как создать шаблон для мониторинга DNS сервиса на Windows. [...] 
 03.07.2015 
 Active Directory, Linux, Windows, Windows Server 
        
	
 
 Автоматический аудит компьютеров в Active Directory через powershell. 
В данной статье мы рассмотрим как автоматически проводить аудит компьютеров в Active Directory.
Я думаю многие системные администраторы ломали голову как вести учет за каким ПК какой пользователь работает, особенно если имена ПК статичны.
Для решения данной проблемы воспользуемся PowerShell. [...] 
 10.06.2015 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Автоматизируем бэкап баз данных MSSQL Express 
В данной статье мы рассмотрим как настроить автоматическое резервное копирование баз данных MSSQL расположенных на бесплатном MSSQL Express. [...] 
 26.05.2015 
 Windows, Windows Server 
        
	
 
 Настройка HA кластера Hyper-V 
В данной статье мы рассмотрим как установить и настроить кластер по отказу (HA) Hyper-v.
 [...] 
 21.05.2015 
 Windows, Windows Server, Виртуализация 
        
	
 
 Установка и настройка кластера MSSQL 2012. 
В данной статье будет рассмотрена установка и настройка кластера MSSQL 2012. [...] 
 20.05.2015 
 Windows, Windows Server 
        
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
Февраль 2024
Пн
Вт
Ср
Чт
Пт
Сб
Вс
&nbsp;1234
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
                 
« Назад«1234&hellip;6»Вперед »  
Все права защищены. IT Traveler 2024 
                            
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
