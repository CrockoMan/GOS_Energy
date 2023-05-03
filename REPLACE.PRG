*******************************************************************************
*
*       Добавление к базе данных поля с субабонентами
*
*******************************************************************************
wopen(0,0,24,79)
set curs off
obrabot("Обрабатываются базы данных")
dir=diskname()+':'+dirname()
decl dbf[12]
dbf[1]='jan'
dbf[2]='feb'
dbf[3]='mar'
dbf[4]='apr'
dbf[5]='may'
dbf[6]='jun'
dbf[7]='jul'
dbf[8]='aug'
dbf[9]='sep'
dbf[10]='oct'
dbf[11]='nov'
dbf[12]='dec'
find=dir+'\database\jan.dbf'
use &find
*if field(13)='SUBAB'
*       error(" Перезапись баз уже была осуществлена !  ",;
*              ' Повторную перезапись осуществить нельзя.',;
*             '                                         ',;
*              '     Для окончания нажмите любую клавишу.')
*       set curs on
*       wclose()
*       quit
*endif

temp1=39/13
kol1kl=0

for tprp=1 to 12
        decl my_name[13],my_len[13],my_type[13],my_dec[13]
        my_name[1]='kod'
        my_name[3]='pokazaniq'
        my_name[2]='month'
        my_name[4]='raznica'
        my_name[5]='koeficient'
        my_name[6]='rashod'
        my_name[7]='tarif'
        my_name[8]='summa'
        my_name[9]='num_of_sch'
        my_name[10]='licevoj'
        my_name[11]='percent'
        my_name[12]='drug_nach'
        my_name[13]='subab'

        my_len[1]=14
        my_len[2]=2
        my_len[3]=5
        my_len[4]=5
        my_len[5]=5
        my_len[6]=9
        my_len[7]=8
        my_len[8]=12
        my_len[9]=6
        my_len[10]=6
        my_len[11]=5
        my_len[12]=1
        my_len[13]=6

        my_type[1]='C'
        my_type[2]='N'
        my_type[3]='N'
        my_type[4]='N'
        my_type[5]='N'
        my_type[6]='N'
        my_type[7]='N'
        my_type[8]='N'
        my_type[9]='C'
        my_type[10]='N'
        my_type[11]='N'
        my_type[12]='L'
        my_type[13]='N'

        my_dec[1]=0
        my_dec[2]=0
        my_dec[3]=0
        my_dec[4]=0
        my_dec[5]=0
        my_dec[6]=0
        my_dec[7]=3
        my_dec[8]=2
        my_dec[9]=0
        my_dec[10]=0
        my_dec[11]=2
        my_dec[12]=0
        my_dec[13]=0
        do case
                case tprp=1
                        create_dbf(Ddir+'\database\jan_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=2
                        create_dbf(Ddir+'\database\feb_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=3
                        create_dbf(Ddir+'\database\mar_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=4
                        create_dbf(Ddir+'\database\apr_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=5
                        create_dbf(Ddir+'\database\may_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=6
                        create_dbf(Ddir+'\database\jun_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=7
                        create_dbf(Ddir+'\database\jul_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=8
                        create_dbf(Ddir+'\database\aug_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=9
                        create_dbf(Ddir+'\database\sep_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=10
                        create_dbf(Ddir+'\database\oct_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=11
                        create_dbf(Ddir+'\database\nov_.dbf',my_name,my_type,my_len,my_dec)
                case tprp=12
                        create_dbf(Ddir+'\database\dec_.dbf',my_name,my_type,my_len,my_dec)
        endcase
        olddbf=dir+'\database\'+dbf[tprp]+'.dbf'
        tempdb=dir+'\database\'+dbf[tprp]+'_'+'.dbf'
        sele 1
        use &olddbf
        sele 2
        use &tempdb
        sele 1
        do while !eof()
                sele 2
                append blank
                replace b->kod with a->kod
                replace b->pokazaniq with a->pokazaniq
                replace b->month with a->month
                replace b->raznica with a->raznica
                replace b->koeficient with a->koeficient
                replace b->rashod with a->rashod
                replace b->tarif with a->tarif
                replace b->summa with a->summa
                replace b->num_of_sch with a->num_of_sch
                replace b->licevoj with a->licevoj
                replace b->percent with a->percent
                replace b->drug_nach with a->drug_nach
                replace b->subab with a->subab
                sele 1
                skip
        enddo
        commit
        sele 1
        use
        sele 2
        use
        copy_(tempdb,olddbf)
        deletefile(tempdb)
        kol1kl=kol1kl+temp1
        colorwin(12,21,12,21+kol1kl,'n/n')
next


decl my_name[11],my_len[11],my_type[11],my_dec[11]
my_name[1]='kod'
my_name[2]='month'
my_name[3]='pokazaniq'
my_name[4]='raznica'
my_name[5]='koeficient'
my_name[6]='rashod'
my_name[7]='tarif'
my_name[8]='summa'
my_name[9]='recno'
my_name[10]='percent'
my_name[11]='subab'

my_len[1]=14
my_len[2]=2
my_len[3]=5
my_len[4]=5
my_len[5]=5
my_len[6]=9
my_len[7]=7
my_len[8]=12
my_len[9]=10
my_len[10]=5
my_len[11]=6

my_type[1]='C'
my_type[2]='N'
my_type[3]='N'
my_type[4]='N'
my_type[5]='N'
my_type[6]='N'
my_type[7]='N'
my_type[8]='N'
my_type[9]='N'
my_type[10]='N'
my_type[11]='N'

my_dec[1]=0
my_dec[2]=0
my_dec[3]=0
my_dec[4]=0
my_dec[5]=0
my_dec[6]=0
my_dec[7]=4
my_dec[8]=2
my_dec[9]=0
my_dec[10]=2
my_dec[11]=0
create_dbf(Ddir+'\database\all_mon.dbf',my_name,my_type,my_len,my_dec)
olddbf=Ddir+'\database\all_month.dbf'
tempdb=Ddir+'\database\all_mon.dbf'
sele 1
use &olddbf
sele 2
use &tempdb
sele 1
do while !eof()
        sele 2
        append blank
        replace b->kod with a->kod
        replace b->month with a->month
        replace b->pokazaniq with a->pokazaniq
        replace b->raznica with a->raznica
        replace b->koeficient with a->koeficient
        replace b->rashod with a->rashod
        replace b->tarif with a->tarif
        replace b->summa with a->summa
        replace b->recno with a->recno
        replace b->percent with a->percent
        sele 1
        skip
enddo
commit
sele 1
use
sele 2
use
copy_(tempdb,olddbf)
deletefile(tempdb)
colorwin(12,21,12,60,'n/n')
set curs on
wclose()
quit




func create_dbf
para my_file,my_name,my_type,my_len,my_dec
priv old_sel

if pcount()<5
   priv my_dec[len(my_name)]
   afill(my_dec,0)
endif

old_sel=select()
select 0
create vrem_f
use vrem_f
for i=1 to len(my_name)
     append blank
     replace Field_name with my_name[i]
     replace Field_type with my_type[i]
     replace Field_len with my_len[i]
     replace Field_dec with my_dec[i]
next
use
create &my_file from vrem_f
use
erase vrem_f.dbf
select(old_sel)
return .t.


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
                        endif
                ENDIF

                FCLOSE(shandle)

        ELSE
                if lower(target)='prn'
                        Myerror(' Не могу открыть файл отчета (Удален ?)')
                else
                        Myerror('Ошибка открытия копируемого файла (Удален ?)')
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
*sound(2600,3)
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
old_screen=savescreen(y1,x1,y2,x2)

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
restscreen(y1,x1,y2,x2,old_screen)
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
param y,x,y1,x1
y=y-1
x=x-1
y1=y1+1
x1=x1+1
set color to
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
