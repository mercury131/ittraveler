# Автоматизируем бэкап баз данных MSSQL Express                	  
***Дата: 26.05.2015 Автор Admin***

В данной статье мы рассмотрим как настроить автоматическое резервное копирование баз данных MSSQL расположенных на бесплатном MSSQL Express.
Для автоматизации резервного копирования напишем следующий sql скрипт:
MySQL
```
declare @path varchar(max)=N'C:\Backup\BASE_backup_'+convert(varchar(max),getdate(),102)
BACKUP DATABASE [BASE_NAME] TO  DISK = @path  WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'BASE_NAME-Полная База данных Резервное копирование', SKIP, NOREWIND, NOUNLOAD,   STATS = 10
GO
```
declare @path varchar(max)=N'C:\Backup\BASE_backup_'+convert(varchar(max),getdate(),102)BACKUP DATABASE [BASE_NAME] TO&nbsp;&nbsp;DISK = @path&nbsp;&nbsp;WITH&nbsp;&nbsp;COPY_ONLY, NOFORMAT, NOINIT,&nbsp;&nbsp;NAME = N'BASE_NAME-Полная База данных Резервное копирование', SKIP, NOREWIND, NOUNLOAD,&nbsp;&nbsp; STATS = 10GO
Кодировка скрипта должны быть &#8212; UCS-2 Little Endian
Рассмотрим параметры скрипта:
Путь куда сохранять резервные копии указывается тут &#8212; C:\Backup\
Имя резервной копии будет начинаться с BASE_backup_ и заканчиваться датой резервного копирования.
Имя базы, которую мы будем сохранять задается тут:
```
BACKUP DATABASE [BASE_NAME]
```
BACKUP DATABASE [BASE_NAME]
И тут:
```
NAME = N'BASE_NAME
```
NAME = N'BASE_NAME
(adsbygoogle = window.adsbygoogle || []).push({});
Далее открываем планировщик задач Windows и создаем новую задачу.
В поле &#171;действие&#187; выбираем &#171;Запуск программы&#187;
Путь к программе &#8212; &#171;C:\Program Files\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE&#187;
Аргументы &#8212; -S \sqlexpress  -i &#171;C:\Backup_ScriptDir\backup.sql&#187;
Рассмотрим параметры:
-S \sqlexpress путь к инстансу MSSQL, в данном примере инстанс sqlexpress
Если у вас используется локальный инстанс укажите просто \
-i &#171;C:\Backup_ScriptDir\backup.sql&#187; путь к созданному SQL скрипту.
Готово! Теперь резервное копирование MSSQL баз автоматизированно!
