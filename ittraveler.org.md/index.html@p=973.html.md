# Настройка работы прокси сервера SQUID через сторонний прокси сервер.                	  
***Дата: 25.06.2018 Автор Admin***

Иногда в тестовых средах вы по каким-то причинам не можете использовать прокси сервер с авторизацией по логину и паролю, и прямого доступа в интернет у вас нет.
В таком случае вам поможет промежуточный прокси сервер на базе Squid, который будет использовать основной прокси сервер для доступа в интернет.
Далее я расскажу как все это настроить.
Устанавливать squid я буду на ubuntu server 16.04.
Обновим список пакетов и проапдейтим систему
```
apt-get update
apt-get upgrade
```
apt-get updateapt-get upgrade
установим squid
```
apt-get install squid3
```
apt-get install squid3
Сделаем бэкап конфига
```
cp /etc/squid/squid.conf /etc/squid/squid.conf.old
```
cp /etc/squid/squid.conf /etc/squid/squid.conf.old
Теперь откроем файл /etc/squid/squid.conf и отредактируем его следующим образом:
```
http_access allow all
http_port 80
coredump_dir /var/spool/squid3
refresh_pattern ^ftp:       1440    20% 10080
refresh_pattern ^gopher:    1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%  0
refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
refresh_pattern .       0   20% 4320
cache_peer YOUR-PROXY-SERVER-DNS-NAME parent 3128 0 no-query default login=YOUR-LOGIN:YOUR-PASS
never_direct allow all
via off
forwarded_for off
request_header_access From deny all
request_header_access Server deny all
request_header_access WWW-Authenticate deny all
request_header_access Link deny all
request_header_access Cache-Control deny all
request_header_access Proxy-Connection deny all
request_header_access X-Cache deny all
request_header_access X-Cache-Lookup deny all
request_header_access Via deny all
request_header_access X-Forwarded-For deny all
request_header_access Pragma deny all
request_header_access Keep-Alive deny all
acl test_net src 192.168.1.0/19
http_access allow test_net
http_access allow localhost
http_access deny all
```
http_access allow allhttp_port 80&nbsp;coredump_dir /var/spool/squid3refresh_pattern ^ftp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1440&nbsp;&nbsp;&nbsp;&nbsp;20% 10080refresh_pattern ^gopher:&nbsp;&nbsp;&nbsp;&nbsp;1440&nbsp;&nbsp;&nbsp;&nbsp;0%&nbsp;&nbsp;1440refresh_pattern -i (/cgi-bin/|\?) 0 0%&nbsp;&nbsp;0refresh_pattern (Release|Packages(.gz)*)$&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20%&nbsp;&nbsp;&nbsp;&nbsp; 2880refresh_pattern .&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; 20% 4320&nbsp;cache_peer YOUR-PROXY-SERVER-DNS-NAME parent 3128 0 no-query default login=YOUR-LOGIN:YOUR-PASSnever_direct allow allvia offforwarded_for off&nbsp;request_header_access From deny allrequest_header_access Server deny allrequest_header_access WWW-Authenticate deny allrequest_header_access Link deny allrequest_header_access Cache-Control deny allrequest_header_access Proxy-Connection deny allrequest_header_access X-Cache deny allrequest_header_access X-Cache-Lookup deny allrequest_header_access Via deny allrequest_header_access X-Forwarded-For deny allrequest_header_access Pragma deny allrequest_header_access Keep-Alive deny all&nbsp;acl test_net src 192.168.1.0/19&nbsp;http_access allow test_net&nbsp;http_access allow localhosthttp_access deny all
Вместо YOUR-PROXY-SERVER-DNS-NAME введите dns имя вашего прокси сервера
Вместо YOUR-LOGIN:YOUR-PASS укажите ваши логин и пароль к прокси
Вместо test_net укажите название своей сети
Вместо 192.168.1.0/19 укажите свою подсеть.
Сохраните конфиг.
Теперь откройте доступ к серверу из вашей подсети командой:
```
ufw allow from 192.168.1.0/19
```
ufw allow from 192.168.1.0/19
Перезапустите прокси сервер squid
```
service squid restart
```
service squid restart
Готово, настройка сервера завершена.
Доступ к данному прокси серверу есть только из вашей подсети и прокси сервер доступен без авторизации.
