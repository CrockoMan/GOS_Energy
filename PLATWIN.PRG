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

   Function PlatTreWin(TypePlat)
      LOCAL oPrinter, oPS, oDlg, aSize,cText,nMaxLines,PrintLine,nPosCurPage
      LOCAL aAttr[ GRA_AL_COUNT ],aOld,OldFont,OldFocus:=SetAppFocus(),aPrinter:={}

			 aPrinter:=MainPrinterConfig(5,XBPPRN_ORIENT_PORTRAIT,"Печать платежного требования")
			 IF Empty(aPrinter[1])
			 		Return nil
			 ENDIF

      // Create presentation space for default printer
       oPS := PrinterPS(aPrinter)

      // Activate spooling
       oPS:device():startDoc()


      // Obtain configured printer object
         aSize := oPS:device():paperSize()
         aSize := { aSize[5] - aSize[3], ;
                    aSize[6] - aSize[4]  }

        oFont := XbpFont():new()              // Create XbpFont object
//        oFont:familyName := "Lucida Console" // Describe font
        oFont:familyName := "Times New Roman" // Describe font
//      oFont:height     := DEF_FONTHEIGHT
//      oFont:width      := DEF_WIDTH
        oFont:height     := 20
        oFont:width      := 10
        oFont:create()                        // Create font
        OldFont:=GraSetFont (oPS , oFont )                // Select font
//        aSize:=oPrinter:PaperSize()
        aSize := oPS:device():paperSize()
        StartX:=aSize[1]-aSize[3]
        StartY:=aSize[2]-aSize[4]
        dX:=40
        dY:=0


         aAttr[ GRA_AL_WIDTH  ] := 3
         aAttr[ GRA_AL_COLOR  ] := GRA_CLR_BLACK
         aOld:=GraSetAttrLine( oPS, aAttr )
         GraBox(oPS,{1850-dX,2780} ,{2000-dX,2830})

//         GraLine(oPS,{200,2780} ,{550,2780})
         GraLine(oPS,{200-dX,2780} ,{600-dX,2780})
         GraLine(oPS,{650-dX,2780} ,{1000-dX,2780})
         GraLine(oPS,{1050-dX,2780},{1400-dX,2780})

         GraLine(oPS,{1100-dX,2630} ,{1450-dX,2630})
         GraLine(oPS,{1500-dX,2630} ,{1850-dX,2630})


         GraLine(oPS,{200-dX,2580} ,{2000-dX,2580})
         GraLine(oPS,{400-dX,2580} ,{400-dX,2280})
         GraLine(oPS,{1700-dX,2580},{1700-dX,2430})
         GraLine(oPS,{1900-dX,2580},{1900-dX,2430})

         GraLine(oPS,{200-dX,2430} ,{2000-dX,2430})

         GraLine(oPS,{200-dX,2280} ,{2000-dX,2280})
         GraLine(oPS,{1200-dX,2130},{2000-dX,2130})

         GraLine(oPS,{200-dX,2030} ,{1350-dX,2030})
         GraLine(oPS,{1200-dX,1980},{1350-dX,1980})

         GraLine(oPS,{200-dX,1880} ,{2000-dX,1880})
         GraLine(oPS,{1200-dX,1830},{1350-dX,1830})
         GraLine(oPS,{200-dX,1730} ,{1350-dX,1730})
         GraLine(oPS,{1200-dX,1630},{2000-dX,1630})
         GraLine(oPS,{1200-dX,1580},{1350-dX,1580})
         GraLine(oPS,{1200-dX,1530},{1350-dX,1530})
         GraLine(oPS,{1550-dX,1555},{1750-dX,1555})
         GraLine(oPS,{200-dX,1480} ,{2000-dX,1480})
         GraLine(oPS,{1200-dX,2280},{1200-dX,1480})
         GraLine(oPS,{1350-dX,2280},{1350-dX,1480})
         GraLine(oPS,{200-dX,1130} ,{2000-dX,1130})

         GraLine(oPS,{1550-dX,1630},{1550-dX,1480})
         GraLine(oPS,{1750-dX,1630},{1750-dX,1480})

         GraLine(oPS,{700-dX,980} ,{1300-dX,980})
         GraLine(oPS,{700-dX,830} ,{1300-dX,830})

         GraLine(oPS,{200-dX,780} ,{1450-dX,780})
         GraLine(oPS,{200-dX,680} ,{1450-dX,680})
         GraLine(oPS,{300-dX,780} ,{ 300-dX,230})
         GraLine(oPS,{450-dX,780} ,{ 450-dX,230})
         GraLine(oPS,{700-dX,780} ,{ 700-dX,230})
         GraLine(oPS,{1000-dX,780},{1000-dX,230})
         GraLine(oPS,{1300-dX,780},{1300-dX,230})

         oFont:destroy()                        // Create font
//         oFont:familyName := "Lucida Console" // Describe font
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 45
         oFont:width      := 17
         oFont:bold       := .T.
         oFont:create()                        // Create font
         GraSetFont (oPS , oFont )             // Select font
         DO CASE
            case main->tip_plat=0
                 GraStringAt( oPS, {200-dX, 2640 },  "ПЛАТЕЖНОЕ ТРЕБОВАНИЕ № "+AllTrim(Str(Main->Lic_Schet)))
            OtherWise
                 GraStringAt( oPS, {200-dX, 2640 },  "ПЛАТЕЖНОЕ ТРЕБОВАНИЕ № "+AllTrim(Str(Main->Lic_Schet)))
         ENDCASE
         oFont:destroy()                        // Destroy font

//         oFont:familyName := "Lucida Console" // Describe font
         oFont := XbpFont():new()              // Create XbpFont object
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 22
         oFont:width      := 11
         oFont:create()                        // Destroy font
         GraSetFont (oPS , oFont )             // Select font
         GraStringAt( oPS, {270-dX,  2760 }, "Поступ.в банк плат.")
         GraStringAt( oPS, {720-dX,  2760 }, "Оконч.срока акцепта")
         GraStringAt( oPS, {1150-dX, 2760 }, "Списано со сч.плат.")
         oFont:destroy()                        // Destroy font

//         oFont:familyName := "Lucida Console" // Describe font
         oFont := XbpFont():new()              // Create XbpFont object
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 22
         oFont:width      := 11
         oFont:create()                        // Destroy font
         GraSetFont (oPS , oFont )             // Select font
         GraStringAt( oPS, {270-dX,  2760 }, "Поступ.в банк плат.")
