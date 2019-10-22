@echo off
cls

masm32\bin\ML /c /coff %1.asm
if errorlevel 1 goto terminate

masm32\bin\link /SUBSYSTEM:CONSOLE /LIBPATH:masm32\lib %1.obj

if errorLevel 1 goto terminate

echo OK

:terminate