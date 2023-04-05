#                 	Отказоустойчивый ISCSI кластер на Windows Server 2012 R2                	  
***            ***

			
            
		

    




	
    	  Дата: 19.05.2015 Автор Admin  
	В данной статье мы рассмотрим как настроить Отказоустойчивый ISCSI кластер на Windows Server 2012 R2.Для настройки нам понадобятся 2 сервера.
Кластер в данной статье будет настраиваться по следующей схеме:
Соответственно у вас должна быть сеть хранения данных, подключенная по FC, SAS или ISCSI (необходим ISCSI протокол версии не ниже iSCSI-3)
Должна быть настроена LAN сеть на каждом узле кластера, и отдельная сеть между кластерами.
На первом сервере включаем компонент &#171;отказоустойчивая кластеризация&#187;
Нажимаем далее, и выбираем установить.
По аналогии устанавливаем компонент на втором сервере.
Перейдем на первый сервер и перейдем к созданию кластера.
Открываем Диспетчер отказоустойчивости кластеров.
Выбираем создать кластер
Добавляем сервера (узлы кластера)
Далее по желанию запускаем проверочные тесты.
Вводим имя кластера и адреса.
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Создаем кластер. Обязательно добавляем все допустимые хранилища.
&nbsp;
Дождитесь окончания работы мастера. Если мастер не находит узлы кластера, проверьте настройки брандмауэра или сети.
&nbsp;
Далее в консоли должен появится созданный кластер.
Добавляем роль ISCSI target на каждый узел кластера.
Дожидаемся установки компонента роли.
Возвращаемся в консоль управления кластером, и добавляем новую роль кластера.
Выбираем &#171;Настроить роль&#187;
Выбираем роль ISCSI сервера
Указываем название кластера и сетевые адреса.
Выбираем диск кластера.
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Подтверждаем создание роли.
Дожидаемся установки роли.
Теперь перейдем к настройке ISCSI сервера.
На одном из узлов кластера открываем диспетчер сервера, в нем открываем файловые службы и выбираем ISCSI.
Запускаем мастер создания ISCSI диска.
Выбираем кластер и общий кластерный диск.
Вводим название диска.
Указываем размер диска и его тип.
Далее выбираем пункт &#8212; &#171;Новая цель ISCSI&#187;
Далее вводим название цели ISCSI.
Указываем каким серверам можно подключаться к ISCSI цели.
Указываем учетные данные для подключения.
Далее нажимаем &#171;Создать&#187; и ожидаем окончания работы мастера.
Готово! Теперь указанные клиенты могут подключаться к кластеру ISCSI. Для подключения нужно использовать DNS имя кластера.
Удачной установки!
&nbsp;
Related posts:Перенос виртуальной машины из Hyper-V в Proxmox (KVM)Установка и настройка AlwaysOn на MS SQL 2016Переход на репликацию SYSVOL по DFS
        
             Windows, Windows Server 
             Метки: Cluster, ISCSI, Windows Server  
        
            
        
    



                        
                    
                    
                
        
                
	
    	
        
        	Комментарии
        
		
		 
    
    
        
                    
         
        
            
            
                
                Саян
                  
                21.07.2016 в 04:26 - 
                Ответить                                
                
            
    
                      
            Объясните пожалуйста у вас 2 или 3 узла в таком кластере, т.к. когда я создаю кластер из 2 серверов, то в списке у меня отображается только 1 узел.
          
        
        
        


    
    

 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                24.04.2017 в 12:13 - 
                Ответить                                
                
            
    
                      
            У меня 2 узла, странно что у вас отображается 1 узел, проверьте настройки серверов, подсети, в домене ли они, есть ли у них общее хранилище.
          
        
        
        


    
    

 
    
    
        
                    
         
        
            
            
                
                Вячеслав
                  
                04.04.2017 в 06:06 - 
                Ответить                                
                
            
    
                      
            Редакция Windows 2012 должна быть Datacenter или достаточно Standard?
          
        
        
        


    
    

 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                24.04.2017 в 11:48 - 
                Ответить                                
                
            
    
                      
            Standard достаточно.
          
        
        
        


    
    

	
    








	
		
		Добавить комментарий для Admin Отменить ответВаш адрес email не будет опубликован.Комментарий Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
	


<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">

(adsbygoogle = window.adsbygoogle || []).push({});





			
        
        

		

        

           
    
    


  


	
    

		
        
             
			

                

                    
                                                  Все права защищены. IT Traveler 2023 
                         
                        
																														                    
                    

				
                
                
    
			
		                            
	

	
                
                
			
                
		
        
	
    


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






