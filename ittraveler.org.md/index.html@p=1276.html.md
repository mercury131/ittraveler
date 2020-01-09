# QEMU/KVM проброс физического диска гипевизора в виртуальную машину                	  
***Дата: 15.09.2019 Автор Admin***

В этой статье мы рассмотрим как пробросить физический диск в VM.Выполняется эта процедура несколькими командами:
Находим наш диск:
```
lshw -class disk -class storage
```
lshw -class disk -class storage
```
*-disk
description: ATA Disk
product: ST3000DM001-1CH1
vendor: Seagate
physical id: 0.0.0
bus info: scsi@3:0.0.0
logical name: /dev/sda
version: CC27
serial: Z1F41BLC
size: 2794GiB (3TB)
configuration: ansiversion=5 sectorsize=4096
```
*-disk&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;description: ATA Disk&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;product: ST3000DM001-1CH1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vendor: Seagate&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;physical id: 0.0.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;bus info: scsi@3:0.0.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;logical name: /dev/sda&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;version: CC27&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;serial: Z1F41BLC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;size: 2794GiB (3TB)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;configuration: ansiversion=5 sectorsize=4096
Находим путь к диску по id с помощью его serial number
```
ls -l /dev/disk/by-id | grep Z1F41BLC
```
ls -l /dev/disk/by-id | grep Z1F41BLC
Пробрасываем диск в VM с id 592
```
qm set  592  -virtio2 /dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F41BLC
update VM 592: -virtio2 /dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F41BLC
```
qm set&nbsp;&nbsp;592&nbsp;&nbsp;-virtio2 /dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F41BLC&nbsp;update VM 592: -virtio2 /dev/disk/by-id/ata-ST3000DM001-1CH166_Z1F41BLC
Чтобы диск появился, vm необходимо выключить и включить.
