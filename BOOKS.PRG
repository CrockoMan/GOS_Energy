// ¡« áâì 18 - ª­¨£  ¯à®¤ ¦
// ¡« áâì 19 - ª­¨£  ¯®ªã¯®ª
function writesfkniga(dogpotr,lic,dat,sum,nds,typ,mesyac)
LOCAL sel:=select(),rec:=recno(),potrstring,innstring
LOCAL Writed:=.F.
POTRSTRING=delstring(MAIN->POTREBITEL,"ˆ")
INNSTRING=appendstring(MAIN->POTREBITEL,"ˆ")
INNSTRING=alltrim(substr(INNSTRING,4,11))
select 18
IF NetAppend(10)
   replace number with DOGPOTR
   replace lic_schet with LIC
   replace data with DAT
   replace wsegosnds with SUM
   replace summands with NDS
   replace type with TYP
   replace potrebitel with POTRSTRING
   replace inn with INNSTRING
   replace okonx with MAIN->OKONX
   replace okpo with MAIN->OKPO
   replace month with mesyac
   Writed=.T.
   unlock
ELSE
     al_box({"‡ ¯¨áì ¢ ª­¨£ã ¯à®¤ ¦  ­¥  ¯à®¨§¢¥¤¥­ .",;
             "‚ë ®âª § «¨áì ®¦¨¤ âì ®á¢®¡®¦¤¥­¨ï ¡ §ë",;
             "‡ ¯¨è¨â¥ ¤ ­­ë¥ ¯« â¥¦ª¨ ¢àãç­ãî."})
ENDIF
go recno()
select(sel)
go rec
Return Writed


// à®á¬®âà ª­¨£¨ ¯à®¤ ¦ ¨ ª­¨£¨ ¯®ªã¯®ª
// 18 ®¡« áâì - ¯à®¤ ¦¨
// 19 ®¡« áâì - ¯®ªã¯ª¨
FUNCTION ViewProdag(type)
local show,spisok,is_ch,stri,Buff,ColorBuf,sel:=select()
PRIVATE recbuf,ordbuf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,inp,GloMes,Cho
Kniga:=""
type:=if(type==NIL,1,type)
recbuf=recno()
ordbuf=indexord()
buff=win_save()
colorbuf=setcolor()
if urov<1
        if (.not. file(schet_share+'SFKNIGA.DBF')) .or.;
           (.not. file(schet_share+'SFKNIGA.ntx')) .or.;
           (.not. file(schet_share+'SFKNIGAp.DBF')).or.;
           (.not. file(schet_share+'SFKNIGAp.ntx'))
                sign(2)
                select(sel); go recbuf; set order to ordbuf
                setcolor(colorbuf)
                win_rest(buff)
                return NIL
        else
             if type=1
                select 18
                Kniga:="SFKNIGA"
             else
                select 19
                Kniga:="SFKNIGAP"
             endif
                if empty(fieldname(1))
                        wosst=.T.
                        al_box({" §  ¤ ­­ëå ­¥ ®¯à¥¤¥«¥­ "})
                        return NIL
                endif
        endif
endif
spisok:={" «¥ªâà®í­¥à£¨ï+¥­ï+®¢ëè¥­­ ï+€¢ ­á  ",;
         " «¥ªâà®í­¥à£¨ï                  ",;
         " ¥­ï                            ",;
         " ®¢ëè¥­­ ï                      ",;
         " €¢ ­á      "}
is_ch:={.t.,.t.,.t.,.t.}
cho=vert_menu(spisok,"‚¨¤ ª­¨£¨ ¯à®¤ ¦",is_ch,5,20,1,'n/w,n/g,,,r/w',.F.)
if cho==0
   PREV_REC:=-1
   RET_VAL:=2
   select(sel)
   set order to ordbuf
   go recbuf
   setcolor(colorbuf)
   win_rest(buff)
endif
mesyac:=Month_Menu()
GloMes:=Mesyac
if mesyac=0
   PREV_REC:=-1
   RET_VAL:=2
   select(sel)
   set order to ordbuf
   go recbuf
   setcolor(colorbuf)
   win_rest(buff)
   return NIL
endif
   colorwin(2,1,15,78,"n+/n")
   @ 3,2 clear to 14,77
   colorwin(3,2,14,77,"w/w")
   colorwin(1,1,1,78,"n/w")
   set color to n/w
   @ 9,25 say "Š­¨£a "+if(type=1,"à®¤ ¦","®ªã¯®ª")+" á®àâ¨àã¥âáï..."
   do case
      case cho=1
           stri="«¥ªâà®í­¥à£¨¨, ¥­¨ ¨ ®¢ëè¥­­®©"
           set filter to &KNIGA->MONTH==mesyac
      case cho=2
           stri="«¥ªâà®í­¥à£¨¨"
           set filter to &KNIGA->TYPE==0.and.&KNIGA->MONTH==mesyac
      case cho=3
           stri="¥­¨"
           set filter to &KNIGA->TYPE==1.and.&KNIGA->MONTH==mesyac
      case cho=4
           stri="®¢ëè¥­­®©"
           set filter to &KNIGA->TYPE==2.and.&KNIGA->MONTH==mesyac
      case cho=5
           stri="€¢ ­á"
           set filter to &KNIGA->TYPE==3.and.&KNIGA->MONTH==mesyac
   endcase
   IF Type==1
   		Set Order To 2
   ENDIF
   IF Type==1
   		seek main->lic_schet
   ENDIF
   Set Order To 1
   If !found()
      go top
   Else
      Go Recno()
   Endif
   if type=1
      @ 1,0  say center('Š­¨£  ¯à®¤ ¦ '+stri+" "+dbfilter(),78," ",.t.)
   else
      @ 1,0  say center('Š­¨£  ¯®ªã¯®ª '+stri+" "+dbfilter(),78," ",.t.)
   endif
   declare zgl[11]
   declare fil[11]
   nm1=loarr('zgl','N ¤®ªã¬','‹¨æ¥¢®©','„ â ',' ® â à ¥ ¡ ¨ â ¥ « ì ','ˆ  ',"Š•","Š",'‚á¥£® á „‘',"‘ã¬¬  „‘","’¨¯","Œ¥á")
   nm2=loarr('fil','lic_schet',"number",'data','potrebitel','inn','okonx','okpo','wsegosnds','summands',"type","Month")
   IF Type==1
   	  inp='12000000000'
   ELSE
   	  inp='10000000000'
   ENDIF
   t1=2
   l1=1
   b1=14
   r1=77
   *********
   fsbrowse(2,1,14,77,'fil','zgl',inp,urov,kl)
   if cho>0
      set filter to
   endif
   go top
