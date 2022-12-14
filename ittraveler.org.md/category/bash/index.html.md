#  Установка и настройка Kafka кластера   
***В данной статье рассмотрим как настроить kafka кластер из 3-х серверов с поддержкой ssl. [...] ***

 28.10.2019 
 Bash, Debian, Linux 
        
	
 
 Кастомизация гостевых ОС Windows в KVM на примере Proxmox 
В VMware Vsphere есть удобный механизм кастомизации ОС при деплое - OS Customization 
С помощью него можно например ввести виртуальную машину в домен или запустить скрипты после деплоя.
Это очень удобно, особенно при развертывании сотни виртуальных машин. Похожий механизм захотелось иметь и в KVM.
В этой статье мы рассмотрим как обеспечить похожий функционал на примере Proxmox и шаблона Windows [...] 
 22.03.2019 
 Bash, Debian, Windows, Windows Server, Без рубрики, Виртуализация 
        
	
 
 Clickhouse ошибка DB::Exception: Replica already exists.. 
При моргании сети или при длительной недоступности одной из реплик clickhouse - возможно ее повреждение.
В таком случае сервер может не стартовать службу clickhouse и при попытке пересоздания реплицируемой таблицы вы получите ошибку 253 Replica already exists..
 [...] 
 19.03.2019 
 Bash, Debian, Без рубрики 
        
	
 
 Запуск команд внутри гостевых ОС в гипервизоре KVM на примере Proxmox 
В VMware, с помощью Powercli, есть возможность запускать команды внутри гостевых ОС с помощью командлета Invoke-VMScript , это очень удобно, ведь с помощью этого механизма можно выполнить необходимые команды на сотне VM, не открывая на них консоль. Работая с KVM мне захотелось найти аналог данного механизма, чтобы запускать команды из консоли гипервизора порямо на гостевых [...] 
 18.03.2019 
 Bash, Debian, Linux, Без рубрики, Виртуализация 
        
	
 
 Установка и настройка Foreman + Puppet 
В данной статье мы рассмотрим как установить и настроить связку foreman + puppet, для  удобного управления конфигурациями [...] 
 03.08.2018 
 Bash, Debian, Linux, Puppet, Ubuntu, Web/Cloud 
        
	
 
 Настройка ZFS в Proxmox 
В этой статье мы рассмотрим как создать ZFS разделы и подключить их как хранилища виртуальных машин в Proxmox .
 [...] 
 29.07.2018 
 Bash, Debian, Linux, Ubuntu, Виртуализация 
        
	
 
 Установка и настройка Ansible 
В данной статье мы рассмотрим как установить Ansible на Ubuntu server 18.04 и настроить playbook с автоматической установкой обновлений на Windows и Ubuntu хосты.
Также рассмотрим простой пример как поднять веб сервер с nginx,php7,mysql и поднять роли iis, fileserver на Windows хостах с помощью playbook Ansible. [...] 
 27.07.2018 
 Bash, Linux, PowerShell, Ubuntu, Web, Web/Cloud, Windows, Windows Server 
        
	
 
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
                 
12»Вперед »  
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
