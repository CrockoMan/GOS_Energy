proc debkred
private old_col,old_scr,edkredit,eddebet
IF F_Script<=12.and.Asc(Substr(Main->LockMonth,F_Script,1))==F_Script
   Al_Box({"��������� ���⪠ ����饭�"})
   Return
ENDIF
IF .NOT.IsCorrect("��������� ᠫ줮")
   Return
ENDIF
old_col=setcolor()
old_scr=savescreen(8,22,12,54)
colorwin(9,23,12,54,'n+/n')
edkredit=if(f_script<=12,'kredit'+alltrim(str(f_script)),"last_kred")
eddebet=if(f_script<=12,'debet'+alltrim(str(f_script)),"Last_debet")
SET COLOR TO &GetColor
@ 08,22 SAY "������������������������������Ŀ"
@ 09,22 SAY "�"+space(30)+"�"
@ 10,22 SAY "�"+space(30)+"�"
@ 11,22 SAY "��������������������������������"
@ 8,23 say center(' '+mesqc(f_script)+' ',29,'�',.t.)
SET COLOR TO W/B,w+/bg,,,w/b
@ 09,23 SAY "    �।��                    "
@ 10,23 SAY "    �����                     "
set curs on
set conf on
if reclock()
   do while .t.
        @ 9,35 get &edkredit
        @ 10,35 get &eddebet
        read
        if lastkey()=27
           Clear Typeahead
           exit
        endif
   enddo
   unlock
endif
set curs off
set conf off
setcolor(old_col)
restscreen(8,22,12,54,old_scr)
return




Function obormot()
Local TypeOborot:=Al_Box({"�   ��ᬮ����  �������  ���������   �"},3,{" ���������ࣨ� "," �����஢����� "," ��室 "})
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,found
Private change,name,old_sel
IF TypeOborot==3
   Return NIL
ELSEIF TypeOborot==2
   AOborot()
   Return NIL
ENDIF
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
old_sel=select()
select 15
set filter to lic_schet=main->lic_schet
go top
set color to n/w
@ 1,3 say replicate(' ',73)
name=alltrim('�।���⨥ '+main->potrebitel)
@ 1,(79-len(name))/2 say name
set color to n/w
declare zgl[14]
declare fil[14]

jan=if(empty(debet1),'kredit1','debet1')
feb=if(empty(debet2),'kredit2','debet2')
mac=if(empty(debet3),'kredit3','debet3')
apr=if(empty(debet4),'kredit4','debet4')
may=if(empty(debet5),'kredit5','debet5')
jun=if(empty(debet6),'kredit6','debet6')
jul=if(empty(debet7),'kredit7','debet7')
aug=if(empty(debet8),'kredit8','debet8')
sep=if(empty(debet9),'kredit9','debet9')
oct=if(empty(debet10),'kredit10','debet10')
nov=if(empty(debet11),'kredit11','debet11')
dec=if(empty(debet12),'kredit12','debet12')

jan_=if(empty(debet1),'������;�।��','������;�����')
feb_=if(empty(debet2),'���ࠫ�;�।��','���ࠫ�;�����')
mac_=if(empty(debet3),' ���� ;�।��',' ���� ;�����')
apr_=if(empty(debet4),'��५�;�।��','��५�;�����')
may_=if(empty(debet5),' ��� ;�।��',' ��� ;�����')
jun_=if(empty(debet6),'���;�।��','���;�����')
jul_=if(empty(debet7),'���;�।��','���;�����')
aug_=if(empty(debet8),'������;�।��','������;�����')
sep_=if(empty(debet9),'�������;�।��','�������;�����')
oct_=if(empty(debet10),'������;�।��','������;�����')
nov_=if(empty(debet11),'�����;�।��','�����;�����')
dec_=if(empty(debet12),'�������;�।��','�������;�����')
nm1=loarr('fil',jan,feb,mac,apr,may,jun,jul,aug,sep,oct,nov,dec,'last_debet','last_kred')
nm2=loarr('zgl',jan_,feb_,mac_,apr_,may_,jun_,jul_,aug_,sep_,oct_,nov_,dec_,'���.�����','���.�।��')
inp='00000000000000'
************ Begin make box
t1=2   && Up
l1=3   && Left
b1=7  && Down
r1=77  && Right
*************  End make
colorwin(3,4,8,78,'n+/n')
keyboard replicate(chr(4),month(New_date))+chr(19)
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
set filter to
go recno()
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
return NIL
*********************************




