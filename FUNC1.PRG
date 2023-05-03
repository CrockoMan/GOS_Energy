#include "Gra.ch"
#include "Xbp.ch"
#include "Appevent.ch"
#include "Font.ch"
#include "commands.ch"      // Для DEFAULT TO
#include "inkey.ch"



Function ChoiceBox(cString,aButtons)
   LOCAL nEvent, mp1, mp2,oParent,oOwner,oFocus:=SetAppFocus()
   LOCAL oDlg, oXbp1, oXbp2, oXbp3, drawingArea, aEditControls := {},RetVal:=0,aSizeDesktop:={}


   cString:=IF(cString==NIL,"",cString)
   aButtons:=IF(aButtons==NIL,{" Да "," Нет "},aButtons)
   	
//   oDlg := XbpDialog():new(AppDesktop(), SetAppWindow(), {350,268}, {368,162}, , .F.)
//-----------------------------------------------------------------------------------------
      aSizeDesktop    := AppDesktop():currentSize()
//      aPos            := { (aSizeDesktop[1]-(DEF_COLS * DEF_FONTWIDTH))  /2, ;
//                           (aSizeDesktop[2]-(DEF_ROWS * DEF_FONTHEIGHT)) /2  }
   oDlg := XbpDialog():new(AppDesktop(), SetAppWindow(), {aSizeDeskTop[1]/2-368/2,;
   	                       aSizeDeskTop[2]/2-162/2}, {368,162}, , .F.)
//-----------------------------------------------------------------------------------------


   oDlg:sysMenu   := .F.
   oDlg:minButton := .F.
   oDlg:maxButton := .F.
   oDlg:border    := XBPDLG_DLGBORDER

//   oDlg:taskList := .T.
   oDlg:title := "Внимание"
   oDlg:create()

   drawingArea := oDlg:drawingArea
   drawingArea:setFontCompoundName( "8.MS Sans Serif" )

   oXbp := XbpStatic():new( drawingArea, , {24,95}, {312,36}, { { XBP_PP_COMPOUNDNAME, "11.MS Sans Serif" } } )
   oXbp:autoSize := .T.
   oXbp:caption := cString
   oXbp:clipSiblings := .T.
   oXbp:options := XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_CENTER
   oXbp:create()

   oXbp := XbpPushButton():new( drawingArea, , {24,24}, {96,36}, { { XBP_PP_BGCLR, XBPSYSCLR_BUTTONMIDDLE }, { XBP_PP_FGCLR, -58 } } )
   oXbp:caption := aButtons[1]
   oXbp:tabStop := .T.
   oXbp:create()
   oXbp:activate := {|| RetVal:=1}

   IF Len(aButtons)>2
   		oXbp := XbpPushButton():new( drawingArea, , {132,24}, {96,36}, { { XBP_PP_BGCLR, XBPSYSCLR_BUTTONMIDDLE }, { XBP_PP_FGCLR, -58 } } )
   		oXbp:caption := aButtons[2]
   		oXbp:tabStop := .T.
   		oXbp:create()
   		oXbp:activate := {|| RetVal:=2 }
   ENDIF

   oXbp := XbpPushButton():new( drawingArea, , {240,24}, {96,36}, { { XBP_PP_BGCLR, XBPSYSCLR_BUTTONMIDDLE }, { XBP_PP_FGCLR, -58 } } )
   oXbp:caption := IF(Len(aButtons)>2,aButtons[3],aButtons[2])
   oXbp:tabStop := .T.
   oXbp:create()
   oXbp:activate := {|| RetVal:=Len(aButtons) }

   oDlg:show()
	 oDlg:setModalState( XBP_DISP_APPMODAL )
   SetAppFocus(oDlg)

   nEvent := xbe_None
   DO WHILE nEvent <> xbeP_Close
      IF RetVal!=0
   			 oDlg:destroy()
     	   Exit
      ENDIF
      nEvent := AppEvent( @mp1, @mp2, @oXbp )
      oXbp:handleEvent( nEvent, mp1, mp2 )
   ENDDO
   SetAppFocus(oFocus)
   	
RETURN RetVal





Function GetStrToken(fStr,Pos,Tok)
Local cStr:="",aPos:={},i
For I=1 to Len(fStr)
    IF Substr(fStr,i,1)==Tok
       AADD(aPos,i)
    ENDIF
Next
IF Len(aPos)>0
   IF Pos==1
      cStr:=Substr(fStr,1,aPos[1]-1)
   ELSE
      cStr:=Substr(fStr,aPos[Pos-1]+1,aPos[Pos]-aPos[Pos-1]-1)
   ENDIF
ENDIF
Return cStr




Function ClearBuffer()
Local nKey
IF (nKey:=NextKey())<>0
   Do While nKey<>0
      nKey:=NextKey()
      IF nKey<>0
         Inkey(1)
      ENDIF
   ENDDO
Else
ENDIF
Keyboard Chr(255)
PostAppEvent(32)
Inkey()
Return NIL



Function TimeKey()
Local cKey:="",nSec:=Seconds(),nYear:=Year(New_date)
Local nMonth:=Month(New_date),nDay:=Day(New_date)
cKey:=Str(nYear,4)+IF(nMonth<10,"0","")+AllTrim(Str(nMonth,2))
cKey:=cKey+IF(nDay<10,"0","")+AllTrim(Str(nDay,2))
cKey:=cKey+Replicate("0",5-Len(AllTrim(Str(nSec,5))))+AllTrim(Str(nSec,5))
Return cKey



Function GoBase(Recno)
IF RecNo!=0
   Go Recno
ENDIF
Return NIL
//---------------------------------------------------------------------------
// Функция создания файла базы данных
// Параметры : Fields - Многомерный массив структуры базы данных, где
//                      1-й элемент - имя поля
//                      2-й элемент - тип поля (один символ)
//                      3-й элемент - длинны поля
//                      4-й элемент - количество десятичных знаков поля
//             FileName - Имя создаваемого файла базы данных
//
FUNCTION MakeDbf(Fields,FileName)
CREATE Struct
FOR I=1 TO Len(Fields)
    APPEND BLANK
    REPLACE Field_Name With Fields[i][1]
    REPLACE Field_Type With Fields[i][2]
    REPLACE Field_Len With Fields[i][3]
    REPLACE Field_Dec With Fields[i][4]
NEXT
CLOSE
CREATE &FileName FROM Struct
DeleteFile("struct.dbf")
RETURN Nil



************************************************************************
*  CHAR    delstring(string1,string2,is_all)
*  CHAR    string1,string2     - Входная строка, срока поиска
*  LOGICAL is_all              - удалять все после строки STRING2
*  RETURN: CHAR строка, выделенная из исходной без строки STRING2

function delstring(string1,string2,is_all)
LOCAL ret_string:=string1,len1,len2
is_all:=if(is_all==NIL,.T.,is_all)
len1=len(string1)
len2=len(string2)
for i=1 to len1
    if substr(string1,i,len2)=string2
       if is_all
          ret_string=substr(string1,1,i-1)
       else
          ret_string=substr(string1,1,i-1)
          ret_string=ret_string+substr(string1,i+len2)
       endif
       exit
    endif
next
return ret_string

************************************************************************
*  NUMERIC hot_inkey(wait_val)
*  NUMERIC wait_val     - Число секунд для ожидания
*  RETURN: Числовой код нажатой клавиши, 0 - если нажатия не было.
*  Замена inkey, позволяющая организовывать горячие ключи.

#include "commands.ch"     // Для команды REPEAT UNTIL

FUNCTION hot_inkey(wait_val)
LOCAL hot_key, lkey, key_blk
        REPEAT
           hot_key = .F.
           IF wait_val = NIL
              lkey = inkey()
           ELSE
              lkey = inkey(wait_val)
           ENDIF
           IF lkey != 0 .AND. (key_blk := setkey(lkey)) != NIL
              eval(key_blk, procname(2), procline(2), "")
              hot_key = .T.
           ENDIF
        UNTIL ! hot_key
RETURN lkey
*******************************************************************************
/*              Вывод строки cText в строке nRow цветом nCol
                строка выводится из центра к краям                           */
function saycenter(cText,nRow,nCol,lMode)
nRow:=IF(nRow==NIL,MaxRow()/2,nRow)
nCol:=IF(nCol==NIL,7,nCol)
lMode:=if(lMode==NIL,.T.,lMode)
IF lMode==.T.
   SAYSPREAD(cText, nRow, nCol )
ELSE
   nCol:=int(maxcol()/2-Len(cText)/2)
   @ nRow, nCol say cText
ENDIF
return NIL

*******************************************************************************
//  Очистка экрана от координат Tol,Left до Bottom,Right c задержкой Delay

FUNCTION ClearToMid(Delay, Top, Left, Bottom, Right)
 Delay =IF(Delay ==NIL,20,      Delay )
 Top   =IF(Top   ==NIL, 0,      Top   )
 Left  =IF(Left  ==NIL, 0,      Left  )
 Bottom=IF(Bottom==NIL,maxrow(),Bottom)
 Right =IF(Right ==NIL,maxcol(),Right )
 DO WHILE Left <= Right
   CLEARWIN(Top, Left,  Bottom, Left)
   CLEARWIN(Top, Right, Bottom, Right)
   MILLISEC(Delay)
   Left  := Left  +1
   Right := Right -1
 ENDDO
