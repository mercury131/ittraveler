# Установка и настройка Citrix XenServer Часть 4.                	  
***Дата: 27.05.2015 Автор Admin***

В данной статье мы рассмотрим автозапуск виртуальных машин и создание локальных хранилищ.
Добавим новый хост Xen &#8212; xen3.
Настроим автоматический запуск виртуальных машин на хосте xen3.
Открываем консоль сервера, и определяем UUID пула xen3 следующей командой:
```
xe pool-list
```
xe pool-list
В данном случае UUID равен &#8212;  22a1a096-b11c-eeda-194d-58aa6168e6dd
Теперь включаем функцию автостарта на уровне пула xen.
```
xe pool-param-set uuid=22a1a096-b11c-eeda-194d-58aa6168e6dd other-config:auto_poweron=true
```
xe pool-param-set uuid=22a1a096-b11c-eeda-194d-58aa6168e6dd other-config:auto_poweron=true
Теперь включим автозапуск на уровне виртуальных машин.
Получаем список vm командой:
```
xe vm-list
```
xe vm-list
Далее берем параметр UUID необходимой VM и включаем автозапуск:
```
xe vm-param-set uuid=9663daca-6e73-fee7-5571-ba582cf637ca other-config:auto_poweron=true
```
xe vm-param-set uuid=9663daca-6e73-fee7-5571-ba582cf637ca other-config:auto_poweron=true
Теперь перезагрузим хост xen. После загрузки гипервизора виртуальная машина будет запущена.
Перейдем к настройке локальных хранилищ.
Если по каким-то причинам вы не можете использовать общие хранилища, вы можете создать  SR из локальных дисков.
Далее мы создадим:
Локальное хранилище ISO файлов
Локальное хранилище LVM
Локальное хранилище EXT
Выключим хост и добавим 3 диска.
Я добавлю 1 диск на 100 гб для ISO хранилища, 1 диск на 200 гб для LVM SR и 1 диск на 300 гб для EXT SR.
Начнем с настройки  локального хранилища iso файлов.
Открываем консоль сервера xen3 через xencenter.
Посмотрим диски в системе командой:
```
fdisk -l
```
fdisk -l
Вывод будет примерно таким:
В данном случае мне нужен диск /dev/sdb , т.к. его размер 100 гб и на нем мы планировали сделать iso хранилище.
Создадим таблицу разделов на данном диске.
```
fdisk /dev/sdb
```
fdisk /dev/sdb
Теперь если набрать fdisk -l , вы увидите следующую картину:
Теперь создадим на диске файловую систему.
```
mkfs.ext3 /dev/sdb1
```
mkfs.ext3 /dev/sdb1
Создадим папку куда будет подключаться данный диск:
```
mkdir /mnt/isosr
```
mkdir /mnt/isosr
Добавим в  файл /etc/fstab точку монтирования для нового диска:
```
echo "/dev/sdb1  /mnt/isosr		ext3     defaults   1  1" &gt;&gt; /etc/fstab
```
echo "/dev/sdb1&nbsp;&nbsp;/mnt/isosr		ext3&nbsp;&nbsp;&nbsp;&nbsp; defaults&nbsp;&nbsp; 1&nbsp;&nbsp;1" &gt;&gt; /etc/fstab
Подключаем диск:
```
mount /mnt/isosr
```
mount /mnt/isosr
После перезагрузки диск не нужно подключать снова. Он будет подключаться автоматически.
Создадим новое ISO хранилище:
```
xe sr-create name-label=ISO  type=iso device-config:location=/mnt/isosr device-config:legacy_mode=true content-type=iso
```
xe sr-create name-label=ISO&nbsp;&nbsp;type=iso device-config:location=/mnt/isosr device-config:legacy_mode=true content-type=iso
Как видите у нас появилось новое хранилище для ISO образов.
Перейдем к созданию хранилищ виртуальных машин.
Создадим LVM хранилище на диске /dev/sdd , размер которого 200гб.
```
xe sr-create host-uuid=uuid content-type=user type=lvm device-config:device=/dev/sdd shared=false name-label="VM Storage 1"
```
xe sr-create host-uuid=uuid content-type=user type=lvm device-config:device=/dev/sdd shared=false name-label="VM Storage 1"
В данной команде вместо uuid вводится значение uuid хоста, для удобства при вводе команды удалите uuid, чтобы получилось host-uuid= и нажмите Tab, консоль сама подставит значение uuid вашего хоста.
Теперь у нас появилось LVM хранилище для виртуальных машин.
Создадим EXT хранилище, на оставшемся диске /dev/sdc на 300 гб.
```
xe sr-create host-uuid=uuid content-type=user type=ext device-config:device=/dev/sdc shared=false name-label="VM Storage 2"
```
xe sr-create host-uuid=uuid content-type=user type=ext device-config:device=/dev/sdc shared=false name-label="VM Storage 2"
Отличие EXT хранилища в том, что виртуальные машины на нем хранятся в виде файлов, например как на NFS.
EXT хранилище создано!
Готово, теперь у нашего хоста есть одно локальное хранилище ISO дисков, и два хранилища для виртуальных машин.
Но настоятельно рекомендую использовать общие хранилища, т.к. это наиболее надежный способ.
Удачной установки! =)
&nbsp;
&nbsp;
Related posts:Установка и настройка VMWare Vsphere 6. Часть 2Vsphere. Поиск виртуальных машин с толстыми дискамиKVM восстановление qcow2 диска
 Виртуализация 
 Метки: XenServer, Виртуализация  
                        
Комментарии
        
Андрей.
  
19.06.2016 в 00:18 - 
Ответить                                
Приветствую автора.
Интересно было бы увидеть настройку по поводу повышения отказоустойчивости Xen Server.  Касаемо  настройки кластера из двух физических серверов с Xen Server.
А так же как прикручивать к Xen Server мониторинг raid  если имеется в самом железе в  сервере аппаратный контроллер.
        
Admin
  
24.04.2017 в 12:19 - 
Ответить                                
Новая версия Xenserver вроде умеет мониторить железо сервера, в самом XenCenter можно настроить нотификации.
По поводу отказоустийчивости есть статья про настройку HA на Xenserver http://ittraveler.org/ustanovka-i-nastrojka-citrix-xenserver-chast-2/
        
Андрей
  
04.07.2018 в 15:55 - 
Ответить                                
Добрый день, а где третья часть 1,2,4 ?
        
Admin
  
04.07.2018 в 18:10 - 
Ответить                                
Третья часть тут http://ittraveler.org/ustanovka-i-nastrojka-citrix-xenserver-chast-3/ 
        
Михаил
  
27.02.2019 в 11:29 - 
Ответить                                
Добрый день
А можно ли примонтировать диск с имеющейся файлофой системой(к примеру ntfs)
и подключить его к виртуальной машине?
Спасибо
        
Admin
  
05.03.2019 в 10:52 - 
Ответить                                
Насколько я помню, CItrixXen поддерживает проброс внешних usb дисков, с этим проблем нет.
Если нужно целиком пробросить весь диск, то из коробки (через Citrix xen center) такой сценарий не поддерживается.
Но вообще с помощью консоли, люди пробрасывают диски в виртуальные машины, вот несколько топиков, попробуйте:
https://discussions.citrix.com/topic/372192-sata-pass-through/
https://discussions.citrix.com/topic/378709-xenserver-7-sata-passthrough-to-vm/
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