Function AOborot()
Local Color:=SetColor(),Win:=Win_Save(),Sel:=Select(),Rec:=RecNo()
Select Obormot
KeyBoard Replicate(Chr(13),Month(New_date))
ColorWin(5,12,19,73,"n+/n")
Set Color To &GetColor
@ 03,11 SAY "���������������� �����஢����� ��魮��� ��������������������ķ"
@ 04,11 SAY "�  �����       �  ���᫥��   �   ����祭�   �  ���줮       �"
@ 05,11 SAY "� �������      �              �              �               �"
@ 06,11 SAY "� ������       �              �              �               �"
@ 07,11 SAY "� ���ࠫ�      �              �              �               �"
@ 08,11 SAY "� ����         �              �              �               �"
@ 09,11 SAY "� ��५�       �              �              �               �"
@ 10,11 SAY "� ���          �              �              �               �"
@ 11,11 SAY "� ���         �              �              �               �"
@ 12,11 SAY "� ���         �              �              �               �"
@ 13,11 SAY "� ������       �              �              �               �"
@ 14,11 SAY "� �������     �              �              �               �"
@ 15,11 SAY "� ������      �              �              �               �"
@ 16,11 SAY "� �����       �              �              �               �"
@ 17,11 SAY "� �������      �              �              �               �"
@ 18,11 SAY "������������������������������������������������������������ͼ"

@ 05,62 say Str(SALDOA,10,Decimal)
For i=1 to 12
    @ 05+i,31 Say Replicate("?",10)
    @ 05+i,31 Say Str(GetAbonSum(Main->Lic_Schet,i)+GetAbonSum(Main->Lic_Schet,i)*Schet_Nds/100,10,Decimal)
    @ 05+i,46 Say Replicate("?",10)
    @ 05+i,46 Say Str(CalckPay(i,Main->Lic_Schet,.f.,4),10,Decimal)
    @ 05+i,62 Say Replicate("?",10)
    @ 05+i,62 Say Str(IF(GetAbonSaldo(Main->Lic_Schet,i)>0,GetAbonSaldo(Main->Lic_Schet,i),-1*GetAbonSaldo(Main->Lic_Schet,i)),10,Decimal)
    @ 05+i,58 Say IF(GetAbonSaldo(Main->Lic_Schet,i)>0,"��",IF(GetAbonSaldo(Main->Lic_Schet,i)<0,"��",""))
Next
Clear TypeAhead
Hot_Inkey(0)

/*
IF RecLock()
   Set Cursor  On
   Set Confirm On
   @ 05,37 GET SALDOA
   @ 06,37 GET SALDOA1
   @ 07,37 GET SALDOA2
   @ 08,37 GET SALDOA3
   @ 09,37 GET SALDOA4
   @ 10,37 GET SALDOA5
   @ 11,37 GET SALDOA6
   @ 12,37 GET SALDOA7
   @ 13,37 GET SALDOA8
   @ 14,37 GET SALDOA9
   @ 15,37 GET SALDOA10
   @ 16,37 GET SALDOA11
   @ 17,37 GET SALDOA12
   Read
   Set Cursor  Off
   Set Confirm Off
   UNLOCK
ENDIF
*/
SetColor(Color)
Win_Rest(Win)
Select(Sel)
Go Rec
Return NIL