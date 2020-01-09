# Windows WSL подключение к сетевым шарам                	  
***Дата: 15.09.2019 Автор Admin***

При использовании Ubuntu через WSL на Windows, столкнулся с тем что подключенные сетевые шары недоступны и отсутствуют в /mnt.
В этой статье я покажу как просто подключать сетевые шары в WSL.Для начала о том как можно активировать WSL:
https://docs.microsoft.com/ru-ru/windows/wsl/install-win10
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux
Чтобы подключить сетевую шару, необходимо выполнить две команды:
Создать каталог для монтирования
```
sudo mkdir /mnt/share
```
sudo mkdir /mnt/share
примонтировать сетевую шару
```
sudo mount -t drvfs '\\server\share' /mnt/share
```
sudo mount -t drvfs '\\server\share' /mnt/share
Соответственно подключение сработает, если у вашей Windows учетной записи есть необходимые права на сетевую шару.
