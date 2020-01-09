# Новые компьютеры не появляются на WSUS сервере                	  
***Дата: 17.08.2018 Автор Admin***

Если вы используете различные инструменты деплоя ОС из образов или имеете большое количество виртуальных машин, то наверняка замечали что далеко не все развернутые ОС отправляют отчет на сервер WSUS или вообще пропадают с сервера.
В этой статье я расскажу почему так происходит и как с этим боротьсяПредположим вы деплоите ваши рабочие станции из эталонного образа ОС или клонируете виртуальные машины из преднастроенного шаблона, скорее всего после или во время деплоя вы запускаете на них sysprep, но обнуляете ли вы SusClientId ?  =)
Тут то и кроется корень проблемы, после клонирования у машин остается один и тот же SusClientId.
Посмотреть его можно в реестре, по следующему пути:
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate
Значения которые нам нужны называются &#8212; SusClientId и SusClientIdValidation.
Данные значения должны быть уникальными на каждой машине, если это не так, то машины будут перерегистрироваться на WSUS затирая таким образом соседей с таким же SusClientId.
Чтобы это исправить нужно выполнить следующие команды:
```
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientId"
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientIdValidation"
wuauclt /resetauthorization /detectnow
```
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientId"reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientIdValidation"wuauclt /resetauthorization /detectnow
После этого машина сбросит авторизацию на WSUS и зарегистрируется с новым, уникальным SusClientId.
Если вы хотите выполнить эту операцию массово, на всех машинах в домене или на таргетированной группе, можете создать GPO со следующим logon скриптом:
```
@echo off
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientId"
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientIdValidation"
net stop WUAUServ
timeout 10
net start WUAUServ
timeout 10
wuauclt /resetauthorization /detectnow
```
@echo offreg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientId"reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientIdValidation"net stop WUAUServtimeout 10net start WUAUServtimeout 10wuauclt /resetauthorization /detectnow
В качестве альтернативы logon скрипту, можно создать через GPO scheduled task на завершение работы ПК пользователя или с каким-то другим расписанием.
После этих манипуляций число машин на WSUS сервере должно существенно вырасти.
