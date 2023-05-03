proc outex(mon_the)
local schet_dnold:=schet_dnal,FoundAbon:=.F.,IsAbon:=.F.,RashAb:=0,ASaldo
Local PrevSel,PrevRec,FoundPost:=.F.,DolgPotr:=0,NameInd:=""
LOCAL APres,ALast,ASumma:=0,CalckLose,tmpLose,SmenaHour:=0
private oldsel,oldrec,oldind,month,MonthAbon
//Save Screen
//        i := 2
//        while ( !Empty(ProcName(i)) )
//                ? "Called from", Trim(ProcName(i)) + ;
//                        "(" + AllTRIM(Str(ProcLine(i))) + ")  "
//
//                i++
//        end
//Inkey(0)
//Restore Screen
IF Asc(Substr(Main->LockMonth,Mon_The,1))==Mon_The
   Al_Box({"Сальдо пересчитать нельзя","Месяц закрыт от расчетов"})
   Return
ELSE
//   Commit
   go recno()
ENDIF
IF Main->Kategory==chr(1).and.new_date>=Main->DatKat
   IsAbon:=.T.
ENDIF
oldsel=select()
oldrec=recno()
SELECT Main
IF empty(DatKat).and.Kategory==chr(1)
   IF RecLock(0)
      REPLACE DatKat WITH CTOD("01.05.97")
      UNLOCK
   ENDIF
ENDIF
SELECT(OldSel)
rashnds=0
beznds=0
woz_wrat=0
sum_rashod=0
power=0
month=0
Month:=If(mon_the==NIL,month_,mon_the)
IF Main->Lic_Schet>99999
   WriteChastnRash(Main->Lic_Schet,Month) // Расчет расхода частного сектора
ENDIF
MonthLose(Month)                          // Расчет потерь по расходу
MonthAbon:=Month
select 77
//go top
seek main->lic_schet
RashAb:=Round(IF((GetRashod(Main->Lic_Schet,Mon_the)-(MaxRashod*300))>0,GetRashod(Main->Lic_Schet,Mon_the)-(MaxRashod*300),0)/300,0)
do while lic_sch==main->lic_schet
   select(month)
   poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
   seek poisk
   IF found().and..not.deleted()
// Анализ категории счетчика. Если это промышленный, то считаем расход
// и, согласно постановления, превышение расчитывается по увеличенному тарифу
      IF Main->Kategory==chr(1).and.alltrim(MYupper(Licevoj->schetchik))=="АБОН.МОЩН".and.new_date>=Main->DatKat.and.new_date<CtoD("31.03.1999")
//      IF IsAbon
        FoundAbon:=.T.
//        IF summa==0
         IF Reclock(0)
//            Al_Box({"1)  "+Str(GetRashod(Main->Lic_Schet,Mon_the))})
            REPLACE Rashod WITH RashAb
            REPLACE Tarif WITH MaxRashSum
            REPLACE Summa WITH Round(Rashod*Tarif,Decimal)
//            REPLACE Rashod WITH IF((GetLimit(Mon_the)-MaxRashod)>0,GetLimit(Mon_the)-MaxRashod,0)
//            REPLACE Tarif WITH MaxRashSum
//            REPLACE Summa WITH Round(Rashod*Tarif,Decimal)
            UNLOCK
//         ENDIF
        ENDIF
      ENDIF
      if summa>0
         if .not.isnonds(tarif,Main->Lic_Schet)
            beznds=beznds+summa
         else
            sum_rashod=sum_rashod+summa
         endif
      else
         IF Main->Lic_Schet<99999
            sum_rashod=sum_rashod+summa
         ELSE
            if .not.isnonds(tarif,Main->lic_schet)
               beznds=beznds+summa
            else
               sum_rashod=sum_rashod+summa
            endif
         ENDIF
      endif
      if .not.empty(tarif)
         if .not.drug_nach.and.MYUpper(Num_Of_Sch)!="АБОН.М"
            power=power+rashod
         endif
      endif
   ELSE
//      IF IsAbon
      IF Main->Kategory==chr(1).and.alltrim(MYupper(Licevoj->schetchik))=="АБОН.МОЩН".and.new_date>=Main->DatKat.and.new_date<CtoD("31.03.1999")
         IF NetAppend(0)
            poisk='('+Alltrim(Str(Main->Lic_Schet))+')'+Alltrim(Licevoj->Schetchik)
            REPLACE Kod WITH Poisk
            REPLACE Num_Of_Sch WITH Licevoj->Schetchik
            REPLACE Licevoj WITH Main->Lic_Schet
