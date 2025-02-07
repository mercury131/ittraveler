#                 	Настраиваем SFTP chroot на OpenSSH.                	  
***            ***

			
            
		
    
	
    	  Дата: 24.04.2017 Автор Admin  
	Иногда нужно ограничить пользователя правами только на подключение по SFTP , без возможности выполнения команд на сервере.
Давайте рассмотрим как это сделать.
Первое, убедитесь что у вас версия openssh не ниже OpenSSH 4.9+
На Ubuntu это можно сделать следующей командой:
dpkg -s openssh-server | grep Version
Теперь создаем новую группу, в которую должны входить пользователи которым необходим доступ только по SFTP
groupadd sftponly
Далее открываем конфиг openssh (/etc/ssh/sshd_config) и вносим в него следующие параметры:
Match Group sftponly
  ChrootDirectory %h
  ForceCommand internal-sftp
  AllowTcpForwarding no
  PermitTunnel no
  X11Forwarding no
Этими настройками мы указываем настройки chroot для этой группы.
Перезапускаем службу openssh для применения изменений
service ssh restart
Теперь добавляем пользователя (например USER) в группу
gpasswd -a USER sftponly
Далее установим владельцем chroot каталога пользователя пользователя root
chown root:root /home/user
Отключаем пользователю возможность использовать Shell
usermod -s /bin/false user
Теперь при подключении пользователю USER будет доступен только доступ по SFTP, выполнять команды на сервере пользователь не сможет.
Чтобы немного сэкономить время, можно вот так добавлять новых пользователей
usermod -g sftponly username
usermod -s /bin/false username
Вот и все, удачной вам настройки!
Related posts:Настройка отказоустойчивого веб сервера на базе nginx и apache.Настройка ZFS в ProxmoxQEMU/KVM проброс физического диска гипевизора в виртуальную машину
        
             Bash, Linux, Ubuntu, Web/Cloud, Без рубрики 
             Метки: chroot, Linux, openssh, sftp, ssh, Ubuntu  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
