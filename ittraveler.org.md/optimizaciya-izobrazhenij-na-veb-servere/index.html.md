#                 	Оптимизация изображений на веб сервере                	  
***            ***

			
            
		
    
	
    	  Дата: 12.05.2017 Автор Admin  
	Если вы или ваши пользователи загружают изображения на ваш сайт, то рано или поздно они начнут занимать неприлично много места.
В данной статье я расскажу как оптимизировать все jpg и png изображения на вашем веб сервере. 
В оптимизации изображений нам помогут следующие утилиты &#8212; jpegoptim и optipng.
Установим их, в качестве примера я буду использовать Ubuntu server
apt-get update
apt-get install jpegoptim optipng
Рассмотрим как можно использовать данные утилиты.
Для оптимизации JPG достаточно выполнить команду:
jpegoptim --size=100k YourPIC.jpeg --overwrite
На мой взгляд наиболее оптимально использовать параметр size=250k , тогда команда будет выглядеть так:
jpegoptim --size=250k YourPIC.jpeg --overwrite
Теперь рассмотрим оптимизацию PNG.
Выполним команду:
optipng -o5 YourPIC.png
Если вы хотите сжать изображение еще сильнее, то используйте параметр -o7 , команда будет выглядеть так:
optipng -o7 YourPIC.png
Обратите внимание , что при использовании параметра -o7 у вас увеличится утилизация CPU на сервере.
Теперь для автоматизации всего этого добра создадим такой скрипт:
#!/bin/bash

picdir='/hosting/website/upload/images'

# Optimize JPG
jpgs=$(find $picdir -iname *.jpg )

for jpg in $jpgs
do

echo $jpg

jpegoptim --size=250k $jpg
chown www-data $jpg


done

# Optimize JPEG
jpegs=$(find $picdir -iname *.jpeg )

for jpeg in $jpegs
do

echo $jpeg

jpegoptim --size=250k $jpeg
chown www-data $jpeg


done


# Optimize PNG
pngs=$(find $picdir -iname *.png )

for png in $pngs
do

echo $png

optipng -o7 $png
chown www-data $png

done
Сохраните себе этот скрипт , в переменной picdir вместо /hosting/website/upload/images укажите путь к каталогу с изображениями на вашем сайте.
Не забудьте сделать скрипт исполняемым , командой chmod +x ./your_script.sh
Теперь можно добавить его в крон
crontab -e
0 1 * * * /path_to_script/your_script.sh
Обратите внимание что при запуске этого скрипта у вас увеличится утилизация CPU , запускайте скрипт в то время, когда у вас мало посетителей на сайте, перед запуском обязательно протестируйте оптимизацию изображений на тестовом стенде, возможно для вас параметры -o7 и &#8212;size=250k не оптимальные.
Related posts:Установка и настройка Radius сервера на Ubuntu с веб интерфейсом.Установка и настройка Foreman + PuppetLVM переезд с диска на диск в виртуальной среде.
        
             Bash, Linux, Ubuntu, Web, Web/Cloud 
             Метки: оптимизация изображений  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
