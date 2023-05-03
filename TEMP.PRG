
proc penq2
private month,base,oplata,sele,old_ind,dni,kredit_last,scr,form,is_oplata
old_ind=indexord()
sele=select()
month=month_menu()
numscheta=main->lic_schet
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
        base=dir+alltrim(str(round(month,0)))+'.dbf'
        load('44',base)
        go top
        do while .not.eof()
                if licevoj=numscheta
                        if data<oplata
                                oplata=data
                        endif
                        is_oplata=.t.
                        @ 0,0 say "Первая оплата "+dtoc(oplata)
                        colorwin(0,0,0,0+len("Первая оплата"+dtoc(oplata)),'w+/n')
                endif
                skip
        enddo
        sele 44
        go top
        use
        if !empty(oplata)
                if month(oplata)=month
                        dni=day(oplata)-day(ctod('06.'+alltrim(str(month))+'.'+alltrim(str(year(new_date)))))
                        if dni>0
                                kredit_last=if(month>1,'kredit'+alltrim(str(M->month-1)),'last_kred')
                                kredit_pres=if(month>1,'kredit'+alltrim(str(M->month)),'last_kred')
*                               if .not.empty(obormot->&kredit_last)
*                                       error(" За "+if(month-1#0,mesqc(month-1),"Декабрь")+' кредиторская задолженность предприятия. Пеня не выставляется',3)
*                               else
************************************************
                                                go top
select 77
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
Myerror(str(sum_rashod)+str(&kredit_last))
                                        if obormot->&kredit_last-sum_rashod<0
*                                       if empty(obormot->&kredit_pres)
        *                                       error(' Кредиторская задолженность отсутствует, начисляю пеню за '+alltrim(str(dni))+' дней',3)
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
                                                penq=round((obormot->&kredit_last-sum_rashod*schet_penq/100)*dni,2)
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
        *                                       error('Начислено '+alltrim(str(penq->&ppenq))+' рублей. ',2)
                                                restore screen
                                                colorwin(12,31,14,52,'n+/n')
                                                set color to
                                                @ 12,30 say "┌──── Сформировать ────╖"
                                                @ 13,30 say "│                      ║"
                                                @ 14,30 say "│ Платежное требование ║"
                                                @ 15,30 say "│ Требование-поручение ║"
                                                @ 16,30 say "╘══════════════════════╝"
                                                @ 14,31 prompt " Платежное требование "
                                                @ 15,31 prompt " Требование-поручение "
                                                menu to form
                                                message('  Ждите, идет формирование документа ... ')
                                                do case
                                                        case form=1
                                                                do pt
        *                                                       message_wa('  Платежное требование сформировано !!!')
                                                        case form=2
                                                                do ptp
        *                                                       message_wa('  Платежное требование-поручение сформировано !!!')
                                                endcase
                                                set color to w/b,n/w
                                        endif
*                               endif
                        else
                                Myerror('Оплата произведена своевременно, пеня не начислена !',5)
                        endif
                else
                        e_rror('                  Оплата произведена своевременно,             ',;
                               '                  пеня не начисляется !                        ')
                endif
        else
                Myerror('Дата поступления оплаты не введена,начислить невозможно!',5)
        endif
endif
select(sele)
set order to old_ind
*restscreen(10,0,20,79,scr)
return
