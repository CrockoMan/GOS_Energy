// Расчет и формирование счета-фактуры
FUNCTION SchetFaktura(MyParam)
LOCAL old_col:=setcolor(),old_sel:=select(),old_scr:=win_save(),FRec
LOCAL recno:=recno(),month,debet_last,kredit_last,counter:=0,Make:=.T.
LOCAL tmpit:=0,tmnpnds:=0,mo_nth,lPoisk:=""
PRIVATE Plmontn,MpSum1:="",SumAbon:=0,RashAbon:=0,cSumma1:="",cSumma2:="",lPresDate:=0
PRIVATE TarAbon:=0,Post29nds:=0,TmpCalckItog:=0,SFString:=""
PRIVATE AktEn:=0,RashAkt:=0,WsegoItNds:=0,OCH_PL:="06",DOP_STR:=" ",post294:=0
Private Tarifs:={},TarFound:=.F.
schet_=main->lic_schet
SFString:=" Сч/ф "+AllTrim(Str(Main->Lic_Schet))+" от "+DTOC(new_date+1)
month:=month_menu("Месяц для расчета")
Plmonth:=mesqc(Month)           // Месяц в платежку
if month=0
   return .f.
endif
mo_nth=month
AktEn:=GetRashod(main->lic_Schet,Month); RashAkt:=AktEn
//potrstring=delstring(potrebitel,"ИНН")
IF AtNum("КПП",AllTrim(Potrebitel),1)=1
   POTRSTRING=delstring(Substr(potrebitel,15),"ИНН")
ELSE
   POTRSTRING=delstring(potrebitel,"ИНН")
ENDIF
KPPSTRING=Alltrim(Substr(appendstring(main->potrebitel,"КПП"),4,11))
innstring=appendstring(potrebitel,"ИНН")
//@ 1,0 say alltrim(substr(innstring,4,AtNum(" ",InnString,1,6)-4))
//Inkey(0)
//innstring=alltrim(substr(innstring,4,11))
innstring=alltrim(substr(innstring,4,AtNum(" ",InnString,1,6)-4))
Select 77
seek main->lic_schet
Do While Lic_Sch==main->lic_schet
   IF !Reaktivn
      lpoisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
      Select(Mo_nth)
      Seek lPoisk
      IF Found()
         IF Len(Tarifs)>0
            For I=1 To Len(Tarifs)
                IF Tarif#0
                   IF Tarifs[i][1]==Tarif
                      Tarifs[i][2]=Tarifs[i][2]+if(rashod-subab>0,rashod-subab,subab-rashod)
                      Tarifs[i][3]=Tarifs[i][3]+Summa
                      TarFound:=.T.
                   ENDIF
                ENDIF
            Next
            IF TarFound==.F.
               IF Tarif#0
                  AADD(Tarifs,{Tarif,Rashod,Summa})
               ENDIF
            ENDIF
            TarFound:=.F.
         ELSE
            IF Tarif#0
               AADD(Tarifs,{Tarif,Rashod,Summa})
            ENDIF
         ENDIF
      ENDIF
      Select Licevoj
   ENDIF
   Skip
ENDDO
IF Len(Tarifs)>1
   For I=1 To Len(Tarifs)
       Perem:="AktEn"+AllTrim(Str(I))
       &Perem:=Tarifs[i][2]
       Perem:="CenaA"+AllTrim(Str(I))
       &Perem:=Tarifs[i][1]
       Perem:="SumAktEn"+AllTrim(Str(I))
       &Perem:=Tarifs[i][3]
       Perem:="NdsAktEn"+AllTrim(Str(I))
       &Perem:=Round(Tarifs[i][3]*schet_nds/100,Decimal)
       Perem:="WsegoSNds"+AllTrim(Str(I))
       &Perem:=Tarifs[i][3]+Round(Tarifs[i][3]*schet_nds/100,Decimal)
   Next
ENDIF
//Inkey(0)
select 77
seek main->lic_schet
IF atnum("ЮГБАНК",MYupper(licevoj->bank))>0
   OCHPL:="05"
ELSE
   OCHPL:="06"
ENDIF
if found()
   select(old_sel)
   townstring=substr(appendstring(MYupper(licevoj->bank),MYupper("г.")),3)
   townstring=substr(townstring,1,1)+lower(substr(townstring,2))
   if atnum("АНАПА",MYupper(licevoj->bank))>0
      gruzpol:=alltrim(alltrim(potrstring)+" "+alltrim(main->adress))
      VidBankPlat:=""
   else
//      VidBankPlat:="Почтой"
      VidBankPlat:="      "
      gruzpol:=alltrim(alltrim(LICEVOJ->object1)+" "+alltrim(LICEVOJ->object2)+alltrim(main->adress))
   endif
   VidBankPlat:=Center(VidBankPlat,10," ",.t.)
else
   select(old_sel)
   townstring="."
   gruzpol:=alltrim(alltrim(potrstring)+" "+alltrim(main->adress))
endif
DO Case
   CASE atnum("РКЦ",MYupper(licevoj->bank))>0
       TmpStr2Plat:=AllTrim(AllTrim(Licevoj->Str2Plat)+" ИНН "+AllTrim(InnString)+" "+AllTrim(PotrString))
   OTHERWISE
       TmpStr2Plat:="ИНН "+AllTrim(InnString)+" "+AllTrim(PotrString)+" "+AllTrim(Licevoj->Str2Plat)
ENDCASE
// Al_Box({TmpStr2Plat})
//StrPlat1:=SubStr(TmpStr2Plat,1 ,LenBank)
//StrPlat2:=SubStr(TmpStr2Plat,LenBank+1,Len(TmpStr2Plat)-LenBank)