//         GraStringAt( oPS, {680,  2760 }, "Оконч.срока акцепта")
//         GraStringAt( oPS, {1090, 2760 }, "Списано со сч.плат.")
         GraStringAt( oPS, {1250-dX, 2600 }, "Дата")
         GraStringAt( oPS, {1600-dX, 2600 }, "Вид платежа")
         oFont:destroy()                        // Destroy font



//         oFont:familyName := "Lucida Console" // Describe font
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 35
         oFont:width      := 15
         oFont:create()                        // Destroy font
         GraSetFont (oPS , oFont )             // Select font
         GraStringAt( oPS, {1860-dX,2795 }, "0401061")
         GraStringAt( oPS, {210-dX, 2530 }, "Условие")
         GraStringAt( oPS, {210-dX, 2500 }, "оплаты")

         GraStringAt( oPS, {1720-dX, 2530 }, "Срок для")
         GraStringAt( oPS, {1720-dX, 2500 }, "акцепта")

         GraStringAt( oPS, {210-dX, 2400 }, "Сумма")
         GraStringAt( oPS, {210-dX, 2370 }, "прописью")

//         GraStringAt( oPS, {210,  2230 }, "ИНН")
         GraStringAt( oPS, {1220-dX, 2230 }, "Cумма")
         GraStringAt( oPS, {1220-dX, 2090 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  2040 }, "Плательщик")
         GraStringAt( oPS, {1220-dX, 1990 }, "БИК")
         GraStringAt( oPS, {1220-dX, 1940 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  1890 }, "Банк плательщика")

         GraStringAt( oPS, {1220-dX, 1840 }, "БИК")
         GraStringAt( oPS, {1220-dX, 1800 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  1740 }, "Банк получателя")
         GraStringAt( oPS, {210-dX,  1690 }, "ИНН")
         GraStringAt( oPS, {1220-dX, 1690 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  1490 }, "Получатель")

//         GraStringAt( oPS, {210,  1440 }, "Назначение платежа")
//         GraStringAt( oPS, {210,  1140 }, "Дата отсылки (вручения) плательщику предусмотренных договором документов")
         GraStringAt( oPS, {940-dX,  1090 }, "Подписи")
         GraStringAt( oPS, {1530-dX, 1090 }, "Отметки банка получателя")
         GraStringAt( oPS, {420-dX,   940 }, "М.П.")

         GraStringAt( oPS, {1210-dX,  1590 }, "Вид оп.")
         GraStringAt( oPS, {1210-dX,  1540 }, "Наз.пл.")
         GraStringAt( oPS, {1210-dX,  1490 }, "Код")

         GraStringAt( oPS, {1570-dX,  1580 }, "Очер.плат.")
         GraStringAt( oPS, {1570-dX,  1510 }, "Рез.поле")

         GraStringAt( oPS, {210-dX,  745 }, "№ ч.")
         GraStringAt( oPS, {210-dX,  690 }, "плат.")
         GraStringAt( oPS, {310-dX,  745 }, "№ плат.")
         GraStringAt( oPS, {310-dX,  690 }, "ордера")
         GraStringAt( oPS, {470-dX,  745 }, "Дата плат.")
         GraStringAt( oPS, {470-dX,  690 }, " ордера")
         GraStringAt( oPS, {710-dX,  745 }, "Сумма частичного")
         GraStringAt( oPS, {710-dX,  690 }, "   платежа")
         GraStringAt( oPS, {1020-dX, 745 }, "Сумма остатка")
         GraStringAt( oPS, {1020-dX, 690 }, "   платежа")
         GraStringAt( oPS, {1310-dX, 745 }, "Подпись")
         GraStringAt( oPS, {1530-dX, 745 }, "Дата помещения в картотеку")
         GraStringAt( oPS, {1530-dX, 585 }, "Отметки банка плательщика")

// Дата платежа
         GraStringAt(oPS , {1220-dX,2645},if(Day(new_date+1)>9,"","0")+ltrim(str(day(new_date+1),2))+if(month(New_date+1)>9,".",".0")+ltrim(str(month(New_date+1),2))+"."+trim(str(year(New_date+1),4)))
// Вид платежа
         GraStringAt(oPS , {1600-dX,2645},VidBankPlat)
         GraStringAt( oPS, {420-dX, 2530 }, "БЕЗ АКЦЕПТА")
         GraStringAt( ops, {420-dX, 2500 }, "на основании Постановления Верховного Совета РФ n 4725-1 от 01.04.1993г.")
// Сумма прописью
         GraStringAt( oPS, {420-dX, 2400 }, cSumma1)
         GraStringAt( oPS, {420-dX, 2370 }, cSumma2)
// Сумма платежа
// [Rubls:=Substr(Trim(Str(WSEGOITNDS)),1,Len(Trim(Str(WSEGOITNDS)))-3)]
// [Kops:=Substr(Trim(Str(WSEGOITNDS)),Len(Trim(Str(WSEGOITNDS)))-1)]
         GraStringAt( oPS, {1370-dX, 2230 }, Trim(Substr(Trim(Str(WSEGOITNDS)),1,Len(Trim(Str(WSEGOITNDS)))-3)+"-"+Substr(Trim(Str(WSEGOITNDS)),Len(Trim(Str(WSEGOITNDS)))-1)))
// Счет плательщика
         GraStringAt( oPS, {1370-dX, 2090 }, AllTrim(Licevoj->R_Schet))
// Плательщик ИНН и тд
         GraStringAt( oPS, {210-dX,  2230 }, StrPlat1)
         GraStringAt( oPS, {210-dX,  2200 }, StrPlat2)
// БИК плательщика
         GraStringAt( oPS, {1370-dX, 1990 }, AllTrim(Licevoj->MFO))
// Корсчет лательщика
         GraStringAt( oPS, {1370-dX, 1940 }, AllTrim(Licevoj->K_Schet))
// Банк плательщика
         GraStringAt( oPS, {210-dX,  1980 }, SubStr(Licevoj->Bank,1,47))
         GraStringAt( oPS, {210-dX,  1950 }, Substr(Licevoj->Bank,48,Len(Licevoj->Bank)))

            GraStringAt( oPS, {210-dX,  1440 }, "Назначение платежа")
            GraStringAt( oPS, {210-dX,  1410 }, "По показаниям электросчетчиков и утвержденным тарифам за электроэнергию "+PlMonth+" месяц ") //+str(Year(New_date),4,0)+"г.")
