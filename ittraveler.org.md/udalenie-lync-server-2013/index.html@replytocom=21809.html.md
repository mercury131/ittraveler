# Удаление Lync Server 2013                	  
***Дата: 27.07.2015 Автор Admin***

Если вам нужно удалить MS Lync 2013 , и почистить инфраструктуру Active Directory от следов Lync 2013, прошу под кат.
1) Запускаем Powershell на сервере Lync от имени администратора.
2) Отключаем всех пользователей Lync командой:
```
Get-CsUser | Disable-CsUser
```
Get-CsUser | Disable-CsUser
3) Удаляем созданные конференции
Получаем конференции командой:
```
Get-CsConferenceDirectory
```
Get-CsConferenceDirectory
Из вывода команды запоминаем значение Identity
Удаляем конференции
```
Get-CsConferenceDirectory -Identity 1 | Remove-CsConferenceDirectory –force
```
Get-CsConferenceDirectory -Identity 1 | Remove-CsConferenceDirectory –force
4) Удаляем авторизованные приложения пула Lync 2013
```
Get-CsTrustedApplication | Remove-CsTrustedApplication –force
```
Get-CsTrustedApplication | Remove-CsTrustedApplication –force
5) Удаляем контакты Exchange UM
```
Get-CsExUmContact -Filter {RegistrarPool -eq "your_lync_server.domain.local"} | Remove-CsExUmContact
```
Get-CsExUmContact -Filter {RegistrarPool -eq "your_lync_server.domain.local"} | Remove-CsExUmContact
6) Удаляем контакты для групп
```
Get-CsRgsWorkflow -Identity:Service:ApplicationServer:your_lync.domain.local | Remove-CsRgsWorkflow
```
Get-CsRgsWorkflow -Identity:Service:ApplicationServer:your_lync.domain.local | Remove-CsRgsWorkflow
7) Удаляем контакты для конференций
```
Get-CsDialInConferencingAccessNumber | where {$_.Pool -eq "your_lyncserver.domain.local"} | Remove-CsDialInConferencingAccessNumber
```
Get-CsDialInConferencingAccessNumber | where {$_.Pool -eq "your_lyncserver.domain.local"} | Remove-CsDialInConferencingAccessNumber
8) Удаляем настройки AreaPhone и AnalogDevice
```
Get-CsCommonAreaPhone | Remove-CsCommonAreaPhone 
```
Get-CsCommonAreaPhone | Remove-CsCommonAreaPhone 
```
Get-CsAnalogDevice | Remove-CsAnalogDevice
```
Get-CsAnalogDevice | Remove-CsAnalogDevice
9) Удаляем настройки call park
```
Get-CsCallParkOrbit | Remove-CsCallParkOrbit  -Force
```
Get-CsCallParkOrbit | Remove-CsCallParkOrbit&nbsp;&nbsp;-Force
10) Удаляем голосовые маршруты
```
Get-CsVoiceRoute | Remove-CsVoiceRoute
```
Get-CsVoiceRoute | Remove-CsVoiceRoute
10) Откройте мастер построения топологий и удалите все шлюзы. Затем опубликуйте топологию
&nbsp;
12) Удалите EDGE сервер если он есть.
13) Отключите федерацию на сайте Lync и опубликуйте топологию.
14) В мастере построения топологии удалите развертывание
15) Если у вас имеется сервер frontend выполните на нем команду:
```
Publish-CsTopology -FinalizeUninstall
```
Publish-CsTopology -FinalizeUninstall
16) Удаляем развертывание через bootstrapper
```
cd "C:\Program Files\Microsoft Lync Server 2013\Deployment\"
```
cd "C:\Program Files\Microsoft Lync Server 2013\Deployment\"
```
.\bootstrapper.exe /scorch
```
.\bootstrapper.exe /scorch
17) Удаляем базы данных:
```
Uninstall-CsDatabase -DatabaseType Application –SqlServerFqdn your_lyncserver.domain.local –SqlInstanceName rtc
```
Uninstall-CsDatabase -DatabaseType Application –SqlServerFqdn your_lyncserver.domain.local –SqlInstanceName rtc
```
Uninstall-CsDatabase -CentralManagementDatabase –SqlServerFqdn your_lyncserver.domain.local -SqlInstanceName rtc
```
Uninstall-CsDatabase -CentralManagementDatabase –SqlServerFqdn your_lyncserver.domain.local -SqlInstanceName rtc
18) Удаляем хранилище SCP Central Management Store
```
Remove-CsConfigurationStoreLocation
```
Remove-CsConfigurationStoreLocation
19) Удаляем информацию о Lync server из Active Directory
```
Disable-CsAdDomain
```
Disable-CsAdDomain
```
Disable-CsAdForest
```
Disable-CsAdForest
&nbsp;
Related posts:Установка и настройка кластера MSSQL 2012.Создание индивидуальных адресных книг в Office 365 и Exchange onlineВосстановление объектов Active Directory: сборник сценариев
 PowerShell, Windows, Windows Server 
 Метки: Lync  
                        
Комментарии
        
Сергей
  
09.02.2016 в 12:12 - 
Ответить                                
Спасибо за мануал.. Правда поправка по последним двум коммандам- надо добавить -force иначе  не сработает.
        
Admin
  
10.02.2016 в 08:26 - 
Ответить                                
Добрый день!
Спасибо за замечание, возможно в некоторых конфигурациях ключ force необходим.
При стандартном удалении он не требуется.
        
Алексей
  
29.01.2020 в 17:08 - 
Ответить                                
Большое спасибо за мануал.
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
