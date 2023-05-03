//////////////////////////////////////////////////////////////////////
//
//  PCONFIG.PRG
//
//  Copyright:
//      Alaska Software, (c) 2000-2003. All rights reserved.         
//  
//  Contents:
//      User defined class XbpPrinterConfig()
//   
//  Remarks:
//      The class displays a modal XbpDialog window which can be used
//      to configure an XbpPrinter object before a print job is started.
//      Configurable values are:
//   
//      - Paper format          => XbpPrinter:setFormSize() 
//      - Paper bin             => XbpPrinter:setPaperBin()
//      - Print resolution      => XbpPrinter:setResolution()
//      - Number of copies      => XbpPrinter:setNumCopies()
//      - Color or monochrome   => XbpPrinter:setColorMode()
//      - Print to file         => XbpPrinter:setPrintFile()
//      - Portrait/landscape    => XbpPrinter:setOrientation()
//   
//      The configuration values are obtained from the printer driver and
//      depend on the selected printer!
//   
//////////////////////////////////////////////////////////////////////

#include "Gra.ch"
#include "Xbp.ch"
#include "Common.ch"
#include "Appevent.ch"
#include "Font.ch"


#include "XbpDev.ch"

/*
 * The code embedded in #ifdef __TEST__ is a test scenario for the
 * XbpPrinterConfig() class. The usage of this class is demonstrated in 
 * Main().
 */

#define __TEST__

#ifdef __TEST__

/*
PROCEDURE Main
Local aPrinter:={}
	
			 aPrinter:=MainPrinterConfig(2,XBPPRN_ORIENT_LANDSCAPE)
			 IF Empty(aPrinter[1])
			 		Return
			 ENDIF



       oPS := PrinterPS(aPrinter)
       oPS:device():startDoc()

       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 23
       oFont:width      := 12
       oFont:create()                        // Create font
       OldFont:=GraSetFont (oPS , oFont )                // Select font



       GraStringAt( oPS, {2630,1890}, 'Приложение N1' )
       GraStringAt( oPS, {1825,1865}, 'к Правилам ведения журналов учета полученных и выставленных счетов-фактур, ' )
       GraStringAt( oPS, {1840,1840}, 'книг покупок и книг продаж при расчетах по налогу на добавленную стоимость,' )
       GraStringAt( oPS, {1630,1815}, 'утвержденным постановлением Правительства Российской Федерации от 2 декабря 2000 г. N 914')
       GraStringAt( oPS, {2010,1790}, '(в редакции постановлений Правительства Российской Федерации' )
       GraStringAt( oPS, {1850,1765}, 'от 15 марта 2001 г. N 189, от 27 июля 2002 г. N 575, от 16 февраля 2004 г. N 84)' )

       oFont:destroy()                        // Create font
      oPS:device():endDoc()

      DestroyDevice( oPS )
 


Return
*/

#endif // __TEST__




   FUNCTION PrinterPS( cPrinterObjectName )
      LOCAL aSize
      LOCAL oPS, oDC := XbpPrinter():New()


      oDC:Create( cPrinterObjectName[1] )
      oDC:setPaperBin(cPrinterObjectName[2])
      oDC:setNumCopies(cPrinterObjectName[3])
      oDC:setOrientation(cPrinterObjectName[4])
//      @ 1,0 Say oDC:devName
//     	Inkey(0)
//	    oDC:SetUpDialog()



      oPS := XbpPresSpace():New()
      aSize := oDC:paperSize()

      // Size of printable region on paper
      aSize := { aSize[5] - aSize[3], ;
                 aSize[6] - aSize[4]  }
      oPS:Create( oDC, aSize, GRA_PU_LOMETRIC )
      
   RETURN oPS


   FUNCTION DestroyDevice( oPS )
      LOCAL oDC := oPS:device()

      IF oDC <> NIL
         oPS:configure()
         oDC:destroy()
      ENDIF

   RETURN NIL






