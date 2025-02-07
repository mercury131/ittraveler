#                 	Получаем MD5 файла или переменной в Powershell                	  
***            ***

			
            
		
    
	
    	  Дата: 24.04.2017 Автор Admin  
	Для сравнения файлов или данных удобно использовать хэш суммы MD5, на днях понадобилось сделать это на Powershell.
Итак, как же это сделать?
Для рассчета MD5 конкретного файл, нам поможет командлет Get-FileHash.
Давайте рассчитаем MD5 для какого-нибудь файла, например explorer.exe , в папке Windows
Get-FileHash -Algorithm MD5 -Path "C:\Windows\explorer.exe"
В примере выше мы указали алгоритм и путь к файлу, вывод будет таким:
Algorithm Hash                             Path                   
--------- ----                             ----                   
MD5       38AE1B3C38FAEF56FE4907922F0385BA C:\Windows\explorer.exe
Если вам нужен только результат, то можно добавить select
Get-FileHash -Algorithm MD5 -Path "C:\Windows\explorer.exe" | select Hash
Так мы увидим только хэш
Ну и если нужна только строка с данными, то команда будет выглядеть так:
(Get-FileHash -Algorithm MD5 -Path "C:\Windows\explorer.exe" ).Hash
Если вам нужно посчитать хэш для нескольких файлов в папке выполните такую команду:
Get-ChildItem -Recurse -Path "C:\Windows\Speech\Engines" | Get-FileHash -Algorithm MD5
Тут мы указали в качестве папки C:\Windows\Speech\Engines , файлы которой мы передали командлету Get-FileHash, результат будет таким:
Algorithm Hash                             Path                                                
--------- ----                             ----                                                
MD5       CDDA15F40E6D29B544FBEAF7C735F88A C:\Windows\Speech\Engines\Lexicon\en-GB\grph2057.lxa
MD5       F07F80D3C09AF21A2CAF82AB1C13227D C:\Windows\Speech\Engines\Lexicon\en-GB\lsr2057.lxa
MD5       B53BC8C90D764A51077DD6F324D5B678 C:\Windows\Speech\Engines\Lexicon\en-US\grph1033.lxa
MD5       9D50D770BC02AC1216BB2867AD2B8F15 C:\Windows\Speech\Engines\Lexicon\en-US\lsr1033.lxa
MD5       21D1F5C2DE826F5C5F460FACA67828C9 C:\Windows\Speech\Engines\SR\en-GB\AF032057.am      
MD5       E7CAE5491A15E31A1D02702013A98F97 C:\Windows\Speech\Engines\SR\en-GB\AI032057.am      
MD5       1B539E72DCFDAB992724867BC1DC0429 C:\Windows\Speech\Engines\SR\en-GB\AM032057.am      
MD5       F830EB033176B5F72F93D01D0F9219C4 C:\Windows\Speech\Engines\SR\en-GB\c2057dsk.fe      
MD5       B29F86EBC270050ECA872396B28E12C7 C:\Windows\Speech\Engines\SR\en-GB\l2057.cw         
MD5       132800B1399094F9CB9B34A56BCC12E0 C:\Windows\Speech\Engines\SR\en-GB\l2057.dlm        
MD5       29C399C33ED104F1BD3F4D80CDF40BD1 C:\Windows\Speech\Engines\SR\en-GB\L2057.ini        
MD5       86C3F9DF9D2DB563E5A020CC1F213605 C:\Windows\Speech\Engines\SR\en-GB\l2057.mllr       
MD5       DFE1255D28307C8B27A65914F8ADBBE1 C:\Windows\Speech\Engines\SR\en-GB\l2057.ngr        
MD5       C3178654D958620AFC70FC14ACEA34CE C:\Windows\Speech\Engines\SR\en-GB\l2057.phn        
MD5       D9C4B89F65017CE1EB96DF631B7B8931 C:\Windows\Speech\Engines\SR\en-GB\l2057.smp        
MD5       EEFCEC11612B2061835E39A928ABCDEA C:\Windows\Speech\Engines\SR\en-GB\l2057.wwd        
MD5       A48252F56DD1D2E381146AFB665BAD67 C:\Windows\Speech\Engines\SR\en-GB\p2057.dlm        
MD5       AA1713B978A161EC0981F95BE567FF78 C:\Windows\Speech\Engines\SR\en-GB\p2057.ngr        
MD5       63307FA9DFA317FD0B008DBFD5BABDA7 C:\Windows\Speech\Engines\SR\en-GB\s2057.dlm        
MD5       B3928B65035AD19C374930A4410A25DF C:\Windows\Speech\Engines\SR\en-GB\s2057.ngr        
MD5       BAFA101C0498CFC92E9908FEC4F1DD48 C:\Windows\Speech\Engines\SR\en-GB\tn2057.bin       
MD5       5A71C66A79028C995CAE2DCBAFE36E9B C:\Windows\Speech\Engines\SR\en-GB\wp2057.bin       
MD5       8D35B98E3393F4C0CF7F67E0D024CD47 C:\Windows\Speech\Engines\SR\en-US\af031033.am      
MD5       DCD25275A5AEC6364F93A65E82EBF14C C:\Windows\Speech\Engines\SR\en-US\ai031033.am      
MD5       C7DA29C2035819AD466CCF6B5DE66B95 C:\Windows\Speech\Engines\SR\en-US\am031033.am      
MD5       49468F2176E03A712A28053C13DAC04E C:\Windows\Speech\Engines\SR\en-US\c1033dsk.fe      
MD5       512E4A9F194719C26C2ADE99D970C4F9 C:\Windows\Speech\Engines\SR\en-US\l1033.cw         
MD5       B9587D89A04C26EC28ADBB4735046BA9 C:\Windows\Speech\Engines\SR\en-US\l1033.dlm        
MD5       D92EC2B7ED8CB9EAA291E709D39FCB64 C:\Windows\Speech\Engines\SR\en-US\l1033.ini        
MD5       4DAD2CDBF07DCA13F2574F2DCBE77B53 C:\Windows\Speech\Engines\SR\en-US\l1033.mllr       
MD5       B413FA9A12AC9C14E129E1BDF009E281 C:\Windows\Speech\Engines\SR\en-US\l1033.ngr        
MD5       36A2F60F6A086AE862D3B98462974BA3 C:\Windows\Speech\Engines\SR\en-US\l1033.phn        
MD5       54EED816EEBFF08A5483A744444694A4 C:\Windows\Speech\Engines\SR\en-US\l1033.smp        
MD5       955058D9ED9DB531E8902A9EE6E53FCB C:\Windows\Speech\Engines\SR\en-US\l1033.wwd        
MD5       13CBC2C90CBC8312E168071F3399A605 C:\Windows\Speech\Engines\SR\en-US\p1033.dlm        
MD5       DEB2AD12419510B764731908406A1E75 C:\Windows\Speech\Engines\SR\en-US\p1033.ngr        
MD5       8CC756F9C384AFBC0B7F819D98685DD5 C:\Windows\Speech\Engines\SR\en-US\s1033.dlm        
MD5       29B51106C8C8BD7285F96B7C8225BE0E C:\Windows\Speech\Engines\SR\en-US\s1033.ngr        
MD5       587DE13713907D970620B2283C456866 C:\Windows\Speech\Engines\SR\en-US\t1033.dlm        
MD5       F8619745AACAF43A29461718A6F703A0 C:\Windows\Speech\Engines\SR\en-US\t1033.ngr        
MD5       598202D11EE03D4156A756DDBE46A6DC C:\Windows\Speech\Engines\SR\en-US\tn1033.bin       
MD5       035DBB60BE15F11672CC9C6DEC5094C8 C:\Windows\Speech\Engines\SR\en-US\u1033.dlm        
MD5       51009DF0F0193E60FDE90213300195D3 C:\Windows\Speech\Engines\SR\en-US\u1033.ngr        
MD5       C1166E3892C173F0FF6C74A81F00147C C:\Windows\Speech\Engines\SR\en-US\wp1033.bin
Кстати, кроме MD5 можно указать следующие алгоритмы:
SHA1
SHA256
SHA384
SHA512
MACTripleDES
MD5
RIPEMD160
Этот командлет отлично подходит для файлов, но что делать если хэш MD5 нужно получить из переменной или строк?
Тут нам поможет следующая функция:
function Hash($textToHash)

