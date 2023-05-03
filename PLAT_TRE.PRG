function trebowanie(tip_plat_tr)
local po_debetu:=.F.
private old_col,sum_rashod,power,rashnds,month,month_,sum,debet,kredit,plata,;
beznds,woz_wrat,tratata,mo_nth,dopnal,brtr,aaa,scr1,mrashod,oldsele,_kredit,;
plan_plateg:=0,vsego:=0,nds:=0,nalog3:=0
***
*** PLAT_TRE : format file
*** Generated Апрел 23, 1993
***
plan_plateg=0
dopnal=0
rashnds=0
beznds=0
woz_wrat=0
old_col=setcolor()
month=month_menu()
mesqc=mesqc(month)
mo_nth=month
if month=0
        return .f.
endif
set color to n/w,w/b
if schet_treb>999998
        schet_trreb=1
else
        schet_treb=int(schet_treb+1)
endif
clear typeahead
save screen
@ 11,20,13,59 box "         "
colorwin(12,21,14,60,'n+/n')
@ 11,20 say "┌──────────────────────────────────────┐"
@ 12,20 say "│ Текущий порядковый номер треб.       │"
@ 13,20 say "└──────────────────────────────────────┘"
set cursor on
set conf on
@ 12,53 get schet_treb picture '999999'
read
set cursor off
set conf off
restore screen
if lastkey()=27
        schet_treb=int(schet_treb-1)
        return .f.
endif
sum_rashod=0
power=0
select 77
if schet_vplan
        @ 3,0 say center(" В окончательный платеж будет включена сумма планового !",79,' ',.t.)
        colorwin(3,0,3,79,'w+/b')
*       ?? chr(7)
endif
save screen
obrabot(" Расчет сальдо на сегодняшний день ")
temp_=39/reccount()
kol_kl=0
go top
is_nds=0
is_6=0
kolich=0
 do while .not.eof()
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        if lic_sch#main->lic_schet
                skip
        else
                select(month)
                poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
                if lower(alltrim(licevoj->schetchik))="дебет"
                   po_debetu:=.T.
                endif
                seek poisk
                        if found().and..not.deleted()
                                kolich=kolich+1
if summa>0
        if tarif=schet_tar1 .or.tarif=schet_tar2 .or.tarif=schet_tar3 .or.tarif=schet_tar4 .or.;
        tarif=schet_tar5 .or.tarif=schet_tar6 .or.tarif=schet_tar7.or.;
        tarif=schet_tar8 .or.tarif=schet_tar9
                beznds=beznds+summa
                is_6=is_6+1
*************************************
&& При тарифе 6 руб. НДС не взимается
*************************************
        else
                sum_rashod=sum_rashod+summa
                is_nds=is_nds+1
****************************************
&& При тарифе не 6 руб. надо считать НДС
****************************************
        endif
else
        sum_rashod=sum_rashod+summa
        is_nds=is_nds+1
endif
                                if .not.empty(tarif)
                                        if .not.drug_nach
                                                power=power+rashod
                                        endif
                                endif
                        endif
                select 77
                skip
        endif
enddo
colorwin(12,21,12,60,'n/n')
select 88
select 15
seek main->lic_schet
if !found()
        Myerror('Не нашел в оборотке лицевой счет N '+str(main->lic_schet))
endif
*****************************************************************
*  Блок расчета Дебет/Кредит при выписке платежного поручения   *
*****************************************************************
select 44
month_=Schet_Share+'o'+alltrim(str(month))+".dbf"
NetUse(month_,,0)
go top
aaa=savescreen(9,7,13,74)
message("   Ждите,   идет    расчет    !!!    ")
sum=0
wozw_n=0
do while .not.EOF()
        if licevoj=main->lic_schet
                if .not.deleted()
                        if alltrim(vid_dokum)#'Пеня'.and.alltrim(vid_dokum)#'пеня'
                                if alltrim(vid_dokum)="возврат".or.alltrim(vid_dokum)='Возврат'
                                        beznds=beznds+summa
                                        ***************************
                                        * Сумма возврата с начисления
                                        woz_wrat=woz_wrat+summa

                                        ***************************
                                else
                                        if alltrim(vid_dokum)="о возврат".or.alltrim(vid_dokum)='о Возврат'
                                                sum=sum-summa
                                        else
                                                if alltrim(vid_dokum)="н возврат".or.alltrim(vid_dokum)='н Возврат'
                                                        wozw_n=wozw_n+summa
                                                else
                                                        sum=sum+summa
                                                endif
                                        endif
                                endif
                        else
                        endif
                endif
        endif
        skip
