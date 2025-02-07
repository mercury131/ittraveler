#                 	Удаляем неисправный контроллер домена при помощи утилиты NTDSUTIL                	  
***            ***

			
            
		
    
	
    	  Дата: 30.12.2014 Автор Admin  
	Нередки ситуации, когда системному администратору приходится вручную удалять контроллер домена из Active Directory. Такие ситуации возникают при физическом выходе из строя севера с ролью контроллера домена или другой нештатной ситуации. Естественно, наиболее предпочтительно удалить контроллер домена при помощи команды DCPROMO (подробно DCPROMO и ее параметрах) Однако, что же делать, если контроллер домена недоступен (выключен, сломался, недоступен по сети)?
Естественно, нельзя просто удалить учетную запись контроллера домена при помощи оснастки Active Directory User and Computer. Для ручного удаления контроллера домена из Active Directory подойдет утилита NTDSUTIL.  NTDSUTIL – это утилита командной строки, которая предназначена для выполнения различных сложных операций с ActiveDirectory, в том числе процедур обслуживания,  управления и модификации Active Directory. Я уже писал об использовании Ntdsutil для создания снимков (snapshot) Active Directory.
Следующая инструкция позволит вручную удалить неисправный контроллер домена.
Примечание: при использовании NTDSUTIL не обязательно вводит команду целиком, достаточно ввести  информацию, позволяющую однозначно идентифицировать команду, например вместо того, чтобы набирать metadata cleanup, можно набрать met cle, или m c
Откройте командную строку
Наберите
ntdsutil
(все последующие команды будут вводится в контексте ntdsutil)
metadata cleanup
connections
Наберите
connect to server
, где &lt;ServerName&gt; — имя работоспособного контроллера домена, хозяина операций
quit
select operation target
list sites
select site &lt;#&gt;
, где &lt;#&gt; — где  – номер сайта, в котором находился неисправный контроллер домена (команда list sites отобразит номер сайта)
list servers in site
select server &lt;#&gt;
, где &lt;#&gt; -где  – номер неисправного контроллера домена (команда list servers отобразит номер сервера)
list domains
select domain &lt;#&gt;
, где &lt;#&gt;  номер домена, в котором находится неисправный DC (команда list domains отобразит номер домена)
quit
(вернемся в меню metadata cleanup)
remove selected server
( появится предупреждающее окно, следует убедится, что удаляется искомый контроллер домена)
Yes
Откройте консоль Active Directory Sites and Services
Разверните сайт, в котором находился ненужный DC
Проверьте, что данный контролер не содержит никаких объектов
Щелкните правой кнопкой по контроллеру и выберите Delete
Закройте консоль Active Directory Sites and Services
Откройте оснастку  Active Directory Users and Computers
Разверните OU «Domain Controllers»
Удалите учетную запись компьютера неисправного контроллера домена из данной OU
Откройте оснастку DNS Manager
Найдите зону DNS, для которой ваш контроллер домена был DNS сервером
Щелкните правой кнопкой мыши по зоне и выберите Properties
Перейдите на вкладку серверов Name Servers
Удалите запись неисправного DC
Нажмите ОК, для того чтобы удалить все оставшиеся DNS записи: HOST (A) или Pointer (PTR
Удостоверьтесь, что в зоне не осталось никаких DNS записей, связанных с удаленным контроллером домена
Вот и все, мы полностью удалили из DNS и Active Directory неисправный контроллер домена и все ресурсы, связанные с ним.
Источник &#8212; http://winitpro.ru/index.php/2011/04/08/udalyaem-neispravnyj-kontroller-domena-pri-pomoshhi-utility-ntdsutil/
Related posts:Автоматическая активация пользователей Lync через PowershellЭкспорт почтовых ящиков Exchange 2010 через Powershell и PSTНовые компьютеры не появляются на WSUS сервере
        
             Active Directory, Windows, Windows Server 
             Метки: Active Directory, NTDSUTIL, удаление контроллера домена  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