//            GraStringAt( oPS, {210-dX,  1410 }, "По показаниям электросчетчиков и утвержденным тарифам за электроэнергию за Январь месяц "+str(Year(New_date),4,0)+"г.")
            SI:=STR(ROUND(SUMITEN,DECIMAL))
            NI:=str(round(NDSITEN,DECIMAL))
            WS:=str(round(WSEGOITNDS,DECIMAL))
            Sum3:=WSegoitnds-Post294-WSEGOPLANNDS
            Sum3:=if(Sum3>0,Sum3,0)
            Sum1:=round(Sum3*100/(100+SCHET_NDS),DECIMAL)
            Sum2:=Sum3-Sum1
            Sum1:=if(Sum1>0,Sum1,0)
            Sum2:=if(Sum2>0,Sum2,0)
            GraStringAt( oPS, {210-dX,  1380 }, "Договор № "+Str(Main->LIC_SCHET,5,0)+" от "+DTOC(MAIN->DATA_DOG)+"  "+SFString)
//            GraStringAt( oPS, {210-dX,  1350 }, "Ок.сум. "+Str(Sum1)+" НДС "+Str(Sum2)+" Всего "+Str(Sum3))
            GraStringAt( oPS, {210-dX,  1350 }, "Ок.сум. "+Str(Sum1)+" НДС "+Str(Sum2)+" Всего "+Str(Sum3)+IF(SumReaEn>0," Реак."+Str(SUMREAEN)+"  НДС"+Str(NDSREAEN)+" Всего "+Str(SUMREAEN+NDSREAEN),""))
            IF Schet_vplan=.T.
               GraStringAt( oPS, {210-dX,  1320 }, "Дог.пл. Расход "+Str(RashAKT)+" Сумма "+Str(round(WSEGOPLANNDS-NDSPLANEN,DECIMAL))+" НДС "+Str(round(NDSPLANEN,DECIMAL))+" Всего "+Str(round(WSEGOPLANNDS,DECIMAL)))
            ENDIF
            GraStringAt( oPS, {210-dX,  1290 }, Dop_Str)
            GraStringAt( oPS, {210-dX,  1200 }, "Тариф "+Str(SCHET_1NEW))
            GraStringAt( oPS, {210-dX,  1170 }, "НДС "+Str(Sum2+NDSPLANEN))
            GraStringAt( oPS, {210-dX,  1140 }, "Дата отсылки (вручения) плательщику предусмотренных договором документов "+Plat_Dat+"г.")


// Реквизиты получателя
         GraStringAt( oPS, {1360-dX,  1590 }, "02")
         GraStringAt( oPS, {1770-dX,  1580 }, "6")
         DO CASE
            CASE main->tip_plat=0.or.main->tip_plat=1
                 GraStringAt( oPS, {210-dX,  1830 }, 'Анапский филиал ОАО АКБ "УРАЛСИБ-ЮГ БАНК" г.Анапа')
                 GraStringAt( oPS, {1370-dX, 1840 }, "040304793")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810500000000793")

                 GraStringAt( oPS, {310-dX,  1690 }, '2308091759 Филиал ОАО "НЭСК" "Анапские ГЭС"')
//                 GraStringAt( oPS, {210-dX,  1640 }, 'р\сч 40702810200001003933 в Анапском филиале ОАО АКБ')
//                 GraStringAt( oPS, {210-dX,  1590 }, '"ЮГБАНК" г.Анапа')

                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810200001003933")

            CASE main->tip_plat=6
                 GraStringAt( oPS, {210-dX,  1830 }, 'ОАО "Крайинвестбанк" г.Краснодар')
                 GraStringAt( oPS, {1370-dX, 1840 }, "040349516")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810500000000516")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть"')
                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810400070000029")
            CASE main->tip_plat=4
                 GraStringAt( oPS, {210-dX,  1830 }, 'Юго-Западный банк СБ РФ г.Ростов-на-Дону')
                 GraStringAt( oPS, {1370-dX, 1840 }, "046015602")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810600000000602")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть" Анапское ОСБ')
                 GraStringAt( oPS, {210-dX,  1640 }, '1804 г.Анапа')
                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810030040100370")
            CASE main->tip_plat=8
                 GraStringAt( oPS, {210-dX,  1830 }, 'ФКБ "ПЕТРОКОММЕРЦ" в г.Новороссийске г.Новороссийск')
                 GraStringAt( oPS, {1370-dX, 1840 }, "040395988")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810300000000988")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть"')
                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810400120100263")

         ENDCASE

         oFont:destroy()                        // Destroy font



         GraSetAttrLine( oPS, aOld )
         GraSetFont(oPs,OldFont)
      oPS:device():endDoc()

      DestroyDevice( oPS )

      SetAppFocus(oldFocus)
   RETURN NIL


   Function PenqPlatTreWin()
      LOCAL oPrinter, oPS, oDlg, aSize,cText,nMaxLines,PrintLine,nPosCurPage
      LOCAL aAttr[ GRA_AL_COUNT ],aOld,OldFont,OldFocus:=SetAppFocus()

      oDlg := XbpPrintDialog():new()
      oDlg:numCopies := 5
      oDlg:create()

      // Obtain configured printer object

      oPrinter := oDlg:display()
      oDlg:destroy()

      IF oPrinter <> NIL
         // Create a new presentation space
         oPS   := XbpPresSpace():new()

         // Size of printable region on paper
         aSize := oPrinter:paperSize()
         aSize := { aSize[5] - aSize[3], ;
                    aSize[6] - aSize[4]  }
         oPS:create( oPrinter, aSize, GRA_PU_LOMETRIC )

        oFont := XbpFont():new()              // Create XbpFont object
//        oFont:familyName := "Lucida Console" // Describe font
        oFont:familyName := "Times New Roman" // Describe font
//      oFont:height     := DEF_FONTHEIGHT
//      oFont:width      := DEF_WIDTH
        oFont:height     := 20
        oFont:width      := 10
        oFont:create()                        // Create font
        OldFont:=GraSetFont (oPS , oFont )                // Select font
        aSize:=oPrinter:PaperSize()
        StartX:=aSize[1]-aSize[3]
        StartY:=aSize[2]-aSize[4]
        dX:=40
        dY:=0


         oPrinter:startDoc()
         aAttr[ GRA_AL_WIDTH  ] := 3
         aAttr[ GRA_AL_COLOR  ] := GRA_CLR_BLACK
         aOld:=GraSetAttrLine( oPS, aAttr )
         GraBox(oPS,{1850-dX,2780} ,{2000-dX,2830})

