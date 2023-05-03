FUNCTION Energy
Local Dbf:={}
Private MonthIn:=Month_Menu("§´Ô ¢Î°Æ‡† ¨•·ÔÊ† Ø‡®•¨† Ì≠•‡£®®")
IF MonthIn==0
   Return NIL
ENDIF
IF .not.File(Schet_Share+"NameIn.Dbf")
   AADD(DBF,{"Number","N",3,0})
   AADD(DBF,{"Name","C",30,0})
   DbCreate(Schet_Share+"NameIn.Dbf",DBF)
   DeleteFile(Schet_Share+"NameIn.Ntx")
ENDIF
IF .not.File(Schet_Share+"CountIn.Dbf")
   Dbf:={}
   AADD(DBF,{"Number","N",3, 0})
   AADD(DBF,{"Name","C",  10,0})
   AADD(DBF,{"Znak","N",  1,0})
   AADD(DBF,{"Koeff","N", 5, 0})
   AADD(DBF,{"Pok1","N",  10, 2})
   AADD(DBF,{"Pok2","N",  10, 2})
   AADD(DBF,{"Pok3","N",  10, 2})
   AADD(DBF,{"Pok4","N",  10, 2})
   AADD(DBF,{"Pok5","N",  10, 2})
   AADD(DBF,{"Pok6","N",  10, 2})
   AADD(DBF,{"Pok7","N",  10, 2})
   AADD(DBF,{"Pok8","N",  10, 2})
   AADD(DBF,{"Pok9","N",  10, 2})
   AADD(DBF,{"Pok10","N", 10, 2})
   AADD(DBF,{"Pok11","N", 10, 2})
   AADD(DBF,{"Pok12","N", 10, 2})
   AADD(DBF,{"Reaktivn", "L", 1, 0})
   DbCreate(Schet_Share+"CountIn.Dbf",DBF)
   DeleteFile(Schet_Share+"CountIn.Ntx")
ENDIF
Close All
IF .not.File(Schet_Share+"NameIn.Ntx")
   make_ind('0',schet_share+'NameIn.Dbf',schet_share+'NameIn.ntx','Number',,,.t.,.f.)
ENDIF
IF .not.File(Schet_Share+"CountIn.Ntx")
   make_ind('0',schet_share+'CountIn.Dbf',schet_share+'CountIn.ntx','Number',,,.t.,.f.)
ENDIF
Close All
LoadGos()
/*
    Select 40
    IF NetUse(Schet_Share+"NameIn.Dbf")
       Set Index To (Schet_Share+"NameIn.Ntx")
       Select 41
       IF NetUse(Schet_Share+"CountIn.Dbf")
          Set Index To (Schet_Share+"CountIn.Ntx")
       ELSE
          Close All
          Return NIL
       ENDIF
    ELSE
       Close All
       Return NIL
    ENDIF
*/
InEnergy()
Commit
Close All
Return NIL


*******************************
STATIC Function InEnergy
PRIVATE recbuf,ordbuf,buff,colorbuf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,inp
recbuf=recno()
ordbuf=indexord()
buff=win_save(1,0,maxrow(),maxcol())
colorbuf=setcolor()
if urov<1
   if (.not. file(Schet_Share+"NameIn.Dbf")) .or. (.not. file(Schet_Share+"NameIn.Ntx"))
      sign(2)
      set color to (colorbuf)
      win_rest(buff)
      return NIL
   else
      select 40
      if empty(fieldname(1))
          wosst=.T.
          al_box({"Å†ß† §†≠≠ÎÂ ≠• ÆØ‡•§•´•≠†"})
          return NIL
      endif
   endif
