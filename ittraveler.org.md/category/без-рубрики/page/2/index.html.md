#  Изменение Hostname в Ubuntu Server 18.04   
***В этой статье я расскажу как изменить Hostname в Ubuntu Server 18.04 , т.к эта процедура немного изменилась. [...] ***

 24.06.2018 
 Linux, Ubuntu, Без рубрики 
        
	
 
 Как узнать WWN (World Wide Name)  в Windows Server 2012R2 
Поскольку в Windows Server 2012 R2 нельзя узнать wwn через Storage explorer, я покажу новый, простой способ как это сделать. [...] 
 24.06.2018 
 PowerShell, Windows, Windows Server, Без рубрики 
        
	
 
 Установка и настройка хостинг панели VestaCP c поддержкой разных версий PHP 
В этой статье мы установим хостинг панель VestaCP и добавим в нее поддержку разных версий PHP
 [...] 
 24.06.2018 
 Cloud, Ubuntu, Web, Web/Cloud, Без рубрики 
        
	
 
 Установка и настройка Scale-Out File Server + Storage Spaces Direct 
В рамках этой статьи мы настроим отказоустойчивый файловый кластер, данные которого будут находится на пуле Storage Spaces direct.
Итак, нам понадобится 2-а сервера на базе Windows server 2016 введенные в домен active directory [...] 
 24.06.2018 
 Windows, Windows Server, Без рубрики 
        
	
 
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
        
	
 
 Получаем MD5 файла или переменной в Powershell 
Для сравнения файлов или данных удобно использовать хэш суммы MD5, на днях понадобилось сделать это на Powershell.
Итак, как же это сделать? [...] 
 24.04.2017 
 PowerShell, Windows Server, Без рубрики 
        
	
 
 Настраиваем SFTP chroot на OpenSSH. 
Иногда нужно ограничить пользователя правами только на подключение по SFTP , без возможности выполнения команд на сервере.
Давайте рассмотрим как это сделать. [...] 
 24.04.2017 
 Bash, Linux, Ubuntu, Web/Cloud, Без рубрики 
        
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
                 
« Назад«12  
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
