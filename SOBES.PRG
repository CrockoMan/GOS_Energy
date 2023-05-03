#include "XBP.CH"

FUNCTION SborSobes()
Local Sel:=Select(),Rec:=RecNo(),cFosns:=Schet_Share+"Fosns.Dbf"
Local nMonth:=Month_Menu("для сбора данных"),Scr:=Win_Save()
Local Kol_Kl:=0,Temp_,Poisk:="",aChastn:={0,0,0,0,""}
Local oDlg,aSizeDeskTop,aPos,oProgress
IF nMonth==0.or.nMonth>12
   Return NIL
ENDIF

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Обработано" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
Select Fosn
Copy Structure to &cFosns
make_ind('0',Schet_Share +'fosns.dbf',Schet_Share +'fosns.ntx','KA',,,.t.,.t.)
load("181",SCHET_SHARE+"FOSNs.dbf",SCHET_SHARE+'FOSNs.ntx',,  .f.)
Select Main
Go Top
oProgress:maximum := RecCount()
Do While !Eof()
   oProgress:increment()																				// Progress Bar Increment
   Select FNSI
   Seek Main->Lic_Schet
   IF Found()
      Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(FNSI->NS)
      Select(nMonth)
      Seek Poisk
      IF Found()
         aChastn:={Pokazaniq,Rashod,Tarif,Summa,Info}
         Select FOSN
         Seek Main->Lic_Schet
         Select FOSNs
         IF NetAppend()
            Replace KA   With Main->Lic_Schet
            Replace DOP  With Fosn->DOP
            Replace PO   With aChastn[1]
            Replace Kvt  With aChastn[2]
            Replace Sm   With aChastn[4]
            Replace Vo   With FNSI->VO
            Replace Kvt1 With IF(.not.Empty(aChastn[5]),Val(GetStrToken(aChastn[5],1,";")),0)
            UNLOCK
         ENDIF
      ENDIF
   ENDIF
   Select Main
   Skip
EndDO
Select Fosns
Close
Select(Sel)
Go Rec
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
Win_Rest(Scr)
RETURN NIL





function WriteSobes(BasePath)
Local TmpGlava,TmpVo,TmpTar,ItogSumma:=0,Counter:=0,RecCount:=0
Local Scr:=Win_Save(),Clr:=SetColor(),Sel:=Select(),Rec:=RecNo()
Local Temp_,Kol_Kl:=0,I,CurAlias:="",BaseInd:=Schet_Share+"BaseInd.Ntx"
Local LgotaKvt:=0,TmpLgotaSum:=0,Desc,TmpLgotaKvt:=0,Desc2,Desc3

set cursor off
clear typeahead
BasePath:=FileList("*.09d",Schet_Share )
IF Empty(BasePath)
   Al_Box({"Не выбран файл собеса. Расчет прерван"})
   Return NIL
ENDIF
Clear Typeahead
Obrabot("Расчет данных для собеса")
Close All

make_ind('0',Schet_Share +'fosns.dbf',Schet_Share +'fosns.ntx','KA',,,.t.,.t.)
make_ind('0',Schet_Share + 'fvo.dbf',Schet_Share +'Kvo.ntx','Kvo',,,.t.,.t.)
make_ind('0',Schet_Share + 'fnsi.dbf',Schet_Share +'Fnsi.ntx','KA',,,.t.,.t.)
Make_Ind('0',Schet_Share + 'fyear.dbf',Schet_Share +'fyear.ntx','KA',,,.t.)

//Close All
Load("186",Schet_Share +"fyear.dbf",Schet_Share +"fyear.ntx",,  .f.)
load("185",Schet_Share +"fnsi.dbf", Schet_Share +"fnsi.ntx",,  .f.)
load("184",Schet_Share +"Razbivka.dbf")
zap
load("181",Schet_Share +"fosns.dbf",Schet_Share +"fosns.ntx",,  .f.)
load("182",Schet_Share +"fvo.dbf", Schet_Share+"Fvo.ntx",,  .f.)
load("183",BasePath)
CurAlias=ALIAS()
Index On Val(Glava) To &BaseInd Unique
Select 183
Go Top
Do While !Eof()
   RecCount++
   Skip
EndDo
ColorWin(18,22,23,61,"n+/n")
@ 17,21 SAY "┌─────────────────────────────────────╖"
@ 18,21 SAY "│ Всего не двойных льготников         ║"
@ 19,21 SAY "│ Найдено льготных оплат              ║"
@ 20,21 SAY "│ Сумма к возмещению                  ║"
@ 21,21 SAY "│ Льготные киловатты                  ║"
@ 22,21 SAY "╘═════════════════════════════════════╝"
@ 18,53 say Str(RecCount,5,0)
temp_=39/RecCount
go top
Desc:=Fcreate(DDir+ReportFIle)
Desc2:=FCreate(DDir+"Razbivka.txt")
Desc3:=FCreate(DDir+"Error.txt")
DO WHILE !Eof()
   TmpGlava:=&CurAlias->Glava
   IF !Empty(TmpGlava)
      Select Fosns
      Seek Val(TmpGlava)
      IF Found()
         TmpLgotaSum:=0
         TmpLgotaKvt:=0
         DO While Val(TmpGlava)==Fosns->KA
           TmpVo:=FOsns->Vo
           Select Fvo
           Seek TmpVo
           IF Found()
              IF !Empty(Fosns->DOP)
                 Select 183
                 Fwrite(Desc,Str(Fosns->KA)+" "+Dtoc(Fosns->DOP)+" "+Str(Fosns->Kvt1))
                 IF TmpLgotaSum#0
                    Fwrite(Desc,"     <-----------"+Chr(13)+Chr(10))
                 ELSE
                    Fwrite(Desc,Chr(13)+Chr(10))
                 ENDIF
