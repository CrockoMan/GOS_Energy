function plombirovka()
Local MyRecNo,Temp_,Kol_Kl
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel
Private bufer,name,old_edit1,_Code
t1=0
l1=0
b1=0
r1=0
old_sel1=select()
rec_buf1=recno()
ord_buf1=indexord()
buff1=savescreen(0,0,24,79)
color_buf1=setcolor()
   if (.not. file(schet_Share+'plomba.dbf')) .or. (.not. file(schet_share+'plomba.ntx'))
           sign(2)
           set color to (color_buf1)
           restscreen(0,0,24,79,buff1)
           return NIL
   else
              Select 43
              Zap

              Select 42
              go top
   endif
   old_edit1=edit
   set color to
colorwin(15,2,24,22,'n+/n')
set color to &GetColor
_CodE:='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
Seek _Code
IF Found()
   Do While AllTrim(Kod)=AllTrim(_CodE)
      MyRecNo:=RecNo()
      Select 43
      Append Blank
      Replace RecNum  With MyRecNo
      Replace Kod     With Plomba->Kod
      Replace DateOn  With Plomba->DateOn
      Replace DateOff With Plomba->DateOff
      Replace NameOn  With Plomba->NameOn
      Replace NameOff With Plomba->NameOff
      Replace Zagim   With Plomba->Zagim
      Replace PhaseA  With Plomba->PhaseA
      Replace PhaseB  With Plomba->PhaseB
      Replace PhaseC  With Plomba->PhaseC
      Replace Panel   With Plomba->Panel
      Replace Lenta   With Plomba->Lenta
      Replace VvodName    With Plomba->VvodName
      Replace VvodPlomba  With Plomba->VvodPlomba
      Replace Operator1   With Plomba->Operator1
      Replace WriteDate1  With Plomba->WriteDate1
      Replace Operator2   With Plomba->Operator2
      Replace WriteDate2  With Plomba->WriteDate2
      Replace Licevoj     With Plomba->Licevoj
      Replace NewKoeff    With Plomba->NewKoeff
      Select 42
      Skip
   EndDO
ENDIF
select 43
go top
declare zgl[1]
declare fil[1]
nm1=loarr('zgl','Опломбировано')
nm2=loarr('fil','DateOn')
inp='000000000000'
************ Begin make box
t1=14
l1=1
b1=23
r1=21
*************  End make
fsbrowse(3,3,7,77,'fil','zgl',inp,urov,kl)
obrabot("Запись данных о пломбировке")
temp_=39/RecCount()
kol_kl=0
go top
Do While !EOF()
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
   IF !Deleted()
      Select 42
      IF !Empty(PlLocal->RecNum)
         Go PlLocal->RecNum
      ELSE
         IF NetAppend()
            UNLOCK
         ENDIF
      ENDIF
      IF RecLock()
         Replace Kod     With PlLocal->Kod
         Replace DateOn  With PlLocal->DateOn
         Replace DateOff With PlLocal->DateOff
         Replace NameOn  With PlLocal->NameOn
         Replace NameOff With PlLocal->NameOff
         Replace Zagim   With PlLocal->Zagim
         Replace PhaseA  With PlLocal->PhaseA
         Replace PhaseB  With PlLocal->PhaseB
         Replace PhaseC  With PlLocal->PhaseC
         Replace Lenta   With PlLocal->Lenta
         Replace PANEL   With PlLocal->PANEL
         Replace VvodName   With PlLocal->VvodName
         Replace VvodPlomba With PlLocal->VvodPlomba
         Replace Operator1  With PlLocal->Operator1
         Replace WriteDate1 With PlLocal->WriteDate1
         Replace Operator2  With PlLocal->Operator2
         Replace WriteDate2 With PlLocal->WriteDate2
         Replace Licevoj    With PlLocal->Licevoj
         Replace NewKoeff   With PlLocal->NewKoeff
         UNLOCK
      ENDIF
   ENDIF
   Select 43
   Skip
EndDO
Select 42
Go Top
select(old_sel1)
set color to (color_buf1)
set order to ord_buf1
go rec_buf1
restscreen(0,0,24,79,buff1)
edit=old_edit1
Return Nil