enddo
* inkey(1)
use
mont_h_='h'+alltrim(str(int(month)))
use &mont_h_
hsum=0
do while .not.eof()
        if licevoj=main->lic_schet
                hsum=hsum+summa
        endif
        skip
enddo
use
mont_h_='p'+alltrim(str(int(month)))
use &mont_h_
psum=0
do while .not.eof()
        if licevoj=main->lic_schet
                psum=psum+summa
        endif
        skip
enddo
penq='penq'+alltrim(str(int(month)))
high='high'+alltrim(str(int(month)))
use
select 15
******************************************************************
IF RecLock(0)
   replace &penq with psum
   replace &high with hsum
   Unlock
ENDIF
******************************************************************
nds_=round(sum_rashod*schet_nds/100,0)
nalog3=ROUND(sum_rashod*schet_dnal/100,0)
rashnds=round(sum_rashod-woz_wrat-wozw_n+nds_+nalog3,0)
*@ 1,0 say str(nalog3)
******************************************************************
debet_pres='debet'+alltrim(str(month))
kredit_pres='kredit'+alltrim(str(month))
debet_last=if(month>1,'debet'+alltrim(str(month-1)),'last_debet')
kredit_last=if(month>1,'kredit'+alltrim(str(month-1)),'last_kred')
debet=&debet_pres
kredit=&kredit_pres

if &debet_last=0.and.&kredit_last#0
        do case
                case &kredit_last+sum-(rashnds+beznds)>0
*                       error('1.1) Текущий кредит  '+alltrim(str(&kredit_last+sum-(rashnds+beznds)))+' руб.',2)
                        replace &kredit_pres with &kredit_last+sum-(rashnds+beznds)
                        replace &debet_pres with 0
                case &kredit_last+sum-(rashnds+beznds)<0
*                       error('1.2) Текущий дебет  '+alltrim(str(rashnds+beznds-(&kredit_last+sum)))+' руб.',2)
                        replace &debet_pres with (rashnds+beznds)-(&kredit_last+sum)
                        replace &kredit_pres with 0
                case &kredit_last+sum-(rashnds+beznds)=0
*                       error('1.3) Текущий кредит  0 руб.',2)
                        replace &debet_pres with 0
                        replace &kredit_pres with 0
        endcase

endif
if &kredit_last=0.and.&debet_last#0
        do case
                case &debet_last+(rashnds+beznds)-sum>0
*                       error('2.1) Текущий Дебет  '+alltrim(str(&debet_last+(rashnds+beznds)-sum))+' руб.',2)
                        replace &debet_pres with (&debet_last+(rashnds+beznds)-sum)
                        replace &kredit_pres with 0
                case &debet_last+(rashnds+beznds)-sum<0
*                       error('2.2) Текущий кредит  '+alltrim(str(sum-(&debet_last+rashnds+beznds)))+' руб.',2)
                        replace &kredit_pres with sum-(&debet_last+(rashnds+beznds))
                        replace &debet_pres with 0
                case &debet_last+(rashnds+beznds)-sum=0
*                       error('2.3) Текущий дебет  0 руб.',2)
                        replace &kredit_pres with 0
                        replace &debet_pres with 0
        endcase
endif
if &kredit_last=0.and.&debet_last=0
        if rashnds+beznds-sum>0
                replace &debet_pres with rashnds+beznds-sum
*               error('3.1) Текущий дебет  '+alltrim(str(beznds+rashnds-sum))+' руб.',2)
                replace &kredit_pres with 0
        else
                replace &kredit_pres with sum-(rashnds+beznds)
*               error('3.2) Текущий кредит  '+alltrim(str(sum-(rashnds+beznds)))+' руб.',2)
                replace &debet_pres with 0
        endif
endif
if &kredit_last#0.and.&debet_last#0
        e_rror("           Внимание ! в данном предприятии в оборотной          ",;
               "           ведомости присутствуют данные по  дебету  и          ",;
               "           кредиту. Расчет остановлен !                         ")
endif
restscreen(9,7,13,74,aaa)
*********************************************** Конец блока
plata=al_box({" Укажите тип платежа для генерации платежки "},3,;
        {" Плановый "," Окончательный "," Отменить "},2,,,,,,"N/W,W+/B,,,N/W")
