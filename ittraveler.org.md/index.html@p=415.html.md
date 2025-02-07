#                 	Установка и настройка VMWare Vsphere 6. Часть 3                	  
***            ***

			
            
		
    
	
    	  Дата: 12.05.2015 Автор Admin  
	В данной статье мы рассмотрим настройку кластера HA, DRS в Vsphere6.
Открываем Vcenter web client, переходим в раздел Hosts and clusters.
Выбираем пункт &#171;New cluster&#187;
&nbsp;
Вводим имя кластера и нажимаем Ok.
&nbsp;
Далее перемещаем хосты в кластер
&nbsp;
Выбираем хосты и жмем Ok.
&nbsp;
Рассмотрим пример включения HA.
Выбираем кластер.
&nbsp;
Переходим в раздел &#171;Manage&#187; и выбираем Vsphere HA
&nbsp;
Далее нажимаем Edit и настраиваем HA.
&nbsp;
Включаем HA, мониторинг хостов ESXI, также можно включить мониторинг виртуальных машин и приложений внутри VM. Для работы последних необходимы установленные vmware tools на виртуальной машине.
&nbsp;
Теперь, если один из хостов ESXI (размещенных в кластере) выйдет из строя, vm будут перезапущены на соседнем хосте ESXI.
Важно чтобы на всех серверах размещенных в кластере хватало ресурсов для перезапуска VM.
Так же важно чтобы совпадали инструкции процессоров. Если в вашем случае на хостах используются разные процессоры, поможет функция EVC.
Данная функция &#171;выравнивает&#187; процессорные инструкции между хостами, используя набор инструкций самого слабого хоста.
Для включения данной функции перейдем в раздел Manage,  расположенный в настройках кластера.
&nbsp;
Нажимаем Edit, и включаем данную функцию.
Выбираем тип процессора, и EVC mode.
&nbsp;
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Рассмотрим настройку DRS.
Отличие DRS в том что Vcenter сам определяет на каких хостах какие VM хранить. В данном случае Vcenter распределяет VM по хостам в зависимости от нагрузки.
Переходим в раздел Manage нашего кластера.
Выбираем Vsphere DRS.
&nbsp;
Нажимаем Edit и настраиваем DRS.
Можно выбрать уровень автоматизации DRS.
Manual &#8212; позволяет выбрать хост самостоятельно,  Vmotion не активируется автоматически.
Partially automated &#8212; DRS выбирает где включить VM, но Vmotion не активируется автоматически.
Fully automated &#8212; DRS выбирает где включить VM, Vmotion активируется автоматически, в этом случае Vcenter будет сам перемещать VM в кластере.
Так же возможно настроить расписание работы DRS.
Настроить его можно в разделе Manage.
&nbsp;
В расписании можно указать когда DRS будет выполнять свои задачи.
&nbsp;
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Также в DRS возможно настроить управление питанием хостов ESXI.
Например если один из хостов израсходовал ресурсы, DRS может перенести с него VM, перезагрузить хост, вернуть VM обратно. Таким образом DRS освободит часть ресурсов.
Настроить это можно в настройках DFS, в пункте Power management.
В режиме manual, Vcenter будет рекомендовать как поступать с нагруженными хостами
В режиме Automatic, Vcenter будет управлять питанием хостов самостоятельно.
Для корректной работы данного режима Vcenter использует технологии WOL, IPMI, ILO.
Для использования этих технологий используется DPM, для его корректной работы требуется дистрибутив ESXI от производителя вашего сервера.
На этом все. В следующей статье мы рассмотрим технологию fault tolerance, ручное распределение ресурсов хоста для виртуальной машины.
&nbsp;
Related posts:LVM Добавляем место на диске в виртуальной средеНастройка ZFS в ProxmoxQEMU/KVM проброс физического диска гипевизора в виртуальную машину
        
             Виртуализация 
             Метки: DRS, HA, vmware, vsphere  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
