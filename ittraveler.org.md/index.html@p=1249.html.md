# Ошибка Database Mirroring login attempt by user ‘Domain\user.’ failed with error: ‘Connection handshake failed. при настройке AlwaysON                	  
***Дата: 12.06.2019 Автор Admin***

Иногда при настройке AlwaysOn может возникать ошибка &#8212; Database Mirroring login attempt by user ‘Domain\user.’ failed with error: ‘Connection handshake failed. 
В этой статье мы рассмотрим как можно ее исправить.
&nbsp;
Данная ошибка может возникать из-за нехватки прав на CONNECT ON ENDPOINT , чтобы это исправить выполните следующий SQL запрос:
```
GRANT CONNECT ON ENDPOINT::hadr_endpoint TO [Domain\user]
GO
```
GRANT CONNECT ON ENDPOINT::hadr_endpoint TO [Domain\user]&nbsp;GO
После этого AlwaysOn группа должна успешно собраться.
Также данная проблема может воспроизводиться если одна из но SQL сервера использует не доменную сервисную учетную запись.
