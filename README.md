# GOS_Energy
Учёт потребления и оплаты электроэнергии абонентами энергосбытовой компании</br>
Стек: xBase, ODBC, DBF, dBase </br></br>
для сборки и запуска использовать следующие инструкции:</br>
@echo off</br>
del %1.exe</br>
masm %1.asm %1.obj %1.lst nul /s</br>
if not errorlevel 1 tlink %1.obj,,con</br>
exe2bin %1.exe %1.com</br>
%1</br>
arm32 no_intro //swapk:65535</br></br>
 Автор: [К.Гурашкин](<https://github.com/CrockoMan>)
