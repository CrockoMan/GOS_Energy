/*function limits()
LOCAL old_col1:=setcolor(),screen:=win_save(7,24,24,79),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1
local first:=.T.
spisok:={ " ��c���� �����                 ",;
          " ������� ����� �ᥬ ����.      ",;
          " ��ᯥ���� ����� �����         ",;
          " ��ᯥ���� ����� ����� �� ���. ",;
          " ���᮪ ����⮢ �� ���ॡ�⥫�   ",;
          " ������ ����⮢ �� ���ॡ�⥫�   ",;
          " ���ᮢ�� ���४�஢�� ����⮢   ",;
          " ������� ������ �ᥬ ���ॡ�⥫�     ",;
          "����������������������������������",;
          " ����� ����                    "}
prev_rec=prev_rec-1
do while pos>0
   if file(Ddir+'otchet.gkv')
      pos=len(spisok)
      is_choice:={.t.,.t.,.t.,.t.,.t.,.t.,.t.,.F.,.t.}
   else
      is_choice:={.t.,.t.,.t.,.t.,.t.,.t.,.t.,.F.,.F.}
   endif
   if first
      pos=1
      first=.F.
   endif
   choice=vert_menu(spisok,"������",is_choice,7,24,pos,'n/w,n/g,,,r/w',.F.)
        pos=choice
        wid=choice
        widsav:=wid
        if wid<len(spisok).and.wid>0
                deletefile(Ddir+"otchet.gkv")
                pos=choice
        else
                pos=len(spisok)
        endif
        do case
                case wid=1
                     makelimit()
                case wid=2
                     limitpaket()
                case wid=3
                     PrintOneLimit(2)
                case wid=4
                     PrintOneLimit(1)
                case wid=5
                     printlimit()
                case wid=6
                     allprintlimit()
                case wid=7
                     MasKorLim()
                case wid=8
                     DivideLim()
                case wid=len(spisok)
                        copy_(Ddir+'otchet.gkv',"prn")
                otherwise
                        exit
        endcase
        wid=if(file(Ddir+'otchet.gkv'),8,widsav)
enddo
win_rest(screen)
setcolor(old_col1)
return NIL
*/

Function AddRashodBudget()
Local Sel:=Select(),Rec:=RecNo(),Win:=Win_Save(),Desc,CrLf:=Chr(13)+Chr(10)
Local Mon:=Month_Menu("��� �롮� ��⭨��� � �ॢ�襭���"),GetRash:=0
Local GetLim:=0,Kol_Kl:=0
IF Mon==0
   Return NIL
ENDIF
Win:=Obrabot("�롮ઠ ��⭨��� � ॢ�襭���")
Desc:=FCreate(DDir+ReportFile)
FWrite(Desc," �/�"+Center("���ॡ�⥫�",30," ",.t.)+" "+"�ॢ�襭��"+CrLf)
Go Top
Do While !EOF()
   kol_kl=kol_kl+39/RecCount()
   colorwin(12,21,12,21+kol_kl,'n/n')
   IF Bit_Test(BitStr,1)
      GetRash:=GetRashod(Main->Lic_Schet,Mon)
      GetLim:=GetLimit(Mon,Main->Lic_Schet)*1000
      IF GetRash>GetLim
         FWrite(Desc,Str(Lic_Schet,4,0)+" "+Substr(DelString(Potrebitel,"���"),1,30)+" "+Str(GetRash-GetLim,7,0)+CrLf)
      ENDIF
   ENDIF
   Skip
ENDDO
FClose(Desc)
Select(Sel)
Go Rec
Win_Rest(Win)
Return NIL


function PrintOneLimit(Type)
LOCAL sel:=select(),rec:=recno(),month
PRIVATE kvartal,LIM_STR1,LIM_STR2,LIM_STR3,FIRM,DRESS,MonthName
month:=month_menu()
if month==0
   return NIL
