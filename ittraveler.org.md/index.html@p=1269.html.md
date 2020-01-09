# Docker Основные примеры использования.                	  
***Дата: 15.09.2019 Автор Admin***

В этой статье я хотел собрать основные рецепты и заметки по Docker, которые помогут познакомиться с ним и быстро начать работу.
Начнем с установки, установить Doсker можно так:
На Debian based:
Ставим необходимые пакеты:
```
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
```
sudo apt-get update&nbsp;sudo apt-get install \&nbsp;    apt-transport-https \&nbsp;    ca-certificates \&nbsp;    curl \&nbsp;    gnupg2 \&nbsp;    software-properties-common
Добавляем ключ GPG для репозитория Docker
```
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
Добавляем репозиторий
```
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable
```
sudo add-apt-repository \&nbsp;   "deb [arch=amd64] https://download.docker.com/linux/debian \&nbsp;   $(lsb_release -cs) \&nbsp;   stable
Ставим Docker
```
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```
sudo apt-get update&nbsp;sudo apt-get install docker-ce docker-ce-cli containerd.io
Для установки Docker в Ubuntu повторяем те же шаги кроме:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
sudo add-apt-repository \&nbsp;   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \&nbsp;   $(lsb_release -cs) \&nbsp;   stable"
Для установки Docker на CentOS делаем следующее:
Устанавливаем необходимые пакеты
```
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```
sudo yum install -y yum-utils \&nbsp;  device-mapper-persistent-data \&nbsp;  lvm2
Добавляем репозиторий
```
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```
sudo yum-config-manager \&nbsp;    --add-repo \&nbsp;    https://download.docker.com/linux/centos/docker-ce.repo
Устанавливаем Docker
```
sudo yum install docker-ce docker-ce-cli containerd.io
```
sudo yum install docker-ce docker-ce-cli containerd.io
Запуск контейнера
Чтобы запустить контейнер выполните следующую команду:
```
docker run hello-world
```
docker run hello-world
Рассмотрим пример запуска двух контейнеров с пробросом портов наружу и созданием линка между контейнерами и указанием volume для постоянного хранения данных.
Запуск первого контейнера в интерактивном режиме
```
docker run -it --name teamcity-server-instance  \
    -v data:/data/teamcity_server/datadir \
    -v logs:/opt/teamcity/logs  \
    -p 8080:8111 \
                --link gitlab \
    jetbrains/teamcity-server