endif
devout("")
set color to n/w
@ 6, 0 clear to maxrow()-1,maxcol()
set color to n/w
@ 6, 14 say ' è ê à Ö å   ù ã Ö ä í ê é ù ç Ö ê É à à  á Ä '+MYUpper(Mesqc(MonthIn))
declare zgl[3]
declare fil[3]
nm1=loarr('zgl','N Ø/Ø','ç†®¨•≠Æ¢†≠®•',"è‡®¨•Á†≠®•")
nm2=loarr('fil','Number','Name',"Text")
inp='1000000000'
go top
t1=7
l1=1
b1=maxrow()-1
r1=maxcol()
*********
fsbrowse(7,1,23,78,'fil','zgl',inp,urov,kl)
devout("")
set color to (colorbuf)
set order to ordbuf
go recbuf
win_rest(buff)
return NIL
*********************************



*******************************
Function CountEnergy()
LOCAL MonthName:="Pok",PrevMonthName
LOCAL recbuf,ordbuf,buff,colorbuf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,inp,Sel:=Select()
recbuf=recno()
ordbuf=indexord()
buff=win_save(1,0,maxrow(),maxcol())
colorbuf=setcolor()
if urov<1
   if (.not. file(Schet_Share+"CountIn.Dbf")) .or. (.not. file(Schet_Share+"CountIn.Ntx"))
      sign(2)
      set color to (colorbuf)
      win_rest(buff)
      return NIL
   else
      select 41
      if empty(fieldname(1))
          wosst=.T.
          al_box({"Å†ß† §†≠≠ÎÂ ≠• ÆØ‡•§•´•≠†"})
          return NIL
      endif
   endif
endif
devout("")
set color to n/w
@ 6, 0 clear to maxrow()-1,maxcol()
set color to n/w
@ 6, 14 say ' ìÁ•‚ Ø‡®•¨† Ì´•™‚‡ÆÌ≠•‡£®® ØÆ '+Alltrim(NameIn->Name)+" ß† "+Mesqc(MonthIn)
declare zgl[6]
declare fil[6]
PrevMonthName:=MonthName+Alltrim(Str(IF(MonthIn-1>0,MonthIn-1,12)))
MonthName:=MonthName+Alltrim(Str(MonthIn))
nm1=loarr('zgl','N ·Á•‚Á®™†',"á≠†Á≠.","äÆÌ‰.",Mesqc(MonthIn),Mesqc(if(MonthIn-1>0,MonthIn-1,12)),"è‡®¨•Á†≠®•")
nm2=loarr('fil','Name',"Znak",'Koeff',MonthName,PrevMonthName,"Text")
inp='00000'
Set Filter To Number==NameIn->Number
go top
t1=7
l1=1
b1=maxrow()-1
r1=maxcol()
*********
fsbrowse(7,1,23,78,'fil','zgl',inp,urov,kl)
Set Filter To
go top
devout("")
Select(Sel)
set color to (colorbuf)
set order to ordbuf
go recbuf
win_rest(buff)
return NIL
*********************************


function EnergyMenu()
LOCAL old_col1:=setcolor(),screen:=win_save(6,28,24,79),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1
local first:=.T.
spisok:={" îÆ‡¨®‡Æ¢†≠®• ·Á•‚†",;
         " è„·‚Æ£‡†‰™† ",;
         " ë¨•≠† ‡†°ÆÁ•£Æ ¨•·ÔÊ     ",;
         " è‡Æ·¨Æ‚‡ Æ‚Á•‚† ",;
         "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ",;
         " è•Á†‚Ï Æ‚Á•‚†         "}
