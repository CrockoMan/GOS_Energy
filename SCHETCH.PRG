FUNCTION CalckSch()
Local aSch:={},i,Desc,CrLf:=Chr(13)+Chr(10),Itogo:=0,TipSch:=Schet_Share+"LicTip.Ntx"
Local Sel:=Select(),Rec:=RecNo(),Temp_,Kol_KL,Scr:=Win_Save()
Local oDlg,aSizeDeskTop,aPos,oProgress

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := AppDesktop():currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := "Расчет данных по счетчикам"
oDlg:SysMenu    := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos                                    := oDlg:CurrentPos()
oProgress               := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()*2

Select FSCH
GO TOP
Do While !EOF()
   IF KTS>0
      AADD(aSch,{0,KTS,ZNS,TS,ST})
   ENDIF
   SKip
ENDDO
Select Main
Go TOp
Do While !EOF()
   oProgress:increment()                                                                                                                                                                // Progress Bar Increment
   Select FNSI
   Seek Main->Lic_Schet
   IF Found()
      For i=1 To Len(aSch)
          IF aSch[i][2]==Sh
             aSch[i][1]:=aSch[i][1]+1
             Itogo:=Itogo+1
          ENDIF
      NEXT
   ENDIF
   Select Main
   SKIP
ENDDO
Desc:=FCreate(dDir+ReportFile)
FWrite(Desc,"   Справочник счетчиков на "+DtoC(new_date)+CrLf)
FWrite(Desc,"   Частный сектор"+CrLf)
Fwrite(Desc,"   ┌───┬──────────┬──────────┬──┬─────┐"+CrLf)
Fwrite(Desc,"   │Код│    Тип   │   Ток    │Зн│Колич│"+CrLf)
Fwrite(Desc,"   ├───┼──────────┼──────────┼──┼─────┤"+CrLf)
For I=1 To Len(aSch)
    FWrite(Desc,"   │"+Str(aSch[i][2],3)+"│"+aSch[i][4]+"│"+aSch[i][5]+"│"+;
                 Str(aSch[i][3],2)+"│"+Str(aSch[i][1],5)+"│"+CrLf)
Next
Fwrite(Desc,"   └───┴──────────┴──────────┴──┴─────┘"+CrLf)
FWrite(Desc,"   Всего: "+Str(Itogo,10)+CrLf)
Itogo:=0
Select Licevoj
go top
Set Unique On
Index on Upper(Tip) to &TipSch
aSch:={}
Do While !EOF()
   AADD(aSch,{0,TIP})
   SKip
ENDDO
Set Unique Off
Select Licevoj
Close
load('77',SCHET_SHARE+'licevoj.dbf',SCHET_SHARE+'lic_sch.ntx',SCHET_SHARE+'schetchi.ntx',.f.)
Go Top
Select Main
Go TOp
Do While .not.EOF()
   oProgress:increment()                                                                                                                                                                // Progress Bar Increment
   IF Main->Lic_Schet<99999
      Select Licevoj
      Seek Main->Lic_Schet
      Do While Lic_Sch==Main->Lic_Schet
      		FOR I=1 To Len(aSch)
              IF AllTrim(Upper(aSch[i][2]))==AllTrim(Upper(Licevoj->TIP)).and..not.empty(AllTrim(Licevoj->Tip))
                 Itogo:=Itogo+1
                 aSch[i][1]:=aSch[i][1]+1
              ENDIF
      		NEXT
      		Skip
      ENDDO
      Select Main
   ENDIF
   Skip
ENDDO
FWrite(Desc,"   Госсектор"+CrLf)
FWrite(Desc,"   ┌────────────┬──────┐"+CrLf)
FWrite(Desc,"   │Тип счетчика│Кол-во│"+CrLf)
FWrite(Desc,"   ├────────────┼──────┤"+CrLf)
For i=1 To Len(aSch)
    IF aSch[i][1]!=0
       FWrite(Desc,"   │"+aSch[i][2]+" │ "+Str(aSch[i][1],5)+"│"+CrLF)
    ENDIF
NEXT
FWrite(Desc,"   └────────────┴──────┘"+CrLf)
FWrite(Desc,"   Всего: "+Str(Itogo,10)+CrLf)
Fclose(Desc)
oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
oDlg:Destroy()

Win_Rest(Scr)
Select(Sel)
Go Rec
Return Nil







