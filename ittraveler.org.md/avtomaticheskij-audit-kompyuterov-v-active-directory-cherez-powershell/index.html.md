#                 	Автоматический аудит компьютеров в Active Directory через powershell.                	  
***            ***

			
            
		
    
	
    	  Дата: 10.06.2015 Автор Admin  
	В данной статье мы рассмотрим как автоматически проводить аудит компьютеров в Active Directory.
Я думаю многие системные администраторы ломали голову как вести учет за каким ПК какой пользователь работает, особенно если имена ПК статичны.
Для решения данной проблемы воспользуемся PowerShell.
Алгоритм данного скрипта будет таким:
1) Делаем выборку по всем пк, которые попадают под фильтр
2) Проверяем какой пользователь в настоящий момент работает за ПК
3) Переводим полученные данные в удобный формат
4) Записываем данные в отчет
5) Добавляем в описание компьютера имя пользователя
Внимание, данный скрипт подойдет тем администраторам, у которых рабочие места пользователей статичны.
Если в вашей организации пользователи постоянно пересаживаются с места на место, такой подход будет неудобен.
Перейдем к скрипту:
# Объявляем переменные

# область поиска
$OU="DC=domain,DC=local"

# Указываем Домен

$domain='DOMAIN'

# Указываем путь к отчету

$reportPatch="C:\PC_audit.csv"

#Импортируем модуль ActiveDirectory 
Import-Module ActiveDirectory
Remove-Item C:\PC_audit.csv

# Отбираем ПК по фильтру
Get-ADComputer -Filter * -SearchBase $OU  |



ForEach-Object {

#Переводим в переменную только имя ПК
$computer=($_).Name

# Узнаем какой пользователь работает на данном ПК и удаляем приставку с названием домена. 
$list=(gwmi win32_computersystem -comp $computer | select USername).USername -replace $domain

# Удаляем спец символы из полученного вывода
$list=[System.Text.RegularExpressions.Regex]::Replace("$list($7&amp;","[^1-9a-zA-Z_]"," ");

# Удаляем пробелы из полученного вывода
$list=$list -replace '\s',''

# Находим пользователя в ActiveDirectory по samaccountname и переводим в вывод Имя Фамилия
$list=(Get-ADUser $list).Name

# Выводим полученный результат на экран - ПК - Имя Фамилия
echo "$computer - $list"

# Записываем полученные данные в отчет
$result=(echo"$computer - $list")
$result=$result -replace '\s','' 

$result &gt;&gt; $reportPatch

 

# Добавляем Имя и Фамилию пользователя в описание ПК в Active Directory
Get-ADComputer $computer | Set-ADComputer -Description $list

}
(adsbygoogle = window.adsbygoogle || []).push({});
Если при выполнении скрипта будет ошибка:
gwmi : Сервер RPC недоступен.
Это означает что ПК выключен или на нем отключен WMI.
Теперь добавьте данный скрипт в планировщик задач, и запускайте за час до конца рабочего дня.
Скрипт актуализирует информацию о пользователях на работающих ПК.
Удачной установки =)
Related posts:Кастомизация гостевых ОС Windows в KVM на примере ProxmoxПеренос базы данных Active DirectoryАвтоматическая активация лицензий Office 365
        
             Active Directory, PowerShell, Windows, Windows Server 
             Метки: Active Directory, Powershell, Windows Server  
        
            
        
    
                        
                    
                    
                
        
                
	
		
		Добавить комментарий Отменить ответВаш адрес email не будет опубликован. Обязательные поля помечены *Комментарий * Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
	
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1890562251101921"
     data-ad-slot="9117958896"
     data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
			
        
        
		
        
           
    
    
  
	
    
		
        
             
			
                
                    
                                                  Все права защищены. IT Traveler 2025 
                         
                        
																														                    
                    
				
                
                
    
			
		                            
	
	
                
                
			
                
		
        
	
    
jQuery(document).ready(function($){
  $("a[rel*=lightbox]").colorbox({initialWidth:"30%",initialHeight:"30%",maxWidth:"90%",maxHeight:"90%",opacity:0.8,current:" {current}  {total}",previous:"",close:"Закрыть"});
});
  
    (function (d, w, c) {
        (w[c] = w[c] || []).push(function() {
            try {
                w.yaCounter27780774 = new Ya.Metrika({
                    id:27780774,
                    clickmap:true,
                    trackLinks:true,
                    accurateTrackBounce:true,
                    webvisor:true,
                    trackHash:true
                });
            } catch(e) { }
        });
        var n = d.getElementsByTagName("script")[0],
            s = d.createElement("script"),
            f = function () { n.parentNode.insertBefore(s, n); };
        s.type = "text/javascript";
        s.async = true;
        s.src = "https://mc.yandex.ru/metrika/watch.js";
        if (w.opera == "[object Opera]") {
            d.addEventListener("DOMContentLoaded", f, false);
        } else { f(); }
    })(document, window, "yandex_metrika_callbacks");
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-58126221-1', 'auto');
  ga('send', 'pageview');