do while pos>0
        if file(Ddir+'otchet.gkv')
           is_choice:={.t.,.t.,.t.,.t.,.F.,.t.}
        else
           is_choice:={.t.,.t.,.t.,.t.,.F.,.F.}
        endif
        choice=vert_menu(spisok,"Ç†Ë• §•©·‚¢®•",is_choice,12,28,pos,'n/w,n/g,,,r/w',.F.)
        pos=choice
        wid=choice
        widsav:=wid
        if wid<8.and.wid>0
           pos=choice
        else
           pos=len(spisok)
        endif
        do case
                case wid=1
                     PrintEnergy()
                case wid=2
                     PrintBlankEnergy()
                case wid=3
                     Month_In:=Month_Menu("§´Ô ¢Î°Æ‡† ¨•·ÔÊ† Ø‡®•¨† Ì≠•‡£®®")
                     IF Month_In!=0
                        MonthIn:=Month_In
                        Al_Box({"å•·ÔÊ ®ß¨•≠•≠ ≠† "+Mesqc(MonthIn)})
                     ELSE
                        Al_Box({"å•·ÔÊ ≠• ®ß¨•≠•≠"})
                     ENDIF
                case wid=4
                     TxtView(DDir+ReportFile)
                case wid=len(spisok)
                        do print_fi
                otherwise
                        exit
        endcase
        wid=if(file(Ddir+'otchet.gkv'),Len(Spisok),widsav)
enddo
M->prev_rec=-1
win_rest(screen)
set color to n/w
@ 6, 14 say ' è ê à Ö å   ù ã Ö ä í ê é ù ç Ö ê É à à  á Ä '+MYUpper(Mesqc(MonthIn))
setcolor(old_col1)
return NIL


Function PrintEnergy()
LOCAL Desc:=Fcreate(DDir+ReportFile),Win:=Win_Save(),Rec:=Recno(),Kol_Kl:=0
Local CrLf:=Chr(13)+Chr(10),Act:=0,React:=0,LenString
SELECT 41; GO Top
Obrabot("îÆ‡¨®‡Æ¢†≠®• ·Á•‚†")
PredPok:="CountIn->Pok"+Alltrim(Str(IF(MonthIn>2,MonthIn-1,12)))
TekPok:= "CountIn->Pok"+Alltrim(Str(MonthIn))
FWrite(Desc,"⁄"+Replicate("ƒ",Len(Str(NameIn->Number)))+"¬"+Replicate("ƒ",Len(CountIn->Name))+"¬"+Replicate("ƒ",Len(Str(CountIn->Znak)))+"¬"+Replicate("ƒ",Len(Str(&PredPok)))+"¬"+;
      Replicate("ƒ",Len(Str(&TekPok)))+"¬"+Replicate("ƒ",Len(Str(CalculateEnergy(&TekPok,&PredPok))))+"¬"+;
      Replicate("ƒ",Len(Str(CountIn->Koeff)))+"¬"+Replicate("ƒ",Len(Str(CountIn->Koeff*CalculateEnergy(&TekPok,&PredPok))))+"ø"+CrLf)
FWrite(Desc,"≥"+Center("N",Len(Str(NameIn->Number))," ",.t.)+"≥"+Center("ç†®¨•≠.",Len(CountIn->Name)," ",.t.)+"≥"+Replicate("f",Len(Str(CountIn->Znak)))+"≥"+Center("è‡•§.ØÆ™",Len(Str(&PredPok))," ",.t.)+"≥"+;
      Center("í•™.ØÆ™",Len(Str(&TekPok))," ",.t.)+"≥"+Center("ê†ß≠Æ·‚Ï",Len(Str(CalculateEnergy(&TekPok,&PredPok)))," ",.t.)+"≥"+;
      Center("äÆÌ‰.",Len(Str(CountIn->Koeff))," ",.T.)+"≥"+Center("ê†·ÂÆ§",Len(Str(Koeff*CalculateEnergy(&TekPok,&PredPok)))," ",.t.)+"≥"+CrLf)
FWrite(Desc,"√"+Replicate("ƒ",Len(Str(NameIn->Number)))+"≈"+Replicate("ƒ",Len(CountIn->Name))+"≈"+Replicate("ƒ",Len(Str(CountIn->Znak)))+"≈"+Replicate("ƒ",Len(Str(&PredPok)))+"≈"+;
      Replicate("ƒ",Len(Str(&TekPok)))+"≈"+Replicate("ƒ",Len(Str(CalculateEnergy(&TekPok,&PredPok))))+"≈"+;
      Replicate("ƒ",Len(Str(CountIn->Koeff)))+"≈"+Replicate("ƒ",Len(Str(Koeff*CalculateEnergy(&TekPok,&PredPok))))+"¥"+CrLf)
