# Настраиваем оповещение при подключении по SSH.                	  
***Дата: 05.05.2017 Автор Admin***

Бывает полезно знать кто и когда подключился к серверу по ssh, особенно если этот сервер в публичном облаке и смотрит в интернет.
В данной заметке я расскажу как это настроить в openssh server.
Для настройки оповещений первым делом настройте ssmtp , т.к его мы будем использовать для отправки писем. Как это сделать написано в этой статье.
Теперь создайте файл sshrc в каталоге /etc/ssh
```
touch /etc/ssh/sshrc
```
touch /etc/ssh/sshrc
Добавим в файл следующий скрипт:
```
ip=`echo $SSH_CONNECTION | cut -d " " -f 1`
logger -t ssh-wrapper $USER login from $ip
SERVER="yourServerName"
EMAIL='your@email.com'
FROM='yourServer@email.com'
ALERTMESSAGE='/tmp/ALERTMESSAGE1.tmp'
echo "To: $EMAIL" &gt; $ALERTMESSAGE
echo "From: $FROM" &gt;&gt; $ALERTMESSAGE
echo "Subject: Alarm! $USER login from $ip" &gt;&gt; $ALERTMESSAGE
echo "" &gt;&gt; $ALERTMESSAGE
echo "$USER login from $ip " &gt;&gt; $ALERTMESSAGE
/usr/sbin/ssmtp $EMAIL &lt; $ALERTMESSAGE
```
ip=`echo $SSH_CONNECTION | cut -d " " -f 1`&nbsp;logger -t ssh-wrapper $USER login from $ip&nbsp;&nbsp;SERVER="yourServerName"EMAIL='your@email.com'FROM='yourServer@email.com'ALERTMESSAGE='/tmp/ALERTMESSAGE1.tmp'&nbsp;echo "To: $EMAIL" &gt; $ALERTMESSAGEecho "From: $FROM" &gt;&gt; $ALERTMESSAGEecho "Subject: Alarm! $USER login from $ip" &gt;&gt; $ALERTMESSAGEecho "" &gt;&gt; $ALERTMESSAGEecho "$USER login from $ip " &gt;&gt; $ALERTMESSAGE&nbsp;/usr/sbin/ssmtp $EMAIL &lt; $ALERTMESSAGE
Теперь перезапустим ssh сервер
```
service ssh restart
```
service ssh restart
Теперь при каждом успешном подключении по ssh сервер будет отправлять уведомление, кто с какого ip зашел на сервер.
&nbsp;
