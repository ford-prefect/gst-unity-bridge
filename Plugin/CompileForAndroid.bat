@echo on
REM TODO add checks for Ant/NDK/JDK/Android SDK

SET target-version=21

echo android version %target-version%
CALL android update project -p . -s --target android-%target-version%
echo project updated

CALL ndk-build APP_ABI=armeabi-v7a
xcopy /S /Y libs\* ..\Unity\Assets\Plugins\Android

CALL ant clean
CALL ant release
cd bin/classes
CALL jar cvf gub.jar org/*
xcopy /Y gub.jar ..\..\..\Unity\Assets\Plugins\Android

cd ..
cd ..

echo Successfully compiled for Armv7, android version %target-version%
