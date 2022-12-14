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
        
	
 
 Кастомизация гостевых ОС Windows в KVM на примере Proxmox 
В VMware Vsphere есть удобный механизм кастомизации ОС при деплое - OS Customization 
С помощью него можно например ввести виртуальную машину в домен или запустить скрипты после деплоя.
Это очень удобно, особенно при развертывании сотни виртуальных машин. Похожий механизм захотелось иметь и в KVM.
В этой статье мы рассмотрим как обеспечить похожий функционал на примере Proxmox и шаблона Windows [...] 
 22.03.2019 
 Bash, Debian, Windows, Windows Server, Без рубрики, Виртуализация 
        
	
 
 Новые компьютеры не появляются на WSUS сервере 
Если вы используете различные инструменты деплоя ОС из образов или имеете большое количество виртуальных машин, то наверняка замечали что далеко не все развернутые ОС отправляют отчет на сервер WSUS или вообще пропадают с сервера.
В этой статье я расскажу почему так происходит и как с этим бороться [...] 
 17.08.2018 
 Active Directory, Windows Server 
        
	
 
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
        
	
 
 Установка и настройка Scale-Out File Server + Storage Spaces Direct 
В рамках этой статьи мы настроим отказоустойчивый файловый кластер, данные которого будут находится на пуле Storage Spaces direct.
Итак, нам понадобится 2-а сервера на базе Windows server 2016 введенные в домен active directory [...] 
 24.06.2018 
 Windows, Windows Server, Без рубрики 
        
	
 
 Сброс настроек GPO на стандартные 
Иногда, после вывода машины из домена Active Directory нужно сбросить все примененные ранее настройки GPO на стандартные. Давайте рассмотрим на примере Windows 10 как легко это сделать. [...] 
 12.05.2017 
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
                 
123&hellip;5»Вперед »  
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
