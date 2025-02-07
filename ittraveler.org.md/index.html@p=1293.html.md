#                 	Установка и настройка Kafka кластера                	  
***            ***

			
            
		
    
	
    	  Дата: 28.10.2019 Автор Admin  
	В данной статье рассмотрим как настроить kafka кластер из 3-х серверов с поддержкой ssl.
Действия описанные ниже выполняем на всех 3-х серверах.
&nbsp;
Добавляем правила Firewall для Kafka и Zookeeper
sudo nano /etc/firewalld/services/zooKeeper.xml
 
&lt;?xml version="1.0" encoding="utf-8"?&gt;
 
&lt;service&gt;
 
&lt;short&gt;ZooKeeper&lt;/short&gt;
 
&lt;description&gt;Firewall rule for ZooKeeper ports&lt;/description&gt;
 
&lt;port protocol="tcp" port="2888"/&gt;
 
&lt;port protocol="tcp" port="3888"/&gt;
 
&lt;port protocol="tcp" port="2181"/&gt;
 
&lt;/service&gt;
&nbsp;
sudo nano /etc/firewalld/services/kafka.xml
&lt;?xml version="1.0" encoding="utf-8"?&gt;
 
&lt;service&gt;
 
&lt;short&gt;Kafka&lt;/short&gt;
 
&lt;description&gt;Firewall rule for Kafka port&lt;/description&gt;
 
&lt;port protocol="tcp" port="9092"/&gt;
 
&lt;/service&gt;
&nbsp;
Активируем правила
sudo service firewalld restart

sudo firewall-cmd --permanent --add-service=zooKeeper

sudo firewall-cmd --permanent --add-service=kafka

sudo service firewalld restart
&nbsp;
Создаем пользователя для kafka
sudo adduser kafka

sudo passwd kafka
&nbsp;
Устанавливаем Java
yum install java-1.8.0-openjdk
&nbsp;
Скачиваем последнюю версию Kafka
wget http://apache-mirror.8birdsvideo.com/kafka/2.3.0/kafka_2.11-2.3.0.tgz
&nbsp;
Распаковываем
tar -xzf kafka_2.11-2.3.0.tgz
&nbsp;
Перемещаем в /opt
mv kafka_2.11-2.3.0 /opt/kafka
&nbsp;
Создаем каталоги для логов Kafka и для zooKeeper
mkdir -p /opt/kafka/zookeeper/data

mkdir -p /opt/kafka/kafka-logs
&nbsp;
Переходим к конфигурации zooKeeper, открываем файл с конфигурацией
nano /opt/kafka/config/zookeeper.properties
&nbsp;
и указываем:
директорию с данными:
dataDir=/opt/kafka/zookeeper/data
Сервера и лимиты синхронизации:
server.1=kafka1.dev.local:2888:3888
server.2=kafka2.dev.local:2888:3888
server.3=kafka3.dev.local:2888:3888
initLimit=5
syncLimit=2
Далее, на каждом сервере создаем свой id для zooKeeper
echo "1" &gt; /opt/kafka/zookeeper/data/myid (для сервера kafka1.dev.local)

echo "2" &gt; /opt/kafka/zookeeper/data/myid (для сервера kafka2.dev.local)

echo "3" &gt; /opt/kafka/zookeeper/data/myid (для сервера kafka3.dev.local)
&nbsp;
Переходим к настройке kafka
Редактируем конфиг сервера
nano /opt/kafka/config/server.properties
&nbsp;
Добавляем:
broker.id=1 (для каждого сервера свой 1,2,3)
директорию с логами
log.dirs=/opt/kafka/kafka-logs
указываем прослушиватели:
listeners=PLAINTEXT://:9092
advertised.listeners=PLAINTEXT://kafka1.dev.local:9092
listeners &#8212; используется для внутреннего траффика между нодами кластера
advertised.listeners &#8212; используется для клиентского траффика
указываем ноды zooKeeper:
zookeeper.connect=kafka1.dev.local:2181,kafka2.dev.local:2181,kafka3.dev.local:2181
Если вам требуется поддержка удаления топиков, включите опцию ниже:
delete.topic.enable=true
Далее меняем владельца на пользователя kafka
chown -R kafka /opt/kafka
&nbsp;
Теперь создадим сервисы systemd для zooKeeper и kafka
Создадим сервис zooKeeper
nano /etc/systemd/system/zookeeper.service
&nbsp;
[Unit]

