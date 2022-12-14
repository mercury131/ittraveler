# Перенос базы данных Active Directory                	  
***Дата: 30.12.2014 Автор Admin***

В этой статье мы покажем, как перенести базу данных и транзакционные логи Active Directory из одного каталога в другой. Данный мануал может пригодится, когда нужно перенести базу AD на другой диск (в ситуациях, когда на первоначальном диске закончилось свободное место или при недостаточной производительности дисковой подсистемы), либо перенести файлы AD в другой каталог (например, в рамках приведения к стандартному виду путей к БД AD на всех контроллерах домена предприятия).
Перенос файлов базы данных Active Directory возможен только при остановленных службах Active Directory Domain Services. Для переноса мы воспользуемся утилитой ntdsutil.
Перед началом переноса базы и файлов журналов транзакций Active Directory нужно убедится, что диск, на который планируется перенос подключен к системе, а целевая папка создана.
Важно! Для хранения базы данных Active Directory нельзя использовать съемный диск. Диск должен быть отформатирован в файловой системе NTFS. Файловые системы FAT/FAT32/ReFS/ExFAT не поддерживаются.
Операция переноса должна выполняться из-под учетной записи администратора домена / предприятия (группы Domain Admins/Enterprise Admins).
Перенос базы и журналов транзакций Active Directory на контроллере домена во всех поддерживаемых на данный момент серверных ОС Microsoft практически идентичен за исключением пары моментов.
Перенос NTFS разрешений каталога NTDS
Перенос БД AD в Windows Server 2008/2008 R2
Перенос БД AD в Windows Server 2012/2012 R2
Перенос базы AD в Windows Server 2003
Перенос NTFS разрешений каталога NTDS
Очень важно при переносе файлов базы и журналов AD, чтобы на новый каталог действовали те же самые разрешения, что и на исходный. NTFS разрешения на новый каталог можно назначить вручную или скопировать такой командой Powershell:
get-acl C:\Windows\NTDS | set-acl E:\NTDS
где, C:\Windows\NTDS – первоначальный каталог с базой AD
E:\NTDS – каталог, в который производится перенос
Перенос БД AD в Windows Server 2008/2008 R2
В Windows Server 2008 / 2008 R2 роль Active Directory является отдельной службой (ADDS), которую можно остановить, без необходимости перезагружать сервер в режиме восстановления каталога (DSRM). Чтобы остановить службу Active Directory Domain Services, откройте командную строку с правами администратора и выполните команду:
net stop ntds
И подтвердить остановку службы нажав Y и Enter.
Далее в этой же командной строке запускаем утилиту ntdsutil:
ntdsutil
Выберем активный экземпляр базы AD:
activate instance NTDS
Перейдем в контекст files, в котором возможно выполнение операция с файлами базы AD, набрав к командной строке:
files
Перенесем базу AD в новый каталог:
move DB to E:\ADDB\
Убедимся, что база данных Active Directory теперь находится в другом каталоге, набрав в командной строке ntdsutil:
info
Далее переместим в тот же каталог файлы с журналами транзакций:
move logs to E:\ADDB\
Удостоверимся, что все перенесено корректно, открыв целевой каталог в проводнике.
Осталось в контексте ntdsutil дважды набрать quit.
Запустим службу Active Directory Domain Services командой:
net start NTDS
Перенос БД AD в Windows Server 2012/2012 R2
В Windows Server 2012/ 2012 R2 процедура переноса базы аналогична описанной в предыдущем разделе  для  Windows Server 2008/2008 R2 и также не требует входа в DSRM режим.
Останавливаем службу Active Directory Domain Services:
net stop ntds
Откроем командную строку и последовательно выполним команды:
ntdsutil
activate instance NTDS
files
move DB to E:\ADDB\
move logs to E:\ADDB\
quit
quit
Запустим службу ADDS:
net start NTDS
Перенос базы AD в Windows Server 2003
В отличии от более новых платформ, служба каталога Directory Service в Windows Server 2003 / 2003 R2 использует файлы БД Active Directory в монопольном режиме. Это означает, что при работе сервера в роли контроллера домена доступ к этим файлам получить нельзя. Выполнить перенос файлов базы AD можно только в режиме восстановления Directory Services Restore Mode.
Чтобы попасть в DSRM режим, нужно перезагрузить DC и, нажав во время загрузки F8, выбрать в меню  пункт Directory Services Restore Mode (Windows domain controllers only)
Осталось зайти в систему с паролем администратора DSRM (задается при развертывания контроллера домена),  а далее отработать по уже описанной выше процедуре переноса с помощью ntdsutil.
После окончания переноса базы, сервер нужно перезагрузить в обычном режиме.
Источник &#8212; http://winitpro.ru/index.php/2014/11/10/perenos-bazy-dannyx-active-directory/ 
Related posts:Экспорт почтовых ящиков Exchange 2010 через Powershell и PSTОтказоустойчивый ISCSI кластер на Windows Server 2012 R2Создание email рассылки через Powershell
 Active Directory, Windows, Windows Server 
 Метки: Active Directory, Active Directory перенос базы  
                        
Добавить комментарий Отменить ответВаш адрес email не будет опубликован.Комментарий Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-1890562251101921"
data-ad-slot="9117958896"
data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
  
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
