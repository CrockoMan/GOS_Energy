**********************************************************************
*                                                                    *
*        Функция генерации акта сверки                               *
*                                                                    *
**********************************************************************
function sverka()
LOCAL old_col1:=setcolor(),screen:=win_save(6,28,24,79),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok:={},pos:=1
local first:=.T.
spisok:={" Cтандартный ",;
         ' АО "КубаньЭнерго" ',;
         " Стандартный с пеней ",;
         ' АО "КубаньЭнерго" с пеней',;
         " За период",;
         ' АО "КубаньЭнерго" свернутый   ',;
         ' Абонированная за период',;
         ' АО "КубаньЭнерго" с реквизитами    ',;
         ' Акт сверки без перепродавцов ',;
         ' Реестр актов сверки ФБ'}
//         "───────────────────────────────",;
//         " Выход"}
do while pos>0
   AFill(is_choice,.t.)
   if first
      pos=1
      first=.F.
   endif
   choice=vert_menu(spisok,"Акт сверки",is_choice,9,32,pos,'n/w,n/g,,,r/w',.F.)
   pos=choice
   wid=choice
   widsav:=wid
   if wid<8.and.wid>0
      deletefile(Ddir+"otchet.gkv")
      pos=choice
   else
      pos=len(spisok)
   endif
   do case
      case wid=1
           sverka1(.f.)
      case wid=2
           sverka2(.f.)
      case wid=3
           sverka1(.t.)
      case wid=4
           sverka2(.t.)
      case wid=5
           sverka3()
      case wid=6
           sverka4()
      case wid=7
           sverka5()
      case wid=8
           sverka6()
      case wid=9
           sverka7()
      case wid=10
           SvReestr()
      otherwise
           exit
   endcase
   wid=if(file(Ddir+'otchet.gkv'),8,widsav)
enddo
M->prev_rec=-1
M->ret_val=2
win_rest(screen)
setcolor(old_col1)
return NIL




FUNCTION Sverka6()
Local Sel:=select(),Rec:=Recno(),Win:=Win_Save(),Color:=Setcolor()
Local Desc,Period:=0,CrLf:=chr(13)+chr(10),Rash:=0,Opl:=0,Total:={0,0,0}
Local Position:=0,Saldo:="Не найдено",Rh:=0,Choi:=0
Private Town:=" ",FirstDolg:=0,EnergyMoney:=0,cDolg:="Дебет",cEDolg:="Дебет"
Private EnergyOplata:=0,PresDolg:=0,Period_Name:="месяц",SMonth:=0,EMonth:=0
Private EnergyRashod:=0,Potr:=DelString(Potrebitel,"ИНН"),cMon:="01."
Potr:=DelString(Potr,"л/с ")
Choi:=Al_Box({'Акт сверки АО "Кубаньэнерго" за период'},3,{" Месяц "," Квартал "," Выход "})
DO Case
   Case Choi==1
        Period:=Month_Menu("Акт сверки за месяц")
        SMonth:=Period; EMonth:=Period
        Period_Name:=Mesqc(Period)+" месяц"
   Case Choi==2
        Period:=Kvartal_Menu("для формирования акта")
        DO Case
           Case Period==1
                SMonth:=1; EMonth:=3
                Period_Name:="первый квартал"
           Case Period==2
                SMonth:=4; EMonth:=6
                Period_Name:="второй квартал"
           Case Period==3
                SMonth:=7; EMonth:=9
                Period_Name:="третий квартал"
           Case Period==4
                SMonth:=10; EMonth:=12
                Period_Name:="четвертый квартал"
        ENDCASE
ENDCASE
IF Choi>0.and.Choi<3.And.Period>0
   obrabot("Расчет акта сверки")
   Select Obormot; Seek Main->Lic_Schet
   IF Found()
      IF SMonth==1
         FirstDolg:=Round(IF(Last_Debet>0,-1*Last_Debet,Last_Kred)/1000,2)
         cMon:="01.01."+Alltrim(Str(Year(new_date)))
      ELSE
         FirstDolg:=Round(GetSaldo(Main->Lic_Schet,SMonth-1)/1000,2)
         cMon:="01."+IF(SMonth<10,"0","")+Alltrim(Str(SMonth))+"."+Alltrim(Str(Year(new_date)))
      ENDIF
   ENDIF
   cDolg:=IF(FirstDolg>0,"Кредит","Дебет ")
   FirstDolg:=IF(FirstDolg>0,FirstDolg,-1*FirstDolg)
   Select Main
   PresDolg:=Round(GetSaldo(Main->Lic_Schet,EMonth)/1000,2)
   cEDolg:=IF(PresDolg>0,"Кредит","Дебет ")
   PresDolg:=IF(PresDolg>0,PresDolg,-1*PresDolg)
   For i=SMonth to EMonth
       Position=Position+39/EMonth
       ColorWin(12,21,12,21+Position,'n/n')
       EnergyOplata:=EnergyOplata+Round(CalckPay(i,Main->Lic_Schet,.f.,1)/1000,2)
       EnergyMoney :=EnergyMoney +Round(GetSum(Main->Lic_Schet,i)/1000,2)
       EnergyRashod:=EnergyRashod+Round(GetRashod(Main->Lic_Schet,i)/1000,2)
   Next
   Select Licevoj
   Seek Main->Lic_Schet
   IF AtNum("Г.",MYUpper(Bank))!=0
      Town:=Substr(Bank,AtNum("Г.",MYUpper(Bank)),Len(Bank))
   ELSE
      Town:="."
   ENDIF
   Report(DDir+"Sverka.Rpt",DDir+ReportFile,130)
ENDIF
Select(Sel);  Go Rec;  SetColor(Color);  Win_Rest(Win)
Return Nil




FUNCTION Sverka5()
Local Sel:=select(),Rec:=Recno(),Win:=Win_Save(),Color:=Setcolor()
Local Desc,Period:=0,CrLf:=chr(13)+chr(10),Rash:=0,Opl:=0,Total:={0,0,0}
Local Position:=0,Saldo:="Не найдено",Rh:=0
Period:=Month_Menu("Акт сверки с Января по")
If Period!=0
   obrabot("Расчет акта сверки")
   Desc:=FCreate(DDir+ReportFile)
   Fwrite(Desc,Space(10)+center("Акт сверки",43," ")+CrLf)
   fwrite(Desc,Space(10)+center(alltrim(Main->Potrebitel),43," ")+CrLf)
   fwrite(Desc,Space(10)+center("c 01.01."+alltrim(str(year(new_date)))+" по "+AllTrim(str(LastDayoM(Period)))+"."+;
               if(Period<10,"0","")+alltrim(str(Period))+"."+alltrim(str(year(new_date))),43," ")+CrLf)
   Fwrite(Desc,Space(10)+center("Сальдо на 01.01."+alltrim(str(year(new_date)))+;
               " "+Saldo,43," ")+CrLf)
   Fwrite(Desc,space(10)+"┌─────────┬───────────────┬───────────────┬────────────┐"+CrLf)
   Fwrite(Desc,space(10)+"│  Месяц  │   Начислено   │    Оплачено   │   Сальдо   │"+CrLf)
   Fwrite(Desc,space(10)+"├─────────┼───────────────┼───────────────┼────────────┤"+CrLf)
   For i=1 to Period
       Position=Position+39/(Period*2)
       ColorWin(12,21,12,21+Position,'n/n')
       Rash:=0; Opl:=0
       Rash:=GetAbonSum(Main->Lic_Schet,i)
       Rash:=Rash*(Schet_Nds+100)/100
       Total[1]:=Total[1]+Rash
       Position=Position+39/(Period*2)
       colorwin(12,21,12,21+Position,'n/n')
       Opl:=CalckPay(i,Main->Lic_Schet,.f.,4)
       Total[2]:=Total[2]+Opl
       Fwrite(Desc,space(10)+"│"+center(Mesqc(I),9," ",.t.)+"│"+str(Rash,15,2)+"│"+str(Opl,15,2)+"│"+str(GetAbonSaldo(Main->Lic_Schet,I),12,2)+"│"+CrLf)
   Next
   Fwrite(Desc, space(10)+"├─────────┼───────────────┼───────────────┼────────────┤"+CrLf)
   Fwrite(Desc, space(10)+"│  Всего  │"+str(Total[1],15,2)+"│"+str(Total[2],15,2)+"│"+str(GetAbonSaldo(Main->Lic_Schet,Period),12,2)+"│"+CrLf)
   Fwrite(Desc, space(10)+"└─────────┴───────────────┴───────────────┴────────────┘"+CrLf+CrLf)
   FWrite(Desc, Space(10)+SchetNameOrg+CrLf)
   FWrite(Desc, Space(10)+cNameBoss+'                                   '+AllTrim(NameBoss)+CrLf+CrLf)
   FWrite(Desc, Space(10)+cNameBuh+ "                                   "+AllTrim(NameBuh)+CrLf)
   FClose(Desc)
   Select(Sel)
   Go Rec
   SetColor(Color)
   Win_Rest(Win)
