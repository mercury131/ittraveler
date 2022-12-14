# Автоматическая активация пользователей Lync через Powershell                	  
***Дата: 13.01.2015 Автор Admin***

В данной статье я расскажу как сделать автоматическую активацию пользователей Lync через Powershell. 
Согласитесь ведь активация каждого пользователя в панели администрирования Lync может занять много времени, плюс это рутина.
Предлагаю автоматизировать данный процесс следующим образом:
1) Будем активировать только пользователей из определенной группы Active Directory
2) Активировать будем в автоматическом режиме, каждые 15 минут.
Для решения данной задачи нам поможет следующий скрипт:
```
# Задаем по какой группе искать пользователей
$users = (Get-ADGroupMember GD-Lync-Users | select name) 
foreach ($user in $users) {
# Включаем пользователей в Lync
Enable-CsUser -Identity $user -RegistrarPool "Your-Lync-Server" -SipAddressType SamAccountName -SipDomain SIP-Domain.local
}
# Определяем каких пользователей отключать
$Disableusers = Get-ADUser -Filter * -SearchBase "DC=Domain,DC=local" -properties memberOf | Where-Object {$_.MemberOf -notcontains "CN=GD-Lync-Users,OU=Lync,OU=Groups,DC=Domain,DC=local"} 
# Отображаем только имя пользователя
$Disableusers = $Disableusers.name 
foreach ($user in $Disableusers) {
# Отключаем пользователей которые не состоят в группе GD-Lync-Users
Disable-CsUser -Identity "$user"
}
```
# Задаем по какой группе искать пользователей&nbsp;$users = (Get-ADGroupMember GD-Lync-Users | select name) &nbsp;foreach ($user in $users) {&nbsp;# Включаем пользователей в Lync&nbsp;Enable-CsUser -Identity $user -RegistrarPool "Your-Lync-Server" -SipAddressType SamAccountName -SipDomain SIP-Domain.local&nbsp;}&nbsp;# Определяем каких пользователей отключать$Disableusers = Get-ADUser -Filter * -SearchBase "DC=Domain,DC=local" -properties memberOf | Where-Object {$_.MemberOf -notcontains "CN=GD-Lync-Users,OU=Lync,OU=Groups,DC=Domain,DC=local"} &nbsp;# Отображаем только имя пользователя$Disableusers = $Disableusers.name &nbsp;foreach ($user in $Disableusers) {&nbsp;# Отключаем пользователей которые не состоят в группе GD-Lync-Users&nbsp;Disable-CsUser -Identity "$user"&nbsp;}
Обратите внимание что для работы данного скрипта должны быть установлены модули Lync и Active Directory
Остается только добавить данный скрипт в планировщик задач.
Теперь вам не придется добавлять пользователей вручную =)
Related posts:Удаление Lync Server 2013Подключение к Office 365 через Powershell и зашифрованный парольУстановка и настройка AlwaysOn на MS SQL 2016
 PowerShell, Windows 
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
