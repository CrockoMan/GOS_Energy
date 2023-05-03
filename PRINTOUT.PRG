// The example demonstrates the steps required for
// print job configuration.

#include "Gra.ch"
#include "Xbp.ch"
#include "Common.ch"
#include "Appevent.ch"
#include "Font.ch"

#include "XbpDev.ch"

#pragma Library( "XppUI2.lib" )
#pragma Library( "xbtbase1.lib" )
#pragma Library( "xbtbase2.lib" )


   FUNCTION PrintOut(cFile,Orientation)
      LOCAL oPrinter, oPS, oDlg, aSize,cText,nMaxLines,PrintLine,nPosCurPage
      LOCAL Kol_Kl:=0,OldFocus:=SetAppFocus(),cCurLine:="",Desc,Scr,aPos,aSizeDeskTop


//---------------------------------------------------------------------------------------
      Orientation:=IF(Orientation==NIL,.F.,Orientation)
//      IF Orientation==.T.	
			 aPrinter:=MainPrinterConfig(1,XBPPRN_ORIENT_PORTRAIT)
//			 aPrinter:=MainPrinterConfig()
//			ELSE
//			 aPrinter:=MainPrinterConfig(1,XBPPRN_ORIENT_LANDSCAPE)
//			ENDIF 	
			 IF Empty(aPrinter[1])
			 		Return nil
			 ENDIF



      // Create presentation space for default printer
      oPS := PrinterPS(aPrinter)
//       oPS := PrinterPS()


      cFile:=IF(cFile==NIL,DDir+ReportFile,cFile)
      Desc:=Fopen(cFile)
      cText:=FReadStr(Desc,FSize(Desc))
      Fclose(Desc)
      IF FError()#0
         Al_Box({"Ошибка открытия отчета, печать отчета невозможна."})
      	 DestroyDevice( oPS )
      	 Return NIL
      ENDIF
      
      
      // Activate spooling
      oPS:device():startDoc()
//---------------------------------------------------------------------------------------



//      oDlg := XbpPrintDialog():new()

      // Default output goes to file
//      oDlg:enablePrintToFile := .F.
//      oDlg:printToFile       := .F.
//      oDlg:create()

      // Obtain configured printer object

//      oPrinter := oDlg:display()
//      oDlg:destroy()

//      IF oPrinter <> NIL
//         cText:=memoread(cFile)
         nMaxLines:=MlCount(cText,250)
         // Create a new presentation space
//         oPS   := XbpPresSpace():new()
//         oPS:SetOrientation(XBPPRN_ORIENT_LANDSCAPE)

         // Size of printable region on paper
//         aSize := oPrinter:paperSize()
         aSize := oPS:device():paperSize()
         aSize := { aSize[5] - aSize[3], ;
                    aSize[6] - aSize[4]  }
//         oPS:create( oPrinter, aSize, GRA_PU_LOMETRIC )

         oFont := XbpFont():new()              // Create XbpFont object
         oFont:familyName := PrFontName // Describe font
         oFont:height     := PrCharHigh
         oFont:width      := PrCharWidth
         oFont:create()                        // Create font
         GraSetFont (oPS , oFont )                // Select font

         // Tiny print job
//         Scr:=obrabot("Печать отчета")
//         kol_kl=0
//         oPrinter:startDoc()

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
   			 oProgress:maximum := nMaxLines

         nPosCurPage:=PrStrHigh
         For PrintLine=1 To nMaxLines
      	 		 oProgress:increment()																				// Progress Bar Increment
//             kol_kl=kol_kl+39/nMaxLines
//             colorwin(12,21,12,21+kol_kl,'n/n')
             cCurLine:=MemoLine(cText,250,PrintLine)
             IF AtNum(Chr(12),cCurLine)==0
                GraStringAt( oPS, {20, aSize[2]-nPosCurPage }, cCurLine)
             ELSE
                GraStringAt( oPS, {20, aSize[2]-nPosCurPage }, SubStr(cCurLine,1,AtNum(Chr(12),cCurLine)-1))
                nPosCurPage:=PrStrHigh
//                oPrinter:newPage()
                oPS:device():newPage()
                GraStringAt( oPS, {20, aSize[2]-nPosCurPage }, SubStr(cCurLine,AtNum(Chr(12),cCurLine)+1))
             ENDIF
             IF (aSize[2]-nPosCurPage)<PrStrHigh
                nPosCurPage:=PrStrHigh
//                oPrinter:newPage()
                oPS:device():newPage()
             ELSE
                nPosCurPage:=nPosCurPage+PrStrHigh
             ENDIF
             IF Inkey()==27
             		IF ChoiceBox(" Прекратить печать отчета")==1
             			 PrintLine=nMaxLines
             			 Exit
             		ENDIF
             ENDIF
         Next
      	 oProgress:destroy()																				// Progress Bar Increment
   			 oDlg:Destroy()
         oFont:destroy()                        // Destroy font
//         oPrinter:endDoc()
//         Win_Rest(Scr)

         // Housekeeping
//         oPrinter:destroy()
//         oPS:destroy()
//      ENDIF
//      SetAppFocus(oldFocus)


      oPS:device():endDoc()

      DestroyDevice( oPS )


   RETURN NIL