Description=ZooKeeper for Kafka

After=network.target

[Service]

Type=forking

User=kafka

Restart=on-failure

LimitNOFILE=16384:163840

ExecStart=/opt/kafka/bin/zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties

[Install]

WantedBy=multi-user.target
&nbsp;
&nbsp;
Создадим сервис Kafka
nano /etc/systemd/system/kafka.service
&nbsp;
[Unit]

Description=Kafka Broker

After=network.target

After=zookeeper.service

[Service]

Type=forking

User=kafka

SyslogIdentifier=kafka (%i)

Restart=on-failure

LimitNOFILE=16384:163840

ExecStart=/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties

[Install]

WantedBy=multi-user.target
&nbsp;
После создания файлов загружаем информацию о новых сервисах и включаем их
systemctl daemon-reload

systemctl enable zookeeper

systemctl enable kafka
&nbsp;
Перезагружаем сервера и убеждаемся что сервисы запущены
Логинимся под пользователем kafka
su kafka
переходим в каталог с kafka
cd /opt/kafka
&nbsp;
Проверим что zooKeeper работает корректно и все ноды видят друг друга
bin/zookeeper-shell.sh localhost:2181 ls /brokers/ids
&nbsp;
вывод должен быть таким:
Connecting to localhost:2181

WATCHER::

WatchedEvent state:SyncConnected type:None path:null

[1, 2, 3]
&nbsp;
Теперь проверим корректность работы Kafka, на текущей ноде запустим Producer, обратите внимание, что топик будет создан автоматически
bin/kafka-console-producer.sh --broker-list kafka1:9092,kafka2:9092,kafka3:9092 --topic example-topic
&nbsp;
На другой ноде, например на kafka2, запустим Consumer
su kafka
cd /opt/kafka
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic example-topic
&nbsp;
Теперь на запущенном Producer вводим сообщения, они должны появится на ноде с запущенным Consumer
Посмотреть список созданных топиков можно следующей командой:
bin/kafka-topics.sh --list --zookeeper localhost:2181
Получить информацию о созданном топике можно следующей командой:
bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic example-topic
&nbsp;
Удалить топик можно следующей командой:
bin/kafka-topics.sh --zookeeper localhost:2181 --delete --topic example-topic
Обратите внимание, что для удаления топика необходимо добавить delete.topic.enable=True в конфиг сервера Kafka
Создать топик с определенными параметрами можно следующей командой:
bin/kafka-topics.sh --create \

--zookeeper localhost:2181 \

--topic &lt;topic-name&gt; \

--partitions &lt;number-of-partitions&gt; \

--replication-factor &lt;number-of-replicating-servers&gt;
&nbsp;
Также можно выполнить более тонкую настройку топика при его создании, например:
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 3 --config min.insync.replicas=1 --config retention.ms=-1 --config unclean.leader.election.enable=false --topic test-topic
Изменить параметры топика можно следующей командой (изменим количество партиций и параметр min.insync.replicas):
bin/kafka-topics.sh --zookeeper localhost:2181 --alter --topic test-topic --partitions 8 --config min.insync.replicas=2
&nbsp;
Посмотреть кол-во открытых соединений к Kafka можно командой:
netstat -anp | grep :9092 | grep ESTABLISHED | wc -l
&nbsp;
Узнать размер топика можно командой:
bin/kafka-log-dirs.sh --bootstrap-server localhost:9092 --topic-list 'test-topic' --describe | grep '^{' | jq '[ ..|.size? | numbers ] | add'
&nbsp;
Посмотреть список активных consumer можно командой:
bin/kafka-consumer-groups.sh --list --bootstrap-server localhost:9092
Получив список клиентов можно посмотреть более подробную информацию о consumer, в примере ниже клиент console-consumer-70311
bin/kafka-consumer-groups.sh --describe --group console-consumer-70311 --bootstrap-server localhost:9092
Теперь рассмотрим как добавить подержку SSL, это снизит производительность, но повысит безопасность, т.к. соединения к kafka будут зашифрованы
Создадим сертификаты для Kafka, в данном случае они будут самоподписанные, но ничего не мешает использовать свой CA для подписи, если он у вас есть.
Создаем каталог /opt/kafka/ssl на всех нодах
mkdir /opt/kafka/ssl
переходим в него
cd /opt/kafka/ssl
На этом этапе создадим ключи для нашего CA
openssl req -new -x509 -keyout ca-key -out ca-cert -days 365
&nbsp;
Далее импортируем сертификат CA в создаваемые server.truststore.jks и client.truststore.jks
keytool -keystore server.truststore.jks -alias CARoot -import -file ca-cert

