#                 	ZFS перенос корневого пула с ОС на новый диск, меньшего размера.                	  
***            ***

			
            
		
    
	
    	  Дата: 15.09.2019 Автор Admin  
	Понадобилось перенести ос, расположенную на zfs, на новый SSD диск меньшего размера. В этой статье я расскажу как это сделать.Обычно проблем с переносом нет, если оба диска имеют одинаковый размер, просто создаем в ZFS Raid1, ждем синхронизации данных и потом удаляем старый диск, но т.к в моем случае диск меньше (SSD 360 GB против HDD 500GB) , то сделать зеркало не получится.
Итак, вот последовательность действий, которая позволит перенести ОС на ZFS на меньший диск, при условии что данные на него поместятся.
Итак, первым делом, с помощью fdisk создаем boot и efi разделы аналогичного размера как на исходном диске.
Далее с помощью dd переносим эти разделы на новый диск.
Создаем третий раздел под новый ZFS пул.
Создаем ZFS пул, куда мы будем переносить ОС, в моем случае пул называется rpoolssd.
Далее создаем снапшот оригинального пула
zfs snapshot -r rpool@today1
Переносим снапшот на новый пул
zfs send -R rpool@today1 |pv| zfs receive -F rpoolssd
откатываемся на снапшот
zfs rollback rpoolssd@today1
Монтируем новый пул и выполняем chroot
zfs set mountpoint=/test rpoolssd/ROOT/pve-1
zfs mount rpoolssd/ROOT/pve-1
cd /test
$ mount --bind /dev dev
$ mount --bind /proc proc
$ mount --bind /sys sys
$ mount --bind /run run
$ chroot .
Далее редактируем grub, указываем новый пул как загрузочный
делаем
update-grub
Выходим из chroot
exit
Отмонтируем разделы и изменим точку монтирования / на новый zfs пул
umount /test/dev
umount /test/proc
umount /test/sys
umount /test/run
zfs umount rpoolssd/ROOT/pve-1
zfs set mountpoint=/ rpoolssd/ROOT/pve-1
Перезагружаемся, grub запуститься со старого диска, в загрузочном меню нажимаем e и редактируем строку с указанием zfs пула , указываем новый пул.
Загружаемся в ос на новом диске.
Выполняем
install-grub
на новый диск, на новом пуле.
перезагружаемся, отключаем старый диск.
Related posts:Настройка связки веб серверов Nginx + ApacheУстановка и настройка сервера GitКак работать с LVM
        
             Linux 
               
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
