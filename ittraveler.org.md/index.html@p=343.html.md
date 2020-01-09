# Отключение Skype UI в Lync 2013                	  
***Дата: 15.04.2015 Автор Admin***

Я думаю многие заметили что после обновления интерфейс Lync 2013 изменился, и теперь он называется Skype for Business.
В данной статье я расскажу как вернуть прежний внешний вид клиенту Lync 2013.
Определить что Skype UI включен очень просто, новый интерфейс встречает нас такой надписью:
Первое что нужно сделать, так это установить все обновления на сервер Lync 2013.
Далее для отключения Skype UI у всех пользователей Lync выполним команду в Powershell
```
Set-CsClientPolicy -Identity Global -EnableSkypeUI $false
```
Set-CsClientPolicy -Identity Global -EnableSkypeUI $false
Если вы хотите отключить Skype UI только для определенного сайта, выполните следующую команду:
```
Set-CsClientPolicy -Identity site:YourSite -EnableSkypeUI $false
```
Set-CsClientPolicy -Identity site:YourSite -EnableSkypeUI $false
Если вы хотите включить Skype UI только для некоторых пользователей то создайте новую политику командой
```
New-CsClientPolicy -Identity YourPolicyName -EnableSkypeUI $true
```
New-CsClientPolicy -Identity YourPolicyName -EnableSkypeUI $true
В данной команде уже включен Skype UI
Теперь назначим пользователям эту политику
```
Get-CsUser -LDAPFilter "Department=YourDepartment" | Grant-CsClientPolicy -PolicyName YourPolicyName
```
Get-CsUser -LDAPFilter "Department=YourDepartment" | Grant-CsClientPolicy -PolicyName YourPolicyName
Однако при первом старте клиента Lync 2013, пользователь все равно будет видеть Skype UI.
Чтобы этого избежать добавьте в реестр следующее значение:
Ветка реестра &#8212; HKEY_CURRENT_USER\Software\Microsoft\Office\Lync
Тип параметра &#8212; REG_BINARY
Имя параметра &#8212; EnableSkypeUI
Значение &#8212; 00 00 00 00
Добавить его всем пользователям можно через групповую политику.
Как это сделать показано на скриншоте ниже:
