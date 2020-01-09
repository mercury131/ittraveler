# Настройка сети в организации. Часть 1.                	  
***Дата: 21.01.2015 Автор Admin***

В данном цикле статей, я расскажу как настроить сеть на оборудовании Cisco в средней организации.
Давайте рассмотрим пример, у нас средняя компания, человек на 100-500. Что нам нужно?
Настроить маршрутизаторы и коммутаторы, VLAN, разделить сети, настроить туннель VPN между филиалами, DHCP, ACL, NAT, подключиться к ISP провайдеру, изолировать некоторые сети (DMZ), маршрутизацию (Static, OSPF, ERGRP), агрегацию каналов (Etherchannel).
Придерживаться мы будем следующего плана ip адресов:
Адресация
Gateway
VLAN
Назначение
Регион
10.10.1.0/24
10.10.1.1
Workstations
MSK
10.10.2.0/24
10.10.2.1
IP Phones
MSK
10.10.3.0/24
10.10.3.1
Servers
MSK
10.10.4.0/24
10.10.4.1
Printers
MSK
10.10.9.0/24
10.10.9.1
Management
all
Адресация
Gateway
VLAN
Назначение
Регион
10.11.1.0/24
10.11.1.1
Workstations
DC
10.11.2.0/24
10.11.2.1
IP Telephony
DC
10.11.3.0/24
10.11.3.1
Servers
DC
10.11.4.0/24
10.11.4.1
DMZ
DC
Адресация
Gateway
VLAN
Назначение
Регион
10.12.1.0/24
10.12.1.1
Workstations
YAR
10.12.2.0/24
10.12.2.1
IP Phones
YAR
10.12.3.0/24
10.12.3.1
Servers
YAR
10.12.4.0/24
10.12.4.1
Printers
YAR
Адресация
Gateway
VLAN
Назначение
Регион
10.10.10.0/24
&#8212;
&#8212;
GRE Tunnel
MSK-DC-YAR
192.168.12.0/24
192.168.12.1
WIFI
ALL
Сеть провайдера ISP
172.16.1.0/24
172.16.2.0/24
172.16.3.0/24
172.16.4.0/24
172.16.5.0/24
172.16.5.0/24
172.16.7.0/24
172.16.8.0/24
172.16.9.0/24
172.16.10.0/24
В данной статье мы рассмотрим:
1) Базовую настройку маршрутизатора
2) Настройку SSH
3) Настройку доступов
4) Настройку VLAN
5) Настройку VTP
Итак, начнем. Тренироваться мы будем в эмуляторе GNS3 , будем использовать образы IOS c3725-adventerprisek9-mz124-15, c7200-advipservicesk9-mz.152-4.S5 , c2691-entservicesk9-mz.124-13b.
Добавим маршрутизатор c3725, это будет ядром нашей сети в Москве.
Подключаемся к консоли и назначаем hostname
```
R1#conf t
```
R1#conf t
```
R1(config)#hostname coremsk
```
R1(config)#hostname coremsk
```
coremsk(config)#
```
coremsk(config)#
Готово, как видите теперь наш маршрутизатор имеет нормальное название.
Теперь настроим доступы
Создадим новую модель
```
coremsk(config)#aaa new-model
```
coremsk(config)#aaa new-model
Создадим пользователя
```
coremsk(config)#username admin privilege 15  password 1234
```
coremsk(config)#username admin privilege 15&nbsp;&nbsp;password 1234
Установим Enable пароль
```
coremsk(config)#enable secret 1234
```
coremsk(config)#enable secret 1234
Теперь настроим SSH
Назначаем имя локального домена
```
coremsk(config)#ip domain name test.com
```
coremsk(config)#ip domain name test.com
Создаем RSA ключ
```
coremsk(config)#crypto key generate rsa
```
coremsk(config)#crypto key generate rsa
Включаем шифрование паролей
```
coremsk(config)#service password-encryption
```
coremsk(config)#service password-encryption
Конфигурируем виртуальный терминал
```
coremsk(config)#line vty 0 4
```
coremsk(config)#line vty 0 4
Указываем соединение по умолчанию &#8212; SSH
```
coremsk(config-line)#transport input ssh
```
coremsk(config-line)#transport input ssh
```
coremsk(config-line)#logging synchronous
```
coremsk(config-line)#logging synchronous
Устанавливаем SSH таймаут в 60 минут
```
coremsk(config-line)#exec-timeout 60 0
```
coremsk(config-line)#exec-timeout 60 0
Теперь 2 раза вводим exit и сохраняем настройки
```
coremsk#wr
Building configuration...
[OK]
```
coremsk#wrBuilding configuration...[OK]
Теперь мы можем подключаться к нашему устройству по SSH, пользователем admin.
Теперь настроим VLAN.
Переходим в режим конфигурации (команда conf t)
И настраиваем первый VLAN -101
```
coremsk(config)#vlan 101
```
coremsk(config)#vlan 101
```
coremsk(config-vlan)#name workstations_msk
```
coremsk(config-vlan)#name workstations_msk
```
coremsk(config-vlan)#exit
```
coremsk(config-vlan)#exit
```
coremsk(config)#
```
coremsk(config)#
&nbsp;
Готово! Наш первый Vlan создан.
Теперь создадим остальные VLAN из таблицы
```
coremsk(config)#vlan 102
```
coremsk(config)#vlan 102
```
coremsk(config-vlan)#name ipphones_msk
```
coremsk(config-vlan)#name ipphones_msk
```
coremsk(config-vlan)#exit
```
coremsk(config-vlan)#exit
```
coremsk(config)#vlan 103
```
coremsk(config)#vlan 103
```
coremsk(config-vlan)#name servers_msk
```
coremsk(config-vlan)#name servers_msk
```
coremsk(config-vlan)#exit
```
coremsk(config-vlan)#exit
```
coremsk(config)#vlan 104
```
coremsk(config)#vlan 104
```
coremsk(config-vlan)#name printers_msk
```
coremsk(config-vlan)#name printers_msk
```
coremsk(config-vlan)#exit
```
coremsk(config-vlan)#exit
Готово, vlan для московского офиса добавлены.
Список vlan можно посмотреть командой
```
coremsk#sh vlan-switch
```
coremsk#sh vlan-switch
или
```
coremsk#show vlans
```
coremsk#show vlans
Теперь настроим интерфейсы VLAN
Для этого переходим в режим конфигурации
Выбираем интерфейс нашего vlan
```
coremsk(config)#interface vlan 101
```
coremsk(config)#interface vlan 101
Настраиваем ip адрес, этот адрес будет шлюзом сети этого vlan
```
coremsk(config-if)#ip address 10.10.1.1 255.255.255.0
```
coremsk(config-if)#ip address 10.10.1.1 255.255.255.0
Поднимем интерфейс
```
coremsk(config-if)#no sh
```
coremsk(config-if)#no sh
Выйдем из режима конфигурации порта
```
coremsk(config-if)#exit
```
coremsk(config-if)#exit
Настраиваем остальные vlan
```
coremsk(config)#interface vlan 102
```
coremsk(config)#interface vlan 102
```
coremsk(config-if)#ip address 10.10.2.1 255.255.255.0
```
coremsk(config-if)#ip address 10.10.2.1 255.255.255.0
```
coremsk(config-if)#no sh
```
coremsk(config-if)#no sh
```
coremsk(config-if)#exit
```
coremsk(config-if)#exit
```
coremsk(config)#interface vlan 103
```
coremsk(config)#interface vlan 103
```
coremsk(config-if)#ip address 10.10.3.1 255.255.255.0
```
coremsk(config-if)#ip address 10.10.3.1 255.255.255.0
```
coremsk(config-if)#no sh
```
coremsk(config-if)#no sh
```
coremsk(config-if)#exit
```
coremsk(config-if)#exit
```
coremsk(config)#interface vlan 104
```
coremsk(config)#interface vlan 104
```
coremsk(config-if)#ip address 10.10.4.1 255.255.255.0
```
coremsk(config-if)#ip address 10.10.4.1 255.255.255.0
```
coremsk(config-if)#no sh
```
coremsk(config-if)#no sh
```
coremsk(config-if)#exit
```
coremsk(config-if)#exit
```
coremsk(config)#
```
coremsk(config)#
```
coremsk(config)#interface vlan 109
```
coremsk(config)#interface vlan 109
```
coremsk(config-if)#ip address 10.10.9.1 255.255.255.0
```
coremsk(config-if)#ip address 10.10.9.1 255.255.255.0
```
coremsk(config-if)#no sh
```
coremsk(config-if)#no sh
```
coremsk(config-if)#exit
```
coremsk(config-if)#exit
Теперь адреса шлюзов виртуальных сетей настроены.
Просмотреть настройки интерфейса можно командой
```
coremsk#sh interfaces vlan 101
```
coremsk#sh interfaces vlan 101
Сохраняем конфигурацию
```
coremsk#wr
```
coremsk#wr
Теперь виртуальные сети на нашем ядре настроены, очередь vtp.
VTP будет использоваться для автоматической загрузки VLAN на другие коммутаторы.
Начнем!
```
coremsk#conf t
```
coremsk#conf t
Переводим ядро в режим сервера
```
coremsk(config)#vtp mode server
```
coremsk(config)#vtp mode server
Устанавливаем домен
```
coremsk(config)#vtp domain test.com
```
coremsk(config)#vtp domain test.com
Устанавливаем пароль
```
coremsk(config)#vtp password cisco
```
coremsk(config)#vtp password cisco
```
coremsk(config)#exit
```
coremsk(config)#exit
Готово.
Статус VTP можно посмотреть командой:
```
coremsk#show vtp status
```
coremsk#show vtp status
Теперь включим на ядре маршрутизацию, иначе наши VLAN пинговаться не будут.
```
coremsk#conf t
```
coremsk#conf t
```
coremsk(config)#ip routing
```
coremsk(config)#ip routing
```
coremsk(config)#exit
```
coremsk(config)#exit
```
coremsk#wr
```
coremsk#wr
Готово. Теперь самое время добавить клиентские коммутаторы.
Добавим в GNS3 свич 2691
Теперь соединим его с ядром. Тут есть один момент.
Чтобы наши VLAN проходили между устройствами, порт прохождения должен быть транковым.
Еще нам нужно настроить ip адрес нового клиентского свича, вот тут и кроется нюанс.
Мы не можем назначить ip адрес на транковый порт. Порт должен быть в режиме маршрутизации.
А настраивать такой порт нам нет смысла.
Поэтому предлагаю убить 2-х зайцев и сделать следующее:
1) настроить ip адрес устройства на vlan 109
2) настроить 2 порта как link aggregation (для отказоустойчивости и повышенной пропускной способности) и перевести их в режим транк.
3) Настроить Access порты для клиентских устройств.
Начнем!
Первое что вы должны настроить, это доступы, пользователей, SSH, hostname. После этого переходите к следующему шагу. Настраивайте по аналогии с ядром.
Начнем настройку
Настроим транковые порты
Выбираем порты
```
sw-climsk01(config)#interface range fastEthernet 1/1 - 2
```
sw-climsk01(config)#interface range fastEthernet 1/1 - 2
Включаем на портах link aggregation
```
sw-climsk01(config)#Creating a port-channel interface Port-channel1
```
sw-climsk01(config)#Creating a port-channel interface Port-channel1
Настраиваем режим инкапсуляции порта
```
sw-climsk01(config)#interface portchannel 1
```
sw-climsk01(config)#interface portchannel 1
```
sw-climsk01(config-if)#switchport trunk encapsulation dot1q
```
sw-climsk01(config-if)#switchport trunk encapsulation dot1q
Переключаем порт в режим транк
```
sw-climsk01(config-if)#switchport mode trunk
```
sw-climsk01(config-if)#switchport mode trunk
Включаем порт
```
sw-climsk01(config-if)#no sh
```
sw-climsk01(config-if)#no sh
Готово.
Делаем параллельную настройку  link aggregation на ядре и соединяем порты ядра и свича.
```
coremsk(config)#interface range fastEthernet 1/1 - 2
```
coremsk(config)#interface range fastEthernet 1/1 - 2
```
coremsk(config-if-range)#channel-group 1 mode on
```
coremsk(config-if-range)#channel-group 1 mode on
```
coremsk(config)#interface portchannel 1
```
coremsk(config)#interface portchannel 1
```
coremsk(config-if-range)#switchport trunk encapsulation dot1q
```
coremsk(config-if-range)#switchport trunk encapsulation dot1q
```
coremsk(config-if-range)#switchport mode trunk
```
coremsk(config-if-range)#switchport mode trunk
```
coremsk(config-if-range)#no sh
```
coremsk(config-if-range)#no sh
Теперь настроим VTP клиент на клиентском свиче
В данном примере я покажу как это сделать в старых версиях IOS и новых.
В старых:
```
sw-climsk01#vlan database
```
sw-climsk01#vlan database
```
sw-climsk01(vlan)#vtp client
```
sw-climsk01(vlan)#vtp client
```
sw-climsk01(vlan)#vtp domain test.com
```
sw-climsk01(vlan)#vtp domain test.com
```
sw-climsk01(vlan)#vtp password cisco
```
sw-climsk01(vlan)#vtp password cisco
В новых:
```
coremsk(config)#vtp mode client
```
coremsk(config)#vtp mode client
```
coremsk(config)#vtp domain test.com
```
coremsk(config)#vtp domain test.com
```
coremsk(config)#vtp password cisco
```
coremsk(config)#vtp password cisco
Еще один момент. В GNS3 может корректно не заработать VTP если на интерфейсах не выполнить команды
```
sw-climsk01(config-if)#duplex full
```
sw-climsk01(config-if)#duplex full
```
coremsk(config-if)#duplex full
```
coremsk(config-if)#duplex full
```
sw-climsk01(config-if)#speed 100
```
sw-climsk01(config-if)#speed 100
```
coremsk(config-if)#speed 100
```
coremsk(config-if)#speed 100
Желательно предварительно выполнить эти команды на всех портах.
Теперь посмотрим создались ли VLAN на клиентском свиче
```
sw-climsk01#sh vlan-switch
```
sw-climsk01#sh vlan-switch
 
