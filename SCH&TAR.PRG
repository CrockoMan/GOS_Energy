#include "commands.ch"      // Для DEFAULT TO
#include "inkey.ch"


FUNCTION SearchTar()
LOCAL Month,Select:=Select(),Screen,SearchTarif:=0.000,Position:=0
LOCAL Desc,CrLf:=chr(13)+chr(10)
Local oDlg,aSizeDeskTop,aPos,oProgress
Month:=Month_Menu("для выбора номеров счетчиков")
IF Month<1.or.Month>12
   Return NIL
ENDIF
SearchTarif:=GetVal(" Введите тариф для поиска счетчиков ",0.0000,-1)
IF SearchTarif==-1
   Return Nil
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
Select(month)
oProgress:maximum := RecCount()
GO Top
//Screen:=Obrabot("Поиск счетчиков с тарифом "+alltrim(str(SearchTarif)))
Desc:=Fcreate(DDir+ReportFile)
Fwrite(Desc,"Счетчики с тарифом "+alltrim(str(SearchTarif))+" за "+Mesqc(Month)+CrLf)
FWrite(Desc,"┌"+replicate("─",len(str(licevoj)))+"┬"+replicate("─",len(kod))+"┬"+replicate("─",len(str(rashod)))+"┬"+replicate("─",len(str(summa)))+"┐"+CrLf)
FWrite(Desc,"│"+center("Л/c",len(str(licevoj))," ",.t.)+"│"+center("Счетчик N",len(kod)," ",.t.)+"│"+center("Расход",len(str(rashod))," ",.t.)+"│"+center("Сумма",len(str(summa))," ",.t.)+"│"+CrLf)
FWrite(Desc,"├"+replicate("─",len(str(licevoj)))+"┼"+replicate("─",len(kod))+"┼"+replicate("─",len(str(rashod)))+"┼"+replicate("─",len(str(summa)))+"┤"+CrLf)
DO WHILE !Eof()
   oProgress:increment()																				// Progress Bar Increment
//   Position=Position+(39/Reccount())
//   colorwin(12,21,12,21+Position,'n/n')
   IF Tarif==SearchTarif
      FWrite(Desc,"│"+Center(substr(Kod,2,atnum(")",kod)-2),6,"",.t.)+"│ "+space(len(kod)-;
                  len(alltrim(substr(kod,atnum(")",kod)+1)))-2)+;
                  alltrim(substr(kod,atnum(")",kod)+1))+" │"+str(rashod)+;
                  "│"+str(summa)+"│"+CrLf)
   ENDIF
   SKIP
ENDDO
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
FWrite(Desc,"└"+replicate("─",len(str(licevoj)))+"┴"+replicate("─",len(kod))+"┴"+replicate("─",len(str(rashod)))+"┴"+replicate("─",len(str(summa)))+"┘"+CrLf)
Fclose(Desc)
//Win_Rest(Screen)
Select(Select)
RETURN NIL


/*
Function GetVal(String,Value,EcsValue)
Local RowStart:=MaxRow()/2,ColStart:=MaxCol()/2,Screen,Color:=SetColor(),LenVal
DEFAULT EcsValue TO Value
DO Case
   Case ValType(Value)=="C"
        LenVal:=Len(Value)
   Case ValType(Value)=="D"
        LenVal:=Len(Dtoc(new_date))
   Case ValType(Value)=="N"
        LenVal:=Len(str(Value))
EndCase
Screen:=Win_Save(RowStart-1,ColStart-1-(Len(String)+LenVal)/2,RowStart+3,ColStart+4+(Len(String)+LenVal)/2)
Set Color To &GetColor
colorwin(RowStart,ColStart-(Len(String)+LenVal)/2,RowStart+2,ColStart+4+(Len(String)+LenVal)/2,'n+/n')
@ RowStart-1,ColStart-1-(Len(String)+LenVal)/2 say "┌"+Replicate("─",Len(String)+LenVal+3)+"┐"
@ RowStart,ColStart-1-(Len(String)+LenVal)/2 say "│ "+String+Space(LenVal+1)+" │"
@ RowStart+1,ColStart-1-(Len(String)+LenVal)/2 say "└"+Replicate("─",Len(String)+LenVal+3)+"┘"
@ RowStart,ColStart-1-(Len(String)+LenVal)/2+3+len(string) get Value
set cursor on
set confirm on
read
set confirm off
set cursor off
IF Lastkey()==K_ESC
   Value:=EcsValue
ENDIF
         Clear Typeahead
SetColor(Color)
Win_Rest(Screen)
Return Value
*/