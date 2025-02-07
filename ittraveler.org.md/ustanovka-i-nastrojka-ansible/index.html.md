#                 	Установка и настройка Ansible                	  
***            ***

			
            
		
    
	
    	  Дата: 27.07.2018 Автор Admin  
	В данной статье мы рассмотрим как установить Ansible на Ubuntu server 18.04 и настроить playbook с автоматической установкой обновлений на Windows и Ubuntu хосты.
Также рассмотрим простой пример как поднять веб сервер с nginx,php7,mysql и поднять роли iis, fileserver на Windows хостах с помощью playbook Ansible.
Поехали!
Добавим ключ от репозитория Ansible
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
Добавим сам репозиторий
apt-add-repository "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main"
Обновим список пакетов и установим Ansible
apt-get update &amp;&amp; apt-get install ansible
Ansible использует ssh для подключения к Linux серверам.
Поэтому создадим ключ ssh на сервере Ansible
ssh-keygen -t rsa -b 4096
Далее нужно скопировать ключ кодандой ниже, на каждый сервер который мы планируем обслуживать через Ansible
ssh-copy-id root@test-ubuntu1
В данной команде измените root на своего пользователя и test-ubuntu1 на hostname вашего сервера
Ansible использует python для управления linux хостами, поэтому подклюючимся к каждой ноде с Ubuntu и установим на них python командой:
apt-get update &amp;&amp; apt-get install python python-apt
Теперь вернемся на сервер Ansible и откроем файл /etc/ansible/hosts
В данный файл заносятся хосты которые мы планируем обслуживать через Ansible.
Хосты заносятся по группам.
Например:
[servers_ubuntu]
test-ubuntu1
test-ubuntu1
Теперь проверим можем ли мы подключиться к добавленным хостам
Запустим ping
ansible -m ping all
Вывод должен быть таким:
test-ubuntu1 | SUCCESS =&gt; {
    "changed": false,
    "ping": "pong"
}
test-ubuntu2 | SUCCESS =&gt; {
    "changed": false,
    "ping": "pong"
}
Также можно изменить команду ping следующим образом:
ansible -m ping servers_ubuntu - в данном случае мы пингуем только сервера из группы servers_ubuntu

ansible -m ping test-ubuntu1 - в данном случае мы пингуем только хост test-ubuntu1
Теперь проверим связь по ssh
Выполним команду , которая выведет нам кол-во свободной памяти на наших серверах с Ubuntu
ansible -m shell -a 'free -m' servers_ubuntu
Вывод должен быть примерно таким:
test-ubuntu2 | SUCCESS | rc=0 &gt;&gt;
              total        used        free      shared  buff/cache   available
Mem:           1993          99        1454           1         440        1742
Swap:          2047           0        2047

test-ubuntu1 | SUCCESS | rc=0 &gt;&gt;
              total        used        free      shared  buff/cache   available
Mem:           1993          99        1454           1         439        1742
Swap:          2047           0        2047
Если команда выполнилась на серверах значит у нас все ок, и соединение по ssh работает.
По умолчанию Ansible пытается подключиться по ssh под тем пользователем под которым вы в данный момент находитесь в системе.
Если на хосте, к которому вы подключаетесь этого пользователя нет, или нужно подключаться под другим пользователем, нужно добавить переменную в Ansible.
Для этого создаем папку &#8212; /etc/ansible/group_vars командой ниже:
mkdir /etc/ansible/group_vars
Далее создаем в ней файл с названием нашей группы серверов
touch /etc/ansible/group_vars/servers_ubuntu
и внесем в него следующую переменную, сам файл необходимо создавать в формате YAML.
Содержимое файла будет следующее:
---
ansible_ssh_user: root
Вместо root укажите своего пользователя.
&nbsp;
Теперь перейдем к самому интересному, создадим свой первый Playbook, который будет устанавливать обновления на Ubuntu.
Создадим папку для Playbook
mkdir -p ~/ansible/playbooks
Создадим новый Playbook
touch ~/ansible/playbooks/update_ubuntu.yml
Открываем файл ~/ansible/playbooks/update_ubuntu.yml и заполняем его следующим образом:
---
- hosts: servers_ubuntu
  tasks:
   - name: updates a server
     apt: update_cache=yes
   - name: upgrade a server
     apt: upgrade=dist
   - name: Check if a reboot is required
     register: file
     stat: path=/var/run/reboot-required get_md5=no
   - name: Reboot the server
     command: /sbin/reboot
     when: file.stat.exists == true
&nbsp;
Проверим Playbook
ansible-playbook --check  ~/ansible/playbooks/update_ubuntu.yml
Вывод команды должен быть таким:
PLAY [servers_ubuntu] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [test-ubuntu2]
ok: [test-ubuntu1]

TASK [updates a server] *********************************************************************************************************************************************************************************************************************
changed: [test-ubuntu1]
changed: [test-ubuntu2]

