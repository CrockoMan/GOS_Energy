*******************************************************************
***                                                               *
***   Функция генерации отчета по потребителю по всем счетчикам   *
***                                                               *
*******************************************************************
Function OTCHET
local old_deb:=0,old_kred:=0,oldsel,mesqc2,osum_rashod,mych:=0
LOCAL desc,CrLf:=chr(13)+chr(10),full_list:=.T.,schtmp:=schet_
LOCAL FoundAbon:=.F.,Post393:=0,PredPok:=0,NumTok:=0,aTok:={}
LOCAL SumKategory:=0, RashKategory:=0,AbonSaldo:=0,RecCount:=0
Local oDlg,aSizeDeskTop,aPos,oProgress
PRIVATE old_sel,old_col,old_scr,x,sum_rashod,power,first,nm1,ret,sixrub
PRIVATE beznds,reaktiv,sum_reak,o_ldsel,schet_dnold:=schet_dnal
sum_reak=0
reaktiv=0
sixrub=.f.
ret=.t.
old_col=setcolor()
old_scr=win_save()
old_sel=select()

if (mych:=al_box({"Режим формирования счета по потребителю"},3,;
          {" Обычный "," Расширенный "," Выход "}))==1
   full_list=.T.
else
   full_list=.F.
endif
if mych==3
   schet_=schtmp
   return .f.
endif

month=month_menu()
if month=0
   schet_=schtmp
   return .f.
endif
IF Month<10.and.Year(new_date)==1998
   Return OtchetOld(Month,Mych)
ENDIF
mesqc=mesqc(month)
mesqc2=mesqc(month,1)
do case
   case month>0.and.month<13
        schtmp=schet_
        schet_=main->lic_schet
        save screen

                        oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
                        aSizeDesktop  := AppDesktop():currentSize()
                        oDlg:create( ,, {100,70}, {aSizeDeskTop[1]-200,90} )
      oDlg:title    := "Формирование счета"
                oDlg:SysMenu     := .F.
                oDlg:Configure()
      oDlg:Show()
      aSizeDesktop    := oDlg:currentSize()
      aPos                                              := oDlg:CurrentPos()
                oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
                oProgress:create()
                oProgress:minimum := 1
******************************************************************************
* Здесь был блок расчета дебет/кредит, который перемещен в конец файла,
* а вместо него добавлен вызов следующего:
//message("Расчет сальдо за выбранный месяц")
//obrabot("Расчет сальдо за выбранный месяц")
mon_the=month
do outex with month
******************************************************************************
        restore screen
//        colorwin(11,19,15,65,'b/n')
//       obrabot("Анализ показаний счетчиков")
//       obrabot("Формирование "+if(full_list,"обычного","расширенного")+" счета")
        _lic_schet=main->lic_schet
        sum_rashod=0
        power=0
        first=.t.
        desc:=fcreate(M->Ddir+"otchet.gkv")
        select 77
        go top
        beznds=0
        seek main->lic_schet
        do while lic_sch=main->lic_schet
           RecCount:=RecCount+1
           Skip
        ENDDO
        oProgress:maximum := RecCount
//        temp_=39/reccount
//        kol_kl=0
        seek main->lic_schet
        do while lic_sch=main->lic_schet
                         oProgress:increment()                                                                                                                                                          // Progress Bar Increment
                if lic_sch#_lic_schet
                        skip
                else
                        select(if(month==1,13,month-1))
                        poisk='('+alltrim(str(_lic_schet))+')'+alltrim(licevoj->schetchik)
                        seek poisk
                        PredPok:=Pokazaniq

                        select(mon_the)
                        poisk='('+alltrim(str(_lic_schet))+')'+alltrim(licevoj->schetchik)
                        seek poisk
                        if found().and..not.deleted()
// Анализ категории счетчика. Если это промышленный, то считаем расход
// и согласно постановления превышение расчитывается по увеличенному тарифу
                           IF Alltrim(MYUpper(Licevoj->Schetchik))=="АБОН.МОЩН"
                              FoundAbon:=.T.
                              SumKategory:=SumKategory+Summa
                              RashKategory:=RashKategory+Rashod
                           ENDIF
                            IF First=.t.
                               IF Full_List==.T.
                                 Fwrite(Desc,M->Schet_Naz1+"           "+'С Ч Е Т  '+alltrim(str(schet_))+crlf)
                                 Fwrite(Desc,M->schet_naz2+crlf)
                                 Fwrite(Desc,M->Schet_Naz3+'           Наименование потребителя'+crlf)
                                 Fwrite(Desc,M->Schet_Ban2+'           '+alltrim(main->potrebitel)+crlf)
                                 Fwrite(Desc,M->Schet_Rsch+'           Р.сч. N '+alltrim(licevoj->r_schet)+crlf)
                                 Fwrite(Desc,M->Schet_Ksch+'           в '+alltrim(licevoj->bank)+crlf)
