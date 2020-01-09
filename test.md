# ZFS перенос корневого пула с ОС на новый диск, меньшего размера.                	  
**   Дата: 15.09.2019 Автор Admin   **  
Понадобилось перенести ос, расположенную на zfs, на новый SSD диск меньшего размера. В этой статье я расскажу как это сделать.Обычно проблем с переносом нет, если оба диска имеют одинаковый размер, просто создаем в ZFS Raid1, ждем синхронизации данных и потом удаляем старый диск, но т.к в моем случае диск меньше (SSD 360 GB против HDD 500GB) , то сделать зеркало не получится.
Итак, вот последовательность действий, которая позволит перенести ОС на ZFS на меньший диск, при условии что данные на него поместятся.
Итак, первым делом, с помощью fdisk создаем boot и efi разделы аналогичного размера как на исходном диске.
Далее с помощью dd переносим эти разделы на новый диск.
Создаем третий раздел под новый ZFS пул.
Создаем ZFS пул, куда мы будем переносить ОС, в моем случае пул называется rpoolssd.
Далее создаем снапшот оригинального пула
```
zfs snapshot -r rpool@today1
```
1
zfs snapshot -r rpool@today1
Переносим снапшот на новый пул
```
zfs send -R rpool@today1 |pv| zfs receive -F rpoolssd
```
1
zfs send -R rpool@today1 |pv| zfs receive -F rpoolssd
откатываемся на снапшот
```
zfs rollback rpoolssd@today1
```
1
zfs rollback rpoolssd@today1
Монтируем новый пул и выполняем chroot
```
zfs set mountpoint=/test rpoolssd/ROOT/pve-1
zfs mount rpoolssd/ROOT/pve-1
cd /test
$ mount --bind /dev dev
$ mount --bind /proc proc
$ mount --bind /sys sys
$ mount --bind /run run
$ chroot .
```
12345678
zfs set mountpoint=/test rpoolssd/ROOT/pve-1zfs mount rpoolssd/ROOT/pve-1cd /test$ mount --bind /dev dev$ mount --bind /proc proc$ mount --bind /sys sys$ mount --bind /run run$ chroot .
Далее редактируем grub, указываем новый пул как загрузочный
делаем
```
update-grub
```
1
update-grub
Выходим из chroot
```
exit
```
1
exit
Отмонтируем разделы и изменим точку монтирования / на новый zfs пул
```
umount /test/dev
umount /test/proc
umount /test/sys
umount /test/run
zfs umount rpoolssd/ROOT/pve-1
zfs set mountpoint=/ rpoolssd/ROOT/pve-1
```
123456
umount /test/devumount /test/procumount /test/sysumount /test/runzfs umount rpoolssd/ROOT/pve-1zfs set mountpoint=/ rpoolssd/ROOT/pve-1
Перезагружаемся, grub запуститься со старого диска, в загрузочном меню нажимаем e и редактируем строку с указанием zfs пула , указываем новый пул.
Загружаемся в ос на новом диске.
Выполняем
```
install-grub
```
1
install-grub
на новый диск, на новом пуле.
перезагружаемся, отключаем старый диск.
