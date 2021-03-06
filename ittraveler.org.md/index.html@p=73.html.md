# Активируем LDAP over SSL                	  
***Дата: 30.12.2014 Автор Admin***

По-умолчанию в Active Directory трафик по протоколу LDAP между контроллерами домена и клиентами не шифруется, т.е. данные по сети передаются в открытом виде. Потенциально это означает, что злоумышленник с помощью снифера пакетов может прочитать эти данные. Для стандартной среды Windows среды это в общем-то не критично, но ограничивает возможности разработчиков сторонних приложений, которые  используют  LDAP.
Так, например, операция смены пароля должна обязательно осуществляться через безопасный канал (например Kerberos или SSL/TLS). Это означает, что например, с помощью функции-php, обеспечивающей работу с AD по протоколу LDAP  изменить пароль пользователя в домене не удастся.
Защитить данные, передаваемых по протоколу LDAP между клиентом и контроллером домена можно с помощью SSL версии протокола LDAP – LDAPS, который работает по порту 636 (LDAP «живет» на порту 389).  Для этого на контроллере домена необходимо установить специальный SSL сертификат. Сертификат может быть как сторонним, выданным 3-ей стороной (например,  Verisign), самоподписанным или выданным корпоративным центром сертификации.
В этой статье мы покажем, как с помощью установки сертификата задействовать  LDAPS (LDAP over Secure Sockets Layer) на котроллере домена под управление Windows Server 2012 R2. При наличии требуемого сертификата служба LDAP на контроллере домена может устанавливать SSL соединения для передачи трафика LDAP и трафика сервера глобального каталога (GC).
Отметим, что LDAPS преимущественно используется сторонними приложениями (имеются в виде не-Microsoft клиенты) в целях защиты передаваемых по сети данных (обеспечить невозможности перехвата имена и паролей пользователей и других приватных данных).
Предположим, в вашей инфраструктуре уже развернут корпоративный удостоверяющий сервер  Certification Authority (CA). Это может быть как полноценная инфраструктура PKI, так и отдельной-стоящий сервер с ролью Certification Authority.
На севере с ролью Certification Authority запустите консоль Certification Authority Management Console, выберите раздел шаблонов сертификатов (Certificate Templates ) и в контекстном меню выберите Manage.
Найдите шаблон Kerberos Authentication certificate и создайте его копию, выбрав в меню Duplicate Template.
На вкладке General переименуйте шаблон сертификата в LDAPoverSSL, укажите период его действия и опубликуйте его в AD (Publish certificate in Active Directory).
На вкладке Request Handling поставьте чекбокс у пункта Allow private key to be exported и сохраните шаблон.
На базе созданного шаблона, опубликуем новый тип сертификата. Для этого, в контекстном меню раздела Certificate Templates выберем пункт New -&gt; Certificate Template to issue.
Из списка доступных шаблонов выберите LDAPoverSSL и нажмите OK.
На контроллере домена, для которого планируется задействовать LDAPS, откройте оснастку управления сертификатами и в хранилище сертификатов Personal запросим новый сертификат  (All Tasks -&gt; Request New Certificate).
В списке доступных сертификатов выберите сертификат LDAPoverSSL и нажмите Enroll (выпустить сертификат).
Следующее требование – необходимо, чтобы контроллер домена и клиенты, которые будут взаимодействовать через  LDAPS доверяли удостоверяющему центру (CA), который выдал сертификат для контроллера домена.
Если это еще не сделано, экспортируем корневой сертификат удостоверяющего центра в файл, выполнив на сервере с ролью Certification Authority команду:
certutil -ca.cert ca_name.cer
Совет. Файл сертификата сохранится в профиле текущего пользователя и в нашем случае имеет имя ca_name.cer.
А затем добавьте экспортированный сертификат в контейнере сертификатов Trusted Root Certification Authorities хранилища сертификатов на клиенте и контроллере домена. Сделать это можно через вручную через оснастку управления сертификатами, через GPO или из командной строки (подробнее здесь).
certmgr.exe -add C:\ca_name.cer -s -r localMachine ROOT
Необходимо перезапустить службы Active Directory на контроллере домена, либо целиком перезагрузить DC.
Осталось протестировать работу по LDAPS. Для этого на клиенте запустим утилиту  ldp.exe и в меню выбираем Connection-&gt; Connect-&gt;Укажите полное (FQDN) имя контроллера домена, выберите порт 636 и отметьте SSL -&gt; OK. Если все сделано правильно, подключение должно установиться.
Примечание. Утилита ldp.exe на клиентах устанавливается в составе пакета Remote Server Administration Kit (RSAT): RSAT для Windows 8, для 8.1.
Источник &#8212; http://winitpro.ru/index.php/2014/10/02/aktiviruem-ldap-over-ssl-ldaps-v-windows-server-2012-r2/
