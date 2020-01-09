# Glpi Интеграция с Active Directory.                	  
***Дата: 05.05.2015 Автор Admin***

В данной статье мы рассмотрим интеграцию helpdesk системы GLPI с Active Directory.
Интеграция настраивается в меню  настройки -&gt; Аутентификация-&gt; Каталоги LDAP
Через “Плюс” создаются новые настройки LDAP 
Нажимаем “Плюс” и вводим настройки нашей Active Directory
Наименование &#8212; Domain.local
Сервер DC.Domain.local
Фильтр соединений:
(&amp;(objectclass=user)(objectcategory=person)(!(useraccountcontrol:1.2.840.113556.1.4.803:=2)))
База поиска (baseDN) &#8212; DC=Domain,DC=local
rootDN (пользователь для подключения) &#8212; glpi@Domain.local
Поле имени пользователя – samaccountname
Порт (по умолчанию=389)
Настраиваем пользовательские поля, открываем вкладку “пользователи”
Настраиваем как на скриншоте:
&nbsp;
