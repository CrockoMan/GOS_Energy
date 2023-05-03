//#define DEBUGON	1

function OutChPok()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out17.dbf",rec:=recno(),nInn,nKpp,aPok:={0,CTOD("01.01.2000")}
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nCount:=0
Local cStr1,cStr2,nLic,nSum,dDat,nPok,ind:="d:\gos\ose\out17.ntx",tLic:=0
aBank:={}
BankFile:="D:\GOS\OSE\Cart.csv"

select 65
use &out exclusive
index on Val(nls_id) to &Ind
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

select main
go top

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Выгрузка счетчики" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
   	
cStr:=ConvToOemCP(Memoread(BankFile))

For I=2 To MlCount(cStr,350)

    oProgress:increment()																				// Progress Bar Increment
    cStr1:=MemoLine(cStr,350,I)
    cLic:=GetStrToken(cStr1,1,";")   // Лицевой счет
//    @ 1,0 say cLic
    nLic:=VAL(SUBSTR(cLic,5,6))
//    @ 2,0 say nLic

   Select Main
   Seek nLic	
   IF Main->Lic_Schet>=100000
      select licevoj
      Seek Main->Lic_Schet
      if found()
      	 aPok:=GetMaxPok(Main->Lic_Schet,3)
      	 Select FNSI
      	 Seek Main->Lic_Schet
      	 select FSCH
      	 Seek FNSI->SH
      	 Select Licevoj
      	 Seek Main->Lic_Schet
         Select 65
         
         if reclock()
            append blank
            Replace Nls_ID				With  cLic
            Replace Show					With  aPok[1]
						
            unlock
            nCount:=nCount+1


         ENDIF
         
      endif
    ENDIF

Next

oProgress:destroy()																							// Progress Bar Destroy

Select Main
Go Top

oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()

Do While !eof()
   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet>=100000
   	  tnLic:=1019000000+Main->Lic_Schet
   		Select 65
   		Seek tnLic
   		IF .not.Found()
      	select licevoj
      	Seek Main->Lic_Schet
      	IF found()
      		  aPok:=GetMaxPok(Main->Lic_Schet,3)
         		Select 65
         		IF reclock()
		           append blank
            	 Replace Nls_Id				With  str(tnLic,10,0)
            	 Replace Show					With  aPok[1]
		           Unlock
      			ENDIF
      	ENDIF
      ENDIF
   ENDIF
   Select Main
   Skip
EndDo


oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select 65
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil




function OutRash()
Local Sel:=Select(),Rec:=Recno(),cStr:="Dog_num;Value1;Value2;Value3;Value4;Value5;Value6;Value7;Value8;Value9;Value10;Value11;Value12"+Chr(13)+Chr(10)
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",nCount:=0
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
desc:=FCreate("D:\Gos\Ose\Out.txt")

go top
do while !eof()
   oProgress:increment()																				// Progress Bar Increment
   cStr=cStr+AllTrim(Str(Main->Lic_Schet,6,0))+";"
   for i=1 to 12
       cStr=cStr+AllTrim(Str(GetRashod(Main->Lic_Schet,i),12,0))+if(i<12,";","")
   next
   cStr=cStr+Chr(13)+Chr(10)
	 Skip
enddo	
FWrite(Desc,cStr)
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
	
Select(Sel)
Go Rec
Return NIL



function OutChSaldo()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out15.dbf",rec:=recno(),nInn,nKpp,aPok:={0,CTOD("01.01.2000")}
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nCount:=0,nSaldo:=0
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

select main
go top

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Выгрузка остатков" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet>=100000
   	
   			 Select 65
         if reclock()
         		nSaldo=GetSaldo(Main->Lic_Schet,3)
         		IF nSaldo!=0

            	append blank
            	Replace Nls_Old				With  Str(Main->Lic_Schet,6,0)
            	Replace Saldo					With  -1*nSaldo
            	replace Serv_id				With 	1
            	Replace Type_Sch			With	40
            	Replace	Opl_Group			With	1
            ENDIF
						
            unlock
            nCount:=nCount+1

         ENDIF
         
//------------------------------
         pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
            		DO CASE
            				CASE ValType(&FName)=="N"
            				     Val=Str(&FName,12,0)+";"
            				CASE ValType(&FName)=="D"
            					   IF Empty(&FName)
            				     		Val="        ;"
            					   ELSE
            				     		Val=DTOC(&FName)+";"
            				     ENDIF
            				OTHERWISE
            				     Val=&FName+";"
            		ENDCASE
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         Val:=""
         cStr:=""