RETURN NIL

*******************************************************************************
//  Изменение отрибутов экрана OldColor на NewColorm от координат Tol,Left до
//  Bottom,Right c задержкой Delay

FUNCTION ColorToMid(Delay, Top, Left, Bottom, Right, NewColor, OldColor)
 DO WHILE Left <= Right
    COLORWIN(Top, Left,  Bottom, Left,  NewColor, OldColor)
    COLORWIN(Top, Right, Bottom, Right, NewColor, OldColor)
*    MILLISEC(Delay)
    Left  := Left  +1
    Right := Right -1
 ENDDO
RETURN NIL

*******************************************************************************
// Вывести текст cRowText в координатах nRow, nCol

FUNCTION SayTop(cRowText, nRow, nCol)
LOCAL i
 nColNum := LEN(cRowText)
 FOR i = 0 TO nRow -1
   cRowTextOld := SCREENSTR(i, nCol, nColNum)
   @ i, nCol SAY cRowText
   MILLISEC(MAXROW() -i)
   STRSCREEN(cRowTextOld, i, nCol)
 NEXT i
 @ nRow, nCol SAY cRowText
RETURN NIL

// Заполнение всего экрана текстом String
//FUNCTION StrWin(String)
// _SAYWRAP(LEFT(REPLICATE(String,;
//          (SCREENSIZE() /2) /LEN(String) +1),;
//          (SCREENSIZE() /2)), 0, 0)
//RETURN NIL
*******************************************************************************

function search_
LOCAL is_sch_fou:=.F.,NumPos:=-1,Desc,CrLf:=Chr(13)+Chr(10)
private num_off,old_co,old_se,recn
old_se=select()
recn=recno()
num_off=space(len(a->num_of_sch)+3)
old_co=setcolor()
Save screen
set color to  &GetColor
colorwin(7,20,9,65,'b/n')
@ 06,19 say " ┌─────────────────────────────────────────╖ "
@ 07,19 say " │ Требующийся счетчик =>                  ║ "
@ 08,19 say " ╘═════════════════════════════════════════╝ "
set color to  &GetColor
@ 07,44 get Num_off
set cursor on
set confir on
read
set curs off
set conf off
Restore screen
save screen
if lastkey()#27
   Clear Typeahead
   message(" Поиск счетчика N "+num_off)
   select Licevoj
   locate for Schetchik=AllTrim(num_off)
   if found()
      lic_=lic_Sch
      Select 88
      seek lic_
      ret_val=2
      Is_Sch_Fou:=.T.
      NumPos:=RecNo()
//      Desc:=Fcreate(Dir+ReportFile)
//      Fwrite(Desc,"Найденные счетчики N"+AllTrim(Num_Off)+CrLf)
//      Fwrite(Desc,Str(Lic_)+" "+Potreb+" "+Tip+CrLf)
//      Do While Found()
//         Fwrite(Desc,Str(Lic_Sch)+" "+Potreb+" "+Tip+CrLf)
//         Continue
//      ENDDO
//      Fclose(Desc)
      Go NumPos
   else
      select (old_se)
      go recn
      al_box({"Счетчик N "+alltrim(num_off)+" не найден"})
   endif
endif
setcolor(old_co)
select(old_se)
Restore screen
Clear Typeahead
return Is_Sch_Fou







function load(oblast,database,ind1,ind2,is_monopol,Ind3,Ind4,Ind5,Ind6,cAlias,Ind7)
LOCAL retlogval
is_monopol:=if(is_monopol==NIL,.T.,.F.)
cAlias:=IF(cAlias==NIL,"",cAlias)
if file(database)
   DO CASE
      CASE database#NIL.and.ind1#NIL.and.ind2#NIL.and.Ind3#Nil
              @ maxrow(),0 say ' '+database+'           '
              select &oblast
//              retlogval:=superload(database,ind1,ind2,is_monopol)
              	 retlogval:=netuse(database,is_monopol,,cAlias)
              IF Retlogval
                 set index to &ind1,&ind2,&ind3
              ENDIF
      CASE database#NIL.and.ind1#NIL.and.ind2#NIL.and.Ind3#Nil.and.Ind4#Nil.and.Ind5#Nil.and.Ind6#Nil.and.Ind7#Nil
              @ maxrow(),0 say ' '+database+'           '
              select &oblast
//              retlogval:=superload(database,ind1,ind2,is_monopol)
              retlogval:=netuse(database,is_monopol,,cAlias)
              IF Retlogval
                 set index to &ind1,&ind2,&ind3,&ind4,&ind5,&Ind6,&Ind7
              ENDIF
      CASE database#NIL.and.ind1#NIL.and.ind2#NIL.and.Ind3#Nil.and.Ind4#Nil.and.Ind5#Nil.and.Ind6#Nil
              @ maxrow(),0 say ' '+database+'           '
              select &oblast
//              retlogval:=superload(database,ind1,ind2,is_monopol)
              retlogval:=netuse(database,is_monopol,,cAlias)
              IF Retlogval
                 set index to &ind1,&ind2,&ind3,&ind4,&ind5,&Ind6
              ENDIF
      CASE database#NIL.and.ind1#NIL.and.ind2#NIL
              @ maxrow(),0 say ' '+database+'           '
              select &oblast
//              retlogval:=superload(database,ind1,ind2,is_monopol)
              retlogval:=netuse(database,is_monopol,,cAlias)
              IF Retlogval
                 set index to &ind1,&ind2
              ENDIF
      CASE database#NIL.and.ind1#NIL.and.ind2=NIL
              @ maxrow(),0 say ' '+database+'           '
              select &oblast
//              retlogval:=superload(database,ind1,,is_monopol)
              retlogval:=netuse(database,is_monopol,,cAlias)
              IF Retlogval
                 set index to &ind1
//                 Set index to "d:\gos\alaska\database\pllocal.ntx"
              ENDIF
      CASE database#NIL.and.ind1=NIL.and.ind2=NIL
              @ maxrow(),0 say ' '+database+'           '
              select &oblast
//              retlogval:=superload(database,,,is_monopol)
              retlogval:=netuse(database,is_monopol,,cAlias)
   ENDCASE
ELSE
        al_box({'Отсутствует файл ',database})
        wosst=.t.
ENDIF
RETURN RetLogVal


function month_menu(MenuString)
local old_scr:=win_save(6,30,23),Len,I:=3
spisok:={if(pcount()=0,"для генерации отчета"," для поиска оплаты"),;
         "───────────────────",;
         "  Январь           ",;
         "  Февраль          ",;
         "  Март             ",;
         "  Апрель           ",;
         "  Май              ",;
         "  Июнь             ",;
         "  Июль             ",;
         "  Август           ",;
         "  Сентябрь         ",;
         "  Октябрь          ",;
         "  Ноябрь           ",;
         "  Декабрь          "}
IF ValType(MenuString)=="C"
   IF Len(MenuString)<=19
      Spisok[1]=center(MenuString,19," ",.t.)
   ELSE
      Len:=Len(MenuString)
      Spisok[1]=MenuString
      Spisok[2]=center(Spisok[2],Len," ",.t.)
      FOR I=3 to 14
          Spisok[I]=Spisok[I]+Space(Len-Len(Spisok[I]))
      NEXT
   ENDIF
