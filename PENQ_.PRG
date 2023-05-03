
proc penq
private chioce,old_col1,old_scr1,scr__
old_col1=setcolor()
old_scr1=savescreen(10,26,16,48)
        set color to w/b,w/n
        colorwin(11,27,16,48,'n+/n')
        @ 10,26,15,47 box "         "
        @ 10,27 say "┌──── П Е Н Я ─────╖"
        @ 11,27 say "│    Начислить     ║"
        @ 12,27 say "│   Просмотреть    ║"
        @ 13,27 say "│   Отпечатать     ║"
        @ 14,27 say "│      Выход       ║"
        @ 15,27 say "╘══════════════════╝"
        do while .t.
                @ 11,28 prompt "    Начислить     "
                @ 12,28 prompt "   Просмотреть    "
                @ 13,28 prompt "   Отпечатать     "
                @ 14,28 prompt "      Выход       "
                menu to choice
                do case
                        case choice=1
                                save screen to scr__
                                message('   Начисляю ...   ')
                                do penq2
                                restore screen from scr__
                        case choice=2
                                do penq1
                        case choice=3
                                if file(Ddir+'otchet.gkv')
                                        copy_(Ddir+'otchet.gkv','prn')
                                endif
                        otherwise
                                exit
                endcase
        enddo
setcolor(old_col1)
restscreen(10,26,16,48,old_scr1)
return


*******************************
*********
****
*
proc penq1
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,;
bufer,name,old_edit,found
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
if (.not. file(schet_Share+'penq.dbf')) .or. (.not. file(schet_Share+'lic_penq.ntx'))
        sign(2)
        set color to (color_buf)
        restscreen(0,0,24,79,buff)
        return
else
*       if select()#99
                select 99
*       endif
endif
set filter to licevoj=main->lic_schet
seek main->lic_schet
old_edit=edit
edit=.f.
set color to
endif
*brshelp(22)
set color to n/w
*@ 1,3 clear to 7,77
name=alltrim(main->potrebitel)
@ 2,0 say center(name,80,' ',.t.)
*@ 2,(79-len(name))/2 say name
name='Справочник начисления пени  '+alltrim(main->lic_schet)
@ 1,0 say center(name,80,' ',.t.)
*@ 1,(79-len(name))/2 say name
found=0
seek main->lic_schet
for i=1 to 12
        penq='penq'+alltrim(str(i))
        found=if(empty(&penq),found,found+1)
next
if found>0
        declare zgl[found*2]
        declare fil[found*2]
        found=0
        for i=1 to 12
                penq='penq'+alltrim(str(i))
                if !empty(&penq)
                        found=found+1
                        zgl[found]=mesqc(i)+';  пеня'
                        fil[found]='penq'+alltrim(str(i))
                        found=found+1
                        zgl[found]='Опоздание;{ дней }'
                        fil[found]='data'+alltrim(str(i))
                endif
        next
        inp='000000000000'
        ************ Begin make box
        t1=3   && Up
        l1=3   && Left
        b1=7   && Down
        r1=77  && Right
        *************  End make
        colorwin(4,4,8,78,'n+/n')
        fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
else
        al_box({'Начисленной пени за '+alltrim(str(year(new_date)))+' год не найдено.'})
endif
set filter to
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
edit=old_edit
return