PREV_REC:=-1
RET_VAL:=2
select(sel)
set order to ordbuf
go recbuf
setcolor(colorbuf)
win_rest(buff)
return NIL





FUNCTION bookpay(dogpotr,lic,dat,sum,nds,typ,mesyac)
LOCAL potrstring,innstring
NDS=IF(NDS==NIL,ROUND(SUM*SCHET_NDS/(SCHET_NDS+100),DECIMAL),NDS)
POTRSTRING=delstring(main->potrebitel,"ˆ")
INNSTRING=appendstring(main->potrebitel,"ˆ")
INNSTRING:=alltrim(substr(INNSTRING,4,11))
MESYAC:=IF(Mesyac==NIL,month(New_date+1),Mesyac)
replace number with DOGPOTR
replace lic_schet with LIC
replace data with DAT
replace wsegosnds with SUM
replace summands with NDS
replace type with TYP
replace potrebitel with POTRSTRING
replace inn with INNSTRING
replace okonx with MAIN->OKONX
replace okpo with MAIN->OKPO
replace month with mesyac
Return NIL






// ®¨áª ¤¢®©­¨ª®¢ ¢ ª­¨£¥ ¯à®¤ ¦.
FUNCTION FoundRec(sLic,sMon,sTyp)
Local IsFound:=0,Old_sel:=select(),rec:=recno(),rec18,aData[3]
AFill(aData,0)
select 18
rec18:=recno()
set order to 2
go top
seek slic
IF Found()
   DO WHILE SfKniga->Number==sLic
      IF Month==sMon.and.Type==sTyp
         aData[1]:=Lic_Schet
         aData[2]:=Data
         aData[3]:=WsegoSNds
         exit
      ENDIF
      skip
   ENDDO
ENDIF
set order to 1
go rec18
select(Old_sel)
go rec
Return aData




Function BookPaySchet()
Local myScr:=Win_Save(),myClr:=SetColor(),MRec:=Recno(),tRec,mSel:=Select()
Private PlMonth,Plat_Dat,TownString,GruzPol,TypePay:=""
PlMonth:=Mesqc(GloMes)
plat_dat:=alltrim(str(day((data))))+"  "+mesqc(month(data),1)+;
          ' '+alltrim(str(year(data)))
Select Main
tRec:=Recno()
Seek SfKniga->Number
select 77
seek main->lic_schet
if found()
   TownString=Substr(appendstring(upper(licevoj->bank),upper("£.")),3)
   TownString=Substr(townstring,1,1)+lower(substr(townstring,2))
   If Atnum("€€€",Upper(Licevoj->Bank))>0
      Gruzpol:=Alltrim(Alltrim(SfKniga->Potrebitel)+" "+Alltrim(Main->Adress))
   Else
      Gruzpol:=Alltrim(Alltrim(LICEVOJ->Object1)+" "+Alltrim(LICEVOJ->Object2)+Alltrim(Main->Adress))
   Endif
else
   townstring="."
   gruzpol:=alltrim(main->adress)
endif
Select Main
Go tRec
Do Case
   Case Cho=2
        Report(DDir+"SFNew.Rpt",DDir+ReportFile,140)
   Case Cho=3
        Report(DDir+"SFNewP.Rpt",DDir+ReportFile,140)
   Case Cho=4
        Report(DDir+"SFNewH.Rpt",DDir+ReportFile,140)
   Case Cho=5
        Report(DDir+"SFNewA.Rpt",DDir+ReportFile,140)
EndCase
IF Al_Box({"â¯¥ç â âì áç¥â-ä ªâãàã"},2)==1
   Do Print_Fi
//   Copy_(DDir+ReportFile,"prn")
EndIF
Select(mSel); Go MRec
SetColor(myClr); Win_Rest(myScr)
Return NIL







// Š­¨£  ¯®ªã¯®ª
Function MakeKnigaP()
Local Month:=Month_Menu("ä®à¬¨à®¢ ­¨ï ª­¨£¨ ¯®ªã¯®ª"),Scr:=Win_Save(),Clr:=SetColor(),nPay:=0,nDolg:=0
Local Rec:=Recno(),Sel:=Select(),Opl,Kol_Kl:=0,oDlg,aSizeDeskTop,aPos,oProgress,RecCount:=0
Local aOpl:={},lFirst:=.T.,I,nLic,nMonth,cDat:=""
Private PlMonth:=Mesqc(Month),cNumPlat:=""
IF Month==0
   Return NIL
ENDIF

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := AppDesktop():currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := "”®à¬¨à®¢ ­¨¥ ª­¨£¨ ¯®ªã¯®ª"
oDlg:SysMenu     := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos                                            := oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
oProgress:create()
oProgress:minimum := 1

Do While Lic_Schet<99999.and..not.EOF()
   RecCount:=RecCount+1
   Skip
EndDo
oProgress:maximum := RecCount

Go Top
Do While Lic_Schet<99999.and..not.EOF()
   oProgress:increment()                                                                                                                                                          // Progress Bar Increment
   nPay:=CalckMinusPay(Month,Lic_Schet)
   cDat:=GetPayDate(Month,Lic_Schet)
   IF nPay>0
//      PutBookSale(0,Month,Lic_Schet,nPay,cDat)
        PutBookSale(0,Month,Lic_Schet,nPay,ctod(Alltrim(Str(LastDayOm(Month)))+"."+Alltrim(Str(Month))+"."+Alltrim(Str(Year(New_date)))),cDat)
   ENDIF
   Skip
EndDo
oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
oDlg:destroy()
DeleteFile(DDir+ReportFile)
Select(Sel);   Go Rec
SetColor(Clr); Win_Rest(Scr)
Return NIL






Function GetPayDate(nMonth,nLic)
Local dDat,cDat:="",I,Sel:=Select(),Rec:=RecNo(),nCount:=0
FOR i=1 to nMonth
		Month_:=Schet_Share+"o"+AllTrim(Str(i,2))+".dbf"
		NameInd:=Schet_Share+"o"+AllTrim(Str(i,2))+".ntx"
		Select 43
		NetUse(Month_)
		Set Index to &NameInd
		Seek nLic
		DO While Licevoj==nLIC
   		IF nCount==0
   			 dDat:=Data
   			 nCount:=nCount+1
   		ELSE
   			 IF Data>dDat
   			 		dDat:=Data
   			 ENDIF
   		ENDIF
   		Skip
		ENDDO
		Close
NEXT
cDat:=IF(nCount==0,"",DTOC(dDat))
Select(Sel)
Go Rec
Return cDat