LenString:=Len("√"+Replicate("ƒ",Len(Str(NameIn->Number)))+"≈"+Replicate("ƒ",Len(CountIn->Name))+"≈"+Replicate("ƒ",Len(Str(CountIn->Znak)))+"≈"+Replicate("ƒ",Len(Str(&PredPok)))+"≈"+;
                Replicate("ƒ",Len(Str(&TekPok)))+"≈"+Replicate("ƒ",Len(Str(CalculateEnergy(&TekPok,&PredPok))))+"≈"+;
                Replicate("ƒ",Len(Str(CountIn->Koeff)))+"≈"+Replicate("ƒ",Len(Str(Koeff*CalculateEnergy(&TekPok,&PredPok))))+"¥"+CrLf)-2
Select 40; Go Top
Do While .not.Eof()
   kol_kl=kol_kl+39/Reccount()
   colorwin(12,21,12,21+kol_kl,'n/n')
   FWrite(Desc,"≥"+Str(Number)+"≥"+Name+Space(LenString-1-Len("≥"+Str(Number)+"≥"+Name))+"≥"+CrLf)
   Select 41
   Seek NameIn->Number
   IF Found()
      Do While Number==NameIn->Number
         PredPok:="Pok"+Alltrim(Str(IF(MonthIn>1,MonthIn-1,12)))
         TekPok:="Pok"+Alltrim(Str(MonthIn))
         IF Val(Name)!=0
            IF .not.Empty(Koeff*CalculateEnergy(&TekPok,&PredPok))
               FWrite(Desc,"≥"+Space(Len(Str(NameIn->Number)))+"≥"+Name+"≥"+Str(Znak)+"≥"+Str(&PredPok)+"≥"+;
                     Str(&TekPok)+"≥"+Str(CalculateEnergy(&TekPok,&PredPok))+"≥"+;
                     Str(Koeff)+"≥"+Str(Koeff*CalculateEnergy(&TekPok,&PredPok))+"≥"+CrLf)
               If Reaktivn
                  React:=React+Koeff*CalculateEnergy(&TekPok,&PredPok)
               Else
                  Act:=Act+Koeff*CalculateEnergy(&TekPok,&PredPok)
               Endif
            ENDIF
         ELSE
            IF .not.Empty(Koeff*&TekPok)
               FWrite(Desc,"≥"+Space(Len(Str(NameIn->Number)))+"≥"+Name+"≥"+Str(Znak)+"≥"+Space(Len(Str(&PredPok)))+"≥"+;
                     Str(&TekPok)+"≥   "+Str(&TekPok)+"≥"+;
                     Str(Koeff)+"≥"+Str(Koeff*&TekPok)+"≥"+CrLf)
               If Reaktivn
                  React:=React+Koeff*&TekPok
               Else
                  Act:=Act+Koeff*&TekPok
               Endif
            ENDIF
         ENDIF
         Skip
      EndDo
   EndIF
   Select 40
   Skip
EndDo
SELECT 41; GO Top
FWrite(Desc,"¿"+Replicate("ƒ",Len(Str(NameIn->Number)))+"¡"+Replicate("ƒ",Len(CountIn->Name))+"¡"+Replicate("ƒ",Len(Str(CountIn->Znak)))+"¡"+Replicate("ƒ",Len(Str(&PredPok)))+"¡"+;
      Replicate("ƒ",Len(Str(&TekPok)))+"¡"+Replicate("ƒ",Len(Str(CalculateEnergy(&TekPok,&PredPok))))+"¡"+;
      Replicate("ƒ",Len(Str(CountIn->Koeff)))+"¡"+Replicate("ƒ",Len(Str(Koeff*CalculateEnergy(&TekPok,&PredPok))))+"Ÿ"+CrLf)