//                                fwrite(desc,M->schet_town+'           Наименование об`екта '+alltrim(licevoj->object1)+' '+alltrim(licevoj->object2)+crlf)
                                 Fwrite(Desc,M->Schet_Town+Crlf)
                                 Fwrite(Desc,'Адрес об`екта '+If(Empty(Main->Adress),Alltrim(Licevoj->Adres),Alltrim(Main->Adress))+Crlf)
                                 Fwrite(Desc,'За '+Mesqc+' '+Alltrim(Str(Year(new_date)))+"г.  по лицевому счету N "+Alltrim(Str(Main->Lic_Schet))+Crlf)
                               ELSE
                                 Fwrite(Desc,Center("А К Т",76)+CrLf)
                                 fwrite(Desc,"   от "+Dtoc(new_date)+"                                        г.Анапа"+Crlf)
                                 fwrite(Desc,'   Мы, нижеподписавшиеся, гл. бухгалтер '+SchetNameOrg+AllTrim(NameBuh)+Crlf)
                                 fwrite(Desc,"   с одной стороны и бухгалтер "+Alltrim(Main->Potrebitel)+Crlf)
                                 fwrite(Desc,"   адрес "+Alltrim(Main->Adress)+" договор N"+Alltrim(Str(Main->Lic_Schet))+" банк "+Alltrim(Licevoj->Bank)+Crlf)
                                 fwrite(Desc,"   р/с "+Alltrim(Licevoj->R_Schet)+"  к/с "+Licevoj->K_Schet+" БИК "+Licevoj->Mfo+Crlf)
                                 fwrite(Desc,"   с другой, произвели сверку  расчетов  за  эл. энергию  по  состоянию" + Crlf)
                                 fwrite(Desc,"   на "+If(Mon_the=Month(new_date),Dtoc(new_date),Alltrim(Str(Lastdayom(Mon_the))) + "."+Alltrim(Str(Mon_the))+"."+Alltrim(Str(Year(new_date))) )+Crlf+Chr(15))
                               ENDIF
                                oldsel=select()
                                select 15
                                old_deb=if(month>1,"debet"+alltrim(str(month-1)),"last_debet")
                                old_kred=if(month>1,"kredit"+alltrim(str(month-1)),"last_kred")
                                old_deb=&old_deb
                                old_kred=&old_kred
                                select(oldsel)
                                if .not.full_list
                                   fwrite(desc,crlf)
                                endif
                                IF Full_List
                                   DO CASE
                                      CASE old_deb>0.and.old_kred=0
                                           fwrite(desc,"На 1-е "+mesqc2+" сальдо: дебeт "+alltrim(str(old_deb))+crlf)
                                      CASE old_deb=0.and.old_kred>0
                                           fwrite(desc,"На 1-е "+mesqc2+" сальдо: кредит "+alltrim(str(old_kred))+crlf)
                                      CASE old_deb>0.and.old_kred>0
                                           fwrite(desc,"На 1-е "+mesqc2+" сальдо: дебeт "+alltrim(str(old_deb))+" кредит "+alltrim(str(old_kred))+crlf)
                                      CASE old_deb=0.and.old_kred=0
                                           fwrite(desc,"На 1-е "+mesqc2+" сальдо нулевое"+crlf)
                                   ENDCASE
                                ENDIF
                             FWrite(Desc,"ПРИ  ОТСТУТСТВИИ 100% ОПЛАТЫ ДОГОВОРНОЙ ВЕЛИЧИНЫ ЭЛЕКТРОПОТРЕБЛЕНИЯ ДО 5-ГО ЧИСЛА"+CrLf)
                             FWrite(Desc,"И ОКОНЧАТЕЛЬНОГО РАСЧЕТА ДО 30-ГО ЧИСЛА РАСЧЕТНОГО МЕСЯЦА, В СООТВЕТСТВИИ СО СТ. 546"+CrLf)
                             FWrite(Desc,"ГК РФ, П.2.2.5 ДОГОВОРА, ПОДАЧА ЭЛЕКТРОЭНЕРГИИ БУДЕТ ОГРАНИЧЕНА (ПРЕКРАЩЕНА)"+CrLF)
                             IF full_list
                                fwrite(desc,"┌───────────────────┬─────────┬─────────┬───────┬─────────┬────────┬─────────────────┐"+crlf)
                                fwrite(desc,"│   N эл/счетчика   │Показания│ Разность│Коэфф. │ Расход  │ Тариф  │      Сумма      │"+crlf)
                                fwrite(desc,"│                   │         │показаний│       │ квт/ква │        │                 │"+crlf)
                                fwrite(desc,"├───────────────────┼─────────┼─────────┼───────┼─────────┼────────┼─────────────────┤"+crlf)
                             ELSE
                                fwrite(desc,"┌─────────┬──────┬─────────────────────────┬───────┬───────┬───────┬─────┬──────┬─────┬───────────┐"+crlf)
                                fwrite(desc,"│ N счетч.│Об`ект│          Адрес          │ Пред. │  Наст │Разница│Коэфф│Расход│Тариф│  Сумма    │  "+crlf)
                                fwrite(desc,"│         │учета │                         │ показ │ показ │       │     │      │     │           │"+crlf)
                                fwrite(desc,"├─────────┼──────┼─────────────────────────┼───────┼───────┼───────┼─────┼──────┼─────┼───────────┤"+crlf)
                             ENDIF
                               first=.f.
                             endif
                                if summa#0.and.alltrim(MYupper(Licevoj->schetchik))!="АБОН.МОЩН"
                                   IF Full_List
                                        fwrite(desc,"│  "+LICEVOJ->Schetchik+;
                                        '  │ '+str(pokazaniq,7,0)+' │  '+;
                                        str(raznica,5,0)+'  │ '+;
                                        str(koeficient,5,0)+' │'+;
                                        str(if(rashod-subab>0,rashod-subab,subab-rashod),9,0)+;
                                        '│'+str(tarif,8,4)+'│ '+;
                                        str(summa,16,2)+'│'+crlf)
                                   ELSE
                                        fwrite(desc,"│"+Licevoj->Schetchik+"│"+Substr(Licevoj->Razdel_1,1,6)+"│"+Substr(Licevoj->Adres,1,25)+"│"+Str(PredPok,7,0)+"│"+Str(Pokazaniq,7,0)+"│"+Str(Raznica,7,0)+"│"+;
                                        Str(Koeficient,5,0)+"│"+str(if(rashod-subab>0,rashod-subab,subab-rashod),6,0)+'│'+str(tarif,5,4)+'│ '+str(summa,10,2)+'│'+crlf)
                                   ENDIF
                                endif
                                IF MYUpper(alltrim(Licevoj->schetchik))="ПО СТ.393"
                                   Post393:=Post393+Summa
                                ENDIF
                                if summa>0
                                   if isnonds(Tarif,Main->Lic_Schet)==.F.
                                      beznds=beznds+summa
                                   else
                                      if .not.isnonds(tarif,Main->Lic_Schet)
                                         beznds=beznds+summa
                                      else
                                         sum_rashod=sum_rashod+summa
                                      endif
                                   endif
                                else
                                    IF Main->Lic_Schet<99999
                                       sum_rashod=sum_rashod+summa
                                    ELSE
                                       if .not.isnonds(tarif,Main->Lic_Schet)
                                          beznds=beznds+summa
                                       else
                                          sum_rashod=sum_rashod+summa
                                       endif
                                    ENDIF
