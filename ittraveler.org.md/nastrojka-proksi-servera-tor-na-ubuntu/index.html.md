# Настройка прокси сервера Tor на Ubuntu.                	  
***Дата: 12.05.2015 Автор Admin***

В данной статье мы рассмотрим установку и настройку прокси сервера Tor на Ubuntu.
Устанавливаем Tor
```
apt-get install tor
```
apt-get install tor
Устанавливаем прокси сервер privoxy
apt-get install tor privoxy
Далее открываем конфиг privoxy расположенный по адресу:
```
/etc/privoxy/config
```
/etc/privoxy/config
И добавляем в конфиг строку:
```
forward-socks4a / localhost:9050
```
forward-socks4a / localhost:9050
Внимание знак &#171;.&#187; (точка) обязателен!
Этой записью мы перенаправляем трафик прокси на сеть Tor.
Запускаем сервисы
```
service tor start
```
service tor start
```
service privoxy start
```
service privoxy start
Готово! Прокси сервер работает на порту 8118.
Если Вы хотите изменить порт или ip адрес для прокси, измените в конфиге (/etc/privoxy/config) строку:
```
listen-address 192.168.1.55:8118
```
listen-address 192.168.1.55:8118
Где 192.168.1.55 ваш ip адрес, а 8118 ваш порт.
Остается только настроить в браузере адрес прокси сервера и порт 8118
