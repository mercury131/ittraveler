# Принудительная синхронизация Office 365 и локальной Active Directory                	  
***Дата: 30.12.2014 Автор Admin***

Для принудительной синхронизации Office 365 и локальной Active Directory мы будем использовать Powershell.
Открываем Powershell от имени администратора, и вводим следующие команды:
PowerShell
```
Import-Module DirSync
```
Import-Module DirSync
PowerShell
```
Start-OnlineCoexistenceSync
```
Start-OnlineCoexistenceSync
Первая команда импортирует модуль Dirsync
Вторая команда запускает синхронизацию
