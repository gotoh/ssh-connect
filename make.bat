@echo off
setlocal

REM *** build script for win32 environment.
REM compiler selection
REM  msc    ... Microsoft Visual Studio
REM  bcc    ... Borland C
REM  cygwin ... Cygwin GNU C
REM  mingw  ... MinGW GNU C

REM set default copiler
set DOPT=SOCKLEN_T=unsigned
if x%COMPILER% == x set COMPILER=%1
if x%COMPILER% == x set COMPILER=msc
if %COMPILER%==msc     set CMD=cl /nologo /D%DOPT%  connect.c wsock32.lib iphlpapi.lib advapi32.lib
if %COMPILER%==bcc     set CMD=bcc32 /D%DOPT% connect.c wsock32.lib iphlpapi.lib advapi32.lib
if %COMPILER%==cygwin  set CMD=gcc -D%DOPT% connect.c -o connect
if %COMPILER%==mingw   set CMD=gcc -D%DOPT% connect.c -o connect -lwsock32 -liphlpapi

echo %CMD%
%CMD%

endlocal
