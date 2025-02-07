#                 	Запуск команд внутри гостевых ОС в гипервизоре KVM на примере Proxmox                	  
***            ***

			
            
		
    
	
    	  Дата: 18.03.2019 Автор Admin  
	
В VMware, с помощью Powercli, есть возможность запускать команды внутри гостевых ОС с помощью командлета Invoke-VMScript , это очень удобно, ведь с помощью этого механизма можно выполнить необходимые команды на сотне VM, не открывая на них консоль.
Работая с KVM мне захотелось найти аналог данного механизма, чтобы запускать команды из консоли гипервизора порямо на гостевых ОС, по аналогии с VMware.
В данной статье мы рассмотрим как использовать qemu агент для выполнения задуманного.
Для начала установите qemu агент, взять его можно по ссылке
Для установки в Linux используйте слеющие команды:
apt-get install qemu-guest-agent
yum install qemu-guest-agent
После установки агента внутри виртуальной машины, нужно активировать его поддержку в настройках VM, вот так активированный агент для VM выглядит в Proxmox:
Если вы используете libvirt, то xml код будет примерно такой:
&lt;channel type='unix'&gt;
   &lt;source mode='bind' path='/var/lib/libvirt/qemu/f16x86_64.agent'/&gt;
   &lt;target type='virtio' name='org.qemu.guest_agent.0'/&gt;
&lt;/channel&gt;
Теперь включите VM, с помощью команды qm ping, можно убедиться что агент внутри VM функционирует нормально.
Если команда
qm ping 101
где 101 &#8212; это ID вашей VM, не вернула ничего &#8212; значит агент функционирует нормально.
Теперь рассмотрим как запускать команды внутри VM с windows из консоли гипервизора KVM (он же в данном случае Proxmox)
Чтобы подключиться к сессии VM, выполните команду, где 101 &#8212; ID вашей VM
socat /var/run/qemu-server/101.qga -
Теперь нам нужно передать команду внутрь гостевой ОС, команды передаются в формате JSON.
Для примера отправим команду на перезапуск гостевой ОС
{"execute":"guest-exec", "arguments":{"path":"cmd.exe","arg":["/c","shutdown", "-r", "-f"]}}
Данная команда перезагрузит вашу VM.
По аналогии можно перезагрузить VM без использования cmd:
{"execute":"guest-exec", "arguments":{"path":"shutdown.exe","arg":["-r", "-f"]}}
или например та же перезагрузка, только с помощью powershell:
{"execute":"guest-exec", "arguments":{"path":"powershell.exe","arg":["-command","restart-computer", "-force"]}}
Вот так к примеру можно запустить sysprep:
{"execute":"guest-exec", "arguments":{"path":"c:\\windows\\system32\\sysprep\\sysprep.exe","arg":["/oobe", "/generalize", "/reboot"]}}
Если вы не хотите подключаться к сессии агента, а просто отправить команду одной строкой &#8212; используйте echo и отправляйте команду в socat:
echo '{"execute":"guest-exec", "arguments":{"path":"c:\\windows\\system32\\sysprep\\sysprep.exe","arg":["/oobe", "/generalize", "/reboot"]}}' | socat /var/run/qemu-server/101.qga -
Обратите внимание что слеши и спец символы в JSON экранируются, поэтому, перед тем как отправлять команду гостю &#8212; проверьте что синтаксис корректный.
Если не уверены, то всегда можно воспользоваться командой ConvertTo-Json в Powershell, например:
'cmd.exe "с:\windows\system32\sysprep.exe /oobe"' | ConvertTo-Json
на выходе получите строку, с экранированным выводом:
"cmd.exe \"с:\\windows\\system32\\sysprep.exe /oobe\""
На этом все.
В следующей статье рассмотрим как можно автоматизировать процесс деплоя и ввода в домен AD, VM на базе KVM.
Удачной настройки!
&nbsp;
&nbsp;
&nbsp;
&nbsp;
Related posts:LVM переезд с диска на диск в виртуальной среде.Настройка дисковых квот в UbuntuClickhouse ошибка DB::Exception: Replica already exists..
        
             Bash, Debian, Linux, Без рубрики, Виртуализация 
               
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