```
VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Fa1/0, Fa1/3, Fa1/4, Fa1/5
Fa1/6, Fa1/7, Fa1/8, Fa1/9
Fa1/10, Fa1/11, Fa1/12, Fa1/13
Fa1/14, Fa1/15
101  workstations_msk                 active
102  ipphones_msk                     active
103  servers_msk                      active
104  printers_msk                     active
109  management                       active
1002 fddi-default                     act/unsup
1003 token-ring-default               act/unsup
1004 fddinet-default                  act/unsup
1005 trnet-default
```
VLAN Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status&nbsp;&nbsp;&nbsp;&nbsp;Ports---- -------------------------------- --------- -------------------------------1&nbsp;&nbsp;&nbsp;&nbsp;default&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;active&nbsp;&nbsp;&nbsp;&nbsp;Fa1/0, Fa1/3, Fa1/4, Fa1/5Fa1/6, Fa1/7, Fa1/8, Fa1/9Fa1/10, Fa1/11, Fa1/12, Fa1/13Fa1/14, Fa1/15101&nbsp;&nbsp;workstations_msk&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active102&nbsp;&nbsp;ipphones_msk&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active103&nbsp;&nbsp;servers_msk&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;active104&nbsp;&nbsp;printers_msk&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active109&nbsp;&nbsp;management&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active1002 fddi-default&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; act/unsup1003 token-ring-default&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; act/unsup1004 fddinet-default&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;act/unsup1005 trnet-default
&nbsp;
 
