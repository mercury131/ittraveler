# Clickhouse ошибка DB::Exception: Replica already exists..                	  
***Дата: 19.03.2019 Автор Admin***

При моргании сети или при длительной недоступности одной из реплик clickhouse &#8212; возможно ее повреждение.
В таком случае сервер может не стартовать службу clickhouse и при попытке пересоздания реплицируемой таблицы вы получите ошибку 253 Replica already exists..
Чтобы исправить эту ошибку и восстановить реплику clickhouse выполните следующее:
Cкопируйте sql файл с доступной живой реплики по пути
```
/var/lib/clickhouse/metadata/default
```
/var/lib/clickhouse/metadata/default
где default для БД, файл будет иметь название имя_таблицы.sql
Этот фай поместите на сломанную реплику, по аналогичному пути.
Далее выполните следующие команды:
```
chown clickhouse:clickhouse &lt;table_name&gt;.sql
```
chown clickhouse:clickhouse &lt;table_name&gt;.sql
```
chmod 0640 &lt;table_name&gt;.sql
```
chmod 0640 &lt;table_name&gt;.sql
Инициируйте процесс принудительного восстановления
```
sudo -u clickhouse touch /var/lib/clickhouse/flags/force_restore_data
```
sudo -u clickhouse touch /var/lib/clickhouse/flags/force_restore_data
Запустите службу clickhouse
```
service clickhouse-server start
```
service clickhouse-server start
Если при создании реплицируемой таблицы вы все еще получаете данную ошибку &#8212; удалите данные о таблице из zookeeper
Для этого откройте консоль zookeeper (расположена в директории с установленным zookeeper)
```
zkCli.sh
```
zkCli.sh
При возникновении ошибки Replica  already exists.. обычно указан путь в zookeeper, в котором хранится информация о реплике, например:
```
/clickhouse/tables/tx/replicas/srv1
```
/clickhouse/tables/tx/replicas/srv1
Выполните команду на удаление этого пути в запущенной ранее консоли zookeeper
```
rmr /clickhouse/tables/tx/replicas/srv1
```
 rmr /clickhouse/tables/tx/replicas/srv1
Теперь выполните команду
```
get /clickhouse/tables/tx/replicas/srv1
```
get /clickhouse/tables/tx/replicas/srv1
Если вы получили ошибку Node does not exist &#8212; значит информация о реплике удалена.
Теперь перезапустите clickhouse
```
service clickhouse-server restart
```
service clickhouse-server restart
После этих действий вы сможете создать реплицируемую таблицу, данные автоматически синхронизируются с доступных реплик.
Related posts:Перенос виртуальной машины из Hyper-V в Proxmox (KVM)Настраиваем аудит сервера Ubuntu через AIDEУстановка и настройка Sphinx
 Bash, Debian, Без рубрики 
   
                        
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
