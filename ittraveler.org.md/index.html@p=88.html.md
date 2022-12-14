# Управление репликацией Active Directory                	  
***Дата: 30.12.2014 Автор Admin***

Обеспечение корректной репликации в лесу Active Directory – это одна из главных задач администратора AD. В этой статье попытаемся понять базовые принципы репликации базы Active Directory и методики диагностики неисправности. Стоит отметить,  что репликации — один из основополагающих принципов построения современной корпоративной сети на базе AD, так, например, мы уже говорили о репликации групповых политик в домене AD и репликации зон DNS.
Для мониторинга репликации Active Directory в корпоративной среде Microsoft рекомендует использовать продукт SCOM (либо другие продукты мониторинга с похожим функционалом).  Кроме того, для  мониторинга репликации AD можно использовать утилиту repadmin (repadmin /showrepl * /csv) совместно с самописными скриптами анализа вывода этой утилиты. Типичные проблемы, связанные с ошибками репликации Active Directory,  — ситуации, когда объекты не появляются в одном или нескольких сайтах (например, только что созданный пользователь, группа или другой объект AD не доступны на контроллерах домена в других сайтах).
Хорошая отправная точка для поиска неисправности в механизме репликации Active Directory – анализ журнала «Directory Services» на контроллерах домена. Конкретные действия будут зависеть от того, какие ошибки будут обнаружены в журнале, однако для разрешения проблем нужно достаточно четко понимать процессы репликации Active Directory.
Одним из базовых элементов управлением трафиком репликации между контроллерами домена являются сайты Active Directory. Сайты связаны между собой особыми связями, называемыми «site link», которые определяют стоимость маршрутизации данных AD (элементы леса, домена, папка SYSVOL и т.д.) между различными сайтами. Расчет алгоритма управления и маршрутизации трафика репликации в лесу ведется службой KCC.
KCC определяет партнеров по репликации для всех контроллеров домена в лесу. Для межсайтовой репликации KCC автоматически выбирает специальные сервера-плацдармы (bridgehead server), помимо этого, администратор домена может вручную указать контролеры домена, которые будут выполнять роль сервера-плацдарма для того или иного сайта, именно эти сервера и управляют межсайтовой репликацией.   Сайты и сервера bridgehead нужны для того, чтобы удобно управлять трафиком репликации Active Directory, и чтобы уменьшить объем передаваемого трафика по сети.
Межсайтовую топологию в лесу можно проанализировать при помощи команды:
repadmin /showism
данная команда отобразит список сайтов в лесу Active Directory.  Для каждого из сайтов указаны 3 значения: стоимость репликации между двумя сайтами, интервал репликации в минутах, а также дополнительные настроенные параметры межсайтовой связи. Вывод этой команды может выглядеть так:
C:\&gt;repadmin /showism
==== TRANSPORT CN=IP,CN=Inter-Site Transports,CN=Sites,CN=Configu
ration,DC=winitpro,DC=ru CONNECTIVITY INFORMATION FOR 3 SITES: ====
0,    1,    2
Site(0) CN=LAB-Site1,CN=Sites,CN=Configuration,DC=winitpro,DC=ru
0:0:0, 10:15:0, 10:30:0
All DSAs in site CN=ADP-ADSN,CN=Sites,CN=Configuration,DC=lab,
DC=net (with trans&amp; hosting NC) are bridgehead candidates.
Site(1) CN=LAB-Site2,CN=Sites,CN=Configuration,DC=winitpro,DC=ru
10:15:0, 0:0:0, 20:30:0
All DSAs in site CN=ADP-Intranet,CN=Sites,CN=Configuration,DC=la
b,DC=net (with trans &amp; hosting NC) are bridgehead candidates
Site(2) CN=LAB-Site3,CN=Sites,CN=Configuration,DC=winitpro,DC=ru
10:30:0, 20:30:0, 0:0:0
1 server(s) are defined as bridgeheads for transport CN=IP,CN=Int
er-Site Transports,CN=Sites,CN=Configuration,DC=winitpro,DC=ru &amp;
site CN=LAB-Site3,CN=Sites,CN=Configuration,DC=winitpro,DC=ru:
Server(0) CN=testlabdc2,CN=Servers,CN=LAB-Site3,CN=Sites,CN=Co
nfiguration,DC=winitpro,DC=ru
C:\&gt;
В вышеприведённом логе видно, что в домене test.com существует 3 сайта, которые называется соответственно Site(0), Site(1) иSite(2).  Каждый из сайтов имеет 3 набора репликационной информации, по одной для каждого сайта в лесу. Например, настроена связь между Sites(2) (LAB-Site3) и Site(0) (LAB-Site1), параметры этой связи — 10:30:0, что означает: 10 – стоимость репликации, и интервал репликации  30 минут.  Также обратите внимание, что для сайта Site(2) задан сервер-плацдарм (bridgehead) – это контроллер домена с именем testlabdc2.
Контроллеры домена, партнеры по репликации – могут быть идентифицированы при помощи графического Gui или при помощи утилит командной строки. Откройте консоль    MMC «Active Directory Sites and Services», разверните узел  Sites, в нем найдите интересующий ваш сайт. В этом узле будут содержатся контроллеры домена, относящиеся к этому сайту. Развернув контроллер домена и выбрав пункт NTDS Settings, вы увидите всех партнеров по репликации данного контроллера домена.
В командной строке при помощи команды nslookup можно получить список контроллеров домена, относящихся к нашему сайту (естественно для этого необходимо,  чтобы все DC имели корректные записи SRV).  Формат команды такой:
nslookup -type=srv _ldap._tcp.._sites.dc._
на выходе получаем примерно следующее:
C:\&gt;
_ldap._tcp.LAB-Site1._sites.dc._msdcs.test.com SRV service location
priority       = 0
weight         = 100
port           = 389
svr hostname   = testlabdc1.test.com
_ldap._tcp.LAB-Site1._sites.dc._msdcs.test.com SRV service location
priority       = 0
weight         = 100
port           = 389
svr hostname   = testlabdc2.test.com
testlabdc1.test.com       internet address = 172.21.23.13
testlabdc2.test.com       internet address = 172.21.23.16
Чтобы для определенного контролера домена отобразить всех партнеров по репликации, с датой и временем  последней репликации, воспользуйтесь командой:
repadmin /showrepl
Стоит отметить, что служба DNS – это важный компонент службы репликации Active Directory. Контроллеры домена регистрируют свои SRV записи в DNS.   Каждый контроллер домена в лесу регистрирует записи CNAME вида dsaGuid._msdcs.forestName, где dsaGuid –GUID видимый у объекта в пункте NTDS Settings в консоли «AD Sites and Services». Если в журнале Directory Services есть ошибки, связанные со службой DNS, для проверки корректных записей  типа CNAME и A для контроллера домена.
dcdiag /test:connectivity
Если будут ошибки, перезапустите службу Netlogon, в результате чего произойдет перерегистрация отсутствующих dns записей. Если dcdiag все также будет выдавать ошибки, проверьте конфигурацию службы DNS и корректность DNS настроек на DC. Для более детального знакомства с темой тестирования служб dns, рекомендую обратиться к статье Диагностика проблем с поиском контроллера домена.
Команда repadmin имеет специальный параметр /replsummary, который позволяет быстро проверить состояние репликации на конкретном контроллере домена (указывается его имя) или на всех контроллерах (опция wildcard).
repadmin /replsummary [targetDC|wildcard]
В том случае, если ошибки репликации отсутствуют, в выводе этой команды будет видно, что ошибок – 0.:
C:\&gt;repadmin /replsummary testlabdc2
Replication Summary Start Time: 2010-01-24 15:56:03
Beginning data collection for replication summary, this may take a
while:
&#8230;.
Source DSA       largest delta    fails/total  %% error
testlabdc1           06m:27s       0 /   3    0
testlabdc3           06m:27s       0 /   6    0
testlabdc4           06m:27s       0 /   5    0
Destination DSA  largest delta    fails/total  %% error
testlabdc3           06m:27s       0 /  14    0
C:\&gt;
В том случае, если ошибки все-таки будут, при помощи утилиты Repadmin можно получить более полную информацию. Каждый контроллер домена имеет собственный   уникальный USN (Update Sequence Number), который инкрементируется каждый раз при успешном изменении обновлении  объекта Active Directory. При инициализации репликации, партнеру передается USN, который сравнивается с USN, полученным в результате последней успешной репликации  с данным партнером, тем самым определяя сколько изменений произошло в базе AD со времени последней репликации.
При помощи ключа /showutdvec, можно получить список текущих значений USN, хранящихся на указанном DC.
repadmin /showutdvec
например
C:\&gt;repadmin /showutdvec  testlabdc4 DC=test,DC=ru
Caching GUIDs.
&#8230;.
LAB-Site1\testlabdc1   @ USN  16608532 @ Time 2010-01-24 16:27:11
LAB-Site1\testlabdc2   @ USN    307126 @ Time 2010-01-24 16:27:27
LAB-Site2\testlabdc3   @ USN 297948217 @ Time 2010-01-24 16:19:34
LAB-Site3\testlabdc4   @ USN 245646728 @ Time 2010-01-24 16:19:36
C:\&gt;
Запустив эту команду на контроллере домена, на котором наблюдаются проблемы с репликацией, можно понять насколько различаются базы AD, просто сравнив значения USN.
Тестирование репликации  Active Directory при помощи утилиты  repadmin можно осуществить несколькими способами:
replmon /replicate &lt;targetDC&gt; &lt;sourceDC&gt; &lt;dirPartition&gt; (позволяет запустить репликацию определенного раздела на указанный контроллер домена)
replmon /replsingleobj &lt;targetDC&gt; &lt;sourceDC&gt; &lt;objPath&gt; (репликация конкретного объекта между двумя DC)
replmon /syncall &lt;targetDC&gt; (синхронизация указанного контроллера домена со всем партнерами по репликации)
C:\&gt;repadmin /replicate testlabdc1 testlabdc3 DC=test,DC=ru
Sync from testlabdc3 to testlabdc1 completed successfully.
C:\&gt;repadmin /replsingleobj testlabdc1 testlabdc3 cn=stuart,ou=dsu
sers,DC=test,DC=ru
Successfully replicated object cn=stuart,ou=dsusers,DC=test,DC=ru
to testlabdc1 from .
C:\&gt;repadmin /replsingleobj testlabdc1 testlabdc3 ou=dsusers,dc=la
b,dc=net
Successfully replicated object ou=dsusers,DC=test,DC=ru to testlab
dc1 from .
C:\&gt;repadmin /replsingleobj testlabdc1 testlabdc3 DC=winitpro,DC=ru
Successfully replicated object DC=test,DC=ru to testlabdc1 from
.
C:\&gt;repadmin /syncall testlabdc3
CALLBACK MESSAGE: The following replication is in progress:
From: 25fdc051-6ff6-4922-bc02-0b77a4652bfc._msdcs.test.com
To  : 99305007-2290-489b-9551-20827ba0664d._msdcs.test.com
CALLBACK MESSAGE: The following replication completed successfully
From: 25fdc051-6ff6-4922-bc02-0b77a4652bfc._msdcs.test.com
To  : 99305007-2290-489b-9551-20827ba0664d._msdcs.test.com
CALLBACK MESSAGE: The following replication is in progress:
From: b0870af5-ab82-4372-9e39-0a9772a5e47c._msdcs.test.com
To  : 99305007-2290-489b-9551-20827ba0664d._msdcs.test.com
CALLBACK MESSAGE: The following replication completed successfully
From: b0870af5-ab82-4372-9e39-0a9772a5e47c._msdcs.test.com
To  : 99305007-2290-489b-9551-20827ba0664d._msdcs.test.com
CALLBACK MESSAGE: SyncAll Finished.
SyncAll terminated with no errors.
C:\&gt;
При наличии проблем с механизмом репликации Active Directory, нужно знать и уметь пользоваться утилитами repadmin, nslookup, dcdiag, крайне полезен при анализе журнал событий Directory Services. В особо сложный  и нестандартных ситуациях может помочь база знаний Microsoft KB, в которой описаны типовые проблемы и методики их решения. Поиск по базе KB обычно осуществляется по идентификаторам ошибок (Event ID), полученным из указанного журнала..
Источник &#8212; http://winitpro.ru/index.php/2011/07/01/upravlenie-replikaciej-active-directory/ 
Related posts:Настройка HA кластера Hyper-VАвтоматизация создания адресных книг в Office 365 через Powershell Часть 3.Ошибка ERR: CERT_COMMON_NAME_INVALID в Chrome при использовании SSL сертификата.
 Active Directory, Windows, Windows Server 
 Метки: Active Directory, Репликация  
                        
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
