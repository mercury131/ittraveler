# Балансировка нагрузки веб серверов IIS с Windows аутентификацией через Haproxy                	  
***Дата: 04.07.2018 Автор Admin***

На днях понадобилось настроить балансировку нагрузки между двумя серверами IIS с Windows аутентификацией.
Думал использовать привычный nginx для этих целей, но оказалось из коробки этот функционал доступен только в редакции Nginx Plus.
Ну ничего страшного, тут нас выручит не менее крутой Haproxy =)
Приступим к настройке, я буду разворачивать балансировщик Haproxy на Ubuntu Server 16.04 LTS.
Обновим все пакеты и установим Haproxy
```
apt-get update &amp;&amp; apt-get install haproxy
```
apt-get update &amp;&amp; apt-get install haproxy
Теперь перейдем к настройке, открываем файл /etc/haproxy/haproxy.cfg и приводим его к виду:
```
global
log /dev/log	local0
log /dev/log	local1 notice
chroot /var/lib/haproxy
stats socket /run/haproxy/admin.sock mode 660 level admin
stats timeout 30s
user haproxy
group haproxy
daemon
# Default SSL material locations
ca-base /etc/ssl/certs
crt-base /etc/ssl/private
ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
ssl-default-bind-options no-sslv3
backend backend_iis
server iissrv1 iis-01.mydomain.local:80 weight 1 check port 80 inter 5s rise 3 fall 2
server iissrv2 iis-02.mydomain.local:80 weight 1 check port 80 inter 5s rise 3 fall 2
server iissrv3 iis-03.mydomain.local:80 check backup
mode http
balance roundrobin
option http-keep-alive
option prefer-last-server
timeout server 30s
timeout connect 4s
frontend frontend_iis
bind *:80 name frontend_iis
mode http
option http-keep-alive
timeout client 30s
default_backend backend_iis
```
global	log /dev/log	local0	log /dev/log	local1 notice	chroot /var/lib/haproxy	stats socket /run/haproxy/admin.sock mode 660 level admin	stats timeout 30s	user haproxy	group haproxy	daemon&nbsp;	# Default SSL material locations	ca-base /etc/ssl/certs	crt-base /etc/ssl/private&nbsp;	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS	ssl-default-bind-options no-sslv3&nbsp;&nbsp;&nbsp;backend backend_iis&nbsp;&nbsp;&nbsp;&nbsp;server iissrv1 iis-01.mydomain.local:80 weight 1 check port 80 inter 5s rise 3 fall 2	server iissrv2 iis-02.mydomain.local:80 weight 1 check port 80 inter 5s rise 3 fall 2	server iissrv3 iis-03.mydomain.local:80 check backup&nbsp;&nbsp;&nbsp;&nbsp;mode http&nbsp;&nbsp;&nbsp;&nbsp;balance roundrobin&nbsp;&nbsp;&nbsp;&nbsp;option http-keep-alive&nbsp;&nbsp;&nbsp;&nbsp;option prefer-last-server&nbsp;&nbsp;&nbsp;&nbsp;timeout server 30s&nbsp;&nbsp;&nbsp;&nbsp;timeout connect 4s&nbsp;frontend frontend_iis&nbsp;&nbsp;&nbsp; bind *:80 name frontend_iis&nbsp;&nbsp;&nbsp;&nbsp;mode http&nbsp;&nbsp;&nbsp;&nbsp;option http-keep-alive&nbsp;&nbsp;&nbsp;&nbsp;timeout client 30s&nbsp;&nbsp;&nbsp;&nbsp;default_backend backend_iis
Пройдемся по конфигу
В нем указаны мои сервера IIS, нагрузку между которыми я балансирую
iis-01.mydomain.local
iis-02.mydomain.local
Сервер iis-03.mydomain.local указан как запасной, на случай недоступности первых двух серверов
Теперь секции, в секции backend, указаны сами сервера IIS и параметры балансировки и проверки
В данном случае строка server iissrv1 iis-01.mydomain.local:80 weight 1 check port 80 inter 5s rise 3 fall 2 означает:
1) мы используем сервер iis-01.mydomain.local на порту 80
2) вес сервера равен 1 (weight 1)
3) используется проверка доступности порта (check port 80)
4) интервал между проверками равен 5 секундам (inter 5s)
5) число успешных проверок прежде чем считать сервер UP (rise 3)
6) число не успешных проверок прежде чем считать сервер DOWN (fall 2)
7) режим работы haproxy &#8212; http
8) тип балансировки нагрузки roundrobin
Далее идет секция frontend , в ней мы указываем какие backend мы будем использовать
Параметры следующие:
1) балансировщик принимает запросы на порту 80, на всех сетевых интерфейсах (bind *:80 )
2) режим работы haproxy &#8212; http (mode http)
3) используемый backend backend_iis (default_backend backend_iis)
Сохраните конфиг и перезапустите сервис haproxy
```
service haproxy restart
```
service haproxy restart
Теперь настройте ваши DNS записи на балансировщик, а не напрямую на IIS как было раньше.
Теперь все запросы проходят равномерно через балансировщик и Windows аутентификация работает для клиентов корректно.
При недоступности одного из IIS серверов клиенты будут перенаправлены на другой доступный сервер автоматически.
