setcancel(.f.)
sound(30,1)
@ 24,0 say space(79)
set color to w+/n
? "Поиск счетчиков без данных..."
set color to
?
load('1',dirname()+'\database\licevoj.dbf',dirname()+'\database\schetchi.ntx')
load('2',dirname()+'\database\jan.dbf',dirname()+'\database\jan_kod.ntx')
set deleted on

select 1
no=0
do while !eof()
        @ 24,0 say "Запись # "+alltrim(str(recno()))+" Счетчик "+licevoj->schetchik
        select 2
        kod_='('+alltrim(str(licevoj->lic_sch))+')'+licevoj->schetchik
        seek kod_
        if !found()
                @ 24,0 say "Не найдены данные по счетчику "+alltrim(licevoj->schetchik)
                ?? "  "+alltrim(licevoj->potreb)
                ?
                sound(4000,2)
                no=no+1
        endif
        select 1
        skip
end
@ 24,0 say space(70)
if no#0
        set color to g+/n
        @ 24,0 say "Итого не найдено данных по "+alltrim(str(no))+if(no#1,' счетчикам',' счетчику')
        set color to
else
        @ 24,0 say "Счетчиков без данных не найдено !!!"
end
no=0
?
set color to bg+/n
@ 24,0 say "Произвести поиск потерянных счетчиков (Д/Н) ?"
set color to
inkey(0)
do while .not.(chr(lastkey()))$"YyNnДдНн"
        inkey(0)
end
if .not. chr(lastkey()) $ "ДдYy"
        @ 24,0
        close all
        Quit
end
@ 24,0
set color to w+/n
? "Поиск потерянных счетчиков..."
set color to
select 2
go top
*select 1
*set order to 2
*select 2
del=0
? "Поиск в Январе..."
?
for i=2 to 14
        in_month=0
        do while !eof()
                @ 24,0 say "Запись # "+alltrim(str(recno()))+" Счетчик "+licevoj->schetchik
                select 1
                seek b->num_of_sch
                if !found()
                        in_month=in_month+1
                        @ 24,0 say "Потерянный счетчик "+b->num_of_sch+"  Лиц.счет "+alltrim(str(b->licevoj))
                        ?? "  - Удалить (Д/Н)"
                        sound(4000,2)
                        no=no+1
                        inkey(0)
                        do while .not.(chr(lastkey()))$"YyNnДдНн"
                                inkey(0)
                        end
                        if .not. chr(lastkey()) $ "NnНн"
                                select 2
                                delete
                                del=del+1
                                set color to r+/n
                                ?? " УДАЛЕН"
                                set color to
                                select 1
                        else
                                set color to w+/n
                                ?? " Не удален"
                                set color to
                        end
                        ?
                        sound(4000,2)
                endif
                select 2
                skip
        enddo
        select 2
        use
        if in_month=0
                @ 23,20 say "НЕ НАЙДЕНО !"
        endif
        in_month=0
        @ 24,0
        @ 24,0 say ""
        do case
                case i=3
                        ?? "Поиск в Феврале..."
                        load('2',dirname()+'\database\feb.dbf',dirname()+'\database\feb_kod.ntx')
                case i=4
                        ?? "Поиск в Марте..."
                        load('2',dirname()+'\database\mar.dbf',dirname()+'\database\mar_kod.ntx')
                case i=5
                        ?? "Поиск в Апреле..."
                        load('2',dirname()+'\database\apr.dbf',dirname()+'\database\apr_kod.ntx')
                case i=6
                        ?? "Поиск в Мае..."
                        load('2',dirname()+'\database\may.dbf',dirname()+'\database\may_kod.ntx')
                case i=7
                        ?? "Поиск в Июне..."
                        load('2',dirname()+'\database\jun.dbf',dirname()+'\database\jun_kod.ntx')
                case i=8
                        ?? "Поиск в Июле..."
                        load('2',dirname()+'\database\jul.dbf',dirname()+'\database\jul_kod.ntx')
                case i=9
                        ?? "Поиск в Августе..."
                        load('2',dirname()+'\database\aug.dbf',dirname()+'\database\aug_kod.ntx')
                case i=10
                        ?? "Поиск в Сентябре..."
                        load('2',dirname()+'\database\sep.dbf',dirname()+'\database\sep_kod.ntx')
                case i=11
                        ?? "Поиск в Октябре..."
                        load('2',dirname()+'\database\oct.dbf',dirname()+'\database\oct_kod.ntx')
                case i=12
                        ?? "Поиск в Ноябре..."
                        load('2',dirname()+'\database\nov.dbf',dirname()+'\database\nov_kod.ntx')
                case i=13
                        ?? "Поиск в Декабре..."
                        load('2',dirname()+'\database\dec.dbf',dirname()+'\database\dec_kod.ntx')
        end
        if i>2
                ?
        endif
next
@ 24,0
if no#0
        set color to g+/n
        @ 24,0 say "Итого  потерянных счетчиков => "+alltrim(str(no))+"    Удалено => "+alltrim(str(del))
        set color to
else
        @ 24,0 say "Потерянных счетчиков не найдено !!!"
end
close all
quit




function load
param oblast,database,ind1,ind2
if file(database)
        do case
                case pcount()=3
                        if .not.file(ind1)
                                Myerror(' Отсутствует важный файл. Выполните восстановление файлов ! ',2)
                                wosst=.t.
                        else
                                select &oblast
                                use &database index &ind1
                        endif
                case pcount()=4
                        if .not.file(ind1).or..not.file(ind2)
                                Myerror(' Отсутствует важный файл. Выполните восстановление файлов ! ',2)
                                wosst=.t.
                        else
                                select &oblast
                                use &database index &ind1,&ind2
                        endif
                otherwise
                        select &oblast
                        use &database
        endcase
else
        Myerror(' Отсутствует важный файл. Выполните восстановление файлов ! ',2)
        wosst=.t.
endif
return .t.


FUNCTION Error
PARAMETERS msg,pause
private old_col,old_scr,tone,ret_val,curs
curs=csetcurs()
if curs
        set cursor off
endif
old_col=setcolor()
if pcount()=1
        msg=msg+' Нажмите клавишу...'
else
        if pause=0
                msg=msg+' Нажмите клавишу...'
        endif
endif
set color to gr+/r
col = INT((80 - LEN(msg))/2) - 2
old_scr=savescreen(10,col,13,col+len(msg)+6)
colorwin(11,col+1,13,col+len(msg)+6,'+n/n')
@ 10, col CLEAR TO 12, col + LEN(msg) + 4
@ 10, col,12, col + LEN(msg) + 4  box '┌─╖║╝═╘│ '
@ 11, col + 2 SAY msg
sound(1300,5)
sound(2600,3)
sound(3900,2)
sound(5200,5)
if pcount()=2
        ret_val=INKEY(pause)
else
        ret_val=inkey(0)
endif
sound(5200,5)
sound(3900,2)
sound(2600,3)
sound(1300,5)
restscreen(10,col,13,col+len(msg)+6,old_scr)
setcolor(old_col)
if curs
        set cursor on
endif
RETURN ret_val
************************************************* End of function
