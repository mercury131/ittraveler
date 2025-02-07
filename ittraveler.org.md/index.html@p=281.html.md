#                 	LVM переезд с диска на диск в виртуальной среде.                	  
***            ***

			
            
		
    
	
    	  Дата: 13.02.2015 Автор Admin  
	В данной статье я расскажу как в виртуальной среде переехать с диска на диск с помощью LVM
1) Добавляем новый диск
2) Обновляем информацию в системе о новых дисках
ls  /sys/class/scsi_host/
echo "- - -" &gt; /sys/class/scsi_host/host0/scan
где host0 подставляется из вывода команды &#8212; ls  /sys/class/scsi_host/
3) Открываем parted
parted /dev/sdb
где /dev/sdb наш новый диск
Создаем GPT записи
mklabel gpt
Создаем Boot раздел и устанавливаем флаги для Grub2
mkpart bbp 1MB 2MB
set 1 bios_grub on
Создаем раздел для LVM
mkpart lvmPartition 2MB 100%
4) Добавляем раздел к физической и логической группе LVM
pvcreate /dev/sdb2
vgextend gr0 /dev/sdb2
5) Переносим данные со старого раздела на новый
pvmove /dev/sda1 /dev/sdb2
6) Удаляем старый диск из группы
vgreduce gr0 /dev/sda1
pvremove /dev/sda1
7) Переустанавливаем Grub2 на новый раздел
grub-install /dev/sdb
Готово! Теперь можно удалить старый диск, и загрузится с нового.
Related posts:Установка и настройка memcacheLVM Добавляем место на диске в виртуальной средеЗапуск команд внутри гостевых ОС в гипервизоре KVM на примере Proxmox
        
             Linux, Виртуализация 
             Метки: Linux, LVM  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
