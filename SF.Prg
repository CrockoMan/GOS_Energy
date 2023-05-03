#include "Gra.ch"
#include "Xbp.ch"
#include "xbpdev.ch"

   FUNCTION MainSF(nSfMonth)
      LOCAL oPS
      Local nOrientation
      Local i,SfDat,nPrintLine,Perem,oFont,OldFont
			Local aPrinter:={}
	
			 aPrinter:=MainPrinterConfig(1,XBPPRN_ORIENT_LANDSCAPE,"Печать счета-фактуры")
			 IF Empty(aPrinter[1])
			 		Return nil
			 ENDIF
//			 lPresDate:=Al_BOX({"Дата для формирования документа"},2,{" Текущая "," Конец месяца "})


      // Create presentation space for default printer
       oPS := PrinterPS(aPrinter)


//       oPS := PrinterPS()

      // Activate spooling
       oPS:device():startDoc()

       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 23
       oFont:width      := 12
       oFont:create()                        // Create font
       OldFont:=GraSetFont (oPS , oFont )                // Select font



//      GraLine( oPS, {450,1850}, {2150,1850} )
       GraStringAt( oPS, {2630,1890}, 'Приложение N1' )
       GraStringAt( oPS, {1825,1865}, 'к Правилам ведения журналов учета полученных и выставленных счетов-фактур, ' )
       GraStringAt( oPS, {1840,1840}, 'книг покупок и книг продаж при расчетах по налогу на добавленную стоимость,' )
       GraStringAt( oPS, {1630,1815}, 'утвержденным постановлением Правительства Российской Федерации от 2 декабря 2000 г. N 914')
       GraStringAt( oPS, {2010,1790}, '(в редакции постановлений Правительства Российской Федерации' )
       GraStringAt( oPS, {1850,1765}, 'от 15 марта 2001 г. N 189, от 27 июля 2002 г. N 575, от 16 февраля 2004 г. N 84)' )

       oFont:destroy()                        // Create font

       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 60
       oFont:width      := 25
       oFont:bold:=.T.
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
//       SFDat:="30 декабря 2006г."
       IF lPresDate==1
          SFDat:=alltrim(str(day((New_Date+1))))+"  "+mesqc(month(New_Date+1),1)+;
                 ' '+alltrim(str(year(New_Date+1)))
       ELSE
          SFDat:=alltrim(str(LastDayOM(nSfMonth)))+"  "+mesqc(NSfMonth,1)+' '+;
          	  if(nSfMonth==12,"2006",alltrim(str(year(New_Date+1))))
       ENDIF
       GraStringAt( oPS, {150,1670}, 'Счет-фактура № '+AllTrim(Str(lic_schet,8))+" от "+SFDat+"г." )

       oFont:destroy()                        // Create font

       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 31
       oFont:width      := 16
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font

//Грузоотправитель и его адрес [SchetNameOrg                     ],353410,Россия,Краснодарский край,г.Анапа,ул.Лермонтова 117
//Грузополучатель и его адрес [GruzPol                                                                                         ]
//К платежно-расчетному документу N [SCHET_ ] от [PLAT_DAT         ]
//Покупатель [POTRSTRING                                                                                                       ]
//Адрес [Main->DressBoss                             ] Телефон [PHONE             ]
//#Расчетный счет [LICEVOJ->R_SCHET  ] в [trim(LICEVOJ->BANK)             ]
//#Город [TOWNSTRING        ]       БИК [MFOl     ]    к/с [K_SCH                  ]
//Идентификационный номер покупателя (ИНН) [INNSTRING   ] (КПП) [KPPSTRING   ]
//       GraStringAt( oPS, {150,1630}, 'Продавец: '+SchetNameOrg )
       GraStringAt( oPS, {150,1630}, 'Продавец: ОАО "НЭСК"' )
//       GraStringAt( oPS, {150,1590}, 'Адрес: '+SchetAdr )
       GraStringAt( oPS, {150,1590}, 'Адрес: 350049 г.Краснодар ул.Северная 247' )
       GraStringAt( oPS, {150,1550}, 'ИНН/КПП продавца '+SchetInn+' / '+SchetKpp )
//       GraStringAt( oPS, {150,1550}, 'ИНН/КПП продавца  2308091759 / 230801001' )
       GraStringAt( oPS, {150,1510}, 'Грузоотправитель и его адрес: '+SchetNameOrg+" "+SchetAdr )
       GraStringAt( oPS, {150,1470}, 'Грузополучатель и его адрес: '+PotrString+" "+Main->DressBoss )
       GraStringAt( oPS, {150,1430}, 'К платежно-расчетному документу N '+AllTrim(Str(Schet_,9))+' от '+Plat_Dat+"г." )
       
       GraStringAt( oPS, {150,1390}, 'Покупатель '+IF(Empty(Main->Platel),PotrString,Delstring(Main->Platel,"ИНН")) )
       IF .not.Empty(Main->Platel)
					KPPSTRING=Alltrim(Substr(appendstring(main->Platel,"КПП"),4,11))
					innstring=appendstring(Main->Platel,"ИНН")
					innstring=alltrim(substr(innstring,4,AtNum(" ",InnString,1,6)-4))
       ENDIF
       	
       GraStringAt( oPS, {150,1350}, 'Адрес:'+Main->DressBoss )
       GraStringAt( oPS, {150,1310}, 'ИНН/КПП покупателя '+InnString+" / "+KppString )
       oFont:destroy()                        // Create font


       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 28
       oFont:width      := 12
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
       GraStringAt( oPS, {170 ,1240}, 'Наименование товара (описание' )
       GraStringAt( oPS, {180 ,1210}, 'выполненных работ, оказанных' )
//       GraStringAt( oPS, {350 ,1180}, 'услуг), имущественного права' )
       GraStringAt( oPS, {180 ,1180}, 'услуг), имущественного права' )
       GraStringAt( oPS, {624 ,1240}, 'Еденица' )
       GraStringAt( oPS, {633 ,1210}, 'изме-' )
       GraStringAt( oPS, {630 ,1180}, 'рения' )
       GraStringAt( oPS, {765 ,1240}, 'Коли-' )
       GraStringAt( oPS, {762 ,1210}, 'чество' )
       GraStringAt( oPS, {905 ,1240}, 'Цена (тариф)' )
       GraStringAt( oPS, {915 ,1210}, 'за еденицу' )
       GraStringAt( oPS, {917 ,1180}, 'измерения' )
       
       GraStringAt( oPS, {1135,1260}, 'Стоимость' )
       GraStringAt( oPS, {1092,1235}, 'товаров (работ,' )
       GraStringAt( oPS, {1092,1210}, 'услуг),имуществ' )
       GraStringAt( oPS, {1092,1185}, 'енных прав,всего' )
       GraStringAt( oPS, {1132,1168}, 'без налога' )
       
       GraStringAt( oPS, {1330,1240}, 'В том' )
       GraStringAt( oPS, {1330,1210}, 'числе' )
       GraStringAt( oPS, {1330,1180}, 'акциз' )
       GraStringAt( oPS, {1452,1240}, 'Налоговая' )
       GraStringAt( oPS, {1480,1210}, 'ставка' )
       GraStringAt( oPS, {1606,1240}, 'Сумма налога' )

//       GraStringAt( oPS, {1845,1260}, 'Стоимость' )
//       GraStringAt( oPS, {1807,1230}, 'товаров (работ,' )
//       GraStringAt( oPS, {1815,1200}, 'услуг), всего с' )
//       GraStringAt( oPS, {1815,1170}, 'учетом налога' )
       GraStringAt( oPS, {1845,1260}, 'Стоимость' )
       GraStringAt( oPS, {1807,1235}, 'товаров (работ,' )
       GraStringAt( oPS, {1815,1210}, 'услуг),имуществ' )
       GraStringAt( oPS, {1815,1185}, 'енных прав,всего' )
       GraStringAt( oPS, {1815,1168}, 'c учетом налога' )

       GraStringAt( oPS, {2100,1240}, 'Страна' )
       GraStringAt( oPS, {2080,1210}, 'происхож-' )
       GraStringAt( oPS, {2110,1180}, 'дения' )
       GraStringAt( oPS, {2510,1260}, 'Номер' )
//       GraStringAt( oPS, {2490,1230}, 'грузовой' )
//       GraStringAt( oPS, {2470,1200}, 'таможенной' )
//       GraStringAt( oPS, {2475,1170}, 'декларации' )
       GraStringAt( oPS, {2470,1230}, 'таможенной' )
       GraStringAt( oPS, {2475,1200}, 'декларации' )
       GraStringAt( oPS, {390,1130}, '1' )
       GraStringAt( oPS, {675,1130}, '2' )
       GraStringAt( oPS, {815,1130}, '3' )
       GraStringAt( oPS, {950,1130}, '4' )
       GraStringAt( oPS, {1200,1130}, '5' )
       GraStringAt( oPS, {1350,1130}, '6' )
       GraStringAt( oPS, {1540,1130}, '7' )
       GraStringAt( oPS, {1700,1130}, '8' )
       GraStringAt( oPS, {1900,1130}, '9' )
       GraStringAt( oPS, {2150,1130}, '10' )
       GraStringAt( oPS, {2550,1130}, '11' )
       oFont:destroy()                        // Create font

