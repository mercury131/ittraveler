# Сброс пароля администратора Active Directory                	  
***Дата: 30.12.2014 Автор Admin***

В этой статье мы рассмотрим сценарий сброса пароля администратора домена Active Direcotory.  Эта возможность может понадобиться в случаях утраты прав доменного администратора вследствие, например, «забывчивости» или намеренного саботажа увольняющегося админа, атаки злоумышленников или других форс мажорных обстоятельствах.   Для успешного сброса пароля администратора домена необходимо иметь физический или удаленный (ILO, iDRAC или консоль vSphere, в случае использования виртуального DC) доступ к  консоли сервера. В данном примере мы будем сбрасывать пароль администратора на контроллере домене с ОС Windows Server 2012. В том случае, если в сети несколько контроллеров домена, рекомендуется выполнять процедуру на сервере PDC (primary domain controller) с ролью FSMO (flexible single-master operations).
Для сброса пароля домен-админа необходимо попасть в режим восстановления  службы каталогов  – DSRM (Directory Services Restore Mode) с паролем администратора DSRM (он задается при повышении уровня сервера до контроллера домена). По сути это учетная запись локального администратора, хранящаяся в локальной базе SAM на контроллере домена.
В том случае, если пароль DSRM не известен, его можно сбросить таким способом, или, если администратор обезопасил сервер от использования подобных трюков, с помощью специализированных загрузочных дисков  (типа Hiren’s BootCD, PCUnlocker и им подобных).
Итак, загружаем контроллер домена в DSRM режиме (сервер загружается с отключенными службами AD), выбрав соответствующую опцию в меню расширенных параметров загрузки.
На экране входа в систему вводим имя локального пользователя (administrator) и его пароль (пароль DSRM режима).
В данном примере имя контроллера домена – DC01.
Проверим, под каким пользователем выполнен вход в системе, для этого выполним команду:
whoami /user
USER INFORMATION
—————-
User Name          SID
================== ============================================
dc01\administrator S-1-5-21-3244332244-383844547-2464936909-500
Как вы видите, мы работаем под локальным админом.
Следующий шаг – смена пароля учетной записи администратора Active Directory (по умолчанию это учетная тоже называется Administrator). Сбросить пароль администратора домена можно, например, создав отдельную службу, которая при старте контроллера домена из под системной учетной записи сбросила бы в Active Directory пароль учетной записи  Administrator. Создадим такую службу:
sc create ResetADPass binPath= &#171;%ComSpec% /k net user administrator P@ssw0rd&#187; start= auto
Примечание. Обратите внимание, при задании пути в переменной binPath, между знаком ‘=’ и ее значением необходим пробел. Кроме того, новый пароль должен обязательно отвечать доменным требованиям длины и сложности пароля.
Указанная команда создаст службу с именем ResetADPass, которая при загрузке системы с правами LocalSystem выполнит команду net user и изменит пароль администратора AD на P@ssw0rd.
С помощью следующей команды мы можем удостовериться, что служба была создана корректно:
sc qc ResetADPass
[SC] QueryServiceConfig SUCCESS
SERVICE_NAME: ResetADPass
TYPE               : 10  WIN32_OWN_PROCESS
START_TYPE         : 2   AUTO_START
ERROR_CONTROL      : 1   NORMAL
BINARY_PATH_NAME   : C:\Windows\system32\cmd.exe /k net user administrator P@ssw0rd
LOAD_ORDER_GROUP   :
TAG                : 0
DISPLAY_NAME       : ResetADPass
DEPENDENCIES       :
SERVICE_START_NAME : LocalSystem
Перезагрузим сервер в нормальном режиме:
shutdown -r -t 0
Во время загрузки созданная нами служба изменит пароль учетной записи амина домена на заданный. Авторизуемся на контроллере домена под этой учетной записью и паролем.
whoami /user
USER INFORMATION
—————-
User Name             SID
===================== ============================================
corp\administrator S-1-5-21-1737425439-783543262-1234318981-500
Осталось удалить созданную нами службу:
sc delete ResetADPass
[SC] DeleteService SUCCESS
Итак, в этой статье мы разобрались, как можно сбросить пароль администратора домена AD, и еще раз намекнули о том, насколько в концепции информационной безопасности важен момент обеспечения физической безопасности Вашей IT инфраструктуры.
Источник &#8212; http://winitpro.ru/index.php/2013/07/22/sbros-parolya-administratora-active-directory/
Related posts:Создание индивидуальных адресных книг в Office 365 и Exchange onlineУдаляем неисправный контроллер домена при помощи утилиты NTDSUTILДобавление почтовых контактов в Office 365 через Powershell и CSV
 Active Directory, Windows, Windows Server 
 Метки: Active Directory, Сброс пароля  
                        
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
