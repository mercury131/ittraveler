# Clickhouse ошибка DB::Exception: Replica already exists..                	  
***Дата: 19.03.2019 Автор Admin***

При моргании сети или при длительной недоступности одной из реплик clickhouse &#8212; возможно ее повреждение.
В таком случае сервер может не стартовать службу clickhouse и при попытке пересоздания реплицируемой таблицы вы получите ошибку 253 Replica already exists..
Чтобы исправить эту ошибку и восстановить реплику clickhouse выполните следующее:
Cкопируйте sql файл с доступной живой реплики по пути
```
/var/lib/clickhouse/metadata/default
```
/var/lib/clickhouse/metadata/default
где default для БД, файл будет иметь название имя_таблицы.sql
Этот фай поместите на сломанную реплику, по аналогичному пути.
Далее выполните следующие команды:
```
chown clickhouse:clickhouse &lt;table_name&gt;.sql
```
chown clickhouse:clickhouse &lt;table_name&gt;.sql
```
chmod 0640 &lt;table_name&gt;.sql
```
chmod 0640 &lt;table_name&gt;.sql
Инициируйте процесс принудительного восстановления
```
sudo -u clickhouse touch /var/lib/clickhouse/flags/force_restore_data
```
sudo -u clickhouse touch /var/lib/clickhouse/flags/force_restore_data
Запустите службу clickhouse
```
service clickhouse-server start
```
service clickhouse-server start
Если при создании реплицируемой таблицы вы все еще получаете данную ошибку &#8212; удалите данные о таблице из zookeeper
Для этого откройте консоль zookeeper (расположена в директории с установленным zookeeper)
```
zkCli.sh
```
zkCli.sh
При возникновении ошибки Replica  already exists.. обычно указан путь в zookeeper, в котором хранится информация о реплике, например:
```
/clickhouse/tables/tx/replicas/srv1
```
/clickhouse/tables/tx/replicas/srv1
Выполните команду на удаление этого пути в запущенной ранее консоли zookeeper
```
rmr /clickhouse/tables/tx/replicas/srv1
```
 rmr /clickhouse/tables/tx/replicas/srv1
Теперь выполните команду
```
get /clickhouse/tables/tx/replicas/srv1
```
get /clickhouse/tables/tx/replicas/srv1
Если вы получили ошибку Node does not exist &#8212; значит информация о реплике удалена.
Теперь перезапустите clickhouse
```
service clickhouse-server restart
```
service clickhouse-server restart
После этих действий вы сможете создать реплицируемую таблицу, данные автоматически синхронизируются с доступных реплик.