EndIf
Return Nil





Function SVERKA1(is_show_penq)
local itog1:=0,itog2:=0,itog3:=0,itog4:=0
private old_sel,old_col,old_scr,x,sum_rashod,power,first,x,nm1,ret,sixrub,;
beznds,reaktiv,sum_reak,o_ldsel,schet_dnold:=schet_dnal,desc,CrLf:=chr(13)+chr(10)
sum_reak=0
reaktiv=0
sixrub=.f.
ret=.t.
old_col=setcolor()
save screen to old_scr
old_sel=select()
month=month_menu()
if month=0
        return .f.
endif
mesqc=mesqc(month)
do case
   case month>0.and.month<13
        colorwin(11,19,15,65,'b/n')
        obrabot("Анализ показаний счетчиков")
******************************************************************************
* блок расчета дебет/кредит
mon_the=month
do outex with month
month=mon_the
******************************************************************************
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
        do while lic_sch==main->lic_schet
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if lic_sch#_lic_schet
                        skip
                else
                        select(month)
                        poisk='('+alltrim(str(_lic_schet))+')'+alltrim(licevoj->schetchik)
                        seek poisk
                        if found().and..not.deleted().and.alltrim(MYupper(Licevoj->schetchik))!="АБОН.МОЩН"

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
                                   IF reclock()
                                        replace drug_nach with licevoj->reaktivn
                                        unlock
                                   ENDIF
                                endif
                        endif
                        select 77
                        skip
                endif
        enddo
        nextmon1:=sum_rashod+beznds
        nextmon2:=round(sum_rashod*schet_nds/100,DECIMAL)
*        fwrite(desc,space(62)+str(round(sum_rashod+beznds,2))+crlf)
*        fwrite(desc,space(36)+" Н Д С "+alltrim(str(schet_nds))+"%             "+str(round(round(sum_rashod*schet_nds/100,0),2))+crlf)
        IF month<4.and.year(new_date)=1995
                schet_dnal:=3.00
        ENDIF
        sum_rashod=sum_rashod+round(sum_rashod*schet_nds/100,2)+beznds+round(sum_rashod*schet_dnal/100,2)
        schet_dnal:=schet_dnold
         itog1=round(sum_rashod,Decimal)
         itog2=nextmon2
        select 15
        debet_pres='debet'+alltrim(str(month))
        kredit_pres='kredit'+alltrim(str(month))
len:=len('К оплате на след. месяц :')
        do case
