#                 	Docker Основные примеры использования.                	  
***            ***

			
            
		
    
	
    	  Дата: 15.09.2019 Автор Admin  
	В этой статье я хотел собрать основные рецепты и заметки по Docker, которые помогут познакомиться с ним и быстро начать работу.
Начнем с установки, установить Doсker можно так:
На Debian based:
Ставим необходимые пакеты:
sudo apt-get update

sudo apt-get install \

    apt-transport-https \

    ca-certificates \

    curl \

    gnupg2 \

    software-properties-common
Добавляем ключ GPG для репозитория Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
Добавляем репозиторий
sudo add-apt-repository \

   "deb [arch=amd64] https://download.docker.com/linux/debian \

   $(lsb_release -cs) \

   stable
Ставим Docker
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io
Для установки Docker в Ubuntu повторяем те же шаги кроме:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \

   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \

   $(lsb_release -cs) \

   stable"
Для установки Docker на CentOS делаем следующее:
Устанавливаем необходимые пакеты
sudo yum install -y yum-utils \

  device-mapper-persistent-data \

  lvm2
Добавляем репозиторий
sudo yum-config-manager \

    --add-repo \

    https://download.docker.com/linux/centos/docker-ce.repo
Устанавливаем Docker
sudo yum install docker-ce docker-ce-cli containerd.io
Запуск контейнера
Чтобы запустить контейнер выполните следующую команду:
docker run hello-world
Рассмотрим пример запуска двух контейнеров с пробросом портов наружу и созданием линка между контейнерами и указанием volume для постоянного хранения данных.
Запуск первого контейнера в интерактивном режиме
docker run -it --name teamcity-server-instance  \

    -v data:/data/teamcity_server/datadir \

    -v logs:/opt/teamcity/logs  \

    -p 8080:8111 \

                --link gitlab \

    jetbrains/teamcity-server
Запуск второго контейнера в фоне
docker run --detach \

  --hostname mydockerserver.local \

  --env GITLAB_OMNIBUS_CONFIG="external_url 'http://mydockerserver.local/'; gitlab_rails['lfs_enabled'] = true;" \

  --publish 443:443 --publish 80:80 --publish 2222:2222 \

  --name gitlab \

  --restart always \

  --volume config:/etc/gitlab \

  --volume logs:/var/log/gitlab \

  --volume data:/var/opt/gitlab \

  gitlab/gitlab-ce:latest
Таким образом мы запустили 2 контейнера, teamcity и gitlab, к которым можно подключиться через ip адрес нашего хоста (на котором запущен Docker)
и настроили связь между этими двумя контейнерами.
параметры:
&#8212;publish &#8212; проброс портов
&#8212;name имя для запускаемого контейнера
&#8212;restart перезапуск при падении
&#8212;volume подключение внешнего хранилища для хранения данных внутри контейнера на хосте, например &#8212;volume logs:/var/log/gitlab &#8212; сохранит папку /var/log/gitlab внутри контейнера на хосте в папке logs
&#8212;env позволяет назначить переменные окружения
&#8212;detach запускает контейнер в фоне
-it выполняет интерактивный запуск
&#8212;link позволяет линковать контейнеру друг с другом
Последний параметр указывает какой образ docker запустить в примерах это jetbrains/teamcity-server и gitlab/gitlab-ce:latest
Посмотреть список образов можно тут https://hub.docker.com/
Сборка контейнера
Рассмотрим пример сборки Docker образа
Создадим простейший dockerfile
# Use an official Python runtime as a parent image

FROM python:2.7-slim

# Set the working directory to /app

WORKDIR /app

# Copy the current directory contents into the container at /app

COPY . /app

# Install any needed packages specified in requirements.txt

RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 80 available to the world outside this container

EXPOSE 80

# Define environment variable

ENV NAME World

# Run app.py when the container launches

CMD ["python", "app.py"]
Создадим файл приложения app.py со следующим содержимым:
from flask import Flask

from redis import Redis, RedisError

import os

import socket

# Connect to Redis

redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)




app = Flask(__name__)




@app.route("/")

def hello():

    try:

        visits = redis.incr("counter")

    except RedisError:

        visits = "&lt;i&gt;cannot connect to Redis, counter disabled&lt;/i&gt;"




    html = "&lt;h3&gt;Hello {name}!&lt;/h3&gt;" \

           "&lt;b&gt;Hostname:&lt;/b&gt; {hostname}&lt;br/&gt;" \

           "&lt;b&gt;Visits:&lt;/b&gt; {visits}"

    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)




