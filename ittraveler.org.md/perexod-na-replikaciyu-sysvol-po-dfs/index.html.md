#                 	Переход на репликацию SYSVOL по DFS                	  
***            ***

			
            
		
    
	
    	  Дата: 30.12.2014 Автор Admin  
	Напомним, что каталог Sysvol присутствует на всех контроллерах домена Active Directory и используется для хранения логон скриптов и объектов групповых политик (подробнее о репликации в Active Directory можно почитать тут). В том случае, если вы развернули новый домен с нуля на функциональном уровне Windows Server 2008, то для репликации каталога SYSVOL используется механизм репликации DFS ( Особенности и преимущества DFS ).
Если же функциональный уровень домена Windows Server 2003 (или ниже), то для репликации SYSVOL используется служба FRS. После того, как функциональный уровень домена поднят до Windows Server 2008, то для репликации объектов AD можно использовать DFS, но только осуществив процедуру миграции, о которой мы и поговорим.
Узнаем текущий тип репликации
1.На контроллере домена с правами администратора домена откройте mmc консоль adsiedit.msc.
2. Жмем правой кнопкой по ADSIEdit и выбираем Connectto.
3. Указываем Select a well known Naming Context и Default naming context.
4. Жмем OK.
5. Развернем элемент Default Naming Context -&gt; Domain Name — &gt; CN=System -&gt; CN=File Replication Service
6. Т.е. сейчас для репликации SYSVOL используется механизм File Replication Service
Предварительные требования
Все контроллеры домена должны быть обновлены до функционального уровня Windows Server 2008 или выше
Перед процедурой миграции необходимо выполнить принудительную полную миграцию разделов Active Directory на каждом из контроллеров домена, выполнив команды:
repadmin /syncall Aed
repadmin /syncall /AedP
Устанавливаем роль DFS
На всех контроллерах домена устанавливаем роль DFS командой:
ServerManagercmd -iFS-DFS
Проверим состояние службы DFS, выполнив команды:
dfsrmig /get/GlobalStatedfsrmig /getMigrationState
Начало миграции?
1. Установим флаг подготовки к миграции (global state:
Prepared), выполнив команду:
dfsrmig /setGlobalState 1
2. Текущее состояние контроллеров проверим командой:
dfsrmig /getmigrationstate,
http://winitpro.ru/wp-content/uploads/2012/05/12/pic7.png
В том случае, если хотя бы у одного из контролеров состояние не изменится на Prepared, не переходите к следующему шагу!
Принудительно запустить репликации DFS и AD, можно командами:
repadmin /syncall /Aed?
repadmin /syncall /AedP
dfsrdiag /pollad /member:dc1.contoso.com
3. Запустите консоль ADSI Edit, и перейдите в
раздел
Default naming context -&gt;Domain name-&gt; CN=System — &gt; CN=DFSR-GlobalSettings
Как вы видите, появился новый раздел, который будет использоваться для управления репликацией.
4. Запустите редактор реестра и перейдите в ключу
HKLM\SYSTEM\CurrentControlSet\Services\DFSR\Parameters\Sysvols\Migrating sysVols\Local State
Значение: Local State = 1 говорит о том, что текущий статус — Prepared.
5. Перейдем к ключу HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\SysVol
Как вы видите, AD все еще использует папку SYSVOL
6. Служба DFS в каталоге %WINDIR% должна создать полную копию каталога SYSVOL с именем SYSVOL_DFSR
Перенаправление продуктивной папки
Прежде чем перейди к следующему этапу миграции (состояние Redirected), необходимо убедиться что:
Все контроллеры домена находятся в состоянии Prepared. Удостоверьтесь, что шара SYSVOL еще доступна.
1. Перейдем к следующему этапу миграции, набрав
dfsrmig /setGlobalState 2
2. Убедимся, что все контроллеры домена находятся в статусе Redirected:
dfsrmig /getmigrationstate
?3. В редакторе реестра проверим, что LocalState=2 и SYSVOL= C:\windows\SYSVOL_DFSR\sysvol.
?Удаляем старый каталог SYSVOL?
Примечание! Процесс удаления («Eliminated«) не может быть отменен!
Прежде чем перейди в режим Elminated, необходимо убедиться что:
Все контроллеры домена находятся в статусе Redirected
Шара SYSVOL все еще доступна
1. Набираем команду:
dfsrmig /setGlobalState 3
2. Проверяем статус командой:
dfsrmig /getmigrationstate
В результате каталог SYSVOL будет мигрирован в папку SYSVOL_DFSR. И теперь для репликации шары SYSVOL применяется механизм DFS.
Источник &#8212; http://winitpro.ru/index.php/2012/05/12/perexod-na-replikaciyu-sysvol-po-dfs/ 
Related posts:Подключение к Office 365 через Powershell и зашифрованный парольСоздание шаблонов Zabbix для Windows.Обновление схемы Active Directory
        
             Active Directory, Windows, Windows Server 
             Метки: SYSVOL, Переход на репликацию SYSVOL по DFS, Репликация  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