keytool -keystore client.truststore.jks -alias CARoot -import -file ca-cert
Копируем эти файлы на остальные ноды
scp ca-cert root@kafka2:/opt/kafka/ssl/

scp ca-cert root@kafka3:/opt/kafka/ssl/

scp ca-key root@kafka2:/opt/kafka/ssl/

scp ca-key root@kafka3:/opt/kafka/ssl/

scp server.truststore.jks root@kafka2:/opt/kafka/ssl/

scp server.truststore.jks root@kafka3:/opt/kafka/ssl/

scp client.truststore.jks root@kafka2:/opt/kafka/ssl/

scp client.truststore.jks root@kafka3:/opt/kafka/ssl/
&nbsp;
Создаем Java keystore и CSR запрос для сертификатов брокера, выполняем эти операции каждой ноде
keytool -genkeypair -alias KafkaServerSSL -keyalg RSA -keystore server.keystore.jks -keysize 2048 -dname "CN=$(hostname -f),OU=IT,O=COMPANY,L=RUSSIA,ST=Moscow,C=RU" -ext san=dns:kafka1.dev.local,dns:kafka2.dev.local,dns:kafka3.dev.local
keytool -certreq -alias KafkaServerSSL -keystore server.keystore.jks -file $(hostname -f).csr -ext san=dns:kafka1.dev.local,dns:kafka2.dev.local,dns:kafka3.dev.local -ext EKU=serverAuth,clientAuth
&nbsp;
При создании сертифката убедитесь что CN полностью совпадает с FQDN вашего Kafka сервера
Создаем файл myssl-config.cnf со следующим содержимым
[ SAN ]

extendedKeyUsage = serverAuth, clientAuth

subjectAltName = @alt_names

[alt_names]

DNS.1 = kafka1.dev.local

DNS.2 = kafka2.dev.local

DNS.3 = kafka3.dev.local
&nbsp;
Подписываем его нашим CA (пароль укажите от своего CA)
openssl x509 -req -CA ca-cert -CAkey ca-key -extensions SAN -extfile myssl-config.cnf -in $(hostname -f).csr -out cert-signed -CAcreateserial -passin pass:123123
Добавляем сертифкаты в server.keystore.jks
keytool -keystore server.keystore.jks -alias CARoot -import -file ca-cert

keytool -import -file cert-signed -keystore server.keystore.jks -alias KafkaServerSSL
Теперь, когда на каждой ноде есть сертификаты, переходим к конфигурации KAFKA, добавляем поддержку SSL.
Открываем server.properties на серверах и добавляем следующие строки в конфиг
nano /opt/kafka/config/server.properties
ssl.keystore.location=/opt/kafka/ssl/server.keystore.jks

ssl.keystore.password=123123

ssl.key.password=123123

ssl.truststore.location=/opt/kafka/ssl/server.truststore.jks

ssl.truststore.password=123123

ssl.client.auth=none

ssl.enabled.protocols=TLSv1.2,TLSv1.1,TLSv1

ssl.keystore.type=JKS

ssl.truststore.type=JKS

security.inter.broker.protocol=SSL

ssl.endpoint.identification.algorithm=

listeners=PLAINTEXT://:9092,SSL://kafka1.dev.local:9093

advertised.listeners=PLAINTEXT://kafka1.dev.local:9092,SSL://kafka1.dev.local:9093
&nbsp;
Добавим правила для firewall
sudo nano /etc/firewalld/services/kafkassl.xml
&lt;?xml version="1.0" encoding="utf-8"?&gt;