ENDIF
is_choice:={.f.,.f.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}
pos=month(New_date)+2
choice=vert_menu(spisok,"Укажите месяц",is_choice,6,30,pos,'n/w,n/g,,,n/w',.F.)
choice=choice-if(choice#0,2,0)
win_rest(old_scr)
return choice



FUNCTION Kvartal_menu(MenuString)
local old_scr:=win_save(10,30,23),Len,I:=3
spisok:={if(pcount()=0,"для генерации отчета"," для поиска оплаты"),;
         "─────────────────────────────",;
         "  Первый квартал           ",;
         "  Втророй квартал          ",;
         "  Третий квартал          ",;
         "  Четвертый квартал          "}
IF ValType(MenuString)=="C"
   IF Len(MenuString)<=19
      Spisok[1]=center(MenuString,29," ",.t.)
   ELSE
      Len:=Len(MenuString)
      Spisok[1]=MenuString
      Spisok[2]=center(Spisok[2],Len," ",.t.)
      FOR I=3 to Len(Spisok)
          Spisok[I]=Spisok[I]+Space(Len-Len(Spisok[I]))
      NEXT
   ENDIF
ENDIF
is_choice:={.f.,.f.,.t.,.t.,.t.,.t.}
pos=month(New_date)/3
choice=vert_menu(spisok,"Укажите квартал",is_choice,10,32,pos,'n/w,n/g,,,n/w',.F.)
choice=choice-if(choice#0,2,0)
win_rest(old_scr)
return choice



function mesqc(month)
mesqc=''
do case
        case month=1
                mesqc='Январ'+if(pcount()>1,'я','ь')
        case month=2
                mesqc='Феврал'+if(pcount()>1,'я','ь')
        case month=3
                mesqc='Март'+if(pcount()>1,'а','')
        case month=4
                mesqc='Апрел'+if(pcount()>1,'я','ь')
        case month=5
                mesqc='Ма'+if(pcount()>1,'я','й')
        case month=6
                mesqc='Июн'+if(pcount()>1,'я','ь')
        case month=7
                mesqc='Июл'+if(pcount()>1,'я','ь')
        case month=8
                mesqc='Август'+if(pcount()>1,'а','')
        case month=9
                mesqc='Сентябр'+if(pcount()>1,'я','ь')
        case month=10
                mesqc='Октябр'+if(pcount()>1,'я','ь')
        case month=11
                mesqc='Ноябр'+if(pcount()>1,'я','ь')
        case month=12
                mesqc='Декабр'+if(pcount()>1,'я','ь')
endcase
return mesqc

func proverka
param pokaz,last
IF (Pokaz-Last)>=0
   Temp:=Pokaz-Last
ELSE
   len=len(alltrim(str(last)))
   temp=1+val(replicate('9',len))
   temp=temp-last
   temp=temp+pokaz
ENDIF
return temp



******************************************************************************
*  Функция вывода информационной строки о F-клавишах
*  До 6-и символов в параметре
******************************************************************************
FUNCTION Fkeys
param msg1,msg2,msg3,msg4,msg5,msg6,msg7,msg8,msg9,msg10
private old_col,_msg,col
old_col=setcolor()
set color to w+/n
@ maxrow(),00 SAY "F1"
@ maxrow(),8 say 'F2'
@ maxrow(),16 say 'F3'
@ maxrow(),24 say 'F4'
@ maxrow(),32 say 'F5'
@ maxrow(),40 say 'F6'
@ maxrow(),48 say 'F7'
@ maxrow(),56 say 'F8'
@ maxrow(),64 say 'F9'
@ maxrow(),72 say 'F10'
SET COLOR TO N/BG
col=2
for i=1 to 10
        _msg='msg'+alltrim(str(i))
        if empty(&_msg)
                @ maxrow(),col SAY "      "
        else
                @ maxrow(),col SAY &_msg+space(6-len(&_msg))
        endif
        if i<9
                col=col+8
        else
                col=col+9
        endif
next
setcolor(old_col)
return ''
******************************************************* End of function




******************************************************************************
*                     Функция вывода сообщения об ошибке
******************************************************************************
FUNCTION MyError
PARAMETERS msg,pause
private old_col,old_scre,tone,ret_val,curs
curs=csetcurs()
if curs
        set cursor off
endif
old_col=setcolor()
if pcount()=1
        msg=msg+' Нажмите клавишу...'
else
        if pause=0
                msg=msg+' Нажмите клавишу...'
        endif
endif
set color to gr+/r
col = INT((80 - LEN(msg))/2) - 2
old_scre=savescreen(10,col,13,col+len(msg)+6)
colorwin(11,col+1,13,col+len(msg)+6,'+n/n')
@ 10, col CLEAR TO 12, col + LEN(msg) + 4
@ 10, col,12, col + LEN(msg) + 4  box '┌─╖║╝═╘│ '
@ 11, col + 2 SAY msg
//SayRandom(msg, 11, col+2)
? chr(7)
*sound(300,15)
if pcount()=2
        ret_val=hot_INKEY(pause)
else
        ret_val=hot_inkey(0)
endif
restscreen(10,col,13,col+len(msg)+6,old_scre)
setcolor(old_col)
if curs
        set cursor on
endif
RETURN ret_val
************************************************* End of function


******************************************************************************
*             Функция вывода сoобщения c задержкой для нажатия клавиши
******************************************************************************
FUNCTION message_wait
PARAMETERS msg
private old_col,old_scr,curs
curs=csetcurs()
if curs
        set cursor off
endif
old_col=setcolor()
*sound(2600,3)
*? chr(7)
msg=msg+' Нажмите любую клавишу...'
set color to bg+/b
col = INT((80 - LEN(msg))/2) - 2
old_scr=savescreen(10,col,13,col+len(msg)+6)
colorwin(11,col+1,13,col+len(msg)+6,'n+/n')
@ 10, col CLEAR TO 12, col + LEN(msg) + 4
@ 10, col,12, col + LEN(msg) + 4  box '┌─╖║╝═╘│ '
*@ 11, col + 2 SAY msg
SayRandom(msg, 11, col+2)
hot_INKEY(0)
restscreen(10,col,13,col+len(msg)+6,old_scr)
setcolor(old_col)
if curs
        set cursor on
endif
RETURN ""
**************************************************** End of function



******************************************************************************
*             Функция вывода сoобщения без ожидания нажатия клавиши
******************************************************************************
FUNCTION message(msg,t,l)
t:=if(t==NIL,10,t)
l:=if(l==NIL,INT((80 - LEN(msg))/2) - 2,l)
private old_col,old_scr
old_col=setcolor()
set color to w+/r+
colorwin(t+1,l+1,t+3,l+len(msg)+6,'n+/n')
@ t, l CLEAR TO t+2, l + LEN(msg) + 4
@ t, l,t+2, l + LEN(msg) + 4  box '┌─╖║╝═╘│ '
@ t+1, l + 2 SAY msg
setcolor(old_col)
RETURN ""
**************************************************** End of function



****************
* Функция требующая подтверждения либо отрицания
****************
    func yes_or_not
      para quest_str1,quest_str2,quest_str3,quest_str4,quest_str5,quest_str6
      priv i,old_color,temp,c_temp,p_to_Enter,p_to_Left,p_to_Right,old_s,old_a,enter
        priv old_w,left,right,col_ten
        enter=13
        left=19
        right=4
if .not.iscolor()
        col_ten="w+/n"
else
        col_ten="n+/n"
endif

        old_w=wselect()
        wselect(0)
         p_to_Enter=csetkey(Enter)
         p_to_Left=csetkey(Left)
         p_to_Right=csetkey(Right)
         if .not.empty(p_to_Enter)
            set key Enter to
         endif
         if .not.empty(p_to_Left)
             set key Left to
         endif
         if .not.empty(p_to_Right)
            set key Right to
         endif
         temp=max(len(quest_str1),14)
         old_color=setcolor('n/w,gr+/g')
         old_s=savescreen(6,(77-temp)/2,12+pcount(),(77-temp)/2+temp+2)
         old_a=screenattr(7,(77-temp)/2+1)
         colorwin(7,(77-temp)/2+1,12+pcount(),(77-temp)/2+temp+2,col_ten)
         @ 6,(77-temp)/2,11+pcount(),(77-temp)/2+temp+1 box"╔═╗║╝═╚║ "
         @ pcount()+9,int((temp-14)/3)+(77-temp)/2+1 prompt chr(16)+" Да  "+chr(17)
         @ row(),col() say "▄"
         @ row(),col()+3            prompt chr(16)+" Нет "+chr(17)
         @ row(),col() say "▄"
         @ pcount()+10,int((temp-14)/3)+1+(77-temp)/2+1 say "▀▀▀▀▀▀▀"
         @ row(),col()+4 say "▀▀▀▀▀▀▀"
         for i=1 to pcount()
             c_temp='quest_str'+str(i,1)
             @ i+7,(77-temp)/2+1 say &c_temp
*            SayRandom(&c_temp, i+7, (77-temp)/2+1)
         next

         i=1
*         clear typeahead    && Если в буфеpе есть коды
         menu to i
         restscreen(6,(77-temp)/2,12+pcount(),(77-temp)/2+temp+2,old_s)
         if .not.empty(p_to_Enter)
            set key Enter to &p_to_Enter
         endif
         if .not.empty(p_to_Left)
             set key Left to &p_to_Left
         endif
         if .not.empty(p_to_Right)
            set key Right to &p_to_Right0
         endif

         setcolor(old_color)
        wselect(old_w)
         if i <> 1
            return .f.
         endif
    return .t.
*************************************************** End of function


function printer
private ret_val,status,scree
do while .t.
        status=printstat()
        do case
                case status=56
                        if Myerror("  В принтере нет бумаги (Esc-выход) ",2)=27
                                ret_val=.f.
                                exit
                        endif
                case status=200.or.status=248
                        if Myerror('  Принтер не подключен к сети (Esc-выход) ',2)=27
                                ret_val=.f.
                                exit
                        endif
                case status=48.or.status=112
                        Myerror('  Принтер  не  обнаружен  ! ')
                        ret_val=.f.
                        exit
                case status=40
                        if Myerror('  В принтер не вставлена бумага ! (Esc-выход)',2)=27
                                ret_val=.f.
                                exit
                        endif
                case status=0
                        if Myerror('  Нет индикации готовности принтера к печати ! (Esc-выход)',2)=27
                                ret_val=.f.
                                exit
                        endif
                case status=24
                        if Myerror('  Нет индикации готовности принтера к печати ! (Esc-выход)',2)=27
                                ret_val=.f.
                                exit
                        endif
                case status=144
                        ret_val=.t.
                        exit
                otherwise
                        if Myerror('  Неопознанная ошибка принтера '+alltrim(str(status)),5)==27
                           ret_val=.f.
                           exit
                        endif
        endcase
enddo
return ret_val




*********
* t,l,b,r - координаты окна
* field_list - массив названий полей
* n_col - массив названий колонок
* inp - массив наличия индексов для поиска по полям начиная с пеpвого
* urov - уpовень вложенности пpогpаммы
* kl - ключ по виду вызова спpавочника
* b_color -
* head_color -
*********
funct FSBROWSE
Param t, l, b, r, field_list, n_col,in_pol,urov,kl,IsEdit
PRIVATE n,move_chrs,force_rec,ntx_expr,ntx_eval,prev_rec,color_buf,;
gts_data,is_append,any_append,keystroke,e_field,get_data,fbrose_buf,c_b,tr_lst,;
mkdoc,mkkl
IsEdit:=If(IsEdit==NIL,.T.,IsEdit)
//FsKeyboard:=If(FsKeyboard==NIL,"",FsKeyboard)
//IF !Empty(FsKeyBoard)
//   Al_Box({FsKeyBoard})
//EndIf
if .not.wosst
        IF EMPTY(FIELDNAME(1))
           * база данных не опpеделена
           wosst:=.T.
           RETURN .F.
        ENDIF
else
        al_box({"Выполните восстановление файлов из резервной копии"})
        RETURN .F.
endif
fbrowse_buf = SAVESCREEN(0,0,24,79)
c_b=setcolor()
* описание окна
if select()=33
        t1=3
        l1=3
        b1=7
        r1=77
        @ 3, 3, 7, 77 BOX "╒═╕│╛═╘│ "
        @ 3 + 2, 3 SAY "╞"
        @ 3 + 2, 77 SAY "╡"
else
        @ t1, l1, b1, r1 BOX "╒═╕│╛═╘│ "
        @ t1 + 2, l1 SAY "╞"
        @ t1 + 2, r1 SAY "╡"
endif
* знаки пеpесылки вниз, ввеpх, PgUp,PgDn,^PgUp,^PgDn
move_chrs = CHR(24) + CHR(5) + CHR(3) + CHR(18) + CHR(31) + CHR(30)
* инициализация пеpеменных pедактиpования
force_rec = .T.
is_append = .F.
any_append = .F.
if select()#55
        prev_rec = 0
else
        prev_rec=recno()
endif
IF LASTREC() = 0
   * пустой файл ..pежим добавления
   KEYBOARD CHR(24)
ENDIF
IF ISCOLOR()
        if select()<=5 .or. select()=15.or.select()=33.or.select()=22.or.select()=55
           SET COLOR TO n/g,w+/B
        else
*          SET COLOR TO n/bg,w+/r,w/n,w/n,w+/b
           SET COLOR TO n/bg,w+/b
        endif
ELSE
   SET COLOR TO N/W, W/N
ENDIF
Clear Typeahead
ClearBuffer()
//KeyBoard (FsKeyboard)
IF IsEdit
   if select()=33
        DBEDIT(3+1, 3+1, 7, 77-1, &field_list, "xsbrowse", .T., &n_col, .T., .T.,"═╧═")
   else
        DBEDIT(t1+1, l1+1, b1, r1-1, &field_list, "xsbrowse", .T., &n_col, .T., .T.,"═╧═")
   endif
ELSE
        DBEDIT(t1+1,l1+1,b1,r1-1,&field_list,,,&n_col,,,"═╧═")
ENDIF
Clear Typeahead
if select()=88
        rec88=recno()
endif
set color to (c_b)
RESTSCREEN(0,0,24,79, fbrowse_buf)
RETURN .T.



proc SOB(ft,string)
private color_buf
color_buf=SETCOLOR()
if ft==nil
   SET COLOR TO n/w
   colorwin(9,16,13,66,'n+/n')
else
   SET COLOR TO W+/n
endif
@ 8,15 clear to 12,65
@ 8,15 to 12,65
if (FT==NIL)
   @ 10,16 SAY center(string,48,.t.," ")
else
   @ 10,18 SAY 'Ждите, идет индексация базы данных '+ft
endif
SET COLOR TO (color_buf)
return



FUNC ISDATA
PARAM key
RETURN IF(key>32 .AND. key<=175 .OR. key>223 .AND. key<240,.T., .F.)


FUNC LOARR
PARAM  name,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20
PRIVATE elm,nop
nop=PCOUNT()-1
FOR I=1 TO nop
        elm='f'+LTRIM(STR(I))
        &name[I]=&elm
NEXT
RETURN name





***************** Поиск по набранному условию *************
*                    в текущем поле ввода                 *
FUNCTION   SEARCH
PRIVATE c_ord, ord_buf, keysearch, search_buf, color_buf, search_var,r_s,l_wind:=0,;
aaa,is_found:=.F.
recno=recno()
SET EXACT OFF
DO CASE
   CASE type(e_field)='N'
        e_f=str(&e_field)
        l_wind=LEN(e_f)+4
        search_var=&e_field-&e_Field
   CASE TYPE(e_field)='C'
        l_wind=LEN(&e_field)+4
        IF .not.Empty(cSearch)
           search_var=substr(cSearch+SPACE(LEN(&e_field)-Len(cSearch)),1,LEN(&e_field))
        ELSE
           search_var=SPACE(LEN(&e_field))
           cSearch:=Search_Var
        Endif
   CASE TYPE(e_field)='L'
        search_var=.T.
        l_wind=5
   CASE TYPE(e_field)='D'
        l_wind=12
        if select()=14 .and. f_script=5
                search_var=substr(dtoc(New_date),7,2)+substr(dtoc(New_date),4,2)+substr(dtoc(New_date),1,2)
        else
                search_var=New_date
        endif
ENDCASE
IF l_wind<22
   l_wind=22
ENDIF
color_buf=SETCOLOR()
search_buf=SAVESCREEN(19,10,22,(10+l_wind+2))
colorwin(20,12,22,(10+l_wind+2),'n/n')
SET COLOR TO n/w,n/w
@ 19,10,21,(10+l_wind) BOX "╒═╕│╛═╘│ "
SayRandom('Введи ключ поиска', 19, 12,'n/w')
SET CURS ON
SET CONF ON
Clear TypeAhead
@ 20,12 GET search_var picture "@K"
READ
SET CURS OFF
SET CONF OFF
IF LastKey()=27
   Clear Typeahead
   go recno
   ret_val=1
   SET COLOR TO (color_buf)
   RESTSCREEN(19,10,22,(10+l_wind+2),search_buf)
   return .f.
endif
ClearBuffer()
Clear Typeahead
aaa=savescreen(10,0,13,79)
message('   Поиск по индексу   ')
IF TYPE(e_field)='C'
   keysearch=TRIM(search_var)
ELSE
   keysearch=search_var
ENDIF
if val(substr(in_pol,f_script,1))#0
   IF Select()==88.and.MainOrder==2.and.f_script==2
      SEEK MyUpper(keysearch)
   ELSE
      ord_buf=IndexOrd()
      SET ORDER TO val(substr(in_pol,f_script,1))
      SEEK keysearch
      SET ORDER TO ord_buf
   ENDIF
else
      GO TOP
      LOCATE  FOR (e_field)=keysearch
      ret_val=2
ENDIF
IF FOUND()
   ret_val=2
   r_s=.T.
   is_found=.T.
ELSE
   message('  Поиск по вхождению  ')
   IF TYPE(e_field)='C'
        k_keysearch=MYupper(alltrim(search_var))
        IF MYUpper(Alltrim(cSearch))!=k_KeySearch
           go top
           cSearch:=Search_Var
        ELSE
           go Recno; skip
        ENDIF
        do while .not.eof()
           Inkey()
           IF LastKey()==27
              IF Al_Box({"Прервать поиск"},2)==1
                 IS_Found:=.F.
                 EXIT
              ENDIF
           ENDIF
           if atnum(k_keysearch,MYupper(alltrim(&e_field)),1)>0
              r_s=.T.
              is_found=.T.
              exit
           endif
           skip
        enddo
   Endif
   if .not.is_found
        DO CASE
           CASE type(e_field)='N'
                keysearch=alltrim(str(keysearch))
           CASE TYPE(e_field)='L'
                keysearch=if(keysearch,".T.",".F.")
           CASE TYPE(e_field)='D'
                keysearch=dtoc(keysearch)
        ENDCASE
        al_box({'Отсутствует "'+keysearch+'"'})
        go recno()
        ret_val:=2
        r_s=.F.
   ENDIF
ENDIF
Clear Typeahead
restscreen(10,0,13,79,aaa)
SET COLOR TO (color_buf)
RESTSCREEN(19,10,22,(10+l_wind+2),search_buf)
RETURN r_s





function obrabot(string,row,col,color,IsSay)
//private old_col,curs,myscreen
LOCAL old_col,curs,myscreen,Screen,ScreenSave:="",I
row=if(row==NIL,10,row)
col=if(col==NIL,18,col)
IsSay:=IF(IsSay==NIL,.F.,IsSay)
string=if(string==NIL,"",string)
color:=if(color==NIL,'n/w',color)
curs=csetcurs()
if curs
        set cursor off
endif
myscreen:=win_save(row,col,row+5,col+47)
old_col=setcolor()
setcolor(color)
IF IsSay
   @ row+1,col+1 say center(string,42,' ',.t.)
   setcolor(Old_Col)
   Return MyScreen
ENDIF
Screen:=SaveScreen(row,col+12,row,col+30)
FOR I=1 TO Len(Screen) STEP 4
    ScreenSave:=ScreenSave+SubStr(Screen,I,1)
NEXT
IF AllTrim(ScreenSave)!="О Б Р А Б О Т А Н О"
   colorwin(row+1,col+1,row+5,col+47,'n+/n')
ENDIF
@ row  ,col say "┌────────── О Б Р А Б О Т А Н О  :───────────╖"
@ row+1,col say "│"+space(44)+"║"
@ row+2,col say "│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║"
@ row+3,col say "│  0%.......25%......50%......75%......100%  ║"
@ row+4,col say "╘════════════════════════════════════════════╝"
if pcount()#0
//      set color to n/w
        @ row+1,col+1 say center(string,42,' ',.t.)
*       SayRandom(center(string,42,' ',.t.), 11, 19,'n/w')
endif
setcolor(old_col)
if curs
        set cursor on
endif
return myscreen





function obrabot2(string,row,col,color,IsSay)
LOCAL old_col,curs,myscreen,Screen,ScreenSave:="",I
row=if(row==NIL,10,row)
col=if(col==NIL,18,col)
IsSay:=IF(IsSay==NIL,.F.,IsSay)
string=if(string==NIL,"",string)
color:=if(color==NIL,'n/w',color)
curs=csetcurs()
if curs
        set cursor off
endif
myscreen:=win_save(row,col,row+5,col+47)
old_col=setcolor()
setcolor(color)
IF IsSay
   @ row+1,col+1 say center(string,42,' ',.t.)
   setcolor(Old_Col)
   Return MyScreen
ENDIF
Screen:=SaveScreen(row,col+12,row,col+30)
FOR I=1 TO Len(Screen) STEP 4
    ScreenSave:=ScreenSave+SubStr(Screen,I,1)
NEXT
IF AllTrim(ScreenSave)!="Сейчас:"
   colorwin(row+1,col+1,row+5,col+47,'n+/n')
ENDIF
@ row  ,col say "┌────────────────────────────────────────────╖"
@ row+1,col say "│   Сейчас:             Окончание:           ║"
@ row+2,col say "│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║"
@ row+3,col say "│  0%.......25%......50%......75%......100%  ║"
@ row+4,col say "╘════════════════════════════════════════════╝"
if pcount()#0
        @ row,col+2 say center(string,42,'─',.t.)
endif
setcolor(old_col)
if curs
        set cursor on
endif
return myscreen







function prov_tarif
para tarif
private ret_val
ret_val=0
do case
        case tarif=main->lim_tar1
                ret_val=rashod
        case tarif=main->lim_tar2
                if .not.empty(main->lim_tar2)
                        ret_val=rashod
                endif
        case tarif=main->lim_tar3
                if .not.empty(main->lim_tar3)
                        ret_val=rashod
                endif
endcase
return ret_val





function make_ind(oblast,database,ind1,pole1,ind2,pole2,monopol,Is_Close)
LOCAL old_scr,oldscr,retlogval:=.T.,win:=win_save(),clr:=setcolor()
LOCAL Pcount:=0
work(maxrow(),0)
Monopol:=IF(Monopol==NIL,.F.,Monopol)
Is_Close:=If(Is_Close==NIL,.T.,Is_Close)
pcount=if(oblast!=NIL,pcount+1,pcount)
pcount=if(database!=NIL,pcount+1,pcount)
pcount=if(ind1!=NIL,pcount+1,pcount)
pcount=if(pole1!=NIL,pcount+1,pcount)
pcount=if(ind2!=NIL,pcount+1,pcount)
pcount=if(pole2!=NIL,pcount+1,pcount)
IF FILE(DataBase)
   DO CASE
      CASE pcount=6
           select &oblast
           IF NetUse(database,Monopol,0.1,,.f.)
              IF !NetErr()
                 indexing(pole1,ind1,database)
                 indexing(pole2,ind2,database)
                 IF Is_Close
                    Use
                 ENDIF
              ELSE
                 IF NetUse(database,,0.1,,.f.)
                    CLOSE
//                    inkey(0.1)
                 ELSE
                    DO WHILE NetUse(database,,0.1,,.f.)
                       CLOSE
                    ENDDO
                 ENDIF
                 retlogval:=.F.
              ENDIF
           ENDIF
      CASE pcount=4
           select &oblast
           IF NetUse(database,Monopol,0.1,,.f.)
              IF !NetErr()
                 indexing(pole1,ind1,database)
                 IF Is_Close
                    Use
                 ENDIF
              ELSE
                 IF NetUse(database,,0.1,,.f.)
                    CLOSE
//                    inkey(0.1)
                 ELSE
                    DO WHILE NetUse(database,,0.1,,.f.)
                       CLOSE
                    ENDDO
                 ENDIF
                 retlogval:=.F.
              ENDIF
           ENDIF
   ENDCASE
   IF Is_Close
      IF retlogval:=.T.
         close
      ENDIF
   ENDIF
ELSE
   al_box({'"'+MYupper(database)+'" отсутсвует. Восстановите файлы с диска'})
ENDIF
setcolor(clr)
win_rest(win)
return retlogval


function smallcopy(source,dest,row,col,pos)
LOCAL TMPFILE,Desc,Remain:=0,Size,Total,Buffer,Kol_Kl:=0
TmpFile:=Fopen(Source,0)
Total := FSEEK(TmpFile, 0, 2)
FSEEK(TmpFile, 0,0)
Desc:=FCreate(dest)
DO While .T.
   IF (Remain+(512*20))<TOTAL
      SIZE:=512*20
   ELSE
      SIZE:=Total-Remain
      Buffer:=Space(SIZE)
      FRead(TmpFile, @buffer, SIZE)
      FWrite(Desc,buffer)
      exit
   ENDIF
   buffer = space(SIZE)
   Remain:=Remain+SIZE
   FRead(TmpFile, @buffer, SIZE)
   FWrite(Desc,buffer)
   IF Row!=NIL
      kol_kl=kol_kl+((Pos-Row)/Total)*size
      colorwin(row,col,row,col+kol_kl,'n/n')
   ENDIF
ENDDO
IF Row!=NIL
   colorwin(row,col,row,pos,'n/n')
ENDIF
FClose(Desc)
FClose(TmpFile)
RETURN NIL


FUNCTION AppendFile(Source,Dest,row,col,pos,IsReplace)
LOCAL Desc,Total,TmpFile,Buffer:=" ",i,Kol_Kl:=0
Desc  := Fopen(Source)
Total := FSEEK(Desc, 0, 2)
FSEEK(Desc, 0,0)
IsReplace:=IF(IsReplace==NIL,.t.,Isreplace)
IF File(Dest)
   TmpFile:=Fopen(Dest,2)
   FSeek(TmpFile, 0, 2)
ELSE
   TmpFile:=FCreate(Dest)
ENDIF
Buffer=chr(20)
For i=1 to Total
    FRead(Desc, @Buffer, 1)
    IF IsReplace
       DO Case
          Case Buffer=Schet_Norm
               Buffer:=NetPortr
          Case Buffer=Schet_Cond
               Buffer:=NetLand
       EndCase
    ENDIF
    Fwrite(TmpFile,Buffer)
    IF Row!=NIL
       kol_kl=kol_kl+((Pos-Row)/Total)*Len(Buffer)
       colorwin(row,col,row,col+kol_kl,'n/n')
    ENDIF
Next
Fclose(Desc)
Fclose(TmpFile)
RETURN Nil





// Ожидание готовности принтера в порту NN, в течении NN секунд
FUNCTION PrinterReady(nPort, nSeconds )
   LOCAL Net_Wait:=0.1
   LOCAL lForever          // Бесконечные попытки?
   LOCAL nRetry
   Local Status,Str
   nSeconds:=if(nSeconds==NIL,5,nSeconds)
   nRetry:=nSeconds
//   @ 1,0 say Space(40)
   Status:=PrintStat(nPort)
   IF .not.AskPort
      Return (.T.)
   ENDIF
//   @ 1,0 say "Бит 1 "+IF(IsBit(Status,1),"1","0")
//   @ 2,0 say "Бит 2 "+IF(IsBit(Status,2),"1","0")
//   @ 3,0 say "Бит 3 "+IF(IsBit(Status,3),"1","0")
//   @ 4,0 say "Бит 4 "+IF(IsBit(Status,4),"1","0")
//   @ 5,0 say "Бит 5 "+IF(IsBit(Status,5),"1","0")
//   @ 6,0 say "Бит 6 "+IF(IsBit(Status,6),"1","0")
//   @ 7,0 say "Бит 7 "+IF(IsBit(Status,7),"1","0")
//   @ 8,0 say "Бит 8 "+IF(IsBit(Status,8),"1","0")
      IF IsBit(Status,5).and.(!IsBit(Status,1).and.!IsBit(Status,4).and.;
         !IsBit(Status,6))
      RETURN ( .T. )       // Разрешено.
   ENDIF
   lForever := ( nSeconds == 0 )
//------------------------- Ожидаю готовность принтера...
   DO WHILE ( lForever .OR. ( nSeconds > 0 ) )
      Status:=PrintStat(nPort)
      IF IsBit(Status,5).and..not.IsBit(Status,1).and..not.IsBit(Status,4).and.;
         .not.IsBit(Status,6)
//      IF PrintReady(nPort)==.T.
         RETURN ( .T. )    // Дождались
      ENDIF
      DO Case
         Case IsBit(Status,1)
              Str:="Тайм-аут передачи данных истек"
         Case IsBit(Status,2)
              Str:="Неизвестная ошибка"
         Case IsBit(Status,3)
              Str:="Неизвестная ошибка"
         Case IsBit(Status,4)
              Str:="Ошибка передачи данных"
         Case IsBit(Status,5)
              Str:="Принтер готов ?!"
         Case IsBit(Status,6)
              Str:="Отсутствует бумага"
         Case IsBit(Status,7)
              Str:="Принтер ожидает данные"
         Case IsBit(Status,8)
              Str:="Принтер не доступен"
         Otherwise
              Str:="Код ошибки "+Str(Status,5,0)
      EndCase
//     @ 1,0 say Str
//      Al_Box({Str})
      INKEY( NET_WAIT )    // Жду NET_WAT секунд...
      nSeconds -= NET_WAIT
      if .not.(nSeconds>0)
        IF al_box({"Возникла ошибка печати",Str},2,;
           {" Подождать "," Выход "})==1
                 nSeconds:=nRetry
        ELSE
           return .F.     // Не дождались...
        ENDIF
      endif
   ENDDO
RETURN ( .F. )          // Не дождались




func copy_(source,target,pos_win,Ask,Show)
LOCAL PortName:="LPT1",IsNetPrint:=.F.,i,RunString:="",Byte:="",MORE:=.F.
LOCAL Remain:=0,Buffer:=" ",CopyString:="Copy /b ",TmpKolKl:=0
private ret_val,old_scr,total,kol_kl,temp,old_col,error,string,fishka
Ask:=IF(Ask==NIL,.F.,Ask)
Show:=IF(Show==NIL,.T.,Show)
Pos_win:=if(Pos_Win==NIL,12,Pos_win)
old_col=setcolor()
old_scr=savescreen(Pos_Win,0,24,79)
ret_val=0
IF Show
   obrabot("",Pos_Win)
ENDIF
work(maxrow(),0)
error=.f.
fishka=.f.       && Все нормально, работаeм
set color to n/w
if pcount()>=2
        IF lower(target)=="prn".or.substr(lower(target),1,3)='lpt'
           IF ASK
              PortName:=Al_Box({"Какой принтер использовать для печати"},;
                             2,{" Локальный ","  Сетевой "})
              IF PortName==1
                 PortName:=PrintPort
              ELSE
                 PortName:="LPT"+alltrim(str(NetPort))
              ENDIF
              Target:=PortName
           ELSE
                IF .Not.Printer()
                   restscreen(Pos_Win,0,24,79,old_scr)
                   setcolor(old_col)
                   RETURN ret_val
                EndIf
           ENDIF
                size = 512*SectorBuff  && 512
        ELSE
                size = 512*20
        ENDIF
        string='Копирую '+if(substr(target,1,3)='LPT',source+' на принтер',target)
        if len(string)>44
                string='Копирую ...'+substr(string,len(string)-31)
        endif
        IF Show
           @ Pos_Win+1,19 say center(alltrim(string),44,' ',.t.)
        EndIf
        IF IsNetPrint
           Save Screen
           IF Al_Box({"Загрузить русский шрифт в принтер"},2)==2
              obrabot("Подготовка отчета к удаленной печати")
              SmallCopy(FontFile,Schet_SDisk+"TmpFile.Tmp",12,21,51)
              AppendFile(Source,Schet_SDisk+"TmpFile.Tmp",12,21,51)
              Source:=Schet_SDisk+"TmpFile.Tmp"
           ELSE
              obrabot("Подготовка отчета к удаленной печати")
              CopyString:=CopyString+FontFile+" "+PortName
              AppendFile(Source,Schet_SDisk+"TmpFile.Tmp",12,21,51)
              Source:=Schet_SDisk+"TmpFile.Tmp"
           ENDIF
           Restore Screen
        EndIf
//        quit
        buffer = SPACE(size)
        total  = 0
        remaining = 0
        shandle = FOPEN(source,0)
        IF FERROR() = 0
           IF .not.IsNetPrint
                thandle = FCREATE(target)
           ELSE
                Thandle = FOpen(target,1)
           ENDIF
                IF FERROR() = 0
                   IF IsNetPrint
                      Fwrite(THandle,NETNORMAL)
                   ENDIF
                        total = FSEEK(shandle, 0, 2)
                        FSEEK(shandle, 0)
                        remaining = total
                        temp_=39/total
                        kol_kl=0
                        TmpKolKl:=0
                        DO WHILE (remaining > 0)
                                IF (remaining < size)
                                        size = remaining                        && Last part of file.
                                ENDIF
                                scount = FREAD(shandle, @buffer, size)
                                IF scount <> size
                                   IF Substr(MYupper(PortName),1,3)='LPT'
                                      Al_Box({'Ошибка чтения файла отчета','(Плохой сeктор ?)'})
                                   ELSE
                                      Al_Box({'Ошибка чтения копируемого файла','(Сбой диска?)'})
                                   ENDIF
                                   Error=.t.
                                   EXIT
                                ENDIF
                                IF IsNetPrint
                                   FOR i=1 to Size
//                                       @ 1,0 say SendByte(substr(buffer,i,1), NetPort-1)
//                                       TCount:=FWrite(thandle, substr(buffer,i,1), 1)
                                   Next
                                   TCount:=Size
                                ELSE
                                 IF substr(MYupper(Target),1,3)='LPT'
                                   More:=.T.
                                   TCount:=0
                                   FOR I=1 TO Size
                                      IF PrinterReady(val(Substr(PrintPort,4,1)))
                                         TCount =TCount+FWRITE(thandle, Substr(Buffer,I,1))
                                      ELSE
                                         More:=.F.
                                         I:=Size+1
                                         TCount:=-1
                                         Exit
                                      ENDIF
                                      TmpKolKl=Temp_*I
                                      ColorWin(Pos_Win+2,21,Pos_Win+2,21+TmpKolKl,'n/n')
                                   NEXT
                                   IF More
                                      TCount:=Size
                                   ENDIF
                                 ELSE
                                   TCount:=FWRITE(thandle, buffer, size)
                                 ENDIF
                                ENDIF
                                IF tcount <> size
                                   if substr(MYupper(Target),1,3)='LPT'
                                      IF TCount <> Size-1
                                         Al_Box({"Ошибка записи в принтер"})
                                           fishka=.t.
                                      ENDIF
                                   else
                                           error=.t.
                                           al_box({'Ошибка записи на диск (Диск полон/Ошибка диска)'})
                                   endif
                                   EXIT
                                ENDIF
                                IF Show
                                   kol_kl=kol_kl+temp_*size
                                   colorwin(Pos_Win+2,21,Pos_Win+2,21+kol_kl,'n/n')
                                ENDIF
                                remaining = remaining - size
                                ret_val=ret_val+scount

                        ENDDO
                        if error
                           ret_val=0
                        endif
                        IF IsNetPrint
                           Fwrite(Thandle,NetNormal)
//                           nnetcapend(NetPort)
//                           nnetcapflu(NetPort)
                        ENDIF
                        FCLOSE(thandle)
                ELSE
                        if substr(MYupper(PortName),1,3)='LPT'
                           Myerror('Не могу инициализировать принтер (Не подключен ?)')
                        else
                           al_box({'Ошибка создания нового файла','(Диск полон/Ошибка диска?)'})
                        endif
                ENDIF

                FCLOSE(shandle)

        ELSE
                if substr(MYupper(PortName),1,3)='LPT'
                        al_box({'Не могу открыть файл отчета',source})
                else
                        al_box({'Ошибка открытия копируемого файла',source})
                endif
        ENDIF
endif
if error
        deletefile(target)
endif
restscreen(Pos_Win,0,24,79,old_scr)
setcolor(old_col)
RETURN ret_val
* <EOF> Philes.prg





func replmem
param filerepl
private ret_val,len,desc,mem
ret_val=.t.
desc=fopen(filerepl)
len=fseek(desc,0,2)
fclose(desc)
if len=0.or.len>64000
        ret_val=.f.
else
        memowrit(filerepl,substr(rangerepl('К','К',rangerepl('Н','Н',;
        memoread(filerepl),'H'),'K'),1,len(rangerepl('К','К',;
        rangerepl('Н','Н',memoread(filerepl),'H'),'K'))-2))
endif
return ret_val

func wibor
param y,x,s,c
private old_col
old_col=setcolor()
if pcount()=4
        set color to (c)
else
        set color to w*+/n
endif
if datatype(s)=2
        @ y,x say chr(s)
else
        @ y,x say ''+s
endif
setcolor(old_col)
return ''



func e_rror
PARAMETERS msg1,msg2,msg3,msg4,msg5,msg6,msg7,msg8,msg9,msg10
private old_col,old_scr,curs,_a,pcount,msg_,row,col,msg11,i
row=row()
col=col()
if pcount()>=10
        pcount=9
else
        pcount=pcount()-1
endif
curs=csetcurs()
if curs
        set cursor off
endif
old_col=setcolor()
*sound(2600,3)
? chr(7)
*set color to bg+/b
msg=''
for i=1 to pcount+1
        msg_='msg'+alltrim(str(int(i)))
        msg=if(len(&msg_)>len(msg),&msg_,msg)
next
if empty(msg)
        return NIL //'(c) Kostya ltd  < Phone (861-33) 4-37-67 >'
endif
col = INT((80 - LEN(msg))/2) - 2
old_scr=savescreen(10-pcount/2,col,13+pcount/2,col+len(msg)+6)
wope(10-pcount/2,col,13+pcount/2,col+len(msg)+6,'r+/g+','bg+/b')
wope(10-pcount/2,col,13+pcount/2,col+len(msg)+6,'n+/rb+','gr+/r+')
colorwin(11-pcount/2,col+1,13+pcount/2,col+len(msg)+6,'n+/n')
@ 10-pcount/2, col CLEAR TO 12+pcount/2, col + LEN(msg) + 4
@ 10-pcount/2, col,12+pcount/2, col + LEN(msg) + 4  box '┌─╖║╝═╘│ '
@ 10-pcount/2,col+1 say center(" Ошибка ",len(msg),'─',.t.)
colorwin(10-pcount/2,col-3+len(msg)/2,10-pcount/2,col+len(msg)/2+4,'w+/r')
_a=0
for i=11-pcount/2 to 12+pcount/2
        if _a#pcount+1
                _a=_a+1
        else
                exit
        endif
        msg_='msg'+alltrim(str(int(_a)))
        @ i, col+2 SAY &msg_
//      SayRandom(&msg_, i, Col+2)
next
i=hot_INKEY(0)
wclo(10-pcount/2,col,13+pcount/2,col+len(msg)+6,'bg+/bg+')
restscreen(10-pcount/2,col,13+pcount/2,col+len(msg)+6,old_scr)
setcolor(old_col)
if curs
        set cursor on
endif
@ row,col say ''
return i


func wope
priv y_1,x_1,y_2,x_2,old_screen
parameters y1,x1,y2,x2,col1,col2
* old_screen=savescreen(y1,x1,y2,x2)

y_1=y1+min(int((y2-y1)/2),(y2-y1)/2)
x_1=x1+min(int((x2-x1)/2),(x2-x1)/2)
y_2=y1+(y2-y1)/2+1
x_2=x1+(x2-x1)/2+1
set color to (col1)
do while x_1>x1.or.y_1>y1
        @ y_1,x_1 clear to y_2,x_2
        @ y_1,x_1, y_2,x_2 box "╔═╗║╝═╚║ "
        x_1=if(x_1>=x1+2,x_1-2,x1)
        x_2=if(x_2<=x2-2,x_2+2,x2)
        y_1=if(y_1>=y1+2,y_1-2,y1)
        y_2=if(y_2<=y2-2,y_2+2,y2)
enddo
* restscreen(y1,x1,y2,x2,old_screen)
set color to (col2)
return NIL //'(c) Kostya ltd  < Phone (861-33) 4-37-67 >'

*******************************************************************************
*                                                                             *
* Функция закрывание окна                                                     *
* Параметры: координаты окна                                                  *
* Пример :                                                                    *
*        wclo(10-pcount/2,col,13+pcount/2,col+len(msg)+6)                     *
*                                                                             *
* Возвращает: Символьную строку                                               *
*******************************************************************************
func wclo(y,x,y1,x1,clr)
//private y,x,y1,x1
y=y-1
x=x-1
y1=y1+1
x1=x1+1
if pcount()>4
        setcolor(clr)
else
        set color to
endif
j=0
do while j<=39
        if j=int(j/3.5)*3.5
                y=y+1
                y1=y1-1
        endif
        if j=int(j)
        x=x+1
        x1=x1-1
        endif
        @ y,x,y1,x1 box "        "
        j=j+0.5
enddo
return NIL //'(c) Kostya ltd  < Phone (861-33) 4-37-67 >'


*******************************************************************************
// Вывести текст cRowText в координатах nRow, nCol, цветом cColor
FUNCTION SayRandom(cRowText, nRow, nCol,cColor)
LOCAL RandomPos, RandomStr, TextLen, Char,cOldColor:=setcolor()
//      Проверка переданных параметров
 nRow:=IF(nRow==NIL,INT(MaxRow()/2),nRow)
 nCol:=IF(nCol==NIL,INT(MaxCol()/2)-INT(LEN(cRowText)/2),nCol)
 cColor:=IF(cColor==NIL,setcolor(),cColor)
 ColorWin(nRow,nCol,nRow,nCol+len(cRowText),cColor)
 nCol    := nCol +COUNTLEFT(cRowText)
 cRowText  := REMALL(cRowText)
 TextLen   := LEN(cRowText)
 RandomStr := ""
 SetColor(cColor)
 DO WHILE LEN(RandomStr) <TextLen
   RandomPos := RANDOM() %TextLen +1
   IF AT(CHR(RandomPos), RandomStr) =0
     RandomStr := RandomStr +CHR(RandomPos)
     @ nRow, nCol +RandomPos -1 SAY SUBSTR(cRowText, RandomPos, 1)
   ENDIF
 ENDDO
 SetColor(cOldColor)
RETURN NIL



function work(_x,_y)
@ _x,_y say chr(16)+" Работа "+chr(17)
colorwin(_x,_y,_x,_y+9,'g*/r+')
return .t.



******
*  str_chislo() - первая строка
*  mpsum2 - вторая строка
*
*  если длина строки < 82 , то результат в строке из функции
*  если              > 82 , то первая часть в строке mpsum2
*                         , а вторая часть в строке из функции
*********
func str_chislo(number,len_ret_string,IsMoney)
LOCAL RubSuff,KopSuff,TmpVal:=0
public mpsum2
priv desyat,len_mass,ret_str:="",kopeyky:=""
mpsum2=''
if pcount()=0.or.number=0
   return '0 рублей 00 копеек'
endif
IF Number<0
   Number=Number*-1
   ret_str:=ret_str+"Минус "
ENDIF
len_ret_string=if(len_ret_string==NIL,82,len_ret_string)
TmpVal:=val(substr(alltrim(str(number)),len(alltrim(str(number)))-3,1))
IsMoney:=IF(IsMoney==NIL,.T.,IsMoney)
DO Case
   Case TmpVal==1
        IF IsMoney==.T.
           kopeyky=' рубль '+substr(alltrim(str(number)),-2)+' копеек'
        ENDIF
   Case TmpVal>1.and.TmpVal<5
        IF IsMoney==.T.
           kopeyky=' рубля '+substr(alltrim(str(number)),-2)+' копеек'
        ENDIF
   Otherwise
        IF IsMoney==.T.
           kopeyky=' рублей '+substr(alltrim(str(number)),-2)+' копеек'
        ENDIF
ENDCASE
number=val(substr(alltrim(str(number)),1,len(alltrim(str(number)))-3))
declare prost[9],des[9],des20_90[8],sot[9],chislo[4]
desyat='десять'
prost[1]='один'
prost[2]='два'
prost[3]='три'
prost[4]='четыре'
prost[5]='пять'
prost[6]='шесть'
prost[7]='семь'
prost[8]='восемь'
prost[9]='девять'

des[1]='одиннадцать'
des[2]='двенадцать'
des[3]='тринадцать'
des[4]='четырнадцать'
des[5]='пятнадцать'
des[6]='шестнадцать'
des[7]='семнадцать'
des[8]='восемнадцать'
des[9]='девятнадцать'

des20_90[1]='двадцать'
des20_90[2]='тридцать'
des20_90[3]='сорок'
des20_90[4]='пятьдесят'
des20_90[5]='шестьдесят'
des20_90[6]='семьдесят'
des20_90[7]='восемдесят'
des20_90[8]='девяносто'

sot[1]='сто'
sot[2]='двести'
sot[3]='триста'
sot[4]='четыреста'
sot[5]='пятьсот'
sot[6]='шестьсот'
sot[7]='семьсот'
sot[8]='восемьсот'
sot[9]="девятьсот"
//ret_str=''
len_mass=chislo_mass(number)
for i=len_mass to 1 step -1
    s_chislo=alltrim(str(chislo[i]))
    do case
        case i=4
                ret_str=ret_str+fviv('миллиард',.t.)
        case i=3      &&  Миллион
                ret_str=ret_str+fviv('миллион',.t.)
        case i=2
                ret_str=ret_str+fviv('тысяч',.f.)
        case i=1
                ret_str=ret_str+chislo(chislo[i])
    endcase
next i
Ret_Str:=AllTrim(Ret_Str)
ret_str=MYUpper(Substr(ret_str,1,1))+Substr(ret_str,2)+kopeyky

for i=9 to 1 step -1
        if i<9
                adel(prost,i)
                adel(des,i)
                adel(sot,i)
        else
                adel(prost,i)
                adel(des,i)
                adel(des20_90,i)
                adel(sot,i)
        endif
next
//if len(ret_str)<87
if len(ret_str)<len_ret_string
  return ret_str
else
        private str1,str2,pos
//      str1=substr(ret_str,1,87)
//      str2=substr(ret_str,88)
        str1=substr(ret_str,1,len_ret_string)
        str2=substr(ret_str,len_ret_string+1)
        pos=rat(' ',str1)
        str2=substr(str1,pos)+str2
        str1=substr(str1,1,pos-1)
        mpsum2=alltrim(str2)
        return str1
endif
Return ""



function chislo
para number
priv ret_str
if number=0
  return ''
endif
number=alltrim(str(number))
ret_str=''
do case                         && Простые числа 1...100
        case len(number)=1      && Числа 1...9
                ret_str=ret_str+prost[val(number)]
        case len(number)=2
                if substr(number,1,1)='1'       && Числа 11...19
                        if val(number)=10
                                ret_str=desyat       && Число 10
                        else
                                ret_str=des[val(substr(number,2,1))]
                        endif
                else                            && Числа 20...99
                        ret_str=des20_90[val(substr(number,1,1))-1]+;
                        if(val(substr(number,2,1))#0,' '+prost[val(substr(number,2,1))],'')
                endif
        case len(number)=3
                ret_str=sot[val(substr(number,1,1))]+' '
&& Если первое число(с позиции 2) не 1,то...
&& разложить строку на цифры и склеить строчки
                if substr(number,2,1)#'1'
                        ret_str=ret_str+;
                        if(substr(number,2,1)#'0',des20_90[val(substr(number,2,1))-1],'')+;
                        if(substr(number,3,1)#'0',' '+prost[val(substr(number,3,1))],"")
                else
&& Посмотеть,если первое число =10,тогда записать "десять" и выйти
                   if substr(number,2)='10'
                        ret_str=ret_str+desyat
                   else
&& Если первое число не 10,но первая цифра 1,тогда записать число и выйти
                        ret_str=ret_str+des[val(substr(number,3,1))]
                   endif
                endif
endcase
return ret_str






func chislo_mass
para num
priv len,len_mass
len=len(alltrim(str(num)))
do case
        case len<=3
                chislo[1]=num
                len_mass=1
        case len<=6
                chislo[1]=val(substr(alltrim(str(num)),-3))
                chislo[2]=val(substr(alltrim(str(num)),1,len(alltrim(str(num)))-3))
                len_mass=2
        case len<=9
                chislo[1]=val(substr(alltrim(str(num)),-3))
                chislo[2]=val(substr(alltrim(str(num)),-6,3))
                chislo[3]=val(substr(alltrim(str(num)),1,len(alltrim(str(num)))-6))
                len_mass=3
        case len<=12
                chislo[1]=val(substr(alltrim(str(num)),-3))
                chislo[2]=val(substr(alltrim(str(num)),-6,3))
                chislo[3]=val(substr(alltrim(str(num)),-9,3))
                chislo[4]=val(substr(alltrim(str(num)),1,len(alltrim(str(num)))-9))
                len_mass=4
        otherwise
                @ 0,27 say "Пеpеполнение"
endcase
return len_mass

func fviv
param par,yt
private ret_str
ret_str=''
 if s_chislo#'0'
  do case
    case len(s_chislo)=3
   do case
        case val(substr(s_chislo,-1))=1.and.substr(s_chislo,2,1)#'1'.and.substr(s_chislo,2)#'00'
            ret_str=ret_str+chislo(val(substr(s_chislo,1,2)+'0'))+iif(yt," один "+par+" "," одна "+par+'а ')
        case val(substr(s_chislo,-1))=2.and.substr(s_chislo,2,1)#'1'.and.substr(s_chislo,2)#'00' .and. (.not.yt)
            ret_str=ret_str+chislo(val(substr(s_chislo,1,2)+'0'))+" две "+par+'и '
        case val(substr(s_chislo,-1))<5.and.substr(s_chislo,2,1)#'1'.and.substr(s_chislo,2)#'00'.and.substr(s_chislo,-1)#'0'
            ret_str=ret_str+chislo(chislo[i])+iif(yt," "+par+"а "," "+par+"и ")
        otherwise
           ret_str=ret_str+chislo(chislo[i])+iif(yt,' '+par+'ов ',' '+par+' ')
   endcase
    case len(s_chislo)=2
     do case
      case substr(s_chislo,-1,1)='1'.and.substr(s_chislo,1,1)#'1'
            ret_str=ret_str+chislo(val(substr(s_chislo,1,1)+'0'))+iif(yt,' один '+par+' ',' одна '+par+'а ')
      case substr(s_chislo,-1,1)='2'.and.substr(s_chislo,1,1)#'1' .and. (.not.yt)
            ret_str=ret_str+chislo(val(substr(s_chislo,1,1)+'0'))+' две '+par+'и '
      case val(substr(s_chislo,-1,1))<5.and.substr(s_chislo,1,1)#'1'.and.substr(s_chislo,-1,1)#'0'
            ret_str=ret_str+chislo(chislo[i])+iif(yt,' '+par+'а ',' '+par+'и ')
      otherwise
            ret_str=ret_str+chislo(chislo[i])+iif(yt,' '+par+'ов ',' '+par+' ')
     endcase
    case len(s_chislo)=1
     do case
       case chislo[i]=1
        ret_str=ret_str+iif(yt,' один '+par+' ',' одна '+par+'а ')
       case chislo[i]=2 .and. (.not.yt)
        ret_str=ret_str+' две '+par+'и '
       case chislo[i]>1.and.chislo[i]<5
        ret_str=ret_str+prost[chislo[i]]+iif(yt,' '+par+'а ',' '+par+'и ')
       case chislo[i]>=5
        ret_str=ret_str+chislo(chislo[i])+iif(yt," "+par+"ов "," "+par+" ")
     endcase
  endcase
  endif
return ret_str



Function GetVal(String,Value,EcsValue)
Local RowStart:=MaxRow()/2,ColStart:=MaxCol()/2,Screen,Color:=SetColor(),LenVal
DEFAULT EcsValue TO Value
DO Case
   Case ValType(Value)=="C"
        LenVal:=Len(Value)
   Case ValType(Value)=="D"
        LenVal:=Len(Dtoc(New_date))
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
SetColor(Color)
Win_Rest(Screen)
Return Value


Function Bit_Test(cStr,nBitNum)
Local boolBitSet:=.F.,nByte:=0,nBit:=0
nByte=Int(nBitNum/8)

Return boolBitSet


Function Bit_Set(cStr,nBitNum)
Local boolBitSet:=.F.

Return boolBitSet


Function Bit_Reset(cStr,nBitNum)
Local boolBitSet:=.F.

Return boolBitSet



FUNCTION MyUPPER(cStr)
Local i,cNewStr:=""
For i=1 To Len(cStr)
    DO CASE
       CASE ASC(Substr(cStr,i,1))>=160.and.ASC(Substr(cStr,i,1))<176
            cNewStr=cNewStr+Chr(ASC(Substr(cStr,i,1))-32)
       CASE ASC(Substr(cStr,i,1))>=224.and.ASC(Substr(cStr,i,1))<240
            cNewStr=cNewStr+Chr(ASC(Substr(cStr,i,1))-80)
       CASE ASC(Substr(cStr,i,1))>=97.and.ASC(Substr(cStr,i,1))<123
            cNewStr=cNewStr+Chr(ASC(Substr(cStr,i,1))-32)
       OTHERWISE
            cNewStr=cNewStr+Substr(cStr,i,1)
    ENDCASE
Next
Return cNewStr




Function Num2Str(nNum)
Local cString:=""
Local aNum:={"Один","Два","Три","Четыре","Пять","Шесть","Семь","Восемь","Девять","Десять",;
		  "Одиннадцать","Двенадцать","Тринадцать","Четырнадцать","Пятнадцать","Шестнадцать","Семнадцать",;
		  "Восемнадцать","Девятнадцать","Двадцать"}
DO Case
	 Case nNum>=1.and.nNum<=20
	 			cString:=aNum[nNum]
ENDCASE	
Return cString