//         GraLine(oPS,{200,2780} ,{550,2780})
         GraLine(oPS,{200-dX,2780} ,{600-dX,2780})
         GraLine(oPS,{650-dX,2780} ,{1000-dX,2780})
         GraLine(oPS,{1050-dX,2780},{1400-dX,2780})

         GraLine(oPS,{1100-dX,2630} ,{1450-dX,2630})
         GraLine(oPS,{1500-dX,2630} ,{1850-dX,2630})


         GraLine(oPS,{200-dX,2580} ,{2000-dX,2580})
         GraLine(oPS,{400-dX,2580} ,{400-dX,2280})
         GraLine(oPS,{1700-dX,2580},{1700-dX,2430})
         GraLine(oPS,{1900-dX,2580},{1900-dX,2430})

         GraLine(oPS,{200-dX,2430} ,{2000-dX,2430})

         GraLine(oPS,{200-dX,2280} ,{2000-dX,2280})
         GraLine(oPS,{1200-dX,2130},{2000-dX,2130})

         GraLine(oPS,{200-dX,2030} ,{1350-dX,2030})
         GraLine(oPS,{1200-dX,1980},{1350-dX,1980})

         GraLine(oPS,{200-dX,1880} ,{2000-dX,1880})
         GraLine(oPS,{1200-dX,1830},{1350-dX,1830})
         GraLine(oPS,{200-dX,1730} ,{1350-dX,1730})
         GraLine(oPS,{1200-dX,1630},{2000-dX,1630})
         GraLine(oPS,{1200-dX,1580},{1350-dX,1580})
         GraLine(oPS,{1200-dX,1530},{1350-dX,1530})
         GraLine(oPS,{1550-dX,1555},{1750-dX,1555})
         GraLine(oPS,{200-dX,1480} ,{2000-dX,1480})
         GraLine(oPS,{1200-dX,2280},{1200-dX,1480})
         GraLine(oPS,{1350-dX,2280},{1350-dX,1480})
         GraLine(oPS,{200-dX,1130} ,{2000-dX,1130})

         GraLine(oPS,{1550-dX,1630},{1550-dX,1480})
         GraLine(oPS,{1750-dX,1630},{1750-dX,1480})

         GraLine(oPS,{700-dX,980} ,{1300-dX,980})
         GraLine(oPS,{700-dX,830} ,{1300-dX,830})

         GraLine(oPS,{200-dX,780} ,{1450-dX,780})
         GraLine(oPS,{200-dX,680} ,{1450-dX,680})
         GraLine(oPS,{300-dX,780} ,{ 300-dX,230})
         GraLine(oPS,{450-dX,780} ,{ 450-dX,230})
         GraLine(oPS,{700-dX,780} ,{ 700-dX,230})
         GraLine(oPS,{1000-dX,780},{1000-dX,230})
         GraLine(oPS,{1300-dX,780},{1300-dX,230})

         oFont:destroy()                        // Create font
//         oFont:familyName := "Lucida Console" // Describe font
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 45
         oFont:width      := 17
         oFont:bold       := .T.
         oFont:create()                        // Create font
         GraSetFont (oPS , oFont )             // Select font
         DO CASE
            case main->tip_plat=0
                 GraStringAt( oPS, {200-dX, 2640 },  "ПЛАТЕЖНОЕ ТРЕБОВАНИЕ № "+AllTrim(Str(Main->Lic_Schet)))
            OtherWise
                 GraStringAt( oPS, {200-dX, 2640 },  "ПЛАТЕЖНОЕ ТРЕБОВАНИЕ № "+AllTrim(Str(Main->Lic_Schet)))
         ENDCASE
         oFont:destroy()                        // Destroy font

//         oFont:familyName := "Lucida Console" // Describe font
         oFont := XbpFont():new()              // Create XbpFont object
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 22
         oFont:width      := 11
         oFont:create()                        // Destroy font
         GraSetFont (oPS , oFont )             // Select font
         GraStringAt( oPS, {270-dX,  2760 }, "Поступ.в банк плат.")
         GraStringAt( oPS, {720-dX,  2760 }, "Оконч.срока акцепта")
         GraStringAt( oPS, {1150-dX, 2760 }, "Списано со сч.плат.")
         oFont:destroy()                        // Destroy font

//         oFont:familyName := "Lucida Console" // Describe font
         oFont := XbpFont():new()              // Create XbpFont object
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 22
         oFont:width      := 11
         oFont:create()                        // Destroy font
         GraSetFont (oPS , oFont )             // Select font
         GraStringAt( oPS, {270-dX,  2760 }, "Поступ.в банк плат.")
//         GraStringAt( oPS, {680,  2760 }, "Оконч.срока акцепта")
//         GraStringAt( oPS, {1090, 2760 }, "Списано со сч.плат.")
         GraStringAt( oPS, {1250-dX, 2600 }, "Дата")
         GraStringAt( oPS, {1600-dX, 2600 }, "Вид платежа")
         oFont:destroy()                        // Destroy font



//         oFont:familyName := "Lucida Console" // Describe font
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 35
         oFont:width      := 15
         oFont:create()                        // Destroy font
         GraSetFont (oPS , oFont )             // Select font
         GraStringAt( oPS, {1860-dX,2795 }, "0401061")
         GraStringAt( oPS, {210-dX, 2530 }, "Условие")
         GraStringAt( oPS, {210-dX, 2500 }, "оплаты")

         GraStringAt( oPS, {1720-dX, 2530 }, "Срок для")
         GraStringAt( oPS, {1720-dX, 2500 }, "акцепта")

         GraStringAt( oPS, {210-dX, 2400 }, "Сумма")
         GraStringAt( oPS, {210-dX, 2370 }, "прописью")

//         GraStringAt( oPS, {210,  2230 }, "ИНН")
         GraStringAt( oPS, {1220-dX, 2230 }, "Cумма")
         GraStringAt( oPS, {1220-dX, 2090 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  2040 }, "Плательщик")
         GraStringAt( oPS, {1220-dX, 1990 }, "БИК")
         GraStringAt( oPS, {1220-dX, 1940 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  1890 }, "Банк плательщика")

         GraStringAt( oPS, {1220-dX, 1840 }, "БИК")
         GraStringAt( oPS, {1220-dX, 1800 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  1740 }, "Банк получателя")
         GraStringAt( oPS, {210-dX,  1690 }, "ИНН")
         GraStringAt( oPS, {1220-dX, 1690 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  1490 }, "Получатель")

