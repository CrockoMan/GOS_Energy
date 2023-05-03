*               Вьюер для файлов любых размеров.
*****************************************************************************
#include "inkey.ch"

function TxtView(cFileName,nRowTop,nColLeft,nRowBottom,nColRight,cColor,nColor,cStrTop,cStrBottom)
//-----------------------------------------------------------------------
//  Parameters:
//    cFileName - Имя файла для просмотра (единственный обязательный параметр)
//    nRowTop,
//    nColLeft,
//    nRowBottom,
//    nColRight - координаты окна                               (optional!)
//    cColor    - Цвет для вывода строк cStrTop & cStrBottom    (optional!)
//    nColor    - Номер цвета для просмотра файла               (optional!)
//    cStrTop   - Текст для вывода в сроке nRowTop-1            (optional!)
//    cStrBottom- Текст для вывода в сроке nRowBottom+1         (optional!)
/*
    For Example:
        TxtView('txtview.doc',2,1,22,78,"n/w",31,;
                 'Строка в верхней части экрана',;
                 'Строка в нижней части экрана')
*/
//-----------------------------------------------------------------------
Local OldScreen:=SaveScreen() // Store old Screen
Local OldColor:=SetColor()    // Store old color
Local Result:=0

   //--- Check parameters ---

   IF cFileName==NIL            // Adjust Top Row
      cFileName:=Ddir+'otchet.gkv'
   endif

   IF nRowTop==NIL            // Adjust Top Row
      nRowTop:=1
   endif

   IF nColLeft==NIL           // Adjust Left Column
      nColLeft:=0
   endif

   IF nRowBottom==NIL         // Adjust Bottom Row
      nRowBottom:=MaxRow()-1
   endif

   IF nColRight==NIL          // Adjust Right Column
      nColRight:=MaxCol()
   endif

   IF cColor==NIL             // Adjust color
      cColor:='n/w'
   endif

   IF nColor==NIL             // Adjust numeric color
      nColor:="w+/b"
   endif

   IF cStrTop==NIL             // Adjust String for top draw
      cStrTop:=center(substr('Просмотр отчета, сгенерированного программой',1,nColRight-nColLeft+1),nColRight-nColLeft+1,' ',.t.)
   Else
      cStrTop:=substr(cStrTop,1,nColRight-nColLeft+1)
      cStrtop:=cStrTop+space(nColRight-nColLeft+1-len(cStrTop))
      IF empty(cStrTop).and.empty(cStrBottom)
                cColor='w+/n'
      Endif
   endif

   IF cStrBottom==NIL             // Adjust String for bottom draw
      cStrBottom:=center(substr('Esc - Выход',1,nColRight-nColLeft+1),nColRight-nColLeft+1,' ',.t.)
   Else
      cStrBottom:=substr(cStrBottom,1,nColRight-nColLeft+1)
      cStrBottom:=cStrBottom+space(nColRight-nColLeft+1-len(cStrBottom))
   endif

   SetColor(cColor)

   If !File(cFileName)
      @ 10,15,15,65 BOX "╔═╗║╝═╚║ "
      @ 12,20 SAY " File "+AllTrim(cFileName)+" not found!"
      @ 14,20 SAY " Press any key to continue..."
      Inkey(0)
   else

        @ nRowTop-1,nColLeft say space(nColRight-nColLeft+1)
        @ nRowTop-1,nColLeft say cStrTop

        @ nRowBottom+1,nColLeft say space(nColRight-nColLeft+1)
        @ nRowBottom+1,nColLeft say cStrBottom
      Result:=tView(cFileName,nRowTop,nColLeft,nRowBottom,nColRight,nColor)
   endif

   Restore Screen from OldScreen   // Let's restore all
   SetColor(OldColor)              // as it was !
   Devout("")
return NIL


Function TView(cFile,nTop,nLeft,nBottom,nRight,cColor)
//MemoEdit(MemoRead(cStr),nTop,nLeft,nBottom,nRight,.f.,,300)


Local Desc,cText,nMaxLines,Clr:=SetColor()
Local TopLine:=1,LeftPos:=1,PressedKey,ScrPos:=0,ActionKey:=.T.
Desc:=Fopen(cFile)
cText:=FReadStr(Desc,FSize(Desc))
Fclose(Desc)
nMaxLines:=MlCount(cText,300)
Set Color To (cColor)
Do While .t.
   IF ActionKey
      ScrPos:=nTop
      For i=TopLine To (TopLine+(nBottom-nTop))
          IF i<=nMaxLines
             @ ScrPos,nLeft Say Substr(MemoLine(cText,300,i)+Space(80),LeftPos,nRight-nLeft+1)
             ScrPos:=ScrPos+1
          ELSE
             @ ScrPos,nLeft Say Space(80)
             ScrPos:=ScrPos+1
          ENDIF
      NEXT
   ENDIF
   ActionKey:=.F.
   PressedKey:=Inkey(0)
   Do Case
      Case PressedKey=406
           Do PrintWorkScreen
           
      Case PressedKey=K_ESC
           Exit

      Case PressedKey=K_RIGHT
           LeftPos:=LeftPos+1
           ActionKey:=.T.

      Case PressedKey=K_LEFT
           LeftPos:=IF(LeftPos-1>1,LeftPos-1,1)
           ActionKey:=.T.

      Case PressedKey=K_DOWN
           TopLine:=IF(TopLine+1+(nBottom-nTop)>nMaxLines,nMaxLines-(nBottom-nTop),TopLine+1)
           ActionKey:=.T.

      Case PressedKey=K_UP
           TopLine:=IF(TopLine-1>1,TopLine-1,1)
           ActionKey:=.T.

      Case PressedKey=K_PGDN
           TopLine:=IF(TopLine+(nBottom-nTop)<nMaxLines,TopLine+(nBottom-nTop)+1,nMaxLines)
           ActionKey:=.T.

      Case PressedKey=K_PGUP
           TopLine:=IF(TopLine-(nBottom-nTop)>1,TopLine-(1+nBottom-nTop),1)
           ActionKey:=.T.

      Case PressedKey=K_CTRL_PGDN
           TopLine:=nMaxLines-(nBottom-nTop+1)
           ActionKey:=.T.

      Case PressedKey=K_CTRL_PGUP
           TopLine:=1
           ActionKey:=.T.

      Case PressedKey=K_CTRL_RIGHT
           LeftPos:=IF(Len(AllTrim(MemoLine(cText,300,TopLine)))-(nRight-nLeft)+1>0,Len(AllTrim(MemoLine(cText,300,TopLine)))-(nRight-nLeft)+1,LeftPos)
           ActionKey:=.T.

      Case PressedKey=K_CTRL_LEFT
           LeftPos:=1
           ActionKey:=.T.

   ENDCASE
ENDDO
Setcolor(Clr)
Return NIL