StrPlat1:=SubStr(TmpStr2Plat,1 ,47)
StrPlat2:=SubStr(TmpStr2Plat,47+1,Len(TmpStr2Plat)-47)

//@ 1,0 say StrPlat1
//@ 2,0 say StrPlat2
//inkey(0)
//----------------------------------------- Расчет потребленной энергии
// WSEGOITNDS - Сумма с НДС (расчитывается в форме RPT)
// NDSITEN    - Сумма НДС (расчитывается в форме RPT)
// AKTEN    - Активная энергия        REAEN    - Реактивная энергия
// SUMAKTEN - Сумма активной энергии  SUMREAEN - Сумма реактивной энергии
// NDSAKTEN - НДС активной энергии    NDSREAEN - НДС реактивной энергии
// DONSUM   - Сумма доначислений      DONNDS   - Расход доначислений
// WOZWSUM  - Сумма возврата          WOZWNDS  - НДС возврата
wsegoitnds:=0; ndsiten:=0               // Оконч. сумма
reaktiv=0; sum_reak=0                   // Реактивная
sum_rashod=0; power=0; beznds=0         // Расход эл.энергии
donsum:=0; donpow:=0; donnds:=0         // Доначисления
wozwsum:=0; wozwpow:=0; wozwnds:=0      // Возврат
CalcEnergy(month)
WsegOplach:=CalckPay(month)
select 15
seek main->lic_schet
if !found()
   append blank
   replace lic_schet with main->lic_schet
endif
TmpCalckItog:=BezNds+Sum_Rashod+round((Sum_Rashod)*schet_nds/100,DECIMAL)

debl=if(month>1,'debet'+alltrim(str(month-1)),'last_debet'); debl=&debl
krel=if(month>1,'kredit'+alltrim(str(month-1)),'last_kred'); krel=&krel
debp='debet'+alltrim(str(month)); debp:=&debp
krep='kredit'+alltrim(str(month)); krep:=&krep

sumakten:=sum_rashod+beznds-sum_reak; ndsakten:=round((sumakten-beznds)*schet_nds/100,DECIMAL)
reaen:=reaktiv; sumreaen:=sum_reak; ndsreaen:=round(sum_reak*schet_nds/100,DECIMAL)
wozwnds:=round(wozwsum*schet_nds/100,DECIMAL)
donnds:=round(donsum*schet_nds/100,DECIMAL)
//----------------------------------------- Подготовка файла счета-фактуры...
do outex with month //------------------------------ Перерасчет начислений...
select 77; seek main->lic_schet;   select 88 //поиск банковских реквизитов...
mesqc=mesqc(month)
plat_dat:=alltrim(str(day((new_date+1))))+"  "+mesqc(month(new_date+1),1)+;
          ' '+alltrim(str(year(new_date+1)))
// WSEGOPLACH:=if(WSEGOPLACH-DEBL>0,WSEGOPLACH-DEBL,0)
IF Debl==0.and.WsegoPlach<0
   WSEGOPLACH:=WSEGOPLACH-DEBL
ELSE
   WSEGOPLACH:=if(WSEGOPLACH-DEBL>0,WSEGOPLACH-DEBL,0)
ENDIF
// WSEGOPLACH:=WSEGOPLACH-DEBL
AbonSum:=GetAbonSum(Main->Lic_Schet,Month)
//----
WSEGOPLA :=WSEGOPLACH+KREL
NDSOPLACH:=round(WSEGOPLA*SCHET_NDS/(100+SCHET_NDS),DECIMAL)
SUMOPLACH:=WSEGOPLA-NDSOPLACH
WSEGOSNDS:=SUMAKTEN+NDSAKTEN
WSEGOSNDS:=SUMREAEN+NDSREAEN
WSEGODON :=DONNDS+DONSUM

IF atnum("РКЦ",MYupper(licevoj->bank))==0
//   @ 1,0 say DonSum
//   Inkey(0)
   PLANEN   :=AKTEN+REAEN-WOZWPOW
   SUMPLANEN:=(SUMAKTEN+SUMREAEN-WOZWSUM-AbonSum)*MyPlanKoeff
   NDSPLANEN:=(NDSAKTEN+NDSREAEN-WOZWNDS-round(AbonSum*SCHET_NDS/(100+SCHET_NDS),DECIMAL))*MyPlanKoeff
   WSEGOPLANNDS:=(SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN-WOZWSUM-WOZWNDS)*MyPlanKoeff
ELSE
   PLANEN   :=0
   SUMPLANEN:=0
   NDSPLANEN:=0
   WSEGOPLANNDS:=0
ENDIF
IF Schet_vplan==.F.
   PLANEN   :=0
   SUMPLANEN:=0
   NDSPLANEN:=0
   WSEGOPLANNDS:=0
ENDIF


