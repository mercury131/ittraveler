#                 	Установка и настройка Citrix XenServer Часть 3.                	  
***            ***

			
            
		

    




	
    	  Дата: 26.05.2015 Автор Admin  
	В данной статье мы рассмотрим настройку резервного копирования хостов Xen и запущенных виртуальных машин.
Настроим путь к хранилищу бэкапов.
Открываем консоль хоста через XenCenter.
Создадим папку, куда будет примонтировано хранилище резервных копий.
mkdir /mnt/backup
Подключаем хранилище.
mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
Далее установите Xentools на каждую виртуальную машину.
Теперь подготовим скрипты для бэкапа виртуальных машин использующих vss. (Данный скрипт подходит для бэкапа windows виртуальных машин)
Создаем каталог для файлов скрипта.
mkdir /home/backup
Переходим в созданный каталог.
cd /home/backup
Скачиваем скрипты резервного копирования.
wget www.andy-burton.co.uk/files/xenserver_backup/xenserver_backup.tar.gz
Распаковываем скрипты.
tar -xzf xenserver_backup.tar.gz
Назначаем права на файлы скриптов.
chmod 700 vm_backup.*
Теперь перейдем к настройке.
Нам нужно отредактировать файл vm_backup.cfg , расположенный в каталоге /home/backup.
Для удобства можно подключиться к серверу через программу winscp, или использовать консольный редактор vi.
Открываем файл через vi и редактируем.
vi /home/backup/vm_backup.cfg
Теперь рассмотрим параметры конфига.
Секция где указывается путь к логам:
# Set log path

log_path="/home/backup/vm_backup.log"
Включение/отключение логирования.
# Enable logging
# Remove to disable logging

log_enable
Путь к хранилищу резервных копий.
# Local backup directory
# You can link this to a Windows CIFS share using the blog article

backup_dir="/mnt/backup"
Формат резервной копии (рекомендуется не изменять!)
# Backup extension
# .xva is the default Citrix template/vm extension

backup_ext=".xva"
Какие виртуальные машины бэкапить.
# Which VMs to backup. Possible values are:
# "all" - Backup all VMs
# "running" - Backup all running VMs
# "list" - Backup all VMs in the backup list (see below)
# "none" - Don't backup any VMs, this is the default

backup_vms="all"
Список виртуальных машин, которые нужно бэкапить (индивидуальный список)
# VM backup list
# Only VMs in this list will be backed up when backup_ext="list"
# You can add VMs to the list using: add_to_backup_list "uuid"

# Example:
# add_to_backup_list "2844954f-966d-3ff4-250b-638249b66313"
Формат даты в файле резервной копии.
# Current Date
# This is appended to the backup file name and the format can be changed here
# Default format: YYYY-MM-DD_HH-MM-SS

date=$(date +%Y-%m-%d_%H-%M-%S)
После настройки конфига, запустим скрипт резервного копирования.
vm_backup.sh
После этого вы увидите бэкапы виртуальных машин в формате .xva на вашем хранилище. Данный способ подходит только для Windows подобных виртуальных машин.
Автоматизируем данный скрипт.
Чтобы каждый раз не подключать хранилище вручную добавим в файл vm_backup.sh следующую строку в начале файла, под #!/bin/bash.
mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
Должно получится так:
&nbsp;
#!/bin/bash

mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
Теперь добавим следующую строку в самый конец файла.
umount /mnt/backup
Должно получится так:
if [ $vm_log_enabled ]; then
	log_disable
fi


umount /mnt/backup
Теперь отмонтируем наше хранилище.
umount /mnt/backup
Теперь составим расписание резервного копирования. Тут нам поможет планировщик заданий Cron.
Открываем консоль хоста xen1 и вводим команду:
crontab -e
Откроется редактор vi, в нем нужно ввести расписание и выполняемую команду.
Рассмотрим примеры расписания Cron:
Задание Cron выглядит как строка
поле1 поле2 поле3 поле4 поле5 команда
Значения первых пяти полей:
минуты — число от 0 до 59
часы — число от 0 до 23
день месяца — число от 1 до 31
номер месяца в году — число от 1 до 12
день недели — число от 0 до 7 (0-Вс,1-Пн,2-Вт,3-Ср,4-Чт,5-Пт,6-Сб,7-Вс)
Примеры расписания:
# выполнять резервное копирование раз в час в 0 минут
0 */1 * * * /home/backup/vm_backup.sh
# выполнять резервное копирование каждые три часа в 0 минут
0 */3 * * * /home/backup/vm_backup.sh
# выполнять резервное копирование по понедельникам в 1 час 15 минут ночи
15 1 * * 1 /home/backup/vm_backup.sh
# выполнять резервное копирование 5 апреля в 0 часов 1 минуту каждый год
1 0 5 4 * /home/backup/vm_backup.sh
# выполнять резервное копирование в пятницу 13 числа в 13 часов 13 минут
13 13 13 * 5 /home/backup/vm_backup.sh
# выполнять резервное копирование ежемесячно 1 числа в 6 часов 10 минут
10 6 1 * * /home/backup/vm_backup.sh
Мы будем выполнять резервное копирование каждый день в 23:00
00 23 * * * /home/backup/vm_backup.sh
Для редактирования в VI нажмите A, далее введите строку задания Cron и нажмите Enter, чтобы следующая строка была пустая.
Чтобы Cron корректно сохранил задание последняя строка всегда должна быть пустая.
Для сохранения изменений в Cron нажмите Esc а затем 2 раза z. Теперь Cron задание сохранено.
Мы рассмотрели резервное копирование для Windows подобных VM. Теперь рассмотрим скрипт резервного копирования, который подходит для все типов гостевых ОС.
Создадим новый файл.
touch /home/backup/backupall
Настроим права.
chmod 700 /home/backup/backupall
Теперь подключитесь к хосту через Winscp, откройте файл /home/backup/backupall.
Вставьте в файл следующее содержимое:
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
Сохраните файл.
В строке :
mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup
Вводится подключение к бэкап хранилищу.
Данный скрипт экспортирует запущенные VM и выключенные VM.
Внимание! Имена виртуальных машин не должны содержать пробелы! Иначе скрипт работать не будет.
Запустите скрипт. После выполнения скрипта, на хранилище появятся новые файлы с расширением .xva
Теперь добавим данный скрипт в Cron, строка в Cron должна выглядеть так:
30 23 * * * /home/backup/backupall
Данный скрипт будет запускаться в 23:30
Данный скрипт может быть запущен на пул мастере, при этом резервные копии будут делаться для всех серверов в пуле Xen.
Теперь рассмотрим резервное копирование конфигурации Xen хоста.
Тут нам нужна команда:
xe host-backup host=xen1 file-name=/mnt/backup/Xen1-$(date +%Y-%m-%d).xbk
Где xen1 имя хоста, а Xen1-$(date +%Y-%m-%d).xbk имя файла резервной копии.
Автоматизируем данную задачу.
Создадим новый скрипт:
touch /home/backup/hostbackup
Настраиваем права:
chmod 700 /home/backup/hostbackup
Добавляем в файл следующее содержимое:
#!/bin/bash

