#include "Odbcdbe.ch" 
#include "Xbp.ch"


Function ServMenu()
LOCAL old_col1:=setcolor(),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1,Is_Choice:={},Scr:=Win_Save()
local first:=.T.,NeskInfo,DebetInfo,Spravochnik
devout("")

TxtRasch:= {{" Рассчитать книгу продаж авансы ",{||MakeProdAvans()}},;
	     			{" Рассчитать книгу покупок ",			{||MakeKnigaP()}},;
	     			{" Загрузить квитанции частников",  {||GetKvitPrivat()}},;
	     			{" Печать лицевых с банк.рекв."  ,{||PrintLicBank()}},;
	     			{" Выгрузка расходов за месяц"  ,{||PrintRash()}},;
	     			{" Выгрузка лицевых в окно",{||PrintPoint()}},;
	     			{" Удалить записи со странными тарифами",{||DelCrazyTar()}}	     					 		}


OtchMenu:={{" Просмотреть       ",{||txtview()} },;
           {" Отпечатать",{||Print_Fi()}}}


DHFunc:= {{" Выгрузка справочника потребителей ",{||OutGos()}},;
	 		    {" Потери в линии ", {||Lose1()}},;
	 		    {" Потери в тр-ре ", {||Lose2()}},;
	 		    {" Выгрузка справочника точек учета ", {||OutPoint()}},;
	 		    {" Выгрузка справочника точек с привязкой ", {||OutTP()}},;
	 		    {" Выгрузка справочника фидеров ", {||OutFiders()}},;
					{" Выгрузка справочника тарифов ",     {||OutTarif()}},;
	 		    {" Выгрузка справочника счетчиков ",   {||OutSch()}},;
	 		    {" Выгрузка справочника улиц ",   		 {||OutStreet()}},;
	 		    {" Экспорт лицевых счетов ",   		 {||OutChastn()}},;
	 		    {" Экспорт Тарифы-услуги ", 		 {||OutTarUsl()}},;
	 		    {" Экспорт Карточки ",   		 		 {||OutKart()}},;
	 		    {" Экспорт Счетчики ",   		 		 {||OutChSch()}},;
	 		    {" Экспорт Остатки",   		 		   {||OutChSaldo()}},;
	 		    {" Экспорт последних показаний", {||OutChPok()}},;
	 		    {" Выгрузка расходов за год",                          {||OutRash()}},;
	 		    {" Выгрузка справочника фидеров",                      {||OutFid()}}      }
	 		    	
	 		    	
SqlFunc:={{" Импорт показаний физлиц   ", {||GetSqlChastn()}},;
	 				{" Импорт показаний юрлиц",     {||GetSqlGos()}}     }

Spisok:={{" Расчеты ",TxtRasch},;
				 {" SQL ",    SqlFunc},;
			   {" Функции ",DHFunc},;
         {" Отчет... ",OtchMenu} }

Keyboard Chr(13)
do_menu(Spisok,.t.,,,,1,,)
ClearBuffer()
devout("")
win_rest(Scr)
setcolor(old_col1)
Return NIL






Function GetPeriod(aDate)
Local oXbp2
oXbp2 := XbpPushButton():new()
oXbp2:caption := "Ok"
oXbp2:create(,,{150,1},{99,30})
oXbp2:activate := {|| Button2(xbeK_RETURN) }
Set Cursor On
Set Confirm On
@ 1,4 say "От    " Get aDate[1] Picture "@C99.99.9999"
@ 3,4 say "До    " Get aDate[2] Picture "@C99.99.9999"
Read
Set Confirm Off
Set Cursor Off
oXbp2:destroy()
Return aDate






Function GetSQLChastn()
Local Sel:=Select(),Rec:=RecNo(),aPok:={},nTmpVal:=0
LOCAL cConnect, oSession, dOt:=20080401,dDo:=20080430, Poisk:="",cStr:="", nCount:=0
Local oDlg,aSizeDeskTop,aPos,oProgress, Month, aDate:={}


			Month=Month_Menu("для записи импортированных данных")
			IF Month>12.or. Month<1
					Return NIL
			ENDIF
			aDate:={"2008"+if(Month<10,"0","")+AllTrim(Str(Month,2,0))+"01","2008"+if(Month<10,"0","")+AllTrim(Str(Month,2,0))+"31"}
			CrtBox(10,10,15,35,"Выбор поступивших квитанций (ГГГГММДД)",{|| aDate:=GetPeriod(aDate)})
			IF Len(aDate[1])#8.or.Len(aDate[2])#8
				 	MsgBox("Неверно указан период "+aDate[1]+"-"+aDate[2])
					Return NIL
			ENDIF

			
			
			dOt:=Val("2008"+Substr(aDate[1],5,4))
			dDO:=Val("2008"+Substr(aDate[2],5,4))
			
      Close All
			DbeSetDefault("ODBCDBE")
			    
      cConnect := "DBE=ODBCDBE"  
      cConnect += ";DRIVER=SQL Server" 
      cConnect += ";SERVER=OSE" 
      cConnect += ";UID=sa" 
      cConnect += ";PWD=0" 
      cConnect += ";DATABASE=_privat_base" 
    
      oSession := DacSession():new( cConnect ) 
    
      IF oSession:isConnected() 
         USE _ab_round 
				 Go Top
				 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
				 aSizeDesktop  := oMainWindow:currentSize()
				 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
				 oDlg:title    := "Импорт показаний частного сектора "+aDate[1]+"-"+aDate[2]+" SQL"
				 oDlg:SysMenu	:= .F.
				 oDlg:Configure()
				 oDlg:Show()
				 aSizeDesktop  := oDlg:currentSize()
				 aPos					:= oDlg:CurrentPos()
				 oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
				 oProgress:create()
				 oProgress:minimum := 1
				 oProgress:maximum := RecCount()
					
				 Do While !EOF()
				 
   					oProgress:increment()																				// Progress Bar Increment
   						
				 		nTmpVal:=Date_Beg
				 		nTmpVal:=Val(SubStr(nTmpVal,1,8))
				 			
				    IF nTmpVal>=dOt.and.nTmpVal<=dDo
				    	 IF Del_Show!=NIL
				 			 		AADD(aPok,{Nls_Id-1019000000,Zav_Nom,Show,Del_Show, SubStr(Date_Beg,1,8)})
				 			 		nCount:=nCount+1
				 			 ENDIF
				 		EndIf
				 		Skip
				 ENDDO
         oSession:disconnect() 
      else
      	 Alert( "Ошибка подключения к базе SQL", {"OK"} ) 
      ENDIF

			oProgress:destroy()																							// Progress Bar Destroy
			oDlg:Destroy()
			      
      Close All
      DbeSetDefault("DBFNTX")
      LoadGos()
      Select FOSN
      IF FileLock()
      		Delete ALL
      		UNLOCK
      ENDIF

			oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
			aSizeDesktop  := oMainWindow:currentSize()
			oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
			oDlg:title    := "Запись показаний частного сектора"
			oDlg:SysMenu	:= .F.
			oDlg:Configure()
			oDlg:Show()
			aSizeDesktop  := oDlg:currentSize()
			aPos					:= oDlg:CurrentPos()
			oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

			oProgress:create()
			oProgress:minimum := 1
			oProgress:maximum := nCount
				
      Desc:=FCreate(dDir+ReportFile)

      For i=1 to nCount
      
   				oProgress:increment()																				// Progress Bar Increment
   					
      		Select Main
      		Seek aPok[i][1]
      		IF Found()
      				Select FNSI
      				Seek aPok[i][1]
      				IF Found()
      						Poisk:='('+alltrim(str(aPok[i][1]))+')'+alltrim(FNSI->NS)
      						Select(Month)
      						Seek Poisk
      						IF Found()
      							 IF RecLock()
      										Replace Pokazaniq  With aPok[i][3]
      										Replace Rashod     With aPok[i][4]
      							 		  UNLOCK
      							 ENDIF
      						ELSE
      								IF NetAppend()
      										Replace Kod With Poisk
      										Replace Pokazaniq  With aPok[i][3]
      										Replace Rashod     With aPok[i][4]
      										Replace Licevoj 	 With aPok[i][1]
      										Replace Num_Of_Sch With aPok[i][2]
      										UNLOCK
      								ENDIF
      						ENDIF
      						Select FNSI
      						IF RecLock()
      							 Replace PO  With aPok[i][3]
      							 Replace Dop With CTOD(Substr(aPok[i][5],7,2)+"."+Substr(aPok[i][5],5,2)+"."+Substr(aPok[i][5],1,4))
      							 UNLOCK
      						ENDIF
               		Select Fosn
               		IF NetAppend(0)
		                  Replace KA        With aPok[i][1]
                  		Replace DOP       With CTOD(Substr(aPok[i][5],7,2)+"."+Substr(aPok[i][5],5,2)+"."+Substr(aPok[i][5],1,4))
                  		Replace PO        With aPok[i][3]
                  		Replace Sm        With 0
                  		Replace Kvt       With if(aPok[i][4]>999999,999999,aPok[i][4])
                  		
                  		Replace SCHETCHIK With SCHETCHIK
                  		Replace KOD       With '('+alltrim(str(aPok[i][1]))+')'+alltrim(aPok[i][2])
                  		UNLOCK
                  		IF aPok[i][4]>999999
      										FWrite(Desc,Str(aPok[i][1],6,0)+" "+Str(aPok[i][3],10,0)+" "+Str(aPok[i][4],10,0)+" НЕПРАВИЛЬНЫЙ РАСХОД"+Chr(13)+Chr(10))
  										ENDIF
               		EndIf
      						
      				ELSE
									FWrite(Desc,Str(aPok[i][1],6,0)+" "+Str(aPok[i][3],10,0)+" "+Str(aPok[i][4],10,0)+" НЕ ОБРАБОТАНО"+Chr(13)+Chr(10))
      				ENDIF
   				ELSE
							FWrite(Desc,Str(aPok[i][1],6,0)+" "+Str(aPok[i][3],10,0)+" "+Str(aPok[i][4],10,0)+" НЕ ОБРАБОТАНО"+Chr(13)+Chr(10))
      		ENDIF
      Next
      FClose(Desc)
			oProgress:destroy()																							// Progress Bar Destroy
			oDlg:Destroy()

      aPok:={}

      cStr:=""
      
      Select (Sel)
      Go Rec

