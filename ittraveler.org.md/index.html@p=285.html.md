# LVM Добавляем место на диске в виртуальной среде                	  
***Дата: 13.02.2015 Автор Admin***

В данной статье мы рассмотрим как в режиме онлайн добавить свободное место на диске, в виртуальной среде.
1) Добавляем место на диске LVM (делается в вашей системе виртуализации)
2) Обновим информацию о свободном пространстве
Просмотрим iscsi адреса
```
ls /sys/class/scsi_device/
```
ls /sys/class/scsi_device/
Выполним для них rescan
```
echo 1 &gt; /sys/class/scsi_device/0\:0\:0\:0/device/rescan
```
echo 1 &gt; /sys/class/scsi_device/0\:0\:0\:0/device/rescan
3) Открываем parted и создаем новый раздел
```
parted
```
parted
На предупреждение parted вводим Fix
смотрим список разделов
```
print
```
print
Создаем новый раздел
```
mkpart lvmPartition 10GB 100%
```
mkpart lvmPartition 10GB 100%
где 10GB размер последнего раздела
4) Добавляем новый раздел в LVM группы
```
pvcreate /dev/sda3
```
pvcreate /dev/sda3
```
vgextend gr0 /dev/sda3
```
vgextend gr0 /dev/sda3
5) Проверяем свободное пространство в LVM
```
vgdisplay | grep Free
```
vgdisplay | grep Free
6) Добавляем свободное пространство к группе
```
lvextend -L+#G /dev/VolGroup00/LogVol00
```
lvextend -L+#G /dev/VolGroup00/LogVol00
где # размер добавляемого места и /dev/VolGroup00/LogVol00 путь lvm
7) Добавляем размер к существующей файловой системе
```
resize2fs /dev/VolGroup00/LogVol00
```
resize2fs /dev/VolGroup00/LogVol00
Готово!
&nbsp;
Если вы используете LVM с таблицей разделов MBR (например используется в Ubuntu 14.04) то следуйте следующей инструкции:
1) Добавляем место на диске LVM (делается в вашей системе виртуализации)
2) Обновим информацию о свободном пространстве
Просмотрим iscsi адреса
```
ls /sys/class/scsi_device/
```
ls /sys/class/scsi_device/
Выполним для них rescan
```
echo 1 &gt; /sys/class/scsi_device/0\:0\:0\:0/device/rescan
```
echo 1 &gt; /sys/class/scsi_device/0\:0\:0\:0/device/rescan
3) Открываем fdisk и создаем новый раздел
```
fdisk /dev/sda
```
fdisk /dev/sda
где sda ваш диск
Добавляем новые разделы
```
Command (m for help): n
```
Command (m for help): n
```
Partition type: p
```
Partition type: p
```
Partition number (1-4, default 3): 3
```
Partition number (1-4, default 3): 3
```
First sector (499712-52428799, default 499712): 499712
```
First sector (499712-52428799, default 499712): 499712
```
Last sector, +sectors or +size{K,M,G} (499712-501757, default 501757): 501757
```
Last sector, +sectors or +size{K,M,G} (499712-501757, default 501757): 501757
Создаем еще 1 раздел
```
Command (m for help): n
```
Command (m for help): n
```
Partition type: p
```
Partition type: p
```
Selected partition 4
```
Selected partition 4
```
First sector (33552384-52428799, default 33552384): 33552384
```
First sector (33552384-52428799, default 33552384): 33552384
```
Last sector, +sectors or +size{K,M,G} (33552384-52428799, default 52428799): 52428799
```
Last sector, +sectors or +size{K,M,G} (33552384-52428799, default 52428799): 52428799
Сохраняем изменения
```
Command (m for help): w
```
Command (m for help): w
4) Обновляем информацию о разделах в системе:
```
partprobe
```
partprobe
5) Добавляем новый раздел в LVM группы
```
pvcreate /dev/sda4
```
pvcreate /dev/sda4
```
vgextend gr0 /dev/sda4
```
vgextend gr0 /dev/sda4
6) Проверяем свободное пространство в LVM
```
vgdisplay | grep Free
```
vgdisplay | grep Free
7) Добавляем свободное пространство к группе
```
lvextend -L+#G /dev/VolGroup00/LogVol00
```
lvextend -L+#G /dev/VolGroup00/LogVol00
где # размер добавляемого места и /dev/VolGroup00/LogVol00 путь lvm
8) Добавляем размер к существующей файловой системе
```
resize2fs /dev/VolGroup00/LogVol00
```
resize2fs /dev/VolGroup00/LogVol00
Готово!
&nbsp;
