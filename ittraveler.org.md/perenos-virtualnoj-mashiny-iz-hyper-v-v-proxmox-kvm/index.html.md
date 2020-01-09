# Перенос виртуальной машины из Hyper-V в Proxmox (KVM)                	  
***Дата: 01.12.2018 Автор Admin***

В данной статье мы рассмотрим как можно перенести виртуальную машину из Hyper-V в Proxmox (KVM).
Чтобы импортировать Vm из Hyper-V в Proxmox нужно конвертировать ее виртуальный диск.
Делается это в два этапа.
Первый этап это конвертирование диска Hyper-V в формат vhd.
Откройте консоль Hyper-V и выберите пункт &#171;изменить диск&#187;
Далее выберите диск вашей виртуальной машины
Выберите пункт преобразовать
Далее укажите тип &#8212; &#171;виртуальный жесткий диск&#187;
В конце мастера укажите расположение конвертированного диска.
Следующий этап &#8212; это загрузка сконвертированного vhd диска на Proxmox.
Подключитесь по Ssh к proxmox.
Создайте папку на датасторе (это можно сделать на примонтированном датасторе, например если вы используете датастор с ext4 или btrfs)
Далее загрузите в нее диск (например через winscp).
Мой датастор находится по пути /mnt/content/
Я создал следующую папку для диска /mnt/content/images/700/ и скопировал в нее по scp сконвертированный ранее vhd диск.
Теперь нужно запустить конвертацию vhd образа с qcow2.
```
qemu-img convert -f vpc -O qcow2 /mnt/content/images/700/VM.vhd /mnt/content/images/700/ADtest.local.qcow2
```
qemu-img convert -f vpc -O qcow2 /mnt/content/images/700/VM.vhd /mnt/content/images/700/ADtest.local.qcow2
Это довольно долгая операция.
Теперь нужно создать VM и подключить к ней сконвертированный диск qcow2.
Создайте в proxmox виртуальную машину, по характеристикам идентичную вашей изначальной машине в Hyper-V.
При создании VM выберите тип контроллера sata, иначе если будет указан тип Virtio, ваша VM не загрузится.
После создания машины удалите пустой виртуальный диск, который создал Proxmox, он нам не понадобится.
Если в Hyper-V ваша машина была второго поколения, то в Proxmox для созданной ранее машины нужно изменить тип биос на OVMF и добавить EFI диск
Добавленный EFI диск.
Теперь нужно добавить сконвертированный ранее qcow2 диск.
Сделать это можно отредактировав конфиг VM.
В интерфейсе proxmox посмотрите номер VM, в моем случае номер 700
Теперь посмотрите название Вашего датастора, на котором храниться сконвертированный диск qcow2
У меня он называется Backup_Storage
Запомните id машины и название датастора, они нам понадобятся при редактировании конфига.
Подключаемся к Proxmox по ssh и запускаем команду редактирования конфига
```
nano /etc/pve/qemu-server/700.conf
```
nano /etc/pve/qemu-server/700.conf
Конфиг созданной VM следующий:
```
bios: ovmf
boot: cdn
bootdisk: sata0
cores: 1
efidisk0: Backup_Storage:700/vm-700-disk-1.qcow2,size=128K
ide2: none,media=cdrom
memory: 2048
name: ADtest.local
net0: e1000=5A:2D:85:BD:CA:CB,bridge=vmbr0
numa: 0
ostype: win10
scsihw: virtio-scsi-pci
smbios1: uuid=032130f8-58ce-43bb-a6fb-9733671a7306
sockets: 1
```
bios: ovmfboot: cdnbootdisk: sata0cores: 1efidisk0: Backup_Storage:700/vm-700-disk-1.qcow2,size=128Kide2: none,media=cdrommemory: 2048name: ADtest.localnet0: e1000=5A:2D:85:BD:CA:CB,bridge=vmbr0numa: 0ostype: win10scsihw: virtio-scsi-pcismbios1: uuid=032130f8-58ce-43bb-a6fb-9733671a7306sockets: 1
Мы помним что сконвертированный диск называется ADtest.local.qcow2 и расположен на датасторе Backup_Storage, а id нашей машины 700.
Добавим в конфиг следующую строку чтобы подключить диск qcow2
```
sata0: Backup_Storage:700/ADtestlocal.qcow2,size=40G
```
sata0: Backup_Storage:700/ADtestlocal.qcow2,size=40G
Конфиг должен получиться такой:
```
bios: ovmf
boot: cdn
bootdisk: sata0
cores: 1
efidisk0: Backup_Storage:700/vm-700-disk-1.qcow2,size=128K
ide2: none,media=cdrom
memory: 2048
name: ADtest.local
net0: e1000=5A:2D:85:BD:CA:CB,bridge=vmbr0
numa: 0
ostype: win10
sata0: Backup_Storage:700/ADtestlocal.qcow2,size=40G
scsihw: virtio-scsi-pci
smbios1: uuid=032130f8-58ce-43bb-a6fb-9733671a7306
sockets: 1
```
bios: ovmfboot: cdnbootdisk: sata0cores: 1efidisk0: Backup_Storage:700/vm-700-disk-1.qcow2,size=128Kide2: none,media=cdrommemory: 2048name: ADtest.localnet0: e1000=5A:2D:85:BD:CA:CB,bridge=vmbr0numa: 0ostype: win10sata0: Backup_Storage:700/ADtestlocal.qcow2,size=40Gscsihw: virtio-scsi-pcismbios1: uuid=032130f8-58ce-43bb-a6fb-9733671a7306sockets: 1
Сохраните конфиг через CTRL + X
Теперь в Proxmox будет виден диск виртуальной машины
Теперь, чтобы при включении VM нормально загрузилась, нужно изменить ее boot order
Теперь можно включить виртуальную машину и убедиться что она работает.
&nbsp;
