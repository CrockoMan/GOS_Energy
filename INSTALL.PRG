***
*** INSTALL1 : format file
*** Generated Январь 1, 1994
***
param kostya
set date german
setcursor(2,7,.t.)
set scoreboard off
set confirm on
set cursor off
setcancel(.f.)
if pcount()=0
        kostya='kos&kos.dbf'
endif
if kostya#chr(107)+chr(111)+chr(115)+chr(38)+chr(105)+chr(110)+chr(115)+chr(116)+chr(97)+chr(108)+chr(108)
        if .not.diskreadyw(diskname())
                set color to w+/n
                ? "Снимите защиту с диска и запустите программу заново !"
                ? ""
                set color to
                quit
        endif
endif
name_=diskname()+':'+dirname(diskname())
wopen(0,0,24,79)
set scoreboard off
SET COLOR TO W/N,+w/bg
CLEAR
@ 00,00 SAY "╔══════════════════════════════════════════════════════════════════════════════╗"
@ 01,00 SAY "║"+space(78)+"║"
@ 02,00 SAY "║                   Производится установка программы ...                       ║"
@ 03,00 SAY "║"+space(78)+"║"
@ 04,00 SAY "╚══════════════════════════════════════════════════════════════════════════════╝"
set color to w+*/n
@ 06,01 say "Идет анализ системы..."
count=adir('*.$@#')
decl dbf[count]
adir("*.$@#",dbf)
SET COLOR TO W/N,+w/bg
puti=space(18)
set conf on
set curs on
@ 06,01 SAY "Введите путь для установки : " get puti picture "X:\XXXXXXXXXXXX"
read
set conf off
set curs off
puti=alltrim(puti)
del=.t.
if lastkey()=27
        wclose()
*       filedelete(exename())
*       fclose(fcreate(exename()))
*       filedelete(exename())
        quit
endif
if len(alltrim(puti))=0.or.len(alltrim(puti))<4
        wclose()
*       filedelete(exename())
*       fclose(fcreate(exename()))
*       filedelete(exename())
        quit
