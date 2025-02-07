#                 	Установка и настройка хостинг панели VestaCP c поддержкой разных версий PHP                	  
***            ***

			
            
		
    
	
    	  Дата: 24.06.2018 Автор Admin  
	В этой статье мы установим хостинг панель VestaCP и добавим в нее поддержку разных версий PHP
В качестве основной ОС я буду использовать Ubuntu 16.04 server.
Подключаемся к серверу по SSH и следующими командами запустим установку панели VestaCP
curl -O http://vestacp.com/pub/vst-install.sh
bash vst-install.sh
Далее вы увидите список ПО которое будет использоваться VestaCP.
Забегая немного вперед скажу что конфигурация с разными версиями php пока работает только с apache, поэтому его обязательно нужно использовать как backend.
Итак, нажимаем y, вводим свой email (на него vestacp отправит учетные данные), dns имя сервера и ждем пока VestaCP установится
После успешной установки панели вы увидите логин/пароль пользователя admin и адрес подключения к панели VestaCP.
Итак, перейдем в панель управления хостингом
Перейдем в раздел Web, пока там нет ни одного сайта
Нажмем + чтобы добавить новый сайт, я добавлю сайт test.local
Теперь подключимся по sftp (например через winscp) к нашему серверу под пользователем admin и перейдем в каталог /home/admin/web/test.local/public_html
Создадим в этом каталоге файл info.php со следующим содержимым:
&lt;?php
phpinfo();
?&gt;
Теперь перейдем на http://test.local/ , мы должны увидеть следующую страницу
Теперь перейдем на http://test.local/info.php , открыв ссылку вы увидите справочную информацию о используемой версии php.
Теперь перейдем к установке менеджера php.
Переходим обратно в ssh консоль сервера и клонируем php менеджер командой:
git clone https://github.com/petranikin/mgrvphp.git
Переходим в каталог с менеджером и запускаем его
cd mgrvphp
bash mgrvphp
Далее через пробел вводим нужные нам версии PHP.
Сами версии берем отсюда http://php.net/releases/ 
В качестве примера я установлю версии 7.2.6 /5.6.35 /5.5.37 /5.4.45
Вот пример ввода версий в менеджер
На вопросы о создании симлинков и шаблонов vestaCP отвечаем yes , на вопрос о установке необходимых зависимостей тоже yes
Теперь начнется процесс скачивания и установки выбранных ранее версий PHP, это займет продолжительное время..
После завершения работы мастера, откройте созданный ранее сайт и нажмите Edit
Выберем шаблон php7.2
Теперь если зайти на сайт, на нашу проверочную страницу PHP, мы увидим другую версию PHP
Попробуем выбрать PHP 5.6
Сайт успешно работает на новой выбранной версии php
Теперь вы можете использовать разные версии php для разных сайтов.
&nbsp;
Related posts:Настройка Mysql репликации Master - MasterПеренос виртуальной машины из Hyper-V в Proxmox (KVM)Восстановление пароля root на сервере Mysql
        
             Cloud, Ubuntu, Web, Web/Cloud, Без рубрики 
             Метки: Apache2, Nginx, vestacp, webserver  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