do case
        case plata=1
                konec=.f.
                        plan_plateg=0
                        oldsele=select()
                        sum_rashod=0
                        nds_=0
                        nalog3=0
                        power=0
                        rashnds=0
                        select 77
                        save screen to scr1
                        obrabot('Анализирую сальдо прошлого месяца')
                        temp_=39/reccount()
                        kol_kl=0
                        go top
                        do while .not.eof()
                                kol_kl=kol_kl+temp_
                                colorwin(12,21,12,21+kol_kl,'n/n')
                                if lic_sch#main->lic_schet
                                        skip
                                else
                                        if month-1>0
                                                select(month-1)
                                        else
                                                select 13
                                        endif
                                        poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
                                        seek poisk
                                        if found().and..not.deleted()
if tarif=schet_tar1 .or.tarif=schet_tar2 .or.tarif=schet_tar3 .or.tarif=schet_tar4 .or.;
tarif=schet_tar5 .or.tarif=schet_tar6 .or.tarif=schet_tar7.and.;
tarif=schet_tar8 .or.tarif=schet_tar9
                                                        beznds=beznds+summa
                                                else
                                                        sum_rashod=sum_rashod+round(summa,0)
                                                endif
                                                if .not.empty(tarif)
                                                        if .not.drug_nach
                                                                power=power+rashod
                                                        endif
                                                endif
                                        endif
                                        select 77
                                        skip
                                endif
                        enddo
                        colorwin(12,21,12,60,'n/n')
                        select 88
                        sum_rashod=round(sum_rashod,0)
                        nds_=round(sum_rashod*schet_nds/100,0)
                        nalog3=round(sum_rashod*3/100,0)
                        rashnds=round((beznds+sum_rashod+nalog3+nds_),0)
                        restore screen from scr1
                        select 15
                        select(oldsele)
*                       error(str(rashnds)+str(&kredit_pres))
                if &kredit_pres<=rashnds .and. &debet_pres>=0
        *               if &debet_pres>=0.and.&kredit_pres=0
                        sum_rashod=0
                        nds_=0
                        nalog3=0
                        power=0
                        rashnds=0
                        _kredit=&kredit_pres
                        replace &debet_pres with 0
                        replace &kredit_pres with 0
                        select 77
                        save screen to scr1
                        obrabot('Расчет планового платежа')
                        temp_=39/reccount()
                        kol_kl=0
                        go top
is_6=0
kolich=0
                         do while .not.eof()
                                kol_kl=kol_kl+temp_
                                colorwin(12,21,12,21+kol_kl,'n/n')
                                if lic_sch#main->lic_schet
                                        skip
                                else
                                        if month-1>0
                                                select(month-1)
                                        else
                                                select 13
                                        endif
                                        poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
                                        seek poisk
                                        if found().and..not.deleted()
kolich=kolich+1
if tarif=schet_tar1 .or.tarif=schet_tar2 .or.tarif=schet_tar3 .or.tarif=schet_tar4 .or.;
tarif=schet_tar5 .or.tarif=schet_tar6 .or.tarif=schet_tar7.and.;
tarif=schet_tar8 .or.tarif=schet_tar9
                                                        is_6=is_6+1
                                                        beznds=beznds+round(summa*if(schet_plan=0,1,schet_bplan),0)
                                                else
* При плановом платеже изменить коэфициент при расчете суммы
                                                        sum_rashod=sum_rashod+round(summa*if(schet_plan=0,1,schet_plan),0)
                                                endif
                                                if .not.empty(tarif)
                                                        if .not.drug_nach
                                                                power=power+rashod
                                                        endif
                                                endif
                                        endif
                                        select 77
                                        skip
                                endif
                        enddo
                        colorwin(12,21,12,60,'n/n')
                        select 88
                        nds_=0
                        sum_rashod=round(sum_rashod,0)
                        nds_=round(sum_rashod*schet_nds/100,0)
                        nalog3=round(sum_rashod*3/100,0)
                        rashnds=round((beznds+sum_rashod+nalog3+nds_),0)
                        restore screen from scr1
                        select 15
                else
                        e_rror("     Плановый платеж не выставляется, так как   ",;
                             '     у прeдприятия кредиторская задолженность   ',;
                             '                        Нажмите любую клавишу...')
                        _kredit=0
                        rashnds=0
                        beznds=0
                endif
                plan_plateg:=0      // 16-05-95

        case plata=2
                IF schet_vplan
                        plan_plateg=if((rashnds*if(schet_plan>0,schet_plan,1)+;
                        beznds*if(schet_bplan>0,schet_bplan,1))-;
                        &kredit_pres>0,(rashnds*if(schet_plan>0,schet_plan,1)+beznds*if(schet_bplan>0,schet_bplan,1))-;
                        &kredit_pres,0)
                ELSE
                        plan_plateg:=0      // 16-05-95
                        vsego:=0
                ENDIF
                rashnds=&debet_pres+if(schet_vplan=.t.,plan_plateg,0)
                _kredit=0
                konec=.t.
        otherwise
                schet_treb=int(schet_treb-1)
                select 88
                setcolor(old_col)
                restore screen
                return .f.