Function ChNoMonthOpl()
Local Sel:=select(),Rec:=RecNo(),Scr:=Win_Save()
Local MaxDate:=new_date,CrLf:=Chr(13)+Chr(10),Desc,aLastPok
Local oDlg,aSizeDeskTop,aPos,oProgress
MaxDate:=GetVal("Дата максимальной оплаты для поиска ",MaxDate,CTOD("01.01.1999"))
IF MaxDate#CTOD("01.01.1999")
   oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
   aSizeDesktop  := AppDesktop():currentSize()
   oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
   oDlg:title    := " Выбор потребителей, оплативших до "+DTOC(MaxDate)
   oDlg:SysMenu   := .F.
   oDlg:Configure()
   oDlg:Show()
   aSizeDesktop  := oDlg:currentSize()
   aPos                                   := oDlg:CurrentPos()
   oProgress              := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

   oProgress:create()
   oProgress:minimum := 1
   oProgress:maximum := RecCount()
   Desc:=FCreate(dDir+ReportFile)
   FWrite(Desc," Выбор потребителей, оплативших до "+DTOC(MaxDate)+CrLf)
   FWrite(Desc," ┌────────┬────────────────────┬───────────────────────────────────┬────────┬──────────┐"+CrLf)
   FWrite(Desc," │ Договор│    Потребитель     │              Адрес                │Показан.│   Дата   │"+CrLf)
   FWrite(Desc," ├────────┼────────────────────┼───────────────────────────────────┼────────┼──────────┤"+CrLf)

   Select Main
   Go Top
   Do While !EOF()
      oProgress:increment()                                                                                                                                                         // Progress Bar Increment
      Select FNSI
      Seek Main->Lic_Schet
      IF Found()
         aLastPok:=GetMaxPok(Main->Lic_Schet,Month(new_date),.F.)
         IF aLastPok[2]<MaxDate
            FWrite(Desc," │"+Str(KA,8)+"│"+Substr(Main->Potrebitel+Space(30),1,20)+"│"+;
                        Padr(AllTrim(GetcUl(FNSI->KUL))+" "+;
                        AllTrim(FNSI->Dm)+" "+AllTrim(FNSI->Kv),35," ")+"│"+;
                        Str(aLastPok[1],8)+"│"+DTOC(aLastPok[2])+"│"+CrLf)
         ENDIF
      ENDIF
      Select Main
      SKIP
   ENDDO
   FWrite(Desc," └────────┴────────────────────┴───────────────────────────────────┴────────┴──────────┘"+CrLf)
   FClose(Desc)
   oProgress:destroy()                                                                                                                                                                                  // Progress Bar Destroy
   oDlg:Destroy()
ENDIF
ClearBuffer()
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL






Function ChMonthDolg()
Local Sel:=select(),Rec:=RecNo(),Scr:=Win_Save(),LgotaString:="БВЖЗИКЛПРУФХ"
Local MaxDate:=new_date,CrLf:=Chr(13)+Chr(10),Desc,aLastPok,LgCount:=0,MonthDolg:=0
MaxDate:=GetVal("Дата максимальной оплаты для поиска ",MaxDate,CTOD("01.01.1999"))
IF MaxDate#CTOD("01.01.1999")
//   Obrabot("Выбор потребителей")
         oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
         aSizeDesktop  := AppDesktop():currentSize()
         oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
         oDlg:title    := "Выбор потребителей оплативших до " +DTOC(MaxDate)
         oDlg:SysMenu   := .F.
         oDlg:Configure()
         oDlg:Show()
         aSizeDesktop  := oDlg:currentSize()
         aPos                                   := oDlg:CurrentPos()
         oProgress              := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

         oProgress:create()
         oProgress:minimum := 1
         oProgress:maximum := RecCount()
   Desc:=FCreate(dDir+ReportFile)
   FWrite(Desc," Выбор потребителей, оплативших до "+DTOC(MaxDate)+CrLf)
   FWrite(Desc," ┌────────┬────────────────────┬───────────────────────────────────┬────────┬──────────┐"+CrLf)
   FWrite(Desc," │ Договор│    Потребитель     │              Адрес                │Показан.│Период мес│"+CrLf)
   FWrite(Desc," ├────────┼────────────────────┼───────────────────────────────────┼────────┼──────────┤"+CrLf)

   Select Main
//   temp_=39/reccount()
//   kol_kl=0
   Go Top
   Do While !EOF()
          oProgress:increment()                                                                                                                                                         // Progress Bar Increment
//      Kol_Kl=Kol_Kl+Temp_
//      ColorWin(12,21,12,21+kol_kl,'n/n')
      MonthDolg:=0
      Select FNSI
      Seek Main->Lic_Schet
      IF Found()
         aLastPok:=GetMaxPok(Main->Lic_Schet,Month(new_date),.F.)
                LgCount:=0
         For I=1 To Len(LgotaString)
             IF AtNum(Substr(LgotaString,I,1),Fnsi->Gos)!=0
                LgCount:=LgCount+1
             ENDIF
         Next
         IF LgCount>0.and.aLastPok[2]<MaxDate