// ------------------------------------------------------------------------------ Текст в счет-фактуру
       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 30
       oFont:width      := 14
       oFont:bold:=.T.
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font

//│за {PlMonth   }{YE}│      │            │         │              │      │      │            │              │ Россия │     │
			 nPrintLine:=1090
			 	
//       GraStringAt( oPS, {155,nPrintLine}, 'за '+PlMonth+" "+Str(Year(New_Date),4,)+"г." )
       GraStringAt( oPS, {155,nPrintLine}, 'за '+PlMonth+" "+;
              Str(if(nSFMonth==12.and.Month(New_Date)==1,Year(New_Date)-1,Year(New_Date)),4,)+"г." )
              	
       nPrintLine:=nPrintLine-30
//# {NdsAktEn:=Round(Sumakten*Schet_Nds/100,DECIMAL)} {WsegoSNds:=SumAktEn+NdsAktEn}
//│Активная энергия   │кВт.ч │{AKTEN     }│{CENAA  }│{SUMAKTEN    }│      │{NDS }│{NDSAKTEN  }│{WSEGOSNDS   }│        │     │
       GraStringAt( oPS, {155 ,nPrintLine}, "Активная энергия" )
       GraStringAt( oPS, {628 ,nPrintLine}, 'кВт/ч' )
       GraStringAt( oPS, {765 ,nPrintLine}, Str(AktEn,6) )
       GraStringAt( oPS, {915 ,nPrintLine}, Str(round(SUMAKTEN/AKTEN,3),8,4) )
       GraStringAt( oPS, {1135,nPrintLine}, Str(SumAktEn,12,2) )
       GraStringAt( oPS, {1480,nPrintLine}, Str(Schet_Nds,5,2) )
       GraStringAt( oPS, {1606,nPrintLine}, Str(Round(Sumakten*Schet_Nds/100,DECIMAL),12,2) )
       GraStringAt( oPS, {1815,nPrintLine}, Str(SumAktEn+NdsAktEn,12,2) )
       GraStringAt( oPS, {2100,nPrintLine}, 'Россия' )
       nPrintLine:=nPrintLine-30
       For i=1 to 7
         Perem:="AktEn"+AllTrim(Str(I))
      	 IF Type(Perem)#"UE".and.Type(Perem)#"UI".and.Type(Perem)#"U"
      		 GraStringAt( oPS, {155 ,nPrintLine}, "в том числе" )
      		 GraStringAt( oPS, {628 ,nPrintLine}, 'кВт/ч' )
      		 GraStringAt( oPS, {765 ,nPrintLine}, Str( &("AktEn"+AllTrim(Str(I))) ,6) )
      		 GraStringAt( oPS, {915 ,nPrintLine}, Str(&("CenaA"+AllTrim(Str(I))),8,4) )
      		 GraStringAt( oPS, {1135,nPrintLine}, Str(&("SumAktEn"+AllTrim(Str(I))),12,2) )
      		 GraStringAt( oPS, {1480,nPrintLine}, Str(Schet_nds,5,2) )
      		 GraStringAt( oPS, {1606,nPrintLine}, Str(&("NdsAktEn"+AllTrim(Str(I))),12,2) )
      		 GraStringAt( oPS, {1815,nPrintLine}, Str(&("WsegosNds"+AllTrim(Str(I))),12,2) )
      		 nPrintLine:=nPrintLine-30
      	 ENDIF
       next
//│в том числе        │кВт.ч │{AKTEN1    }│{CENAA1 }│{SUMAKTEN1   }│      │{NDS }│{NDSAKTEN1 }│{WSEGOSNDS1  }│        │     │
//│в том числе        │кВт.ч │{AKTEN2    }│{CENAA2 }│{SUMAKTEN2   }│      │{NDS }│{NDSAKTEN2 }│{WSEGOSNDS2  }│        │     │
//│в том числе        │кВт.ч │{AKTEN3    }│{CENAA3 }│{SUMAKTEN3   }│      │{NDS }│{NDSAKTEN3 }│{WSEGOSNDS3  }│        │     │
//│в том числе        │кВт.ч │{AKTEN4    }│{CENAA4 }│{SUMAKTEN4   }│      │{NDS }│{NDSAKTEN4 }│{WSEGOSNDS4  }│        │     │
//# Всего с НДС для реактивной энергии {WSEGOSNDS:=SUMREAEN+NDSREAEN}
//│Реактивная энергия │Квар.ч│{REAEN     }│{CENAR  }│{SUMREAEN    }│      │{NDS }│{NDSREAEN  }│{WSEGOSNDS   }│        │     │
			 IF ReaEn>0
      	GraStringAt( oPS, {155 ,nPrintLine}, "Реактивная энергия" )
      	GraStringAt( oPS, {628 ,nPrintLine}, 'кВар/ч' )
      	GraStringAt( oPS, {765 ,nPrintLine}, Str(ReaEn,6) )
      	GraStringAt( oPS, {915 ,nPrintLine}, Str(round(SUMREAEN/REAEN,4),8,4) )
      	GraStringAt( oPS, {1135,nPrintLine}, Str(SumReaEn,12,2) )
      	GraStringAt( oPS, {1480,nPrintLine}, Str(Schet_Nds,5,2) )
      	GraStringAt( oPS, {1606,nPrintLine}, Str(NdsReaEn,12,2) )
      	GraStringAt( oPS, {1815,nPrintLine}, Str(SUMREAEN+NDSREAEN,12,2) )
   			nPrintLine:=nPrintLine-30
   		 ENDIF	
//# Доначисления {WSEGODON:=DONNDS+DONSUM}
//│Доначислено        │кВт.ч │{DONPOW    }│{CENAD  }│{DONSUM      }│      │{NDS }│{DONNDS    }│{WSEGODON    }│        │     │
			 IF DonPow>0
      	GraStringAt( oPS, {155 ,nPrintLine}, "Доначислено" )
      	GraStringAt( oPS, {628 ,nPrintLine}, 'кВт/ч' )
      	GraStringAt( oPS, {765 ,nPrintLine}, Str(DonPow,6) )
      	GraStringAt( oPS, {915 ,nPrintLine}, Str(round(DONSUM/DONPOW,4),8,4) )
      	GraStringAt( oPS, {1135,nPrintLine}, Str(DonSum,12,2) )
      	GraStringAt( oPS, {1480,nPrintLine}, Str(Schet_Nds,5,2) )
      	GraStringAt( oPS, {1606,nPrintLine}, Str(DonNds,12,2) )
      	GraStringAt( oPS, {1815,nPrintLine}, Str(DONNDS+DONSUM,12,2) )
   			nPrintLine:=nPrintLine-30
       ENDIF
//# Расчет планового платежа {PLANEN:=AKTEN+REAEN-WOZWPOW} {SUMPLANEN:=SUMAKTEN+SUMREAEN-WOZWSUM-AbonSum} {NDSPLANEN:=NDSAKTEN+NDSREAEN-WOZWNDS}
//# {WSEGOPLANNDS:=SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN-WOZWSUM-WOZWND
//#│Договорной платеж  │      │{PLANEN    }│         │{SUMPLANEN   }│      │{NDS }│{NDSPLANEN }│{WSEGOPLANNDS}│        │     │
//#│Оплачено всего:    │      │            │         │{SUMOPLACH   }│      │{NDS }│{NDSOPLACH }│{WSEGOPLA    }│        │     │
//├───────────────────┼──────┼────────────┼─────────┼──────────────┼──────┼──────┼────────────┼──────────────┼────────┼─────┤
//# Итог: {ITEN:=AKTEN+REAEN+DONPOW} {SUMITEN:=SUMAKTEN+SUMREAEN+DONSUM} {NDSITEN:=NDSAKTEN+NDSREAEN+DONNDS}
//#       {WSEGOITNDS:=DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN}
//│Всего к оплате     │      │            │         │{SUMITEN     }│      │      │{NDSITEN   }│{WSEGOITNDS  }│        │     │
 			 nPrintLine:=nPrintLine-20
       GraStringAt( oPS, {1606,nPrintLine}, Str(NDSAKTEN+NDSREAEN+DONNDS,12,2) )
       GraStringAt( oPS, {1815,nPrintLine}, Str(DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN,12,2) )
       oFont:destroy()                        // Create font
//   		nPrintLine:=nPrintLine-50

       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 28
       oFont:width      := 16
       oFont:bold:=.T.
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
       GraStringAt( oPS, {155,nPrintLine}, 'Всего к оплате' )
       GraStringAt( oPS, {2620,1290}, 'Валюта: руб.' )
       oFont:destroy()                        // Create font

