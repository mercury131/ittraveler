# Vsphere. Поиск виртуальных машин с толстыми дисками                	  
***Дата: 23.05.2016 Автор Admin***

Иногда, требуется найти на датасторе виртуальные машины с толстыми дисками.
Это не вызывает проблем, если виртуальных машин немного, но если их тысяча?
Под катом я покажу как через PowerCLI найти машины с толстыми дисками.
В решении данной задачи нам поможет следующий скрипт:
PowerShell
```
Add-PSSnapin VMware.VimAutomation.Core
$vcenter="vcenter.test.local"
$datastore="Datastore01"
connect-VIServer -Server $vcenter #-User -Password
get-datastore $datastore | get-vm | get-view | %{
$name = $_.name
$_.Config.Hardware.Device | where {$_.GetType().Name -eq "VirtualDisk"} | %{
if(!$_.Backing.ThinProvisioned){
"$name has a thick provisioned disk"
}
}
}
Disconnect-VIServer $vcenter -Confirm:$false
remove-PSSnapin VMware.VimAutomation.Core
```
Add-PSSnapin VMware.VimAutomation.Core&nbsp; $vcenter="vcenter.test.local"&nbsp;$datastore="Datastore01"&nbsp;connect-VIServer -Server $vcenter #-User -Passwordget-datastore $datastore | get-vm | get-view | %{ $name = $_.name $_.Config.Hardware.Device | where {$_.GetType().Name -eq "VirtualDisk"} | %{&nbsp;&nbsp;if(!$_.Backing.ThinProvisioned){&nbsp;&nbsp; "$name has a thick provisioned disk"&nbsp;&nbsp;} }}&nbsp;&nbsp;Disconnect-VIServer $vcenter -Confirm:$false&nbsp;remove-PSSnapin VMware.VimAutomation.Core
Заполняем переменные:
$vcenter &#8212; ваш сервер vcenter
$datastore &#8212; ваш датастор
Вывод скрипта будет таким:
```
vm01 has a thick provisioned disk
vm02 has a thick provisioned disk
vm03 has a thick provisioned disk
```
vm01 has a thick provisioned diskvm02 has a thick provisioned diskvm03 has a thick provisioned disk
Кстати, если вам нужно найти машины с тонкими дисками, воспользуйтесь этим скриптом:
PowerShell
```
Add-PSSnapin VMware.VimAutomation.Core
$vcenter="vcenter.test.local"
$datastore="Datastore01"
connect-VIServer -Server $vcenter #-User -Password
get-datastore $datastore | get-vm | get-view | %{
$name = $_.name
$_.Config.Hardware.Device | where {$_.GetType().Name -eq "VirtualDisk"} | %{
if($_.Backing.ThinProvisioned){
"$name has a thin provisioned disk"
}
}
}
Disconnect-VIServer $vcenter -Confirm:$false
remove-PSSnapin VMware.VimAutomation.Core
```
Add-PSSnapin VMware.VimAutomation.Core$vcenter="vcenter.test.local"&nbsp;$datastore="Datastore01"&nbsp;connect-VIServer -Server $vcenter #-User -Passwordget-datastore $datastore | get-vm | get-view | %{ $name = $_.name $_.Config.Hardware.Device | where {$_.GetType().Name -eq "VirtualDisk"} | %{&nbsp;&nbsp;if($_.Backing.ThinProvisioned){&nbsp;&nbsp; "$name has a thin provisioned disk"&nbsp;&nbsp;} }}&nbsp;&nbsp;Disconnect-VIServer $vcenter -Confirm:$false&nbsp;remove-PSSnapin VMware.VimAutomation.Core
&nbsp;
