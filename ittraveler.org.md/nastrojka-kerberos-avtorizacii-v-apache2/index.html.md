# Настройка Kerberos авторизации в Apache2                	  
***Дата: 20.02.2015 Автор Admin***

В данной статье мы рассмотрим настройку автоматической Kerberos авторизации в Apache2. 
Устанавливаем Kerberos
```
apt-get install krb5-user
```
apt-get install krb5-user
Приводим файл /etc/krb5.conf к виду:
```
[logging]
default = FILE:/var/log/krb5libs.log
kdc = FILE:/var/log/krb5kdc.log
admin_server = FILE:/var/log/kadmind.log
[libdefaults]
default_realm = DOMAIN.LOCAL
dns_lookup_realm = false
dns_lookup_kdc = false
ticket_lifetime = 24h
forwardable = yes
[realms]
DOMAIN.LOCAL = {
kdc = pdc.domain.local
kdc = dc.domain.local
admin_server = pdc.domain.local
}
[domain_realm]
.domain.local = DOMAIN.LOCAL
domain.local = DOMAIN.LOCAL
[appdefaults]
pam = {
debug = false
ticket_lifetime = 36000
renew_lifetime = 36000
forwardable = true
krb4_convert = false
}
```
[logging]default = FILE:/var/log/krb5libs.logkdc = FILE:/var/log/krb5kdc.logadmin_server = FILE:/var/log/kadmind.log&nbsp;[libdefaults]default_realm = DOMAIN.LOCALdns_lookup_realm = falsedns_lookup_kdc = falseticket_lifetime = 24hforwardable = yes&nbsp;[realms]DOMAIN.LOCAL = {kdc = pdc.domain.localkdc = dc.domain.localadmin_server = pdc.domain.local}&nbsp;[domain_realm].domain.local = DOMAIN.LOCALdomain.local = DOMAIN.LOCAL&nbsp;[appdefaults]pam = {debug = falseticket_lifetime = 36000renew_lifetime = 36000forwardable = truekrb4_convert = false}
Проверяем что права доступа на файл /etc/krb5.conf &#8212; 644 (чтение всем пользователям)
Проверяем можем ли мы авторизоваться в домене
```
kinit Administrator
```
kinit Administrator
где Administrator учетная запись в AD
Смотрим вывод командой
```
klist
```
klist
Если вывод такой :
```
Ticket cache: FILE:/tmp/krb5cc_1000
Default principal: Administrator@DOMAIN.LOCAL
Valid starting     Expires            Service principal
09/23/11 14:50:50  09/24/11 00:50:51  krbtgt/DOMAIN@DOMAIN.LOCAL
renew until 09/24/11 14:50:50
```
Ticket cache: FILE:/tmp/krb5cc_1000Default principal: Administrator@DOMAIN.LOCAL&nbsp;Valid starting     Expires            Service principal09/23/11 14:50:50  09/24/11 00:50:51  krbtgt/DOMAIN@DOMAIN.LOCALrenew until 09/24/11 14:50:50
То все хорошо.
Создаем в AD учетную запись компьютер с именем домена нашего сайта.
Далее заходим на контроллер домена 2008R2 и создаем Kerberos ключ командой:
```
ktpass -princ HTTP/apachesite01.domain.local@DOMAIN.LOCAL -mapuser apachesite01$@DOMAIN.LOCAL -crypto ALL -ptype KRB5_NT_SRV_HST +rndpass -out c:\apachesite01.keytab
```
ktpass -princ HTTP/apachesite01.domain.local@DOMAIN.LOCAL -mapuser apachesite01$@DOMAIN.LOCAL -crypto ALL -ptype KRB5_NT_SRV_HST +rndpass -out c:\apachesite01.keytab
где apachesite01  имя нашей учетной записи компьютера в AD.
На вопрос «Reset apachesite01’s password [y/n]?» нужно ответить y.
Копируем полученный файл в каталог с apache 2 и назначаем владельцем пользователя и группу www-data (пользователь Apache2) и даем права на чтение всем пользователям.
Устанавливаем модуль Kerberos для Apache 2.
```
apt-get install libapache2-mod-auth-kerb
```
apt-get install libapache2-mod-auth-kerb
Далее открываем .htaccess файл в корне каталога сайта.
и добавляем в него строки :
```
AuthType Kerberos
Krb5KeyTab /etc/apache2/apachesite01.keytab
KrbServiceName HTTP/apachesite01.domain.local@DOMAIN.LOCAL
Require valid-user
```
AuthType KerberosKrb5KeyTab /etc/apache2/apachesite01.keytabKrbServiceName HTTP/apachesite01.domain.local@DOMAIN.LOCALRequire valid-user
В данном примере строка Krb5KeyTab содержит путь к файлу keytab, созданному на контроллере домена.
В данном примере строка KrbServiceName содержит название домена ПК созданного в Active Directory, без этого работать не будет.
Обязательно должно быть создано DNS имя типа A в AD.