//                      IF Year(MaxDate)#Year(aLastPok[2])
//                               IF Year(MaxDate)-Year(aLastPok[2])==1
//                               ELSE
//                               ENDIF
//                ELSE
                         MonthDolg:=Month(MaxDate)-Month(aLastPok[2])-1
//                ENDIF
                                                IF MonthDolg>0
                 FWrite(Desc," │"+Str(KA,8)+"│"+FNSI->FAM+"│"+;
                           Padr(AllTrim(GetcUl(FNSI->KUL))+" "+;
                                 AllTrim(FNSI->Dm)+" "+AllTrim(FNSI->Kv),35," ")+"│"+;
                               Str(aLastPok[1],8)+"│"+Str(MonthDolg,10)+"│"+Dtoc(aLastPok[2])+" "+FNSI->GOS+CrLf)

            ENDIF
         ENDIF
      ENDIF
      Select Main
      SKIP
   ENDDO
   FWrite(Desc," └────────┴────────────────────┴───────────────────────────────────┴────────┴──────────┘"+CrLf)
   FClose(Desc)
   oProgress:destroy()                                                                                                                                                                                  // Progress Bar Destroy
   oDlg:Destroy()
ENDIF
ClearBuffer()
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL





Function SubsidiiChMonthDolg()
Local Sel:=select(),Rec:=RecNo(),Scr:=Win_Save(),LgotaString:="БВЖЗИКЛПРУФХ",nDolg:=0
Local MaxDate:=new_date,CrLf:=Chr(13)+Chr(10),Desc,aLastPok,LgCount:=0,MonthDolg:=0,FoundPay:=.F.
//MaxDate:=GetVal("Дата максимальной оплаты для поиска ",MaxDate,CTOD("01.01.1999"))
MaxDate:=New_Date-90
IF MaxDate#CTOD("01.01.1999")
//   Obrabot("Выбор потребителей")
         oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
         aSizeDesktop  := AppDesktop():currentSize()
         oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
         oDlg:title    := "Выбор потребителей не плативших с " +DTOC(MaxDate)
         oDlg:SysMenu   := .F.
         oDlg:Configure()
         oDlg:Show()
         aSizeDesktop  := oDlg:currentSize()
         aPos                                   := oDlg:CurrentPos()
         oProgress              := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

         oProgress:create()
         oProgress:minimum := 1
         oProgress:maximum := RecCount()
   Desc:=FCreate(dDir+ReportFile)
   FWrite(Desc," Выбор потребителей, не плативших с "+DTOC(MaxDate)+CrLf)
   FWrite(Desc," ┌────────┬────────────────────┬───────────────────────────────────┬────────┬──────────┐"+CrLf)
   FWrite(Desc," │ Договор│    Потребитель     │              Адрес                │Показан.│   Долг   │"+CrLf)
   FWrite(Desc," ├────────┼────────────────────┼───────────────────────────────────┼────────┼──────────┤"+CrLf)

	 load("109",SCHET_SHARE+"Subsidii.dbf",,,  .f.)
   oProgress:maximum := RecCount()
//   temp_=39/reccount()
//   kol_kl=0
   Go Top
   Do While !EOF()
          oProgress:increment()                                                                                                                                                         // Progress Bar Increment
//    Kol_Kl=Kol_Kl+Temp_
//    ColorWin(12,21,12,21+kol_kl,'n/n')
		FoundPay:=.T.
    NotFound:=.F.
		Select Main
		Seek Val(Subsidii->Glava)
		IF Found()
      MonthDolg:=0
      nDolg=GetDolg(Main->Lic_Schet,Month(New_Date))
      Select FNSI
      Seek Main->Lic_Schet
      IF Found()
         aLastPok:=GetMaxPok(Main->Lic_Schet,Month(new_date),.F.)
                LgCount:=0
/*                	
         For I=1 To Len(LgotaString)
             IF AtNum(Substr(LgotaString,I,1),Fnsi->Gos)!=0
                LgCount:=LgCount+1
             ENDIF
         Next
*/
		     LgCount:=1
         IF LgCount>0.and.aLastPok[2]<MaxDate.and.nDolg>0
             MonthDolg:=Month(MaxDate)-Month(aLastPok[2])-1
             IF MonthDolg>0
                 FWrite(Desc," │"+Str(KA,8)+"│"+FNSI->FAM+"│"+;
                        Padr(AllTrim(GetcUl(FNSI->KUL))+" "+;
                        AllTrim(FNSI->Dm)+" "+AllTrim(FNSI->Kv),35," ")+"│"+;
                        Str(aLastPok[1],8)+"│"+Str(nDolg,10)+"│"+CrLf)
