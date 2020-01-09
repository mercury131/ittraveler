# Выполняем команды внутри гостевых ОС через PowerCLI                	  
***Дата: 22.06.2016 Автор Admin***

Порой нужно запустить скрипт на множестве VM, или выполнить одну и туже команду.
Под катом я расскажу как выполнять команды внутри гостевых ОС через PowerCLI
Поможет нам скрипт:
PowerShell
```
function Load-PowerCLI
{
Add-PSSnapin VMware.VimAutomation.Core
Add-PSSnapin VMware.VimAutomation.Vds
}
Load-PowerCLI
# Connect to Vcenter
$vcenter=""
Connect-VIServer -Server $vcenter #-User -Password
$csv='C:\VM-invokeScript.csv'
Import-Csv $csv -Delimiter ";"| % {
$vcenteruser = $_.vcenteruser; 
$vcenterpass = $_.vcenterpass; 
$vm = $_.vm; 
$guestuser = $_.guestuser; 
$guestpass = $_.guestpass; 
$vcenter = $_.vcenter;
Connect-VIServer -Server $vcenter -User $vcenteruser -Password $vcenterpass
$script1 = 'Your batch file patch or command'
$script2 = '\\test.local\fileshare\bat\run.bat'
Invoke-VMScript -ScriptText $script1 -VM $vm -Server $vcenter -GuestUser $guestuser -GuestPassword $guestpass -ScriptType Bat
Invoke-VMScript -ScriptText $script2 -VM $vm -Server $vcenter -GuestUser $guestuser -GuestPassword $guestpass -ScriptType Bat
disconnect-viserver -Server $vcenter -confirm:$false
}
# Disconnect Vcenter
Disconnect-VIServer $vcenter -Confirm:$false
function Unload-PowerCLI
{
Remove-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue
Remove-PSSnapin VMware.VimAutomation.Vds -ErrorAction SilentlyContinue
}
Unload-PowerCLI
```
function Load-PowerCLI{&nbsp;&nbsp;&nbsp;&nbsp;Add-PSSnapin VMware.VimAutomation.Core&nbsp;&nbsp;&nbsp;&nbsp;Add-PSSnapin VMware.VimAutomation.Vds}&nbsp;Load-PowerCLI&nbsp;# Connect to Vcenter&nbsp;$vcenter=""&nbsp;Connect-VIServer -Server $vcenter #-User -Password&nbsp;&nbsp;$csv='C:\VM-invokeScript.csv'&nbsp;Import-Csv $csv -Delimiter ";"| % {&nbsp;$vcenteruser = $_.vcenteruser; $vcenterpass = $_.vcenterpass; $vm = $_.vm; $guestuser = $_.guestuser; $guestpass = $_.guestpass; $vcenter = $_.vcenter;&nbsp;Connect-VIServer -Server $vcenter -User $vcenteruser -Password $vcenterpass&nbsp;$script1 = 'Your batch file patch or command'&nbsp;$script2 = '\\test.local\fileshare\bat\run.bat'&nbsp;Invoke-VMScript -ScriptText $script1 -VM $vm -Server $vcenter -GuestUser $guestuser -GuestPassword $guestpass -ScriptType Bat&nbsp;Invoke-VMScript -ScriptText $script2 -VM $vm -Server $vcenter -GuestUser $guestuser -GuestPassword $guestpass -ScriptType Bat&nbsp;&nbsp;&nbsp;disconnect-viserver -Server $vcenter -confirm:$false&nbsp;}&nbsp;&nbsp;# Disconnect Vcenter&nbsp;Disconnect-VIServer $vcenter -Confirm:$false&nbsp;&nbsp;&nbsp;function Unload-PowerCLI{&nbsp;&nbsp;&nbsp;&nbsp;Remove-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue&nbsp;&nbsp;&nbsp;&nbsp;Remove-PSSnapin VMware.VimAutomation.Vds -ErrorAction SilentlyContinue&nbsp;&nbsp; }&nbsp;Unload-PowerCLI
Заполняем переменные:
$vcenter &#8212; ваш vcenter сервер
$csv &#8212; путь к файлу с параметрами
Создайте CSV файл с параметрами, следующего вида:
vcenteruser;vcenterpass;guestuser;guestpass;vm;vcenter
user;your_pass;localOSuser;PASS;vm01;vcenter.test.local
user;your_pass;localOSuser;PASS;vm02;vcenter.test.local
user;your_pass;localOSuser;PASS;vm03;vcenter.test.local
user;your_pass;localOSuser;PASS;vm04;vcenter.test.local
&nbsp;
Заполняется файл так:
Логин и пароль к Vcenter; Пользователь гостевой ОС пароль к пользователю гостевой ОС; имя vcenter сервера
user;your_pass;localOSuser;PASS;vm01;vcenter.test.local
Далее в скрипте указываются команды:
$script1 = &#8216;Your batch file patch or command&#8217;
$script2 = &#8216;\\test.local\fileshare\bat\run.bat&#8217;
Замените содержимое этих переменных на ваши команды.
Далее просто запустите скрипт.
Если команды не запускаются проверьте запущены ли vmware tools, включена ли VM, корректные ли логин и пароль к гостевой ОС.