//                                   sum_rashod=sum_rashod+summa
                                endif
                                if .not.empty(summa)
                                        if rashod>0
//-------------------------------------                                                  if .not.drug_nach
                                                if .not.licevoj->reaktivn
                                                        power=power+if(rashod-subab>0,rashod-subab,subab-rashod)
                                                else
                                                        reaktiv=reaktiv+if(rashod-subab>0,rashod-subab,subab-rashod)
                                                        sum_reak=sum_reak+summa
                                                endif
                                        else
//-------------------------------------                                                  if .not.drug_nach
                                                if .not.licevoj->reaktivn
                                                        power=power+rashod-subab
                                                else
                                                        reaktiv=reaktiv+rashod-subab
                                                        sum_reak=sum_reak+summa
                                                endif
                                        endif
                                endif
                                if drug_nach#licevoj->reaktivn
                                   if reclock()
                                        replace drug_nach with licevoj->reaktivn
                                        unlock
                                   endif
                                endif
                                IF Main->Lic_Schet>99999.and..not.Empty(Info)
                                   fwrite(desc,"│В том числе: "+Space(71)+"│"+crlf)
//                                   AADD(aTok,"Льгота       "+GetStrToken(Info,1,";")+" кВт "+GetStrToken(Info,2,";")+" руб. ")
//                                   AADD(aTok,"Соц.норматив "+GetStrToken(Info,4,";")+" кВт "+GetStrToken(Info,3,";")+" руб. ")
//                                   aTok[1]:=GetStrToken(Info,1,";")+" кВт "+GetStrToken(Info,2,";")+" руб. "
//                                   aTok[2]:=GetStrToken(Info,4,";")+" кВт "+GetStrToken(Info,3,";")+" руб. "
                                   AADD(aTok,"Льгота       "+GetStrToken(Info,1,";")+" кВт "+GetStrToken(Info,2,";")+" руб. ")
                                   AADD(aTok,"Соц.норматив "+GetStrToken(Info,4,";")+" кВт "+GetStrToken(Info,3,";")+" руб. ")
                                   fwrite(desc,"│"+aTok[1]+Space(84-Len(aTok[1]))+"│"+crlf)
                                   fwrite(desc,"│"+aTok[2]+Space(84-Len(aTok[2]))+"│"+crlf)
                                ENDIF
                        endif
                        select 77
                        skip
                endif
        enddo
        IF Full_List
           Fwrite(desc,"└───────────────────┴─────────┴─────────┴───────┴─────────┴────────┴─────────────────┘"+crlf)
        ELSE
           FWrite(desc,"└─────────┴──────┴─────────────────────────┴───────┴───────┴───────┴─────┴──────┴─────┴───────────┘"+crlf+Chr(18))
        ENDIF
        osum_rashod=sum_rashod
        nextmon1:=sum_rashod
        nextmon2:=round((sum_rashod-SumKategory+beznds)*schet_nds/100,Decimal)
        IF Full_List
           fwrite(desc,space(62)+str(round(osum_rashod-SumKategory+beznds,Decimal))+crlf)
        ENDIF
        IF Full_List
           fwrite(desc,if(full_list,space(24),"")+"Активная энергия  :"+str(round(power-RashKategory,0))+"         "+str(round(sum_rashod+BezNds-sum_reak-SumKategory-Post393,Decimal))+crlf)
           fwrite(desc,if(full_list,space(24),"")+"Реактивная энергия:"+str(round(reaktiv,0))+"         "+str(round(sum_reak,Decimal))+crlf)

