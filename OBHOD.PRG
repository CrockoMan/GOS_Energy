Function WriteObhod()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),NoExit:=.T.,Clr:=SetColor()
Local FNSIRec

Select FNSI
FNSIRec:=RecNo()

Select Obhod

set color to w+/b,gr+/b,,,w+/b
ColorWin(14,07,23,78,"n+/n")
@ 13,06 SAY "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캠"
@ 14,06 SAY "�  꽑�� �▼�쩆                     �"+space(35)+"�"
@ 15,06 SAY "�  꽡．¡�                         �"+space(35)+"�"
@ 16,06 SAY "�  룼첓쭬�⑨                       �"+space(35)+"�"
@ 17,06 SAY "�  뒶�循�カ��                      �"+space(35)+"�"
@ 18,06 SAY "�                                  �"+space(35)+"�"
@ 19,06 SAY "�                                  �"+space(35)+"�"
@ 20,06 SAY "�                                  �"+space(35)+"�"
@ 21,06 SAY "�                                  �"+space(35)+"�"
@ 22,06 SAY "突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠"
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
      IF Al_Box({"귗� 쩆��瑜 �□젩��젺�"},2,{" 뜢� "," 꽑 "})==2
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
         Replace Vid_Dokum With "렊若�"
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
       "    꽑��      룼첓쭬�⑨       뒶�循�カ��"+Chr(13)+Chr(10)
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
oDlg:title    := "뵰席ⓣ�쥯��� ´ㄾМ飡� �▼�쩆" 
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
cText:="旼컴컴컫컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴�"+CrLf+;
       "퀖ⓩ/淞�    룼循ⅰⓥ�レ     �              �ㅰα                �   꽑��   퀛�첓쭬��     뜮Д�     �                    �"+CrLf+;
       "�      �                    �                                   �  ��쳽瞬  �       � �黍‘�� 晨β� �                    �"+CrLf
//       "쳐컴컴컵컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컵컴컴컴컵컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴캑"+CrLf;

Do While !EOF()
   oProgress:increment()																				// Progress Bar Increment
   Select FNSI
   Seek Main->Lic_Schet
   IF Found()
      cText:=cText+"쳐컴컴컵컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컵컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴�"+CrLf

      cText:=cText+"�"+Str(Main->Lic_Schet,6)+"�"+Substr(Main->Potrebitel+Space(30),1,20)+"�"+;
             Padr(AllTrim(GetcUl(FNSI->KUL))+" "+;
             AllTrim(FNSI->Dm)+" "+AllTrim(FnSi->Kv),35," ")+;
             "�"+DTOC(FNSI->DOP)+"�"+if(nType==1,STR(FNSI->PO,7),"       ")+"�"+FNSI->NS+"�"+;
             Space(20)+"�"+CrLf
//             "�"+DTOC(FNSI->DOP)+"�"+STR(FNSI->PO,7)+"�"+DTOC(FNSI->DS5)+"�"+;

   ENDIF
   Select Main
   Skip
ENDDO
cText:=cText+"읕컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴�"+CrLf
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
Local Desc,cStr:="",nMonth:=Month_Menu("젶� � 뜚몜"),npp:=1
Local CrLf:=Chr(13)+Chr(10),Poisk
Local oDlg,aSizeDeskTop,aPos,oProgress
IF nMonth<1.and.nMonth>12
   Return NIL
ENDIF

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "뵰席ⓣ�쥯��� 젶��" 
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
FWrite(Desc,"旼컴컴컫컴컴컴컴컴컴컴컫컴컴컴컴컴컫컴컴컫컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴�"+CrLf)
FWrite(Desc,"쿙 �/� 퀒젪. N 淞β葉첓�    殊�    퀜졹�.퀕��循.�            뙠飡� 信�젺�˚� 淞β葉첓                  � 믞-� �"+CrLf)
FWrite(Desc,"�      �               �  淞β葉첓 나�庄牙��첓�.�                                                      � 獸첓 �"+CrLf)
FWrite(Desc,"쳐컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컵컴컴컵컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴�"+CrLf)
Do While !EOF()
   oProgress:increment()																				// Progress Bar Increment
