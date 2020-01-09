# LVM переезд с диска на диск в виртуальной среде.                	  
***Дата: 13.02.2015 Автор Admin***

В данной статье я расскажу как в виртуальной среде переехать с диска на диск с помощью LVM
1) Добавляем новый диск
2) Обновляем информацию в системе о новых дисках
```
ls  /sys/class/scsi_host/
```
ls  /sys/class/scsi_host/
```
echo "- - -" &gt; /sys/class/scsi_host/host0/scan
```
echo "- - -" &gt; /sys/class/scsi_host/host0/scan
где host0 подставляется из вывода команды &#8212; ls  /sys/class/scsi_host/
3) Открываем parted
```
parted /dev/sdb
```
parted /dev/sdb
где /dev/sdb наш новый диск
Создаем GPT записи
```
mklabel gpt
```
mklabel gpt
Создаем Boot раздел и устанавливаем флаги для Grub2
```
mkpart bbp 1MB 2MB
```
mkpart bbp 1MB 2MB
```
set 1 bios_grub on
```
set 1 bios_grub on
Создаем раздел для LVM
```
mkpart lvmPartition 2MB 100%
```
mkpart lvmPartition 2MB 100%
4) Добавляем раздел к физической и логической группе LVM
```
pvcreate /dev/sdb2
```
pvcreate /dev/sdb2
```
vgextend gr0 /dev/sdb2
```
vgextend gr0 /dev/sdb2
5) Переносим данные со старого раздела на новый
```
pvmove /dev/sda1 /dev/sdb2
```
pvmove /dev/sda1 /dev/sdb2
6) Удаляем старый диск из группы
```
vgreduce gr0 /dev/sda1
```
vgreduce gr0 /dev/sda1
```
pvremove /dev/sda1
```
pvremove /dev/sda1
7) Переустанавливаем Grub2 на новый раздел
```
grub-install /dev/sdb
```
grub-install /dev/sdb
Готово! Теперь можно удалить старый диск, и загрузится с нового.
