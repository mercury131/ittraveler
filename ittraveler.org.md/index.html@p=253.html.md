# Настройка сети в организации. Часть 4                	  
***Дата: 30.01.2015 Автор Admin***

В этой части статьи мы рассмотрим создание GRE туннеля между офисом нашей компании и дата центром. Создадим инфраструктуру нашего оборудования в ДЦ, перенесем VTP сервер, добавим DMZ сеть и пропишем статические маршруты.Начнем мы с того что добавим новые устройства в нашу топологию, а именно:
gw-dc01 &#8212; маршрутизатор
coredc &#8212; ядро в сети ДЦ
sw-dcsrv01 &#8212; коммутатор для серверов
sw-dcdmz01 &#8212; коммутатор для DMZ сети
Должна получится следующая схема:
Теперь настроим наш маршрутизатор
Настройте hostname, пользователей, SSH.
Теперь настроим интерфейсы и подключимся к ISP
Интерфейс во внутреннюю сеть
```
gw-dc01(config)#interface ethernet 1/1
```
gw-dc01(config)#interface ethernet 1/1
```
gw-dc01(config-if)#ip address 10.10.18.90 255.255.255.0
```
gw-dc01(config-if)#ip address 10.10.18.90 255.255.255.0
```
gw-dc01(config-if)#no sh
```
gw-dc01(config-if)#no sh
```
*Jan 30 10:43:47.855: %LINK-3-UPDOWN: Interface Ethernet1/1, changed state to up
*Jan 30 10:43:48.855: %LINEPROTO-5-UPDOWN: Line protocol on Interface Ethernet1/1, changed state to up
```
*Jan 30 10:43:47.855: %LINK-3-UPDOWN: Interface Ethernet1/1, changed state to up*Jan 30 10:43:48.855: %LINEPROTO-5-UPDOWN: Line protocol on Interface Ethernet1/1, changed state to up
```
gw-dc01(config-if)#
```
gw-dc01(config-if)#
Интерфейс к ISP
```
gw-dc01(config)#interface ethernet 1/0
```
gw-dc01(config)#interface ethernet 1/0
```
gw-dc01(config-if)#ip address 172.16.13.51 255.255.255.0
```
gw-dc01(config-if)#ip address 172.16.13.51 255.255.255.0
```
gw-dc01(config-if)#no sh
```
gw-dc01(config-if)#no sh
```
gw-dc01(config-if)#
```
gw-dc01(config-if)#
Не забываем про маршруты
```
gw-dc01(config)#ip route 0.0.0.0 0.0.0.0 172.16.13.52
```
gw-dc01(config)#ip route 0.0.0.0 0.0.0.0 172.16.13.52
```
gw-dc01(config)#exit
```
gw-dc01(config)#exit
```
gw-dc01(config)#ip route 10.11.1.0 255.255.255.0 10.10.18.91
```
gw-dc01(config)#ip route 10.11.1.0 255.255.255.0 10.10.18.91
```
gw-dc01(config)#ip route 10.11.2.0 255.255.255.0 10.10.18.91
```
gw-dc01(config)#ip route 10.11.2.0 255.255.255.0 10.10.18.91
```
gw-dc01(config)#ip route 10.11.3.0 255.255.255.0 10.10.18.91
```
gw-dc01(config)#ip route 10.11.3.0 255.255.255.0 10.10.18.91
```
gw-dc01(config)#ip route 10.11.4.0 255.255.255.0 10.10.18.91
```
gw-dc01(config)#ip route 10.11.4.0 255.255.255.0 10.10.18.91
```
gw-dc01(config)#
```
gw-dc01(config)#
На самом роутере ISP тоже пропишем адрес и добавим адрес в топологию EIGRP
```
ISP-R5(config-if)#ip address 172.16.13.52 255.255.255.0
```
ISP-R5(config-if)#ip address 172.16.13.52 255.255.255.0
```
ISP-R5(config-if)#exit
```
ISP-R5(config-if)#exit
```
*Jan 30 10:33:14.323: %LINK-3-UPDOWN: Interface Ethernet1/1, changed state to up
*Jan 30 10:33:15.323: %LINEPROTO-5-UPDOWN: Line protocol on Interface Ethernet1/1, changed state to up
```
*Jan 30 10:33:14.323: %LINK-3-UPDOWN: Interface Ethernet1/1, changed state to up*Jan 30 10:33:15.323: %LINEPROTO-5-UPDOWN: Line protocol on Interface Ethernet1/1, changed state to up
```
ISP-R5(config-if)#exit
```
ISP-R5(config-if)#exit
```
ISP-R5(config)#router eigrp 1
```
ISP-R5(config)#router eigrp 1
```
ISP-R5(config-router)#network 172.16.13.0 0.0.0.255
```
ISP-R5(config-router)#network 172.16.13.0 0.0.0.255
```
ISP-R5(config-router)#
```
ISP-R5(config-router)#
Проверяем, пинг до Isp должен проходить.
```
gw-dc01#ping 172.16.13.52
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.13.52, timeout is 2 seconds:
.!!!!
Success rate is 80 percent (4/5), round-trip min/avg/max = 24/37/56 ms
gw-dc01#
```
gw-dc01#ping 172.16.13.52&nbsp;Type escape sequence to abort.Sending 5, 100-byte ICMP Echos to 172.16.13.52, timeout is 2 seconds:.!!!!Success rate is 80 percent (4/5), round-trip min/avg/max = 24/37/56 msgw-dc01#
Теперь настроим NAT для будущих сетей.
```
gw-dc01(config)#interface ethernet 1/1
```
gw-dc01(config)#interface ethernet 1/1
```
gw-dc01(config-if)#ip nat inside
```
gw-dc01(config-if)#ip nat inside
```
*Jan 30 10:56:49.015: %LINEPROTO-5-UPDOWN: Line protocol on Interface NVI0, changed state to up
```
*Jan 30 10:56:49.015: %LINEPROTO-5-UPDOWN: Line protocol on Interface NVI0, changed state to up
```
gw-dc01(config-if)#exit
```
gw-dc01(config-if)#exit
```
gw-dc01(config)#interface ethernet 1/0
```
gw-dc01(config)#interface ethernet 1/0
```
gw-dc01(config-if)#ip nat outside
```
gw-dc01(config-if)#ip nat outside
```
gw-dc01(config-if)#exit
```
gw-dc01(config-if)#exit
```
gw-dc01(config)#ip access-list standard internetdc
```
gw-dc01(config)#ip access-list standard internetdc
```
gw-dc01(config-std-nacl)#permit 10.10.18.0 0.0.0.255
```
gw-dc01(config-std-nacl)#permit 10.10.18.0 0.0.0.255
```
gw-dc01(config-std-nacl)#permit 10.11.1.0 0.0.0.255
```
gw-dc01(config-std-nacl)#permit 10.11.1.0 0.0.0.255
```
gw-dc01(config-std-nacl)#permit 10.11.2.0 0.0.0.255
```
gw-dc01(config-std-nacl)#permit 10.11.2.0 0.0.0.255
```
gw-dc01(config-std-nacl)#permit 10.11.3.0 0.0.0.255
```
gw-dc01(config-std-nacl)#permit 10.11.3.0 0.0.0.255
```
gw-dc01(config-std-nacl)#permit 10.11.4.0 0.0.0.255
```
gw-dc01(config-std-nacl)#permit 10.11.4.0 0.0.0.255
```
gw-dc01(config-std-nacl)#exit
```
gw-dc01(config-std-nacl)#exit
```
gw-dc01(config)#ip nat inside source list inetdc interface ethernet 1/0 overload
```
gw-dc01(config)#ip nat inside source list inetdc interface ethernet 1/0 overload
```
gw-dc01(config)#
```
gw-dc01(config)#
Теперь время настроить GRE туннель между офисом и ДЦ
Проверим пинг между внешними адресами
```
gw-dc01#ping 172.16.11.55
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.11.55, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 96/120/160 ms
gw-dc01#
```
gw-dc01#ping 172.16.11.55&nbsp;Type escape sequence to abort.Sending 5, 100-byte ICMP Echos to 172.16.11.55, timeout is 2 seconds:!!!!!Success rate is 100 percent (5/5), round-trip min/avg/max = 96/120/160 msgw-dc01#
Пинг есть. Отлично.
Начнем настройку туннеля.
Туннель настраивается с 2-х сторон. Начнем с DC
Создаем интерфейс туннеля
```
gw-dc01(config)#interface tunnel 0
```
gw-dc01(config)#interface tunnel 0
```
*Jan 30 11:19:31.303: %LINEPROTO-5-UPDOWN: Line protocol on Interface Tunnel0, changed state to down
```
*Jan 30 11:19:31.303: %LINEPROTO-5-UPDOWN: Line protocol on Interface Tunnel0, changed state to down
Задаем IP адрес туннеля
```
gw-dc01(config-if)#ip address 10.10.10.1 255.255.255.0
```
gw-dc01(config-if)#ip address 10.10.10.1 255.255.255.0
Указываем выходной интерфейс
```
gw-dc01(config-if)#tunnel source ethernet 1/0
```
gw-dc01(config-if)#tunnel source ethernet 1/0
Указываем принимающий IP
```
gw-dc01(config-if)#tunnel destination 172.16.11.55
```
gw-dc01(config-if)#tunnel destination 172.16.11.55
```
*Jan 30 11:22:27.695: %LINEPROTO-5-UPDOWN: Line protocol on Interface Tunnel0, changed state to up
```
*Jan 30 11:22:27.695: %LINEPROTO-5-UPDOWN: Line protocol on Interface Tunnel0, changed state to up
```
gw-dc01(config-if)#no sh
```
gw-dc01(config-if)#no sh
```
gw-dc01(config-if)#
```
gw-dc01(config-if)#
Теперь настроим шифрование IPsec
Создаем политику
```
gw-dc01(config)#crypto isakmp policy 1
```
gw-dc01(config)#crypto isakmp policy 1
Указываем алгоритм шафрования
```
gw-dc01(config-isakmp)#encr aes
```
gw-dc01(config-isakmp)#encr aes
Указываем аутентификацию по предварительному ключу
```
gw-dc01(config-isakmp)#authentication pre-share
```
gw-dc01(config-isakmp)#authentication pre-share
Указываем pre-shared key для проверки подлинности соседа
```
gw-dc01(config-isakmp)#crypto isakmp key CISCO address 172.16.11.55
```
gw-dc01(config-isakmp)#crypto isakmp key CISCO address 172.16.11.55
Далее мы указываем параметры для обработки трафика.
```
gw-dc01(config)#crypto ipsec transform-set AES128-SHA esp-aes esp-sha-hmac
```
gw-dc01(config)#crypto ipsec transform-set AES128-SHA esp-aes esp-sha-hmac
Теперь создаём карту шифрования:
```
gw-dc01(cfg-crypto-trans)#crypto map MAP1 10 ipsec-isakmp
% NOTE: This new crypto map will remain disabled until a peer
and a valid access list have been configured.
```
gw-dc01(cfg-crypto-trans)#crypto map MAP1 10 ipsec-isakmp% NOTE: This new crypto map will remain disabled until a peer&nbsp;and a valid access list have been configured.
Указываем адрес соседа IPsec
```
gw-dc01(config-crypto-map)#set peer 172.16.11.55
```
gw-dc01(config-crypto-map)#set peer 172.16.11.55
```
gw-dc01(config-crypto-map)#set transform-set AES128-SHA
```
gw-dc01(config-crypto-map)#set transform-set AES128-SHA
```
gw-dc01(config-crypto-map)#match address 101
```
gw-dc01(config-crypto-map)#match address 101
```
gw-dc01(config-crypto-map)#exit
```
gw-dc01(config-crypto-map)#exit
Создаем ACL для нашего туннеля
```
gw-dc01(config)#access-list 101 permit ip host 10.10.10.1 host 10.10.10.2
```
gw-dc01(config)#access-list 101 permit ip host 10.10.10.1 host 10.10.10.2
Назначаем карту шифрования на интерфейс
```
gw-dc01(config)#interface ethernet 1/0
```
gw-dc01(config)#interface ethernet 1/0
```
gw-dc01(config-if)#crypto map MAP1
```
gw-dc01(config-if)#crypto map MAP1
```
*Jan 30 11:33:02.055: %CRYPTO-6-ISAKMP_ON_OFF: ISAKMP is ON
```
*Jan 30 11:33:02.055: %CRYPTO-6-ISAKMP_ON_OFF: ISAKMP is ON
```
gw-dc01(config-if)#exit
```
gw-dc01(config-if)#exit
```
gw-dc01(config)#do wr
```
gw-dc01(config)#do wr
```
Building configuration...
[OK]
```
Building configuration...[OK]
Со стороны DC все готово. Проведем симметричную настройку со стороны офиса.
```
gw-msk01#conf t
Enter configuration commands, one per line.  End with CNTL/Z.
```
gw-msk01#conf tEnter configuration commands, one per line.  End with CNTL/Z.
```
gw-msk01(config)#interface Tunnel0
*Jan 30 11:40:23.863: %LINEPROTO-5-UPDOWN: Line protocol on Interface Tunnel0, changed state to down
```
gw-msk01(config)#interface Tunnel0*Jan 30 11:40:23.863: %LINEPROTO-5-UPDOWN: Line protocol on Interface Tunnel0, changed state to down
```
gw-msk01(config-if)#ip address 10.10.10.2 255.255.255.0
```
gw-msk01(config-if)#ip address 10.10.10.2 255.255.255.0
```
gw-msk01(config-if)#tunnel source ethernet 1/0
```
gw-msk01(config-if)#tunnel source ethernet 1/0
```
gw-msk01(config-if)#tunnel destination 172.16.13.51
```
gw-msk01(config-if)#tunnel destination 172.16.13.51
```
*Jan 30 11:41:50.859: %LINEPROTO-5-UPDOWN: Line protocol on Interface Tunnel0, changed state to up
```
*Jan 30 11:41:50.859: %LINEPROTO-5-UPDOWN: Line protocol on Interface Tunnel0, changed state to up
```
gw-msk01(config-if)#exit
```
gw-msk01(config-if)#exit
```
gw-msk01(config)#crypto isakmp policy 1
```
gw-msk01(config)#crypto isakmp policy 1
```
gw-msk01(config-isakmp)#encr aes
```
gw-msk01(config-isakmp)#encr aes
```
gw-msk01(config-isakmp)#authentication pre-share
```
gw-msk01(config-isakmp)#authentication pre-share
```
gw-msk01(config-isakmp)#crypto isakmp key CISCO address 172.16.13.51
```
gw-msk01(config-isakmp)#crypto isakmp key CISCO address 172.16.13.51
```
gw-msk01(config)#crypto ipsec transform-set AES128-SHA esp-aes esp-sha-hmac
```
gw-msk01(config)#crypto ipsec transform-set AES128-SHA esp-aes esp-sha-hmac
```
gw-msk01(cfg-crypto-trans)#crypto map MAP1 10 ipsec-isakmp
% NOTE: This new crypto map will remain disabled until a peer
and a valid access list have been configured.
```
gw-msk01(cfg-crypto-trans)#crypto map MAP1 10 ipsec-isakmp% NOTE: This new crypto map will remain disabled until a peer&nbsp;and a valid access list have been configured.
```
gw-msk01(config-crypto-map)#set peer 172.16.13.51
```
gw-msk01(config-crypto-map)#set peer 172.16.13.51
```
gw-msk01(config-crypto-map)#set transform-set AES128-SHA
```
gw-msk01(config-crypto-map)#set transform-set AES128-SHA
```
gw-msk01(config-crypto-map)#match address 101
```
gw-msk01(config-crypto-map)#match address 101
```
gw-msk01(config-crypto-map)#exit
```
gw-msk01(config-crypto-map)#exit
```
gw-msk01(config)#access-list 101 permit ip host 10.10.10.1 host 10.10.10.2
```
gw-msk01(config)#access-list 101 permit ip host 10.10.10.1 host 10.10.10.2
```
gw-msk01(config)#interface ethernet 1/0
```
gw-msk01(config)#interface ethernet 1/0
```
gw-msk01(config-if)#crypto map MAP1
```
gw-msk01(config-if)#crypto map MAP1
```
gw-msk01(config-if)#
```
gw-msk01(config-if)#
```
*Jan 30 11:45:27.407: %CRYPTO-6-ISAKMP_ON_OFF: ISAKMP is ON
```
*Jan 30 11:45:27.407: %CRYPTO-6-ISAKMP_ON_OFF: ISAKMP is ON
```
gw-msk01(config-if)#exit
```
gw-msk01(config-if)#exit
```
gw-msk01(config)#exit
```
gw-msk01(config)#exit
```
*Jan 30 11:45:33.307: %SYS-5-CONFIG_I: Configured from console by console
```
*Jan 30 11:45:33.307: %SYS-5-CONFIG_I: Configured from console by console
```
gw-msk01#wr
Building configuration...
[OK]
```
gw-msk01#wrBuilding configuration...[OK]
Проверяем пинг между маршрутизаторами в туннеле.
```
gw-msk01#ping 10.10.10.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.10.10.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 112/148/168 ms
gw-msk01#
```
gw-msk01#ping 10.10.10.1&nbsp;Type escape sequence to abort.Sending 5, 100-byte ICMP Echos to 10.10.10.1, timeout is 2 seconds:!!!!!Success rate is 100 percent (5/5), round-trip min/avg/max = 112/148/168 msgw-msk01#
Все работает. Туннель настроен
Теперь настроим маршруты между нашими сетями.
Из DC в Office
```
gw-dc01#conf t
```
gw-dc01#conf t
```
gw-dc01(config)#ip route 10.10.1.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.1.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.2.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.2.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.3.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.3.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.4.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.4.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.9.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.9.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.19.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#ip route 10.10.19.0 255.255.255.0 10.10.10.2
```
gw-dc01(config)#
```
gw-dc01(config)#
Из Office в DC
```
gw-msk01#conf t
Enter configuration commands, one per line.  End with CNTL/Z.
```
gw-msk01#conf tEnter configuration commands, one per line.  End with CNTL/Z.
```
gw-msk01(config)#ip route 10.11.1.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#ip route 10.11.1.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#ip route 10.11.2.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#ip route 10.11.2.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#ip route 10.11.3.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#ip route 10.11.3.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#ip route 10.11.4.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#ip route 10.11.4.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#ip route 10.10.18.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#ip route 10.10.18.0 255.255.255.0 10.10.10.1
```
gw-msk01(config)#
```
gw-msk01(config)#
Проверяем пинг из DC
```
gw-dc01#ping 10.10.1.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.10.1.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 128/172/248 ms
gw-dc01#
```
gw-dc01#ping 10.10.1.1&nbsp;Type escape sequence to abort.Sending 5, 100-byte ICMP Echos to 10.10.1.1, timeout is 2 seconds:!!!!!Success rate is 100 percent (5/5), round-trip min/avg/max = 128/172/248 msgw-dc01#
Все работает.
Перейдем к настройке ядра.
Настройте на нем пользователей, SSH, hostname
Настроим интерфейсы
```
core-dc(config)#interface fastEthernet 1/1
```
core-dc(config)#interface fastEthernet 1/1
```
core-dc(config-if)#no switchport
*Mar  1 00:05:21.415: %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet1/1, changed state to up
```
core-dc(config-if)#no switchport*Mar  1 00:05:21.415: %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet1/1, changed state to up
```
core-dc(config-if)#ip address 10.10.18.91 255.255.255.0
```
core-dc(config-if)#ip address 10.10.18.91 255.255.255.0
```
core-dc(config-if)#exit
```
core-dc(config-if)#exit
```
core-dc(config)#interface range fastEthernet 1/2 - 15
```
core-dc(config)#interface range fastEthernet 1/2 - 15
```
core-dc(config-if-range)#duplex full
```
core-dc(config-if-range)#duplex full
```
core-dc(config-if-range)#speed 100
```
core-dc(config-if-range)#speed 100
```
core-dc(config-if-range)#no sh
```
core-dc(config-if-range)#no sh
```
core-dc(config-if-range)#switchport trunk encapsulation dot1q
```
core-dc(config-if-range)#switchport trunk encapsulation dot1q
```
core-dc(config-if-range)#switchport mode trunk
```
core-dc(config-if-range)#switchport mode trunk
```
core-dc(config-if-range)#
```
core-dc(config-if-range)#
Включим маршрутизацию.
```
core-dc(config)#ip routing
```
core-dc(config)#ip routing
Пропишем Default route
```
core-dc(config)#ip route 0.0.0.0 0.0.0.0 10.10.18.90
```
core-dc(config)#ip route 0.0.0.0 0.0.0.0 10.10.18.90
Настроим VTP сервер для DC
```
core-dc(config)#vtp mode server
Setting device to VTP SERVER mode
```
core-dc(config)#vtp mode serverSetting device to VTP SERVER mode
```
core-dc(config)#vtp domain test.com
Domain name already set to test.com.
```
core-dc(config)#vtp domain test.comDomain name already set to test.com.
```
core-dc(config)#vtp password cisco
Password already set to cisco
core-dc(config)#
```
core-dc(config)#vtp password ciscoPassword already set to ciscocore-dc(config)#
Объясню почему мы поднимаем отдельный VTP сервер.
Дело в том что vtp работает только по транковым портам, а в нашем случае взять транковый порт неоткуда. Поэтому создаем сервер и заполняем VLAN вручную.
```
core-dc(config)#vlan 101
```
core-dc(config)#vlan 101
```
core-dc(config-vlan)#name MSK-workstations
```
core-dc(config-vlan)#name MSK-workstations
```
core-dc(config-vlan)#exit
```
core-dc(config-vlan)#exit
```
core-dc(config)#vlan 102
```
core-dc(config)#vlan 102
И так добавляем все известные VLAN
Настроим шлюзы для VLAN
```
core-dc(config)#interface vlan 201
```
core-dc(config)#interface vlan 201
```
core-dc(config-if)#ip address 10.11.1.1 255.255.255.0
```
core-dc(config-if)#ip address 10.11.1.1 255.255.255.0
```
core-dc(config-if)#no sh
```
core-dc(config-if)#no sh
```
core-dc(config-if)#
```
core-dc(config-if)#
```
core-dc(config)#interface vlan 202
```
core-dc(config)#interface vlan 202
```
core-dc(config-if)#ip address 10.11.2.1 255.255.255.0
```
core-dc(config-if)#ip address 10.11.2.1 255.255.255.0
```
core-dc(config-if)#no sh
```
core-dc(config-if)#no sh
```
core-dc(config-if)#
```
core-dc(config-if)#
```
core-dc(config)#interface vlan 203
```
core-dc(config)#interface vlan 203
```
core-dc(config-if)#ip address 10.11.3.1 255.255.255.0
```
core-dc(config-if)#ip address 10.11.3.1 255.255.255.0
```
core-dc(config-if)#no sh
```
core-dc(config-if)#no sh
```
core-dc(config-if)#
```
core-dc(config-if)#
```
core-dc(config)#int vlan 204
```
core-dc(config)#int vlan 204
```
core-dc(config-if)#ip address 10.11.4.1 255.255.255.0
```
core-dc(config-if)#ip address 10.11.4.1 255.255.255.0
```
core-dc(config-if)#no sh
```
core-dc(config-if)#no sh
```
core-dc(config-if)#
```
core-dc(config-if)#
Теперь настроим DMZ сеть.
Создадим ACL правило
```
core-dc(config)#ip access-list extended dmz
```
core-dc(config)#ip access-list extended dmz
```
core-dc(config-ext-nacl)#permit ip 10.11.4.0 0.0.0.255 any
```
core-dc(config-ext-nacl)#permit ip 10.11.4.0 0.0.0.255 any
```
core-dc(config-ext-nacl)#exit
```
core-dc(config-ext-nacl)#exit
```
core-dc(config)#
```
core-dc(config)#
Применим правило.
```
core-dc(config)#interface vlan 204
```
core-dc(config)#interface vlan 204
```
core-dc(config-if)#ip access-group dmz in
```
core-dc(config-if)#ip access-group dmz in
```
core-dc(config-if)#ip access-group dmz out
```
core-dc(config-if)#ip access-group dmz out
```
core-dc(config-if)#exit
```
core-dc(config-if)#exit
```
core-dc(config)#
```
core-dc(config)#
Готово. Теперь настроим клиентские коммутаторы.
Настройте коммутатор sw-dcsrv01 на использование VTP  и настройте Access порты на VLAN 203
Настройте коммутатор sw-dcdmz01 на использование VTP  и настройте Access порты на VLAN 400
В итоге у Вас должна получиться такая схема сети:
Дата центр
Общая схема сети
Подведем итоги.
Мы добавили нашей компании датацентр, построили GRE туннель между офисом и датацентром, зашифровали трафик внутри, а также настроили сетевую инфраструктуру нашей стойки в дата центре.
Теперь на основе полученных знаний Вы можете добавить еще один регион, построить в нем сетевую инфраструктуру, и построить GRE туннель.
&nbsp;
&nbsp;
&nbsp;
