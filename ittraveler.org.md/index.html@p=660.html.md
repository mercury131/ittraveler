# Обновление Lync 2013 до Skype for Business                	  
***Дата: 28.08.2015 Автор Admin***

Я думаю многие захотели обновиться с Lync 2013 до Skype for Business. Давайте рассмотрим как это сделать.
Первым делом убедитесь что у вас установлены все последние обновления для Lync 2013.
Проверить это можно через Lync Server Update Installer
Убедитесь что у вас установлен &#8212; SQL Server 2012 SP1 или более поздняя версия.
Установите последнюю версию Powershell.
Также установите одно из следующих обновлений (в зависимости на какой ОС установлен Lync)
Windows Server 2008 R2 – KB2533623
Windows Server 2012 – KB2858668
Windows Server 2012 R2 – KB2982006
Далее установите Skype for Business на новый сервер (не на тот где у вас установлен Lync),  но не устанавливайте роли.
Установите средства администрирования.
После установки на новом сервере откройте Topology Builder и выполните обновление пулов Lync до Skype for Business.
Опубликуйте топологию.
Теперь на всех Lync серверах выполняем Powershell команду
PowerShell
```
Stop-CsWindowsService
```
Stop-CsWindowsService
Далее на каждом пуле Lync запускаем команду с инсталяционного диска Skype for Business
```
setup.exe /inplaceupgrade
```
setup.exe /inplaceupgrade
&nbsp;
Дожидаемся окончания установки.
&nbsp;
После окончания установки на серверах lync запускаем команду:
PowerShell
```
Start-CsWindowsService
```
Start-CsWindowsService
Готово! Lync обновлен до Skype for Business!
Удачного обновления =)
&nbsp;
&nbsp;