function ShowPlomba(IsEdit)
Local OldScr:=Win_Save(),OldClr:=SetColor(),Sel:=Select()
Private IsDelRec:=.F.
IsEdit:=IF(IsEdit==NIL,0,IsEdit)
Set Color to &GetColor
@ 14,26 SAY "┌───────────────────────────────────────────────────╖"
@ 15,26 SAY "│ Установлен             Ф.И.О.                     ║"
@ 16,26 SAY "│ Cнят  "+space(44)+"║"
@ 17,26 SAY "│ Крышка зажимов              Лента                 ║"
@ 18,26 SAY "│ Трансформатор тока фазы А            │  Коэффиц.  ║"
@ 19,26 SAY "│ Трансформатор тока фазы B            │ трансформ. ║"
@ 20,26 SAY "│ Трансформатор тока фазы C            │            ║"
@ 21,26 SAY "│ Вводное устройство"+space(32)+"║"
@ 22,26 SAY "│ Номерная пломба                ФП                 ║"
@ 23,26 SAY "╘═══════════════════════════════════════════════════╝"

@ 15,40 SAY DATEON
@ 15,58 SAY NAMEON
@ 16,38 SAY DATEOFF
@ 16,57 SAY NAMEOFF
@ 17,44 SAY IF(!Empty(ZAGIM),Zagim,"")
@ 18,55 SAY IF(!Empty(PHASEA),PhaseA,"")
@ 19,55 SAY IF(!Empty(PHASEB),PhaseB,"")
@ 20,55 SAY IF(!Empty(PHASEC),PhaseC,"")
@ 17,62 SAY IF(!Empty(Lenta),Lenta,"")
@ 20,70 SAY IF(!Empty(NewKoeff),NewKoeff,"")
@ 21,47 SAY VVODNAME
@ 22,47 SAY IF(!Empty(VVODPLOMBA),VvodPlomba,"")
@ 22,62 SAY IF(!Empty(PANEL),PANEL,"")


SET Key 32 TO HelpWrite
set cursor on
Do Case
   Case IsEdit=2
        Do While LastKey()#27
           @ 16,38 GET DATEOFF
           @ 16,57 GET NAMEOFF
           Read
        EndDo
   Case IsEdit=1
        Do While LastKey()#27
           @ 15,40 GET DATEON
           @ 15,58 GET NAMEON
           @ 17,44 GET ZAGIM  Valid SPlNum(Zagim ,1)
           @ 18,55 GET PHASEA Valid SPlNum(PhaseA,1)
           @ 19,55 GET PHASEB Valid SPlNum(PhaseB,1)
           @ 20,55 GET PHASEC Valid SPlNum(PhaseC,1)
           @ 17,62 GET Lenta  Valid SPlNum(Lenta ,1)
           @ 20,70 GET NewKoeff
           @ 21,47 GET VVODNAME
           @ 22,47 GET VVODPLOMBA Valid SPlNum(VvodPlomba,1)
           @ 22,62 GET PANEL Valid SPlNum(VvodPlomba,1)
           Read
//           Select Licevoj2
//           Replace God_Prow With Alltrim(Str(Year(PlLocal->DateOn)))
//           Select(Sel)
        EndDo
        IF IsDelRec
           UnLock
           Go RecNo()
           IF RecLock()
              Delete
              UnLock
           ENDIF
           Skip
           Ret_Val:=2
        EndIf
   Case IsEdit=3
        IF RecLock()
           Do While LastKey()#27
              @ 15,40 GET DATEON
              @ 15,58 GET NAMEON
              @ 16,38 GET DATEOFF
              @ 16,57 GET NAMEOFF
              @ 17,44 GET ZAGIM
              @ 18,55 GET PHASEA
              @ 19,55 GET PHASEB
              @ 20,55 GET PHASEC
           		@ 17,62 GET Lenta 
              @ 20,70 GET NewKoeff
              @ 21,47 GET VVODNAME
              @ 22,47 GET VVODPLOMBA
              @ 22,62 GET PANEL
              Read
           EndDo
           UNLOCK
           Select Licevoj2
           Replace God_Prow With Alltrim(Str(Year(PlLocal->DateOn)))
           Select(Sel)
        ENDIF
ENDCASE
Clear Typeahead
SET Key 32 TO
Prev_Rec:=0
Ret_Val:=2
set cursor off
Return IsDelRec




