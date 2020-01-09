# Мониторинг срока действия сертификатов Lets Encrypt                	  
***Дата: 05.05.2017 Автор Admin***

Я думаю многие из вас пользуются бесплатными сертификатами Lets Encrypt, но многие ли мониторят срок их действия?
Подкатом я покажу простой bash скрипт, который будет заниматься мониторингом сроков действия сертификатов.
Для настройки оповещений первым делом настройте ssmtp , т.к его мы будем использовать для отправки писем. Как это сделать написано в этой статье.
Теперь сам скрипт мониторинга:
```
#!/bin/bash
SERVER="yourServerName"
EMAIL='your@email.com'
FROM='yourServer@email.com'
ALERTMESSAGE='/tmp/ALERTMESSAGE_cert.tmp'
if /usr/bin/openssl x509 -checkend 86400 -noout -in /etc/letsencrypt/live/yourDOMAIN/fullchain.pem
then
echo "Certificate is good for another day!"
else
echo "To: $EMAIL" &gt; $ALERTMESSAGE
echo "From: $FROM" &gt;&gt; $ALERTMESSAGE
echo "Subject: SSL Cert Renew!" &gt;&gt; $ALERTMESSAGE
echo "" &gt;&gt; $ALERTMESSAGE
echo "Certificate has expired or will do so within 24 hours!" &gt;&gt; $ALERTMESSAGE
echo "Start LetsEncrypt" &gt;&gt; $ALERTMESSAGE
/opt/letsencrypt/letsencrypt-auto renew &gt;&gt; $ALERTMESSAGE
/usr/sbin/ssmtp $EMAIL &lt; $ALERTMESSAGE
service nginx reload
fi
```
#!/bin/bash&nbsp;SERVER="yourServerName"EMAIL='your@email.com'FROM='yourServer@email.com'ALERTMESSAGE='/tmp/ALERTMESSAGE_cert.tmp'&nbsp;if /usr/bin/openssl x509 -checkend 86400 -noout -in /etc/letsencrypt/live/yourDOMAIN/fullchain.pemthen&nbsp;&nbsp;echo "Certificate is good for another day!"&nbsp;else&nbsp;echo "To: $EMAIL" &gt; $ALERTMESSAGEecho "From: $FROM" &gt;&gt; $ALERTMESSAGEecho "Subject: SSL Cert Renew!" &gt;&gt; $ALERTMESSAGEecho "" &gt;&gt; $ALERTMESSAGEecho "Certificate has expired or will do so within 24 hours!" &gt;&gt; $ALERTMESSAGEecho "Start LetsEncrypt" &gt;&gt; $ALERTMESSAGE/opt/letsencrypt/letsencrypt-auto renew &gt;&gt; $ALERTMESSAGE&nbsp;/usr/sbin/ssmtp $EMAIL &lt; $ALERTMESSAGE&nbsp;service nginx reloadfi
В данном скрипте замените следующие строки:
SERVER=&#187;yourServerName&#187; &#8212; Имя сервера (можно указать любое)
EMAIL=&#8217;your@email.com&#8217; &#8212; Ваш Email
FROM=&#8217;yourServer@email.com&#8217; &#8212; Email SSMTP
/etc/letsencrypt/live/yourDOMAIN/fullchain.pem &#8212; в этой строке вместо yourDOMAIN укажите ваш домен, на который выдан сертификат
service nginx reload &#8212; эта строка перезагружает конфиг вебсервера nginx, если у вас другой вебсервер замените эту строку
Теперь командой chmod +x sslmonitoring.sh сделайте скрипт исполняемым (где sslmonitoring.sh имя скрипта)
Далее просто добавьте скрипт в cron , командой crontab -e
```
0 1 * * * /path_to_script/sslmonitoring.sh
```
0 1 * * * /path_to_script/sslmonitoring.sh
Данный скрипт будет запускаться раз в сутки в час ночи.
Если сертификат закончится через 24 часа, то он запустит клиент letsencrypt и обновит сертификат , после чего перезапустит веб сервер.
