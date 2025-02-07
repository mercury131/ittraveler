#                 	Настройка дисковых квот в Ubuntu                	  
***            ***

			
            
		
    
	
    	  Дата: 14.10.2015 Автор Admin  
	Если вам нужно настроить дисковые квоты для пользователей прошу под кат)
Данная заметка актуальна для Ubuntu 14.04 LTS.
Устанавливаем поддержку квот
sudo apt-get install quota
Далее в файл /etc/fstab , в строку с вашей точкой монтирования прописываем следующие параметры:
usrquota,grpquota
Должно получиться примерно так:
/dev/sda1 / ext4 errors=remount-ro,usrquota,grpquota 0
Теперь перемонтируем файловую систему
sudo mount -o remount /
Создадим тестового юзера для проверки
sudo useradd test -b /home -m -U -s /bin/bash
Назначим пароль тестовому пользователю
sudo passwd test
Перезапускаем сервис с квотами для применения изменений
/etc/init.d/quota restart
Теперь назначим пользователю квоту
edquota -u test
После этого вы попадете в редактор, в котором можно назначить квоты пользователю.
Рассмотрим параметры:
Blocks &#8212; место используемое пользователем в блоках (длинна 1kB)
Inodes &#8212; Число файлов которое пользователь может использовать.
Soft Limit &#8212; Максимальная квота в килобайтах. ( В данном случае пользователь получит предупреждение когда привысит лимит)
Hard Limit &#8212; Максимальная квота в килобайтах. ( В данном случае пользователь получит предупреждение когда привысит лимит и не сможет закачать новые файлы)
Для сохранения нажимаем ctrl X
Льготный период, используемый параметром Soft Limit можно установить командой
edquota –t
По умолчанию данный период &#8212; 7 дней.
Посмотреть отчет по квотам можно командой
repquota -u /
Если во время перезапуска службы квот Вы получили ошибку
quotacheck: Cannot guess format from filename on /dev/mapper/ , где /dev/mapper/ путь к вашему дисковому устройству
Выполните следующую команду
quotacheck -F vfsv0 -afcvdugm
Это запустит принудительную синхронизацию.
Если Вы используете виртуальный сервер в облаке Amazon EC2 и при перезапуске службы квот получаете ошибку:
quotaon: using //aquota.user on /dev/disk/by-uuid/ [/]: No such process
 quotaon: Quota format not supported in kernel.
Установите пакет linux-image-extra-virtual
apt-get install linux-image-extra-virtual
Это исправит данную проблему.
Удачной настройки =)
Related posts:Установка и настройка Kafka кластераУстановка и настройка веб сервера NginxОптимизация изображений на веб сервере
        
             Bash, Linux, Ubuntu 
             Метки: Linux, Ubuntu  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
