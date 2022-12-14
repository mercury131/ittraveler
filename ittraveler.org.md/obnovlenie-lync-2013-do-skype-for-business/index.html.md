# Обновление Lync 2013 до Skype for Business                	  
***Дата: 28.08.2015 Автор Admin***

Я думаю многие захотели обновиться с Lync 2013 до Skype for Business. Давайте рассмотрим как это сделать.
Первым делом убедитесь что у вас установлены все последние обновления для Lync 2013.
Проверить это можно через Lync Server Update Installer
Убедитесь что у вас установлен &#8212; SQL Server 2012 SP1 или более поздняя версия.
Установите последнюю версию Powershell.
Также установите одно из следующих обновлений (в зависимости на какой ОС установлен Lync)
Windows Server 2008 R2 – KB2533623
Windows Server 2012 – KB2858668
Windows Server 2012 R2 – KB2982006
Далее установите Skype for Business на новый сервер (не на тот где у вас установлен Lync),  но не устанавливайте роли.
Установите средства администрирования.
После установки на новом сервере откройте Topology Builder и выполните обновление пулов Lync до Skype for Business.
Опубликуйте топологию.
Теперь на всех Lync серверах выполняем Powershell команду
PowerShell
```
Stop-CsWindowsService
```
Stop-CsWindowsService
Далее на каждом пуле Lync запускаем команду с инсталяционного диска Skype for Business
```
setup.exe /inplaceupgrade
```
setup.exe /inplaceupgrade
&nbsp;
Дожидаемся окончания установки.
&nbsp;
После окончания установки на серверах lync запускаем команду:
PowerShell
```
Start-CsWindowsService
```
Start-CsWindowsService
Готово! Lync обновлен до Skype for Business!
Удачного обновления =)
&nbsp;
&nbsp;
Related posts:Добавление почтовых контактов в Office 365 через Powershell и CSVУстановка и настройка Scale-Out File Server + Storage Spaces DirectСоздание индивидуальных адресных книг в Office 365 и Exchange online
 Active Directory, PowerShell, Windows, Windows Server 
 Метки: Lync, Powershell, Windows Server  
                        
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
