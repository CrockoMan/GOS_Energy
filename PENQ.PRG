proc Penq2(W_Blank)
LOCAL Writen:=.F.,FRec,PenqZaDogovor:=0.5
private month,base,oplata,sele,old_ord,dni,kredit_last,scr,form,is_oplata,;
        oplata_summa,olata_data,old_rec,oplat_wsego,numscheta,i,days,penq,;
        last
old_ord=indexord()
sele=select()
old_rec=recno()
*numscheta=main->lic_schet
PenqZaDogovor:=Schet_Penq
month_=month_menu()
if month_>0     && Фишка выхода из функции при нажатии "Esc" в меню
        IF W_Blank==NIL
           w_blank=al_box({" Выберите тип выходного документа "},3,{" Платежка "," Бланк расчета "," Отказ "})
        ENDIF
        do case
                case w_blank=1
                        w_blank=.F.
                case w_blank=2
                        w_blank=.T.
                case w_blank=3
                        select(sele)
                        set order to old_ord
                        go old_rec
                        return
        endcase
        if w_blank
                desc=fcreate(Ddir+'otchet.gkv')
                fwrite(desc,center(alltrim(main->potrebitel)+' Расчет суммы процентов за '+mesqc(month_)+' месяц',79,' ',.t.)+chr(13)+chr(10))
                fwrite(desc,replicate('-',78)+chr(13)+chr(10))
        endif
        ******* Расчет количества дней в текущем месяце
        if month_#2
                days=ctod('30.'+if(len(alltrim(str(month_)))=2,alltrim(str(month_)),'0'+alltrim(str(month_)))+'.'+substr(alltrim(str(year(New_date))),3,2))
        else
                days=ctod('27.'+if(len(alltrim(str(month_)))=2,alltrim(str(month_)),'0'+alltrim(str(month_)))+'.'+substr(alltrim(str(year(New_date))),3,2))
        endif
        do case
                case month_=1
                        days=ctod('30.01.'+substr(alltrim(str(year(New_date))),3,2))
                        dni=30
                case month_=2
                        days=ctod(if(year(New_date)/4=int(year(New_date)),'29','28')+'.02'+;
                        substr(alltrim(str(year(New_date))),3,2))
                        dni=if(year(New_date)/4=int(year(New_date)),29,28)
                case month_=3
                        days=ctod('30.03.'+substr(alltrim(str(year(New_date))),3,2))
                        dni=30
                case month_=4
                        days=ctod('30.04.'+substr(alltrim(str(year(New_date))),3,2))
                        dni=30
                case month_=5
                        days=ctod('30.05.'+substr(alltrim(str(year(New_date))),3,2))
                        dni=30
                case month_=6
                        days=ctod('30.06.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=7
                        days=ctod('30.07.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=8
                        days=ctod('30.08.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=9
                        days=ctod('30.09.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=10
                        days=ctod('30.10.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=11
                        days=ctod('30.11.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=12
                        days=ctod('30.12.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
        endcase
        ************************* Конец блока расчета дней *******************
        * DNI  - переменная с количеством дней                               *
        * DAYS - Переменная с последней датой расчитываемого месяца          *
        **********************************************************************
select 15
seek main->lic_schet
oplata_summa=0
oplat_wsego=0
if found()
        kredit_penq=if(month_>1,'kredit'+alltrim(str(M->month_-1)),'last_kred')
        debet_penq=if(month_>1,'debet'+alltrim(str(M->month_-1)),'last_debet')
        *******************************************************************
        *       Расчет Дебет/Кредит без НДС и СН                          *
        kredit_penq=round(&kredit_penq-(&kredit_penq*(schet_nds+schet_dnal)/;
        (100+schet_nds+schet_dnal)),Decimal)
        debet_penq=round(&debet_penq-(&debet_penq*(schet_nds+schet_dnal)/;
        (100+schet_nds+schet_dnal)),Decimal)
        if w_blank
                if debet_penq=0.and.kredit_penq=0
                        fwrite(desc,"Кредиторская задолженность 0,     Дебиторская задолженность 0"+chr(13)+chr(10))
                else
                        fwrite(desc,if(kredit_penq>0,;
                        "Кредиторская задолженность "+alltrim(str(kredit_penq)),;
                        'Дебиторская задолженность '+alltrim(str(debet_penq)))+chr(13)+chr(10))
                endif
        endif
        *******************************************************************
        *      Поиск оплаты и суммирование всех оплат за этот месяц
        save screen
        obrabot("Анализ поступления оплаты")
        oplata='o'+alltrim(str(month_))+'.dbf'
        oplata_summa=0
        select 44
        netuse(schet_share+oplata,,0)
        InInd:=DDir+"da_ta_op.ntx"
        index on data to &InInd
        go top
        is_oplata=.f.
        temp_=39/reccount()
        kol_kl=0
        do while !eof()
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if licevoj=main->lic_schet
                        if alltrim(vid_dokum)#'пеня'.and.;
                        alltrim(vid_dokum)#'о возврат'
                                ****  Определение первой оплаты в эт. месяце
                                if is_oplata=.f.
                                        oplata_data=data
                                else
                                        oplata_data=if(oplata_data>data,data,;
                                                       oplata_data)
                                endif
                                **** Суммирование оплат без НДС и СН
                                Oplata_Summa=Oplata_Summa+(summa-(summa*;
      (schet_nds+schet_dnal)/(100+schet_nds+schet_dnal)))
                                Is_Oplata=.t.
                                Oplat_Wsego=Oplat_Wsego+1
                        endif
                endif
                skip
        enddo
        ************ Выборка всех оплат, если они поступали
        i=0
        if is_oplata=.t. && Фишка поступления оплат
                DECLARE sum_opl[oplat_wsego],data_opl[oplat_wsego]
                AFill(Sum_Opl,0)
                go top
                do while !eof()
                        if licevoj=main->lic_schet
                                if alltrim(vid_dokum)#'пеня'.and.;
                                alltrim(vid_dokum)#'о возврат'
                                        if i>0
                                                if data_opl[i]=data
                                                        Sum_Opl[i]=Sum_Opl[i]+;
        (summa-round(summa*(schet_nds+schet_dnal)/(100+schet_nds+schet_dnal),Decimal))
                                                else
                                                        i=i+1
                                                        Sum_Opl[i]=Sum_Opl[i]+summa-round(summa*;
                (schet_nds+schet_dnal)/(100+schet_nds+schet_dnal),Decimal)
                                                        IF !Empty(Data)
                                                           Data_Opl[i]:=Data
                                                        ELSE
                                                           data_opl[i]=if(month(data)=month_,data,;
                                                           ctod('01.'+alltrim(str(month_))+'.'+;
                                                           alltrim(str(year(new_date)))))
                                                        ENDIF
                                                endif
                                        else
                                                i=i+1
                                                Sum_Opl[i]=Sum_Opl[i]+Summa-round(summa*;
        (schet_nds+schet_dnal)/(100+schet_nds+schet_dnal),Decimal)
                                                IF !Empty(Data)
                                                   Data_Opl[i]:=Data
                                                ELSE
                                                   data_opl[i]=if(month(data)=month_,data,;
                                                   ctod('01.'+alltrim(str(month_))+'.'+;
                                                   alltrim(str(year(new_date)))))
                                                ENDIF
                                        endif
                                endif
                        endif
                        skip
                enddo
        endif
        ************************************************************
        close index
        use
        DeleteFile(InInd)
        oplat_wsego=i
//        sum_nach_proshl=summa_sch(month_)  && Сумма нач.прошл.мес.
      IF ATNUM("ЗАСТРОЙ",MYUPPER(Main->Potrebitel))==0
        sum_nach_proshl=Round(GetSum(Main->Lic_Schet,IF(Month_>1,month_-1,13))/2,Decimal)
      ELSE
        Sum_Nach_Proshl:=0
      ENDIF
//      @ 2,0 say ATNUM("ЗАСТРОЙ",MYUPPER(Main->Potrebitel))
//      @ 1,0 say Sum_Nach_Proshl
//      Inkey(0)
//        Sum_Nach_Proshl:=Round(IF(Month_==1,Sum_Nach_Proshl/1000,Sum_Nach_Proshl),Decimal)
        restore screen
//        e_rror("    Кредит"+str(kredit_penq)+'     Дебет'+str(debet_penq),;
//               '    Первая оплата '+if(is_oplata,dtoc(oplata_data),'не поступала')+"  Сумма"+str(oplata_summa),;
//               '    Сумма начисления прошл.месяца'+str(sum_nach_proshl),;
//               '    Поступило оплат '+str(oplat_wsego))
//
        ******* Непосредственный расчет пени из полученных данных
        for i=1 to oplat_wsego
            IF Day(Data_Opl[i])==31
//               Data_Opl[i]=Data_Opl[i]-1
            ENDIF
//                fwrite(desc,alltrim(str(i))+'. '+dtoc(data_opl[i])+'   '+alltrim(str(sum_opl[i]))+chr(13)+chr(10))
        next
        if w_blank
                if i>0
                        fwrite(desc,'Поступившие оплаты:'+chr(13)+chr(10))
                        for i=1 to oplat_wsego
                                fwrite(desc,alltrim(str(i))+'. '+dtoc(data_opl[i])+'   '+alltrim(str(sum_opl[i]))+chr(13)+chr(10))
                        next
                else
                        fwrite(desc,'Поступивших оплат нет'+chr(13)+chr(10))
                endif
                fwrite(desc,'Плановый платеж за '+mesqc(month_)+' месяц '+alltrim(str(sum_nach_proshl))+chr(13)+chr(10))
        endif
        penq=0
        do case
                case is_oplata=.f..and.debet_penq#0.and.kredit_penq=0
// error(' Расчет пени, исходя из дебета, без поступившей оплаты ')
*******************************************************
                        penq=(debet_penq*if(year(main->data_dog)=;
                        year(new_date),schet_penq,PenqZaDogovor)/100)*dni
                if w_blank
                        fwrite(desc,alltrim(str(debet_penq))+'*'+;
alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+'/100*'+;
alltrim(str(dni))+'='+alltrim(str(penq))+chr(13)+chr(10))
                        fwrite(desc,alltrim(str(penq))+'+('+alltrim(str(sum_nach_proshl))+'*'+;
alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+'/100*'+;
alltrim(str(dni))+'-6+1)'+"=")
                endif
                        penq=penq+(sum_nach_proshl*if(year(main->data_dog)=;
                        year(new_date),schet_penq,PenqZaDogovor)/100)*(dni-6+1)
                if w_blank
                        fwrite(desc,alltrim(str(penq))+chr(13)+chr(10))
                endif
                        *******************************************************
                case is_oplata=.t..and.debet_penq#0.and.;
                        kredit_penq=0
* .and.sum_opl[1]<debet_penq
* .and.(debet_penq+sum_nach_proshl)>;
* oplata_summa.and.
//                      error(' Расчет пени, исходя из дебета, с поступившей оплатой ')
**** Расчет по дебету, до его перекрытия оплатой
                        sum_oplata=0
                        penq=0
                        data_oplat=data_opl[1]
                        ostatok_dolga=sum_nach_proshl
                        sveta=0
                        fishka=.f.
                        for i=1 to oplat_wsego
                                if i=1
                                        penq=(debet_penq*if(year(main->data_dog)=;
                                        year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                        val(substr(dtoc(data_opl[i]),1,2))
if w_blank
        fwrite(desc,;
        '('+alltrim(str(debet_penq))+'*'+alltrim(str(if(year(main->data_dog)=year(new_date),;
        schet_penq,PenqZaDogovor)))+'/100)*'+alltrim(str(val(substr(dtoc(data_opl[i]),1,2))))+'='+;
        alltrim(str(penq))+chr(13)+chr(10))
endif
                                        ostatok_debeta=debet_penq-sum_opl[i]
                                        sveta=-1*ostatok_debeta
                                else
                                        if ostatok_debeta>0
                                                data_oplat=data_opl[i]
                                                _1=(ostatok_debeta*if(year(main->data_dog)=;
                                                year(new_date),schet_penq,PenqZaDogovor)/100)
                                                _2=;
                                                (data_opl[i]-data_opl[i-1])+1
if w_blank
        fwrite(desc,alltrim(str(penq))+'('+alltrim(str(ostatok_debeta))+'*'+;
        alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+')/100'+'*('+;
        alltrim(str(data_opl[i]-data_opl[i-1]))+'+1)'+'='+;
        alltrim(str(penq+_1*_2))+chr(13)+chr(10))
endif
                                                ostatok_debeta=ostatok_debeta-sum_opl[i]
                                                sveta=-1*ostatok_debeta
                                                penq=penq+_1*_2
                                        else
                                                ** Закончено начисление пени по дебету,
                                                ** начисляем пеню по просрочке платежа
&&      sum_nach_proshl - сумма, начисленная в прошлом месяце - плановый пл.
if ostatok_debeta<0.and.sum_nach_proshl>0.and.ostatok_dolga>0
        if fishka=.f.
                i=i-1
                sum_opl[i]=-1*ostatok_debeta
                if sum_opl[i]>0
*                       ostatok_dolga=ostatok_dolga-sum_opl[i]
                        first_data=val(substr(dtoc(data_opl[i]),1,2))
                        next_data=if(oplat_wsego>i,val(substr(dtoc(data_opl[i+1]),1,2)),;
                                  dni-val(substr(dtoc(data_opl[i]),1,2)))
                        _1=(ostatok_dolga*if(year(main->data_dog)=year(new_date),;
                        schet_penq,PenqZaDogovor)/100)
                        _2=if(fishka=.f.,(first_data-6+1),;
                        (next_data-first_data))
*************************
                        if _2>0
if w_blank
        fwrite(desc,'('+alltrim(str(ostatok_dolga))+'*'+;
        alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+'/100)*('+;
        if(fishka=.f.,alltrim(str(first_data))+'-6+1',;
        alltrim(str(next_data))+'-'+alltrim(str(first_data)))+')='+;
        alltrim(str(penq+_1*_2))+chr(13)+chr(10))
endif                                                                           *?? datatype(dni-val(substr(dtoc(data_opl[i]),1,2)))
                        penq=penq+_1*_2
                        fishka=.t.
                        endif
*************************
                        ostatok_dolga=ostatok_dolga-sum_opl[i]
                endif
                i=i+1
        endif
endif

if ostatok_dolga>0
//       ostatok_dolga=ostatok_dolga-sum_opl[i]
        _1=(ostatok_dolga*if(year(main->data_dog)=year(new_date),;
        schet_penq,PenqZaDogovor)/100)
        _2=if(fishka=.f.,val(alltrim(substr(dtoc(data_opl[i]),1,2)))-6+1,;
        (data_opl[i]-data_opl[i-1])+1)
//       if data_opl[i]-data_opl[i-1]+1<=0
                if w_blank
                        fwrite(desc,'('+alltrim(str(ostatok_dolga))+'*'+;
                        alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+'/100)*('+;
                        alltrim(str(if(fishka=.f.,val(alltrim(substr(dtoc(data_opl[i]),1,2)))-6+1,;
                        (data_opl[i]-data_opl[i-1])+1)))+')='+;
                        alltrim(str(penq+_1*_2))+chr(13)+chr(10))
                endif                                                                           *?? datatype(dni-val(substr(dtoc(data_opl[i]),1,2)))
                penq=penq+_1*_2
                fishka=.t.
//       endif
//       last=i
        ostatok_dolga=ostatok_dolga-sum_opl[i]
else
        exit
        last=i
endif
                                        endif
                                endif
                                last=i
                        next

***************************************************************************
if ostatok_debeta<0.and.sum_nach_proshl>0.and.ostatok_dolga>0
        if fishka=.f.
                sum_opl[last]=-1*ostatok_debeta
                if sum_opl[last]>0
                        first_data=val(substr(dtoc(data_opl[last]),1,2))
                        next_data=if(oplat_wsego>last,val(substr(dtoc(data_opl[last+1]),1,2)),;
                                  dni-val(substr(dtoc(data_opl[last]),1,2)))
                        _1=(ostatok_dolga*if(year(main->data_dog)=year(new_date),;
                        schet_penq,PenqZaDogovor)/100)
                        _2=if(fishka=.f.,(first_data-6+1),;
                        (next_data-first_data))
if w_blank
        fwrite(desc,'('+alltrim(str(ostatok_dolga))+'*'+;
        alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+'/100)*('+;
        if(fishka=.f.,alltrim(str(first_data))+'-6+1',;
        alltrim(str(next_data))+'-'+alltrim(str(first_data)))+')='+;
        alltrim(str(penq+_1*_2))+chr(13)+chr(10))
endif                                                                           *?? datatype(dni-val(substr(dtoc(data_opl[i]),1,2)))
                        penq=penq+_1*_2
                        ostatok_dolga=ostatok_dolga-sum_opl[last]
                endif
        fishka=.t.
        endif
endif
***************************************************************************


                        if ostatok_debeta>0
if w_blank
        fwrite(desc,alltrim(str(penq))+'('+alltrim(str(ostatok_debeta))+'*'+;
        alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+'/100)*('+;
        alltrim(str(dni))+'-'+alltrim(str(val(substr(dtoc(data_opl[oplat_wsego]),1,2))));
        +'+1)'+chr(13)+chr(10))
endif
                                penq=penq+(ostatok_debeta*;
                                if(year(main->data_dog)=year(new_date),;
                                schet_penq,PenqZaDogovor)/100)*(dni-;
                                val(substr(dtoc(data_opl[oplat_wsego]),1,2))+1)
                        endif
                        if ostatok_dolga>0
                                _1=(ostatok_dolga*if(year(main->data_dog)=year(new_date),;
                                schet_penq,PenqZaDogovor)/100)
                                _2=if(fishka=.t.,(dni-;
                                val(substr(dtoc(data_opl[oplat_wsego]),1,2))),;
                                dni-6+1)
if w_blank
        fwrite(desc,'('+alltrim(str(ostatok_dolga))+'*'+;
        alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+'/100)*('+;
        alltrim(str(if(fishka=.t.,(dni-;
        val(substr(dtoc(data_opl[oplat_wsego]),1,2))),dni-6+1)))+')='+;
        alltrim(str(penq+_1*_2))+chr(13)+chr(10))
endif
                                penq=penq+(_1*_2)
                        endif


                case is_oplata=.f..and.kredit_penq>0.and.debet_penq=0.and.;
                        sum_nach_proshl>kredit_penq

//error('1) Расчет пени, исходя из остатка долга ')
                        penq=((sum_nach_proshl-kredit_penq)*if(year(main->;
                        data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*(dni-6+1)
                if w_blank
                        fwrite(desc,'('+alltrim(str(sum_nach_proshl))+'-'+;
alltrim(str(kredit_penq))+')*'+alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+;
'/100)*('+alltrim(str(dni))+'-6+1)'+'='+alltrim(str(penq))+chr(13)+chr(10))
                endif


//                case is_oplata=.t..and.sum_nach_proshl>(oplata_summa+;
//                       kredit_penq).and.debet_penq=0
                case is_oplata=.t..and.sum_nach_proshl>(kredit_penq).and.;
                        debet_penq=0

//                        error('2) Расчет пени, исходя из остатка долга ')
                        do_6=0
                        after_6=oplat_wsego
                        min_after_6=days
                        sum_after_6=0
                        for i=1 to oplat_wsego
                                if val(substr(dtoc(data_opl[i]),1,2))<6
                                        do_6=do_6+sum_opl[i]
                                        after_6=after_6-1
                                else
                                        if min_after_6>data_opl[i]
                                                min_after_6=data_opl[i]
                                                sum_after_6=sum_opl[i]
                                        endif
                                endif
                        next
if (sum_nach_proshl-kredit_penq-do_6)>0
                        last_data=min_after_6
                        min_after_6=val(substr(dtoc(min_after_6),1,2))

                        penq=((sum_nach_proshl-kredit_penq-do_6)*;
                        if(year(main->data_dog)=year(new_date),schet_penq,;
                        PenqZaDogovor)/100)*(min_after_6-6+1)
                        ostatok_dolga=sum_nach_proshl-kredit_penq-do_6-sum_after_6
//                        @ 1,0 say str(sum_nach_proshl-kredit_penq-do_6)
//                        @ 2,0 say str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor))
//                        @ 3,0 say str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)
                        if w_blank
                                fwrite(desc,'10) ('+alltrim(str(sum_nach_proshl))+'-'+;
                                alltrim(str(kredit_penq))+'-'+alltrim(str(do_6))+')*'+alltrim(str(;
                                if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+'/100*('+;
                                alltrim(str(min_after_6))+'-6+1)'+'='+alltrim(str(penq))+;
                                chr(13)+chr(10))
                        endif
                        if ostatok_dolga>0
                                if oplat_wsego>=2
                                for i=2 to oplat_wsego
                                        if val(substr(dtoc(data_opl[i]),;
                                        1,2))>6
                                                if ostatok_dolga>0
                                                        ostatok_dolga=ostatok_dolga-sum_opl[i]
                                                        if w_blank
                                                                fwrite(desc,alltrim(str(penq))+'('+alltrim(str(ostatok_dolga))+'*'+;
                                                                alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+;
                                                                '/100)*('+alltrim(str((data_opl[i]-if(i=1,ctod('06.'+alltrim(str(month_))+'.'+;
                                                                alltrim(str(year(data_opl[i])))),data_opl[i-1]))))+')=')
                                                        endif
                                                        penq=penq+;
                                                        (ostatok_dolga*if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                                        (data_opl[i]-if(i=1,ctod('06.'+alltrim(str(month_))+'.'+;
                                                        alltrim(str(year(data_opl[i])))),data_opl[i-1]))
                                                        last_data=data_opl[i]

                                                        if w_blank
                                                                fwrite(desc,alltrim(str(penq))+chr(13)+chr(10))
                                                        endif
                                                endif
                                        endif
                                next
                                else
                                        ostatok_dolga=ostatok_dolga-sum_opl[1]
                                endif
                        endif
                        if ostatok_dolga>0
                                if w_blank
                                        fwrite(desc,alltrim(str(penq))+'+'+alltrim(str(ostatok_dolga))+'*'+;
                                        alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+;
                                        '/100*'+alltrim(str(dni-val(substr(dtoc(last_data),1,2))))+'=')
                                endif
                                        penq=penq+;
                                        (ostatok_dolga*if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                        (dni-val(substr(dtoc(last_data),1,2)))
                                if w_blank
                                        fwrite(desc,alltrim(str(penq))+chr(13)+chr(10))
                                endif
                        endif
endif   &&   Условие DO_6

                case is_oplata=.t..and.sum_nach_proshl>oplata_summa.and.;
                                kredit_penq=0.and.debet_penq=0

//                        error('3) Расчет пени, исходя из остатка долга ')
                        do_6=0
                        after_6=oplat_wsego
                        min_after_6=days
                        for i=1 to oplat_wsego
                                if val(substr(dtoc(data_opl[i]),1,2))<6
                                        do_6=do_6+sum_opl[i]
                                        after_6=after_6-1
                                else
                                        min_after_6=if(min_after_6<data_opl[i],;
                                        data[i],min_after_6)
                                endif
                        next
if (sum_nach_proshl-kredit_penq-do_6)>0
                        min_after_6=val(substr(dtoc(min_after_6),1,2))
                        penq=((sum_nach_proshl-kredit_penq-do_6)*;
                        if(year(main->data_dog)=year(new_date),schet_penq,;
                        PenqZaDogovor)/100)*(min_after_6-6+1)
                        if w_blank
                                fwrite(desc,'('+alltrim(str(sum_nach_proshl))+'-'+alltrim(str(kredit_penq))+;
                                alltrim(str(do_6))+'*'+alltrim(str(if(year(main->data_dog)=;
                                year(new_date),schet_penq,PenqZaDogovor)))+'/100)*('+alltrim(str((min_after_6-6+1)))+;
                                '='+alltrim(str(penq))+chr(13)+chr(10))
                        endif
                        ostatok_dolga=sum_nach_proshl-kredit_penq-do_6
                        if ostatok_dolga>0
                                for i=1 to oplat_wsego
                                        if val(substr(dtoc(data_opl[i]),;
                                        1,2))>6
                                                if ostatok_dolga>0
                                                        ostatok_dolga=ostatok_dolga-sum_opl[i]
                                                        if w_blank
                                                                fwrite(desc,alltrim(str(penq))+'+('+alltrim(str(ostatok_dolga))+'*'+alltrim(str(if(year(main->;
                                                                data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+'/100)*'+alltrim(str(;
                                                                val(substr(dtoc(data_opl[i]-data_opl[i-1]),1,2))))+'=')
                                                        endif
                                                        penq=penq+;
                                                        (ostatok_dolga*if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                                        val(substr(dtoc(data_opl[i]-data_opl[i-1]),1,2))
                                                        if w_blank
                                                                fwrite(desc,alltrim(str(penq))+chr(13)+chr(10))
                                                        endif
                                                        last_data=data_opl[i]
                                                endif
                                        endif
                                next
                        endif
                        if ostatok_dolga>0
                                if w_blank
                                        fwrite(desc,alltrim(str(penq))+'+('+alltrim(str(ostatok_dolga))+'*'+;
                                        alltrim(str(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)))+;
                                        '/100)*'+alltrim(str((dni-val(substr(dtoc(last_data),1,2)))))+'=')
                                endif
                                penq=penq+;
                                (ostatok_dolga*if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                (dni-val(substr(dtoc(last_data),1,2)))
                                if w_blank
                                        fwrite(desc,alltrim(str(penq))+chr(13)+chr(10))
                                endif
                        endif
                endif          &&  Условие DO_6

                case is_oplata=.f..and.sum_nach_proshl>0.and.;
                                kredit_penq=0.and.debet_penq=0

                        penq=sum_nach_proshl*;
(if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*(dni-6+1)
if w_blank
        fwrite(desc,alltrim(str(sum_nach_proshl))+'*'+;
        alltrim(str((if(year(main->data_dog)=year(new_date),;
        schet_penq,PenqZaDogovor)/100)))+'*'+alltrim(str(dni))+'-6+1'+'='+;
        alltrim(str(penq))+chr(13)+chr(10))
endif
        endcase
//        penq=round(penq,Decimal)
        penq=round(penq,Decimal)
        if w_blank
                fwrite(desc,'Итого процентов '+alltrim(str(penq))+chr(13)+chr(10))
                fwrite(desc,replicate('-',78)+chr(13)+chr(10)+chr(13)+chr(10))
                fclose(desc)
        endif
        if w_blank=.f.
              save screen to scr_form
              col_form=setcolor()
              if penq<0
                      penq=0
              endif
              Select PH
              Seek Main->Lic_Schet
              cFoundPenq:=""
              DO While Licevoj==Main->Lic_Schet
                 IF AtNum("Пеня за "+Mesqc(Month_)+" месяц (начислена ",Text)>0
                    cFoundPenq:=AllTrim(Text)
                 ENDIF
                 Skip
              ENDDO
              IF !Empty(cFoundPenq)
                 IF Al_Box({cFoundPenq},2,{" Начислить "," Отменить "})==2
                    Penq:=-1
                 ENDIF
              ENDIF
              IF Empty(cFoundPenq)
                 a:=al_box({" Начислено пени "+alltrim(str(penq))},2,{" Отпечатать "," Выход "})
                 penq:=if(a=1,penq,-1)
              ELSE
                 Penq:=-1
              ENDIF
              IF penq>0
                 Select PH
                   if netappend()
                      replace licevoj with main->lic_schet
                      Replace PenqN With M->Penq
                      Replace Text  With "Пеня за "+Mesqc(Month_)+" месяц (начислена "+DTOC(new_date)+")"
                      Replace Month With Month(new_date)
                      Replace MN    With Month_
                      unlock
                   endif
//                     mesqcpenq='penqn'+alltrim(str(int(month_)))
//                     select obormot
//                     seek main->lic_schet
//                     if !found()
//                        if netappend()
//                           replace lic_schet with main->lic_schet
//                           unlock
//                        endif
//                     endif
//                     if reclock()
//                        replace &mesqcpenq with penq
//                        unlock
//                     endif
              ENDIF
              SELECT Main
              if penq>0
//                 typ:=iswritekniga()
//                 FRec:=FoundRec(main->lic_schet,month(new_date+1),1)
                 PlD:=alltrim(str(day((new_date+1))))+"  "+mesqc(month(new_date+1),1)+'  '+alltrim(str(year(new_date+1)))
                 Select Tobank
                 IF FileLock(0)
                    Append Blank
                    MyRec:=RecNo()
                    Go Bottom
                    Schet_=Plat_Treb+1
                    Go Myrec
                    Replace Plat_Treb With Schet_
                    Replace Summa With Penq
                    Replace Data With new_date+1
                    Replace Lic_Schet With Main->Lic_Schet
                    Replace Tip With "Пеня за "+Mesqc(Month_)
                    Unlock
                 ENDIF
                 Select(Sele)
                 pt(schet_,PlD)
              ENDIF
                setcolor(col_form)
                restore screen from scr_form
        endif
ELSE
        al_box({"Данные в оборотке не найдены !"})
ENDIF
ENDIF
SELECT(Sele)
SET ORDER TO Old_Ord
GO Old_Rec
RETURN




********************* Функция расчета показаний счетчиков за прошлый месяц
* Параметр - месяц для расчета
Function Summa_Sch(Mon,IsShow)
LOCAL Scr:=Win_save()
Private Month_,Base,Oplata,Sele,Oldindex,Dni,Kredit_Last,Form,Is_Oplata,;
        Sum,Old_Rec,Alias
IsShow:=IF(IsShow==NIL,.T.,IsShow)
If Alias()#''
   Oldindex=Indexord()
   Sele=Select()
   Old_Rec=Recno()
   Alias=.T.
Else
   Alias=.F.
Endif
Select(If(Mon>1,Mon-1,13))
Sum=0
Go Top
Kol_Kl=0
IF IsShow
   Obrabot("Анализ показаний счетчиков")
ENDIF
DO WHILE !Eof()
IF IsShow
   Kol_Kl=Kol_Kl+39/Reccount()
   Colorwin(12,21,12,21+Kol_Kl,'N/N')
ENDIF
   IF Licevoj=Main->Lic_Schet
      Sum=Sum+Summa
   ENDIF
   Skip
ENDDO
IF Alias
   Select(Sele)
   Set Order To Oldindex
   Go Old_Rec
ENDIF
Win_Rest(Scr)
Return Round(IF(Mon>1,Sum,Sum/1000),Decimal)
//Return Round(Sum/1000,Decimal))







Function CalkPenq(Month_)
LOCAL Writen:=.F.,PenqZaDogovor:=0.5
LOCAL month,base,oplata,sele,old_ord,dni,kredit_last,form,is_oplata
LOCAL oplata_summa,olata_data,old_rec,oplat_wsego,numscheta,i,days,penq:=0
LOCAL w_blank,last
old_ord=indexord()
sele=select()
old_rec=recno()
PenqZaDogovor:=Schet_Penq
if month_>0     && Фишка выхода из функции при нажатии "Esc" в меню
        ******* Расчет количества дней в текущем месяце
        if month_#2
           days=ctod('30.'+if(len(alltrim(str(month_)))=2,alltrim(str(month_)),'0'+alltrim(str(month_)))+'.'+substr(alltrim(str(year(new_date))),3,2))
        else
           days=ctod('27.'+if(len(alltrim(str(month_)))=2,alltrim(str(month_)),'0'+alltrim(str(month_)))+'.'+substr(alltrim(str(year(new_date))),3,2))
        endif
        do case
                case month_=1
                        days=ctod('30.01.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=2
                        days=ctod(if(year(new_date)/4=int(year(new_date)),'29','28')+'.02'+;
                        substr(alltrim(str(year(new_date))),3,2))
                        dni=if(year(new_date)/4=int(year(new_date)),29,28)
                case month_=3
                        days=ctod('30.03.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=4
                        days=ctod('30.04.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=5
                        days=ctod('30.05.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=6
                        days=ctod('30.06.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=7
                        days=ctod('30.07.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=8
                        days=ctod('30.08.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=9
                        days=ctod('30.09.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=10
                        days=ctod('30.10.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=11
                        days=ctod('30.11.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
                case month_=12
                        days=ctod('30.12.'+substr(alltrim(str(year(new_date))),3,2))
                        dni=30
        endcase
        ************************* Конец блока расчета дней *******************
        * DNI  - переменная с количеством дней                               *
        * DAYS - Переменная с последней датой расчитываемого месяца          *
        **********************************************************************
select 15
seek main->lic_schet
oplata_summa=0
oplat_wsego=0
if found()
        kredit_penq=if(month_>1,'kredit'+alltrim(str(month_-1)),'last_kred')
        debet_penq=if(month_>1,'debet'+alltrim(str(month_-1)),'last_debet')
        *******************************************************************
        *       Расчет Дебет/Кредит без НДС и СН                          *
        kredit_penq=round(&kredit_penq-(&kredit_penq*(schet_nds+schet_dnal)/;
        (100+schet_nds+schet_dnal)),Decimal)
        debet_penq=round(&debet_penq-(&debet_penq*(schet_nds+schet_dnal)/;
        (100+schet_nds+schet_dnal)),Decimal)
        *******************************************************************
        *      Поиск оплаты и суммирование всех оплат за этот месяц
//        save screen
//        obrabot("Анализ поступления оплаты")
        oplata='o'+alltrim(str(month_))+'.dbf'
        oplata_summa=0
        select 44
        netuse(schet_share+oplata,,0)
        InInd:=DDir+"da_ta_op.ntx"
        index on data to &InInd
        go top
        is_oplata=.f.
//        temp_=39/reccount()
//        kol_kl=0
        do while !eof()
//                kol_kl=kol_kl+temp_
//                colorwin(12,21,12,21+kol_kl,'n/n')
                if licevoj=main->lic_schet
                        if alltrim(vid_dokum)#'пеня'.and.;
                        alltrim(vid_dokum)#'о возврат'
                                ****  Определение первой оплаты в эт. месяце
                                if is_oplata=.f.
                                        oplata_data=data
                                else
                                        oplata_data=if(oplata_data>data,data,;
                                                       oplata_data)
                                endif
                                **** Суммирование оплат без НДС и СН
                                oplata_summa=oplata_summa+(summa-(summa*;
                                (schet_nds+schet_dnal)/(100+schet_nds+schet_dnal)))
                                is_oplata=.t.
                                oplat_wsego=oplat_wsego+1
                        endif
                endif
                skip
        enddo
        ************ Выборка всех оплат, если они поступали
        i=0
        if is_oplata=.t. && Фишка поступления оплат
                DECLARE sum_opl[oplat_wsego],data_opl[oplat_wsego]
                go top
                do while !eof()
                        if licevoj=main->lic_schet
                                if alltrim(vid_dokum)#'пеня'.and.;
                                alltrim(vid_dokum)#'о возврат'
                                        if i>0
                                                if data_opl[i]=data
                                                        sum_opl[i]=sum_opl[i]+;
                                                        (summa-round(summa*(schet_nds+schet_dnal)/(100+schet_nds+schet_dnal),Decimal))
                                                else
                                                        i=i+1
                                                        sum_opl[i]=summa-round(summa*;
                                                        (schet_nds+schet_dnal)/(100+schet_nds+schet_dnal),Decimal)
                                                        data_opl[i]=if(month(data)=month_,data,;
                                                        ctod('01.'+alltrim(str(month_))+'.'+;
                                                        alltrim(str(year(new_date)))))
                                                endif
                                        else
                                                i=i+1
                                                sum_opl[i]=summa-round(summa*;
                                                (schet_nds+schet_dnal)/(100+schet_nds+schet_dnal),Decimal)
                                                data_opl[i]=if(month(data)=month_,data,;
                                                ctod('01.'+alltrim(str(month_))+'.'+;
                                                alltrim(str(year(new_date)))))
                                        endif
                                endif
                        endif
                        skip
                enddo
        endif
        ************************************************************
        close index
        use
        DeleteFile(InInd)
        oplat_wsego=i
//        sum_nach_proshl=summa_sch(month_,.F.)  && Сумма нач.прошл.мес.

//        Sum_Nach_Proshl:=Round(IF(Month_==1,Sum_Nach_Proshl/1000,Sum_Nach_Proshl),Decimal)
//        sum_nach_proshl=GetSum(Main->Lic_Schet,month_)  && Сумма нач.прошл.мес.
//        restore screen

//        sum_nach_proshl=Round(GetSum(Main->Lic_Schet,IF(Month_>1,month_-1,13))/2,Decimal)  && Сумма нач.прошл.мес.
      IF ATNUM("ЗАСТРОЙ",MYUPPER(Main->Potrebitel))==0
        sum_nach_proshl=Round(GetSum(Main->Lic_Schet,IF(Month_>1,month_-1,13))/2,Decimal)
      ELSE
        Sum_Nach_Proshl:=0
      ENDIF


        ******* Непосредственный расчет пени из полученных данных
        penq=0
        do case
                case is_oplata=.f..and.debet_penq#0.and.kredit_penq=0
//error(' Расчет пени, исходя из дебета, без поступившей оплаты ')
*******************************************************
                        penq=(debet_penq*if(year(main->data_dog)=;
                        year(new_date),schet_penq,PenqZaDogovor)/100)*dni
                        penq=penq+(sum_nach_proshl*if(year(main->data_dog)=;
                        year(new_date),schet_penq,PenqZaDogovor)/100)*(dni-6+1)
                        *******************************************************
                case is_oplata=.t..and.debet_penq#0.and.;
                        kredit_penq=0
**** Расчет по дебету, до его перекрытия оплатой
                        sum_oplata=0
                        penq=0
                        data_oplat=data_opl[1]
                        ostatok_dolga=sum_nach_proshl
                        sveta=0
                        fishka=.f.
                        for i=1 to oplat_wsego
                                if i=1
                                   penq=(debet_penq*if(year(main->data_dog)=;
                                   year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                   val(substr(dtoc(data_opl[i]),1,2))
                                   ostatok_debeta=debet_penq-sum_opl[i]
                                   sveta=-1*ostatok_debeta
                                else
                                   if ostatok_debeta>0
                                      data_oplat=data_opl[i]
                                      _1=(ostatok_debeta*if(year(main->data_dog)=;
                                      year(new_date),schet_penq,PenqZaDogovor)/100)
                                      _2=;
                                      (data_opl[i]-data_opl[i-1])+1
                                      ostatok_debeta=ostatok_debeta-sum_opl[i]
                                      sveta=-1*ostatok_debeta
                                      penq=penq+_1*_2
                                   else
                         ** Закончено начисление пени по дебету,
                         ** начисляем пеню по просрочке платежа
&&      sum_nach_proshl - сумма, начисленная в прошлом месяце - плановый пл.
                                     if ostatok_debeta<0.and.sum_nach_proshl>0.and.ostatok_dolga>0
                                             if fishka=.f.
                                                     i=i-1
                                                     sum_opl[i]=-1*ostatok_debeta
                                                     if sum_opl[i]>0
                                                             first_data=val(substr(dtoc(data_opl[i]),1,2))
                                                             next_data=if(oplat_wsego>i,val(substr(dtoc(data_opl[i+1]),1,2)),;
                                                                       dni-val(substr(dtoc(data_opl[i]),1,2)))
                                                             _1=(ostatok_dolga*if(year(main->data_dog)=year(new_date),;
                                                             schet_penq,PenqZaDogovor)/100)
                                                             _2=if(fishka=.f.,(first_data-6+1),;
                                                             (next_data-first_data))
                                      *************************
                                                              if _2>0
                                                              penq=penq+_1*_2
                                                              fishka=.t.
                                                              endif
                                      *************************
                                                              ostatok_dolga=ostatok_dolga-sum_opl[i]
                                                      endif
                                                      i=i+1
                                              endif
                                      endif
                                           if ostatok_dolga>0
                                                   _1=(ostatok_dolga*if(year(main->data_dog)=year(new_date),;
                                                   schet_penq,PenqZaDogovor)/100)
                                                   _2=if(fishka=.f.,val(alltrim(substr(dtoc(data_opl[i]),1,2)))-6+1,;
                                                   (data_opl[i]-data_opl[i-1])+1)
                                                           penq=penq+_1*_2
                                                           fishka=.t.
                                                   ostatok_dolga=ostatok_dolga-sum_opl[i]
                                           else
                                                   exit
                                                   last=i
                                           endif
                                        endif
                                endif
                                last=i
                        next

                           ***************************************************************************
                           if ostatok_debeta<0.and.sum_nach_proshl>0.and.ostatok_dolga>0
                                   if fishka=.f.
                                           sum_opl[last]=-1*ostatok_debeta
                                           if sum_opl[last]>0
                                                   first_data=val(substr(dtoc(data_opl[last]),1,2))
                                                   next_data=if(oplat_wsego>last,val(substr(dtoc(data_opl[last+1]),1,2)),;
                                                             dni-val(substr(dtoc(data_opl[last]),1,2)))
                                                   _1=(ostatok_dolga*if(year(main->data_dog)=year(new_date),;
                                                   schet_penq,PenqZaDogovor)/100)
                                                   _2=if(fishka=.f.,(first_data-6+1),;
                                                   (next_data-first_data))
                                                   penq=penq+_1*_2
                                                   ostatok_dolga=ostatok_dolga-sum_opl[last]
                                           endif
                                   fishka=.t.
                                   endif
                           endif
                           ***************************************************************************


                        if ostatok_debeta>0
                                penq=penq+(ostatok_debeta*;
                                if(year(main->data_dog)=year(new_date),;
                                schet_penq,PenqZaDogovor)/100)*(dni-;
                                val(substr(dtoc(data_opl[oplat_wsego]),1,2))+1)
                        endif
                        if ostatok_dolga>0
                                _1=(ostatok_dolga*if(year(main->data_dog)=year(new_date),;
                                schet_penq,PenqZaDogovor)/100)
                                _2=if(fishka=.t.,(dni-;
                                val(substr(dtoc(data_opl[oplat_wsego]),1,2))),;
                                dni-6+1)
                                penq=penq+(_1*_2)
                        endif


                case is_oplata=.f..and.kredit_penq>0.and.debet_penq=0.and.;
                        sum_nach_proshl>kredit_penq
                        penq=((sum_nach_proshl-kredit_penq)*if(year(main->;
                        data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*(dni-6+1)
                case is_oplata=.t..and.sum_nach_proshl>(kredit_penq).and.;
                        debet_penq=0
                        do_6=0
                        after_6=oplat_wsego
                        min_after_6=days
                        sum_after_6=0
                        for i=1 to oplat_wsego
                                if val(substr(dtoc(data_opl[i]),1,2))<6
                                        do_6=do_6+sum_opl[i]
                                        after_6=after_6-1
                                else
                                        if min_after_6>data_opl[i]
                                                min_after_6=data_opl[i]
                                                sum_after_6=sum_opl[i]
                                        endif
                                endif
                        next
                    If (sum_nach_proshl-kredit_penq-do_6)>0
                        last_data=min_after_6
                        min_after_6=val(substr(dtoc(min_after_6),1,2))

                        penq=((sum_nach_proshl-kredit_penq-do_6)*;
                        if(year(main->data_dog)=year(new_date),schet_penq,;
                        PenqZaDogovor)/100)*(min_after_6-6+1)
                        ostatok_dolga=sum_nach_proshl-kredit_penq-do_6-sum_after_6
                        if ostatok_dolga>0
                                if oplat_wsego>=2
                                for i=2 to oplat_wsego
                                        if val(substr(dtoc(data_opl[i]),;
                                        1,2))>6
                                                if ostatok_dolga>0
                                                        ostatok_dolga=ostatok_dolga-sum_opl[i]
                                                        penq=penq+;
                                                        (ostatok_dolga*if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                                        (data_opl[i]-if(i=1,ctod('06.'+alltrim(str(month_))+'.'+;
                                                        alltrim(str(year(data_opl[i])))),data_opl[i-1]))
                                                        last_data=data_opl[i]

                                                endif
                                        endif
                                next
                                else
                                        ostatok_dolga=ostatok_dolga-sum_opl[1]
                                endif
                        endif
                        if ostatok_dolga>0
                                        penq=penq+;
                                        (ostatok_dolga*if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                        (dni-val(substr(dtoc(last_data),1,2)))
                        endif
                    ENDIF   &&   Условие DO_6

                case is_oplata=.t..and.sum_nach_proshl>oplata_summa.and.;
                                kredit_penq=0.and.debet_penq=0
                        do_6=0
                        after_6=oplat_wsego
                        min_after_6=days
                        for i=1 to oplat_wsego
                                if val(substr(dtoc(data_opl[i]),1,2))<6
                                        do_6=do_6+sum_opl[i]
                                        after_6=after_6-1
                                else
                                        min_after_6=if(min_after_6<data_opl[i],;
                                        data[i],min_after_6)
                                endif
                        next
                     if (sum_nach_proshl-kredit_penq-do_6)>0
                        min_after_6=val(substr(dtoc(min_after_6),1,2))
                        penq=((sum_nach_proshl-kredit_penq-do_6)*;
                        if(year(main->data_dog)=year(new_date),schet_penq,;
                        PenqZaDogovor)/100)*(min_after_6-6+1)
                        ostatok_dolga=sum_nach_proshl-kredit_penq-do_6
                        if ostatok_dolga>0
                                for i=1 to oplat_wsego
                                        if val(substr(dtoc(data_opl[i]),;
                                        1,2))>6
                                                if ostatok_dolga>0
                                                        ostatok_dolga=ostatok_dolga-sum_opl[i]
                                                        penq=penq+;
                                                        (ostatok_dolga*if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                                        val(substr(dtoc(data_opl[i]-data_opl[i-1]),1,2))
                                                        last_data=data_opl[i]
                                                endif
                                        endif
                                next
                        endif
                        if ostatok_dolga>0
                                penq=penq+;
                                (ostatok_dolga*if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*;
                                (dni-val(substr(dtoc(last_data),1,2)))
                        endif
                     endif          &&  Условие DO_6

                   case is_oplata=.f..and.sum_nach_proshl>0.and.;
                                   kredit_penq=0.and.debet_penq=0
                           penq=sum_nach_proshl*;
                           (if(year(main->data_dog)=year(new_date),schet_penq,PenqZaDogovor)/100)*(dni-6+1)
               endcase
        penq=round(penq,Decimal)
ENDIF
ENDIF
SELECT(Sele)
SET ORDER TO Old_Ord
GO Old_Rec
//Win_Rest(Scr)
Return Round(Penq,Decimal)





Function PenqSpisok
LOCAL Scr:=Win_Save(),Month,Desc,Sum:=0,Kol_Kl:=0
LOCAL CrLf:=Chr(13)+Chr(10),Itog:=0,Recno:=Recno(),Position:=0,Sel
Month:=Month_Menu("расчета пени")
IF Month==0
   Return NIL
ENDIF
AllPotrebitel:=Al_Box({"Сформировать отчет с выставлением процентов"},3,{" Не выставлять "," Выставить "," Отмена "})
IF AllPotrebitel==3
   Return NIL
ENDIF
RunSaver:=.F.
Go Top
Desc:=FCreate(DDir+ReportFile)
FWrite(Desc,"Расчет суммы процентов за "+Mesqc(Month)+CrLf)
Fwrite(Desc,"┌"+Replicate("─",5)+"┬"+Replicate("─",Len(Main->Potrebitel))+"┬"+Replicate("─",14)+"┐"+CrLf)
Fwrite(Desc,"│"+Center("Л/с",5," ",.t.)+"│"+Center("Потребитель",Len(Main->Potrebitel)," ",.t.)+"│"+Center("Пеня",14," ",.t.)+"│"+CrLf)
Fwrite(Desc,"├"+Replicate("─",5)+"┼"+Replicate("─",Len(Main->Potrebitel))+"┼"+Replicate("─",14)+"┤"+CrLf)
Obrabot("Расчет пени всем потребителям")
Do While .not.EOF().and.Main->Lic_Schet<99999
   IF Hot_InKey()==27
      IF Al_Box({"Прекратить расчет"},2)==1
         Exit
      ENDIF
   ENDIF
   obrabot("Расчет пени всем потребителям "+Alltrim(Str(Position*100/Reccount()))+" %",,,,.T.)
   kol_kl=kol_kl+39/RecCount()
   colorwin(12,21,12,21+kol_kl,'n/n')
   Sum:=CalkPenq(Month)
   IF AllPotrebitel==2
//      IF ATNUM("ЗАСТРОЙ",MYUPPER(Potrebitel))=0.and.ATNUM("ГСК",MYUPPER(Potrebitel))=0.and.;
//         ATNUM("ЖСК",MYUPPER(Potrebitel))=0.and.ATNUM("ДОМОВЛАД",MYUPPER(Potrebitel))=0.and.;
      IF ATNUM("ГСК",MYUPPER(Potrebitel))=0.and.;
         ATNUM("ЖСК",MYUPPER(Potrebitel))=0.and.ATNUM("ДОМОВЛАД",MYUPPER(Potrebitel))=0.and.;
         main->lim_tar1=0.and.main->lic_schet!=723.and.main->lic_schet!=2102
         IF Sum>0
            Fwrite(Desc,"│"+Str(main->Lic_Schet,5,0)+"│"+Main->Potrebitel+"│"+Str(Sum,14,2)+"│"+CrLf)
            Sel:=Select()
            Select PH
            if netappend()
               replace licevoj with main->lic_schet
               Replace PenqN With Sum
               Replace Text  With "Пеня за "+Mesqc(Month)+" месяц (начислена "+DTOC(new_date)+")"
               Replace Month With Month(new_date)
               Replace MN    With Month
               unlock
            endif
            Select(Sel)
         ENDIF
         Itog:=Itog+Sum
      ENDIF
   ELSE
      IF Sum>0
         Fwrite(Desc,"│"+Str(main->Lic_Schet,5,0)+"│"+Main->Potrebitel+"│"+Str(Sum,14,2)+"│"+CrLf)
      ENDIF
      Itog:=Itog+Sum
   ENDIF
   SKIP
   Position++
ENDDO
Fwrite(Desc,"└"+Replicate("─",5)+"┴"+Replicate("─",Len(Main->Potrebitel))+"┴"+Replicate("─",14)+"┘"+CrLf)
FWrite(Desc,"Всего "+Str(Itog,15,2)+CrLf)
FClose(Desc)
Win_Rest(Scr)
GO Recno
RunSaver:=.T.
Return Nil