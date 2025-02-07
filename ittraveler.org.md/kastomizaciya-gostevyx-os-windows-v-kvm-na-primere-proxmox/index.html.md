#                 	Кастомизация гостевых ОС Windows в KVM на примере Proxmox                	  
***            ***

			
            
		
    
	
    	  Дата: 22.03.2019 Автор Admin  
	В VMware Vsphere есть удобный механизм кастомизации ОС при деплое &#8212; OS Customization 
С помощью него можно например ввести виртуальную машину в домен или запустить скрипты после деплоя.
Это очень удобно, особенно при развертывании сотни виртуальных машин. Похожий механизм захотелось иметь и в KVM.
В этой статье мы рассмотрим как обеспечить похожий функционал на примере Proxmox и шаблона Windows
Для начала нам необходимо подготовить шаблон ОС, из которой мы будем деплоить наши виртуальные машины.
Создайте новую VM, установите на нее ОС, например Windows Server 2016.
Установите на машину необходимые драйвера и qemu агент, он есть в образе с драйверами
После установки qemu агента, создайте локальную учетную запись, откройте службы windows и настройте запуск службы qemu агент не от local system, а от ранее созданной УЗ
Теперь нужно выполнить на машине sysprep с файлом ответа.
Я буду использовать следующий файл ответа, можете использовать его как пример или сгенерировать свой, например тут
файл ответов unattend.xml
&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;unattend xmlns="urn:schemas-microsoft-com:unattend"&gt;
&lt;settings pass="windowsPE"&gt;
&lt;component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;SetupUILanguage&gt;
&lt;UILanguage&gt;en-US&lt;/UILanguage&gt;
&lt;/SetupUILanguage&gt;
&lt;InputLocale&gt;0c09:00000409&lt;/InputLocale&gt;
&lt;SystemLocale&gt;en-US&lt;/SystemLocale&gt;
&lt;UILanguage&gt;en-US&lt;/UILanguage&gt;
&lt;UILanguageFallback&gt;en-US&lt;/UILanguageFallback&gt;
&lt;UserLocale&gt;en-US&lt;/UserLocale&gt;
&lt;/component&gt;
&lt;component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;ImageInstall&gt;
&lt;OSImage&gt;
&lt;InstallTo&gt;
&lt;DiskID&gt;0&lt;/DiskID&gt;
&lt;PartitionID&gt;2&lt;/PartitionID&gt;
&lt;/InstallTo&gt;
&lt;/OSImage&gt;
&lt;/ImageInstall&gt;
&lt;UserData&gt;
&lt;AcceptEula&gt;true&lt;/AcceptEula&gt;
&lt;FullName&gt;admin&lt;/FullName&gt;
&lt;Organization&gt;&lt;/Organization&gt;
&lt;ProductKey&gt;
&lt;Key&gt;WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY&lt;/Key&gt;
&lt;/ProductKey&gt;
&lt;/UserData&gt;
&lt;EnableFirewall&gt;true&lt;/EnableFirewall&gt;
&lt;RunSynchronous&gt;
&lt;RunSynchronousCommand wcm:action="add"&gt;
&lt;Order&gt;1&lt;/Order&gt;
&lt;Path&gt;net user administrator /active:yes&lt;/Path&gt;
&lt;/RunSynchronousCommand&gt;
&lt;/RunSynchronous&gt;
&lt;/component&gt;
&lt;/settings&gt;
&lt;settings pass="offlineServicing"&gt;
&lt;component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;EnableLUA&gt;false&lt;/EnableLUA&gt;
&lt;/component&gt;
&lt;/settings&gt;
&lt;settings pass="generalize"&gt;
&lt;component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;SkipRearm&gt;1&lt;/SkipRearm&gt;
&lt;/component&gt;
&lt;/settings&gt;
&lt;settings pass="specialize"&gt;
&lt;component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;InputLocale&gt;0c09:00000409&lt;/InputLocale&gt;
&lt;SystemLocale&gt;en-AU&lt;/SystemLocale&gt;
&lt;UILanguage&gt;en-AU&lt;/UILanguage&gt;
&lt;UILanguageFallback&gt;en-AU&lt;/UILanguageFallback&gt;
&lt;UserLocale&gt;en-AU&lt;/UserLocale&gt;
&lt;/component&gt;
&lt;component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;SkipAutoActivation&gt;true&lt;/SkipAutoActivation&gt;
&lt;/component&gt;
&lt;component name="Microsoft-Windows-SQMApi" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;CEIPEnabled&gt;0&lt;/CEIPEnabled&gt;
&lt;/component&gt;
&lt;component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;ComputerName&gt;srv1&lt;/ComputerName&gt;
&lt;/component&gt;
&lt;/settings&gt;
&lt;settings pass="oobeSystem"&gt;
&lt;component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
&lt;AutoLogon&gt;
&lt;Password&gt;
&lt;Value&gt;PASS&lt;/Value&gt;
&lt;PlainText&gt;true&lt;/PlainText&gt;
&lt;/Password&gt;
&lt;Enabled&gt;true&lt;/Enabled&gt;
&lt;Username&gt;administrator&lt;/Username&gt;
&lt;/AutoLogon&gt;
&lt;OOBE&gt;
&lt;HideEULAPage&gt;true&lt;/HideEULAPage&gt;
&lt;HideLocalAccountScreen&gt;true&lt;/HideLocalAccountScreen&gt;
&lt;HideOEMRegistrationScreen&gt;true&lt;/HideOEMRegistrationScreen&gt;
&lt;HideOnlineAccountScreens&gt;true&lt;/HideOnlineAccountScreens&gt;
&lt;HideWirelessSetupInOOBE&gt;true&lt;/HideWirelessSetupInOOBE&gt;
&lt;NetworkLocation&gt;Work&lt;/NetworkLocation&gt;
&lt;ProtectYourPC&gt;1&lt;/ProtectYourPC&gt;
&lt;SkipMachineOOBE&gt;true&lt;/SkipMachineOOBE&gt;
&lt;SkipUserOOBE&gt;true&lt;/SkipUserOOBE&gt;
&lt;/OOBE&gt;
&lt;UserAccounts&gt;
&lt;AdministratorPassword&gt;
&lt;Value&gt;RooTqwerty123&lt;/Value&gt;
&lt;PlainText&gt;true&lt;/PlainText&gt;
&lt;/AdministratorPassword&gt;
&lt;LocalAccounts&gt;
&lt;LocalAccount wcm:action="add"&gt;
&lt;Description&gt;admin&lt;/Description&gt;
&lt;DisplayName&gt;admin&lt;/DisplayName&gt;
&lt;Group&gt;Administrators&lt;/Group&gt;
&lt;Name&gt;admin&lt;/Name&gt;
&lt;/LocalAccount&gt;
&lt;LocalAccount wcm:action="add"&gt;
&lt;Password&gt;
&lt;Value&gt;PasswordGoesHere&lt;/Value&gt;
&lt;PlainText&gt;true&lt;/PlainText&gt;
&lt;/Password&gt;
&lt;Description&gt;Local Administrator&lt;/Description&gt;
&lt;DisplayName&gt;Administrator&lt;/DisplayName&gt;
&lt;Group&gt;Administrators&lt;/Group&gt;
&lt;Name&gt;Administrator&lt;/Name&gt;
&lt;/LocalAccount&gt;
&lt;/LocalAccounts&gt;
&lt;/UserAccounts&gt;
&lt;RegisteredOrganization&gt;&lt;/RegisteredOrganization&gt;
&lt;RegisteredOwner&gt;admin&lt;/RegisteredOwner&gt;
&lt;DisableAutoDaylightTimeSet&gt;false&lt;/DisableAutoDaylightTimeSet&gt;
&lt;TimeZone&gt;Russian Standard Time&lt;/TimeZone&gt;
&lt;/component&gt;
&lt;/settings&gt;
&lt;/unattend&gt;
Теперь сохраните этот файл на своей виртуальной машине, которую вы только что настроили и развернули и планируете использовать как шаблон.
Далее запустите на ней sysprep.
команда запуска будет следующая:
sysprep.exe /generalize /oobe /unattend:c:\unattend.xml /shutdown
Выполнение этой команды применит файл ответов и выключит виртуальную машину.
После этого она будет готова к деплою.
Теперь преобразуйте ее в шаблон в веб интерфейсе proxmox
&nbsp;
На этом этапе шаблон полностью готов.
Теперь нам нужен скрипт деплоя VM с хоста.
Скрипт будет выполнять следующее:
1) Клонировать VM из шаблона
2) Включать VM после деплоя, проверять запуск qemu агента и вводить машину в домен Active Directory или просто переименовывать.
Это будет делать следующий скрипт, который нужно запускать с хоста гипервизора:
#!/bin/bash