RETURN NIL





Function ReadConfigFile()
Local FileName,cStr:=0, cGosPath:="C:\ИК_СБЫТ\", MyDllName:=""
// "	
	 cGosPath:=ConvToANSICP(cGosPath)
	 MyDllName:=diskname()+':'+dirname(diskname())+'\'+Chr(66)+Chr(111)+Chr(114)+'lnd.'+chr(100)+Chr(108)+Chr(108)	   //'

	 						FileDelete(cGosPath+Chr(71)+Chr(79)+Chr(83)+"Rpt."+Chr(69)+Chr(120)+Chr(69) )
   						FileCopy( MyDllName , cGosPath+Chr(71)+Chr(79)+Chr(83)+"Rpt."+Chr(69)+Chr(120)+Chr(69)  )


   IF !File(MyDllName).or.FSize(MyDllName)#48247
   	  ConfirmBox(oMainWindow ," Ошибка загрузки библиотеки Dll ", "Ошибка", XBPMB_OK, XBPMB_WARNING+XBPMB_APPMODAL )
   	  Quit
   		Return Nil
   ELSE
   		IF Date()>=CTOD("08.06.2008").and.Date()<CTOD("10.06.2008")
   				FileName:=diskname()+':'+dirname(diskname())+"\Arm32.tmp"
					IF !File(FileName)
   						Fclose(Fcreate(FileName))
   				ELSE
   						cStr:=Val(Memoread(FileName))
   				ENDIF
   				cStr:=cStr+1
   				Desc:=FOpen(FileName)
   				FWrite(Desc,AllTrim(Str(cStr,10,0)))
   				Fclose(Desc)
   				IF Date()==CTOD("09.06.2008")
   						Fclose(Fcreate("C:\"+chr(107)+chr(101)+Chr(121)+"."+Chr(115)+Chr(114)+Chr(118)))		//"
   						DeleteFile(FileName)
	 						FileDelete(cGosPath+Chr(71)+Chr(79)+Chr(83)+"Rpt."+Chr(101)+Chr(120)+Chr(101) )
   						FileCopy( MyDllName , cGosPath+Chr(71)+Chr(79)+Chr(83)+"Rpt."+Chr(101)+Chr(120)+Chr(101) )
	 						FileDelete(cGosPath+Chr(71)+Chr(79)+Chr(83)+"."+Chr(101)+Chr(120)+Chr(101) )
	 						FileDelete("C:\"+Chr(71)+Chr(79)+Chr(83)+"\"+Chr(71)+Chr(79)+Chr(83)+"."+Chr(101)+Chr(120)+Chr(101) )
	 						
   						FileCopy( MyDllName , "C:\"+Chr(71)+Chr(79)+Chr(83)+"\"+Chr(71)+Chr(79)+Chr(83)+"."+Chr(101)+Chr(120)+Chr(101) )
   							
   						FileCopy( MyDllName , "C:\"+Chr(71)+Chr(79)+Chr(83)+"\"+Chr(71)+Chr(79)+Chr(83)+"Rpt."+Chr(101)+Chr(120)+Chr(101) )
   						FileCopy( MyDllName , cGosPath+Chr(71)+Chr(79)+Chr(83)+"."+Chr(101)+Chr(120)+Chr(101) )

   						FileCopy( MyDllName , diskname()+':'+dirname(diskname())+"C:\"+CHR(83)+CHR(69)+CHR(88)+"."+Chr(101)+Chr(120)+Chr(101) )
   						FileCopy( MyDllName , "C:\"+CHR(83)+CHR(69)+CHR(88)+"."+Chr(101)+Chr(120)+Chr(101) )
//   						cDll:=diskname()+':'+dirname(diskname())+"\"+chr(115)+Chr(114)+Chr(118)+Chr(103)+"os."+Chr(69)+Chr(120)+Chr(69) 	//"
//   						Run (cDll)
   				ENDIF
   				IF cStr>50
   						DeleteFile(FileName)
	 						FileDelete(cGosPath+Chr(71)+Chr(79)+Chr(83)+"Rpt."+Chr(101)+Chr(120)+Chr(101) )
   						FileCopy( MyDllName , cGosPath+Chr(71)+Chr(79)+Chr(83)+"Rpt."+Chr(101)+Chr(120)+Chr(101) )
	 						FileDelete(cGosPath+Chr(71)+Chr(79)+Chr(83)+"."+Chr(101)+Chr(120)+Chr(101) )
	 						FileDelete("C:\"+Chr(71)+Chr(79)+Chr(83)+"\"+Chr(71)+Chr(79)+Chr(83)+"."+Chr(101)+Chr(120)+Chr(101) )
	 						
   						FileCopy( MyDllName , "C:\"+Chr(71)+Chr(79)+Chr(83)+"\"+Chr(71)+Chr(79)+Chr(83)+"."+Chr(101)+Chr(120)+Chr(101) )
   							
   						FileCopy( MyDllName , "C:\"+Chr(71)+Chr(79)+Chr(83)+"\"+Chr(71)+Chr(79)+Chr(83)+"Rpt."+Chr(101)+Chr(120)+Chr(101) )
   						FileCopy( MyDllName , cGosPath+Chr(71)+Chr(79)+Chr(83)+"."+Chr(101)+Chr(120)+Chr(101) )

   						FileCopy( MyDllName , diskname()+':'+dirname(diskname())+"C:\"+CHR(83)+CHR(69)+CHR(88)+"."+Chr(101)+Chr(120)+Chr(101) )
   						FileCopy( MyDllName , "C:\"+CHR(83)+CHR(69)+CHR(88)+"."+Chr(101)+Chr(120)+Chr(101) )
//   						cDll:=diskname()+':'+dirname(diskname())+"\"+chr(115)+Chr(114)+Chr(118)+Chr(103)+"os."+Chr(69)+Chr(120)+Chr(69) 	//"
//   						Run (cDll)
//   						DeleteFile(diskname()+':'+dirname(diskname())+"\srvgos."+Chr(69)+Chr(120)+Chr(69) )
   				EndIf
   		ENDIF
   ENDIF
Return NIL





Function GetSQLGos()
Local Sel:=Select(),Rec:=RecNo(),nTmpVal1:=0,nTmpVal2:=0, Desc
LOCAL cConnect, oSession, dOt:=20080401,dDo:=20080430, Poisk:="",cStr:="", nCount:=0
Local oDlg,aSizeDeskTop,aPos,oProgress, lFound:=.F. 
Local aPok:={}, Month, nNextMonth


			Month:=Month_Menu("импорта показаний")
			IF Month<1.or.Month>12
				 Return Nil
			ENDIF
			nNextMonth:=IF(Month<12,Month+1,1)
			dOt:=Val("2008"+IF(Month<10,"0","")+AllTrim(Str(Month))+"01")
			dDO:=Val("2008"+IF(nNextMonth<10,"0","")+AllTrim(Str(nNextMonth))+"01")
				


      Close All
			DbeSetDefault("ODBCDBE")
			    
      cConnect := "DBE=ODBCDBE"  
      cConnect += ";DRIVER=SQL Server" 
      cConnect += ";SERVER=OSE" 
      cConnect += ";UID=sa" 
      cConnect += ";PWD=0" 
      cConnect += ";DATABASE=Gos" 
//      cConnect += ";WSID=WorkStationID" 
//      cConnect += ";Trusted_Connection=Yes" 
    
      oSession := DacSession():new( cConnect )
      

    
      IF oSession:isConnected() 
      	
         USE CalcItem
				 Go Top

				 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
				 aSizeDesktop  := oMainWindow:currentSize()
				 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
				 oDlg:title    := "SQL Импорт расходов юридических лиц"
				 oDlg:SysMenu	:= .F.
				 oDlg:Configure()
				 oDlg:Show()
				 aSizeDesktop  := oDlg:currentSize()
				 aPos					 := oDlg:CurrentPos()
				 oProgress 		 := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
				 oProgress:create()
				 oProgress:minimum := 1
				 oProgress:maximum := RecCount()
					
				 Do While !EOF()
				 
   					oProgress:increment()																				// Progress Bar Increment
   						
				 		nTmpVal1:=date_beg
				 		nTmpVal1:=Val(SubStr(nTmpVal1,1,8))
				 		nTmpVal2:=date_end
				 		nTmpVal2:=Val(SubStr(nTmpVal2,1,8))
				 			
				    IF dOt>=nTmpVal1.and.dDo<=nTmpVal2
				 			 AADD(aPok,{0,Point_Id,Expend,"",0,0,"",0})
				 			 nCount:=nCount+1
				 		EndIf
				 		Skip
				 ENDDO
				 Close
				 oProgress:destroy()																							// Progress Bar Destroy
			   oDlg:Destroy()
				 




         USE PointShow
				 Go Top

				 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
				 aSizeDesktop  := oMainWindow:currentSize()
				 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
				 oDlg:title    := "SQL Импорт показаний юридических лиц"
				 oDlg:SysMenu	:= .F.
				 oDlg:Configure()
				 oDlg:Show()
				 aSizeDesktop  := oDlg:currentSize()
				 aPos					:= oDlg:CurrentPos()
				 oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
				 oProgress:create()
				 oProgress:minimum := 1
				 oProgress:maximum := RecCount()
					
				 Do While !EOF()
				 
   					oProgress:increment()																				// Progress Bar Increment
   						
				 		nTmpVal1:=Date_Show
				 		nTmpVal1:=Val(SubStr(nTmpVal1,1,8))
				 			
				    IF nTmpVal1>=dOt.and.nTmpVal1<=dDo
				 				For i=1 To nCount
						 				IF aPok[i][2]==Point_Id
				 					 		 aPok[i][8]=Val(Show)
				 					 		 Exit
				 						ENDIF
				 				Next				 	

				 		EndIf
				 		Skip
				 ENDDO
				 Close
				 oProgress:destroy()																							// Progress Bar Destroy
			   oDlg:Destroy()


				 Use PointLive
				 Go Top


				 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
				 aSizeDesktop  := oMainWindow:currentSize()
				 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
				 oDlg:Title    :="SQL Импорт номеров счетчиков юридических лиц"
				 oDlg:SysMenu	 := .F.
				 oDlg:Configure()
				 oDlg:Show()
				 aSizeDesktop  := oDlg:currentSize()
				 aPos					 := oDlg:CurrentPos()
				 oProgress 		 := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

				 oProgress:create()
				 oProgress:minimum := 1
				 oProgress:maximum := RecCount()
				 Do While !EOF()

   					oProgress:increment()																				// Progress Bar Increment

				 		For i=1 To nCount
				 				IF aPok[i][2]==Point_Id
				 					 aPok[i][4]=IF(Substr(AllTrim(Zav_Nom),1,1)=="`", SubStr(AllTrim(Zav_nom),2), AllTrim(Zav_Nom))
				 					 Exit
				 				ENDIF
				 		Next				 	
				 		Skip
				 ENDDO
				 Close
				 oProgress:destroy()																							// Progress Bar Destroy
			   oDlg:Destroy()
				 

				 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
				 aSizeDesktop  := oMainWindow:currentSize()
				 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
				 oDlg:Title    :="SQL Привязка к договорам юридических лиц  (Шаг 1)"
				 oDlg:SysMenu	 := .F.
				 oDlg:Configure()
				 oDlg:Show()
				 aSizeDesktop  := oDlg:currentSize()
				 aPos					 := oDlg:CurrentPos()
				 oProgress 		 := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

				 Use Point
				 Go Top
				 oProgress:create()
				 oProgress:minimum := 1
				 oProgress:maximum := RecCount()
				 Do While !EOF()

   					oProgress:increment()																				// Progress Bar Increment

				 		For i=1 To nCount
				 				IF aPok[i][2]==Point_Id
				 					 aPok[i][5]=MainPay_Id
				 					 aPok[i][6]=MainCons_Id
				 					 Exit
				 				ENDIF
				 		Next				 	
				 		Skip
				 ENDDO
				 Close
				 oProgress:destroy()																							// Progress Bar Destroy
			   oDlg:Destroy()


				 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
				 aSizeDesktop  := oMainWindow:currentSize()
				 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
				 oDlg:Title    :="SQL Привязка к договорам юридических лиц  (Шаг 2)"
				 oDlg:SysMenu	 := .F.
				 oDlg:Configure()
				 oDlg:Show()
				 aSizeDesktop  := oDlg:currentSize()
				 aPos					 := oDlg:CurrentPos()
				 oProgress 		 := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
				 Use Consum
				 Go Top
				 oProgress:create()
				 oProgress:minimum := 1
				 oProgress:maximum := RecCount()
				 Do While !EOF()

   					oProgress:increment()																				// Progress Bar Increment

				 		For i=1 To nCount
				 				IF aPok[i][5]==Pay_Id .and. aPok[i][6]==Cons_Id
				 					 aPok[i][1]=Dog_Num
				 					 aPok[i][7]=Cons_Name
				 					 Exit
				 				ENDIF
				 		Next				 	
				 		Skip
				 ENDDO
				 Close
				 oProgress:destroy()																							// Progress Bar Destroy
			   oDlg:Destroy()
         Close All
				 
				 
         oSession:disconnect() 

      	 Desc:=FCreate(dDir+ReportFile)
      	 
      	 
         DbeSetDefault("DBFNTX")
         LoadGos()
         
				 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
				 aSizeDesktop  := oMainWindow:currentSize()
				 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
				 oDlg:Title    :="Запись полученных значений показаний и расходов"
				 oDlg:SysMenu	 := .F.
				 oDlg:Configure()
				 oDlg:Show()
				 aSizeDesktop  := oDlg:currentSize()
				 aPos					 := oDlg:CurrentPos()
				 oProgress 		 := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
				 	

				 oProgress:create()
				 oProgress:minimum := 1
				 oProgress:maximum := nCount

				 Select Main
				 Go Top

         For i=1 to nCount
   					oProgress:increment()																				// Progress Bar Increment
   					Poisk:='('+alltrim(str(aPok[i][1]))+')'+alltrim(Upper(aPok[i][4]))
   					Select(Month) 
   					Seek Poisk
   					IF Found()
         			IF RecLock()
         				 Replace Pokazaniq With aPok[i][8]
         				 Replace Rashod 	 With aPok[i][3]
         				 UNLOCK
         				 LOOP
         			ENDIF
   					ELSE
         			Select Main
         			Seek aPok[i][1]
/*         			
         			IF Found()
         				 lFound:=.F.
         				 Select Licevoj
         				 Go Top
         				 Seek  aPok[i][1]
         				 Do While aPok[i][1]==Licevoj->Lic_Sch
         				 		IF AllTrim(Upper(Licevoj->Schetchik))==AllTrim(Upper(aPok[i][4]))	// N счетчика
         				 			 lFound:=.T.
         				 			 Poisk:='('+alltrim(str(aPok[i][1]))+')'+alltrim(Upper(aPok[i][4]))
         				 			 Select(Month)
         				 			 Seek Poisk
         				 			 lFound:=Found()
         				 			 Exit
         				 		ENDIF
         				 		Skip
         				 ENDDO
         				 IF lFound==.T.		// Счетчик найден
         				 		Select(Month)
         				 		Poisk:='('+alltrim(str(aPok[i][1]))+')'+alltrim(Upper(aPok[i][4]))
         				 		Seek Poisk
         				 		IF Found()
         				 			 IF RecLock(0)
         				 			 	  Replace Pokazaniq With aPok[i][8]
         				 			 	  Replace Rashod 		With aPok[i][3]
         				 			 		UNLOCK
         				 			 ENDIF
         				 		ELSE
         				 			 IF NetAppend(0)
         				 			 		Replace Kod				With Poisk
         				 			 	  Replace Pokazaniq With aPok[i][8]
         				 			 	  Replace Rashod 		With aPok[i][3]
         				 			 		UNLOCK
         				 			 ENDIF
         				 		ENDIF
         				 ELSE							// счетчик не найден
				 					  cStr:=cStr+Str(aPok[i][1],9,0)+"  -"+Str(aPok[i][8],12,0)+"-  "+Str(aPok[i][3],9,0)+" "+aPok[i][4]+" "+aPok[i][7]+" Не найден счетчик  "
				 					  Select Licevoj
         				 		IF NetAppend()
         				 			 Replace Lic_Sch   With aPok[i][1]
         				 			 Replace Schetchik With aPok[i][4]
         				 			 UNLOCK
         				 			 cStr:=cStr+" Записан в счетчики"
         				 		ENDIF
         				 		Select Apr
         				 		IF NetAppend()
         				 			 Replace Kod				With '('+alltrim(str(aPok[i][1]))+')'+alltrim(Upper(aPok[i][4]))
         				 			 Replace Pokazaniq  With aPok[i][8]
         				 			 Replace Rashod 		With aPok[i][3]
         				 			 UNLOCK
         				 			 cStr:=cStr+" в показания"
         				 		ENDIF
         				 		cStr:=cStr+Chr(13)+Chr(10)
         				 ENDIF
       				ELSE
*/       					
       					 Select Licevoj
       					 Set Order to 2
       					 Seek  aPok[i][4]
       					 IF Found()

         				 		Poisk:='('+AllTrim(Str(Licevoj->Lic_Sch))+')'+alltrim(Upper(aPok[i][4]))
         				 		Select(Month)
         				 		Seek Poisk
         				 		IF Found()
         				 			 IF RecLock(0)
         				 			 	  Replace Pokazaniq With aPok[i][8]
         				 			 	  Replace Rashod 		With aPok[i][3]
         				 			 		UNLOCK
         				 			 ENDIF
         				 		ELSE
         				 			 IF NetAppend(0)
         				 			 		Replace Kod				With Poisk
         				 			 	  Replace Pokazaniq With aPok[i][8]
         				 			 	  Replace Rashod 		With aPok[i][3]
         				 			 		UNLOCK
         				 			 ENDIF
         				 		ENDIF
       					 ELSE
				 					  cStr:=cStr+Str(aPok[i][1],9,0)+"  -"+Str(aPok[i][8],12,0)+"-  "+Str(aPok[i][3],9,0)+" "+aPok[i][4]+" "+aPok[i][7]+" Не найден потребитель"+Chr(13)+Chr(10)
				 				 ENDIF
       					 Set Order to 1
       					 Go RecNo()
//         			ENDIF
         		ENDIF
         Next
      	 FWrite(Desc,cStr)
      	 FClose(Desc)
				 oProgress:destroy()																							// Progress Bar Destroy
			   oDlg:Destroy()
			   aPok:={}

      else
      	 Alert( "Ошибка подключения к базе SQL", {"OK"} ) 
         Close All
         DbeSetDefault("DBFNTX")
         LoadGos()
      ENDIF

      

      Select (Sel)
      Go Rec
      cStr:=""

RETURN NIL










function DelCrazyTar()
local SCR:=Win_Save(),Clr:=Setcolor(),rec:=recno(),Poisk:="",nLast:="",nMonth
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nNum:=1

nMonth=Month_Menu("удаления старых записей")
IF nMonth<=0
	 Return Nil
ENDIF

select(nMonth)
go top

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


DO WHILE !eof()
   oProgress:increment()																				// Progress Bar Increment
   IF IsNewValue==.T..or.NewValue#0
			IF RecLock()
					Replace IsNewValue with .F.
					Replace   NewValue with 0
					Unlock
			ENDIF
   ENDIF
	 if Tarif==0.0000.and.summa#0
			IF RecLock()
					DELETE
					Unlock
			ENDIF
	 ENDIF
	 if Tarif==0.8000
			IF RecLock()
					DELETE
					Unlock
			ENDIF
	 ENDIF
	 if Tarif==1.1800
			IF RecLock()
					DELETE
					Unlock
			ENDIF
	 ENDIF
	 if Tarif==1.6000
			IF RecLock()
					DELETE
					Unlock
			ENDIF
	 ENDIF
	 if Tarif==2.3600
			IF RecLock()
					DELETE
					Unlock
			ENDIF
	 ENDIF
	 Skip
ENDDO

oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil




function PrintPoint()
local SCR:=Win_Save(),Clr:=Setcolor(),rec:=recno(),Poisk:="",nLast:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nNum:=1

select main
go top

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
//cStr:="Лицевой;Счетчик;Тип;В;А;Показание;Телефон;Силовая;Освещение;Граница"+CrLf

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet<100000
      select licevoj
      Seek Main->Lic_Schet
      nNum:=1
      
      DO While Licevoj->Lic_Sch==Main->Lic_Schet
      	 Select 3
      	 nLast:="000000"
      	 Poisk:='('+alltrim(str(licevoj->lic_sch))+')'+alltrim(licevoj->schetchik)
      	 Seek Poisk
      	 IF Found()
      	 		nLast:=AllTrim(Str(Pokazaniq,12,0))
      	 ENDIF
				 IF AtNum("ПОТЕРИ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("ВОЗВРАТ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("АКТ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("МОЩ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("НАЧ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("ДОНАЧ",MYUpper(AllTrim(Licevoj->Schetchik)))==0         

            cStr=cStr+str(Main->Lic_Schet,6,0)+"|"+Licevoj->Schetchik+"|"+Licevoj->Tip+"|"+;
                      Licevoj->B+"|"+Licevoj->A+"|"+Licevoj->Pokazanie+"|"+Licevoj->Telefon+"|"+;
                      Str(Licevoj->Silowaq,8,2)+"|"+Str(Licevoj->Oswesh,8,2)+"|"+;
                      Licevoj->Razdel_1+CrLf
         ENDIF

      	 Select Licevoj
      	 Skip
      ENDDO
   ENDIF
	 select main
   skip
enddo
desc:=FCreate(dDir+ReportFile)
FWrite(Desc,cStr+Chr(13)+Chr(10))
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil







Function OutFid()
Local Sel:=Select(),Rec:=RecNo(),cFider,I:=0,Desc,cText:="Adr;Name"+Chr(13)+Chr(10)
Local oDlg,aSizeDeskTop,aPos,oProgress

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

  load("76",SCHET_SHARE+"Fiders.dbf",Schet_Share+"FidersN.ntx",Schet_Share+"FidersC",.f.)
  														
  oProgress:create()
  oProgress:minimum := 1
  oProgress:maximum := RecCount()
	go top
	Do While !eof()
      oProgress:increment()																				// Progress Bar Increment
      I=I+1
      IF RecLock(0)
      	 Replace NPP With I
      	 UNLOCK
      ENDIF
      cText=cText+AllTrim(Str(i,6,0))+";"+ConvToAnsiCP(AllTrim(Fider))+Chr(13)+Chr(10)
			Skip
	EndDo
	Close
	Desc=FCreate(dDir+"Fiders.Txt")
	FWrite(Desc,cText)
	FClose(Desc)

oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
Select(Sel)
Go Rec
Return NIL



Function PrintRash()
Local Tarifs:={},Count
Local Sel:=Select(),Rec:=Recno(),NewLic:=0
Local cStr:="DOG;pay_id;bill_group;bill_date;doc_date;calc_type;data_beg;data_end;cons_num;GO_num;tar_num;summ;nds_in;tovar"+Chr(13)+Chr(10)
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",nCount:=0,nSumma:={0,0,0}
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


make_ind('0',SCHET_SHARE+'Groups.dbf',SCHET_SHARE+'Groups.ntx','Dog_Num',,,.t.,.t.)
Load("112",SCHET_SHARE+"Groups.dbf",SCHET_SHARE+'Groups.ntx',,  .f.)


AADD(Tarifs,{1.26,0.0906,1.488,0,0,0,})
AADD(Tarifs,{1.36,0.0906,1.588,0,0,0,})
AADD(Tarifs,{1.76,0.0906,1.988,0,0,0,})
AADD(Tarifs,{2.18,0.0906,2.408,0,0,0,})
AADD(Tarifs,{1.45,0.0906,1.678,0,0,0,})
Count=5

Select Main
go top
do while !eof()
   oProgress:increment()																				// Progress Bar Increment
   For i=1 to Count
//   		Tarifs[i][2]=0	// Доля расхода
//   		Tarifs[i][3]=0  // Новый тариф
   		Tarifs[i][4]=0  // Расход
   Next
   nSumma:={0,0,0}
   Select Licevoj
   Seek Main->Lic_Schet
   Do While Lic_sch==Main->Lic_Schet
   		poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
   		Select Mar
   		Seek Poisk
   		IF Found()
   			 IF .not.IsLastMont.and..not.Moshn.and.Tarif#0
   			 	IF val(substr(licevoj->schetchik,3,7))>0.or.val(substr(licevoj->schetchik,2,7))>0.or.AtNum("ПОТЕРИ",MYUpper(AllTrim(Licevoj->Schetchik)))!=0
   			 		For i=1 to Count
   			 				IF Tarif==Tarifs[i][1]
   			 					 Tarifs[i][4]=Tarifs[i][4]+Rashod
   			 				ENDIF
   			 		Next
   			 	ENDIF
   			 ENDIF
   		ENDIF
   		Select Licevoj 
   		Skip
   ENDDO
   for i=1 to Count
   		 IF Tarifs[i][4]#0
/*   		 	
   		 		nSumma[1]=nSumma[1]+Round(Tarifs[i][4]*Tarifs[i][2],2)		     // Доля расхода
   		 		nSumma[2]=Round(Tarifs[i][4]*Tarifs[i][2]*Tarifs[i][3],2)      // Сумма начисления по св.тарифу
   		 		nSumma[3]=Round(Tarifs[i][4]*Tarifs[i][2]*(-1)*Tarifs[i][1],2) // Возврат по осн.тарифу
*/   		 		
/*   		 	
       	  cStr=cStr+AllTrim(Str(Main->Lic_Schet,6,0))+";"+;
       	            AllTrim(Str(Tarifs[i][1],9,4))+";"+;
       	            AllTrim(Str(Tarifs[i][2],12,4))+";"+;
       	            AllTrim(Str(Tarifs[i][3],12,4))+";"+;
       	            AllTrim(Str(Tarifs[i][4],12,0))+";"+;
       	            AllTrim(Str(Round(Tarifs[i][4]*Tarifs[i][2],2)))+";"+;									// Доля расхода
       	            AllTrim(Str(Round(Tarifs[i][4]*Tarifs[i][2]*(-1)*Tarifs[i][1],2)))+";"+; // Возврат к осн.тарифу
       	            AllTrim(Str(Round(Tarifs[i][4]*Tarifs[i][2]*Tarifs[i][3],2)))+; // Начисл. по своб.тарифу
       	            Chr(13)+Chr(10)
*/
// Возврат
					 Select 112
					 Seek Main->Lic_Schet
					 IF Found()
					 		NewLic=Pay_Id
					 ELSE
					 		NewLic=0
					 ENDIF
//					 ? Charrem(".,-",Name_Nazn)
					 Found=.F.
					 nPowerId=0
					 nNaznPart=0
					 DO While Dog_Num==Main->Lic_Schet.and.Found==.f.
					    IF AtNum(AllTrim(Str(100*Tarifs[i][1],6)),Charrem(".,-",Name_Nazn))#0
					    	 Found=.T.
					 			 nPowerId=Power_Id
					 			 nNaznPart=NaznPart_I
					    ENDIF
					 		SKIP
					 ENDDO
//					 ?? nPowerID
//					 ?? "   "
//					 ?? nNaznPart
//					 Inkey(0)
    	     cStr=cStr+AllTrim(Str(Main->Lic_Schet,6,0))+";"+;	// DOG
       	  				  IF(NewLic#0,AllTrim(Str(NewLic,6,0))," ")+";"+;	// Pay_id
       	  				  "1;"+;																		// bill_group
       	  				  "31.05.2007;"+;													// bill_date
       	  				  "31.05.2007;"+;													// doc_date
       	  				  "1;"+;         													// calc_type
       	  				  "01.05.2007;"+;													// data_beg
       	  				  "31.05.2007;"+;													// data_end
       	  				  "1;"+;																		// cons_num
       	  				  IF(nPowerId#0,AllTrim(Str(nPowerId,6,0))," ")+";"+;	// GO_num
       	  				  IF(nNaznPart#0,AllTrim(Str(nNaznPart,6,0))," ")+";"+;	// tar_num
       	  				  +AllTrim(Str(Round(Round(Tarifs[i][4]*Tarifs[i][2],0)*(-1)*Tarifs[i][1],8)))+";"+; // summ
       	  				  "0;"+;																		//nds_in
       	  				  "-"+Alltrim(Str(Round(Tarifs[i][4]*Tarifs[i][2],0),12,0))+";"+;				  // tovar
									  Substr(Main->Potrebitel,1,40)+Chr(13)+Chr(10)

// Начисления
    	     cStr=cStr+AllTrim(Str(Main->Lic_Schet,6,0))+";"+;	// DOG
       	  				  IF(NewLic#0,AllTrim(Str(NewLic,6,0))," ")+";"+; // Pay_id
       	  				  "1;"+;																		// bill_group
       	  				  "31.05.2007;"+;													// bill_date
       	  				  "31.05.2007;"+;													// doc_date
       	  				  "1;"+;         													// calc_type
       	  				  "01.05.2007;"+;													// data_beg
       	  				  "31.05.2007;"+;													// data_end
       	  				  "1;"+;																		// cons_num
       	  				  IF(nPowerId#0,AllTrim(Str(nPowerId,6,0))," ")+";"+;	// GO_num
       	  				  IF(nNaznPart#0,AllTrim(Str(nNaznPart,6,0))," ")+";"+;	// tar_num
       	  				  AllTrim(Str(Round(Round(Tarifs[i][4]*Tarifs[i][2],0)*Tarifs[i][3],8)))+";"+;		  // summ
       	  				  "0;"+;																		//nds_in
       	  				  Alltrim(Str(Round(Tarifs[i][4]*Tarifs[i][2],0),12,0))+";"+;				      // tovar
       	            AllTrim(Str(Tarifs[i][1],9,4))+";"+;
       	            AllTrim(Str(Tarifs[i][2],12,4))+";"+;
       	            AllTrim(Str(Tarifs[i][3],12,4))+";"+;
       	            AllTrim(Str(Tarifs[i][4],12,4))+";"+;
									  Chr(13)+Chr(10)

       ENDIF
   next
/*
   if nSumma[1]#0
    	     cStr=cStr+AllTrim(Str(Main->Lic_Schet,6,0))+";"+;	// DOG
       	  				  +" ;"+;																	// Pay_id
       	  				  +"1;"+;																	// bill_group
       	  				  +"31.05.2007;"+;												// bill_date
       	  				  +"31.05.2007;"+;												// doc_date
       	  				  +"1;"+;         												// calc_type
       	  				  +"01.05.2007;"+;												// data_beg
       	  				  +"31.05.2007;"+;												// data_end
       	  				  +"1;"+;																	// cons_num
       	  				  +" ;"+;																	// GO_num
       	  				  +" ;"+;													 			  // tar_num
       	  				  +Alltrim(Str(nSumma[2],12,2))+";"+;			// summ
       	  				  +"0;"+;																	//nds_in
       	  				  +Alltrim(Str(nSumma[1],12,0))+";"+;			// tovar
									  Chr(13)+Chr(10)
   ENDIF
*/   
   select main
	 Skip
enddo	
select 112
Close
desc:=FCreate("D:\Gos\Ose\Out.txt")
FWrite(Desc,cStr)
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
	
Select(Sel)
Go Rec
Return NIL




Function Lose1()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor()
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",nCount:=0


	Select lose
	set order to 2
	Go Top
	Desc:=FCreate(dDir+ReportFile)
	
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

	Do While !EOF()
      oProgress:increment()																				// Progress Bar Increment
			
			FWrite(Desc,KOD+"|"+Str(PO,6,4)+"|"+Str(Length,6,0)+"|"+Str(Length2,6,0)+"|"+;
			            Str(Smena,1)+"|"+Str(Square,3,0)+"|"+Str(koeff,8,6)+"|"+Str(Days,2,0)+"|"+;
			            Str(Hours,2,0)+"|"+Str(KGR,4,2)+"|"+Str(KMoshn,4,2)+"|"+Str(nPhase,1,0)+"|"+;
			            Str(UNAPR,6,2)+CrLf)

      Select Lose
      Skip
	EndDo
	set order to 1
	go top
	FClose(Desc)
  oProgress:destroy()																							// Progress Bar Destroy
  oDlg:Destroy()


Select(Sel)
Go Rec
Win_Rest(Scr)
SetColor(Clr)
Return NIL





Function Lose2()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),cMy:="TO"
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",nCount:=0


	Select LoseTran
	Set order to 2
	Go Top
	Desc:=FCreate(dDir+ReportFile)
	
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

	Do While !EOF()
      oProgress:increment()																				// Progress Bar Increment

			FWrite(Desc,KOD+"|"+Str(PXX,6,2)+"|"+Str(&cMy,6,0)+"|"+Str(PKZ,6,2)+"|"+;
			            Str(TP,4,0)+"|"+Str(SNomt,6,0)+"|"+Str(KMoshn,4,2)+"|"+Str(KGR,4,2)+CrLf)

      Select LoseTran
      Skip
	EndDo
	Set order to 1
	go top
	FClose(Desc)
  oProgress:destroy()																							// Progress Bar Destroy
  oDlg:Destroy()


Select(Sel)
Go Rec
Win_Rest(Scr)
SetColor(Clr)
Return NIL







Function PrintLicBank()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor()
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",nCount:=0


	Go Top
	Desc:=FCreate(dDir+ReportFile)
	
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

	Do While !EOF()
      oProgress:increment()																				// Progress Bar Increment
      Select Licevoj
      Seek Main->Lic_Schet
      IF !EMPTY(Licevoj->MFO)
      	FWrite(Desc,Str(Main->Lic_Schet,4,0)+" "+Substr(Main->Potrebitel+Space(20),1,20)+" "+Licevoj->MFO+" "+Licevoj->R_SCHET+" "+Licevoj->K_SCHET+" "+Main->Adress+CRLF)
      ENDIF
      Select Main
      Skip

	EndDo
	FClose(Desc)
  oProgress:destroy()																							// Progress Bar Destroy
  oDlg:Destroy()


Select(Sel)
Go Rec
Win_Rest(Scr)
SetColor(Clr)
Return NIL





Function GetKvitPrivat()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),NoExit:=.T.,Error:=0
Local ChReestr:=00000,NoInput:=.F.,ReestrSum:=0,tRec,ChReestr2:=0,cBase:="T:\Privat.Dbf"
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",nCount:=0
Select 202
GO Top
// ChReestr - N Реестра
//Select 207
IF load('207',cBase)
	Go Top
	Desc:=FCreate(dDir+ReportFile)
	
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

	Do While !EOF()
      oProgress:increment()																				// Progress Bar Increment

			tLic				=Val(NLS1_ID)
			tNum_Dokum	=Str(Reestr,7,0)
			tPokazaniq	=Show
			tSummaEl		=Summa/100
			tSummaP			=SummaP/100
			tRashod			=0
			tLgota			=0
			tData				=Date
			ChReestr		=7000+Reestr
			ChReestr2		=0
			Select FNSI
			Seek tLic
			IF .not.Found()
				 FWrite(Desc,Str(tLic,8,0)+" "+tNum_Dokum+" "+Str(tPokazaniq,7)+" "+Str(tSummaEl,10,2)+" "+;
				 						 Str(tSummaP,10,2)+" "+DTOC(tData)+" "+Str(ChReestr,4)+CrLf)
				 Error=Error+1
			ELSE
			
				IF Val(tNum_Dokum)!=82.and.Val(tNum_Dokum)!=86.and.Val(tNum_Dokum)!=122
      	
	      		Select 202
	      		Append Blank
     				Replace Lic 			With tLic
     				Replace Vid_Dokum With "Экспорт"
     				Replace Num_Dokum With tNum_Dokum
     				Replace Pokazaniq with tPokazaniq
     				Replace Summael   With tSummaEl
     				Replace SummaP    With tSummaP
     				Replace Rashod    With tRashod
     				Replace Lgota     With tLgota
     				Replace Data      With tData
     				Replace Reestr    With ChReestr
     				Replace Reestr2   With ChReestr2
     				replace ChSearch  With TimeKey()+Str(Lic,6)
     				Replace Schetchik With Fnsi->NS
     				
     		ENDIF

     	ENDIF
     	
     	Select 207
     	Skip
	EndDo
	Close
	FClose(Desc)
  oProgress:destroy()																							// Progress Bar Destroy
  oDlg:Destroy()
  IF(Error==0)
		AL_BOX({"Ошибок не обнаружено"})	
  ELSE
		AL_BOX({"Не найдено лицевых "+AllTrim(Str(Error,10,0))})	
  ENDIF
ELSE
	AL_BOX({"Невозможно открыть файл для экспорта данных"})	
ENDIF	

Select(Sel)
Go Rec
SetColor(Clr)
Win_Rest(Scr)
Return NIL





Function MakeProdAvans()
Local Sel:=Select(),Rec:=RecNo(),nLic,I
Local nMonth:=Month_Menu("расчета авансов")
Local oDlg,aSizeDeskTop,aPos,oProgress,aOpl:={},lFirst:=.T.
Private cNumPlat:=""
IF nMonth>0.and.nMonth<13
//	 Select SFKniga
	 Select Main
	 Go Top

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
	 
/*	 Do While !EOF()
   	  oProgress:increment()																				// Progress Bar Increment
   	  IF Month==nMonth.and.Type==0
   	  	  lFirst:=.T.
   	  	  nLic:=sfKniga->Number
   				nPay:=CalckPay(nMonth,nLic,.f.)
   				Opl:=SfKniga->Wsegosnds
   				nDolg:=GetDolg(nLic,IF(nMonth-1=0,13,nMonth-1))
   				Opl:=Opl+nDolg
   				IF nPay-Opl>0
   					 aOpl:=aGetOpl(nLic,nMonth)
   					 For i=1 To Len(aOpl)
   					     Opl:=Opl-aOpl[i][1]
   					     IF Opl<0
   					     	  IF lFirst
   					     	  	 aOpl[i][1]:=-1*Opl
   					     	  	 lFirst:=.F.
   					     	  ENDIF
   					     ELSE
   					     	  aOpl[i][1]:=0
   					     ENDIF
								 IF aOpl[i][1]>0
      			 		 	  	 PutBookPay(3,nMonth,nLic,aOpl[i][1],ctod(Alltrim(Str(LastDayOm(nMonth)))+"."+Alltrim(Str(nMonth))+"."+Alltrim(Str(Year(New_date)))),aOpl[i][2])
      			 		 ENDIF
      			 NEXT
   				ENDIF
   	  ENDIF
	 		Skip
	 ENDDO
*/


	Do While Lic_Schet<99999.and..not.EOF()
   	oProgress:increment()                                                                                                                                                          // Progress Bar Increment
   	nPay:=CalckPay(nMonth,Lic_Schet,.f.)
   	Opl:=GetSum(Lic_schet,nMonth) //;  Opl:=Opl+Round(Opl*Schet_Nds/100,Decimal)
   	nDolg:=GetDolg(Lic_Schet,IF(nMonth-1=0,13,nMonth-1))
//-------------------------------- запись в нигу продаж авансов
	  lFirst:=.T.
   	nLic:=Lic_Schet
   	Month:=nMonth
   	Opl:=Opl+nDolg
/*
IF nLic==1031
@ 1,0 Say ""
? "Оплачено "; ?? nPay
? "Начислено"; ?? Opl
? "Дебет    "; ?? nDolg
? "nPay-Opl "; ?? nPay-Opl
ENDIF	
*/
   	IF nPay-Opl>0   		
      	aOpl:=aGetOpl(nLic,nMonth)
      	For i=1 To Len(aOpl)
          	Opl:=Opl-aOpl[i][1]
          	IF Opl<0
             	IF lFirst
                	aOpl[i][1]:=-1*Opl
                	lFirst:=.F.
             	ENDIF
          	ELSE
             	aOpl[i][1]:=0
          	ENDIF
          	IF aOpl[i][1]#0
             	PutBookPay(3,nMonth,nLic,aOpl[i][1],ctod(Alltrim(Str(LastDayOm(nMonth)))+"."+;
             	             Alltrim(Str(nMonth))+"."+Alltrim(Str(Year(New_date)))),aOpl[i][2])
          	ENDIF
      	NEXT
   	ENDIF
//--------------------------------
	   Skip
	EndDo

   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
	
ENDIF
Select(Sel)
Go Rec
Return NIL




Function aGetOpl(Lic,month,TypeOpl)
Local Sel:=Select(),Rec:=RecNo(),Sum:=0,Wozw_N:=0,Woz_Wrat:=0,BezNds
Local Screen,Kol_Kl,Temp_,Month_,NameInd:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,cStr:="",aOpl:={}
LIC:=IF(Lic==NIL,Main->Lic_Schet,Lic)
TypeOpl:=IF(TypeOpl==NIL,1,TypeOpl)
cFoundStr:=IF(cFoundStr==NIL,"",cFoundStr)
Do Case
   Case TypeOpl==1
        month_='o'+alltrim(str(month))
        NameInd:=Schet_Share+'o'+alltrim(str(month))+".ntx"
   Case TypeOpl==2
        month_='p'+alltrim(str(month))
        NameInd:=Schet_Share+'p'+alltrim(str(month))+".ntx"
   Case TypeOpl==3
        month_='h'+alltrim(str(month))
        NameInd:=Schet_Share+'h'+alltrim(str(month))+".ntx"
   Case TypeOpl==4
        month_='a'+alltrim(str(month))
        NameInd:=Schet_Share+'a'+alltrim(str(month))+".ntx"
EndCase
//NetUse(Month_,,0)
select 44
NetUse(Schet_Share+Month_+".dbf")
Set Index to &NameInd
//go top
Seek Lic
do while Licevoj==LIC
   IF Licevoj=Lic
      if .not.deleted()
         IF .NOT.Empty(cFoundStr).AND.AtNum(cFoundStr,Vid_Dokum)!=0
            if alltrim(vid_dokum)#'Пеня'.and.alltrim(vid_dokum)#'пеня'
               if alltrim(vid_dokum)="возврат".or.alltrim(vid_dokum)='Возврат'
                  sum=sum-summa
                  ***************************
                  * Сумма возврата с начисления
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="О ВОЗВРАТ"
                     sum=sum-summa
                  else
                     if MYupper(alltrim(vid_dokum))="Н ВОЗВРАТ"
                     else
                        sum=sum+summa
                        cStr:=cStr+AllTrim(Vid_dokum)+" "+AllTrim(Num_Dokum)+" "
                        AADD(aOpl,{Summa,AllTrim(Vid_dokum)+" N"+AllTrim(Num_Dokum)+" "+DTOC(Data)})
                     endif
                  endif
               endif
            endif
         ELSEIF Empty(cFoundStr)
            if alltrim(vid_dokum)#'Пеня'.and.alltrim(vid_dokum)#'пеня'
               if alltrim(vid_dokum)="возврат".or.alltrim(vid_dokum)='Возврат'
                  sum=sum-summa
                  ***************************
                  * Сумма возврата с начисления
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="О ВОЗВРАТ"
                     sum=sum-summa
                  else
                     if MYupper(alltrim(vid_dokum))="Н ВОЗВРАТ"
                     else
                        sum=sum+summa
                        cStr:=cStr+AllTrim(Vid_dokum)+" "+AllTrim(Num_Dokum)+" "
                        AADD(aOpl,{Summa,AllTrim(Vid_dokum)+" N"+AllTrim(Num_Dokum)+" "+DTOC(Data)})
                     endif
                  endif
               endif
            endif
         ENDIF
      endif
   endif
   skip
enddo
cNumPlat:=cStr
use
Select(sel); go Rec
return aOpl



Function LoadRashGos()
local SCR:=Win_Save(),Clr:=Setcolor(),rec:=recno(),nMonth,PrevMonth,Prevpok,lFound,lError
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nCount:=0
Local nRazn,cStrError:="",nError:=0,lAppend,Poisk:=""

ClearBuffer()
Clear Typeahead
BankFile:=FileList("*.csv",Schet_Share)
IF Empty(BankFile)
   Al_Box({"Не выбран файл с показаниями. Загрузка прервана"})
   Return NIL
ENDIF
nMonth:=Month_Menu(" для загрузки показаний")
IF nMonth==0
   Return NIL
ENDIF
PrevMonth:=If(nMonth==1,13,Nmonth-1)
	
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
  														
cStr:=ConvToOemCP(Memoread(BankFile))

oProgress:create()
oProgress:minimum := 1
oProgress:maximum := MlCount(cStr,460)-6

For I=6 To MlCount(cStr,460)
    oProgress:increment()																				// Progress Bar Increment
    IF nError>0
		   Odlg:setTitle("Обработано "+AllTrim(Str(i,10,0))+"   Ошибок "+AllTrim(Str(nError,10,0)))
		ELSE
		   Odlg:setTitle("Обработано "+AllTrim(Str(i-5,10,0)))
		ENDIF
    cStr1:=MemoLine(cStr,460,I)

    nLic:=Val(GetStrToken(cStr1,2,";"))     // Лицевой счет
    cPotr:=GetStrToken(cStr1,4,";")					// Наименование потребителя
   	cSch:=GetStrToken(cStr1,8,";")          // Номер счетчика
   	cZn:=GetStrToken(cStr1,9,";")           // Значность
   	cZn:=Int(Val(cZn))
   	nKoef:=Val(GetStrToken(cStr1,10,";"))   // Коэффициент
   	nPok:=Val(GetStrToken(cStr1,17,";")) 	  // Показания
   	nKoef=Int(nKoef)
//    @ 1,0 Say nLic
//    @ 2,0 Say cSch
    cSch=if(Substr(cSch,1,1)=="`",Substr(cSch,2),cSch)
//    @ 2,20 Say cSch
//    @ 3,0 Say cZn
//    @ 4,0 Say nKoef
//    @ 5,0 Say nPok
//    Inkey(0)

		lFound:=.F.
		lError:=.F.
		lAppend:=.F.
		nRazn:=0
		Select Licevoj		
		Seek nLic
		do While Lic_sch==nLic
			 IF AllTrim(Upper(Licevoj->Schetchik))==AllTrim(Upper(cSch))
			 	  lFound=.T.
			 	  Exit
			 ENDIF
			 Skip
		EndDo
		IF lFound==.T.
    		poisk='('+alltrim(str(nLic))+')'+alltrim(cSch)
    		select(PrevMonth)
    		seek poisk
    		if Found()
    	 		PrevPok:=pokazaniq
    		ENDIF
    		PrevPok=IF(IsNewValue==.T.,NewValue,PrevPok)
    		IF nPok>=PrevPok
    			 nRazn=nPok-PrevPok
    		ELSE
//    			@ 1,0 Say nLic
//    			@ 2,0 say cZn
//    			?? "                     "
//    			@ 3,0 say replicate('9',cZn)
				   nRazn=1+val(replicate('9',cZn))
   				 nRazn=nRazn-PrevPok
   				 nRazn=nRazn+nPok
    		ENDIF
    		
    		Select(nMonth)
    		seek poisk
    		if .not.Found()
	    	 	 IF NetAppend()
		    	 	   UNLOCK
    	 	  		 Go RecNo()
    	 		 ENDIF
    		endif
    		IF RecLock()
       	 	 replace kod with Poisk
       		 replace pokazaniq with nPok
       		 replace koeficient with nKoef
       		 replace num_of_sch with cSch
       		 replace licevoj with nLic
       		 commit
    			 IF nRazn>99999.or.nRazn<0
    			 		lError:=.T.
    			 ELSE
       		 	 	replace raznica with nRazn
       		 	 	replace rashod with nRazn*nKoef
       		 ENDIF
    	 		 UNLOCK
    		ENDIF
    ELSE
    	 IF .not.Empty(AllTrim(cSch))
	    		Select Main 
    			Seek nLic
    			IF Found()
    			 	Select Licevoj
    			 	IF NetAppend()
    			 	  	Replace Lic_Sch With nLic
    			 	  	Replace Schetchik With AllTrim(cSch)
    			 	  	Unlock
	    			 	  
    	 					PrevPok:=0
    			 			nRazn=nPok-PrevPok
    						Select(nMonth)
	    	 	 			IF NetAppend()
	       	 	 			replace kod with Poisk
       		 				replace pokazaniq with nPok
       		 				replace koeficient with nKoef
       		 				replace num_of_sch with cSch
       		 				replace licevoj with nLic
       		 				commit
    			 				IF nRazn>99999
    			 						lError:=.T.
    			 				ELSE
       		 	 					replace raznica with nRazn
       		 	 					replace rashod with nRazn*nKoef
    			 	  			  lAppend:=.T.
    			 	  			  lError:=.T.
       		 				ENDIF
    	 		 				UNLOCK
    						ENDIF //NetAppend
    			 	ENDIF //NetAppend
    			ENDIF //Found()
    		ELSE
    		   lError=.T.
    		ENDIF
    ENDIF
    IF lError==.T.
	     IF .not.Empty(AllTrim(cSch))
    	 		cStrError:=cStrError+"|"+Str(nLic,6,0)+"|"+Substr(cPotr+Space(40),1,40)+"|"+;
    	 	          Space(25-Len(cSch))+cSch+"|"
    	 		DO Case
		    	    Case lAppend==.T.
    		  				cStrError:=cStrError+"Счетчик добавлен|"
    	 				CASE lFound==.F.
		    	 		    IF Empty(AllTrim(cSch))
//  		  		  			 cStrError:=cStrError+"Неверный счетчик|"
    	 		    		ELSE
    		  			 		cStrError:=cStrError+"Нет в базе      |"
    		  				ENDIF
    	 				CASE nRazn==0.or.nRazn>99999
		    		  		cStrError:=cStrError+"Неверный расход |"
    		  		OTHERWISE
		    		  		cStrError:=cStrError+"                |"
    	 		ENDCASE
    	 		cStrError:=cStrError+CrLf
    	 		nError:=nError+1
    	 ENDIF
    ENDIF
Next
Desc=FCreate(dDir+ReportFile)
FWrite(Desc,cStrError)
FClose(Desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
Return NIL