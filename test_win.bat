runas /user:AdminLo
ver | find "5.1." && set result=XP
ver | find "6.1." && set result=7
ver | find "10." && set result=10
echo %result%
if %result%==XP ( goto:winxp )
goto:win7
:win7
echo started win7 module
rem #############################################################################################################
rem #										МАКСИМАЛЬНО ВАЖНОЕ УСЛОВИЕ!!!!!!!!!!!!!!							#
rem #								НЕ ИСПОЛЬЗОВАТЬ, ОТКРЫВАТЬ, ЧИТАТЬ, УДАЛЯТЬ, СМОТРЕТЬ,						#
rem #						НАВОДИТЬ МЫШКОЙ НА ПАПКУ, В КОТОРОЙ СЕЙЧАС ЗАПИСЫВАЕТ СКРИПТ!!!!!!!!!!				#
rem #				ТО ЕСТЬ ЕСЛИ СЕЙЧАС ПИШЕТСЯ ПАПКА ArtemB, В \\Storage\fileserver\pc_config$\,				#
rem #							ТО НЕ ТРОГАТЬ ЕЕ ВООБЩЕ, ПОКА НЕ ЗАКОНЧИТСЯ РАБОТА СКРИПТА						#
rem #	ПОКА НЕТ ОПОВЕЩЕНИЯ О ГОТОВНОСТИ, НО СКОРО БУДЕТ. СЕЙЧАС СКРИПТ В СРЕДНЕМ ОТРАБАТЫВАЕТ ЗА 3-7 МИНУТ, 	#
rem #							В ЗАВИСИМОСТИ ОТ КОЛИЧЕСТВА УСТАНОВЛЕНЫХ ПРОГРАММ У ЮЗЕРА 						#
rem #							(НАПРЯМУЮ ЗАВИСИТ НА СКОРОСТЬ ВЫПОЛНЕНИЯ ШАГА НА 94-96 СТРОКАХ)					#
rem #############################################################################################################

set /p 
chcp 65003 
mkdir \\Storage\fileserver\pc_config$\%UserName%
mkdir \\Storage\fileserver\pc_config$\%UserName%\conf 
mkdir \\Storage\fileserver\pc_config$\%UserName%\conf\programs 
mkdir \\Storage\fileserver\pc_config$\%UserName%\conf\hard
rem используем имя компа для создания папки на сервере
echo %UserName% > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-1.txt
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-1.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-login.txt'"
rem используем имя пользователя		
net user %UserName% /DOMAIN | find "*"> \\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-2.txt		
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-2.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-groups.txt'"

rem hostname >> Получаем имя маашины в домене	
hostname > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-3.txt						
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-3.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-hostname.txt'"

rem Получаем домен, в которой находится машина	
wmic ComputerSystem get domain > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-4.txt	
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-4.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-domain.txt'"

rem Получаем адрес ipv4	
ipconfig | find "IPv4" > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\test.txt			

rem форматируем файл с адресом, убирая лишнее	
type \\Storage\fileserver\pc_config$\%UserName%\conf\hard\test.txt| find "10.71." > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-5.txt			
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-5.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-addr.txt'"

rem Получаем ОС	
wmic os get Caption /value > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-6.txt		
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-6.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-os.txt'"

rem Получаем ключ активации Windows
wmic os get serialnumber > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-tmp.txt		
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-tmp.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-os_serial.txt'"

rem Получаем информацию о процессоре
wmic cpu get Name | find "Intel" > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-7.txt			
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-7.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-cpu.txt'"

rem снимаем оперативку	
wmic computersystem get totalphysicalmemory > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-8.txt		
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-8.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-fram.txt'"

rem берем количество максимальных слотов памяти	
wmic memphysical get MemoryDevices > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-9.txt
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-9.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-nslot.txt'"

rem берем информацию о каждой планке
wmic MEMORYCHIP get capacity > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-10.txt	
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-10.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-slotob.txt'"

rem получаем скорость оперативной памяти	
wmic MEMORYCHIP get speed > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-11.txt		
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-11.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-ramsp.txt'"

rem получаем тип памяти (ddr*  , если 0 - невозможно определить)	
wmic MEMORYCHIP get memorytype > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-12.txt	
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-12.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-ramtype.txt'"

rem информация о жестких дисках	
wmic diskdrive get name,model,size > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-13.txt
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-13.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-disks.txt'"

rem получаем информацию о материнской плате	
wmic baseboard get manufacturer, product > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-14.txt
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-14.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-mother.txt'"

rem получаем информацию о видеоадаптерах
wmic PATH Win32_videocontroller GET description > \\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-video.txt	

