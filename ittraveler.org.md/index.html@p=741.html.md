# Установка и настройка дедупликации  на Windows Server 2012 R2                	  
***Дата: 03.06.2016 Автор Admin***

В данной статье я расскажу как легко и быстро можно настроить дедупликацию через Powershell.
1) Устанавливаем роль дедупликации.
PowerShell
```
Import-Module ServerManager
Add-WindowsFeature -name FS-Data-Deduplication
Import-Module Deduplication
```
Import-Module ServerManagerAdd-WindowsFeature -name FS-Data-DeduplicationImport-Module Deduplication
2) Включаем дедупликацию. В данном случае на диске E
PowerShell
```
Enable-DedupVolume E: -UsageType Default
```
Enable-DedupVolume E: -UsageType Default
Если вы планируете дедуплицировать хранилище дисков виртуальных машин Hyper-v, используйте следующую команду:
PowerShell
```
Enable-DedupVolume E: -UsageType HyperV
```
Enable-DedupVolume E: -UsageType HyperV
3) Задаем минимальное количество дней, после которых выполняется дедупликация файлов
PowerShell
```
Set-Dedupvolume E: -MinimumFileAgeDays 20
```
Set-Dedupvolume E: -MinimumFileAgeDays 20
Если необходимо дедупликацировать файлы сразу и вам необходима максимальная дедупликация установите значение 0
4) Добавляем каталог, который не нужно дедупликацировать (если необходимо)
PowerShell
```
Set-DedupVolume –Volume "E:" -ExcludeFolder "E:\temp"
```
Set-DedupVolume –Volume "E:" -ExcludeFolder "E:\temp"
5) Устанавливаем минимальный размер файла
PowerShell
```
Set-DedupVolume –Volume "E:" -MinimumFileSize "32768"
```
Set-DedupVolume –Volume "E:" -MinimumFileSize "32768"
6) Отключаем дедупликацию используемых файлов
PowerShell
```
Set-DedupVolume –Volume "E:" -OptimizeInUseFiles:$False
Set-DedupVolume –Volume "E:" -OptimizePartialFiles:$False
```
Set-DedupVolume –Volume "E:" -OptimizeInUseFiles:$False&nbsp;Set-DedupVolume –Volume "E:" -OptimizePartialFiles:$False
Для просмотра текущих запущенных заданий дедупликации выполните команду:
PowerShell
```
Get-DedupJob
```
Get-DedupJob
Для просмотра существующих заданий используйте команду:
PowerShell
```
Get-DedupSchedule
```
Get-DedupSchedule
Если вы хотите добавить новое задание используйте команду &#8212; New-DedupSchedule
Ниже пример как добавить задание оптимизации:
PowerShell
```
New-DedupSchedule –Name "ThroughputOptimization" –Type Optimization –Days on,Tues,Wed,Thurs,Fri,Sunday –Start 00:00 –DurationHours 8 -Priority Normal
```
New-DedupSchedule –Name "ThroughputOptimization" –Type Optimization –Days on,Tues,Wed,Thurs,Fri,Sunday –Start 00:00 –DurationHours 8 -Priority Normal
Теперь разберем этот пример
–Name &#8212; имя нового задания
–Type тип задания (Optimization/GarbageCollection/Scrubbing)
Scrubbing &#8212; восстановление поврежденных данных
GarbageCollection &#8212; сборка мусора (высвобождение места)
Optimization &#8212; дедупликация и сжатие данных
–Days дни в которые задание должно запускаться
&#8212;Start в какое время
–DurationHours сколько часов может выполняться задание
&#8212;Priority приоритет
Для просмотра текущего статуса дедупликации используйте команду:
PowerShell
```
Get-DedupVolume
```
Get-DedupVolume
Вывод будет таким:
Enabled    UsageType      SavedSpace      SavingsRate    Volume
&#8212;&#8212;-         &#8212;&#8212;&#8212;             &#8212;&#8212;&#8212;-           &#8212;&#8212;&#8212;&#8212;         &#8212;&#8212;
True           Default             76.94 GB            66 %                 E:
В моем случае дедупликация превратила 65 GB в 354MB.
Это очень эффективно!  Удачной настройки! =)
