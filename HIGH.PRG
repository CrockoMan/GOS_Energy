*************************** ����襭��� ����� *********************************
proc high_money
LOCAL typ,ismakeplat:=.F.,FRec
private month_,sele,old_ord,old_rec,mesqc,temp_,kol_kl,ras_hod,mesqc,sum_scr
PRIVATE sum,li_mit,BankName,Data_Pl,OCH_PL:="06"
save screen to sum_scr
old_ord=indexord()
sele=select()
old_rec=recno()
month_=month_menu()
*li_mit=0
if month_>0     && ��誠 ��室� �� �㭪樨 �� ����⨨ "Esc" � ����
        do case
                case month_=1
                        mesqc='jan'
                case month_=2
                        mesqc='feb'
                case month_=3
                        mesqc='mac'
                case month_=4
                        mesqc='apr'
                case month_=5
                        mesqc='may'
                case month_=6
                        mesqc='jun'
                case month_=7
                        mesqc='jul'
                case month_=8
                        mesqc='aug'
                case month_=9
                        mesqc='sep'
                case month_=10
                        mesqc='oct'
                case month_=11
                        mesqc='nov'
                case month_=12
                        mesqc='dec'
        endcase
        select 77
        seek main->lic_schet
        ras_hod=round(GetRasHigh(Main->Lic_Schet,Month_)/1000,1)
        select 33
        seek main->lic_schet
        if !found()
           append blank
           replace lic_schet with main->lic_schet
        endif
        shtraph=0
        limit=0
        pererashod=0
        if found()
                if .not.empty(schet_1new)
                        do case
                                case &mesqc>ras_hod
*                                       shtraph=round((&mesqc-ras_hod)*1000*9*M->schet_1new,Decimal)
*                                       limit=&mesqc
*                                       pererashod=&mesqc-ras_hod
*                                       e_rror("  ������室 "+alltrim(str(&mesqc-ras_hod))+'�.����.      ',;
*                                              "  ���� "+alltrim(str(round((&mesqc-ras_hod)*1000*HighKoeff*M->schet_1new,Decimal)))+' ��.')
                                case &mesqc<ras_hod
                                        shtraph=round((ras_hod-&mesqc)*1000*HighKoeff*M->schet_1new,Decimal)
                                        limit=&mesqc
                                        pererashod=ras_hod-&mesqc
                        endcase
                        save screen
mesqchigh='highn'+alltrim(str(int(month_)))
osel:=select()
Select PH
IF Al_Box({"�㬬� �ॢ�襭�� ������୮� ����稭� "+alltrim(str(Shtraph))},2,{" �த������ "," ��室 "})==2
   select(sele)
   set order to old_ord
   go old_rec
   restore screen from sum_scr
   Return
ENDIF
if NetAppend()
   replace licevoj with main->lic_schet
   Replace HighN With M->Shtraph
   Replace Text  With "����襭��� �� "+Mesqc(Month_)+" ����� (���᫥�� "+DTOC(New_date)+")"
   Replace Month With Month(New_date)
   Replace MN    With Month_
   unlock
else
     al_box({"�⪠� � �����஢��. ����� ��⠭�����"})
     select(sele)
     set order to old_ord
     go old_rec
     restore screen from sum_scr
     return
endif
// �㬬� ����襭��� �ய����
cSumma1=str_chislo(Shtraph,70)
cSumma1=cSumma1+space(70-len(cSumma1))
cSumma2=mpsum2 +space(70-len(mpsum2))
// ------------------------------------------------------------------------
select(osel)
data_pl:=alltrim(str(day(New_date+1)))+"  "+mesqc(month(New_date+1),1)+'  '+alltrim(str(year(New_date+1)))+"�."
mes_name:=mesqc(int(month_))
select(sele)
set order to old_ord
go old_rec
select 77   && ��� ���������� ४����⮢ � ���⥦��
seek main->lic_schet
//BankName:=Bank
POTRSTRING=delstring(main->potrebitel,"���")
INNSTRING=appendstring(main->potrebitel,"���")
INNSTRING=alltrim(substr(innstring,4,11))
TOWNSTRING=substr(appendstring(MYupper(licevoj->bank),MYupper("�.")),3)
TOWNSTRING=substr(townstring,1,1)+lower(substr(townstring,2))
IF atnum("������",MYupper(licevoj->bank))>0
   OCHPL:="05"
ELSE
   OCHPL:="06"
ENDIF
IF atnum("�����",MYupper(licevoj->bank))>0
   GRUZPOL:=alltrim(alltrim(potrstring)+" "+alltrim(licevoj->adres))
      VidBankPlat:=""
ELSE
//      VidBankPlat:="���⮩"
      VidBankPlat:="      "
   GRUZPOL:=alltrim(alltrim(LICEVOJ->object1)+" "+;
            alltrim(LICEVOJ->object2)+alltrim(licevoj->adres))
ENDIF
DO Case
   CASE atnum("���",MYupper(licevoj->bank))>0
       TmpStr2Plat:=AllTrim(AllTrim(Licevoj->Str2Plat)+" ��� "+AllTrim(InnString)+" "+AllTrim(PotrString))
   OTHERWISE
       TmpStr2Plat:="��� "+AllTrim(InnString)+" "+AllTrim(PotrString)+" "+AllTrim(Licevoj->Str2Plat)
ENDCASE
StrPlat1:=SubStr(TmpStr2Plat,1 ,LenBank)
StrPlat2:=SubStr(TmpStr2Plat,LenBank+1,Len(TmpStr2Plat)-LenBank)