Function CalckMinusPay(nMonth,nLic)
Local Sel:=Select(),Rec:=RecNo(),Sum:=0,Month_,NameInd
Month_:=Schet_Share+"o"+AllTrim(Str(nMonth,2))+".dbf"
NameInd:=Schet_Share+"o"+AllTrim(Str(nMonth,2))+".ntx"
select 44
NetUse(Month_)
Set Index to &NameInd
//go top
Seek nLic
DO While Licevoj==nLIC
   Sum:=Sum+IF(Summa<0,-1*Summa,0)
	 Skip
ENDDO
Select(Sel)
Go Rec
Return Sum






Function PutBookSale(_TypeOplata,_Month,_Licevoj,_Summa,_Data,_cStr)
Local Rec:=Recno(),Sel:=Select(),Num,MyRec,TmpRec
_cStr:=IF(_cStr==NIL,"",_cStr)
Select Main
TmpRec:=RecNo()
Seek _Licevoj
Select 19
IF FileLock(0)
   Append Blank
   MyRec:=RecNo()
   Go Bottom
   Num:=Lic_Schet+1
   Go Myrec
   Replace Lic_Schet With Num
   Replace Number With _Licevoj
   Replace Data With _Data
   Replace WsegoSNds With _Summa
   Replace SummaNds With Round(_Summa*Schet_Nds/(100+Schet_Nds),2)
   Replace Type With _TypeOplata
   Replace Month With _Month
   Replace NumPlat With _cStr
   Replace Potrebitel With Delstring(Main->Potrebitel,"ˆ")
   Replace Inn With Alltrim(Substr(appendstring(MAIN->POTREBITEL,"ˆ"),4,11))
   Replace Okonx With Main->Okonx
   Replace Okpo With  Main->Okpo
   Unlock
ENDIF
Select Main; GoBase(TmpRec)
Select(Sel); GoBase(Rec)
Return NIL








Function ReportBookSale()
Local Sel:=Select(),Rec:=RecNo(),Desc,cStr:="",CrLf:=Chr(13)+Chr(10)
Local oDlg,aSizeDeskTop,aPos,oProgress

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "¡à ¡®â ­®" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()

