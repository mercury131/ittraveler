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