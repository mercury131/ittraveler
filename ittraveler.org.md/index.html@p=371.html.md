# Glpi Интеграция с Active Directory.                	  
***Дата: 05.05.2015 Автор Admin***

В данной статье мы рассмотрим интеграцию helpdesk системы GLPI с Active Directory.
Интеграция настраивается в меню  настройки -&gt; Аутентификация-&gt; Каталоги LDAP
Через “Плюс” создаются новые настройки LDAP 
Нажимаем “Плюс” и вводим настройки нашей Active Directory
Наименование &#8212; Domain.local
Сервер DC.Domain.local
Фильтр соединений:
(&amp;(objectclass=user)(objectcategory=person)(!(useraccountcontrol:1.2.840.113556.1.4.803:=2)))
База поиска (baseDN) &#8212; DC=Domain,DC=local
rootDN (пользователь для подключения) &#8212; glpi@Domain.local
Поле имени пользователя – samaccountname
Порт (по умолчанию=389)
Настраиваем пользовательские поля, открываем вкладку “пользователи”
Настраиваем как на скриншоте:
&nbsp;
Related posts:GLPI прием заявок через почту.
 GLPI Service Desk 
 Метки: GLPI  
                        
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