//            REPLACE Rashod WITH IF( (GetLimit(Mon_the)-MaxRashod)>0,GetLimit(Mon_the)-MaxRashod,0)
            REPLACE Rashod WITH RashAb
            REPLACE Tarif WITH MaxRashSum
            REPLACE Summa WITH Round(Rashod*Tarif,Decimal)
            UNLOCK
            FoundAbon:=.T.
         ENDIF
//         SumKategory:=SumKategory+Summa
//         RashKategory:=RashKategory+Rashod
      ENDIF
      sum_rashod=sum_rashod+summa
   ENDIF
   SELECT Licevoj
   skip
enddo
// Счетчик с абонированной платой не найден. Добавляю его и расчитываю расход
// за текущий месяц.
//IF FoundAbon==.F..and.Main->Kategory==chr(1).and.alltrim(upper(Licevoj->schetchik))=="АБОН.МОЩН".and.new_date>=Main->DatKat.and.mon_the>=month(Main->DatKat)
IF FoundAbon==.F..and.Main->Kategory==chr(1).and.new_date>=Main->DatKat.and.new_date<CtoD("31.03.1999")
   SELECT Licevoj
   IF NetAppend(0)
      REPLACE Lic_Sch WITH Main->Lic_Schet
      REPLACE Delo WITH str(Main->Lic_Schet)
      REPLACE Potreb WITH Main->Potrebitel
      REPLACE Schetchik with "Абон.Мощн"
      UNLOCK
      SELECT(Month)
      IF NetAppend(0)
         poisk='('+Alltrim(Str(Main->Lic_Schet))+')'+Alltrim(Licevoj->Schetchik)
         REPLACE Kod WITH Poisk
         REPLACE Num_Of_Sch WITH Licevoj->Schetchik
         REPLACE Licevoj WITH Main->Lic_Schet
//         REPLACE Rashod WITH IF( (GetLimit(Mon_the)-MaxRashod)>0,GetLimit(Mon_the)-MaxRashod,0)
         REPLACE Rashod WITH RashAb
         REPLACE Tarif WITH MaxRashSum
         REPLACE Summa WITH Round(Rashod*Tarif,Decimal)
         UNLOCK
         sum_rashod=sum_rashod+summa
      ENDIF
   ENDIF
ENDIF
//================================================= Доначисление в связи
//================================================= со сменой тарифов
DolgPotr:=GetDolg(Main->Lic_Schet,2)
//@ 1,0 say DolgPotr
//Al_Box({Str(DolgPotr)})
IF Month==14.and.year(new_date)=2003.and.DolgPotr>0 //.and.Main->Lim_Tar1==0
//   @ 1,0 say DolgPotr
//   inkey(0)
//   Al_Box({"!!!"})
   DolgPotr:=Round(DolgPotr*100/(100+Schet_NDS),Decimal)
//@ 2,0 say DolgPotr
//Inkey(0)
   PrevSel:=Select()
   PrevRec:=RecNo()
   FoundPost:=.F.
   Select Licevoj
   Seek Main->Lic_Schet
   Do While lic_sch==main->lic_schet
      IF Alltrim(MYUpper(Schetchik))=="ПО СТ.393"
         FoundPost:=.T.
         Exit
      ENDIF
      SKIP
   EndDo
   IF !FoundPost
//      Al_Box({"1111"})
      SELECT Licevoj
      IF NetAppend(0)
         REPLACE Lic_Sch WITH Main->Lic_Schet
         REPLACE Delo WITH str(Main->Lic_Schet)
         REPLACE Potreb WITH Main->Potrebitel
         REPLACE Schetchik with "По ст.393"
         UNLOCK
         SELECT(Month)
         IF NetAppend(0)
            poisk='('+Alltrim(Str(Main->Lic_Schet))+')'+Alltrim(Licevoj->Schetchik)
            REPLACE Kod WITH Poisk
            REPLACE Num_Of_Sch WITH Licevoj->Schetchik
            REPLACE Licevoj WITH Main->Lic_Schet
//            REPLACE Summa WITH Round(0.47*Round((DolgPotr*100)/(100+Schet_Nds),Decimal),Decimal)

// 09.04.2002            REPLACE Summa WITH Round(0.0*(DolgPotr*100/(100+Schet_Nds)),Decimal)
            REPLACE Summa WITH Round(1.14*DolgPotr-DolgPotr,Decimal)
            Replace Tarif With 1.32
            UNLOCK
            sum_rashod=sum_rashod+summa
         ENDIF
      ENDIF
   ELSE
      SELECT(Month)
      poisk='('+Alltrim(Str(Main->Lic_Schet))+')'+Alltrim(Licevoj->Schetchik)