//------------------------------------------------------
       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 31
       oFont:width      := 16
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
//       GraStringAt( oPS, {150, nPrintLine- 80}, 'Руководитель организации        _________________  '+AllTrim(NAMEBOSS)+'                              Главный бухгалтер  ____________________  '+AllTrim(NAMEBUH) )
       GraStringAt( oPS, {150, nPrintLine- 80}, 'Руководитель организации  (Нач.ОСЭ)_________________  Бородай Ю.Ю.                          Главный бухгалтер (Экономист ОСЭ) ____________________  Карпович В.Г.' )
       GraStringAt( oPS, {150, nPrintLine- 102},'Приказ  №79 от 27.02.07                                                                                                                  Приказ  №79 от 27.02.07' )

       GraStringAt( oPS, {150, nPrintLine-160}, 'Индивидуальный предприниматель  _________________' )
       GraStringAt( oPS, {1620,nPrintLine-160}, '(реквизиты свидетельства о государственной')
       GraStringAt( oPS, {1620,nPrintLine-180}, 'регистрации индивидуального предпринимателя)')
       oFont:destroy()                        // Create font


       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 27
       oFont:width      := 13
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
       GraStringAt( oPS, {150,540}, 'ПРИМЕЧАНИЕ. Первый экземпляр - покупателю, второй экземпляр - продавцу')

       oFont:destroy()                        // Create font
       GraSetFont (oPS , OldFont )                // Select font

// ----------------------------------------------------------------- Отрисовка таблицы
      // Spool graphic output
       GraLine( oPS, {150,1280}, {2820,1280} )
       GraLine( oPS, {150,1160}, {2820,1160} )
       GraLine( oPS, {150,1120}, {2820,1120} )
       GraLine( oPS, {150,nPrintLine+35}, {2820,nPrintLine+35} )
//      GraLine( oPS, {150,1080}, {2020,1080} )
       GraLine( oPS, {150,nPrintLine-10}, {2020,nPrintLine-10} )
//      GraLine( oPS, {150,1080}, {150,1280} )
       GraLine( oPS, {150 ,nPrintLine-10}, {150,1280} )
       GraLine( oPS, {620 ,nPrintLine+35}, {620,1280} )
       GraLine( oPS, {740 ,nPrintLine+35}, {740,1280} )
       GraLine( oPS, {900 ,nPrintLine+35}, {900,1280} )
       GraLine( oPS, {1090,nPrintLine+35}, {1090,1280} )
       GraLine( oPS, {1300,nPrintLine+35}, {1300,1280} )
       GraLine( oPS, {1450,nPrintLine+35}, {1450,1280} )
       GraLine( oPS, {1600,nPrintLine-10}, {1600,1280} )
       GraLine( oPS, {1800,nPrintLine-10}, {1800,1280} )
       GraLine( oPS, {2020,nPrintLine-10}, {2020,1280} )
       GraLine( oPS, {2290,nPrintLine+35}, {2290,1280} )
       GraLine( oPS, {2820,nPrintLine+35}, {2820,1280} )
// ----------------------------------------------------------------- Отрисовка таблицы

      // End spooling
      oPS:device():endDoc()

      DestroyDevice( oPS )
   RETURN Nil






Function MainNakl(nNaklMonth)
      LOCAL oPS,ntMonth,ntDay,ntYear
      Local nOrientation
      Local i,SfDat,nPrintLine,Perem,oFont,OldFont,strSumma1:="",strSumma2:=""
			Local aPrinter:={},aAttr[ GRA_AL_COUNT ],aOldLine,nPP:=1
	
			 aPrinter:=MainPrinterConfig(1,XBPPRN_ORIENT_LANDSCAPE,"Печать накладной")
			 IF Empty(aPrinter[1])
			 		Return nil
			 ENDIF



      // Create presentation space for default printer
      oPS := PrinterPS(aPrinter)


//       oPS := PrinterPS()

      // Activate spooling
      oPS:device():startDoc()
      aOldLine:=GraSetAttrLine(oPs,aAttr)


//      graBox( oPs, { 70,230}, {200,350}  )

//      aAttr[ GRA_AL_WIDTH  ] := 5
//      GraSetAttrLine(oPs,aAttr)
 
//      GraSetAttrLine(oPs,aOldLine) 
      // Spool graphic output
      
      GraLine( oPS, {2400,1930}, {2600,1930} )
      GraLine( oPS, {2400,1880}, {2600,1880} )
      GraLine( oPS, {2400,1830}, {2600,1830} )
      GraLine( oPS, {2400,1780}, {2600,1780} )
      GraLine( oPS, {680,1730}, {2600,1730} )
      GraLine( oPS, {2400,1680}, {2600,1680} )
      GraLine( oPS, {2400,1615}, {2600,1615} )
      GraLine( oPS, {2400,1550}, {2600,1550} )
      GraLine( oPS, {450,1485}, {2600,1485} )
      GraLine( oPS, {450,1435}, {2600,1435} )
      GraLine( oPS, {2230,1385}, {2600,1385} )
      GraLine( oPS, {2230,1335}, {2600,1335} )
      GraLine( oPS, {2230,1285}, {2600,1285} )
      GraLine( oPS, {2400,1235}, {2600,1235} )
      GraLine( oPS, {450,1780}, {2100,1780} )
      GraLine( oPS, {450,1615}, {2100,1615} )
      GraLine( oPS, {450,1550}, {2100,1550} )
      GraLine( oPS, {2400,1930}, {2400,1235} )
      GraLine( oPS, {2600,1930}, {2600,1235} )
      GraLine( oPS, {2230,1485}, {2230,1285} )
      GraLine( oPS, {1080,1385}, {1580,1385} )
      GraLine( oPS, {1080,1335}, {1580,1335} )
      GraLine( oPS, {1080,1285}, {1580,1285} )
      GraLine( oPS, {1080,1385}, {1080,1285} )
      GraLine( oPS, {1330,1385}, {1330,1285} )
      GraLine( oPS, {1580,1385}, {1580,1285} )

        aAttr[ GRA_AL_WIDTH  ] := 5
        GraSetAttrLine(oPs,aAttr)
 
     graBox( oPs, {1080,1285}, {1580,1335}  )
     GraLine( oPS, {1330,1335}, {1330,1285} )
     GraLine( oPS, {2400,1880}, {2400,1235} )
     GraLine( oPS, {2600,1880}, {2600,1235} )
     GraLine( oPS, {2400,1235}, {2600,1235} )
       
        GraSetAttrLine(oPs,aOldLine)


//      GraLine( oPS, {450,1850}, {2150,1850} )
      
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 27
      oFont:width      := 11

//      oFont:bold:=.t.
      
      oFont:create()                        // Create font
      OldFont:=GraSetFont (oPS , oFont )                // Select font
      GraStringAt( oPS, {2150,1970}, 'Унифицированная форма № ТОРГ-12' )
      GraStringAt( oPS, {1800,1940}, 'Утверждена постановлением Госкомстата России от 25.12.98 № 132' )
     
      oFont:destroy()                        // Create font

      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 34
      oFont:width      := 14

