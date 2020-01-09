# Настройка отправки PHP Mail через Gmail                	  
***Дата: 05.05.2017 Автор Admin***

Если вам нужно отправлять почту через функцию php mail через внешний почтовый сервер, прошу подкат.
Первым делом обновим пакеты на сервере
```
apt-get update
```
apt-get update
```
apt-get upgrade
```
apt-get upgrade
Далее поставим пакет ssmtp
```
apt-get install ssmtp
```
apt-get install ssmtp
Теперь открываем файл /etc/ssmtp/ssmtp.conf и прописываем настройки ящика через который мы хотим отправлять почту
```
root=username@gmail.com # ваш почтовый ящик
mailhub=smtp.gmail.com:465 # адрем smtp сервера
rewriteDomain=gmail.com # домен почтового сервера
AuthUser=username # учетные данные
AuthPass=password #
FromLineOverride=YES
UseTLS=YES
```
root=username@gmail.com # ваш почтовый ящикmailhub=smtp.gmail.com:465 # адрем smtp сервераrewriteDomain=gmail.com # домен почтового сервераAuthUser=username # учетные данныеAuthPass=password #FromLineOverride=YESUseTLS=YES
Можно использовать не только Gmail в качестве почтового провайдера, тут подойдет любой smtp сервер с существующей почтовой учетной записью.
Для проверки создадим следующий текстовый файл:
```
To: recipient_name@gmail.com
From: username@gmail.com
Subject: Sent from a terminal!
Your content goes here. Lorem ipsum dolor sit amet, consectetur adipisicing.
```
To: recipient_name@gmail.comFrom: username@gmail.comSubject: Sent from a terminal!&nbsp;Your content goes here. Lorem ipsum dolor sit amet, consectetur adipisicing.
В файлы замените значения полей To:  и From:
Теперь отправим почту командой:
```
ssmtp recipient_name@gmail.com &lt; filename.txt
```
ssmtp recipient_name@gmail.com &lt; filename.txt
где filename.txt созданный ранее файл.
Теперь откроем конфиг php.ini и исправим параметр sendmail_path , должно получится так:
```
sendmail_path = /usr/sbin/ssmtp -t
```
sendmail_path = /usr/sbin/ssmtp -t
Теперь после перезапуска php почта отправленная через php mail должна ходить через ssmtp.
Для проверки можно использовать следующий PHP скрипт:
PHP
```
&lt;?php
$to      = 'nobody@example.com';
$subject = 'the subject';
$message = 'hello';
$headers = 'From: webmaster@example.com' . "\r\n" .
'Reply-To: webmaster@example.com' . "\r\n" .
'X-Mailer: PHP/' . phpversion();
mail($to, $subject, $message, $headers);
?&gt;
```
&lt;?php$to&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;= 'nobody@example.com';$subject = 'the subject';$message = 'hello';$headers = 'From: webmaster@example.com' . "\r\n" .'Reply-To: webmaster@example.com' . "\r\n" .'X-Mailer: PHP/' . phpversion();&nbsp;mail($to, $subject, $message, $headers);?&gt;
&nbsp;
В скрипте замените параметр переменной $to
Удачной настройки!
