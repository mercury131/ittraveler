#                 	Установка и настройка Puppet.                	  
***            ***

			
            
		
    
	
    	  Дата: 18.05.2015 Автор Admin  
	Установка и настройка Puppet.
В данной статье мы рассмотрим установку и настройку системы управления конфигурациями Puppet.
Устанавливать Puppet будем на Ubuntu 14.04 LTS.
Создайте DNS запись A для сервера Puppet.
Устанавливаем NTP клиент.
apt-get -y install ntp
Синхронизируем время на сервере Puppet и клиенте.
ntpdate pool.ntp.org
Скачиваем пакет Puppet Labs.
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
&nbsp;
Устанавливаем пакет.
dpkg -i puppetlabs-release-trusty.deb
Обновляем кэш пакетов .
apt-get update
Устанавливаем Puppet.
apt-get install puppetmaster-passenger
Фиксируем версию Puppet.
Просматриваем установленную версию.
puppet help | tail -n 1
Далее создаем файл /etc/apt/preferences.d/00-puppet.pref
В файле меняем версию на версию полученную из предыдущей команды (в примере это 3.6)
Package: puppet puppet-common puppetmaster-passenger
Pin: version 3.6*
Pin-Priority: 501
&nbsp;
Настройка сертификатов .
Удаляем установленные сертификаты.
sudo rm -rf /var/lib/puppet/ssl
Настраиваем конфигурацию Puppet. Для этого открывам файл конфигурации /etc/puppet/puppet.conf и приводим к виду:
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=$vardir/lib/facter
certname = puppet
dns_alt_names = puppet,puppet.nyc2.example.com

[master]
# These are needed when the puppetmaster is run by passenger
# and can safely be removed if webrick is used.
ssl_client_header = SSL_CLIENT_S_DN
ssl_client_verify_header = SSL_CLIENT_VERIFY
&nbsp;
В данном файле в секции dns_alt_names указываются DNS имена сервера Puppet.
Более подробную документацию по настройке конфигурации Puppet можно найти тут
Создаем новый сертификат.
puppet master --verbose --no-daemonize
Просматриваем сертификат.
puppet cert list -all
Запускаем Apache2
service apache2 start
Перейдем к установке Puppet агента на клиентскую машину.
Скачиваем пакет Puppet Labs
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
Устанавливаем пакет.
dpkg -i puppetlabs-release-trusty.deb
Обновляем кэш пакетов.
apt-get update
Устанавливаем Puppet agent.
apt-get install puppet
Включим Puppet агент.
Открываем файл &#8212; /etc/default/puppet
Изменяем содержимое на это:
START=yes
Блокируем версию Puppet.
Создаем файл /etc/apt/preferences.d/00-puppet.pref
В строке Pin: version указываем версию Puppet.
Перейдем к настройке агента.
Открываем файл /etc/puppet/puppet.conf
И в поле server указываем наш Puppet сервер.
[agent]
server = puppet.nyc2.example.com
&nbsp;
Запускаем сервис Puppet.
service puppet start
Для тестирования работоспособности выполните команду
puppet agent --test
Теперь перейдем на сервер Puppet и подпишем сертификат агента.
puppet cert sign "ubuntu01.domain.local"
Выполняем puppet agent &#8212;test еще раз
Вывод должен быть таким:
Info: Caching certificate for ca
Info: csr_attributes file loading from /etc/puppet/csr_attributes.yaml
Info: Creating a new SSL certificate request for ubuntu01.domain.local
Info: Certificate Request fingerprint (SHA256): 0E:7A:26:D9:45:29:31:7F:88:E0:AF:75:50:4E:B7:DE:C5:1F:A4:99:AE:6B:F8:2E:0E:8A:F9:37:5B:6C:DE:32
Info: Caching certificate for ca
Теперь рассмотрим примеры управления конфигурациями.
Перейдем на сервер Puppet.
Конфигурации Puppet хранятся в папке /etc/puppet/manifests
Создадим файл манифеста /etc/puppet/manifests/site.pp
Рассмотрим пример создания файла example, в папке /root с содержимым Test 123 с правами 644
В файл /etc/puppet/manifests/site.pp добавляем следующие строки:
file {'/root/example':
ensure =&gt; present,
mode =&gt; 0644,
content =&gt; "Test 123",
}
&nbsp;
Теперь откроем клиент и выполним puppet agent &#8212;test
Проверяем папку /root
Файл example создался.
Рассмотрим пример создания папки
file { "/etc/site-conf":
ensure =&gt; "directory",
}
&nbsp;
Создание папки с правами
file { "/var/log/admin-app-log":
ensure =&gt; "directory",
owner =&gt; "root",
group =&gt; "wheel",
mode =&gt; 750,
}
&nbsp;
Cron задание
cron { 'update_cron':
ensure =&gt; 'present',
command =&gt; '/bin/bash /root/update',
user =&gt; 'root',
hour =&gt; '12',
minute =&gt; '00',
weekday =&gt; '1',
}
&nbsp;
Установку deb пакета
package { "tzdata":
provider =&gt; dpkg,
ensure =&gt; latest,
source =&gt; "/home/user/tzdata_2014h-2_all.deb"
}
&nbsp;
Установка пакета из репозиториев
package { "screen":
ensure =&gt; "installed"
}
&nbsp;
Установка нескольких пакетов
package { "screen": ensure =&gt; "installed" }
package { "strace": ensure =&gt; "installed" }
package { "sudo": ensure =&gt; "installed" }
&nbsp;
Удаление пакетов
package { "screen":
ensure =&gt; "absent"
}
&nbsp;
Удаление пакета и конфигурационных файлов
package { "screen":
ensure =&gt; "purged"
}
&nbsp;
Выполнить команду
exec { "refresh_cache":
command =&gt; "refresh_cache 8600",
path =&gt; "/usr/local/bin/:/bin/",
# path =&gt; [ "/usr/local/bin/", "/bin/" ], # alternative syntax
}
&nbsp;
Запустить сервис
service { "cron":
ensure =&gt; "running",
}
&nbsp;
Запуск конфигурации на конкретных клиентах, где клиентами являются test1 и test2
node 'test1', 'test2' {
file {'/tmp/dns':
ensure =&gt; present,
mode =&gt; 0644,
content =&gt; "TEST01",
}
}
&nbsp;
На этом все. Удачной установки! =)
Related posts:Установка и настройка веб сервера Apache 2Настройка отказоустойчивого веб сервера на базе nginx и apache.ZFS перенос корневого пула с ОС на новый диск, меньшего размера.
        
             Linux, Puppet, Ubuntu 
             Метки: Linux, Puppet, Ubuntu  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
