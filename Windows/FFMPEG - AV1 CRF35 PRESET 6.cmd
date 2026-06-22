@echo off
setlocal enabledelayedexpansion

set /a count=0
set /a total=0

if "%~1"=="" (
    for %%F in (*.mp4 *.mov *.mkv *.avi *.m4v *.webm) do if exist "%%F" (
        echo %%~nxF | findstr /i /c:"[AV1" >nul || set /a total+=1
    )
    for %%F in (*.mp4 *.mov *.mkv *.avi *.m4v *.webm) do if exist "%%F" (
        echo %%~nxF | findstr /i /c:"[AV1" >nul || (
            set /a count+=1
            title [!count!/!total!] Converting: %%~nxF
            call :convert "%%~fF"
        )
    )
) else (
    for %%A in (%*) do (
        if exist "%%~fA\" (
            for %%F in ("%%~fA\*.mp4" "%%~fA\*.mov" "%%~fA\*.mkv" "%%~fA\*.avi" "%%~fA\*.m4v" "%%~fA\*.webm") do (
                echo %%~nxF | findstr /i /c:"[AV1" >nul || set /a total+=1
            )
        ) else if exist "%%~fA" (
            echo %%~nxA | findstr /i /c:"[AV1" >nul || set /a total+=1
        )
    )
    for %%A in (%*) do (
        if exist "%%~fA\" (
            for %%F in ("%%~fA\*.mp4" "%%~fA\*.mov" "%%~fA\*.mkv" "%%~fA\*.avi" "%%~fA\*.m4v" "%%~fA\*.webm") do (
                echo %%~nxF | findstr /i /c:"[AV1" >nul || (
                    set /a count+=1
                    title [!count!/!total!] Converting: %%~nxF
                    call :convert "%%~fF"
                )
            )
        ) else if exist "%%~fA" (
            echo %%~nxA | findstr /i /c:"[AV1" >nul || (
                set /a count+=1
                title [!count!/!total!] Converting: %%~nxA
                call :convert "%%~fA"
            )
        )
    )
)

title Done - !count! file^(s^) converted to AV1
echo.
echo Finished: !count! file(s) converted.
pause
exit /b

:convert
ffmpeg -n -i "%~1" ^
    -c:v libsvtav1 ^
    -preset 6 ^
    -crf 35 ^
    -c:a copy ^
    "%~dpn1 [AV1 CRF35 P6].mkv"

if !errorlevel! equ 0 (
    title [!count!/!total!] Done: %~nx1
) else (
    title [!count!/!total!] FAILED: %~nx1
)
exit /b
