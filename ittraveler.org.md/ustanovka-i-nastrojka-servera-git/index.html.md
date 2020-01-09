# Установка и настройка сервера Git                	  
***Дата: 15.05.2016 Автор Admin***

В данной статье мы рассмотрим как установить свой сервер git на ubuntu.
1) Устанавливаем Git
```
apt-get update
```
apt-get update
```
sudo apt-get install -y gitweb
```
sudo apt-get install -y gitweb
2) Открываем файл  /etc/apache2/conf.d/gitweb
Редактируем строку &#8212; Options FollowSymLinks +ExecCGI
на Options +FollowSymLinks +ExecCGI
3) Включаем модуль CGI
```
sudo a2enmod cgi
```
sudo a2enmod cgi
4) Выполняем активацию конфига
```
ln -s /etc/apache2/conf.d/gitweb /etc/apache2/conf-available/gitweb.conf
```
ln -s /etc/apache2/conf.d/gitweb /etc/apache2/conf-available/gitweb.conf
```
a2enconf gitweb
```
a2enconf gitweb
```
service apache2 restart
```
service apache2 restart
Теперь по пути &#8212; http://192.168.1.41/gitweb/ , где 192.168.1.41 это ip адрес вашего сервера, откроется Gitweb с пустыми проектами.
Рассмотрим как создать новый репозиторий git.
1) Создаем папку с репозиторием
```
mkdir /home/git
```
mkdir /home/git
2) Переходим в созданный каталог &#8212; /home/git
```
cd /home/git
```
 cd /home/git
3) Создаем новый пустой репозиторий
```
git init
```
git init
4) Далее загрузим в этот каталог свой файл с кодом, который нам нужно добавить в репозиторий.
В качестве примера я загрузил файл index.php, загруженный файл лежит тут &#8212; /home/git/index.php
5) Добавляем загруженный файл в репозиторий
```
git add index.php
```
git add index.php
6) Сделаем commit, что мы добавили файл в репозиторий
```
git commit -m "I add this file"
```
git commit -m "I add this file"
Чтобы увидеть проект в веб интерфейсе по адресу http://192.168.1.41/gitweb/ ,
нужно изменить в конфиге /etc/gitweb.conf переменную, указывающую путь к проекту.
меняем $projectroot = &#171;/var/lib/git&#187;;
на
$projectroot = &#171;/home/git&#187;;
Теперь в веб интерфейсе GIT виден наш репозиторий.
Удачной установки! =)