&lt;service&gt;

&lt;short&gt;Kafkassl&lt;/short&gt;

&lt;description&gt;Firewall rule for Kafka SSL port&lt;/description&gt;

&lt;port protocol="tcp" port="9093"/&gt;

&lt;/service&gt;
&nbsp;
Активируем правила
sudo service firewalld restart

sudo firewall-cmd --permanent --add-service=kafkassl

sudo service firewalld restart
&nbsp;
Перезапускаем сервисы Kafka
service kafka restart
&nbsp;
Теперь Kafka доступна по порту SSL 9093
Но чтобы к ней подключиться необходимо добавить конфигурацию для клиента, для этого нужно создать специальный файл client.properties, создаем его
nano client.properties
&nbsp;
содержимое файла:
security.protocol=SSL

ssl.truststore.location=/opt/kafka/ssl/client.truststore.jks

ssl.truststore.password=123123

ssl.truststore.type=JKS

ssl.keystore.type=JKS
&nbsp;
В данном файле указывается путь к файлу truststore, тип хранилища и security protocol
Теперь, чтобы producer или consumer клиенты его использовали, нужно передать им этот конфиг в специальном параметре
Пример запуска producer
/opt/kafka/bin/kafka-console-producer.sh --producer.config client.properties --broker-list kafka1.dev.local:9093,kafka2.dev.local:9093,kafka3.dev.local:9093 --topic example-topic2
&nbsp;
Пример запуска consumer
/opt/kafka/bin/kafka-console-consumer.sh --consumer.config client.properties --bootstrap-server kafka3.dev.local:9093 --topic example-topic2
&nbsp;
Обратите внимание что при подключении нужно указывать полный FQDN брокеров
Если вы будете использовать свой внутренний CA, то вам понадобятся следующие команды чтобы импортировать PFX сертификаты в keystore:
keytool -importkeystore -srckeystore cert.pfx -srcstoretype pkcs12 -destkeystore cert.keystore.jks -deststoretype JKS
&nbsp;
Также, обратите внимание что Kafka в параметре ssl.keystore.password (в файле server.properties) ожидает что пароль от приватного ключа и keystore совпадает.
Если это не так, выполните команду по замене пароля приватного ключа:
keytool -keypasswd -keystore cert.keystore.jks -alias Hnmshuefg7efsjfh3w4hffs
Узнать алиас сертификата в keystore можно командой:
keytool -list -v -keystore cert.keystore.jks
&nbsp;
Теперь перейдем к настройке авторизации, рассмотрим мы два варианта, по логину и паролю и по сертификату.
Начнем с первого метода.
Создаем файл /opt/kafka/config/kafka_jaas.conf , в котором будут храниться логины и пароли в SASL/PLAIN формате
nano /opt/kafka/config/kafka_jaas.conf
содержимое файла будет следующим:
KafkaServer {

org.apache.kafka.common.security.plain.PlainLoginModule required

username="admin"

password="password"

user_admin="password"

user_test="password";

};
&nbsp;
Итого мы создали 3 пользователя:brokeradmin,admin,test
Далее нужно добавить в строку запуска сервиса kafka параметр Djava.security.auth.login.config , в переменную KAFKA_OPTS, для этого выполняем:
nano /etc/systemd/system/kafka.service
Добавляем строку Environment=&#8217;KAFKA_OPTS=-Djava.security.auth.login.config=/opt/kafka/config/kafka_jaas.conf&#8217;
Должно получиться так:
[Unit]

Description=Kafka Broker

After=network.target

After=zookeeper.service

[Service]

Type=forking

User=kafka

SyslogIdentifier=kafka (%i)

Restart=on-failure

LimitNOFILE=16384:163840

Environment='KAFKA_OPTS=-Djava.security.auth.login.config=/opt/kafka/config/kafka_jaas.conf'

ExecStart=/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties

[Install]

