# Восстановление пароля root на сервере Mysql                	  
***Дата: 23.06.2015 Автор Admin***

Бывают ситуации когда тебе достался сервер Mysql, а пароль root ты не знаешь.
Как быть в такой ситуации? Правильно, изменим пароль root.
Останавливаем службу Mysql сервера.
```
/etc/init.d/mysql stop
```
/etc/init.d/mysql stop
Для redhat команда остановки сервера будет такой:
```
/etc/init.d/mysqld stop
```
/etc/init.d/mysqld stop
Загружаем Mysql сервер в безопасном режиме
```
mysqld_safe --skip-grant-tables &amp;
```
mysqld_safe --skip-grant-tables &amp;
Теперь откроем консоль mysql сервера
```
mysql -u root
```
mysql -u root
Выбираем БД mysql
```
use mysql;
```
use mysql;
Сбрасывам пароль
```
update user set password=PASSWORD("mynewpassword") where User='root';
```
update user set password=PASSWORD("mynewpassword") where User='root';
Перезапускаем привелегии
```
flush privileges;
```
flush privileges;
Выходим из консоли Mysql
```
exit
```
exit
Останавливаем службу Mysql сервера.
```
/etc/init.d/mysql stop
```
/etc/init.d/mysql stop
Запускаем службу Mysql сервера.
```
/etc/init.d/mysql start
```
/etc/init.d/mysql start
Теперь вы можете войти в консоль mysql с новым паролем.
