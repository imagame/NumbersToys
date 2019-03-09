@echo off

:: Set working dir
cd %~dp0 & cd ..

set PAUSE_ERRORS=1
call bat\SetupSDK.bat
call bat\SetupApp.bat

:target
goto desktop
::goto android-debug
::goto android-test
::set INTERPRETER=-interpreter
::goto ios-debug
::goto ios-test

:desktop
:: http://help.adobe.com/en_US/air/build/WSfffb011ac560372f-6fa6d7e0128cca93d31-8000.html

set SCREEN_SIZE=NexusOne
::set SCREEN_SIZE=iPhoneRetina
::set SCREEN_SIZE=NexusOne
::set SCREEN_SIZE=iPadRetina
::set SCREEN_SIZE=iPhone6Plus
::set SCREEN_SIZE=iPhone6
::set SCREEN_SIZE=Droid
::set SCREEN_SIZE=SamsungGalaxyS
::set SCREEN_SIZE=SamsungGalaxyTab
::set SCREEN_SIZE=2560x1600:400x640
::set SCREEN_SIZE=2560x1600:375x667 
::set SCREEN_SIZE=2560x1600:621x1104
::set SCREEN_SIZE=2732x2048: iPhone|iPhoneRetina|iPhone5Retina|iPhone6|iPhone6Plus|iPod|iPodRetina|iPod5Retina|iPad|iPadRetina|Droid|NexusOne|SamsungGalaxyS|SamsungGalaxyTab|QVGA|WQVGA|FWQVGA|HVGA|WVGA|FWVGA|1080|720|480


:desktop-run
echo.
echo Starting AIR Debug Launcher with screen size '%SCREEN_SIZE%'
echo.
echo (hint: edit 'Run.bat' to test on device or change screen size)
echo.
adl -screensize %SCREEN_SIZE% "%APP_XML%" "%APP_DIR%"
if errorlevel 1 goto end
goto endNoPause

:ios-debug
echo.
echo Packaging application for debugging on iOS %INTERPRETER%
if "%INTERPRETER%" == "" echo (this will take a while)
echo.
set TARGET=-debug%INTERPRETER%
set OPTIONS=-connect %DEBUG_IP%
goto ios-package

:ios-test
echo.
echo Packaging application for testing on iOS %INTERPRETER%
if "%INTERPRETER%" == "" echo (this will take a while)
echo.
set TARGET=-test%INTERPRETER%
set OPTIONS=
goto ios-package

:ios-package
set PLATFORM=ios
call bat\Packager.bat

if "%AUTO_INSTALL_IOS%" == "yes" goto ios-install
echo Now manually install and start application on device
echo.
goto end

:ios-install
echo Installing application for testing on iOS (%DEBUG_IP%)
echo.
call adt -installApp -platform ios -package "%OUTPUT%"
if errorlevel 1 goto installfail

echo Now manually start application on device
echo.
goto end

:android-debug
echo.
echo Packaging and installing application for debugging on Android (%DEBUG_IP%)
echo.
set TARGET=-debug
set OPTIONS=-connect %DEBUG_IP%
goto android-package

:android-test
echo.
echo Packaging and Installing application for testing on Android (%DEBUG_IP%)
echo.
set TARGET=
set OPTIONS=
goto android-package

:android-package
set PLATFORM=android
call bat\Packager.bat

adb devices
echo.
echo Installing %OUTPUT% on the device...
echo.
adb -d install -r "%OUTPUT%"
if errorlevel 1 goto installfail

echo.
echo Starting application on the device for debugging...
echo.
adb shell am start -n air.%APP_ID%/.AppEntry
exit

:installfail
echo.
echo Installing the app on the device failed

:end
pause

:endNoPause

