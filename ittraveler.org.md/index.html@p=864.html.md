# Сброс настроек GPO на стандартные                	  
***Дата: 12.05.2017 Автор Admin***

Иногда, после вывода машины из домена Active Directory нужно сбросить все примененные ранее настройки GPO на стандартные. Давайте рассмотрим на примере Windows 10 как легко это сделать.Сделать это очень просто, выполним 3 команды:
Сброс политик безопасности:
```
secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose
```
secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose
Удаление настроек GPO:
```
RD /S /Q "%WinDir%\System32\GroupPolicyUsers"
```
RD /S /Q "%WinDir%\System32\GroupPolicyUsers"
```
RD /S /Q "%WinDir%\System32\GroupPolicy"
```
RD /S /Q "%WinDir%\System32\GroupPolicy"
Далее просто перезагрузите компьютер.
