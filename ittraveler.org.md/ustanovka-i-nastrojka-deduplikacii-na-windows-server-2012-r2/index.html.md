# Установка и настройка дедупликации  на Windows Server 2012 R2                	  
***Дата: 03.06.2016 Автор Admin***

В данной статье я расскажу как легко и быстро можно настроить дедупликацию через Powershell.
1) Устанавливаем роль дедупликации.
PowerShell
```
Import-Module ServerManager
Add-WindowsFeature -name FS-Data-Deduplication
Import-Module Deduplication
```
Import-Module ServerManagerAdd-WindowsFeature -name FS-Data-DeduplicationImport-Module Deduplication
2) Включаем дедупликацию. В данном случае на диске E
PowerShell
```
Enable-DedupVolume E: -UsageType Default
```
Enable-DedupVolume E: -UsageType Default
Если вы планируете дедуплицировать хранилище дисков виртуальных машин Hyper-v, используйте следующую команду:
PowerShell
```
Enable-DedupVolume E: -UsageType HyperV
```
Enable-DedupVolume E: -UsageType HyperV
3) Задаем минимальное количество дней, после которых выполняется дедупликация файлов
PowerShell
```
Set-Dedupvolume E: -MinimumFileAgeDays 20
```
Set-Dedupvolume E: -MinimumFileAgeDays 20
Если необходимо дедупликацировать файлы сразу и вам необходима максимальная дедупликация установите значение 0
4) Добавляем каталог, который не нужно дедупликацировать (если необходимо)
PowerShell
```
Set-DedupVolume –Volume "E:" -ExcludeFolder "E:\temp"
```
Set-DedupVolume –Volume "E:" -ExcludeFolder "E:\temp"
5) Устанавливаем минимальный размер файла
PowerShell
```
Set-DedupVolume –Volume "E:" -MinimumFileSize "32768"
```
Set-DedupVolume –Volume "E:" -MinimumFileSize "32768"
6) Отключаем дедупликацию используемых файлов
PowerShell
```
Set-DedupVolume –Volume "E:" -OptimizeInUseFiles:$False
Set-DedupVolume –Volume "E:" -OptimizePartialFiles:$False
```
Set-DedupVolume –Volume "E:" -OptimizeInUseFiles:$False&nbsp;Set-DedupVolume –Volume "E:" -OptimizePartialFiles:$False
Для просмотра текущих запущенных заданий дедупликации выполните команду:
PowerShell
```
Get-DedupJob
```
Get-DedupJob
Для просмотра существующих заданий используйте команду:
PowerShell
```
Get-DedupSchedule
```
Get-DedupSchedule
Если вы хотите добавить новое задание используйте команду &#8212; New-DedupSchedule
Ниже пример как добавить задание оптимизации:
PowerShell
```
New-DedupSchedule –Name "ThroughputOptimization" –Type Optimization –Days on,Tues,Wed,Thurs,Fri,Sunday –Start 00:00 –DurationHours 8 -Priority Normal
```
New-DedupSchedule –Name "ThroughputOptimization" –Type Optimization –Days on,Tues,Wed,Thurs,Fri,Sunday –Start 00:00 –DurationHours 8 -Priority Normal
Теперь разберем этот пример
–Name &#8212; имя нового задания
–Type тип задания (Optimization/GarbageCollection/Scrubbing)
Scrubbing &#8212; восстановление поврежденных данных
GarbageCollection &#8212; сборка мусора (высвобождение места)
Optimization &#8212; дедупликация и сжатие данных
–Days дни в которые задание должно запускаться
&#8212;Start в какое время
–DurationHours сколько часов может выполняться задание
&#8212;Priority приоритет
Для просмотра текущего статуса дедупликации используйте команду:
PowerShell
```
Get-DedupVolume
```
Get-DedupVolume
Вывод будет таким:
Enabled    UsageType      SavedSpace      SavingsRate    Volume
&#8212;&#8212;-         &#8212;&#8212;&#8212;             &#8212;&#8212;&#8212;-           &#8212;&#8212;&#8212;&#8212;         &#8212;&#8212;
True           Default             76.94 GB            66 %                 E:
В моем случае дедупликация превратила 65 GB в 354MB.
Это очень эффективно!  Удачной настройки! =)
Related posts:Переход на репликацию SYSVOL по DFSАвтоматическая активация пользователей Lync через PowershellНовые компьютеры не появляются на WSUS сервере
 PowerShell, Windows Server 
 Метки: Powershell, Windows Server, дедупликация  
                        
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