WantedBy=multi-user.target
&nbsp;
Теперь редактируем файл /opt/kafka/config/server.properties
nano /opt/kafka/config/server.properties
&nbsp;
Добавляем/редактируем строки:
listeners=SASL_SSL://kafka1.dev.local:9093
advertised.listeners=SASL_SSL://kafka1.dev.local:9093
security.inter.broker.protocol=SASL_SSL
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.enabled.mechanisms=PLAIN
authorizer.class.name=kafka.security.auth.SimpleAclAuthorizer
ssl.endpoint.identification.algorithm=
super.users=User:admin
Выполняем эти настройки на всех трех нодах kafka1.dev.local/kafka2.dev.local/kafka2.dev.local и перезапускаем сервисы.
systemctl daemon-reload

systemctl restart kafka
Теперь, если запустить Producer со старым конфигом мы получим ошибку авторизации.
/opt/kafka/bin/kafka-console-producer.sh --producer.config client.properties --broker-list kafka1.dev.local:9093,kafka2.dev.local:9093,kafka3.dev.local:9093 --topic example-topic2
ошибка &#8212; disconnected
Чтобы все заработало, изменим тип подключения в client.properties на SASL_SSL
nano client.properties
&nbsp;
добавляем/изменяем строки:
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
Теперь создаем jaas файл для авторизации
nano jaas.conf
&nbsp;
содержимое файла:
KafkaClient {

org.apache.kafka.common.security.plain.PlainLoginModule required

username="test"

password="password";

};
&nbsp;
Перед использованием Consumer или producer нужно экспортировать переменную KAFKA_OPTS, в которой будут переданы наши учетные данные
export KAFKA_OPTS="-Djava.security.auth.login.config=jaas.conf"
Теперь запустим команду еще раз, и подключение заработает, но мы получим ошибку TOPIC_AUTHORIZATION_FAILED
/opt/kafka/bin/kafka-console-producer.sh --producer.config client.properties --broker-list kafka1.dev.local:9093,kafka2.dev.local:9093,kafka3.dev.local:9093 --topic example-topic2
&nbsp;
Настраиваем по аналогии Consumer на соседней ноде и видим что подключение работает, но сообщения не читаются, ошибка TOPIC_AUTHORIZATION_FAILED
/opt/kafka/bin/kafka-console-consumer.sh --consumer.config client.properties --bootstrap-server kafka3.dev.local:9093 --topic example-topic2
&nbsp;
Это связано с тем что мы еще не выдали права на топики Kafka. Исправим это.
Предоставим пользователю test права на запись в топик example-topic2 с любого хоста
/opt/kafka/bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:test --operation Write --topic example-topic2
&nbsp;
И на чтение
/opt/kafka/bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:test --operation Read --topic example-topic2
&nbsp;
Также нужно дать права на чтение группы, в моем случае это группа console-consumer-87796
/opt/kafka/bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:test --operation Read --group console-consumer-87796
&nbsp;
Если топик еще не создан, нужно выдать права на их создание, делается это так:
/opt/kafka/bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:test --operation Create --group console-consumer-87796
&nbsp;
Если не хотите заморачиваться можете выдавать права сразу на все группы, делается это параметром &#8212;group=&#8217;*&#8217; , например так:
/opt/kafka/bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:test --operation Read --topic example-topic2 --group='*'
&nbsp;
Теперь если запустить Consumer и Producer, все заработает корректно.
Более подробно ознакомится с правами доступа можно тут &#8212; https://docs.confluent.io/current/kafka/authorization.html
&nbsp;
Теперь, рассмотрим второй метод, выдачу доступа по SSL сертификатам.
Создаем Java keystore и CSR запрос для сертификата клиента.
keytool -genkeypair -alias KafkaClientSSL -keyalg RSA -keystore client.keystore.jks -keysize 2048 -dname "CN=kafka-client.dev.local,OU=IT,O=COMPANY,L=RUSSIA,ST=Moscow,C=RU"

keytool -certreq -alias KafkaClientSSL -keystore client.keystore.jks -file client.csr -ext EKU=serverAuth,clientAuth
&nbsp;
При создании сертифката убедитесь что CN полностью совпадает с FQDN вашего Kafka клиента
Создаем файл client-config.cnf со следующим содержимым
[ SAN ]

