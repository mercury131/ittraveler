# Установка и настройка memcache                	  
***Дата: 12.05.2017 Автор Admin***

Давайте рассмотрим настройку memcached на примере связки memcached + PHP7.
Для начала давайте вспомним для чего нужен memcached.
memcached &#8212; это сервис кэширования данных в оперативной памяти на основе хеш-таблиц.
Другими словами, с помощью memcached вы можете кэшировать наиболее часто использующиеся данные в вашем приложении, например на вебсайте.
Установим memcached на ubuntu server
```
apt-get update
```
apt-get update
```
apt-get install memcached php-memcached
```
apt-get install memcached php-memcached
Перезапустим сервис memcached
```
service memcached restart
```
service memcached restart
Убедиться что сервис memcached запущен можно командой:
```
ps aux | grep memcached
```
ps aux | grep memcached
Перезапустим сервис PHP7
```
service php7.0-fpm restart
```
service php7.0-fpm restart
Теперь создайте страницу с PHP Info
PHP
```
&lt;?php
phpinfo();
?&gt;
```
&lt;?phpphpinfo();?&gt;
На ней должна появится запись о подключенном модуле memcached
Теперь рассмотрим простой пример на PHP
После установки memcached работает на localhost на порту 11211, к нему мы и подключимся.
Далее мы запишем ключ MYnewDATA с данными &#8212; Value Found!  I am saved in memcached!
PHP
```
&lt;?php
$mem = new Memcached();
$mem-&gt;addServer("127.0.0.1", 11211);
$result = $mem-&gt;get("MYnewDATA");
if ($result) {
echo $result;
} else {
echo "No matching key found yet. Let's start adding that now!";
$mem-&gt;set("MYnewDATA", "Value Found!  I am saved in memcached!") or die("Value not found in memcached...");
}
?&gt;
```
&lt;?php$mem = new Memcached();$mem-&gt;addServer("127.0.0.1", 11211); $result = $mem-&gt;get("MYnewDATA"); if ($result) {&nbsp;&nbsp;&nbsp;&nbsp;echo $result;} else {&nbsp;&nbsp;&nbsp;&nbsp;echo "No matching key found yet. Let's start adding that now!";&nbsp;&nbsp;&nbsp;&nbsp;$mem-&gt;set("MYnewDATA", "Value Found!&nbsp;&nbsp;I am saved in memcached!") or die("Value not found in memcached...");}?&gt;
При первой загрузке страницы вы должны увидеть надпись &#8212; Value not found in memcached&#8230;&#187;
При повторной загрузке страницы вы увидите надпись &#8212; Value Found!  I am saved in memcached!
Это самый простой пример сохранения данных из PHP в memcached , на самом деле методов работы с memcached через PHP намного больше, более подробно все описано тут.
Для просмотра сохраненных ключей можно использовать telnet
```
telnet localhost 11211
```
telnet localhost 11211
Далее выполнить команд:
```
stats items
```
stats items
Для просмотра текущих показателей memcached выполните команду:
```
stats
```
stats
Для удаления всех значений можно использовать команд:
```
flush_all
```
flush_all
Теперь давайте рассмотрим как работает memcached и как мы можем оптимизировать его работу.
Memcached использует алгоритм выделения памяти SLAB.
В самом SLAB храняться так называемые чанки, в которых храняться данные.
Когда мы сохраняем что-то в memcached , то выбирается пустой SLAB , а в нем пустой чанк.
Чтобы было проще понять иерархию хранения данных в Memcached , то выглядит она так:
```
SERVER-RAM---&gt;
Память выделенная под Memcached
---&gt;SLAB
---&gt;Chunk
---&gt;Memcached KEY-VALUE
```
SERVER-RAM---&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Память выделенная под Memcached&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---&gt;SLAB&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---&gt;Chunk&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---&gt;Memcached KEY-VALUE
Для обеспечения высокой скорости работы memcached выделяет чанки одинакового размера, если значение которое нужно сохранить в чанк меньше чем сам чанк, то остается свободное место.
Именно свободное место и можно использовать для оптимизации.
Для определения размера минимального размера чанка используется параметр -n , установить минимальный размер чанка в 16 байт можно так:
```
memcached -n 16
```
memcached -n 16
Уменьшать размер  чанка имеет смысл только для очень маленьких данных, например для хэшей, логинов, флагов.
Следующий параметр оптимизации -f , это фактор роста, с его помощью можно более эффективно создавать размеры SLAB
```
memcached -f 1.05
```
memcached -f 1.05
Это имеет смысл когда вы используете для хранения объекты разного размера, от очень маленьких данных до очень больших.
Еще один полезный параметр это -L, он позволяем выделить всю память под memcached сразу при старте.
Это значит что в процессе работы memcached не будет заниматься инициализацией SLAB и чанков.
Еще в конфиге memcached (/etc/memcached.conf) вы можете поменять следующие параметры:
```
-p 11211 (Используемый порт) 
-m 4096  (Кол-во выделенной памяти, в данном примере 4 GB)
-c 2000  (Лимит на кол-во соединений)
```
-p 11211 (Используемый порт) -m 4096&nbsp;&nbsp;(Кол-во выделенной памяти, в данном примере 4 GB)-c 2000&nbsp;&nbsp;(Лимит на кол-во соединений)
Обратите внимание, если вы выделили memcached 4 GB памяти, а хотите записать данных на 5 GB, то memcached начнет удалять данные по принципу Least Recently Used (LRU)
Это означает что в первую очередь memcached удалит те данные, которые запрашивались очень давно.
Наверное пока это все что хотелось бы рассказать про memcached, возможно в следующей статье я раскрою тему оптимизации более подробно.
