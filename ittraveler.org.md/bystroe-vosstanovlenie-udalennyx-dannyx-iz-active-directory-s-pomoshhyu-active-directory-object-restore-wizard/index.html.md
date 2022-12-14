# Быстрое восстановление удаленных данных из Active Directory с помощью Active Directory Object Restore Wizard                	  
***Дата: 30.12.2014 Автор Admin***

Бывают случаи, когда кто-нибудь из системных администраторов удалит нужную пользовательскую или системную учетную запись.
К счастью есть удобная утилита от компании Netwrix &#8212; Active Directory Object Restore Wizard.
Плюс данной утилиты в том что после установки она не требует перезагрузки сервера.
Скачать программу можно с сайта производителя.
По умолчанию программа ищет удаленные объекты в снимках Active Directory.
Если в снимках ничего не найдено, программа будет искать в контейнере удаленных объектов.
Выбираем удаленный объект и восстанавливаем
Related posts:Установка и настройка дедупликации  на Windows Server 2012 R2Восстановление объектов Active Directory: сборник сценариевПередача и захват ролей FSMO
 Active Directory, Windows, Windows Server 
 Метки: Active Directory, восстановление удаленных данных  
                        
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
