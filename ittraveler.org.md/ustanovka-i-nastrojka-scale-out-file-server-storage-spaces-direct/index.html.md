# Установка и настройка Scale-Out File Server + Storage Spaces Direct                	  
***Дата: 24.06.2018 Автор Admin***

В рамках этой статьи мы настроим отказоустойчивый файловый кластер, данные которого будут находится на пуле Storage Spaces direct.
Итак, нам понадобится 2-а сервера на базе Windows server 2016 введенные в домен active directory
Далее на каждом сервере настройте статические ip адреса и добавьте роль failover clustering командами powershell:
PowerShell
```
Install-WindowsFeature Failover-Clustering –IncludeManagementTools -ComputerName "srv-cl1"
Install-WindowsFeature Failover-Clustering –IncludeManagementTools -ComputerName "srv-cl2"
```
Install-WindowsFeature Failover-Clustering –IncludeManagementTools -ComputerName "srv-cl1"Install-WindowsFeature Failover-Clustering –IncludeManagementTools -ComputerName "srv-cl2"
Вместо srv-cl1 и srv-cl2 введите имена своих серверов.
Далее на любом из серверов откройте failover cluster manager.
Далее запустите создание нового кластера
Добавьте в список свои сервера
Запустите проверку на возможность использовать сервера в кластере
После того как все проверки завершились введите имя создаваемого кластера и назначьте его ip адрес
Далее запустите процесс создания нового кластера и дождитесь завершения этого процесса
Далее убедитесь что на ваших серверах есть диски, которые можно включить в Storage Spaces Direct пул.
Для этого выполните команду на каждом сервере:
PowerShell
```
Get-PhysicalDisk –CanPool $True | Sort Model
```
Get-PhysicalDisk –CanPool $True | Sort Model
В результате вы получите список дисков
Далее активируем Storage Spaces Direct командой:
PowerShell
```
Enable-ClusterStorageSpacesDirect
```
Enable-ClusterStorageSpacesDirect
После успешного выполнения команды откройте failover cluster manager, теперь в информации о кластере отображается что Storage Spaces Direct включен
В разделе Pools, созданный пул тоже отображается
&nbsp;
Теперь перейдем к созданию Scale Out File сервера.
В failover cluster manager нажмите Roles -&gt; Configure Role
Выберите роль file server
Далее укажите что нам нужен именно scale out file server
Введите имя сервера, это то сетевое имя по которому будут подключаться клиенты
Как только мастер закончит создание роли вы увидите ее в списке ролей сервера
Далее создадим виртуальный диск для нашего кластера, нажмите правой кнопкой по пулу и выберите
New Virtual Disk
Далее выберите созданный ранее пул и укажите имя создаваемого диска
Далее укажите размер диска
Подтвердите выбор и нажмите create
Далее, после того как виртуальный диск будет создан, в открывшемся мастере укажите что диск должен быть презентован для нашего Scale out file сервера
Теперь новый виртуальный диск виден в разделе Disks
Чтобы создать на сервере файловую шару нажмите правой кнопкой мыши по роли и выберите &#8212; Add File Share
В качестве примера выберем профиль quick
Далее укажем на каком диске и сервере будет создана шара
Далее укажите имя шары
Теперь укажем настройки для этой шары
Пункт Access Based enumeration &#8212; означает что при включении этой опции шара будет видна только тем пользователям у которых есть на нее права, другие пользователи в списке шар ее не увидят.
Пункт Continuous availability позволяет клиентам продолжать работу с шарой в случае отказа одной из нод кластера, без разрыва соединения. Данный пункт особенно актуален для приложений которые могут использовать шару
Далее можно включить поддержку кэширования и поддержку шифрования сетевого трафика.
Обратите внимание что шифрование не поддерживают клиенты младше Windows 8.
Далее настройте необходимые вам права доступа и нажмите Create.
&nbsp;
Готово, на этом настройка завершена, мы построили масштабируемый отказоустойчивый файловый кластер.
&nbsp;
&nbsp;
&nbsp;
Related posts:Установка и настройка AlwaysOn на MS SQL 2016Аудит незаполненных полей в Active Directory через PowershellУстановка и настройка Lync 2013
 Windows, Windows Server, Без рубрики 
 Метки: File-Server, S2D, Windows Server  
                        
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
