#                 	Установка и настройка Citrix XenServer Часть 2.                	  
***            ***

			
            
		
    
	
    	  Дата: 25.05.2015 Автор Admin  
	В данной статье мы рассмотрим добавление общих хранилищ, создание пулов XenServer, настройку HA и интеграцию с Active Directory.
Добавим общее хранилище ISCSI.
Открываем консоль XenCenter, выбираем хост, далее нажимаем &#8212; New SR.
Выбираем Software ISCSI.
Указываем имя хранилища.
Далее указываем адрес ISCSI хранилища, target IQN и LUN.
Далее XenCenter предупредит что создаст группу LVM на iscsi хранилище. Соглашаемся.
Теперь хранилище ISCSI появилось у хоста Xen1.
Добавим NFS хранилище. Нажимаем New SR.
Выбираем NFS VHD.
Укажем имя хранилища.
Вводим данные NFS сервера, нажимаем Scan, и подключаем NFS хранилище.
Теперь у первого хоста 2 общих хранилища, ISCSI и NFS.
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Теперь добавим общее хранилище для ISO образов.
Нажимаем New SR.
Выбираем ISO library. Укажем Cifs хранилище.
Укажем имя хранилища.
Указываем данные для подключения.
Теперь открыв хранилище Cifs, мы увидим загруженные ISO образы доступные для подключения в VM.
Как видите, общие хранилища доступны только на одном хосте. Чтобы это исправить создадим новый пул серверов.
Выбираем New pool.
Вводим название пула и выбираем мастер сервер, данный сервер управляет пулом.
Нажимаем Create Pool.
Теперь добавим второй хост в созданный пул.
Перед данным действием необходимо выключить все виртуальные машины.
Также необходимо удалить существующие настройки виртуальных сетей и агрегированные адаптеры.
Подтверждаем перенос сервера в пул.
Теперь каждому серверу доступны общие хранилища.
Перейдем к активации высокой доступности виртуальных машин (HA).
Выбираем High Availability.
Указываем какое общее хранилище будет использоваться для мониторинга виртуальных машин.
&nbsp;
&nbsp;
Выбираем виртуальные машины, которые будет &#171;защищены&#187; и указываем перезапуск при аварии.
Проверяем настройки и включаем HA.
Теперь в консоли XenCenter виден статус HA.
Выключаем VM.
Переместим VM на общее хранилище.
Выбираем общее хранилище для VM.
Включаем VM.
&nbsp;
Теперь выключим из сети сервер xen2, тем самым сымитировав аварию.
Как видите VM успешно запустилась, а сервер xen1 взял на себя роль мастера пула.
&nbsp;
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Включим сервер Xen2 и перейдем к настройке Active Directory.
Открываем в консоли пул Xen серверов, и переходим во вкладку Users.
Нажимаем кнопку Join Domain.
Указываем домен и данные доменного администратора.
После выполнения этой операции в Active Directory должны появится сервера xen из нашего пула.
Теперь добавим нового доменного администратора для Xen.
Во вкладке Users нажимаем add.
Далее вводим имена пользователей или группы Active Directory.
&nbsp;
После добавления пользователя, ему можно изменить роль администрирования.
Теперь пользователю можно назначить роли администрирования.
На этом интеграция с Active Directory завершена.
Также хотелось бы отметить несколько полезных команд Xen для управления пулами.
Вводить команды можно через консоль XenCenter, с одного из хостов.
&nbsp;
Полезные команды:
Просмотр данных о пулах:
xe pool-list
Просмотр хостов в пуле:
xe host-list
Показать мастер сервер пула:
xe pool-list params=uuid,master
Изменение мастера пула:
1) Отключаем HA.
xe pool-ha-disable
2) Просматриваем атрибуты хостов в пуле (нас интересует host uuid)
xe host-list
3) Указываем кто теперь будет пул мастером:
xe pool-designate-new-master host-uuid=&lt;uuid&gt;
4) Включаем HA.
xe pool-ha-enable
После этого Pool Master будет изменен.
На этом все! В следующей статье мы рассмотрим резервное копирование хостов и виртуальных машин.
Related posts:KVM восстановление qcow2 дискаVsphere. Поиск виртуальных машин с толстыми дискамиУстановка и настройка VMWare Vsphere 6. Часть 1.
        
             Виртуализация 
             Метки: Active Directory, XenServer, Виртуализация  
        
            
        
    
                        
                    
                    
                
        
                
	
    	
        
        	Комментарии
        
		
		 
    
    
        
                    
         
        
            
            
                
                Евгений
                  
                30.10.2015 в 10:41 - 
                Ответить                                
                
            
    
                      
            А вот в кластере не нужно настраивать виртуальные сети и агрегированные адаптеры?
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                30.10.2015 в 11:40 - 
                Ответить                                
                
            
    
                      
            Добрый день!
Желательно в каждом узле кластера настроить агрегированные адаптеры, если есть такая возможность.
Виртуальные сети само собой необходимы.
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Евгений
                  
                30.10.2015 в 12:21 - 
                Ответить                                
                
            
    
                      
            Значит настраиваем адаптеры в кластере точно так же, как описано в первой статье?
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                30.10.2015 в 14:15 - 
                Ответить                                
                
            
    
                      
            Да, можно так же.
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Евгений
                  
                31.10.2015 в 19:06 - 
                Ответить                                
                
            
    
                      
            А агрегация настраивается только на мастерпуле? На втором узле не даёт настроить
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Евгений
                  
                27.02.2021 в 08:19 - 
                Ответить                                
                
            
    
                      
            Спасибо автору статьи!
Все очень понятно и доходчиво.
Успехов и удачи!
          
        
        
        
    
    
	
    
	
		
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