Function MainPrinterConfig(nConfig1,nConfig2,nConfig3)
   LOCAL oDialog, oPrinter
   Private aPrinterSet:={"",0,0,0,"Конфигурация принтера"}

   aPrinterSet[3]:=IF(nConfig1==NIL,1,nConfig1)
   aPrinterSet[4]:=IF(nConfig2==NIL,XBPPRN_ORIENT_PORTRAI,nConfig2)
   aPrinterSet[5]:=IF(nConfig3==NIL,aPrinterSet[5],nConfig3)
   /*
    * Create the configuration window
    */
   oDialog  := XbpPrinterConfig():new():create()

   /*
    * Create an XbpPrinter object
    */
   oPrinter := XbpPrinter():new():create()
   IF oPrinter:list() == NIL
      MsgBox( "В системе нет установленных принтеров" )
      RETURN NIL
   ENDIF

   /*
    * Assign the printer object to the window
    */
   oDialog:setData( oPrinter )

   /*
    * Display the window. It is modal. An event loop runs
    * within :show()
    */
   oDialog:show()

   /*
    * Simple procedure to display the printer configuration data
    */
RETURN aPrinterSet




/*
 * Calculate the centered position for a window
 */
STATIC FUNCTION CenterPos( aSize, aRefSize )
RETURN { Int( (aRefSize[1]-aSize[1]) / 2 ), ;
         Int( (aRefSize[2]-aSize[2]) / 2 )  }


/*
 * Class to configure an XbpPrinter object
 */
CLASS XbpPrinterConfig FROM XbpDialog

   PROTECTED:
   VAR oFocus               // Input focus must be set to this Xbp
                            // when the window is closed
   VAR aForms               // Available paper formats
   VAR aBins                // Available paper bins
   VAR aDPI                 // Available print resolutions

   VAR grpBox1              // Groupbox    Printer settings
   VAR txtForms             // XbpStatic   Text
   VAR forms                // Combobox    Paper format
   VAR txtBins              // XbpStatic   Text
   VAR Bins                 // Combobox    Paper bin
   VAR txtDPI               // XbpStatic   Text
   VAR Dpi                  // Combobox    Print resolution

   VAR grpBox2              // Groupbox    Printjob settings
   VAR txtCopies            // XbpStatic   Text 
   VAR numCopies            // Spinbutton  Number of copies
   VAR useColor             // Checkbox    Color/monochrome
   VAR toFile               // Checkbox    Print to file

   VAR grpBox3              // Groupbox    Paper orientation
   VAR portrait             // RadioButton Portrait
   VAR landscape            // Radiobutton Landscape

   VAR btnOK                // Pushbutton  OK
   VAR btnCancel            // PushButton  Cancel

   EXPORTED: 
   VAR oPrinter  READONLY   // The XbpPrinter object

   METHOD init              // Life cycle methods
   METHOD create            // 

   METHOD show              // Display the dialog window
   METHOD hide              // Hide the window
   METHOD setData           // Assign XbpPrinter object to window
   METHOD getData           // Configure XbpPrinter object and close
                            // the window

ENDCLASS


/*
 * Initialize the object
 */
METHOD XbpPrinterConfig:init( oParent, oOwner )
   LOCAL aPos, aSize, aPP

   DEFAULT oParent  TO AppDesktop(), ;
           oOwner   TO SetAppwindow()

   aPP     := { { XBP_PP_COMPOUNDNAME, "Lucida Console"} }
//   aSize   := {288,333}
   aSize   := {288,233}
   aPos    := CenterPos( aSize, oOwner:currentSize() )
   aPos[1] += oOwner:currentPos()[1]
   aPos[2] += oOwner:currentPos()[2]

   ::XbpDialog:init( oParent, oOwner, aPos, aSize, aPP, .F. )

   ::XbpDialog:sysMenu   := .F.
   ::XbpDialog:minButton := .F.
   ::XbpDialog:maxButton := .F.
   ::XbpDialog:border    := XBPDLG_DLGBORDER
   ::XbpDialog:title     := aPrinterSet[5]
