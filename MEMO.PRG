proc help
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel
set key 28 to
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
*if urov<1
        if (.not. file(Ddir+'help.dbf')) .or. (.not. file(Ddir+'help.dbt'))
                sign(13)
                set color to (color_buf)
                restscreen(0,0,24,79,buff)
                set key 28 to help
                return
        else
                select 222
        endif
*endif
set color to
brshelp(2)
colorwin(3,21,20,61,'n+/n')
set color to n/bg+
declare zgl[1]
declare fil[1]
nm1=loarr('zgl','   Выберите опцию меню помощи  ')
nm2=loarr('fil','help->help')
inp='00000'
go top
t1=2
l1=20
b1=19
r1=60
fsbrowse(3,10,20,50,'fil','zgl',inp,urov,kl)
select(old_SEL)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
*set key 28 to help
return
*********************************