endif
if diskfree(token(puti,'\',1))>3500000
        if diskreadyw(token(puti,'\',1))
                if dirchange(substr(puti,1,1)+':\'+token(puti,'\',2))=0
                        set color to
                        @ 07,01 say 'Создан корневой каталог для АРМ`а "'+upper(substr(puti,1,1)+':\'+token(puti,'\',2))+'"'
                        skolko=copy_(name_+if(len(dirname(diskname()))=1,'start.$@#','\start.$@#'),substr(puti,1,1)+':\'+token(puti,'\',2)+'\arm.exe')
                        if skolko=0
                                del=.f.
                        endif
                else
                        if dirmake(substr(puti,1,1)+':\'+token(puti,'\',2))=0
                                set color to
                                @ 07,01 say 'Создан корневой каталог для АРМ`а "'+upper(substr(puti,1,1)+':\'+token(puti,'\',2))+'"'
                                skolko=copy_(name_+if(len(dirname(diskname()))=1,'start.$@#','\start.$@#'),substr(puti,1,1)+':\'+token(puti,'\',2)+'\arm.exe')
                                if skolko=0
                                        del=.f.
                                endif
                        else
                                set color to r+*/n
                                @ 24,01 say center('Указанный путь "'+alltrim(upper(puti))+'" установить невозможно !',78,' ',.t.)
                                ?? replicate(chr(7),4)
                                inkey(5)
                                wclose()
                                quit
                                del=.f.
                        endif
                endif
        else
                set color to r+*/n
                @ 24,01 say center('Указанный диск "'+token(upper(puti),'\',1)+'" в системе отсутствует !',78,' ',.t.)
                ?? replicate(chr(7),4)
                inkey(5)
                del=.f.
                wclose()
                quit
        endif
else
        set color to r+*/n
        @ 24,01 say center(' Свободного пространства диска "'+token(upper(puti),'\',1)+'" для установки недостаточно !',78,' ',.t.)
        ?? replicate(chr(7),4)
        inkey(5)
        del=.f.
        wclose()
        quit
endif
if del
        set color to
        @ 08,01 say 'Рабочий модуль скопирован в "'+upper(substr(puti,1,1)+':\'+token(puti,'\',2))+'"'
        protect(1)
        dirchange(substr(puti,1,1)+':\'+token(puti,'\',2))
        dirmake(substr(puti,1,1)+':\'+token(puti,'\',2)+'\database')
        dirchange(substr(puti,1,1)+':\'+token(puti,'\',2)+'\database')
        dirmake(substr(puti,1,1)+':\'+token(puti,'\',2)+'\database\#1#2#3')
        dirmake(substr(puti,1,1)+':\'+token(puti,'\',2)+'\database\#4#5')
        dirmake(substr(puti,1,1)+':\'+token(puti,'\',2)+'\database\#6#7#8')
        dirmake(substr(puti,1,1)+':\'+token(puti,'\',2)+'\database\#9#10#11')
        dirmake(substr(puti,1,1)+':\'+token(puti,'\',2)+'\database\#12')
        @ 09,01 say "Созданы каталоги для рабочих баз данных"
        dirchange(substr(puti,1,1)+':\'+token(puti,'\',2))
        dirmake(substr(puti,1,1)+':\'+token(puti,'\',2)+'\text`s')
        @ 10,01 say "Создан каталог для встроенного текстового редактора "
        for j=1 to 5
                for i=1 to count
                        do case
                                case j=1
                                        base='\#1#2#3'
                                case j=2
                                        base='\#4#5'
                                case j=3
                                        base='\#6#7#8'
                                case j=4
                                        base='\#9#10#11'
                                case j=5
                                        base='\#12'
                        endcase
                        if upper(dbf[i])#upper('start.$@#')
                                skolko=copy_(name_+if(len(dirname(diskname()))=1,dbf[i],'\'+dbf[i]),substr(puti,1,1)+':\'+token(puti,'\',2)+'\database'+base+'\'+token(dbf[i],'.',1)+'.dbf')
                        endif
                        if skolko=0
                                exit
                        endif
                next
                if skolko=0
                        exit
                endif
        next
        if skolko#0
                skolko=copy_(name_+if(len(dirname(diskname()))=1,'noname.txt','\noname.txt'),substr(puti,1,1)+':\'+token(puti,'\',2)+'\text`s'+'\noname.txt')
                del=.t.
        else
                del=.f.
        endif
        if skolko#0
                @ 11,01 say "Все книги установлены в рабочие каталоги"
                del=.t.
        else
                del=.f.
        endif
*       protect(1)
        norton='              '
        clear typeahead
        setlastkey(19)
        if skolko#0
                set curs on
                set conf on
                SET COLOR TO W/N,+w/bg
                do while empty(norton)
                        @ 12,01 say "Введите каталог Norton Commander " get norton picture 'X:\XXXXXXXXXXXX'
                        read
                enddo
                set curs off
                set conf off
                SET COLOR TO
                copy_(substr(norton,1,1)+':\'+token(norton,'\',2)+'\nc.mnu',substr(norton,1,1)+':\'+token(norton,'\',2)+"\nc_mnu.arm")
                copy_('c:\autoexec.bat','c:\autoexec.arm')
                copy_('c:\config.sys','c:\config.arm')
                norton=alltrim(upper(norton))
*               substr(norton,1,1)+':\'+token(norton,'\',2)+'\nc.mnu'
                string=''
                if file(substr(norton,1,1)+':\'+token(norton,'\',2)+'\nc.mnu')
                        desc=fopen(substr(norton,1,1)+':\'+token(norton,'\',2)+'\nc.mnu')
                        len=fseek(desc,0,2)
                        fseek(desc,0,0)
                        string=freadstr(desc,len)
                        fclose(desc)
                endif
                string='A: АРМ "Госсектор"'+chr(13)+chr(10)+'  '+substr(puti,1,1)+':'+chr(13)+chr(10)+'  cd '+substr(puti,1,1)+':\'+token(puti,'\',2)+chr(13)+chr(10)+'  arm.exe'+chr(13)+chr(10)+'  cd ..'+chr(13)+chr(10)+string
                desc=fcreate(substr(norton,1,1)+':\'+token(norton,'\',2)+'\nc.mnu')
                fwrite(desc,string)
                fclose(desc)
                @ 13,01 say "Изменен файл NC.MNU"
                string=''
                if file('c:\autoexec.bat')
                        desc=fopen('c:\autoexec.bat')
                        len=fseek(desc,0,2)
                        fseek(desc,0,0)
                        string=freadstr(desc,len)
                        fclose(desc)
                endif
                string='SET CLIPPER=F056'+chr(13)+chr(10)+string
                desc=fcreate('c:\autoexec.bat')
                fwrite(desc,string)
                fclose(desc)
                string=''
                @ 14,01 say "Изменен файл AUTOEXEC.BAT"
                if file('c:\config.sys')
                        desc=fopen('c:\config.sys')
                        len=fseek(desc,0,2)
                        fseek(desc,0,0)
                        string=freadstr(desc,len)
                        fclose(desc)
                endif
                string=string+'FILES=80'+chr(13)+chr(10)+'BUFFERS=20'+chr(13)+chr(10)
                desc=fcreate('c:\config.sys')
                fwrite(desc,string)
                fclose(desc)
                @ 15,01 say "Изменен файл CONFIG.SYS"
        endif
endif


if skolko#0
        set color to g+*/n
        @ 24,0 say center(" Программа установлена ! Нажмите любую клавишу ...",79,' ',.t.)
        set color to w+/n
        @ 20,0 say center("Для полной установки программы прийдется перезапустить Вашу систему ...",79,' ',.t.)
        set color to
        do while diskready('A:')
        set color to w+/n
        @ 22,0 say center(' Удалите диск из устройства "A:"',79,' ',.t.)
        set color to r+/n
        @ 22,0 say center(' Удалите диск из устройства "A:"',79,' ',.t.)
        enddo
        set color to
        inkey(0)
else
        set color to gr+*/r
        @ 24,0 say center(" В процессе установки произошла ошибка, установка не завершена ! ",79,' ',.t.)
        inkey(5)
endif
wclose()
if del                && Удаление программы установки с невозможностью ее
                      && восстановление утилитами  восстановления файлов.
        if kostya#chr(107)+chr(111)+chr(115)+chr(38)+chr(105)+chr(110)+chr(115)+chr(116)+chr(97)+chr(108)+chr(108)
                filedelete(exename())
                fclose(fcreate(exename()))
                filedelete(exename())
                bootwarm()
        endif
endif
quit






func copy_
param source,target,shrift
private ret_val,target,old_scr,total,kol_kl,temp,old_col,error,string,fishka
old_col=setcolor()
old_scr=savescreen(0,0,24,79)
ret_val=0
obrabot()
error=.f.
fishka=.f.       && Все нормально, работаeм
set color to w+/b
if pcount()>=2
        if lower(target)='prn'
                if !printer()
                        restscreen(0,0,24,79,old_scr)
                        setcolor(old_col)
                        RETURN ret_val
                endif
                size = 512*2  && 512
        else
                size = 512*20
        endif
        string='Копирую '+if(lower(target)='prn',source+' на принтер',target)
        if len(string)>44
                string='Копирую ...'+substr(string,len(string)-31)
        endif
        @ 11,19 say center(alltrim(string),44,' ',.t.)
        buffer = SPACE(size)
        total  = 0
        remaining = 0
*       target='prn'
        shandle = FOPEN(source)
        IF FERROR() = 0
                thandle = FCREATE(target)
                IF FERROR() = 0
                        if lower(target)='prn'
                                if pcount()>2
                                        fwrite(thandle,chr(18))
                                else
                                        fwrite(thandle,chr(15))
                                endif
                                fwrite(chr(13)+chr(10))
                        endif
                        total = FSEEK(shandle, 0, 2)
                        remaining = total
                        if upper(target)='PRN'
                                temp_=39.3/total
                        else
                                temp_=39.3/total
                        endif
                        kol_kl=0

                        FSEEK(shandle, 0)

                        DO WHILE (remaining > 0)

                                IF (remaining < size)
                                        size = remaining                        && Last part of file.
                                ENDIF

                                scount = FREAD(shandle, @buffer, size)
                                IF scount <> size
                                        if lower(target)='prn'
                                                Myerror('Ошибка чтения файла отчета (Плохой сeктор ?)')
                                        else
                                                Myerror('Ошибка чтения копируемого файла (Сбой диска?)')
                                                ret_val=0
                                        endif
                                        error=.t.
                                        EXIT
                                ENDIF

                                tcount = FWRITE(thandle, buffer, size)
                                IF tcount <> size
                                        && Myerror('Ошибка передачи данных в принтер. Включите принтер!')
                                        if lower(target)='prn'
                                                fishka=.t.
                                        else
                                                error=.t.
                                                Myerror(' Ошибка записи на диск (Диск полон/Ошибка диска) ')
                                                ret_val=0
                                        endif
                                        EXIT
                                ENDIF


                                kol_kl=kol_kl+temp_*size
                                colorwin(12,21,12,21+kol_kl,'n/n')

                                remaining = remaining - size
                                ret_val=ret_val+scount

                        ENDDO
                        if lower(target)='prn'
                                if pcount()=2
                                        fwrite(thandle,chr(18)+replicate(chr(13)+chr(10),3))
                                else
                                        fwrite(thandle,chr(18)+chr(12))
                                endif
                        endif
                        if error
                                ret_val=0
                        endif
                        FCLOSE(thandle)
*                       sound(5200,5)
*                       sound(2600,3)
                ELSE
                        if upper(target)='PRN'
                                Myerror('Не могу инициализировать принтер (Не подключен ?)')
                        else
                                Myerror(' Ошибка создания нового файла (Диск полон/Ошибка диска?) ')
                                ret_val=0
                        endif
                ENDIF

                FCLOSE(shandle)

        ELSE
                if lower(target)='prn'
                        Myerror(' Не могу открыть файл отчета (Удален ?)')
                else
                        Myerror('Ошибка открытия копируемого файла (Удален ?)')
                        ret_val=0
                endif
        ENDIF
endif
*endif
if error
        deletefile(target)
endif
restscreen(0,0,24,79,old_scr)
setcolor(old_col)
RETURN ret_val
* <EOF> Philes.prg





func error
PARAMETERS msg1,msg2,msg3,msg4,msg5,msg6,msg7,msg8,msg9,msg10
private old_col,old_scr,curs,_a,pcount,msg_,row,col,msg11,i
row=row()
col=col()
if pcount()>=10
        pcount=9
else
        pcount=pcount()-1
endif
curs=csetcurs()
if curs
        set cursor off
endif
old_col=setcolor()
sound(2600,3)
*set color to bg+/b
msg=''
for i=1 to pcount+1
        msg_='msg'+alltrim(str(int(i)))
        msg=if(len(&msg_)>len(msg),&msg_,msg)
next
if empty(msg)
        return '(c) Kostya ltd  < Phone (861-33) 4-37-67 >'
endif
col = INT((80 - LEN(msg))/2) - 2
old_scr=savescreen(10-pcount/2,col,13+pcount/2,col+len(msg)+6)
wope(10-pcount/2,col,13+pcount/2,col+len(msg)+6,'r+/g+','bg+/b')
wope(10-pcount/2,col,13+pcount/2,col+len(msg)+6,'n+/rb+','gr+/r+')
colorwin(11-pcount/2,col+1,13+pcount/2,col+len(msg)+6,'n+/n')
@ 10-pcount/2, col CLEAR TO 12+pcount/2, col + LEN(msg) + 4
@ 10-pcount/2, col,12+pcount/2, col + LEN(msg) + 4  box '┌─╖║╝═╘│ '
@ 10-pcount/2,col+1 say center(" Ошибка ",len(msg),'─',.t.)
colorwin(10-pcount/2,col-3+len(msg)/2,10-pcount/2,col+len(msg)/2+4,'w+/r')
_a=0
for i=11-pcount/2 to 12+pcount/2
        if _a#pcount+1
                _a=_a+1
        else
                exit
        endif
        msg_='msg'+alltrim(str(int(_a)))
        @ i, col+2 SAY &msg_
next
i=INKEY(0)
wclo(10-pcount/2,col,13+pcount/2,col+len(msg)+6)
restscreen(10-pcount/2,col,13+pcount/2,col+len(msg)+6,old_scr)
setcolor(old_col)
if curs
        set cursor on
endif
@ row,col say ''
return i



*******************************************************************************
*                                                                             *
* Функция открывания окна                                                     *
* Параметры: координаты окна, цвета открываемого окна                         *
* Пример :                                                                    *
*        wope(10-pcount/2,col,13+pcount/2,col+len(msg)+6,'n+/rb+','gr+/r+')   *
*                                                                             *
* Возвращает: Символьную строку                                               *
*******************************************************************************
func wope
priv y1,x1,y2,x2,col1,col2,y_1,x_1,y_2,x_2,old_screen
parameters y1,x1,y2,x2,col1,col2
* old_screen=savescreen(y1,x1,y2,x2)

y_1=y1+min(int((y2-y1)/2),(y2-y1)/2)
x_1=x1+min(int((x2-x1)/2),(x2-x1)/2)
y_2=y1+(y2-y1)/2+1
x_2=x1+(x2-x1)/2+1
set color to (col1)
do while x_1>x1.or.y_1>y1
        @ y_1,x_1 clear to y_2,x_2
        @ y_1,x_1, y_2,x_2 box "╔═╗║╝═╚║ "
        x_1=if(x_1>=x1+2,x_1-2,x1)
        x_2=if(x_2<=x2-2,x_2+2,x2)
        y_1=if(y_1>=y1+2,y_1-2,y1)
        y_2=if(y_2<=y2-2,y_2+2,y2)
enddo
* restscreen(y1,x1,y2,x2,old_screen)
set color to (col2)
return '(c) Kostya ltd  < Phone (861-33) 4-37-67 >'

*******************************************************************************
*                                                                             *
* Функция закрывание окна                                                     *
* Параметры: координаты окна                                                  *
* Пример :                                                                    *
*        wclo(10-pcount/2,col,13+pcount/2,col+len(msg)+6)                     *
*                                                                             *
* Возвращает: Символьную строку                                               *
*******************************************************************************
func wclo
private y,x,y1,x1
param y,x,y1,x1,clr
y=y-1
x=x-1
y1=y1+1
x1=x1+1
if pcount()>4
        set color to &clr
else
        set color to
endif
j=0
do while j<=39
        if j=int(j/3.5)*3.5
                y=y+1
                y1=y1-1
        endif
        if j=int(j)
        x=x+1
        x1=x1-1
        endif
        @ y,x,y1,x1 box "        "
        j=j+0.5
enddo
return '(c) Kostya ltd  < Phone (861-33) 4-37-67 >'




function obrabot
param string
private old_col,curs
curs=csetcurs()
if curs
        set cursor off
endif
old_col=setcolor()
colorwin(11,19,15,65,'n+/n')
set color to w/b
@ 10,18 say "┌────────── О Б Р А Б О Т А Н О  :───────────╖"
@ 11,18 say "│"+space(44)+"║"
@ 12,18 say "│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║"
@ 13,18 say "│  0%.......25%......50%......75%......100%  ║"
@ 14,18 say "╘════════════════════════════════════════════╝"
if pcount()#0
        set color to gr+/b
        @ 11,19 say center(string,42,' ',.t.)
endif
setcolor(old_col)
if curs
        set cursor on
endif
return ''






function printer
private ret_val,status
do while .t.
        status=printstat()
        do case
                case status=56
                        if Myerror("     В принтере нет бумаги или  нет      ",;
                                 "     индикации готовности к  печати      ",;
                                 "                        (Esc-выход)      ")=27
                                ret_val=.f.
                                exit
                        endif
                case status=200
                        if Myerror('   Принтер не подключен к сети      ',;
                                 '                   (Esc-выход)      ')=27
                                ret_val=.f.
                                exit
                        endif
                case status=48
                        Myerror('      Принтер  не  обнаружен  !     ',;
                              '         Нажмите любую клавишу     ')
                        ret_val=.f.
                        exit
                case status=40
                        if Myerror('  В принтер не вставлена бумага !    ',;
                                 '                      (Esc-выход)    ')=27
                                ret_val=.f.
                                exit
                        endif
                case status=0
                        if Myerror('  Нет индикации готовности принтера к печати !   ',;
                                 '                                   (Esc-выход)   ')=27
                                ret_val=.f.
                                exit
                        endif
                case status=144
                        ret_val=.t.
                        exit
                otherwise
                        ret_val=.f.
                        Myerror('  Фатальная ошибка принтера, печать не возможна !!! ',;
                              '                           Нажмите любую клавишу... ')
                        exit
        endcase
enddo
return ret_val




func protect
para i_o_p
priv karet,desc,perem,len,kol_13,pos,stroka
file=substr(puti,1,1)+':\'+token(puti,'\',2)+'\kos&kos.dbf'
desc=fcreate(file)
str=charnot(charmirr(alltrim(str(disktotal(substr(puti,1,1))))))+chr(13)+chr(10)
fwrite(desc,str)
str=charnot(charmirr(alltrim(str(disktype(substr(puti,1,1))))))+chr(13)+chr(10)
fwrite(desc,str)
str=charnot(charmirr(alltrim(str(drivetype(substr(puti,1,1))))))+chr(13)+chr(10)
fwrite(desc,str)
str=charnot(charmirr(upper(substr(puti,1,1)+':\'+token(puti,'\',2)+'\arm.exe')))+chr(13)+chr(10)
fwrite(desc,str)
fclose(desc)
return .t.
