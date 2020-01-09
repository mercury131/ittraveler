# Настройка дисковых квот в Ubuntu                	  
***Дата: 14.10.2015 Автор Admin***

Если вам нужно настроить дисковые квоты для пользователей прошу под кат)
Данная заметка актуальна для Ubuntu 14.04 LTS.
Устанавливаем поддержку квот
```
sudo apt-get install quota
```
sudo apt-get install quota
Далее в файл /etc/fstab , в строку с вашей точкой монтирования прописываем следующие параметры:
```
usrquota,grpquota
```
usrquota,grpquota
Должно получиться примерно так:
```
/dev/sda1 / ext4 errors=remount-ro,usrquota,grpquota 0
```
/dev/sda1 / ext4 errors=remount-ro,usrquota,grpquota 0
Теперь перемонтируем файловую систему
```
sudo mount -o remount /
```
sudo mount -o remount /
Создадим тестового юзера для проверки
```
sudo useradd test -b /home -m -U -s /bin/bash
```
sudo useradd test -b /home -m -U -s /bin/bash
Назначим пароль тестовому пользователю
```
sudo passwd test
```
sudo passwd test
Перезапускаем сервис с квотами для применения изменений
```
/etc/init.d/quota restart
```
/etc/init.d/quota restart
Теперь назначим пользователю квоту
```
edquota -u test
```
edquota -u test
После этого вы попадете в редактор, в котором можно назначить квоты пользователю.
Рассмотрим параметры:
Blocks &#8212; место используемое пользователем в блоках (длинна 1kB)
Inodes &#8212; Число файлов которое пользователь может использовать.
Soft Limit &#8212; Максимальная квота в килобайтах. ( В данном случае пользователь получит предупреждение когда привысит лимит)
Hard Limit &#8212; Максимальная квота в килобайтах. ( В данном случае пользователь получит предупреждение когда привысит лимит и не сможет закачать новые файлы)
Для сохранения нажимаем ctrl X
Льготный период, используемый параметром Soft Limit можно установить командой
```
edquota –t
```
edquota –t
По умолчанию данный период &#8212; 7 дней.
Посмотреть отчет по квотам можно командой
```
repquota -u /
```
repquota -u /
Если во время перезапуска службы квот Вы получили ошибку
quotacheck: Cannot guess format from filename on /dev/mapper/ , где /dev/mapper/ путь к вашему дисковому устройству
Выполните следующую команду
```
quotacheck -F vfsv0 -afcvdugm
```
quotacheck -F vfsv0 -afcvdugm
Это запустит принудительную синхронизацию.
Если Вы используете виртуальный сервер в облаке Amazon EC2 и при перезапуске службы квот получаете ошибку:
quotaon: using //aquota.user on /dev/disk/by-uuid/ [/]: No such process
 quotaon: Quota format not supported in kernel.
Установите пакет linux-image-extra-virtual
```
apt-get install linux-image-extra-virtual
```
apt-get install linux-image-extra-virtual
Это исправит данную проблему.
Удачной настройки =)
