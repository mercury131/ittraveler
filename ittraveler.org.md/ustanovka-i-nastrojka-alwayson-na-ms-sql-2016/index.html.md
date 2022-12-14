# Установка и настройка AlwaysOn на MS SQL 2016                	  
***Дата: 12.06.2019 Автор Admin***

В данной статье мы рассмотрим установку MS SQL 2016 в режиме AlwaysOn на двух нодах Windows Server 2016
Для начала нам нужно 2 сервера Windows Server 2016 в домене AD.
На каждом сервере должны быть отдельные диски для хранения БД, логов и TempDB.
Откройте диспетчер дисков и отформатируйте каждый диск в NTFS и задайте размер кластера 64kb
Должно получиться так:
Далее установите на оба сервера фичу failover clustering.
&nbsp;
Теперь запускаем Failover Cluster manager и создаем кластер, общее хранилище для него нам не нужно.
&nbsp;
&nbsp;
&nbsp;
&nbsp;
После прохождения всех проверок переходим к следующим шагам.
Создаем кластер.
&nbsp;
&nbsp;
&nbsp;
&nbsp;
Теперь нужно добавить witness для созданного кластера
&nbsp;
&nbsp;
Теперь кворум успешно настроен.
&nbsp;
&nbsp;
Теперь установите SQL сервер на обе ноды кластера.
Создайте инстанс по умоланию или создайте инстанс с другим именем.
Укажите доменные сервисные учетные записи вместо локальных
Укажите Collation, обратите внимание что он должен быть одинаковым на всех нодах
Укажите администраторов
&nbsp;
Укажите расположение директорий для БД, tempdb и логов (их нужно расположить на ранее подготовленных дисках)
&nbsp;
Дожидаемся завершения установки
&nbsp;
&nbsp;
Далее открываем SQL Server Configuration Manager, щелкаем правой кнопкой мыши по SQL Server и выбираем properties.
Открываем вкладку Always On и ставим галочку
Выполняем эту процедуру на каждом сервере.
Теперь скачиваем SQL Management Studio по этой ссылке 
Создайте или импортируйте базу данных на одном из серверов.
Теперь перейдем к настройке AlwaysOn
Запускаем Management Studio на одном из серверов и запускаем New Availability Group Wizard
Указываем имя новой AG группы
&nbsp;
Выбираем нашу базу, для которой собственно мы и настраиваем AlwaysOn.
Обратите внимание что база должна иметь модель восстановления full и иметь один полный бэкап
&nbsp;
Добавляем второй сервер и настраиваем все следующим образом
&nbsp;
Далее добавляем Listner, если ваши приложения, подключающиеся к кластеру не умеют multi subnet availability group, в моем случае ноды сервера расположены в разных ДЦ, соответственно и сети у них разные.
Чтобы подключиться к БД приложения должны использовать dns имя listner-а.
Выбираем тип синхронизации full и отказоустойчивую шару для этого, желательно расположенную на отказоустойчивом кластере.
Проверяем что все настроено корректно и выполняем создание группы
На этом настройка AlwaysOn завершена, теперь Ваш SQL сервер может пережить отказ одной из нод, также Вы можете спокойно проводить обслуживание сервера, переключая ноды между собой.
&nbsp;
Переключать AlwaysON группу между нодами можно следующим образом:
Выбираем failover
&nbsp;
Выбираем вторую ноду
&nbsp;
Проверяем выбранные данные и запускаем переключение
&nbsp;
Переключение успешно завершено
&nbsp;
&nbsp;
&nbsp;
Related posts:Сброс пароля администратора Active DirectoryНазначение служб для сертификатов Exchange через Powershell.Настройка отправки PHP Mail через Gmail
 Windows, Windows Server, Без рубрики 
   
                        
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
