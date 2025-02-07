#                 	Active Directory + Thunderbird = Общая адресная книга                	  
***            ***

			
            
		
    
	
    	  Дата: 30.12.2014 Автор Admin  
	Active Directory + Thunderbird = Общая адресная книга
Простой способ как можно научить Thunderbird работать с адресной книгой Active Directory.
Для подключения к адресной книге Active Directory, в Mozilla Thunderbird необходимо выполнить следующие настройки:
1. Открываем &#171;Адресная книга&#187;
2. Создаем новую адресную книгу при помощи меню &#171;Файл &gt; Создать &gt; Каталог LDAP&#187;
3. Заполняем необходимые поля на вкладке &#171;Основное&#187;
Название: любое имя, используется только для отображения.
Имя сервера: &lt;имя_сервера_LDAP&gt;
Корневой элемент (Base DN): dc=&lt;domain&gt;,dc=&lt;net&gt; (если домен domain.net)
Порт: 3268
Имя пользователя (Bind DN): &lt;username&gt;@&lt;domain.net&gt;
4. Открываем вкладку &#171;Дополнительно&#187;
Область поиска: &#171;поддерево&#187;
Фильтр поиска: (mail=*)
5. Нажимаем &#171;Ок&#187;, закрываем адресную книгу.
6. Открываем &#171;Инструменты &gt; Настройки &gt; Составление &gt; Вкладка Адресация&#187;
Пункт &#171;При вводе адреса искать подходящие почтовые адреса в:&#187;. Ставим галочку &#171;Сервере каталогов&#187; и указываем наш сервер.
7. Перезапускаем Mozilla Thunderbird.
Для поиска нужного адреса нажмите &#171;Создать&#187; и начните вводить имя пользователя или группы в поле &#171;Кому&#187;, сработает автоподстановка и в поле добавиться нужный адрес.
Источник &#8212; http://www.it-35.ru/
Related posts:Подключение к Office 365 через Powershell и зашифрованный парольОшибка ERR: CERT_COMMON_NAME_INVALID в Chrome при использовании SSL сертификата.Автоматизируем бэкап баз данных MSSQL Express
        
             Active Directory, Windows 
             Метки: Active Directory, Thunderbird  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
