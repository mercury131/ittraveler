#  Установка и настройка Ansible   
***В данной статье мы рассмотрим как установить Ansible на Ubuntu server 18.04 и настроить playbook с автоматической установкой обновлений на Windows и Ubuntu хосты.***

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
        
	
 
 Получаем MD5 файла или переменной в Powershell 
Для сравнения файлов или данных удобно использовать хэш суммы MD5, на днях понадобилось сделать это на Powershell.
Итак, как же это сделать? [...] 
 24.04.2017 
 PowerShell, Windows Server, Без рубрики 
        
	
 
 Выполняем команды внутри гостевых ОС через PowerCLI 
Порой нужно запустить скрипт на множестве VM, или выполнить одну и туже команду.
Под катом я расскажу как выполнять команды внутри гостевых ОС через PowerCLI [...] 
 22.06.2016 
 PowerShell, Виртуализация 
        
	
 
 Установка и настройка дедупликации  на Windows Server 2012 R2 
В данной статье я расскажу как легко и быстро можно настроить дедупликацию через Powershell. [...] 
 03.06.2016 
 PowerShell, Windows Server 
        
	
 
 Vsphere. Поиск виртуальных машин с толстыми дисками 
Иногда, требуется найти на датасторе виртуальные машины с толстыми дисками.
Это не вызывает проблем, если виртуальных машин немного, но если их тысяча?
Под катом я покажу как через PowerCLI найти машины с толстыми дисками. [...] 
 23.05.2016 
 PowerShell, Виртуализация 
        
	
 
 Обновление Lync 2013 до Skype for Business 
Я думаю многие захотели обновиться с Lync 2013 до Skype for Business. Давайте рассмотрим как это сделать.
 [...] 
 28.08.2015 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Аудит изменений групповых политик через PowerShell 
Если в вашей компании больше чем один системный администратор, то рано или поздно вы столкнетесь с проблемой аудита GPO.
В данной статье мы разберем как получить уведомление на почту об измененных групповых политиках. [...] 
 07.08.2015 
 Active Directory, PowerShell 
        
	
 
 Установка и настройка Lync 2013 
Если вам нужно развернуть в своей инфраструктуре Lync 2013, прошу под кат.
 [...] 
 27.07.2015 
 PowerShell, Windows, Windows Server 
        
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
                 
1234»Вперед »  
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
