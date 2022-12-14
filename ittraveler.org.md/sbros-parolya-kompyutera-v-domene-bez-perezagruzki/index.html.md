# Сброс пароля компьютера в домене без перезагрузки                	  
***Дата: 30.12.2014 Автор Admin***

Я думаю, многие администраторы сталкивались с проблемой, когда компьютер не может пройти проверку подлинности в домене и при попытке логона пользователя выдает сообщение: The trust relationship between this workstation and the primary domain failed («Не удалось установить доверительные отношения между этой рабочей станцией и основным доменом»).
В общем-то причина появления такой ошибки известна. Все компьютеры в домене Windows имеют свой собственный пароль и по умолчанию должны менять его каждые 30 дней. Однако если по какой либо причине эти пароли не совпадают, то компьютер не может пройти аутентификации в домене (установить доверительные отношения и безопасный канал).
Такое рассогласование может произойти в случае, если компьютер был восстановлен из резервной копии, созданной раньше момента последней смены пароля компьютера в домене (особенно часто это случается при восстановлении виртуальной машины из снапшота), или же произошла принудительная смена пароля в домене, а на компьютер эти изменения по какой-либо причине не попали (например, была сброшена или перезатерта учетная запись ПК).
В принципе, избежать такую ситуации можно, запретив смену пароля в в домене групповой политике (например, только  для виртуальных машин), но, естественно это небезопасно и делать это обычно не рекомендуется.
В таких случаях, системный администратор обычно просто заново включал вылетевший компьютер в домен. Но для этого компьютер нужно перезагружать. Мне захотелось найти альтернативу такому решению, и как оказалось, оно существует.  Для этого можно воспользоваться Powershell.
Откройте консоль PowerShell
Введите команду
Test-ComputerSecureChannel
Если в ответ мы получим False, это означает что невозможно установить безопасный канал между клиентом и контроллером домена. А т.к. не устанавливается безопасный канал, то и залогинится с доменной учетной записью нельзя.
Чтобы сбросить и синхронизировать пароль компьютера в домене, воспользуемся командой
Test-ComputerSecureChannel –Credential  -Repair
В появившемся окне введите имя пользователя, которому разрешено управлять учетной записью компьютера в домене и его пароль
После чего еще раз проверим возможность установки безопасного канала первой командой, если все получилось, она вернет True
Осталось выйти из системы и зайти под доменной учетной записью
Исчтоник &#8212; http://winitpro.ru/index.php/2012/08/15/sbros-parolya-kompyutera-v-domene-bez-perezagruzki/
Related posts:Аудит изменений в Active DirectoryВыполняем команды внутри гостевых ОС через PowerCLIWindows WSL подключение к сетевым шарам
 Active Directory, PowerShell, Windows, Windows Server 
 Метки: Active Directory, Сброс пароля компьютера в домене  
                        
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
