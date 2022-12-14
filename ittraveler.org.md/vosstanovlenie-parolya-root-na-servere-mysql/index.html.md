# Восстановление пароля root на сервере Mysql                	  
***Дата: 23.06.2015 Автор Admin***

Бывают ситуации когда тебе достался сервер Mysql, а пароль root ты не знаешь.
Как быть в такой ситуации? Правильно, изменим пароль root.
Останавливаем службу Mysql сервера.
```
/etc/init.d/mysql stop
```
/etc/init.d/mysql stop
Для redhat команда остановки сервера будет такой:
```
/etc/init.d/mysqld stop
```
/etc/init.d/mysqld stop
Загружаем Mysql сервер в безопасном режиме
```
mysqld_safe --skip-grant-tables &amp;
```
mysqld_safe --skip-grant-tables &amp;
Теперь откроем консоль mysql сервера
```
mysql -u root
```
mysql -u root
Выбираем БД mysql
```
use mysql;
```
use mysql;
Сбрасывам пароль
```
update user set password=PASSWORD("mynewpassword") where User='root';
```
update user set password=PASSWORD("mynewpassword") where User='root';
Перезапускаем привелегии
```
flush privileges;
```
flush privileges;
Выходим из консоли Mysql
```
exit
```
exit
Останавливаем службу Mysql сервера.
```
/etc/init.d/mysql stop
```
/etc/init.d/mysql stop
Запускаем службу Mysql сервера.
```
/etc/init.d/mysql start
```
/etc/init.d/mysql start
Теперь вы можете войти в консоль mysql с новым паролем.
Related posts:Восстановление HP ILOБалансировка нагрузки веб серверов IIS с Windows аутентификацией через HaproxyDocker Основные примеры использования.
 Linux, Ubuntu, Web/Cloud 
 Метки: Linux, Mysql, Ubuntu  
                        
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