Fwrite(Desc,"Ä™‚®¢≠†Ô Ì≠•‡£®Ô   "+Str(Act)+CrLf)
Fwrite(Desc,"ê•†™‚®¢≠†Ô Ì≠•‡£®Ô "+Str(React)+CrLf)
Fclose(Desc)
Select 40
Go Rec
Win_Rest(Win)
Return NIL


Function CalculateEnergy(Pres,Last)
Local Energy:=0,MaxNumber:=Val("1"+CharRepl("1234567890",Alltrim(Str(Last)),"0"))
IF Pres>=Last
   Energy:=Pres-Last
ELSE
   Energy:=MaxNumber-Last+Pres
ENDIF
Return Energy


Function PrintBlankEnergy()
LOCAL Desc:=Fcreate(DDir+ReportFile),Win:=Win_Save(),Rec:=Recno(),Kol_Kl:=0
Local CrLf:=Chr(13)+Chr(10),Act:=0,React:=0,LenString
SELECT 41; GO Top
Obrabot("îÆ‡¨®‡Æ¢†≠®• Ø„·‚Æ£‡†‰™®")
PredPok:="CountIn->Pok"+Alltrim(Str(IF(MonthIn>2,MonthIn-1,12)))
TekPok:= "CountIn->Pok"+Alltrim(Str(MonthIn))
FWrite(Desc,"⁄"+Replicate("ƒ",Len(Str(NameIn->Number)))+"¬"+Replicate("ƒ",Len(CountIn->Name))+"¬"+Replicate("ƒ",Len(Str(CountIn->Znak)))+"¬"+Replicate("ƒ",Len(Str(&PredPok)))+"¬"+;
      Replicate("ƒ",Len(Str(&TekPok)))+"¬"+Replicate("ƒ",Len(Str(CalculateEnergy(&TekPok,&PredPok))))+"¬"+;
      Replicate("ƒ",Len(Str(CountIn->Koeff)))+"¬"+Replicate("ƒ",Len(Str(CountIn->Koeff*CalculateEnergy(&TekPok,&PredPok))))+"ø"+CrLf)
FWrite(Desc,"≥"+Center("N",Len(Str(NameIn->Number))," ",.t.)+"≥"+Center("ç†®¨•≠.",Len(CountIn->Name)," ",.t.)+"≥"+Replicate("f",Len(Str(CountIn->Znak)))+"≥"+Center("è‡•§.ØÆ™",Len(Str(&PredPok))," ",.t.)+"≥"+;
      Center("í•™.ØÆ™",Len(Str(&TekPok))," ",.t.)+"≥"+Center("ê†ß≠Æ·‚Ï",Len(Str(CalculateEnergy(&TekPok,&PredPok)))," ",.t.)+"≥"+;
      Center("äÆÌ‰.",Len(Str(CountIn->Koeff))," ",.T.)+"≥"+Center("ê†·ÂÆ§",Len(Str(Koeff*CalculateEnergy(&TekPok,&PredPok)))," ",.t.)+"≥"+CrLf)
FWrite(Desc,"√"+Replicate("ƒ",Len(Str(NameIn->Number)))+"≈"+Replicate("ƒ",Len(CountIn->Name))+"≈"+Replicate("ƒ",Len(Str(CountIn->Znak)))+"≈"+Replicate("ƒ",Len(Str(&PredPok)))+"≈"+;
      Replicate("ƒ",Len(Str(&TekPok)))+"≈"+Replicate("ƒ",Len(Str(CalculateEnergy(&TekPok,&PredPok))))+"≈"+;
      Replicate("ƒ",Len(Str(CountIn->Koeff)))+"≈"+Replicate("ƒ",Len(Str(Koeff*CalculateEnergy(&TekPok,&PredPok))))+"¥"+CrLf)
