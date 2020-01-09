#  Оптимизация изображений на веб сервере   
***Если вы или ваши пользователи загружают изображения на ваш сайт, то рано или поздно они начнут занимать неприлично много места.***

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
        
	
 
 Установка и настройка Sphinx 
Относительно недавно, мне было нужно настроить sphinxsearch для одного проекта на Bitrix. Поэтому в этой статье я  поделюсь с вами информацией как просто это сделать. И так, Sphinx (англ. SQL Phrase Index) — система полнотекстового поиска, разработанная Андреем Аксёновым и распространяемая по лицензии GNU GPL. Отличительной особенностью является высокая скорость индексации и поиска, а также [...] 
 23.04.2017 
 Bash, Cloud, Linux, Web/Cloud 
        
	
 
 Выполняем команды внутри гостевых ОС через PowerCLI 
Порой нужно запустить скрипт на множестве VM, или выполнить одну и туже команду.
Под катом я расскажу как выполнять команды внутри гостевых ОС через PowerCLI [...] 
 22.06.2016 
 PowerShell, Виртуализация 
        
	
 
 Установка и настройка дедупликации  на Windows Server 2012 R2 
В данной статье я расскажу как легко и быстро можно настроить дедупликацию через Powershell. [...] 
 03.06.2016 
 PowerShell, Windows Server 
        
Поиск
Найти:
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
Реклама			
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-1890562251101921"
data-ad-slot="9117958896"
data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Облако тегов
Active Directory
adrestore
Apache2
Cisco
Cluster
DNS
Exchange
Exchange online
File-Server
Get-ADObject
GLPI
GPO
ldp.exe
Linix
Linux
LVM
Lync
MSSQL
Mysql
Nginx
NTDSUTIL
Office 365
openssh
powercli
Powershell
proxmox
Puppet
ssh
Ubuntu
UPN
vmware
vsphere
webserver
Windows Server
XenServer
Аудит
Блокировка учетной записи
Виртуализация
Обновление схемы
Прокси
Резервное копирование
Репликация
веб сервера
восстановление удаленных данных
удаление контроллера домена
            
« Назад«123456&hellip;13»Вперед »  
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
