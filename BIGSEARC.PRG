#include "My.Ch"
#include "inkey.ch"
#include "MemoEdit.Ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "Appevent.ch"
#include "Font.ch"


Static IsFiltered:=.F.
Static Potr,Adr,Podkl,TipSch,Dolg:=0.00,Object,NumMon,Dog,TOKENS:=";,"
Static BankSchet,nsLicStart:=1,nsLicEnd:=99999,IsSayInfo:=.F.




Function SayInfo(cText)
   LOCAL nEvent, mp1, mp2,aSizeDeskTop:={},PresentLic:=Main->Lic_Schet
   LOCAL oDlg, oXbp, drawingArea, aEditControls := {}

   oDlg := XbpDialog():new( AppDesktop(), SetAppWindow(),,,,.F.)
	 aSizeDesktop  := oMainWindow:currentSize()
   oDlg:create(oMainWindow ,,{aSizeDeskTop[1]-9.3*Len(cText),aSizeDeskTop[2]-74}, {9.3*Len(cText),39},,.F.)
	 oDlg:SysMenu	 := .F.
	 oDlg:TitleBar := .F.
	 oDlg:border	 := XBPDLG_NO_BORDER
	 oDlg:configure()
//   oDlg := XbpDialog():new( AppDesktop(), , {720,742}, {187,79}, , .F.)

   drawingArea := oDlg:drawingArea
   drawingArea:setColorBG( GRA_CLR_YELLOW     )
   drawingArea:setColorFG( GRA_CLR_BLACK      )
   drawingArea:setFontCompoundName( "12.System Bold" )

   oXbp := XbpStatic():new( drawingArea, , {12,12}, {156,24} )
   oXbp:autoSize := .T.
   oXbp:caption := cText
   oXbp:clipSiblings := .T.
   oXbp:options := XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_RIGHT
   oXbp:create()
   oDlg:show()
   	
   IsSayInfo:=.T.
   oSayInfoDlg:=oDlg
Return NIL


Function BigSearch()
LOCAL old_col1:=setcolor(),screen:=win_save(),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1,sel:=select(),rec:=recno()
local first:=.T.,ProcessWorked:="",oDlg
spisok:={" По номеру счетчика    ",;
         " По номеру телефона    ",;
         " По адресу             ",;
         " По наименованию       ",;
         " По подключению ",;
         " Множественные условия   ",;
         " Потребители госсектора",;
         " Потребители промсектора",;
         " Потребители с тарифом",;
         " Удалить из списка",;
         " Окно без поиска",;
         "──────────────────────────",;
         " Выход                 "}
do while pos>0
        IF oSayInfoDlg!=NIL
           Spisok[Len(Spisok)-2]:="√Окно без поиска"
           is_choice:={.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.F.,.t.}
        ELSE
           Spisok[Len(Spisok)-2]:=" Окно без поиска"
           is_choice:={.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.F.,.f.,.F.,.t.}
        ENDIF
        ProcessWorked:=AllTrim(ReadProcess(1))
        IF !Empty(ProcessWorked).and.ProcessWorked==AllTrim(Station)
           Spisok[Len(Spisok)-2]:="√Окно без поиска"
           is_choice:={.t.,.t.,.t.,.t.,.t.,.t.,.F.,.T.,.F.,.t.}
        ENDIF
        choice=vert_menu(spisok,"Расширенный поиск",is_choice,9,28,pos,'n/w,n/g,,,r/w',.F.)
        pos=choice
        wid=choice
        widsav:=wid
        do case
           case wid=1
                if bigsear(1)
                   pos:=0
                   exit
                else
                     al_box({"Поиск завершен неудачно"})
                     Ret_Val:=2
                endif
           case wid=2
                if bigsear(2)
                   pos:=0
                   exit
                else
                     al_box({"Поиск завершен неудачно"})
                endif
           case wid=3
                if bigsear(3)
                   pos:=0
                   exit
                else
                     al_box({"Поиск завершен неудачно"})
                endif
           case wid=4
                if bigsear(4)
                   pos:=0
                   exit
                else
                     al_box({"Поиск завершен неудачно"})
                endif
           case wid=5
                al_box({"Sorry, under construction"})
           case wid=6
                ProcessWorked:=ReadProcess(1)
                IF !Empty(ProcessWorked).and.ProcessWorked!=Station
                   Al_Box({"Поиск по множественному условию производит "+AllTrim(ProcessWorked)})
                ELSE
//                   WriteProcess(1,SET_ON)
                   IF GetManyFilter()
                   		IF oSayInfoDlg==NIL
                   				SayInfo("Фильтрация включена")
                   		ENDIF
//                      WriteProcess(1,SET_OFF)
                      Select Main
                      Close
                      Select BSMain
                      Close
                      load('88',DDir+'BSmain.dbf',DDir+'BS1.ntx',DDir+'BS2.ntx',,,,,,"Main")
                      
                      pos:=0
                      exit
                   ELSE
                        al_box({"Поиск завершен неудачно"})
                        IsFiltered:=.F.
//                        WriteProcess(1,SET_OFF)
                   ENDIF
                ENDIF
           CASE wid=7
           			WritePromSector(.T.)
                IsFiltered:=.T.
                      Select Main
                      Close
                      Select BSMain
                      Close
                      load('88',DDir+'BSmain.dbf',DDir+'BS1.ntx',DDir+'BS2.ntx',,,,,,"Main")
                      
                      pos:=0
                      exit
                IF oSayInfoDlg==NIL
                	 SayInfo("Фильтрация включена")
                ENDIF
           			
           CASE wid=8
           			WritePromSector(.F.)
                IsFiltered:=.T.
                      Select Main
                      Close
                      Select BSMain
                      Close
                      load('88',DDir+'BSmain.dbf',DDir+'BS1.ntx',DDir+'BS2.ntx',,,,,,"Main")
                      
                      pos:=0
                      exit
                IF oSayInfoDlg==NIL
                	 SayInfo("Фильтрация включена")
                ENDIF
           CASE wid=9
           			WriteTarif()
//                IF oSayInfoDlg==NIL
//                	 SayInfo("Фильтрация включена")
//                ENDIF
           case wid=10
                IF RecLock()
                   Delete
                   UNLOCK
                   RecNo:=-1
                   Ret_val:=2
                   Al_Box({" Потребитель исключен из списка "})
                ENDIF
           case wid=11
								PresentLic:=Main->Lic_Schet
                IsFiltered:=.F.
                Set Filter To
                Go Recno()
                Select Main
                Close
                load('89',DDir+'BSmain.dbf',DDir+'BS1.ntx',DDir+'BS2.ntx')
								load('88',SCHET_SHARE+'main.dbf',SCHET_SHARE+'lic.ntx',SCHET_SHARE+'potrebit.ntx',.f.)
								Select Main
								Seek PresentLic
								IF .Not.Found()
									Go Top
								ENDIF
								IF oSayInfoDlg!=NIL
									oSayInfoDlg:Destroy()
									IsSayInfo:=.F.
									oSayInfoDlg:=NIL
								ENDIF

                Ret_Val=2
                Exit
           otherwise
                   exit
        endcase
enddo
IsFiltered:=IF(Pos==0.and.lastkey()!=27,.T.,IsFiltered)
M->prev_rec=-1
win_rest(screen)
setcolor(old_col1)
Return NIL





FUNCTION WritePromSector(Par)
LOCAL oDlg,aSizeDeskTop,aPos,oProgress,RecCount:=0,nRec:=0,RecNo:=RecNo()
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


IF IsFiltered
	 Close
	 load('89',DDir+'BSmain.dbf',DDir+'BS1.ntx',DDir+'BS2.ntx')
	 load('88',SCHET_SHARE+'main.dbf',SCHET_SHARE+'lic.ntx',SCHET_SHARE+'potrebit.ntx',.f.)
	 Go Top
ELSE
	 SayInfo("Фильтрация включена")		 
ENDIF
Select 89
Zap
Select Main
Go TOp
//DO While !EOF()
//	 RecCount:=RecCount+1
//	 SKIP
//ENDDO
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()

DO WHILE .NOT.EOF()
 	 	oProgress:increment()																				// Progress Bar Increment
 	 	IsWrite:=.F.
 	 	DO CASE
 	 		 CASE AtNum("ПРЕДПРИНИМАТЕЛЬ",UPPER(Main->POTREBITEL))>0
 	 					IsWrite:=.F.
 	 		 CASE AtNum("СОБСТВЕННИК",UPPER(Main->POTREBITEL))>0
 	 					IsWrite:=.F.
 	 		 CASE AtNum("ЗАСТРОЙЩИК",UPPER(Main->POTREBITEL))>0
 	 					IsWrite:=.F.
 	 		 CASE Main->Lic_Schet<99999 .and. Par==.T. .and. Main->Kniga_old # 7
 	 		 			IsWrite:=.T.
 	 		 CASE Main->Lic_Schet<99999 .and. Par==.F. .and. Main->Kniga_old = 7
 	 		 			IsWrite:=.T.
 	 	ENDCASE
 	 	IF IsWrite
 	 			 nRec:=RecNo()
         Select BSMain
         Append Blank
         Select Main
         Replace BSMain->Recno With nRec
//--------------------------------------------------------
				 nPos:=1
         DO While nPos#0
            FName:=Fieldname(nPos)
            IF .not.empty(FName)
               replace BSMain->&FName with Main->&FName
            	 nPos++
            ELSE
               nPos:=0
            ENDIF
         ENDDO
         Select Main
 	 	ENDIF
 	 	SKIP
ENDDO
Go RecNo
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
Return NIL





Function WriteTarif
Local SearchTar:=0000.0000,Poisk:="",cStr1:="",Desc,cStr:="",RecNo:=RecNo(),Count:={0,0}
LOCAL oDlg,aSizeDeskTop,aPos,oProgress,RecCount:=0,nRec:=0
SearchTar:=GetVal("Введите тариф для поиска потребителей  ",SearchTar,0)	
IF SearchTar>0.and.IsFiltered
		cStr:="Потребители с тарифом "+Str(SearchTar,9,4)+Chr(13)+Chr(10)
		CStr:=CStr+"-----------------------------------------------------------------"+Chr(13)+Chr(10)
		CStr:=Cstr+"|  Л/С |                  Потребитель                       |Кол|"+Chr(13)+Chr(10)
		CStr:=CStr+"-----------------------------------------------------------------"+Chr(13)+Chr(10)
			
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

		DO WHILE .NOT.EOF()
 	 			oProgress:increment()																				// Progress Bar Increment
	 	 		IsWrite:=.F.
	 	 		cStr1:=" "
	 	 			Count:={0,0}
	 	 		Select Licevoj
	 	 		Seek Main->Lic_Schet
	 	 		Do While Main->Lic_Schet==Licevoj->Lic_Sch
   				 Poisk:="("+alltrim(str(Main->Lic_Schet))+")"+Alltrim(Licevoj->Schetchik)
	 	 			 Select 2
	 	 			 Seek Poisk
	 	 			 IF Found()
	 	 			 		Count[2]:=Count[2]+1
	 	 			 		DO Case
	 	 			 			CASE Tarif==SearchTar
	 	 			 			 		 IsWrite:=.T.
	 	 			 			 		 Count[1]:=Count[1]+1
	 	 			 			CASE Tarif>0
	 	 								 cStr1:=" ? "
	 	 			 		ENDCASE
	 	 			 ENDIF
	 	 			 Select Licevoj
	 	 			 SKIP
	 	 		ENDDO
	 	 		IF IsWrite
	 	 				cStr:=cStr+"|"+Str(Main->Lic_Schet,6,0)+"|"+Substr(DelString(Main->Potrebitel,"ИНН")+;
	 	 							Space(50)+" "+cStr1,1,52)+"|"+Str(Count[1],3,0)+"|"+Chr(13)+Chr(10)
	 	 		ELSE
	 	 			 Select Main
	 	 			 IF RecLock()
	 	 			 		DbDelete()
	 	 			 		UNLOCK
	 	 			 ENDIF
	 	 		ENDIF
	 	 		Select Main
	 	 		SKIP
	 	ENDDO
		CStr:=CStr+"-----------------------------------------------------------------"+Chr(13)+Chr(10)
		Desc:=FCreate(dDir+ReportFile)
		FWrite(Desc,cStr)
		FClose(Desc)
		oProgress:destroy()																							// Progress Bar Destroy
		oDlg:Destroy()
ENDIF
Go RecNo
Return NIL




function BigSear(TypeSear)
LOCAL IsFound:=.F.,FieldName:="",clr:=setcolor(),scr:=win_save(),rec:=recno()
LOCAL temp_,Kol_Kl,KeySearch:=space(38),PrevNum:=-1
Local oDlg,aSizeDeskTop,aPos,oProgress
Do Case
   Case TypeSear==1
        FieldName:="LICEVOJ->SCHETCHIK"
   Case TypeSear==2
        FieldName:="LICEVOJ->TELEFON"
   Case TypeSear==3
        FieldName:="LICEVOJ->ADRES"
   Case TypeSear==4
        FieldName:="LICEVOJ->POTREB"
EndCase

SET COLOR TO n/w
colorwin(20,11,22,51,"n+/n")
@ 19,10,21,50 BOX "╒═╕│╛═╘│ "
SayRandom('Введи ключ поиска', 19, 12,'n/w')
SET Color To &GetColor
SET CURS On; SET CONF On
@ 20,11 GET KeySearch
READ
SET CURS Off; SET CONF Off
KeySearch:=MYupper(charrem("{}[]-/\(),.",Alltrim(KeySearch)))
IF lastkey()==27
   Clear Typeahead
   setcolor(clr)
   win_rest(scr)
   return .F.
ENDIF
Clear Typeahead
//Obrabot("Расширенный поиск по контексту")
SELECT Licevoj
//Temp_=39/RECCOUNT()
//Kol_Kl=0


oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Обработано" 
oDlg:SysMenu	 := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos						:= oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
// 	 oProgress:increment()																				// Progress Bar Increment
//oProgress:destroy()																							// Progress Bar Destroy
	
GO Top

DO WHILE !Eof()
 	 oProgress:increment()																				// Progress Bar Increment
//   Kol_Kl=Kol_Kl+Temp_
//   ColorWin(12,21,12,21+kol_kl,'n/n')
   IF ATNUM(Keysearch,MYUPPER(ALLTRIM(CHARREM("{}[]-/\(),.",&Fieldname))),1)>0
//      @ 1,0 say Keysearch
//      @ 2,0 say UPPER(ALLTRIM(CHARREM("{}[]-/\(),.",&Fieldname)))
//      @ 3,0 say "= 1"
//      @ 4,0 Say ATNUM(Keysearch,UPPER(ALLTRIM(CHARREM("{}[]-/\(),.",&Fieldname))),1)
//      Inkey(0)
//   IF ATNUM(Keysearch,UPPER(Fieldname),1)>0
      SELECT Main
      SEEK Licevoj->Lic_Sch
      IF Found()
         IF IsShowPos!=.T.
            IF Reclock()
               Replace IsShowPos With .T.
               UNLOCK
            ENDIF
         ENDIF
      ENDIF
      IsFound:=.T.
   else
//      @ 1,0 say Keysearch
//      @ 2,0 say UPPER(ALLTRIM(CHARREM("{}[]-/\(),.",&Fieldname)))
//      @ 3,0 say "= 2"
//      @ 4,0 Say ATNUM(Keysearch,UPPER(ALLTRIM(CHARREM("{}[]-/\(),.",&Fieldname))),1)
//      Inkey(0)
         SELECT Main
         SEEK Licevoj->Lic_Sch
         IF PrevNum!=Main->Lic_Schet
            PrevNum:=Main->Lic_Schet
            IF Found()
               IF ATNUM(Keysearch,MYUPPER(ALLTRIM(Potrebitel)),1)>0
                  IF IsShowPos!=.T.
                     IF Reclock()
                        Replace IsShowPos With .T.
                        Unlock
                        IsFound:=.T.
                     ENDIF
                  ENDIF
               ELSE
                  IF IsShowPos!=.F.
                     IF Reclock()
                        Replace IsShowPos With .F.
                        Unlock
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
   endif
   SELECT Licevoj
   SKIP
ENDDO
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
SELECT Main
IF IsFound
   set filter to IsShowPos==.T.
   go top
ELSE
   go rec
ENDIF
setcolor(clr)
win_rest(scr)
return IsFound







FUNCTION GetManyFilter()
LOCAL Scr:=Win_Save(),Clr:=SetColor(),Sel:=Select(),Recno:=Recno()
LOCAL String:="Debet",Search[8],Counter:=0,Kol_Kl:=0,I,TmpSearch:=.F.
Local AllNot:=.T.,aFields:={},fName,nRec
Local oDlg,aSizeDeskTop,aPos,oProgress,nPos:=1
//LOCAL Potr:=Space(50),Adr:=Space(50),Podkl:=Space(50),TipSch:=Space(50)
//LOCAL Dolg:=0.00,Object:=space(50)
Set Color to &GetColor
ColorWin(8,12,18,73,"n+/n")
IF Potr!=NIL
   Potr:=Potr+Space(100-Len(Potr));      Adr:=Adr+Space(50-Len(Adr))
   Podkl:=Podkl+Space(50-Len(Podkl));    TipSch:=TipSch+Space(50-Len(TipSch))
   Object:=Object+space(50-Len(Object)); Dog:=Dog+Space(10240-Len(Dog))
   BankSchet:=BankSchet+Space(50-Len(BankSchet))
ELSE
   Potr:=Space(100);   Adr:=Space(50);      Podkl:=Space(50)
   TipSch:=Space(50);  Object:=space(50);   NumMon:=Month(New_date)
   Dog:=Space(10240);    BankSchet:=Space(50)
ENDIF
@ 07,11 SAY "┌───────────────────────────────────────────────────────────╖"
@ 08,11 SAY "│ Наименование потребителя"+space(34)+"║"
@ 09,11 SAY "│ Договор"+space(51)+"║"
@ 10,11 SAY "│ Адрес"+space(53)+"║"
@ 11,11 SAY "│ Подключение"+space(47)+"║"
@ 12,11 SAY "│ Тип счетчика"+space(46)+"║"
@ 13,11 SAY "│ Наименование объекта                                      ║"
@ 14,11 SAY "│ Сумма задолженности               Номер месяца            ║"
@ 15,11 SAY "│ Кор.счет банка                                            ║"
@ 16,11 SAY "│ Договор от             До                                 ║"
@ 17,11 SAY "╘═══════════════════════════════════════════════════════════╝"
set cursor on
set confirm on
@ 08,38 get Potr   Picture "@S32"
@ 09,22 get Dog    Picture "@S48"
@ 10,20 get Adr    Picture "@S51"
@ 11,25 get Podkl  Picture "@S45"
@ 12,27 get TipSch Picture "@S43"
@ 13,34 get Object Picture "@S36"
@ 14,33 get Dolg
@ 14,60 get NumMon Picture "99"
@ 15,28 get BankSchet Picture "@S36"
@ 16,24 Get nsLicStart  Picture "@K 999999"
@ 16,39 Get nsLicEnd    Picture "@K 999999"
read
set cursor off
set confirm off
Potr:=Alltrim(MYUpper(Potr))
Adr:=Alltrim(MYUpper(Adr))
Podkl:=Alltrim(MYUpper(Podkl))
TipSch:=Alltrim(MYUpper(TipSch))
Object:=Alltrim(MYUpper(Object))
Dog:=Alltrim(Dog)
BankSchet:=Alltrim(BankSchet)
String:=IF(Dolg>=0,"Debet","Kredit")+Alltrim(Str(NumMon))
Dolg:=IF(Dolg>0,Dolg,-1*Dolg)
IF LastKey()==27
  Clear Typeahead
   IF Al_Box({"Вы хотите отказаться от поиска"},2)==1
      Win_Rest(Scr)
      SetColor(Clr)
      Return .F.
   ENDIF
EndIf
Clear Typeahead
IF .Not.Empty(DbFilter())
   Set Filter To
ENDIF
go top
//obrabot("Поиск по множественному условию")

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Поиск по множественному условию" 
oDlg:SysMenu	 := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos						:= oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
oProgress:create()
oProgress:minimum := 1
// 	 oProgress:increment()																				// Progress Bar Increment
//oProgress:destroy()																							// Progress Bar Destroy
IF IsFiltered
	 Close
	 load('89',DDir+'BSmain.dbf',DDir+'BS1.ntx',DDir+'BS2.ntx')
	 load('88',SCHET_SHARE+'main.dbf',SCHET_SHARE+'lic.ntx',SCHET_SHARE+'potrebit.ntx',.f.)
	 Go Top
ENDIF
Select 89
Zap
Select Main
oProgress:maximum := RecCount()

DO WHILE .NOT.EOF()
 	 oProgress:increment()																				// Progress Bar Increment
//   kol_kl=kol_kl+(39/reccount())
//   colorwin(12,21,12,21+kol_kl,'n/n')
   AFill(Search,.F.)
// Поиск вхождения по наименованию потребителя или по имени вышестоящей орг.
   IF .not.Empty(Potr)
      FOR I=1 TO NumToken(Potr,TOKENS)
          IF Substr(AllTrim(Token(Potr,TOKENS,I)),1,1)=="!"
             IF Atnum(Substr(AllTrim(Token(Potr,TOKENS,I)),2,Len(Potr)-1),Alltrim(MYUpper(Potrebitel)))>0
                Search[1]:=.F.
                EXIT
             ELSE
                Search[1]:=.T.
             ENDIF
          ELSE
             IF Atnum(Token(Potr,TOKENS,I),Alltrim(MYUpper(Potrebitel)))>0
                Search[1]:=.T.
                EXIT
             ENDIF
             IF Atnum(Token(Potr,TOKENS,I),Alltrim(MYUpper(SecondName)))>0
                Search[1]:=.T.
                EXIT
             ENDIF
          ENDIF
      NEXT
   ELSE
      Search[1]:=.T.
   ENDIF
// Поиск вхождения по адресу
   IF .not.Empty(Adr)
//@ 5,0 say "2"
      FOR I=1 TO NumToken(Adr,TOKENS)
          IF Atnum(Token(Adr,TOKENS,I),Alltrim(MYUpper(Adress)))>0
             Search[2]:=.T.
             EXIT
          ENDIF
          SELECT Licevoj
          SEEK Main->Lic_Schet
          DO WHILE Lic_Sch==Main->Lic_Schet
             IF Atnum(Token(Adr,TOKENS,I),Alltrim(MYUpper(Adres)))>0
                Search[2]:=.T.
                EXIT
             ENDIF
             SKIP
          ENDDO
          SELECT Main
      NEXT
   ELSE
      Search[2]:=.T.
   ENDIF
// Поиск вхождения по подключению к фидеру
   IF .not.Empty(Podkl)
//@ 5,1 say "3"
      FOR I=1 TO NumToken(Podkl,TOKENS)
          SELECT Licevoj
          SEEK Main->Lic_Schet
          DO WHILE Lic_Sch==Main->Lic_Schet
             IF Atnum(Token(Podkl,TOKENS,I),MYUpper(Razdel_1))>0
                Search[3]:=.T.
                EXIT
             ENDIF
             IF Atnum(Token(Podkl,TOKENS,I),MYUpper(Razdel_2))>0
                Search[3]:=.T.
                EXIT
             ENDIF
             SKIP
          ENDDO
          SELECT Main
      NEXT
   ELSE
      Search[3]:=.T.
   ENDIF
// Поиск вхoждения по типу счетчика (Licevoj)
   IF .not.Empty(TipSch)
//@ 5,2 say "4"
      FOR I=1 TO NumToken(TipSch,TOKENS)
          SELECT Licevoj
          SEEK Main->Lic_Schet
          DO WHILE Lic_Sch==Main->Lic_Schet
             IF Atnum(Token(TipSch,TOKENS,I),MYUpper(Tip))>0
                Search[4]:=.T.
                EXIT
             ENDIF
             SKIP
          ENDDO
          SELECT Main
      NEXT
   ELSE
      Search[4]:=.T.
   ENDIF
// Поиск вхoждения по наименованию объекта (Licevoj & Main)
   IF .not.Empty(Object)
//@ 5,3 say "5"
      FOR I=1 TO NumToken(Object,TOKENS)
          IF Atnum(Token(Object,TOKENS,I),Alltrim(MYUpper(Potrebitel)))>0
             Search[5]:=.T.
          ELSE
             IF Atnum(Token(Object,TOKENS,I),Alltrim(MYUpper(SecondName)))>0
                Search[5]:=.T.
             ELSE
                SELECT Licevoj
                SEEK Main->Lic_Schet
                DO WHILE Lic_Sch==Main->Lic_Schet
                   IF Atnum(Token(Object,TOKENS,I),Alltrim(MYUpper(Object1)))>0
                      Search[5]:=.T.
                      EXIT
                   ENDIF
                   IF Atnum(Token(Object,TOKENS,I),Alltrim(MYUpper(Object2)))>0
                      Search[5]:=.T.
                      EXIT
                   ENDIF
                   SKIP
                ENDDO
                SELECT Main
             ENDIF
          ENDIF
      NEXT
   ELSE
      Search[5]:=.T.
   ENDIF
// Поиск вхoждения по наличию задолженности
   IF .not.Empty(Dolg).and..Not.Empty(NumMon)
//@ 5,4 say "6"
//@ 10,0 say "!!!"
      SELECT Obormot
      SEEK Main->Lic_Schet
      IF Found()
         IF &String!=0.and.Dolg<=&String
            Search[6]:=.T.
         ELSE
         ENDIF
      ENDIF
      SELECT Main
   ELSE
      Search[6]:=.T.
   ENDIF
   SELECT Main
// Поиск вхoждения по номеру договора
   IF .not.Empty(Dog)
//@ 5,5 say "7"
      FOR I=1 TO NumToken(Dog,TOKENS)
          IF Substr(Token(Dog,TOKENS,I),1,1)=="!"
             LOOP
          ELSEIF Val(Token(Dog,TOKENS,I))==Lic_Schet
             Search[7]:=.T.
             EXIT
          ENDIF
      NEXT
      // Поиск по отрицанию условия
      TmpSearch:=.F.; AllNot:=.T.
      FOR I=1 TO NumToken(Dog,TOKENS)
          IF Substr(Token(Dog,TOKENS,I),1,1)!="!"
             AllNot:=.F.
             Exit
          ENDIF
      NEXT
      FOR I=1 TO NumToken(Dog,TOKENS)
          IF Substr(Token(Dog,TOKENS,I),1,1)=="!"
             IF Val(Substr(Token(Dog,TOKENS,I),2))==Lic_Schet
                TmpSearch:=.T.
                EXIT
             ENDIF
          ENDIF
      NEXT
      DO Case
         Case Search[7].and.!TmpSearch
              Search[7]:=.T.
         Case !Search[7].and.!TmpSearch.and.AllNot
              Search[7]:=.T.
         OtherWise
              Search[7]:=.F.
      EndCase
   ELSE
      Search[7]:=.T.
   ENDIF
// Поиск вхождения по корсчету
   IF .not.Empty(BankSchet)
//@ 5,6 say "8"
      FOR I=1 TO NumToken(BankSchet,TOKENS)
          SELECT Licevoj
          SEEK Main->Lic_Schet
          DO WHILE Lic_Sch==Main->Lic_Schet
             IF Atnum(Token(BankSchet,TOKENS,I),Alltrim(MYUpper(K_Schet)))>0
                Search[8]:=.T.
                EXIT
             ENDIF
             SKIP
          ENDDO
          SELECT Main
      NEXT
   ELSE
      Search[8]:=.T.
   ENDIF
   DO CASE
      CASE Main->Lic_Schet>nsLicStart.and.Main->Lic_Schet>nsLicEnd
           Search[1]:=.F.
      CASE Main->Lic_Schet<nsLicStart.and.Main->Lic_Schet<nsLicEnd
           Search[1]:=.F.
   ENDCASE
   IF Search[1].and.Search[2].and.Search[3].and.Search[4].and.;
      Search[5].and.Search[6].and.Search[7].and.Search[8]
         Counter++
         nRec:=RecNo()
         Select BSMain
         Append Blank
         Select Main
         Replace BSMain->Recno With nRec
//--------------------------------------------------------
				 nPos:=1
         do while nPos#0
            FName:=Fieldname(nPos)
            IF .not.empty(FName)
               replace BSMain->&FName with Main->&FName
            	 nPos++
            ELSE
               nPos:=0
            ENDIF
         enddo
//--------------------------------------------------------
   ENDIF
   Skip
ENDDO
oProgress:destroy()																							// Progress Bar Destroy
oDlg:destroy()
Win_Rest(Scr)
SetColor(Clr)
Select(Sel)
IF Counter>0
   ret_val:=2
//   set filter to IsShowPos==.T.
   go top
   IsFiltered:=.T.
ELSE
   Go Recno
ENDIF
RETURN IF(Counter>0,.T.,.F.)



Function GetManyReport()
LOCAL Buttons, On_Off, selectables:={}, i, MaxSize,Window:=SaveScreen(0,0,24,79)
LOCAL Clr:=SetColor(),Sel:=Select(),Rec:=Recno(),cDate,Kol_Kl:=0,Desc
Local CrLf:=Chr(13)+Chr(10),Position:={},Head:="",SumR,NumString:=0,Page:=1
LOCAL Itog:={},TmpVal,NumNextMon,cNextDate,InMain:=.T.,NumLic:=-1,Count:=0
LOCAL LenPos:={},Title:={"",""},PagePrefix,Search[4],Chosen,RecCount:=0
Local oDlg,aSizeDeskTop,aPos,oProgress
DevOut("")
IF Potr==NIL
   Potr:=Space(100);   Adr:=Space(50);      Podkl:=Space(50)
   TipSch:=Space(50);  Object:=space(50);   NumMon:=Month(New_date)
   Dog:=Space(250);    BankSchet:=Space(50)
ENDIF
Clear Typeahead
NumMon:=IF(NumMon==NIL,Month(New_date),NumMon)
NumNextMon:=IF(NumMon+1<=12,NumMon+1,1)
cDate:=ctod("31."+alltrim(str(NumMon))+"."+substr(alltrim(str(year(New_date))),3,2))
cNextDate:=cToD("01."+alltrim(str(NumNextMon))+"."+substr(alltrim(str(year(New_date))),3,2))
tcDate:="31."+IF(NumMon<10,"0","")+alltrim(str(NumMon))+"."+substr(alltrim(str(year(New_date+3))),3,2)
tcNextDate:="01."+IF(NumMon<10,"0","")+alltrim(str(NumNextMon))+"."+substr(alltrim(str(year(New_date+3))),3,2)
* Распределим и установим кнопки, результат и выбираемость
buttons:={"Договор","Наименование потребителя   ",;
          "Дата договора",;
          "Задолженность за "+CMonth(cDate)+"     ",;
          "Начислено за " +CMonth(cDate),;
          "Расход за "+CMonth(cDate),;
          "Оплата за "+CMonth(cDate),;
          "Сальдо на "+tcDate,;
          "Сальдо на "+tcNextDate,;
          "Пеня "+CMonth(cDate),;
          "Повышенная "+CMonth(cDate),;
          "Срок задолженности",;
          "Лимит на "+CMonth(cDate),;
          "Точка подключения",;
          "Силовая","Освещение",;
          "Ток","В","А",;
          "Тип счетчика","N Счетчика","Год проверки",;
          "Адрес",;
          "Телефон","По объектам","Пустое поле"}

* Заполнение массива значениями по умолчанию
ASize(Selectables,Len(Buttons))
ASize(Position,Len(Buttons))
ASize(Itog,Len(Buttons))
ASize(LenPos,Len(Buttons))
afill(LenPos, 0)
afill(Itog, 0)
afill(selectables, .T.)
afill(Position, .F.)
Afill(Search,.F.)

