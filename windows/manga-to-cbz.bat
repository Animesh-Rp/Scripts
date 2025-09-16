@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM Set base folders
set "SOURCE_ROOT=%~dp0"
set "PANELS_ROOT=%SOURCE_ROOT%\..\Panels"

REM Path to 7z.exe — adjust if necessary
set "zipper=C:\Program Files\7-Zip\7z.exe"

echo Starting CBZ generation for all manga in: %SOURCE_ROOT%
echo Output will go to: %PANELS_ROOT%
echo.

REM Loop through all manga folders in Downloads
for /d %%M in ("%SOURCE_ROOT%\*") do (
    set "manga_name=%%~nM"
    set "manga_path=%%~fM"
    set "output_folder=%PANELS_ROOT%\!manga_name!"

    echo.
    echo ==== Processing "!manga_name!" ====

    REM Create output folder for this manga if it doesn't exist
    if not exist "!output_folder!" (
        echo Creating folder: !output_folder!
        mkdir "!output_folder!"
    )

    REM Loop through each chapter folder inside the manga
    for /d %%C in ("!manga_path!\*") do (
        set "chapter_name=%%~nC"
        set "cbz_file=!output_folder!\!chapter_name!.cbz"

        if exist "!cbz_file!" (
            echo Skipping "!chapter_name!" - CBZ already exists.
        ) else (
            echo Zipping "!chapter_name!" into !cbz_file!

            pushd "%%C"
            "!zipper!" a -tzip -r "!cbz_file!" * >nul
            popd

            echo Done: !chapter_name!.cbz
        )
    )
)

echo.
echo ✅ All manga processed. CBZ files stored in Panels folder.
pause