//      Al_Box({Poisk})
      SEEK Poisk
//      @ 1,0 say Found()
//      Inkey(0)
      IF Found()
        IF Tarif==0
//      @ 2,0 say "1111"
         IF RecLock()
//      @ 3,0 say "22222"
//            REPLACE Kod WITH Poisk
//            REPLACE Num_Of_Sch WITH Licevoj->Schetchik
//            REPLACE Licevoj WITH Main->Lic_Schet
            REPLACE Summa WITH Round(1.14*DolgPotr-DolgPotr,Decimal)
            Replace Tarif With 1.32
            sum_rashod=sum_rashod+summa
            UNLOCK
         ENDIF
        ENDIF
      ELSE
         IF NetAppend(0)
            poisk='('+Alltrim(Str(Main->Lic_Schet))+')'+Alltrim(Licevoj->Schetchik)
            REPLACE Kod WITH Poisk
            REPLACE Num_Of_Sch WITH Licevoj->Schetchik
            REPLACE Licevoj WITH Main->Lic_Schet
//            REPLACE Summa WITH Round(0.47*Round((DolgPotr*100)/(100+Schet_Nds),Decimal),Decimal)

// 09.04.2002            REPLACE Summa WITH Round(0.0*(DolgPotr*100/(100+Schet_Nds)),Decimal)
//            REPLACE Summa WITH Round(1.14*DolgPotr-DolgPotr,Decimal)
//            Replace Tarif With 1.32
            UNLOCK
            sum_rashod=sum_rashod+summa
         ENDIF
      ENDIF
   ENDIF
   Select(PrevSel)
   Go PrevRec
ENDIF
//================================================= Доначисление в связи
//================================================= со сменой тарифов



//------------------------- Вычитание из расхода суммы абонированной мощности
Sum_Rashod:=Sum_Rashod-GetAbonSum(Main->Lic_Schet,MonthAbon)
//---------------------------------------------------------------------------
/* select 88 */
select 15
seek main->lic_schet
if !found()
//        Myerror('Не нашел в оборотке лицевой счет N'+str(main->lic_schet))
        if netappend(0)
           replace lic_schet with main->lic_schet
           unlock
        endif
endif
*****************************************************************
*  Блок расчета Дебет/Кредит при выписке платежного поручения   *
*****************************************************************
select 44
month_='o'+alltrim(str(month))
NameInd:=schet_share+'o'+alltrim(str(month))+".Ntx"
if netuse(schet_share+month_+".dbf",,0)
	Set Index To &NameInd
	go top
	Seek Main->Lic_Schet
	sum=0
	wozw_n=0
	woz_wrat=0
	do while licevoj=main->lic_schet
//do while .not.EOF()
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
//                        wozw_n=wozw_n+summa
                  	else
	                  	IF Main->Lic_Schet<100000
                          	sum=sum+summa
                    	ELSE
//                    	 IF Data>CTOD("15.01.2008")
                          	sum=sum+summa
//                       ENDIF
                    	ENDIF
                  	endif
               	endif
            	endif
         	endif
      	endif
   	endif
   	skip
	enddo
  use
ELSE
	select(oldsel)
	go oldrec
	Return  
ENDIF
mont_h_='h'+alltrim(str(int(month)))
netuse(schet_share+mont_h_+".dbf",,0)
NameInd:=schet_share+'h'+alltrim(str(month))+".Ntx"
Set Index To &NameInd
hsum=0
do while .not.eof()
        if licevoj=main->lic_schet.and..not.Deleted()
           if alltrim(MYupper(vid_dokum))#MYupper("о возврат")
              hsum=hsum+summa
           else
              hsum=hsum-summa
           endif
        endif
        skip
enddo
use
mont_a_='a'+alltrim(str(int(month)))
netuse(schet_share+mont_a_+".dbf",,0)
NameInd:=schet_share+'a'+alltrim(str(month))+".Ntx"
Set Index To &NameInd
asumma=0
do while .not.eof()
        if licevoj=main->lic_schet.and..not.Deleted()
           if alltrim(MYupper(vid_dokum))#MYupper("о возврат")
              asumma=asumma+summa
           else
              asumma=asumma-summa
           endif
        endif
        skip
enddo
use
mont_h_='p'+alltrim(str(int(month)))
netuse(schet_share+mont_h_+".dbf",,0)
NameInd:=schet_share+'p'+alltrim(str(month))+".Ntx"
Set Index To &NameInd
psum=0
do while .not.eof()
        if licevoj=main->lic_schet.and..not.Deleted()
           if alltrim(MYupper(vid_dokum))#MYupper("о возврат")
              psum=psum+summa
           else
              psum=psum-summa
           endif
        endif
        skip