* Заполнение массива названием и длинной элемента
LenPos:={{"Дог.",6},;
         {"Потребитель",30},;
         {"Договор",Len(Dtoc(New_date))},;
         {"Долг",12},;
         {"Начислено",12},;
         {"Расход",12},;
         {"Оплачено",12},;
         {"Сальдо "+TcDate,16},;
         {"Сальдо "+TcNextDate,16},;
         {"Пеня "+CMonth(cDate),16},;
         {"Повышенная "+CMonth(cDate),18},;
         {"Срок задолж",11},;
         {"Лимит",7},;
         {"Подключение",Len(Licevoj->Razdel_1)},;
         {"Cиловая",9},;
         {"Освещение",9},;
         {"Тр/Т",9},;
         {"В",9},;
         {"A",9},;
         {"Тип",9},;
         {"Счетчик",9},;
         {"Проверен",9},;
         {"Адрес",Len(Licevoj->Adres)},;
         {"Телефон",Len(Licevoj->Telefon)},;
         {"",0},;
         {"",30}}


* Невыбираемые кнопки
selectables[2] = .F.

* Начальные выборы
on_off = {1, 2, 5, 9}

MaxSize:=0
for i=1 to len(Buttons)
    MaxSize:=IF(Len(Buttons[i])>MaxSize,Len(Buttons[i])+7,MaxSize)
Next
//chosen = sel_box(3, 10, 3+Len(Buttons)+1, 10+MaxSize, buttons, selectables, ;
chosen = sel_box(3, 10, buttons, selectables, ;
         on_off, 1, 0, .T.,.T.,.F.)

* Теперь высветим возвращенные результаты
FOR I=1 TO LEN(Chosen)
    Position[Chosen[I]]:=.T.
NEXT
IF Al_Box({"Печатать заголовок и окончание"},2,,2)==1
   Title:=GetTitle()
ENDIF
//----------------------------------------- Расчет ожидаемой длинны строки.
Head:="┌"+If(Position[01],Replicate("─",LenPos[1][2])+"┬","")+;
      If(Position[02],Replicate("─",LenPos[2][2])+"┬","")+;
      If(Position[03],Replicate("─",LenPos[3][2])+"┬","")+;
      If(Position[04],Replicate("─",LenPos[4][2])+"┬","")+;
      If(Position[05],Replicate("─",LenPos[5][2])+"┬","")+;
      If(Position[06],Replicate("─",LenPos[6][2])+"┬","")+;
      If(Position[07],Replicate("─",LenPos[7][2])+"┬","")+;
      If(Position[08],Replicate("─",LenPos[8][2])+"┬","")+;
      If(Position[09],Replicate("─",LenPos[9][2])+"┬","")+;
      If(Position[10],Replicate("─",LenPos[10][2])+"┬","")+;
      If(Position[11],Replicate("─",LenPos[11][2])+"┬","")+;
      If(Position[12],Replicate("─",LenPos[12][2])+"┬","")+;
      If(Position[13],Replicate("─",LenPos[13][2])+"┬","")+;
      If(Position[14],Replicate("─",LenPos[14][2])+"┬","")+;
      If(Position[15],Replicate("─",LenPos[15][2])+"┬","")+;
      If(Position[16],Replicate("─",LenPos[16][2])+"┬","")+;
      If(Position[17],Replicate("─",LenPos[17][2])+"┬","")+;
      If(Position[18],Replicate("─",LenPos[18][2])+"┬","")+;
      If(Position[19],Replicate("─",LenPos[19][2])+"┬","")+;
      If(Position[20],Replicate("─",LenPos[20][2])+"┬","")+;
      If(Position[21],Replicate("─",LenPos[21][2])+"┬","")+;
      If(Position[23],Replicate("─",LenPos[23][2])+"┬","")+;
      If(Position[23],Replicate("─",LenPos[23][2])+"┬","")+;
      If(Position[24],Replicate("─",LenPos[24][2])+"┬","")+;
      If(Position[26],Replicate("─",LenPos[26][2])+"┬","")
LenPage:=GetVal("Количество строк на листе ",IF(Len(Head)<150,62,42),-1)
Head:=""
IF LenPage<=0
   RestScreen(0,0,24,79,Window)
   SetColor(Clr)
   Return NIL
ENDIF
SELECT Main
GO Top
Do While .not.Eof()
	 RecCount:=RecCount+1
	 Skip
EndDO
Go Top
//Obrabot("Отчет по выбранному условию")
Desc:=FCreate(DDir+ReportFile)
FWrite(Desc,Head)
DevOut("")
oDlg          := XbpDialog():new() 
aSizeDesktop    := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Обработано" 
oDlg:SysMenu	 := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos						:= oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
	
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount
// 	 oProgress:increment()																				// Progress Bar Increment
//oProgress:destroy()																							// Progress Bar Destroy
DO WHILE .Not.EOF()
   IF Hot_Inkey()==27.and.Al_Box({"Прекратить формирование документа"},2)==1
      EXIT
   ENDIF
   IF NumString==0
      IF Page!=1
         TmpVal:="Страница  N "+AllTrim(str(Page))
         LenTitle:=0
      ELSE
         TmpVal:=""
         FWrite(Desc,Title[1])
         LenTitle:=MlCount(Title[1])
      ENDIF
      NumString:=NumString+4+LenTitle
      Head:="┌"+If(Position[01],Replicate("─",LenPos[1][2])+"┬","")+;
            If(Position[02],Replicate("─",LenPos[2][2])+"┬","")+;
            If(Position[03],Replicate("─",LenPos[3][2])+"┬","")+;
            If(Position[04],Replicate("─",LenPos[4][2])+"┬","")+;
            If(Position[05],Replicate("─",LenPos[5][2])+"┬","")+;
            If(Position[06],Replicate("─",LenPos[6][2])+"┬","")+;
            If(Position[07],Replicate("─",LenPos[7][2])+"┬","")+;
            If(Position[08],Replicate("─",LenPos[8][2])+"┬","")+;
            If(Position[09],Replicate("─",LenPos[9][2])+"┬","")+;
            If(Position[10],Replicate("─",LenPos[10][2])+"┬","")+;
            If(Position[11],Replicate("─",LenPos[11][2])+"┬","")+;
            If(Position[12],Replicate("─",LenPos[12][2])+"┬","")+;
            If(Position[13],Replicate("─",LenPos[13][2])+"┬","")+;
            If(Position[14],Replicate("─",LenPos[14][2])+"┬","")+;
            If(Position[15],Replicate("─",LenPos[15][2])+"┬","")+;
            If(Position[16],Replicate("─",LenPos[16][2])+"┬","")+;
            If(Position[17],Replicate("─",LenPos[17][2])+"┬","")+;
            If(Position[18],Replicate("─",LenPos[18][2])+"┬","")+;
            If(Position[19],Replicate("─",LenPos[19][2])+"┬","")+;
            If(Position[20],Replicate("─",LenPos[20][2])+"┬","")+;
            If(Position[21],Replicate("─",LenPos[21][2])+"┬","")+;
            If(Position[22],Replicate("─",LenPos[22][2])+"┬","")+;
            If(Position[23],Replicate("─",LenPos[23][2])+"┬","")+;
            If(Position[24],Replicate("─",LenPos[24][2])+"┬","")+;
            If(Position[26],Replicate("─",LenPos[26][2])+"┬","")
      Head:=Substr(Head,1,Len(Head)-1)+"┐"+CrLf
      Head:=IF(Len(Head)>82,Schet_Cond,"")+;
            Space(Len(Head)-Len(TmpVal)-3)+TmpVal+CrLf+Head
      NumString:=NumString+IF(Len(Head)>82,LenTitle,0)
      Head:=Head+"│"+If(Position[01],Center(LenPos[1][1],LenPos[1][2]," ",.t.)+"│","")+;
            If(Position[02],Center(LenPos[2][1],LenPos[2][2]," ",.t.)+"│","")+;
            If(Position[03],Center(LenPos[3][1],LenPos[3][2]," ",.t.)+"│","")+;
            If(Position[04],Center(LenPos[4][1],LenPos[4][2]," ",.t.)+"│","")+;
            If(Position[05],Center(LenPos[5][1],LenPos[5][2]," ",.t.)+"│","")+;
            If(Position[06],Center(LenPos[6][1],LenPos[6][2]," ",.t.)+"│","")+;
            If(Position[07],Center(LenPos[7][1],LenPos[7][2]," ",.t.)+"│","")+;
            If(Position[08],Center(LenPos[8][1],LenPos[8][2]," ",.t.)+"│","")+;
            If(Position[09],Center(LenPos[9][1],LenPos[9][2]," ",.t.)+"│","")+;
            If(Position[10],Center(LenPos[10][1],LenPos[10][2]," ",.t.)+"│","")+;
            If(Position[11],Center(LenPos[11][1],LenPos[11][2]," ",.t.)+"│","")+;
            If(Position[12],Center(LenPos[12][1],LenPos[12][2]," ",.t.)+"│","")+;
            If(Position[13],Center(LenPos[13][1],LenPos[13][2]," ",.t.)+"│","")+;
            If(Position[14],Center(LenPos[14][1],LenPos[14][2]," ",.t.)+"│","")+;
            If(Position[15],Center(LenPos[15][1],LenPos[15][2]," ",.t.)+"│","")+;
            If(Position[16],Center(LenPos[16][1],LenPos[16][2]," ",.t.)+"│","")+;
            If(Position[17],Center(LenPos[17][1],LenPos[17][2]," ",.t.)+"│","")+;
            If(Position[18],Center(LenPos[18][1],LenPos[18][2]," ",.t.)+"│","")+;
            If(Position[19],Center(LenPos[19][1],LenPos[19][2]," ",.t.)+"│","")+;
            If(Position[20],Center(LenPos[20][1],LenPos[20][2]," ",.t.)+"│","")+;
            If(Position[21],Center(LenPos[21][1],LenPos[21][2]," ",.t.)+"│","")+;
            If(Position[22],Center(LenPos[22][1],LenPos[22][2]," ",.t.)+"│","")+;
            If(Position[23],Center(LenPos[23][1],LenPos[23][2]," ",.t.)+"│","")+;
            If(Position[24],Center(LenPos[24][1],LenPos[24][2]," ",.t.)+"│","")+;
            If(Position[26],Center(LenPos[26][1],LenPos[26][2]," ",.t.)+"│","")
      Head:=Substr(Head,1,Len(Head)-1)+"│"+CrLf
      Head:=Head+"├"+If(Position[01],Replicate("─",LenPos[1][2])+"┼","")+;
            If(Position[02],Replicate("─",LenPos[2][2])+"┼","")+;
            If(Position[03],Replicate("─",LenPos[3][2])+"┼","")+;
            If(Position[04],Replicate("─",LenPos[4][2])+"┼","")+;
            If(Position[05],Replicate("─",LenPos[5][2])+"┼","")+;
            If(Position[06],Replicate("─",LenPos[6][2])+"┼","")+;
            If(Position[07],Replicate("─",LenPos[7][2])+"┼","")+;
            If(Position[08],Replicate("─",LenPos[8][2])+"┼","")+;
            If(Position[09],Replicate("─",LenPos[9][2])+"┼","")+;
            If(Position[10],Replicate("─",LenPos[10][2])+"┼","")+;
            If(Position[11],Replicate("─",LenPos[11][2])+"┼","")+;
            If(Position[12],Replicate("─",LenPos[12][2])+"┼","")+;
            If(Position[13],Replicate("─",LenPos[13][2])+"┼","")+;
            If(Position[14],Replicate("─",LenPos[14][2])+"┼","")+;
            If(Position[15],Replicate("─",LenPos[15][2])+"┼","")+;
            If(Position[16],Replicate("─",LenPos[16][2])+"┼","")+;
            If(Position[17],Replicate("─",LenPos[17][2])+"┼","")+;
            If(Position[18],Replicate("─",LenPos[18][2])+"┼","")+;
            If(Position[19],Replicate("─",LenPos[19][2])+"┼","")+;
            If(Position[20],Replicate("─",LenPos[20][2])+"┼","")+;
            If(Position[21],Replicate("─",LenPos[21][2])+"┼","")+;
            If(Position[22],Replicate("─",LenPos[22][2])+"┼","")+;
            If(Position[23],Replicate("─",LenPos[23][2])+"┼","")+;
            If(Position[24],Replicate("─",LenPos[24][2])+"┼","")+;
            If(Position[26],Replicate("─",LenPos[26][2])+"┼","")
      Head:=Substr(Head,1,Len(Head)-1)+"┤"+CrLf
      FWrite(Desc,Head)
      Page++
   ENDIF
   Head:=""
