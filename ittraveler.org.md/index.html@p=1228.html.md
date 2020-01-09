# Установка RSAT на Windows 10 1809                	  
***Дата: 25.03.2019 Автор Admin***

После обновления рабочей машины до версии Windows 10 1809, обнаружил что для нее нельзя скачать пакет RSAT с сайта Microsoft.
А после обновления версии до 1809 установленный ранее пакет RSAT был удален. В этой заметке я рассказу как быстро вернуть RSAT на место.
Теперь, начиная с версии 1809, пакет RSAT предоставляется как Windows Feature, поэтому его можно установить через интерфейс установки и удаления программ, либо DISM, либо Powershell.
Мы рассмотрим последние 2 варианта.
Вариант первый &#8212; Powershell.
Для установки RSAT выполните следующую команду:
```
Get-WindowsCapability -Online | Where-Object {($_.State -notmatch 'Installed') -and ($_.Name -match 'rsat')} | %{Add-WindowsCapability -Name $_.Name -Online}
```
Get-WindowsCapability -Online | Where-Object {($_.State -notmatch 'Installed') -and ($_.Name -match 'rsat')} | %{Add-WindowsCapability -Name $_.Name -Online}
Вариант второй &#8212; DISM.
Для установки пакетов RSAT через DISM, выполните следующие команды:
```
DISM.exe /Online /add-capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 /CapabilityName:Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0 /CapabilityName:Rsat.CertificateServices.Tools~~~~0.0.1.0 /CapabilityName:Rsat.DHCP.Tools~~~~0.0.1.0 /CapabilityName:Rsat.Dns.Tools~~~~0.0.1.0 /CapabilityName:Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.FileServices.Tools~~~~0.0.1.0 /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.IPAM.Client.Tools~~~~0.0.1.0 /CapabilityName:Rsat.LLDP.Tools~~~~0.0.1.0 /CapabilityName:Rsat.NetworkController.Tools~~~~0.0.1.0 /CapabilityName:Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0 /CapabilityName:Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0 /CapabilityName:Rsat.ServerManager.Tools~~~~0.0.1.0 /CapabilityName:Rsat.Shielded.VM.Tools~~~~0.0.1.0 /CapabilityName:Rsat.StorageReplica.Tools~~~~0.0.1.0 /CapabilityName:Rsat.VolumeActivation.Tools~~~~0.0.1.0 /CapabilityName:Rsat.WSUS.Tools~~~~0.0.1.0 /CapabilityName:Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.SystemInsights.Management.Tools~~~~0.0.1.0
```
DISM.exe /Online /add-capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 /CapabilityName:Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0 /CapabilityName:Rsat.CertificateServices.Tools~~~~0.0.1.0 /CapabilityName:Rsat.DHCP.Tools~~~~0.0.1.0 /CapabilityName:Rsat.Dns.Tools~~~~0.0.1.0 /CapabilityName:Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.FileServices.Tools~~~~0.0.1.0 /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.IPAM.Client.Tools~~~~0.0.1.0 /CapabilityName:Rsat.LLDP.Tools~~~~0.0.1.0 /CapabilityName:Rsat.NetworkController.Tools~~~~0.0.1.0 /CapabilityName:Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0 /CapabilityName:Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0 /CapabilityName:Rsat.ServerManager.Tools~~~~0.0.1.0 /CapabilityName:Rsat.Shielded.VM.Tools~~~~0.0.1.0 /CapabilityName:Rsat.StorageReplica.Tools~~~~0.0.1.0 /CapabilityName:Rsat.VolumeActivation.Tools~~~~0.0.1.0 /CapabilityName:Rsat.WSUS.Tools~~~~0.0.1.0 /CapabilityName:Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.SystemInsights.Management.Tools~~~~0.0.1.0
Сам список пакетов ниже:
```
Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0
Rsat.CertificateServices.Tools~~~~0.0.1.0
Rsat.DHCP.Tools~~~~0.0.1.0
Rsat.Dns.Tools~~~~0.0.1.0
Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0
Rsat.FileServices.Tools~~~~0.0.1.0
Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0
Rsat.IPAM.Client.Tools~~~~0.0.1.0
Rsat.LLDP.Tools~~~~0.0.1.0
Rsat.NetworkController.Tools~~~~0.0.1.0
Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0
Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0
Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0
Rsat.ServerManager.Tools~~~~0.0.1.0
Rsat.Shielded.VM.Tools~~~~0.0.1.0
Rsat.StorageReplica.Tools~~~~0.0.1.0
Rsat.VolumeActivation.Tools~~~~0.0.1.0
Rsat.WSUS.Tools~~~~0.0.1.0
Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0
Rsat.SystemInsights.Management.Tools~~~~0.0.1.0
```
Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0Rsat.CertificateServices.Tools~~~~0.0.1.0Rsat.DHCP.Tools~~~~0.0.1.0Rsat.Dns.Tools~~~~0.0.1.0Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0Rsat.FileServices.Tools~~~~0.0.1.0Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0Rsat.IPAM.Client.Tools~~~~0.0.1.0Rsat.LLDP.Tools~~~~0.0.1.0Rsat.NetworkController.Tools~~~~0.0.1.0Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0Rsat.ServerManager.Tools~~~~0.0.1.0Rsat.Shielded.VM.Tools~~~~0.0.1.0Rsat.StorageReplica.Tools~~~~0.0.1.0Rsat.VolumeActivation.Tools~~~~0.0.1.0Rsat.WSUS.Tools~~~~0.0.1.0Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0Rsat.SystemInsights.Management.Tools~~~~0.0.1.0
Получить этот список можно через Powershell, выполнив следующую команду:
```
Get-WindowsCapability -Online | Where-Object {($_.Name -match 'rsat')}
```
Get-WindowsCapability -Online | Where-Object {($_.Name -match 'rsat')}
&nbsp;
&nbsp;