//         GraStringAt( oPS, {210,  1440 }, "Назначение платежа")
//         GraStringAt( oPS, {210,  1140 }, "Дата отсылки (вручения) плательщику предусмотренных договором документов")
         GraStringAt( oPS, {940-dX,  1090 }, "Подписи")
         GraStringAt( oPS, {1530-dX, 1090 }, "Отметки банка получателя")
         GraStringAt( oPS, {420-dX,   940 }, "М.П.")

         GraStringAt( oPS, {1210-dX,  1590 }, "Вид оп.")
         GraStringAt( oPS, {1210-dX,  1540 }, "Наз.пл.")
         GraStringAt( oPS, {1210-dX,  1490 }, "Код")

         GraStringAt( oPS, {1570-dX,  1580 }, "Очер.плат.")
         GraStringAt( oPS, {1570-dX,  1510 }, "Рез.поле")

         GraStringAt( oPS, {210-dX,  745 }, "№ ч.")
         GraStringAt( oPS, {210-dX,  690 }, "плат.")
         GraStringAt( oPS, {310-dX,  745 }, "№ плат.")
         GraStringAt( oPS, {310-dX,  690 }, "ордера")
         GraStringAt( oPS, {470-dX,  745 }, "Дата плат.")
         GraStringAt( oPS, {470-dX,  690 }, " ордера")
         GraStringAt( oPS, {710-dX,  745 }, "Сумма частичного")
         GraStringAt( oPS, {710-dX,  690 }, "   платежа")
         GraStringAt( oPS, {1020-dX, 745 }, "Сумма остатка")
         GraStringAt( oPS, {1020-dX, 690 }, "   платежа")
         GraStringAt( oPS, {1310-dX, 745 }, "Подпись")
         GraStringAt( oPS, {1530-dX, 745 }, "Дата помещения в картотеку")
         GraStringAt( oPS, {1530-dX, 585 }, "Отметки банка плательщика")

// Дата платежа
         GraStringAt(oPS , {1220-dX,2645},if(Day(New_date+1)>9,"","0")+ltrim(str(day(new_date+1),2))+if(month(new_date+1)>9,".",".0")+ltrim(str(month(new_date+1),2))+"."+trim(str(year(new_date+1),4)))
// Вид платежа
         GraStringAt(oPS , {1600-dX,2645},VidBankPlat)
         GraStringAt( oPS, {420-dX, 2530 }, "С АКЦЕПТОМ")
//         GraStringAt( ops, {420-dX, 2500 }, "на основании Постановления Верховного Совета РФ n 4725-1 от 01.04.1993г.")
// Сумма прописью
         GraStringAt( oPS, {420-dX, 2400 }, cSumma1)
         GraStringAt( oPS, {420-dX, 2370 }, cSumma2)
// Сумма платежа
// [Rubls:=Substr(Trim(Str(WSEGOITNDS)),1,Len(Trim(Str(WSEGOITNDS)))-3)]
// [Kops:=Substr(Trim(Str(WSEGOITNDS)),Len(Trim(Str(WSEGOITNDS)))-1)]
         GraStringAt( oPS, {1370-dX, 2230 }, Trim(Substr(Trim(Str(Penq)),1,Len(Trim(Str(Penq)))-3)+"-"+Substr(Trim(Str(Penq)),Len(Trim(Str(Penq)))-1)))
// Счет плательщика
         GraStringAt( oPS, {1370-dX, 2090 }, AllTrim(Licevoj->R_Schet))
// Плательщик ИНН и тд
         GraStringAt( oPS, {210-dX,  2230 }, StrPlat1)
         GraStringAt( oPS, {210-dX,  2200 }, StrPlat2)
// БИК плательщика
         GraStringAt( oPS, {1370-dX, 1990 }, AllTrim(Licevoj->MFO))
// Корсчет лательщика
         GraStringAt( oPS, {1370-dX, 1940 }, AllTrim(Licevoj->K_Schet))
// Банк плательщика
         GraStringAt( oPS, {210-dX,  1980 }, SubStr(Licevoj->Bank,1,47))
         GraStringAt( oPS, {210-dX,  1950 }, Substr(Licevoj->Bank,48,Len(Licevoj->Bank)))

            GraStringAt( oPS, {210-dX,  1440 }, "Назначение платежа")
            GraStringAt( oPS, {210-dX,  1410 }, "Проценты в размере банковской ставки рефинансирования за несвоевременную оплату электрической энергии")
//            SI:=STR(ROUND(SUMITEN,DECIMAL))
//            NI:=str(round(NDSITEN,DECIMAL))
//            WS:=str(round(WSEGOITNDS,DECIMAL))
//            Sum3:=WSegoitnds-Post294-WSEGOPLANNDS
//            Sum3:=if(Sum3>0,Sum3,0)
//            Sum1:=round(Sum3*100/(100+SCHET_NDS),DECIMAL)
//            Sum2:=Sum3-Sum1
//            Sum1:=if(Sum1>0,Sum1,0)
//            Sum2:=if(Sum2>0,Sum2,0)
            PL_ALL_NAL:=100+SCHET_NDS+SCHET_DNAL
            NDS_IS_PL:=round(PENQ*schet_nds/PL_ALL_NAL,Decimal)
            SUMBNDS:=PENQ-NDS_IS_PL
            PL_DOG:=MAIN->DOGOWOR
            GraStringAt( oPS, {210-dX,  1380 }, "за "+Mes_Name+" месяц Договор № "+Str(Main->LIC_SCHET,5,0)+" от "+DTOC(MAIN->DATA_DOG))
            GraStringAt( oPS, {210-dX,  1350 }, "Сумма    "+Str(Penq)+" Без НДС")
//            GraStringAt( oPS, {210-dX,  1350 }, "Всего "+Str(SUMBNDS)+"  НДС "+Str(NDS_IS_PL)+"  Сумма    "+Str(Penq))
//            GraStringAt( oPS, {210-dX,  1320 }, "Дог.пл. Расход "+Str(RashAKT)+" Сумма "+Str(round(WSEGOPLANNDS-NDSPLANEN,DECIMAL))+" НДС "+Str(round(NDSPLANEN,DECIMAL))+" Всего "+Str(round(WSEGOPLANNDS,DECIMAL)))
//            GraStringAt( oPS, {210-dX,  1290 }, Dop_Str)
//            GraStringAt( oPS, {210-dX,  1200 }, "Тариф "+Str(SCHET_1NEW))
//            GraStringAt( oPS, {210-dX,  1170 }, "НДС "+Str(NDS_IS_PL))

            GraStringAt( oPS, {210-dX,  1140 }, "Дата отсылки (вручения) плательщику предусмотренных договором документов "+Plat_Dat+"г.")


