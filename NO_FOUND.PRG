setcancel(.f.)
sound(30,1)
@ 24,0 say space(79)
set color to w+/n
? "���� ���稪�� ��� ������..."
set color to
?
load('1',dirname()+'\database\licevoj.dbf',dirname()+'\database\schetchi.ntx')
load('2',dirname()+'\database\jan.dbf',dirname()+'\database\jan_kod.ntx')
set deleted on

select 1
no=0
do while !eof()
        @ 24,0 say "������ # "+alltrim(str(recno()))+" ���稪 "+licevoj->schetchik
        select 2
        kod_='('+alltrim(str(licevoj->lic_sch))+')'+licevoj->schetchik
        seek kod_
        if !found()
                @ 24,0 say "�� ������� ����� �� ���稪� "+alltrim(licevoj->schetchik)
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
        @ 24,0 say "�⮣� �� ������� ������ �� "+alltrim(str(no))+if(no#1,' ���稪��',' ���稪�')
        set color to
else
        @ 24,0 say "���稪�� ��� ������ �� ������� !!!"
end
no=0
?
set color to bg+/n
@ 24,0 say "�ந����� ���� ����ﭭ�� ���稪�� (�/�) ?"
set color to
inkey(0)
do while .not.(chr(lastkey()))$"YyNn����"
        inkey(0)
end
if .not. chr(lastkey()) $ "��Yy"
        @ 24,0
        close all
        Quit
end
@ 24,0
set color to w+/n
? "���� ����ﭭ�� ���稪��..."
set color to
select 2
go top
*select 1
*set order to 2
*select 2
del=0
? "���� � �����..."
?
for i=2 to 14
        in_month=0
        do while !eof()
                @ 24,0 say "������ # "+alltrim(str(recno()))+" ���稪 "+licevoj->schetchik
                select 1
                seek b->num_of_sch
                if !found()
                        in_month=in_month+1
                        @ 24,0 say "����ﭭ� ���稪 "+b->num_of_sch+"  ���.��� "+alltrim(str(b->licevoj))
                        ?? "  - ������� (�/�)"
                        sound(4000,2)
                        no=no+1
                        inkey(0)
                        do while .not.(chr(lastkey()))$"YyNn����"
                                inkey(0)
                        end
                        if .not. chr(lastkey()) $ "Nn��"
                                select 2
                                delete
                                del=del+1
                                set color to r+/n
                                ?? " ������"
                                set color to
                                select 1
                        else
                                set color to w+/n
                                ?? " �� 㤠���"
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
                @ 23,20 say "�� ������� !"
        endif
        in_month=0
        @ 24,0
        @ 24,0 say ""
        do case
                case i=3
                        ?? "���� � ���ࠫ�..."
                        load('2',dirname()+'\database\feb.dbf',dirname()+'\database\feb_kod.ntx')
                case i=4
                        ?? "���� � ����..."
                        load('2',dirname()+'\database\mar.dbf',dirname()+'\database\mar_kod.ntx')
                case i=5
                        ?? "���� � ��५�..."
                        load('2',dirname()+'\database\apr.dbf',dirname()+'\database\apr_kod.ntx')
                case i=6
                        ?? "���� � ���..."
                        load('2',dirname()+'\database\may.dbf',dirname()+'\database\may_kod.ntx')
                case i=7
                        ?? "���� � �..."
                        load('2',dirname()+'\database\jun.dbf',dirname()+'\database\jun_kod.ntx')
                case i=8
                        ?? "���� � �..."
                        load('2',dirname()+'\database\jul.dbf',dirname()+'\database\jul_kod.ntx')
                case i=9
                        ?? "���� � ������..."
                        load('2',dirname()+'\database\aug.dbf',dirname()+'\database\aug_kod.ntx')
                case i=10
                        ?? "���� � ������..."
                        load('2',dirname()+'\database\sep.dbf',dirname()+'\database\sep_kod.ntx')
                case i=11
                        ?? "���� � �����..."
                        load('2',dirname()+'\database\oct.dbf',dirname()+'\database\oct_kod.ntx')
                case i=12
                        ?? "���� � ����..."
                        load('2',dirname()+'\database\nov.dbf',dirname()+'\database\nov_kod.ntx')
                case i=13
                        ?? "���� � ������..."
                        load('2',dirname()+'\database\dec.dbf',dirname()+'\database\dec_kod.ntx')
        end
        if i>2
                ?
        endif
next
@ 24,0
if no#0
        set color to g+/n
        @ 24,0 say "�⮣�  ����ﭭ�� ���稪�� => "+alltrim(str(no))+"    ������� => "+alltrim(str(del))
        set color to
else
        @ 24,0 say "����ﭭ�� ���稪�� �� ������� !!!"
end
close all
quit




function load
param oblast,database,ind1,ind2
if file(database)
        do case
                case pcount()=3
                        if .not.file(ind1)
                                Myerror(' ��������� ����� 䠩�. �믮���� ����⠭������� 䠩��� ! ',2)
                                wosst=.t.
                        else
                                select &oblast
                                use &database index &ind1
                        endif
                case pcount()=4
                        if .not.file(ind1).or..not.file(ind2)
                                Myerror(' ��������� ����� 䠩�. �믮���� ����⠭������� 䠩��� ! ',2)
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
        Myerror(' ��������� ����� 䠩�. �믮���� ����⠭������� 䠩��� ! ',2)
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
        msg=msg+' ������ �������...'
else
        if pause=0
                msg=msg+' ������ �������...'
        endif
endif
set color to gr+/r
col = INT((80 - LEN(msg))/2) - 2
old_scr=savescreen(10,col,13,col+len(msg)+6)
colorwin(11,col+1,13,col+len(msg)+6,'+n/n')
@ 10, col CLEAR TO 12, col + LEN(msg) + 4
@ 10, col,12, col + LEN(msg) + 4  box '�ķ���Գ '
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
