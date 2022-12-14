# Создание шаблонов Zabbix для Windows.                	  
***Дата: 03.07.2015 Автор Admin***

Недавно мне понадобилось мониторить некоторые службы и порты на ОС Windows Server 2012 R2 .
Давайте рассмотрим пример как создать шаблон для мониторинга DNS сервиса на Windows.
Первым делом убедитесь что на ОС Windows установлен и активен Zabbix агент. Без него данный способ работать не будет.
В узлах zabbix, значок агента должен быть зеленым.
Перейдем в раздел Настройка &#8212; Шаблоны 
Нажимаем кнопку  &#171;создать шаблон&#187;
Далее вводим название шаблона и выбираем группу. Нажимаем обновить.
&nbsp;
Переходим в шаблоны и открываем созданный ранее шаблон.
Переходим во вкладку &#171;Группы элементов данных&#187;
Создаем новую группу с именем Active Directory DNS.
Переходим во вкладку &#171;Элементы данных&#187;
Нажимаем кнопку &#171;Создать элемент данных&#187;
Теперь создадим элемент, который будет мониторить службу DNS (системное название службы &#8212; DNS)
В данном случае вводится параметр &#8212; service_state[DNS] , где DNS системное название службы.
Также выбирается ранее созданная группа элементов данных.
Нажимаем кнопку &#171;Добавить&#187;
Теперь создадим элемент, который будет проверять DNS порты.
Параметры должны быть такими:
В данном случае за параметры мониторинга отвечает ключ &#8212; net.tcp.service[dns] , где dns тип сервиса.
Добавляем данный элемент и переходим во вкладку триггеры.
Выбираем &#171;создать триггер&#187;.
Создаем новый триггер для элемента отвечающего за работу службы dns.
В данном случае выражение будет таким &#8212; {Template_Active_Directory_DNS:service_state[DNS].last(0)}&lt;&gt;0
service_state[DNS] &#8212; название проверяемой службы.
Также укажите важность данного триггера.
Теперь создадим триггер для мониторинга доступности порта dns.
Параметры будут такими:
В данном случае в имени триггера указывается переменная &#8212; {HOST.NAME}
Используемое выражение &#8212; {Template_Active_Directory_DNS:net.tcp.service[dns].max(#3)}=0 
Где:
Template_Active_Directory_DNS &#8212; название созданного шаблона
net.tcp.service[dns] &#8212; указывается название элемента данных и проверяемый сервис
На этом создание шаблона завершено, осталось только добавить данный шаблон к узлу сети zabbix.
&nbsp;
Related posts:Установка и настройка веб сервера Apache 2Поиск старых почтовых ящиков в Exchange 2010Создание email рассылки через Powershell
 Active Directory, Linux, Windows, Windows Server 
 Метки: DNS, Ubuntu, Zabbix  
                        
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
