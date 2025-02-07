#                 	Выполняем команды внутри гостевых ОС через PowerCLI                	  
***            ***

			
            
		
    
	
    	  Дата: 22.06.2016 Автор Admin  
	Порой нужно запустить скрипт на множестве VM, или выполнить одну и туже команду.
Под катом я расскажу как выполнять команды внутри гостевых ОС через PowerCLI
Поможет нам скрипт:
function Load-PowerCLI
{
    Add-PSSnapin VMware.VimAutomation.Core
    Add-PSSnapin VMware.VimAutomation.Vds
}

Load-PowerCLI

# Connect to Vcenter

$vcenter=""

Connect-VIServer -Server $vcenter #-User -Password


$csv='C:\VM-invokeScript.csv'

Import-Csv $csv -Delimiter ";"| % {

$vcenteruser = $_.vcenteruser; 
$vcenterpass = $_.vcenterpass; 
$vm = $_.vm; 
$guestuser = $_.guestuser; 
$guestpass = $_.guestpass; 
$vcenter = $_.vcenter;

Connect-VIServer -Server $vcenter -User $vcenteruser -Password $vcenterpass

$script1 = 'Your batch file patch or command'

$script2 = '\\test.local\fileshare\bat\run.bat'

Invoke-VMScript -ScriptText $script1 -VM $vm -Server $vcenter -GuestUser $guestuser -GuestPassword $guestpass -ScriptType Bat

Invoke-VMScript -ScriptText $script2 -VM $vm -Server $vcenter -GuestUser $guestuser -GuestPassword $guestpass -ScriptType Bat



disconnect-viserver -Server $vcenter -confirm:$false

}


# Disconnect Vcenter

Disconnect-VIServer $vcenter -Confirm:$false

  function Unload-PowerCLI
{
    Remove-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue
    Remove-PSSnapin VMware.VimAutomation.Vds -ErrorAction SilentlyContinue
   
}

Unload-PowerCLI
Заполняем переменные:
$vcenter &#8212; ваш vcenter сервер
$csv &#8212; путь к файлу с параметрами
Создайте CSV файл с параметрами, следующего вида:
vcenteruser;vcenterpass;guestuser;guestpass;vm;vcenter
user;your_pass;localOSuser;PASS;vm01;vcenter.test.local
user;your_pass;localOSuser;PASS;vm02;vcenter.test.local
user;your_pass;localOSuser;PASS;vm03;vcenter.test.local
user;your_pass;localOSuser;PASS;vm04;vcenter.test.local
&nbsp;
Заполняется файл так:
Логин и пароль к Vcenter; Пользователь гостевой ОС пароль к пользователю гостевой ОС; имя vcenter сервера
user;your_pass;localOSuser;PASS;vm01;vcenter.test.local
Далее в скрипте указываются команды:
$script1 = &#8216;Your batch file patch or command&#8217;
$script2 = &#8216;\\test.local\fileshare\bat\run.bat&#8217;
Замените содержимое этих переменных на ваши команды.
Далее просто запустите скрипт.
Если команды не запускаются проверьте запущены ли vmware tools, включена ли VM, корректные ли логин и пароль к гостевой ОС.
Related posts:Автоматический перенос старых перемещаемых профилей в архив с помощью Powershell.Поиск старых почтовых ящиков в Exchange 2010Настройка HA кластера Hyper-V
        
             PowerShell, Виртуализация 
             Метки: powercli, vsphere  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
