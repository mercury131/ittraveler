#                 	Установка и настройка кластера MongoDB (replication set)                	  
***            ***

			
            
		
    
	
    	  Дата: 15.09.2019 Автор Admin  
	В этой статье мы рассмотрим как установить и настроить кластер MongoDB (replication set), создать базы, пользователей, включить авторизацию по ключу.
 
Установка MongoDB делается следующим образом:
 на Ubuntu:
Импортируем публичный ключ
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
Создаем list файл с данными репозитория
Создаем /etc/apt/sources.list.d/mongodb-org-4.0.list
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
Устанавливаем MongoDB
sudo apt-get update

sudo apt-get install -y mongodb-org
на CentOS:
Создаем файл с данными по репозиторию /etc/yum.repos.d/mongodb-org-4.0.repo
[mongodb-org-4.0]

name=MongoDB Repository

baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/


gpgcheck=1

enabled=1

gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
Устанавливаем MongoDB
sudo yum install -y mongodb-org
Для установки на Windows ставим KB2999226 и скачиваем и устанавливаем msi с MongoDB Download Center (https://www.mongodb.com/download&#8212;center/community?jmp=docs)
 
После установки открываем конфиг MongoDB, в /etc на Linux или в каталоге C:\Program Files\MongoDB\Server\4.0\bin\ на Windows
 в конфиге настраиваем сетевые интерфейсы, добавьте ip адрес сервера
 
# network interfaces

net:

  port: 27017

  bindIp: localhost,192.168.1.10
Перезапустите сервис MongoDB
Далее создадим ключ для авторизации между нодами MongoDB, сделать это можно через openssl
 openssl rand -base64 756 &gt; &lt;path-to-keyfile&gt;
Создаем супер пользователя, для этого запускаем  консоль mongo и выполняем:
db.createUser(

  {

    user: "mongo-root",

    pwd: "Password",

    roles: [ { role: "root", db: "admin" } ]

  }

)
&nbsp;
Теперь создадим пользователя с правами администратора
db.createUser({user:"mongoadmin", pwd:"password",roles:["userAdminAnyDatabase","dbAdmin"]})
Далее редактируем конфиг следующим образом, добавляем или редактируем секции:
#включаем авторизацию по ключам

security:

  keyFile: C:\Program Files\MongoDB\Server.0\bin\mongo.key

  authorization: enabled




#указываем replication set

replication:

   replSetName: "rs0"
&nbsp;
Сохраняем конфиг, копируем ключ по пути указанному в keyFile и перезапускаем сервис MongoDB
Выполнить эти действия нужно на всех серверах MongoDB
Теперь подключаемся к консоли MongoDB и авторизуемся на одной из нод:
mongo
db.auth("mongo-root", "Password")
Далее добавляем все ноды в кластер:
rs.initiate( {

   _id : "rs0",

   members: [

      { _id: 0, host: "mongo-1.local:27017" },

      { _id: 1, host: "mongo-2.local:27017" },

      { _id: 2, host: "mongo-3.local:27017" }

   ]

})
&nbsp;
Изменить приоритет серверов можно следующим образом:
 получаем текущий конфиг:
 conf = rs.conf()
Выставляем приоритеты:
conf['members'][0].priority = 7

conf['members'][1].priority = 5

conf['members'][2].priority = 1
Применяем изменения:
rs.reconfig(conf)
Проверяем что изменения были применены:
rs.conf()['members']
Настройка кластера на этом завершена, перейдем к настройке БД.
Подключаемся к MongoDB
 mongo
&nbsp;
Создаем базу
use new_database
Добавим в нее тестовую запись
 db.new_collection2.insert({ some_key: "some_value" })
Чтобы очистить все данные в БД выполните следующие команды:
 use new_database;

db.dropDatabase();
Посмотрим данные в бд
 show collections
Создадим пользователя для БД
 db.createUser(

  {

    user: "dbadmin",

    pwd: "password",

    roles: [ { role: "readWrite", db: "new_database" } ]

  }

)
&nbsp;
Посмотреть список пользователей можно командой:
 db.getUsers()
Посмотреть список созданных БД можно командой
 show dbs
Для импорта/ экспорта БД используйте следующие команды:
 mongorestore --archive=test.20150715.archive --db test
Для экспорта:
mongodump --archive=test.20150715.archive --db test
Если нужно использовать логин / пароль или подключаться к внешнему серверу добавьте параметры:
--host mongodb1.example.net --port 37017 --username user --password "pass"
На этом основная настройка завершена.
 
Ну и напоследок, для повышения уровня безопасности MongoDB, не выставляйте ее наружу, тщательно настраивайте правила на ваших firewall, в идеале чтобы к кластеру могли подключаться только клиенты и сами ноды кластера.
Related posts:LVM Добавляем место на диске в виртуальной средеНастройка связки веб серверов Nginx + ApacheУстановка и настройка Puppet.
        
             Linux 
               
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