//           fwrite(desc,if(full_list,space(37),space(13))+"Н Д С "+alltrim(str(schet_nds))+"%             "+str(round((osum_rashod-SumKategory)*schet_nds/100,Decimal))+crlf)
           fwrite(desc,if(full_list,space(37),space(13))+"Н Д С "+alltrim(str(schet_nds))+"%             "+str(round((osum_rashod-SumKategory+BezNds)*schet_nds/100,Decimal))+crlf)
           fwrite(desc,if(full_list,space(37),space(13))+"Итого:                   "+str(round(sum_rashod-SumKategory+BezNds+(osum_rashod-SumKategory)*schet_nds/100,Decimal))+crlf)
           sum_rashod=sum_rashod-SumKategory+round((sum_rashod-SumKategory)*schet_nds/100,Decimal)+beznds+round(sum_rashod*schet_dnal/100,Decimal)+round(RashKategory*MaxRashSum,Decimal)
           schet_dnal:=schet_dnold
//           NextMon1:=NextMon1-SumKategory
           IF Main->Lic_Schet<99999.and.schet_vplan==.T.
              fwrite(desc,if(full_list,space(37),space(13))+'К оплате на след. месяц :'+Str(Round(NextMon1-SumKategory+beznds,Decimal))+crlf)
              fwrite(desc,if(full_list,space(37),space(13))+'                    НДС :'+Str(Round(NextMon2,Decimal))+crlf)
              fwrite(desc,if(full_list,space(37),space(13))+'                  Итого :'+Str(Round(NextMon1+NextMon2-SumKategory,Decimal))+crlf)
           ENDIF