TASK [upgrade a server] *********************************************************************************************************************************************************************************************************************
ok: [test-ubuntu2]
ok: [test-ubuntu1]

TASK [Check if a reboot is required] ********************************************************************************************************************************************************************************************************
ok: [test-ubuntu1]
ok: [test-ubuntu2]

TASK [Reboot the server] ********************************************************************************************************************************************************************************************************************
skipping: [test-ubuntu1]
skipping: [test-ubuntu2]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
test-ubuntu1               : ok=4    changed=1    unreachable=0    failed=0
test-ubuntu2               : ok=4    changed=1    unreachable=0    failed=0
Запустим Playbook
ansible-playbook ~/ansible/playbooks/update_ubuntu.yml
Вывод команды должен быть таким:
PLAY [servers_ubuntu] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [test-ubuntu2]
ok: [test-ubuntu1]

TASK [updates a server] *********************************************************************************************************************************************************************************************************************
changed: [test-ubuntu2]
changed: [test-ubuntu1]

TASK [upgrade a server] *********************************************************************************************************************************************************************************************************************
changed: [test-ubuntu1]
changed: [test-ubuntu2]

TASK [Check if a reboot is required] ********************************************************************************************************************************************************************************************************
ok: [test-ubuntu1]
ok: [test-ubuntu2]

TASK [Reboot the server] ********************************************************************************************************************************************************************************************************************
fatal: [test-ubuntu2]: UNREACHABLE! =&gt; {"changed": false, "msg": "Failed to connect to the host via ssh: Shared connection to test-ubuntu2 closed.\r\n", "unreachable": true}
fatal: [test-ubuntu1]: UNREACHABLE! =&gt; {"changed": false, "msg": "Failed to connect to the host via ssh: Shared connection to test-ubuntu1 closed.\r\n", "unreachable": true}
        to retry, use: --limit @/root/ansible/playbooks/update_ubuntu.retry

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
test-ubuntu1               : ok=4    changed=2    unreachable=1    failed=0
test-ubuntu2               : ok=4    changed=2    unreachable=1    failed=0
Сервера успешно обновились.
Строку fatal: [test-ubuntu2]: UNREACHABLE! мы получили из-за того что Ansible отправил сервера на перезагрузку , т.к. в сценарии Playbook мы указали проверить есть ли хостах файл /var/run/reboot-required
Если перезагрузка серверов не требуется можно использовать следующий Playbook:
---
- hosts: servers_ubuntu
  tasks:
    - name: Run the equivalent of apt-get update
      apt:
        update_cache: yes

    - name: Update all packages to the latest version
      apt:
        upgrade: dist
&nbsp;
Обратите внимание, тут я использую немного другой синтаксис apt , он тоже корректный.
Более подробно о синтаксисе можно почитать тут &#8212; https://docs.ansible.com/ansible/latest/modules/apt_module.html#examples
Теперь создадим Playbook устанавливающий Nginx, PHP и Mysql на наши сервера с Ubuntu
touch ~/ansible/playbooks/lemp_ubuntu.yml
Сам Playbook будет выглядеть так:
---
- hosts: servers_ubuntu
  tasks:
    - name: Run the equivalent of apt-get update
      apt:
        update_cache: yes

    - name: Install Nginx
      apt:
        name: nginx
        state: latest

    - name: Install Mysql
      apt:
        name: mysql-server-5.7
        state: latest

    - name: Install PHP-FPM
      apt:
        name: php-fpm
        state: latest

    - name: Install PHP-MYSQL
      apt:
        name: php-mysql
        state: latest
Проверим Playbook
ansible-playbook --check   ~/ansible/playbooks/lemp_ubuntu.yml
PLAY [servers_ubuntu] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [test-ubuntu2]
ok: [test-ubuntu1]

TASK [Run the equivalent of apt-get update] *************************************************************************************************************************************************************************************************
changed: [test-ubuntu2]
changed: [test-ubuntu1]

TASK [Install Nginx] ************************************************************************************************************************************************************************************************************************
changed: [test-ubuntu1]
changed: [test-ubuntu2]

TASK [Install Mysql] ************************************************************************************************************************************************************************************************************************
changed: [test-ubuntu2]
changed: [test-ubuntu1]

TASK [Install PHP-FPM] **********************************************************************************************************************************************************************************************************************
changed: [test-ubuntu1]
changed: [test-ubuntu2]

TASK [Install PHP-MYSQL] ********************************************************************************************************************************************************************************************************************
changed: [test-ubuntu1]
changed: [test-ubuntu2]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
test-ubuntu1               : ok=6    changed=5    unreachable=0    failed=0
test-ubuntu2               : ok=6    changed=5    unreachable=0    failed=0
Запустим Playbook
ansible-playbook  ~/ansible/playbooks/lemp_ubuntu.yml
PLAY [servers_ubuntu] ***********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [test-ubuntu2]
ok: [test-ubuntu1]

