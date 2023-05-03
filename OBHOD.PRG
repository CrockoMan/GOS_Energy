Function WriteObhod()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),NoExit:=.T.,Clr:=SetColor()
Local FNSIRec

Select FNSI
FNSIRec:=RecNo()

Select Obhod

set color to w+/b,gr+/b,,,w+/b
ColorWin(14,07,23,78,"n+/n")
@ 13,06 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·"
@ 14,06 SAY "³  „ â  ®¡å®¤                      ³"+space(35)+"º"
@ 15,06 SAY "³  „®£®¢®à                         ³"+space(35)+"º"
@ 16,06 SAY "³  ®ª § ­¨ï                       ³"+space(35)+"º"
@ 17,06 SAY "³  Š®­âà®««¥à                      ³"+space(35)+"º"
@ 18,06 SAY "³                                  ³"+space(35)+"º"
@ 19,06 SAY "³                                  ³"+space(35)+"º"
@ 20,06 SAY "³                                  ³"+space(35)+"º"
@ 21,06 SAY "³                                  ³"+space(35)+"º"
@ 22,06 SAY "ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
Set Curs On
Set Conf On
set color to w+/b,n/w,,,w+/b
tData:=New_date
tLic:=Main->Lic_Schet
tName:=Space(25)
Set Key 32 To HelpWrite
Do While NoExit
   @ 14,16 Say Space(8)
   @ 15,34 Say Space(6)
   @ 16,23 say space(15)

   tPokazaniq:=0

   @ 14,29 GET tDATA
   @ 15,33 GET tLIC Valid IsLicCorrect(@tLic)
   @ 16,33 GET tPOKAZANIQ Picture  "@K 999999"
   @ 17,22 GET tName      Picture  "@S17"
   Read
   Set Key 32 To
   IF LastKey()==27
      IF Al_Box({"‚á¥ ¤ ­­ë¥ ®¡à ¡®â ­ë"},2,{" ¥â "," „  "})==2
         NoExit=.F.
      ENDIF
   ELSE
      IF NetAppend()
         Replace Licevoj   With tLic
         Replace Pokazaniq with tPokazaniq
         Replace Data      With tData
         Replace Name      With tName
         UNLOCK
      ENDIF
      Select FNSI
      Seek tLic
      IF RecLock()
         Replace Ds5 With tData
         Replace Pb5 With tPokazaniq
         IF DOP<tData
            Replace PO With tPokazaniq
         ENDIF
         UNLOCK
      ENDIF
      Select FOSN
      IF NetAppend()
         Replace KA        With tLic
         Replace DOP       With tData
         Replace PO        With tPokazaniq
         Replace Vid_Dokum With "¡å®¤"
         Replace KOD       With '('+alltrim(str(tlic))+')'+alltrim(FNSI->NS)
         Replace USER      With STATION
         UNLOCK
      ENDIF
   ENDIF
   Select Obhod
   Set Key 32 To HelpWrite
EndDo
Set Key 32 To
Set Curs Off
Set Conf Off
Select Fnsi
Go FnsiRec

SetColor(Clr)
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL



PROCEDURE viewf6
local sel:=Select(),Rec:=RecNo(),cText:="",Scr:=Win_Save(),Desc
Select Obhod
go top
seek main->Lic_Schet
cText:=Str(Main->Lic_Schet)+" "+AllTrim(Main->Potrebitel)+Chr(13)+Chr(10)+;
       "    „ â       ®ª § ­¨ï       Š®­âà®««¥à"+Chr(13)+Chr(10)
Do While Licevoj==Main->Lic_Schet
   cText:=cText+" "+dtoc(Data)+"     "+Str(Pokazaniq)+"      "+Name+Chr(13)+Chr(10)
   SKIP
ENDDO
Desc:=FCreate(dDir+"Chastn.Gkv")
FWrite(Desc,cText)
FClose(Desc)
set cursor off
TxtView(dDir+"Chastn.Gkv")
set cursor on
//MemoEdit(cText,1,1,22,78,.f.,,300)
Select(Sel)
Go Rec
Win_Rest(Scr)
RETURN







