#                 	Аудит изменений в Active Directory                	  
***            ***

			
            
		
    
	
    	  Дата: 30.12.2014 Автор Admin  
	Любой администратор Active Directory рано или поздно сталкивается с необходимостью аудита изменения в Active Directory, и этот вопрос может встать тем острее, чем больше и  сложнее структура Active Directory и чем больше список лиц, кому делегированы права управления в том или ином сайте или контейнере AD. В сферу интересов администратора (или специалиста по ИБ) могут попасть такие вопросы как:
кто добавил / удалил пользователя  или группу AD
кто включил / заблокировал пользователя
с какого адреса был изменен / сброшен пароль пользователя домена
кто создал / отредактировал групповую политику и т.д.
В ОС семейства Windows существуют встроенные средства аудита изменений в различных объектах, которые, как и многие другие параметры Windows, имеют возможности управления с помощью групповых политики.
Примечание. Мы уже касались темы аудита Windows в статье: «Аудит доступа к файлам и папкам в Windows 2008»
Разберем на конкретном примере методику включения аудит изменений параметров пользователей и членства в группах Active Directory (согласно данной методики можно включить отслеживание и других категорий событий).
Расширенные политики аудита Windows
Создадим новый объект GPO (групповую политику) с именем «Audit Changes in AD». Перейдите в раздел редактирования и разверните ветку Computer Configuration &gt; Policies &gt; Windows Settings &gt; Security Settings &gt; Advanced Audit Configuration. В данной ветке групповых политик находятся расширенные политики аудита, который можно активировать в ОС семейства Windows для отслеживания различных событий.  В Windows 7 и Windows Server 2008 R2 количество событий, для которых можно осуществлять аудит увеличено до 53. Эти 53 политики аудита (т.н. гранулярные политики аудита) находятся в ветке Security Settings\Advanced Audit Policy Configuration сгруппированы в 10 категориях:
Account Logon – аудит проверки учетных данных, службы проверки подлинности Kerberos, операций с билетами Kerberos и других события входа
Account Management – отслеживание изменений в учетных записей пользователей и компьютеров, а также информации о группах AD и членстве в них
Detailed Tracking – аудит активности индивидуальных приложений (RPC, DPAPI)
DS Access – расширенный аудит изменений в объектах службы Active Directory Domain Services (AD DS)
Logon/Logoff – аудит интерактивных и сетевых попыток входа на компьютеры и сервера домена, а также блокировок учетных записей
Object Access – аудит доступа к различным объектам (ядру, файловой системе и общим папкам, реестру, службам сертификации и т.д.)
Policy Change – аудит изменений в групповых политиках
Privilege Use — аудит прав доступа к различным категориям данных
System – изменения в настройках компьютеров, потенциально критичных с точки зрения безопасности
Global Object AccessAuditing – позволяют администратору создать собственное списки ACL, отслеживающие изменения в реестре и файловой системой на всех интересующих объектах
Естественно, чтобы не перегружать систему лишней работой, а журналы ненужной информацией, рекомендуется использовать лишь минимально необходимый набор аудирумых параметров.
Настройка аудита изменений учетных записей и групп Active Directory
В данном случае, нас интересует категория Account Management, позволяющая включить аудит изменений в группах Audit Security Group Management)  и аудит учетных записей пользователей (политика Audit User Account Management). Активируем данные политики аудита, задав отслеживание только успешных изменений (Success).
Осталось прилинковать данную политику к контейнеру, содержащему учетные записи контроллеров домена (по умолчанию это OU Domain Controllers) и применить эту политику (выждав 90 минут или выполнив команду gpupdate /force).
После применения данной политики информация обо всех изменения в учетных записях пользователей и членстве в группах будет фиксировать на контроллерах домена в журнале Security. На скриншоте ниже отображено событие, фиксирующие момент удаления пользователя из групп Active Directory (в событии можно увидеть кто, когда и кого удалил из группы).
По умолчанию журнал отображает все события безопасности, попавшие в лог. Чтобы упростить поиск нужного события, журнал можно отфильтровать по конкретному Event ID. В том случае, если нас интересуюсь только события, например, качающиеся сброса пароля пользователя в домене, необходимо включить фильтр по id 4724.
Ниже приведен список некоторых ID событий, которые могут понадобиться для поиска и фильтрации событий в журнале Security практике:
ID событий, в контексте изменений в группах AD:
4727 : A security-enabled global group was created.
4728 : A member was added to a security-enabled global group.
4729 : A member was removed from a security-enabled global group.
4730 : A security-enabled global group was deleted.
4731 : A security-enabled local group was created.
4732 : A member was added to a security-enabled local group.
4733 : A member was removed from a security-enabled local group.
4734 : A security-enabled local group was deleted.
4735 : A security-enabled local group was changed.
4737 : A security-enabled global group was changed.
4754 : A security-enabled universal group was created.
4755 : A security-enabled universal group was changed.
4756 : A member was added to a security-enabled universal group.
4757 : A member was removed from a security-enabled universal group.
4758 : A security-enabled universal group was deleted.
4764 : A group’s type was changed.
ID событий, в контексте изменений в учетных записей пользователей в AD:
4720 : A user account was created.
4722 : A user account was enabled.
4723 : An attempt was made to change an account’s password.
4724 : An attempt was made to reset an account’s password.
4725 : A user account was disabled.
4726 : A user account was deleted.
4738 : A user account was changed.
4740 : A user account was locked out.
4765 : SID History was added to an account.
4766 : An attempt to add SID History to an account failed.
4767 : A user account was unlocked.
4780 : The ACL was set on accounts which are members of administrators groups.
4781 : The name of an account was changed:
4794 : An attempt was made to set the Directory Services Restore Mode.
5376 : Credential Manager credentials were backed up.
5377 : Credential Manager credentials were restored from a backup.
Основные недостатки встроенной системы аудита Windows
Однако у штатных средств просмотра и анализа логов в Windows есть определенные недостатки.
Естественно, консоль Event Viewer предоставляет лишь базовые возможности просмотра и поиска информации о тех или иных событиях в системе и не предполагает возможностей сложной обработки, группировки и агрегации информации. По сути эта задача целиком зависит от способностей и уровня подготовки системного администратора или инженера ИБ, который с помощью различных скриптов (например, powershell илл vbs) или офисных средств может разработать собственную систему импорта и поиска по журналам.
Также не стоит забывать, что с помощью встроенных средств Windows сложно объединить журналы с различных контроллеров домена (можно, конечно, воспользоваться возможностью перенаправления логов в Windows, но этот инструмент также недостаточно гибкий), поэтому поиск нужного события придется осуществлять на всех контроллерах домена (в рамках больших сетей это очень накладно).
Кроме того, при организации системы аудита изменений в AD с помощью штатных средств Windows нужно учесть, что в журнал системы пишется огромное количество событий (зачастую ненужных) и это приводит к его быстрому заполнению и перезатиранию. Чтобы иметь возможность работы с архивом событий, необходимо увеличить максимальный размер журнала и запретить перезапись, а также разработать стратегию импорта и очистки журналов.
Именно по этим причинам, для аудита изменений в AD в крупных и распределенных системах предпочтительно использовать программные комплексы сторонних разработчиков. В последнее время на слуху, например, такие продукты, как NetWrix Active Directory Change Reporter или ChangeAuditor for Active Directory.
Источник &#8212; http://winitpro.ru/index.php/2013/06/11/audit-izmeneniya-v-active-directory/
Related posts:Изменение UPN суффикса в Active Directory через PowershellПринудительная синхронизация контроллеров домена Active DirectoryПеренос виртуальной машины из Hyper-V в Proxmox (KVM)
        
             Active Directory, Windows, Windows Server 
             Метки: Active Directory, Аудит  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
