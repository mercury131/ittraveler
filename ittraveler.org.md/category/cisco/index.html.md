#  Настройка сети в организации. Часть 4   
***В этой части статьи мы рассмотрим создание GRE туннеля между офисом нашей компании и дата центром. Создадим инфраструктуру нашего оборудования в ДЦ, перенесем VTP сервер, добавим DMZ сеть и пропишем статические маршруты. [...] ***

 30.01.2015 
 Cisco, Сети 
        
	
 
 Настройка сети в организации. Часть 3 
В данной статье мы рассмотрим подключение к ISP провайдеру и динамическую маршрутизацию. [...] 
 27.01.2015 
 Cisco, Сети 
        
	
 
 Настройка сети в организации. Часть 2 
В данной статье мы продолжим настройку нашей сети. В этом выпуске мы настроим: DHCP, ACL и добавим сеть WIFI. [...] 
 23.01.2015 
 Cisco, Сети 
        
	
 
 Настройка сети в организации. Часть 1. 
В данном цикле статей, я расскажу как настроить сеть на оборудовании Cisco в средней организации.
Давайте рассмотрим пример, у нас средняя компания, человек на 100-500. Что нам нужно?
Настроить маршрутизаторы и коммутаторы, VLAN, разделить сети, настроить туннель VPN между филиалами, DHCP, ACL, NAT, подключиться к ISP провайдеру, изолировать некоторые сети (DMZ), маршрутизацию (Static, OSPF, ERGRP), агрегацию каналов (Etherchannel). [...] 
 21.01.2015 
 Cisco, Сети 
        
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
Октябрь 2019
Пн
Вт
Ср
Чт
Пт
Сб
Вс
&laquo; Сен
&nbsp;
&nbsp;
&nbsp;123456
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