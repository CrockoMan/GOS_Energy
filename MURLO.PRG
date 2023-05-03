func oraschet
private _para
paramet _para
* Оборотка - 15 область
* Оплата   - 44 область
* Счетчики - 1-12 область
* month_   - Переменная с месяцем расчета д./кр.
sele_old=select()
buff_old=indexord()
numrec=recno()
if pcount()<2
        colorwin(0,0,5,79,'n/n')
endif
debet=0
kredit=0
beznds=0
**************** Считаю сколько нагорело по счетчикам **************
sele(month_)
go top
do while !eof()
        if licevoj=main->lic_schet
                if tarif#6
                        debet=debet+summa
                else
                        beznds=beznds+summa
                endif
        endif
        skip
enddo
**************** Считаю оплату с возвратами ************************
if _para=.t.
        sele 44
else
        mm=alltrim(str(month_))
        sele 44
        use &mm
endif
go top
w_ozw1=0
w_ozw2=0
w_ozw3=0
do while !eof()
        if licevoj=main->lic_schet
                if alltrim(vid_dokum)#'о возврат'.and.alltrim(vid_dokum)#'о Возврат';
                .and.alltrim(vid_dokum)#'пеня'.and.alltrim(vid_dokum)#'Пеня';
                .and.alltrim(vid_dokum)#'Возврат'.and.alltrim(vid_dokum)#'возврат';
                .and.alltrim(vid_dokum)#'н возврат'.and.alltrim(vid_dokum)#'н Возврат'
                        kredit=kredit+summa
                else
                        if alltrim(vid_dokum)='о возврат'.or.alltrim(vid_dokum)='о Возврат'
                                        w_ozw1=w_ozw1+summa
                        else
                                if alltrim(vid_dokum)='возврат'.or.alltrim(vid_dokum)='Возврат'
                                        w_ozw2=w_ozw2+summa
                                else
                                        if alltrim(vid_dokum)='н возврат'.or.alltrim(vid_dokum)='н Возврат'
                                                w_ozw3=w_ozw3+summa
                                        endif
                                endif
                        endif
                endif
        endif
        skip
enddo
if .not._para
        use
endif
**************** Считаю HДС к полученной сумме *********************
* debet+bez_nds - нагорело по счетчикам
* w_ozw         - сумма возврата по начислению
nds=round(debet*schet_nds/100,0)
debet=(debet+nds+beznds+w_ozw1)-w_ozw2-w_ozw3
kredit=kredit-w_ozw2
**************** Вычисляю прошлый дебет/кредит *********************
sele 15
seek main->lic_schet
d_last=if(month_>1,'obormot->debet'+alltrim(str(month_-1)),'obormot->last_debet')
k_last=if(month_>1,'obormot->kredit'+alltrim(str(month_-1)),'obormot->last_kred')
if !empty(&d_last).and.!empty(&k_last)
        Myerror("По счету "+alltrim(str(main->lic_schet))+" есть дебет и кредит")
        return .f.
endif
**************** Вычисляю настоящий дебет/кредит *******************
d_pres='obormot->debet'+alltrim(str(month_))
k_pres='obormot->kredit'+alltrim(str(month_))
**************** Вычисляю результат с учетом прошлого месяца *******
debet=debet+&d_last
kredit=kredit+&k_last
**************** Записываю настоящий дебет/кредит ******************
sele 15
seek main->lic_schet
do case
        case debet>kredit
                if &d_pres#round(debet-kredit,0).and.&k_pres#0
                        if pcount()<2
                                Myerror("Hесовпадение данных по счету "+str(main->lic_schet))
                        endif
                endif
                replace &d_pres with round(debet-kredit,0)
                replace &k_pres with 0
        case debet<kredit
                if &k_pres#round(kredit-debet,0).and.&d_pres#0
                        if pcount()<2
                                Myerror("Hесовпадение данных по счету "+str(main->lic_schet))
                        endif
                endif
                replace &k_pres with round(kredit-debet,0)
                replace &d_pres with 0
        case debet=kredit
                if &d_pres#0.and.&k_pres#0
                        if pcount()<2
                                Myerror("Hесовпадение данных по счету "+str(main->lic_schet))
                        endif
                endif
                replace &d_pres with 0
                replace &k_pres with 0
endcase
**************** Конец всем расчетам, записываю результат **********
select(sele_old)
set order to buff_old
go numrec
return .t.