# Включение корзины Active Directory                	  
***Дата: 30.12.2014 Автор Admin***

Корзину Active Directory можно включить только в том случае, если в среде установлен режим работы леса Windows Server 2008 R2. Можно повысить режим работы леса с помощью приведенных далее методов.
Использование командлета Set-ADForestMode модуля Active Directory
Set-ADForestMode –Identity contoso.com -ForestMode Windows2008R2Forest
Или использовать Ldp.exe
1)Чтобы открыть Ldp.exe, нажмите кнопку Пуск, выберите команду Выполнить и введите ldp.exe.
2)Чтобы подключиться и выполнить привязку к серверу, на котором находится корневой домен леса среды AD DS, в разделе Подключение выберите пункт Подключить и нажмите Привязка.
3)Щелкните пункт Просмотр и выберите пункт Дерево. В разделе BaseDN выберите раздел каталога конфигураций и нажмите кнопку ОК.
4)В дереве консоли дважды щелкните различающееся имя (DN) раздела каталога конфигураций и перейдите в контейнер CN=Partitions.
5)Щелкните правой кнопкой мыши различающееся имя контейнера CN=Partitions и выберите Изменить.
6)В диалоговом окне Изменение в поле Изменить запись Атрибут введите msDS-Behavior-Version.
7)В диалоговом окне Изменение в поле Значения укажите 4 (значение режима работы леса Windows Server 2008 R2).
8)В диалоговом окне Изменение в разделе Операция выберите Заменить, нажмите клавишу ВВОД, а затем нажмите Выполнить.
После установки Windows Server 2008 R2 в качестве режима работы леса можно включить корзину Active Directory с помощью следующих методов:
Включение корзины Active Directory с помощью командлета Enable-ADOptionalFeature
Нажмите кнопку Пуск, выберите пункт Администрирование, щелкните правой кнопкой мыши пункт Модуль Active Directory для Windows PowerShell и выберите команду Запуск от имени администратора.
В командной строке Active Directory module for Windows PowerShell введите следующую команду и нажмите клавишу ВВОД:
Enable-ADOptionalFeature -Identity &lt;ADOptionalFeature&gt; -Scope &lt;ADOptionalFeatureScope&gt; -Target &lt;ADEntity&gt;
Пример: Enable-ADOptionalFeature –Identity ‘CN=Recycle Bin Feature,CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration, DC=contoso,DC=com’ –Scope ForestOrConfigurationSet –Target ‘contoso.com’
Для включения корзины Active Directory в среде AD LDS можно также использовать командлет Enable-ADOptionalFeature. Например, чтобы включить корзину Active Directory на локальном сервере AD LDS, когда различающееся имя раздела каталога конфигураций AD LDS имеет значение CN=Configuration,CN={372A5A3F-6ABE-4AFD-82DE-4A84D2A10E81}, используется следующий командлет:
Enable-ADOptionalFeature &#8216;recycle bin feature&#8217; -Scope ForestOrConfigurationSet -Server localhost:50000 -Target &#8216;CN=Configuration,CN={372A5A3F-6ABE-4AFD-82DE-4A84D2A10E81}&#8217;
Включение корзины Active Directory с помощью средства Ldp.exe
1)Чтобы открыть Ldp.exe, нажмите кнопку Пуск, выберите команду Выполнить и введите ldp.exe.
2)Чтобы подключиться и выполнить привязку к серверу, на котором находится корневой домен леса среды AD DS, в разделе Подключение выберите пункт Подключить и нажмите Привязка.
3)В меню Обзор выберите пункт Дерево, в поле BaseDN выберите раздел каталога конфигураций, а затем нажмите кнопку ОК.
4)В дереве консоли дважды щелкните различающееся имя раздела каталога конфигураций и перейдите в контейнер CN=Partitions.
5)Щелкните правой кнопкой мыши различающееся имя контейнера CN=Partitions и выберите Изменить.
6)В диалоговом окне Изменение убедитесь, что поле DN пустое.
7)В диалоговом окне Изменение в поле Изменить запись Атрибут введите enableOptionalFeature.
8)В диалоговом окне Изменение в поле Значения введите CN=Partitions,CN=Configuration,DC=mydomain,DC=com:766ddcd8-acd0-445e-f3b9-a7f9b6744f2a. Замените значения mydomain и com соответствующим именем корневого домена леса среды AD DS.
9)В диалоговом окне Изменение в разделе Операция выберите Добавить, нажмите клавишу ВВОД, а затем нажмите Выполнить.
10)Чтобы проверить, включена ли корзина Active Directory, перейдите в контейнер CN=Partitions. В области сведений найдите атрибут msDS-EnabledFeature и убедитесь, что для него установлено значение CN=Recycle Bin Feature,CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration, DC=mydomain,DC=com, где mydomain и com представляют имя корневого домена леса среды AD DS.
Related posts:Как узнать WWN (World Wide Name)  в Windows Server 2012R2Установка и настройка Lync 2013Кастомизация гостевых ОС Windows в KVM на примере Proxmox
 Active Directory, PowerShell, Windows, Windows Server 
 Метки: Active Directory, Корзина Active Directory  
                        
Добавить комментарий Отменить ответВаш адрес email не будет опубликован.Комментарий Имя 
Email 
Сайт 
 
&#916;document.getElementById( "ak_js_1" ).setAttribute( "value", ( new Date() ).getTime() );	
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-1890562251101921"
data-ad-slot="9117958896"
data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
  
Все права защищены. IT Traveler 2022 
                            
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
