#                 	Настройка ZFS в Proxmox                	  
***            ***

			
            
		
    
	
    	  Дата: 29.07.2018 Автор Admin  
	В этой статье мы рассмотрим как создать ZFS разделы и подключить их как хранилища виртуальных машин в Proxmox .
Откроем веб интерфейс Proxmox и перейдем в раздел Disks.
Создадим Mirroring раздел ZFS.
Использовать в массиве RAID 1 мы будем 2 диска по 100GB , а диск на 60 Gb будем использовать в качестве ssh cache.
Для начала найдем ID наших дисков, это нужно для того чтобы диски в массиве были привязаны по ID , а не по пути типа /dev/sdb . Иначе при перестановке дисков буквы изменятся и массив не поднимется.
Выполняем команду ниже и находим ID своих дисков
ls /dev/disk/by-id/
Если вы не уверены в ID диска выполните команду hdparm. она покажет информацию о диске
hdparm -i /dev/sdb
теперь когда вы знаете ID своих дисков выполним команду создания зеркального ZFS пула
zpool create  -f raid1-pool mirror /dev/ata-WDC_WD15EARS-00MVWB0_WD-WMAZ20198340 /dev/ata-WDC_WD10EARS-00Y5B1_WD-WCAV5L720683
Замените raid1-pool, на имя своего пула и укажите свои диски.
Теперь посмотрим список созданных пулов командой ниже:
zpool list
Видим созданный пул
NAME         SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
raid1-pool  59.5G   272K  59.5G         -     0%     0%  1.00x  ONLINE  -
теперь добавим в наш пул SSH cache
zpool add -f raid1-pool cache /dev/disk/by-id/ata-KINGSTON_SV300S37A120G_50026B723C0A2039
Теперь посмотрим статус нашего пула командой
zpool status
        NAME        STATE     READ WRITE CKSUM
        raid1-pool  ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            ata-WDC_WD15EARS-00MVWB0_WD-WMAZ20198340     ONLINE       0     0     0
            ata-WDC_WD10EARS-00Y5B1_WD-WCAV5L720683      ONLINE       0     0     0
        cache
          ata-KINGSTON_SV300S37A120G_50026B723C0A2039       ONLINE       0     0     0
Теперь вы видите информацию о пуле, наш пул зеркальный, показаны имена дисков и диск под кэш.
Давайте включим сжатие на этом пуле, выполните команду:
zfs set compression=on raid1-pool
Получить информацию о том включено ли сжатие можно командой;
zfs get compression raid1-pool
NAME        PROPERTY     VALUE     SOURCE
raid1-pool  compression  on        local
Также можно включить Online дедупликацию файлов
zfs set dedup=on raid1-pool
Получить информацию о статусе дедупликации можно командой:
zfs get dedup raid1-pool
NAME        PROPERTY  VALUE          SOURCE
raid1-pool  dedup     on             local
Обратите внимание что Online дедупликация очень ресурсоемкая функция и для ее корректной производительности нужно много свободной оперативной памяти.
Также обратите внимание что при отключении дедупликации, ранее дедуплицированные файлы не будут иметь исходный размер, данные так и останутся дедуплицированными.
Для повышения производительности пула можно отключить синхронизацию
zfs set sync=disabled raid1-pool
Обратите внимание что при отключенной синхронизации возможна потеря данных при отключении питания.
Это означает что данные за последние 5 секунд могут быть потеряны.
Теперь подключим созданный ZFS пул в качестве хранилища VM.
Переходим в веб интерфейс, открываем Datacenter и переходим в раздел Storage, нажимаем кнопку add, выбираем ZFS
В поле ID указываем произвольное имя нашего хранилища, далее  выбираем созданный zfs пул и включаем thin provision (использование тонких дисков для VM)
Теперь в списке появилось наше новое хранилище
рассмотрим какие типы ZFS еще можно создать.
&nbsp;
Раздел без зеркалирования (RAID0)
zpool create -f [new pool name] /dev/sdb /dev/sdc
RAID10 (2 RAID0 в одном RAID1 минимум 4 диска)
zpool create [pool name] \
mirror disk1 disk2 \
mirror disk3 disk4
RAIDZ, он же RAID5
zpool create -f [pool name] raidz /dev/sdb /dev/sdc /dev/sdd
RAIDZ2 , он же RAID6 (обладает более высокой надежностью в отличие от RAIDZ)
zpool create -f [pool name] raidz2 /dev/sdb /dev/sdc /dev/sdd
Если вам нужно добавить новый диск в пул ZFS, выполните команду:
zpool add [existing pool name] /dev/sdd
Для удаления пула выполните команду
zpool destroy [pool name]
&nbsp;
На этом базовая настройка завершена, надеюсь статья была вам полезна)
Related posts:Восстановление пароля root на сервере MysqlУстановка и настройка Foreman + PuppetУстановка и настройка кластера MongoDB (replication set)
        
             Bash, Debian, Linux, Ubuntu, Виртуализация 
             Метки: Linux, proxmox, zfs  
        
            
        
    
                        
                    
                    
                
        
                
	
		
		Добавить комментарий Отменить ответВаш адрес email не будет опубликован. Обязательные поля помечены *Комментарий * Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
	
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
			
        
        
		
        
           
    
    
  
	
    
		
        
             
			
                
                    
                                                  Все права защищены. IT Traveler 2025 
                         
                        
																														                    
                    
				
                
                
    
			
		                            
	
	
                
                
			
                
		
        
	
    
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