endif
select licevoj
seek main->lic_schet
DRESS:=LICEVOJ->ADRES
select limit
seek main->lic_schet
MonthName:=Mesqc(Month(New_date),1)
IF Type==1.or.Type==2
   Type=90
EndIF
do case
   case month>=1.and.month<=3
        kvartal="I"
        LIM_STR1:="������     "+str(limit->jan,7,2)
        LIM_STR2:="�������    "+str(limit->feb,7,2)
        LIM_STR3:="����       "+str(limit->mac,7,2)
        Select Limit2
        IF !Empty(Jan1).or.!Empty(Jan2).or.!Empty(Feb1).or.!Empty(Feb2).or.;
           !Empty(Mac1).or.!Empty(Mac2).or.Type==90

           cMonth1="������"
           cMonth2="���ࠫ�"
           cMonth3="����"
           LimMonth1:=Str(Limit->Jan,7,2)
           LimMonth2:=Str(Limit->Feb,7,2)
           LimMonth3:=Str(Limit->Mac,7,2)
           AM1=Jan1
           AM2=Feb1
           AM3=Mac1
           Pm1=Jan2
           Pm2=Feb2
           Pm3=Mac2
           Type=90                      &&+Type
        ENDIF
        Select Limit
   case month>=4.and.month<=6
        kvartal="II"
        LIM_STR1:="������     "+str(limit->apr,7,2)
        LIM_STR2:="���        "+str(limit->may,7,2)
        LIM_STR3:="����       "+str(limit->jun,7,2)
        Select Limit2
        IF !Empty(Apr1).or.!Empty(Apr2).or.!Empty(May1).or.!Empty(May2).or.;
           !Empty(Jun1).or.!Empty(Jun2).or.Type==90
           cMonth1="��५�"
           cMonth2="���"
           cMonth3="���"
           LimMonth1:=Str(Limit->Apr,7,2)
           LimMonth2:=Str(Limit->May,7,2)
           LimMonth3:=Str(Limit->Jun,7,2)
           AM1=Apr1
           AM2=May1
           AM3=Jun1
           Pm1=Apr2
           Pm2=May2
           Pm3=Jun2
           Type=90                      &&+Type
        ENDIF
        Select Limit
   case month>=7.and.month<=9
        kvartal="III"
        LIM_STR1:="����       "+str(limit->jul,7,2)
        LIM_STR2:="������     "+str(limit->aug,7,2)
        LIM_STR3:="��������   "+str(limit->sep,7,2)
        Select Limit2
        IF !Empty(Jul1).or.!Empty(Jul2).or.!Empty(Aug1).or.!Empty(Aug2).or.;
           !Empty(Sep1).or.!Empty(Sep2).or.Type==90
           cMonth1="���"
           cMonth2="������"
           cMonth3="�������"
           LimMonth1:=Str(Limit->Jul,7,2)
           LimMonth2:=Str(Limit->Aug,7,2)
           LimMonth3:=Str(Limit->Sep,7,2)
           AM1=Jul1
           AM2=Aug1
           AM3=Sep1
           Pm1=Jul2
           Pm2=Aug2
           Pm3=Sep2
           Type=90                      &&+Type
        ENDIF
        Select Limit
   case month>=10.and.month<=12
        kvartal="IV"
        LIM_STR1:="�������    "+str(limit->oct,7,2)
        LIM_STR2:="������     "+str(limit->nov,7,2)
        LIM_STR3:="�������    "+str(limit->dec,7,2)
        Select Limit2
        IF !Empty(Oct1).or.!Empty(Oct2).or.!Empty(Nov1).or.!Empty(Nov2).or.;
           !Empty(Dec1).or.!Empty(Dec2).or.Type==90
           cMonth1="������"
           cMonth2="�����"
           cMonth3="�������"
           LimMonth1:=Str(Limit->Oct,7,2)
           LimMonth2:=Str(Limit->Nov,7,2)
           LimMonth3:=Str(Limit->Dec,7,2)
           AM1=Oct1
           AM2=Nov1
           AM3=Dec1
           Pm1=Oct2
           Pm2=Nov2
           Pm3=Dec2
           Type=90                      &&+Type
        ENDIF
        Select Limit
