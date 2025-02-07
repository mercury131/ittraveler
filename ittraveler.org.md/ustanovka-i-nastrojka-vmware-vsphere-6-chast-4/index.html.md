#                 	Установка и настройка VMWare Vsphere 6. Часть 4                	  
***            ***

			
            
		
    
	
    	  Дата: 14.05.2015 Автор Admin  
	В данной статье мы рассмотрим настройку Fault tolerance и рассмотрим настройку Latency в виртуальных машинах.
Задачей Fault tolerance является обеспечить доступность виртуальной машины при выходе из строя физического сервера ESXI.
При работе Fault tolerance у виртуальной машины создается копия на другом хосте. Данная копия отрезана от сети, и активируется только когда сервер ESXI выйдет из строя.
Минусом данной технологии являются ограничения накладываемые на ресурсы виртуальной машины, в Vsphere 6 это:
&#8212; 4 vCPU
&#8212; 64 GB оперативной памяти
&#8212; На хосте ESXI можно запустить не более 4 VM с Fault tolerance
&#8212; На хосте требуется сетевой адаптер 10 Gb
&#8212; Отсутствует горячие добавление vCPU и оперативной памяти
&#8212; Не поддерживается Storage vMotion если используется более одного vCPU
Поддерживаются:
&#8212; Тонкие диски
&#8212; Имеется возможность создания снапшотов
&#8212; Storage vMotion если используется не более одного vCPU
&nbsp;
Для корректной работы FT требуется кластер HA, как его настроить можно посмотреть в прошлой статье.
Также для корректной работы FT рекомендуется настроить отдельный VMkernel адаптер, настроенный только на использование Fault tolerance.
Добавим VMkernel адаптер.
Открываем VMkernel адаптеры хоста, и добавляем новый.
&nbsp;
Нажимаем Add Host Networking, и выбираем vmkernel.
&nbsp;
Выбираем коммутатор.
&nbsp;
Указываем Fault tolerance.
&nbsp;
Далее вводим статический IP и жмем next. На этом настройка vmkernel закончена, делаем аналогичные настройки на втором ESXI хосте.
Теперь включаем FT на виртуальной машине.
&nbsp;
После активации FT и запуска VM, в ее свойствах должно появится следующее
Это означает что VM защищена с помощью Fault tolerance.
Перейдем к настройке Latency Sensitivity.
Latency Sensitivity &#8212; это режим высокой производительности виртуальной машины.
С помощью данной функции производительность VM приближается к нативной.
Для настройки данной функции, откроем нужную VM, перейдем в раздел Manage, далее откроем settings далее vm options, далее раздел Advanced Settings.
В  разделе Advanced Settings выбираем пункт Latency Sensitivity
Далее указываем значения Low, High, Medium или Normal.
Рассмотрим как работает данная технология.
Если мы выбираем режим High, хост ESXI определяет возможность предоставления эксклюзивного доступа Vcpu к физическому процессору, рассчитывая реальную загрузку физического процессора.
Также ESXI будет пытаться зарезервировать ресурсы физического процессора для виртуальной машины с включенным Latency Sensitivity.
Также рекомендуется сделать резервирование оперативной памяти для виртуальной машины с включенным Latency Sensitivity.
После включения данной функции, процессор виртуальной машины может напрямую взаимодействовать с физическим процессором, в обход планировщика VMkernel.
Таким образом, для VM с повышенной нагрузкой лучше использовать механизм Latency Sensitivity.
В следующей статье мы рассмотрим настройку системы резервного копирования Vshpere Data Protection 6.
&nbsp;
Related posts:Установка и настройка VMWare Vsphere 6. Часть 1.QEMU/KVM проброс физического диска гипевизора в виртуальную машинуVsphere. Поиск виртуальных машин с толстыми дисками
        
             Виртуализация 
             Метки: vmware, vsphere  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
