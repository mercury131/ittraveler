# Настройка сети в организации. Часть 2                	  
***Дата: 23.01.2015 Автор Admin***

В данной статье мы продолжим настройку нашей сети. В этом выпуске мы настроим: DHCP, ACL и добавим сеть WIFI.Начнем с добавления DHCP.
Открываем консоль нашего ядра, и вводим:
```
coremsk#conf t
```
coremsk#conf t
Создадим DHCP pool для Vlan 101
```
coremsk(config)#ip dhcp pool vlan101
```
coremsk(config)#ip dhcp pool vlan101
Теперь укажем сеть
```
coremsk(dhcp-config)#network 10.10.1.0 255.255.255.0
```
coremsk(dhcp-config)#network 10.10.1.0 255.255.255.0
Укажем шлюз
```
coremsk(dhcp-config)#default-router 10.10.1.1
```
coremsk(dhcp-config)#default-router 10.10.1.1
```
coremsk(dhcp-config)#exit
```
coremsk(dhcp-config)#exit
Теперь укажем какие адреса не нужно раздавать клиентам, в нашем случае это адрес шлюза
```
coremsk(config)#ip dhcp excluded-address 10.10.1.1
```
coremsk(config)#ip dhcp excluded-address 10.10.1.1
Настраиваем другие DHCP пулы по аналогии
```
coremsk(config)#ip dhcp pool vlan102
```
coremsk(config)#ip dhcp pool vlan102
```
coremsk(dhcp-config)#network 10.10.2.0 255.255.255.0
```
coremsk(dhcp-config)#network 10.10.2.0 255.255.255.0
```
coremsk(dhcp-config)#default-router 10.10.2.1
```
coremsk(dhcp-config)#default-router 10.10.2.1
```
coremsk(config)#ip dhcp excluded-address 10.10.2.1
```
coremsk(config)#ip dhcp excluded-address 10.10.2.1
```
coremsk(config)#ip dhcp pool vlan103
```
coremsk(config)#ip dhcp pool vlan103
```
coremsk(dhcp-config)#network 10.10.3.0 255.255.255.0
```
coremsk(dhcp-config)#network 10.10.3.0 255.255.255.0
```
coremsk(dhcp-config)#default-router 10.10.3.1
```
coremsk(dhcp-config)#default-router 10.10.3.1
```
coremsk(config)#ip dhcp excluded-address 10.10.3.1
```
coremsk(config)#ip dhcp excluded-address 10.10.3.1
```
coremsk(config)#ip dhcp pool vlan104
```
coremsk(config)#ip dhcp pool vlan104
```
coremsk(dhcp-config)#network 10.10.4.1 255.255.255.0
```
coremsk(dhcp-config)#network 10.10.4.1 255.255.255.0
```
coremsk(dhcp-config)#default-router 10.10.4.1
```
coremsk(dhcp-config)#default-router 10.10.4.1
```
coremsk(config)#ip dhcp excluded-address 10.10.4.1
```
coremsk(config)#ip dhcp excluded-address 10.10.4.1
Готово, теперь настройте компьютеры на автоматическое получение адресов.
Как видите компьютеры получили адреса из своей сети.
Если вы используете свой DHCP сервер, то на шлюзе нужно указать IP Helper
Делается это так:
```
coremsk(config)# interface vlan101
```
coremsk(config)# interface vlan101
```
coremsk(config-if)# ip address 10.10.1.1 255.255.255.0
```
coremsk(config-if)# ip address 10.10.1.1 255.255.255.0
```
coremsk(config-if)# ip helper-address 10.10.3.55
```
coremsk(config-if)# ip helper-address 10.10.3.55
Где 10.10.3.55, это адрес вашего DHCP сервера.
Теперь добавим сеть WIFI.
Условие такое, сеть должна быть изолирована, никто кроме клиентов WIFI не должен ее видеть.
Добавляем новый VLAN на ядре
```
coremsk(config)#vlan 400
```
coremsk(config)#vlan 400
```
coremsk(config-vlan)#name wifi
```
coremsk(config-vlan)#name wifi
Настроим шлюз
```
coremsk(config)#interface vlan 400
```
coremsk(config)#interface vlan 400
```
coremsk(config-if)#ip address 192.168.12.1 255.255.255.0
```
coremsk(config-if)#ip address 192.168.12.1 255.255.255.0
```
coremsk(config-if)#no sh
```
coremsk(config-if)#no sh
Теперь добавим коммутатор для WIFI.
Настройте на нем portchannel, VTP ,  и назначьте все клиентские порты на vlan 400
Теперь нам нужно изолировать сеть WIFI.
Данную сеть должны видеть только клиенты сети 192.168.12.0
Для этого на coremsk создадим правило ACL , разрешить сеть 192.168.12.0
```
coremsk(config)#ip access-list extended wifi-net
```
coremsk(config)#ip access-list extended wifi-net
Примечание. Так создаются extended правила, в них можно разрешать не только хосты но и типы трафика и многое другое
Вот пример создания стандартного ACL правила:
```
coremsk(config)#ip access-list standard wifi-net
```
coremsk(config)#ip access-list standard wifi-net
Добавим описание
```
coremsk(config-std-nacl)#remark permit wifi network deny other
```
coremsk(config-std-nacl)#remark permit wifi network deny other
Добавляем разрешающее правило для DHCP, его трафик было бы тоже неплохо разрешить
```
coremsk(config-ext-nacl)#permit udp any any eq 67
```
coremsk(config-ext-nacl)#permit udp any any eq 67
```
coremsk(config-ext-nacl)#permit udp any any eq 68
```
coremsk(config-ext-nacl)#permit udp any any eq 68
Добавим разрешающее правило для сети
```
coremsk(config-ext-nacl)#permit ip 192.168.12.0 0.0.0.255 any
```
coremsk(config-ext-nacl)#permit ip 192.168.12.0 0.0.0.255 any
Обратите внимание, в правиле мы используем обратную маску подсети, тут можно почитать что это такое.
Просмотреть созданные ACL правила можно командой
```
coremsk#show ip access-lists
```
coremsk#show ip access-lists
```
Extended IP access list wifi-net
10 permit udp any any eq bootps
20 permit udp any any eq bootpc
30 permit ip any 192.168.12.0 0.0.0.255
```
Extended IP access list wifi-net10 permit udp any any eq bootps20 permit udp any any eq bootpc30 permit ip any 192.168.12.0 0.0.0.255
Теперь применим правило на VLAN 400
```
coremsk(config)#interface vlan 400
```
coremsk(config)#interface vlan 400
```
coremsk(config-if)#ip access-group wifi-net in
```
coremsk(config-if)#ip access-group wifi-net in
```
coremsk(config-if)#ip access-group wifi-net out
```
coremsk(config-if)#ip access-group wifi-net out
Теперь создадим DHCP pool
```
coremsk(config)#ip dhcp pool vlan400
```
coremsk(config)#ip dhcp pool vlan400
```
coremsk(dhcp-config)#network 192.168.12.0 255.255.255.0
```
coremsk(dhcp-config)#network 192.168.12.0 255.255.255.0
```
coremsk(dhcp-config)#default-router 192.168.12.1
```
coremsk(dhcp-config)#default-router 192.168.12.1
```
coremsk(config)#ip dhcp excluded-address 192.168.12.1
```
coremsk(config)#ip dhcp excluded-address 192.168.12.1
Теперь подключим клиентов wifi сети
Как видите пинги между wifi клиентами идут.
Если сделать пинг между клиентом vlan 101 и клиентом wifi пинг идти не будет.
Теперь наша сеть выглядит вот так:
&nbsp;
В следующей статье мы настроем подключение к ISP провайдеру, рассмотрим настройку динамической маршрутизации и многое другое.
&nbsp;
Related posts:Настройка сети в организации. Часть 1.Настройка прокси сервера Tor на Ubuntu.Установка и настройка Radius сервера на Ubuntu с веб интерфейсом.
 Cisco, Сети 
 Метки: Cisco  
                        
Добавить комментарий Отменить ответВаш адрес email не будет опубликован.Комментарий Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-1890562251101921"
data-ad-slot="9117958896"
data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
  
Все права защищены. IT Traveler 2022 
                            
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
