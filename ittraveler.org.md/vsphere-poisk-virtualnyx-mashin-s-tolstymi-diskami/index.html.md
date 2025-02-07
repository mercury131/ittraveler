#                 	Vsphere. Поиск виртуальных машин с толстыми дисками                	  
***            ***

			
            
		
    
	
    	  Дата: 23.05.2016 Автор Admin  
	Иногда, требуется найти на датасторе виртуальные машины с толстыми дисками.
Это не вызывает проблем, если виртуальных машин немного, но если их тысяча?
Под катом я покажу как через PowerCLI найти машины с толстыми дисками.
В решении данной задачи нам поможет следующий скрипт:
Add-PSSnapin VMware.VimAutomation.Core

 
$vcenter="vcenter.test.local"

$datastore="Datastore01"

connect-VIServer -Server $vcenter #-User -Password
get-datastore $datastore | get-vm | get-view | %{
 $name = $_.name
 $_.Config.Hardware.Device | where {$_.GetType().Name -eq "VirtualDisk"} | %{
  if(!$_.Backing.ThinProvisioned){
   "$name has a thick provisioned disk"
  }
 }
}


Disconnect-VIServer $vcenter -Confirm:$false

remove-PSSnapin VMware.VimAutomation.Core
Заполняем переменные:
$vcenter &#8212; ваш сервер vcenter
$datastore &#8212; ваш датастор
Вывод скрипта будет таким:
vm01 has a thick provisioned disk
vm02 has a thick provisioned disk
vm03 has a thick provisioned disk
Кстати, если вам нужно найти машины с тонкими дисками, воспользуйтесь этим скриптом:
Add-PSSnapin VMware.VimAutomation.Core
$vcenter="vcenter.test.local"

$datastore="Datastore01"

connect-VIServer -Server $vcenter #-User -Password
get-datastore $datastore | get-vm | get-view | %{
 $name = $_.name
 $_.Config.Hardware.Device | where {$_.GetType().Name -eq "VirtualDisk"} | %{
  if($_.Backing.ThinProvisioned){
   "$name has a thin provisioned disk"
  }
 }
}


Disconnect-VIServer $vcenter -Confirm:$false

remove-PSSnapin VMware.VimAutomation.Core
&nbsp;
Related posts:LVM переезд с диска на диск в виртуальной среде.Установка и настройка дедупликации  на Windows Server 2012 R2QEMU/KVM проброс физического диска гипевизора в виртуальную машину
        
             PowerShell, Виртуализация 
             Метки: powercli, Powershell, vmware  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
