#                 	Новые компьютеры не появляются на WSUS сервере                	  
***            ***

			
            
		
    
	
    	  Дата: 17.08.2018 Автор Admin  
	Если вы используете различные инструменты деплоя ОС из образов или имеете большое количество виртуальных машин, то наверняка замечали что далеко не все развернутые ОС отправляют отчет на сервер WSUS или вообще пропадают с сервера.
В этой статье я расскажу почему так происходит и как с этим боротьсяПредположим вы деплоите ваши рабочие станции из эталонного образа ОС или клонируете виртуальные машины из преднастроенного шаблона, скорее всего после или во время деплоя вы запускаете на них sysprep, но обнуляете ли вы SusClientId ?  =)
Тут то и кроется корень проблемы, после клонирования у машин остается один и тот же SusClientId.
Посмотреть его можно в реестре, по следующему пути:
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate
Значения которые нам нужны называются &#8212; SusClientId и SusClientIdValidation.
Данные значения должны быть уникальными на каждой машине, если это не так, то машины будут перерегистрироваться на WSUS затирая таким образом соседей с таким же SusClientId.
Чтобы это исправить нужно выполнить следующие команды:
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientId"
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientIdValidation"
wuauclt /resetauthorization /detectnow
После этого машина сбросит авторизацию на WSUS и зарегистрируется с новым, уникальным SusClientId.
Если вы хотите выполнить эту операцию массово, на всех машинах в домене или на таргетированной группе, можете создать GPO со следующим logon скриптом:
@echo off
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientId"
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /f /v "SusClientIdValidation"
net stop WUAUServ
timeout 10
net start WUAUServ
timeout 10
wuauclt /resetauthorization /detectnow
В качестве альтернативы logon скрипту, можно создать через GPO scheduled task на завершение работы ПК пользователя или с каким-то другим расписанием.
После этих манипуляций число машин на WSUS сервере должно существенно вырасти.
Related posts:Перенос базы данных Active DirectoryУдаляем неисправный контроллер домена при помощи утилиты NTDSUTILОтказоустойчивый ISCSI кластер на Windows Server 2012 R2
        
             Active Directory, Windows Server 
             Метки: wsus  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