ITEN:=AKTEN+REAEN+DONPOW; SUMITEN:=Round(SUMAKTEN+SUMREAEN+DONSUM,DECIMAL); NDSITEN:=round(NDSAKTEN+NDSREAEN+DONNDS,Decimal)
WSEGOITNDS:=ROUND(DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN,DECIMAL)
//=======================================
//=======================================
//=======================================
//POST294:=ROUND(WSEGOITNDS*0.5,DECIMAL)
POST294:=0
//AL_BOX({STR(POST294),str(WsegoItNds)})
//=======================================
//=======================================
//=======================================
ITEN:=AKTEN+REAEN+PLANEN+DONPOW; SUMITEN:=SUMAKTEN+SUMREAEN+SUMPLANEN+DONSUM-SUMOPLACH; NDSITEN:=NDSAKTEN+NDSREAEN+NDSPLANEN+DONNDS-NDSOPLACH
WSEGOITNDS:=round(DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN+WSEGOPLANNDS-WSEGOPLA,DECIMAL)
Sum2Plat:=WsegoItNds
Sum2Plat:=WsegoItNds+POST294
Post294NDS:=Round((Post294*Schet_NDS)/(100+SCHET_NDS),2)
//DOP_STR:="В том числе Пост.Прав. РФ N 294 от 04.04.2000г. "+AllTrim(Str(Round(Post294/1.2,Decimal)))+" НДС "+ALLTRIM(STR(POST294-Round(Post294/1.2,Decimal)))+" Всего "+ALLTRIM(STR(POST294))
// @ 1,0 say "DonSum"; ?? DonSum
// ? "DonNds"; ?? DonNds
// ? "SumAktEn"; ?? SumAktEn
// ? "NdsAktEn"; ?? NdsAktEn
// ? "SumReaEn"; ?? SumReaEn
// ? "NdsReaEn"; ?? NdsReaEn
// ? "WsegoPlanNds"; ?? WsegoPlanNds
// ? "WsegoPla";     ?? WsegoPla
// ? "WsegoPlach";     ?? WsegoPlach
// Inkey(0)

IF MyParam==1.and.WSEGOITNDS<1
   if al_box({"Полученная сумма для выставления: "+alltrim(str(WsegoItNds)),;
              "Приступить к формированию документа"},2)==2
              setcolor(old_col)
              win_rest(old_scr)
              select(old_sel)
              go recno
              prev_rec=-1
              return .f.
   endif
endif

IF MyParam==2
//   if al_box({"Полученная сумма для выставления: "+alltrim(str(Round(GetAbonSum(Main->Lic_Schet,Month)*(Schet_Nds+100)/100,Decimal))),;
   RashAkt:=GetRashod(Main->Lic_Schet,Month)
   WsegoAbon:=GetAbonSaldo(Main->Lic_Schet,Month); WsegoAbon:=IF(WsegoAbon<0,-1*WsegoAbon,0)
   WsegoAbon:=IF(WsegoAbon>0,GetAbonSum(Main->Lic_Schet,Month),0)
   WsegoAbon:=Round(IF(WsegoAbon>0,GetAbonSum(Main->Lic_Schet,Month),0)*(100+Schet_Nds)/100,Decimal)
   TarAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)/RashAbon,Decimal)
   NdsAbon:=Round(WsegoAbon*20/120,Decimal)
   SumAbon:=WsegoAbon-NdsAbon
   IF WsegoAbon>0.AND.Al_Box({"Полученная сумма для выставления: "+alltrim(str(WsegoAbon)),;
              "Приступить к формированию документа"},2)==2
              setcolor(old_col)
              win_rest(old_scr)
              select(old_sel)
              go recno
              prev_rec=-1
              return .f.
   ELSE
      IF WsegoAbon=0
         IF Al_Box({"Платежка не выставляется"},2,{" Выход "," Продолжить "})==1
            Return .F.
         ENDIF
      ENDIF
   endif
endif

//----------------------------------------------- Блок формирования докуметов
spisok:={" Платежный документ     ",;
         " Счет за наличный расчет     ",;
         " Счет за безналичный расчет  ",;
         " Накладная  ",;
         " Счет - фактура с абонированной   ",;
         " Счет-фактура льготная",;
         "──────────────────────────────────",;
         " Выход                       "}
ASize(is_choice,Len(Spisok))
AFill(Is_Choice,.t.);        Is_Choice[Len(Spisok)-1]:=.F.
TIPD=vert_menu(spisok,"Формировать",is_choice,12,31,1,'n/w,n/g,,,r/w',.F.)
IF TIPD=8.OR.TIPD=0
   setcolor(old_col)
   win_rest(old_scr)
   select(old_sel)
   go recno
   prev_rec=-1
   return .f.
ENDIF
IF Tipd==5
   report(Ddir+"SfOld.rpt",Ddir+ReportFile,250)
   setcolor(old_col)
   win_rest(old_scr)
   select(old_sel)
   unlock all
   go recno
   prev_rec=-1
   return .t.
ENDIF
//---------------
cSumma1=str_chislo(Sum2Plat,70)
cSumma1=cSumma1+space(70-len(cSumma1))
cSumma2=mpsum2 +space(70-len(mpsum2))
//---------------------------------------- Формирование платежного документа
IF MyParam==1
      Select Tobank
      IF FoundBank(Main->Lic_Schet,"Электроэнергия за "+PlMonth+" "+AllTrim(Str(Year(new_date+1))))
         IF ChoiceBox("Требование было выставлено ранее",{" Выход "," Продолжить "})==1
//         IF Al_Box({"Платежка уже была выставлена"},2,{" Выход "," Продолжить "})==1
            Make:=.f.
         ENDIF
      ENDIF
      IF make.and.FileLock(0)
         Append Blank
         MyRec:=RecNo()
         Go Bottom
         Schet_=Main->Lic_Schet
         Go Myrec
         Replace Plat_Treb With Schet_
         Replace Summa With WsegoItNds
         Replace Data With new_date+1
         Replace Lic_Schet With Main->Lic_Schet
         Replace Tip With "Электроэнергия за "+PlMonth+" "+AllTrim(Str(Year(new_date+1)))
        Unlock
      ENDIF
      Select(Old_Sel)
      IF Make
       	 IF Mo_Nth==12.and.Month(New_Date+1)==1
         		SFString:=" Сч/ф "+AllTrim(Str(Main->Lic_Schet))+" от "+"31.12."+AllTrim(Str(Year(New_Date+1)-1))
       	 ELSE
         		SFString:=" Сч/ф "+AllTrim(Str(Main->Lic_Schet))+" от "+DTOC(new_date+1)
         ENDIF
       IF TipD==1
         MakePlata(TipD)
