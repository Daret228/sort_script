@echo off
setlocal enableDelayedExpansion

rem ✅ Запрос директории для сортировки (по умолчанию текущая)
set /p "folderPath=Enter the folder to sort (default: %cd%): "
if "%folderPath%"=="" set "folderPath=%cd%"

rem ❌ Проверка существования директории
if not exist "%folderPath%" (
    echo ❌ The specified path does not exist. Please try again.
    pause
    exit /b 1
)

rem ✅ Запрос имени папки для сортировки (по умолчанию SORT)
set /p "subdirName=Enter the name for the sorted folder (default: SORT): "
if "%subdirName%"=="" set "subdirName=SORT"

rem 📂 Определяем путь для сортировки
set "sortedPath=%folderPath%\%subdirName%"

rem ✅ Создание основной папки для сортировки
md "%sortedPath%\Folders" 2>nul

rem 🔄 Цикл по всем папкам (исключая папку сортировки)
for /d %%D in ("%folderPath%\*") do (
    if /i "%%D" neq "%sortedPath%" (
        move "%%D" "%sortedPath%\Folders" >nul
        echo 📂 Moved folder "%%~nxD" to "%sortedPath%\Folders\"
    )
)

rem 🔄 Цикл по всем файлам
for %%F in ("%folderPath%\*.*") do (
    set "ext=%%~xF"

    rem ✅ Обработка файлов без расширений
    if not defined ext set "ext=No_Extension"
    if "!ext:~0,1!"=="." set "ext=!ext:~1!"

    rem 📁 Создание папки для расширения (только если её ещё нет)
    if not exist "%sortedPath%\!ext!\" md "%sortedPath%\!ext!"

    rem 📄 Перемещение файла
    move "%%F" "%sortedPath%\!ext!" >nul
    echo 📄 Moved "%%~nxF" to "%sortedPath%\!ext!\"
)

echo ✅ Sorting complete! Files are in "%sortedPath%"
pause
