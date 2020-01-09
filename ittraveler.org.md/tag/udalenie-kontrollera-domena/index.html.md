#  Удаляем неисправный контроллер домена при помощи утилиты NTDSUTIL   
***Нередки ситуации, когда системному администратору приходится вручную удалять контроллер домена из Active Directory. Такие ситуации возникают при физическом выходе из строя севера с ролью контроллера домена или другой нештатной ситуации. Естественно, наиболее предпочтительно удалить контроллер домена при помощи команды DCPROMO (подробно DCPROMO и ее параметрах) Однако, что же делать, если контроллер домена недоступен (выключен, сломался, недоступен по сети)? [...] ***

 30.12.2014 
 Active Directory, Windows, Windows Server 
        
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