extendedKeyUsage = serverAuth, clientAuth
&nbsp;
Подписываем его нашим CA (пароль укажите от своего CA)
openssl x509 -req -CA ca-cert -CAkey ca-key -extensions SAN -extfile client-config.cnf -in client.csr -out client-cert-signed -CAcreateserial -passin pass:123123
&nbsp;
Добавляем сертифкат в client.keystore.jks
keytool -keystore client.keystore.jks -alias CARoot -import -file ca-cert

keytool -import -file client-cert-signed -keystore client.keystore.jks -alias KafkaClientSSL
&nbsp;
Создаем следующей файл для подключения
security.protocol=SSL

sasl.mechanism=PLAIN

ssl.truststore.location=/opt/kafka/ssl/client.truststore.jks

ssl.truststore.password=123123

#ssl.enabled.protocols=TLSv1.2,TLSv1.1,TLSv1

ssl.truststore.type=JKS

ssl.keystore.type=JKS

ssl.keystore.location=/opt/kafka/ssl/client.keystore.jks

ssl.keystore.password=123123

ssl.key.password=123123
&nbsp;
Проверяем что параметры в server.properties следующие:
ssl.keystore.location=/opt/kafka/ssl/server.keystore.jks

ssl.keystore.password=123123

ssl.key.password=123123

ssl.truststore.location=/opt/kafka/ssl/server.truststore.jks

ssl.truststore.password=123123

ssl.client.auth=required

ssl.enabled.protocols=TLSv1.2,TLSv1.1,TLSv1

ssl.keystore.type=JKS

ssl.truststore.type=JKS

security.inter.broker.protocol=SSL

ssl.endpoint.identification.algorithm=
authorizer.class.name=kafka.security.auth.SimpleAclAuthorizer
super.users=User:CN=kafka1.dev.local,OU=IT,O=COMPANY,L=RUSSIA,ST=Moscow,C=RU
&nbsp;
Выдадим права на запись в топик example-topic2
/opt/kafka/bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:'CN=kafka-client.dev.local,OU=IT,O=COMPANY,L=RUSSIA,ST=Moscow,C=RU' --operation Write --topic example-topic2

/opt/kafka/bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:'CN=kafka-client.dev.local,OU=IT,O=COMPANY,L=RUSSIA,ST=Moscow,C=RU' --operation Create --topic example-topic2
&nbsp;
Выдадим права на чтение в топик example-topic2
/opt/kafka/bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:'CN=kafka-client.dev.local,OU=IT,O=COMPANY,L=RUSSIA,ST=Moscow,C=RU' --operation Read --topic example-topic2 --group '*'
Теперь запустим Producer
/opt/kafka/bin/kafka-console-producer.sh --producer.config client.propertiesssl --broker-list kafka1.dev.local:9093,kafka2.dev.local:9093,kafka3.dev.local:9093 --topic example-topic2
&nbsp;
Запустим Consumer
/opt/kafka/bin/kafka-console-consumer.sh --consumer.config client.propertiesssl --bootstrap-server kafka3.dev.local:9093 --topic example-topic2
&nbsp;
Все работает.
Теперь протестируем отказоустойчивость kafka.
Для этого я сгенерирую текстовый файл в 10 000 000 строк, эти строки мы запишем в топик kafka, далее примем сообщения consumer и сохраним их в текстовый файл.
Во время заливки мы отключим одну из 3-х нод kafka и в конце сравним, файл на consumer и оригинальный файл.
Поскольку kafka гарантирует доставку сообщений, то файлы должны совпадать.
Создадим топик million
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 3 --config min.insync.replicas=2 --config retention.ms=-1 --config unclean.leader.election.enable=false --topic million
&nbsp;
Создадим тестовый файл
touch generate
nano generate
#/bin/bash

for i in {1..10000000};

do

