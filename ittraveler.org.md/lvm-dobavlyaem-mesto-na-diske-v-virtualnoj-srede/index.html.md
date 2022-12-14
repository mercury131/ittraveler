# LVM Добавляем место на диске в виртуальной среде                	  
***Дата: 13.02.2015 Автор Admin***

В данной статье мы рассмотрим как в режиме онлайн добавить свободное место на диске, в виртуальной среде.
1) Добавляем место на диске LVM (делается в вашей системе виртуализации)
2) Обновим информацию о свободном пространстве
Просмотрим iscsi адреса
```
ls /sys/class/scsi_device/
```
ls /sys/class/scsi_device/
Выполним для них rescan
```
echo 1 &gt; /sys/class/scsi_device/0\:0\:0\:0/device/rescan
```
echo 1 &gt; /sys/class/scsi_device/0\:0\:0\:0/device/rescan
3) Открываем parted и создаем новый раздел
```
parted
```
parted
На предупреждение parted вводим Fix
смотрим список разделов
```
print
```
print
Создаем новый раздел
```
mkpart lvmPartition 10GB 100%
```
mkpart lvmPartition 10GB 100%
где 10GB размер последнего раздела
4) Добавляем новый раздел в LVM группы
```
pvcreate /dev/sda3
```
pvcreate /dev/sda3
```
vgextend gr0 /dev/sda3
```
vgextend gr0 /dev/sda3
5) Проверяем свободное пространство в LVM
```
vgdisplay | grep Free
```
vgdisplay | grep Free
6) Добавляем свободное пространство к группе
```
lvextend -L+#G /dev/VolGroup00/LogVol00
```
lvextend -L+#G /dev/VolGroup00/LogVol00
где # размер добавляемого места и /dev/VolGroup00/LogVol00 путь lvm
7) Добавляем размер к существующей файловой системе
```
resize2fs /dev/VolGroup00/LogVol00
```
resize2fs /dev/VolGroup00/LogVol00
Готово!
&nbsp;
Если вы используете LVM с таблицей разделов MBR (например используется в Ubuntu 14.04) то следуйте следующей инструкции:
1) Добавляем место на диске LVM (делается в вашей системе виртуализации)
2) Обновим информацию о свободном пространстве
Просмотрим iscsi адреса
```
ls /sys/class/scsi_device/
```
ls /sys/class/scsi_device/
Выполним для них rescan
```
echo 1 &gt; /sys/class/scsi_device/0\:0\:0\:0/device/rescan
```
echo 1 &gt; /sys/class/scsi_device/0\:0\:0\:0/device/rescan
3) Открываем fdisk и создаем новый раздел
```
fdisk /dev/sda
```
fdisk /dev/sda
где sda ваш диск
Добавляем новые разделы
```
Command (m for help): n
```
Command (m for help): n
```
Partition type: p
```
Partition type: p
```
Partition number (1-4, default 3): 3
```
Partition number (1-4, default 3): 3
```
First sector (499712-52428799, default 499712): 499712
```
First sector (499712-52428799, default 499712): 499712
```
Last sector, +sectors or +size{K,M,G} (499712-501757, default 501757): 501757
```
Last sector, +sectors or +size{K,M,G} (499712-501757, default 501757): 501757
Создаем еще 1 раздел
```
Command (m for help): n
```
Command (m for help): n
```
Partition type: p
```
Partition type: p
```
Selected partition 4
```
Selected partition 4
```
First sector (33552384-52428799, default 33552384): 33552384
```
First sector (33552384-52428799, default 33552384): 33552384
```
Last sector, +sectors or +size{K,M,G} (33552384-52428799, default 52428799): 52428799
```
Last sector, +sectors or +size{K,M,G} (33552384-52428799, default 52428799): 52428799
Сохраняем изменения
```
Command (m for help): w
```
Command (m for help): w
4) Обновляем информацию о разделах в системе:
```
partprobe
```
partprobe
5) Добавляем новый раздел в LVM группы
```
pvcreate /dev/sda4
```
pvcreate /dev/sda4
```
vgextend gr0 /dev/sda4
```
vgextend gr0 /dev/sda4
6) Проверяем свободное пространство в LVM
```
vgdisplay | grep Free
```
vgdisplay | grep Free
7) Добавляем свободное пространство к группе
```
lvextend -L+#G /dev/VolGroup00/LogVol00
```
lvextend -L+#G /dev/VolGroup00/LogVol00
где # размер добавляемого места и /dev/VolGroup00/LogVol00 путь lvm
8) Добавляем размер к существующей файловой системе
```
resize2fs /dev/VolGroup00/LogVol00
```
resize2fs /dev/VolGroup00/LogVol00
Готово!
&nbsp;
Related posts:Настройка прокси сервера Tor на Ubuntu.Установка и настройка Radius сервера на Ubuntu с веб интерфейсом.Установка и настройка Citrix XenServer Часть 1.
 Linux, Виртуализация 
 Метки: Linux, LVM  
                        
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
