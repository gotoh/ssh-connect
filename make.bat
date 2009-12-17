@echo off
setlocal

REM *** build script for win32 environment.
REM compiler selection
REM  msc    ... Microsoft Visual Studio
REM  bcc    ... Borland C
REM  cygwin ... Cygwin GNU C
REM  mingw  ... MinGW GNU C

REM set default copiler
if x%COMPILER% == x set COMPILER=%1
if x%COMPILER% == x set COMPILER=msc
if %COMPILER%==msc     set CMD=cl /nologo connect.c wsock32.lib advapi32.lib
if %COMPILER%==bcc     set CMD=bcc32  connect.c wsock32.lib advapi32.lib
if %COMPILER%==cygwin  set CMD=gcc connect.c -o connect
if %COMPILER%==mingw   set CMD=gcc -mno-cygwin connect.c -o connect

echo %CMD%
%CMD%

endlocal