if __name__ == "__main__":

    app.run(host='0.0.0.0', port=80)
Создаим файл с зависимостями &#8212; requirements.txt со следующим содержимым:
Flask
Redis
Для сборки мы должны находится в каталоге с ранее созданными файлами, проверяем с помощью команды ls
$ ls

Dockerfile                           app.py                                  requirements.txt
Запускаем сборку контейнера:
docker build --tag=friendlyhello .
Мы собрали контейнер с именем friendlyhello
Запусим собранный контейнер, с пробросом порта
docker run -p 4000:80 friendlyhello
Контейнер запущен и доступен по адресу
http://localhost:4000
&nbsp;
Основные команды
Просмотр образов Docker:
docker image ls
&nbsp;
Просмотр запущенных контейнеров:
$ docker container ls

CONTAINER ID        IMAGE               COMMAND             CREATED

1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
Либо
docker ps -a
&nbsp;
Остановка контейнера
docker container stop 1fa4ab2cf395
Удаление контейнера
docker ps -a

CONTAINER ID        IMAGE               COMMAND             CREATED

1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago

docker rm 1fa4ab2cf395
&nbsp;
Подключение к консоли контейнера
находим контейнер:
$ docker container ls

CONTAINER ID        IMAGE               COMMAND             CREATED

1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
&nbsp;
подключаемся к консоли контейнера:
docker exec -it 1fa4ab2cf395 bash
&nbsp;
Также можно выполнять команды внутри контейнера:
$ docker exec -it web ip addr

1: lo: &lt;LOOPBACK,UP,LOWER_UP&gt; mtu 65536 qdisc noqueue state UNKNOWN

    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00

    inet 127.0.0.1/8 scope host lo

       valid_lft forever preferred_lft forever

    inet6 ::1/128 scope host

       valid_lft forever preferred_lft forever

18: eth0: &lt;BROADCAST,UP,LOWER_UP&gt; mtu 1500 qdisc noqueue state UP

    link/ether 02:42:ac:11:00:03 brd ff:ff:ff:ff:ff:ff

    inet 172.17.0.3/16 scope global eth0

       valid_lft forever preferred_lft forever

    inet6 fe80::42:acff:fe11:3/64 scope link

       valid_lft forever preferred_lft forever
Теперь рассмотрим настройку прокси на Docker хосте
ЕСЛИ ИСПОЛЬЗУЕТСЯ SYSTEMD нужно в настройки сервиса Docker добавить прокси, открываем сервис и добавляем в него строку:
Environment="HTTP_PROXY=http://proxy.example.com:80/"
Должно получится примерно так:
[Service]

Environment="HTTP_PROXY=http://proxy.example.com:80/
Далее применяем изменения systemd
sudo systemctl daemon-reload

sudo systemctl restart docker
Теперь редактируем файл ~/.docker/config.json под своим пользователем (если файла нет &#8212; создаем)
{

"proxies":

{

   "default":

   {

     "httpProxy": "http://127.0.0.1:3001",

     "httpsProxy": "http://127.0.0.1:3001",

     "noProxy": "*.test.example.com,.example2.com"

   }

}

}
В качестве альтернативы можно передать параметры прокси контейнеру, через Docker run,
--env HTTP_PROXY="http://127.0.0.1:3128"

--env HTTPS_PROXY="https://127.0.0.1:3128"

--env FTP_PROXY="ftp://127.0.0.1:3001"

--env NO_PROXY="*.test.example.com,.example2.com"
&nbsp;
Или внутри Dockerfile
ENV HTTP_PROXY "http://127.0.0.1:3001"

ENV HTTPS_PROXY "https://127.0.0.1:3001"

ENV FTP_PROXY "ftp://127.0.0.1:3001"

ENV NO_PROXY "*.test.example.com,.example2.com"
&nbsp;
Сборка Dockerfile с указанием прокси:
docker build --build-arg http_proxy=http://127.0.0.1:3001 --build-arg https_proxy=http://127.0.0.1:3001
&nbsp;
Чтобы узнать IP адрес контейнера выполните команды:
находим нужный контейнер
$ docker container ls

CONTAINER ID        IMAGE               COMMAND             CREATED

1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
&nbsp;
Узнаем его ip адрес:
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 1fa4ab2cf395
&nbsp;
Related posts:Установка и настройка сервера GitПеренос виртуальной машины из Hyper-V в Proxmox (KVM)Установка и настройка Ansible
        
             Cloud, Debian, Linux, Web/Cloud 
               
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
