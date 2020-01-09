#                 	Установка и настройка Citrix XenServer Часть 3.                	  
***            ***

			
            
		

    




	
    	  Дата: 26.05.2015 Автор Admin  
	В данной статье мы рассмотрим настройку резервного копирования хостов Xen и запущенных виртуальных машин.
Настроим путь к хранилищу бэкапов.
Открываем консоль хоста через XenCenter.
Создадим папку, куда будет примонтировано хранилище резервных копий.

		
		
			
			
			
```
mkdir /mnt/backup
```
			
				
					
				
					1
				
						mkdir /mnt/backup
					
				
			
		

Подключаем хранилище.

		
		
			
			
			
```
mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
```
			
				
					
				
					1
				
						mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
					
				
			
		

Далее установите Xentools на каждую виртуальную машину.
Теперь подготовим скрипты для бэкапа виртуальных машин использующих vss. (Данный скрипт подходит для бэкапа windows виртуальных машин)
Создаем каталог для файлов скрипта.

		
		
			
			
			
```
mkdir /home/backup
```
			
				
					
				
					1
				
						mkdir /home/backup
					
				
			
		

Переходим в созданный каталог.

		
		
			
			
			
```
cd /home/backup
```
			
				
					
				
					1
				
						cd /home/backup
					
				
			
		

Скачиваем скрипты резервного копирования.

		
		
			
			
			
```
wget www.andy-burton.co.uk/files/xenserver_backup/xenserver_backup.tar.gz
```
			
				
					
				
					1
				
						wget www.andy-burton.co.uk/files/xenserver_backup/xenserver_backup.tar.gz
					
				
			
		

Распаковываем скрипты.

		
		
			
			
			
```
tar -xzf xenserver_backup.tar.gz
```
			
				
					
				
					1
				
						tar -xzf xenserver_backup.tar.gz
					
				
			
		

Назначаем права на файлы скриптов.

		
		
			
			
			
```
chmod 700 vm_backup.*
```
			
				
					
				
					1
				
						chmod 700 vm_backup.*
					
				
			
		

Теперь перейдем к настройке.
Нам нужно отредактировать файл vm_backup.cfg , расположенный в каталоге /home/backup.
Для удобства можно подключиться к серверу через программу winscp, или использовать консольный редактор vi.
Открываем файл через vi и редактируем.

		
		
			
			
			
```
vi /home/backup/vm_backup.cfg
```
			
				
					
				
					1
				
						vi /home/backup/vm_backup.cfg
					
				
			
		

Теперь рассмотрим параметры конфига.
Секция где указывается путь к логам:

		
		
			
			
			
```
# Set log path

log_path="/home/backup/vm_backup.log"
```
			
				
					
				
					123
				
						# Set log path&nbsp;log_path="/home/backup/vm_backup.log"
					
				
			
		

Включение/отключение логирования.

		
		
			
			
			
```
# Enable logging
# Remove to disable logging

log_enable
```
			
				
					
				
					1234
				
						# Enable logging# Remove to disable logging&nbsp;log_enable
					
				
			
		

Путь к хранилищу резервных копий.

		
		
			
			
			
```
# Local backup directory
# You can link this to a Windows CIFS share using the blog article

backup_dir="/mnt/backup"
```
			
				
					
				
					1234
				
						# Local backup directory# You can link this to a Windows CIFS share using the blog article&nbsp;backup_dir="/mnt/backup"
					
				
			
		

Формат резервной копии (рекомендуется не изменять!)

		
		
			
			
			
```
# Backup extension
# .xva is the default Citrix template/vm extension

backup_ext=".xva"
```
			
				
					
				
					1234
				
						# Backup extension# .xva is the default Citrix template/vm extension&nbsp;backup_ext=".xva"
					
				
			
		

Какие виртуальные машины бэкапить.

		
		
			
			
			
```
# Which VMs to backup. Possible values are:
# "all" - Backup all VMs
# "running" - Backup all running VMs
# "list" - Backup all VMs in the backup list (see below)
# "none" - Don't backup any VMs, this is the default

backup_vms="all"
```
			
				
					
				
					1234567
				
						# Which VMs to backup. Possible values are:# "all" - Backup all VMs# "running" - Backup all running VMs# "list" - Backup all VMs in the backup list (see below)# "none" - Don't backup any VMs, this is the default&nbsp;backup_vms="all"
					
				
			
		

Список виртуальных машин, которые нужно бэкапить (индивидуальный список)

		
		
			
			
			
```
# VM backup list
# Only VMs in this list will be backed up when backup_ext="list"
# You can add VMs to the list using: add_to_backup_list "uuid"

# Example:
# add_to_backup_list "2844954f-966d-3ff4-250b-638249b66313"
```
			
				
					
				
					123456
				
						# VM backup list# Only VMs in this list will be backed up when backup_ext="list"# You can add VMs to the list using: add_to_backup_list "uuid"&nbsp;# Example:# add_to_backup_list "2844954f-966d-3ff4-250b-638249b66313"
					
				
			
		

Формат даты в файле резервной копии.

		
		
			
			
			
```
# Current Date
# This is appended to the backup file name and the format can be changed here
# Default format: YYYY-MM-DD_HH-MM-SS

date=$(date +%Y-%m-%d_%H-%M-%S)
```
			
				
					
				
					12345
				
						# Current Date# This is appended to the backup file name and the format can be changed here# Default format: YYYY-MM-DD_HH-MM-SS&nbsp;date=$(date +%Y-%m-%d_%H-%M-%S)
					
				
			
		

После настройки конфига, запустим скрипт резервного копирования.

		
		
			
			
			
```
vm_backup.sh
```
			
				
					
				
					1
				
						vm_backup.sh
					
				
			
		

После этого вы увидите бэкапы виртуальных машин в формате .xva на вашем хранилище. Данный способ подходит только для Windows подобных виртуальных машин.
Автоматизируем данный скрипт.
Чтобы каждый раз не подключать хранилище вручную добавим в файл vm_backup.sh следующую строку в начале файла, под #!/bin/bash.

		
		
			
			
			
```
mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
```
			
				
					
				
					1
				
						mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
					
				
			
		

Должно получится так:
&nbsp;

		
		
			
			
			
```
#!/bin/bash

mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
```
			
				
					
				
					123
				
						#!/bin/bash&nbsp;mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
					
				
			
		

Теперь добавим следующую строку в самый конец файла.

		
		
			
			
			
```
umount /mnt/backup
```
			
				
					
				
					1
				
						umount /mnt/backup
					
				
			
		

Должно получится так:

		
		
			
			
			
```
if [ $vm_log_enabled ]; then
	log_disable
fi


umount /mnt/backup
```
			
				
					
				
					123456
				
						if [ $vm_log_enabled ]; then	log_disablefi&nbsp;&nbsp;umount /mnt/backup
					
				
			
		

Теперь отмонтируем наше хранилище.

		
		
			
			
			
```
umount /mnt/backup
```
			
				
					
				
					1
				
						umount /mnt/backup
					
				
			
		

Теперь составим расписание резервного копирования. Тут нам поможет планировщик заданий Cron.
Открываем консоль хоста xen1 и вводим команду:

		
		
			
			
			
```
crontab -e
```
			
				
					
				
					1
				
						crontab -e
					
				
			
		

Откроется редактор vi, в нем нужно ввести расписание и выполняемую команду.
Рассмотрим примеры расписания Cron:
Задание Cron выглядит как строка

		
		
			
			
			
```
поле1 поле2 поле3 поле4 поле5 команда
```
			
				
					
				
					1
				
						поле1 поле2 поле3 поле4 поле5 команда
					
				
			
		

Значения первых пяти полей:
минуты — число от 0 до 59
часы — число от 0 до 23
день месяца — число от 1 до 31
номер месяца в году — число от 1 до 12
день недели — число от 0 до 7 (0-Вс,1-Пн,2-Вт,3-Ср,4-Чт,5-Пт,6-Сб,7-Вс)
Примеры расписания:
# выполнять резервное копирование раз в час в 0 минут

		
		
			
			
			
```
0 */1 * * * /home/backup/vm_backup.sh
```
			
				
					
				
					1
				
						0 */1 * * * /home/backup/vm_backup.sh
					
				
			
		

# выполнять резервное копирование каждые три часа в 0 минут

		
		
			
			
			
```
0 */3 * * * /home/backup/vm_backup.sh
```
			
				
					
				
					1
				
						0 */3 * * * /home/backup/vm_backup.sh
					
				
			
		

# выполнять резервное копирование по понедельникам в 1 час 15 минут ночи

		
		
			
			
			
```
15 1 * * 1 /home/backup/vm_backup.sh
```
			
				
					
				
					1
				
						15 1 * * 1 /home/backup/vm_backup.sh
					
				
			
		

# выполнять резервное копирование 5 апреля в 0 часов 1 минуту каждый год

		
		
			
			
			
```
1 0 5 4 * /home/backup/vm_backup.sh
```
			
				
					
				
					1
				
						1 0 5 4 * /home/backup/vm_backup.sh
					
				
			
		

# выполнять резервное копирование в пятницу 13 числа в 13 часов 13 минут

		
		
			
			
			
```
13 13 13 * 5 /home/backup/vm_backup.sh
```
			
				
					
				
					1
				
						13 13 13 * 5 /home/backup/vm_backup.sh
					
				
			
		

# выполнять резервное копирование ежемесячно 1 числа в 6 часов 10 минут

		
		
			
			
			
```
10 6 1 * * /home/backup/vm_backup.sh
```
			
				
					
				
					1
				
						10 6 1 * * /home/backup/vm_backup.sh
					
				
			
		

Мы будем выполнять резервное копирование каждый день в 23:00

		
		
			
			
			
```
00 23 * * * /home/backup/vm_backup.sh
```
			
				
					
				
					1
				
						00 23 * * * /home/backup/vm_backup.sh
					
				
			
		

Для редактирования в VI нажмите A, далее введите строку задания Cron и нажмите Enter, чтобы следующая строка была пустая.
Чтобы Cron корректно сохранил задание последняя строка всегда должна быть пустая.
Для сохранения изменений в Cron нажмите Esc а затем 2 раза z. Теперь Cron задание сохранено.
Мы рассмотрели резервное копирование для Windows подобных VM. Теперь рассмотрим скрипт резервного копирования, который подходит для все типов гостевых ОС.
Создадим новый файл.

		
		
			
			
			
```
touch /home/backup/backupall
```
			
				
					
				
					1
				
						touch /home/backup/backupall
					
				
			
		

Настроим права.

		
		
			
			
			
```
chmod 700 /home/backup/backupall
```
			
				
					
				
					1
				
						chmod 700 /home/backup/backupall
					
				
			
		

Теперь подключитесь к хосту через Winscp, откройте файл /home/backup/backupall.
Вставьте в файл следующее содержимое:

		
		
			
			
			
```
#! /bin/bash
set -e # exit on any error
mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup


RUNNINGVMS=`xe vm-list is-control-domain=false power-state=running | grep name | awk 'BEGIN { FS = ":" };{ print $2 }'`

for i in $RUNNINGVMS;
do SNAPSHOTUUID=`xe vm-snapshot vm=$i new-name-label=Backup-$i`;
xe template-param-set is-a-template=false uuid=$SNAPSHOTUUID;

xe vm-export uuid=$SNAPSHOTUUID filename=/mnt/backup/backup-$i-$(date +%Y-%m-%d).xva;


xe vm-uninstall uuid=$SNAPSHOTUUID force=true;
done;


HALTEDVMS=`xe vm-list power-state=halted | grep name | awk 'BEGIN { FS = ":" };{ print $2 }'`
for j in $HALTEDVMS;
	do xe vm-export vm=$j filename=/backupfolder/backup-$j-$(date +%Y-%m-%d).xva;
done;


umount /mnt/backup
```
			
				
					
				
					12345678910111213141516171819202122232425
				
						#! /bin/bashset -e # exit on any errormount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup&nbsp;&nbsp;RUNNINGVMS=`xe vm-list is-control-domain=false power-state=running | grep name | awk 'BEGIN { FS = ":" };{ print $2 }'`&nbsp;for i in $RUNNINGVMS;do SNAPSHOTUUID=`xe vm-snapshot vm=$i new-name-label=Backup-$i`;xe template-param-set is-a-template=false uuid=$SNAPSHOTUUID;&nbsp;xe vm-export uuid=$SNAPSHOTUUID filename=/mnt/backup/backup-$i-$(date +%Y-%m-%d).xva;&nbsp;&nbsp;xe vm-uninstall uuid=$SNAPSHOTUUID force=true;done;&nbsp;&nbsp;HALTEDVMS=`xe vm-list power-state=halted | grep name | awk 'BEGIN { FS = ":" };{ print $2 }'`for j in $HALTEDVMS;	do xe vm-export vm=$j filename=/backupfolder/backup-$j-$(date +%Y-%m-%d).xva;done;&nbsp;&nbsp;umount /mnt/backup
					
				
			
		

Сохраните файл.
В строке :

		
		
			
			
			
```
mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
```
			
				
					
				
					1
				
						mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
					
				
			
		

Вводится подключение к бэкап хранилищу.
Данный скрипт экспортирует запущенные VM и выключенные VM.
Внимание! Имена виртуальных машин не должны содержать пробелы! Иначе скрипт работать не будет.
Запустите скрипт. После выполнения скрипта, на хранилище появятся новые файлы с расширением .xva
Теперь добавим данный скрипт в Cron, строка в Cron должна выглядеть так:

		
		
			
			
			
```
30 23 * * * /home/backup/backupall
```
			
				
					
				
					1
				
						30 23 * * * /home/backup/backupall
					
				
			
		

Данный скрипт будет запускаться в 23:30
Данный скрипт может быть запущен на пул мастере, при этом резервные копии будут делаться для всех серверов в пуле Xen.
Теперь рассмотрим резервное копирование конфигурации Xen хоста.
Тут нам нужна команда:

		
		
			
			
			
```
xe host-backup host=xen1 file-name=/mnt/backup/Xen1-$(date +%Y-%m-%d).xbk
```
			
				
					
				
					1
				
						xe host-backup host=xen1 file-name=/mnt/backup/Xen1-$(date +%Y-%m-%d).xbk
					
				
			
		

Где xen1 имя хоста, а Xen1-$(date +%Y-%m-%d).xbk имя файла резервной копии.
Автоматизируем данную задачу.
Создадим новый скрипт:

		
		
			
			
			
```
touch /home/backup/hostbackup
```
			
				
					
				
					1
				
						touch /home/backup/hostbackup
					
				
			
		

Настраиваем права:

		
		
			
			
			
```
chmod 700 /home/backup/hostbackup
```
			
				
					
				
					1
				
						chmod 700 /home/backup/hostbackup
					
				
			
		

Добавляем в файл следующее содержимое:

		
		
			
			
			
```
#!/bin/bash

xenhost=xen1

mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup

xe host-backup host=$xenhost file-name=/mnt/backup/$xenhost-$(date +%Y-%m-%d).xbk


umount /mnt/backup
```
			
				
					
				
					12345678910
				
						#!/bin/bash&nbsp;xenhost=xen1&nbsp;mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup&nbsp;xe host-backup host=$xenhost file-name=/mnt/backup/$xenhost-$(date +%Y-%m-%d).xbk&nbsp;&nbsp;umount /mnt/backup
					
				
			
		

В переменную xenhost указывается имя хоста Xen.
Добавим строку в задание Cron:

		
		
			
			
			
```
00 01 * * * /home/backup/hostbackup
```
			
				
					
				
					1
				
						00 01 * * * /home/backup/hostbackup
					
				
			
		

Конфигурация хоста будет сохраняться в час ночи, каждый день.
Теперь рассмотрим восстановление виртуальных машин.
Открываем консоль XenCenter и выбираем &#171;Import&#187;
Выбираем файл резервной копии.
Выбираем сервер на который будет восстановлена VM.
Указываем хранилище.
Выбираем сеть.
Проверяем параметры и импортируем VM.
После этого восстановленная VM появится в списке.
На этом настройка резервного копирования закончена. Разумеется коммерческие решения удобнее и проще чем скрипты. Но скрипты бесплатны =)
В следующей статье мы рассмотрим настройку локальных хранилищ на хостах Xen.
Будет рассмотрено создание LVM, EXT и ISO хранилищ.
&nbsp;
&nbsp;