echo $i
echo $i &gt;&gt; tokafka.txt
chmod +x generate
./generate
&nbsp;
Тестовый файл с сообщениями готов.
Теперь запускаем команду для заливки данных
cat tokafka.txt | /opt/kafka/bin/kafka-console-producer.sh --producer.config client.propertiesssl --broker-list kafka1.dev.local:9093,kafka2.dev.local:9093,kafka3.dev.local:9093 --topic million
&nbsp;
теперь на сервере с consumer запускаем сам consumer с выводом в файл
/opt/kafka/bin/kafka-console-consumer.sh --consumer.config client.propertiesssl --bootstrap-server kafka1.dev.local:9093 --topic million &gt; from-kafka.txt
&nbsp;
Запускаем скрипт Producer-а , видим что пошла заливка данных и через некоторое время отключаем любую из нод сервера kafka
После завершения заливки данных проверим файл from-kafka.txt ,командой:
wc -l from-kafka.txt
число строк в выводе должно быть 10000000.
Недоступность одного из брокеров не повлияла на отправку/доставку сообщений.
Проверим состояние топика во время недоступности одной из нод:
bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic million
&nbsp;
Вывод будет следующим:
Topic:million PartitionCount:3 ReplicationFactor:3 Configs:retention.ms=-1,unclean.leader.election.enable=false,min.insync.replicas=2
Topic: million Partition: 0 Leader: 1 Replicas: 1,2,3 Isr: 1,2
Topic: million Partition: 1 Leader: 2 Replicas: 2,3,1 Isr: 2,1
Topic: million Partition: 2 Leader: 1 Replicas: 3,1,2 Isr: 1,2
&nbsp;
Как видим число синхронных реплик &#8212; 1 (Isr), все партиции доступны и у каждой из них есть лидер.
В данном случае топик был настроен правильно, т.к. мы указали следующие параметры:
min.insync.replicas &#8212; кол-во реплик, на которые должны быть синхронизированы данные, прежде чем записаться.
unclean.leader.election.enable=false отключение возможности провести failover на не синхронную отстающую реплику с потенциальной потерей данных
ReplicationFactor:3 &#8212; кол-во реплик, на которые реплицируются данные.
После восстановления отключенной реплики видим что данные успешно синхронизированы
Topic:million PartitionCount:3 ReplicationFactor:3 Configs:retention.ms=-1,unclean.leader.election.enable=false,min.insync.replicas=2
Topic: million Partition: 0 Leader: 1 Replicas: 1,2,3 Isr: 1,2,3
Topic: million Partition: 1 Leader: 2 Replicas: 2,3,1 Isr: 2,1,3
Topic: million Partition: 2 Leader: 1 Replicas: 3,1,2 Isr: 1,2,3
&nbsp;
Related posts:Создание шаблонов Zabbix для Windows.Настраиваем аудит сервера Ubuntu через AIDEУстановка и настройка кластера MongoDB (replication set)
        
             Bash, Debian, Linux 
               
        
            
        
    
                        
                    
                    
                
        
                
	
		
		Добавить комментарий Отменить ответВаш адрес email не будет опубликован. Обязательные поля помечены *Комментарий * Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
	
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
			
        
        
		
        
           
    
    
  
	
    
		
        
             
			
                
                    
                                                  Все права защищены. IT Traveler 2025 
                         
                        
																														                    
                    
				
                
                
    
			
		                            
	
	
                
                
			
                
		
        
	
    
jQuery(document).ready(function($){
  $("a[rel*=lightbox]").colorbox({initialWidth:"30%",initialHeight:"30%",maxWidth:"90%",maxHeight:"90%",opacity:0.8,current:" {current}  {total}",previous:"",close:"Закрыть"});
});
  
    (function (d, w, c) {
        (w[c] = w[c] || []).push(function() {
            try {
                w.yaCounter27780774 = new Ya.Metrika({
                    id:27780774,
                    clickmap:true,
                    trackLinks:true,
                    accurateTrackBounce:true,
                    webvisor:true,
                    trackHash:true
                });
            } catch(e) { }
        });
        var n = d.getElementsByTagName("script")[0],
            s = d.createElement("script"),
            f = function () { n.parentNode.insertBefore(s, n); };
        s.type = "text/javascript";
        s.async = true;
        s.src = "https://mc.yandex.ru/metrika/watch.js";
        if (w.opera == "[object Opera]") {
            d.addEventListener("DOMContentLoaded", f, false);
        } else { f(); }
    })(document, window, "yandex_metrika_callbacks");
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-58126221-1', 'auto');
  ga('send', 'pageview');
