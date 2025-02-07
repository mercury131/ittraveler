#                 	Установка RSAT на Windows 10 1809                	  
***            ***

			
            
		
    
	
    	  Дата: 25.03.2019 Автор Admin  
	После обновления рабочей машины до версии Windows 10 1809, обнаружил что для нее нельзя скачать пакет RSAT с сайта Microsoft.
А после обновления версии до 1809 установленный ранее пакет RSAT был удален. В этой заметке я рассказу как быстро вернуть RSAT на место.
Теперь, начиная с версии 1809, пакет RSAT предоставляется как Windows Feature, поэтому его можно установить через интерфейс установки и удаления программ, либо DISM, либо Powershell.
Мы рассмотрим последние 2 варианта.
Вариант первый &#8212; Powershell.
Для установки RSAT выполните следующую команду:
Get-WindowsCapability -Online | Where-Object {($_.State -notmatch 'Installed') -and ($_.Name -match 'rsat')} | %{Add-WindowsCapability -Name $_.Name -Online}
Вариант второй &#8212; DISM.
Для установки пакетов RSAT через DISM, выполните следующие команды:
DISM.exe /Online /add-capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 /CapabilityName:Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0 /CapabilityName:Rsat.CertificateServices.Tools~~~~0.0.1.0 /CapabilityName:Rsat.DHCP.Tools~~~~0.0.1.0 /CapabilityName:Rsat.Dns.Tools~~~~0.0.1.0 /CapabilityName:Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.FileServices.Tools~~~~0.0.1.0 /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.IPAM.Client.Tools~~~~0.0.1.0 /CapabilityName:Rsat.LLDP.Tools~~~~0.0.1.0 /CapabilityName:Rsat.NetworkController.Tools~~~~0.0.1.0 /CapabilityName:Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0 /CapabilityName:Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0 /CapabilityName:Rsat.ServerManager.Tools~~~~0.0.1.0 /CapabilityName:Rsat.Shielded.VM.Tools~~~~0.0.1.0 /CapabilityName:Rsat.StorageReplica.Tools~~~~0.0.1.0 /CapabilityName:Rsat.VolumeActivation.Tools~~~~0.0.1.0 /CapabilityName:Rsat.WSUS.Tools~~~~0.0.1.0 /CapabilityName:Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0 /CapabilityName:Rsat.SystemInsights.Management.Tools~~~~0.0.1.0
Сам список пакетов ниже:
Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0
Rsat.CertificateServices.Tools~~~~0.0.1.0
Rsat.DHCP.Tools~~~~0.0.1.0
Rsat.Dns.Tools~~~~0.0.1.0
Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0
Rsat.FileServices.Tools~~~~0.0.1.0
Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0
Rsat.IPAM.Client.Tools~~~~0.0.1.0
Rsat.LLDP.Tools~~~~0.0.1.0
Rsat.NetworkController.Tools~~~~0.0.1.0
Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0
Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0
Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0
Rsat.ServerManager.Tools~~~~0.0.1.0
Rsat.Shielded.VM.Tools~~~~0.0.1.0
Rsat.StorageReplica.Tools~~~~0.0.1.0
Rsat.VolumeActivation.Tools~~~~0.0.1.0
Rsat.WSUS.Tools~~~~0.0.1.0
Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0
Rsat.SystemInsights.Management.Tools~~~~0.0.1.0
Получить этот список можно через Powershell, выполнив следующую команду:
Get-WindowsCapability -Online | Where-Object {($_.Name -match 'rsat')}
&nbsp;
&nbsp;
Related posts:Управление репликацией Active DirectoryУстановка и настройка кластера RabbitMQ на WindowsУстановка и настройка Lync 2013
        
             Windows, Без рубрики 
               
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