//---------------------------------------------------------- Выборка в базу
                 WriteRazbivka(Fosns->Kvt1,Fvo->Tarif4*Fosns->Kvt1,TmpGlava,Desc2,Desc3)
//---------------------------------------------------------- Льготных оплат
                 TmpLgotaSum:=TmpLgotaSum+Round(Fvo->Tarif4*Fosns->Kvt1,2)
                 TmpLgotaKvt:=TmpLgotaKvt+Fosns->Kvt1
                 ItogSumma:=ItogSumma+Round(Fvo->Tarif4*Fosns->Kvt1,2)
                 LgotaKvt:=LgotaKvt+Fosns->Kvt1
                 Counter++
                 @ 19,53 say Str(Counter,5,0)
                 @ 20,48 say Str(ItogSumma,10,2)
                 @ 21,48 say Str(LgotaKvt,10,0)
              ENDIF
           ENDIF
           Select Fosns
           Skip
         ENDDO
         Select 183
         if AtNum(",",&CurAlias->Osnovan,1)>0.or.Val(Document)>999
            Replace &CurAlias->Osnovan With SubStr(&CurAlias->Document,1,4)
         ELSE
            Replace &CurAlias->Osnovan With SubStr(&CurAlias->Document,1,3)
         ENDIF
         Replace &CurAlias->Summa With TmpLgotaSum
      ENDIF
   ENDIF
   Select 183
   skip
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
ENDDO
Fclose(Desc3)
Fclose(Desc2)
Fclose(Desc)
CloseMyBase()
Deletefile(Schet_Share +"Fosns.ntx")
Deletefile(Schet_Share +"Kvo.ntx")
Deletefile(BaseInd)
Select(Sel)
colorwin(12,21,12,60,'n/n')
ColorWin(17,21,22,59,"n/bg")

LoadGos()

IF Rec>0
   Go Rec
ENDIF
@ 1,1 say ""
?? chr(7)
Inkey(0)
SetColor(Clr)
Win_Rest(Scr)
RETURN nil





Function SobesEI()
Local strSpisok:={},ChoicedElement:=0,Kod:=0,ToReport:="",CrLf:=Chr(13)+Chr(10)
Local Sel:=Select(),Rec:=RecNo(),Clr:=SetColor(),Scr:=Win_Save(),nStreet
Local top:=3,Left:=10,Bottom:=21,Right:=69,CurAlias:="",SobesKod:=0,BasePath
Local Temp_,Kol_Kl:=0,BaseInd:=Schet_Share+"BaseInd.Ntx",Counter:=0,Desc
Local AllSumma:=0,AllKvt:=0,RecCount:=0,ReportFunc:=0,ShowAll
Local MyTmpSum:=0,MyTmpKvt:=0
strSpisok:={}
//Close All
Clear Typeahead
load("180",Schet_Share+"Fsign.dbf",Schet_Share+"Fsign.ntx",,  .f.)
Go Top
Do While !Eof()
   IF !Empty(Fsign->Symbol)
      aadd(StrSpisok," "+Fsign->Symbol+" "+Alltrim(Fsign->Name))
   EndIf
   Skip
EndDO

Clear Typeahead
ColorWin(Top+1,Left+1,Bottom+1,Right+1,'n+/n')
@ Top, Left, Bottom, Right BOX "┌─╖║╝═╘│ "
Sb_Attach(Top, Right, Bottom,len(strSpisok))
ChoicedElement:=aChoice(top+1, left+1, bottom-1, right-1, strSpisok, .T., 'handle_sb')
Sb_Detach()
Clear Typeahead
IF ChoicedElement#0
   set cursor off
   BasePath:=FileList("*.09d",Schet_Share )
   IF Empty(BasePath)
       Al_Box({"Не выбран файл собеса. Расчет прерван"})
   ELSE
      ShowAll:=Al_Box({"Сформировать развернутый отчет"},2,,2)
      desc:=FCreate(dDir + ReportFile)
      Obrabot("Загрузка данных собеса")
      kol_kl=kol_kl+39/5
      colorwin(12,21,12,21+kol_kl,'n/n')
      Make_Ind('0',Schet_Share+'fosns.dbf',Schet_Share+'fosns.ntx','KA',,,.t.)
      kol_kl=kol_kl+39/5
      colorwin(12,21,12,21+kol_kl,'n/n')
      Make_Ind('0',Schet_Share +'Razbivka.dbf',Schet_Share +'Razbivka.ntx','KA',,,.t.)
      kol_kl=kol_kl+39/5
      colorwin(12,21,12,21+kol_kl,'n/n')
      Make_Ind('0',Schet_Share +'fnsi.dbf',Schet_Share+'fnsi.ntx','KA',,,.t.)
      kol_kl=kol_kl+39/5
      colorwin(12,21,12,21+kol_kl,'n/n')

      load("180",BasePath)
      CurAlias=ALIAS()
      Index On Val(Glava) To &BaseInd Unique
      kol_kl=kol_kl+39/5
      colorwin(12,21,12,21+kol_kl,'n/n')
      go top
      do while !eof()
         RecCount++
         Skip
      enddo
      Load("184",Schet_Share +"Razbivka.dbf",Schet_Share  +"Razbivka.ntx",,  .f.)
      load("185",Schet_Share +"SobesLic.dbf",Schet_Share +"LcSobes.ntx",,  .f.)
      Load("181",Schet_Share +"fosns.dbf", Schet_Share +"fosns.ntx",,  .f.)
      Win_Rest(Scr)
      select 180
      Kol_Kl:=0
      temp_=39/RecCount
      Obrabot('Выбор льготников с категорией "'+Substr(strSpisok[ChoicedElement],2,1)+'"')
      FWrite(Desc,'  Выбор льготников с категорией "'+Substr(strSpisok[ChoicedElement],4)+'"'+Chr(13)+Chr(10))
      FWrite(Desc,'---------------------------------------------------------------------------------------'+Chr(13)+Chr(10))
      FWrite(Desc,'| Абонент  |       Фамилия      |          Адрес          |Льгот| "'+Substr(strSpisok[ChoicedElement],2,1)+'"| Сумма |Признаки|'+Chr(13)+Chr(10))
      FWrite(Desc,'|          |                    |                         | Квт | Квт| льгот |        |'+Chr(13)+Chr(10))
      FWrite(Desc,'---------------------------------------------------------------------------------------'+Chr(13)+Chr(10))
      Go Top
      Do While !EOF()
         IF !Empty(&CurAlias->Summa)
            SobesKod:=Val(&CurAlias->Glava)
            select FNSI
            Seek SobesKod
            IF Found()
               IF AtNum(Substr(strSpisok[ChoicedElement],2,1),FNSI->Gos)#0.or.;
                  Substr(strSpisok[ChoicedElement],2,1)=="Я"
                  ToReport:="|"+Str(SobesKod)+"|"+FNSI->Fam+"|"
                  nStreet:=FNSI->KUL
                  Select FKODS
                  Seek nStreet
                  IF Found()
                     nStreet:=FKODS->NUL
                  ELSE
                     nStreet:=Space(Len(FKODS->NUL))
                  ENDIF
                  select FNSI
                  ToReport:=ToReport+Padr(AllTrim(nStreet)+" "+;
                            AllTrim(FNSI->Dm)+" "+AllTrim(FnSi->Kv),25," ")+"|"