TASK [Run the equivalent of apt-get update] *************************************************************************************************************************************************************************************************
changed: [test-ubuntu2]
changed: [test-ubuntu1]

TASK [Install Nginx] ************************************************************************************************************************************************************************************************************************
changed: [test-ubuntu1]
changed: [test-ubuntu2]

TASK [Install Mysql] ************************************************************************************************************************************************************************************************************************
changed: [test-ubuntu2]
changed: [test-ubuntu1]

TASK [Install PHP-FPM] **********************************************************************************************************************************************************************************************************************
changed: [test-ubuntu2]
changed: [test-ubuntu1]

TASK [Install PHP-MYSQL] ********************************************************************************************************************************************************************************************************************
changed: [test-ubuntu2]
changed: [test-ubuntu1]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
test-ubuntu1               : ok=6    changed=5    unreachable=0    failed=0
test-ubuntu2               : ok=6    changed=5    unreachable=0    failed=0
Playbook Успешно отработал, если зайти на хосты мы увидим что nginx, php и mysql успешно установились.
На этом этапе базовая настройка Playbook для хостов Ubuntu закончена перейдем к настройке хостов под управлением Windows.
Для работы с Windows хостами Ansible использует Powershell и winrm , версия Powershell требуется не ниже 3.0 , а net framework не ниже 4.
Для обновления Powershell и net framework можно использовать следующий скрипт:
$url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Upgrade-PowerShell.ps1"
$file = "$env:temp\Upgrade-PowerShell.ps1"
$username = "Administrator"
$password = "Password"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

# version can be 3.0, 4.0 or 5.1
&amp;$file -Version 5.1 -Username $username -Password $password -Verbose

# this isn't needed but is a good security practice to complete
Set-ExecutionPolicy -ExecutionPolicy Restricted -Force

$reg_winlogon_path = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $reg_winlogon_path -Name AutoAdminLogon -Value 0
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultUserName -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultPassword -ErrorAction SilentlyContinue
Далее запустите следующий скрипт для активации WINRM
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)

powershell.exe -ExecutionPolicy ByPass -File $file
После того как скрипты успешно отработали на ваших Windows хостах перейдем к настройке самого Ansible.
Переходим в консоль Ansible и запускаем команды для установки поддержки приложений python
apt-get install python-pip 
export PATH="${HOME}/.local/bin:$PATH"
pip install pywinrm
Откроем файл /etc/ansible/hosts и добавим Windows Хосты.
[servers_windows]
test-ansible
test-ansible-iis

[servers_windows:vars]
ansible_user=YOUR_ADMIN_USER
ansible_password=password
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
Обратите внимание что кроме самих хостов были добавлены переменные с логином и паролем для подключения и включено игнорирование проверки ssl сертификата.
Теперь запустим ping до Windows хостов командой:
ansible servers_windows -m win_ping
Вывод должен быть следующим:
ansible servers_windows -m win_ping

test-ansible-iis | SUCCESS =&gt; {
    "changed": false,
    "ping": "pong"
}
test-ansible | SUCCESS =&gt; {
    "changed": false,
    "ping": "pong"
}
Теперь создадим новый Playbook, который будет устанавливать обновления на Windows хосты.
touch ~/ansible/playbooks/update_windows.yml
Сам Playbook будет следующий:
---
- hosts: servers_windows
  tasks:
     - name: Install all security, critical, and rollup updates
       win_updates:
        category_names:
          - SecurityUpdates
          - CriticalUpdates
          - UpdateRollups
        reboot: yes
Проверим Playbook
ansible-playbook --check   ~/ansible/playbooks/update_windows.yml
Вывод должен быть таким:
PLAY [servers_windows] **********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [test-ansible-iis]
ok: [test-ansible]

TASK [Install all security, critical, and rollup updates] ***********************************************************************************************************************************************************************************
ok: [test-ansible-iis]
ok: [test-ansible]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
test-ansible               : ok=2    changed=0    unreachable=0    failed=0
test-ansible-iis           : ok=2    changed=0    unreachable=0    failed=0
Запустим Playbook
ansible-playbook   ~/ansible/playbooks/update_windows.yml
Вывод должен быть примерно таким:
PLAY [servers_windows] **********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [test-ansible]
ok: [test-ansible-iis]

TASK [Install all security, critical, and rollup updates] ***********************************************************************************************************************************************************************************
ok: [test-ansible]
changed: [test-ansible-iis]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
test-ansible               : ok=2    changed=0    unreachable=0    failed=0
test-ansible-iis           : ok=2    changed=1    unreachable=0    failed=0
Обновления успешно установились на сервер test-ansible-iis , а для сервера test-ansible нет новых обновлений.
Теперь создадим Playbook для установки роли веб сервера IIS.
Создаем Playbook
touch ~/ansible/playbooks/install_iis_windows.yml
Сам Playbook будет следующего содержания:
---
- hosts: servers_windows
  tasks:
     - name: Install IIS Web-Server with  management tools
       win_feature:
        name: Web-Server
        state: present
        include_management_tools: True
       register: win_feature