enddo
penq='penq'+alltrim(str(int(month)))
high='high'+alltrim(str(int(month)))
use
select 15
if reclock(20)
//   replace obormot->&penq with psum
//   replace obormot->&high with hsum
   replace &penq with psum
   replace &high with hsum
   Unlock
else
     al_box({"Пеня и повышенная не переписана","Блокировка неудачна (Outex)"})
endif
SaldoPH(Month)
******************************************************************
*nalog3=0
IF Main->Lic_Schet<=99999
	 nds_=round(sum_rashod*schet_nds/100,DECIMAL)
ELSE
	 nds_=0
ENDIF	 
//nds_=round(sum_rashod*schet_nds/100,DECIMAL)
IF month<4.and.year(new_date)=1995
        schet_dnal:=3.00
ENDIF
nalog3=round(sum_rashod*schet_dnal/100,DECIMAL)
schet_dnal:=schet_dnold
rashnds=round(sum_rashod-woz_wrat-wozw_n+nds_+nalog3,DECIMAL)
******************************************************************
debet_pres='debet'+alltrim(str(month))
kredit_pres='kredit'+alltrim(str(month))
debet_last=if(month>1,'debet'+alltrim(str(month-1)),'last_debet')
kredit_last=if(month>1,'kredit'+alltrim(str(month-1)),'last_kred')
debet=&debet_pres
kredit=&kredit_pres

// @ 1,0 say "Оплата"; ?? Sum
// @ 2,0 say "Кредиторская"; ?? &Kredit_Last
// @ 3,0 say "Дебеторская"; ??  &Debet_Last
// @ 4,0 say "Расход"; ?? rashnds+beznds
if reclock()
   ALast:="SaldoA"+IF(Month>1,AllTrim(Str(Month-1)),"")
   APres:="SaldoA"+AllTrim(Str(Month))
   Replace &APres With (&ALast+ASumma-(GetAbonSum(Main->Lic_Schet,Month)*(Schet_Nds+100)/100))
   if &debet_last=0.and.&kredit_last#0
        do case
                case &kredit_last+sum-(rashnds+beznds)>0
                        replace &kredit_pres with &kredit_last+sum-(rashnds+beznds)
                        replace &debet_pres with 0
                case &kredit_last+sum-(rashnds+beznds)<0
                        replace &debet_pres with (rashnds+beznds)-(&kredit_last+sum)
                        replace &kredit_pres with 0
                case &kredit_last+sum-(rashnds+beznds)=0
                        replace &debet_pres with 0
                        replace &kredit_pres with 0
        endcase

   endif
   if &kredit_last=0.and.&debet_last#0
        do case
                case &debet_last+(rashnds+beznds)-sum>0
                        replace &debet_pres with (&debet_last+(rashnds+beznds)-sum)
                        replace &kredit_pres with 0
                case &debet_last+(rashnds+beznds)-sum<0
                        replace &kredit_pres with sum-(&debet_last+(rashnds+beznds))
                        replace &debet_pres with 0
                case &debet_last+(rashnds+beznds)-sum=0
                        replace &kredit_pres with 0
                        replace &debet_pres with 0
        endcase
   endif
   if &kredit_last=0.and.&debet_last=0
        if rashnds+beznds-sum>0
                replace &debet_pres with rashnds+beznds-sum
                replace &kredit_pres with 0
        else
                replace &kredit_pres with sum-(rashnds+beznds)
                replace &debet_pres with 0
        endif
   endif
   unlock
else
   al_box({"Сальдо не переписано","Блокировка неудачна "},1,{"Функция OutEx"})
endif
// @ 5,0 say "Сальдо"; ?? IF(&Kredit_Pres>0,&Kredit_Pres,-1*&Debet_Pres)
// Inkey(0)
if &kredit_last#0.and.&debet_last#0
   al_box({str(main->lic_schet)+" Присутствует дебет и кредит. Исправьте данные !"})
endif
*********************************************** Конец блока
select(oldsel)
go oldrec
return





Function SaldoPH(rMonth)
Local Summa:=0,Sel:=Select(),Rec:=RecNo(),sPenq:=0,sHigh:=0
rMonth:=If(rMonth==NIL,Month(new_date),rMonth)
IF Asc(Substr(Main->LockMonth,rMonth,1))==rMonth
   Al_Box({"Сальдо пересчитать нельзя","Месяц закрыт от расчетов"})
   Return NIL