```
docker run -it --name teamcity-server-instance  \&nbsp;    -v data:/data/teamcity_server/datadir \&nbsp;    -v logs:/opt/teamcity/logs  \&nbsp;    -p 8080:8111 \&nbsp;                --link gitlab \&nbsp;    jetbrains/teamcity-server
Запуск второго контейнера в фоне
```
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
```
docker run --detach \&nbsp;  --hostname mydockerserver.local \&nbsp;  --env GITLAB_OMNIBUS_CONFIG="external_url 'http://mydockerserver.local/'; gitlab_rails['lfs_enabled'] = true;" \&nbsp;  --publish 443:443 --publish 80:80 --publish 2222:2222 \&nbsp;  --name gitlab \&nbsp;  --restart always \&nbsp;  --volume config:/etc/gitlab \&nbsp;  --volume logs:/var/log/gitlab \&nbsp;  --volume data:/var/opt/gitlab \&nbsp;  gitlab/gitlab-ce:latest
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
```
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
```
# Use an official Python runtime as a parent image&nbsp;FROM python:2.7-slim&nbsp;# Set the working directory to /app&nbsp;WORKDIR /app&nbsp;# Copy the current directory contents into the container at /app&nbsp;COPY . /app&nbsp;# Install any needed packages specified in requirements.txt&nbsp;RUN pip install --trusted-host pypi.python.org -r requirements.txt&nbsp;# Make port 80 available to the world outside this container&nbsp;EXPOSE 80&nbsp;# Define environment variable&nbsp;ENV NAME World&nbsp;# Run app.py when the container launches&nbsp;CMD ["python", "app.py"]
Создадим файл приложения app.py со следующим содержимым:
```
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
```
from flask import Flask&nbsp;from redis import Redis, RedisError&nbsp;import os&nbsp;import socket&nbsp;# Connect to Redis&nbsp;redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)&nbsp;&nbsp;&nbsp;&nbsp;app = Flask(__name__)&nbsp;&nbsp;&nbsp;&nbsp;@app.route("/")&nbsp;def hello():&nbsp;    try:&nbsp;        visits = redis.incr("counter")&nbsp;    except RedisError:&nbsp;        visits = "&lt;i&gt;cannot connect to Redis, counter disabled&lt;/i&gt;"&nbsp;&nbsp;&nbsp;&nbsp;    html = "&lt;h3&gt;Hello {name}!&lt;/h3&gt;" \&nbsp;           "&lt;b&gt;Hostname:&lt;/b&gt; {hostname}&lt;br/&gt;" \&nbsp;           "&lt;b&gt;Visits:&lt;/b&gt; {visits}"&nbsp;    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)&nbsp;&nbsp;&nbsp;&nbsp;if __name__ == "__main__":&nbsp;    app.run(host='0.0.0.0', port=80)
Создаим файл с зависимостями &#8212; requirements.txt со следующим содержимым:
```
Flask
Redis
```
FlaskRedis
Для сборки мы должны находится в каталоге с ранее созданными файлами, проверяем с помощью команды ls
```
$ ls
Dockerfile                           app.py                                  requirements.txt
```
$ ls&nbsp;Dockerfile                           app.py                                  requirements.txt
Запускаем сборку контейнера:
```
docker build --tag=friendlyhello .
```
docker build --tag=friendlyhello .
Мы собрали контейнер с именем friendlyhello
Запусим собранный контейнер, с пробросом порта
```
docker run -p 4000:80 friendlyhello
```
docker run -p 4000:80 friendlyhello
Контейнер запущен и доступен по адресу
http://localhost:4000
&nbsp;
Основные команды
Просмотр образов Docker:
```
docker image ls
```
docker image ls
&nbsp;
Просмотр запущенных контейнеров:
```
$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED
1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
```
$ docker container ls&nbsp;CONTAINER ID        IMAGE               COMMAND             CREATED&nbsp;1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
Либо
```
docker ps -a
```
docker ps -a
&nbsp;
Остановка контейнера
```
docker container stop 1fa4ab2cf395
```
docker container stop 1fa4ab2cf395
Удаление контейнера
```
docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED
1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
docker rm 1fa4ab2cf395
```
docker ps -a&nbsp;CONTAINER ID        IMAGE               COMMAND             CREATED&nbsp;1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago&nbsp;docker rm 1fa4ab2cf395
&nbsp;
Подключение к консоли контейнера
находим контейнер:
```
$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED
1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
```
$ docker container ls&nbsp;CONTAINER ID        IMAGE               COMMAND             CREATED&nbsp;1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
&nbsp;
подключаемся к консоли контейнера:
```
docker exec -it 1fa4ab2cf395 bash
```
docker exec -it 1fa4ab2cf395 bash
&nbsp;
Также можно выполнять команды внутри контейнера:
```
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
```
$ docker exec -it web ip addr&nbsp;1: lo: &lt;LOOPBACK,UP,LOWER_UP&gt; mtu 65536 qdisc noqueue state UNKNOWN&nbsp;    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00&nbsp;    inet 127.0.0.1/8 scope host lo&nbsp;       valid_lft forever preferred_lft forever&nbsp;    inet6 ::1/128 scope host&nbsp;       valid_lft forever preferred_lft forever&nbsp;18: eth0: &lt;BROADCAST,UP,LOWER_UP&gt; mtu 1500 qdisc noqueue state UP&nbsp;    link/ether 02:42:ac:11:00:03 brd ff:ff:ff:ff:ff:ff&nbsp;    inet 172.17.0.3/16 scope global eth0&nbsp;       valid_lft forever preferred_lft forever&nbsp;    inet6 fe80::42:acff:fe11:3/64 scope link&nbsp;       valid_lft forever preferred_lft forever
Теперь рассмотрим настройку прокси на Docker хосте
ЕСЛИ ИСПОЛЬЗУЕТСЯ SYSTEMD нужно в настройки сервиса Docker добавить прокси, открываем сервис и добавляем в него строку:
```
Environment="HTTP_PROXY=http://proxy.example.com:80/"
```
Environment="HTTP_PROXY=http://proxy.example.com:80/"
Должно получится примерно так:
```
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80/
```
[Service]&nbsp;Environment="HTTP_PROXY=http://proxy.example.com:80/
Далее применяем изменения systemd
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```
sudo systemctl daemon-reload&nbsp;sudo systemctl restart docker
Теперь редактируем файл ~/.docker/config.json под своим пользователем (если файла нет &#8212; создаем)
```
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
```
{&nbsp;"proxies":&nbsp;{&nbsp;   "default":&nbsp;   {&nbsp;     "httpProxy": "http://127.0.0.1:3001",&nbsp;     "httpsProxy": "http://127.0.0.1:3001",&nbsp;     "noProxy": "*.test.example.com,.example2.com"&nbsp;   }&nbsp;}&nbsp;}
В качестве альтернативы можно передать параметры прокси контейнеру, через Docker run,
```
--env HTTP_PROXY="http://127.0.0.1:3128"
--env HTTPS_PROXY="https://127.0.0.1:3128"
--env FTP_PROXY="ftp://127.0.0.1:3001"
--env NO_PROXY="*.test.example.com,.example2.com"
```
--env HTTP_PROXY="http://127.0.0.1:3128"&nbsp;--env HTTPS_PROXY="https://127.0.0.1:3128"&nbsp;--env FTP_PROXY="ftp://127.0.0.1:3001"&nbsp;--env NO_PROXY="*.test.example.com,.example2.com"
&nbsp;
Или внутри Dockerfile
```
ENV HTTP_PROXY "http://127.0.0.1:3001"
ENV HTTPS_PROXY "https://127.0.0.1:3001"
ENV FTP_PROXY "ftp://127.0.0.1:3001"
ENV NO_PROXY "*.test.example.com,.example2.com"
```
ENV HTTP_PROXY "http://127.0.0.1:3001"&nbsp;ENV HTTPS_PROXY "https://127.0.0.1:3001"&nbsp;ENV FTP_PROXY "ftp://127.0.0.1:3001"&nbsp;ENV NO_PROXY "*.test.example.com,.example2.com"
&nbsp;
Сборка Dockerfile с указанием прокси:
```
docker build --build-arg http_proxy=http://127.0.0.1:3001 --build-arg https_proxy=http://127.0.0.1:3001
```
docker build --build-arg http_proxy=http://127.0.0.1:3001 --build-arg https_proxy=http://127.0.0.1:3001
&nbsp;
Чтобы узнать IP адрес контейнера выполните команды:
находим нужный контейнер
```
$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED
1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
```
$ docker container ls&nbsp;CONTAINER ID        IMAGE               COMMAND             CREATED&nbsp;1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
&nbsp;
Узнаем его ip адрес:
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 1fa4ab2cf395
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 1fa4ab2cf395
&nbsp;