//   ::XbpDialog:title     := "Конфигурация принтера"
   ::XbpDialog:close     := {|mp1, mp2, obj| obj:hide() }

//   ::grpBox1             := XbpStatic():new( ::drawingArea, , {8,202}, {264,92} )
   ::grpBox1             := XbpStatic():new( ::drawingArea, , {8,112}, {264,92} )
   ::grpBox1:caption     := "Установки принтера"
   ::grpBox1:type        := XBPSTATIC_TYPE_GROUPBOX

   ::txtForms            := XbpStatic():new( ::grpBox1, , {8,52}, {60,24} )
   ::txtForms:caption    := "Принтер"
   ::txtForms:options    := XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_RIGHT

//   ::forms               := XbpCombobox():new( ::grpBox1, , {96,-16}, {160,112} )
   ::forms               := XbpCombobox():new( ::grpBox1, , {76,-36}, {180,112} )
   ::forms:type          := XBPCOMBO_DROPDOWNLIST
   ::forms:tabStop       := .T.

//   ::txtBins             := XbpStatic():new( ::grpBox1, , {8,40}, {80,24} )
//   ::txtBins:caption     := "Подача бумаги"
//   ::txtBins:options     := XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_RIGHT

//   ::bins                := XbpCombobox():new( ::grpBox1, , {96,-50}, {160,112} )
//   ::bins:type           := XBPCOMBO_DROPDOWNLIST
//   ::bins:tabStop        := .T.

//   ::txtDPI              := XbpStatic():new( ::grpBox1, , {8,8}, {80,24} )
//   ::txtDPI:caption      := "Разрешение"
//   ::txtDPI:options      := XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_RIGHT

/*   ::dpi                 := XbpCombobox():new( ::grpBox1, , {96,-82}, {160,112} )
   ::dpi:type            := XBPCOMBO_DROPDOWNLIST
   ::dpi:tabStop         := .T.
   ::grpBox2             := XbpStatic():new( ::drawingArea, , {8,104}, {264,80} )
   ::grpBox2:caption     := "Установки режима печати"
   ::grpBox2:type        := XBPSTATIC_TYPE_GROUPBOX
*/

   ::txtCopies           := XbpStatic():new( ::grpBox1, , {14,20}, {104,24} )
   ::txtCopies:caption   := "Количество копий"
   ::txtCopies:options   := XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_RIGHT

//   ::numCopies           := XbpSpinbutton():new( ::grpBox1, , {154,20}, {64,24} )
   ::numCopies           := XbpSpinbutton():new( ::grpBox1, , {154,20}, {100,24} )
   ::numCopies:tabStop   := .T.



   ::grpBox3             := XbpStatic():new( ::drawingArea, , {8,58}, {264,48} )
   ::grpBox3:caption     := "Ориентация страницы"
   ::grpBox3:type        := XBPSTATIC_TYPE_GROUPBOX

   ::portrait            := XbpRadiobutton():new( ::grpBox3, , {32,8}, {88,24} )
   ::portrait:caption    := "Книга"
   ::portrait:tabStop    := .T.
   ::portrait:selection  := .T.

   ::landscape           := XbpRadiobutton():new( ::grpBox3, , {154,8}, {88,24} )
   ::landscape:caption   := "Альбом"
   ::landscape:tabStop   := .T.

   ::btnOK               := XbpPushButton():new( ::drawingArea, , {8,8}, {104,24} )
//   ::btnOK               := XbpPushButton():new( ::drawingArea, , {8,80}, {104,24} )
   ::btnOK:caption       := "Ok"
   ::btnOK:activate      := {|| ::getData(), ::hide() }
   ::btnOK:tabStop       := .T.

   ::btnCancel           := XbpPushButton():new( ::drawingArea, , {168,8}, {104,24} )
//   ::btnCancel           := XbpPushButton():new( ::drawingArea, , {168,80}, {104,24} )
   ::btnCancel:caption   := "Отменить"
   ::btnCancel:activate  := {|| ::hide() }
   ::btnCancel:tabStop   := .T.

