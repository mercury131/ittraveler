# Как работать с LVM                	  
***Дата: 15.09.2019 Автор Admin***

В этой статье рассмотрим как работать с LVM, а именно как создать/расширить/удалить LVM.
Чтобы создать LVM необходимо подготовить physical volumes, который состоит из физических дисков, на которых и будет располагаться Volume Group LVM.
Создаем physical volumes на 3-х дисках:
```
pvcreate /dev/sdb /dev/sdc /dev/sdd
```
pvcreate /dev/sdb /dev/sdc /dev/sdd
Посмотреть список physical volumes можно командой:
```
pvs
```
pvs
также можно более детально посмотреть информацию о диске
```
pvdisplay /dev/sdX
```
pvdisplay /dev/sdX
Теперь эти диски можно добавить в Volume Group, на котором будет создаваться LVM.
Создадим Volume Group из двух дисков:
```
vgcreate vg00 /dev/sdb /dev/sdc
```
vgcreate vg00 /dev/sdb /dev/sdc
Посмотреть информацию о VG можно командой:
```
vgdisplay vg00
```
vgdisplay vg00
Теперь все готово к созданию LVM, создадим 2 раздела, первый на 10 GB
```
lvcreate -n vol_projects -L 10G vg00
```
lvcreate -n vol_projects -L 10G vg00
Второй будет размером равным оставшемуся месту
```
lvcreate -n vol_backups -l 100%FREE vg00
```
lvcreate -n vol_backups -l 100%FREE vg00
Посмотреть список LVM можно командой:
```
lvs
```
lvs
Либо более подробно о конкретном разделе
```
lvdisplay vg00/vol_projects
```
lvdisplay vg00/vol_projects
Теперь можно создать файловую систему на этих разделах
```
# mkfs.ext4 /dev/vg00/vol_projects
# mkfs.ext4 /dev/vg00/vol_backups
```
# mkfs.ext4 /dev/vg00/vol_projects# mkfs.ext4 /dev/vg00/vol_backups
Теперь рассмотрим как можно менять размер LVM разделов.
Уменьшим размер раздела vol_projects
```
lvreduce -L -2.5G -r /dev/vg00/vol_projects
```
lvreduce -L -2.5G -r /dev/vg00/vol_projects
И увеличим раздел vol_backups
```
lvextend -l +100%FREE -r /dev/vg00/vol_backups
```
lvextend -l +100%FREE -r /dev/vg00/vol_backups
Также нужно выполнить команду resize2fs , для применения изменений в файловой системе.
Теперь рассмотрим как добавить диск в VG.
Добавляем свободный диск в VG
```
vgextend vg00 /dev/sdd
```
vgextend vg00 /dev/sdd
Командой
```
vgdisplay vg00
```
vgdisplay vg00
можно убедиться что диск добавлен в VG
Соответственно для удаления PV используется команда
```
pvremove
```
pvremove
Для удаления LVM
```
lvremove
```
lvremove
Для удаления VG
```
vgremove
```
vgremove
Соответственно если вы хотите удалить все, то нужно удалить LVM, потом VG, потом PV.
Теперь рассмотрим как создать &#171;тонкий&#187; LVM.
В примере ниже я создам LVM на 100 MB и внутри него тонкий LVM на 1 GB.
```
lvcreate -L 100M -T vg001/mythinpool
```
lvcreate -L 100M -T vg001/mythinpool
```
lvcreate -V1G -T vg001/mythinpool -n thinvolume
```
lvcreate -V1G -T vg001/mythinpool -n thinvolume
&nbsp;