//      oFont:bold:=.t.
      
      oFont:create()                        // Create font
      OldFont:=GraSetFont (oPS , oFont )                // Select font
      GraStringAt( oPS, {2460,1895}, 'Коды' )
      GraStringAt( oPS, {2147,1845}, 'Форма по ОКУД' )
      GraStringAt( oPS, {2250,1795}, 'по ОКПО' )
      GraStringAt( oPS, {2430,1795}, '03216321' )
      GraStringAt( oPS, {1985,1695}, 'Вид деятельности по ОКДП' )
      GraStringAt( oPS, {2250,1630}, 'по ОКПО' )
      
      GraStringAt( oPS, {2430,1565}, '14809308' )
      GraStringAt( oPS, {2250,1565}, 'по ОКПО' )
      GraStringAt( oPS, {2250,1500}, 'по ОКПО' )
      GraStringAt( oPS, {2300,1450}, 'номер' )
      GraStringAt( oPS, {2320,1400}, 'дата' )
      GraStringAt( oPS, {2300,1350}, 'номер' )      
      GraStringAt( oPS, {2320,1300}, 'дата' )      
      GraStringAt( oPS, {2190,1250}, 'Вид операции' )
      GraStringAt( oPS, {1865,1350}, 'Транспортная накладная' )       
      GraStringAt( oPS, {175,1795}, 'Грузоотправитель' )      
      GraStringAt( oPS, {265,1745}, 'Структурное подразделение       Отдел сбыта энергии' )
      GraStringAt( oPS, {190,1630}, 'Грузополучатель '+PotrString )      
      GraStringAt( oPS, {270,1565}, 'Поставщик' )

      GraStringAt( oPS, {260,1500}, 'Плательщик '+IF(Empty(Main->Platel),PotrString,Delstring(Main->Platel,"ИНН")) )
     
      GraStringAt( oPS, {270,1450}, 'Основание   Договор' ) 
      
      oFont:destroy()                        // Create font
      
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 35
      oFont:width      := 15
      oFont:bold:=.t.
      oFont:create()                        // Create font
      OldFont:=GraSetFont (oPS , oFont )                // Select font
      GraStringAt( oPS, {2440,1845}, '0330212' )
      
      oFont:destroy()                        // Create font
      
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 32
      oFont:width      := 12
      oFont:bold:=.t.
      oFont:create()                        // Create font
      OldFont:=GraSetFont (oPS , oFont )                // Select font

      GraStringAt( oPS, {450,1845}, 'Филиал ОАО "НЭСК" "Анапские городские электрические сети", 353440, Краснодарский край, Анапа г, Лермонтова ул,' )
      GraStringAt( oPS, {450,1815}, 'д. 117, тел: 5-45-80, 5-26-80, р/с 40702810200001003933 в АНАПСКИЙ ФИЛИАЛ ОАО АКБ "УРАЛСИБ-ЮГ БАНК", г.Анапа' )      
      GraStringAt( oPS, {450,1785}, 'БИК 040304793, корр/с 30101810500000000793' )        
        
      oFont:destroy()                        // Create font     
     
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 32
      oFont:width      := 12
      oFont:bold:=.f.
      oFont:create()                        // Create font
      OldFont:=GraSetFont (oPS , oFont )                // Select font
      GraStringAt( oPS, {450,1585}, 'тел: 5-45-80, 5-26-80, р/с 40702810200001003933 в АНАПСКИЙ ФИЛИАЛ ОАО АКБ "УРАЛСИБ-ЮГ БАНК",г.Анапа,' )      
      GraStringAt( oPS, {450,1555}, ' БИК 040304793, корр/с 30101810500000000793' )        
        
      oFont:destroy()                        // Create font     
     
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 25
      oFont:width      := 10
      oFont:create()                        // Create font
      OldFont:=GraSetFont (oPS , oFont )                // Select font
      GraStringAt( oPS, {1200,1765}, 'организация, адрес, телефон, факс, банковские' )
      GraStringAt( oPS, {1100,1420}, 'наименование документа (договор, контракт, заказ-наряд)' )
        
      oFont:destroy()                        // Create font     
     
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 27
      oFont:width      := 11
      oFont:create()                        // Create font
      OldFont:=GraSetFont (oPS , oFont )                // Select font
      GraStringAt( oPS, {1100,1355}, 'Номер документа' )
      GraStringAt( oPS, {1350,1355}, 'Дата составления' )
        
      oFont:destroy()                        // Create font      

      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 38
      oFont:width      := 16
      oFont:bold:=.t.
      oFont:create()                        // Create font
      OldFont:=GraSetFont (oPS , oFont )                // Select font
      GraStringAt( oPS, {1170,1300}, AllTrim(Str(Schet_,9)) )

/*
       IF lPresDate==1
          SFDat:=alltrim(str(day((New_Date+1))))+"  "+mesqc(month(New_Date+1),1)+;
                 ' '+alltrim(str(year(New_Date+1)))
       ELSE
          SFDat:=alltrim(str(LastDayOM(nSfMonth)))+"  "+mesqc(NSfMonth,1)+' '+;
          	  if(nSfMonth==12,"2006",alltrim(str(year(New_Date+1))))
       ENDIF
*/


//       SFDat:=alltrim(str(LastDayOM(nSfMonth)))+"  "+mesqc(NSfMonth,1)+' '+;
//       	  if(nSfMonth==12,"2006",alltrim(str(year(New_Date+1))))


      IF (nNaklMonth==12.and.Month(New_Date+1)==1)
      	GraStringAt( oPS, {1380,1300}, "31.12."+AllTrim(Str(Year(New_Date+1)-1)) )
      ELSE
//      	GraStringAt( oPS, {1380,1300}, DTOC(New_Date+1) )

	      IF lPresDate==1
        	GraStringAt( oPS, {1380,1300}, alltrim(str(Day(New_Date+1)))+"."+if(nNaklMonth<10,"0","")+AllTrim(Str(nNaklMonth,2,0))+'.'+;
       	             	if(nNaklMonth==12,"2006",alltrim(str(year(New_Date+1))))  )
				ELSE
	        GraStringAt( oPS, {1380,1300}, alltrim(str(LastDayOM(nNaklMonth)))+"."+if(nNaklMonth<10,"0","")+AllTrim(Str(nNaklMonth,2,0))+'.'+;
       	             	if(nNaklMonth==12,"2006",alltrim(str(year(New_Date+1))))  )
      	ENDIF
/*
				ntMonth:=AllTrim(Str(Month(New_Date+1),2,0))
				ntDay:=AllTrim(Str(LastDayOM(ntMonth),2,0))
				ntYear:=AllTrim(Str(Year(New_Date+1),4,0))
      	GraStringAt( oPS, {1380,1300}, DTOC(CTOD(ntDay+"."+ntMonth+"."+ntYear)) )
*/
      ENDIF
        
      oFont:destroy()                        // Create font         
      
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 38
      oFont:width      := 16
      oFont:bold:=.t.
      oFont:create()                        // Create font
      OldFont:=GraSetFont (oPS , oFont )                // Select font
      GraStringAt( oPS, {550,1300}, 'ТОВАРНАЯ НАКЛАДНАЯ' )
        


//----------------------------------------------------

      GraLine( oPS, {130,1200}, {2620,1200} )
      GraLine( oPS, {230,1160}, {1110,1160} )
      GraLine( oPS, {1250,1160}, {1470,1160} )
      GraLine( oPS, {2130,1160}, {2420,1160} )
      GraLine( oPS, {130,1060}, {2620,1060} )
      GraLine( oPS, {130,1020}, {2620,1020} )

 
      GraLine( oPS, {700,1020}, {810,1020} )
      GraLine( oPS, {950,1020}, {2130,1020} )
      GraLine( oPS, {2260,1020}, {2620,1020} )
       
      GraSetAttrLine(oPs,aOldLine)    

     
      
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 34
      oFont:width      := 13
//      oFont:bold:=.t.
      oFont:create()                        // Create font
      GraSetFont (oPS , oFont )                // Select font
      
      GraStringAt( oPS, {132,1172}, 'Номер' )
      GraStringAt( oPS, {165,1140}, 'по' )
      GraStringAt( oPS, {132,1108}, 'поряд-' )
      GraStringAt( oPS, {165,1076}, 'ку' )
      GraStringAt( oPS, {168,1030}, '1' )
      GraStringAt( oPS, {460,1172}, 'Товар' )
      GraStringAt( oPS, {250,1125}, 'наименование, характеристика,' )      
      GraStringAt( oPS, {330,1093}, 'сорт, артикул товара' ) 
      GraStringAt( oPS, {440,1030}, '2' ) 
      GraStringAt( oPS, {730,1108}, 'код' )
      GraStringAt( oPS, {750,1030}, '3' )  
      GraStringAt( oPS, {820,1172}, 'Еденица измерения' )
      GraStringAt( oPS, {825,1125}, 'наиме-' )
      GraStringAt( oPS, {820,1093}, 'нование' )
      GraStringAt( oPS, {880,1030}, '4' ) 
      GraStringAt( oPS, {980,1125}, 'код по' )
      GraStringAt( oPS, {985,1093}, 'ОКЕИ' )
      GraStringAt( oPS, {1015,1030}, '5' ) 
      GraStringAt( oPS, {1150,1140}, 'Вид' )
      GraStringAt( oPS, {1120,1108}, 'упаковки' )
      GraStringAt( oPS, {1170,1030}, '6' )
      GraStringAt( oPS, {1270,1172}, 'Количество' )  
      GraStringAt( oPS, {1300,1140}, 'в' )
      GraStringAt( oPS, {1270,1108}, 'одном' )
      GraStringAt( oPS, {1270,1076}, 'месте' )
      GraStringAt( oPS, {1300,1030}, '7' )
      GraStringAt( oPS, {1380,1125}, 'мест,' )
      GraStringAt( oPS, {1380,1093}, 'штук' )
      GraStringAt( oPS, {1410,1030}, '8' )
      GraStringAt( oPS, {1500,1140}, 'Масса' )
      GraStringAt( oPS, {1500,1108}, 'брутто' )
      GraStringAt( oPS, {1520,1030}, '9' )
      GraStringAt( oPS, {1640,1172}, 'Количе-' )
      GraStringAt( oPS, {1665,1140}, 'ство' )
      GraStringAt( oPS, {1650,1108}, '(масса' )
      GraStringAt( oPS, {1650,1076}, 'нетто)' )
      GraStringAt( oPS, {1675,1030}, '10' )
      GraStringAt( oPS, {1810,1140}, 'Цена' )
      GraStringAt( oPS, {1800,1108}, 'руб. коп.' )
      GraStringAt( oPS, {1830,1030}, '11' )
      GraStringAt( oPS, {1960,1155}, 'Сумма без' )
      GraStringAt( oPS, {1950,1123}, 'учета НДС,' )
      GraStringAt( oPS, {1960,1091}, 'руб. коп.' )
      GraStringAt( oPS, {2000,1030}, '12' )
      GraStringAt( oPS, {2245,1172}, 'НДС' )
      GraStringAt( oPS, {2150,1125}, 'ставка,' )
      GraStringAt( oPS, {2180,1093}, '%' )
      GraStringAt( oPS, {2180,1030}, '13' )
      GraStringAt( oPS, {2300,1125}, 'сумма,' )
      GraStringAt( oPS, {2290,1093}, 'руб.коп.' )
      GraStringAt( oPS, {2325,1030}, '14' )      
      GraStringAt( oPS, {2460,1172}, 'Сумма с' )
      GraStringAt( oPS, {2470,1140}, 'учетом' )
      GraStringAt( oPS, {2490,1108}, 'НДС,' )
      GraStringAt( oPS, {2470,1076}, 'руб. коп.' )      
      GraStringAt( oPS, {2500,1030}, '15' )
      nPrintline:=990



       GraStringAt( oPS, {165 ,nPrintLine}, Str(nPP,2,0) )
       GraStringAt( oPS, {250 ,nPrintLine}, "Активная энергия" )
       GraStringAt( oPS, {820 ,nPrintLine}, 'кВт/ч' )
       GraStringAt( oPS, {1640 ,nPrintLine}, Str(AktEn,6) )
       
       GraStringAt( oPS, {1800,nPrintLine}, Str(round(SUMAKTEN/AKTEN,3),8,4) )