IF SHTRAPH>0
   Select Tobank
   IF FileLock(0)
      Append Blank
      MyRec:=RecNo()
      Go Bottom
      Schet_=Plat_Treb+1
      Go Myrec
      Replace Plat_Treb With Schet_
      Replace Summa With Shtraph
      Replace Data With New_date+1
      Replace Lic_Schet With Main->Lic_Schet
      Replace Tip With "����襭��� �� "+Mes_Name
      Unlock
   ENDIF
   Select(Sele)
   genhigh(SCHET_)                                    // ᤥ���� ���⥦��
   GenSchetHigh()
ELSE
     AL_BOX({"�ॢ�襭�� ����� �� �����㦥��"})
ENDIF
                        restore screen
                else
                        al_box({"���������� ����� �᭮����� ���.",;
                                '������ ���ଠ�� � ���� "������ ��䮢"',;
                                '� �㭪� "����", � ��ࢮ� �������.'})
                        keyboard chr(27)
                endif
        else
                al_box({"����� � ����� �� ����� �� �������"})
        endif
endif
select(sele)
set order to old_ord
go old_rec
restore screen from sum_scr
return



//------------- ������� ���⥦�� �� ����襭��� ��ࠬ��� - ����� ���⥦��...
Function GenHigh(Pos)
// LOCAL Sel:=Select()
// SELECT LICEVOJ
Schet_=Pos
Do Case
   Case main->tip_plat=0.or.main->tip_plat=1
        report(Ddir+"hightreb.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=2
        report(Ddir+"hightrp.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=3
        report(Ddir+"highinc.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=4
        report(Ddir+"htr_ocb.rpt",Ddir+'otchet.gkv',170)
        OCHPL:="06"
   Case main->tip_plat=5
        report(Ddir+"htrp_ocb.rpt",Ddir+'otchet.gkv',170)
        OCHPL:="06"
   Case main->tip_plat=6
        report(Ddir+"htrebai.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=7
        report(Ddir+"htrpai.rpt",Ddir+'otchet.gkv',170)
   Otherwise
        Al_Box({"��ଠ ���⠢�塞�� ���⥦�� ��������a"})
EndCase
// Select(Sel)
Return NIL



Function GenSchetHigh(IsAsk)
LOCAL Gen:=1
IsAsk:=IF(IsAsk==NIL,.T.,IsAsk)
IF IsAsk
   Gen:=IF(Al_Box({"��ନ஢��� ���-�������"},2)==1,1,0)
ENDIF
IF FIle(DDir+ReportFile)
   Copy_(DDir+ReportFile,DDir+"TmpFile.Tmp")
ENDIF
IF Gen!=0
   IF main->tip_plat>=4.and.main->tip_plat<=5
      Report(DDir+"SFHighO.Rpt",DDir+ReportFile,170)
   ELSEIF main->tip_plat>5
      Report(DDir+"SFHighAi.Rpt",DDir+ReportFile,170)
   ELSE
      Report(DDir+"SFHigh.Rpt", DDir+ReportFile,170)
   ENDIF
   IF Al_Box({"�⯥���� ���-䠪����"},2)==1
      Copy_(DDir+ReportFile,"Lpt1")
   EndIF
ENDIF
IF FIle(DDir+"TmpFile.Tmp")
   Copy_(DDir+"TmpFile.Tmp",DDir+ReportFile)
   DeleteFile(DDir+"TmpFile.Tmp")
ENDIF
Return NIL



Function isonlimit(searchkod)
Local isonlimit:=.T.,startpos:=at(')',searchkod),I,tmpstring:=""
IF startpos>0
   For I=1 To 18
       tmpstring="SCHET_NL"+alltrim(str(int(I)))
       IF alltrim(&tmpstring)==alltrim(substr(searchkod,startpos+1))
          isonlimit=.F.
          EXIT  && ���稪 � ����� �� �室��, ��室 �� 横��.
       ENDIF
   Next
ELSE
        isonlimit=.F.
ENDIF
Return isonlimit






Function isnonds(tarifs,nLicevoj)
Local isonnds:=.F.
nLicevoj:=IF(nLicevoj==NIL,0,nLicevoj)
IF tarifs#0.and.tarifs#schet_tar1.and.tarifs#schet_tar2.and.tarifs#schet_tar3.and.;
      tarifs#schet_tar4.and.tarifs#schet_tar5.and.tarifs#schet_tar6.and.;
      tarifs#schet_tar7.and.tarifs#schet_tar8.and.tarifs#schet_tar9
        isonnds:=.T.
ELSE
        isonnds:=.F.
ENDIF
IF nLicevoj<99999
	 IsOnNds:=.T.
ENDIF
Return isonnds






//---------------------------------------------------------------------------
Function iswritekniga
LOCAL screen:=win_save(),color:=setcolor(),write,spisok,is_choice:={}
spisok:={" ������� � ����� �� ���浪� ",;
         " �� �����뢠�� � �����       ",;
         " ������� � �㦭� ����஬   ",;
         " ������� ࠭�� �믨ᠭ���",;
         "�����������������������������",;
         " ��室                       "}
ASize(is_choice,Len(Spisok))
AFill(Is_Choice,.t.);        Is_Choice[Len(Spisok)-1]:=.F.
WRITE=vert_menu(spisok,"����� �த��",is_choice,14,33,1,'n/w,n/g,,,r/w',.F.)
win_rest(screen)
setcolor(color)
return Write
