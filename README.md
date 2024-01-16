# GOS_Energy
Стек: xBase, ODBC, DBF, dBase </br></br>
для сборки и запуска EXE использовать следующие инструкции:</br>
@echo off</br>
rem del %1.exe</br>
rem masm %1.asm %1.obj %1.lst nul /s</br>
rem if not errorlevel 1 tlink %1.obj,,con</br>
rem exe2bin %1.exe %1.com</br>
rem %1</br>
arm32 no_intro //swapk:65535</br></br>
 Автор: [К.Гурашкин](<https://github.com/CrockoMan>)
