# Назначение служб для сертификатов Exchange через Powershell.                	  
***Дата: 12.03.2015 Автор Admin***

В данной статье я расскажу как назначить службы сертификату Exchange через Powershell.Первое что мы сделаем, это выведем список текущих сертификатов
```
Get-ExchangeCertificate
```
Get-ExchangeCertificate
В данном списке найдите сертификат которому вы будете назначать службу, и скопируйте его значение Thumbprint.
Теперь назначим службу выбранному сертификату
```
Enable-ExchangeCertificate -Server 'ExchangeServer' -Services 'SMTP' -Thumbprint 'EDF57B5F9D81F1EC329BFB77ADD4465B426A40FB'
```
Enable-ExchangeCertificate -Server 'ExchangeServer' -Services 'SMTP' -Thumbprint 'EDF57B5F9D81F1EC329BFB77ADD4465B426A40FB'
Так же можно назначить сертификат на все службы
```
Enable-ExchangeCertificate -Server 'EXCH-H-868' -Services 'IMAP, POP, IIS, SMTP' -Thumbprint 'EDF57B5F9D81F1EC329BFB77ADD4465B426A40FB'
```
Enable-ExchangeCertificate -Server 'EXCH-H-868' -Services 'IMAP, POP, IIS, SMTP' -Thumbprint 'EDF57B5F9D81F1EC329BFB77ADD4465B426A40FB'
