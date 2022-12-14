# Установка и настройка кластера MSSQL 2012.                	  
***Дата: 20.05.2015 Автор Admin***

В данной статье будет рассмотрена установка и настройка кластера MSSQL 2012.
Устанавливаем на каждый сервер компонент отказоустойчивого кластера. Объединяем сервера в кластер.
Как это сделать можно посмотреть тут.
Запускаем мастер установки MSSQL 2012 и выбираем пункт &#8212; Новая установка отказоустойчивого кластера.
Запускать мастер нужно под пользователем с правом заведения ПК в домен Active Directory.
Вводим ключ продукта, и соглашаемся с лицензией.
Устанавливаем доступные обновления.
Проходим проверку конфигурации кластера для MSSQL.
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-1890562251101921"
data-ad-slot="9117958896"
data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
Выбираем компоненты для установки.
Выбираем компоненты для установки.
Далее проходим проверку конфигурации и нажимаем далее.
Указываем сетевое имя кластера MSSQL.
Проверка использования свободного пространства.
Просматриваем доступные кластерные хранилища.
Указываем общий диск кластера.
Указываем сетевые настройки кластера.
Указываем учетные данные администратора.
Желательно завести отдельного пользователя для MSSQL.
Также укажите параметры сортировки.
Если вам нужна учетная запись администратора MSSQL (SA), выберите смешанный тип, и укажите пароль.
Также добавьте своего пользователя.
&nbsp;
<ins class="adsbygoogle"
style="display:block"
data-ad-client="ca-pub-1890562251101921"
data-ad-slot="9117958896"
data-ad-format="auto">
(adsbygoogle = window.adsbygoogle || []).push({});
В каталогах данных можете указать локальные пути для Temp DB. Данное действие доступно с версии 2012.
Проходим еще одну проверку и нажимаем далее.
Нажимаем установить, и ждем окончания установки.
Установка может идти очень долго.
Установка на первой ноде кластера завершена.
Переходим ко второй ноде.
Запускаем мастер установки MSSQL.
Выбираем пункт &#8212; добавление узла в отказоустойчивый кластер SQL.
Далее, проходим тест, вводим ключ, принимаем лицензию,  устанавливаем обновления.
Проходим проверку.
Выбираем узел кластера.
Выбираем ip адрес кластера.
Указываем учетные данные.
Далее проходим проверки, и переходим к установке.
Ожидаем завершения установки.
&nbsp;
На этом установка второй ноды завершена.
Установка кластера завершена. Можно подключаться к адресу кластера, для управления базами данных.
&nbsp;
&nbsp;
&nbsp;
Related posts:Аудит изменений в Active DirectoryОшибка ERR: CERT_COMMON_NAME_INVALID в Chrome при использовании SSL сертификата.Передача и захват ролей FSMO
 Windows, Windows Server 
 Метки: Cluster, MSSQL, Windows Server  
                        
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