/*               DO WHILE nButton <> XBPMB_RET_YES
         nButton := ConfirmBox( , ;
                       "Do you want to end the program?", ;
                       "Quit", ;
                        XBPMB_YESNO , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

                                 DO CASE
                                          CASE nButton==XBPMB_RET_YES
         ENDCASE
*/
//         TipD:=1+Al_Box({"Вид формируемой СЧЕТ - ФАКТУРЫ к платежному документу"},3,{" Наличный расчет "," Безналичный "," Отказ "},2)
         TipD:=1+ ChoiceBox("Вид формируемой счет-фактуры",{" Наличный расчет "," Безналичный "," Отказ "})
         IF TipD#4  // Отказ печати счетфактуры
//            MakePlata(TipD)
//            al_box("Готово!")

//            IF Al_Box({"Отпечатать СЧЕТ - ФАКТУРУ"},2)==1
               IF .NOT.Empty(AllTrim(PRFONTNAME))
					 			   lPresDate:=Al_BOX({"Дата для формирования документа"},2,{" Текущая "," Конец месяца "})
                   MainSf(Mo_Nth)
                   MainNakl(Mo_Nth)
               ELSE
                 Print_Fi(.t.)
               ENDIF
//               Copy_(DDir+ReportFile,"prn")
//            ENDIF
         ENDIF
         TipD:=1
       ELSE
         MakePlata(TipD)
         IF ChoiceBox("Отпечатать счет-фактуру",{" Да "," Нет "})==1
//         IF Al_Box({"Отпечатать СЧЕТ - ФАКТУРУ"},2)==1
            IF .NOT.Empty(AllTrim(PRFONTNAME))
					 			lPresDate:=Al_BOX({"Дата для формирования документа"},2,{" Текущая "," Конец месяца "})
                MainSf(Mo_Nth)
                MainNakl(Mo_Nth)
            ELSE
                Print_Fi(.t.)
            ENDIF
//               Copy_(DDir+ReportFile,"prn")
         ENDIF
       ENDIF
      ENDIF
//   DO While Al_Box({"Отпечатать платежный документ за электроэнергию"},2)==1
//      Copy_(Dir+ReportFile,"prn")
//   ENDDO
//   WsegoAbon:=GetAbonSum(Main->Lic_Schet,Month)
ELSE
      Select Tobank
      IF FoundBank(Main->Lic_Schet,"Абонированная за "+PlMonth+" "+AllTrim(Str(Year(new_date+1))))
         IF Al_Box({"Платежка уже была выставлена"},2,{" Выход "," Продолжить "})==1
            Make:=.F.
         ENDIF
      ENDIF
      RashAkt:=GetRashod(Main->Lic_Schet,Month)
//      WsegoAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)*(Schet_Nds+100)/100,Decimal)
//      WsegoAbon:=GetAbonSaldo(Main->Lic_Schet,Month)
      WsegoAbon:=GetAbonSaldo(Main->Lic_Schet,Month); WsegoAbon:=IF(WsegoAbon<0,-1*WsegoAbon,0)
      TarAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)/RashAbon,Decimal)
//      NdsAbon:=WsegoAbon-GetAbonSum(Main->Lic_Schet,Month)
      NdsAbon:=Round(WsegoAbon*20/120,Decimal)
      SumAbon:=WsegoAbon-NdsAbon
//      IF make.and.WsegoAbon!=0
      IF make
         cSumma1=str_chislo(WsegoAbon,70)
         cSumma1=cSumma1+space(70-len(cSumma1))
         cSumma2=mpsum2 +space(70-len(mpsum2))
         Select ToBank
         IF FileLock(0)
            Append Blank
            MyRec:=RecNo()
            Go Bottom
//            Schet_=Plat_Treb+1
            Schet_=Main->Lic_Schet
            Go Myrec
            Replace Plat_Treb With Schet_
            Replace Summa With WsegoAbon
            Replace Data With new_date+1
            Replace Lic_Schet With Main->Lic_Schet
            Replace Tip With "Абонированная за "+PlMonth+" "+AllTrim(Str(Year(new_date+1)))
           Unlock
         ENDIF
         Select(Old_Sel)
         IF TipD==1
            MakeAbonPl(TipD)
            Copy_(DDir+ReportFile,DDir+"Otchet_.tmp")
         ELSE
            DeleteFile(DDir+"Otchet_.tmp")
         ENDIF
         RashAkt:=GetRashod(Main->Lic_Schet,Month)
         WsegoAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)*(100+Schet_Nds)/100,Decimal)
         TarAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)/RashAbon,Decimal)
         NdsAbon:=Round(WsegoAbon*20/120,Decimal)
         SumAbon:=WsegoAbon-NdsAbon
         If TipD==1
            TipD:=1+Al_Box({"Вид формируемой СЧЕТ - ФАКТУРЫ для абонированной "},3,{" Наличный расчет "," Безналичный "," Отказ "},2)
            MakeAbonPl(TipD)
            TipD:=1
            IF Al_Box({"Отпечатать СЧЕТ - ФАКТУРУ"},2)==1
               Copy_(DDir+ReportFile,"prn")
            ENDIF
         ELSE
            MakeAbonPl(TipD)
         ENDIF
         IF File(DDir+"Otchet_.tmp")
            Copy_(DDir+"Otchet_.tmp",DDir+ReportFile)
         EndIf
      ENDIF
ENDIF
//--------------------------------------------------------------------------
setcolor(old_col)
win_rest(old_scr)
select(old_sel)
unlock all
go recno
prev_rec=-1
return .t.