//   Kol_Kl=Kol_Kl+(39/RecCount())
//   ColorWin(12,21,12,21+kol_kl,'n/n')
 	 oProgress:increment()																				// Progress Bar Increment
   IF Position[1]
      Head:=Head+"│"+str(Main->Lic_schet,LenPos[1][2],0)
   ENDIF
   IF Position[2]
      Head:=Head+"│"+Substr(Delstring(Main->Potrebitel,"ИНН"),1,LenPos[2][2])+Space(LenPos[2][2]-Len(Substr(Delstring(Main->Potrebitel,"ИНН"),1,LenPos[2][2])))
   ENDIF
   IF Position[3]
      Head:=Head+"│"+dtoc(Data_Dog)+space(LenPos[3][2]-Len(DTOC(Data_Dog)))
   ENDIF
   IF Position[4]
      TmpVal:=GetDolg(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[4][2],Decimal)
      Itog[4]:=Itog[4]+TmpVal
   ENDIF
   IF Position[5]
//      TmpVal:=GetSum(Main->Lic_Schet,NumMon); TmpVal:=TmpVal+IF(Main->Lic_Schet>99999,0,Round(TmpVal*Schet_Nds/100,Decimal))
      TmpVal:=GetSum(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+IF(.not.Position[25],str(TmpVal,LenPos[5][2],Decimal),Space(LenPos[4][2]))
      Itog[5]:=Itog[5]+If(.not.Position[25],TmpVal,0)
   ENDIF
   IF Position[6]
      Sumr:=GetRashod(Main->Lic_Schet,NumMon)
//      ; Sumr:=Sumr+Round(Sumr*Schet_Nds/100,Decimal)
      Head:=Head+"│"+IF(.not.Position[25],str(Sumr,LenPos[6][2],Decimal),Space(LenPos[6][2]))
      Itog[6]:=Itog[6]+IF(.not.Position[25],Sumr,0)
   ENDIF
   IF Position[7]
      TmpVal:=CalckPay(NumMon,Main->Lic_Schet,.f.)
      Head:=Head+"│"+str(TmpVal,LenPos[7][2],Decimal)
      Itog[7]:=Itog[7]+TmpVal
   ENDIF
   IF Position[8]
      TmpVal:=GetSaldo(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[8][2],Decimal)
      Itog[8]:=Itog[8]+TmpVal
   ENDIF
   IF Position[9]
      TmpVal:=GetSaldo(Main->Lic_Schet,NumNextMon)
      Head:=Head+"│"+str(TmpVal,LenPos[9][2],Decimal)
      Itog[9]:=Itog[9]+TmpVal
   ENDIF
   IF Position[10]
      TmpVal:=GetPenq(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[10][2],Decimal)
      Itog[10]:=Itog[10]+TmpVal
   ENDIF
   IF Position[11]
      TmpVal:=GetHigh(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[11][2],Decimal)
      Itog[11]:=Itog[11]+TmpVal
   ENDIF
   IF Position[12]
      TmpVal:=SrokDolg(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[12][2],0)
   ENDIF
   IF Position[13]
      TmpVal:=GetLimit(NumMon,Main->Lic_Schet)
      Head:=Head+"│"+str(TmpVal,LenPos[13][2],Decimal)
      Itog[13]:=Itog[13]+TmpVal
   ENDIF
   IF Position[14]
      Select Licevoj
      Seek Main->Lic_Schet
      Head:=Head+"│"+IF(Position[25],Space(LenPos[14][2]),Razdel_1)
      Select Main
   ENDIF
   IF Position[15]
      IF .not.Position[25]
         TmpVal:=GetSil(Main->Lic_Schet,1)
         Head:=Head+"│"+Str(TmpVal,LenPos[15][2],2)
         Itog[15]:=Itog[15]+TmpVal
      ELSE
         Head:=Head+"│"+Space(LenPos[15][2])
      ENDIF
   ENDIF
   IF Position[16]
      IF .not.Position[25]
         TmpVal:=GetSil(Main->Lic_Schet,2)
         Head:=Head+"│"+Str(TmpVal,LenPos[16][2],2)
         Itog[16]:=Itog[16]+TmpVal
      ELSE
         Head:=Head+"│"+Space(LenPos[16][2])
      ENDIF
   ENDIF
   IF Position[17]
      Head:=Head+"│"+space(LenPos[17][2])
   ENDIF
   IF Position[18]
      Head:=Head+"│"+space(LenPos[18][2])
   ENDIF
   IF Position[19]
      Head:=Head+"│"+space(LenPos[19][2])
   ENDIF
   IF Position[20]
      Head:=Head+"│"+space(LenPos[20][2])
   ENDIF
   IF Position[21]
      Head:=Head+"│"+space(LenPos[21][2])
   ENDIF
   IF Position[22]
      Head:=Head+"│"+space(LenPos[22][2])
   ENDIF
   IF Position[23]
      Head:=Head+"│"+Adress+Space(LenPos[23][2]-Len(Adress))
   ENDIF
   IF Position[24]
      Select Licevoj
      Seek Main->Lic_Schet
      Head:=Head+"│"+Telefon+Space(LenPos[24][2]-Len(Telefon))
      Select Main
   ENDIF
   IF Position[26]
      Head:=Head+"│"+Space(LenPos[26][2])
      Select Main
   ENDIF
   FWrite(Desc,Head+"│"+CrLf)
   NumString++
// Выборка по счетчикам ----------------------------------------------------
   IF Position[25]
      DevOut("")
      Select LICEVOJ
      Seek Main->Lic_Schet
      DO While Lic_Sch==Main->Lic_Schet
         AFill(Search,.F.)
         IF .not.Empty(Podkl)
            FOR I=1 TO NumToken(Podkl,TOKENS)
                IF Atnum(Token(Podkl,TOKENS,I),MYUpper(Razdel_1))>0
                   Search[1]:=.T.
                   EXIT
                ENDIF
                IF Atnum(Token(Podkl,TOKENS,I),MYUpper(Razdel_2))>0
                   Search[1]:=.T.
                   EXIT
                ENDIF
            NEXT
         ELSE
            Search[1]:=.T.
         ENDIF
         IF .not.Empty(Adr)
            IF Atnum(Token(Adr,TOKENS,I),Alltrim(MYUpper(Adres)))>0
               Search[2]:=.T.
               EXIT
            ENDIF
         ELSE
            Search[2]:=.T.
         ENDIF
         IF .Not.Empty(Object)
            FOR I=1 TO NumToken(Object,TOKENS)
                IF Atnum(Token(Object,TOKENS,I),Alltrim(MYUpper(Object1)))>0
                   Search[3]:=.T.
                   EXIT
                ENDIF
                IF Atnum(Token(Object,TOKENS,I),Alltrim(MYUpper(Object2)))>0
                   Search[3]:=.T.
                   EXIT
                ENDIF
            NEXT
         ELSE
            Search[3]:=.T.
         ENDIF
         IF .Not.Empty(TipSch)
            FOR I=1 TO NumToken(TipSch,TOKENS)
                IF Atnum(Token(TipSch,TOKENS,I),Alltrim(MYUpper(Tip)))>0
                   Search[4]:=.T.
                   EXIT
                ENDIF
            NEXT
         ELSE
            Search[4]:=.T.
         ENDIF
         IF .not.Search[1].or..not.Search[2].or..not.Search[3].or.;
            .not.Search[4]
            SKIP
            LOOP
         ENDIF
//         IF Alltrim(Upper(Schetchik))=="ВОЗВРАТ".or.;
//            Alltrim(Upper(Schetchik))=="АБОН.МОЩН".or.;
//            Alltrim(Upper(Schetchik))=="ДОНАЧ".or.;
//            Alltrim(Upper(Schetchik))=="ПО АКТУ"
//            SKIP
//            LOOP
//         ENDIF
         IF NumString==0
            TmpVal:=IF(Page!=1,"Страница  N "+AllTrim(str(Page)),"")
            NumString:=NumString+4
            Head:="┌"+If(Position[01],Replicate("─",LenPos[1][2])+"┬","")+;
                  If(Position[02],Replicate("─",LenPos[2][2])+"┬","")+;
                  If(Position[03],Replicate("─",LenPos[3][2])+"┬","")+;
                  If(Position[04],Replicate("─",LenPos[4][2])+"┬","")+;
                  If(Position[05],Replicate("─",LenPos[5][2])+"┬","")+;
                  If(Position[06],Replicate("─",LenPos[6][2])+"┬","")+;
                  If(Position[07],Replicate("─",LenPos[7][2])+"┬","")+;
                  If(Position[08],Replicate("─",LenPos[8][2])+"┬","")+;
                  If(Position[09],Replicate("─",LenPos[9][2])+"┬","")+;
                  If(Position[10],Replicate("─",LenPos[10][2])+"┬","")+;
                  If(Position[11],Replicate("─",LenPos[11][2])+"┬","")+;
                  If(Position[12],Replicate("─",LenPos[12][2])+"┬","")+;
                  If(Position[13],Replicate("─",LenPos[13][2])+"┬","")+;
                  If(Position[14],Replicate("─",LenPos[14][2])+"┬","")+;
                  If(Position[15],Replicate("─",LenPos[15][2])+"┬","")+;
                  If(Position[16],Replicate("─",LenPos[16][2])+"┬","")+;
                  If(Position[17],Replicate("─",LenPos[17][2])+"┬","")+;
                  If(Position[18],Replicate("─",LenPos[18][2])+"┬","")+;
                  If(Position[19],Replicate("─",LenPos[19][2])+"┬","")+;
                  If(Position[20],Replicate("─",LenPos[20][2])+"┬","")+;
                  If(Position[21],Replicate("─",LenPos[21][2])+"┬","")+;
                  If(Position[22],Replicate("─",LenPos[22][2])+"┬","")+;
                  If(Position[23],Replicate("─",LenPos[23][2])+"┬","")+;
                  If(Position[24],Replicate("─",LenPos[24][2])+"┬","")+;
                  If(Position[26],Replicate("─",LenPos[26][2])+"┬","")
            Head:=Substr(Head,1,Len(Head)-1)+"┐"+CrLf
            Head:=IF(Len(Head)>82,Schet_Cond,"")+;
                  Space(Len(Head)-Len(TmpVal)-3)+TmpVal+CrLf+Head
            Head:=Head+"│"+If(Position[01],Center(LenPos[1][1],LenPos[1][2]," ",.t.)+"│","")+;
                  If(Position[02],Center(LenPos[2][1],LenPos[2][2]," ",.t.)+"│","")+;
                  If(Position[03],Center(LenPos[3][1],LenPos[3][2]," ",.t.)+"│","")+;
                  If(Position[04],Center(LenPos[4][1],LenPos[4][2]," ",.t.)+"│","")+;
                  If(Position[05],Center(LenPos[5][1],LenPos[5][2]," ",.t.)+"│","")+;
                  If(Position[06],Center(LenPos[6][1],LenPos[6][2]," ",.t.)+"│","")+;
                  If(Position[07],Center(LenPos[7][1],LenPos[7][2]," ",.t.)+"│","")+;
                  If(Position[08],Center(LenPos[8][1],LenPos[8][2]," ",.t.)+"│","")+;
                  If(Position[09],Center(LenPos[9][1],LenPos[9][2]," ",.t.)+"│","")+;
                  If(Position[10],Center(LenPos[10][1],LenPos[10][2]," ",.t.)+"│","")+;
                  If(Position[11],Center(LenPos[11][1],LenPos[11][2]," ",.t.)+"│","")+;
                  If(Position[12],Center(LenPos[12][1],LenPos[12][2]," ",.t.)+"│","")+;
                  If(Position[13],Center(LenPos[13][1],LenPos[13][2]," ",.t.)+"│","")+;
                  If(Position[14],Center(LenPos[14][1],LenPos[14][2]," ",.t.)+"│","")+;
                  If(Position[15],Center(LenPos[15][1],LenPos[15][2]," ",.t.)+"│","")+;
                  If(Position[16],Center(LenPos[16][1],LenPos[16][2]," ",.t.)+"│","")+;
                  If(Position[17],Center(LenPos[17][1],LenPos[17][2]," ",.t.)+"│","")+;
                  If(Position[18],Center(LenPos[18][1],LenPos[18][2]," ",.t.)+"│","")+;
                  If(Position[19],Center(LenPos[19][1],LenPos[19][2]," ",.t.)+"│","")+;
                  If(Position[20],Center(LenPos[20][1],LenPos[20][2]," ",.t.)+"│","")+;
                  If(Position[21],Center(LenPos[21][1],LenPos[21][2]," ",.t.)+"│","")+;
                  If(Position[22],Center(LenPos[22][1],LenPos[22][2]," ",.t.)+"│","")+;
                  If(Position[23],Center(LenPos[23][1],LenPos[23][2]," ",.t.)+"│","")+;
                  If(Position[24],Center(LenPos[24][1],LenPos[24][2]," ",.t.)+"│","")+;
                  If(Position[26],Center(LenPos[26][1],LenPos[26][2]," ",.t.)+"│","")
            Head:=Substr(Head,1,Len(Head)-1)+"│"+CrLf
            Head:=Head+"├"+If(Position[01],Replicate("─",LenPos[1][2])+"┼","")+;
                  If(Position[02],Replicate("─",LenPos[2][2])+"┼","")+;
                  If(Position[03],Replicate("─",LenPos[3][2])+"┼","")+;
                  If(Position[04],Replicate("─",LenPos[4][2])+"┼","")+;
                  If(Position[05],Replicate("─",LenPos[5][2])+"┼","")+;
                  If(Position[06],Replicate("─",LenPos[6][2])+"┼","")+;
                  If(Position[07],Replicate("─",LenPos[7][2])+"┼","")+;
                  If(Position[08],Replicate("─",LenPos[8][2])+"┼","")+;
                  If(Position[09],Replicate("─",LenPos[9][2])+"┼","")+;
                  If(Position[10],Replicate("─",LenPos[10][2])+"┼","")+;
                  If(Position[11],Replicate("─",LenPos[11][2])+"┼","")+;
                  If(Position[12],Replicate("─",LenPos[12][2])+"┼","")+;
                  If(Position[13],Replicate("─",LenPos[13][2])+"┼","")+;
                  If(Position[14],Replicate("─",LenPos[14][2])+"┼","")+;
                  If(Position[15],Replicate("─",LenPos[15][2])+"┼","")+;
                  If(Position[16],Replicate("─",LenPos[16][2])+"┼","")+;
                  If(Position[17],Replicate("─",LenPos[17][2])+"┼","")+;
                  If(Position[18],Replicate("─",LenPos[18][2])+"┼","")+;
                  If(Position[19],Replicate("─",LenPos[19][2])+"┼","")+;
                  If(Position[20],Replicate("─",LenPos[20][2])+"┼","")+;
                  If(Position[21],Replicate("─",LenPos[21][2])+"┼","")+;
                  If(Position[22],Replicate("─",LenPos[22][2])+"┼","")+;
                  If(Position[23],Replicate("─",LenPos[23][2])+"┼","")+;
                  If(Position[24],Replicate("─",LenPos[24][2])+"┼","")+;
                  If(Position[26],Replicate("─",LenPos[26][2])+"┼","")
            Head:=Substr(Head,1,Len(Head)-1)+"┤"+CrLf
            FWrite(Desc,Head)
            Page++
         ENDIF
         Head:=""
         IF Position[1]
            Head:=Head+"│"+space(LenPos[1][2])
         ENDIF
         IF Position[2]
            Head:=Head+"│"+Space(LenPos[2][2]-Len(Substr(Alltrim(Object1),1,LenPos[2][2])))+;
                           Substr(Alltrim(Object1),1,LenPos[2][2])
         ENDIF
         IF Position[3]
            Head:=Head+"│"+space(LenPos[3][2])
         ENDIF
         IF Position[4]
            Head:=Head+"│"+space(LenPos[4][2])
         ENDIF
         IF Position[5]
            TmpVal:=GetSl(Main->Lic_Schet,Schetchik,NumMon)
            TmpVal:=TmpVal+Round(TmpVal*Schet_Nds/100,Decimal)
            Head:=Head+"│"+Str(TmpVal,LenPos[5][2],Decimal)
            Itog[5]:=Itog[5]+TmpVal
         ENDIF
         IF Position[6]
            Sumr:=GetRl(Main->Lic_Schet,Schetchik,NumMon)
            Head:=Head+"│"+Str(Sumr,LenPos[6][2],Decimal)
            Itog[6]:=Itog[6]+Sumr
         ENDIF
         IF Position[7]
            Head:=Head+"│"+space(LenPos[7][2])
         ENDIF
         IF Position[8]
            Head:=Head+"│"+space(LenPos[8][2])
         ENDIF
         IF Position[9]
            Head:=Head+"│"+space(LenPos[9][2])
         ENDIF
         IF Position[10]
            Head:=Head+"│"+space(LenPos[10][2])
         ENDIF
         IF Position[11]
            Head:=Head+"│"+space(LenPos[11][2])
         ENDIF
         IF Position[12]
            Head:=Head+"│"+space(LenPos[12][2])
         ENDIF
         IF Position[13]
            Head:=Head+"│"+space(LenPos[13][2])
         ENDIF
         IF Position[14]
            Head:=Head+"│"+Razdel_1+Space(LenPos[14][2]-Len(Razdel_1))
         ENDIF
         IF Position[15]
            Head:=Head+"│"+Str(Silowaq,LenPos[15][2],Decimal)
            Itog[15]:=Itog[15]+Silowaq
         ENDIF
         IF Position[16]
            Head:=Head+"│"+Str(Oswesh,LenPos[16][2],Decimal)
            Itog[16]:=Itog[16]+Oswesh
         ENDIF
         IF Position[17]
            Head:=Head+"│"+center(Tok,LenPos[17][2]," ",.t.)
         ENDIF
         IF Position[18]
            Head:=Head+"│"+center(B,LenPos[18][2]," ",.t.)
         ENDIF
         IF Position[19]
            Head:=Head+"│"+center(A,LenPos[19][2]," ",.t.)
         ENDIF
         IF Position[20]
            Head:=Head+"│"+center(Tip,LenPos[20][2]," ",.t.)
         ENDIF
         IF Position[21]
            Head:=Head+"│"+center(Schetchik,LenPos[21][2]," ",.t.)
         ENDIF
         IF Position[22]
            Head:=Head+"│"+center(God_Prow,LenPos[22][2]," ",.t.)
         ENDIF
         IF Position[23]
            Head:=Head+"│"+Adres+Space(LenPos[23][2]-Len(Adres))
         ENDIF
         IF Position[24]
            Head:=Head+"│"+Telefon+Space(LenPos[24][2]-Len(Telefon))
         ENDIF
         IF Position[26]
            Head:=Head+"│"+Space(LenPos[26][2])
         ENDIF
         FWrite(Desc,Head+"│"+CrLf)
         NumString++
         IF NumString>=LenPage-1
            NumString:=0
            Head:="└"+If(Position[01],Replicate("─",LenPos[1][2])+"┴","")+;
                  If(Position[02],Replicate("─",LenPos[2][2])+"┴","")+;
                  If(Position[03],Replicate("─",LenPos[3][2])+"┴","")+;
                  If(Position[04],Replicate("─",LenPos[4][2])+"┴","")+;
                  If(Position[05],Replicate("─",LenPos[5][2])+"┴","")+;
                  If(Position[06],Replicate("─",LenPos[6][2])+"┴","")+;
                  If(Position[07],Replicate("─",LenPos[7][2])+"┴","")+;
                  If(Position[08],Replicate("─",LenPos[8][2])+"┴","")+;
                  If(Position[09],Replicate("─",LenPos[9][2])+"┴","")+;
                  If(Position[10],Replicate("─",LenPos[10][2])+"┴","")+;
                  If(Position[11],Replicate("─",LenPos[11][2])+"┴","")+;
                  If(Position[12],Replicate("─",LenPos[12][2])+"┴","")+;
                  If(Position[13],Replicate("─",LenPos[13][2])+"┴","")+;
                  If(Position[14],Replicate("─",LenPos[14][2])+"┴","")+;
                  If(Position[15],Replicate("─",LenPos[15][2])+"┴","")+;
                  If(Position[16],Replicate("─",LenPos[16][2])+"┴","")+;
                  If(Position[17],Replicate("─",LenPos[17][2])+"┴","")+;
                  If(Position[18],Replicate("─",LenPos[18][2])+"┴","")+;
                  If(Position[19],Replicate("─",LenPos[19][2])+"┴","")+;
                  If(Position[20],Replicate("─",LenPos[20][2])+"┴","")+;
                  If(Position[21],Replicate("─",LenPos[21][2])+"┴","")+;
                  If(Position[22],Replicate("─",LenPos[22][2])+"┴","")+;
                  If(Position[23],Replicate("─",LenPos[23][2])+"┴","")+;
                  If(Position[24],Replicate("─",LenPos[24][2])+"┴","")+;
                  If(Position[26],Replicate("─",LenPos[26][2])+"┴","")
            Head:=Substr(Head,1,Len(Head)-1)+"┘"+CrLf
            Head:=IF(Len(Head)>82,Head+Schet_Norm,Head)+chr(12)
            FWrite(Desc,Head)
         ENDIF
         SKIP
      ENDDO
      Select Main
   ENDIF                && От выборки по счетчикам
//--------------------------------------------------------------------------
   IF NumString>=LenPage-1
      DevOut("")
      NumString:=0
      Head:="└"+If(Position[01],Replicate("─",LenPos[1][2])+"┴","")+;
            If(Position[02],Replicate("─",LenPos[2][2])+"┴","")+;
            If(Position[03],Replicate("─",LenPos[3][2])+"┴","")+;
            If(Position[04],Replicate("─",LenPos[4][2])+"┴","")+;
            If(Position[05],Replicate("─",LenPos[5][2])+"┴","")+;
            If(Position[06],Replicate("─",LenPos[6][2])+"┴","")+;
            If(Position[07],Replicate("─",LenPos[7][2])+"┴","")+;
            If(Position[08],Replicate("─",LenPos[8][2])+"┴","")+;
            If(Position[09],Replicate("─",LenPos[9][2])+"┴","")+;
            If(Position[10],Replicate("─",LenPos[10][2])+"┴","")+;
            If(Position[11],Replicate("─",LenPos[11][2])+"┴","")+;
            If(Position[12],Replicate("─",LenPos[12][2])+"┴","")+;
            If(Position[13],Replicate("─",LenPos[13][2])+"┴","")+;
            If(Position[14],Replicate("─",LenPos[14][2])+"┴","")+;
            If(Position[15],Replicate("─",LenPos[15][2])+"┴","")+;
            If(Position[16],Replicate("─",LenPos[16][2])+"┴","")+;
            If(Position[17],Replicate("─",LenPos[17][2])+"┴","")+;
            If(Position[18],Replicate("─",LenPos[18][2])+"┴","")+;
            If(Position[19],Replicate("─",LenPos[19][2])+"┴","")+;
            If(Position[20],Replicate("─",LenPos[20][2])+"┴","")+;
            If(Position[21],Replicate("─",LenPos[21][2])+"┴","")+;
            If(Position[22],Replicate("─",LenPos[22][2])+"┴","")+;
            If(Position[23],Replicate("─",LenPos[23][2])+"┴","")+;
            If(Position[24],Replicate("─",LenPos[24][2])+"┴","")+;
            If(Position[26],Replicate("─",LenPos[26][2])+"┴","")
      Head:=Substr(Head,1,Len(Head)-1)+"┘"+CrLf
      Head:=IF(Len(Head)>82,Head+Schet_Norm,Head)+Chr(12)
      FWrite(Desc,Head)
   ENDIF
   Count++
   Skip
ENDDO
DevOut("")
IF NumString!=0
   Head:="└"+If(Position[01],Replicate("─",LenPos[1][2])+"┴","")+;
         If(Position[02],Replicate("─",LenPos[2][2])+"┴","")+;
         If(Position[03],Replicate("─",LenPos[3][2])+"┴","")+;
         If(Position[04],Replicate("─",LenPos[4][2])+"┴","")+;
         If(Position[05],Replicate("─",LenPos[5][2])+"┴","")+;
         If(Position[06],Replicate("─",LenPos[6][2])+"┴","")+;
         If(Position[07],Replicate("─",LenPos[7][2])+"┴","")+;
         If(Position[08],Replicate("─",LenPos[8][2])+"┴","")+;
         If(Position[09],Replicate("─",LenPos[9][2])+"┴","")+;
         If(Position[10],Replicate("─",LenPos[10][2])+"┴","")+;
         If(Position[11],Replicate("─",LenPos[11][2])+"┴","")+;
         If(Position[12],Replicate("─",LenPos[12][2])+"┴","")+;
         If(Position[13],Replicate("─",LenPos[13][2])+"┴","")+;
         If(Position[14],Replicate("─",LenPos[14][2])+"┴","")+;
         If(Position[15],Replicate("─",LenPos[15][2])+"┴","")+;
         If(Position[16],Replicate("─",LenPos[16][2])+"┴","")+;
         If(Position[17],Replicate("─",LenPos[17][2])+"┴","")+;
         If(Position[18],Replicate("─",LenPos[18][2])+"┴","")+;
         If(Position[19],Replicate("─",LenPos[19][2])+"┴","")+;
         If(Position[20],Replicate("─",LenPos[20][2])+"┴","")+;
         If(Position[21],Replicate("─",LenPos[21][2])+"┴","")+;
         If(Position[22],Replicate("─",LenPos[22][2])+"┴","")+;
         If(Position[23],Replicate("─",LenPos[23][2])+"┴","")+;
         If(Position[24],Replicate("─",LenPos[24][2])+"┴","")+;
         If(Position[26],Replicate("─",LenPos[26][2])+"┴","")
   Head:=Substr(Head,1,Len(Head)-1)+"┘"+CrLf
   Head:=IF(Len(Head)>82,Head+Schet_Norm,Head)
   FWrite(Desc,Head)
ENDIF
Head:=" "+If(Position[01],Replicate(" ",LenPos[1][2])+" ","")+;
      If(Position[02],"Всего "+Alltrim(Str(Count))+;
         Space(LenPos[2][2]-Len("Всего "+Alltrim(Str(Count))))+" ","")+;
      If(Position[03],space(LenPos[3][2])+" ","")+;
      If(Position[04],Str(Itog[4],LenPos[4][2],Decimal)+" ","")+;
      If(Position[05],Str(Itog[5],LenPos[5][2],Decimal)+" ","")+;
      If(Position[06],Str(Itog[6],LenPos[6][2],Decimal)+" ","")+;
      If(Position[07],Str(Itog[7],LenPos[7][2],Decimal)+" ","")+;
      If(Position[08],Str(Itog[8],LenPos[8][2],Decimal)+" ","")+;
      If(Position[09],Str(Itog[9],LenPos[9][2],Decimal)+" ","")+;
      If(Position[10],Str(Itog[10],LenPos[10][2],Decimal)+" ","")+;
      If(Position[11],Str(Itog[11],LenPos[11][2],Decimal)+" ","")+;
      If(Position[12],Replicate(" ",LenPos[12][2])+" ","")+;
      If(Position[13],Str(Itog[13],LenPos[13][2],Decimal)+" ","")+;
      If(Position[14],Replicate(" ",LenPos[14][2])+" ","")+;
      If(Position[15],Str(Itog[15],LenPos[15][2],Decimal)+" ","")+;
      If(Position[16],Str(Itog[16],LenPos[16][2],Decimal)+" ","")+;
      If(Position[17],Replicate(" ",LenPos[17][2])+" ","")+;
      If(Position[18],Replicate(" ",LenPos[18][2])+" ","")
Head:=Substr(Head,1,Len(Head)-1)+" "+CrLf
Head:=IF(Len(Head)>82,Schet_Cond+Head+Schet_Norm,Head)+title[2]
FWrite(Desc,Head+Chr(12))
Fclose(Desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:destroy()
RestScreen(0,0,24,79,Window)
SetColor(Clr)
Select(Sel)
Go Rec
Return NIL






Function GetPenq(Lic,Mon)
LOCAL Sum:=0,Rec:=Recno(),Sel:=Select(),i,Str
Select Obormot
Seek Lic
IF Found()
   Sum:=Sum+SaldoP
   FOR I=1 To Mon
       Str:="Penqn"+Alltrim(Str(I))
       Sum:=Sum+&Str
       Str:="Penq"+Alltrim(Str(I))
       Sum:=Sum-&Str
   NEXT
ENDIF
Select(Sel); Go Rec
Return SUM


Function GetHigh(Lic,Mon)
LOCAL Sum:=0,Rec:=Recno(),Sel:=Select(),i,Str
Select Obormot
Seek Lic
IF Found()
   Sum:=Sum+SaldoH
   FOR I=1 To Mon
       Str:="Highn"+Alltrim(Str(I))
       Sum:=Sum+&Str
       Str:="High"+Alltrim(Str(I))
       Sum:=Sum-&Str
   NEXT
ENDIF
Select(Sel); Go Rec
Return SUM



Function GetDolg(Lic,Mon)
Local Sel:=Select(),Rec:=Recno(),Dolg,Sum:=0
IF Mon>0.and.Mon<13
   Dolg:="Obormot->Debet"+Alltrim(Str(Mon))
ELSE
   Dolg:="Last_Debet"
ENDIF
//@ 1,0 Say Dolg
Select Obormot
Seek Lic
IF Found()
   Sum:=&Dolg
ENDIF
Select(Sel); Go Rec
Return Sum



Function GetRashod(Lic,Mon)
Local Sel:=Select(),Rec:=Recno(),Dolg,tRash:=0,Poisk
//Local tDesc:=Fcreate("aaa")
Select Licevoj
Seek Lic
//IF Found()
   DO While Lic_Sch==Lic
      Poisk:="("+AllTrim(Str(Lic))+")"+AllTrim(Schetchik)
//      IF .not.Reaktivn.and.alltrim(MYupper(Licevoj->schetchik))!="АБОН.МОЩН"
      IF alltrim(MYupper(Licevoj->schetchik))!="АБОН.МОЩН"
         Select(Mon)
         Seek Poisk
//         IF Found().and.Rashod>0
         IF Found().and.Summa#0
//         IF Found()
//            tRash:=tRash+Rashod-SubAb
							IF Rashod>0
								 tRash:=tRash+if((rashod-subab)>0,rashod-subab,subab-rashod)
							ELSE
								 tRash:=tRash+rashod
							ENDIF
//            Fwrite(tDesc,poisk+"   "+AllTrim(Str(Rashod-SubAb))+Chr(13)+Chr(10))
         ENDIF
         Select Licevoj
      ENDIF
      skip
   ENDDO
//ENDIF
//FWrite(tDesc,Str(tRash)+Chr(13)+Chr(10))
//Fclose(tDesc)
Select(Sel); Go Rec
Return tRash



Function GetSum(Lic,Mon)
Local Sel:=Select(),Rec:=Recno(),Dolg,TempSumma:=0,Poisk,SelRec,atSumma:={0,0}
Select Licevoj
SelRec:=Recno()
go top
Seek Lic
IF Found()
   DO While Licevoj->Lic_Sch==Lic
//      IF alltrim(MYupper(Licevoj->schetchik))!="АБОН.МОЩН"
         Poisk:="("+AllTrim(Str(Lic))+")"+AllTrim(Schetchik)
         Select(Mon)
         Seek Poisk
         IF Found().and.summa#0.and.alltrim(MYupper(Licevoj->schetchik))!="АБОН.МОЩН"
				    IF Main->Lic_Schet<99999
				    	 atSumma[1]:=atSumma[1]+Summa
//                TempSumma:=TempSumma+Summa+Round(Summa*schet_nds/100,Decimal)
//                TempSumma:=IF(TempSumma>0,-1,1)*TempSumma
				    ELSE
//                TempSumma:=TempSumma+Summa+Round(IF(.not.isnonds(tarif,Main->Lic_Schet),0,;
//            	                   Summa*schet_nds/100),Decimal )
									IF isnonds(tarif,Main->Lic_Schet)
										 atSumma[1]:=atSumma[1]+Summa
								  ELSE
										 atSumma[2]:=atSumma[2]+Summa
									ENDIF
//            	  TempSumma:=IF(.not.isnonds(tarif,Main->Lic_Schet),1,-1)*TempSumma
            ENDIF
         ENDIF
         Select Licevoj
/*      ELSE
         IF Mon<10.and.Year(New_date)==1998
            Poisk:="("+AllTrim(Str(Lic))+")"+AllTrim(Schetchik)
            Select(Mon)
            Seek Poisk
            IF Found()
				    		IF Main->Lic_Schet<99999
                		TempSumma:=TempSumma+Summa+Round(Summa*schet_nds/100,Decimal )
				    		ELSE
                		TempSumma:=TempSumma+Summa+Round(IF(.not.isnonds(tarif,Main->Lic_Schet),0,;
            	                   		Summa*schet_nds/100),Decimal )
            		ENDIF
            ENDIF
            Select Licevoj
         ENDIF
      ENDIF
*/      
      Skip
   ENDDO
ENDIF
if main->lic_schet<100000
	TempSumma:=TempSumma+atSumma[1]+AtSumma[2]+Round(atSumma[1]*schet_nds/100,Decimal)
else		
	TempSumma:=TempSumma+atSumma[1]+AtSumma[2]
ENDIF		
Go SelRec
Select(Sel)
If Rec!=0
   Go Rec
EndIf
Return TempSumma



Function GetSaldo(Lic,Mon)
Local Sel:=Select(),Rec:=Recno(),Dolg,Saldo:=0
LOCAL Deb:="Obormot->",Kred:="Obormot->"
Lic:=IF(Lic==NIL,Main->Lic_Schet,LIC)
Mon:=IF(Mon==NIL,Month(New_date),Mon)
Deb:=IF(Mon<13,"Debet"+Alltrim(Str(Mon)),"Last_Debet")
Kred:=IF(Mon<13,"Kredit"+Alltrim(Str(Mon)),"Last_Kred")
Select Obormot
Seek Lic
IF Found()
   IF &Deb!=0
      Saldo:=&Deb*-1
   ELSE
      Saldo:=&Kred
   ENDIF
ENDIF
Select(Sel); Go Rec
Return Saldo



Function GetSil(Lic,Type)
Local Sum:=0,Sel:=Select(),Rec:=Recno()
Select Licevoj
Seek Lic
DO While Lic_Sch==Lic
   Sum:=Sum+IF(Type==1,Silowaq,Oswesh)
   SKIP
ENDDO
Select(Sel); Go Rec
Return Sum



Function GetRl(LS,nSch,NMon)
LOCAL Sel:=Select(),Rec:=Recno(),Poisk:="("+Alltrim(Str(Ls))+")"+Alltrim(nSch)
LOCAL Sum:=0
Select(NMon)
Seek Poisk
IF Found()
   Sum:=Rashod
ENDIF
select(Sel); GO Rec
Return Sum



Function GetSl(LS,nSch,NMon)
LOCAL Sel:=Select(),Rec:=Recno(),Poisk:="("+Alltrim(Str(Ls))+")"+Alltrim(nSch)
LOCAL Sum:=0
Select(NMon)
Seek Poisk
IF Found()
   Sum:=Summa
ENDIF
select(Sel); GO Rec
Return Sum




Function GetTitle()
LOCAL show,spisok,is_ch,stri,cho,Sel,rec,ordbuf,buff:=Win_Save(),colorbuf
PRIVATE nm1,nm2,nm3,nm4,t1,l1,b1,r1,inp,Title:={"",""}
Sel:=Select(); Rec=Recno()
Ordbuf=Indexord()
Colorbuf=Setcolor()
IF Urov<1
   IF (.Not. File(schet_share+'Title.Dbf')) .or.;
      (.Not. File(schet_share+'Title.Dbt'))
           sign(2)
           select(sel); go rec
           RETURN Title
   ELSE
      Select 20
      IF NetUse(Schet_Share+"Title.Dbf")
         IF Empty(FieldName(1))
            Wosst=.T.
            Al_Box({"База данных не определена"})
            select(sel); go rec
            RETURN Title
         ENDIF
      ENDIF
   ENDIF
ENDIF
Colorwin(7,45,23,78,"n+/n")
Set Color To N/W
@ 7,43  Say Center('Список готовых заголовков',35," ",.t.)
go top
declare zgl[1]
declare fil[1]
nm1=loarr('zgl','Краткое содержание заголовка')
nm2=loarr('fil','Contens')
inp='0'; t1=7; l1=44; b1=22; r1=77
*********
//message("F1 - Редактирование заголовка; F2 - редактирования окончания",2,15)
//message("Ctrl+Enter - Вставка текущего фрагмента в отчет",5,15)
FsBrowse(7,44,22,77,'fil','zgl',inp,urov,kl)
PREV_REC:=-1
RET_VAL:=2
Select(Sel)
Set Order To Ordbuf
Go Rec
Set Color To (Colorbuf)
Win_Rest(buff)
RETURN Title


Function EditContens(MyField,String,LenEditWindow)
LOCAL Scr:=Win_Save(),Clr:=SetColor()
String:=IF(String==NIL,"Редактирование заголовка",String)
set color to n/w
LenEditWindow:=IF(LenEditWindow==NIL,12,LenEditWindow)
@ 2,0,LenEditWindow,79 box MY_BOX
@ 1,0 say center(String,80," ",.t.)
set key 141 to RusH
set cursor on
set color to w/b
MyField:=hardcr(memoedit(MyField,3,1,LenEditWindow-1,78,,"MyEdit"))
set cursor off
Set Key 141 to
SetColor(Clr); Win_Rest(Scr)
Return MyField


Function MyEdit(Mode,Row,Col)
LOCAL Key:=LastKey()
Do Case
   Case Key==K_ESC
        IF Al_Box({"Редактируемый текст"},2,{" Сохранить "," Выход "})==1
           Return (K_CTRL_W)
        ELSE
           Return (K_ESC)
        ENDIF
EndCase
RETURN 0


Function GetAbonSum(Lic,Month)
Local AbonSum:=0,Sel:=Select(),Rec:=Recno(),Poisk:="("+Alltrim(Str(Lic))+")Абон.Мощн"
Select Licevoj
Seek Lic
If Found()
   Select(Month)
   Seek Poisk
   IF Found()
      AbonSum:=Summa
   EndIf
EndIf
Select(Sel); Go Rec
Return AbonSum



Function GetAbonSaldo(Lic,Month)
LOCAL Sum:=0,Rec:=Recno(),Sel:=Select(),i,Str
Select Obormot
Seek Lic
IF Found().and.month>0
   Str:="SaldoA"+Alltrim(Str(Month))
   Sum:=&Str
ENDIF
Select(Sel); Go Rec
Return Sum



Function GetRasHigh(Lic,Month)
Local RasHigh:=0,Sel:=Select(),Rec:=Recno(),Poisk:=""
Select Licevoj
Seek Lic
IF Found()
   Do While Lic_Sch==Lic
      if licevoj->reaktivn=.f.
         Poisk:="("+Alltrim(Str(Lic))+")"+Alltrim(Schetchik)
         Select(Month)
         Seek Poisk
         IF Found()
            if schet_nl1#licevoj->schetchik.and.schet_nl2#licevoj->schetchik.and.schet_nl3#licevoj->schetchik.and.;
               schet_nl4#licevoj->schetchik.and.schet_nl5#licevoj->schetchik.and.schet_nl6#licevoj->schetchik.and.;
               schet_nl7#licevoj->schetchik.and.schet_nl8#licevoj->schetchik.and.schet_nl9#licevoj->schetchik.and.;
               schet_nl10#licevoj->schetchik.and.schet_nl11#licevoj->schetchik.and.schet_nl12#licevoj->schetchik.and.;
               schet_nl13#licevoj->schetchik.and.schet_nl14#licevoj->schetchik.and.schet_nl5#licevoj->schetchik.and.;
               schet_nl16#licevoj->schetchik.and.schet_nl17#licevoj->schetchik.and.schet_nl18#licevoj->schetchik
                  if tarif#M->schet_tar1.and.tarif#M->schet_tar2.and.tarif#M->schet_tar3.and.tarif#M->schet_tar4.and.;
                     tarif#M->schet_tar5.and.tarif#M->schet_tar6.and.tarif#M->schet_tar7.and.;
                     tarif#M->schet_tar8.and.tarif#M->schet_tar9
                     IF IS_ON_HIGH(tarif) && Тариф в лимит?
                         if summa>0
                            RasHigh=RasHigh+if(rashod-subab>0,rashod-subab,subab-rashod)
                         endif
                     ENDIF
                 endif
            endif
          ENDIF
          Select Licevoj
      endif
      Skip
   EndDo
Endif
Select(Sel); Go Rec
Return RasHigh




Function SrokDolg(nLic,nMon)
Local Sel:=Select(),Rec:=RecNo(),Srok:=0,cStr:=""
Select Obormot
Seek nLic
IF Found()
   For I=nMon To 0 Step -1
       IF I==0
          cStr:="Last_Debet"
          IF &cStr>0
             Srok:=Srok+1
          ENDIF
       ELSE
          cStr:="Debet"+Alltrim(Str(i))
          IF &cStr>0
             Srok:=Srok+1
          ELSE
             Exit
          ENDIF
       ENDIF
   Next
EndIf
Select(Sel)
Go Rec
Return Srok