//       GraStringAt( oPS, {1800,nPrintLine}, "1.76" )
       GraStringAt( oPS, {1950,nPrintLine}, Str(SumAktEn,12,2) )
       GraStringAt( oPS, {2150,nPrintLine}, Str(Schet_Nds,5,2) )
       GraStringAt( oPS, {2250,nPrintLine}, Str(Round(Sumakten*Schet_Nds/100,DECIMAL),12,2) )
       GraStringAt( oPS, {2450,nPrintLine}, Str(SumAktEn+NdsAktEn,12,2) )
       nPrintLine:=nPrintLine-30
       nPP:=nPP+1
       For i=1 to 7
         Perem:="AktEn"+AllTrim(Str(I))
      	 IF Type(Perem)#"UE".and.Type(Perem)#"UI".and.Type(Perem)#"U"
       		 GraStringAt( oPS, {165 ,nPrintLine}, Str(nPP,2,0) )
      		 GraStringAt( oPS, {250 ,nPrintLine}, "в том числе" )
      		 GraStringAt( oPS, {820 ,nPrintLine}, 'кВт/ч' )
      		 GraStringAt( oPS, {1640,nPrintLine}, Str( &("AktEn"+AllTrim(Str(I))) ,6) )
      		 GraStringAt( oPS, {1800,nPrintLine}, Str(&("CenaA"+AllTrim(Str(I))),8,4) )
//      		 GraStringAt( oPS, {1800,nPrintLine}, "1.76")
      		 GraStringAt( oPS, {1950,nPrintLine}, Str(&("SumAktEn"+AllTrim(Str(I))),12,2) )
      		 GraStringAt( oPS, {2150,nPrintLine}, Str(Schet_nds,5,2) )
      		 GraStringAt( oPS, {2250,nPrintLine}, Str(&("NdsAktEn"+AllTrim(Str(I))),12,2) )
      		 GraStringAt( oPS, {2450,nPrintLine}, Str(&("WsegosNds"+AllTrim(Str(I))),12,2) )
      		 nPrintLine:=nPrintLine-30
      		 nPP:=nPP+1
      	 ENDIF
       next
       
			 IF ReaEn>0
        GraStringAt( oPS, {165 ,nPrintLine}, Str(nPP,2,0) )
      	GraStringAt( oPS, {250 ,nPrintLine}, "Реактивная энергия" )
      	GraStringAt( oPS, {820 ,nPrintLine}, 'кВар/ч' )
      	GraStringAt( oPS, {1640,nPrintLine}, Str(ReaEn,6) )
      	GraStringAt( oPS, {1800,nPrintLine}, Str(round(SUMREAEN/REAEN,4),8,4) )
      	GraStringAt( oPS, {1950,nPrintLine}, Str(SumReaEn,12,2) )
      	GraStringAt( oPS, {2150,nPrintLine}, Str(Schet_Nds,5,2) )
      	GraStringAt( oPS, {2250,nPrintLine}, Str(NdsReaEn,12,2) )
      	GraStringAt( oPS, {2450,nPrintLine}, Str(SUMREAEN+NDSREAEN,12,2) )
   			nPrintLine:=nPrintLine-30
   		 ENDIF	

      GraLine( oPS, {130,nPrintLine+20}, {2620,nPrintLine+20} )

      GraLine( oPS, {130,1200},  {130, nPrintLine+20} )
      GraLine( oPS, {230,1200},  {230, nPrintLine+20} )
      GraLine( oPS, {700,1160},  {700, nPrintLine+20} )      
      GraLine( oPS, {810,1200},  {810, nPrintLine+20} )
      GraLine( oPS, {950,1160},  {950, nPrintLine+20} )
      GraLine( oPS, {1110,1200}, {1110,nPrintLine+20} )
      GraLine( oPS, {1250,1200}, {1250,nPrintLine+20} )

      nPrintLine:=nPrintLine-10

      GraStringAt( oPS, {1265,nPrintLine}, 'Итого' )
      GraStringAt( oPS, {1950,nPrintLine}, Str(SUMAKTEN+SUMREAEN+DONSUM,12,2) )
      GraStringAt( oPS, {2250,nPrintLine}, Str(NDSAKTEN+NDSREAEN+DONNDS,12,2) )
      GraStringAt( oPS, {2450,nPrintLine}, Str(DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN,12,2) )
      GraLine( oPS, {1360,nPrintLine-7}, {2620,nPrintLine-7} )
      
			nPrintLine:=nPrintLine-40
     
     
      
      GraStringAt( oPS, {1080,nPrintLine}, 'Всего по накладной' )
      GraStringAt( oPS, {1950,nPrintLine}, Str(SUMAKTEN+SUMREAEN+DONSUM,12,2) )
      GraStringAt( oPS, {2250,nPrintLine}, Str(NDSAKTEN+NDSREAEN+DONNDS,12,2) )
      GraStringAt( oPS, {2450,nPrintLine}, Str(DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN,12,2) )
      
      GraLine( oPS, {1360,nPrintLine-20}, {2620,nPrintLine-20} )
      GraLine( oPS, {1360,1160}, {1360,nPrintLine-20} )
      GraLine( oPS, {1470,1200}, {1470,nPrintLine-20} )
      GraLine( oPS, {1620,1200}, {1620,nPrintLine-20} )
      GraLine( oPS, {1770,1200}, {1770,nPrintLine-20} )
      GraLine( oPS, {1930,1200}, {1930,nPrintLine-20} )
      GraLine( oPS, {2130,1200}, {2130,nPrintLine-20} )
      GraLine( oPS, {2260,1160}, {2260,nPrintLine-20} )
      GraLine( oPS, {2420,1200}, {2420,nPrintLine-20} )
      GraLine( oPS, {2620,1200}, {2620,nPrintLine-20} )
			nPrintLine:=nPrintLine-60
      
      
      GraStringAt( oPS, {520 ,nPrintLine}, 'Товарная накладная имеет приложение на' )
      GraStringAt( oPS, {1940,nPrintLine}, 'листах' )
      GraLine( oPS, {1110,nPrintLine-2}, {1930,nPrintLine-2} )
      
      
			nPrintLine:=nPrintLine-50
      GraStringAt( oPS, {520, nPrintLine}, 'и содержит' )
      GraStringAt( oPS, {570, nPrintLine+3}, Center(Num2Str(nPP-1),190," ",.T.) )
      GraStringAt( oPS, {1940,nPrintLine}, 'порядковых номеров записей' )
      GraLine( oPS, {700,nPrintLine-2}, {1930,nPrintLine-2} )
      oFont:destroy()                        // Create font

      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 22
      oFont:width      := 10
//      oFont:bold:=.t.
      oFont:create()                        // Create font
      GraSetFont (oPS , oFont )                // Select font
      
      GraStringAt( oPS, {1500,nPrintLine+37}, 'прописью' )
      GraStringAt( oPS, {1270,nPrintLine-14}, 'прописью' )
//----------------------------------------------------


          
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 34
      oFont:width      := 13
//      oFont:bold:=.t.
      oFont:create()                        // Create font
      GraSetFont (oPS , oFont )                // Select font
      
      aAttr[ GRA_AL_WIDTH  ] := 3
      GraSetAttrLine(oPs,aAttr)
      
      

      GraStringAt( oPS, {1100,535}, 'Масса груза (нетто)' ) 
      GraLine( oPS, {1450,530}, {2620,530} )  
      GraStringAt( oPS, {1100,475}, 'Масса груза (брутто)' )
      GraLine( oPS, {1450,470}, {2620,470} )
      GraStringAt( oPS, {470,475}, 'Всего мест' )
      GraLine( oPS, {750,470}, {1050,470} )
      GraStringAt( oPS, {130,425}, 'Положение (паспорта, сертификаты и т.п.) на' )
      GraLine( oPS, {750,420}, {1050,420} )
      GraStringAt( oPS, {1100,425}, 'листах' )
      
			strSumma1=str_chislo( (DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN) ,60)
			strSumma1=strSumma1+space(60-len(strSumma1))
			strSumma2=mpsum2 +space(60-len(mpsum2))

      GraStringAt( oPS, {130,365}, 'Всего отпущено на сумму '+strSumma1 )
      GraStringAt( oPS, {130,335}, strSumma2 )
      GraStringAt( oPS, {130,270}, 'Отпуск груза разрешил  '+cNameBoss )
