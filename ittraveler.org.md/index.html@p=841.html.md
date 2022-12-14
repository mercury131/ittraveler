# Настраиваем аудит сервера Ubuntu через AIDE                	  
***Дата: 05.05.2017 Автор Admin***

Думаю многим из вас приходила в голову мысль что было бы неплохо вести аудит изменений на сервере, особенно если например это vps в облаке. 
И так, перейдем к настройке аудита.
Обновим список пакетов
```
apt-get update
```
apt-get update
Установим AIDE
```
apt-get install aide
```
apt-get install aide
Инициализируем базу данных AIDE
```
aideinit
```
aideinit
Это нужно для создания слепка БД с информацией о нашей системе.
Теперь скопируем и создадим новую базу
```
cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
```
cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
Далее для настройки AIDE нужно использовать 2 файла
/etc/default/aide –&gt; Основной конфиг AIDE
/etc/aide/aide.conf –&gt; Конфиг с правилами для AIDE
В первый конфиг добавим строку MAILTO=me@example.com , в вашим email.
Теперь , раз в сутки AIDE будет отправлять отчет о произошедших изменениях в системе.
Если вам нужно изменить параметры аудита, то список правил для настройки можно посмотреть тут
Related posts:Docker Основные примеры использования.Настройка прокси сервера Tor на Ubuntu.Оптимизация изображений на веб сервере
 Bash, Cloud, Debian, Linux, Ubuntu, Web, Web/Cloud, Без рубрики 
 Метки: AIDE, Linix, Ubuntu, Аудит  
                        
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