LenString:=Len("√"+Replicate("ƒ",Len(Str(NameIn->Number)))+"≈"+Replicate("ƒ",Len(CountIn->Name))+"≈"+Replicate("ƒ",Len(Str(CountIn->Znak)))+"≈"+Replicate("ƒ",Len(Str(&PredPok)))+"≈"+;
                Replicate("ƒ",Len(Str(&TekPok)))+"≈"+Replicate("ƒ",Len(Str(CalculateEnergy(&TekPok,&PredPok))))+"≈"+;
                Replicate("ƒ",Len(Str(CountIn->Koeff)))+"≈"+Replicate("ƒ",Len(Str(Koeff*CalculateEnergy(&TekPok,&PredPok))))+"¥"+CrLf)-2
Select 40; Go Top
Do While .not.Eof()
   kol_kl=kol_kl+39/Reccount()
   colorwin(12,21,12,21+kol_kl,'n/n')
   FWrite(Desc,"≥"+Str(Number)+"≥"+Name+Space(LenString-1-Len("≥"+Str(Number)+"≥"+Name))+"≥"+CrLf)
   Select 41
   Seek NameIn->Number
   IF Found()
      Do While Number==NameIn->Number
         PredPok:="Pok"+Alltrim(Str(IF(MonthIn>2,MonthIn-1,12)))
         TekPok:="Pok"+Alltrim(Str(MonthIn))
         IF .not.Empty(Koeff*CalculateEnergy(&TekPok,&PredPok))
            IF Val(Name)!=0
               FWrite(Desc,"≥"+Space(Len(Str(NameIn->Number)))+"≥"+Name+"≥"+Str(Znak)+"≥"+Str(&TekPok)+"≥"+;
                     Space(Len(Str(&TekPok)))+"≥"+Space(Len(Str(CalculateEnergy(&TekPok,&PredPok))))+"≥"+;
                     Str(Koeff)+"≥"+Space(Len(Str(Koeff*CalculateEnergy(&TekPok,&PredPok))))+"≥"+CrLf)
            ELSE
               FWrite(Desc,"≥"+Space(Len(Str(NameIn->Number)))+"≥"+Name+"≥"+Str(Znak)+"≥"+Space(Len(Str(&PredPok)))+"≥"+;
                     Space(Len(Str(&TekPok)))+"≥   "+Space(Len(Str(&TekPok)))+"≥"+;
                     Str(Koeff)+"≥"+Space(Len(Str(Koeff*&TekPok)))+"≥"+CrLf)
            ENDIF
         ENDIF
         Skip
      EndDo
   EndIF
   Select 40
   Skip
EndDo
SELECT 41; GO Top
FWrite(Desc,"¿"+Replicate("ƒ",Len(Str(NameIn->Number)))+"¡"+Replicate("ƒ",Len(CountIn->Name))+"¡"+Replicate("ƒ",Len(Str(CountIn->Znak)))+"¡"+Replicate("ƒ",Len(Str(&PredPok)))+"¡"+;
      Replicate("ƒ",Len(Str(&TekPok)))+"¡"+Replicate("ƒ",Len(Str(CalculateEnergy(&TekPok,&PredPok))))+"¡"+;
      Replicate("ƒ",Len(Str(CountIn->Koeff)))+"¡"+Replicate("ƒ",Len(Str(Koeff*CalculateEnergy(&TekPok,&PredPok))))+"Ÿ"+CrLf)
Fwrite(Desc,"Ä™‚®¢≠†Ô Ì≠•‡£®Ô   "+CrLf)
Fwrite(Desc,"ê•†™‚®¢≠†Ô Ì≠•‡£®Ô "+CrLf)
Fclose(Desc)
Select 40
Go Rec
Win_Rest(Win)
Return NIL