//      GraStringAt( oPS, {130,270}, 'Отпуск груза разрешил  Нач.ОСЭ (пр 79 от 27.02.07)' )
      GraLine( oPS, {455,265}, {710,265} )
      GraLine( oPS, {750,265}, {1050,265} )
      GraLine( oPS, {1090,265}, {1410,265} )
      GraStringAt( oPS, {130,123}, 'Отпуск груза произвел  Нач.ОСЭ' )
      
      GraLine( oPS, {455,120}, {710,120} )
      GraLine( oPS, {750,120}, {1050,120} )
      GraLine( oPS, {1090,120}, {1410,120} )
      
      GraStringAt( oPS, {1130,205}, NameBuh )			// NameBoss
//      GraStringAt( oPS, {1130,205}, "Карпович В.Г." )			// NameBoss
      GraStringAt( oPS, {1130,270}, NameBoss )			// NameBoss
//      GraStringAt( oPS, {1130,270}, "Бородай Ю.Ю." )			// NameBoss
      GraStringAt( oPS, {1130,123}, "Бородай Ю.Ю." )			
      
      GraLine( oPS, {750,195}, {1050,195} )
      GraLine( oPS, {1090,195}, {1410,195} )
     
     
     
      GraStringAt( oPS, {1450,365}, 'По доверенности №' )
      GraLine( oPS, {1750,360}, {1920,360} )
      GraStringAt( oPS, {1930,365}, 'от     "       "' )
      GraLine( oPS, {2120,360}, {2410,360} )
      GraStringAt( oPS, {2420,365}, '20       года' )
      GraStringAt( oPS, {1450,325}, 'выданной' )
      GraLine( oPS, {1600,320}, {2620,320} )
      GraLine( oPS, {1600,280}, {2620,280} )
      GraStringAt( oPS, {1450,245}, 'Груз принял' )
      GraLine( oPS, {1630,240}, {1920,240} )
      GraLine( oPS, {1960,240}, {2260,240} )
      GraLine( oPS, {2300,240}, {2620,240} )
      GraStringAt( oPS, {1450,120}, 'Груз получил' )
      GraStringAt( oPS, {1450,90}, 'грузополучатель' )
      GraLine( oPS, {1700,120}, {1990,120} )
      GraLine( oPS, {2030,120}, {2260,120} )
      GraLine( oPS, {2300,120}, {2620,120} )
        
      
      
      GraLine( oPS, {1445,420}, {1445,50} )
            
      aAttr[ GRA_AL_WIDTH  ] := 5
      GraSetAttrLine(oPs,aAttr)
      graBox( oPs, {2420,470}, {2620,590}  )
      GraSetAttrLine(oPs,aOldLine)   
      oFont:destroy()                        // Create font      


      
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 22
      oFont:width      := 10
//      oFont:bold:=.t.
      oFont:create()                        // Create font
      GraSetFont (oPS , oFont )                // Select font
      
      GraStringAt( oPS, {1900,515}, 'прописью' )
      GraStringAt( oPS, {1900,455}, 'прописью' )
      GraStringAt( oPS, {850,455}, 'прописью' )  
      GraStringAt( oPS, {850,405}, 'прописью' )   
      GraStringAt( oPS, {850,250}, 'подпись' ) 
      GraStringAt( oPS, {850,180}, 'подпись' ) 
      GraStringAt( oPS, {850,105}, 'подпись' ) 
      GraStringAt( oPS, {525,250}, 'должность' ) 
      GraStringAt( oPS, {525,105}, 'должность' ) 
      GraStringAt( oPS, {1150,250}, 'расшифровка подписи' )
      GraStringAt( oPS, {1150,180}, 'расшифровка подписи' )
      GraStringAt( oPS, {1150,105}, 'расшифровка подписи' )    
      
      
      GraStringAt( oPS, {1850,305}, 'кем, кому (организация, место работы, фамилия, и.о.)' )
      GraStringAt( oPS, {1700,225}, 'должность' ) 
      GraStringAt( oPS, {1800,105}, 'должность' ) 
      GraStringAt( oPS, {2060,225}, 'подпись' ) 
      GraStringAt( oPS, {2100,105}, 'подпись' )      
      GraStringAt( oPS, {2350,225}, 'расшифровка подписи' )
      GraStringAt( oPS, {2350,105}, 'расшифровка подписи' )      
      oFont:destroy()                        // Create font      
      
      
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 40
      oFont:width      := 18
      oFont:bold:=.t.
      oFont:create()                        // Create font
      GraSetFont (oPS , oFont )                // Select font

      GraStringAt( oPS, {180,200}, ' '+cNameBuh )
//      GraStringAt( oPS, {180,200}, 'Вед.экономист (пр 79 от 27.02.07)' )
      oFont:destroy()                        // Create font      

      
      oFont := XbpFont():new()              // Create XbpFont object
      oFont:familyName := "Times New Roman" // Describe font
      oFont:height     := 34
      oFont:width      := 13
//      oFont:bold:=.t.
      oFont:create()                        // Create font
      GraSetFont (oPS , oFont )                // Select font
      
      
      GraStringAt( oPS, {250,55}, 'М.П.' )
      GraStringAt( oPS, {400,55}, '" '+if(Day(new_date+1)>9,"","0")+ltrim(str(day(new_date+1),2))+;
      														'"             '+Mesqc(month(New_date),.t.))
      GraLine( oPS, {490,50}, {790,50} )
      GraStringAt( oPS, {800,55}, trim(str(year(New_date+1),4))+"  года"  )
      

      GraStringAt( oPS, {1650,55}, 'М.П.' )
      GraStringAt( oPS, {1900,55}, '" '+if(Day(new_date+1)>9,"","0")+ltrim(str(day(new_date+1),2))+;
      														'"             '+Mesqc(month(New_date),.t.))
      GraLine( oPS, {2000,50}, {2300,50} )
      GraStringAt( oPS, {2310,55}, trim(str(year(New_date+1),4))+"  года"  )






      oFont:destroy()                        // Create font      
      
      // End spooling
      oPS:device():endDoc()

      DestroyDevice( oPS )
RETURN Nil








   FUNCTION SFAvans()
      LOCAL oPS
      Local nOrientation,Sel:=Select(),Rec:=RecNo()
      Local i,SfDat,nPrintLine,Perem,oFont,OldFont
			Local aPrinter:={}
	
			 aPrinter:=MainPrinterConfig(1,XBPPRN_ORIENT_LANDSCAPE,"Печать счета-фактуры")
			 IF Empty(aPrinter[1])
			 		Return nil
			 ENDIF
			 IF AtNum("КПП",AllTrim(Main->Potrebitel),1)=1
   				POTRSTRING=delstring(Substr(Main->potrebitel,15),"ИНН")
			 ELSE
   				POTRSTRING=delstring(Main->potrebitel,"ИНН")
			 ENDIF
			 KPPSTRING=Alltrim(Substr(appendstring(main->potrebitel,"КПП"),4,11))
			 innstring=appendstring(Main->potrebitel,"ИНН")
			 innstring=alltrim(substr(innstring,4,AtNum(" ",InnString,1,6)-4))
			 
			 Select Main
			 Seek SfKniga->Number
			 Select SfKniga


      // Create presentation space for default printer
       oPS := PrinterPS(aPrinter)

      // Activate spooling
       oPS:device():startDoc()

       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 23
       oFont:width      := 12
       oFont:create()                        // Create font
       OldFont:=GraSetFont (oPS , oFont )                // Select font



//      GraLine( oPS, {450,1850}, {2150,1850} )
       GraStringAt( oPS, {2630,1890}, 'Приложение N1' )
       GraStringAt( oPS, {1825,1865}, 'к Правилам ведения журналов учета полученных и выставленных счетов-фактур, ' )
       GraStringAt( oPS, {1840,1840}, 'книг покупок и книг продаж при расчетах по налогу на добавленную стоимость,' )
       GraStringAt( oPS, {1630,1815}, 'утвержденным постановлением Правительства Российской Федерации от 2 декабря 2000 г. N 914')
       GraStringAt( oPS, {2010,1790}, '(в редакции постановлений Правительства Российской Федерации' )
       GraStringAt( oPS, {1850,1765}, 'от 15 марта 2001 г. N 189, от 27 июля 2002 г. N 575, от 16 февраля 2004 г. N 84)' )

       oFont:destroy()                        // Create font

       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 60
       oFont:width      := 25
       oFont:bold:=.T.
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
       SFDat:=alltrim(str(day((SfKniga->Data))))+"  "+mesqc(month(SfKniga->Data),1)+;
          ' '+alltrim(str(year(SfKniga->Data)))
       GraStringAt( oPS, {150,1670}, 'Счет-фактура № '+AllTrim(Str(SfKniga->lic_schet,8))+" от "+SFDat+"г." )

       oFont:destroy()                        // Create font

       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 31
       oFont:width      := 16
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font

