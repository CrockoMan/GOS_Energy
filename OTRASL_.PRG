proc OTRASL
LOCAL typ:=0
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,name
private code
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
   if (.not. file(schet_Share+'otrasl.dbf'))
      sign(2)
      set color to (color_buf)
      restscreen(0,0,24,79,buff)
      return
   else
      if select()#55
         select 55
         go top
      endif
   endif
endif
colorwin(5,0,21,79,'w/w')
set color to g+/w
name=alltrim('�।���⨥ '+main->potrebitel)
@ 5,(79-len(name))/2 say name
set color to n/w
name='  ��ࠢ�筨� ���᫥� �஬�諥�����  '
@ 6,(79-len(name))/2 say name
********************************************************************
*       ��।���� ���ᨢ� �������� ����� � ���ᨢ ������ �����ᮢ
********************************************************************
declare zgl[4]
declare fil[4]
nm1=loarr('zgl',"NN",'����� �ந�����⢠ ��� 9��',"���","��த��� 宧-��")
nm2=loarr('fil','Kod_Otr','otrasl',"budget","narod")
code=main->kod_otr
inp='00'
go top
if .not.empty(code)
   locate for kod_otr=code
   set color to w+/b
   @ 2,0 say "            �����  㪠�뢠�� �� ����� �ந�����⢠ ������� �।�����     "
else
   set color to w*/b
   @ 2,0 say "               �롥��  �����  �ந�����⢠  �������  �।�����           "
endif
set color to n/w
******* Begin make box
t1=7
l1=1
b1=20
r1=78
******** End make box
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
return
*********************************



function replace_otrasl
local choice_otrasl:=0,kotr,sel:=select()
choice_otrasl=al_box({"����� �ந�����⢠ ���:"},3,{" 9�� "," ��� "," ���.宧-��"})
//kotr:=kod_otr
select main
do case
   case choice_otrasl=1
        if reclock()
           replace kod_otr with otrasl->kod_otr
           unlock
        else
           al_box({'��� ���᫨ �।����� �� ����ᠭ'})
        endif
   case choice_otrasl=2
        if reclock()
           replace lim_tar1 with otrasl->kod_otr
           unlock
        else
           al_box({'��� ���᫨ �।����� �� ����ᠭ'})
        endif
   case choice_otrasl=3
        if reclock()
           replace lim_tar2 with otrasl->kod_otr
           unlock
        else
           al_box({'��� ���᫨ �।����� �� ����ᠭ'})
        endif
endcase
select(sel)
return NIL