// Реквизиты получателя
         GraStringAt( oPS, {1360-dX,  1590 }, "02")
         GraStringAt( oPS, {1770-dX,  1580 }, "6")
         DO CASE
            CASE main->tip_plat=0.or.main->tip_plat=1
                 GraStringAt( oPS, {210-dX,  1830 }, 'ОАО АКБ "ЮГБАНК" г.Краснодар')
                 GraStringAt( oPS, {1370-dX, 1840 }, "040349713")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810400000000713")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть"')
//                 GraStringAt( oPS, {210-dX,  1640 }, 'р\сч 40602810900000000052 в Анапском филиале ОАО АКБ')
//                 GraStringAt( oPS, {210-dX,  1590 }, '"ЮГБАНК" г.Анапа')
                 GraStringAt( oPS, {1370-dX, 1690 }, "30301810600000000001")
            CASE main->tip_plat=6
                 GraStringAt( oPS, {210-dX,  1830 }, 'ОАО "Крайинвестбанк" г.Краснодар')
                 GraStringAt( oPS, {1370-dX, 1840 }, "040349516")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810500000000516")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть"')
                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810400070000029")
            CASE main->tip_plat=4
                 GraStringAt( oPS, {210-dX,  1830 }, 'Юго-Западный банк СБ РФ г.Ростов-на-Дону')
                 GraStringAt( oPS, {1370-dX, 1840 }, "046015602")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810600000000602")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть" Анапское ОСБ')
                 GraStringAt( oPS, {210-dX,  1640 }, '1804 г.Анапа')
                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810030040100370")
            CASE main->tip_plat=8
                 GraStringAt( oPS, {210-dX,  1830 }, 'ФКБ "ПЕТРОКОММЕРЦ" в г.Новороссийске г.Новороссийск')
                 GraStringAt( oPS, {1370-dX, 1840 }, "040395988")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810300000000988")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть"')
                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810400120100263")

         ENDCASE

         oFont:destroy()                        // Destroy font



         GraSetAttrLine( oPS, aOld )
         GraSetFont(oPs,OldFont)
         oPrinter:endDoc()

         // Housekeeping
         oPrinter:destroy()
         oPS:destroy()
      ENDIF
      SetAppFocus(oldFocus)
   RETURN NIL



   Function GenFiftyDays2(TypePlat)
      LOCAL oPrinter, oPS, oDlg, aSize,cText,nMaxLines,PrintLine,nPosCurPage
      LOCAL aAttr[ GRA_AL_COUNT ],aOld,OldFont,OldFocus:=SetAppFocus(),aPrinter:={}

			 aPrinter:=MainPrinterConfig(5,XBPPRN_ORIENT_PORTRAIT,"Печать платежного требования")
			 IF Empty(aPrinter[1])
			 		Return nil
			 ENDIF

      // Create presentation space for default printer
       oPS := PrinterPS(aPrinter)

      // Activate spooling
       oPS:device():startDoc()


      // Obtain configured printer object
         aSize := oPS:device():paperSize()
         aSize := { aSize[5] - aSize[3], ;
                    aSize[6] - aSize[4]  }

        oFont := XbpFont():new()              // Create XbpFont object
//        oFont:familyName := "Lucida Console" // Describe font
        oFont:familyName := "Times New Roman" // Describe font
//      oFont:height     := DEF_FONTHEIGHT
//      oFont:width      := DEF_WIDTH
        oFont:height     := 20
        oFont:width      := 10
        oFont:create()                        // Create font
        OldFont:=GraSetFont (oPS , oFont )                // Select font
//        aSize:=oPrinter:PaperSize()
        aSize := oPS:device():paperSize()
        StartX:=aSize[1]-aSize[3]
        StartY:=aSize[2]-aSize[4]
        dX:=40
        dY:=0


         aAttr[ GRA_AL_WIDTH  ] := 3
         aAttr[ GRA_AL_COLOR  ] := GRA_CLR_BLACK
         aOld:=GraSetAttrLine( oPS, aAttr )
         GraBox(oPS,{1850-dX,2780} ,{2000-dX,2830})

//         GraLine(oPS,{200,2780} ,{550,2780})
         GraLine(oPS,{200-dX,2780} ,{600-dX,2780})
         GraLine(oPS,{650-dX,2780} ,{1000-dX,2780})
         GraLine(oPS,{1050-dX,2780},{1400-dX,2780})

         GraLine(oPS,{1100-dX,2630} ,{1450-dX,2630})
         GraLine(oPS,{1500-dX,2630} ,{1850-dX,2630})


         GraLine(oPS,{200-dX,2580} ,{2000-dX,2580})
         GraLine(oPS,{400-dX,2580} ,{400-dX,2280})
         GraLine(oPS,{1700-dX,2580},{1700-dX,2430})
         GraLine(oPS,{1900-dX,2580},{1900-dX,2430})

         GraLine(oPS,{200-dX,2430} ,{2000-dX,2430})

         GraLine(oPS,{200-dX,2280} ,{2000-dX,2280})
         GraLine(oPS,{1200-dX,2130},{2000-dX,2130})

         GraLine(oPS,{200-dX,2030} ,{1350-dX,2030})
         GraLine(oPS,{1200-dX,1980},{1350-dX,1980})

         GraLine(oPS,{200-dX,1880} ,{2000-dX,1880})
         GraLine(oPS,{1200-dX,1830},{1350-dX,1830})
         GraLine(oPS,{200-dX,1730} ,{1350-dX,1730})
         GraLine(oPS,{1200-dX,1630},{2000-dX,1630})
         GraLine(oPS,{1200-dX,1580},{1350-dX,1580})
         GraLine(oPS,{1200-dX,1530},{1350-dX,1530})
         GraLine(oPS,{1550-dX,1555},{1750-dX,1555})
         GraLine(oPS,{200-dX,1480} ,{2000-dX,1480})
         GraLine(oPS,{1200-dX,2280},{1200-dX,1480})
         GraLine(oPS,{1350-dX,2280},{1350-dX,1480})
         GraLine(oPS,{200-dX,1130} ,{2000-dX,1130})

         GraLine(oPS,{1550-dX,1630},{1550-dX,1480})
         GraLine(oPS,{1750-dX,1630},{1750-dX,1480})

         GraLine(oPS,{700-dX,980} ,{1300-dX,980})
         GraLine(oPS,{700-dX,830} ,{1300-dX,830})

         GraLine(oPS,{200-dX,780} ,{1450-dX,780})
         GraLine(oPS,{200-dX,680} ,{1450-dX,680})
         GraLine(oPS,{300-dX,780} ,{ 300-dX,230})
         GraLine(oPS,{450-dX,780} ,{ 450-dX,230})
         GraLine(oPS,{700-dX,780} ,{ 700-dX,230})
         GraLine(oPS,{1000-dX,780},{1000-dX,230})
         GraLine(oPS,{1300-dX,780},{1300-dX,230})

         oFont:destroy()                        // Create font
