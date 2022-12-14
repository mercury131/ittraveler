# Сброс настроек GPO на стандартные                	  
***Дата: 12.05.2017 Автор Admin***

Иногда, после вывода машины из домена Active Directory нужно сбросить все примененные ранее настройки GPO на стандартные. Давайте рассмотрим на примере Windows 10 как легко это сделать.Сделать это очень просто, выполним 3 команды:
Сброс политик безопасности:
```
secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose
```
secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose
Удаление настроек GPO:
```
RD /S /Q "%WinDir%\System32\GroupPolicyUsers"
```
RD /S /Q "%WinDir%\System32\GroupPolicyUsers"
```
RD /S /Q "%WinDir%\System32\GroupPolicy"
```
RD /S /Q "%WinDir%\System32\GroupPolicy"
Далее просто перезагрузите компьютер.
Related posts:Настройка HA кластера Hyper-VОтключение Skype UI в Lync 2013Удаление Lync Server 2013
 Windows, Windows Server 
 Метки: GPO  
                        
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
