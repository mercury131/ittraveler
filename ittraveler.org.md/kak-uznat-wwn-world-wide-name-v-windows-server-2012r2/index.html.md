# Как узнать WWN (World Wide Name)  в Windows Server 2012R2                	  
***Дата: 24.06.2018 Автор Admin***

Поскольку в Windows Server 2012 R2 нельзя узнать wwn через Storage explorer, я покажу новый, простой способ как это сделать.Откройте консоль PowerShell и выполните команду:
PowerShell
```
Get-InitiatorPort
```
Get-InitiatorPort
В выводе команды  вы увидите WWN FiberChannel адаптеров сервера.
