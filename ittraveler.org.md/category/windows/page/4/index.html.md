#  Автоматизация создания адресных книг в Office 365 через Powershell Часть 3.   
***В данной статья я расскажу как автоматизировать процесс добавления новых пользователей в политику адресных книг Office 365.***

 [...] 
 31.12.2014 
 Active Directory, Exchange, Office 365, PowerShell, Windows, Windows Server 
        
	
 
 Добавление почтовых контактов в Office 365 через Powershell и CSV 
Если вам нужно добавить большое кол-во почтовых контактов в Office 365 или Exchange Online, да еще и в группу рассылки их включить, прошу под кат) [...] 
 30.12.2014 
 Exchange, Office 365, PowerShell, Windows, Windows Server 
        
	
 
 Подключение к Office 365 через Powershell и зашифрованный пароль 
В данной статье я покажу как с помощью Powershell можно подключиться к Office 365, не храня пароль в открытом виде в скрипте. [...] 
 30.12.2014 
 Office 365, PowerShell, Windows, Windows Server 
        
	
 
 Создание индивидуальных адресных книг в Office 365 и Exchange online 
Один раз мне поставили задачу разграничить адресные книги пользователям Office 365.
Смысл был в том, что каждый пользователь должен видеть только адресную книгу своей компании, чужих пользователей и их адресные книги он видеть не должен.
В моем случае пользователи синхронизировались из локальной Active Directory в Office 365, поэтому было решено фильтровать пользователей по группам AD, и с помощью групп разграничивать адресные книги.
Далее скрипт как это сделать. [...] 
 30.12.2014 
 Active Directory, Office 365, PowerShell, Windows, Windows Server 
        
	
 
 Создание пользователей Active Directory через CSV файл 
Иногда бывает нужно создать в Active Directory кучу пользователей.
Создавать все это добро вручную долго и муторно, а если для каждой группы пользователей нужна своя OU? Или названия компаний для каждого свое?
Ниже я покажу скрипт, который создает пользователей из CSV файла.
Алгоритм следующий:
1) Создаем OU с названием компании пользователя [...] 
 30.12.2014 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Принудительная синхронизация Office 365 и локальной Active Directory 
Для принудительной синхронизации Office 365 и локальной Active Directory мы будем использовать Powershell.
Открываем Powershell от имени администратора, и вводим следующие команды: [...] 
 30.12.2014 
 Active Directory, Office 365, PowerShell, Windows, Windows Server 
        
	
 
 Перенос базы данных Active Directory 
В этой статье мы покажем, как перенести базу данных и транзакционные логи Active Directory из одного каталога в другой. Данный мануал может пригодится, когда нужно перенести базу AD на другой диск (в ситуациях, когда на первоначальном диске закончилось свободное место или при недостаточной производительности дисковой подсистемы), либо перенести файлы AD в другой каталог (например, в рамках приведения к стандартному виду путей к БД AD на всех контроллерах домена предприятия). [...] 
 30.12.2014 
 Active Directory, Windows, Windows Server 
        
	
 
 Включение корзины Active Directory 
Корзину Active Directory можно включить только в том случае, если в среде установлен режим работы леса Windows Server 2008 R2. Можно повысить режим работы леса с помощью приведенных далее методов.
Использование командлета Set-ADForestMode модуля Active Directory
Set-ADForestMode –Identity contoso.com -ForestMode Windows2008R2Forest
Или использовать Ldp.exe [...] 
 30.12.2014 
 Active Directory, PowerShell, Windows, Windows Server 
        
	
 
 Удаляем неисправный контроллер домена при помощи утилиты NTDSUTIL 
Нередки ситуации, когда системному администратору приходится вручную удалять контроллер домена из Active Directory. Такие ситуации возникают при физическом выходе из строя севера с ролью контроллера домена или другой нештатной ситуации. Естественно, наиболее предпочтительно удалить контроллер домена при помощи команды DCPROMO (подробно DCPROMO и ее параметрах) Однако, что же делать, если контроллер домена недоступен (выключен, сломался, недоступен по сети)? [...] 
 30.12.2014 
 Active Directory, Windows, Windows Server 
        
	
 
 Управление репликацией Active Directory 
Обеспечение корректной репликации в лесу Active Directory – это одна из главных задач администратора AD. В этой статье попытаемся понять базовые принципы репликации базы Active Directory и методики диагностики неисправности. Стоит отметить,  что репликации — один из основополагающих принципов построения современной корпоративной сети на базе AD, так, например, мы уже говорили о репликации групповых политик в домене AD и репликации зон DNS. [...] 
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
                 
« Назад«123456»Вперед »  
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
