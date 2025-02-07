#                 	Перенос виртуальной машины из Hyper-V в Proxmox (KVM)                	  
***            ***

			
            
		
    
	
    	  Дата: 01.12.2018 Автор Admin  
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
nano /etc/pve/qemu-server/700.conf
Конфиг созданной VM следующий:
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
Мы помним что сконвертированный диск называется ADtest.local.qcow2 и расположен на датасторе Backup_Storage, а id нашей машины 700.
Добавим в конфиг следующую строку чтобы подключить диск qcow2
sata0: Backup_Storage:700/ADtestlocal.qcow2,size=40G
Конфиг должен получиться такой:
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
Сохраните конфиг через CTRL + X
Теперь в Proxmox будет виден диск виртуальной машины
Теперь, чтобы при включении VM нормально загрузилась, нужно изменить ее boot order
Теперь можно включить виртуальную машину и убедиться что она работает.
&nbsp;
Related posts:Установка и настройка Foreman + PuppetДобавление почтовых контактов в Office 365 через Powershell и CSVУстановка и настройка Radius сервера на Ubuntu с веб интерфейсом.
        
             Linux, Windows, Без рубрики, Виртуализация 
             Метки: kvm, Linux, proxmox  
        
            
        
    
                        
                    
                    
                
        
                
	
    	
        
        	Комментарии
        
		
		 
    
    
        
                    
         
        
            
            
                
                Виктор
                  
                13.05.2021 в 09:56 - 
                Ответить                                
                
            
    
                      
            Отличная статья, только надо было немного подробней остановиться на создании хранилища (или как здесь он называется датасторе). Я, например, изрядно помучился, прежде чем догадался назначить хранилищу (тип Каталог) права на Образы дисков. Иначе при запуске машины шла ошибка &#171;unable to parse directory volume name&#187;. И кстати, можно пользовать и локальное хранилище local, просто скопировав образ в соответствующее место, без всяких монтировок, но это уже от задач зависит&#8230;
          
        
        
        
    
    
	
    
	
		
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
