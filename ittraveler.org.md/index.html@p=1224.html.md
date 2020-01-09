# Ошибка ERR: CERT_COMMON_NAME_INVALID в Chrome при использовании SSL сертификата.                	  
***Дата: 25.03.2019 Автор Admin***

Недавно столкнулся с проблемой при создании SSL сертификов. Нужно было подписать сертификат на доменном CA для одного хоста, по привычке я воспользовался командой:
```
openssl req -new -newkey rsa:2048 -nodes -keyout SSL.key -out SSL.csr
```
openssl req -new -newkey rsa:2048 -nodes -keyout SSL.key -out SSL.csr
Но после установки сертификатов обнаружил что Chrome, в отличие от других браузеров не принимает такой сертификат. В этой заметке я расскажу в чем проблема и как ее исправить.
Проблема в том что Chrome, начиная в 58 версии игнорирует поле Common Name и из-за этого не доверяет такому сертификату.
Раньше я не замечал эту проблему, т.к. выписывал сертификаты сразу с несколькими DNS Name &#8212; такие сертификаты как раз подходят.
Чтобы создать такой сертификат, нужно создать следующий шаблон в виде текстового файла:
```
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
[ req_distinguished_name ]
countryName                 = Country Name (2 letter code)
stateOrProvinceName         = State or Province Name (full name)
localityName               = Locality Name (eg, city)
organizationName           = Organization Name (eg, company)
commonName                 = Common Name (e.g. server FQDN or YOUR name)
[ req_ext ]
subjectAltName = @alt_names
[alt_names]
DNS.1   = mysrv1.domain.local
DNS.2   = mysrv2.domain.local
DNS.3   = mysrv3.domain.local
```
[ req ]default_bits&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = 2048distinguished_name = req_distinguished_namereq_extensions&nbsp;&nbsp;&nbsp;&nbsp; = req_ext[ req_distinguished_name ]countryName&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = Country Name (2 letter code)stateOrProvinceName&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = State or Province Name (full name)localityName&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = Locality Name (eg, city)organizationName&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = Organization Name (eg, company)commonName&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = Common Name (e.g. server FQDN or YOUR name)[ req_ext ]subjectAltName = @alt_names[alt_names]DNS.1&nbsp;&nbsp; = mysrv1.domain.localDNS.2&nbsp;&nbsp; = mysrv2.domain.localDNS.3&nbsp;&nbsp; = mysrv3.domain.local
Далее выполняем команду для создания приватного ключа и запроса для подписи сертификата в CA
```
openssl req -out sslcert.csr -newkey rsa:2048 -nodes -keyout private.key -config myssl-config.cnf
```
openssl req -out sslcert.csr -newkey rsa:2048 -nodes -keyout private.key -config myssl-config.cnf
Далее как обычно подписываем сертификат (содержимое файла sslcert.csr, шаблон CA &#8212; web server)
Сертификат такого вида подходит для всех браузеров.