endcase
firm:=delstring(main->potrebitel,"���")
report(Ddir+"limit"+alltrim(str(Type))+".rpt",dir+"otchet.gkv",100)
select(sel)
go rec
M->PREV_REC:=-1
return NIL




function printlimit()
local sel:=select(),rec:=recno(),scr,clr:=setcolor(),month,desc
local crlf:=chr(13)+chr(10),temp_,kol_kl,month1,month2,month3,str:=""
LOCAL mon1,mon2,mon3,itog1:=0,itog2:=0,itog3:=0
month:=month_menu()
temp_=39/reccount()
kol_kl=0
str:="������ �� "
if month>0
   do case
      case month>=1.and.month<=3
           month1:="JAN"; month2:="FEB"; month3:="MAC"
           str=str+"���� "
           mon1:="������"
           mon2:="���ࠫ�"
           mon3:="����"
      case month=4.and.month<=6
           month1:="APR"; month2:="MAY"; month3:="JUN"
           str=str+"��ன "
           mon1:="��५�"
           mon2:="���"
           mon3:="���"
      case month=7.and.month<=9
           month1:="JUL"; month2:="AUG"; month3:="SEP"
           str=str+"��⨩ "
           mon1:="���"
           mon2:="������"
           mon3:="�������"
      case month=10.and.month<=12
           month1:="OCT"; month2:="NOV"; month3:="DEC"
           str=str+"��⢥��� "
           mon1:="������"
           mon2:="�����"
           mon3:="�������"
      otherwise
                al_box({"����� 㪠��� ���ࠢ��쭮"})
                return NIL
   endcase
   mon1=substr(mon1,1,7); mon1=center(mon1,7," ",.t.)
   mon2=substr(mon2,1,7); mon2=center(mon2,7," ",.t.)
   mon3=substr(mon3,1,7); mon3=center(mon3,7," ",.t.)
   str=str+"����⠫ "+str(year(New_date))+"�.   ����᪮� ����"
   go top
   scr:=obrabot("��ᯥ�⪠ ����⮢")
   desc:=fcreate(Ddir+"otchet.gkv")
   fwrite(desc,str+crlf)
   fwrite(desc,"�������������������������������������������������������������������������������Ŀ"+crlf)
   fwrite(desc,"�  N �               ������������ �࣠����樨           �"+mon1+"�"+mon2+"�"+mon3+"�"+crlf)
   fwrite(desc,"�������������������������������������������������������������������������������Ĵ"+crlf)
   do while !eof()
      kol_kl=kol_kl+temp_
      colorwin(12,21,12,21+kol_kl,'n/n')
      select 33
      seek main->lic_schet
      if !found()
         if netappend()
            replace lic_schet with main->lic_schet
            unlock
         endif
         fwrite(desc,"�"+str(main->lic_schet,4,0)+"�"+SubStr(main->potrebitel,1,50)+"�"+str(&month1,7,2)+"�"+str(&month2,7,2)+"�"+str(&month3,7,2)+"�"+crlf)
      else
         fwrite(desc,"�"+str(main->lic_schet,4,0)+"�"+SubStr(main->potrebitel,1,50)+"�"+str(&month1,7,2)+"�"+str(&month2,7,2)+"�"+str(&month3,7,2)+"�"+crlf)
      endif
      itog1:=itog1+&month1
      itog2:=itog2+&month2
      itog3:=itog3+&month3
      select 88
      skip
   enddo
   fwrite(desc,"���������������������������������������������������������������������������������"+crlf)
   fwrite(desc,"                                                         "+str(itog1,7,2)+" "+str(itog2,7,2)+" "+str(itog3,7,2)+" "+crlf)
   fclose(desc)
   select(sel)
   go rec
   win_rest(scr)
   setcolor(clr)