Как видите VLAN создались
Теперь настроим ip адрес устройства в vlan 109
```
sw-climsk01#conf t
```
sw-climsk01#conf t
```
sw-climsk01(config)#interface vlan 109
```
sw-climsk01(config)#interface vlan 109
```
sw-climsk01(config-if)#no sh
```
sw-climsk01(config-if)#no sh
```
sw-climsk01(config-if)#ip address 10.10.9.2 255.255.255.0
```
sw-climsk01(config-if)#ip address 10.10.9.2 255.255.255.0
```
sw-climsk01(config-if)#exit
```
sw-climsk01(config-if)#exit
Теперь у нашего устройства есть адрес.
Теперь настроим порты под клиентские устройства
```
sw-climsk01(config)#interface range fastEthernet 1/3 - 4
```
sw-climsk01(config)#interface range fastEthernet 1/3 - 4
```
sw-climsk01(config-if-range)#no sh
```
sw-climsk01(config-if-range)#no sh
```
sw-climsk01(config-if-range)#switchport mode access
```
sw-climsk01(config-if-range)#switchport mode access
```
sw-climsk01(config-if-range)#switchport access vlan 101
```
sw-climsk01(config-if-range)#switchport access vlan 101
```
sw-climsk01(config-if-range)#exit
```
sw-climsk01(config-if-range)#exit
```
sw-climsk01(config)#interface range fastEthernet 1/5 - 6
```
sw-climsk01(config)#interface range fastEthernet 1/5 - 6
```
sw-climsk01(config-if-range)#no sh
```
sw-climsk01(config-if-range)#no sh
```
sw-climsk01(config-if-range)#switchport mode access
```
sw-climsk01(config-if-range)#switchport mode access
```
sw-climsk01(config-if-range)#switchport access vlan 102
```
sw-climsk01(config-if-range)#switchport access vlan 102
```
sw-climsk01(config-if-range)#exit
```
sw-climsk01(config-if-range)#exit
```
sw-climsk01(config)#interface range fastEthernet 1/7 - 8
```
sw-climsk01(config)#interface range fastEthernet 1/7 - 8
```
sw-climsk01(config-if-range)#switchport mode access
```
sw-climsk01(config-if-range)#switchport mode access
```
sw-climsk01(config-if-range)#switchport access vlan 103
```
sw-climsk01(config-if-range)#switchport access vlan 103
```
sw-climsk01(config-if-range)#exit
```
sw-climsk01(config-if-range)#exit
```
sw-climsk01(config)#interface range fastEthernet 1/9 - 10
```
sw-climsk01(config)#interface range fastEthernet 1/9 - 10
```
sw-climsk01(config-if-range)#switchport mode access
```
sw-climsk01(config-if-range)#switchport mode access
```
sw-climsk01(config-if-range)#switchport access vlan 104
```
sw-climsk01(config-if-range)#switchport access vlan 104
```
sw-climsk01(config-if-range)#exit
```
sw-climsk01(config-if-range)#exit
Готово, клиентские порты настроены, можно подключать устройства.
По аналогии настроим еще один клиентский свич sw-climsk02
Теперь подключим клиентские устройства в свичи.
Если запустить ping с ПК из VLAN 101 на коммутаторе sw-climsk01 на ПК из VLAN 103 на коммутаторе sw-climsk02, пинг пройдет корректно.
В итоге мы должны получить следующую схему:
Подведем итоги.
Мы настроили доступы, SSH, Vlan для наших сетей, VTP для передачи настроек VLAN между маршрутизаторами и коммутаторами, шлюзы, link aggregation, и порты.
В следующей статье мы рассмотрим настройку DHCP на устройствах Cisco, правила ACL, и многое другое.
Продолжение следует.
&nbsp;
