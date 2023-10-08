# GOS_Energy
xBase
для сборки EXE использовать следующие инструкции:
@echo off
rem del %1.exe
rem masm %1.asm %1.obj %1.lst nul /s
rem if not errorlevel 1 tlink %1.obj,,con
rem exe2bin %1.exe %1.com
rem %1
arm32 no_intro //swapk:65535</br>
 Автор: [К.Гурашкин](<https://github.com/CrockoMan>)