//------- Поиск подстроки в строке и выделения от найденного места до конца
//------- Если подстрока не найдена и IS_SPACE=.T. возвращается один пробел
//------- если IS_SPACE=.F. возвращается нулевая строка
//------- Иначе возвращается подстрока, начиная от символа STRING2 и до конца
function appendstring(string1, string2, is_space)
local potr_inn,start_inn
is_space:=if(is_space==NIL,.T.,is_space)
Start_Inn:=Atnum(string2,string1)
Start_Inn:=If(Start_Inn==0,Len(string1),Start_Inn)
potr_inn:=substr(string1,start_inn)
potr_inn=if(empty(potr_inn).and.is_space," ",potr_inn)
return potr_inn


//------------------------- Функция расчета расхода электроэнергии
//------------------------- за конкретный месяц.
// Возвращаемое значение в переменные, объявленные выше как Private или Public
// reaktiv, sum_reak, sum_rashod, power, beznds, SumAbon:=0, RashAbon:=0
function CalcEnergy(month,is_bar)
Local Sel:=select(),Rec:=recno(),first:=.t.,old_sel,old_deb,old_kred,poisk
Local Screen,kol_kl,temp_
Is_Bar:=if(Is_Bar==NIL,.T.,Is_Bar)
select 77
go top
if Is_Bar
   Screen:=obrabot("Расчет расхода электроэнергии")
   temp_=39/reccount()
   kol_kl=0
ENDIF
seek main->lic_schet
do while lic_sch==main->lic_schet
 IF Is_Bar
    kol_kl=kol_kl+temp_
    colorwin(12,21,12,21+kol_kl,'n/n')
 ENDIF
 select(month)
 poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
 seek poisk
// if atnum("ДОНАЧ",upper(alltrim(licevoj->schetchik)))!=0.or.;
//    atnum("АКТ",upper(alltrim(licevoj->schetchik)))!=0
//    donsum:=donsum+summa                              // Доначисления сумма
//    donpow:=donpow+(rashod-subab)                     // доначисления расход
// else                                                  && Без доначислений!
  if atnum("ВОЗВРАТ",MYupper(alltrim(licevoj->schetchik)))!=0
     wozwsum:=wozwsum+summa                            // Возврат сумма
     wozwpow:=wozwpow+(rashod-subab)                  // Возврат расход
  endif
   if found().and..not.deleted()
       IF MYUpper(Licevoj->schetchik)=="АБОН.МОЩН"
          SumAbon:=SumAbon+Summa
          RashAbon:=RashAbon+rashod
       ELSE
//       ENDIF
        if summa>0
           if tarif=schet_tar1.or.tarif=schet_tar2.or.tarif=schet_tar3.or.;
              tarif=schet_tar4.or.tarif=schet_tar5.or.tarif=schet_tar6.or.;
              tarif=schet_tar7.and.tarif=schet_tar8.or.tarif=schet_tar9
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
           if reclock()
              replace drug_nach with licevoj->reaktivn
              unlock
           endif
        endif
       ENDIF // От Абонированной
  endif
// endif
 select 77
 skip
enddo
Select(sel); go Rec
IF Is_Bar
   win_rest(Screen)
ENDIF
return NIL



//------------------------- Функция расчета оплаты за конкретный месяц.
//------------------------- Возвращает сумму поступившей оплаты
Function CalckPay(month,Lic,IsBar,TypeOpl,cFoundStr)
Local Sel:=Select(),Rec:=RecNo(),Sum:=0,Wozw_N:=0,Woz_Wrat:=0,BezNds
Local Screen,Kol_Kl,Temp_,Month_,NameInd:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,cStr:=""
LIC:=IF(Lic==NIL,Main->Lic_Schet,Lic)
IsBar:=IF(IsBar==NIL,.T.,IsBar)
TypeOpl:=IF(TypeOpl==NIL,1,TypeOpl)
cFoundStr:=IF(cFoundStr==NIL,"",cFoundStr)
Do Case
   Case TypeOpl==1
        month_='o'+alltrim(str(month))
        NameInd:=Schet_Share+'o'+alltrim(str(month))+".ntx"
   Case TypeOpl==2
        month_='p'+alltrim(str(month))
        NameInd:=Schet_Share+'p'+alltrim(str(month))+".ntx"
   Case TypeOpl==3
        month_='h'+alltrim(str(month))
        NameInd:=Schet_Share+'h'+alltrim(str(month))+".ntx"
   Case TypeOpl==4
        month_='a'+alltrim(str(month))
        NameInd:=Schet_Share+'a'+alltrim(str(month))+".ntx"
EndCase
//NetUse(Month_,,0)
select 44
NetUse(Schet_Share+Month_+".dbf")
Set Index to &NameInd
//go top
Seek Lic
IF IsBar

		oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
		aSizeDesktop  := oMainWindow:currentSize()
		oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
		oDlg:title    := "Выбор оплат по потребителю" 
		oDlg:SysMenu	:= .F.
		oDlg:Configure()
		oDlg:Show()
		aSizeDesktop  := oDlg:currentSize()
		aPos					:= oDlg:CurrentPos()
		oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
		oProgress:create()
		oProgress:minimum := 1
		oProgress:maximum := RecCount()
