#                 	Удаление Lync Server 2013                	  
***            ***

			
            
		

    




	
    	  Дата: 27.07.2015 Автор Admin  
	Если вам нужно удалить MS Lync 2013 , и почистить инфраструктуру Active Directory от следов Lync 2013, прошу под кат.
1) Запускаем Powershell на сервере Lync от имени администратора.
2) Отключаем всех пользователей Lync командой:

		
		
			
			
			
```
Get-CsUser | Disable-CsUser
```
			
				
					
				
					1
				
						Get-CsUser | Disable-CsUser
					
				
			
		

3) Удаляем созданные конференции
Получаем конференции командой:

		
		
			
			
			
```
Get-CsConferenceDirectory
```
			
				
					
				
					1
				
						Get-CsConferenceDirectory
					
				
			
		

Из вывода команды запоминаем значение Identity
Удаляем конференции

		
		
			
			
			
```
Get-CsConferenceDirectory -Identity 1 | Remove-CsConferenceDirectory –force
```
			
				
					
				
					1
				
						Get-CsConferenceDirectory -Identity 1 | Remove-CsConferenceDirectory –force
					
				
			
		

4) Удаляем авторизованные приложения пула Lync 2013

		
		
			
			
			
```
Get-CsTrustedApplication | Remove-CsTrustedApplication –force
```
			
				
					
				
					1
				
						Get-CsTrustedApplication | Remove-CsTrustedApplication –force
					
				
			
		

5) Удаляем контакты Exchange UM

		
		
			
			
			
```
Get-CsExUmContact -Filter {RegistrarPool -eq "your_lync_server.domain.local"} | Remove-CsExUmContact
```
			
				
					
				
					1
				
						Get-CsExUmContact -Filter {RegistrarPool -eq "your_lync_server.domain.local"} | Remove-CsExUmContact
					
				
			
		

6) Удаляем контакты для групп

		
		
			
			
			
```
Get-CsRgsWorkflow -Identity:Service:ApplicationServer:your_lync.domain.local | Remove-CsRgsWorkflow
```
			
				
					
				
					1
				
						Get-CsRgsWorkflow -Identity:Service:ApplicationServer:your_lync.domain.local | Remove-CsRgsWorkflow
					
				
			
		

7) Удаляем контакты для конференций

		
		
			
			
			
```
Get-CsDialInConferencingAccessNumber | where {$_.Pool -eq "your_lyncserver.domain.local"} | Remove-CsDialInConferencingAccessNumber
```
			
				
					
				
					1
				
						Get-CsDialInConferencingAccessNumber | where {$_.Pool -eq "your_lyncserver.domain.local"} | Remove-CsDialInConferencingAccessNumber
					
				
			
		

8) Удаляем настройки AreaPhone и AnalogDevice

		
		
			
			
			
```
Get-CsCommonAreaPhone | Remove-CsCommonAreaPhone 
```
			
				
					
				
					1
				
						Get-CsCommonAreaPhone | Remove-CsCommonAreaPhone 
					
				
			
		



		
		
			
			
			
```
Get-CsAnalogDevice | Remove-CsAnalogDevice
```
			
				
					
				
					1
				
						Get-CsAnalogDevice | Remove-CsAnalogDevice
					
				
			
		

9) Удаляем настройки call park

		
		
			
			
			
```
Get-CsCallParkOrbit | Remove-CsCallParkOrbit  -Force
```
			
				
					
				
					1
				
						Get-CsCallParkOrbit | Remove-CsCallParkOrbit&nbsp;&nbsp;-Force
					
				
			
		

10) Удаляем голосовые маршруты

		
		
			
			
			
```
Get-CsVoiceRoute | Remove-CsVoiceRoute
```
			
				
					
				
					1
				
						Get-CsVoiceRoute | Remove-CsVoiceRoute
					
				
			
		

10) Откройте мастер построения топологий и удалите все шлюзы. Затем опубликуйте топологию
&nbsp;
12) Удалите EDGE сервер если он есть.
13) Отключите федерацию на сайте Lync и опубликуйте топологию.
14) В мастере построения топологии удалите развертывание
15) Если у вас имеется сервер frontend выполните на нем команду:

		
		
			
			
			
```
Publish-CsTopology -FinalizeUninstall
```
			
				
					
				
					1
				
						Publish-CsTopology -FinalizeUninstall
					
				
			
		

16) Удаляем развертывание через bootstrapper

		
		
			
			
			
```
cd "C:\Program Files\Microsoft Lync Server 2013\Deployment\"
```
			
				
					
				
					1
				
						cd "C:\Program Files\Microsoft Lync Server 2013\Deployment\"
					
				
			
		



		
		
			
			
			
```
.\bootstrapper.exe /scorch
```
			
				
					
				
					1
				
						.\bootstrapper.exe /scorch
					
				
			
		

17) Удаляем базы данных:

		
		
			
			
			
```
Uninstall-CsDatabase -DatabaseType Application –SqlServerFqdn your_lyncserver.domain.local –SqlInstanceName rtc
```
			
				
					
				
					1
				
						Uninstall-CsDatabase -DatabaseType Application –SqlServerFqdn your_lyncserver.domain.local –SqlInstanceName rtc
					
				
			
		



		
		
			
			
			
```
Uninstall-CsDatabase -CentralManagementDatabase –SqlServerFqdn your_lyncserver.domain.local -SqlInstanceName rtc
```
			
				
					
				
					1
				
						Uninstall-CsDatabase -CentralManagementDatabase –SqlServerFqdn your_lyncserver.domain.local -SqlInstanceName rtc
					
				
			
		

18) Удаляем хранилище SCP Central Management Store

		
		
			
			
			
```
Remove-CsConfigurationStoreLocation
```
			
				
					
				
					1
				
						Remove-CsConfigurationStoreLocation
					
				
			
		

19) Удаляем информацию о Lync server из Active Directory

		
		
			
			
			
```
Disable-CsAdDomain
```
			
				
					
				
					1
				
						Disable-CsAdDomain
					
				
			
		



		
		
			
			
			
```
Disable-CsAdForest
```
			
				
					
				
					1
				
						Disable-CsAdForest
					
				
			
		

&nbsp;
