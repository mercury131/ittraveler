#  Установка и настройка Ansible   
***В данной статье мы рассмотрим как установить Ansible на Ubuntu server 18.04 и настроить playbook с автоматической установкой обновлений на Windows и Ubuntu хосты.***

Также рассмотрим простой пример как поднять веб сервер с nginx,php7,mysql и поднять роли iis, fileserver на Windows хостах с помощью playbook Ansible. [...] 
 27.07.2018 
 Bash, Linux, PowerShell, Ubuntu, Web, Web/Cloud, Windows, Windows Server 
        
	
 
 Настройка работы прокси сервера SQUID через сторонний прокси сервер. 
Иногда в тестовых средах вы по каким-то причинам не можете использовать прокси сервер с авторизацией по логину и паролю, и прямого доступа в интернет у вас нет.
В таком случае вам поможет промежуточный прокси сервер на базе Squid, который будет использовать основной прокси сервер для доступа в интернет.
Далее я расскажу как все это настроить. [...] 
 25.06.2018 
 Ubuntu, Сети 
        
	
 
 Изменение Hostname в Ubuntu Server 18.04 
В этой статье я расскажу как изменить Hostname в Ubuntu Server 18.04 , т.к эта процедура немного изменилась. [...] 
 24.06.2018 
 Linux, Ubuntu, Без рубрики 
        
	
 
 Установка и настройка memcache 
Давайте рассмотрим настройку memcached на примере связки memcached + PHP7. [...] 
 12.05.2017 
 Bash, Debian, Linux, Ubuntu, Web/Cloud 
        
	
 
 Настраиваем оповещение при подключении по SSH. 
Бывает полезно знать кто и когда подключился к серверу по ssh, особенно если этот сервер в публичном облаке и смотрит в интернет.
В данной заметке я расскажу как это настроить в openssh server. [...] 
 05.05.2017 
 Bash, Linux, Web/Cloud, Без рубрики 
        
	
 
 Настраиваем аудит сервера Ubuntu через AIDE 
Думаю многим из вас приходила в голову мысль что было бы неплохо вести аудит изменений на сервере, особенно если например это vps в облаке.  [...] 
 05.05.2017 
 Bash, Cloud, Debian, Linux, Ubuntu, Web, Web/Cloud, Без рубрики 
        
	
 
 Настраиваем SFTP chroot на OpenSSH. 
Иногда нужно ограничить пользователя правами только на подключение по SFTP , без возможности выполнения команд на сервере.
Давайте рассмотрим как это сделать. [...] 
 24.04.2017 
 Bash, Linux, Ubuntu, Web/Cloud, Без рубрики 
        
	
 
 Установка и настройка Sphinx 
Относительно недавно, мне было нужно настроить sphinxsearch для одного проекта на Bitrix. Поэтому в этой статье я  поделюсь с вами информацией как просто это сделать. И так, Sphinx (англ. SQL Phrase Index) — система полнотекстового поиска, разработанная Андреем Аксёновым и распространяемая по лицензии GNU GPL. Отличительной особенностью является высокая скорость индексации и поиска, а также [...] 
 23.04.2017 
 Bash, Cloud, Linux, Web/Cloud 
        
	
 
 Установка и настройка сервера Git 
В данной статье мы рассмотрим как установить свой сервер git на ubuntu. [...] 
 15.05.2016 
 Linux, Web, Web/Cloud 
        
	
 
 Настройка дисковых квот в Ubuntu 
Если вам нужно настроить дисковые квоты для пользователей прошу под кат)
 [...] 
 14.10.2015 
 Bash, Linux, Ubuntu 
        
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
Ноябрь 2019
Пн
Вт
Ср
Чт
Пт
Сб
Вс
&laquo; Окт
&nbsp;
&nbsp;
&nbsp;123
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
                 
12»Вперед »  
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