rem получаем принтеры и адреса	
wmic printer get name, portname > \\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-printer.txt

rem получаем список названия программ	
wmic product get name > \\Storage\fileserver\pc_config$\%UserName%\conf\programs\program1-1.txt
rem получаем список версий программ	
wmic product get version > \\Storage\fileserver\pc_config$\%UserName%\conf\programs\program2-1.txt	

rem получаем подключенные ftp папки
net use > \\Storage\fileserver\pc_config$\%UserName%\net.txt
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\net.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\net_fold.txt'"

rem По дефолту ставим все имеющиеся дрова. Если нет совпадений, то ставим заново, если есть - ничего не делать
pnputil.exe -e | find "View" > c:\Users\%UserName%\t.txt
set file_for_testing=c:\Users\%UserName%\t.txt
for %%i in ("%file_for_testing%") do (
  if %%~zi==0 (
   goto:end
   )
echo Drivers were installed previously. Check File for make sure.
)
:end
pnputil.exe -i -a \\storage\fileserver\pc_config$\drivers_mon\*.inf > \\storage\fileserver\pc_config$\%UserName%\drive_inst_%date%.txt
echo Drivers were installed now! Check File for make sure.

rem получаем монитор
wmic desktopmonitor get NAME > \\Storage\fileserver\pc_config$\%UserName%\mon.txt
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\mon.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\monitor.txt'"

rem проверяем разрешение удаленного рабочего стола (RDP)
SetLocal EnableExtensions
for /f "tokens=2*" %%a in ('REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections') do set "AppPath=%%~b"
if  %AppPath% LEQ 0x0 (set AppPath=Granted) else (set AppPath=denied)
echo %AppPath% > \\Storage\fileserver\pc_config$\%UserName%\RDP1.txt
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\RDP1.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\RDP.txt'"

rem узнаем активные сессии, а так же способ (удаленно или локально)
quser /server localhost > \\Storage\fileserver\pc_config$\%UserName%\ses.txt
powershell /nologo /noprofile /command "get-content -encoding string '\\Storage\fileserver\pc_config$\%UserName%\ses.txt'|out-file -encoding utf8 '\\Storage\fileserver\pc_config$\%UserName%\session.txt'"
rem удаляем лишние файлы на сервере
@echo off
DEL /F /S /Q /A "%file_for_testing%"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\ses.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\RDP1.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\mon.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\net.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\programs\program1.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\programs\program2.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\hard\hard2.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\video.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\group.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\print.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\hard\test.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-1.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-2.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-3.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-4.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-5.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-6.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-7.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-8.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-9.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-10.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-11.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-12.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-13.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-14.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-tmp.txt"
rem получаем размер рабочего стола пользователя
SetLocal enabledelayedexpansion
Set D=c:\Users\%username%\Desktop
For /F "tokens=1-3" %%a IN ('Dir "%D%" /-C/S/A:-D') Do Set DirSize=!n2!& Set n2=%%c
CAll :var_count "%DirSize%" VarC
Set /A VarC-=6
if %VarC% LEQ 0 (Set DirSizeMB=0) else (Set DirSizeMB=%DirSize:~0,-6%)
if %VarC% GEQ 1 Set DirSizeMB=%DirSizeMB%,!DirSize:~%VarC%,2!
Echo %D% - %DirSizeMB% MB. > \\Storage\fileserver\pc_config$\%UserName%\desk_size.txt
xcopy \\Storage\fileserver\pc_config$\%UserName% /D \\Storage\fileserver\pc_config$\computers\%computername%\ /s /e /y
Goto :eof
 
:var_count %1-Var.Value %2-Var.Count.Result
::Определяет длину переменной
set var=%~1
if not defined var exit /b
set var=%var:~1%
set /a %~2+=1
call :var_count "%var%" %~2
exit /b
exit

:winxp
echo started winxp module
rem #############################################################################################################
rem #										МАКСИМАЛЬНО ВАЖНОЕ УСЛОВИЕ!!!!!!!!!!!!!!							#
rem #								НЕ ИСПОЛЬЗОВАТЬ, ОТКРЫВАТЬ, ЧИТАТЬ, УДАЛЯТЬ, СМОТРЕТЬ,						#
rem #						НАВОДИТЬ МЫШКОЙ НА ПАПКУ, В КОТОРОЙ СЕЙЧАС ЗАПИСЫВАЕТ СКРИПТ!!!!!!!!!!				#
rem #				ТО ЕСТЬ ЕСЛИ СЕЙЧАС ПИШЕТСЯ ПАПКА ArtemB, В \\Storage\fileserver\pc_config$\,				#
rem #							ТО НЕ ТРОГАТЬ ЕЕ ВООБЩЕ, ПОКА НЕ ЗАКОНЧИТСЯ РАБОТА СКРИПТА						#
rem #############################################################################################################