{

    $hasher = new-object System.Security.Cryptography.MD5CryptoServiceProvider

    $toHash = [System.Text.Encoding]::UTF8.GetBytes($textToHash)

    $hashByteArray = $hasher.ComputeHash($toHash)

    foreach($byte in $hashByteArray)

    {

         $res += $byte.ToString()

    }

    return $res;

}
Вот как она работает:
Hash "Test-text"
Вывод будет таким:
Давайте рассмотрим пример, что нам нужно получить слепок MD5 из нескольких строк, из массива данных.
Объявим переменную:
$testDATA=Get-ChildItem -Recurse -Path "C:\Windows\Speech\Engines" | Get-FileHash -Algorithm MD5
Теперь получим хэш MD5 нескольких строк MD5 из переменной указанной выше:
Hash $testDATA.Hash
Вывод будет таким:
В указанной выше функции мы используем класс .NET System.Security.Cryptography , в котором используем алгоритм MD5, если вам нужны другие алгоритмы, вы можете найти их на этой странице
Надеюсь статья была полезной и возможно кому-то это поможет сэкономить время.
Related posts:Управление репликацией Active DirectoryОшибка ERR: CERT_COMMON_NAME_INVALID в Chrome при использовании SSL сертификата.Автоматическая активация пользователей Lync через Powershell
        
             PowerShell, Windows Server, Без рубрики 
             Метки: MD5, Powershell, Windows Server  
        
            
        
    
                        
                    
                    
                
        
                
	
		
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