ENDIF
do while Licevoj==LIC
   IF IsBar
   	  oProgress:increment()																				// Progress Bar Increment
   ENDIF
   IF Licevoj=Lic
      if .not.deleted()
         IF .NOT.Empty(cFoundStr).AND.AtNum(cFoundStr,Vid_Dokum)!=0
            if alltrim(vid_dokum)#'Пеня'.and.alltrim(vid_dokum)#'пеня'
               if alltrim(vid_dokum)="возврат".or.alltrim(vid_dokum)='Возврат'
                  sum=sum-summa
                  ***************************
                  * Сумма возврата с начисления
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="О ВОЗВРАТ"
                     sum=sum-summa
                  else
                     if MYupper(alltrim(vid_dokum))="Н ВОЗВРАТ"
                     else
                        sum=sum+summa
                        cStr:=cStr+AllTrim(Vid_dokum)+" "+AllTrim(Num_Dokum)+" "
                     endif
                  endif
               endif
            endif
         ELSEIF Empty(cFoundStr)
            if alltrim(vid_dokum)#'Пеня'.and.alltrim(vid_dokum)#'пеня'
               if alltrim(vid_dokum)="возврат".or.alltrim(vid_dokum)='Возврат'
                  sum=sum-summa
                  ***************************
                  * Сумма возврата с начисления
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="О ВОЗВРАТ"
                     sum=sum-summa
                  else
                     if MYupper(alltrim(vid_dokum))="Н ВОЗВРАТ"
                     else
                        sum=sum+summa
                        cStr:=cStr+AllTrim(Vid_dokum)+" "+AllTrim(Num_Dokum)+" "
                     endif
                  endif
               endif
            endif
         ENDIF
      endif
   endif
   skip
enddo
cNumPlat:=cStr
use
Select(sel); go Rec
IF IsBar
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
ENDIF
return sum




//------------------------- Функция расчета оплаты за конкретный месяц.
//------------------------- Возвращает сумму поступившей оплаты
Function GetPayData(Lic,month,nDate)
Local Sel:=Select(),Rec:=RecNo(),Sum:=0,Wozw_N:=0,Woz_Wrat:=0,BezNds
Local Screen,Kol_Kl,Temp_,Month_,NameInd:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,cStr:=""
LIC:=IF(Lic==NIL,Main->Lic_Schet,Lic)
IsBar:=IF(IsBar==NIL,.T.,IsBar)
TypeOpl:=IF(TypeOpl==NIL,1,TypeOpl)
cFoundStr:=IF(cFoundStr==NIL,"",cFoundStr)
Do Case
   Case TypeOpl==1
        month_='o'+alltrim(str(month))
        NameInd:=Schet_Share+'o'+alltrim(str(month))+".ntx"
   Case TypeOpl==2
        month_='p'+alltrim(str(month))
        NameInd:=Schet_Share+'p'+alltrim(str(month))+".ntx"
   Case TypeOpl==3
        month_='h'+alltrim(str(month))
        NameInd:=Schet_Share+'h'+alltrim(str(month))+".ntx"
   Case TypeOpl==4
        month_='a'+alltrim(str(month))
        NameInd:=Schet_Share+'a'+alltrim(str(month))+".ntx"
EndCase
//NetUse(Month_,,0)
select 44
NetUse(Schet_Share+Month_+".dbf")
Set Index to &NameInd
//go top
Seek Lic
do while Licevoj==LIC
   IF Licevoj=Lic
      if .not.deleted()
         IF .NOT.Empty(cFoundStr).AND.AtNum(cFoundStr,Vid_Dokum)!=0
            if alltrim(vid_dokum)#'Пеня'.and.alltrim(vid_dokum)#'пеня'
               if alltrim(vid_dokum)="возврат".or.alltrim(vid_dokum)='Возврат'
               	  IF Day(Data)<nDate
                  	 sum=sum-summa
                  ENDIF
                  ***************************
                  * Сумма возврата с начисления
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="О ВОЗВРАТ"
               	  	IF Day(Data)<nDate
                     		sum=sum-summa
                  	ENDIF
                  else
                     if MYupper(alltrim(vid_dokum))="Н ВОЗВРАТ"
                     else
               	  			IF Day(Data)<nDate
		                        sum=sum+summa
                        ENDIF
                     endif
                  endif
               endif
            endif
         ELSEIF Empty(cFoundStr)
            if alltrim(vid_dokum)#'Пеня'.and.alltrim(vid_dokum)#'пеня'
               if alltrim(vid_dokum)="возврат".or.alltrim(vid_dokum)='Возврат'
               	  IF Day(Data)<nDate
                  		sum=sum-summa
                  ENDIF
                  ***************************
                  * Сумма возврата с начисления
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="О ВОЗВРАТ"
               	  	IF Day(Data)<nDate
                     		sum=sum-summa
                    ENDIF
                  else
                     if MYupper(alltrim(vid_dokum))="Н ВОЗВРАТ"
                     else
               	  			IF Day(Data)<nDate
		                        sum=sum+summa
                        ENDIF
                     endif
                  endif
               endif
            endif
         ENDIF
      endif
   endif
   skip
enddo
use
Select(sel); go Rec
return sum







// -------------------------------------------------- Расчет номера счета...
function next_schet()
local old_col:=setcolor(),old_scr:=win_save()
set color to n/w,w/n
schet_=int(schet_+1)
colorwin(12,21,14,60,'n+/n')
@ 11,20,13,59 box "         "
colorwin(12,21,14,60,'n+/n')
@ 11,20 say "┌──────────────────────────────────────┐"
@ 12,20 say "│ Текущий порядковый номер счета       │"
@ 13,20 say "└──────────────────────────────────────┘"
set cursor on
set conf on
@ 12,52 get schet_ picture '999999'
read
set cursor off
set conf off
Clear Typeahead
if lastkey()=27
   setcolor(old_col)
   win_rest(old_scr)
   select(old_sel)
   go recno
   schet_=int(schet_-1)
   prev_rec=-1
   return .f.
endif
return schet_


