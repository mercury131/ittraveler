#  Windows WSL подключение к сетевым шарам   
***При использовании Ubuntu через WSL на Windows, столкнулся с тем что подключенные сетевые шары недоступны и отсутствуют в /mnt.***

В этой статье я покажу как просто подключать сетевые шары в WSL. [...] 
 15.09.2019 
 Windows, Windows Server 
        
	
 
 Ошибка Database Mirroring login attempt by user ‘Domain\user.’ failed with error: ‘Connection handshake failed. при настройке AlwaysON 
Иногда при настройке AlwaysOn может возникать ошибка - Database Mirroring login attempt by user ‘Domain\user.’ failed with error: ‘Connection handshake failed. 
В этой статье мы рассмотрим как можно ее исправить.
 [...] 
 12.06.2019 
 Windows, Windows Server, Без рубрики 
        
	
 
 Установка и настройка AlwaysOn на MS SQL 2016 
В данной статье мы рассмотрим установку MS SQL 2016 в режиме AlwaysOn на двух нодах Windows Server 2016 [...] 
 12.06.2019 
 Windows, Windows Server, Без рубрики 
        
	
 
 Установка RSAT на Windows 10 1809 
После обновления рабочей машины до версии Windows 10 1809, обнаружил что для нее нельзя скачать пакет RSAT с сайта Microsoft.
А после обновления версии до 1809 установленный ранее пакет RSAT был удален. В этой заметке я рассказу как быстро вернуть RSAT на место.
 [...] 
 25.03.2019 
 Windows, Без рубрики 
        
	
 
 Ошибка ERR: CERT_COMMON_NAME_INVALID в Chrome при использовании SSL сертификата. 
Недавно столкнулся с проблемой при создании SSL сертификов. Нужно было подписать сертификат на доменном CA для одного хоста, по привычке я воспользовался командой:
[crayon-61f43d443dd7d730811087/]
Но после установки сертификатов обнаружил что Chrome, в отличие от других браузеров не принимает такой сертификат. В этой заметке я расскажу в чем проблема и как ее исправить.
 [...] 
 25.03.2019 
 Active Directory, Windows, Без рубрики 
        
	
 
 Кастомизация гостевых ОС Windows в KVM на примере Proxmox 
В VMware Vsphere есть удобный механизм кастомизации ОС при деплое - OS Customization 
С помощью него можно например ввести виртуальную машину в домен или запустить скрипты после деплоя.
Это очень удобно, особенно при развертывании сотни виртуальных машин. Похожий механизм захотелось иметь и в KVM.
В этой статье мы рассмотрим как обеспечить похожий функционал на примере Proxmox и шаблона Windows [...] 
 22.03.2019 
 Bash, Debian, Windows, Windows Server, Без рубрики, Виртуализация 
        
	
 
 Перенос виртуальной машины из Hyper-V в Proxmox (KVM) 
В данной статье мы рассмотрим как можно перенести виртуальную машину из Hyper-V в Proxmox (KVM).
 [...] 
 01.12.2018 
 Linux, Windows, Без рубрики, Виртуализация 
        
	
 
 Установка и настройка Ansible 
В данной статье мы рассмотрим как установить Ansible на Ubuntu server 18.04 и настроить playbook с автоматической установкой обновлений на Windows и Ubuntu хосты.
Также рассмотрим простой пример как поднять веб сервер с nginx,php7,mysql и поднять роли iis, fileserver на Windows хостах с помощью playbook Ansible. [...] 
 27.07.2018 
 Bash, Linux, PowerShell, Ubuntu, Web, Web/Cloud, Windows, Windows Server 
        
	
 
 Настройка растянутого кластера (stretch-cluster) на Windows server 2016 
В данной статье мы рассмотрим как настроить отказоустойчивый растянутый кластер на базе Windows Server 2016.
В нашем сценарии кластер будет растянут между двумя дата центрами, при этом между хранилищами с помощью технологии storage replica будет настроена репликация данных. [...] 
 06.07.2018 
 PowerShell, Windows, Windows Server, Без рубрики 
        
	
 
 Как узнать WWN (World Wide Name)  в Windows Server 2012R2 
Поскольку в Windows Server 2012 R2 нельзя узнать wwn через Storage explorer, я покажу новый, простой способ как это сделать. [...] 
 24.06.2018 
 PowerShell, Windows, Windows Server, Без рубрики 
        
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
                 
123&hellip;6»Вперед »  
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
