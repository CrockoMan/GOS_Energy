#INCLUDE "Inkey.ch"
*******************************
*********
****
*
proc limit
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,;
bufer,name,old_edit1
t1=0
l1=0
b1=0
r1=0
old_sel1=select()
rec_buf1=recno()
ord_buf1=indexord()
buff1=savescreen(0,0,24,79)
color_buf1=setcolor()
if urov<1
if (.not. file(schet_share+'limit.dbf')) .or. (.not. file(schet_share+'lic_limi.ntx'))
        sign(2)
        set color to (color_buf1)
        restscreen(0,0,24,79,buff1)
        return
else
        if select()#33
                select 33
        endif
endif
*colorwin(2,0,24,79,'n+/n')
old_edit1=edit
//if .not.edit
//        edit=.t.
//else
//        edit=.f.
//endif
//edit=.t.
set color to
endif
*brshelp(22)
set color to n/w
@ 1,3 clear to 7,77
set filter to lic_schet=main->lic_schet
go top
name=alltrim(main->potrebitel)
@ 2,(79-len(name))/2 say name
name='Справочник лимитов на энергию '
@ 1,(79-len(name))/2 say name
declare zgl[12]
declare fil[12]
nm1=loarr('zgl','Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь')
nm2=loarr('fil','jan','feb','mac','apr','may','jun','jul','aug','sep','oct','nov','dec')
inp='000000000000'
************ Begin make box
t1=3
l1=3
b1=7
r1=77
l1=3
*************  End make
colorwin(4,4,8,78,'n+/n')
keyboard replicate(chr(K_RIGHT),IF(day(New_date)>15,month(New_date+1),Month(New_date)-1)+1)+chr(K_LEFT)
fsbrowse(3,3,7,77,'fil','zgl',inp,urov,kl)
set filter to
select(old_sel1)
set color to (color_buf1)
set order to ord_buf1
go rec_buf1
restscreen(0,0,24,79,buff1)
edit=old_edit1
return



Function Limit2()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=Setcolor()
SET COLOR TO &GetColor
ColorWin(6,20,20,61,"n+/n")
@ 05,20 SAY "┌──────────────────────────────────────╖"
@ 06,20 SAY "│                Утро         Вечер    ║"
@ 07,20 SAY "│ Январь"+space(31)+"║"
@ 08,20 SAY "│ Февраль"+space(30)+"║"
@ 09,20 SAY "│ Март"+space(33)+"║"
@ 10,20 SAY "│ Апрель"+space(31)+"║"
@ 11,20 SAY "│ Май"+space(34)+"║"
@ 12,20 SAY "│ Июнь"+space(33)+"║"
@ 13,20 SAY "│ Июль"+space(33)+"║"
@ 14,20 SAY "│ Август"+space(31)+"║"
@ 15,20 SAY "│ Сентябрь"+space(29)+"║"
@ 16,20 SAY "│ Октябрь"+space(30)+"║"
@ 17,20 SAY "│ Ноябрь"+space(31)+"║"
@ 18,20 SAY "│ Декабрь"+space(30)+"║"
@ 19,20 SAY "╘══════════════════════════════════════╝"
Select Limit2

IF RecLock()
   Set Cursor On
   Set Confirm On
   @ 07,35 GET JAN1
   @ 07,49 GET JAN2
   @ 08,35 GET FEB1
   @ 08,49 GET FEB2
   @ 09,35 GET MAC1
   @ 09,49 GET MAC2
   @ 10,35 GET APR1
   @ 10,49 GET APR2
   @ 11,35 GET MAY1
   @ 11,49 GET MAY2
   @ 12,35 GET JUN1
   @ 12,49 GET JUN2
   @ 13,35 GET JUL1
   @ 13,49 GET JUL2
   @ 14,35 GET AUG1
   @ 14,49 GET AUG2
   @ 15,35 GET SEP1
   @ 15,49 GET SEP2
   @ 16,35 GET OCT1
   @ 16,49 GET OCT2
   @ 17,35 GET NOV1
   @ 17,49 GET NOV2
   @ 18,35 GET DEC1
   @ 18,49 GET DEC2
   Read
   Set Cursor Off
   Set Confirm Off
ENDIF
Clear Typeahead
SetColor(Clr)
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL


function limit_raschet
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,;
bufer,name,old_edit1,month,power,limit,kol_kl,temp_
old_sl=select()
rec_bf=recno()
ord_bf=indexord()
bff=savescreen(0,0,24,79)
color_bf=setcolor()
mon_th=month_menu()
power=0
if mon_th>0
        obrabot("Анализ расхода за "+mesqc(mon_th)+' месяц')
        do case
                case mon_th=1
                        limit=limit->jan
                case mon_th=2
                        limit=limit->feb
                case mon_th=3
                        limit=limit->mac
                case mon_th=4
                        limit=limit->apr
                case mon_th=5
                        limit=limit->may
                case mon_th=6
                        limit=limit->jun
                case mon_th=7
                        limit=limit->jul
                case mon_th=8
                        limit=limit->aug
                case mon_th=9
                        limit=limit->sep
                case mon_th=10
                        limit=limit->oct
                case mon_th=11
                        limit=limit->nov
                case mon_th=12
                        limit=limit->dec
        endcase
        select 77
        go top
        temp_=39/reccount()
        kol_kl=0
        do while .not.eof()
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if lic_sch#main->lic_schet
                        skip
                else
                        select(mon_th)
                        poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
                        seek poisk
                        if found().and..not.deleted()
if tarif#schet_tar1.and.tarif#schet_tar2.and.tarif#schet_tar3.and.;
tarif#schet_tar4.and.tarif#schet_tar5.and.tarif#schet_tar6.and.tarif#schet_tar7.and.;
tarif#schet_tar8.and.tarif#schet_tar9
                                        if .not.empty(tarif)
                                                if drug_nach=.F.
                                                        power=power+rashod
                                                endif
                                        endif
                                endif
                        endif
                        select 77
                        skip
                endif
        enddo
        colorwin(12,21,12,21+39,'n/n')
        power=round(power/1000,2)
        e_rror("      Расход за "+mesqc(mon_th)+' месяц :='+alltrim(str(power))+'     ',;
               "      Лимит на этот месяц :=   "+alltrim(str(limit))+'       ',;
               "      "+if(power>limit,'Перерасход '+alltrim(str(power-limit))+'т.квтч.',;
                        if(power<limit,'Недорасход '+alltrim(str(limit-power))+'т.квтч.','') ))
endif
select(old_sl)
set color to (color_bf)
set order to ord_bf
go rec_bf
restscreen(0,0,24,79,bff)
return .t.