Запустим проверку нашего Playbook
ansible-playbook --check ~/ansible/playbooks/install_iis_windows.yml
Вывод должен быть следующий:
PLAY [servers_windows] **********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [test-ansible]
ok: [test-ansible-iis]

TASK [Install IIS Web-Server with  management tools] ************************************************************************************************************************************************************************
changed: [test-ansible]
changed: [test-ansible-iis]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
test-ansible               : ok=2    changed=1    unreachable=0    failed=0
test-ansible-iis           : ok=2    changed=1    unreachable=0    failed=0
Теперь запустим Playbook
~/ansible/playbooks/install_iis_windows.yml
Вывод должен быть таким:
PLAY [servers_windows] **********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [test-ansible]
ok: [test-ansible-iis]

TASK [Install IIS Web-Server with management tools] ************************************************************************************************************************************************************************
ok: [test-ansible]
changed: [test-ansible-iis]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
test-ansible               : ok=2    changed=0    unreachable=0    failed=0
test-ansible-iis           : ok=2    changed=1    unreachable=0    failed=0
На сервере test-ansible IIS уже был установлен, поэтому для него изменения не применились, а вот на сервер test-ansible-iis успешно установилась роль веб сервера IIS.
Более подробно о модуле win_feature можно почитать тут &#8212; https://docs.ansible.com/ansible/2.5/modules/win_feature_module.html
Сам список доступных фич можно получить Powershell командой Get-WindowsFeature , которую нужно выполнить на хосте с Windows.
Рассмотрим еще один пример, установим роли файлового сервера и ISCSI Target.
Создаем Playbook
touch ~/ansible/playbooks/install_fileserver_iscsi_target_windows.yml
Сам Playbook будет следующий:
---
- hosts: servers_windows
  tasks:
     - name: Install File-Server with management tools
       win_feature:
        name: FS-FileServer
        state: present
        include_management_tools: True
       register: win_feature

     - name: Install ISCSI Target-Server with  management tools
       win_feature:
        name: FS-iSCSITarget-Server
        state: present
        include_management_tools: True
       register: win_feature
Теперь запустим Playbook
ansible-playbook  ~/ansible/playbooks/install_fileserver_iscsi_target_windows.yml
Результат:
PLAY [servers_windows] **********************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [test-ansible]
ok: [test-ansible-iis]

TASK [Install File-Server with management tools] ********************************************************************************************************************************************************************************************
changed: [test-ansible-iis]
changed: [test-ansible]

TASK [Install ISCSI Target-Server with  management tools] ***********************************************************************************************************************************************************************************
changed: [test-ansible]
changed: [test-ansible-iis]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
test-ansible               : ok=3    changed=2    unreachable=0    failed=0
test-ansible-iis           : ok=3    changed=2    unreachable=0    failed=0
Роли файлового сервера и ISCSI Target успешно установились на сервера.
Обратите внимание что роли в playbook указываются из графы Name, команды Get-WindowsFeature.
Ниже пример вывода команды Get-WindowsFeature и список доступных ролей и фич Windows Server
Display Name                                            Name                       Install State
------------                                            ----                       -------------
[ ] Active Directory Certificate Services               AD-Certificate                 Available
    [ ] Certification Authority                         ADCS-Cert-Authority            Available
    [ ] Certificate Enrollment Policy Web Service       ADCS-Enroll-Web-Pol            Available
    [ ] Certificate Enrollment Web Service              ADCS-Enroll-Web-Svc            Available
    [ ] Certification Authority Web Enrollment          ADCS-Web-Enrollment            Available
    [ ] Network Device Enrollment Service               ADCS-Device-Enrollment         Available
    [ ] Online Responder                                ADCS-Online-Cert               Available
[ ] Active Directory Domain Services                    AD-Domain-Services             Available
[ ] Active Directory Federation Services                ADFS-Federation                Available
[ ] Active Directory Lightweight Directory Services     ADLDS                          Available
[ ] Active Directory Rights Management Services         ADRMS                          Available
    [ ] Active Directory Rights Management Server       ADRMS-Server                   Available
    [ ] Identity Federation Support                     ADRMS-Identity                 Available
[ ] Application Server                                  Application-Server             Available
    [ ] .NET Framework 4.5                              AS-NET-Framework               Available
    [ ] COM+ Network Access                             AS-Ent-Services                Available
    [ ] Distributed Transactions                        AS-Dist-Transaction            Available
        [ ] WS-Atomic Transactions                      AS-WS-Atomic                   Available
        [ ] Incoming Network Transactions               AS-Incoming-Trans              Available
        [ ] Outgoing Network Transactions               AS-Outgoing-Trans              Available
    [ ] TCP Port Sharing                                AS-TCP-Port-Sharing            Available
    [ ] Web Server (IIS) Support                        AS-Web-Support                 Available
    [ ] Windows Process Activation Service Support      AS-WAS-Support                 Available
        [ ] HTTP Activation                             AS-HTTP-Activation             Available
        [ ] Message Queuing Activation                  AS-MSMQ-Activation             Available
        [ ] Named Pipes Activation                      AS-Named-Pipes                 Available
        [ ] TCP Activation                              AS-TCP-Activation              Available
