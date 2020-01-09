# Изменение Hostname в Ubuntu Server 18.04                	  
***Дата: 24.06.2018 Автор Admin***

В этой статье я расскажу как изменить Hostname в Ubuntu Server 18.04 , т.к эта процедура немного изменилась.Откройте файл /etc/cloud/cloud.cfg командой
```
sudo nano /etc/cloud/cloud.cfg
```
sudo nano /etc/cloud/cloud.cfg
И измените строку С
```
preserve_hostname: false
```
preserve_hostname: false
На
```
preserve_hostname: true
```
preserve_hostname: true
Теперь измените hostname в файле /etc/hosts командой
```
sudo nano /etc/hosts
```
sudo nano /etc/hosts
и в файле /etc/hostname командой
```
sudo nano /etc/hostname
```
sudo nano /etc/hostname
Перезапустите сервер, после этого hostname будет успешно изменен.
