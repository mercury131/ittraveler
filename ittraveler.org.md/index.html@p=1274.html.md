#                 	KVM восстановление qcow2 диска                	  
***            ***

			
            
		
    
	
    	  Дата: 15.09.2019 Автор Admin  
	В данной статье я расскажу как можно восстановить поврежденный диск VM в формате qcow2Если при запуске виртуальной машины Вы получаете ошибку :
qcow2: Image is corrupt; cannot be opened read/write
то вероятно диск вашей VM поврежден.
Чтобы это проверить выполните команду:
qemu-img info /data/vm_images/CentOS7/system.img
В выводе будет информация поврежден файл или нет
file format: qcow2
virtual size: 20G (21474836480 bytes)
disk size: 6.8G
cluster_size: 65536
Snapshot list:
ID        TAG                 VM SIZE                DATE       VM CLOCK
1         srv7-before-MySQL-Posts   347M 2017-08-10 20:44:07   00:03:33.196
2         Before_MYSQL_upgrade   652M 2017-08-15 07:20:12   00:46:35.477
Format specific information:
    compat: 1.1
    lazy refcounts: true
    refcount bits: 16
    corrupt: true
Насколько сильно поврежден диск можно узнать командой:
qemu-img check /data/vm_images/CentOS7/system.img
Выполнить восстановление диска можно командой:
qemu-img check -r all /data/vm_images/CentOS7/system.img
&nbsp;
Related posts:Настройка Mysql репликации Master - MasterУстановка и настройка сервера GitZFS перенос корневого пула с ОС на новый диск, меньшего размера.
        
             Linux, Виртуализация 
               
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