[ ] DHCP Server                                         DHCP                           Available
[ ] DNS Server                                          DNS                            Available
[ ] Fax Server                                          Fax                            Available
[X] File and Storage Services                           FileAndStorage-Services        Installed
    [X] File and iSCSI Services                         File-Services                  Installed
        [X] File Server                                 FS-FileServer                  Installed
        [ ] BranchCache for Network Files               FS-BranchCache                 Available
        [X] Data Deduplication                          FS-Data-Deduplication          Installed
        [ ] DFS Namespaces                              FS-DFS-Namespace               Available
        [ ] DFS Replication                             FS-DFS-Replication             Available
        [ ] File Server Resource Manager                FS-Resource-Manager            Available
        [ ] File Server VSS Agent Service               FS-VSS-Agent                   Available
        [ ] iSCSI Target Server                         FS-iSCSITarget-Server          Available
        [ ] iSCSI Target Storage Provider (VDS and V... iSCSITarget-VSS-VDS            Available
        [ ] Server for NFS                              FS-NFS-Service                 Available
        [ ] Work Folders                                FS-SyncShareService            Available
    [X] Storage Services                                Storage-Services               Installed
[ ] Hyper-V                                             Hyper-V                        Available
[ ] Network Policy and Access Services                  NPAS                           Available
    [ ] Network Policy Server                           NPAS-Policy-Server             Available
    [ ] Health Registration Authority                   NPAS-Health                    Available
    [ ] Host Credential Authorization Protocol          NPAS-Host-Cred                 Available
[ ] Print and Document Services                         Print-Services                 Available
    [ ] Print Server                                    Print-Server                   Available
    [ ] Distributed Scan Server                         Print-Scan-Server              Available
    [ ] Internet Printing                               Print-Internet                 Available
    [ ] LPD Service                                     Print-LPD-Service              Available
[ ] Remote Access                                       RemoteAccess                   Available
    [ ] DirectAccess and VPN (RAS)                      DirectAccess-VPN               Available
    [ ] Routing                                         Routing                        Available
    [ ] Web Application Proxy                           Web-Application-Proxy          Available
[ ] Remote Desktop Services                             Remote-Desktop-Services        Available
    [ ] Remote Desktop Connection Broker                RDS-Connection-Broker          Available
    [ ] Remote Desktop Gateway                          RDS-Gateway                    Available
    [ ] Remote Desktop Licensing                        RDS-Licensing                  Available
    [ ] Remote Desktop Session Host                     RDS-RD-Server                  Available
    [ ] Remote Desktop Virtualization Host              RDS-Virtualization             Available
    [ ] Remote Desktop Web Access                       RDS-Web-Access                 Available
[ ] Volume Activation Services                          VolumeActivation               Available
[ ] Web Server (IIS)                                    Web-Server                     Available
    [ ] Web Server                                      Web-WebServer                  Available
        [ ] Common HTTP Features                        Web-Common-Http                Available
            [ ] Default Document                        Web-Default-Doc                Available
            [ ] Directory Browsing                      Web-Dir-Browsing               Available
            [ ] HTTP Errors                             Web-Http-Errors                Available
            [ ] Static Content                          Web-Static-Content             Available
            [ ] HTTP Redirection                        Web-Http-Redirect              Available
            [ ] WebDAV Publishing                       Web-DAV-Publishing             Available
        [ ] Health and Diagnostics                      Web-Health                     Available
            [ ] HTTP Logging                            Web-Http-Logging               Available
            [ ] Custom Logging                          Web-Custom-Logging             Available
            [ ] Logging Tools                           Web-Log-Libraries              Available
            [ ] ODBC Logging                            Web-ODBC-Logging               Available
            [ ] Request Monitor                         Web-Request-Monitor            Available
            [ ] Tracing                                 Web-Http-Tracing               Available
        [ ] Performance                                 Web-Performance                Available
            [ ] Static Content Compression              Web-Stat-Compression           Available
            [ ] Dynamic Content Compression             Web-Dyn-Compression            Available
        [ ] Security                                    Web-Security                   Available
            [ ] Request Filtering                       Web-Filtering                  Available
            [ ] Basic Authentication                    Web-Basic-Auth                 Available
            [ ] Centralized SSL Certificate Support     Web-CertProvider               Available
            [ ] Client Certificate Mapping Authentic... Web-Client-Auth                Available
            [ ] Digest Authentication                   Web-Digest-Auth                Available
            [ ] IIS Client Certificate Mapping Authe... Web-Cert-Auth                  Available
            [ ] IP and Domain Restrictions              Web-IP-Security                Available
            [ ] URL Authorization                       Web-Url-Auth                   Available
            [ ] Windows Authentication                  Web-Windows-Auth               Available
        [ ] Application Development                     Web-App-Dev                    Available
            [ ] .NET Extensibility 3.5                  Web-Net-Ext                    Available
            [ ] .NET Extensibility 4.5                  Web-Net-Ext45                  Available
            [ ] Application Initialization              Web-AppInit                    Available
            [ ] ASP                                     Web-ASP                        Available
            [ ] ASP.NET 3.5                             Web-Asp-Net                    Available
            [ ] ASP.NET 4.5                             Web-Asp-Net45                  Available
            [ ] CGI                                     Web-CGI                        Available
            [ ] ISAPI Extensions                        Web-ISAPI-Ext                  Available
            [ ] ISAPI Filters                           Web-ISAPI-Filter               Available
            [ ] Server Side Includes                    Web-Includes                   Available
            [ ] WebSocket Protocol                      Web-WebSockets                 Available
    [ ] FTP Server                                      Web-Ftp-Server                 Available
        [ ] FTP Service                                 Web-Ftp-Service                Available
        [ ] FTP Extensibility                           Web-Ftp-Ext                    Available
    [ ] Management Tools                                Web-Mgmt-Tools                 Available
        [ ] IIS Management Console                      Web-Mgmt-Console               Available
        [ ] IIS 6 Management Compatibility              Web-Mgmt-Compat                Available
            [ ] IIS 6 Metabase Compatibility            Web-Metabase                   Available
            [ ] IIS 6 Management Console                Web-Lgcy-Mgmt-Console          Available
            [ ] IIS 6 Scripting Tools                   Web-Lgcy-Scripting             Available
            [ ] IIS 6 WMI Compatibility                 Web-WMI                        Available
        [ ] IIS Management Scripts and Tools            Web-Scripting-Tools            Available
        [ ] Management Service                          Web-Mgmt-Service               Available
[ ] Windows Deployment Services                         WDS                            Available
    [ ] Deployment Server                               WDS-Deployment                 Available
    [ ] Transport Server                                WDS-Transport                  Available
[ ] Windows Server Essentials Experience                ServerEssentialsRole           Available
[ ] Windows Server Update Services                      UpdateServices                 Available
    [ ] WID Database                                    UpdateServices-WidDB           Available
    [ ] WSUS Services                                   UpdateServices-Services        Available
    [ ] Database                                        UpdateServices-DB              Available
[X] .NET Framework 3.5 Features                         NET-Framework-Features         Installed
    [X] .NET Framework 3.5 (includes .NET 2.0 and 3.0)  NET-Framework-Core             Installed
    [ ] HTTP Activation                                 NET-HTTP-Activation            Available
    [ ] Non-HTTP Activation                             NET-Non-HTTP-Activ             Available
[X] .NET Framework 4.5 Features                         NET-Framework-45-Fea...        Installed
    [X] .NET Framework 4.5                              NET-Framework-45-Core          Installed
    [ ] ASP.NET 4.5                                     NET-Framework-45-ASPNET        Available
    [X] WCF Services                                    NET-WCF-Services45             Installed
        [ ] HTTP Activation                             NET-WCF-HTTP-Activat...        Available
        [ ] Message Queuing (MSMQ) Activation           NET-WCF-MSMQ-Activat...        Available
        [ ] Named Pipe Activation                       NET-WCF-Pipe-Activat...        Available
        [ ] TCP Activation                              NET-WCF-TCP-Activati...        Available
        [X] TCP Port Sharing                            NET-WCF-TCP-PortShar...        Installed
[ ] Background Intelligent Transfer Service (BITS)      BITS                           Available
    [ ] IIS Server Extension                            BITS-IIS-Ext                   Available
    [ ] Compact Server                                  BITS-Compact-Server            Available
[ ] BitLocker Drive Encryption                          BitLocker                      Available
[ ] BitLocker Network Unlock                            BitLocker-NetworkUnlock        Available
[ ] BranchCache                                         BranchCache                    Available
[ ] Client for NFS                                      NFS-Client                     Available
[ ] Data Center Bridging                                Data-Center-Bridging           Available
[ ] Direct Play                                         Direct-Play                    Available
[ ] Enhanced Storage                                    EnhancedStorage                Available
[ ] Failover Clustering                                 Failover-Clustering            Available
[X] Group Policy Management                             GPMC                           Installed
[ ] IIS Hostable Web Core                               Web-WHC                        Available
[X] Ink and Handwriting Services                        InkAndHandwritingSer...        Installed
[ ] Internet Printing Client                            Internet-Print-Client          Available
[ ] IP Address Management (IPAM) Server                 IPAM                           Available
[ ] iSNS Server service                                 ISNS                           Available
[ ] LPR Port Monitor                                    LPR-Port-Monitor               Available
[ ] Management OData IIS Extension                      ManagementOdata                Available
[X] Media Foundation                                    Server-Media-Foundation        Installed
[ ] Message Queuing                                     MSMQ                           Available
    [ ] Message Queuing Services                        MSMQ-Services                  Available
        [ ] Message Queuing Server                      MSMQ-Server                    Available
        [ ] Directory Service Integration               MSMQ-Directory                 Available
        [ ] HTTP Support                                MSMQ-HTTP-Support              Available
        [ ] Message Queuing Triggers                    MSMQ-Triggers                  Available
        [ ] Multicasting Support                        MSMQ-Multicasting              Available
        [ ] Routing Service                             MSMQ-Routing                   Available
    [ ] Message Queuing DCOM Proxy                      MSMQ-DCOM                      Available
[ ] Multipath I/O                                       Multipath-IO                   Available
[ ] Network Load Balancing                              NLB                            Available
[ ] Peer Name Resolution Protocol                       PNRP                           Available
[ ] Quality Windows Audio Video Experience              qWave                          Available
[ ] RAS Connection Manager Administration Kit (CMAK)    CMAK                           Available
[ ] Remote Assistance                                   Remote-Assistance              Available
[ ] Remote Differential Compression                     RDC                            Available
[X] Remote Server Administration Tools                  RSAT                           Installed
    [ ] Feature Administration Tools                    RSAT-Feature-Tools             Available
        [ ] SMTP Server Tools                           RSAT-SMTP                      Available
        [ ] BitLocker Drive Encryption Administratio... RSAT-Feature-Tools-B...        Available
            [ ] BitLocker Drive Encryption Tools        RSAT-Feature-Tools-B...        Available
            [ ] BitLocker Recovery Password Viewer      RSAT-Feature-Tools-B...        Available
        [ ] BITS Server Extensions Tools                RSAT-Bits-Server               Available
        [ ] Failover Clustering Tools                   RSAT-Clustering                Available
            [ ] Failover Cluster Management Tools       RSAT-Clustering-Mgmt           Available
            [ ] Failover Cluster Module for Windows ... RSAT-Clustering-Powe...        Available
            [ ] Failover Cluster Automation Server      RSAT-Clustering-Auto...        Available
            [ ] Failover Cluster Command Interface      RSAT-Clustering-CmdI...        Available
        [ ] IP Address Management (IPAM) Client         IPAM-Client-Feature            Available
        [ ] Network Load Balancing Tools                RSAT-NLB                       Available
        [ ] SNMP Tools                                  RSAT-SNMP                      Available
        [ ] WINS Server Tools                           RSAT-WINS                      Available
    [X] Role Administration Tools                       RSAT-Role-Tools                Installed
        [X] AD DS and AD LDS Tools                      RSAT-AD-Tools                  Installed
            [X] Active Directory module for Windows ... RSAT-AD-PowerShell             Installed
            [X] AD DS Tools                             RSAT-ADDS                      Installed
                [X] Active Directory Administrative ... RSAT-AD-AdminCenter            Installed
                [X] AD DS Snap-Ins and Command-Line ... RSAT-ADDS-Tools                Installed
                [ ] Server for NIS Tools [DEPRECATED]   RSAT-NIS                       Available
            [X] AD LDS Snap-Ins and Command-Line Tools  RSAT-ADLDS                     Installed
        [ ] Hyper-V Management Tools                    RSAT-Hyper-V-Tools             Available
            [ ] Hyper-V GUI Management Tools            Hyper-V-Tools                  Available
            [ ] Hyper-V Module for Windows PowerShell   Hyper-V-PowerShell             Available
        [ ] Remote Desktop Services Tools               RSAT-RDS-Tools                 Available
            [ ] Remote Desktop Gateway Tools            RSAT-RDS-Gateway               Available
            [ ] Remote Desktop Licensing Diagnoser T... RSAT-RDS-Licensing-D...        Available
            [ ] Remote Desktop Licensing Tools          RDS-Licensing-UI               Available
        [ ] Windows Server Update Services Tools        UpdateServices-RSAT            Available
            [ ] API and PowerShell cmdlets              UpdateServices-API             Available
            [ ] User Interface Management Console       UpdateServices-UI              Available
        [X] Active Directory Certificate Services Tools RSAT-ADCS                      Installed
            [X] Certification Authority Management T... RSAT-ADCS-Mgmt                 Installed
            [ ] Online Responder Tools                  RSAT-Online-Responder          Available
        [X] Active Directory Rights Management Servi... RSAT-ADRMS                     Installed
        [X] DHCP Server Tools                           RSAT-DHCP                      Installed
        [X] DNS Server Tools                            RSAT-DNS-Server                Installed
        [ ] Fax Server Tools                            RSAT-Fax                       Available
        [X] File Services Tools                         RSAT-File-Services             Installed
            [X] DFS Management Tools                    RSAT-DFS-Mgmt-Con              Installed
            [X] File Server Resource Manager Tools      RSAT-FSRM-Mgmt                 Installed
            [X] Services for Network File System Man... RSAT-NFS-Admin                 Installed
            [X] Share and Storage Management Tool       RSAT-CoreFile-Mgmt             Installed
        [ ] Network Policy and Access Services Tools    RSAT-NPAS                      Available
        [ ] Print and Document Services Tools           RSAT-Print-Services            Available
        [ ] Remote Access Management Tools              RSAT-RemoteAccess              Available
            [ ] Remote Access GUI and Command-Line T... RSAT-RemoteAccess-Mgmt         Available
            [ ] Remote Access module for Windows Pow... RSAT-RemoteAccess-Po...        Available
        [ ] Volume Activation Tools                     RSAT-VA-Tools                  Available
        [ ] Windows Deployment Services Tools           WDS-AdminPack                  Available
[ ] RPC over HTTP Proxy                                 RPC-over-HTTP-Proxy            Available
[ ] Simple TCP/IP Services                              Simple-TCPIP                   Available
[X] SMB 1.0/CIFS File Sharing Support                   FS-SMB1                        Installed
[ ] SMB Bandwidth Limit                                 FS-SMBBW                       Available
[ ] SMTP Server                                         SMTP-Server                    Available
[ ] SNMP Service                                        SNMP-Service                   Available
    [ ] SNMP WMI Provider                               SNMP-WMI-Provider              Available
[ ] Telnet Client                                       Telnet-Client                  Available
[ ] Telnet Server                                       Telnet-Server                  Available
[ ] TFTP Client                                         TFTP-Client                    Available
[X] User Interfaces and Infrastructure                  User-Interfaces-Infra          Installed
    [X] Graphical Management Tools and Infrastructure   Server-Gui-Mgmt-Infra          Installed
    [X] Desktop Experience                              Desktop-Experience             Installed
    [X] Server Graphical Shell                          Server-Gui-Shell               Installed
[ ] Windows Biometric Framework                         Biometric-Framework            Available
[ ] Windows Feedback Forwarder                          WFF                            Available
[ ] Windows Identity Foundation 3.5                     Windows-Identity-Fou...        Available
[ ] Windows Internal Database                           Windows-Internal-Dat...        Available
[X] Windows PowerShell                                  PowerShellRoot                 Installed
    [X] Windows PowerShell 4.0                          PowerShell                     Installed
    [X] Windows PowerShell 2.0 Engine                   PowerShell-V2                  Installed
    [ ] Windows PowerShell Desired State Configurati... DSC-Service                    Available
    [X] Windows PowerShell ISE                          PowerShell-ISE                 Installed
    [ ] Windows PowerShell Web Access                   WindowsPowerShellWeb...        Available
[ ] Windows Process Activation Service                  WAS                            Available
    [ ] Process Model                                   WAS-Process-Model              Available
    [ ] .NET Environment 3.5                            WAS-NET-Environment            Available
    [ ] Configuration APIs                              WAS-Config-APIs                Available
[ ] Windows Search Service                              Search-Service                 Available
[ ] Windows Server Backup                               Windows-Server-Backup          Available
[ ] Windows Server Migration Tools                      Migration                      Available
[ ] Windows Standards-Based Storage Management          WindowsStorageManage...        Available
[ ] Windows TIFF IFilter                                Windows-TIFF-IFilter           Available
[ ] WinRM IIS Extension                                 WinRM-IIS-Ext                  Available
[ ] WINS Server                                         WINS                           Available
[ ] Wireless LAN Service                                Wireless-Networking            Available
[X] WoW64 Support                                       WoW64-Support                  Installed
[ ] XPS Viewer                                          XPS-Viewer                     Available
На этом базовое ознакомление с Ansible можно считать законченным)
Удачной установки!
Related posts:Принудительная синхронизация контроллеров домена Active DirectoryСоздание пользователей Active Directory через CSV файлАвтоматизация создания адресных книг в Office 365 через Powershell Часть 2
        
             Bash, Linux, PowerShell, Ubuntu, Web, Web/Cloud, Windows, Windows Server 
             Метки: Ansible, Bash, Powershell, Ubuntu, Windows Server  
        
            
        
    
                        
                    
                    
                
        
                
	
    	
        
        	Комментарии
        
		
		 
    
    
        
                    
         
        
            
            
                
                Роман
                  
                28.07.2018 в 15:39 - 
                Ответить                                
                
            
    
                      
            А можно ли с помощью подобного этого ПО изменять конфиги сразу на множестве серверов?
          
        
        
        
    
    
 
    
    
        
                    
         
        
            
            
                
                Admin
                  
                30.07.2018 в 10:17 - 
                Ответить                                
                
            
    
                      
            Можно, также создаете группу хостов и пишите для них playbook.
Но на мой взгляд удобнее для этих целей использовать Puppet, я на днях планирую опубликовать статью о настройке связки Foreman + Puppet.
          
        
        
        
    
    
	
    
	
		
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