*                case &debet_pres=0.and.&kredit_pres=0
*                        fwrite(desc,space(37)+'На '+if(month#month(new_date),'1-e '+mesqc(month+1,.t.),dtoc(new_date))+' сальдо нулевое '+crlf)
                case &debet_pres>0.and.&kredit_pres=0
*                        tmpstr:='На '+if(month#month(new_date),'1-e '+mesqc(month+1,.t.),dtoc(new_date))+' Дебет  '
*                        fwrite(desc,space(37)+tmpstr+space(len-len(tmpstr)+1)+str(&debet_pres)+crlf)
                         itog3:=&debet_pres
                case &debet_pres=0.and.&kredit_pres>0
*                        tmpstr:='На '+if(month#month(new_date),'1-e '+mesqc(month+1,.t.),dtoc(new_date))+' Кредит '
*                        fwrite(desc,space(37)+tmpstr+space(len-len(tmpstr)+1)+str(&kredit_pres)+crlf)
                         itog4:=&kredit_pres
        endcase
*        fwrite(desc,space(37)+"К оплате за эл.энергию  "+str(round(;
*        if(&kredit_pres-&debet_pres-sum_rashod>0,0,&debet_pres+;
*        sum_rashod-&kredit_pres),0),14,2)+chr(13)+chr(10))
        OborOtpenq=GetPenq(Main->Lic_Schet,Month)
*        fwrite(desc,space(37)+'Пеня       (задолженность)'+str(oborotpenq-obor_otpenq,12,2)+crlf)
        OborOthigh=GetHigh(Main->Lic_Schet,Month)
*        fwrite(desc,space(37)+'Повышенная (задолженность)'+str(oborothigh-obor_othigh,12,2)+crlf)
        OborotAbon:=GetAbonSaldo(Main->Lic_Schet,Month)
        colorwin(12,21,12,60,'n/n')
        ret=.t.
        select 77
        seek main->lic_schet
        for jk=1 to 2
            FWRITE(DESC,CENTER("АКТ СВЕРКИ",76)+CRLF+crlf)
            fwrite(desc,"   от "+dtoc(new_date)+"                                        г.Анапа"+crlf+crlf)
            fwrite(desc,'   Мы, нижеподписавшиеся, гл. бухгалтер '+SchetNameOrg+AllTrim(NameBuh)+crlf+crlf)
            fwrite(desc,"   с одной стороны и бухгалтер "+alltrim(main->potrebitel)+crlf+crlf)
            fwrite(desc,"   адрес "+alltrim(main->adress)+" договор N"+alltrim(str(main->lic_schet))+" банк "+alltrim(licevoj->bank)+crlf+crlf)
            fwrite(desc,"   р/с "+alltrim(licevoj->r_schet)+"  к/с "+licevoj->k_schet+" БИК "+licevoj->mfo+crlf+crlf)
            fwrite(desc,"   с другой, произвели сверку  расчетов  за  эл. энергию  по  состоянию"+crlf+crlf)
            fwrite(desc,"   на "+if(month=month(new_date),dtoc(new_date),alltrim(str(lastdayom(month)))+"."+alltrim(str(month))+"."+alltrim(str(year(new_date))) )+crlf+crlf)
            fwrite(desc,"--------------------------------------------------------------------------"+crlf)
            fwrite(desc," "+SchetNameOrg+'   |'+delstring(alltrim(main->potrebitel),"ИНН")+crlf)
            fwrite(desc,"По данным _________________________|По данным_____________________________"+crlf)
            fwrite(desc,"--------------------------------------------------------------------------"+crlf)
            fwrite(desc,"       Дебет     |     Кредит      |      Дебет      |      Кредит"+crlf)
            fwrite(desc,"--------------------------------------------------------------------------"+crlf)
            fwrite(desc,"                                   |"+crlf)
            fwrite(desc," "+if(itog3#0,str(itog3,14,2),space(14))+"    "+if(itog4#0,str(itog4,14,2),space(14))+"  |"+crlf)
            IF Is_Show_Penq
               If oborotPenq!=0
                  fwrite(desc,"% бан"+str(oborotpenq,14,2)+space(16)+"|"+crlf)
               EndIf
               If OborotHigh!=0
                  fwrite(desc,"Повышенная "+str(oborothigh,14,2)+space(10)+"|"+crlf)
               EndIf
               If OborotAbon!=0
                  fwrite(desc,"Абонированная "+str(OborotAbon,14,2)+space(10)+"|"+crlf)
               EndIf
            ENDIF
            fwrite(desc,"                                   |"+replicate(crlf,2))
            fwrite(desc,cNameBoss+"                                    Руководитель"+crlf)
//            fwrite(desc,'УМП "Горэлектросеть"     В.М.Волков'+CrLf+CrLf)
            fwrite(desc,SchetNameOrg+'   '+AllTrim(NameBoss)+CrLf+CrLf)
            fwrite(desc,cNameBuh+ "             "+AllTrim(NameBuh)+"       Гл.Бухгалтер"+crlf)
            if jk=1
               fwrite(desc,crlf)
            endif
        next
        fclose(desc)
endcase
if select()#old_sel
        select(old_sel)
endif
setcolor(old_col)
restore screen from old_scr
Return ret





Function SVERKA2(is_show_penq)
local itog1:=0,itog2:=0,itog3:=0,itog4:=0,itog5:=0,itog6:=0,TempLen:=0
Local OborotPenq:=0,OborotHigh:=0,OborotAbon:=0
Local oDlg,aSizeDeskTop,aPos,oProgress
private old_sel,old_col,old_scr,x,sum_rashod,power,first,x,nm1,ret,sixrub,;
beznds,reaktiv,sum_reak,o_ldsel,schet_dnold:=schet_dnal,desc,CrLf:=chr(13)+chr(10)
sum_reak=0
reaktiv=0
sixrub=.f.
ret=.t.
old_col=setcolor()
save screen to old_scr
old_sel=select()
month=month_menu()
if month=0
        return .f.
endif
mesqc=mesqc(month)
do case
   case month>0.and.month<13
//        colorwin(11,19,15,65,'b/n')
//        obrabot("Анализ показаний счетчиков")

                                oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
                                aSizeDesktop  := AppDesktop():currentSize()
                                oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
                                oDlg:title    := "Анализ показаний счетчиков"
                                oDlg:SysMenu    := .F.
                                oDlg:Configure()
                                oDlg:Show()
                                aSizeDesktop  := oDlg:currentSize()
                                aPos                                    := oDlg:CurrentPos()
                                oProgress               := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

                                oProgress:create()
                                oProgress:minimum := 1
                                oProgress:maximum := 7
******************************************************************************
* блок расчета дебет/кредит
mon_the=month
do outex with month
month=mon_the
                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
******************************************************************************
        _lic_schet=main->lic_schet
        sum_rashod=0
        power=0
        first=.t.
        desc:=fcreate(M->Ddir+"otchet.gkv")
        select 77
//        temp_=39/reccount()
//        kol_kl=0
        go top
        seek main->lic_schet
        beznds=0
                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
        do while lic_sch==main->lic_schet
//           kol_kl=kol_kl+temp_
//           colorwin(12,21,12,21+kol_kl,'n/n')
           if lic_sch#_lic_schet
              skip
           else
              select(month)
              poisk='('+alltrim(str(_lic_schet))+')'+alltrim(licevoj->schetchik)
              seek poisk
              if found().and..not.deleted().and.alltrim(MYupper(Licevoj->schetchik))!="АБОН.МОЩН"
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
                       if .not.licevoj->reaktivn
                          power=power+if(rashod-subab>0,rashod-subab,subab-rashod)
                       else
                          reaktiv=reaktiv+if(rashod-subab>0,rashod-subab,subab-rashod)
                          sum_reak=sum_reak+summa
                       endif
                    else
                       if .not.licevoj->reaktivn
                          power=power+rashod-subab
                       else
                          reaktiv=reaktiv+rashod-subab
                          sum_reak=sum_reak+summa
                       endif
                    endif
                 endif
                 if drug_nach#licevoj->reaktivn
                    IF reclock()
                       replace drug_nach with licevoj->reaktivn
                       unlock
                    ENDIF
                 endif
              endif
              select 77
              skip
           endif
        enddo
                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
        nextmon1:=sum_rashod+beznds
        nextmon2:=round(sum_rashod*schet_nds/100,DECIMAL)
        IF month<4.and.year(new_date)=1995
           schet_dnal:=3.00
        ENDIF
        sum_rashod=sum_rashod+round(sum_rashod*schet_nds/100,2)+beznds+round(sum_rashod*schet_dnal/100,2)
        schet_dnal:=schet_dnold
         itog1=round(round(sum_rashod,DECIMAL),2)
         itog2=nextmon2
        select 15
                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
// Сальдо на сегодняшнее число
        debet_pres='debet'+alltrim(str(month))
        kredit_pres='kredit'+alltrim(str(month))
                                len:=len('К оплате на след. месяц :')
        do case
           case &debet_pres>0.and.&kredit_pres=0
                itog3:=&debet_pres
           case &debet_pres=0.and.&kredit_pres>0
                itog4:=&kredit_pres
        endcase
// Сальдо на начало месяца
        debet_pres=if(month#1,'debet'+alltrim(str(month-1)),'last_debet')
        kredit_pres=if(month#1,'kredit'+alltrim(str(month-1)),'last_kred')
        do case
           case &debet_pres>0.and.&kredit_pres=0
                itog5:=&debet_pres
           case &debet_pres=0.and.&kredit_pres>0
                itog6:=&kredit_pres
        endcase
                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
//        colorwin(12,21,12,60,'n/n')
        ret=.t.
        select 77
        seek main->lic_schet
// Расчет оплаты за месяц
//select 44
month_='o'+alltrim(str(month))
//use &month_ SHARE
load('44',SCHET_SHARE+month_+".dbf",SCHET_SHARE+'o'+alltrim(str(month))+".Ntx",,.f.)
go top
sum=0
wozw_n=0
woz_wrat=0
do while .not.EOF()
   if licevoj=main->lic_schet
      if .not.deleted()
         if alltrim(vid_dokum)#'Пеня'.and.alltrim(vid_dokum)#'пеня'
            if alltrim(vid_dokum)="возврат".or.alltrim(vid_dokum)='Возврат'
               beznds=beznds+summa
               ***************************
               * Сумма возврата с начисления
//             woz_wrat=woz_wrat+summa
               ***************************
            else
               if alltrim(vid_dokum)="о возврат".or.alltrim(vid_dokum)='о Возврат'
                  sum=sum-summa
               else
                  if alltrim(vid_dokum)="н возврат".or.alltrim(vid_dokum)='н Возврат'
//                   wozw_n=wozw_n+summa
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
                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
// Конец расчета
        select 77
        seek main->lic_schet
            FWRITE(DESC,CENTER("А К Т",76)+CRLF+crlf)
            fwrite(desc,'   сверки расчетов между организацией ОАO "НЭСК" перепродавец '+crlf+"   "+SchetNameOrg+" ИНН "+SchetInn+" КПП "+SchetKPP+CrLf)
            fwrite(desc,'   '+alltrim(SchetAdr)+crlf)
            fwrite(desc,'   и потребителем электрической энергии '+alltrim(main->potrebitel)+crlf+"   "+AllTrim(Main->SecondName)+crlf)
            fwrite(desc,"   адрес "+alltrim(main->adress)+" договор N"+alltrim(str(main->lic_schet))+" банк "+alltrim(licevoj->bank)+crlf)
            fwrite(desc,"   р/с "+alltrim(licevoj->r_schet)+"  к/с "+licevoj->k_schet+" БИК "+licevoj->mfo+crlf+crlf+crlf)
            fwrite(desc,"   г. Анапа                                                    "+;
                        if(month=month(new_date),dtoc(new_date),alltrim(str(lastdayom(month)))+"."+alltrim(str(month))+"."+alltrim(str(year(new_date))) )+crlf+crlf+crlf)

            fwrite(desc,'   Мы, нижеподписавшиеся '+cNameBuh+" "+SchetNameOrg+" "+AllTrim(NameBuh)+crlf)
//            fwrite(desc,'   отделения Энергосбыта ОАО "НЭСК" с одной стороны '+crlf)
            fwrite(desc,"   с одной стороны и _____________________________________ бухгалтер предприятия"+crlf)
            fwrite(desc,"   "+alltrim(main->potrebitel)+","+crlf)
            fwrite(desc,"   с другой стороны произвели сверку взаимных расчетов за потребленную эл."+crlf)
            fwrite(desc,"   энергию по состоянию на "+;
                        if(month=month(new_date),dtoc(new_date),alltrim(str(lastdayom(month)))+"."+alltrim(str(month))+"."+alltrim(str(year(new_date))) )+crlf)
            fwrite(desc,"   При чем оказалось следующее:"+crlf+crlf+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"          |    По данным ОАО НЭСК      |   По данным потребителя   |  Отклонения"+crlf)
            fwrite(desc,'          |       перепродавец         |'+center(delstring(alltrim(main->potrebitel),"ИНН"),27," ",.t.)+"|"+crlf)
            fwrite(desc,'          |                            |                           |            '+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"          |   Дебет     |    Кредит    |    Дебет    |    Кредит   |"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Сальдо на |                            |                           |"+crlf)
            fwrite(desc,"нач.месяца|"+if(itog5#0,str(itog5,14,2),"")+space(14)+if(itog6#0,str(itog6,14,2),"")+"|"+space(27)+"|"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Начислено |"+str(itog1,14,2)+"              |                           |"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Оплачено  |              "+str(sum,14,2)+"|                           |"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Сальдо на |                            |                           |"+crlf)
            fwrite(desc,""+center(if(month=month(new_date),dtoc(new_date),alltrim(str(LastDayoM(month)))+"."+alltrim(str(month))+"."+;
            alltrim(str(year(new_date))) ),10," ",.t.)+"|"+if(itog3#0,str(itog3,14,2),"")+space(14)+;
            if(itog4#0,str(itog4,14,2),"")+"|                           |"+crlf)
            IF Is_Show_Penq
               OborotPenq:=GetPenq(Main->Lic_Schet,Month)
               If OborotPenq!=0
                  fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
                  fwrite(desc,"% банка   |"+str(oborotpenq,14,2)+"              |                           |"+crlf)
               EndIf
               OborotHigh:=GetHigh(Main->Lic_Schet,Month)
               If OborotHigh!=0
                  fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
                  fwrite(desc,"Повышенная|"+str(oborothigh,14,2)+"              |                           |"+crlf)
               EndIf
               OborotAbon:=GetAbonSaldo(Main->Lic_Schet,Month)
               OborotAbon:=IF(OborotAbon>0,OborotAbon,-1*OborotAbon)
               If OborotAbon!=0
                  fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
                  fwrite(desc,"Абонирован|"+IF(GetAbonSaldo(Main->Lic_Schet,Month)>0,Space(14),"")+str(OborotAbon,14,2)+"|                           |"+crlf)
                  OborotAbon:=IF(GetAbonSaldo(Main->Lic_Schet,Month)>0,-1*OborotAbon,OborotAbon)
               EndIf
            ENDIF
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Итого     |                            |                           |"+crlf)
            fwrite(desc,"допровести|                            |                           |"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf+crlf)
            fwrite(desc,"После проведения дополнительных записей бесспорное сальдо на сумму:"+crlf)
// Расчет суммы прописью
            IF Is_Show_Penq
               If Itog3>0
                  IF Itog3+OborotPenq+OborotHigh+OborotAbon>0
                     MySumma:=Itog3+OborotPenq+OborotHigh+OborotAbon
                  ELSE
                     MySumma:=-1*(Itog3+OborotPenq+OborotHigh+OborotAbon)
                  ENDIF
               ELSE
                  IF ((OborotPenq+OborotHigh+OborotAbon)-ITOG4)>0
                     MySumma:=((OborotPenq+OborotHigh+OborotAbon)-ITOG4)
                  ELSE
                     MySumma:=((OborotPenq+OborotHigh+OborotAbon)-ITOG4)
                     MySumma:=-1*MySumma
                  ENDIF
               ENDIF
//               mysumma=if(itog3#0,itog3+OborotPenq+OborotHigh,itog4+OborotPenq+OborotHigh)
            ELSE
               mysumma=if(itog3#0,itog3,itog4)
            ENDIF
            OborotAbon:=IF(OborotAbon>0,OborotAbon,-1*OborotAbon)
            mpsum2=""
            sumprop=str_chislo(mysumma,65)
            sumprop=sumprop+space(65-len(sumprop))
            sumpro=mpsum2+space(65-len(mpsum2))
//---------------------------------------------------
            fwrite(desc,alltrim(MYupper(sumprop)))
            TempLen:=Len(SumProp)
            if !empty(sumpro)
               fwrite(desc,crlf+alltrim(MYupper(sumpro)))
               TempLen:=Len(SumProp)
            endif
            IF Is_Show_Penq
               If OborotPenq!=0
                  mpsum2:=""
                  fwrite(desc,crlf+"В том числе % банка: "+MYupper(str_chislo(OborotPenq,65)))
                  TempLen:=Len(str_chislo(OborotPenq,65))+24
                  if !empty(mpsum2)
                     fwrite(desc,crlf+MYupper(mpsum2))
                     TempLen:=Len(MpSum2)
                  endif
               EndIf
               If OborotHigh!=0
                  mpsum2:=""
                  fwrite(desc,crlf+"В том числе повышенная "+MYupper(str_chislo(oborothigh,65)))
                  TempLen:=Len(str_chislo(OborotHigh,65))+24
                  if !empty(mpsum2)
                     fwrite(desc,crlf+MYupper(mpsum2))
                     TempLen:=Len(MpSum2)
                  endif
               EndIf
               If OborotAbon!=0
                  mpsum2:=""
                  fwrite(desc,crlf+"В том числе абонированная "+MYupper(str_chislo(oborotAbon,55)))
                  TempLen:=Len(str_chislo(OborotAbon,65))+24
                  if !empty(mpsum2)
                     fwrite(desc,crlf+MYupper(mpsum2))
                     TempLen:=Len(MpSum2)
                  endif
               EndIf
            ENDIF
//            fwrite(desc,IF(TempLen<56," ",CrLf)+'в пользу УМП "Горэлектросеть"'+crlf+crlf)
            fwrite(desc,IF(TempLen<56," ",CrLf)+'в пользу '+IF(Itog3+OborotPenq+OborotHigh+OborotAbon!=0,SchetNameOrg,Delstring(alltrim(main->potrebitel),"ИНН"))+crlf+crlf)
            fwrite(desc,MYupper(SchetNameOrg)+crlf)
            fwrite(desc,MYupper("задолженности по налогам и другим платежам в Федеральный бюджет не имеет")+crlf)
            fwrite(desc,"Подписи сторон:"+crlf)
            fwrite(desc,"Энергоснабжающей организации                         Потребителя электроэнергии"+crlf)
            fwrite(desc,cNameBoss+"                  "+AllTrim(NameBoss)+"            Руководитель"+crlf+CrLf)
            fwrite(desc,cNameBuh+ "                  "+AllTrim(NameBuh)+"             Гл. Бухгалтер"+crlf+crlf)
            fwrite(desc,"       М.П.                                          М.П."+crlf)
        fclose(desc)
                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
                        oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
                        oDlg:Destroy()
endcase
if select()#old_sel
        select(old_sel)
endif
setcolor(old_col)
restore screen from old_scr
Return ret




FUNCTION Sverka3()
Local Sel:=select(),Rec:=Recno(),Win:=Win_Save(),Color:=Setcolor()
Local Desc,Period:=0,CrLf:=chr(13)+chr(10),Rash:=0,Opl:=0,Total:={0,0,0}
Local Position:=0,Saldo:="Не найдено"
Local oDlg,aSizeDeskTop,aPos,oProgress
Period:=Month_Menu("Акт сверки с Января по")
If Period!=0
//   obrabot("Расчет акта сверки")

        oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
        aSizeDesktop  := AppDesktop():currentSize()
        oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
        oDlg:title    := "Обработано"
        oDlg:SysMenu    := .F.
        oDlg:Configure()
        oDlg:Show()
        aSizeDesktop  := oDlg:currentSize()
        aPos                                    := oDlg:CurrentPos()
        oProgress               := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

        oProgress:create()
        oProgress:minimum := 1
        oProgress:maximum := Period+1
   Desc:=FCreate(DDir+ReportFile)
   Fwrite(Desc,Space(10)+center("Акт сверки дог.N"+AllTrim(Str(Main->Lic_Schet)),45," ")+CrLf)
   fwrite(Desc,Space(10)+center(Substr(alltrim(Main->Potrebitel),1,45),45," ")+CrLf)
   fwrite(Desc,Space(10)+center(Substr(alltrim(Main->Potrebitel),45),45," ")+CrLf)
   fwrite(Desc,Space(10)+center("c 01.01."+alltrim(str(year(new_date)))+" по "+AllTrim(str(LastDayoM(Period)))+"."+;
               if(Period<10,"0","")+alltrim(str(Period))+"."+alltrim(str(year(new_date))),45," ")+CrLf)
   select obormot
   seek main->lic_schet
   if found()
      Saldo:=if(Last_Debet!=0,"Дебет "+alltrim(str(Last_Debet)),"Кредит "+alltrim(str(Last_Kred)))
   ENDIF
   oProgress:increment()                                                                                                                                                                // Progress Bar Increment
   Fwrite(Desc,Space(10)+center("Сальдо на 01.01."+alltrim(str(year(new_date)))+;
               " "+Saldo,43," ")+CrLf)
   Fwrite(Desc,space(10)+"┌─────────┬────────────┬───────────────┬───────────────┐"+CrLf)
   Fwrite(Desc,space(10)+"│  Месяц  │   Расход   │   Начислено   │    Оплачено   │"+CrLf)
   Fwrite(Desc,space(10)+"├─────────┼────────────┼───────────────┼───────────────┤"+CrLf)
   For i=1 to Period
                 oProgress:increment()                                                                                                                                                          // Progress Bar Increment
//       Position=Position+39/(Period*2)
//       ColorWin(12,21,12,21+Position,'n/n')
       Rash:=0; Opl:=0; Rh:=0
       Select Licevoj
       SEEK Main->Lic_Schet
       do while Lic_sch==Main->Lic_Schet
          IF AllTrim(MYUpper(Schetchik))!="АБОН.МОЩН"
             Poisk:="("+alltrim(str(Main->Lic_Schet))+")"+alltrim(schetchik)
             select(i); seek poisk
             IF Found()
                Rash:=Rash+Summa
             ENDIF
             SELECT Licevoj
          ENDIF
          Skip
       enddo
       Rash:=IF(I>9,Rash-GetAbonSum(Main->Lic_Schet,i),Rash)
       Rash:=Rash*(Schet_Nds+100)/100
       Total[1]:=Total[1]+Rash
       Position=Position+39/(Period*2)
       Rh:=GetRashod(Main->Lic_Schet,i)
       Total[3]:=Total[3]+Rh
//       colorwin(12,21,12,21+Position,'n/n')
       Base:=Schet_Share+"o"+alltrim(str(i))+".dbf"
       select 44
       IF NetUse(Base)
          go top
          do while !eof()
             IF Licevoj==Main->Lic_Schet
                IF lower(Vid_Dokum)!="о возврат"
                   Opl:=Opl+Summa
                ELSE
                   Opl:=Opl-Summa
                ENDIF
             ENDIF
             skip
          enddo
          Total[2]:=Total[2]+Opl
          use
       ENDIF
       Fwrite(Desc,space(10)+"│"+center(Mesqc(I),9," ",.t.)+"│"+Str(Rh,12,0)+"│"+str(Rash,15,2)+"│"+str(Opl,15,2)+"│"+CrLf)
   Next
   Fwrite(Desc,space(10)+"├─────────┼────────────┼───────────────┼───────────────┤"+CrLf)
   Fwrite(Desc,space(10)+"│  Всего  │"+str(Total[3],12,0)+"│"+str(Total[1],15,2)+"│"+str(Total[2],15,2)+"│"+CrLf)
   Fwrite(Desc,space(10)+"├─────────┴────────────┴───────────────┴───────────────┤"+CrLf)
   select obormot
   if found()
      Debet:="Debet"+alltrim(str(Period))
      Kredit:="Kredit"+alltrim(str(Period))
      Saldo:=if(&Debet!=0,"Дебет "+alltrim(str(&Debet)),"Кредит "+alltrim(str(&Kredit)))
      Fwrite(Desc,space(10)+"│"+center("Сальдо на "+Alltrim(Str(LastDayoM(Period)))+"."+if(Period<10,"0","")+alltrim(str(Period))+"."+alltrim(str(year(new_date)))+;
      " "+Saldo,54," ",.t.)+"│"+CrLf)
      Fwrite(Desc,space(10)+"└──────────────────────────────────────────────────────┘"+CrLf)
//      FWrite(Desc, Space(10)+'Директор УМП "Горэлектросеть"              В.М. Волков'+CrLf+CrLf)
      FWrite(Desc, Space(10)+SchetNameOrg+CrLf)
      FWrite(Desc, Space(10)+cNameBoss+'                                   '+AllTrim(NameBoss)+CrLf+CrLf)
      FWrite(Desc, Space(10)+cNameBuh+ "                                   "+AllTrim(NameBuh)+CrLf)
   ENDIF
   FClose(Desc)
   Select(Sel)
   Go Rec
   SetColor(Color)
   Win_Rest(Win)
   oProgress:destroy()                                                                                                                                                                                  // Progress Bar Destroy
   oDlg:Destroy()
EndIf
Return Nil



Function SVERKA4()
local itog1:=0,itog2:=0,itog3:=0,itog4:=0,itog5:=0,itog6:=0,TempLen:=0
Local OborotPenq:=0,OborotHigh:=0,OborotAbon:=0
private old_sel,old_col,old_scr,x,sum_rashod,power,first,x,nm1,ret,sixrub,;
beznds,reaktiv,sum_reak,o_ldsel,schet_dnold:=schet_dnal,desc,CrLf:=chr(13)+chr(10)
sum_reak=0
reaktiv=0
sixrub=.f.
ret=.t.
old_col=setcolor()
save screen to old_scr
old_sel=select()
month=month_menu()
if month=0
        return .f.
endif
mesqc=mesqc(month)
do case
   case month>0.and.month<13
        colorwin(11,19,15,65,'b/n')
        obrabot("Анализ показаний счетчиков")
******************************************************************************
* блок расчета дебет/кредит
mon_the=month
do outex with month
month=mon_the
******************************************************************************
        _lic_schet=main->lic_schet
        sum_rashod=0
        power=0
        first=.t.
        desc:=fcreate(M->Ddir+"otchet.gkv")
        select 77
        temp_=39/reccount()
        kol_kl=0
        go top
        seek main->lic_schet
        beznds=0
        do while lic_sch==main->lic_schet
           kol_kl=kol_kl+temp_
           colorwin(12,21,12,21+kol_kl,'n/n')
           if lic_sch#_lic_schet
              skip
           else
              select(month)
              poisk='('+alltrim(str(_lic_schet))+')'+alltrim(licevoj->schetchik)
              seek poisk
              if found().and..not.deleted().and.alltrim(MYupper(Licevoj->schetchik))!="АБОН.МОЩН"
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
                       if .not.licevoj->reaktivn
                          power=power+if(rashod-subab>0,rashod-subab,subab-rashod)
                       else
                          reaktiv=reaktiv+if(rashod-subab>0,rashod-subab,subab-rashod)
                          sum_reak=sum_reak+summa
                       endif
                    else
                       if .not.licevoj->reaktivn
                          power=power+rashod-subab
                       else
                          reaktiv=reaktiv+rashod-subab
                          sum_reak=sum_reak+summa
                       endif
                    endif
                 endif
                 if drug_nach#licevoj->reaktivn
                    IF reclock()
                       replace drug_nach with licevoj->reaktivn
                       unlock
                    ENDIF
                 endif
              endif
              select 77
              skip
           endif
        enddo
        nextmon1:=sum_rashod+beznds
        nextmon2:=round(sum_rashod*schet_nds/100,DECIMAL)
        IF month<4.and.year(new_date)=1995
           schet_dnal:=3.00
        ENDIF
        sum_rashod=sum_rashod+round(sum_rashod*schet_nds/100,2)+beznds+round(sum_rashod*schet_dnal/100,2)
        schet_dnal:=schet_dnold
         itog1=round(sum_rashod,Decimal)
         itog2=nextmon2
        select 15
// Сальдо на сегодняшнее число
        debet_pres='debet'+alltrim(str(month))
        kredit_pres='kredit'+alltrim(str(month))
len:=len('К оплате на след. месяц :')
        do case
           case &debet_pres>0.and.&kredit_pres=0
                itog3:=&debet_pres
           case &debet_pres=0.and.&kredit_pres>0
                itog4:=&kredit_pres
        endcase
// Сальдо на начало месяца
        debet_pres=if(month#1,'debet'+alltrim(str(month-1)),'last_debet')
        kredit_pres=if(month#1,'kredit'+alltrim(str(month-1)),'last_kred')
        do case
           case &debet_pres>0.and.&kredit_pres=0
                itog5:=&debet_pres
           case &debet_pres=0.and.&kredit_pres>0
                itog6:=&kredit_pres
        endcase
        colorwin(12,21,12,60,'n/n')
        ret=.t.
        select 77
        seek main->lic_schet
// Расчет оплаты за месяц
//select 44
month_='o'+alltrim(str(month))
//use &month_ SHARE
//load('44',SCHET_SHARE+month_+".dbf",,,.f.)
load('44',SCHET_SHARE+month_+".dbf",SCHET_SHARE+'o'+alltrim(str(month))+".Ntx",,.f.)
go top
sum=0
wozw_n=0
woz_wrat=0
do while .not.EOF()
   if licevoj=main->lic_schet
      if .not.deleted()
         if alltrim(vid_dokum)#'Пеня'.and.alltrim(vid_dokum)#'пеня'
            if alltrim(vid_dokum)="возврат".or.alltrim(vid_dokum)='Возврат'
               beznds=beznds+summa
               ***************************
               * Сумма возврата с начисления
//             woz_wrat=woz_wrat+summa
               ***************************
            else
               if alltrim(vid_dokum)="о возврат".or.alltrim(vid_dokum)='о Возврат'
                  sum=sum-summa
               else
                  if alltrim(vid_dokum)="н возврат".or.alltrim(vid_dokum)='н Возврат'
//                   wozw_n=wozw_n+summa
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
// Конец расчета
        select 77
        seek main->lic_schet
            FWRITE(DESC,CENTER("А К Т",76)+CRLF+crlf)
            fwrite(desc,'   сверки расчетов между организацией ОАO "НЭСК" перепродавец '+crlf)
            fwrite(desc,'   '+SchetNameOrg+' и потребителем электрической энергии '+CrLf+alltrim(main->potrebitel)+crlf+"   "+AllTrim(Main->SecondName)+crlf)
            fwrite(desc,"   адрес "+alltrim(main->adress)+" договор N"+alltrim(str(main->lic_schet))+" банк "+alltrim(licevoj->bank)+crlf)
            fwrite(desc,"   р/с "+alltrim(licevoj->r_schet)+"  к/с "+licevoj->k_schet+" БИК "+licevoj->mfo+crlf+crlf+crlf)
            fwrite(desc,"   г. Анапа                                                    "+;
                        if(month=month(new_date),dtoc(new_date),alltrim(str(lastdayom(month)))+"."+alltrim(str(month))+"."+alltrim(str(year(new_date))) )+crlf+crlf+crlf)

            fwrite(desc,'   Мы, нижеподписавшиеся '+cNameBuh+' '+SchetNameOrg+AllTrim(NameBuh)+crlf)
            fwrite(desc,'   отделения Энергосбыта ОАО "НЭСК" с одной стороны '+crlf)
            fwrite(desc,"   и _____________________________________ бухгалтер предприятия"+crlf)
            fwrite(desc,"   "+alltrim(main->potrebitel)+","+crlf)
            fwrite(desc,"   с другой стороны произвели сверку взаимных расчетов за потребленную эл."+crlf)
            fwrite(desc,"   энергию по состоянию на "+;
                        if(month=month(new_date),dtoc(new_date),alltrim(str(lastdayom(month)))+"."+alltrim(str(month))+"."+alltrim(str(year(new_date))) )+crlf)
            fwrite(desc,"   При чем оказалось следующее:"+crlf+crlf+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"          |     По данным АО НЭСК      |   По данным потребителя   |  Отклонения"+crlf)
            fwrite(desc,"          |        перепродавец        |"+center(delstring(alltrim(main->potrebitel),"ИНН"),27," ",.t.)+"|"+crlf)
            fwrite(desc,'          |                            |                           |            '+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"          |   Дебет     |    Кредит    |    Дебет    |    Кредит   |"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Сальдо на |                            |                           |"+crlf)
            fwrite(desc,"нач.месяца|"+if(itog5#0,str(itog5,14,2),"")+space(14)+if(itog6#0,str(itog6,14,2),"")+"|"+space(27)+"|"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Начислено |"+str(itog1,14,2)+"              |                           |"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Оплачено  |              "+str(sum,14,2)+"|                           |"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Сальдо на |                            |                           |"+crlf)
            OborotPenq:=GetPenq(Main->Lic_Schet,Month)
            OborotHigh:=GetHigh(Main->Lic_Schet,Month)
            OborotAbon:=GetAbonSaldo(Main->Lic_Schet,Month); OborotAbon:=IF(OborotAbon>0,OborotAbon,-1*OborotAbon)
            Itog3:=GetDolg(Main->Lic_Schet,Month)
            Itog4:=IF(Itog3>0,0,GetSaldo(Main->Lic_Schet,Month))
            IF Itog3>0
               IF (itog3+OborotPenq+OborotHigh+OborotAbon)>0
                  Itog3:=itog3+OborotPenq+OborotHigh+OborotAbon
               ELSE
                  Itog4:=-1*(itog3+OborotPenq+OborotHigh+OborotAbon)
                  Itog3:=0
               ENDIF
            ELSE
               IF Itog4!=0
                  IF (itog4-OborotPenq-OborotHigh-OborotAbon)>0
                     Itog4:=itog3-OborotPenq-OborotHigh-OborotAbon
                  ELSE
                     Itog3:=(itog3-OborotPenq-OborotHigh-OborotAbon)*-1
                     Itog4:=0
                  ENDIF
               ENDIF
            ENDIF
            fwrite(desc,""+center(if(month=month(new_date),dtoc(new_date),alltrim(str(lastdayom(month)))+"."+alltrim(str(month))+"."+;
            alltrim(str(year(new_date))) ),10," ",.t.)+"|"+if(itog3#0,str(itog3,14,2),"")+space(14)+;
            if(itog4#0,str(itog4,14,2),"")+"|                           |"+crlf)
            If OborotPenq!=0.or.OborotHigh!=0
               fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
               fwrite(desc,"   в том  |                            |                           |"+crlf)
               fwrite(desc,"   числе  |                            |                           |"+crlf)
            EndIf
            If OborotPenq!=0
               fwrite(desc,"% банка   |"+str(oborotpenq,14,2)+"              |                           |"+crlf)
            EndIf
            If OborotHigh!=0
               fwrite(desc,"Повышенная|"+str(oborothigh,14,2)+"              |                           |"+crlf)
            EndIf
            If OborotAbon!=0
               fwrite(desc,"Абонирован|"+str(OborotAbon,14,2)+"              |                           |"+crlf)
            EndIf
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf)
            fwrite(desc,"Итого     |                            |                           |"+crlf)
            fwrite(desc,"допровести|                            |                           |"+crlf)
            fwrite(desc,"---------------------------------------------------------------------------------"+crlf+crlf)
            fwrite(desc,"После проведения дополнительных записей бесспорное сальдо на сумму:"+crlf)
// Расчет суммы прописью
            mysumma=if(itog3#0,itog3,itog4)
            mpsum2=""
            sumprop=str_chislo(mysumma,65)
            sumprop=sumprop+space(65-len(sumprop))
            sumpro=mpsum2+space(65-len(mpsum2))
//---------------------------------------------------
            fwrite(desc,alltrim(MYupper(sumprop)))
            TempLen:=Len(SumProp)
            if !empty(sumpro)
               fwrite(desc,crlf+alltrim(MYupper(sumpro)))
               TempLen:=Len(SumProp)
            endif
               If OborotPenq!=0
                  mpsum2:=""
                  fwrite(desc,crlf+"В том числе % банка:"+MYupper(str_chislo(OborotPenq,65)))
                  TempLen:=Len(str_chislo(OborotPenq,65))+24
                  if !empty(mpsum2)
                     fwrite(desc,crlf+MYupper(mpsum2))
                     TempLen:=Len(MpSum2)
                  endif
               EndIf
               If OborotHigh!=0
                  mpsum2:=""
                  fwrite(desc,crlf+"В том числе повышенная "+MYupper(str_chislo(oborothigh,65)))
                  TempLen:=Len(str_chislo(OborotHigh,65))+24
                  if !empty(mpsum2)
                     fwrite(desc,crlf+MYupper(mpsum2))
                     TempLen:=Len(MpSum2)
                  endif
               EndIf
               If OborotAbon!=0
                  mpsum2:=""
                  fwrite(desc,crlf+"В том числе абонированная "+MYupper(str_chislo(oborotAbon,55)))
                  TempLen:=Len(str_chislo(OborotAbon,65))+24
                  if !empty(mpsum2)
                     fwrite(desc,crlf+MYupper(mpsum2))
                     TempLen:=Len(MpSum2)
                  endif
               EndIf
            fwrite(desc,IF(TempLen<56," ",CrLf)+'в пользу '+IF(Itog3+OborotPenq+OborotHigh+OborotAbon!=0,SchetNameOrg,Delstring(alltrim(main->potrebitel),"ИНН"))+crlf+crlf)
            fwrite(desc,MYupper(SchetNameOrg)+crlf)
            fwrite(desc,MYupper("задолженности по налогам и другим платежам в Федеральный бюджет не имеет")+crlf)
            fwrite(desc,"Подписи сторон:"+crlf)
            fwrite(desc,"Энергоснабжающей организации                         Потребителя электроэнергии"+crlf)
            fwrite(desc,cNameBoss+"                                            Руководитель"+crlf)
            fwrite(desc,SchetNameOrg+'       '+AllTrim(NameBoss)+CrLf+CrLf)
            fwrite(desc,cNameBuh+ "          "+AllTrim(NameBuh)+"              Бухгалтер"+crlf+crlf)
            fwrite(desc,"       М.П.                                          М.П."+crlf)
        fclose(desc)
endcase
if select()#old_sel
        select(old_sel)
endif
setcolor(old_col)
restore screen from old_scr
Return ret




FUNCTION Sverka7()
Local Sel:=select(),Rec:=Recno(),Win:=Win_Save(),Color:=Setcolor()
Local Position:=0,tDec:=0,Divide:=1000,Period2:=1,ShtrPenq:=0,ShtrHigh:=0
Private Period:=0,OplAll:=0,SumNach:=0,Shtr:=0,cStr1:="",cStr2:="",Shtr2:=0
Private InSaldo:=0,OutSaldo:=0,tRash:=0,sDate:="",cPeriod:="",InnStr:=""
Private OplTekMon:=0,ShtrOpl:=0,MonthName,SumShtr:=0,Potrebit:=""
Period2:=Month_Menu("Акт сверки с ???")
Period:=Month_Menu("Акт сверки с "+Mesqc(Period2,.t.)+" по ???")
sDate:="01."+IF(Period2<10,"0","")+AllTrim(Str(Period2))+"."+Alltrim(Str(Year(new_date)))
If Period>0.and.Period2>0
   IF Period!=Period2
      cPeriod:=Mesqc(Period2)+" - "+Mesqc(Period)
   ELSE
      cPeriod:=Mesqc(Period)
   ENDIF
   Win:=obrabot("Расчет акта сверки")
   MonthName:=Mesqc(Period)
   Potrebit:=DelString(Potrebitel,"ИНН")
   IF Period2==1
      select obormot
      seek main->lic_schet
      IF found()
         InSaldo:=(-1*Last_Debet)+Last_Kred+(SaldoP*-1)+(SaldoH*-1)
         SaldoShtr:=SaldoP+SaldoH
      ENDIF
      Select Main
   ELSE
      InSaldo:=GetSaldo(Main->Lic_Schet,Period2-1)+(-1*GetPenq(Main->Lic_Schet,Period2-1))+(-1*GetHigh(Main->Lic_Schet,Period2-1))
      SaldoShtr:=GetPenq(Main->Lic_Schet,Period2-1)+GetHigh(Main->Lic_Schet,Period2-1)
   ENDIF
   SaldoShtr:=Round(SaldoShtr/Divide,tDec)
   AStr:=""
   For i=Period2 to Period
       Position=Position+39/if(Period!=Period2,Period,1)
       ColorWin(12,21,12,21+Position,'n/n')
       tRash:=tRash+Round(GetRashod(Main->Lic_Schet,I)/Divide,tDec)
       SumNach:=SumNach+GetSum(Main->Lic_Schet,I)
       AStr:=AStr+Str(GetSum(Main->Lic_Schet,I))+" "
       OplAll:=OplAll+Round(CalckPay(I,Main->Lic_Schet,.f.,1)/Divide,tDec)
//       ShtrhOpl:=ShtrOpl+Round((CalckPay(I,Main->Lic_Schet,.f.,2)+CalckPay(I,Main->Lic_Schet,.f.,3))/Divide,tDec)
       ShtrPenq:=ShtrPenq+CalckPay(I,Main->Lic_Schet,.f.,2)
//       ShtrhOpl:=ShtrOpl+Round(CalckPay(I,Main->Lic_Schet,.f.,2)/Divide,tDec)
//       ShtrOpl:=ShtrOpl+Round(CalckPay(I,Main->Lic_Schet,.f.,3)/Divide,tDec)
       ShtrHigh:=ShtrHigh+CalckPay(I,Main->Lic_Schet,.f.,3)
       Select Obormot
       seek main->lic_schet
       IF FOUND()
          cStr1:="PenqN"+AllTrim(Str(I))
          cStr2:="HighN"+AllTrim(Str(I))
          Shtr:=Shtr+&cStr1+&cStr2
          Shtr2:=Shtr2+&cStr2
       ENDIF
       Select Main
   Next
   ShtrOpl:=Round((ShtrPenq+ShtrHigh)/Divide,tDec)
//   Al_Box({Str(ShtrOpl)})
//   SumNach:=SumNach*(100+Schet_Nds)/100;  SumNach:=Round(SumNach/Divide,tDec)
   SumNach:=Round(SumNach/Divide,tDec)
   Shtr:=Round(Shtr/Divide,tDec)
   Shtr2:=Round(Shtr2/Divide,tDec)
   OplTekMon:=Round(CalckPay(Period,Main->Lic_Schet,.f.,1)/Divide,tDec)
   OplAll:=OplAll+ShtrOpl
   SumShtr:=Round((-1*GetPenq(Main->Lic_Schet,Period)+GetHigh(Main->Lic_Schet,Period)*-1)/Divide,tDec)
//******   OutSaldo:=(Round(InSaldo/Divide,tDec)+(-1*SumNach)+(-1*Shtr))+OplAll
   OutSaldo:=round((GetSaldo(Main->Lic_Schet,Period)+(-1*GetPenq(Main->Lic_Schet,Period))+(-1*GetHigh(Main->Lic_Schet,Period)))/Divide,tDec)
   InSaldo:=if(InSaldo<0,"Дт "+alltrim(str(Round(-1*InSaldo/Divide,tDec))),"Кт "+alltrim(str(Round(InSaldo/Divide,tDec))))
//   OutSaldo:=Round(OutSaldo+SumShtr+GetSaldo(Main->Lic_Schet,Period)/1000,tDec)
   OutSaldo:=if(OutSaldo<0,"Дт "+alltrim(str(-1*OutSaldo)),"Кт "+alltrim(str(OutSaldo)))
   SumShtr:=-1*SumShtr
   InnStr:=appendstring(main->potrebitel,"ИНН")
   Select Licevoj
   Seek Main->Lic_Schet
   Select(Sel)
   Go Rec
   Report(DDir+"AktSv.rpt",DDir+ReportFile,125)
   SetColor(Color)
   Win_Rest(Win)
EndIf
Win_Rest(Win)
Return Nil



FUNCTION SvReestr()
Local Sel:=Select(),Rec:=Recno(),Scr:=Win_Save(),Clr:=SetColor(),Desc
Local CrLf:=Chr(13)+Chr(10),sMonth:=0,eMonth:=0,Kol_Kl:=0
LOCAL MO:={26,132,419,531,729,788},MOn:={},MVD:={27,78,153,951},MVDn:={}
LOCAL MOB:={74,124},MOBn:={},MZ:={29,182,508},MZn:={},FSB:={144,1237},FSBn:={}
LOCAL GNI:={1170},GNIn:={},FPS:={844,14,37,432,1103},FPSn:={}
LOCAL MF:={679},MFn:={},MU:={198,237},MUn:={},Wsego:=0
sMonth:=Month_Menu("начала формирования реестра")
IF sMonth<1.or.sMonth>12
   Return NIL
ENDIF
eMonth:=Month_Menu("окончания формирования реестра")
IF eMonth<1.or.eMonth>12
   Return NIL
ENDIF
Obrabot("Расчет реестра актов сверки бюджета")
SELECT MAIN
go top
DO WHILE !Eof()
   Found:=.F.
   cFound:=""
   For i=1 to Len(Mo)
       IF MO[i]==Lic_Schet
          cFound:="MOn"
          Found:=.T.
          EXIT
       ENDIF
   Next
   IF !Found
      For i=1 to Len(MVD)
          IF MO[i]==Lic_Schet
             cFound:="MVDn"
             Found:=.T.
             EXIT
          ENDIF
      Next
   ENDIF
   IF !Found
      For i=1 to Len(MOB)
          IF MO[i]==Lic_Schet
             cFound:="MOBn"
             Found:=.T.
             EXIT
          ENDIF
      Next
   ENDIF
   IF !Found
      For i=1 to Len(MZ)
          IF MO[i]==Lic_Schet
             cFound:="MZn"
             Found:=.T.
             EXIT
          ENDIF
      Next
   ENDIF
   IF !Found
      For i=1 to Len(FSB)
          IF MO[i]==Lic_Schet
             cFound:="FSBn"
             Found:=.T.
             EXIT
          ENDIF
      Next
   ENDIF
   IF !Found
      For i=1 to Len(GNI)
          IF MO[i]==Lic_Schet
             cFound:="GNIn"
             Found:=.T.
             EXIT
          ENDIF
      Next
   ENDIF
   IF !Found
      For i=1 to Len(FPS)
          IF MO[i]==Lic_Schet
             cFound:="FPSn"
             Found:=.T.
             EXIT
          ENDIF
      Next
   ENDIF
   IF !Found
      For i=1 to Len(MF)
          IF MO[i]==Lic_Schet
             cFound:="MFn"
             Found:=.T.
             EXIT
          ENDIF
      Next
   ENDIF
   IF !Found
      For i=1 to Len(MU)
          IF MO[i]==Lic_Schet
             cFound:="MUn"
             Found:=.T.
             EXIT
          ENDIF
      Next
   ENDIF
   IF Found
      AADD(&cFound,{0,0,0,0,0,0,0,0})
      Wsego++
   ENDIF
   Kol_Kl=Kol_Kl+39/RecCount()
   ColorWin(12,21,12,21+Kol_Kl,'n/n')
   Skip
ENDDO
Al_Box({" Всего "+Alltrim(Str(Wsego))})
Desc:=Fcreate(DDir+ReportFile)
FWrite(Desc,chr(15))
FWrite(Desc,"┌───────────────────┬───────────────────┬───────────────────────────────────────┬───────────────────────────────────────────────────────────┬───────────────────┬───────────────────┐"+CrLf)
FWrite(Desc,"│       N дог.      │   Задолженность   │    Фактчески отпущено за месяц        │            Фактически  оплачено за месяц                  │ Задолжен.на конец │Задолжен.на 1.01.99│"+CrLf)
FWrite(Desc,"│    Наименование   │     на начало     ├─────────┬─────────┬─────────┬─────────┼─────────┬─────────┬─────────┬─────────┬─────────┬─────────┤ отчетного периода │  с учетом оплат   │"+CrLf)
FWrite(Desc,"│    пердприятия    ├─────────┬─────────┤ в натур.│в стоим. │в т.ч.   │  в т.ч. │  всего  │ в т.ч.  │оплачено │ из них  │ оплач.  │ оплач.  ├─────────┬─────────┼─────────┬─────────┤"+CrLf)
FWrite(Desc,"│                   │  всего  │ в т.ч.  │ выражен.│выражен. │пени     │  штрафы │         │ платежи │в текущ. │ пени и  │ за пред │ в пред  │  Всего  │  в т.ч. │  всего  │ в т.ч.  │"+CrLf)
FWrite(Desc,"│                   │         │ пени и  │  кВт/ч  │         │текущего │ текущего│         │ текущего│пер.деньг│ штрафы  │ период  │ период  │         │  пени и │         │ пени и  │"+CrLf)
FWrite(Desc,"│                   │         │ штрафы  │         │         │периода  │ периода │         │ периода │векселями│         │         │ деньг.  │         │  штрафы │         │ штрафы  │"+CrLf)
FWrite(Desc,"├───────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤"+CrLf)
FWrite(Desc,"│                   │         │         │         │         │         │         │         │         │         │         │         │         │         │         │         │         │"+CrLf)
FWrite(Desc,"└───────────────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┘"+CrLf)
FWrite(Desc,Chr(18))
FClose(Desc)
SetColor(Clr)
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL
