# Отключение Skype UI в Lync 2013                	  
***Дата: 15.04.2015 Автор Admin***

Я думаю многие заметили что после обновления интерфейс Lync 2013 изменился, и теперь он называется Skype for Business.
В данной статье я расскажу как вернуть прежний внешний вид клиенту Lync 2013.
Определить что Skype UI включен очень просто, новый интерфейс встречает нас такой надписью:
Первое что нужно сделать, так это установить все обновления на сервер Lync 2013.
Далее для отключения Skype UI у всех пользователей Lync выполним команду в Powershell
```
Set-CsClientPolicy -Identity Global -EnableSkypeUI $false
```
Set-CsClientPolicy -Identity Global -EnableSkypeUI $false
Если вы хотите отключить Skype UI только для определенного сайта, выполните следующую команду:
```
Set-CsClientPolicy -Identity site:YourSite -EnableSkypeUI $false
```
Set-CsClientPolicy -Identity site:YourSite -EnableSkypeUI $false
Если вы хотите включить Skype UI только для некоторых пользователей то создайте новую политику командой
```
New-CsClientPolicy -Identity YourPolicyName -EnableSkypeUI $true
```
New-CsClientPolicy -Identity YourPolicyName -EnableSkypeUI $true
В данной команде уже включен Skype UI
Теперь назначим пользователям эту политику
```
Get-CsUser -LDAPFilter "Department=YourDepartment" | Grant-CsClientPolicy -PolicyName YourPolicyName
```
Get-CsUser -LDAPFilter "Department=YourDepartment" | Grant-CsClientPolicy -PolicyName YourPolicyName
Однако при первом старте клиента Lync 2013, пользователь все равно будет видеть Skype UI.
Чтобы этого избежать добавьте в реестр следующее значение:
Ветка реестра &#8212; HKEY_CURRENT_USER\Software\Microsoft\Office\Lync
Тип параметра &#8212; REG_BINARY
Имя параметра &#8212; EnableSkypeUI
Значение &#8212; 00 00 00 00
Добавить его всем пользователям можно через групповую политику.
Как это сделать показано на скриншоте ниже:
Related posts:Переход на репликацию SYSVOL по DFSСброс пароля компьютера в домене без перезагрузкиСоздание шаблонов Zabbix для Windows.
 PowerShell, Windows 
 Метки: Lync, Powershell, Skype for business  
                        
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