//   kol_kl=kol_kl+temp_
//   colorwin(12,21,12,21+kol_kl,'n/n')
   cStr:="�"+Str(npp,6)+"�"+Substr(DelString(main->potrebitel,"닄�"),1,102)+;
         space(102-Len(Substr(DelString(main->potrebitel,"닄�"),1,102)))+"�"+CrLf
   Select Licevoj
   Seek Main->Lic_Schet
   Do While Lic_sch==Main->Lic_Schet
      IF val(substr(licevoj->schetchik,3,7))>0.or.val(substr(licevoj->schetchik,2,7))>0
         cStr:=cStr+"�"+space(6)+"�"+Schetchik+"�"+Tip+"�"
         Select(nMonth)
         Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
         Seek Poisk
         cStr:=cStr+Str(Koeficient,5)+"�"+Str(Pokazaniq,6)+"�"
         Select Licevoj
         cStr:=cStr+Object1+" "+Adres+"�"+Tok+"�"+CrLf
      ENDIF
      Skip
   ENDDO
   FWrite(Desc,cStr)
   Select Main
   Skip
   npp:=npp+1
ENDDO
FWrite(Desc,"읕컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컨컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴�"+CrLf)
FClose(Desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
Win_Rest(Scr)
Select(Sel)
Go Rec
Return Nil




Function NESKAKTDTKT()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),NoExit:=.T.,Clr:=SetColor()
Local Desc,cStr:="",nMonth:=Month_Menu("젶� � 뜚몜 꾟/듼"),npp:=1
Local CrLf:=Chr(13)+Chr(10),Poisk,nSaldo:=0
Local oDlg,aSizeDeskTop,aPos,oProgress
IF nMonth<1.and.nMonth>12
   Return NIL
ENDIF
//Obrabot("뵰席ⓣ�쥯��� 젶�� � 뜚몜")
oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "뵰席ⓣ�쥯��� 젶�� � 뜚몜" 
oDlg:SysMenu	 := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos						:= oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
oProgress:create()
Desc:=FCreate(dDir+ReportFile)
FWrite(Desc,"旼컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컫컴컴컴컴컴�"+CrLf)
FWrite(Desc,"쿙 �/� �                      룼循ⅰⓥ�レ                                                                     �  꽖〃�   �  듺ⅳⓥ  �"+CrLf)
FWrite(Desc,"쳐컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컵컴컴컴컴컴�"+CrLf)
Select Main

oProgress:minimum := 1
oProgress:maximum := RecCount()
Go Top
Do While !EOF()
   oProgress:increment()																				// Progress Bar Increment
   nSaldo:=GetSaldo(Main->Lic_Schet,nMonth)
   cStr:="�"+Str(npp,6)+"�"+Substr(DelString(main->potrebitel,"닄�"),1,80)+;
         space(102-Len(Substr(DelString(main->potrebitel,"닄�"),1,80)))+"�"
   DO Case
      Case nSaldo==0
           cStr:=cStr+Space(10)+"�"+Space(10)+"�"+CrLf
      Case nSaldo>0
           cStr:=cStr+Space(10)+"�"+Str(nSaldo,10,2)+"�"+CrLf
      Case nSaldo<0
           cStr:=cStr+Str(nSaldo*-1,10,2)+"�"+Space(10)+"�"+CrLf
   ENDCASE
   FWrite(Desc,cStr)
   Skip
   npp:=npp+1
ENDDO
FWrite(Desc,"읕컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컨컴컴컴컴컴�"+CrLf)
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
name='뫍�젪�嶺Ø 乘ⓩ'
@ 6,(79-len(name))/2 say name
declare zgl[2]
declare fil[2]
nm1=loarr('zgl','K�� 乘ⓩ�',"뜝㎖젺�� 乘ⓩ�")
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
