@echo off

if "%~1"=="" goto PARAM_ERROR
if "%~2"=="" goto PARAM_ERROR

set SSID=%~1
set PASSWD=%~2
set CONFIG_FILE=Wi-Fi_config_tmp.xml



setlocal EnableDelayedExpansion 
set /p "=%SSID%" <NUL> chr.tmp
for %%a in (chr.tmp) do fsutil file createnew zero.tmp %%~Za > NUL
set "hex="
for /F "skip=1 tokens=2" %%a in ('fc /B chr.tmp zero.tmp') do set "hex=!hex!%%a"
del chr.tmp zero.tmp



(
echo ^<?xml version=^"1.0^"?^>
echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>
echo 	^<name^>%SSID%^</name^>
echo 	^<SSIDConfig^>
echo 		^<SSID^>
echo 			^<hex^>%hex%^</hex^>
echo 			^<name^>%SSID%^</name^>
echo 		^</SSID^>
echo 	^</SSIDConfig^>
echo 	^<connectionType^>ESS^</connectionType^>
echo 	^<connectionMode^>auto^</connectionMode^>
echo 	^<MSM^>
echo 		^<security^>
echo 			^<authEncryption^>
echo 				^<authentication^>WPA2PSK^</authentication^>
echo 				^<encryption^>AES^</encryption^>
echo 				^<useOneX^>false^</useOneX^>
echo 			^</authEncryption^>
echo 			^<sharedKey^>
echo 				^<keyType^>passPhrase^</keyType^>
echo 				^<protected^>false^</protected^>
echo 				^<keyMaterial^>%PASSWD%^</keyMaterial^>
echo 			^</sharedKey^>
echo 		^</security^>
echo 	^</MSM^>
echo 	^<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3"^>
echo 		^<enableRandomization^>false^</enableRandomization^>
echo 	^</MacRandomization^>
echo ^</WLANProfile^>
) > %CONFIG_FILE%

endlocal



netsh wlan add profile filename=%CONFIG_FILE% user=all
netsh wlan set profileparameter name=%SSID% nonBroadcast=yes keymaterial=%PASSWD%



del %CONFIG_FILE% hex.bat
goto END



:PARAM_ERROR
echo "Usage: wifi_setup.bat SSID PASSWD"
exit /B

:END