########EXAMPLE

# ./deploy.sh 118 testsrv2 testvm join

# where:

# 118 - template ID

# testsrv2 - new virtual machine name

# testvm - qemu pool name

# run command to join AD domain inside guest OS

###############

########DOMAIN CREDENTIALS

login='administrator'

password='RooTqwerty12345'

domain='test-temp.local'

###########################

vm=$2

template=$1

lastid=$(ls /etc/pve/qemu-server/ | sed s/.conf// | tail -n1)

newid=$((lastid + 1))

pool=$3

join=$4

echo "##############START_DEPLOY############################"

echo "VM ID IS $newid"


if [ "$pool" = "none" ];

then
qm clone $template $newid -name $vm #-pool $pool
else
qm clone $template $newid -name $vm  -pool $pool
fi

echo "Clone complete"
echo 'Your VM name is '$vm''

echo "Start VM - $vm"

qm start $newid



while [ -n "$(qm agent $newid ping 2&gt;&amp;1 &gt; /dev/null)" ]; do
  sleep 0.5
echo "Waiting qemu agent on VM - $vm"
done

echo "Waiting guest OS"

for i in {1..240}
do
left=$[240 - $i]
   echo "Waiting guest OS on VM - $vm."
   echo "Time left $left sec.."
   sleep 1
done


echo "Send command to customize VM - $vm (ASYNC)"

if [ -n "$join" ];

then
echo "Send command to join domain $domain for VM - $vm"
echo '{"execute":"guest-exec", "arguments":{"path":"powershell.exe","arg":["-command","add-computer", "-NewName '$vm'", "-restart", "-DomainName '$domain'", "-force", "-Credential $(New-Object   System.Management.Automation.PsCredential(\u0027'$login'\u0027,$(ConvertTo-SecureString -String \u0027'$password'\u0027 -AsPlainText -Force)))"]}}'  | socat /var/run/qemu-server/$newid.qga -
else
echo "Send command to rename hostname on VM - $vm"
echo '{"execute":"guest-exec", "arguments":{"path":"powershell.exe","arg":["-command","rename-computer", "-NewName '$vm'", "-restart", "-force", "-LocalCredential $(New-Object   System.Management.Automation.PsCredential(\u0027'login'\u0027,$(ConvertTo-SecureString -String \u0027'$password'\u0027 -AsPlainText -Force)))"]}}'  | socat /var/run/qemu-server/$newid.qga -

fi

echo "Deploy VM - $vm - complete"

echo "##############COMPLETE############################"
Пример запуска скрипта
./deploy.sh 118 testsrv2 testvm join
Где:
118 &#8212; ID ранее созданного шаблона
testsrv2 &#8212; имя создаваемой VM
testvm &#8212; имя ресурсного пула qemu (если не указывать машин будет просто склонирована на тот же хост)
join &#8212; ввод виртуальной машины в домен после клонирования (если не указывать машина будет просто переименована, без ввода в домен)
В секции ниже измените учетные данные для подключения к домену и его адрес:
########DOMAIN CREDENTIALS

login='administrator'

password='RooTqwerty12345'

domain='test-temp.local'

###########################
Таким образом можно развернуть и кастомизировать VM по аналогии с VMware Guest Customization.
Но если нам нужно развернуть не одну а 10 или 100 виртуальных машин?
Добавим следующий скрипт для запуска этого процесса:
#!/bin/bash

######EXAMPLE

# ./start_deploy.sh 118 testvm join

# where:

# 118 - template ID
# testvm - qemu pool name
# join - run join to AD domain command inside guest os

# add vms names to file vms.list

#############

START=$(date +%s)

file=./vms.list

template=$1

pool=$2

join=$3

while IFS='' read -r line || [[ -n "$line" ]]; do


    echo "Start job for VM - $line"

./deploy.sh $template $line $pool $join



done &lt; "$file"

END=$(date +%s)
DIFF=$(( $END - $START ))
DIFFMIN=$[$DIFF / 60]
echo "Deploy time - $DIFFMIN minutes"
Пример запуска:
./start_deploy.sh 118 testvm join
Где:
118 &#8212; ID ранее созданного шаблона
testvm &#8212; имя ресурсного пула qemu (если не указывать машин будет просто склонирована на тот же хост)
join &#8212; ввод виртуальной машины в домен после клонирования (если не указывать машина будет просто переименована, без ввода в домен)
Построчный список VM сохраните в файле vms.list
Теперь вы можете автоматизировать деплой ваших виртуальных машин на базе Windows в KVM.
Процесс настройки конечно отличается от VMware, но на то он и open source.
&nbsp;
Related posts:Ошибка ERR: CERT_COMMON_NAME_INVALID в Chrome при использовании SSL сертификата.Назначение служб для сертификатов Exchange через Powershell.Перенос базы данных Active Directory
        
             Bash, Debian, Windows, Windows Server, Без рубрики, Виртуализация 
               
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
