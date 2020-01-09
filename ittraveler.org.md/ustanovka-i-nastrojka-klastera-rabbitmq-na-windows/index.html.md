# Установка и настройка кластера RabbitMQ на Windows                	  
***Дата: 15.09.2019 Автор Admin***

Иногда есть необходимость установить кластер RabbitMQ на Windows сервера, в этой статье мы рассмотрим как это можно сделать.
Установка будет проводится на 3 сервера, на каждом из них нужно выполнить операции указанные ниже.
Устанавливаем Erlang, переходим на страницу https://www.rabbitmq.com/which&#8212;erlang.html и проверяем какая версия Erlang совместима с текущим RabbitMQ.
Скачиваем и устанавливаем необходимую версию Erlang по ссылке http://www.erlang.org/download.html
После установки устанавливаем переменную окружения ERLANG_HOME
Открываем Start &gt; Settings &gt; Control Panel &gt; System &gt; Advanced &gt; Environment Variables
Создаем системную переменную ERLANG_HOME, которая должна указывать на путь к установленному Erlang, например &#8212;  C:\Program Files\erl10.4
Скачиваем архив с RabbitMQ https://github.com/rabbitmq/rabbitmq&#8212;server/releases/download/v3.7.15/rabbitmq&#8212;server&#8212;windows-3.7.15.zip
В настоящий момент последняя версия 3.7.15
Распаковываем архив в C:\Program Files\RabbitMQ
По аналогии создаем системную переменную  RABBITMQ_SERVER , которая должна содержать полный путь к серверу (C:\Program Files\RabbitMQ)
Далее, в системную переменную Path добавляем значение ;%RABBITMQ_SERVER%\sbin
По аналогии создаем переменную с указанием пути к конфигу RABBITMQ
Переменная RABBITMQ_CONFIG_FILE , значение имя файла без расширения, например &#8212; c:\rabbitmq\rabbitmq
Создаем конфиг RABBITMQ &#8212; c:\rabbitmq\rabbitmq.config со следующим содержимым:
 
```
%% Sample
[
                {rabbit,
                                [
                                {tcp_listeners, [5672]},
                                {log_levels, [{connection, error}]},
                                {default_vhost,       &lt;&lt;"/"&gt;&gt;},
                                {default_user,        &lt;&lt;"username"&gt;&gt;},
                                {default_pass,        &lt;&lt;"password"&gt;&gt;},
                                {default_permissions, [&lt;&lt;".*"&gt;&gt;, &lt;&lt;".*"&gt;&gt;, &lt;&lt;".*"&gt;&gt;]},
                                {heartbeat, 60},
                                {cluster_partition_handling, pause-minority},
                                {frame_max, 1048576}
                                ]}
].
```
%% Sample&nbsp;&nbsp;[&nbsp;                {rabbit,&nbsp;                                [&nbsp;                                {tcp_listeners, [5672]},&nbsp;                                {log_levels, [{connection, error}]},&nbsp;                                {default_vhost,       &lt;&lt;"/"&gt;&gt;},&nbsp;                                {default_user,        &lt;&lt;"username"&gt;&gt;},&nbsp;                                {default_pass,        &lt;&lt;"password"&gt;&gt;},&nbsp;                                {default_permissions, [&lt;&lt;".*"&gt;&gt;, &lt;&lt;".*"&gt;&gt;, &lt;&lt;".*"&gt;&gt;]},&nbsp;                                {heartbeat, 60},&nbsp;                                {cluster_partition_handling, pause-minority},&nbsp;                                {frame_max, 1048576}&nbsp;                                ]}&nbsp;].
Соответственно вместо default_user и default_pass прописываем значения для дефолтного пользователя
cluster_partition_handling выставляем согласно статье https://www.rabbitmq.com/partitions.html#automatic&#8212;handling
pause&#8212;minority &#8212;  RabbitMQ перестанет принимать запросы если из строя вышло 2-е ноды из 3-х
pause_if_all_down &#8212; перестанет принимать запросы если из строя вышли все ноды указанные в конфиге 
ignore  &#8212; подойдет для кластера из двух нод
autoheal &#8212; RabbitMQ продолжит принимать запросы даже если из строя вышло 2-е ноды из 3-х. Минус данного подхода в том что сообщения могут потеряться. Данный режим подойдет если вы работаете в нестабильной сети.
 
Устанавливаем RabbitMQ как сервис. 
Для этого в консоли запускаем команду:
```
rabbitmq-service.bat install
```
rabbitmq-service.bat install
Запускаем сервис
Активируем Management плагин командой:
```
rabbitmq-plugins.bat enable rabbitmq_management
```
rabbitmq-plugins.bat enable rabbitmq_management
Теперь веб интерфейс RabbitMQ доступен по адресу http://localhost:15672 и доступен под УЗ указанной в конфиге
Теперь, перед тем как создавать кластер, синхронизируйте erlang cookie
В качестве мастера мы будем использовать первый сервер, у меня это rmq1.dev.local
На мастер сервере я копирую cookie из %APPDATA%\RabbitMQ\.erlang.cookie в каталог C:\Windows\System32\config\systemprofile
Далее с этого сервера я копирую файл %APPDATA%\RabbitMQ\.erlang.cookie в каталоги %APPDATA%\RabbitMQ\ и C:\Windows\System32\config\systemprofile на другие 2 сервера. 
В моем случае это rmq2.dev.local и rmq3.dev.local
После этого перезапускаем сервис RABBITMQ на серверах rmq2.dev.local и rmq3.dev.local
&nbsp;
Переходим к созданию кластера.
Открываем консоль на сервере rmq2.dev.local и выполняем 
```
 rabbitmqctl stop_app
rabbitmqctl join_cluster --ram rabbit@rmq1.dev.local
rabbitmqctl start_app
```
 rabbitmqctl stop_app&nbsp;rabbitmqctl join_cluster --ram rabbit@rmq1.dev.local&nbsp;&nbsp;rabbitmqctl start_app
&nbsp;
Повторяем операцию на сервере rmq3.dev.local
Кластер готов, все ноды отображаются в веб интерфейсе http://localhost:15672
Если для вас критична консистентность данных выполните команду ниже на любой из нод RABBITMQ
```
rabbitmqctl set_policy HA ".*" "{""ha-mode"": ""all""}"
```
rabbitmqctl set_policy HA ".*" "{""ha-mode"": ""all""}"
Теперь все сообщения будут считаться записанными только после того как будут синхронизированы на всех серверах.
Если по какой-то причине вам нужно удалить одну из нод выполните команды:
```
rabbitmqctl -n rabbit@rmq2.dev.local stop_app
rabbitmqctl forget_cluster_node rabbit@rmq2.dev.local
```
rabbitmqctl -n rabbit@rmq2.dev.local stop_app&nbsp;rabbitmqctl forget_cluster_node rabbit@rmq2.dev.local
На этом настройка кластера RabbitMQ завершена.
&nbsp;
