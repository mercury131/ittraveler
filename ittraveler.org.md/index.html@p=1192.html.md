# Запуск команд внутри гостевых ОС в гипервизоре KVM на примере Proxmox                	  
***Дата: 18.03.2019 Автор Admin***

В VMware, с помощью Powercli, есть возможность запускать команды внутри гостевых ОС с помощью командлета Invoke-VMScript , это очень удобно, ведь с помощью этого механизма можно выполнить необходимые команды на сотне VM, не открывая на них консоль.
Работая с KVM мне захотелось найти аналог данного механизма, чтобы запускать команды из консоли гипервизора порямо на гостевых ОС, по аналогии с VMware.
В данной статье мы рассмотрим как использовать qemu агент для выполнения задуманного.
Для начала установите qemu агент, взять его можно по ссылке
Для установки в Linux используйте слеющие команды:
```
apt-get install qemu-guest-agent
```
apt-get install qemu-guest-agent
```
yum install qemu-guest-agent
```
yum install qemu-guest-agent
После установки агента внутри виртуальной машины, нужно активировать его поддержку в настройках VM, вот так активированный агент для VM выглядит в Proxmox:
Если вы используете libvirt, то xml код будет примерно такой:
```
&lt;channel type='unix'&gt;
&lt;source mode='bind' path='/var/lib/libvirt/qemu/f16x86_64.agent'/&gt;
&lt;target type='virtio' name='org.qemu.guest_agent.0'/&gt;
&lt;/channel&gt;
```
&lt;channel type='unix'&gt;&nbsp;&nbsp; &lt;source mode='bind' path='/var/lib/libvirt/qemu/f16x86_64.agent'/&gt;&nbsp;&nbsp; &lt;target type='virtio' name='org.qemu.guest_agent.0'/&gt;&lt;/channel&gt;
Теперь включите VM, с помощью команды qm ping, можно убедиться что агент внутри VM функционирует нормально.
Если команда
```
qm ping 101
```
qm ping 101
где 101 &#8212; это ID вашей VM, не вернула ничего &#8212; значит агент функционирует нормально.
Теперь рассмотрим как запускать команды внутри VM с windows из консоли гипервизора KVM (он же в данном случае Proxmox)
Чтобы подключиться к сессии VM, выполните команду, где 101 &#8212; ID вашей VM
```
socat /var/run/qemu-server/101.qga -
```
socat /var/run/qemu-server/101.qga -
Теперь нам нужно передать команду внутрь гостевой ОС, команды передаются в формате JSON.
Для примера отправим команду на перезапуск гостевой ОС
```
{"execute":"guest-exec", "arguments":{"path":"cmd.exe","arg":["/c","shutdown", "-r", "-f"]}}
```
{"execute":"guest-exec", "arguments":{"path":"cmd.exe","arg":["/c","shutdown", "-r", "-f"]}}
Данная команда перезагрузит вашу VM.
По аналогии можно перезагрузить VM без использования cmd:
```
{"execute":"guest-exec", "arguments":{"path":"shutdown.exe","arg":["-r", "-f"]}}
```
{"execute":"guest-exec", "arguments":{"path":"shutdown.exe","arg":["-r", "-f"]}}
или например та же перезагрузка, только с помощью powershell:
```
{"execute":"guest-exec", "arguments":{"path":"powershell.exe","arg":["-command","restart-computer", "-force"]}}
```
{"execute":"guest-exec", "arguments":{"path":"powershell.exe","arg":["-command","restart-computer", "-force"]}}
Вот так к примеру можно запустить sysprep:
```
{"execute":"guest-exec", "arguments":{"path":"c:\\windows\\system32\\sysprep\\sysprep.exe","arg":["/oobe", "/generalize", "/reboot"]}}
```
{"execute":"guest-exec", "arguments":{"path":"c:\\windows\\system32\\sysprep\\sysprep.exe","arg":["/oobe", "/generalize", "/reboot"]}}
Если вы не хотите подключаться к сессии агента, а просто отправить команду одной строкой &#8212; используйте echo и отправляйте команду в socat:
```
echo '{"execute":"guest-exec", "arguments":{"path":"c:\\windows\\system32\\sysprep\\sysprep.exe","arg":["/oobe", "/generalize", "/reboot"]}}' | socat /var/run/qemu-server/101.qga -
```
echo '{"execute":"guest-exec", "arguments":{"path":"c:\\windows\\system32\\sysprep\\sysprep.exe","arg":["/oobe", "/generalize", "/reboot"]}}' | socat /var/run/qemu-server/101.qga -
Обратите внимание что слеши и спец символы в JSON экранируются, поэтому, перед тем как отправлять команду гостю &#8212; проверьте что синтаксис корректный.
Если не уверены, то всегда можно воспользоваться командой ConvertTo-Json в Powershell, например:
```
'cmd.exe "с:\windows\system32\sysprep.exe /oobe"' | ConvertTo-Json
```
'cmd.exe "с:\windows\system32\sysprep.exe /oobe"' | ConvertTo-Json
на выходе получите строку, с экранированным выводом:
```
"cmd.exe \"с:\\windows\\system32\\sysprep.exe /oobe\""
```
"cmd.exe \"с:\\windows\\system32\\sysprep.exe /oobe\""
На этом все.
В следующей статье рассмотрим как можно автоматизировать процесс деплоя и ввода в домен AD, VM на базе KVM.
Удачной настройки!
&nbsp;
&nbsp;
&nbsp;
&nbsp;
