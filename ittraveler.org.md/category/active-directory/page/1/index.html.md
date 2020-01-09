#  Ошибка ERR: CERT_COMMON_NAME_INVALID в Chrome при использовании SSL сертификата.   
***Недавно столкнулся с проблемой при создании SSL сертификов. Нужно было подписать сертификат на доменном CA для одного хоста, по привычке я воспользовался командой:***

[crayon-5db70b2d00f65642458188/]
Но после установки сертификатов обнаружил что Chrome, в отличие от других браузеров не принимает такой сертификат. В этой заметке я расскажу в чем проблема и как ее исправить.
 [...] 
 25.03.2019 
 Active Directory, Windows, Без рубрики 
        
	
 
 Новые компьютеры не появляются на WSUS сервере 
Если вы используете различные инструменты деплоя ОС из образов или имеете большое количество виртуальных машин, то наверняка замечали что далеко не все развернутые ОС отправляют отчет на сервер WSUS или вообще пропадают с сервера.
В этой статье я расскажу почему так происходит и как с этим бороться [...] 
 17.08.2018 
 Active Directory, Windows Server 
        
	
 
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
        
	
 
 Создание шаблонов Zabbix для Windows. 
Недавно мне понадобилось мониторить некоторые службы и порты на ОС Windows Server 2012 R2 .
Давайте рассмотрим пример как создать шаблон для мониторинга DNS сервиса на Windows. [...] 
 03.07.2015 
 Active Directory, Linux, Windows, Windows Server 
        
	
 
 Автоматический аудит компьютеров в Active Directory через powershell. 
В данной статье мы рассмотрим как автоматически проводить аудит компьютеров в Active Directory.
Я думаю многие системные администраторы ломали голову как вести учет за каким ПК какой пользователь работает, особенно если имена ПК статичны.
Для решения данной проблемы воспользуемся PowerShell. [...] 
 10.06.2015 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Автоматический перенос старых перемещаемых профилей в архив с помощью Powershell. 
Думаю многие системные администраторы использующие перемещаемые профили или folder redirection, сталкивались с проблемой старых профилей уволенных сотрудников.
Ведь не всегда можно проследить перенесли профиль в архив или нет.
Для решения данной проблемы предлагаю использовать следующий скрипт: [...] 
 05.05.2015 
 Active Directory, PowerShell, Windows Server 
        
	
 
 Назначение служб для сертификатов Exchange через Powershell. 
В данной статье я расскажу как назначить службы сертификату Exchange через Powershell. [...] 
 12.03.2015 
 Active Directory, Exchange, PowerShell, Windows, Windows Server 
        
	
 
 Изменение UPN суффикса в Active Directory через Powershell 
В данной статье я расскажу как изменить UPN суффикс пользователей в домене Active Directory через Powershell. [...] 
 12.03.2015 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Аудит незаполненных полей в Active Directory через Powershell 
В данной статье я расскажу как проводить аудит полей Active Directory через Powershell. [...] 
 06.03.2015 
 Active Directory, PowerShell, Windows, Windows Server 
        
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
                 
1234»Вперед »  
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