ENDIF
Select PH
Seek Main->Lic_Schet
IF Found()
   Do While Licevoj==Main->Lic_Schet
      IF Month==rMonth
         sPenq:=sPenq+PenqN
         sHigh:=sHigh+HighN
      ENDIF
      Skip
   EndDo
EndIf
Select Obormot
Seek Main->Lic_Schet
IF Found()
   IF RecLock()
      Str:="PenqN"+alltrim(str(int(rMonth)))
      Replace &Str With sPenq
      Str:="HighN"+alltrim(str(int(rMonth)))
      Replace &Str With sHigh
      Unlock
   ENDIF
ENDIF
Select(Sel)
Go Rec
Return NIL





Function MonthLose(Month,Blank)
Local Sel:=Select(),Rec:=RecNo(),RashAkt:=0,RashReak:=0,TarReak:=0,nRl:=0,nTR:=0,nLose:=0
LOCAL CalckLose:=0,tmpLose:=0,SmenaHour:=0,CalckTempLose:=0,FoundLose:=.F.
Local NameLose:="",tmpTarif:=0,Desc,CrLf:=Chr(13)+Chr(10),ReakTarif:=0
Local MyScr,Kol_Kl:=0,CountSch:=0,CalkTrLose:=0,MyTo:="To"
Local NameRLose:="",FoundRLose:=.F.,Poisk,Kz
Blank:=IF(Blank==NIL,.F.,Blank)
IF Blank==.F.
   IF Asc(Substr(Main->LockMonth,Month,1))==Month
//      Al_Box({"Сальдо пересчитать нельзя","Месяц закрыт от расчетов"})
      Return Nil
   ELSE
      go recno()
   ENDIF
ELSE
   IF Month==NIL
      Month:=Month_Menu("расчета потерь")
      IF Month==0
         Al_Box({"Не выбран месяц"})
         Return NIL
      EndIf
   ENDIF
   Desc:=FCreate(DDir+ReportFile)
   FWrite(Desc,AllTrim(Main->Potrebitel)+",  расчет потерь за "+Mesqc(Month)+CrLf)
   MyScr:=Obrabot("Расчет потерь за месяц "+Mesqc(Month))
ENDIF



//*************************************************потери реактивной энергии
IF Main->IsReak==.T..and.Year(new_date)==2001
   Select Licevoj
   Seek Main->Lic_Schet
   RashAkt:=0
   Do While Lic_Sch==Main->Lic_Schet
      IF .not.Reaktivn.and.alltrim(MYupper(Licevoj->schetchik))!="АБОН.МОЩН"
         Poisk:="("+AllTrim(Str(Main->Lic_Schet))+")"+AllTrim(Schetchik)
         Select(Month)
         Seek Poisk
         IF Found()
            IF IF(Rashod-Subab>0,Rashod-Subab,SubAb-Rashod)>25000
               RashAkt=RashAkt+IF(Rashod-Subab>0,Rashod-Subab,SubAb-Rashod)
            ENDIF
         ENDIF
         Select Licevoj
      ENDIF
      Skip
   ENDDO
//   RashAkt:=GetRashod(main->lic_schet,Month)
   //@ 1,0 say RashAkt
   RashReak:=Round(RashAkt*0.8,0)
   //@ 2,0 Say RashReak
   Select 77
   Seek Main->Lic_Schet
   DO while lic_sch==main->lic_schet
      IF lower(Alltrim(Schetchik))=='потери р.'
         IF !Deleted()
            NameRLose=licevoj->schetchik
            FoundRLose:=.T.
         EndIf
      EndIf
      Skip
   ENDDO
   IF FoundRLose==.F.
      Select 77
      IF NetAppend()
         Replace Schetchik With "потери р."
         Replace Reaktivn With .T.
         Replace Delo With Str(Main->Lic_Schet)
         Replace Lic_Sch With Main->Lic_Schet
         Replace Potreb With Main->Potrebitel
         UnLock
      ENDIF
      select(IF(month==1,13,Month-1))
      poisk='('+alltrim(str(main->lic_schet))+')потери р.'
      Seek Poisk
      IF Found()
         TarReak:=Tarif
      ELSE
         TarReak:=0.1488
      ENDIF
      Select(Month)
      If NetAppend()
         Replace Kod        With Poisk
         Replace Licevoj    With Main->Lic_Schet
         Replace Num_Of_Sch With "потери р."
         Replace Rashod With RashReak