//         oFont:familyName := "Lucida Console" // Describe font
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 45
         oFont:width      := 17
         oFont:bold       := .T.
         oFont:create()                        // Create font
         GraSetFont (oPS , oFont )             // Select font
         DO CASE
            case main->tip_plat=0
                 GraStringAt( oPS, {200-dX, 2640 },  "ПЛАТЕЖНОЕ ТРЕБОВАНИЕ № "+AllTrim(Str(Main->Lic_Schet)))
            OtherWise
                 GraStringAt( oPS, {200-dX, 2640 },  "ПЛАТЕЖНОЕ ТРЕБОВАНИЕ № "+AllTrim(Str(Main->Lic_Schet)))
         ENDCASE
         oFont:destroy()                        // Destroy font

//         oFont:familyName := "Lucida Console" // Describe font
         oFont := XbpFont():new()              // Create XbpFont object
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 22
         oFont:width      := 11
         oFont:create()                        // Destroy font
         GraSetFont (oPS , oFont )             // Select font
         GraStringAt( oPS, {270-dX,  2760 }, "Поступ.в банк плат.")
         GraStringAt( oPS, {720-dX,  2760 }, "Оконч.срока акцепта")
         GraStringAt( oPS, {1150-dX, 2760 }, "Списано со сч.плат.")
         oFont:destroy()                        // Destroy font

//         oFont:familyName := "Lucida Console" // Describe font
         oFont := XbpFont():new()              // Create XbpFont object
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 22
         oFont:width      := 11
         oFont:create()                        // Destroy font
         GraSetFont (oPS , oFont )             // Select font
         GraStringAt( oPS, {270-dX,  2760 }, "Поступ.в банк плат.")
//         GraStringAt( oPS, {680,  2760 }, "Оконч.срока акцепта")
//         GraStringAt( oPS, {1090, 2760 }, "Списано со сч.плат.")
         GraStringAt( oPS, {1250-dX, 2600 }, "Дата")
         GraStringAt( oPS, {1600-dX, 2600 }, "Вид платежа")
         oFont:destroy()                        // Destroy font



//         oFont:familyName := "Lucida Console" // Describe font
         oFont:familyName := "Times New Roman" // Describe font
         oFont:height     := 35
         oFont:width      := 15
         oFont:create()                        // Destroy font
         GraSetFont (oPS , oFont )             // Select font
         GraStringAt( oPS, {1860-dX,2795 }, "0401061")
         GraStringAt( oPS, {210-dX, 2530 }, "Условие")
         GraStringAt( oPS, {210-dX, 2500 }, "оплаты")

         GraStringAt( oPS, {1720-dX, 2530 }, "Срок для")
         GraStringAt( oPS, {1720-dX, 2500 }, "акцепта")

         GraStringAt( oPS, {210-dX, 2400 }, "Сумма")
         GraStringAt( oPS, {210-dX, 2370 }, "прописью")

//         GraStringAt( oPS, {210,  2230 }, "ИНН")
         GraStringAt( oPS, {1220-dX, 2230 }, "Cумма")
         GraStringAt( oPS, {1220-dX, 2090 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  2040 }, "Плательщик")
         GraStringAt( oPS, {1220-dX, 1990 }, "БИК")
         GraStringAt( oPS, {1220-dX, 1940 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  1890 }, "Банк плательщика")

         GraStringAt( oPS, {1220-dX, 1840 }, "БИК")
         GraStringAt( oPS, {1220-dX, 1800 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  1740 }, "Банк получателя")
         GraStringAt( oPS, {210-dX,  1690 }, "ИНН")
         GraStringAt( oPS, {1220-dX, 1690 }, "Cч.№")
         GraStringAt( oPS, {210-dX,  1490 }, "Получатель")

//         GraStringAt( oPS, {210,  1440 }, "Назначение платежа")
//         GraStringAt( oPS, {210,  1140 }, "Дата отсылки (вручения) плательщику предусмотренных договором документов")
         GraStringAt( oPS, {940-dX,  1090 }, "Подписи")
         GraStringAt( oPS, {1530-dX, 1090 }, "Отметки банка получателя")
         GraStringAt( oPS, {420-dX,   940 }, "М.П.")

         GraStringAt( oPS, {1210-dX,  1590 }, "Вид оп.")
         GraStringAt( oPS, {1210-dX,  1540 }, "Наз.пл.")
         GraStringAt( oPS, {1210-dX,  1490 }, "Код")

         GraStringAt( oPS, {1570-dX,  1580 }, "Очер.плат.")
         GraStringAt( oPS, {1570-dX,  1510 }, "Рез.поле")

         GraStringAt( oPS, {210-dX,  745 }, "№ ч.")
         GraStringAt( oPS, {210-dX,  690 }, "плат.")
         GraStringAt( oPS, {310-dX,  745 }, "№ плат.")
         GraStringAt( oPS, {310-dX,  690 }, "ордера")
         GraStringAt( oPS, {470-dX,  745 }, "Дата плат.")
         GraStringAt( oPS, {470-dX,  690 }, " ордера")
         GraStringAt( oPS, {710-dX,  745 }, "Сумма частичного")
         GraStringAt( oPS, {710-dX,  690 }, "   платежа")
         GraStringAt( oPS, {1020-dX, 745 }, "Сумма остатка")
         GraStringAt( oPS, {1020-dX, 690 }, "   платежа")
         GraStringAt( oPS, {1310-dX, 745 }, "Подпись")
         GraStringAt( oPS, {1530-dX, 745 }, "Дата помещения в картотеку")
         GraStringAt( oPS, {1530-dX, 585 }, "Отметки банка плательщика")