RETURN self


/*
 * Request system resources
 */
METHOD XbpPrinterConfig:create( oParent, oOwner, aPos, aSize, aPP, lVisible )

   ::XbpDialog:create( oParent, oOwner, aPos, aSize, aPP, lVisible )

   ::grpBox1:create()
   ::txtForms:create()
   ::forms:create()

//   ::grpBox2:create()
   ::txtCopies:create()
   ::numCopies:create()
   ::numCopies:setNumLimits( 1, 99 )

   ::grpBox3:create()
   ::portrait:create()
   ::landscape:create()

   ::btnOK:create()
   ::btnCancel:create()
RETURN self


/*
 * Assign XbpPrinter object and transfer the current configuration
 * values to the edit controls (XbaseParts)
 */
METHOD XbpPrinterConfig:setData( oPrinter )
   LOCAL i, imax, xVal

   ::oPrinter  := oPrinter
//   ::aForms    := oPrinter:forms()
   ::aForms    := oPrinter:list()
//   ::aBins     := oPrinter:paperBins()
//   ::aDpi      := oPrinter:resolutions()

   IF ::aForms == NIL
      ::forms:xbpSle:setData( "" )
      ::forms:disable()
   ELSE
      ::forms:enable()
      imax := Len( ::aForms )
      FOR i:=1 TO imax
         ::forms:addItem( ::aForms[i] )
      NEXT

      ::forms:XbpSle:setData( ::aForms[1] )
   ENDIF

      ::numCopies:enable()
      ::numCopies:setData( aPrinterSet[3] )

      ::portrait:enable()
      ::landscape:enable()
      ::portrait:setData (aPrinterSet[4]==XBPPRN_ORIENT_PORTRAIT)
      ::landscape:setData(aPrinterSet[4]<>XBPPRN_ORIENT_PORTRAIT)
RETURN self


/*
 * Transfer the configuration data to the XbpPrinter object
 */
METHOD XbpPrinterConfig:getData()
   LOCAL xVal

   IF ::oPrinter == NIL
      RETURN self
   ENDIF

   IF ::forms:isEnabled()
      xVal := ::forms:getData()
      IF .NOT. Empty( xVal )
      	aPrinterSet[1]=::aForms[ xVal[1] ]
      ENDIF
   ENDIF

   IF ::numCopies:isEnabled()
      	aPrinterSet[3]=::numCopies:getData() 
   ENDIF

   IF ::portrait:isEnabled()
      IF ::portrait:getData()
      	aPrinterSet[4]=XBPPRN_ORIENT_PORTRAIT
      ELSE
      	aPrinterSet[4]=XBPPRN_ORIENT_LANDSCAPE
      ENDIF
   ENDIF
RETURN self


/*
 * Display the window in modal state (event loop!)
 */
METHOD XbpPrinterConfig:show()
   LOCAL nEvent, mp1, mp2, oXbp

   ::oFocus := SetAppFocus()
   ::XbpDialog:show()
   ::setModalState( XBP_DISP_APPMODAL )

//   SetAppFocus( ::forms )
	 SetAppFocus( ::btnOK)

   DO WHILE ::isVisible()
      nEvent := AppEvent( @mp1, @mp2, @oXbp )
      oXbp:handleEvent( nEvent, mp1, mp2 )
   ENDDO

   ::setModalState( XBP_DISP_MODELESS )
RETURN self


/*
 * Hide the window and release configuration data
 */
METHOD XbpPrinterConfig:hide()
   IF ::getModalState() != XBP_DISP_MODELESS
      ::setModalState( XBP_DISP_MODELESS )
   ENDIF
   SetAppFocus( ::oFocus )
   ::XbpDialog:hide()

   ::aForms    := ;
   ::aBins     := ;
   ::aDPI      := ; 
   ::oPrinter  := ;
   ::oFocus    := NIL

   ::forms:clear()
//   ::dpi:clear()
RETURN self