//                        " "+FNSI->GOS+CrLf)
								FoundPay:=.F.
             ENDIF
         ENDIF
     	ENDIF
     ELSE
     	NotFound:=.T.
     ENDIF
     Select Subsidii
     IF RecLock()
     		Replace Pay With FoundPay
     		IF NotFound
     			Replace Dop With ""
     		ELSE
     			Replace Dop With DTOC(aLastPok[2])
     		ENDIF
     		UNLOCK
     ENDIF
     SKIP
   ENDDO
   Select Subsidii
   Close
   FWrite(Desc," └────────┴────────────────────┴───────────────────────────────────┴────────┴──────────┘"+CrLf)
   FClose(Desc)
   oProgress:destroy()                                                                                                                                                                                  // Progress Bar Destroy
   oDlg:Destroy()
ENDIF
ClearBuffer()
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL







Function YearDolg(Type)
Local Sel:=select(),rec:=RecNo(),Desc,CrLf:=Chr(13)+Chr(10),I:=0
Local oDlg,aSizeDeskTop,aPos,oProgress,aSaldo:={0,0},IsCalck:=.F.

Select Main
Go Top
oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := AppDesktop():currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := IF(Type==1,"Дебиторская","Кредиторская")+" задолженность за год"
oDlg:SysMenu    := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos                                    := oDlg:CurrentPos()
oProgress               := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
Desc:=FCreate(DDir+ReportFile)
FWrite(Desc,IF(Type==1,"Дебиторская","Кредиторская")+" задолженность за год"+CrLf)
FWrite(Desc,"┌──────┬──────────────────────────────┬────────────┬────────────┬────────────┬────────────┬───┐"+CrLf)
FWrite(Desc,"│ Л/с  │ Потребитель                  │Сальдо 01/01│ Начислено  │  Оплачено  │Сальдо 31/12│Мес│"+CrLf)
FWrite(Desc,"├──────┼──────────────────────────────┼────────────┼────────────┼────────────┼────────────┼───┤"+CrLf)
Do While !EOF()
   oProgress:increment()                                                                                                                                                                // Progress Bar Increment
   Select Obormot
   Seek Main->Lic_Schet
   aSaldo:={0,0,0,0,0}
   IF Found()
                IsCalck:=.F.
                DO Case
                         Case Type==1
                              aSaldo[1]:=Obormot->Debet12
                         Case Type==2
                              aSaldo[1]:=Obormot->Kredit12
                ENDCASE
                aSaldo[2]:=GetSaldo(Main->Lic_Schet,12)
                For i=12 to 1 Step -1
                        DO Case
                                 Case Type==1
                                        IF GetSaldo(Main->Lic_Schet,i)<0
                                                        aSaldo[5]:=aSaldo[5]+1
                                        ELSE
                                                i:=1
                                        ENDIF
                                Case Type==2
                                        IF GetSaldo(Main->Lic_Schet,i)>=0
                                                        aSaldo[5]:=aSaldo[5]+1
                                        ELSE
                                                i:=1
                                        ENDIF
                        ENDCASE
                Next
                IF Type==1.and.aSaldo[1]>0
                   IsCalck:=.T.
                ELSEIF Type==2.and.aSaldo[1]>0
                    IsCalck:=.T.
                ENDIF
                IF IsCalck
                         aSaldo[1]:=GetSaldo(Main->Lic_Schet,13)
                   For i=1 to 12
                       aSaldo[3]=aSaldo[3]+GetSum(Main->Lic_Schet,i)
                       aSaldo[4]=aSaldo[4]+CalckPay(i,Main->Lic_Schet,.f.)
                   Next
//                   aSaldo[3]=aSaldo[3]+Round(aSaldo[3]*Schet_Nds/100,Decimal)
                   FWrite(Desc,"│"+str(Main->Lic_Schet,6)+"│"+Substr(Main->Potrebitel,1,30)+;
                          Space(30-Len(Substr(Main->Potrebitel,1,30)))+"│"+Str(aSaldo[1],12,2)+;
                          "│"+Str(aSaldo[3],12,2)+"│"+Str(aSaldo[4],12,2)+"│"+;
                          Str(aSaldo[2],12,2)+"│ "+Str(aSaldo[5],2,0)+"│"+CrLf)
                ENDIF
                        Select Main
         ENDIF
         SKIP
ENDDO
FWrite(Desc,"└──────┴──────────────────────────────┴────────────┴────────────┴────────────┴────────────┴───┘"+CrLf)
FClose(Desc)
Select(Sel)
Go Rec
oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
oDlg:Destroy()
Return NIL
