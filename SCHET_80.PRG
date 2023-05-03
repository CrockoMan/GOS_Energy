proc schetN80
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
@ 0,0 clear to 24,79
set color to w+*/n
@ 10 ,32 say 'ANALYSING..'
if (.not. file(schet_share+'main.dbf')) .or. (.not. file(schet_share+'lic.ntx')) .or.(.not. file(schet_Share+'potrebit.ntx'))
        sign(2)
        set color to (color_buf)
        restscreen(0,0,24,79,buff)
        return
else
        if select()#88
                select 88
        endif
endif
//edit=.f.
@ 0,0 clear to 24,79
set color to w/n
endif
brshelp(20)
set color to n/w
@ 6, 0 clear to 20,79
@ 6, 8 say ' Р А Б О Т А   П О   В О С Ь М И Д Е С Я Т О М У   С Ч Е Т У  '
declare zgl[5]
declare fil[5]
nm1=loarr('zgl','Лиц.счет','           П о т р е б и т е л ь ','Номер дог.','Дата дог.','Отрасль')
nm2=loarr('fil','lic_schet','potrebitel','dogowor','data_dog','kod_otr')
inp='12000'
go top
t1=7
l1=1
b1=20
r1=78
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
//edit=.t.
return
*********************************
