#                 	Установка и настройка Lync 2013                	  
***            ***

			
            
		

    




	
    	  Дата: 27.07.2015 Автор Admin  
	Если вам нужно развернуть в своей инфраструктуре Lync 2013, прошу под кат.
Ниже рассмотрена установка сервера Lync 2013 Standard
1) Устанавливаем Silverlight, скачать его можно тут
2) Запускаем Powershell от имени администратора и устанавливаем необходимые компоненты:

		
		
			
			
			
```
Add-WindowsFeature Web-Server, Web-Static-Content, Web-Default-Doc, Web-Scripting-Tools, Web-Windows-Auth, Web-Asp-Net, Web-Log-Libraries, Web-Http-Tracing, Web-Stat-Compression, Web-Default-Doc, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Http-Errors, Web-Http-Logging, Web-Net-Ext, Web-Client-Auth, Web-Filtering, Web-Mgmt-Console, Web-Asp-Net45, Web-Net-Ext45, Web-Dyn-Compression, Web-Mgmt-Console, Desktop-Experience
```
			
				
					
				
					1
				
						Add-WindowsFeature Web-Server, Web-Static-Content, Web-Default-Doc, Web-Scripting-Tools, Web-Windows-Auth, Web-Asp-Net, Web-Log-Libraries, Web-Http-Tracing, Web-Stat-Compression, Web-Default-Doc, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Http-Errors, Web-Http-Logging, Web-Net-Ext, Web-Client-Auth, Web-Filtering, Web-Mgmt-Console, Web-Asp-Net45, Web-Net-Ext45, Web-Dyn-Compression, Web-Mgmt-Console, Desktop-Experience
					
				
			
		

3) Перезагружаемся
4) Создаем DNS записи типа A в локальном домене:
admin
dialin
meet
sip
Так же создаем srv запись _sipinternals
5) Запускаем setup.exe с установочного диска Lync
И устанавливаем компоненты Lync 2013
6) Далее запуститься мастер развертывания Lync. Запустите подготовку Active Directory.
7) Подготовьте схему, далее дождитесь пока пройдет репликация. После этого запустите подготовку леса.
После подготовки мастер должен выглядеть так:
8) Добавьте будущих администраторов Lync в группу CSAdministrator
9) Далее вернитесь в мастер и выберите пункт &#8212; подготовить сервер Standard edition. Предварительно установите компонент &#8212; Windows Identity foundation.
&nbsp;
10) Теперь установим средства администрирования.
11) Теперь открываем пуск и запускаем мастер построения топологии
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Выбираем &#8212; создать топологию
Указываем sip домен
&nbsp;
Указываем дополнительные домены
Указываем описание сайта
Указываем регион
Готово
12) Настраиваем пул Lync
Указываем имя сервера
Далее включаем следующие функции
Указываем совмещенное расположение ролей
Т.к. у нас нет пограничного пула, галочку не ставим.
Оставляем стандартные настройки SQL
Теперь создайте на диске С папку share и предоставьте общий доступ группам указанным на скриншоте
Группе &#171;все&#187; установлен доступ на чтение, остальным группам на чтение и запись
Указываем хранилище файлов
Указываем внешний URL адрес
Не связываем пул с сервером приложений, т.к. его нет.
Далее открываем свойства топологии
И указываем центральный сервер управления и адрес для администрирования.
Публикуем топологию.
Готово, новая топология опубликована.
13) Возвращаемся в мастер развертывания Lync и выбираем установку системы Lync 2013
14) Устанавливаем локальное хранилище конфигурации.
Получаем данные из центрального хранилища
Далее устанавливаем компоненты Lync
Перейдем к шагу 3, установке сертификатов.
Выполняем запрос на сертификат по умолчанию.
Отправляем запрос в локальный центр сертификации.
Выбираем центр сертификации.
Указываем учетные данные (если нужно)
Пропускаем выбор шаблона.
Вводим понятное имя сертификата
Указываем сведения об организации:
Вводим местоположение
Далее идет список доменных имен добавляемых в сертификат
Далее указываем для каких sip доменов создается сертификат.
Добавляем альтернативные имена субъектов (если нужно)
Далее проверяем что все введено верно и выполняем запрос на  сертификат.
Назначаем сертификат серверу Lync.
Готово.
По аналогии запрашиваем и назначаем сертификат &#171;OAuthTokenIssuer&#187;
Должно получиться так:
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Возвращаемся в мастер развертывания и запускаем службы (шаг 4)
Далее проверим обновления.
Теперь установим все Cumulative Update.
За это отвечает обновление KB 2809243
Скачиваем его и запускаем.
Утилита автоматически поверит наличие обновлений.
Установим все обновления нажав &#171;Install Updates&#187;
Перезагружаемся после установки обновлений.
Теперь открываем web интерфейс Lync, перейдя по dns имени admin (в моем случае admin.test.com)
Перейдем в раздел &#171;Пользователи&#187; и добавим нового пользователя Lync.
Выбираем пользователя, указываем пул, URI и параметры телефонии.
&nbsp;
Иногда при развертывании возникают проблемы с EWS. (Ошибка &#8212; Службы EWS не развернуты)
Для решения данной проблемы убедитесь что в домене создана srv dns запись из начала статьи.
Далее перейдите на Exchange сервер и откройте Powershell
Изменяем тип аутентификации у виртуального каталога Autodiscover

		
		
			
			
			
```
Get-AutodiscoverVirtualDirectory | Set-AutodiscoverVirtualDirectory  -BasicAuthentication $true
```
			
				
					
				
					1
				
						Get-AutodiscoverVirtualDirectory | Set-AutodiscoverVirtualDirectory&nbsp;&nbsp;-BasicAuthentication $true
					
				
			
		

Далее создайте либо используйте существующий адрес указывающий на Exchange сервер с ролью CAS.
Я создал ews.test.com
Теперь настроим EWS

		
		
			
			
			
```
Get-WebServicesVirtualDirectory | Set-WebServicesVirtualDirectory -ExternalUrl https://ews.external.com/EWS/exchange.asmx -InternalUrl https://ews.test.com/EWS/exchange.asmx -BasicAuthentication $true
```
			
				
					
				
					1
				
						Get-WebServicesVirtualDirectory | Set-WebServicesVirtualDirectory -ExternalUrl https://ews.external.com/EWS/exchange.asmx -InternalUrl https://ews.test.com/EWS/exchange.asmx -BasicAuthentication $true
					
				
			
		

Соответственно измените адреса на свои.
Так же важно чтобы адрес указанный в команде выше фигурировал в сертификате Exchange
Например так:
Теперь активируем сохраняемый чат.
Открываем Web интерфейс Lync и переходим в раздел &#8212; Сохраняемый чат -&gt; Политика сохраняемого чата
Далее нажимаем изменить и открываем свойства политики.
Устанавливаем галочку &#171;Разрешить сохраняемый чат&#187;
Теперь откроем мастер топологии и настроим архивацию сообщений.
Создаем пул сохраняемого чата.
Указываем сервер.
Указываем стандартное хранилище SQL
Указываем хранилище файлов
Публикуем топологию.
Теперь клиент пользователя будет выглядеть так:
На этом базовая настройка Lync server 2013 завершена.
Удачной установки =)
&nbsp;