//         Replace Tarif With GetVal("Введите тариф для расчета потерь (реактивная) л/c "+AllTrim(Str(Main->Lic_Schet)),Tarif,Tarif)
         Replace Tarif With TarReak
         Replace Summa With Round(RashReak*Tarif,Decimal)
         UnLock
      EndIf
   ELSE
      Select 77
      Seek Main->Lic_Schet
      DO while Lic_Sch==main->lic_schet
         IF Lower(Alltrim(Schetchik))=='потери р.'
            Select(IF(Month==1,13,Month-1))
            poisk='('+alltrim(str(main->lic_schet))+')потери р.'
            Seek Poisk
            IF Found()
              TarReak:=Tarif
              IF TarReak==0
                 TarReak:=0.1488
              ELSE
                 TarReak:=Tarif
              ENDIF
            ENDIF
            Select 77
         EndIf
         Skip
      ENDDO
      select(month)
      poisk='('+alltrim(str(main->lic_schet))+')потери р.'
      seek Poisk
      IF Found()
         IF Reclock()
            Replace Tarif With TarReak
            Replace Rashod With RashReak
            Replace Summa With Round(RashReak*TarReak,Decimal)
            UnLock
         ENDIF
      ELSE
         If NetAppend()
            Replace Kod        With Poisk
            Replace Licevoj    With Main->Lic_Schet
            Replace Num_Of_Sch With "потери р."
            Replace Rashod With RashReak
            Replace Tarif With TarReak
            Replace Summa With Round(RashReak*TarReak,Decimal)
            UnLock
         EndIf
      ENDIF
   ENDIF
ENDIF



//************************************************* потери активной энергии
IF Blank==.T.
   select 77
   seek main->lic_schet
   DO while lic_sch==main->lic_schet
      select(month)
      poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
      seek poisk
      IF found().and..not.deleted()
         CountSch++
      EndIf
      Select 77
      Skip
   EndDO
   CountSch=39/CountSch
EndIF
select 77
seek main->lic_schet
do while lic_sch==main->lic_schet
   IF Blank==.T.
      kol_kl=kol_kl+CountSch
      colorwin(12,21,12,21+kol_kl,'n/n')
   EndIf
   IF lower(Alltrim(Schetchik))=='потери'
      IF !Deleted()
         NameLose=licevoj->schetchik
         FoundLose:=.T.
      EndIf
   EndIf
   select(month)
   poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
   seek poisk
   IF .not.Found()
      IF NetAppend()
         Replace KOD With Poisk
         Replace Licevoj With Main->Lic_Schet
         Replace Num_Of_Sch With licevoj->schetchik
         UNLOCK
      ENDIF
   ENDIF
      IF Rashod#0
         tmpLose:=Rashod
         Select LoseTran
         Seek Poisk
         IF Found()
			      IF Blank
            	 FWrite(Desc,"Показания счетчика N "+licevoj->schetchik+"      "+AllTrim(Str(tmpLose))+CrLf)
            	 FWrite(Desc,"Потери холостого хода               "+AllTrim(Str(Pxx))+CrLf)
            	 FWrite(Desc,"Время работы тр-ра под нагрузкой    "+AllTrim(Str(&MyTo))+CrLf)
            	 FWrite(Desc,"Потери мощности КЗ                  "+AllTrim(Str(Pkz))+CrLf)
            	 FWrite(Desc,"Время работы за учетный период      "+AllTrim(Str(Tp))+CrLf)
            ENDIF
         		DO CASE
         			 CASE SNOMT#0
         			 		IF BLANK
               			 FWrite(Desc,"Мощность                            "+AllTrim(Str(Snomt))+CrLf)
            			ENDIF
            			CalckTrLose=Pxx*&MyTo+Pkz*((tmpLose/Tp)/Snomt*(tmpLose/Tp)/Snomt)*Tp
            			CalckTempLose:=CalckTempLose+CalckTrLose
            			IF Blank
               			FWrite(Desc,AllTrim(Str(Pxx))+"*"+AllTrim(Str(&MyTo))+"+"+AllTrim(Str(Pkz))+"*(("+;
                           AllTrim(Str(tmpLose))+"/"+AllTrim(Str(Tp))+")/"+AllTrim(Str(Snomt))+;
                           ")^2*"+AllTrim(Str(Tp))+"* = "+Alltrim(Str(CalckTrLose))+CrLf+CrLf)
            			ENDIF
         			 CASE KGR#0
         			 		IF BLANK
               			 FWrite(Desc,"Коэффициент мощности                "+AllTrim(Str(KMoshn))+CrLf)
               			 FWrite(Desc,"Коэффициент формы графика           "+AllTrim(Str(KGR))+CrLf)
            			ENDIF
            			KZ=TmpLose/( (TmpLose/Tp) *  TP*KMoshn )
            			
            			CalckTrLose=Pxx*&MyTo+Pkz*KZ*KZ*KGR*KGR*Tp
            			
