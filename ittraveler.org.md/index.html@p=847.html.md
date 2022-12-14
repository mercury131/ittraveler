# Настраиваем оповещение при подключении по SSH.                	  
***Дата: 05.05.2017 Автор Admin***

Бывает полезно знать кто и когда подключился к серверу по ssh, особенно если этот сервер в публичном облаке и смотрит в интернет.
В данной заметке я расскажу как это настроить в openssh server.
Для настройки оповещений первым делом настройте ssmtp , т.к его мы будем использовать для отправки писем. Как это сделать написано в этой статье.
Теперь создайте файл sshrc в каталоге /etc/ssh
```
touch /etc/ssh/sshrc
```
touch /etc/ssh/sshrc
Добавим в файл следующий скрипт:
```
ip=`echo $SSH_CONNECTION | cut -d " " -f 1`
logger -t ssh-wrapper $USER login from $ip
SERVER="yourServerName"
EMAIL='your@email.com'
FROM='yourServer@email.com'
ALERTMESSAGE='/tmp/ALERTMESSAGE1.tmp'
echo "To: $EMAIL" &gt; $ALERTMESSAGE
echo "From: $FROM" &gt;&gt; $ALERTMESSAGE
echo "Subject: Alarm! $USER login from $ip" &gt;&gt; $ALERTMESSAGE
echo "" &gt;&gt; $ALERTMESSAGE
echo "$USER login from $ip " &gt;&gt; $ALERTMESSAGE
/usr/sbin/ssmtp $EMAIL &lt; $ALERTMESSAGE
```
ip=`echo $SSH_CONNECTION | cut -d " " -f 1`&nbsp;logger -t ssh-wrapper $USER login from $ip&nbsp;&nbsp;SERVER="yourServerName"EMAIL='your@email.com'FROM='yourServer@email.com'ALERTMESSAGE='/tmp/ALERTMESSAGE1.tmp'&nbsp;echo "To: $EMAIL" &gt; $ALERTMESSAGEecho "From: $FROM" &gt;&gt; $ALERTMESSAGEecho "Subject: Alarm! $USER login from $ip" &gt;&gt; $ALERTMESSAGEecho "" &gt;&gt; $ALERTMESSAGEecho "$USER login from $ip " &gt;&gt; $ALERTMESSAGE&nbsp;/usr/sbin/ssmtp $EMAIL &lt; $ALERTMESSAGE
Теперь перезапустим ssh сервер
```
service ssh restart
```
service ssh restart
Теперь при каждом успешном подключении по ssh сервер будет отправлять уведомление, кто с какого ip зашел на сервер.
&nbsp;
Related posts:Установка и настройка AnsibleВосстановление HP ILOУстановка и настройка Radius сервера на Ubuntu с веб интерфейсом.
 Bash, Linux, Web/Cloud, Без рубрики 
 Метки: monitoring, openssh, ssh, Ubuntu  
                        
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