//Грузоотправитель и его адрес [SchetNameOrg                     ],353410,Россия,Краснодарский край,г.Анапа,ул.Лермонтова 117
//Грузополучатель и его адрес [GruzPol                                                                                         ]
//К платежно-расчетному документу N [SCHET_ ] от [PLAT_DAT         ]
//Покупатель [POTRSTRING                                                                                                       ]
//Адрес [Main->DressBoss                             ] Телефон [PHONE             ]
//#Расчетный счет [LICEVOJ->R_SCHET  ] в [trim(LICEVOJ->BANK)             ]
//#Город [TOWNSTRING        ]       БИК [MFOl     ]    к/с [K_SCH                  ]
//Идентификационный номер покупателя (ИНН) [INNSTRING   ] (КПП) [KPPSTRING   ]
       GraStringAt( oPS, {150,1630}, 'Продавец: '+SchetNameOrg )
//       GraStringAt( oPS, {150,1630}, 'Продавец: ОАО "НЭСК"' )
       GraStringAt( oPS, {150,1590}, 'Адрес: '+SchetAdr )
//       GraStringAt( oPS, {150,1590}, 'Адрес: 350049 г.Краснодар ул.Северная 247' )
       GraStringAt( oPS, {150,1550}, 'ИНН/КПП продавца '+SchetInn+' / '+SchetKpp )
//       GraStringAt( oPS, {150,1550}, 'ИНН/КПП продавца  2308091759 / 230801001' )
       GraStringAt( oPS, {150,1510}, 'Грузоотправитель и его адрес: '+SchetNameOrg+" "+SchetAdr)
       GraStringAt( oPS, {150,1470}, 'Грузополучатель и его адрес: '+PotrString+" "+Main->DressBoss)
       GraStringAt( oPS, {150,1430}, 'К платежно-расчетному документу '+AllTrim(SfKniga->NumPlat)+"г.")
       
       GraStringAt( oPS, {150,1390}, 'Покупатель '+IF(Empty(Main->Platel),PotrString,Delstring(Main->Platel,"ИНН")) )
       IF .not.Empty(Main->Platel)
					KPPSTRING=Alltrim(Substr(appendstring(main->Platel,"КПП"),4,11))
					innstring=appendstring(Main->Platel,"ИНН")
					innstring=alltrim(substr(innstring,4,AtNum(" ",InnString,1,6)-4))
       ENDIF
       	
       GraStringAt( oPS, {150,1350}, 'Адрес:'+Main->DressBoss )
       GraStringAt( oPS, {150,1310}, 'ИНН/КПП покупателя '+InnString+" / "+KppString )
       oFont:destroy()                        // Create font


       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 28
       oFont:width      := 12
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
       GraStringAt( oPS, {170 ,1240}, 'Наименование товара (описание' )
       GraStringAt( oPS, {180 ,1210}, 'выполненных работ, оказанных' )
//       GraStringAt( oPS, {350 ,1180}, 'услуг), имущественного права' )
       GraStringAt( oPS, {180 ,1180}, 'услуг), имущественного права' )
       GraStringAt( oPS, {624 ,1240}, 'Еденица' )
       GraStringAt( oPS, {633 ,1210}, 'изме-' )
       GraStringAt( oPS, {630 ,1180}, 'рения' )
       GraStringAt( oPS, {765 ,1240}, 'Коли-' )
       GraStringAt( oPS, {762 ,1210}, 'чество' )
       GraStringAt( oPS, {905 ,1240}, 'Цена (тариф)' )
       GraStringAt( oPS, {915 ,1210}, 'за еденицу' )
       GraStringAt( oPS, {917 ,1180}, 'измерения' )
       
       GraStringAt( oPS, {1135,1260}, 'Стоимость' )
       GraStringAt( oPS, {1092,1235}, 'товаров (работ,' )
       GraStringAt( oPS, {1092,1210}, 'услуг),имуществ' )
       GraStringAt( oPS, {1092,1185}, 'енных прав,всего' )
       GraStringAt( oPS, {1132,1168}, 'без налога' )
       
       GraStringAt( oPS, {1330,1240}, 'В том' )
       GraStringAt( oPS, {1330,1210}, 'числе' )
       GraStringAt( oPS, {1330,1180}, 'акциз' )
       GraStringAt( oPS, {1452,1240}, 'Налоговая' )
       GraStringAt( oPS, {1480,1210}, 'ставка' )
       GraStringAt( oPS, {1606,1240}, 'Сумма налога' )

//       GraStringAt( oPS, {1845,1260}, 'Стоимость' )
//       GraStringAt( oPS, {1807,1230}, 'товаров (работ,' )
//       GraStringAt( oPS, {1815,1200}, 'услуг), всего с' )
//       GraStringAt( oPS, {1815,1170}, 'учетом налога' )
       GraStringAt( oPS, {1845,1260}, 'Стоимость' )
       GraStringAt( oPS, {1807,1235}, 'товаров (работ,' )
       GraStringAt( oPS, {1815,1210}, 'услуг),имуществ' )
       GraStringAt( oPS, {1815,1185}, 'енных прав,всего' )
       GraStringAt( oPS, {1815,1168}, 'c учетом налога' )

       GraStringAt( oPS, {2100,1240}, 'Страна' )
       GraStringAt( oPS, {2080,1210}, 'происхож-' )
       GraStringAt( oPS, {2110,1180}, 'дения' )
       GraStringAt( oPS, {2510,1260}, 'Номер' )
//       GraStringAt( oPS, {2490,1230}, 'грузовой' )
//       GraStringAt( oPS, {2470,1200}, 'таможенной' )
//       GraStringAt( oPS, {2475,1170}, 'декларации' )
       GraStringAt( oPS, {2470,1230}, 'таможенной' )
       GraStringAt( oPS, {2475,1200}, 'декларации' )
       GraStringAt( oPS, {390,1130}, '1' )
       GraStringAt( oPS, {675,1130}, '2' )
       GraStringAt( oPS, {815,1130}, '3' )
       GraStringAt( oPS, {950,1130}, '4' )
       GraStringAt( oPS, {1200,1130}, '5' )
       GraStringAt( oPS, {1350,1130}, '6' )
       GraStringAt( oPS, {1540,1130}, '7' )
       GraStringAt( oPS, {1700,1130}, '8' )
       GraStringAt( oPS, {1900,1130}, '9' )
       GraStringAt( oPS, {2150,1130}, '10' )
       GraStringAt( oPS, {2550,1130}, '11' )
       oFont:destroy()                        // Create font

// ------------------------------------------------------------------------------ Текст в счет-фактуру
       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 30
       oFont:width      := 14
       oFont:bold:=.T.
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font

//│за {PlMonth   }{YE}│      │            │         │              │      │      │            │              │ Россия │     │
			 nPrintLine:=1090
//       GraStringAt( oPS, {155,nPrintLine}, 'за '+PlMonth+" "+Str(Year(New_Date),4,)+"г." )
//       nPrintLine:=nPrintLine-30
//# {NdsAktEn:=Round(Sumakten*Schet_Nds/100,DECIMAL)} {WsegoSNds:=SumAktEn+NdsAktEn}
//│Активная энергия   │кВт.ч │{AKTEN     }│{CENAA  }│{SUMAKTEN    }│      │{NDS }│{NDSAKTEN  }│{WSEGOSNDS   }│        │     │
       GraStringAt( oPS, {155 ,nPrintLine}, "Предварительная оплата" )
//       GraStringAt( oPS, {628 ,nPrintLine}, 'кВт/ч' )
//       GraStringAt( oPS, {765 ,nPrintLine}, Str(AktEn,6) )
//       GraStringAt( oPS, {915 ,nPrintLine}, Str(round(SUMAKTEN/AKTEN,3),8,4) )
//       GraStringAt( oPS, {1135,nPrintLine}, Str(SumAktEn,12,2) )
       GraStringAt( oPS, {1470,nPrintLine}, "18/118" )
       GraStringAt( oPS, {1606,nPrintLine}, Str(SfKniga->SummaNds,12,2) )
       GraStringAt( oPS, {1815,nPrintLine}, Str(SfKniga->WsegoSNDS,12,2) )
//       GraStringAt( oPS, {2100,nPrintLine}, 'Россия' )
       nPrintLine:=nPrintLine-30