// Дата платежа
         GraStringAt(oPS , {1220-dX,2645},if(Day(new_date+1)>9,"","0")+ltrim(str(day(new_date+1),2))+if(month(New_date+1)>9,".",".0")+ltrim(str(month(New_date+1),2))+"."+trim(str(year(New_date+1),4)))
// Вид платежа
         GraStringAt(oPS , {1600-dX,2645},VidBankPlat)
         GraStringAt( oPS, {420-dX, 2530 }, "БЕЗ АКЦЕПТА")
         GraStringAt( ops, {420-dX, 2500 }, "на основании Постановления Верховного Совета РФ n 4725-1 от 01.04.1993г.")
// Сумма прописью
         GraStringAt( oPS, {420-dX, 2400 }, cSumma1)
         GraStringAt( oPS, {420-dX, 2370 }, cSumma2)
// Сумма платежа
// [Rubls:=Substr(Trim(Str(WSEGOITNDS)),1,Len(Trim(Str(WSEGOITNDS)))-3)]
// [Kops:=Substr(Trim(Str(WSEGOITNDS)),Len(Trim(Str(WSEGOITNDS)))-1)]
         GraStringAt( oPS, {1370-dX, 2230 }, Trim(Substr(Trim(Str(FiftySumma)),1,Len(Trim(Str(FiftySumma)))-3)+"-"+Substr(Trim(Str(FiftySumma)),Len(Trim(Str(FiftySumma)))-1)))
// Счет плательщика
         GraStringAt( oPS, {1370-dX, 2090 }, AllTrim(Licevoj->R_Schet))
// Плательщик ИНН и тд
         GraStringAt( oPS, {210-dX,  2230 }, StrPlat1)
         GraStringAt( oPS, {210-dX,  2200 }, StrPlat2)
// БИК плательщика
         GraStringAt( oPS, {1370-dX, 1990 }, AllTrim(Licevoj->MFO))
// Корсчет лательщика
         GraStringAt( oPS, {1370-dX, 1940 }, AllTrim(Licevoj->K_Schet))
// Банк плательщика
         GraStringAt( oPS, {210-dX,  1980 }, SubStr(Licevoj->Bank,1,47))
         GraStringAt( oPS, {210-dX,  1950 }, Substr(Licevoj->Bank,48,Len(Licevoj->Bank)))

            GraStringAt( oPS, {210-dX,  1440 }, "Назначение платежа")
            GraStringAt( oPS, {210-dX,  1410 }, "По показаниям электросчетчиков и утвержденным тарифам за электроэнергию "+PlMonth+" месяц ")  //+str(Year(New_date),4,0)+"г.")

//            GraStringAt( oPS, {210-dX,  1380 }, "Пост. Правит. РФ №294 от 04.04.2000г. ")
            GraStringAt( oPS, {210-dX,  1380 }, "Договор № "+Str(Main->LIC_SCHET,5,0)+" от "+DTOC(MAIN->DATA_DOG)+"  "+SFString)
//            GraStringAt( oPS, {210-dX,  1350 }, "Ок.сум. "+Str(Sum1)+" НДС "+Str(Sum2)+" Всего "+Str(Sum3))
            GraStringAt( oPS, {210-dX,  1350 }, "Сумма "+Str(FiftySumma-NDS)+" НДС "+Str(round(NDS,DECIMAL))+" Всего с НДС "+Str(round(FiftySumma,DECIMAL)))
            GraStringAt( oPS, {210-dX,  1290 }, Dop_Str)
            GraStringAt( oPS, {210-dX,  1200 }, "Тариф "+Str(SCHET_1NEW))
            GraStringAt( oPS, {210-dX,  1170 }, "НДС "+Str(NDS))
            GraStringAt( oPS, {210-dX,  1140 }, "Дата отсылки (вручения) плательщику предусмотренных договором документов "+Plat_Dat+"г.")


// Реквизиты получателя
         GraStringAt( oPS, {1360-dX,  1590 }, "02")
         GraStringAt( oPS, {1770-dX,  1580 }, "6")
         DO CASE
            CASE main->tip_plat=0.or.main->tip_plat=1
                 GraStringAt( oPS, {210-dX,  1830 }, 'Анапский филиал ОАО АКБ "УРАЛСИБ-ЮГ БАНК" г.Анапа')
                 GraStringAt( oPS, {1370-dX, 1840 }, "040304793")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810500000000793")

                 GraStringAt( oPS, {310-dX,  1690 }, '2308091759 Филиал ОАО "НЭСК" "Анапские ГЭС"')
//                 GraStringAt( oPS, {210-dX,  1640 }, 'р\сч 40702810200001003933 в Анапском филиале ОАО АКБ')
//                 GraStringAt( oPS, {210-dX,  1590 }, '"ЮГБАНК" г.Анапа')

                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810200001003933")

            CASE main->tip_plat=6
                 GraStringAt( oPS, {210-dX,  1830 }, 'ОАО "Крайинвестбанк" г.Краснодар')
                 GraStringAt( oPS, {1370-dX, 1840 }, "040349516")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810500000000516")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть"')
                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810400070000029")
            CASE main->tip_plat=4
                 GraStringAt( oPS, {210-dX,  1830 }, 'Юго-Западный банк СБ РФ г.Ростов-на-Дону')
                 GraStringAt( oPS, {1370-dX, 1840 }, "046015602")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810600000000602")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть" Анапское ОСБ')
                 GraStringAt( oPS, {210-dX,  1640 }, '1804 г.Анапа')
                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810030040100370")
            CASE main->tip_plat=8
                 GraStringAt( oPS, {210-dX,  1830 }, 'ФКБ "ПЕТРОКОММЕРЦ" в г.Новороссийске г.Новороссийск')
                 GraStringAt( oPS, {1370-dX, 1840 }, "040395988")
                 GraStringAt( oPS, {1370-dX, 1800 }, "30101810300000000988")
                 GraStringAt( oPS, {310-dX,  1690 }, '2301001844 УМП "Горэлектросеть"')
                 GraStringAt( oPS, {1370-dX, 1690 }, "40702810400120100263")

         ENDCASE

         oFont:destroy()                        // Destroy font



         GraSetAttrLine( oPS, aOld )
         GraSetFont(oPs,OldFont)
      oPS:device():endDoc()

      DestroyDevice( oPS )

      SetAppFocus(oldFocus)
   RETURN NIL
