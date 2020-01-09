# Настраиваем SFTP chroot на OpenSSH.                	  
***Дата: 24.04.2017 Автор Admin***

Иногда нужно ограничить пользователя правами только на подключение по SFTP , без возможности выполнения команд на сервере.
Давайте рассмотрим как это сделать.
Первое, убедитесь что у вас версия openssh не ниже OpenSSH 4.9+
На Ubuntu это можно сделать следующей командой:
```
dpkg -s openssh-server | grep Version
```
dpkg -s openssh-server | grep Version
Теперь создаем новую группу, в которую должны входить пользователи которым необходим доступ только по SFTP
```
groupadd sftponly
```
groupadd sftponly
Далее открываем конфиг openssh (/etc/ssh/sshd_config) и вносим в него следующие параметры:
```
Match Group sftponly
ChrootDirectory %h
ForceCommand internal-sftp
AllowTcpForwarding no
PermitTunnel no
X11Forwarding no
```
Match Group sftponly&nbsp;&nbsp;ChrootDirectory %h&nbsp;&nbsp;ForceCommand internal-sftp&nbsp;&nbsp;AllowTcpForwarding no&nbsp;&nbsp;PermitTunnel no&nbsp;&nbsp;X11Forwarding no
Этими настройками мы указываем настройки chroot для этой группы.
Перезапускаем службу openssh для применения изменений
```
service ssh restart
```
service ssh restart
Теперь добавляем пользователя (например USER) в группу
```
gpasswd -a USER sftponly
```
gpasswd -a USER sftponly
Далее установим владельцем chroot каталога пользователя пользователя root
```
chown root:root /home/user
```
chown root:root /home/user
Отключаем пользователю возможность использовать Shell
```
usermod -s /bin/false user
```
usermod -s /bin/false user
Теперь при подключении пользователю USER будет доступен только доступ по SFTP, выполнять команды на сервере пользователь не сможет.
Чтобы немного сэкономить время, можно вот так добавлять новых пользователей
```
usermod -g sftponly username
```
usermod -g sftponly username
```
usermod -s /bin/false username
```
usermod -s /bin/false username
Вот и все, удачной вам настройки!