/*       For i=1 to 7
         Perem:="AktEn"+AllTrim(Str(I))
      	 IF Type(Perem)#"UE".and.Type(Perem)#"UI".and.Type(Perem)#"U"
      		 GraStringAt( oPS, {155 ,nPrintLine}, "в том числе" )
      		 GraStringAt( oPS, {628 ,nPrintLine}, 'кВт/ч' )
      		 GraStringAt( oPS, {765 ,nPrintLine}, Str( &("AktEn"+AllTrim(Str(I))) ,6) )
      		 GraStringAt( oPS, {915 ,nPrintLine}, Str(&("CenaA"+AllTrim(Str(I))),8,4) )
      		 GraStringAt( oPS, {1135,nPrintLine}, Str(&("SumAktEn"+AllTrim(Str(I))),12,2) )
      		 GraStringAt( oPS, {1480,nPrintLine}, Str(Schet_nds,5,2) )
      		 GraStringAt( oPS, {1606,nPrintLine}, Str(&("NdsAktEn"+AllTrim(Str(I))),12,2) )
      		 GraStringAt( oPS, {1815,nPrintLine}, Str(&("WsegosNds"+AllTrim(Str(I))),12,2) )
      		 nPrintLine:=nPrintLine-30
      	 ENDIF
       next
*/       
//│в том числе        │кВт.ч │{AKTEN1    }│{CENAA1 }│{SUMAKTEN1   }│      │{NDS }│{NDSAKTEN1 }│{WSEGOSNDS1  }│        │     │
//│в том числе        │кВт.ч │{AKTEN2    }│{CENAA2 }│{SUMAKTEN2   }│      │{NDS }│{NDSAKTEN2 }│{WSEGOSNDS2  }│        │     │
//│в том числе        │кВт.ч │{AKTEN3    }│{CENAA3 }│{SUMAKTEN3   }│      │{NDS }│{NDSAKTEN3 }│{WSEGOSNDS3  }│        │     │
//│в том числе        │кВт.ч │{AKTEN4    }│{CENAA4 }│{SUMAKTEN4   }│      │{NDS }│{NDSAKTEN4 }│{WSEGOSNDS4  }│        │     │
//# Всего с НДС для реактивной энергии {WSEGOSNDS:=SUMREAEN+NDSREAEN}
//│Реактивная энергия │Квар.ч│{REAEN     }│{CENAR  }│{SUMREAEN    }│      │{NDS }│{NDSREAEN  }│{WSEGOSNDS   }│        │     │
/*			 IF ReaEn>0
      	GraStringAt( oPS, {155 ,nPrintLine}, "Реактивная энергия" )
      	GraStringAt( oPS, {628 ,nPrintLine}, 'кВар/ч' )
      	GraStringAt( oPS, {765 ,nPrintLine}, Str(ReaEn,6) )
      	GraStringAt( oPS, {915 ,nPrintLine}, Str(round(SUMREAEN/REAEN,4),8,4) )
      	GraStringAt( oPS, {1135,nPrintLine}, Str(SumReaEn,12,2) )
      	GraStringAt( oPS, {1480,nPrintLine}, Str(Schet_Nds,5,2) )
      	GraStringAt( oPS, {1606,nPrintLine}, Str(NdsReaEn,12,2) )
      	GraStringAt( oPS, {1815,nPrintLine}, Str(SUMREAEN+NDSREAEN,12,2) )
   			nPrintLine:=nPrintLine-30
   		 ENDIF	
*/   		 
//# Доначисления {WSEGODON:=DONNDS+DONSUM}
//│Доначислено        │кВт.ч │{DONPOW    }│{CENAD  }│{DONSUM      }│      │{NDS }│{DONNDS    }│{WSEGODON    }│        │     │
/*			 IF DonPow>0
      	GraStringAt( oPS, {155 ,nPrintLine}, "Доначислено" )
      	GraStringAt( oPS, {628 ,nPrintLine}, 'кВт/ч' )
      	GraStringAt( oPS, {765 ,nPrintLine}, Str(DonPow,6) )
      	GraStringAt( oPS, {915 ,nPrintLine}, Str(round(DONSUM/DONPOW,4),8,4) )
      	GraStringAt( oPS, {1135,nPrintLine}, Str(DonSum,12,2) )
      	GraStringAt( oPS, {1480,nPrintLine}, Str(Schet_Nds,5,2) )
      	GraStringAt( oPS, {1606,nPrintLine}, Str(DonNds,12,2) )
      	GraStringAt( oPS, {1815,nPrintLine}, Str(DONNDS+DONSUM,12,2) )
   			nPrintLine:=nPrintLine-30
       ENDIF
*/       
//# Расчет планового платежа {PLANEN:=AKTEN+REAEN-WOZWPOW} {SUMPLANEN:=SUMAKTEN+SUMREAEN-WOZWSUM-AbonSum} {NDSPLANEN:=NDSAKTEN+NDSREAEN-WOZWNDS}
//# {WSEGOPLANNDS:=SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN-WOZWSUM-WOZWND
//#│Договорной платеж  │      │{PLANEN    }│         │{SUMPLANEN   }│      │{NDS }│{NDSPLANEN }│{WSEGOPLANNDS}│        │     │
//#│Оплачено всего:    │      │            │         │{SUMOPLACH   }│      │{NDS }│{NDSOPLACH }│{WSEGOPLA    }│        │     │
//├───────────────────┼──────┼────────────┼─────────┼──────────────┼──────┼──────┼────────────┼──────────────┼────────┼─────┤
//# Итог: {ITEN:=AKTEN+REAEN+DONPOW} {SUMITEN:=SUMAKTEN+SUMREAEN+DONSUM} {NDSITEN:=NDSAKTEN+NDSREAEN+DONNDS}
//#       {WSEGOITNDS:=DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN}
//│Всего к оплате     │      │            │         │{SUMITEN     }│      │      │{NDSITEN   }│{WSEGOITNDS  }│        │     │
 			 nPrintLine:=nPrintLine-20

//       GraStringAt( oPS, {1606,nPrintLine}, Str(SfKniga->SummaNds,12,2) )
//       GraStringAt( oPS, {1815,nPrintLine}, Str(SfKniga->WsegoSNDS,12,2) )

       GraStringAt( oPS, {1606,nPrintLine}, Str(SfKniga->SummaNds,12,2) )
       GraStringAt( oPS, {1815,nPrintLine}, Str(SfKniga->WsegoSNDS,12,2) )
       oFont:destroy()                        // Create font
//   		nPrintLine:=nPrintLine-50

       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 28
       oFont:width      := 16
       oFont:bold:=.T.
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
       GraStringAt( oPS, {155,nPrintLine}, 'Всего к оплате' )
       GraStringAt( oPS, {2620,1290}, 'Валюта: руб.' )
       oFont:destroy()                        // Create font

//------------------------------------------------------
       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 31
       oFont:width      := 16
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
       GraStringAt( oPS, {150, nPrintLine- 80}, 'Руководитель организации        _________________  '+AllTrim(NAMEBOSS)+'                              Главный бухгалтер  ____________________  '+AllTrim(NAMEBUH) )
       GraStringAt( oPS, {150, nPrintLine-160}, 'Индивидуальный предприниматель  _________________' )
       GraStringAt( oPS, {1620,nPrintLine-160}, '(реквизиты свидетельства о государственной')
       GraStringAt( oPS, {1620,nPrintLine-180}, 'регистрации индивидуального предпринимателя)')
       oFont:destroy()                        // Create font


       oFont := XbpFont():new()              // Create XbpFont object
       oFont:familyName := "Times New Roman" // Describe font
       oFont:height     := 27
       oFont:width      := 13
       oFont:create()                        // Create font
       GraSetFont (oPS , oFont )                // Select font
       GraStringAt( oPS, {150,540}, 'ПРИМЕЧАНИЕ. Первый экземпляр - покупателю, второй экземпляр - продавцу')

       oFont:destroy()                        // Create font
       GraSetFont (oPS , OldFont )                // Select font

// ----------------------------------------------------------------- Отрисовка таблицы
      // Spool graphic output
       GraLine( oPS, {150,1280}, {2820,1280} )
       GraLine( oPS, {150,1160}, {2820,1160} )
       GraLine( oPS, {150,1120}, {2820,1120} )
       GraLine( oPS, {150,nPrintLine+35}, {2820,nPrintLine+35} )
//      GraLine( oPS, {150,1080}, {2020,1080} )
       GraLine( oPS, {150,nPrintLine-10}, {2020,nPrintLine-10} )
//      GraLine( oPS, {150,1080}, {150,1280} )
       GraLine( oPS, {150 ,nPrintLine-10}, {150,1280} )
       GraLine( oPS, {620 ,nPrintLine+35}, {620,1280} )
       GraLine( oPS, {740 ,nPrintLine+35}, {740,1280} )
       GraLine( oPS, {900 ,nPrintLine+35}, {900,1280} )
       GraLine( oPS, {1090,nPrintLine+35}, {1090,1280} )
       GraLine( oPS, {1300,nPrintLine+35}, {1300,1280} )
       GraLine( oPS, {1450,nPrintLine+35}, {1450,1280} )
       GraLine( oPS, {1600,nPrintLine-10}, {1600,1280} )
       GraLine( oPS, {1800,nPrintLine-10}, {1800,1280} )
       GraLine( oPS, {2020,nPrintLine-10}, {2020,1280} )
       GraLine( oPS, {2290,nPrintLine+35}, {2290,1280} )
       GraLine( oPS, {2820,nPrintLine+35}, {2820,1280} )
// ----------------------------------------------------------------- Отрисовка таблицы

      // End spooling
      oPS:device():endDoc()

      DestroyDevice( oPS )
      ClearBuffer()
   RETURN Nil



