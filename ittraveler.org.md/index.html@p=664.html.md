# Восстановление HP ILO                	  
***Дата: 31.08.2015 Автор Admin***

Недавно я столкнулся с ситуацией, когда интерфейс ILO 4 стал недоступен, а блейдовая корзина начала отправлять сообщения об ошибках на данном лезвии.
Интерфейс Ilo выглядел так:
Ввести логин и пароль было невозможно.
Так как же решить данную проблему?
Очень просто!
Подключаемся по ssh к нашему ilo
Далее выкладываем прошивку на ближайший веб сервер.
Из ssh консоли ILO проверяем можем ли мы выполнить пинг до веб сервера
```
iLO&gt; cd /map1
```
iLO&gt; cd /map1
```
iLO&gt; oemhp_ping web_server_address
```
iLO&gt; oemhp_ping web_server_address
Если пинг прошел, делаем reset ILO
```
hpiLO-&gt; cd /map1
```
hpiLO-&gt; cd /map1
```
hpiLO-&gt; reset
```
hpiLO-&gt; reset
После этого ILO перезагрузится и на него можно будет зайти.
Если на этом шаге вы всеравно не можете попасть в веб интерфейс ILO и перепрошить его, то подключайтесь по ssh и выполняйте команды:
```
cd map1/firmware1
```
cd map1/firmware1
```
load -source http://yourwebserver/ilo4_150.bin
```
load -source http://yourwebserver/ilo4_150.bin
где &#8212; load -source http://yourwebserver/ilo4_150.bin путь к файлу с прошивкой.
После этого ILO выполнит загрузку образа и выполнит перепрошивку.
Все, теперь можно дальше пользоваться ILO.
Данный способ актуален для ILO 3 и ILO 4.
Related posts:Установка и настройка memcacheУстановка и настройка Radius сервера на Ubuntu с веб интерфейсом.Настройка дисковых квот в Ubuntu
 Linux 
 Метки: ilo  
                        
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
