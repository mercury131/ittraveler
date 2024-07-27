#  Принудительная синхронизация Office 365 и локальной Active Directory   
***Для принудительной синхронизации Office 365 и локальной Active Directory мы будем использовать Powershell.***

Открываем Powershell от имени администратора, и вводим следующие команды: [...] 
 30.12.2014 
 Active Directory, Office 365, PowerShell, Windows, Windows Server 
        
	
 
 Включение корзины Active Directory 
Корзину Active Directory можно включить только в том случае, если в среде установлен режим работы леса Windows Server 2008 R2. Можно повысить режим работы леса с помощью приведенных далее методов.
Использование командлета Set-ADForestMode модуля Active Directory
Set-ADForestMode –Identity contoso.com -ForestMode Windows2008R2Forest
Или использовать Ldp.exe [...] 
 30.12.2014 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Сброс пароля компьютера в домене без перезагрузки 
Я думаю, многие администраторы сталкивались с проблемой, когда компьютер не может пройти проверку подлинности в домене и при попытке логона пользователя выдает сообщение: The trust relationship between this workstation and the primary domain failed («Не удалось установить доверительные отношения между этой рабочей станцией и основным доменом»).
 [...] 
 30.12.2014 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Восстановление объектов Active Directory: сборник сценариев 
Несомненно, многие из Вас неоднократно сталкивались с такой проблемой – удалены учетные записи пользователей. Статей по восстановлению учетных записей много, и, наверное, самая лучшая написана Microsoft, однако им всем не хватает наглядности. Мы постараемся преодолеть этот недостаток, сведя процедуру восстановления учетных записей к простым шагам.
Как Вы знаете, восстанавливать объекты можно различными способами, каждый из которых подходит наилучшим образом в той или иной ситуации.
При этом предпочтительным является восстановление из tombstone-объектов. На это есть несколько причин:
- не требуется выведение контроллера домена в автономный режим (все работают, ничего не отключено)
- восстановление объектов-захоронений гораздо лучше, чем простое воссоздание новой версии удаленного объекта [...] 
 30.12.2014 
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
Июль 2024
Пн
Вт
Ср
Чт
Пт
Сб
Вс
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
                 
« Назад«1234  
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
