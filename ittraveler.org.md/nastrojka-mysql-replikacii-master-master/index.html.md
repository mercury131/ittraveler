#                 	Настройка Mysql репликации Master &#8212; Master                	  
***            ***

			
            
		
    
	
    	  Дата: 23.06.2015 Автор Admin  
	Рассмотрим настройку репликации Mysql.
Обновляем пакеты на каждом из серверов:
apt-get update
apt-get upgrade
Установим Mysql сервер и клиент, сделать это нужно на двух серверах.
apt-get install mysql-server mysql-client
Открываем файл /etc/mysql/my.cnf
Изменяем в конфиге следующие строки:
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = example_DB
# bind-address = 127.0.0.1
В данном конфиге:
server-id &#8212; номер id mysql сервера
log_bin &#8212; путь к бинарному логу, в него пишутся изменения
binlog_do_db &#8212; название БД, которую мы будем реплицировать
# bind-address &#8212; строка закоментирована, т.к. сервер должен работать не только на localhost
Перезапускаем mysql сервер
service mysql restart
Перейдем к настройке репликации.
Подключаемся к Mysql.
mysql -u root -p
Создадим пользователя replicator
create user 'replicator'@'%' identified by 'password';
Создаем базу данных, которую мы будем реплицировать.
create database example_DB;
Назначим права пользователю
grant replication slave on *.* to 'replicator'@'%';
Проверить статус репликации можно командой:
show master status;
Запоминаем параметры File (mysql-bin.000001) и Position (107). Эти параметры нам понадобятся на втором сервере.
Отключаемся от консоли mysql
exit
Переходим на второй mysql сервер и правим конфиг файл /etc/mysql/my.cnf
Конфиг файл второго сервера будет отличаться только id
server-id = 2
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = example_DB
# bind-address = 127.0.0.1
Перезапускаем mysql на втором сервере
service mysql restart
Повторяем операцию по созданию пользователя.
mysql -u root –p
create user 'replicator'@'%' identified by 'password';
Создаем базу данных, которую мы будем реплицировать.
create database example_DB;
Назначим права пользователю.
grant replication slave on *.* to 'replicator'@'%';
Запускаем процесс репликации
slave stop;
Параметры MASTER_LOG_FILE и MASTER_LOG_POS берем с первого сервера (вывод команды show master status;)
CHANGE MASTER TO MASTER_HOST = 'ip address first mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 107;
slave start;
Теперь посмотрим статус репликации:
SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000004 | 107      | example_DB   |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
Запоминаем название файла и параметр позиции, эти данные понадобятся нам при включении репликации на первом сервере.
Теперь вернемся на первый сервер и включим репликацию на нем:
slave stop;
Меняем параметры MASTER_LOG_FILE и MASTER_LOG_POS полученные ранее из команды SHOW MASTER STATUS;
CHANGE MASTER TO MASTER_HOST = 'ip address second mysql server', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000004', MASTER_LOG_POS = 107;
slave start;
Теперь репликация работает на двух серверах.
Проведем тестирование, выполним на первом сервере команду в консоли mysql:
create table example_DB.test_table2 (`id` varchar(10));
Теперь выполним команду на втором сервере:
show tables in example_DB;
Вывод должен быть с созданной таблицей
+----------------------+
| Tables_in_example_DB |
+----------------------+
| test_table           |
+----------------------+
1 row in set (0.00 sec)
Как видите репликация работает, таблица создалась.
Related posts:Docker Основные примеры использования.Настраиваем SFTP chroot на OpenSSH.Настройка работы прокси сервера SQUID через сторонний прокси сервер.
        
             Linux, Ubuntu, Web/Cloud 
             Метки: Linux, Mysql, Ubuntu  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
