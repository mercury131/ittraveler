#                 	Как работать с LVM                	  
***            ***

			
            
		
    
	
    	  Дата: 15.09.2019 Автор Admin  
	В этой статье рассмотрим как работать с LVM, а именно как создать/расширить/удалить LVM.
Чтобы создать LVM необходимо подготовить physical volumes, который состоит из физических дисков, на которых и будет располагаться Volume Group LVM.
Создаем physical volumes на 3-х дисках:
pvcreate /dev/sdb /dev/sdc /dev/sdd
Посмотреть список physical volumes можно командой:
pvs
также можно более детально посмотреть информацию о диске
pvdisplay /dev/sdX
Теперь эти диски можно добавить в Volume Group, на котором будет создаваться LVM.
Создадим Volume Group из двух дисков:
vgcreate vg00 /dev/sdb /dev/sdc
Посмотреть информацию о VG можно командой:
vgdisplay vg00
Теперь все готово к созданию LVM, создадим 2 раздела, первый на 10 GB
lvcreate -n vol_projects -L 10G vg00
Второй будет размером равным оставшемуся месту
lvcreate -n vol_backups -l 100%FREE vg00
Посмотреть список LVM можно командой:
lvs
Либо более подробно о конкретном разделе
lvdisplay vg00/vol_projects
Теперь можно создать файловую систему на этих разделах
# mkfs.ext4 /dev/vg00/vol_projects
# mkfs.ext4 /dev/vg00/vol_backups
Теперь рассмотрим как можно менять размер LVM разделов.
Уменьшим размер раздела vol_projects
lvreduce -L -2.5G -r /dev/vg00/vol_projects
И увеличим раздел vol_backups
lvextend -l +100%FREE -r /dev/vg00/vol_backups
Также нужно выполнить команду resize2fs , для применения изменений в файловой системе.
Теперь рассмотрим как добавить диск в VG.
Добавляем свободный диск в VG
vgextend vg00 /dev/sdd
Командой
vgdisplay vg00
можно убедиться что диск добавлен в VG
Соответственно для удаления PV используется команда
pvremove
Для удаления LVM
lvremove
Для удаления VG
vgremove
Соответственно если вы хотите удалить все, то нужно удалить LVM, потом VG, потом PV.
Теперь рассмотрим как создать &#171;тонкий&#187; LVM.
В примере ниже я создам LVM на 100 MB и внутри него тонкий LVM на 1 GB.
lvcreate -L 100M -T vg001/mythinpool
lvcreate -V1G -T vg001/mythinpool -n thinvolume
&nbsp;
Related posts:Настройка ZFS в ProxmoxУстановка и настройка веб сервера Apache 2Настраиваем Postfix как антиспам Frontend.
        
             Debian, Linux, Ubuntu 
               
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
