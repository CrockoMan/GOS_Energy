*******************************************************************************
*
*       ���������� � ���� ������ ���� � �㡠�����⠬�
*
*******************************************************************************
save screen
obrabot(' ���������� ���� "�����஢��" ')
kol_kl=0
temp_=39/12
for e=1 to 12
        ii=alltrim(str(e))+'.dbf'
        sele 1
        use &ii
        pack
        declare my_name[6],my_type[6],my_len[6],my_dec[6]
        my_name[1]='vid_dokum'
        my_name[2]='num_dokum'
        my_name[3]='licevoj'
        my_name[4]='summa'
        my_name[5]='data'
        my_name[6]='reestr_'

        my_type[1]='C'
        my_type[2]='C'
        my_type[3]='N'
        my_type[4]='N'
        my_type[5]='D'
        my_type[6]='N'

        my_len[1]=10
        my_len[2]=7
        my_len[3]=6
        my_len[4]=12
        my_len[5]=8
        my_len[6]=4

        my_dec[1]=0
        my_dec[2]=0
        my_dec[3]=0
        my_dec[4]=2
        my_dec[5]=0
        my_dec[6]=0

        create_dbf('temp.dbf',my_name,my_type,my_len,my_dec)
        sele 2
        use temp
        select 1
        go top
        do while !eof()
                select 2
                append blank
                replace b->vid_dokum with a->vid_dokum
                replace b->num_dokum with a->num_dokum
                replace b->licevoj with a->licevoj
                replace b->summa with a->summa
                replace b->data with a->data
                select 1
                skip
        enddo
        select 2
        skip
        commit
        close all
        copy file temp.dbf to &ii)
        deletefile('temp.dbf')
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
next
restore screen


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
fishka=.f.       && �� ��ଠ�쭮, ࠡ��e�
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
        string='������� '+if(lower(target)='prn',source+' �� �ਭ��',target)
        if len(string)>44
                string='������� ...'+substr(string,len(string)-31)
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
                                temp_=39/total
                        else
                                temp_=39/total
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
                                                Myerror('�訡�� �⥭�� 䠩�� ���� (���宩 �e��� ?)')
                                        else
                                                Myerror('�訡�� �⥭�� �����㥬��� 䠩�� (���� ��᪠?)')
                                        endif
                                        error=.t.
                                        EXIT
                                ENDIF

                                tcount = FWRITE(thandle, buffer, size)
                                IF tcount <> size
                                        && Myerror('�訡�� ��।�� ������ � �ਭ��. ������ �ਭ��!')
                                        if lower(target)='prn'
                                                fishka=.t.
                                        else
                                                error=.t.
                                                Myerror(' �訡�� ����� �� ��� (��� �����/�訡�� ��᪠) ')
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
                                Myerror('�� ���� ���樠����஢��� �ਭ�� (�� ������祭 ?)')
                        else
                                Myerror(' �訡�� ᮧ����� ������ 䠩�� (��� �����/�訡�� ��᪠?) ')
                        endif
                ENDIF

                FCLOSE(shandle)

        ELSE
                if lower(target)='prn'
                        Myerror(' �� ���� ������ 䠩� ���� (������ ?)')
                else
                        Myerror('�訡�� ������ �����㥬��� 䠩�� (������ ?)')
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
@ 10,18 say "����������� � � � � � � � � � �  :����������ķ"
@ 11,18 say "�"+space(44)+"�"
@ 12,18 say "�  ����������������������������������������  �"
@ 13,18 say "�  0%.......25%......50%......75%......100%  �"
@ 14,18 say "��������������������������������������������ͼ"
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
@ 10-pcount/2, col,12+pcount/2, col + LEN(msg) + 4  box '�ķ���Գ '
@ 10-pcount/2,col+1 say center(" �訡�� ",len(msg),'�',.t.)
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
* �㭪�� ���뢠��� ����                                                     *
* ��ࠬ����: ���न���� ����, 梥� ���뢠����� ����                         *
* �ਬ�� :                                                                    *
*        wope(10-pcount/2,col,13+pcount/2,col+len(msg)+6,'n+/rb+','gr+/r+')   *
*                                                                             *
* �����頥�: ��������� ��ப�                                               *
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
        @ y_1,x_1, y_2,x_2 box "�ͻ���Ⱥ "
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
* �㭪�� ����뢠��� ����                                                     *
* ��ࠬ����: ���न���� ����                                                  *
* �ਬ�� :                                                                    *
*        wclo(10-pcount/2,col,13+pcount/2,col+len(msg)+6)                     *
*                                                                             *
* �����頥�: ��������� ��ப�                                               *
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
                        if Myerror("     � �ਭ�� ��� �㬠�� ���  ���      ",;
                                 "     ������樨 ��⮢���� �  ����      ",;
                                 "                        (Esc-��室)      ")=27
                                ret_val=.f.
                                exit
                        endif
                case status=200
                        if Myerror('   �ਭ�� �� ������祭 � ��      ',;
                                 '                   (Esc-��室)      ')=27
                                ret_val=.f.
                                exit
                        endif
                case status=48
                        Myerror('      �ਭ��  ��  �����㦥�  !     ',;
                              '         ������ ���� �������     ')
                        ret_val=.f.
                        exit
                case status=40
                        if Myerror('  � �ਭ�� �� ��⠢���� �㬠�� !    ',;
                                 '                      (Esc-��室)    ')=27
                                ret_val=.f.
                                exit
                        endif
                case status=0
                        if Myerror('  ��� ������樨 ��⮢���� �ਭ�� � ���� !   ',;
                                 '                                   (Esc-��室)   ')=27
                                ret_val=.f.
                                exit
                        endif
                case status=144
                        ret_val=.t.
                        exit
                otherwise
                        ret_val=.f.
                        Myerror('  ��⠫쭠� �訡�� �ਭ��, ����� �� �������� !!! ',;
                              '                           ������ ���� �������... ')
                        exit
        endcase
enddo
return ret_val