//            			CalckTrLose=Pxx*&MyTo+Pkz*((tmpLose/Tp)/Snomt*(tmpLose/Tp)/Snomt)*Tp
            			CalckTempLose:=CalckTempLose+CalckTrLose
            			IF Blank
               			FWrite(Desc,AllTrim(Str(Pxx))+"*"+AllTrim(Str(&MyTo))+"+"+AllTrim(Str(Pkz))+"*("+;
                           AllTrim(Str(KZ))+"^2*"+AllTrim(Str(KGR))+"^2*"+AllTrim(Str(Tp))+;
                           " = "+Alltrim(Str(CalckTrLose))+CrLf+CrLf)
            			ENDIF
            ENDCASE
         ENDIF
         Select Lose
         Seek poisk
         IF Found()
         	  DO CASE
         	     CASE LENGTH#0
            			IF Blank
               				FWrite(Desc,"Показания счетчика N "+licevoj->schetchik+"      "+AllTrim(Str(tmpLose))+CrLf)
               				FWrite(Desc,"Длина провода                       "+AllTrim(Str(Length))+CrLf)
               				FWrite(Desc,"Площадь сечения провода             "+AllTrim(Str(Square))+CrLf)
               				FWrite(Desc,"Удельное сопротивление провода      "+AllTrim(Str(Po))+CrLf)
               				FWrite(Desc,"Количество дней работы              "+AllTrim(Str(Days))+CrLf)
               				FWrite(Desc,"Количество часов работы             "+AllTrim(Str(Hours))+CrLf)
               				FWrite(Desc,"Расчетный коеффициент               "+AllTrim(Str(Koeff))+CrLf)
               				FWrite(Desc,Center(AllTrim(Str(tmpLose))+"*"+AllTrim(Str(tmpLose))+"*"+AllTrim(Str(Po))+"*"+AllTrim(Str(Length)),25,.t.)+CrLf)
            			EndIf
            			tmpLose:=((tmpLose*tmpLose*Po*Length)/(Square*Days*Hours))*Koeff
            			IF Blank
               				FWrite(Desc,"-------------------------"+"*"+AllTrim(Str(Koeff))+" ="+AllTrim(Str(tmpLose))+CrLf)
               				FWrite(Desc,Center(AllTrim(Str(Square))+"*"+AllTrim(Str(Days))+"*"+AllTrim(Str(Hours)),25,.t.)+CrLf+CrLf)
            			ENDIF
            			
         	     CASE LENGTH2#0
               		nRl:=(PO*Length2)/Square
               		nTR:=Round(Days*Hours,0)
            			IF Blank
               				FWrite(Desc,"Расход по счетчику N "+licevoj->schetchik+"      "+AllTrim(Str(tmpLose))+CrLf)
               				FWrite(Desc,"Удельное сопротивление проводника   "+AllTrim(Str(PO))+CrLf)
               				FWrite(Desc,"Длина провода                       "+AllTrim(Str(Length2))+CrLf)
               				FWrite(Desc,"Количество дней работы              "+AllTrim(Str(Days))+CrLf)
               				FWrite(Desc,"Количество часов работы             "+AllTrim(Str(Hours))+CrLf)
               				FWrite(Desc,"Площадь сечения провода             "+AllTrim(Str(Square))+CrLf)
               				FWrite(Desc,"Коэффициент формы графика           "+AllTrim(Str(KGR))+CrLf)
               				FWrite(Desc,"Коэффициент мощности                "+AllTrim(Str(KMOSHN))+CrLf)
               				FWrite(Desc,"Уровень напряжения                  "+AllTrim(Str(UNapr))+CrLf)
               				FWrite(Desc,"Количество фаз ввода                "+AllTrim(Str(NPHASE))+CrLf)
               				FWrite(Desc,"----------------------------------------------------------"+CrLf)
               				FWrite(Desc,"Расчетное количство часов работы    "+AllTrim(Str(nTR,5,0))+CrLf)
               				FWrite(Desc,"Расчетное сопротивление линии P*L/S "+AllTrim(Str(nRl, 5,3))+CrLf)
            			ENDIF
            			DO CASE
            					CASE nPhase==1
            							 IF UNapr#0
            							 		nLose=(TmpLose*TmpLose*2*nRl*KGR*KGR*0.001) / (UNapr*UNapr*nTR*KMOSHN*KMOSHN)
            							 ELSE
            							 		nLose=(TmpLose*TmpLose*2*nRl*KGR*KGR*0.001) / (0.22*0.22*nTR*KMOSHN*KMOSHN)
            							 ENDIF
            					CASE nPhase==3
            							 IF UNapr#0
            							 		nLose=(TmpLose*TmpLose*nRl*KGR*KGR*0.001) / (UNapr*UNapr*nTR*KMOSHN*KMOSHN)
            							 ELSE
            							 		nLose=(TmpLose*TmpLose*nRl*KGR*KGR*0.001) / (UNapr*UNapr*nTR*KMOSHN*KMOSHN)
            							 ENDIF
            					OTHERWISE
            					     nLose=0
            							 IF Blank
            					     		FWrite(Desc,"Неверное значение количества фаз ввода"+CrLf)
            					     ENDIF
            			ENDCASE
            			IF Blank
            					DO CASE
		            					CASE nPhase==1
		            							FWrite(Desc,AllTrim(Str(TmpLose))+"^2*2*"+AllTrim(Str(nRl))+"*"+AllTrim(Str(KGR))+"^2*0.001"+CrLf)
		            							FWrite(Desc,"------------------------------------------ = "+AllTrim(Str(nLose))+CrLf)
		            							FWrite(Desc,"0.22^2*"+AllTrim(Str(nTR))+"*"+AllTrim(Str(KMOSHN))+"^2"+CrLf)
            							CASE nPhase==3
		            							FWrite(Desc,AllTrim(Str(TmpLose))+"^2*"+AllTrim(Str(nRl))+"*"+AllTrim(Str(KGR))+"^2*0.001"+CrLf)
		            							FWrite(Desc,"------------------------------------------ = "+AllTrim(Str(nLose))+CrLf)
		            							FWrite(Desc,AllTrim(Str(NPHASE))+"^2*"+AllTrim(Str(nTR))+"*"+AllTrim(Str(KMOSHN))+"^2"+CrLf)
            							OTHERWISE
            					ENDCASE
               				FWrite(Desc,"Расчетная величина потерь           "+AllTrim(Str(nLose))+CrLf+CrLf)
            			EndIf
            			tmpLose:=nLose
            			
         	     OTHERWISE
         	        tmpLose=0
            ENDCASE		
            CalckTempLose:=CalckTempLose+tmpLose
         ENDIF
         Select(Month)
      ENDIF
   Select 77
   Skip