Function SplNum(Val,IsShowMess)
Local Value:=.T.,Sel:=Select(),Rec:=RecNo(),Ord,I
Return .t.
IF !Empty(Val)
   Select 42
   Ord:=IndexOrd()
   For I=2 to 7
       Go Top
       Set Order to I
       Seek Val
       IF Found()
          Value:=.F.
          IF IsShowMess==1
             Al_Box({"Такой номер пломбы уже есть л/с N"+AllTrim(Str(Licevoj))})
          ENDIF
          Exit
       EndIf
   Next
   Set Order To Ord
EndIf
IsDelRec:=IF(Value==.F.,.T.,.F.)
Select(Sel)
Go Rec
Return Value





Function InstallPlomba()
Local IsDeleteRec:=.F.,Sel:=Select()
Select 43
//IF !Empty(Operator1).and.!Empty(WriteDate1)
//   Al_Box({"Ввод данных уже был осуществлен ранее"})
//   Return NIL
//ENDIF
IF FoundInstPlomba()
   Al_Box({"Данные о пломбировке ввести не возможно","есть установленная пломба на счетчике "+alltrim(Licevoj2->schetchik)})
   Return NIL
ENDIF
IF Al_Box({"Ввести данные об установке пломбы для счетчика "+alltrim(Licevoj2->schetchik)},2)==1
   IF NetAppend()
      Replace Licevoj with Licevoj2->Lic_Sch
      Replace kod with '('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
      Replace WriteDate1 With new_date
      Replace Operator1 With Station
      ShowPlomba(1)
      Ret_Val:=2
      UNLOCK
   ENDIF
ENDIF
Select(Sel)
Return NIL





Function FoundInstPlomba()
Local Rec:=RecNo(),FoundInstPlomba:=.F.
go top
_CodE:='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
seek _CodE
IF Found()
   DO WHILE AllTrim(Kod)==_CodE
      LastRec:=RecNo()
      skip
   ENDDO
   Go LastRec
   IF !Empty(Operator2).and.!Empty(WriteDate2)
      FoundInstPlomba:=.F.
   ELSE
      FoundInstPlomba:=.T.
   ENDIF
ENDIF
Go Rec
//Ret_val:=2
Return FoundInstPlomba



Function RemovePlomba()
IF !Empty(Operator2).and.!Empty(WriteDate2)
   Al_Box({"Ввод данных о снятии уже был осуществлен ранее"})
   Return NIL
ENDIF
IF Al_Box({"Ввести данные о снятии пломбы для счетчика "+alltrim(Licevoj2->schetchik)},2)==1
   IF RecLock()
      Replace WriteDate2 With new_date
      Replace Operator2 With Station
      ShowPlomba(2)
      Ret_Val:=2
      UNLOCK
   ENDIF
ENDIF
Return NIL



Function SayPlombaNumber()
Local String:="",Sel:=Select(),Poisk,LastRec:=0,OldOrd
select 42
OldOrd:=IndexOrd()
Set Order To 1
go top
Poisk:='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
seek Poisk
IF Found()
   DO WHILE AllTrim(Kod)==Poisk
      LastRec:=RecNo()
      Skip
   ENDDO
   IF LastRec!=0
      Go LastRec
      IF !Empty(DateOff)
         String:="Пломба снята "+DToc(DateOff)
         PlombaIsOut:=.T.
         PlombaIsPresent:=.F.
      ELSE
           String:="Опломбирован "+DToC(DateOn)
           PlombaIsOut:=.F.
           PlombaIsPresent:=.T.
      ENDIF
   ELSE
      PlombaIsOut:=.F.
      PlombaIsPresent:=.F.
   ENDIF
ELSE
   String:=IF(Val(Licevoj2->Schetchik)>0,"Не опломбирован"," ")
   PlombaIsOut:=.F.
   PlombaIsPresent:=.F.
ENDIF
Set Order To OldOrd
Go RecNo()
Select(Sel)
Return String






