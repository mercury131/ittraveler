#  Аудит доменных служб Active Directory в Windows Server 2008 R2   
***ИТ среда не является статичной. Ежеминутно в системах происходят тысячи изменений, которые требуется отследить и запротоколировать. Чем больше размер и сложность структуры, тем выше вероятность появления ошибок в администрировании и раскрытия данных. Без постоянного анализа изменений (удачных или неудачных) нельзя построить действительно безопасную среду. Администратор всегда должен ответить, кто, когда и что изменил, кому делегированы права, что произошло в случае изменений (удачных или неудачных), каковы значения старых и новых параметров, кто смог или не смог зайти в систему или получить доступ к ресурсу, кто удалил данные и так далее. Аудит изменений стал неотъемлемой частью управления ИТ инфраструктурой, но в организациях не всегда уделяют внимание аудиту, часто из-за технических проблем. Ведь не совсем понятно, что и как нужно отслеживать, да и документация в этом вопросе не всегда помогает. Количество событий, которые необходимо отслеживать, уже само по себе сложность, объемы данных велики, а штатные инструменты не отличаются удобством и способностью упрощать задачу отслеживания. Специалист должен самостоятельно настроить аудит, задав оптимальные параметры аудита, кроме того, на его плечи ложится анализ результатов и построение отчетов по выбранным событиям. Учитывая, что в сети запущено нескольких служб – Active Directory/GPO, Exchange Server, MS SQL Server, виртуальные машины и так далее, генерирующих очень большое количество событий, отобрать из них действительно необходимые, следуя лишь описаниям, очень тяжело. [...] ***

 30.12.2014 
 Active Directory, Windows, Windows Server 
        
	
 
 Принудительная синхронизация контроллеров домена Active Directory 
Очень часто возникает необходимость быстро синхронизировать информацию на всех контроллерах домена.
Но если у вас большая сеть, несколько сайтов, или просто настроено долгое время репликации, ожидание синхронизации может быть очень долгим. [...] 
 30.12.2014 
 Active Directory, Windows 
        
	
 
 Добавление UPN суффикса в Active Directory 
Добавить новый UPN суффикс в Active Directory очень просто!
Для этого откройте оснастку Active Directory Domains and Trusts
Далее выделите пункт Active Directory Domains and Trusts и нажмите правую клавишу мыши, выберите свойства
 [...] 
 30.12.2014 
 Active Directory, Windows 
        
	
 
 Active Directory + Thunderbird = Общая адресная книга 
Active Directory + Thunderbird = Общая адресная книга
Простой способ как можно научить Thunderbird работать с адресной книгой Active Directory.
Для подключения к адресной книге Active Directory, в Mozilla Thunderbird необходимо выполнить следующие настройки:
1. Открываем "Адресная книга"
2. Создаем новую адресную книгу при помощи меню "Файл &gt; Создать &gt; Каталог LDAP"
3. Заполняем необходимые поля на вкладке "Основное" [...] 
 30.12.2014 
 Active Directory, Windows 
        
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
                 
« Назад«1&hellip;456  
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
