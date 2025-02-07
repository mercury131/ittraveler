#                 	Установка и настройка VMWare Vsphere 6. Часть 5                	  
***            ***

			
            
		
    
	
    	  Дата: 15.05.2015 Автор Admin  
	В данной статье мы рассмотрим настройку системы резервного копирования &#8212; Vsphere Data Protection 6.
Данная система представляет собой appliance в виде ova файла.
Для импорта appliance перейдем в Vcenter и выберем Deploy OVF Template
&nbsp;
Далее укажем путь к файлу appliance
&nbsp;
Далее вы увидите информацию о импортируемой виртуальной машине
&nbsp;
Соглашаемся с лицензией
&nbsp;
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Выбираем каталог для виртуальной машины
&nbsp;
Выбираем хост ESXI
&nbsp;
Указываем тип дисков
&nbsp;
Указываем сеть для виртуальной машины.
Указываем настройки сети
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Нажимаем Next, и ждем завершения импорта, после этого включаем виртуальную машину.
Подключаемся к консоли виртуальной машины через Vcenter
И смотрим адрес Data Protection
Переходим по адресу, указанному в консоли. Внимание! открывайте в браузере Internet explorer! В других браузерах работать не будет!
В интерфейсе вводим логин &#8212; root, пароль &#8212; changeme
Далее мы попадем в мастер настройки, нажимаем Next, и переходим к настройкам сети.
Вводим настройки ip, шлюза, dns, указываем hostname и домен. Не забудьте предварительно создать DNS запись для Data Protection.
&nbsp;
Указываем таймзону
&nbsp;
Указываем новый пароль для Data Protection
&nbsp;
Указываем пользователя с ролью Administrator, и данные для подключения к vcenter.
Обратите внимание что PSC контроллер указывается отдельно.
Создаем хранилище.
&nbsp;
Указываем хранилище и указываем тип дисков.
&nbsp;
Указываем ресурсы для виртуальной машины.
&nbsp;
Анализ производительности можно не включать.
&nbsp;
Соглашаемся на создание хранилища
&nbsp;
Далее начнется процедура создания
Через некоторое время Data protection будет перезагружен.
В веб клиенте Vcenter должно появится задание
Процесс создания хранилища может быть очень долгим.
После выполнения задания, вы можете зайти на тот же адрес Data Protection и увидеть, что теперь доступен интерфейс для настройки системы.
После завершения задания перезайдите в Vcenter. Должен появится новый пункт в меню &#8212; Data Protection.
&nbsp;
Откройте данный пункт и подключитесь к виртуальной машине Data Protection.
После подключения вы увидите интерфейс Data Protection.
&nbsp;
Перейдем во вкладку Backup и настроем задание резервного копирования.
Нажимаем кнопку Backup job actions, и выбираем New.
&nbsp;
Выбираем тип бэкапа. Есть возможность выбрать виртуальные машины или приложения внутри них.
Далее выбираем копирование полного образа ВМ, или отдельные диски.
Выбираем виртуальные машины.
&nbsp;
Далее указываем расписание резервного копирования.
Настраиваем как долго нужно хранить резервные копии.
Вводим название задания резервного копирования и нажимаем Finish.
После этого задание будет доступно в меню Data Protection.
&nbsp;
Для восстановления резервной копии, перейдите во вкладку Restore.
Далее выберите нужную резервную копию и нажмите кнопку Restore.
Выбираем бэкап.
Выбираем опции восстановления,  и нажимаем Next.
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Далее проверяем параметры восстановления и нажимаем Finish.
&nbsp;
В Data Protection имеется возможность репликации резервных копий на другой сервер Data Protection или EMC Avamar.
Для настройки данной функции перейдите во вкладку Replication, и нажмите кнопку Replication job actions. Выберите New.
Указываем что нужно реплицировать, виртуальные машины/резервные копии приложений или сами бэкапы.
Указываем кол-во клиентов Data Protection.
Выбираем за какие периоды нужно реплицировать резервные копии.
Указываем данные удаленной машины Data Protection или EMC Avamar.
Настраиваем расписание репликации.
Настраиваем время хранения резервных копий.
Вводим имя задания.
Далее проверяем настройки и нажимаем Finish.
Во вкладке Reports можно настроить отправку отчетов на электронную почту.
Во вкладке Configuration можно просмотреть текущую конфигурацию Data Protection.
Настройка FLR (File Level Restore).
FLR &#8212; Это веб интерфейс Data Protection позволяющий восстанавливать данные из резервной копии (файлы, папки) в запущенную виртуальную машину.
Перейдем по адресу https://VDP-IP-address-or-DNS-name:8543/flr на виртуальной машине в которую нужно восстановить файлы.
Далее мы можем использовать 2 метода восстановления.
Первый метод Basic. В этом случае мы должны ввести учетные данные локального администратора виртуальной машины в которую мы будем восстанавливать файлы.
В этом случае мы увидим все бэкапы данной виртуальной машины, из данных бэкапов нам будут доступны все файлы и папки.
Второй метод Advanced.
Отличие в том что мы вводим не только учетные данные локального администратора, но и администратора Vcenter.
После авторизации нам будут доступны не только бэкапы виртуальной машины из которой у нас открыта консоль восстановления, но и все бэкапы других виртуальных машин.
Данный метод (FLR) удобен если нам нужно быстро восстановить файл за определенный день, или удаленный файл.
Полное руководство по Data Protection 6 можно прочитать тут.
Внимание! В данной версии Data Protection используется устаревшая таймзона MSK. Поэтому чтобы избежать проблем внимательно настраивайте расписание бэкапов.
Related posts:Выполняем команды внутри гостевых ОС через PowerCLIKVM восстановление qcow2 дискаLVM Добавляем место на диске в виртуальной среде
        
             Виртуализация 
             Метки: backup, vmware, vsphere  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
