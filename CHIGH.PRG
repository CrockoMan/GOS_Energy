*******************************************************************************
** ���� ���� ����襭��� ������ ��� �� � ��� ᠫ줮 ����襭��� � ����
** � 㬥��襭�� (㢥��祭��) ����⮢ �� NN%
**
**      � FS1.PRG ��⠢��� ��ப� � �����襩 Shift-F6 ��� -15 limitpercent
**      B ARM.CLP - (chigh)
**
*******************************************************************************





procedure limitpercent
private sel,rec,temp,kol_kl,screen,period,what,color
if yes_or_not("     �ந����� ���४�஢�� ����⮢ ?    ")
        color=setcolor()
        sel=select()
        rec=recno()
        save screen to screen
        set color to n/w,w+/b
        colorwin(09,30,14,53,'n+/n')
        @ 08,28,13,51 box "         "
        @ 08,29 say "��������������������ķ"
        @ 09,29 say "� �� ����⠫         �"
        @ 10,29 say "� �� �����           �"
        @ 11,29 say "� �� ���             �"
        @ 12,29 say "� �⪠������         �"
        @ 13,29 say "��������������������ͼ"
        @ 09,30 prompt " �� ����⠫         "
        @ 10,30 prompt " �� �����           "
        @ 11,30 prompt " �� ���             "
        @ 12,30 prompt " �⪠������         "
        menu to period
        do case
                case period=1
                        set color to +w/b,n/w
                        colorwin(11,32,16,60,'n+/n')
                        @ 10,30,15,58 box "         "
                        @ 10,31 say "�������������������������ķ"
                        @ 11,31 say "� ���� ����⠫          �"
                        @ 12,31 say "� ��ன ����⠫          �"
                        @ 13,31 say "� ��⨩ ����⠫          �"
                        @ 14,31 say "� ��⢥��� ����⠫       �"
                        @ 15,31 say "�������������������������ͼ"
                        @ 11,32 prompt " ���� ����⠫          "
                        @ 12,32 prompt " ��ன ����⠫          "
                        @ 13,32 prompt " ��⨩ ����⠫          "
                        @ 14,32 prompt " ��⢥��� ����⠫       "
                        menu to what
                        do case
                                case what=1
                                        changepercent()
                                case what=2
                                        changepercent()
                                case what=3
                                        changepercent()
                                case what=4
                                        changepercent()
                        endcase
                case period=2
                        what=month_menu()
                        if what>0
                                changepercent()
                        endif
                case period=3
                        changepercent()
        endcase
        setcolor(color)
        restore screen from screen
        select(sel)
        go rec
endif
return


proc saldohighpenq
return




func changepercent
private plus,minus,clr,percent
percent=000.000
plus=000.00
minus=000.00
clr=setcolor()
save screen
set color to n/w,n/w
colorwin(15,23,19,63,'n+/n')
@ 15,21,18,61 box "         "
@ 15,21 say "���������������������������������������ķ"
@ 16,21 say "� �����樥�� 㢥��祭�� ����� 999.99% �"
@ 17,21 say "� �����樥�� 㬥��襭�� ����� 999.99% �"
@ 18,21 say "���������������������������������������ͼ"
set cursor on
set confirm on
do while .t.
        @ 16,53 get plus picture "@K 999.99"
        @ 17,53 get minus picture "@K 999.99"
        read
        if lastkey()=27
                do case
                        case empty(plus).and..not.empty(minus)
                                percent=-1*minus
                                limitconfirm()
                                exit
                        case empty(minus).and..not.empty(plus)
                                percent=plus
                                limitconfirm()
                                exit
                        case empty(minus).and.empty(plus)
                                percent=0
                                exit
                        otherwise
                                e_rror("       ��� ���� ���������. ����� �������� ����������.       ")
                endcase
        endif
enddo
Clear Typeahead
set cursor off
set confirm off
restore screen
setcolor(clr)
return percent


func limitconfirm
private oldsel,oldrec,temp_,kol_kl
oldsel=select()
oldrec=recno()
select limit
go top
temp_=39/reccount()
kol_kl=0
obrabot("��������� ����� �� "+alltrim(str(abs(percent),12,2))+'%')
do while .not.eof()
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        do case
                case period=1
                        do case
                                case what=1
                                        replace jan with jan+round(((percent*jan)/100),2)
                                        replace feb with feb+round(((percent*feb)/100),2)
                                        replace mac with mac+round(((percent*mac)/100),2)
                                case what=2
                                        replace apr with apr+round(((percent*apr)/100),2)
                                        replace may with may+round(((percent*may)/100),2)
                                        replace jun with jun+round(((percent*jun)/100),2)
                                case what=3
                                        replace jul with jul+round(((percent*jul)/100),2)
                                        replace aug with aug+round(((percent*aug)/100),2)
                                        replace sep with sep+round(((percent*sep)/100),2)
                                case what=4
                                        replace oct with oct+round(((percent*oct)/100),2)
                                        replace nov with nov+round(((percent*nov)/100),2)
                                        replace dec with dec+round(((percent*dec)/100),2)
                        endcase
                case period=2
                        do case
                                case what=1
                                        replace jan with jan+round(((percent*jan)/100),2)
                                case what=2
                                        replace feb with feb+round(((percent*feb)/100),2)
                                case what=3
                                        replace mac with mac+round(((percent*mac)/100),2)
                                case what=4
                                        replace apr with apr+round(((percent*apr)/100),2)
                                case what=5
                                        replace may with may+round(((percent*may)/100),2)
                                case what=6
                                        replace jun with jun+round(((percent*jun)/100),2)
                                case what=7
                                        replace jul with jul+round(((percent*jul)/100),2)
                                case what=8
                                        replace aug with aug+round(((percent*aug)/100),2)
                                case what=9
                                        replace sep with sep+round(((percent*sep)/100),2)
                                case what=10
                                        replace oct with oct+round(((percent*oct)/100),2)
                                case what=11
                                        replace nov with nov+round(((percent*nov)/100),2)
                                case what=12
                                        replace dec with dec+round(((percent*dec)/100),2)
                        endcase
                case period=3
                        replace jan with jan+round(((percent*jan)/100),2)
                        replace feb with feb+round(((percent*feb)/100),2)
                        replace mac with mac+round(((percent*mac)/100),2)
                        replace apr with apr+round(((percent*apr)/100),2)
                        replace may with may+round(((percent*may)/100),2)
                        replace jun with jun+round(((percent*jun)/100),2)
                        replace jul with jul+round(((percent*jul)/100),2)
                        replace aug with aug+round(((percent*aug)/100),2)
                        replace sep with sep+round(((percent*sep)/100),2)
                        replace oct with oct+round(((percent*oct)/100),2)
                        replace nov with nov+round(((percent*nov)/100),2)
                        replace dec with dec+round(((percent*dec)/100),2)
        endcase
        skip
enddo
seek main->lic_schet
select(oldsel)
go oldrec
return .t.