/*
*proc penq2
private month,base,oplata,sele,old_ind,dni,kredit_last,scr,form,is_oplata,tscr:=win_save()
old_ind=indexord()
sele=select()
month=month_menu()
is_oplata=.f.
if month>0
        if month#2
                oplata=ctod('31.'+if(len(alltrim(str(month)))=2,alltrim(str(month)),'0'+alltrim(str(month)))+'.'+substr(alltrim(str(year(new_date))),3,2))
        else
                oplata=ctod('27.'+if(len(alltrim(str(month)))=2,alltrim(str(month)),'0'+alltrim(str(month)))+'.'+substr(alltrim(str(year(new_date))),3,2))
        endif
        do case
                case month=1
                        oplata=ctod('31.01.'+substr(alltrim(str(year(new_date))),3,2))
                case month=2
                        oplata=ctod('27.02.'+substr(alltrim(str(year(new_date))),3,2))
                case month=3
                        oplata=ctod('31.03.'+substr(alltrim(str(year(new_date))),3,2))
                case month=4
                        oplata=ctod('30.04.'+substr(alltrim(str(year(new_date))),3,2))
                case month=5
                        oplata=ctod('31.05.'+substr(alltrim(str(year(new_date))),3,2))
                case month=6
                        oplata=ctod('30.06.'+substr(alltrim(str(year(new_date))),3,2))
                case month=7
                        oplata=ctod('31.07.'+substr(alltrim(str(year(new_date))),3,2))
                case month=8
                        oplata=ctod('31.08.'+substr(alltrim(str(year(new_date))),3,2))
                case month=9
                        oplata=ctod('30.09.'+substr(alltrim(str(year(new_date))),3,2))
                case month=10
                        oplata=ctod('31.10.'+substr(alltrim(str(year(new_date))),3,2))
                case month=11
                        oplata=ctod('30.11.'+substr(alltrim(str(year(new_date))),3,2))
                case month=12
                        oplata=ctod('31.12.'+substr(alltrim(str(year(new_date))),3,2))
        endcase
        base=path_copy+'O'+alltrim(str(round(month,0)))+'.Dbf'
        load('44',base)
        win_rest(tscr)
        go top
        do while .not.eof()
                if licevoj=main->lic_schet
                        if data<oplata
                                oplata=data
                        endif
                        is_oplata=.t.
*                        @ 0,0 say "Первая оплата "+dtoc(oplata)
*                        colorwin(0,0,0,0+len("Первая оплата"+dtoc(oplata)),'w+/n')
                endif
                skip
        enddo
        if !empty(oplata)
                if month(oplata)=month
                        dni=day(oplata)-day(ctod('01.'+alltrim(str(month))+'.'+alltrim(str(year(new_date)))))
                        if dni>0
                                kredit_last=if(month>1,'kredit'+alltrim(str(M->month-1)),'last_kred')
                                kredit_pres=if(month>1,'kredit'+alltrim(str(M->month)),'last_kred')
                                                go top
select 77
go top
sum_rashod=0
                                                do while .not.eof()
                                                        if lic_sch#main->lic_schet
                                                                skip
                                                        else
                                                                if month-1#0
                                                                        select(month-1)
                                                                else
                                                                        select 12
                                                                endif
                                                                poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
                                                                seek poisk
                                                                        if found().and..not.deleted()
                                                                                sum_rashod=sum_rashod+summa
                                                                        endif
                                                                select 77
                                                                skip
                                                        endif
                                                enddo
****************************************************
                                        select 15
                                        seek main->lic_schet
*error(str(sum_rashod)+str(&kredit_last))
                                        if obormot->&kredit_last-sum_rashod<0
                                                sum_rashod=0
                                                select 77
                                                save screen
                                                obrabot(" Расчет пени по предприятию ")
                                                temp_=40/reccount()
                                                kol_kl=0
                                                go top
                                                do while .not.eof()
                                                        kol_kl=kol_kl+temp_
                                                        colorwin(12,21,12,21+kol_kl,'n/n')
                                                        if lic_sch#main->lic_schet
                                                                skip
                                                        else
                                                                if month-1#0
                                                                        select(month-1)
                                                                else
                                                                        select 12
                                                                endif
                                                                poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
                                                                seek poisk
                                                                        if found().and..not.deleted()
                                                                                sum_rashod=sum_rashod+summa
                                                                        endif
                                                                select 77
                                                                skip
                                                        endif
                                                enddo
                                                colorwin(12,21,12,61,'n/n')
//                                                penq=round((obormot->&kredit_last-sum_rashod*schet_penq/100)*dni,2)
                                                penq=round((sum_rashod*schet_penq/100)*dni,2)
penq=if(penq>0,penq,0)
                                                nalog3=round(penq*schet_dnal/100,0)
                                                nalog_=round(penq*schet_nds/100,0)
                                                nalog3=0
                                                nalog_=0
                                                penq=penq+nalog_+nalog3
                                                ppenq='penq'+alltrim(str(month))
                                                pdata='data'+alltrim(str(month))
                                                replace penq->&ppenq with round(penq,0)
                                                replace penq->&pdata with dni
                mesqcpenq='penqn'+alltrim(str(int(month)))
                replace obormot->&mesqcpenq with penq->&ppenq
                                                restore screen
                                                colorwin(12,31,14,52,'n+/n')
                                                set color to
if penq->&ppenq>0
 @ 1,0 say ""
 ? chr(7)
        if main->is_poruch
                do ptp
        else
                do pt
        endif
// Запись платежки в базу данных TOBANK.DBF
        writetobank(main->lic_schet,"пеня за "+mesqc(month))
//Запись платежки в базу данных TOBANK.DBF
endif
                                        endif
                        else
                             al_box({'Оплата произведена своевременно,','пеня не начисляется. '})
                        endif
                else
                        al_box({'Оплата произведена своевременно,','пеня не начисляется. '})
                endif
        else
                al_box({"         В н и м а н и е !",;
                         'Дата поступления оплаты не введена,',;
                         'начислить невозможно.'})
        endif
endif
select(sele)
set order to old_ind
restscreen(10,0,20,79,scr)
*return
*/
