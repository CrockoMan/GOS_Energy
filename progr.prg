Function ServMenu()
LOCAL old_col1:=setcolor(),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1,Is_Choice:={},Scr:=Win_Save()
local first:=.T.,NeskInfo,DebetInfo,Spravochnik
devout("")

TxtRasch:= {{" Рассчитать книгу продаж авансы ",{||MakeProdAvans()}}						 }

OtchMenu:={{" Просмотреть       ",{||txtview()} },;
           {" Отпечатать",{||Print_Fi()}}}



Spisok:={{" Расчеты ",TxtRasch},;
         {" Отчет... ",OtchMenu} }

Keyboard Chr(13)
do_menu(Spisok,.t.,,,,1,,)
ClearBuffer()
devout("")
win_rest(Scr)
setcolor(old_col1)
Return NIL




Function MakeProdAvans()
Local Sel:=Select(),Rec:=RecNo(),nLic,I
Local nMonth:=Month_Menu("расчета авансов")
Local oDlg,aSizeDeskTop,aPos,oProgress,aOpl:={},lFirst:=.T.
Private cNumPlat:=""
IF nMonth>0.and.nMonth<13
	 Select SFKniga
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
	 Do While !EOF()
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