endif
return NIL




FUNCTION AllPrintLimit()
LOCAL sel:=select(),rec:=recno(),month,Type:=2,scr:=win_save()
LOCAL temp_:=0,kol_kl:=0
PRIVATE kvartal,LIM_STR1,LIM_STR2,LIM_STR3,FIRM,DRESS
IF al_box({"��ᯥ���� ������ ����⮢ �ᥬ ���ॡ�⥫�"},2)==2
   return NIL
ENDIF
month:=month_menu()
IF month==0
   return NIL
ENDIF
obrabot("��ᯥ�⠭� ����⮢")
temp_=39/reccount()
kol_kl=0
DO while !eof()
 Type:=2
 kol_kl=kol_kl+temp_
 colorwin(12,21,12,21+kol_kl,'n/n')
 select licevoj
 seek main->lic_schet
 DRESS:=LICEVOJ->ADRES
 select limit
 seek main->lic_schet
 DO CASE
    CASE month>=1.and.month<=3
         kvartal="I"
         LIM_STR1:="������     "+str(limit->jan,7,2)
         LIM_STR2:="�������    "+str(limit->feb,7,2)
         LIM_STR3:="����       "+str(limit->mac,7,2)
         Type:=IF(limit->mac=0,11,Type)
    CASE month>=4.and.month<=6
         kvartal="II"
         LIM_STR1:="������     "+str(limit->apr,7,2)
         LIM_STR2:="���        "+str(limit->may,7,2)
         LIM_STR3:="����       "+str(limit->jun,7,2)
         Type:=IF(limit->Jun=0,11,Type)
    CASE month>=7.and.month<=9
         kvartal="III"
         LIM_STR1:="����       "+str(limit->jul,7,2)
         LIM_STR2:="������     "+str(limit->aug,7,2)
         LIM_STR3:="��������   "+str(limit->sep,7,2)
         Type:=IF(limit->sep=0,11,Type)
    CASE month>=10.and.month<=12
         kvartal="IV"
         LIM_STR1:="�������    "+str(limit->oct,7,2)
         LIM_STR2:="������     "+str(limit->nov,7,2)
         LIM_STR3:="�������    "+str(limit->dec,7,2)
         Type:=IF(limit->Dec=0,11,Type)
 ENDCASE
 firm:=delstring(main->potrebitel,"���")
 IF inkey()=27
    IF AL_Box({"�������� ����� ����⮢"},2)==1
       exit
    ENDIF
 ENDIF
 report(Ddir+"limit"+alltrim(str(Type))+".rpt",Ddir+"otchet.gkv",100)
 copy_(Ddir+"otchet.gkv","prn",16)
 select main
 skip
ENDDO
deletefile(Ddir+"otchet.gkv")
win_rest(scr)
SELECT(sel)
GO rec
M->PREV_REC:=-1
RETURN NIL




FUNCTION MasKorLim()
local osel:=select(),orec:=recno(),clr:=setcolor(),scr:=SaveScreen(0,0,MaxRow(),MaxCol()),Temp_
Local Kol_Kl,Locked
Select 0
IF NetUse(Schet_Share+"maslim.dbf",.t.,, "maslim")
   select maslim
