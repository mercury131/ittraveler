#  QEMU/KVM проброс физического диска гипевизора в виртуальную машину   
***В этой статье мы рассмотрим как пробросить физический диск в VM. [...] ***

 15.09.2019 
 Linux, Виртуализация 
        
	
 
 KVM восстановление qcow2 диска 
В данной статье я расскажу как можно восстановить поврежденный диск VM в формате qcow2 [...] 
 15.09.2019 
 Linux, Виртуализация 
        
	
 
 Кастомизация гостевых ОС Windows в KVM на примере Proxmox 
В VMware Vsphere есть удобный механизм кастомизации ОС при деплое - OS Customization 
С помощью него можно например ввести виртуальную машину в домен или запустить скрипты после деплоя.
Это очень удобно, особенно при развертывании сотни виртуальных машин. Похожий механизм захотелось иметь и в KVM.
В этой статье мы рассмотрим как обеспечить похожий функционал на примере Proxmox и шаблона Windows [...] 
 22.03.2019 
 Bash, Debian, Windows, Windows Server, Без рубрики, Виртуализация 
        
	
 
 Запуск команд внутри гостевых ОС в гипервизоре KVM на примере Proxmox 
В VMware, с помощью Powercli, есть возможность запускать команды внутри гостевых ОС с помощью командлета Invoke-VMScript , это очень удобно, ведь с помощью этого механизма можно выполнить необходимые команды на сотне VM, не открывая на них консоль. Работая с KVM мне захотелось найти аналог данного механизма, чтобы запускать команды из консоли гипервизора порямо на гостевых [...] 
 18.03.2019 
 Bash, Debian, Linux, Без рубрики, Виртуализация 
        
	
 
 Перенос виртуальной машины из Hyper-V в Proxmox (KVM) 
В данной статье мы рассмотрим как можно перенести виртуальную машину из Hyper-V в Proxmox (KVM).
 [...] 
 01.12.2018 
 Linux, Windows, Без рубрики, Виртуализация 
        
	
 
 Настройка ZFS в Proxmox 
В этой статье мы рассмотрим как создать ZFS разделы и подключить их как хранилища виртуальных машин в Proxmox .
 [...] 
 29.07.2018 
 Bash, Debian, Linux, Ubuntu, Виртуализация 
        
	
 
 Выполняем команды внутри гостевых ОС через PowerCLI 
Порой нужно запустить скрипт на множестве VM, или выполнить одну и туже команду.
Под катом я расскажу как выполнять команды внутри гостевых ОС через PowerCLI [...] 
 22.06.2016 
 PowerShell, Виртуализация 
        
	
 
 Vsphere. Поиск виртуальных машин с толстыми дисками 
Иногда, требуется найти на датасторе виртуальные машины с толстыми дисками.
Это не вызывает проблем, если виртуальных машин немного, но если их тысяча?
Под катом я покажу как через PowerCLI найти машины с толстыми дисками. [...] 
 23.05.2016 
 PowerShell, Виртуализация 
        
	
 
 Установка и настройка Citrix XenServer Часть 4. 
В данной статье мы рассмотрим автозапуск виртуальных машин и создание локальных хранилищ.
 [...] 
 27.05.2015 
 Виртуализация 
        
	
 
 Установка и настройка Citrix XenServer Часть 3. 
В данной статье мы рассмотрим настройку резервного копирования хостов Xen и запущенных виртуальных машин.
 [...] 
 26.05.2015 
 Виртуализация 
        
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