endcase
*set decimals to 2

restore screen
if konec
        if rashnds=0
                al_box({'Tребование выстaвлять не надо.'})
                deletefile(Ddir+"otchet.gkv")
                schet_treb=int(schet_treb-1)
                select 88
                setcolor(old_col)
                return .f.
        endif
else
        if rashnds+beznds-_kredit=0
                al_box({'Tребование выстaвлять не надо.'})
                deletefile(Ddir+'otchet.gkv')
                schet_treb=int(schet_treb-1)
                select 88
                setcolor(old_col)
                return .f.
        endif
endif


setcolor(old_col)
//
//************  Запись платежки в базу данных TOBANK.DBF  *******************//
writetobank(main->lic_schet,"эл.энерг.за "+mesqc(mo_nth))
//************  Запись платежки в базу данных TOBANK.DBF  *******************//
//
//message("  Ждите, идет генерация отчета...  ")
brtr='c 15.'+alltrim(str(if(day(new_date+1)>20,month(new_date+1),month(new_date+1)-1)))+;
     ' по 01.'+alltrim(str(if(day(new_date+1)>20,month(new_date+1)+1,month(new_date+1))))
plat_dat:=alltrim(str(day((new_date+1))))+"  "+mesqc(month(new_date+1),1)+;
          ' '+alltrim(str(year(new_date+1)))
select 77
seek main->lic_schet
RKC:=if(substr(alltrim(licevoj->bank),1,3)='РКЦ','РКЦ',"   ")
bik_rkc:="         "
do case
   case alltrim(k_schet)="700161289"
        bik_bank="040304789"
   case alltrim(k_schet)="700161292"
        bik_bank="040304792"
   case alltrim(k_schet)="700161593"
        bik_bank="040304793"
   case alltrim(k_schet)="800161736"
        bik_bank="040304836"
   case alltrim(k_schet)="800161037"
        bik_bank="040304837"
   case alltrim(k_schet)="800161367"
        bik_bank="040304867"
   case alltrim(k_schet)="800161095"
        bik_bank="040304895"
   case alltrim(k_schet)="900161924"
        bik_bank="040304924"
   case alltrim(k_schet)="600164577"
        bik_bank="040304677"
   otherwise
        bik_rkc="040304000"
        bik_bank=alltrim(mfo)
endcase
&& Используемые переменные
pl_tmp1:=if(konec,rashnds*(schet_nds+schet_dnal)/(100+schet_nds+schet_dnal),0)
if is_6#kolich
        vsego:=if(konec,round(rashnds-_kredit-pl_tmp1,0),vsego)
else
        vsego:=if(konec,beznds+sum_rashod+nalog3+nds_-_kredit,bez_nds+sum_rashod)
endif
nds:=if(konec,round(vsego*schet_nds/100,0),nds)
nalog3:=if(konec,round(rashnds-vsego-nds-_kredit,0),nalog3)
mesqc:=mesqc(mo_nth)
    do case
       case main->tip_plat=0
            report(Ddir+"plat_tre.rpt",Ddir+'otchet.gkv',120)
       case main->tip_plat=1
            report(Ddir+"plat_tre.rpt",Ddir+'otchet.gkv',120)
       case main->tip_plat=2
            report(Ddir+"treb_por.rpt",Ddir+'otchet.gkv',120)
       case main->tip_plat=3
            report(Ddir+"incass.rpt",Ddir+'otchet.gkv',120)
       case main->tip_plat=4
//            al_box({dir+"tre_ocb.rpt "+if(file(dir+"tre_ocb.rpt"),"","не ")+"найден"})
            report(Ddir+"tre_ocb.rpt",Ddir+'otchet.gkv',120)
       case main->tip_plat=5
            report(Ddir+"tp_ocb.rpt",Ddir+'otchet.gkv',120)
    endcase
select 88
setcolor(old_col)
return .t.