//---------------------------------------------------------------------------
   devout("")
   set color to n/w
   @ 4, 1 clear to maxrow()-3,maxcol()-3
   colorwin(5,2,maxrow()-3,maxcol()-2,"n+/n")
   set color to n/w
   @ 4, 14 say ' ���ᮢ�� ���४�஢�� ����⮢  '
   declare zgl[14]
   declare fil[14]
   nm1=loarr('zgl','���.���','      � � � � � � � � � � � ','���','���',"���","���","���","��","��","���","���","���","���","���")
   nm2=loarr('fil','lic_schet','potrebitel','jan','feb','mac','apr',"may","jun","jul","aug","sep","oct","nov","dec")
   inp='000000000000000000000'
   t1=5
   l1=1
   b1=maxrow()-4
   r1=maxcol()-3
   fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
   RestScreen(0,0,MaxRow(),MaxCol(),Scr)
   devout("")
   IF Al_Box({"������ ��ࠢ����� ������ � ���� ����⮢"},2,{" ������ "," �� ���뢠�� "})==1
      temp_=39/reccount()
      kol_kl=0
      obrabot("������ �⪮�४�஢����� ����⮢")
      go top
      do while !eof()
         Locked=.F.
         kol_kl=kol_kl+temp_
         colorwin(12,21,12,21+kol_kl,'n/n')
         select limit
         seek maslim->lic_schet
         IF .Not.Found()
            Netappend(0)
            replace lic_schet with maslim->lic_schet
            Locked:=.T.
         ENDIF
         IF .NOT.Locked
            IF Reclock(0)
               Locked:=.T.
            ENDIF
         ENDIF
         IF Locked
            replace jan with jan+maslim->jan
            replace feb with feb+maslim->feb
            replace mac with mac+maslim->mac
            replace apr with apr+maslim->apr
            replace may with may+maslim->may
            replace jun with jun+maslim->jun
            replace jul with jul+maslim->jul
            replace aug with aug+maslim->aug
            replace sep with sep+maslim->sep
            replace oct with oct+maslim->oct
            replace nov with nov+maslim->nov
            replace dec with dec+maslim->dec
            unlock
         ENDIF
         select maslim
         skip
      enddo
      zap
   ENDIF
   RestScreen(0,0,MaxRow(),MaxCol(),Scr)
   devout("")
   pack
//---------------------------------------------------------------------------
   Use
EndIf
select(osel)
go orec
setcolor(clr)
RestScreen(0,0,MaxRow(),MaxCol(),Scr)
RETURN NIL




Function DivideLim()
Local Sel:=Select(),Rec:=RecNo(),Scr1:=SaveScreen(0,0,24,79),Clr:=SetColor()
Local Month,L1:=0,L2:=0,L3:=0,L4:=0,Desc,CrLf:=Chr(13)+Chr(10),Divide:=.F.
Local Old_Lim,New_Lim,MonthName:="",Pay,Dolg,Percent,Kol_Kl:=0,MonthOpl
Month:=Month_Menu("��� ᭨����� ����⮢")
IF Month<=0.or.Month>12
   Return NIL
ENDIF
MonthOpl:=Month_Menu("��� �롮� ������")
IF MonthOpl<=0.or.MonthOpl>12
   Return NIL
ENDIF
Do Case
   Case Month==1
        MonthName="Jan"
   Case Month==2
        MonthName="Feb"
   Case Month==3
        MonthName="Mac"
   Case Month==4
        MonthName="Apr"
   Case Month==5
        MonthName="May"
   Case Month==6
        MonthName="Jun"
   Case Month==7
        MonthName="Jul"
   Case Month==8
        MonthName="Aug"
   Case Month==9
        MonthName="Sep"
   Case Month==10
        MonthName="Oct"
   Case Month==11
        MonthName="Nov"
   Case Month==12
        MonthName="Dec"
EndCase
Set Color To &GetColor
ColorWin(11,15,15,65,"n+/n")
@ 10,14 SAY "����������������� C������ ����� ����������������ķ"
@ 11,14 SAY "� ��� �� ������ ������������                 % �"
@ 12,14 SAY "� ��� ������ ������������� � �� �������      % �"
@ 13,14 SAY "� ��� ������ ������������� � �������         % �"
@ 14,14 SAY "������������������������������������������������ͼ"
Set Cursor On
Set Confirm On
@ 11,57 get L1 Picture "999"
@ 12,57 get L2 Picture "999"
@ 13,57 get L3 Picture "999"
read
Set Cursor Off
Set Confirm Off
IF LastKey()==27
   IF Al_Box({"�������� ᭨����� ����⮢"},2)==1
      Clear Typeahead
      SetColor(Clr)
      RestScreen(0,0,24,79,Scr1)
      Select(Sel)
      Go Rec
      Return NIL
   ENDIF