Function OtchetObhod(nType)
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save()
Local Desc,CrLf:=Chr(13)+Chr(10),cText:="",Temp_,Kol_Kl
Local oDlg,aSizeDeskTop,aPos,oProgress

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "”®à¬¨à®¢ ­¨¥ ¢¥¤®¬®áâ¨ ®¡å®¤ " 
oDlg:SysMenu	 := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos						:= oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
Go Top
cText:="ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"+CrLf+;
       "³‹¨æ/áç³    ®âà¥¡¨â¥«ì     ³              €¤à¥á                ³   „ â    ³®ª § ­³     ®¬¥à     ³                    ³"+CrLf+;
       "³      ³                    ³                                   ³  ®¯« âë  ³       ³ ¯à¨¡®à  ãç¥â  ³                    ³"+CrLf
//       "ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+CrLf;

Do While !EOF()
   oProgress:increment()																				// Progress Bar Increment
   Select FNSI
   Seek Main->Lic_Schet
   IF Found()
      cText:=cText+"ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+CrLf

      cText:=cText+"³"+Str(Main->Lic_Schet,6)+"³"+Substr(Main->Potrebitel+Space(30),1,20)+"³"+;
             Padr(AllTrim(GetcUl(FNSI->KUL))+" "+;
             AllTrim(FNSI->Dm)+" "+AllTrim(FnSi->Kv),35," ")+;
             "³"+DTOC(FNSI->DOP)+"³"+if(nType==1,STR(FNSI->PO,7),"       ")+"³"+FNSI->NS+"³"+;
             Space(20)+"³"+CrLf
//             "³"+DTOC(FNSI->DOP)+"³"+STR(FNSI->PO,7)+"³"+DTOC(FNSI->DS5)+"³"+;

   ENDIF
   Select Main
   Skip
ENDDO
cText:=cText+"ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"+CrLf
Desc:=FCreate(DDir+ReportFile)
FWrite(Desc,cText)
Fclose(Desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL




Function NESKAKT()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),NoExit:=.T.,Clr:=SetColor()
Local Desc,cStr:="",nMonth:=Month_Menu(" ªâ ¢ ‘Š"),npp:=1
Local CrLf:=Chr(13)+Chr(10),Poisk
Local oDlg,aSizeDeskTop,aPos,oProgress
IF nMonth<1.and.nMonth>12
   Return NIL
ENDIF

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "”®à¬¨à®¢ ­¨¥  ªâ " 
oDlg:SysMenu	 := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos						:= oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
oProgress:create()
oProgress:minimum := 1
Desc:=FCreate(dDir+ReportFile)
Select Main
oProgress:maximum := RecCount()
//temp_=39/reccount()
//kol_kl=0
Go Top
FWrite(Desc,"ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄ¿"+CrLf)
FWrite(Desc,"³N ¯/¯ ³‡ ¢. N áç¥âç¨ª ³    â¨¯    ³ áç.³Š®­âà.³            Œ¥áâ® ãáâ ­®¢ª¨ áç¥âç¨ª                   ³ ’à-à ³"+CrLf)
FWrite(Desc,"³      ³               ³  áç¥âç¨ª  ³ª®íää³¯®ª §.³                                                      ³ â®ª  ³"+CrLf)
FWrite(Desc,"ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄ´"+CrLf)
Do While !EOF()
   oProgress:increment()																				// Progress Bar Increment
