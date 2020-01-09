# Настройка сети в организации. Часть 3                	  
***Дата: 27.01.2015 Автор Admin***

В данной статье мы рассмотрим подключение к ISP провайдеру и динамическую маршрутизацию.
Итак, добавим отдельную сеть ISP провайдера.
добавим 4-е маршрутизатора и соединим их вместе.
Будем использовать следующие адреса:
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
172.16.11.0/24
Перейдем к настройке назначим адреса первому роутеру.
```
ISP-R1(config)#interface serial 2/0
```
ISP-R1(config)#interface serial 2/0
```
ISP-R1(config-if)#ip address 172.16.1.55 255.255.255.0
```
ISP-R1(config-if)#ip address 172.16.1.55 255.255.255.0
```
ISP-R1(config-if)#no sh
```
ISP-R1(config-if)#no sh
Настраиваем 2-й интерфейс.
```
ISP-R1(config)#interface serial 2/1
```
ISP-R1(config)#interface serial 2/1
```
ISP-R1(config-if)#ip address 172.16.2.55 255.255.255.0
```
ISP-R1(config-if)#ip address 172.16.2.55 255.255.255.0
```
ISP-R1(config-if)#no sh
```
ISP-R1(config-if)#no sh
Далее настраиваем интерфейсы на всех маршрутизаторах чтобы получилось как на рисунке:
С роутера ISP-R1 должны идти пинги на 172.16.2.56 и 172.16.1.56.
На другие сети 172.16.3.0 и 172.16.4.0 пинг идти не будет.
Исправим эту ситуацию с помощью динамической маршрутизации, поможет нам протокол  OSPF.
Первое, что нам нужно сделать — запустить процесс OSPF маршрутизаторе.
```
ISP-R1(config)#router ospf 1
```
ISP-R1(config)#router ospf 1
Далее указываем сети которые наш роутер будет анонсировать.
```
ISP-R1(config-router)#network 172.16.2.0 0.0.0.255 area 0
```
ISP-R1(config-router)#network 172.16.2.0 0.0.0.255 area 0
```
ISP-R1(config-router)#network 172.16.1.0 0.0.0.255 area 0
```
ISP-R1(config-router)#network 172.16.1.0 0.0.0.255 area 0
```
ISP-R1(config-router)#
```
ISP-R1(config-router)#
&nbsp;
Проводим аналогичные настройки на всех маршрутизаторах.
Обратите внимание что для каждого роутера указываются свои сети. Также обратите внимание что в сети мы указываем обратную маску.
В процессе настройки вы будете видеть следующую надпись:
```
*Jan 23 13:11:33.959: %OSPF-5-ADJCHG: Process 1, Nbr 172.16.2.55 on Serial2/1 from LOADING to FULL, Loading Done
```
*Jan 23 13:11:33.959: %OSPF-5-ADJCHG: Process 1, Nbr 172.16.2.55 on Serial2/1 from LOADING to FULL, Loading Done
Это означает что роутер загрузил настройки (информацию о маршрутизируемых сетях)  с роутера соседа.
Теперь когда вы настроили OSPF на всех роутерах запустите пинг с ISP-R3 на адрес 172.16.2.56.
```
ISP-R3#ping 172.16.2.56
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.2.56, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 128/187/272 ms
ISP-R3#
```
ISP-R3#ping 172.16.2.56Type escape sequence to abort.Sending 5, 100-byte ICMP Echos to 172.16.2.56, timeout is 2 seconds:!!!!!Success rate is 100 percent (5/5), round-trip min/avg/max = 128/187/272 msISP-R3#
Как видите пинг идет.
Просмотреть все маршруты можно командой:
```
ISP-R1#sh ip route
```
ISP-R1#sh ip route
Теперь маршрутизаторы анонсируют друг другу известные им сети.
На основе динамических маршрутов роутеры строят пути прохождения пакетов.
Также роутеры проверяют доступность друг друга, если кто-то из них умрет маршрут уже  пойдет по другому пути, через доступный роутер.
Теперь добавим в нашу схему еще один сегмент ISP сети.
Добавим еще 4 роутера и настроим сеть как показано на рисунке.
Теперь мы настроим протокол динамической маршрутизации EIGRP.
Настройка практически идентична OSPF
```
ISP-R5(config)#router eigrp 1
```
ISP-R5(config)#router eigrp 1
```
ISP-R5(config-router)#no auto-summary
```
ISP-R5(config-router)#no auto-summary
```
ISP-R5(config-router)#network 172.16.6.0 0.0.0.255
```
ISP-R5(config-router)#network 172.16.6.0 0.0.0.255
```
ISP-R5(config-router)#network 172.16.7.0 0.0.0.255
```
ISP-R5(config-router)#network 172.16.7.0 0.0.0.255
Такую настройку нужно произвести на каждом роутере.
Соответственно анонсированные сети на роутерах будут разные.
В процессе настройки будут появляться сообщения:
```
*Jan 23 14:00:05.743: %DUAL-5-NBRCHANGE: IP-EIGRP(0) 1: Neighbor 172.16.7.55 (Serial2/1) is up: new adjacency
```
*Jan 23 14:00:05.743: %DUAL-5-NBRCHANGE: IP-EIGRP(0) 1: Neighbor 172.16.7.55 (Serial2/1) is up: new adjacency
Теперь можно проверить пинг.
```
ISP-R7(config-router)#do ping 172.16.8.55
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.8.55, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 20/32/64 ms
ISP-R7(config-router)#
```
ISP-R7(config-router)#do ping 172.16.8.55Type escape sequence to abort.Sending 5, 100-byte ICMP Echos to 172.16.8.55, timeout is 2 seconds:!!!!!Success rate is 100 percent (5/5), round-trip min/avg/max = 20/32/64 msISP-R7(config-router)#
Все работает корректно.
Теперь рассмотрим как соединить 2-е наши сети.
Рассмотрим как соединить OSPF и EIGRP.
Соединяем сети и настраиваем интерфейсы как на рисунке.
```
ISP-R7(config)#interface serial 2/2
```
ISP-R7(config)#interface serial 2/2
```
ISP-R7(config-if)#ip address 172.16.10.55 255.255.255.0
```
ISP-R7(config-if)#ip address 172.16.10.55 255.255.255.0
```
ISP-R7(config-if)#no sh
```
ISP-R7(config-if)#no sh
```
ISP-R2(config)#interface serial 2/2
```
ISP-R2(config)#interface serial 2/2
```
ISP-R2(config-if)#ip address 172.16.10.56 255.255.255.0
```
ISP-R2(config-if)#ip address 172.16.10.56 255.255.255.0
```
ISP-R2(config-if)#no sh
```
ISP-R2(config-if)#no sh
Настроим маршрутизацию со стороны EIGRP на роутере ISP-R7.
```
ISP-R7(config)#router ospf 1
```
ISP-R7(config)#router ospf 1
```
ISP-R7(config-router)#redistribute eigrp 1 subnets
```
ISP-R7(config-router)#redistribute eigrp 1 subnets
```
ISP-R7(config-router)#
```
ISP-R7(config-router)#
```
ISP-R7(config-router)#router ospf 1
```
ISP-R7(config-router)#router ospf 1
```
ISP-R7(config-router)#network 172.16.10.0 0.0.0.255 area 0
```
ISP-R7(config-router)#network 172.16.10.0 0.0.0.255 area 0
```
*Jan 23 14:49:03.635: %OSPF-5-ADJCHG: Process 1, Nbr 172.16.3.55 on Serial2/2 from LOADING to FULL, Loading Done
```
*Jan 23 14:49:03.635: %OSPF-5-ADJCHG: Process 1, Nbr 172.16.3.55 on Serial2/2 from LOADING to FULL, Loading Done
```
ISP-R7(config-router)#network 172.16.9.0 0.0.0.255 area 0
```
ISP-R7(config-router)#network 172.16.9.0 0.0.0.255 area 0
```
ISP-R7(config-router)#network 172.16.6.0 0.0.0.255 area 0
```
ISP-R7(config-router)#network 172.16.6.0 0.0.0.255 area 0
```
ISP-R7(config-router)#
```
ISP-R7(config-router)#
Теперь из OSPF в EIGRP на роутере ISP-R2.
```
ISP-R2(config)#router eigrp 1
```
ISP-R2(config)#router eigrp 1
```
ISP-R2(config-router)#redistribute ospf 1 metric 100000 20 255 1 1500
```
ISP-R2(config-router)#redistribute ospf 1 metric 100000 20 255 1 1500
```
ISP-R2(config-router)#
```
ISP-R2(config-router)#
```
ISP-R2(config)#router eigrp 1
```
ISP-R2(config)#router eigrp 1
```
ISP-R2(config-router)#no auto-summary
```
ISP-R2(config-router)#no auto-summary
```
ISP-R2(config-router)#network 172.16.10.0
```
ISP-R2(config-router)#network 172.16.10.0
```
*Jan 23 14:47:16.731: %DUAL-5-NBRCHANGE: IP-EIGRP(0) 1: Neighbor 172.16.10.55 (Serial2/2) is up: new adjacency
```
*Jan 23 14:47:16.731: %DUAL-5-NBRCHANGE: IP-EIGRP(0) 1: Neighbor 172.16.10.55 (Serial2/2) is up: new adjacency
```
ISP-R2(config-router)#network 172.16.2.0
```
ISP-R2(config-router)#network 172.16.2.0
```
ISP-R2(config-router)#network 172.16.3.0
```
ISP-R2(config-router)#network 172.16.3.0
```
ISP-R2(config-router)#
```
ISP-R2(config-router)#
Теперь проверим пинг с ISP-R3 на ISP-R6.
```
ISP-R3#ping 172.16.8.55
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.16.8.55, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 308/381/472 ms
ISP-R3#
```
ISP-R3#ping 172.16.8.55Type escape sequence to abort.Sending 5, 100-byte ICMP Echos to 172.16.8.55, timeout is 2 seconds:!!!!!Success rate is 100 percent (5/5), round-trip min/avg/max = 308/381/472 msISP-R3#
Как видите все работает. Теперь у нас работает динамическая маршрутизация  между OSPF и EIRGP.
Теперь самое время добавить нашей компании интернет.
Добавим нашей компании маршрутизатор.
Настроим следующую схему подключений:
Подключим его к ядру.
Настроим адрес на ядре.
```
coremsk(config)#interface fastEthernet 1/3
```
coremsk(config)#interface fastEthernet 1/3
```
coremsk(config-if)#no switchport
```
coremsk(config-if)#no switchport
```
*Mar  1 00:03:04.111: %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet1/3, changed state to up
```
*Mar  1 00:03:04.111: %LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet1/3, changed state to up
```
coremsk(config-if)#ip address 10.10.19.72 255.255.255.0
```
coremsk(config-if)#ip address 10.10.19.72 255.255.255.0
```
coremsk(config-if)#no sh
```
coremsk(config-if)#no sh
```
coremsk(config-if)#
```
coremsk(config-if)#
Настроим адрес на маршрутизаторе.
```
gw-msk01(config)#interface ethernet 1/1
```
gw-msk01(config)#interface ethernet 1/1
```
gw-msk01(config-if)#ip address 10.10.19.71 255.255.255.0
```
gw-msk01(config-if)#ip address 10.10.19.71 255.255.255.0
```
gw-msk01(config-if)#no sh
```
gw-msk01(config-if)#no sh
```
*Jan 23 15:20:13.699: %LINK-3-UPDOWN: Interface Ethernet1/1, changed state to up
*Jan 23 15:20:14.699: %LINEPROTO-5-UPDOWN: Line protocol on Interface Ethernet1/1, changed state to up
```
*Jan 23 15:20:13.699: %LINK-3-UPDOWN: Interface Ethernet1/1, changed state to up*Jan 23 15:20:14.699: %LINEPROTO-5-UPDOWN: Line protocol on Interface Ethernet1/1, changed state to up
```
gw-msk01(config-if)#
```
gw-msk01(config-if)#
Настроим внешний ip адрес.
```
gw-msk01(config)#interface ethernet 1/0
```
gw-msk01(config)#interface ethernet 1/0
```
gw-msk01(config-if)#ip address 172.16.11.55 255.255.255.0
```
gw-msk01(config-if)#ip address 172.16.11.55 255.255.255.0
```
gw-msk01(config-if)#no sh
```
gw-msk01(config-if)#no sh
```
*Jan 23 15:21:33.079: %LINK-3-UPDOWN: Interface Ethernet1/0, changed state to up
```
*Jan 23 15:21:33.079: %LINK-3-UPDOWN: Interface Ethernet1/0, changed state to up
```
*Jan 23 15:21:34.079: %LINEPROTO-5-UPDOWN: Line protocol on Interface Ethernet1/0, changed state to up
```
*Jan 23 15:21:34.079: %LINEPROTO-5-UPDOWN: Line protocol on Interface Ethernet1/0, changed state to up
```
gw-msk01(config-if)#
```
gw-msk01(config-if)#
Теперь настроим адрес на стороне ISP и добавим сеть в анонс.
```
ISP-R1(config)#interface ethernet 1/0
```
ISP-R1(config)#interface ethernet 1/0
```
ISP-R1(config-if)#ip address 172.16.11.56 255.255.255.0
```
ISP-R1(config-if)#ip address 172.16.11.56 255.255.255.0
```
ISP-R1(config-if)#exit
```
ISP-R1(config-if)#exit
```
ISP-R1(config)#router ospf 1
```
ISP-R1(config)#router ospf 1
```
ISP-R1(config-router)#network 172.16.11.0 0.0.0.255 area 0
```
ISP-R1(config-router)#network 172.16.11.0 0.0.0.255 area 0
```
ISP-R1(config-router)#
```
ISP-R1(config-router)#
Готово. Теперь настроим NAT для нашей сети.
Переходим на gw-msk01.
Настраиваем ACL лист с внутренней сетью.
```
gw-msk01(config)#ip access-list standard internet
```
gw-msk01(config)#ip access-list standard internet
```
gw-msk01(config-std-nacl)#permit 10.10.1.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 10.10.1.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 10.10.2.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 10.10.2.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 10.10.3.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 10.10.3.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 10.10.4.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 10.10.4.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 10.10.9.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 10.10.9.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 192.168.12.0 0.0.0.255
```
gw-msk01(config-std-nacl)#permit 192.168.12.0 0.0.0.255
```
gw-msk01(config-std-nacl)#exit
```
gw-msk01(config-std-nacl)#exit
Теперь назначим NAT интерфейс внутрь сети.
```
gw-msk01(config)#interface ethernet 1/1
```
gw-msk01(config)#interface ethernet 1/1
```
gw-msk01(config-if)#ip nat inside
```
gw-msk01(config-if)#ip nat inside
```
gw-msk01(config-if)#
```
gw-msk01(config-if)#
```
*Jan 23 15:32:28.027: %LINEPROTO-5-UPDOWN: Line protocol on Interface NVI0, changed state to up
```
*Jan 23 15:32:28.027: %LINEPROTO-5-UPDOWN: Line protocol on Interface NVI0, changed state to up
```
gw-msk01(config-if)#exit
```
gw-msk01(config-if)#exit
```
gw-msk01(config)#
```
gw-msk01(config)#
И наружу.
```
gw-msk01(config)#interface ethernet 1/0
```
gw-msk01(config)#interface ethernet 1/0
```
gw-msk01(config-if)#ip nat outside
```
gw-msk01(config-if)#ip nat outside
```
gw-msk01(config-if)#exit
```
gw-msk01(config-if)#exit
```
gw-msk01(config)#
```
gw-msk01(config)#
Теперь включаем PAT и склеиваем его с нашим созданным ACL.
```
gw-msk01(config)#$ip nat inside source list inetdc interface ethernet 1/0 overload
```
gw-msk01(config)#$ip nat inside source list inetdc interface ethernet 1/0 overload
Опция overload включает PAT, позволяя выпускать в интернет более чем 1 ip адрес.
Теперь настраиваем default route на ядре и роутере.
```
coremsk(config)#ip route 0.0.0.0 0.0.0.0 10.10.19.71
```
coremsk(config)#ip route 0.0.0.0 0.0.0.0 10.10.19.71
```
coremsk(config)#
```
coremsk(config)#
```
gw-msk01(config)#ip route 0.0.0.0 0.0.0.0 172.16.11.56
```
gw-msk01(config)#ip route 0.0.0.0 0.0.0.0 172.16.11.56
```
gw-msk01(config)#
```
gw-msk01(config)#
Теперь настроим маршруты с gw-msk01 во внутреннюю сеть.
```
gw-msk01(config)#ip route 10.10.1.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#ip route 10.10.1.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#ip route 10.10.2.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#ip route 10.10.2.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#ip route 10.10.3.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#ip route 10.10.3.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#ip route 10.10.4.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#ip route 10.10.4.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#ip route 10.10.9.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#ip route 10.10.9.0 255.255.255.0 10.10.19.72
```
gw-msk01(config)#
```
gw-msk01(config)#
Теперь запустим пинг с клиентского компьютера &#171;наружу&#187;
```
VPCS&gt; ping 172.16.1.56
84 bytes from 172.16.1.56 icmp_seq=1 ttl=252 time=112.007 ms
84 bytes from 172.16.1.56 icmp_seq=2 ttl=252 time=89.005 ms
84 bytes from 172.16.1.56 icmp_seq=3 ttl=252 time=99.006 ms
84 bytes from 172.16.1.56 icmp_seq=4 ttl=252 time=101.006 ms
84 bytes from 172.16.1.56 icmp_seq=5 ttl=252 time=79.005 ms
```
VPCS&gt; ping 172.16.1.5684 bytes from 172.16.1.56 icmp_seq=1 ttl=252 time=112.007 ms84 bytes from 172.16.1.56 icmp_seq=2 ttl=252 time=89.005 ms84 bytes from 172.16.1.56 icmp_seq=3 ttl=252 time=99.006 ms84 bytes from 172.16.1.56 icmp_seq=4 ttl=252 time=101.006 ms84 bytes from 172.16.1.56 icmp_seq=5 ttl=252 time=79.005 ms
Все работает.
Для проверки запустим пинг с ISP-R3 на клиентский компьютер.
```
ISP-R3#ping 10.10.1.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.10.1.2, timeout is 2 seconds:
.....
Success rate is 0 percent (0/5)
ISP-R3#
```
ISP-R3#ping 10.10.1.2Type escape sequence to abort.Sending 5, 100-byte ICMP Echos to 10.10.1.2, timeout is 2 seconds:.....Success rate is 0 percent (0/5)ISP-R3#
Как видите, все настроено правильно, пинг не идет.
Теперь в нашей сети появился интернет.
В следующей статье мы добавим нашей компании дата центр, построим GRE туннель, перенесем vtp сервер, добавим DMZ сеть, и рассмотрим статические маршруты.
