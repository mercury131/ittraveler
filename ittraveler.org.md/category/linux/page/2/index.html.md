#  Настройка ZFS в Proxmox   
***В этой статье мы рассмотрим как создать ZFS разделы и подключить их как хранилища виртуальных машин в Proxmox .***

 [...] 
 29.07.2018 
 Bash, Debian, Linux, Ubuntu, Виртуализация 
        
	
 
 Установка и настройка Ansible 
В данной статье мы рассмотрим как установить Ansible на Ubuntu server 18.04 и настроить playbook с автоматической установкой обновлений на Windows и Ubuntu хосты.
Также рассмотрим простой пример как поднять веб сервер с nginx,php7,mysql и поднять роли iis, fileserver на Windows хостах с помощью playbook Ansible. [...] 
 27.07.2018 
 Bash, Linux, PowerShell, Ubuntu, Web, Web/Cloud, Windows, Windows Server 
        
	
 
 Балансировка нагрузки веб серверов IIS с Windows аутентификацией через Haproxy 
На днях понадобилось настроить балансировку нагрузки между двумя серверами IIS с Windows аутентификацией.
Думал использовать привычный nginx для этих целей, но оказалось из коробки этот функционал доступен только в редакции Nginx Plus.
Ну ничего страшного, тут нас выручит не менее крутой Haproxy =) [...] 
 04.07.2018 
 Cloud, Linux, Ubuntu, Web, Web/Cloud 
        
	
 
 Изменение Hostname в Ubuntu Server 18.04 
В этой статье я расскажу как изменить Hostname в Ubuntu Server 18.04 , т.к эта процедура немного изменилась. [...] 
 24.06.2018 
 Linux, Ubuntu, Без рубрики 
        
	
 
 Установка и настройка memcache 
Давайте рассмотрим настройку memcached на примере связки memcached + PHP7. [...] 
 12.05.2017 
 Bash, Debian, Linux, Ubuntu, Web/Cloud 
        
	
 
 Оптимизация изображений на веб сервере 
Если вы или ваши пользователи загружают изображения на ваш сайт, то рано или поздно они начнут занимать неприлично много места.
В данной статье я расскажу как оптимизировать все jpg и png изображения на вашем веб сервере.  [...] 
 12.05.2017 
 Bash, Linux, Ubuntu, Web, Web/Cloud 
        
	
 
 Мониторинг срока действия сертификатов Lets Encrypt 
Я думаю многие из вас пользуются бесплатными сертификатами Lets Encrypt, но многие ли мониторят срок их действия?
Подкатом я покажу простой bash скрипт, который будет заниматься мониторингом сроков действия сертификатов. [...] 
 05.05.2017 
 Bash, Linux, Web, Web/Cloud, Без рубрики 
        
	
 
 Настраиваем оповещение при подключении по SSH. 
Бывает полезно знать кто и когда подключился к серверу по ssh, особенно если этот сервер в публичном облаке и смотрит в интернет.
В данной заметке я расскажу как это настроить в openssh server. [...] 
 05.05.2017 
 Bash, Linux, Web/Cloud, Без рубрики 
        
	
 
 Настройка отправки PHP Mail через Gmail 
Если вам нужно отправлять почту через функцию php mail через внешний почтовый сервер, прошу подкат. [...] 
 05.05.2017 
 Bash, Linux, Web, Web/Cloud, Без рубрики 
        
	
 
 Настраиваем аудит сервера Ubuntu через AIDE 
Думаю многим из вас приходила в голову мысль что было бы неплохо вести аудит изменений на сервере, особенно если например это vps в облаке.  [...] 
 05.05.2017 
 Bash, Cloud, Debian, Linux, Ubuntu, Web, Web/Cloud, Без рубрики 
        
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