//           fwrite(desc,if(full_list,space(37),space(13))+'                  Итого :'+str(round(sum_rashod-SumKategory+BezNds+(osum_rashod-SumKategory)*schet_nds/100,Decimal))+CrLf)
           fwrite(desc,if(full_list,space(37),space(13))+"Оплачено всего          :"+Str(Oplacheno(Month),13,2)+crlf)
           select 15
           debet_pres='debet'+alltrim(str(month))
           kredit_pres='kredit'+alltrim(str(month))
           len:=len('К оплате на след. месяц :')
           do case
                      case &debet_pres>0.and.&kredit_pres=0
                           tmpstr:='На '+if(month#month(new_date),'1-e '+mesqc(month+1,.t.),dtoc(new_date))+' Дебет '
                           fwrite(desc,if(full_list,space(37),space(13))+tmpstr+space(len-len(tmpstr)-1)+str(&debet_pres)+crlf)
                   case &debet_pres=0.and.&kredit_pres>0
                           tmpstr:='На '+if(month#month(new_date),'1-e '+mesqc(month+1,.t.),dtoc(new_date))+' Кредит'
                           fwrite(desc,if(full_list,space(37),space(13))+tmpstr+space(len-len(tmpstr)-1)+str(&kredit_pres)+crlf)
           endcase
           Sum_Rashod:=round(osum_rashod-SumKategory+(osum_rashod-SumKategory)*schet_nds/100,Decimal)
           IF schet_vplan==.T.
              fwrite(desc,if(full_list,space(37),space(13))+"К оплате за эл.энергию   "+str(round(;
              if(&kredit_pres+-&debet_pres-sum_rashod+beznds>0,0,&debet_pres+;
              sum_rashod+beznds-&kredit_pres),Decimal))+chr(13)+chr(10))
           ENDIF
//           fwrite(desc,if(full_list,space(37),space(13))+'Пеня       (долг)       '+str(oborotpenq-obor_otpenq,14,2)+crlf)
                                         IF GetPenq(Main->Lic_Schet,Month)>0
                        fwrite(desc,if(full_list,space(37),space(13))+'% банка    (долг)       '+str(GetPenq(Main->Lic_Schet,Month),14,2)+crlf)
           ENDIF
           IF GetHigh(Main->Lic_Schet,Month)>0
                        fwrite(desc,if(full_list,space(37),space(13))+'Повышенная (долг)       '+str(GetHigh(Main->Lic_Schet,Month),14,2)+crlf)
           ENDIF
//           IF SumKategory!=0
//              fwrite(desc,if(full_list,space(37),space(13))+"Абонированная мощность  "+str(round(SumKategory*(schet_nds+100)/100,Decimal),14,2)+crlf)
//           ENDIF
           AbonSaldo:=GetAbonSaldo(Main->Lic_Schet,Month)
//           IF AbonSaldo!=0
           IF Main->kategory==chr(1)
              IF AbonSaldo!=0
                 fwrite(desc,if(full_list,space(37),space(13))+"Абонированная       "+IF(AbonSaldo<0,"  Дебет"+str(-1*AbonSaldo,11,2),"Кредит"+str(AbonSaldo,12,2))+crlf)
              ELSE
                 fwrite(desc,if(full_list,space(37),space(13))+"Абонированная             "+str(0,12,2)+crlf)
              ENDIF
           ENDIF
        ELSE
           fwrite(desc,space(24)+"Активная энергия  :"+str(round(power-RashKategory,0))+"        "+str(round(sum_rashod-sum_reak-SumKategory-Post393,Decimal))+crlf)
           fwrite(desc,space(24)+"Реактивная энергия:"+str(round(reaktiv,0))+"         "+str(round(sum_reak,Decimal))+crlf)
           fwrite(desc,space(37)+"Н Д С "+alltrim(str(schet_nds))+"%             "+str(round((osum_rashod-SumKategory)*schet_nds/100,Decimal))+crlf)
           fwrite(desc,space(37)+"Итого:                   "+str(round(sum_rashod-SumKategory+(osum_rashod-SumKategory)*schet_nds/100,Decimal))+crlf)
        ENDIF   // FULL_LIST
//        FWrite(Desc,CrLf+CrLf+Space(20)+"Директор                           "+AllTrim(NameBoss)+CrLf+CrLf)
//        FWrite(Desc,Space(20)+          "Гл.бухгалтер                       "+AllTrim(NameBuh)+CrLf+CrLf)
        FWrite(Desc,CrLf+CrLf+Space(20)+cNameBoss+"                           "+AllTrim(NameBoss)+CrLf+CrLf)
        FWrite(Desc,Space(20)+          cNameBuh +"                           "+AllTrim(NameBuh)+CrLf+CrLf)

//        colorwin(12,21,12,60,'n/n')
        fclose(desc)
        ret=.t.
        if sum_rashod+BezNds=0
                al_box({'Cчет печатать не надо. Cумма нулевая'})
//                deletefile(Ddir+'otchet.gkv')
                ret=.f.
        endif
                 oProgress:destroy()                                                                                                                                                                                    // Progress Bar Destroy
                 oDlg:Destroy()
endcase
if select()#old_sel
        select(old_sel)
endif
schet_=schtmp
setcolor(old_col)
win_rest(old_scr)
Return ret



function oplacheno(month1)
local sum:=0,select:=select(),recno:=recno(),NameInd:=""
select 44
month_=Schet_Share+'o'+alltrim(str(month1))
NameInd:=Schet_Share+'o'+alltrim(str(month1))+".ntx"
IF .not.NetUse(month_,,0)
   Select(Select)
   Al_Box({"Оплата не расчитана"})
   Return 0
ENDIF
Set Index to &NameInd
go top
Seek Main->Lic_Schet
sum=0
wozw_n=0
woz_wrat=0
//do while .not.EOF()
do while licevoj==Main->Lic_Schet
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
                        endif
                endif
        endif
        skip
enddo
use
select(select)
go recno
RETURN Sum



FUNCTION GetLimit(Month_,Lic)
LOCAL Sel:=Select(),Rashod
Lic:=IF(Lic==Nil,Main->Lic_Schet,Lic)
IF Month_<1.and.Month_>12
   Al_Box({"Неверный месяц для поиска лимита"})
   Return 0
ENDIF
DO CASE
   case month_==1
        Rashod:="Limit->jan"
   case month_==2
        Rashod:="Limit->feb"
   case month_==3
        Rashod:="Limit->mac"
   case month_==4
        Rashod:="Limit->apr"
   case month_==5
        Rashod:="Limit->may"
   case month_==6
        Rashod:="Limit->jun"
   case month_==7
        Rashod:="Limit->jul"
   case month_==8
        Rashod:="Limit->aug"
   case month_==9
        Rashod:="Limit->sep"
   case month_==10
        Rashod:="Limit->oct"
   case month_==11
        Rashod:="Limit->nov"
   case month_==12
        Rashod:="Limit->dec"
ENDCASE
Select Limit
SEEK Lic
IF Found()
   Rashod:=&Rashod
ELSE
   Rashod:=0
ENDIF
Select(sel)
RETURN Rashod





*******************************************************************
***                                                               *
***   Функция генерации отчета по потребителю по всем счетчикам   *
***                                                               *
*******************************************************************
Function OTCHETOld(Month,Mych)
local old_deb:=0,old_kred:=0,oldsel,mesqc2,osum_rashod
LOCAL desc,CrLf:=chr(13)+chr(10),full_list:=.T.,schtmp:=schet_
LOCAL FoundAbon:=.F.
LOCAL SumKategory:=0, RashKategory:=0
PRIVATE old_sel,old_col,old_scr,x,sum_rashod,power,first,nm1,ret,sixrub
PRIVATE beznds,reaktiv,sum_reak,o_ldsel,schet_dnold:=schet_dnal
sum_reak=0
reaktiv=0
sixrub=.f.
ret=.t.
old_col=setcolor()
old_scr=win_save()
old_sel=select()

if mych==1
   full_list=.T.
else
   full_list=.F.
endif
if mych==3
   schet_=schtmp
   return .f.
endif

if month=0
   schet_=schtmp
   return .f.
endif
mesqc=mesqc(month)
mesqc2=mesqc(month,1)
do case
   case month>0.and.month<13
        schtmp=schet_
        schet_=main->lic_schet
        save screen
******************************************************************************
* Здесь был блок расчета дебет/кредит, который перемещен в конец файла,
* а вместо него добавлен вызов следующего:
mon_the=month
do outex with month
message("Расчет сальдо за выбранный месяц")
******************************************************************************
        restore screen
//        colorwin(11,19,15,65,'b/n')
//       obrabot("Анализ показаний счетчиков")
       obrabot("Формирование "+if(full_list,"полного","краткого")+" счета")
        _lic_schet=main->lic_schet
        sum_rashod=0
        power=0
        first=.t.
        desc:=fcreate(M->Ddir+"otchet.gkv")
        select 77
        temp_=39/reccount()
        kol_kl=0
        go top
        beznds=0
        seek main->lic_schet
        do while lic_sch=main->lic_schet
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if lic_sch#_lic_schet
                        skip
                else
                        select(month)
                        poisk='('+alltrim(str(_lic_schet))+')'+alltrim(licevoj->schetchik)
                        seek poisk
                        if found().and..not.deleted()
// Анализ категории счетчика. Если это промышленный, то считаем расход
// и согласно постановления превышение расчитывается по увеличенному тарифу
                           IF alltrim(MYupper(Licevoj->schetchik))=="АБОН.МОЩН"
                              FoundAbon:=.T.
                              SumKategory:=SumKategory+Summa
                              RashKategory:=RashKategory+Rashod
                           ENDIF
                            if first=.t.
                                fwrite(desc,M->schet_naz1+"           "+'С Ч Е Т  '+alltrim(str(schet_))+crlf+M->schet_naz2+crlf)
                                fwrite(desc,M->schet_naz3+'           Наименование потребителя'+crlf)
                                fwrite(desc,M->schet_ban2+'           '+alltrim(main->potrebitel)+crlf)
                                Fwrite(desc,M->schet_rsch+'           Р.сч. N '+alltrim(licevoj->r_schet)+crlf)
                                fwrite(desc,M->schet_ksch+'           в '+alltrim(licevoj->bank)+crlf)
//                                fwrite(desc,M->schet_town+'           Наименование об`екта '+alltrim(licevoj->object1)+' '+alltrim(licevoj->object2)+crlf)
                                fwrite(desc,M->schet_town+crlf)
                                fwrite(desc,'Адрес об`екта '+if(empty(main->adress),alltrim(licevoj->adres),alltrim(main->adress))+crlf)
                                fwrite(desc,'За '+mesqc+' '+alltrim(str(year(new_date)))+"г.  по лицевому счету N "+alltrim(str(main->lic_schet))+crlf)
                                oldsel=select()
                                select 15
                                old_deb=if(month>1,"debet"+alltrim(str(month-1)),"last_debet")
                                old_kred=if(month>1,"kredit"+alltrim(str(month-1)),"last_kred")
                                old_deb=&old_deb
                                old_kred=&old_kred
                                select(oldsel)
                                if .not.full_list
                                   fwrite(desc,crlf)
                                endif
                                do case
                                   case old_deb>0.and.old_kred=0
                                        fwrite(desc,"На 1-е "+mesqc2+" сальдо: дебит "+alltrim(str(old_deb))+crlf)
                                   case old_deb=0.and.old_kred>0
                                        fwrite(desc,"На 1-е "+mesqc2+" сальдо: кредит "+alltrim(str(old_kred))+crlf)
                                   case old_deb>0.and.old_kred>0
                                        fwrite(desc,"На 1-е "+mesqc2+" сальдо: дебит "+alltrim(str(old_deb))+" кредит "+alltrim(str(old_kred))+crlf)
                                   case old_deb=0.and.old_kred=0
                                        fwrite(desc,"На 1-е "+mesqc2+" сальдо нулевое"+crlf)
                                endcase
                             if full_list
                                fwrite(desc,"┌─────────────┬─────────┬─────────┬───────┬─────────┬────────┬─────────────────┐"+crlf)
                                fwrite(desc,"│N эл/счетчика│Показания│ Разность│Коэфф. │ Расход  │ Тариф  │      Сумма      │"+crlf)
                                fwrite(desc,"│             │         │показаний│       │ квт/ква │        │                 │"+crlf)
                                fwrite(desc,"├─────────────┼─────────┼─────────┼───────┼─────────┼────────┼─────────────────┤"+crlf)
                             endif
                               first=.f.
                             endif
                                if summa#0
                                   if full_list
//                                        fwrite(desc,"│    "+num_of_sch+;
//                                        '   │ '+str(pokazaniq,5,0)+'   │  '+;
                                        fwrite(desc,"│  "+LICEVOJ->Schetchik+;
                                        '  │ '+str(pokazaniq,5,0)+'   │  '+;
                                        str(raznica,5,0)+'  │ '+;
                                        str(koeficient,5,0)+' │'+;
                                        str(if(rashod-subab>0,rashod-subab,subab-rashod),9,0)+;
                                        '│'+str(tarif,8,4)+'│ '+;
                                        str(summa,16,2)+'│'+crlf)
                                   endif
                                endif
if summa>0
        if tarif=schet_tar1.or.tarif=schet_tar2.or.tarif=schet_tar3.or.;
        tarif=schet_tar4.or.tarif=schet_tar5.or.tarif=schet_tar6.or.tarif=schet_tar7.and.;
        tarif=schet_tar8.or.tarif=schet_tar9
                                        beznds=beznds+summa
                                else
                                        sum_rashod=sum_rashod+summa
                                endif
else
        sum_rashod=sum_rashod+summa
endif
                                if .not.empty(summa)
                                        if rashod>0
*-------------------------------------                                                  if .not.drug_nach
                                                if .not.licevoj->reaktivn
                                                        power=power+if(rashod-subab>0,rashod-subab,subab-rashod)
                                                else
                                                        reaktiv=reaktiv+if(rashod-subab>0,rashod-subab,subab-rashod)
                                                        sum_reak=sum_reak+summa
                                                endif
                                        else
*-------------------------------------                                                  if .not.drug_nach
                                                if .not.licevoj->reaktivn
                                                        power=power+rashod-subab
                                                else
                                                        reaktiv=reaktiv+rashod-subab
                                                        sum_reak=sum_reak+summa
                                                endif
                                        endif
                                endif
                                if drug_nach#licevoj->reaktivn
                                   if reclock()
                                        replace drug_nach with licevoj->reaktivn
                                        unlock
                                   endif
                                endif
                        endif
                        select 77
                        skip
                endif
        enddo
        IF Full_List
           Fwrite(desc,"└─────────────┴─────────┴─────────┴───────┴─────────┴────────┴─────────────────┘"+crlf)
        ENDIF
        osum_rashod=sum_rashod
        nextmon1:=sum_rashod+beznds
        nextmon2:=round(sum_rashod*schet_nds/100,Decimal)
        IF Full_List
           fwrite(desc,space(62)+str(round(osum_rashod+beznds,Decimal))+crlf)
        ENDIF
        fwrite(desc,if(full_list,space(24),"")+"Активная энергия  :"+str(round(power-RashKategory,0))+"         "+str(round(sum_rashod-sum_reak-SumKategory,Decimal))+crlf)
        fwrite(desc,if(full_list,space(24),"")+"Реактивная энергия:"+str(round(reaktiv,0))+"         "+str(round(sum_reak,Decimal))+crlf)
        fwrite(desc,if(full_list,space(24),"")+"Абонированная мощн:"+str(round(RashKategory,0))+"         "+str(round(SumKategory,Decimal))+crlf)

        fwrite(desc,if(full_list,space(37),space(13))+"Н Д С "+alltrim(str(schet_nds))+"%             "+str(round(osum_rashod*schet_nds/100,Decimal))+crlf)
        fwrite(desc,if(full_list,space(37),space(13))+"Итого:                   "+str(round(sum_rashod+osum_rashod*schet_nds/100,Decimal))+crlf)
        sum_rashod=sum_rashod+round(sum_rashod*schet_nds/100,Decimal)+beznds+round(sum_rashod*schet_dnal/100,Decimal)+round(RashKategory*MaxRashSum,Decimal)
        schet_dnal:=schet_dnold
//        NextMon1:=NextMon1-SumKategory
        fwrite(desc,if(full_list,space(37),space(13))+'К оплате на след. месяц :'+str(round(nextmon1,Decimal))+crlf)
        fwrite(desc,if(full_list,space(37),space(13))+'                    НДС :'+str(round(nextmon2,Decimal))+crlf)
        fwrite(desc,if(full_list,space(37),space(13))+'                  Итого :'+str(round(nextmon1+nextmon2,Decimal))+crlf)
        fwrite(desc,if(full_list,space(37),space(13))+"Оплачено всего          :"+str(oplacheno(month),13,2)+crlf)
        select 15
        debet_pres='debet'+alltrim(str(month))
        kredit_pres='kredit'+alltrim(str(month))
        len:=len('К оплате на след. месяц :')
        do case
                   case &debet_pres>0.and.&kredit_pres=0
                        tmpstr:='На '+if(month#month(new_date),'1-e '+mesqc(month+1,.t.),dtoc(new_date))+' Дебет '
                        fwrite(desc,if(full_list,space(37),space(13))+tmpstr+space(len-len(tmpstr)-1)+str(&debet_pres)+crlf)
                case &debet_pres=0.and.&kredit_pres>0
                        tmpstr:='На '+if(month#month(new_date),'1-e '+mesqc(month+1,.t.),dtoc(new_date))+' Кредит'
                        fwrite(desc,if(full_list,space(37),space(13))+tmpstr+space(len-len(tmpstr)-1)+str(&kredit_pres)+crlf)
        endcase
        Sum_Rashod:=round(osum_rashod+osum_rashod*schet_nds/100,Decimal)
        fwrite(desc,if(full_list,space(37),space(13))+"К оплате за эл.энергию   "+str(round(;
        if(&kredit_pres+-&debet_pres-sum_rashod>0,0,&debet_pres+;
        sum_rashod-&kredit_pres),Decimal))+chr(13)+chr(10))
//        fwrite(desc,if(full_list,space(37),space(13))+'Пеня       (долг)       '+str(oborotpenq-obor_otpenq,14,2)+crlf)
        fwrite(desc,if(full_list,space(37),space(13))+'% банка    (долг)       '+str(GetPenq(Main->Lic_Schet,Month),14,2)+crlf)
        fwrite(desc,if(full_list,space(37),space(13))+'Повышенная (долг)       '+str(GetHigh(Main->Lic_Schet,Month),14,2)+crlf)
        colorwin(12,21,12,60,'n/n')
        fclose(desc)
        ret=.t.
        if sum_rashod=0
                al_box({'Cчет печатать не надо. Cумма нулевая'})
                deletefile(Ddir+'otchet.gkv')
                ret=.f.
        endif
endcase
if select()#old_sel
        select(old_sel)
endif
schet_=schtmp
setcolor(old_col)
win_rest(old_scr)
Return ret
