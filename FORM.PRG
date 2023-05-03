///////////////////////////////////////////////////////////////////////////////
//
//  Function-oriented code created by the Xbase++ FormDesigner
//    Creation date: 25.06.2007 Time: 16:05:07
//
///////////////////////////////////////////////////////////////////////////////

#include "Gra.ch"
#include "Xbp.ch"
#include "Appevent.ch"
#include "Font.ch"

Function DateForm
   LOCAL nEvent, mp1, mp2
   LOCAL oDlg, oXbp, drawingArea, aEditControls := {}

   oDlg := XbpDialog():new( AppDesktop(), , {720,657}, {270,180}, , .F.)
   oDlg:taskList := .T.
   oDlg:title := "New form"
   oDlg:create()

   drawingArea := oDlg:drawingArea
   drawingArea:setFontCompoundName( "8.Arial" )

   oXbp := XbpSLE():new( drawingArea, , {108,72}, {84,24}, { { XBP_PP_BGCLR, XBPSYSCLR_ENTRYFIELD }, { XBP_PP_COMPOUNDNAME, "12.Courier" } } )
   oXbp:tabStop := .T.
   oXbp:create()

   oXbp := XbpPushButton():new( drawingArea, , {84,24}, {96,24}, { { XBP_PP_BGCLR, XBPSYSCLR_BUTTONMIDDLE }, { XBP_PP_FGCLR, -58 } } )
   oXbp:caption := "Начать выбор"
   oXbp:tabStop := .T.
   oXbp:create()
   oXbp:activate := {|| NIL }

   oXbp := XbpStatic():new( drawingArea, , {12,72}, {60,24}, { { XBP_PP_COMPOUNDNAME, "12.MS Sans Serif" } } )
   oXbp:caption := "Дата"
   oXbp:clipSiblings := .T.
   oXbp:options := XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_RIGHT
   oXbp:create()

   oDlg:show()

   nEvent := xbe_None
   DO WHILE nEvent <> xbeP_Close
      nEvent := AppEvent( @mp1, @mp2, @oXbp )
      oXbp:handleEvent( nEvent, mp1, mp2 )
   ENDDO
RETURN Nil