set /p 
chcp 65003 
mkdir \\Storage\fileserver\pc_config$\%UserName%
mkdir \\Storage\fileserver\pc_config$\%UserName%\conf 
mkdir \\Storage\fileserver\pc_config$\%UserName%\conf\programs 
mkdir \\Storage\fileserver\pc_config$\%UserName%\conf\hard
rem используем имя компа для создания папки на сервере
echo %UserName% > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-login.txt

rem используем имя пользователя		
net user %UserName% /DOMAIN | find "*"> \\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-groups.txt		

rem hostname >> Получаем имя маашины в домене	
hostname > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-hostname.txt						

rem Получаем домен, в которой находится машина	
wmic ComputerSystem get domain > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-domain.txt

rem Получаем адрес ipv4	
ipconfig | find "IPv4" > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\test.txt			

rem форматируем файл с адресом, убирая лишнее	
type \\Storage\fileserver\pc_config$\%UserName%\conf\hard\test.txt| find "10.71." > Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-addr.txt		

rem Получаем ОС	
wmic os get Caption /value > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-os.txt	

rem Получаем ключ активации Windows
wmic os get serialnumber > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-os_serial.txt		

rem Получаем информацию о процессоре
wmic cpu get Name | find "Intel" > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-cpu.txt			

rem снимаем оперативку	
wmic computersystem get totalphysicalmemory > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-fram.txt		

rem берем количество максимальных слотов памяти	
wmic memphysical get MemoryDevices > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-nslot.txt

rem берем информацию о каждой планке
echo XP hasn't "memorychip" command > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-slotob.txt

rem получаем скорость оперативной памяти	
echo XP hasn't "memorychip" command > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-ramsp.txt

rem получаем тип памяти (ddr*  , если 0 - невозможно определить)	
echo XP hasn't "memorychip" command > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-ramtype.txt

rem информация о жестких дисках	
wmic diskdrive get name,model,size > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-disks.txt

rem получаем информацию о материнской плате	
wmic baseboard get manufacturer, product > \\Storage\fileserver\pc_config$\%UserName%\conf\hard\%UserName%-mother.txt

rem получаем информацию о видеоадаптерах
wmic PATH Win32_videocontroller GET description > \\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-video.txt	

rem получаем принтеры и адреса	
wmic printer get name, portname > \\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-printer.txt

rem получаем список названия программ	
wmic product get name > \\Storage\fileserver\pc_config$\%UserName%\conf\programs\program1-1.txt
rem получаем список версий программ	
wmic product get version > \\Storage\fileserver\pc_config$\%UserName%\conf\programs\program2-1.txt	

rem получаем подключенные ftp папки
net use > \\Storage\fileserver\pc_config$\%UserName%\net_fold.txt

rem не будем мучать старушку с драйверами на мониторы и т.д

rem удаляем лишние файлы на сервере
DEL /F /S /Q /A "%file_for_testing%"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\ses.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\RDP1.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\mon.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\net.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\programs\program1.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\programs\program2.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\hard\hard2.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\video.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\group.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\print.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\hard\test.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-1.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-2.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-3.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-4.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-5.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-6.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-7.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-8.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-9.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-10.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-11.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-12.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-13.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-14.txt"
DEL /F /S /Q /A "\\Storage\fileserver\pc_config$\%UserName%\conf\%UserName%-tmp.txt"
rem получаем размер рабочего стола пользователя
SetLocal enabledelayedexpansion
Set D=c:\Users\%username%\Desktop
For /F "tokens=1-3" %%a IN ('Dir "%D%" /-C/S/A:-D') Do Set DirSize=!n2!& Set n2=%%c
CAll :var_count "%DirSize%" VarC
Set /A VarC-=6
if %VarC% LEQ 0 (Set DirSizeMB=0) else (Set DirSizeMB=%DirSize:~0,-6%)
if %VarC% GEQ 1 Set DirSizeMB=%DirSizeMB%,!DirSize:~%VarC%,2!
Echo %D% - %DirSizeMB% MB. > \\Storage\fileserver\pc_config$\%UserName%\desk_size.txt
xcopy \\Storage\fileserver\pc_config$\%UserName% /D \\Storage\fileserver\pc_config$\computers\%computername%\ /s /e /y
Goto :eof
 
:var_count %1-Var.Value %2-Var.Count.Result
::Определяет длину переменной
set var=%~1
if not defined var exit /b
set var=%var:~1%
set /a %~2+=1
call :var_count "%var%" %~2
exit /b
exit