Function SetPlomba()
Local Sel:=Select(),Rec:=RecNo(),MinNumber:=0,MaxNumber:=0,Desc,CrLf:=Chr(13)+Chr(10),cTxt:="",i,j
Local oDlg,aSizeDeskTop,aPos,oProgress,Clr:=SetColor(),Scr:=Win_Save()
Local cPlombaSet:={},nCount:=0
Set Color to &GetColor
ColorWin(15,19,18,58,"n+/n")
@ 14,18 SAY "┌──────────────────────────────────────╖"
@ 15,18 SAY "│ Начальный номер пломбы               ║"
@ 16,18 SAY "│ Конечный  номер пломбы               ║"
@ 17,18 SAY "╘══════════════════════════════════════╝"
@ 15,45 Get MinNumber picture "@K9999999"
@ 16,45 Get MaxNumber picture "@K9999999"
Set Cursor  On
Set Confirm On
Read
Set Cursor  Off
Set Confirm Off
SetColor(Clr)
Win_Rest(Scr)
IF LastKey()#27
         cPlombaSet:={"Крышка зажимов ",;
                      "Фаза А         ",;
                      "Фаза B         ",;
                      "Фаза С         ",;
                      "Вводное устр-во",;
                      "Фальшпанель    ",;
                      "Лента          "}
         oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
         aSizeDesktop  := oMainWindow:currentSize()
         oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
         oDlg:title    := "Выбор пломб с номерами "+AllTrim(Str(MinNumber))+"-"+AllTrim(Str(MaxNumber))
         oDlg:SysMenu   := .F.
         oDlg:Configure()
         oDlg:Show()
         aSizeDesktop  := oDlg:currentSize()
         aPos                                   := oDlg:CurrentPos()
         oProgress              := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

         Select Plomba
         oProgress:create()
         oProgress:minimum := 1
         oProgress:maximum := RecCount()
				 cTxt:=cTxt+"┌─────────┬────────────────────────────────────────┬───────────────┬──────────┬───────────────┬────────────────────┐"+CrLf
				 cTxt:=cTxt+"│ Договор │           Потребитель                  │  N  Счетчика  │  Пломба  │ Опломбировано │   Электромонтер    │"+CrLf
				 cTxt:=cTxt+"├─────────┼────────────────────────────────────────┼───────────────┼──────────┼───────────────┼────────────────────┤"+CrLf
         Go top
         Do While !EOF()
            oProgress:increment()                                                                                                                                                          // Progress Bar Increment
            For j=MinNumber To MaxNumber
            	I=0
            	IF Zagim==j
            		 I=1
            	ENDIF
            	IF PhaseA==J
            		 I=2
            	ENDIF
            	IF PhaseB==J
            		 I=3
            	ENDIF
            	IF PhaseC==J
            		 I=4
            	ENDIF
            	IF VVodPlomba==J
            		 I=5
            	ENDIF
            	IF Panel==J
            		 I=6
            	ENDIF
            	IF Lenta==J
            		 I=7
            	ENDIF
                 IF I>0
                    Select Main
                    Seek Plomba->Licevoj
                    IF Found()
                       cTxt:=cTxt+"│"+Str(Plomba->Licevoj,9)+"│"+;
                             Substr(DelString(AllTrim(Main->Potrebitel),"ИНН")+Space(40),1,40)+"│"+;
                             Substr(Plomba->Kod+Space(15),AtNum(")",Plomba->Kod,1)+1,15)+;
                             "│"+Str(j,10)+"│"+cPlombaSet[i]+"│"+Plomba->NameOn+"│"+CrLf
                       nCount:=nCount+1
                    ELSE
                    	cTxt:=cTxt+"│"+Str(Plomba->Licevoj,9)+"│"+Space(40)+"│"+;
                             Substr(Plomba->Kod+Space(15),AtNum(")",Plomba->Kod,1)+1,15)+;
                             "│"+Str(j,10)+"│"+cPlombaSet[i]+"│"+Plomba->NameOn+"│"+CrLf                    		    
                    ENDIF
                 ENDIF
            		 Select Plomba
         		Next
            Select Plomba
         		Skip
         ENDDO
				 cTxt:=cTxt+"└─────────┴────────────────────────────────────────┴───────────────┴──────────┴───────────────┴────────────────────┘"+CrLf
				 cTxt:=cTxt+" "+AllTrim(Str(nCount,10))+CrLf
   			 oProgress:destroy()                                                                                                                                                                                  // Progress Bar Destroy
   			 oDlg:Destroy()
         Set Order To 1
				 Desc:=Fcreate(dDir+ReportFile)
				 FWrite(Desc,cTxt)
				 FClose(Desc)
ENDIF
Select(Sel)
Go Rec
Return NIL