# Оптимизация изображений на веб сервере                	  
***Дата: 12.05.2017 Автор Admin***

Если вы или ваши пользователи загружают изображения на ваш сайт, то рано или поздно они начнут занимать неприлично много места.
В данной статье я расскажу как оптимизировать все jpg и png изображения на вашем веб сервере. 
В оптимизации изображений нам помогут следующие утилиты &#8212; jpegoptim и optipng.
Установим их, в качестве примера я буду использовать Ubuntu server
```
apt-get update
```
apt-get update
```
apt-get install jpegoptim optipng
```
apt-get install jpegoptim optipng
Рассмотрим как можно использовать данные утилиты.
Для оптимизации JPG достаточно выполнить команду:
```
jpegoptim --size=100k YourPIC.jpeg --overwrite
```
jpegoptim --size=100k YourPIC.jpeg --overwrite
На мой взгляд наиболее оптимально использовать параметр size=250k , тогда команда будет выглядеть так:
```
jpegoptim --size=250k YourPIC.jpeg --overwrite
```
jpegoptim --size=250k YourPIC.jpeg --overwrite
Теперь рассмотрим оптимизацию PNG.
Выполним команду:
```
optipng -o5 YourPIC.png
```
optipng -o5 YourPIC.png
Если вы хотите сжать изображение еще сильнее, то используйте параметр -o7 , команда будет выглядеть так:
```
optipng -o7 YourPIC.png
```
optipng -o7 YourPIC.png
Обратите внимание , что при использовании параметра -o7 у вас увеличится утилизация CPU на сервере.
Теперь для автоматизации всего этого добра создадим такой скрипт:
```
#!/bin/bash
picdir='/hosting/website/upload/images'
# Optimize JPG
jpgs=$(find $picdir -iname *.jpg )
for jpg in $jpgs
do
echo $jpg
jpegoptim --size=250k $jpg
chown www-data $jpg
done
# Optimize JPEG
jpegs=$(find $picdir -iname *.jpeg )
for jpeg in $jpegs
do
echo $jpeg
jpegoptim --size=250k $jpeg
chown www-data $jpeg
done
# Optimize PNG
pngs=$(find $picdir -iname *.png )
for png in $pngs
do
echo $png
optipng -o7 $png
chown www-data $png
done
```
#!/bin/bash&nbsp;picdir='/hosting/website/upload/images'&nbsp;# Optimize JPGjpgs=$(find $picdir -iname *.jpg )&nbsp;for jpg in $jpgsdo&nbsp;echo $jpg&nbsp;jpegoptim --size=250k $jpgchown www-data $jpg&nbsp;&nbsp;done&nbsp;# Optimize JPEGjpegs=$(find $picdir -iname *.jpeg )&nbsp;for jpeg in $jpegsdo&nbsp;echo $jpeg&nbsp;jpegoptim --size=250k $jpegchown www-data $jpeg&nbsp;&nbsp;done&nbsp;&nbsp;# Optimize PNGpngs=$(find $picdir -iname *.png )&nbsp;for png in $pngsdo&nbsp;echo $png&nbsp;optipng -o7 $pngchown www-data $png&nbsp;done
Сохраните себе этот скрипт , в переменной picdir вместо /hosting/website/upload/images укажите путь к каталогу с изображениями на вашем сайте.
Не забудьте сделать скрипт исполняемым , командой chmod +x ./your_script.sh
Теперь можно добавить его в крон
```
crontab -e
```
crontab -e
```
0 1 * * * /path_to_script/your_script.sh
```
0 1 * * * /path_to_script/your_script.sh
Обратите внимание что при запуске этого скрипта у вас увеличится утилизация CPU , запускайте скрипт в то время, когда у вас мало посетителей на сайте, перед запуском обязательно протестируйте оптимизацию изображений на тестовом стенде, возможно для вас параметры -o7 и &#8212;size=250k не оптимальные.