//---------------------------------------------------------------------------
//---------- Подготовка платежки или счета в банк по потребителю ------------
//---------------------------------------------------------------------------
function makeplata(tip)
Local cStr:="",cPerem:="",PosPerem:=1
do case
   case tip==1  //---------------------------------------- Платежка...
        do case
           case main->tip_plat=0
                report(Ddir+"sft.rpt",Ddir+ReportFile,250)
           case main->tip_plat=1
                report(Ddir+"sft.rpt",Ddir+ReportFile,250)
           case main->tip_plat=2
                report(Ddir+"sftp.rpt",Ddir+ReportFile,250)
           case main->tip_plat=3
                report(Ddir+"sfinc.rpt",Ddir+ReportFile,250)
           case main->tip_plat=4
                report(Ddir+"sfto.rpt",Ddir+ReportFile,250)
                OCHPL:="06"
           case main->tip_plat=5
                report(Ddir+"sftpo.rpt",Ddir+ReportFile,250)
                OCHPL:="06"
           case main->tip_plat=6
                report(Ddir+"sftai.rpt",Ddir+ReportFile,250)
           case main->tip_plat=7
                report(Ddir+"sftpai.rpt",Ddir+ReportFile,250)
           case main->tip_plat=8
                report(Ddir+"sft.rpt",Ddir+ReportFile,250)
        endcase
        Clear Typeahead
        IF .NOT.Empty(AllTrim(PRFONTNAME))
           PlatTreWin()
        ENDIF
   case tip==2  //------------------------------------ Счет-фактура...
     do case
       case main->tip_plat>=0.and.main->tip_plat<=3.or.main->tip_plat==8
            typepay:="ЗА НАЛИЧНЫЙ РАСЧЕТ"
            report(Ddir+"sf.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=4.and.main->tip_plat<=5
            typepay:="ЗА НАЛИЧНЫЙ РАСЧЕТ"
            report(Ddir+"sfo.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=6.and.main->tip_plat<=7
            typepay:="ЗА НАЛИЧНЫЙ РАСЧЕТ"
            report(Ddir+"sfai.rpt",Ddir+ReportFile,250)
     endcase
  case tip==3
     do case
       case main->tip_plat>=0.and.main->tip_plat<=3.or.main->tip_plat==8
            typepay:="В БЕЗНАЛИЧНОМ ПОРЯДКЕ"
            report(Ddir+"sf.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=4.and.main->tip_plat<=5
            typepay:="В БЕЗНАЛИЧНОМ ПОРЯДКЕ"
            report(Ddir+"sfo.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=6.and.main->tip_plat<=7
            typepay:="В БЕЗНАЛИЧНОМ ПОРЯДКЕ"
            report(Ddir+"sfai.rpt",Ddir+ReportFile,250)
     endcase
  case tip==4
            report(Ddir+"sfn.rpt",Ddir+ReportFile,250)
  case tip==6
       cStr:=Alltrim(Licevoj->Razdel_1)+Alltrim(Licevoj->Razdel_2)
       For I=1 To Len(cStr) Step 19
           cPerem:="Kogo"+AllTrim(Str(PosPerem,1,0))
           PosPerem:=PosPerem+1
           &cPerem:=Substr(cStr,I,19)
       Next
            report(Ddir+"sfl.rpt",Ddir+ReportFile,250)
endcase
return NIL




FUNCTION MakeAbonPl(Tip)
do case
   case tip==1  //---------------------------------------- Платежка...
        do case
           case main->tip_plat=0
                report(Ddir+"sfta.rpt",Ddir+ReportFile,250)
           case main->tip_plat=1
                report(Ddir+"sfta.rpt",Ddir+ReportFile,250)
           case main->tip_plat=2
                report(Ddir+"sftpa.rpt",Ddir+ReportFile,250)
           case main->tip_plat=3
                report(Ddir+"sfinca.rpt",Ddir+ReportFile,250)
           case main->tip_plat=4
                report(Ddir+"sftoa.rpt",Ddir+ReportFile,250)
                OCHPL:="06"
           case main->tip_plat=5
                report(Ddir+"sftpoa.rpt",Ddir+ReportFile,250)
                OCHPL:="06"
        endcase
   case tip==2  //------------------------------------ Счет-фактура...
     do case
       case main->tip_plat>=0.and.main->tip_plat<=3
            typepay:="ЗА НАЛИЧНЫЙ РАСЧЕТ"
            report(Ddir+"sfa.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=4.and.main->tip_plat<=5
            typepay:="ЗА НАЛИЧНЫЙ РАСЧЕТ"
            report(Ddir+"sfao.rpt",Ddir+ReportFile,250)
     endcase
  case tip==3
     do case
       case main->tip_plat>=0.and.main->tip_plat<=3
            typepay:="В БЕЗНАЛИЧНОМ ПОРЯДКЕ"
            report(Ddir+"sfa.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=4.and.main->tip_plat<=5
            typepay:="В БЕЗНАЛИЧНОМ ПОРЯДКЕ"
            report(Ddir+"sfao.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=6.and.main->tip_plat<=7
            typepay:="В БЕЗНАЛИЧНОМ ПОРЯДКЕ"
            report(Ddir+"sfao.rpt",Ddir+ReportFile,250)
     endcase
endcase
return NIL




Function FoundBank(Lic,String)
Local Sel:=Select(),Rec:=Recno(),IsFound:=.F.
Select ToBank
Set Order To 2
Go Top
Seek Lic
IF Found()
   Do While .not.EOF()
      IF Alltrim(Substr(String,1,Len(Tip)))==AllTrim(Tip).and.LIC==Lic_Schet
//         Al_Box({Str(RecNo()),Alltrim(Substr(String,1,Len(Tip))),AllTrim(Tip)})
         IsFound:=.T.
         Exit
      ENDIF
      Skip
   EndDo
EndIf
Set Order To 1
Select(Sel); Go Rec
Return IsFound




Function FiftyDays(CalckType)
LOCAL Sel:=Select(),Rec:=RecNo(),Win:=Win_Save(),Clr:=SetColor()
Local Month,PrevMonth,Summa,MonthSaldo:=0
Private FiftySumma,cMonth:="",Nds,PlMonth,Plat_Dat,SfString:="",DOP_STR:=" "
ClackType:=IF(CalckType==NIL,1,CalckType)
plat_dat:=alltrim(str(day((new_date+1))))+"  "+mesqc(month(new_date+1),1)+;
          ' '+alltrim(str(year(new_date+1)))
month:=month_menu("Месяц для расчета")
//cMonth:=IF(Month>9,"","0")+AllTrim(Str(Month))
cMonth:=Mesqc(Month)
Plmonth:=mesqc(Month)
PrevMonth:=IF(Month>1,Month-1,12)
MonthSaldo=GetSaldo(Main->Lic_Schet,PrevMonth)
MonthSaldo=IF(MonthSaldo>0,MonthSaldo,0)
FiftySumma:=Round((GetSum(Main->Lic_Schet,PrevMonth)*FiftyDays),Decimal)
//FiftySumma:=FiftySumma+Round(FiftySumma*schet_nds/100,Decimal)
//Al_Box({Str(MonthSaldo),Str(FiftySumma)})
IF CalckType==1
    IF MonthSaldo<=FiftySumma
       FiftySumma:=MonthSaldo-FiftySumma
       FiftySumma=IF(FiftySumma>0,1,-1)*FiftySumma
    ELSE
       FiftySumma:=0
    ENDIF
ENDIF

SFString:=" Сч/ф "+AllTrim(Str(Main->Lic_Schet))+" от "+DTOC(new_date+1)
Nds:=Round((FiftySumma*Schet_Nds)/(100+Schet_Nds),Decimal)
cSumma1=str_chislo(FiftySumma,70)
cSumma1=cSumma1+space(70-len(cSumma1))
cSumma2=mpsum2 +space(70-len(mpsum2))
select 77   && Для заполнения реквизитов в платежке
seek main->lic_schet
//BankName:=Bank
POTRSTRING=delstring(main->potrebitel,"ИНН")
INNSTRING=appendstring(main->potrebitel,"ИНН")
INNSTRING=alltrim(substr(innstring,4,11))
TOWNSTRING=substr(appendstring(MYupper(licevoj->bank),MYupper("г.")),3)
TOWNSTRING=substr(townstring,1,1)+lower(substr(townstring,2))
IF atnum("ЮГБАНК",MYupper(licevoj->bank))>0
   OCHPL:="05"
ELSE
   OCHPL:="06"
ENDIF
IF atnum("АНАПА",MYupper(licevoj->bank))>0
   GRUZPOL:=alltrim(alltrim(potrstring)+" "+alltrim(licevoj->adres))
      VidBankPlat:=""
ELSE
//      VidBankPlat:="Почтой"
      VidBankPlat:="      "
   GRUZPOL:=alltrim(alltrim(LICEVOJ->object1)+" "+;
            alltrim(LICEVOJ->object2)+alltrim(licevoj->adres))
ENDIF
VidBankPlat:=Center(VidBankPlat,10," ",.t.)

DO Case
   CASE atnum("РКЦ",MYupper(licevoj->bank))>0
       TmpStr2Plat:=AllTrim(AllTrim(Licevoj->Str2Plat)+" ИНН "+AllTrim(InnString)+" "+AllTrim(PotrString))
   OTHERWISE
       TmpStr2Plat:="ИНН "+AllTrim(InnString)+" "+AllTrim(PotrString)+" "+AllTrim(Licevoj->Str2Plat)
ENDCASE
StrPlat1:=SubStr(TmpStr2Plat,1 ,47)
StrPlat2:=SubStr(TmpStr2Plat,47+1,Len(TmpStr2Plat)-47)

Select Main
IF FiftySumma>0
   IF ChoiceBox("Сумма к выставлению "+AllTrim(Str(FiftySumma))+" руб.",{" Продолжить ","Выход"})==1
      Select Tobank
      IF FileLock(0)
         Append Blank
         MyRec:=RecNo()
         Go Bottom
         Schet_=Plat_Treb+1
         Go Myrec
         Replace Plat_Treb With Schet_
         Replace Summa     With FiftySumma
         Replace Data      With new_date+1
         Replace Lic_Schet With Main->Lic_Schet
         Replace Tip       With "Плановый пл. за "+PlMonth
         Unlock
      ENDIF
      Select(Sel)
      IF .NOT.Empty(AllTrim(PRFONTNAME))
      		GenFiftyDays2(SCHET_)                                    // сделаем платежку для Windows
      ELSE
      		GenFiftyDays(SCHET_)                                    // сделаем платежку
      ENDIF
   ENDIF
ELSE
   	 ConfirmBox(oMainWindow," Выставлять нечего ","Внимание",XBPMB_OK,XBPMB_WARNING+XBPMB_APPMODAL)
ENDIF
Select(Sel)
Go Rec
Win_Rest(Win)
SetColor(Clr)
Return NIL




Function GenFiftyDays(Pos)
Schet_=Pos
Do Case
   Case main->tip_plat=0.or.main->tip_plat=1
        report(Ddir+"15treb.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=2
        report(Ddir+"15trp.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=3
        report(Ddir+"15inc.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=4
        report(Ddir+"15trocb.rpt",Ddir+'otchet.gkv',170)
        OCHPL:="06"
   Case main->tip_plat=5
        report(Ddir+"15trpocb.rpt",Ddir+'otchet.gkv',170)
        OCHPL:="06"
   Case main->tip_plat=6
        report(Ddir+"15trebai.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=7
        report(Ddir+"15trpai.rpt",Ddir+'otchet.gkv',170)
   Otherwise
        Al_Box({"Форма выставляемой платежки неизвестнa"})
EndCase
Return NIL