xenhost=xen1

mount -t cifs "//192.168.1.51/backup" -o username=admin,password=Password /mnt/backup

xe host-backup host=$xenhost file-name=/mnt/backup/$xenhost-$(date +%Y-%m-%d).xbk


umount /mnt/backup
В переменную xenhost указывается имя хоста Xen.
Добавим строку в задание Cron:
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
Related posts:Запуск команд внутри гостевых ОС в гипервизоре KVM на примере ProxmoxПеренос виртуальной машины из Hyper-V в Proxmox (KVM)Vsphere. Поиск виртуальных машин с толстыми дисками
        
             Виртуализация 
             Метки: XenServer, Виртуализация, Резервное копирование  
        
            
        
    



                        
                    
                    
                
        
                
	
    	
        
        	Комментарии
        
		
		 
    
    
        
                    
         
        
            
            
                
                Павел
                  
                16.04.2016 в 00:02 - 
                Ответить                                
                
            
    
                      
            &#171;Разумеется коммерческие решения удобнее и проще чем&#187; вопрос спорный Vmware DP постоянно падает на официальном сайте куча kb для решения этих проблем  :-)
          
        
        
        


    
    

 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                06.05.2016 в 23:22 - 
                Ответить                                
                
            
    
                      
            Тут как повезет) У меня с Vmware DP не было серьезных проблем)
          
        
        
        


    
    

 
    
    
        
                    
         
        
            
            
                
                RA
                  
                03.10.2016 в 06:54 - 
                Ответить                                
                
            
    
                      
            Я так понял, что .xva будет выгружаться пока не закончится место в /mnt/backup/. А что потом? Скрипт будет как-то чистить место назначения? Или выдаст ошибку и все?
          
        
        
        


    
    

 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                24.04.2017 в 12:07 - 
                Ответить                                
                
            
    
                      
            Верно, в скрипте не предусмотрена автоочистка, но вы ее можете выполнять вот такой командой &#8212; find /path/to/files* -mtime +5 -exec rm {} \; где /path/to/files* путь к файлам , а +5 старше скольки дней нужно удалять файлы.
          
        
        
        


    
    

	
    








	
		
		Добавить комментарий Отменить ответВаш адрес email не будет опубликован. Обязательные поля помечены *Комментарий * Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
	


<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">

(adsbygoogle = window.adsbygoogle || []).push({});





			
        
        

		

        

           
    
    


  


	
    

		
        
             
			

                

                    
                                                  Все права защищены. IT Traveler 2025 
                         
                        
																														                    
                    

				
                
                
    
			
		                            
	

	
                
                
			
                
		
        
	
    


jQuery(document).ready(function($){
  $("a[rel*=lightbox]").colorbox({initialWidth:"30%",initialHeight:"30%",maxWidth:"90%",maxHeight:"90%",opacity:0.8,current:" {current}  {total}",previous:"",close:"Закрыть"});
});
  



    (function (d, w, c) {
        (w[c] = w[c] || []).push(function() {
            try {
                w.yaCounter27780774 = new Ya.Metrika({
                    id:27780774,
                    clickmap:true,
                    trackLinks:true,
                    accurateTrackBounce:true,
                    webvisor:true,
                    trackHash:true
                });
            } catch(e) { }
        });

        var n = d.getElementsByTagName("script")[0],
            s = d.createElement("script"),
            f = function () { n.parentNode.insertBefore(s, n); };
        s.type = "text/javascript";
        s.async = true;
        s.src = "https://mc.yandex.ru/metrika/watch.js";

        if (w.opera == "[object Opera]") {
            d.addEventListener("DOMContentLoaded", f, false);
        } else { f(); }
    })(document, window, "yandex_metrika_callbacks");





  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-58126221-1', 'auto');
  ga('send', 'pageview');