//-----------------------------------------------------------
                  MyTmpKvt:=0
                  MyTmpSum:=0
                  Select 184
                  Seek SobesKod
                  IF Found()
                     ToReport:=ToReport+Str(Razbivka->LgotaKvt,5,0)+"|"
                     Do While Razbivka->KA==SobesKod
                           DO CASE
                              CASE AtNum("Я",Substr(strSpisok[ChoicedElement],2,1))!=0        // Ошибки
                                   MyTmpKvt:=Razbivka->OstatokKvt
                              CASE AtNum("Д",Substr(strSpisok[ChoicedElement],2,1))!=0        // Доноры 50% расход
                                   MyTmpKvt:=Razbivka->Do1
                              CASE AtNum("Е",Substr(strSpisok[ChoicedElement],2,1))!=0        // Ребенок-инвалид 50% расход
                                   MyTmpKvt:=Razbivka->RI1
                              CASE AtNum("Ц",Substr(strSpisok[ChoicedElement],2,1))!=0        // Вдова Черноб 50% расход
                                   MyTmpKvt:=Razbivka->BYB
                              CASE AtNum("Ч",Substr(strSpisok[ChoicedElement],2,1))!=0        // Чернобыль 50% расход
                                   MyTmpKvt:=Razbivka->Che
                              CASE AtNum("Ь",Substr(strSpisok[ChoicedElement],2,1))!=0        // Почетн.гражд.Анапы 50% расход
                                   MyTmpKvt:=Razbivka->PGA
                              Case AtNum("Б",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->Bl
                              Case AllTrim(Upper(Substr(strSpisok[ChoicedElement],2,1)))=="В"
                                   MyTmpKvt:=Razbivka->Bt
                              Case AtNum("Ж",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->In3
                              Case AtNum("З",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->Videt
                              Case AtNum("И",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->IBOB
                              Case AtNum("К",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->In1
                              Case AtNum("Л",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->In2
                              Case AtNum("П",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->BYB
                              Case AtNum("Р",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->REA
                              Case AtNum("У",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->YZN
                              Case AtNum("Ф",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->BBC
                              Case AtNum("Х",Substr(strSpisok[ChoicedElement],2,1))!=0
                                   MyTmpKvt:=Razbivka->BB
                              OtherWise
                                   ToReport:=ToReport+" <???> "
                           ENDCASE

                           AllKvt:=AllKvt+MyTmpKvt
                           MyTmpSum:=MyTmpSum+MyTmpKvt
                           IF ShowAll==1
                              IF MyTmpKvt#0
                                 FWrite(Desc,STR(Razbivka->KA)+" "+DTOC(Razbivka->DOP)+" "+Str(MyTmpKvt)+CrLf)
                              ENDIF
                           ENDIF
                        Skip
                     ENDDO
                  ELSE
                     ToReport:=ToReport+Replicate(" <??> ",Len(Str(MyTmpSum)))+" "
                  ENDIF
                  ToReport:=ToReport+Str(MyTmpSum,4,0)+"|"
//-----------------------------------------------------------
                  Select 180
                  ToReport:=ToReport+Str(Round(MyTmpSum*Razbivka->LgoTar,2),7,2)+"|"+Substr(Fnsi->Gos,1,7)+Str(Fnsi->LgVet,1,0)+"|"+AllTrim(Str(Razbivka->DivisorLgt,2,0))+CrLf
                  AllSumma:=AllSumma+Round(MyTmpSum*Razbivka->LgoTar,2)
                  IF MyTmpSum#0
                     Counter++
                     FWrite(Desc,ToReport)
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         Select 180
         kol_kl=kol_kl+temp_
         colorwin(12,21,12,21+kol_kl,'n/n')
         Skip
      ENDDO
      colorwin(12,21,12,60,'n/n')
      FWrite(Desc,'---------------------------------------------------------------------------------------'+Chr(13)+Chr(10))
      ToReport:="Всего "+AllTrim(Str(Counter))+" Сумма "+AllTrim(Str(AllSumma))+" руб    Расход "+AllTrim(Str(AllKvt))+" кВт"
      Fwrite(Desc,"   "+ToReport+CrLf)
      Fclose(Desc)
  ENDIF
ENDIF
CloseMyBase()
Select(Sel)
IF Rec>0
   Go Rec
ENDIF
SetColor(Clr)
Win_Rest(Scr)
Return NIL




Function WriteLicSo()
Local BasePath:="",Clr:="",Scr:=Win_Save(),Sel:=Select(),Rec:=RecNo(),LicSbit
Local SobesBase:="p0300307.09d",LicSobes,LicSbyt,Temp_,Kol_Kl:=0,CurAlias:=""
Local cClr:=SetColor()
set cursor off
Clear Typeahead
BasePath:=FileList("*.09d",Schet_Share )
IF Empty(BasePath)
   Al_Box({"Не выбран файл соцзащиты. Расчет прерван"})
   Return NIL
ENDIF
Clear Typeahead
Obrabot("Привязка данных собеса по файлу")
make_ind('0',Schet_Share +'SobesLic.dbf',Schet_Share +'LcSobes.ntx','Lc_Sobes',,,.t.,.t.)
load("181",Schet_Share +"SobesLic.dbf",Schet_Share +"LcSobes.ntx",,  .f.)
temp_=39/RecCount()
load("182",BasePath)
CurAlias=ALIAS()
//------------------------------------
go top
Do While !EOF()
   Replace &CurAlias->Glava With ""
   LicSobes:=&CurAlias->Lc_Sobes
   Select 181
   Seek LicSobes
   IF Found()
      LicSbit:=SobesLic->Glava
      Select 182
      IF !Empty(LicSbit)
         Replace &CurAlias->Glava With LicSbit
      ENDIF
   ENDIF
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
   Select 182
   Skip
ENDDO
//------------------------------------
CloseMyBase()
Select 182
Close
Select(Sel)
IF Rec>0
   Go Rec
ENDIF
SetColor(Clr)
SetColor(cClr)
Win_Rest(Scr)
Return NIL



function CloseMyBase()
Local I
For i=180 to 190
    Select(i)
    Close
Next
Return NIL




Function WriteRazbivka(TmpLgotaKvt,TmpLgotaSum,TmpGlava,Desc2,Desc3)
Local LgotaString:="БВЖЗИКЛПРУФХ",Count50:=0,MyLgotaKvt:=0,I,cStr:=""
Local LastDate:=CTOD("01.01.1985"),Divisor:=1,LgotaNaChel:=50,RetTarif:=0.5
Local Sel:=Select(),Rec:=RecNo(),FieldToReplace:="",LgCount:=0,IsFirst:=.F.
//                 "Б   В     Ж     З       И      К     Л     П     Р     У     Ф    Х"
Local BaseField:={"BL","BT","IN3","VIDET","IBOB","IN1","IN2","BYB","REA","YZN","BBC","BB"}
  IF TmpLgotaKvt>0
     Select FYear
     Seek Val(TmpGlava)
     IF Found()
        DO While FYear->KA==Val(TmpGlava)
           IF FYear->Dop>LastDate
              LastDate=FYear->Dop
           ENDIF
           Skip
        EndDo
     ENDIF
//------------------------------------------------------- Раасчет кол-ва мес.
     IF Month(Fosns->DOP)-Month(LastDate)>0
        Divisor=Month(Fosns->DOP)-Month(LastDate)
     ELSE
        Divisor=1
     ENDIF
//-------------------------------------------------------
     Select FNSI
     Seek Val(TmpGlava)
     IF Found()
        Select Razbivka
        Append Blank
        Replace Razbivka->KA       With Val(TmpGlava)
        Replace Razbivka->Dop      With Fosns->DOP
        Replace Razbivka->LgotaKvt With TmpLgotaKvt
        Replace Razbivka->LgotaSum With TmpLgotaSum
        Replace Razbivka->LgoTar   With Fvo->Tarif4
        Replace Razbivka->DivisorLgt With Divisor
        cStr:=Str(Razbivka->Ka,10,0)+" "+Str(Divisor,1,0)+" "+Fnsi->Gos+" "+Str(TmpLgotaKvt,5,0)+" "+Str(TmpLgotaSum,6,2)+" "
        Fwrite(Desc2,Str(Razbivka->Ka,10,0)+" "+Str(Divisor,1,0)+" "+Fnsi->Gos+" "+Str(TmpLgotaKvt,5,0)+" "+Str(TmpLgotaSum,6,2)+" ")
        Count50:=0
        DO CASE
           CASE AtNum("Д",Fnsi->Gos)!=0        // Доноры 50% расход
                Replace Razbivka->Do1 With tmpLgotaKvt
                cStr:=cStr+Str(tmpLgotaKvt,5,0)+" "
                Fwrite(Desc2,Str(tmpLgotaKvt,5,0)+" ")
           CASE AtNum("Е",Fnsi->Gos)!=0        // Ребенок-инвалид 50% расход
                Replace Razbivka->RI1 With tmpLgotaKvt
                cStr:=cStr+Str(tmpLgotaKvt,5,0)+" "
                Fwrite(Desc2,Str(tmpLgotaKvt,5,0)+" ")
           CASE AtNum("Ц",Fnsi->Gos)!=0        // Вдова Черноб 50% расход
                Replace Razbivka->BYB With tmpLgotaKvt
                cStr:=cStr+Str(tmpLgotaKvt,5,0)+" "
                Fwrite(Desc2,Str(tmpLgotaKvt,5,0)+" ")
           CASE AtNum("Ч",Fnsi->Gos)!=0        // Чернобыль 50% расход
                Replace Razbivka->Che With tmpLgotaKvt
                cStr:=cStr+Str(tmpLgotaKvt,5,0)+" "
                Fwrite(Desc2,Str(tmpLgotaKvt,5,0)+" ")
           CASE AtNum("Ь",Fnsi->Gos)!=0        // Почетн.гражд.Анапы 50% расход
                Replace Razbivka->PGA With tmpLgotaKvt
                cStr:=cStr+Str(tmpLgotaKvt,5,0)+" "
                Fwrite(Desc2,Str(tmpLgotaKvt,5,0)+" ")
           OTHERWISE                     // Остальные льготники
                For I=1 To Len(LgotaString)
                    IF AtNum(Substr(LgotaString,I,1),Fnsi->Gos)!=0
                       LgCount:=LgCount+1
                    ENDIF
                Next
                IF LgCount!=Fnsi->LgVet
                   IsFirst:=.F.
                ELSE
                   IsFirst:=.T.
                ENDIF
                cStr:=cStr+"("+Str(Fnsi->LgVet,2,0)+" "+Str(LgCount,2,0)+") "
                FWrite(Desc2,"("+Str(Fnsi->LgVet,2,0)+" "+Str(LgCount,2,0)+") ")
                DO CASE
                   CASE FNSI->KUL==10010.and.Val(FNSI->DM)==182
                        LgotaNaChel:=75      // 75 квт на человека (Крымская 182)
                        IF Fosns->DOP>CTOD("11.01.2005")
                           RetTarif:=0.59
                        ELSE
                           RetTarif:=0.41
//                           Al_Box({STR(FOSN->KA)+" "+DTOC(Fosn->DOP)})
                        ENDIF
                   CASE FNSI->KUL==10045
                        LgotaNaChel:=50      // 75 квт на человека (Дом Клюева)
                        IF Fosns->DOP>CTOD("11.01.2005")
                           RetTarif:=0.59
                        ELSE
                           RetTarif:=0.41
//                           Al_Box({STR(FOSN->KA)+" "+DTOC(Fosn->DOP)})
                        ENDIF
                   OTHERWISE
                        LgotaNaChel:=50      // 50 квт на человека
                        IF Fosns->DOP>CTOD("11.01.2005")
                           RetTarif:=0.80
                        ELSE
                           RetTarif:=0.58
//                           Al_Box({STR(FOSN->KA)+" "+DTOC(Fosn->DOP)})
                        ENDIF
                ENDCASE
                For I=1 To Len(LgotaString)
                    IF AtNum(SubStr(LgotaString,I,1),FNSI->Gos)!=0
                       Fwrite(Desc2,Substr(LgotaString,I,1)+" ")
                       IF FNSI->VO==4                         // 50% расход
                          MyLgotaKvt=tmpLgotaKvt
                          tmpLgotaKvt=0
                          IsFirst:=.T.
                       ELSE
                          IF IsFirst==.F.
                             IsFirst:=.T.
                             IF (tmpLgotaKvt-Divisor*(LgotaNaChel*(1+Fnsi->LgVet-LgCount)))>=0
                                MyLgotaKvt:=Divisor*LgotaNaChel*(1+Fnsi->LgVet-LgCount)
                                tmpLgotaKvt:=tmpLgotaKvt-Divisor*LgotaNaChel*(1+Fnsi->LgVet-LgCount)
                             ELSE
                                MyLgotaKvt=tmpLgotaKvt
                                tmpLgotaKvt=0
                             ENDIF
                             cStr:=cStr+"!"+Str(1+Fnsi->LgVet-LgCount,3,0)+" "+Str(MyLgotaKvt,3,0)+"! "
                             Fwrite(Desc2,"!"+Str(1+Fnsi->LgVet-LgCount,3,0)+" "+Str(MyLgotaKvt,3,0)+"! ")
                          ELSE
                             IF tmpLgotaKvt-(Divisor*LgotaNaChel)>=0
                                MyLgotaKvt:=Divisor*LgotaNaChel
                                tmpLgotaKvt:=tmpLgotaKvt-(Divisor*LgotaNaChel)
                             ELSE
                                MyLgotaKvt=tmpLgotaKvt
                                tmpLgotaKvt=0
                             ENDIF
                          ENDIF
                       ENDIF
                       FieldToReplace:="Razbivka->"+BaseField[i]
                       Replace &FieldToReplace With &FieldToReplace+MyLgotaKvt
                       cStr:=cStr+" "+Substr(LgotaString,I,1)+"=> "+Str(&FieldToReplace,5,0)+" "
                       Fwrite(Desc2," "+Substr(LgotaString,I,1)+"=> "+Str(&FieldToReplace,5,0)+" ")
                    ENDIF
                NEXT
                IF tmpLgotaKvt>0
                   Replace OstatokKvt With tmpLgotaKvt
                   FWrite(Desc2," ["+Alltrim(Str(tmpLgotaKvt))+"]")
                   FWrite(Desc3,cStr+" ["+Alltrim(Str(tmpLgotaKvt))+"]"+Chr(13)+Chr(10))
                ENDIF
        ENDCASE
        Fwrite(Desc2,Chr(13)+Chr(10))
     ENDIF
  ENDIF
Select(Sel)
Go Rec
Return RetTarif







Function SobesADR()
Local oDlg,aSizeDeskTop,aPos,oProgress,I
Local Sel:=Select(),Rec:=RecNo(),nKodS:=0,nKA:=0,cNotFound:="",CrLf:=Chr(13)+Chr(10)
Local BasPath:="",aKods:={},cAdr:="",nFnsiRec,aKaRec:={}
set cursor off
clear typeahead
BasePath:=FileList("*.09d",Schet_Share )
IF Empty(BasePath)
	 ConfirmBox(oMainWindow , "Не выбран файл соцзащиты. Расчет прерван.", ;
                       "Ошибка", ;
                        XBPMB_OK , ;
                        XBPMB_WARNING+XBPMB_APPMODAL )
   Return NIL
ENDIF
Select FNSI
nFnsiRec:=RecNo()
Select Main
Clear Typeahead
IF load("183",BasePath)
	 CurAlias=ALIAS()
	 Go Top

	 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
	 aSizeDesktop  := oMainWindow:currentSize()
	 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
	 oDlg:title    := "Привязка файла соцзащиты по адресу"
	 oDlg:SysMenu	 := .F.
	 oDlg:Configure()
	 oDlg:Show()
	 aSizeDesktop  := oDlg:currentSize()
	 aPos					 := oDlg:CurrentPos()
	 oProgress 		 := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
	 oProgress:create()
	 oProgress:minimum := 1
	 oProgress:maximum := RecCount()
	 Select FKODS
	 Go top
	 Do While !EOF()
	 		IF KUL#0
	 			 AADD(aKods,{StreetN,KUL})
	 		ENDIF
	 		Skip
	 ENDDO
	 Select FNSI
	 Set Order To 2
	 Select 183
	 Do While .not.EOF()
   	  oProgress:increment()																				// Progress Bar Increment
   	  nKods:=0
   	  nKA:=0
   	  cAdr:=AllTrim(MyUpper(AllTrim(House)+" "+IF(Len(AllTrim(Korp))>0,AllTrim(Korp)+" ","")+AllTrim(Flat)))
   	  For I=1 To Len(aKods)
   	  		IF Street==aKods[i][1]
						nKods:=aKods[i][2]
//						i:=Len(aKods)
						Exit
   	  		ENDIF
			Next
			
			IF nKods!=0
					Select FNSI
					Seek nKods
					Do While nKods==KUL
						 IF MyUpper(AllTrim(AllTrim(DM)+" "+AllTrim(KV)))==cAdr
						 	  nKA:=KA
						 	  Exit
						 ENDIF
						 Skip
					ENDDO
			ENDIF
			Select 183
			IF nKA!=0
				 Replace Glava With Str(nKA,6,0)
			ELSE
				 Replace Glava With ""
			ENDIF
	 	  Skip
	 ENDDO
	 Select FNSI
	 Set Order To 1
	 Select 183
	 Close
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
ELSE
	 ConfirmBox(oMainWindow , "Не могу открыть файл соцзащиты. Расчет прерван.", ;
                       "Ошибка", ;
                        XBPMB_OK , ;
                        XBPMB_WARNING+XBPMB_APPMODAL )

ENDIF
Select FNSI
Go nFnsiRec
Select(Sel)
Go Rec
Return NIL




Function NoInSZ()
Local oDlg,aSizeDeskTop,aPos,oProgress,aLic:={},lFound:=.F.,I,Desc,cText:="",cText2:="",nCount:=0
Local Sel:=Select(),Rec:=RecNo(),nKodS:=0,nKA:=0,cNotFound:="",CrLf:=Chr(13)+Chr(10),IsLg:=.F.
Local BasPath:="",aKods:={},cAdr:="",nFnsiRec,aKaRec:={},LgotaString:="БВЖЗИКЛПРУФХ",nAllSumma:=0
Local cInd:=Schet_Share+"Sobes.Ind",nSumma:=0,nOutSumma:=0,aLgotnik:={}
set cursor off
clear typeahead
BasePath:=FileList("*.09d",Schet_Share )
IF Empty(BasePath)
	 ConfirmBox(oMainWindow , "Не выбран файл соцзащиты. Расчет прерван.", ;
                       "Ошибка", ;
                        XBPMB_OK , ;
                        XBPMB_WARNING+XBPMB_APPMODAL )
   Return NIL
ENDIF
Select FNSI
nFnsiRec:=RecNo()
Select Main
Clear Typeahead
IF load("183",BasePath)
	 CurAlias=ALIAS()
	 Go Top

	 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
	 aSizeDesktop  := oMainWindow:currentSize()
	 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
	 oDlg:title    := "Сортировка льготников"
	 oDlg:SysMenu	 := .F.
	 oDlg:Configure()
	 oDlg:Show()
	 aSizeDesktop  := oDlg:currentSize()
	 aPos					 := oDlg:CurrentPos()

	 Select 183
	 Index On Val(Glava) To &cInd Unique
	 GO Top
	 Do While !EOF()
	 		AADD(aLic,Val(Glava))
	 		Skip
	 ENDDO

	 Select 183
	 Close
	 Select Main
	 Go Top
	 oDlg:SetTitle("Выбор некомпенсируемых льготников")
	 oProgress 		 := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
	 oProgress:create()
	 oProgress:minimum := 1
	 oProgress:maximum := RecCount()

	 Do While .not.EOF()
   	  oProgress:increment()																				// Progress Bar Increment
	 		lFound:=.F.
	 		Select FNSI
	 		Seek Main->Lic_Schet
	 		IF Found()
	 			 IsLg:=.F.

	   	   nSumma:=GetLgota(Main->Lic_Schet,Month(New_Date))
	   	   nOutSumma:=nOutSumma+nSumma[2]
		 		 IF nSumma[2]>0
 			 	 		IsLg:=.T.
  	 		 ENDIF


	 			 IF IsLg==.T.
		   	  	For I=1 To Len(aLic)
		 						IF aLic[I]==FNSI->KA
			 						 lFound:=.T.
	 							ENDIF
	   	  		Next
	   	  		IF lFound==.F.
	   	  			 nCount:=nCount+1

	   	  			 nAllSumma:=nAllSumma+nSumma[2]
	   	  			 cAdr:=AllTrim(AllTrim(GetcUl(FNSI->KUl))+" "+AllTrim(FNSI->DM)+" "+AllTrim(FNSI->Kv))+Space(40)
	   	  			 cText=cText+" "+Str(Main->Lic_Schet,6)+" "+FNSI->FAM+" "+Substr(cAdr,1,35)+" "+FNSI->GOS+;
	   	  			       " "+Str(nSumma[2],12,2)+CrLf
	   	  			 AADD(aLgotnik,FNSI->FAM+" "+Str(Main->Lic_Schet,6)+" "+Substr(cAdr,1,35)+" "+FNSI->GOS+;
	   	  			       " "+Str(nSumma[2],12,2))
	   	  		ENDIF
   	  	 ENDIF
   	  ENDIF
   	  Select Main
	 	  Skip
	 ENDDO
	 ASort(aLgotnik)
	 cText:=""
	 For I:=1 To Len(aLgotnik)
	 		cText:=cText+aLgotnik[i]+CrLf
	 NEXT
	 aLgotnik:={}
	 Desc:=FCreate(dDir+ReportFile)
	 FWrite(Desc,"Всего льготников: "+Str(Len(aLic),12)+CrLf)
	 FWrite(Desc,"Сумма           : "+Str(nOutSumma,12,2)+CrLf)
	 FWrite(Desc,"Непривязанных   : "+Str(nCount,12)+CrLf)
	 FWrite(Desc,"Сумма           : "+Str(nAllSumma,12,2)+CrLf)
	 FWrite(Desc,cText)
	 FClose(Desc)
	 
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
ELSE
	 ConfirmBox(oMainWindow , "Не могу открыть файл соцзащиты. Расчет прерван.", ;
                       "Ошибка", ;
                        XBPMB_OK , ;
                        XBPMB_WARNING+XBPMB_APPMODAL )
ENDIF
Select FNSI
Go nFnsiRec
Select(Sel)
Go Rec
Return NIL





Function SobesWrite()
Local Sel:=Select(),Rec:=RecNo(),BasePath,Lgota:={0,0},nSumma:={0,0},Desc,CrLf:=Chr(13)+Chr(10)
Local oDlg,aSizeDeskTop,aPos,oProgress,nGlava,nMonth,cInd:=Schet_Share+"Sobes.Ind",cStr:=""
	
Clear Typeahead
BasePath:=FileList("*.09d",Schet_Share )
IF Empty(BasePath)
	 ConfirmBox(oMainWindow , "Не выбран файл соцзащиты. Расчет прерван.", ;
                       "Ошибка", ;
                        XBPMB_OK , ;
                        XBPMB_WARNING+XBPMB_APPMODAL )
   Return NIL
ENDIF

nMonth:=Month_Menu("для формирования соцзащиты")
IF nMonth<=0.or.nMonth>12
	 ConfirmBox(oMainWindow , "Не выбран месяц для расчета. Расчет прерван.", ;
                       "Ошибка", ;
                        XBPMB_OK , ;
                        XBPMB_WARNING+XBPMB_APPMODAL )
   Return NIL
ENDIF

Clear Typeahead
IF load("183",BasePath)
	 CurAlias=ALIAS()
	 Go Top

	 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
	 aSizeDesktop  := oMainWindow:currentSize()
	 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
	 oDlg:title    := "Запись данных по предоставленным льготам"
	 oDlg:SysMenu	 := .F.
	 oDlg:Configure()
	 oDlg:Show()
	 aSizeDesktop  := oDlg:currentSize()
	 aPos					 := oDlg:CurrentPos()
	 oProgress 		 := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
	 oProgress:create()
	 oProgress:minimum := 1
	 Select 183
	 Index On Val(Glava) To &cInd Unique
	 GO Top
	 oProgress:maximum := RecCount()
	 Do While !EOF()
   	  oProgress:increment()																				// Progress Bar Increment
   	  nGlava:=Val(Glava)
   	  IF nGlava>0
   	  	Select FNSI
   	  	Seek nGlava
   	  	Select Main
   	  	Seek nGlava
   	  	IF Found()
   	  		Lgota :=GetLgota(Main->Lic_Schet,nMonth)
   	  		Select 183
   	  		IF RecLock()
         		IF AtNum(",",Osnovan,1)>0.or.Val(Document)>999
		            Replace Osnovan With SubStr(Document,1,4)
         		ELSE
		            Replace Osnovan With SubStr(Document,1,3)
         		ENDIF
   	  		 	Replace Summa With Lgota[2]
   	  		 	nSumma[2]:=nSumma[2]+Lgota[2]
   	  		 	nSumma[1]:=nSumma[1]+1
   	  		 	UNLOCK
						IF Lgota[2]>0
           		 cStr:=cStr+Str(nGlava,6)+" "+Substr(Main->Potrebitel,1,40)+" "+FNSI->Gos+" "+Str(Lgota[2],12,2)+CrLf
           	ENDIF
   	  		ENDIF
   	  	ELSE
   	  		Select 183
   	  	ENDIF
   	  ENDIF
	 		Skip
	 ENDDO
	 Select 183
	 Close
	 Desc:=FCreate(dDir+ReportFile)
	 FWrite(Desc,cStr+"Всего льготников "+Str(nSumma[1],5,0)+CrLf+;
	                  "Сумма для компенсации "+Str(nSumma[2],12,2))
	 FClose(Desc)
	 
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
ELSE
	 ConfirmBox(oMainWindow , "Не могу открыть файл соцзащиты. Расчет прерван.", ;
                       "Ошибка", ;
                        XBPMB_OK , ;
                        XBPMB_WARNING+XBPMB_APPMODAL )
ENDIF
Select(Sel)
Go Rec
Return NIL


Function SzZapoln()
Local Sel:=Select(),Rec:=RecNo(),aBon:={0,0,0},Count:=0
Local oDlg,aSizeDeskTop,aPos,oProgress

Select 0
IF NetUse(Schet_Share+"P03_03.09D",,,"So")
// cDatabase, lOpenMode, nSeconds, cAlias,lAsk	
 Go Top
 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
 aSizeDesktop  := oMainWindow:currentSize()
 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
 oDlg:title    := "Обработано" 
 oDlg:SysMenu	:= .F.
 oDlg:Configure()
 oDlg:Show()
 aSizeDesktop  := oDlg:currentSize()
 aPos					:= oDlg:CurrentPos()
 oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
 														
 oProgress:create()
 oProgress:minimum := 1
 oProgress:maximum := RecCount()


 For I=1 to RecCount()
 		Select SO
 		Go I
//	 IF !Empty(Val(Glava))
@ 2,0 Say Tok_lc
@ 2,20 Say Val(Tok_LC)
@ 3,0 Say RecNo()
@ 4,0 Say RecCount()
	 		Count:=Count+1
//INKEY(0)
	 		@ 1,0 Say Count
	 IF Val(TOK_LC)>0
	 		aBon:={0,0,0}
	 		Select FYear
	 		Go Top
//	 		Seek Val(Sobes->Glava)
	 		Seek Val(So->TOK_LC)
	 		IF Found()
//	 			Do While KA==Val(Sobes->Glava)
	 			Do While KA==Val(So->TOK_LC)
	 			 	IF DOP>=CTOD("01.04.2005").and.DOP<=CTOD("01.04.2006")
	 			 	  	aBon[2]:=VO
	 			 			IF VO==3.or.VO==11
	 			 			 	aBon[1]:=aBon[1]+SM/IF(DOP<CTOD("11.01.2006"),1.02,1.18)
	 			 			ELSE
	 			 			 	aBon[1]:=aBon[1]+SM/IF(DOP<CTOD("11.01.2006"),1.60,1.35)
	 			 			ENDIF
	 			 	ENDIF
	 			 	Skip
	 			ENDDO
	 			aBon[3]:=aBon[1]
	 			aBon[1]:=Round(aBon[1]/12,0)
	 			Select So
	 			IF RecLock()
//	 					Replace Tok_Lc With Glava
	 					Replace Tok 	 With 3
	 					Replace TTok 	 With 2
	 					Replace NTOK	 With aBon[1]
	 					Replace NGAZ1	 With 0
	 					Replace UTOK	 With "09"+IF(aBon[2]==3.or.aBon[2]==11,"013","")
	 					UNLOCK
	 			ENDIF
	 		ENDIF
	 ELSE
	 			IF RecLock()
	 					Replace Tok_Lc With Glava
	 					UNLOCK
	 			ENDIF
	 ENDIF
//   SKIP
   oProgress:increment()																				// Progress Bar Increment
 Next

 Select So
 Close
 oProgress:destroy()																							// Progress Bar Destroy
 oDlg:Destroy()
ENDIF
Select(Sel)
Go Rec
Return NIL








Function Subsidii()
Local BasePath:="",Clr:="",Scr:=Win_Save(),Sel:=Select(),Rec:=RecNo(),LicSbit
Local SobesBase:="subsidii.dbf",LicSobes,LicSbyt,Temp_,Kol_Kl:=0,CurAlias:="",ReplaceTarif
Local cClr:=SetColor(),cGlava,nMonth:=Month_Menu("для выгрузки субсидий"),cStr1,cStr2
IF nMonth<=0.and.nMonth>12
   Al_Box({"Не выбран месяц для формирования"})
   Return NIL
ENDIF
set cursor off
Clear Typeahead
BasePath:=FileList("subsidii.dbf",Schet_Share )
IF Empty(BasePath)
   Al_Box({"Не выбран файл соцзащиты. Расчет прерван"})
   Return NIL
ENDIF
Clear Typeahead
Obrabot("Привязка данных собеса по файлу")
make_ind('0',Schet_Share +'SobesLic.dbf',Schet_Share +'LcSobes.ntx','Lc_Sobes',,,.t.,.t.)
load("181",Schet_Share +"SobesLic.dbf",Schet_Share +"LcSobes.ntx",,  .f.)
temp_=39/RecCount()
load("182",BasePath)
CurAlias=ALIAS()
//------------------------------------
go top
Do While !EOF()
   Replace &CurAlias->Glava With ""
   LicSobes:=&CurAlias->Lc_Sobes
   Select 181
   Seek LicSobes
   IF Found()
      LicSbit:=SobesLic->Glava
      Select 182
      IF !Empty(LicSbit)
         Replace &CurAlias->Glava With LicSbit
      ENDIF
   ENDIF
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
   Select 182
   Skip
ENDDO
//------------------------------------
//CloseMyBase()
cStr1:="Debet"+AllTrim(Str(nMonth,2))
cStr2:="Debet"+AllTrim(Str(if(nMonth=1,12,nMonth-1),2))
Select 182
go top
DO while .not.eof()
	 ReplaceTarif=.F.
	 cGlava=Val(Glava)
//	 Select Main
	 Select Obormot
	 Seek cGlava
	 if Found()
	 		IF &cStr1>0.and.&cStr2>0
	 			 ReplaceTarif=.T.
	 		ENDIF
	 ENDIF	 
	 select 182
	 Replace Tarif with ReplaceTarif
	 SKIP
ENDDO
CloseMyBase()
select 182
Close
Select(Sel)
IF Rec>0
   Go Rec
ENDIF
SetColor(Clr)
SetColor(cClr)
Win_Rest(Scr)
Return NIL
