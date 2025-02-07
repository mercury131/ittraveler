#                 	Восстановление ZFS пула при статусе FAULTED                	  
***            ***

			
            
		
    
	
    	  Дата: 07.02.2025 Автор Admin  
	Если про какой-то причине ваш пул перешел в состояние FAULTED и при вызове zpool status POOLNAME вы видите ошибки:
pool metadata is corrupted zfs
zpool import zroot gives 4 times failed to load zpool zroot.

Cannot import POOL: I/O error
Destroy or re-create the pool from a backup source.
Значит дело плохо.
Виной может быть умирающий HDD с битыми секторами.
Еще хуже если пул совсем пропал из системы и найти его можно только командой:
zpool import
Но при импорте пула вы скорее всего получите ошибку:
Cannot import POOL: I/O error
Destroy or re-create the pool from a backup source.
Звучит страшно, импортировать не можем данные повреждены, только бэкап (если он у вас был, а если нет?)
Давайте рассмотри как восстановить пул.
Важно понимать &#8212; если ваш HDD умирает, лучше не рисковать, а по возможности снять с него посекторную копию и уже работать с ней.
Именно это мы и сделаем.
Ставим ddrescue
apt install gddrescue
Далее запустим посекторное копирование данных с диска поврежденного пула в файл (главное чтобы у вас хватило места) , также обязательно укажем  map фай &#8212; это лог куда ddrescue будет записывать прогресс, и если вдруг ваш HDD начнет сбоить (например от перегрева или других причин приводящих к временной недоступности), вы сможете продолжить процесс.
Запускаем копирование:
ddrescue -f -n -v -b 4096 /dev/sdb /mnt/pve/NAS/POOL_backup mapfile
Обратите внимание 4096  &#8212; размер сектора.
Терпеливо ждем пока образ будет готов.
Далее нам нужно подключить его как loop device, да поидее ZFS может делать импорт из файла, но у нас другой случай, у нас повреждены метаданные и такой трюк уже не пройдет, при импорте мы получим ошибку:
root@proxmox-lab1:~# zpool import -fF -d /mnt/pve/NAS/POOL_backup POOL
cannot import 'POOL': no such pool available
Давайте подключим наш образ как loop device (нам нужно получить блочное устройство)
losetup -fP --show /mnt/pve/NAS/POOL_backup
Супер! Теперь с помощью команды zdb проверим что у нас вообще забэкапилось:
zdb -e POOL /dev/loop0
Вывод будет примерно такой:
Configuration for import:
        vdev_children: 4
        hole_array[0]: 1
        hole_array[1]: 2
        version: 5000
        pool_guid: 5643723023173928716
        name: 'POOL'
        state: 0
        hostid: 2815505493
        hostname: 'proxmox-lab1'
        vdev_tree:
            type: 'root'
            id: 0
            guid: 5643723023173928716
            children[0]:
                type: 'disk'
                id: 0
                guid: 12377229841096381893
                whole_disk: 1
                metaslab_array: 256
                metaslab_shift: 33
                ashift: 12
                asize: 1000189984768
                is_log: 0
                DTL: 1066
                create_txg: 4
                degraded: 1
                aux_state: 'err_exceeded'
                path: '/dev/loop0p1'
            children[1]:
                type: 'hole'
                id: 1
                guid: 0
            children[2]:
                type: 'hole'
                id: 2
                guid: 0
        load-policy:
            load-request-txg: 18446744073709551615
            load-rewind-policy: 2
zdb: can't open 'POOL': Input/output error
Отлично! Метаданные есть, информация о пуле есть.
Только прочитать ег омы все еще не можем.
Но это не беда, инспектируем пул, проверим возможно ли откатится на последнюю удачную транзакцию (до момента когда пул вышел из строя):
zpool import -f -FXn POOL
Вывод должен быть примерно таком:
Would be able to return POOL to its state as of Tue Jan 25 19:12:24 2025.
Would discard approximately 3 minutes of transactions.
Хорошо, можно откатится до последней удачной транзакции! Запускаем процесс отката:
zpool import -f -FX POOL
И после завершения импортируем пул как обычно:
zpool import -f -FX POOL
Теперь пул должен появится в системе и быть виден через zpool status
Помним, что мы работаем с образом!
Самое время скопировать с пула все важные данные и после этого его экспортировать:
zpool export POOL
И отключить loop device:
losetup -d /dev/loop0
Надеюсь эта статья вам никогда не понадобится ;)
Всем удачи, делайте и проверяйте бэкапы!
Related posts:Установка и настройка Kafka кластераНастраиваем Postfix как антиспам Frontend.Перенос виртуальной машины из Hyper-V в Proxmox (KVM)
        
             Linux 
             Метки: proxmox, zfs  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