ENDIF
Clear Typeahead
RunSaver:=.F.
SetColor(Clr)
RestScreen(0,0,24,79,Scr1)
IF Al_Box({"������� ����� ����ன騪�� � �।�ਭ���⥫�"},2)==1
   L4:=1
ENDIF
Desc:=FCreate(DDir+ReportFile)
FWrite(Desc,"������������������������������������������������������������������Ŀ"+CrLf)
FWrite(Desc,"�          ���ॡ�⥫�                      ���.����ⳍ��.����� % �"+CrLf)
FWrite(Desc,"������������������������������������������������������������������Ĵ"+CrLf)
FWrite(Desc,"�                                           �        �         �   �"+CrLf)
Select Main
Go Top
Obrabot("�������� ����⮢ �ᥬ ���ॡ�⥫�")
Do While !EOF()
   kol_kl=kol_kl+39/RecCount()
   colorwin(12,21,12,21+kol_kl,'n/n')
   Percent:=0
   Pay:=CalckPay(MonthOpl,Main->Lic_Schet,.f.)
   Dolg:=GetSaldo(Main->Lic_Schet,Month)
   Select Limit
   Seek Main->Lic_Schet
   IF Found()
      Old_Lim:=&MonthName
      DO Case
         Case Dolg>=0
              Percent:=L1
         Case Dolg<0.and.Pay==0
              Percent:=L2
         Case Dolg<0.and.Pay>0
              Percent:=L3
      EndCase
      IF L4==0
         IF AtNum("����������",MYUpper(Main->Potrebitel))!=0.and.AtNum("���������������",MYUpper(Main->Potrebitel))!=0
            New_Lim:=Old_Lim
         ELSE
            New_Lim:=Round(Old_Lim*(100-Percent)/100,2)
         ENDIF
      ELSE
         New_Lim:=Round(Old_Lim*(100-Percent)/100,2)
      ENDIF
      IF RecLock()
         Replace &MonthName With New_Lim
         UNLOCK
      ENDIF
      FWrite(Desc,"�"+Substr(Str(Main->Lic_Schet,4,0)+" "+Main->Potrebitel,1,43)+"�"+Str(Old_Lim,8,2)+"�"+Str(New_Lim,9,2)+"�"+Str(Percent,3,0)+"�"+CrLf)
   ENDIF
   Select Main
//   Divide:=.F.
//   IF L4==0
//      IF AtNum("����������",Upper(Potrebitel))==0.and.AtNum("���������������",Upper(Potrebitel))==0
//         Divide:=.F.
//      ENDIF
//   ENDIF
   Skip
EndDo
FWrite(Desc,"��������������������������������������������������������������������"+CrLf)
FClose(Desc)
SetColor(Clr)
RunSaver:=.T.
RestScreen(0,0,24,79,Scr1)
Select(Sel)
Go Rec
Return NIL


Function PrintDivLimit()
Local Sel:=Select(),Rec:=RecNo(),Scr1:=SaveScreen(0,0,24,79),Clr:=SetColor()
Private Month,Limit,Mesqc,Firm,Dress
Month:=Month_Menu("�롮� �����")
Mesqc:=Mesqc(Month)
Limit:=GetLimit(Month,Main->Lic_Schet)
FIRM:=delstring(main->potrebitel,"���")
DRESS:=LICEVOJ->ADRES
Report(DDir+"OverLimi.Rpt",DDir+ReportFile,140)
SetColor(Clr)
RestScreen(0,0,24,79,Scr1)
Select(Sel)
Go Rec
Return NIL