//------------------------------

         
      
   ENDIF
   
	 select main
   skip
   #ifdef DEBUGON
		  IF nCount>=10
   				exit
   		ENDIF
   #endif
enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select 65
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil






function OutChSch()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out14.dbf",rec:=recno(),nInn,nKpp,aPok:={0,CTOD("01.01.2000")}
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nCount:=0
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

select main
go top

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Выгрузка счетчики" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet>=100000
      select licevoj
      Seek Main->Lic_Schet
      if found()
      	 aPok:=GetMaxPok(Main->Lic_Schet,3)
      	 Select FNSI
      	 Seek Main->Lic_Schet
      	 select FSCH
      	 Seek FNSI->SH
      	 Select Licevoj
      	 Seek Main->Lic_Schet
         Select 65
         
         if reclock()
            append blank
//            replace Region_id 		with  20
            Replace Nls_Old				With  Str(Main->Lic_Schet,6,0)
//            Replace Show1					With  GetMaxPok(Main->Lic_Schet,12)
            Replace Show2					With  0
            Replace Calc_Date			With  CTOD("01.03.2008")
            Replace Type_Calc			With  IF(Fsch->Perenos#0,Fsch->Perenos,4)
						Replace Type_Old			With  FNSI->SH
						Replace Zav_Nom				With  AllTrim(Licevoj->Schetchik)
            Replace Show1					With  aPok[1]
						
            unlock
            nCount:=nCount+1

//------------------------------
         pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
            		DO CASE
            				CASE ValType(&FName)=="N"
            				     Val=Str(&FName,12,0)+";"
            				CASE ValType(&FName)=="D"
            					   if Empty(&FName)
            				     		Val="        ;"
            					   ELSE
            				     		Val=DTOC(&FName)+";"
            				     ENDIF
            				OTHERWISE
            				     Val=&FName+";"
            		ENDCASE
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         Val:=""
         cStr:=""
//------------------------------

         ENDIF
         
      endif
      
   ENDIF
   
	 select main
   skip
   #ifdef DEBUGON
   		IF nCount>=10
		   		exit
   		ENDIF
   #endif
enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select 65
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil




function OutKart()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out13.dbf",rec:=recno(),nInn,nKpp,nCount:=0
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:=""
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

select main
go top

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Выгрузка карточек" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet>=100000
      select licevoj
      Seek Main->Lic_Schet
      if found()
      	 Select FNSI
      	 Seek Main->Lic_Schet
         Select 65
         
         if reclock()
            append blank
//            replace Region_id 		with  20
            Replace Nls_Old				With  Str(Main->Lic_Schet,6,0)
//            Replace Fam						With  ConvToAnsiCP(AllTrim(FNSI->FAM))
            Replace Fam						With  AllTrim(FNSI->FAM)
            Replace FName					With  " "
            Replace FOtch					With  " "
						Replace Men						With  3            
						
            unlock
            nCount:=nCount+1

//------------------------------
         pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
            		DO CASE
            				CASE ValType(&FName)=="N"
            				     Val=Str(&FName,12,0)+";"
            				CASE ValType(&FName)=="D"
            					   if Empty(&FName)
            				     		Val="        ;"
            					   ELSE
            				     		Val=DTOC(&FName)+";"
            				     ENDIF
            				OTHERWISE
            				     Val=&FName+";"
            		ENDCASE
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
//         FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         FWrite(Desc,cStr+Chr(13)+Chr(10))
         Val:=""
         cStr:=""
//------------------------------

         ENDIF
         
      endif
      
   ENDIF
   
	 select main
   skip
   #ifdef DEBUGON
   		IF nCount>=10
   				exit
   		ENDIF
   #endif
enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select 65
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil




function OutTarUsl()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out12.dbf",rec:=recno(),nInn,nKpp
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nCount:=0
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

select main
go top

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Выгрузка тарифы-услуги" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet>=100000
      select licevoj
      Seek Main->Lic_Schet
      if found()
      	 Select FNSI
      	 Seek Main->Lic_Schet
         Select 65
         
         if reclock()
            append blank
            Replace Nls_Old				With  Str(Main->Lic_Schet,6,0)
            DO Case
            	CASE FNSI->VO==1
            			Replace Tarif					With  11
            	CASE FNSI->VO==2
            			Replace Tarif					With  1
            	CASE FNSI->VO==3
            			Replace Tarif					With  6
            	CASE FNSI->VO==11
            			Replace Tarif					With  2
            	CASE FNSI->VO==18
            			Replace Tarif					With  11
            	CASE FNSI->VO==70
            			Replace Tarif					With  11
            	OTHERWISE
            			Replace Tarif					With  1
            ENDCASE
            Replace Tarif_Old			With  FNSI->VO
//            Replace Suppl_Id			With  0
            Replace Activ					With  1
            
            unlock
            nCount:=nCount+1

//------------------------------
         pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
            		DO CASE
            				CASE ValType(&FName)=="N"
            				     Val=Str(&FName,12,0)+";"
            				CASE ValType(&FName)=="D"
            					   if Empty(&FName)
            				     		Val="        ;"
            					   ELSE
            				     		Val=DTOC(&FName)+";"
            				     ENDIF
            				OTHERWISE
            				     Val=&FName+";"
            		ENDCASE
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         Val:=""
         cStr:=""
         	
//------------------------------

         ENDIF
         
      endif
      
   ENDIF
   
	 select main
   skip
   #ifdef DEBUGON
   		IF nCount>=10
   				Exit
   		ENDIF
   #endif
enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select 65
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil





function OutChastn()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out11.dbf",rec:=recno(),nInn,nKpp
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nCount:=0
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

select main
go top

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Выгрузка лицевых счетов" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
	
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet>=100000
      select licevoj
      Seek Main->Lic_Schet
      if found()
      	 Select FNSI
      	 Seek Main->Lic_Schet
				 Select 106
				 Seek FNSI->KUL
					
         Select 65
         
         if reclock()
            append blank
            replace Region_id 		with  19
            replace Village_id 		with  IF(Fkods->Village_id#0,Fkods->Village_Id,2)
            Replace Distr_id 			With  1
            Replace Book_Id				With  Val(Substr(Str(Main->Lic_Schet,6,0),2,2))
            Replace Street_Id			With  IF(Fkods->Perenos#0,Fkods->Perenos,219)
            Replace Str_Old				With	Fkods->KUL
            Replace House					With  Val(FNSI->Dm)
            Replace Korp					With  " "
            Replace Apart					With  Val(FNSI->KV)
            Replace TarId					With  1
            Replace Tarif_Old			With  0
            Replace Date_Beg			With  CTOD("01.03.2008")
            Replace Nls_Old				With  Str(Main->Lic_Schet,6,0)
            Replace Apart1				With  " "
            Replace S_Total 			With  -1
            Replace S_Living 			With  -1
            Replace Privat				With  1
            
            unlock
            nCount:=nCount+1

//------------------------------
         pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
            		DO CASE
            				CASE ValType(&FName)=="N"
            				     Val=Str(&FName,12,0)+";"
            				CASE ValType(&FName)=="D"
            					   if Empty(&FName)
            				     		Val="        ;"
            					   ELSE
            				     		Val=DTOC(&FName)+";"
            				     ENDIF
            				OTHERWISE
            				     Val=&FName+";"
            		ENDCASE
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         Val:=""
         cStr:=""
//------------------------------

         ENDIF
         
      endif
      
   ENDIF
   
	 select main
   skip
   #ifdef DEBUGON
   		IF nCount>=10
		   		exit
   		ENDIF
   #endif
enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select 65
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil




function OutGos()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out.dbf",rec:=recno(),nInn,nKpp
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:=""
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

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
desc:=FCreate("D:\Gos\Ose\Out.txt")
nInn:=27910000000
nKpp:=231111111

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet<100000
      select licevoj
      Seek Main->Lic_Schet
      
      if found()
         Select 65
         
         if reclock()
            append blank
            replace PPC_ID    	with  main->lic_schet
            replace pAR_NAME  	with  DelString(Main->Potrebitel,"ИНН")
            replace INN       	With  Str(Val(substr(AppendString(Main->Potrebitel,"ИНН"),5,11)),12,0)
            if Val(substr(AppendString(Main->Potrebitel,"ИНН"),5,11))==0
            	 replace INN     	With  AllTrim(Str(nInn,15,0))
            	 nInn=nInn+1
            endif
            Replace Rgn					With  '20'
            Replace Village_Id	With  2
            Replace Street_ID		With  263
            replace NB_FLAT   	With  Main->Adress
            replace rg_dt				with  CTOD("01.01.2000")
            replace PERSf 			With  Main->Boss
            replace PERSf_R			With  Main->Boss
            replace PERSf_D			With  Main->Boss
            replace PERSfULL 	 	With  Main->Boss
            replace PERSfULL_R	With  Main->Boss
            replace PERSfULL_D	With  Main->Boss
            replace KPP       	With  substr(AppendString(Main->Potrebitel,"КПП"),5)
            if empty(Kpp)
//            		Replace kpp with AllTrim(Str(nKpp,9,0))
            		Replace kpp with AllTrim(Str(RecNo(),9,0))
            		nKpp=nKpp+1
            ENDIF
            replace DOG_NUM    	with  main->lic_schet
            replace Department	With  2101
            replace Date_Conta 	with  main->data_dog
            Replace def_demand	With  1
            replace OKONH  		  With  Val(Main->OKONX)
            replace BIK    	 	  With  Licevoj->MFO
            replace Ras_Sch 		With  Licevoj->R_SCHET
            replace Cons_NAME  	with  DelString(Main->Potrebitel,"ИНН")
            replace Rgn_2				With  '20'
            Replace villageid2	With  2
            Replace Street_Id		With  263
            Replace shows_freq	With  1
            Replace shows_day	  With  25
            Replace shows_mon		With  1
            replace NB_FLAT2   	With  Main->Adress
            replace Branch_id 	With  Val(Main->OKPO)
            replace Responsibl	With  Main->Boss
            replace Live_In			With  ctod("01.01.2007")
            
            unlock

//------------------------------
         pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
            		DO CASE
            				CASE ValType(&FName)=="N"
            				     Val=Str(&FName,12,0)+";"
            				CASE ValType(&FName)=="D"
            					   if Empty(&FName)
            				     		Val="        ;"
            					   ELSE
            				     		Val=DTOC(&FName)+";"
            				     ENDIF
            				OTHERWISE
            				     Val=&FName+";"
            		ENDCASE
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         Val:=""
         cStr:=""
//------------------------------

         ENDIF
         
      endif
      
   ENDIF
   
	 select main
   skip
enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select out
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil




function OutPoint()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out2.dbf",rec:=recno(),Poisk:="",nLast:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nNum:=1
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

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
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet<100000
      select licevoj
      Seek Main->Lic_Schet
      nNum:=1
      
      DO While Licevoj->Lic_Sch==Main->Lic_Schet
      	 Select 12
      	 nLast:="000000"
      	 Poisk:='('+alltrim(str(licevoj->lic_sch))+')'+alltrim(licevoj->schetchik)
      	 Seek Poisk
      	 IF Found()
      	 		nLast:=AllTrim(Str(Pokazaniq,12,0))
      	 ENDIF
         Select 65
				 IF AtNum("ПОТЕРИ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("ВОЗВРАТ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("АКТ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("МОЩ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("НАЧ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("ДОНАЧ",MYUpper(AllTrim(Licevoj->Schetchik)))==0         
          if reclock()
            append blank
            replace PPC_ID    	with  main->lic_schet
            replace PP_ID     	with  nNum
            nNum=nNum+1
            IF Empty(AllTrim(Licevoj->Object1))
            	replace Power_Name  with AllTrim(Licevoj->Schetchik)
            ELSE
            	replace Power_Name  with AllTrim(Licevoj->Object1)
            ENDIF
            replace Nazn_ID			With 1
            replace p_choice		With 1
            replace p_ust				With Licevoj->Silowaq+Licevoj->Oswesh
            replace p_razr			With Licevoj->Silowaq+Licevoj->Oswesh
            replace kindcalc		With 3
            replace kol_chas		With Licevoj->Hour
            replace point				With Licevoj->Object1
            replace date_beg	  With CTOD("01.01.2005")
            replace show_beg		With nLast				// <- Последние показания
            Replace zav_nom			With "`"+AllTrim(Licevoj->Schetchik)
            replace typecalc_i  With 1
            Replace kft_t				With 1
            Replace portion			With 100
            Replace date_show		With CTOD("01.01.2007")
            Replace show				With nLast				// <- Последние показания

            unlock

//------------------------------
	         	pos=1
         		do while pos>0
            		FName:=Fieldname(pos)
            		IF .not.empty(FName)
	            		DO CASE
            					CASE ValType(&FName)=="N"
            				     	Val=Str(&FName,12,0)+";"
            					CASE ValType(&FName)=="D"
            					   	if Empty(&FName)
            				     			Val="        ;"
            					   	ELSE
            				     			Val=DTOC(&FName)+";"
            				     	ENDIF
            					OTHERWISE
            				     	Val=&FName+";"
            			ENDCASE
            			pos=pos+1
            			cStr=cStr+Val
            		ELSE
            	  		pos=0
            		ENDIF
         		enddo
         		FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         		Val:=""
         		cStr:=""
//------------------------------

          ENDIF
         ENDIF

      	 Select Licevoj
      	 Skip
      ENDDO
      
   ENDIF
   
	 select main
   skip
enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select out2
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil



function OutTP()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out7.dbf",rec:=recno(),Poisk:="",nLast:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nNum:=1
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

   if (.not. file(schet_share+"Fiders.Dbf"))
      sign(2)
      set color to (color_buf)
      restscreen(0,0,24,79,buff)
      return NIL
   else
      load("76",SCHET_SHARE+"Fiders.dbf",Schet_Share+"FidersN.ntx",Schet_Share+"FidersC",.f.)
   endif

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
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
   IF Main->Lic_Schet<100000
      select licevoj
      Seek Main->Lic_Schet
      nNum:=1
      
      DO While Licevoj->Lic_Sch==Main->Lic_Schet
      	 Select 12
      	 nLast:="000000"
      	 Poisk:='('+alltrim(str(licevoj->lic_sch))+')'+alltrim(licevoj->schetchik)
      	 Seek Poisk
      	 IF Found()
      	 		nLast:=AllTrim(Str(Pokazaniq,12,0))
      	 ENDIF
      	 select fiders
      	 seek licevoj->KOD
      	 Select Licevoj

         Select 65
				 IF AtNum("ПОТЕРИ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("ВОЗВРАТ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("АКТ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("МОЩ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("НАЧ",MYUpper(AllTrim(Licevoj->Schetchik)))==0.and.;
				 	  AtNum("ДОНАЧ",MYUpper(AllTrim(Licevoj->Schetchik)))==0         
          if reclock()
            append blank
/*            IF Empty(AllTrim(Licevoj->Object1))
            	replace Power_Name  with AllTrim(Licevoj->Schetchik)
            ELSE
            	replace Power_Name  with AllTrim(Licevoj->Object1)
            ENDIF
*/            
            replace point				With Licevoj->Object1
            Replace zav_nom			With "`"+AllTrim(Licevoj->Schetchik)
            Replace DispName		With Fiders->Fider
            Replace DispCode		With Val( Substr(Str(Licevoj->KOD,6,0),3,4))

            unlock

//------------------------------
	         	pos=1
         		do while pos>0
            		FName:=Fieldname(pos)
            		IF .not.empty(FName)
	            		DO CASE
            					CASE ValType(&FName)=="N"
            				     	Val=Str(&FName,12,0)+";"
            					CASE ValType(&FName)=="D"
            					   	if Empty(&FName)
            				     			Val="        ;"
            					   	ELSE
            				     			Val=DTOC(&FName)+";"
            				     	ENDIF
            					OTHERWISE
            				     	Val=&FName+";"
            			ENDCASE
            			pos=pos+1
            			cStr=cStr+Val
            		ELSE
            	  		pos=0
            		ENDIF
         		enddo
         		FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         		Val:=""
         		cStr:=""
//------------------------------

          ENDIF
         ENDIF

      	 Select Licevoj
      	 Skip
      ENDDO
      
   ENDIF
   
	 select main
   skip
enddo
FClose(desc)
select fiders
close
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select 65
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil





function OutFiders()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out8.dbf",rec:=recno(),Poisk:="",nLast:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:="",nNum:=1
Local aFiders[2]
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

   if (.not. file(schet_share+"Fiders.Dbf"))
      sign(2)
      set color to (color_buf)
      restscreen(0,0,24,79,buff)
      return NIL
   else
      load("76",SCHET_SHARE+"Fiders.dbf",Schet_Share+"FidersN.ntx",Schet_Share+"FidersC",.f.)
   endif

select Fiders
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
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()
   oProgress:increment()																				// Progress Bar Increment
   	Select 65
   	if !empty(Fiders->KOD)
   	@ 1,0 Say Fiders->KOD
   	@ 2,0 Say Str(Fiders->KOD,6,0)
   	@ 3,0 Say Substr(Str(Fiders->KOD,6,0),3,4)
   	@ 4,0 Say Val( Substr(Str(Fiders->KOD,6,0),3,4))
   	
   IF reclock()
      append blank
			Replace DispName	With Fiders->Fider
			Replace DispKode 	With Val( Substr(Str(Fiders->KOD,6,0),3,4))
      
   ENDIF
	         	pos=1
         		do while pos>0
            		FName:=Fieldname(pos)
            		IF .not.empty(FName)
	            		DO CASE
            					CASE ValType(&FName)=="N"
            				     	Val=Str(&FName,12,0)+";"
            					CASE ValType(&FName)=="D"
            					   	if Empty(&FName)
            				     			Val="        ;"
            					   	ELSE
            				     			Val=DTOC(&FName)+";"
            				     	ENDIF
            					OTHERWISE
            				     	Val=&FName+";"
            			ENDCASE
            			pos=pos+1
            			cStr=cStr+Val
            		ELSE
            	  		pos=0
            		ENDIF
         		enddo
         		FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         		Val:=""
         		cStr:=""

	 ENDIF
   Select Fiders
 	 Skip
enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select 65
close
SetColor(Clr)
Win_Rest(Scr)

select fiders
close

select main
go rec
return nil





Function OutTarif()
AL_BOX({"Under Construction"})
Return NIL






function OutSch()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out4.dbf",rec:=recno(),Poisk:="",nLast:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:=""
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

select fsch
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
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()

   oProgress:increment()																				// Progress Bar Increment
	 IF FSCH->KTS>0
   		Select 65
          if reclock()
            append blank
            replace typecalc   With FSCH->KTS
            Replace Quant_Phas With 1
            Replace Quant			 With 1
            Replace Name_Calc	 With FSch->TS
            Replace Tens_Calc	 With "380/220"
            Replace Type_Class With 2

            unlock

//------------------------------
	         	pos=1
         		do while pos>0
            		FName:=Fieldname(pos)
            		IF .not.empty(FName)
	            		DO CASE
            					CASE ValType(&FName)=="N"
            				     	Val=Str(&FName,12,0)+";"
            					CASE ValType(&FName)=="D"
            					   	if Empty(&FName)
            				     			Val="        ;"
            					   	ELSE
            				     			Val=DTOC(&FName)+";"
            				     	ENDIF
            					OTHERWISE
            				     	Val=&FName+";"
            			ENDCASE
            			pos=pos+1
            			cStr=cStr+Val
            		ELSE
            	  		pos=0
            		ENDIF
         		enddo
         		FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         		Val:=""
         		cStr:=""
//------------------------------
				 ENDIF
	 ENDIF
      	 Select FSch
      	 Skip
enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select out4
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil




Function OutStreet()
local SCR:=Win_Save(),Clr:=Setcolor(),out:="d:\gos\ose\out5.dbf",rec:=recno(),Poisk:="",nLast:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,desc,crlf:=Chr(13)+Chr(10),FName,Val:="",cStr:=""
select 65
use &out exclusive
zap
				 pos=1
         do while pos>0
            FName:=Fieldname(pos)
            IF .not.empty(FName)
   				     Val=FName+";"
            		pos=pos+1
            		cStr=cStr+Val
            ELSE
            	  pos=0
            ENDIF
         enddo
         cStr=cStr+Chr(13)+Chr(10)

select fkods
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
desc:=FCreate("D:\Gos\Ose\Out.txt")

do while !eof()

   oProgress:increment()																				// Progress Bar Increment

          Select 65
          if reclock()
            append blank

						replace street_id 		With FKods->KUL-9999
						replace street_nam		With FKods->Nul
						replace tstreet_id		With 1
						replace village_id		With 1

            unlock
//------------------------------
	         	pos=1
         		do while pos>0
            		FName:=Fieldname(pos)
            		IF .not.empty(FName)
	            		DO CASE
            					CASE ValType(&FName)=="N"
            				     	Val=Str(&FName,12,0)+";"
            					CASE ValType(&FName)=="D"
            					   	if Empty(&FName)
            				     			Val="        ;"
            					   	ELSE
            				     			Val=DTOC(&FName)+";"
            				     	ENDIF
            					OTHERWISE
            				     	Val=&FName+";"
            			ENDCASE
            			pos=pos+1
            			cStr=cStr+Val
            		ELSE
            	  		pos=0
            		ENDIF
         		enddo
         		FWrite(Desc,ConvToAnsiCP(cStr+Chr(13)+Chr(10)))
         		Val:=""
         		cStr:=""
//------------------------------
				 ENDIF
      	 Select Fkods
      	 Skip

enddo
FClose(desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select out5
close
SetColor(Clr)
Win_Rest(Scr)
select main
go rec
return nil
