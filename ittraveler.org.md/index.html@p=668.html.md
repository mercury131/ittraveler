# Mysql Перенос баз данных на другой диск                	  
***Дата: 31.08.2015 Автор Admin***

Представим ситуацию когда вам нужно хранить базы данных Mysql на отдельном диске, а не на системном. 
Предположим диск для хранения БД уже подключен и смонтирован в каталог &#8212; /database
Теперь перейдем к настройке.
Останавливаем службу mysql
```
service mysql stop
```
service mysql stop
Далее копируем каталог с существующими БД на новый диск
```
sudo cp -R -p /var/lib/mysql /database/mysql
```
sudo cp -R -p /var/lib/mysql /database/mysql
Теперь открываем файл &#8212; /etc/mysql/my.cnf
В нем меняем значение параметра &#8212; datadir , оно должно соответствовать пути к новому диску.
Далее меняем значения AppArmor
Открываем файл &#8212; /etc/apparmor.d/usr.sbin.mysqld
Меняем все значения &#8212; /var/lib/mysql на /database/mysql
Перезапускаем AppArmor
```
service apparmor reload
```
service apparmor reload
Запускаем Mysql
```
service mysql start
```
service mysql start
Готово! Теперь БД будет храниться на новом диске.
&nbsp;