//   kol_kl=kol_kl+temp_
//   colorwin(12,21,12,21+kol_kl,'n/n')
   cStr:="³"+Str(npp,6)+"³"+Substr(DelString(main->potrebitel,"ˆ"),1,102)+;
         space(102-Len(Substr(DelString(main->potrebitel,"ˆ"),1,102)))+"³"+CrLf
   Select Licevoj
   Seek Main->Lic_Schet
   Do While Lic_sch==Main->Lic_Schet
      IF val(substr(licevoj->schetchik,3,7))>0.or.val(substr(licevoj->schetchik,2,7))>0
         cStr:=cStr+"³"+space(6)+"³"+Schetchik+"³"+Tip+"³"
         Select(nMonth)
         Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
         Seek Poisk
         cStr:=cStr+Str(Koeficient,5)+"³"+Str(Pokazaniq,6)+"³"
         Select Licevoj
         cStr:=cStr+Object1+" "+Adres+"³"+Tok+"³"+CrLf
      ENDIF
      Skip
   ENDDO
   FWrite(Desc,cStr)
   Select Main
   Skip
   npp:=npp+1
ENDDO
FWrite(Desc,"ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÙ"+CrLf)
FClose(Desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
Win_Rest(Scr)
Select(Sel)
Go Rec
Return Nil




Function NESKAKTDTKT()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),NoExit:=.T.,Clr:=SetColor()
Local Desc,cStr:="",nMonth:=Month_Menu(" ªâ ¢ ‘Š „â/Šâ"),npp:=1
Local CrLf:=Chr(13)+Chr(10),Poisk,nSaldo:=0
Local oDlg,aSizeDeskTop,aPos,oProgress
IF nMonth<1.and.nMonth>12
   Return NIL
ENDIF
//Obrabot("”®à¬¨à®¢ ­¨¥  ªâ  ¢ ‘Š")
oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "”®à¬¨à®¢ ­¨¥  ªâ  ¢ ‘Š" 
oDlg:SysMenu	 := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos						:= oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
oProgress:create()
Desc:=FCreate(dDir+ReportFile)
FWrite(Desc,"ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿"+CrLf)
FWrite(Desc,"³N ¯/¯ ³                      ®âà¥¡¨â¥«ì                                                                     ³  „¥¡¨â   ³  Šà¥¤¨â  ³"+CrLf)
FWrite(Desc,"ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´"+CrLf)
Select Main

oProgress:minimum := 1
oProgress:maximum := RecCount()
Go Top
Do While !EOF()
   oProgress:increment()																				// Progress Bar Increment
   nSaldo:=GetSaldo(Main->Lic_Schet,nMonth)
   cStr:="³"+Str(npp,6)+"³"+Substr(DelString(main->potrebitel,"ˆ"),1,80)+;
         space(102-Len(Substr(DelString(main->potrebitel,"ˆ"),1,80)))+"³"
   DO Case
      Case nSaldo==0
           cStr:=cStr+Space(10)+"³"+Space(10)+"³"+CrLf
      Case nSaldo>0
           cStr:=cStr+Space(10)+"³"+Str(nSaldo,10,2)+"³"+CrLf
      Case nSaldo<0
           cStr:=cStr+Str(nSaldo*-1,10,2)+"³"+Space(10)+"³"+CrLf
   ENDCASE
   FWrite(Desc,cStr)
   Skip
   npp:=npp+1
ENDDO
FWrite(Desc,"ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ"+CrLf)
FClose(Desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
Win_Rest(Scr)
Select(Sel)
Go Rec
Return Nil





Function ChastnStreet()
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,name
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
if (.not. file(Schet_Share+'Fkods.dbf'))
        sign(2)
        set color to (color_buf)
        restscreen(0,0,24,79,buff)
        return Nil
else
        if select()#106
                select 106
        endif
endif
endif
colorwin(6,0,21,79,'w/w')
set color to n/w
name='‘¯à ¢®ç­¨ª ã«¨æ'
@ 6,(79-len(name))/2 say name
declare zgl[2]
declare fil[2]
nm1=loarr('zgl','K®¤ ã«¨æë'," §¢ ­¨¥ ã«¨æë")
nm2=loarr('fil','KUL',"NUL")
inp='10'
go top
******* Begin make box
t1=7
l1=1
b1=20
r1=78
******** End make box
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
Return NIL
