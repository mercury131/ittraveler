#                 	Автоматизируем бэкап баз данных MSSQL Express                	  
***            ***

			
            
		
    
	
    	  Дата: 26.05.2015 Автор Admin  
	В данной статье мы рассмотрим как настроить автоматическое резервное копирование баз данных MSSQL расположенных на бесплатном MSSQL Express.
Для автоматизации резервного копирования напишем следующий sql скрипт:
declare @path varchar(max)=N'C:\Backup\BASE_backup_'+convert(varchar(max),getdate(),102)
BACKUP DATABASE [BASE_NAME] TO  DISK = @path  WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'BASE_NAME-Полная База данных Резервное копирование', SKIP, NOREWIND, NOUNLOAD,   STATS = 10
GO
Кодировка скрипта должны быть &#8212; UCS-2 Little Endian
Рассмотрим параметры скрипта:
Путь куда сохранять резервные копии указывается тут &#8212; C:\Backup\
Имя резервной копии будет начинаться с BASE_backup_ и заканчиваться датой резервного копирования.
Имя базы, которую мы будем сохранять задается тут:
BACKUP DATABASE [BASE_NAME]
И тут:
NAME = N'BASE_NAME
(adsbygoogle = window.adsbygoogle || []).push({});
Далее открываем планировщик задач Windows и создаем новую задачу.
В поле &#171;действие&#187; выбираем &#171;Запуск программы&#187;
Путь к программе &#8212; &#171;C:\Program Files\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE&#187;
Аргументы &#8212; -S \sqlexpress  -i &#171;C:\Backup_ScriptDir\backup.sql&#187;
Рассмотрим параметры:
-S \sqlexpress путь к инстансу MSSQL, в данном примере инстанс sqlexpress
Если у вас используется локальный инстанс укажите просто \
-i &#171;C:\Backup_ScriptDir\backup.sql&#187; путь к созданному SQL скрипту.
Готово! Теперь резервное копирование MSSQL баз автоматизированно!
Related posts:Настройка растянутого кластера (stretch-cluster) на Windows server 2016Перенос виртуальной машины из Hyper-V в Proxmox (KVM)Передача и захват ролей FSMO
        
             Windows, Windows Server 
             Метки: MSSQL, Резервное копирование  
        
            
        
    
                        
                    
                    
                
        
                
	
    	
        
        	Комментарии
        
		
		 
    
    
        
                    
         
        
            
            
                
                Иван
                  
                19.04.2016 в 17:01 - 
                Ответить                                
                
            
    
                      
            Спасибо за статью. Очень полезна и актуальна.
Небольшая поправочка по синтаксису:
Нужно добавить точку перед указанием Инстанса SQL, в вашем примере:
-S .\sqlexpress  -i &#171;C:\Backup_ScriptDir\backup.sql&#187;
Либо указать название сервера полностью: -S server_name\sqlexpress  -i &#171;C:\Backup_ScriptDir\backup.sql&#187;
И примечание: при создании задания в &#171;Планировщике задач&#187; указать пользователя, имеющего административные права в SQL Server.
Также удобно добавить к файлику расширение &#8216;.bak&#8217;, чтобы было проще восстановить бэкап.
Ещё Майкрософт не рекомендует использовать в запросе признак конца GO при использовании утилиты &#171;SQLCMD.EXE&#187;, так как при его использовании запрос выполняется сразу.
ссылка на статью: https://msdn.microsoft.com/ru-ru/library/ms162773(v=sql.120).aspx
Таким образом, конечный скрипт будет выглядеть так:
declare @path varchar(max)=N&#8217;C:\Backup\BASE_backup_&#8217;+convert(varchar(max),getdate(),102)+&#8217;.bak&#8217;
BACKUP DATABASE [BASE_NAME] TO  DISK = @path  WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N&#8217;BASE_NAME-Полная База данных Резервное копирование&#8217;, SKIP, NOREWIND, NOUNLOAD,   STATS = 10
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                06.05.2016 в 23:21 - 
                Ответить                                
                
            
    
                      
            Большое спасибо за дополнение!
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Анастасия
                  
                20.09.2016 в 11:41 - 
                Ответить                                
                
            
    
                      
            Подскажите, пожалуйста, что писать вместо sqlexpress?
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                24.04.2017 в 12:12 - 
                Ответить                                
                
            
    
                      
            Тут нужно написать название вашего инстанса MSSQL , его можно посмотреть при подключении через Management Studio.
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                АЛЕКС
                  
                06.07.2018 в 11:29 - 
                Ответить                                
                
            
    
                      
            а в сетевые папки будет копировать?
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                30.07.2018 в 10:18 - 
                Ответить                                
                
            
    
                      
            Если права на сетевую папку есть, то будет
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Андрей
                  
                09.08.2019 в 11:55 - 
                Ответить                                
                
            
    
                      
            В зависимости от выбранного типа авторизации. Если авторизация SQL &#8212; только локальные драйвы.
          
        
        
        
    
    
	
    
	
		
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