go top
nMonth:=Month
cStr:=cStr+center("Š  ˆ ƒ €  "+if(select()==18,"   „ € †","  Š “   Š"),130," ")+crlf
cStr:=cStr+"®ªã¯ â¥«ì "+alltrim(SchetNameOrg)+crlf
cStr:=cStr+"ˆ¤¥­â¨ä¨ª æ¨®­­ë© ­®¬¥à ¯®ªã¯ â¥«ï "+alltrim(schetInn)+"/"+AllTrim(SchetKpp)+crlf
cStr:=cStr+"®ªã¯ª  §  "+mesqc(nmonth)+" "+AllTrim(Str(Year(New_date)))+"£. "+crlf
cStr:=cStr+"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ¿"+crlf
cStr:=cStr+"³  „ â  ¨ ­®¬¥à   ³„ â   ®¯« âë³„ â   ¯à¨­ïâ¨ï³       ¨¬¥­®¢ ­¨¥ ¯à®¤ ¢æ               ³ˆ¤¥­â¨ä¨ª æ¨³              ³‘âà ­  ¯à®¨á- ³‚á¥£® ¯®ªã¯®ª,³      ‚ â®¬ ç¨á«¥ ¯®ªã¯ª¨      ³    ‚ â®¬ ç¨á«¥ ¯®ªã¯ª¨    ³ ‚ â®¬ ç¨á«¥ ¯®ªã¯ª¨ ³ ‚ â®¬ ç¨á«¥ ¯®ªã¯ª¨ ³®ªã¯ª¨³"+crlf
cStr:=cStr+"³     áç¥â        ³   áç¥â -   ³­  ãç¥â â®¢ - ³                                         ³®­­ë© ­®¬¥à ³              ³å®¦¤¥­¨ï â®¢ -³¢ª«îç ï „‘   ³      ®¡« £ ¥¬ë¥ ­ «®£®¬       ³    ®¡« £ ¥¬ë¥ ­ «®£®¬     ³ ®¡« £ ¥¬ë¥ ­ «®£®¬  ³ ®¡« £ ¥¬ë¥ ­ «®£®¬  ³®á¢®¡®¦³"+crlf
cStr:=cStr+"³    ä ªâãàë      ³  ä ªâãàë   ³à®¢ (à ¡®â,   ³                                         ³ ¯à®¤ ¢æ    ³              ³à . ®¬¥à     ³              ³          ¯® áâ ¢ª¥            ³        ¯® áâ ¢ª¥          ³     ¯® áâ ¢ª¥       ³     ¯® áâ ¢ª¥       ³¤ ¥¬ë¥ ³"+crlf
cStr:=cStr+"³  ¯à®¤ ¢æ        ³  ¯à®¤ ¢æ   ³ãá«ã£) ¨¬ãé¥- ³                                         ³            ³              ³ â ¬®¦¥­­®©   ³              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³  ®â   ³"+crlf
cStr:=cStr+"³                 ³            ³áâ¢¥­­ëå ¯à ¢ ³                                         ³            ³              ³ ¤¥ª« à æ¨¨   ³              ³              18%              ³           10%             ³           0%        ³          20%        ³­ «®£  ³"+crlf
cStr:=cStr+"³                 ³            ³              ³                                         ³            ³              ³              ³              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ³       ³"+crlf
cStr:=cStr+"³                 ³            ³              ³                                         ³            ³              ³              ³              ³   ‘â®¨¬®áâì   ³   ‘ã¬¬  „‘   ³‘â®¨¬®áâì   ³   ‘ã¬¬  „‘  ³‘â®¨¬®áâì  ³‘ã¬¬  „‘³‘â®¨¬®áâì  ³‘ã¬¬  „‘³       ³"+crlf
cStr:=cStr+"³                 ³            ³              ³                                         ³            ³              ³              ³              ³   ¯®ªã¯®ª ¡¥§ ³               ³¯®ªã¯®ª ¡¥§ ³              ³¯®ªã¯®ª ¡¥§³         ³¯®ªã¯®ª ¡¥§³         ³       ³"+crlf
cStr:=cStr+"³                 ³            ³              ³                                         ³            ³              ³              ³              ³   „‘         ³               ³  „‘       ³              ³  „‘      ³         ³   „‘     ³         ³       ³"+crlf
cStr:=cStr+"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄ´"+crlf
cStr:=cStr+"³        1        ³     2      ³      3       ³               4                         ³     5a     ³      5¡      ³      6       ³       7      ³       8       ³       8¡      ³     9      ³       9¡     ³     10    ³   10¡   ³     11    ³   11¡   ³  12   ³"+crlf
cStr:=cStr+"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄ´"+crlf
Do While !EOF()
   	oProgress:increment()																				// Progress Bar Increment
		cStr:=cStr+"³"+dtoc(data)+" "+str(lic_schet,6,0)+"³ "+Substr(NumPlat+Space(10),1,10)+" ³  "+dtoc(data)+"  ³"+;
               potrebitel+''+str(number,6,0)+"³"+substr(inn,1,12)+;
        "³"+substr("§  "+Mesqc(nMonth)+space(11),1,14)+"³              ³"+;
        str(wsegosnds,14,Decimal)+"³"+IF(sfkniga->type#3,str((wsegosnds-summands),15,2),Space(15))+;
      	"³"+str(summands,15,2)+;
        "³            ³              ³           ³         ³           ³         ³       ³"+CrLf
	
	SKIP
ENDDO
cStr:=cStr+"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÙ"+crlf

Desc:=fcreate(Ddir+"otchet.gkv")
FWrite(Desc,cStr)
FClose(Desc)

oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()

Select(Sel)
Go Rec
Return NIL





Function PutBookPay(_TypeOplata,_Month,_Licevoj,_Summa,_Data,_cStr)
Local Rec:=Recno(),Sel:=Select(),Num,MyRec,TmpRec
_cStr:=IF(_cStr==NIL,"",_cStr)
Select Main
TmpRec:=RecNo()
Seek _Licevoj
Select 18
IF FileLock(0)
   Append Blank
   MyRec:=RecNo()
   Go Bottom
   Num:=Lic_Schet+1
   Go Myrec
   Replace Lic_Schet With Num
   Replace Number With _Licevoj
   Replace Data With _Data
   Replace WsegoSNds With _Summa
   Replace SummaNds With Round(_Summa*Schet_Nds/(100+Schet_Nds),2)
   Replace Type With _TypeOplata
   Replace Month With _Month
   Replace NumPlat With _cStr
   Replace Potrebitel With Delstring(Main->Potrebitel,"ˆ")
   Replace Inn With Alltrim(Substr(appendstring(MAIN->POTREBITEL,"ˆ"),4,11))
   Replace Okonx With Main->Okonx
   Replace Okpo With  Main->Okpo
   Unlock
ENDIF
Select Main; GoBase(TmpRec)
Select(Sel); GoBase(Rec)
Return NIL










// Š­¨£  ¯à®¤ ¦ ¯® à¥ «¨§ æ¨¨
Function MakeSfKniga
Local Month:=Month_Menu("ä®à¬¨à®¢ ­¨ï ª­¨£¨ ¯à®¤ ¦"),Scr:=Win_Save(),Clr:=SetColor(),nPay:=0,nDolg:=0
Local Rec:=Recno(),Sel:=Select(),Opl,Kol_Kl:=0,oDlg,aSizeDeskTop,aPos,oProgress,RecCount:=0
Local aOpl:={},lFirst:=.T.,I,nLic,nMonth
Private PlMonth:=Mesqc(Month),cNumPlat:=""
IF Month==0
   Return NIL
ENDIF

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := AppDesktop():currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := "”®à¬¨à®¢ ­¨¥ ª­¨£¨ ¯à®¤ ¦"
oDlg:SysMenu     := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos                                            := oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
oProgress:create()
oProgress:minimum := 1

Do While Lic_Schet<99999.and..not.EOF()
   RecCount:=RecCount+1
   Skip
EndDo
oProgress:maximum := RecCount

Go Top
Do While Lic_Schet<99999.and..not.EOF()
   oProgress:increment()                                                                                                                                                          // Progress Bar Increment
   nPay:=CalckPay(Month,Lic_Schet,.f.)
   Opl:=GetSum(Lic_schet,Month) //;  Opl:=Opl+Round(Opl*Schet_Nds/100,Decimal)
   nDolg:=GetDolg(Lic_Schet,IF(Month-1=0,13,Month-1))
   IF Opl!=0
      PutBookPay(0,Month,Lic_Schet,Opl,ctod(Alltrim(Str(LastDayOm(Month)))+"."+Alltrim(Str(Month))+"."+Alltrim(Str(Year(New_date)))))
   ENDIF
//-------------------------------- § ¯¨áì ¢ ­¨£ã ¯à®¤ ¦  ¢ ­á®¢
   lFirst:=.T.
   nLic:=Lic_Schet
   nMonth:=Month
//                              nPay:=CalckPay(nMonth,nLic,.f.)
//                              Opl:=SfKniga->Wsegosnds
//                              nDolg:=GetDolg(nLic,IF(nMonth-1=0,13,nMonth-1))
   Opl:=Opl+nDolg

/*IF nLic==52
         @ 1,0 Say nPay-Opl
ENDIF           */
   IF nPay-Opl>0
      aOpl:=aGetOpl(nLic,nMonth)
      For i=1 To Len(aOpl)
/*IF nLic==52
         @ 2,0 Say i
         @ 2, 10 Say Len(aOpl)
         @ 3,0 Say aOpl[i]
ENDIF           */
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
/*IF nLic==52
Inkey(0)
ENDIF           */
      NEXT
   ENDIF
//--------------------------------
   Skip
EndDo
oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
oDlg:destroy()
DeleteFile(DDir+ReportFile)
Select(Sel);   Go Rec
SetColor(Clr); Win_Rest(Scr)
Return NIL











FUNCTION Calc_Nds(SUM)
RETURN ROUND(SUM*SCHET_NDS/(SCHET_NDS+100),DECIMAL)









//----------------------------------------------- Š­¨£  ¯à®¤ ¦ ¯® ®â£àã§ª¥
FUNCTION MakeKnigaSF()
LOCAL scre:=win_save(),color:=setcolor(),sel:=select(),rec:=recno(),ls
LOCAL snum:=0,enum:=99999,sdat:=New_date-30,edat:=New_date+1,temp_,kol_kl
LOCAL CrLf:=chr(13)+chr(10),itog1:=0,itog2:=0,itog3:=0,nmonth,p1,p2,ps,ntx
LOCAL itog4:=0,itog5:=0,itog6:=0,itog7:=0,itog8:=0,itog9:=0,OldFilter:=DbFilter()
LOCAL page:=0,string:=0,pagelen:=42,first:=.t.,s1:=-1,innstring,potrstring
LOCAL lic_uniq:={},sum_opl:=0,mesyac,IsCentury,VsegoProdag:=0,nType,oDlg,aSizeDeskTop,oProgress
NMonth:=SfKniga->Month
nType :=SfKniga->Type
// à¨ ­ ¦ â¨¨ ES‘ - ¢ëå®¤¨¬ ¨§ ä®à¬¨à®¢ ­¨ï
if nmonth==0
   setcolor(color)
   win_rest(scre)
   select(sel)
   go rec
   prev_rec=-1
   ret_val=2
   RETURN NIL
else

   do case
      case sfkniga->type==0
           p2:=schet_share+'o'+alltrim(str(int(nmonth)))+".dbf"
           KnigaString:=" í«¥ªâà®í­¥à£¨ï"
      case sfkniga->type==1
           p2:=schet_share+'p'+alltrim(str(int(nmonth)))+".dbf"
           KnigaString:=" % ¡ ­ª "
      case sfkniga->type==2
           p2:=schet_share+'h'+alltrim(str(int(nmonth)))+".dbf"
           KnigaString:=" ¯®¢ëè¥­­ ï"
      case sfkniga->type==3
           p2:=schet_share+'a'+alltrim(str(int(nmonth)))+".dbf"
           KnigaString:="  ¢ ­á"
   endcase
endif
//obrabot("”®à¬¨à®¢ ­¨¥ ®âç¥â  ¯® ª­¨£¥")

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := AppDesktop():currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := " áç¥â ª­¨£¨ ¯à®¤ ¦"
oDlg:SysMenu     := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos                                            := oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()


go top
desc:=fcreate(Ddir+"otchet.gkv")
fwrite(desc,center("Š  ˆ ƒ €  "+if(select()==18,"   „ € †","  Š “   Š"),130," ")+crlf)
fwrite(desc," «®£®¯« â¥«ìé¨ª-¯à®¤ ¢¥æ "+alltrim(SchetNameOrg)+crlf)
fwrite(desc,"ˆ¤¥­â¨ä¨ª æ¨®­­ë© ­®¬¥à ­ «®£®¯« â¥«ìé¨ª -¯à®¤ ¢æ  "+alltrim(schetInn)+"/"+AllTrim(SchetKpp)+crlf)
fwrite(desc,"à®¤ ¦  §  "+mesqc(nmonth)+" "+AllTrim(Str(Year(New_date)))+"£. "+KnigaString+crlf)
fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿"+crlf)
fwrite(desc,"³ „ â  ¨ ­®¬¥à  ³       ¨¬¥­®¢ ­¨¥ ¯®ªã¯ â¥«ï            ³ˆ¤¥­â¨ä¨ª æ¨³              ³     „ â  ®¯« âë     ³‚á¥£® ¯à®¤ ¦, ³      ‚ â®¬ ç¨á«¥ ¯à®¤ ¦¨      ³   ‚ â®¬ ç¨á«¥ ¯à®¤ ¦¨   ³‚ â®¬ ç¨á«¥ ¯à®¤ ¦¨³   ‚ â®¬ ç¨á«¥ ¯à®¤ ¦¨   ³à®¤ ¦¨,³"+crlf)
fwrite(desc,"³    áç¥â       ³                                         ³®­­ë© ­®¬¥à ³              ³    áç¥âë-ä ªâãàë    ³¢ª«îç ï „‘   ³      ®¡« £ ¥¬ë¥ ­ «®£®¬       ³   ®¡« £ ¥¬ë¥ ­ «®£®¬    ³®¡« £ ¥¬ë¥ ­ «®£®¬ ³   ®¡« £ ¥¬ë¥ ­ «®£®¬    ³®á¢®¡®¦-³"+crlf)
fwrite(desc,"³   ä ªâãàë     ³                                         ³ ¯®ªã¯ â¥«ï ³              ³       ¯à®¤ ¢æ       ³              ³          ¯® áâ ¢ª¥            ³       ¯® áâ ¢ª¥         ³     ¯® áâ ¢ª¥     ³       ¯® áâ ¢ª¥         ³¤ ¥¬ë¥  ³"+crlf)
fwrite(desc,"³ ¯®áâ ¢é¨ª     ³                                         ³            ³              ³                     ³              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´  ®â    ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³                     ³              ³              18%              ³           10%           ³        0%         ³           20%           ³­ «®£   ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³                     ³              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ´        ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³                     ³              ³   ‘â®¨¬®áâì   ³   ‘ã¬¬  „‘   ³‘â®¨¬®áâì   ³   ‘ã¬¬  „‘³                   ³ ‘â®¨¬®áâì  ³ ‘ã¬¬  „‘  ³        ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³                     ³              ³   ¯à®¤ ¦ ¡¥§  ³               ³¯à®¤ ¦ ¡¥§  ³            ³                   ³ ¯à®¤ ¦ ¡¥§ ³            ³        ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³                     ³              ³   „‘         ³               ³„‘         ³            ³                   ³ „‘        ³            ³        ³"+crlf)
fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"+crlf)
fwrite(desc,"³      1        ³               2                         ³     3      ³      3a      ³           3¡        ³       4      ³       5a      ³       5¡      ³    6a      ³       6¡   ³         7         ³    8a      ³       8¡   ³   9    ³"+crlf)
fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"+crlf)

//fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿"+crlf)
//fwrite(desc,"³      1        ³               2                         ³     3      ³      3a      ³       4      ³       5a      ³       5¡      ³    6a      ³       6¡   ³         7         ³    8a      ³       8¡   ³   9    ³"+crlf)
//fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"+crlf)
string=17
first=.t.
go top
do while !eof()
   if month=nmonth.and.nType==Type
      VsegoProdag:=VsegoProdag+1
//   if lic_schet>=snum.and.lic_schet<=enum.and.data>=sdat.and.data<=edat
      if at(upper("Šà¥¤¨â"),upper(potrebitel))>0
         s1:=lic_schet
         exit
      endif
   endif
   skip
enddo
go top

MySum:=0
IsCentury:=CSetCent()
Set Century Off
//temp_=39/VsegoProdag
//kol_kl=0
do while lic_schet<99999.and..not.eof()
   if string>=pagelen
      page++
      string=4
      fwrite(desc,"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ"+crlf)

      fwrite(desc,chr(12)+space(165)+"‘âà ­¨æ  "+alltrim(str(page))+crlf)
      fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿"+crlf)
			fwrite(desc,"³      1        ³               2                         ³     3      ³      3a      ³          3¡         ³       4      ³       5a      ³       5¡      ³    6a      ³       6¡   ³         7         ³    8a      ³       8¡   ³   9    ³"+crlf)
			fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"+crlf)
   endif
   if month==nmonth.and.Type==nType
//   if lic_schet>=snum.and.lic_schet<=enum.and.data>=sdat.and.data<=edat
            oProgress:increment()                                                                                                                                                               // Progress Bar Increment
//      kol_kl=kol_kl+temp_
//      colorwin(12,21,12,21+kol_kl,'n/n')
      fwrite(desc,"³"+dtoc(data)+" "+str(lic_schet,6,0)+"³"+;
      potrebitel+''+str(number,6,0)+"³"+substr(inn,1,12)+;
      "³"+substr("§  "+Mesqc(nMonth)+space(11),1,14)+"³"+;
      IF(Type==3,Substr(NumPlat+Space(20),1,21),Space(21))+"³"+str(wsegosnds,14,Decimal)+;
      "³"+IF(sfkniga->type#3,str((wsegosnds-summands),15,2),Space(15))+"³"+str(summands,15,2)+"³"+;
      "            ³            ³                   ³            ³            ³        ³"+CrLf)
      itog1=itog1+wsegosnds; itog2=itog2+(wsegosnds-summands)
      itog3=itog3+summands
      ls=number
      MySum:=MySum+WsegoSNds
      string++

//      select(ps)
   endif
   skip
enddo
IF IsCentury
   Set Century On
ELSE
   Set Century Off
ENDIF

itog3=Round(Itog1*Schet_Nds/(100+Schet_Nds),2)
itog2=itog1-itog3
fwrite(desc,"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ"+crlf)
//fwrite(desc,+space(20)+"‚á¥£®:"+space(60)+str(itog1,15,2)+" "+;
//            str(itog2,15,2)+" "+str(itog3,15,2)+" "+str(itog4,14,Decimal)+;
//            " "+str(itog5,14,Decimal)+" "+str(itog6,14,Decimal)+crlf+chr(12))
fwrite(desc,+space(20)+"‚á¥£®:"+space(60)+str(itog1,15,2)+" "+;
            IF(nType#3,str(itog2,15,2),Space(15))+" "+str(itog3,15,2)+crlf+crlf)
FWrite(Desc,"      ƒ« ¢­ë© ¡ãå£ «â¥à                   _________________         "+NameBuh+CrLf+CrLf+CrLf)
FWrite(Desc,"      ˆ­¤¨¢¨¤ã «ì­ë© ¯à¥¤¯à¨­¨¬ â¥«ì      _________________         "+CrLf+CrLf)
FWrite(Desc,"¥ª¢¨§¨âë á¢¨¤¥â¥«ìáâ¢  ® £®áã¤ àáâ¢¥­­®© à¥£¨áâà æ¨¨ ¨­¤¨¢¨¤ã «ì£® ¯à¥¤¯à¨­¨¬ â¥«ï"+CrLf+CrLf)
FWrite(Desc,"___________________________________________________________________________________"+CrLf)
fclose(desc)
oProgress:destroy()                                                                                                                                                             // Progress Bar Increment
oDlg:destroy()
setcolor(color)
win_rest(scre)
select(sel)
Set Filter To &OldFilter
go rec
prev_rec=-1
ret_val=2
return NIL








/*

//----------------------------------------------- Š­¨£  ¯à®¤ ¦ ¯® ®¯« â¥
FUNCTION MakeKnigaSF()
LOCAL scre:=win_save(),color:=setcolor(),sel:=select(),rec:=recno(),ls
LOCAL snum:=0,enum:=99999,sdat:=New_date-30,edat:=New_date+1,temp_,kol_kl
LOCAL CrLf:=chr(13)+chr(10),itog1:=0,itog2:=0,itog3:=0,nmonth,p1,p2,ps,ntx
LOCAL itog4:=0,itog5:=0,itog6:=0,itog7:=0,itog8:=0,itog9:=0,OldFilter:=DbFilter()
LOCAL page:=0,string:=0,pagelen:=42,first:=.t.,s1:=-1,innstring,potrstring
LOCAL lic_uniq:={},sum_opl:=0,mesyac,IsCentury,VsegoProdag:=0,nType
//if al_box({"‘ä®à¬¨à®¢ âì ®âç¥â ¯® ª­¨£¥ "+if(select()=18,"¯à®¤ ¦","¯®ªã¯®ª")},2)==2
//   Return NIL
//endif
//nmonth:=month_menu()
NMonth:=SfKniga->Month
nType :=SfKniga->Type
// à¨ ­ ¦ â¨¨ ES‘ - ¢ëå®¤¨¬ ¨§ ä®à¬¨à®¢ ­¨ï
if nmonth==0
   setcolor(color)
   win_rest(scre)
   select(sel)
   go rec
   prev_rec=-1
   ret_val=2
   RETURN NIL
else
   ps:=select()
   if .not.file(Ddir+'opl.dbf')
      copy_(schet_share+"o"+alltrim(str(nmonth))+'.dbf',Ddir+"opl.dbf")
   endif
   obrabot("‘¡®à ¢á¥å ®¯« â §  "+mesqc(nmonth))
   p1=Ddir+'opl.dbf'
   ntx:=Ddir+'opl.ntx'
   select 120
   use &p1 EXCLUSIVE alias opl1
   index on licevoj to &ntx
   zap

   do case
      case sfkniga->type==0
           p2:=schet_share+'o'+alltrim(str(int(nmonth)))+".dbf"
           KnigaString:=" í«¥ªâà®í­¥à£¨ï"
      case sfkniga->type==1
           p2:=schet_share+'p'+alltrim(str(int(nmonth)))+".dbf"
           KnigaString:=" % ¡ ­ª "
      case sfkniga->type==2
           p2:=schet_share+'h'+alltrim(str(int(nmonth)))+".dbf"
           KnigaString:=" ¯®¢ëè¥­­ ï"
      case sfkniga->type==3
           p2:=schet_share+'a'+alltrim(str(int(nmonth)))+".dbf"
           KnigaString:="  ¡®­¨à®¢ ­­ ï"
   endcase
   select 121
   netuse(p2,,,'opl2')
   go top

   temp_=39/reccount()
   kol_kl=0
   do while !eof()
      kol_kl=kol_kl+temp_
      colorwin(12,21,12,21+kol_kl,'n/n')
      select opl1
      @ 1,0 say RecCount()
      IF Opl2->Licevoj<99999
         IF NetAppend()
            replace opl1->vid_dokum with opl2->vid_dokum
            replace opl1->num_dokum with opl2->num_dokum
            replace opl1->licevoj with opl2->licevoj
            replace opl1->summa with if(atnum("‚‡‚",upper(opl2->vid_dokum))#0,opl2->summa*-1,opl2->summa)
            replace opl1->data with opl2->data
            replace opl1->reestr with opl2->reestr
            UNLOCK
         ENDIF
      ENDIF
      select opl2
      skip
   enddo
   Clear Typeahead
//   @ 1,0 say "2"
//   Inkey(1)
//   select opl2
   Select 121
   use
   select(ps)
   Set Filter To
   Go Top
endif
obrabot("”®à¬¨à®¢ ­¨¥ ®âç¥â  ¯® ª­¨£¥")
//@ 1,0 say "1"
//inkey(1)
//al_box({"1"})
go top
desc:=fcreate(Ddir+"otchet.gkv")
fwrite(desc,center("Š  ˆ ƒ €  "+if(select()==18,"   „ € †","  Š “   Š"),130," ")+crlf)
fwrite(desc," «®£®¯« â¥«ìé¨ª-¯à®¤ ¢¥æ "+alltrim(schet_poluch)+crlf)
fwrite(desc,"ˆ¤¥­â¨ä¨ª æ¨®­­ë© ­®¬¥à ­ «®£®¯« â¥«ìé¨ª -¯à®¤ ¢æ  "+alltrim(schet_naz1)+crlf)
fwrite(desc,"à®¤ ¦  §  "+mesqc(nmonth)+" "+AllTrim(Str(Year(New_date)))+"£. "+KnigaString+crlf)
fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"+crlf)
fwrite(desc,"³„ â  ¨ ­®¬¥à   ³       ¨¬¥­®¢ ­¨¥ ¯®ªã¯ â¥«ï            ³ˆ¤¥­â¨ä¨ª æ¨³              ³‚á¥£® ¯à®¤ ¦, ³      ‚ â®¬ ç¨á«¥ ¯à®¤ ¦¨      ³              — áâ¨ç­ ï ®¯« â               ³"+crlf)
fwrite(desc,"³   áç¥â        ³                                         ³®­­ë© ­®¬¥à ³              ³¢ª«îç ï „‘   ³      ®¡« £ ¥¬ë¥ ­ «®£®¬       ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+crlf)
fwrite(desc,"³  ä ªâãàë      ³                                         ³ ¯®ªã¯ â¥«ï ³              ³              ³          ¯® áâ ¢ª¥            ³‘ã¬¬  ¡¥§ „‘ ³     „‘      ³ ‘ã¬¬  á „‘  ³"+crlf)
fwrite(desc,"³¯®áâ ¢é¨ª      ³                                         ³            ³              ³              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´              ³              ³              ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³              ³              18%              ³              ³              ³              ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´              ³              ³              ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³              ³   ‘â®¨¬®áâì   ³   ‘ã¬¬  „‘   ³              ³              ³              ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³              ³   ¯à®¤ ¦ ¡¥§  ³               ³              ³              ³              ³"+crlf)
fwrite(desc,"³               ³                                         ³            ³              ³              ³   „‘         ³               ³              ³              ³              ³"+crlf)
fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+crlf)
fwrite(desc,"³      1        ³               2                         ³     3      ³      3a      ³       4      ³       5a      ³       5¡      ³       8      ³       9      ³      10      ³"+crlf)
fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+crlf)
string=17
first=.t.
go top
do while !eof()
   if month=nmonth.and.nType==Type
      VsegoProdag:=VsegoProdag+1
//   if lic_schet>=snum.and.lic_schet<=enum.and.data>=sdat.and.data<=edat
      if at(upper("Šà¥¤¨â"),upper(potrebitel))>0
         s1:=lic_schet
         exit
      endif
   endif
   skip
enddo
go top
if s1==-1
   al_box({"‘ã¬¬  ªà¥¤¨â®àáª®© § ¤®«¦¥­­®áâ¨ ­¥ ­ ©¤¥­ "})
endif
MySum:=0
IsCentury:=CSetCent()
Set Century Off
temp_=39/VsegoProdag
kol_kl=0
do while lic_schet<99999.and..not.eof()
   if string>=pagelen
      page++
      string=4
      fwrite(desc,"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"+crlf)
      fwrite(desc,chr(12)+space(165)+"‘âà ­¨æ  "+alltrim(str(page))+crlf)
      fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"+crlf)
      fwrite(desc,"³      1        ³               2                         ³     3      ³      3a      ³       4      ³       5a      ³       5¡      ³       8      ³       9      ³      10      ³"+crlf)
      fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+crlf)
   endif
   if month==nmonth.and.Type==nType
//   if lic_schet>=snum.and.lic_schet<=enum.and.data>=sdat.and.data<=edat
      kol_kl=kol_kl+temp_
      colorwin(12,21,12,21+kol_kl,'n/n')
      fwrite(desc,"³"+dtoc(data)+" "+str(lic_schet,6,0)+"³"+;
      potrebitel+''+str(number,6,0)+"³"+substr(inn,1,12)+;
      "³"+substr("§  "+Mesqc(nMonth)+space(11),1,14)+"³"+str(wsegosnds,14,Decimal)+;
      "³"+str((wsegosnds-summands),15,2)+"³"+str(summands,15,2)+"³")
      itog1=itog1+wsegosnds; itog2=itog2+(wsegosnds-summands)
      itog3=itog3+summands
      ls=number
      MySum:=MySum+WsegoSNds
      select opl1
      seek ls
      if found()
         itog7:=0
         Do While LICEVOJ==LS
            itog7:=itog7+summa
            itog4:=itog4+(summa-calc_nds(summa))
            itog5:=itog5+calc_nds(summa)
            itog6:=itog6+summa
            skip
         Enddo
            fwrite(desc,str(itog7-calc_nds(itog7),14,2)+"³"+;
                        str(calc_nds(itog7),14,2)+"³"+str(itog7,14,2)+"³"+crlf)
// “¤ «¥­¨¥ ­ ©¤¥­­®© ®¯« âë...      ----------------------vvvvvvvvvvvvvvvvvv
         do while .t.
            seek ls
            if found()
               delete
            else
               exit
            endif
        enddo
//---------------------------------------------------------^^^^^^^^^^^^^^^^^^
      else
         fwrite(desc,"              ³              ³              ³"+crlf)
      endif
      string++
      select(ps)
   endif
   skip
enddo
IF IsCentury
   Set Century On
ELSE
   Set Century Off
ENDIF
//----------------------------------------------- ‚ë¢®¤ ¯¥à¢®© áâà®ª¨ ¥é¥ à §
IF S1>0
   seek s1
   fwrite(desc,"³"+dtoc(data)+" "+str(lic_schet,4,0)+"³"+;
          potrebitel+''+str(number,6,0)+"³"+substr(inn,1,12)+;
          "³"+space(14)+"³"+str(-1*wsegosnds,14,Decimal)+;
          "³"+str(-1*(wsegosnds-summands),15,2)+"³"+str(-1*summands,15,2)+"³")
   fwrite(desc,"              ³              ³              ³"+crlf)
   itog1=itog1-wsegosnds; itog2=itog2-wsegosnds-summands
   itog3=itog3-summands
ENDIF
//------------------------------------------------------- ®¤¡¨¢ª  à¥§ã«ìâ â 
itog2=itog1-itog3
select opl1
set unique on
index on licevoj to &ntx
go top
do while !eof()
   aadd(lic_uniq,licevoj)
   skip
enddo
set unique off
index on licevoj to &ntx
if reccount()>0
   if al_box({" ©¤¥­ë ®¯« âë, ­¥ ¢®è¥¤è¨¥ ¢ ª­¨£ã"},2,{" â¯¥ç â âì "," ‡ ª®­ç¨âì "})==1
    temp_=(39-kol_kl)/len(lic_uniq)
    for Mystep=1 to len(lic_uniq)
      kol_kl=kol_kl+temp_
      colorwin(12,21,12,21+kol_kl,'n/n')
      go top
      sum_opl:=0
      do while !eof()
         if lic_uniq[Mystep]==licevoj
            itog4:=itog4+(summa-calc_nds(summa))
            itog5:=itog5+calc_nds(summa)
            itog6:=itog6+summa
            itog7:=itog7+summa
            itog9:=itog9+summa
            sum_opl=sum_opl+summa
         endif
         skip
      enddo
      seek main->lic_schet
      IF string>=pagelen
         page++
         string=4
         fwrite(desc,"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"+CrLf)
         fwrite(desc,chr(12)+space(165)+"‘âà ­¨æ  "+alltrim(str(page))+crlf)
         fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"+CrLf)
         fwrite(desc,"³      1        ³               2                         ³     3      ³      3a      ³       4      ³       5a      ³       5¡      ³       8      ³       9      ³      10      ³"+CrLf)
         fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+CrLf)
      ENDIF
         select main
         seek lic_uniq[Mystep]
         if .not.found()
            fwrite(desc,"³               ³                                         ³            ³       ³      ³              ³               ³               ³")
         else
            INNSTRING=appendstring(MAIN->POTREBITEL,"ˆ")
            INNSTRING=alltrim(substr(INNSTRING,4,11))
            INNSTRING=substr(INNSTRING+space(12-len(INNSTRING)),1,12)
            POTRSTRING=delstring(MAIN->POTREBITEL,"ˆ")
            potrstring=substr(potrstring+space(35-len(potrstring)),1,35)
            fwrite(desc,"³"+dtoc(opl1->data)+" "+space(4)+"³"+;
            potrstring+str(opl1->licevoj,6,0)+"³"+substr(innstring,1,12)+;
            "³              ³"+;
            "              ³               ³               ³")
         endif
         select opl1
         fwrite(desc,str(sum_opl-calc_nds(sum_opl),14,2)+"³"+;
                     str(calc_nds(sum_opl),14,2)+"³"+;
                     str(sum_opl,14,2)+"³"+crlf)
         string++
    next
   endif
endif
fwrite(desc,"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"+crlf)
fwrite(desc,+space(20)+"‚á¥£®:"+space(60)+str(itog1,15,2)+" "+;
            str(itog2,15,2)+" "+str(itog3,15,2)+" "+str(itog4,14,Decimal)+;
            " "+str(itog5,14,Decimal)+" "+str(itog6,14,Decimal)+crlf+chr(12))
fclose(desc)
//select opl1;  use               // ‡ ªàëâ¨¥ ¡ §ë á®¡à ­­ëå ®¯« â
select 120
close
select 121
close
setcolor(color)
win_rest(scre)
select(sel)
//DbSetFilter(OldFilter)
Set Filter To &OldFilter
go rec
prev_rec=-1
ret_val=2
return NIL
*/






/*
//------------------------------------------- Š­¨£  ¯à®¤ ¦ ¯® ®¯« â¥
Function MakeSfKniga
Local Month:=Month_Menu("ä®à¬¨à®¢ ­¨ï ª­¨£¨ ¯à®¤ ¦"),Scr:=Win_Save(),Clr:=SetColor()
Local Rec:=Recno(),Sel:=Select(),Opl,Kol_Kl:=0
Private PlMonth:=Mesqc(Month)
IF Month==0
   Return NIL
ENDIF
Obrabot("‡ ¯®«­¥­¨¥ ª­¨£¨ ¯à®¤ ¦ §  "+Mesqc(Month))
Go Top
Fclose(Fcreate(DDir+ReportFile))
Do While Lic_Schet<99999.and..not.EOF()
   @ 1,0 say Lic_Schet
   Kol_Kl=Kol_Kl+39/reccount()
   ColorWin(12,21,12,21+kol_kl,'n/n')
   Opl:=CalckPay(Month,Lic_Schet,.f.)
   IF Opl!=0
      PutBookPay(0,Month,Lic_Schet,Opl,ctod(Alltrim(Str(LastDayOm(Month)))+"."+Alltrim(Str(Month))+"."+Alltrim(Str(Year(New_date)))))
      Report(DDir+"SfNew.Rpt",DDir+"TmpFile.Tmp",150)
      AppendFile(DDir+"TmpFile.Tmp",DDir+ReportFile,,,,.F.)
   ENDIF
   Opl:=CalckPay(Month,Lic_Schet,.f.,2)
   IF Opl!=0
      PutBookPay(1,Month,Lic_Schet,Opl,ctod(Alltrim(Str(LastDayOm(Month)))+"."+Alltrim(Str(Month))+"."+Alltrim(Str(Year(New_date)))))
      Report(DDir+"SfNewp.Rpt",DDir+"TmpFile.Tmp",150)
      AppendFile(DDir+"TmpFile.Tmp",DDir+ReportFile,,,,.F.)
   ENDIF
   Opl:=CalckPay(Month,Lic_Schet,.f.,3)
   IF Opl!=0
      PutBookPay(2,Month,Lic_Schet,Opl,ctod(Alltrim(Str(LastDayOm(Month)))+"."+Alltrim(Str(Month))+"."+Alltrim(Str(Year(New_date)))))
      Report(DDir+"SfNewH.Rpt",DDir+"TmpFile.Tmp",150)
      AppendFile(DDir+"TmpFile.Tmp",DDir+ReportFile,,,,.F.)
   ENDIF
   Opl:=CalckPay(Month,Lic_Schet,.f.,4)
   IF Opl!=0
      PutBookPay(3,Month,Lic_Schet,Opl,ctod(Alltrim(Str(LastDayOm(Month)))+"."+Alltrim(Str(Month))+"."+Alltrim(Str(Year(New_date)))))
      Report(DDir+"SfNewA.Rpt",DDir+"TmpFile.Tmp",150)
      AppendFile(DDir+"TmpFile.Tmp",DDir+ReportFile,,,,.F.)
   ENDIF
   Skip
EndDo
DeleteFile(DDir+ReportFile)
Select(Sel);   Go Rec
SetColor(Clr); Win_Rest(Scr)
Return NIL
*/