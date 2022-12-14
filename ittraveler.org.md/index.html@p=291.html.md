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
Related posts:Сброс пароля компьютера в домене без перезагрузкиПеренос базы данных Active DirectoryМониторинг срока действия сертификатов Lets Encrypt
 Active Directory, Web, Web/Cloud 
 Метки: Apache2, Kerberos  
                        
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
