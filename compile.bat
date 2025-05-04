@echo off

if "%~1"=="" (
    echo No master file name specified.
    echo Usage: compile.bat main_file_name.pas
    exit /b 1
)

gpc %~1 AlphabetUtils.pas TextUtils.pas WordTree.pas TextProcessor.pas