EndDo
CalckTempLose:=Round(CalckTempLose,0)
IF Blank
   FWrite(Desc,"Итого потерь "+AllTrim(Str(CalckTempLose))+CrLf)
   Fclose(Desc)
   Win_Rest(MyScr)
EndIf
//IF CalckTempLose>0.and.Blank==.F.
IF Blank==.F..and. CalckTempLose#0
  IF FoundLose
     select(month)
     poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(NameLose)
     seek poisk
     IF Found()
  // ************************************* Поиск расчетного тарифа
        IF Month==1
           Select(13)
        Else
           Select(Month-1)
        EndIf
        poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(NameLose)
        seek poisk
        IF Found()
           tmpTarif:=tarfunc(tarif)
        ENDIF
        Select(Month)
  // ************************************* Конец поиска расчетного тарифа
        IF RecLock()
           IF Tarif==0.0.and.tmpTarif#0.0
              Replace Tarif with tmpTarif
           ENDIF
           Replace Rashod With CalckTempLose
           IF Tarif==0.0
              Replace Tarif With GetVal("Введите тариф для расчета потерь (активная) "+AllTrim(Str(Main->Lic_Schet,6)),Tarif,Tarif)
           ENDIF
           Replace Summa With Round(Rashod*Tarif,Decimal)
           UnLock
        ELSE
//            @ 2,0 Say "Не заблокировано !!!"
        ENDIF
     EndIf
  ELSE
     Select 77
     IF NetAppend()
        Replace Schetchik With "потери"
        Replace Delo With Str(Main->Lic_Schet)
        Replace Lic_Sch With Main->Lic_Schet
        Replace Potreb With Main->Potrebitel
        UnLock
     ENDIF
     select(month)
     poisk='('+alltrim(str(main->lic_schet))+')потери'
     If NetAppend()
        Replace Kod        With Poisk
        Replace Licevoj    With Main->Lic_Schet
        Replace Num_Of_Sch With "потери"
        Replace Rashod With Round(CalckTempLose,0)
        Replace Tarif With GetVal("Введите тариф для расчета потерь (активная) л/c "+AllTrim(Str(Main->Lic_Schet)),Tarif,Tarif)
        Replace Summa With Round(Rashod*Tarif,Decimal)
        UnLock
     EndIf
  ENDIF
EndIF
// Inkey(0)
Select(Sel)
Go Rec
Return NIL
