// ����� � �ନ஢���� ���-䠪����
FUNCTION SchetFaktura(MyParam)
LOCAL old_col:=setcolor(),old_sel:=select(),old_scr:=win_save(),FRec
LOCAL recno:=recno(),month,debet_last,kredit_last,counter:=0,Make:=.T.
LOCAL tmpit:=0,tmnpnds:=0,mo_nth,lPoisk:=""
PRIVATE Plmontn,MpSum1:="",SumAbon:=0,RashAbon:=0,cSumma1:="",cSumma2:="",lPresDate:=0
PRIVATE TarAbon:=0,Post29nds:=0,TmpCalckItog:=0,SFString:=""
PRIVATE AktEn:=0,RashAkt:=0,WsegoItNds:=0,OCH_PL:="06",DOP_STR:=" ",post294:=0
Private Tarifs:={},TarFound:=.F.
schet_=main->lic_schet
SFString:=" ��/� "+AllTrim(Str(Main->Lic_Schet))+" �� "+DTOC(new_date+1)
month:=month_menu("����� ��� ����")
Plmonth:=mesqc(Month)           // ����� � ���⥦��
if month=0
   return .f.
endif
mo_nth=month
AktEn:=GetRashod(main->lic_Schet,Month); RashAkt:=AktEn
//potrstring=delstring(potrebitel,"���")
IF AtNum("���",AllTrim(Potrebitel),1)=1
   POTRSTRING=delstring(Substr(potrebitel,15),"���")
ELSE
   POTRSTRING=delstring(potrebitel,"���")
ENDIF
KPPSTRING=Alltrim(Substr(appendstring(main->potrebitel,"���"),4,11))
innstring=appendstring(potrebitel,"���")
//@ 1,0 say alltrim(substr(innstring,4,AtNum(" ",InnString,1,6)-4))
//Inkey(0)
//innstring=alltrim(substr(innstring,4,11))
innstring=alltrim(substr(innstring,4,AtNum(" ",InnString,1,6)-4))
Select 77
seek main->lic_schet
Do While Lic_Sch==main->lic_schet
   IF !Reaktivn
      lpoisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
      Select(Mo_nth)
      Seek lPoisk
      IF Found()
         IF Len(Tarifs)>0
            For I=1 To Len(Tarifs)
                IF Tarif#0
                   IF Tarifs[i][1]==Tarif
                      Tarifs[i][2]=Tarifs[i][2]+if(rashod-subab>0,rashod-subab,subab-rashod)
                      Tarifs[i][3]=Tarifs[i][3]+Summa
                      TarFound:=.T.
                   ENDIF
                ENDIF
            Next
            IF TarFound==.F.
               IF Tarif#0
                  AADD(Tarifs,{Tarif,Rashod,Summa})
               ENDIF
            ENDIF
            TarFound:=.F.
         ELSE
            IF Tarif#0
               AADD(Tarifs,{Tarif,Rashod,Summa})
            ENDIF
         ENDIF
      ENDIF
      Select Licevoj
   ENDIF
   Skip
ENDDO
IF Len(Tarifs)>1
   For I=1 To Len(Tarifs)
       Perem:="AktEn"+AllTrim(Str(I))
       &Perem:=Tarifs[i][2]
       Perem:="CenaA"+AllTrim(Str(I))
       &Perem:=Tarifs[i][1]
       Perem:="SumAktEn"+AllTrim(Str(I))
       &Perem:=Tarifs[i][3]
       Perem:="NdsAktEn"+AllTrim(Str(I))
       &Perem:=Round(Tarifs[i][3]*schet_nds/100,Decimal)
       Perem:="WsegoSNds"+AllTrim(Str(I))
       &Perem:=Tarifs[i][3]+Round(Tarifs[i][3]*schet_nds/100,Decimal)
   Next
ENDIF
//Inkey(0)
select 77
seek main->lic_schet
IF atnum("������",MYupper(licevoj->bank))>0
   OCHPL:="05"
ELSE
   OCHPL:="06"
ENDIF
if found()
   select(old_sel)
   townstring=substr(appendstring(MYupper(licevoj->bank),MYupper("�.")),3)
   townstring=substr(townstring,1,1)+lower(substr(townstring,2))
   if atnum("�����",MYupper(licevoj->bank))>0
      gruzpol:=alltrim(alltrim(potrstring)+" "+alltrim(main->adress))
      VidBankPlat:=""
   else
//      VidBankPlat:="���⮩"
      VidBankPlat:="      "
      gruzpol:=alltrim(alltrim(LICEVOJ->object1)+" "+alltrim(LICEVOJ->object2)+alltrim(main->adress))
   endif
   VidBankPlat:=Center(VidBankPlat,10," ",.t.)
else
   select(old_sel)
   townstring="."
   gruzpol:=alltrim(alltrim(potrstring)+" "+alltrim(main->adress))
endif
DO Case
   CASE atnum("���",MYupper(licevoj->bank))>0
       TmpStr2Plat:=AllTrim(AllTrim(Licevoj->Str2Plat)+" ��� "+AllTrim(InnString)+" "+AllTrim(PotrString))
   OTHERWISE
       TmpStr2Plat:="��� "+AllTrim(InnString)+" "+AllTrim(PotrString)+" "+AllTrim(Licevoj->Str2Plat)
ENDCASE
// Al_Box({TmpStr2Plat})
//StrPlat1:=SubStr(TmpStr2Plat,1 ,LenBank)
//StrPlat2:=SubStr(TmpStr2Plat,LenBank+1,Len(TmpStr2Plat)-LenBank)

StrPlat1:=SubStr(TmpStr2Plat,1 ,47)
StrPlat2:=SubStr(TmpStr2Plat,47+1,Len(TmpStr2Plat)-47)

//@ 1,0 say StrPlat1
//@ 2,0 say StrPlat2
//inkey(0)
//----------------------------------------- ����� ���ॡ������ ���ࣨ�
// WSEGOITNDS - �㬬� � ��� (����뢠���� � �ଥ RPT)
// NDSITEN    - �㬬� ��� (����뢠���� � �ଥ RPT)
// AKTEN    - ��⨢��� ���ࣨ�        REAEN    - ����⨢��� ���ࣨ�
// SUMAKTEN - �㬬� ��⨢��� ���ࣨ�  SUMREAEN - �㬬� ॠ�⨢��� ���ࣨ�
// NDSAKTEN - ��� ��⨢��� ���ࣨ�    NDSREAEN - ��� ॠ�⨢��� ���ࣨ�
// DONSUM   - �㬬� �����᫥���      DONNDS   - ���室 �����᫥���
// WOZWSUM  - �㬬� ������          WOZWNDS  - ��� ������
wsegoitnds:=0; ndsiten:=0               // �����. �㬬�
reaktiv=0; sum_reak=0                   // ����⨢���
sum_rashod=0; power=0; beznds=0         // ���室 ��.���ࣨ�
donsum:=0; donpow:=0; donnds:=0         // �����᫥���
wozwsum:=0; wozwpow:=0; wozwnds:=0      // ������
CalcEnergy(month)
WsegOplach:=CalckPay(month)
select 15
seek main->lic_schet
if !found()
   append blank
   replace lic_schet with main->lic_schet
endif
TmpCalckItog:=BezNds+Sum_Rashod+round((Sum_Rashod)*schet_nds/100,DECIMAL)

debl=if(month>1,'debet'+alltrim(str(month-1)),'last_debet'); debl=&debl
krel=if(month>1,'kredit'+alltrim(str(month-1)),'last_kred'); krel=&krel
debp='debet'+alltrim(str(month)); debp:=&debp
krep='kredit'+alltrim(str(month)); krep:=&krep

sumakten:=sum_rashod+beznds-sum_reak; ndsakten:=round((sumakten-beznds)*schet_nds/100,DECIMAL)
reaen:=reaktiv; sumreaen:=sum_reak; ndsreaen:=round(sum_reak*schet_nds/100,DECIMAL)
wozwnds:=round(wozwsum*schet_nds/100,DECIMAL)
donnds:=round(donsum*schet_nds/100,DECIMAL)
//----------------------------------------- �����⮢�� 䠩�� ���-䠪����...
do outex with month //------------------------------ ������� ���᫥���...
select 77; seek main->lic_schet;   select 88 //���� ������᪨� ४����⮢...
mesqc=mesqc(month)
plat_dat:=alltrim(str(day((new_date+1))))+"  "+mesqc(month(new_date+1),1)+;
          ' '+alltrim(str(year(new_date+1)))
// WSEGOPLACH:=if(WSEGOPLACH-DEBL>0,WSEGOPLACH-DEBL,0)
IF Debl==0.and.WsegoPlach<0
   WSEGOPLACH:=WSEGOPLACH-DEBL
ELSE
   WSEGOPLACH:=if(WSEGOPLACH-DEBL>0,WSEGOPLACH-DEBL,0)
ENDIF
// WSEGOPLACH:=WSEGOPLACH-DEBL
AbonSum:=GetAbonSum(Main->Lic_Schet,Month)
//----
WSEGOPLA :=WSEGOPLACH+KREL
NDSOPLACH:=round(WSEGOPLA*SCHET_NDS/(100+SCHET_NDS),DECIMAL)
SUMOPLACH:=WSEGOPLA-NDSOPLACH
WSEGOSNDS:=SUMAKTEN+NDSAKTEN
WSEGOSNDS:=SUMREAEN+NDSREAEN
WSEGODON :=DONNDS+DONSUM

IF atnum("���",MYupper(licevoj->bank))==0
//   @ 1,0 say DonSum
//   Inkey(0)
   PLANEN   :=AKTEN+REAEN-WOZWPOW
   SUMPLANEN:=(SUMAKTEN+SUMREAEN-WOZWSUM-AbonSum)*MyPlanKoeff
   NDSPLANEN:=(NDSAKTEN+NDSREAEN-WOZWNDS-round(AbonSum*SCHET_NDS/(100+SCHET_NDS),DECIMAL))*MyPlanKoeff
   WSEGOPLANNDS:=(SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN-WOZWSUM-WOZWNDS)*MyPlanKoeff
ELSE
   PLANEN   :=0
   SUMPLANEN:=0
   NDSPLANEN:=0
   WSEGOPLANNDS:=0
ENDIF
IF Schet_vplan==.F.
   PLANEN   :=0
   SUMPLANEN:=0
   NDSPLANEN:=0
   WSEGOPLANNDS:=0
ENDIF


ITEN:=AKTEN+REAEN+DONPOW; SUMITEN:=Round(SUMAKTEN+SUMREAEN+DONSUM,DECIMAL); NDSITEN:=round(NDSAKTEN+NDSREAEN+DONNDS,Decimal)
WSEGOITNDS:=ROUND(DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN,DECIMAL)
//=======================================
//=======================================
//=======================================
//POST294:=ROUND(WSEGOITNDS*0.5,DECIMAL)
POST294:=0
//AL_BOX({STR(POST294),str(WsegoItNds)})
//=======================================
//=======================================
//=======================================
ITEN:=AKTEN+REAEN+PLANEN+DONPOW; SUMITEN:=SUMAKTEN+SUMREAEN+SUMPLANEN+DONSUM-SUMOPLACH; NDSITEN:=NDSAKTEN+NDSREAEN+NDSPLANEN+DONNDS-NDSOPLACH
WSEGOITNDS:=round(DONSUM+DONNDS+SUMAKTEN+NDSAKTEN+SUMREAEN+NDSREAEN+WSEGOPLANNDS-WSEGOPLA,DECIMAL)
Sum2Plat:=WsegoItNds
Sum2Plat:=WsegoItNds+POST294
Post294NDS:=Round((Post294*Schet_NDS)/(100+SCHET_NDS),2)
//DOP_STR:="� ⮬ �᫥ ����.�ࠢ. �� N 294 �� 04.04.2000�. "+AllTrim(Str(Round(Post294/1.2,Decimal)))+" ��� "+ALLTRIM(STR(POST294-Round(Post294/1.2,Decimal)))+" �ᥣ� "+ALLTRIM(STR(POST294))
// @ 1,0 say "DonSum"; ?? DonSum
// ? "DonNds"; ?? DonNds
// ? "SumAktEn"; ?? SumAktEn
// ? "NdsAktEn"; ?? NdsAktEn
// ? "SumReaEn"; ?? SumReaEn
// ? "NdsReaEn"; ?? NdsReaEn
// ? "WsegoPlanNds"; ?? WsegoPlanNds
// ? "WsegoPla";     ?? WsegoPla
// ? "WsegoPlach";     ?? WsegoPlach
// Inkey(0)

IF MyParam==1.and.WSEGOITNDS<1
   if al_box({"����祭��� �㬬� ��� ���⠢�����: "+alltrim(str(WsegoItNds)),;
              "����㯨�� � �ନ஢���� ���㬥��"},2)==2
              setcolor(old_col)
              win_rest(old_scr)
              select(old_sel)
              go recno
              prev_rec=-1
              return .f.
   endif
endif

IF MyParam==2
//   if al_box({"����祭��� �㬬� ��� ���⠢�����: "+alltrim(str(Round(GetAbonSum(Main->Lic_Schet,Month)*(Schet_Nds+100)/100,Decimal))),;
   RashAkt:=GetRashod(Main->Lic_Schet,Month)
   WsegoAbon:=GetAbonSaldo(Main->Lic_Schet,Month); WsegoAbon:=IF(WsegoAbon<0,-1*WsegoAbon,0)
   WsegoAbon:=IF(WsegoAbon>0,GetAbonSum(Main->Lic_Schet,Month),0)
   WsegoAbon:=Round(IF(WsegoAbon>0,GetAbonSum(Main->Lic_Schet,Month),0)*(100+Schet_Nds)/100,Decimal)
   TarAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)/RashAbon,Decimal)
   NdsAbon:=Round(WsegoAbon*20/120,Decimal)
   SumAbon:=WsegoAbon-NdsAbon
   IF WsegoAbon>0.AND.Al_Box({"����祭��� �㬬� ��� ���⠢�����: "+alltrim(str(WsegoAbon)),;
              "����㯨�� � �ନ஢���� ���㬥��"},2)==2
              setcolor(old_col)
              win_rest(old_scr)
              select(old_sel)
              go recno
              prev_rec=-1
              return .f.
   ELSE
      IF WsegoAbon=0
         IF Al_Box({"���⥦�� �� ���⠢�����"},2,{" ��室 "," �த������ "})==1
            Return .F.
         ENDIF
      ENDIF
   endif
endif

//----------------------------------------------- ���� �ନ஢���� ���㬥⮢
spisok:={" ���⥦�� ���㬥��     ",;
         " ��� �� ������ ����     ",;
         " ��� �� ��������� ����  ",;
         " ���������  ",;
         " ��� - 䠪��� � �����஢�����   ",;
         " ���-䠪��� �죮⭠�",;
         "����������������������������������",;
         " ��室                       "}
ASize(is_choice,Len(Spisok))
AFill(Is_Choice,.t.);        Is_Choice[Len(Spisok)-1]:=.F.
TIPD=vert_menu(spisok,"��ନ஢���",is_choice,12,31,1,'n/w,n/g,,,r/w',.F.)
IF TIPD=8.OR.TIPD=0
   setcolor(old_col)
   win_rest(old_scr)
   select(old_sel)
   go recno
   prev_rec=-1
   return .f.
ENDIF
IF Tipd==5
   report(Ddir+"SfOld.rpt",Ddir+ReportFile,250)
   setcolor(old_col)
   win_rest(old_scr)
   select(old_sel)
   unlock all
   go recno
   prev_rec=-1
   return .t.
ENDIF
//---------------
cSumma1=str_chislo(Sum2Plat,70)
cSumma1=cSumma1+space(70-len(cSumma1))
cSumma2=mpsum2 +space(70-len(mpsum2))
//---------------------------------------- ��ନ஢���� ���⥦���� ���㬥��
IF MyParam==1
      Select Tobank
      IF FoundBank(Main->Lic_Schet,"���������ࣨ� �� "+PlMonth+" "+AllTrim(Str(Year(new_date+1))))
         IF ChoiceBox("�ॡ������ �뫮 ���⠢���� ࠭��",{" ��室 "," �த������ "})==1
//         IF Al_Box({"���⥦�� 㦥 �뫠 ���⠢����"},2,{" ��室 "," �த������ "})==1
            Make:=.f.
         ENDIF
      ENDIF
      IF make.and.FileLock(0)
         Append Blank
         MyRec:=RecNo()
         Go Bottom
         Schet_=Main->Lic_Schet
         Go Myrec
         Replace Plat_Treb With Schet_
         Replace Summa With WsegoItNds
         Replace Data With new_date+1
         Replace Lic_Schet With Main->Lic_Schet
         Replace Tip With "���������ࣨ� �� "+PlMonth+" "+AllTrim(Str(Year(new_date+1)))
        Unlock
      ENDIF
      Select(Old_Sel)
      IF Make
       	 IF Mo_Nth==12.and.Month(New_Date+1)==1
         		SFString:=" ��/� "+AllTrim(Str(Main->Lic_Schet))+" �� "+"31.12."+AllTrim(Str(Year(New_Date+1)-1))
       	 ELSE
         		SFString:=" ��/� "+AllTrim(Str(Main->Lic_Schet))+" �� "+DTOC(new_date+1)
         ENDIF
       IF TipD==1
         MakePlata(TipD)
/*               DO WHILE nButton <> XBPMB_RET_YES
         nButton := ConfirmBox( , ;
                       "Do you want to end the program?", ;
                       "Quit", ;
                        XBPMB_YESNO , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

                                 DO CASE
                                          CASE nButton==XBPMB_RET_YES
         ENDCASE
*/
//         TipD:=1+Al_Box({"��� �ନ�㥬�� ���� - ������� � ���⥦���� ���㬥���"},3,{" ������ ���� "," ��������� "," �⪠� "},2)
         TipD:=1+ ChoiceBox("��� �ନ�㥬�� ���-䠪����",{" ������ ���� "," ��������� "," �⪠� "})
         IF TipD#4  // �⪠� ���� ���䠪����
//            MakePlata(TipD)
//            al_box("��⮢�!")

//            IF Al_Box({"�⯥���� ���� - �������"},2)==1
               IF .NOT.Empty(AllTrim(PRFONTNAME))
					 			   lPresDate:=Al_BOX({"��� ��� �ନ஢���� ���㬥��"},2,{" ������ "," ����� ����� "})
                   MainSf(Mo_Nth)
                   MainNakl(Mo_Nth)
               ELSE
                 Print_Fi(.t.)
               ENDIF
//               Copy_(DDir+ReportFile,"prn")
//            ENDIF
         ENDIF
         TipD:=1
       ELSE
         MakePlata(TipD)
         IF ChoiceBox("�⯥���� ���-䠪����",{" �� "," ��� "})==1
//         IF Al_Box({"�⯥���� ���� - �������"},2)==1
            IF .NOT.Empty(AllTrim(PRFONTNAME))
					 			lPresDate:=Al_BOX({"��� ��� �ନ஢���� ���㬥��"},2,{" ������ "," ����� ����� "})
                MainSf(Mo_Nth)
                MainNakl(Mo_Nth)
            ELSE
                Print_Fi(.t.)
            ENDIF
//               Copy_(DDir+ReportFile,"prn")
         ENDIF
       ENDIF
      ENDIF
//   DO While Al_Box({"�⯥���� ���⥦�� ���㬥�� �� ���������ࣨ�"},2)==1
//      Copy_(Dir+ReportFile,"prn")
//   ENDDO
//   WsegoAbon:=GetAbonSum(Main->Lic_Schet,Month)
ELSE
      Select Tobank
      IF FoundBank(Main->Lic_Schet,"�����஢����� �� "+PlMonth+" "+AllTrim(Str(Year(new_date+1))))
         IF Al_Box({"���⥦�� 㦥 �뫠 ���⠢����"},2,{" ��室 "," �த������ "})==1
            Make:=.F.
         ENDIF
      ENDIF
      RashAkt:=GetRashod(Main->Lic_Schet,Month)
//      WsegoAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)*(Schet_Nds+100)/100,Decimal)
//      WsegoAbon:=GetAbonSaldo(Main->Lic_Schet,Month)
      WsegoAbon:=GetAbonSaldo(Main->Lic_Schet,Month); WsegoAbon:=IF(WsegoAbon<0,-1*WsegoAbon,0)
      TarAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)/RashAbon,Decimal)
//      NdsAbon:=WsegoAbon-GetAbonSum(Main->Lic_Schet,Month)
      NdsAbon:=Round(WsegoAbon*20/120,Decimal)
      SumAbon:=WsegoAbon-NdsAbon
//      IF make.and.WsegoAbon!=0
      IF make
         cSumma1=str_chislo(WsegoAbon,70)
         cSumma1=cSumma1+space(70-len(cSumma1))
         cSumma2=mpsum2 +space(70-len(mpsum2))
         Select ToBank
         IF FileLock(0)
            Append Blank
            MyRec:=RecNo()
            Go Bottom
//            Schet_=Plat_Treb+1
            Schet_=Main->Lic_Schet
            Go Myrec
            Replace Plat_Treb With Schet_
            Replace Summa With WsegoAbon
            Replace Data With new_date+1
            Replace Lic_Schet With Main->Lic_Schet
            Replace Tip With "�����஢����� �� "+PlMonth+" "+AllTrim(Str(Year(new_date+1)))
           Unlock
         ENDIF
         Select(Old_Sel)
         IF TipD==1
            MakeAbonPl(TipD)
            Copy_(DDir+ReportFile,DDir+"Otchet_.tmp")
         ELSE
            DeleteFile(DDir+"Otchet_.tmp")
         ENDIF
         RashAkt:=GetRashod(Main->Lic_Schet,Month)
         WsegoAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)*(100+Schet_Nds)/100,Decimal)
         TarAbon:=Round(GetAbonSum(Main->Lic_Schet,Month)/RashAbon,Decimal)
         NdsAbon:=Round(WsegoAbon*20/120,Decimal)
         SumAbon:=WsegoAbon-NdsAbon
         If TipD==1
            TipD:=1+Al_Box({"��� �ନ�㥬�� ���� - ������� ��� �����஢����� "},3,{" ������ ���� "," ��������� "," �⪠� "},2)
            MakeAbonPl(TipD)
            TipD:=1
            IF Al_Box({"�⯥���� ���� - �������"},2)==1
               Copy_(DDir+ReportFile,"prn")
            ENDIF
         ELSE
            MakeAbonPl(TipD)
         ENDIF
         IF File(DDir+"Otchet_.tmp")
            Copy_(DDir+"Otchet_.tmp",DDir+ReportFile)
         EndIf
      ENDIF
ENDIF
//--------------------------------------------------------------------------
setcolor(old_col)
win_rest(old_scr)
select(old_sel)
unlock all
go recno
prev_rec=-1
return .t.





//------- ���� �����ப� � ��ப� � �뤥����� �� ���������� ���� �� ����
//------- �᫨ �����ப� �� ������� � IS_SPACE=.T. �����頥��� ���� �஡��
//------- �᫨ IS_SPACE=.F. �����頥��� �㫥��� ��ப�
//------- ���� �����頥��� �����ப�, ��稭�� �� ᨬ���� STRING2 � �� ����
function appendstring(string1, string2, is_space)
local potr_inn,start_inn
is_space:=if(is_space==NIL,.T.,is_space)
Start_Inn:=Atnum(string2,string1)
Start_Inn:=If(Start_Inn==0,Len(string1),Start_Inn)
potr_inn:=substr(string1,start_inn)
potr_inn=if(empty(potr_inn).and.is_space," ",potr_inn)
return potr_inn


//------------------------- �㭪�� ���� ��室� ���������ࣨ�
//------------------------- �� ������� �����.
// �����頥��� ���祭�� � ��६����, ������� ��� ��� Private ��� Public
// reaktiv, sum_reak, sum_rashod, power, beznds, SumAbon:=0, RashAbon:=0
function CalcEnergy(month,is_bar)
Local Sel:=select(),Rec:=recno(),first:=.t.,old_sel,old_deb,old_kred,poisk
Local Screen,kol_kl,temp_
Is_Bar:=if(Is_Bar==NIL,.T.,Is_Bar)
select 77
go top
if Is_Bar
   Screen:=obrabot("����� ��室� ���������ࣨ�")
   temp_=39/reccount()
   kol_kl=0
ENDIF
seek main->lic_schet
do while lic_sch==main->lic_schet
 IF Is_Bar
    kol_kl=kol_kl+temp_
    colorwin(12,21,12,21+kol_kl,'n/n')
 ENDIF
 select(month)
 poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
 seek poisk
// if atnum("�����",upper(alltrim(licevoj->schetchik)))!=0.or.;
//    atnum("���",upper(alltrim(licevoj->schetchik)))!=0
//    donsum:=donsum+summa                              // �����᫥��� �㬬�
//    donpow:=donpow+(rashod-subab)                     // �����᫥��� ��室
// else                                                  && ��� �����᫥���!
  if atnum("�������",MYupper(alltrim(licevoj->schetchik)))!=0
     wozwsum:=wozwsum+summa                            // ������ �㬬�
     wozwpow:=wozwpow+(rashod-subab)                  // ������ ��室
  endif
   if found().and..not.deleted()
       IF MYUpper(Licevoj->schetchik)=="����.����"
          SumAbon:=SumAbon+Summa
          RashAbon:=RashAbon+rashod
       ELSE
//       ENDIF
        if summa>0
           if tarif=schet_tar1.or.tarif=schet_tar2.or.tarif=schet_tar3.or.;
              tarif=schet_tar4.or.tarif=schet_tar5.or.tarif=schet_tar6.or.;
              tarif=schet_tar7.and.tarif=schet_tar8.or.tarif=schet_tar9
                   beznds=beznds+summa
           else
                   sum_rashod=sum_rashod+summa
           endif
        else
             sum_rashod=sum_rashod+summa
        endif
        if .not.empty(summa)
           if rashod>0
              if .not.licevoj->reaktivn
                 power=power+if(rashod-subab>0,rashod-subab,subab-rashod)
              else
                 reaktiv=reaktiv+if(rashod-subab>0,rashod-subab,subab-rashod)
                 sum_reak=sum_reak+summa
              endif
           else
              if .not.licevoj->reaktivn
                  power=power+rashod-subab
              else
                  reaktiv=reaktiv+rashod-subab
                  sum_reak=sum_reak+summa
              endif
           endif
        endif
        if drug_nach#licevoj->reaktivn
           if reclock()
              replace drug_nach with licevoj->reaktivn
              unlock
           endif
        endif
       ENDIF // �� �����஢�����
  endif
// endif
 select 77
 skip
enddo
Select(sel); go Rec
IF Is_Bar
   win_rest(Screen)
ENDIF
return NIL



//------------------------- �㭪�� ���� ������ �� ������� �����.
//------------------------- �����頥� �㬬� ����㯨�襩 ������
Function CalckPay(month,Lic,IsBar,TypeOpl,cFoundStr)
Local Sel:=Select(),Rec:=RecNo(),Sum:=0,Wozw_N:=0,Woz_Wrat:=0,BezNds
Local Screen,Kol_Kl,Temp_,Month_,NameInd:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,cStr:=""
LIC:=IF(Lic==NIL,Main->Lic_Schet,Lic)
IsBar:=IF(IsBar==NIL,.T.,IsBar)
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
IF IsBar

		oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
		aSizeDesktop  := oMainWindow:currentSize()
		oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
		oDlg:title    := "�롮� ����� �� ���ॡ�⥫�" 
		oDlg:SysMenu	:= .F.
		oDlg:Configure()
		oDlg:Show()
		aSizeDesktop  := oDlg:currentSize()
		aPos					:= oDlg:CurrentPos()
		oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
		oProgress:create()
		oProgress:minimum := 1
		oProgress:maximum := RecCount()
ENDIF
do while Licevoj==LIC
   IF IsBar
   	  oProgress:increment()																				// Progress Bar Increment
   ENDIF
   IF Licevoj=Lic
      if .not.deleted()
         IF .NOT.Empty(cFoundStr).AND.AtNum(cFoundStr,Vid_Dokum)!=0
            if alltrim(vid_dokum)#'����'.and.alltrim(vid_dokum)#'����'
               if alltrim(vid_dokum)="������".or.alltrim(vid_dokum)='������'
                  sum=sum-summa
                  ***************************
                  * �㬬� ������ � ���᫥���
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="� �������"
                     sum=sum-summa
                  else
                     if MYupper(alltrim(vid_dokum))="� �������"
                     else
                        sum=sum+summa
                        cStr:=cStr+AllTrim(Vid_dokum)+" "+AllTrim(Num_Dokum)+" "
                     endif
                  endif
               endif
            endif
         ELSEIF Empty(cFoundStr)
            if alltrim(vid_dokum)#'����'.and.alltrim(vid_dokum)#'����'
               if alltrim(vid_dokum)="������".or.alltrim(vid_dokum)='������'
                  sum=sum-summa
                  ***************************
                  * �㬬� ������ � ���᫥���
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="� �������"
                     sum=sum-summa
                  else
                     if MYupper(alltrim(vid_dokum))="� �������"
                     else
                        sum=sum+summa
                        cStr:=cStr+AllTrim(Vid_dokum)+" "+AllTrim(Num_Dokum)+" "
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
IF IsBar
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
ENDIF
return sum




//------------------------- �㭪�� ���� ������ �� ������� �����.
//------------------------- �����頥� �㬬� ����㯨�襩 ������
Function GetPayData(Lic,month,nDate)
Local Sel:=Select(),Rec:=RecNo(),Sum:=0,Wozw_N:=0,Woz_Wrat:=0,BezNds
Local Screen,Kol_Kl,Temp_,Month_,NameInd:=""
Local oDlg,aSizeDeskTop,aPos,oProgress,cStr:=""
LIC:=IF(Lic==NIL,Main->Lic_Schet,Lic)
IsBar:=IF(IsBar==NIL,.T.,IsBar)
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
            if alltrim(vid_dokum)#'����'.and.alltrim(vid_dokum)#'����'
               if alltrim(vid_dokum)="������".or.alltrim(vid_dokum)='������'
               	  IF Day(Data)<nDate
                  	 sum=sum-summa
                  ENDIF
                  ***************************
                  * �㬬� ������ � ���᫥���
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="� �������"
               	  	IF Day(Data)<nDate
                     		sum=sum-summa
                  	ENDIF
                  else
                     if MYupper(alltrim(vid_dokum))="� �������"
                     else
               	  			IF Day(Data)<nDate
		                        sum=sum+summa
                        ENDIF
                     endif
                  endif
               endif
            endif
         ELSEIF Empty(cFoundStr)
            if alltrim(vid_dokum)#'����'.and.alltrim(vid_dokum)#'����'
               if alltrim(vid_dokum)="������".or.alltrim(vid_dokum)='������'
               	  IF Day(Data)<nDate
                  		sum=sum-summa
                  ENDIF
                  ***************************
                  * �㬬� ������ � ���᫥���
                  ***************************
               else
                  if MYupper(alltrim(vid_dokum))="� �������"
               	  	IF Day(Data)<nDate
                     		sum=sum-summa
                    ENDIF
                  else
                     if MYupper(alltrim(vid_dokum))="� �������"
                     else
               	  			IF Day(Data)<nDate
		                        sum=sum+summa
                        ENDIF
                     endif
                  endif
               endif
            endif
         ENDIF
      endif
   endif
   skip
enddo
use
Select(sel); go Rec
return sum







// -------------------------------------------------- ����� ����� ���...
function next_schet()
local old_col:=setcolor(),old_scr:=win_save()
set color to n/w,w/n
schet_=int(schet_+1)
colorwin(12,21,14,60,'n+/n')
@ 11,20,13,59 box "         "
colorwin(12,21,14,60,'n+/n')
@ 11,20 say "��������������������������������������Ŀ"
@ 12,20 say "� ����騩 ���浪��� ����� ���       �"
@ 13,20 say "����������������������������������������"
set cursor on
set conf on
@ 12,52 get schet_ picture '999999'
read
set cursor off
set conf off
Clear Typeahead
if lastkey()=27
   setcolor(old_col)
   win_rest(old_scr)
   select(old_sel)
   go recno
   schet_=int(schet_-1)
   prev_rec=-1
   return .f.
endif
return schet_


//---------------------------------------------------------------------------
//---------- �����⮢�� ���⥦�� ��� ��� � ���� �� ���ॡ�⥫� ------------
//---------------------------------------------------------------------------
function makeplata(tip)
Local cStr:="",cPerem:="",PosPerem:=1
do case
   case tip==1  //---------------------------------------- ���⥦��...
        do case
           case main->tip_plat=0
                report(Ddir+"sft.rpt",Ddir+ReportFile,250)
           case main->tip_plat=1
                report(Ddir+"sft.rpt",Ddir+ReportFile,250)
           case main->tip_plat=2
                report(Ddir+"sftp.rpt",Ddir+ReportFile,250)
           case main->tip_plat=3
                report(Ddir+"sfinc.rpt",Ddir+ReportFile,250)
           case main->tip_plat=4
                report(Ddir+"sfto.rpt",Ddir+ReportFile,250)
                OCHPL:="06"
           case main->tip_plat=5
                report(Ddir+"sftpo.rpt",Ddir+ReportFile,250)
                OCHPL:="06"
           case main->tip_plat=6
                report(Ddir+"sftai.rpt",Ddir+ReportFile,250)
           case main->tip_plat=7
                report(Ddir+"sftpai.rpt",Ddir+ReportFile,250)
           case main->tip_plat=8
                report(Ddir+"sft.rpt",Ddir+ReportFile,250)
        endcase
        Clear Typeahead
        IF .NOT.Empty(AllTrim(PRFONTNAME))
           PlatTreWin()
        ENDIF
   case tip==2  //------------------------------------ ���-䠪���...
     do case
       case main->tip_plat>=0.and.main->tip_plat<=3.or.main->tip_plat==8
            typepay:="�� �������� ������"
            report(Ddir+"sf.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=4.and.main->tip_plat<=5
            typepay:="�� �������� ������"
            report(Ddir+"sfo.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=6.and.main->tip_plat<=7
            typepay:="�� �������� ������"
            report(Ddir+"sfai.rpt",Ddir+ReportFile,250)
     endcase
  case tip==3
     do case
       case main->tip_plat>=0.and.main->tip_plat<=3.or.main->tip_plat==8
            typepay:="� ����������� �������"
            report(Ddir+"sf.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=4.and.main->tip_plat<=5
            typepay:="� ����������� �������"
            report(Ddir+"sfo.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=6.and.main->tip_plat<=7
            typepay:="� ����������� �������"
            report(Ddir+"sfai.rpt",Ddir+ReportFile,250)
     endcase
  case tip==4
            report(Ddir+"sfn.rpt",Ddir+ReportFile,250)
  case tip==6
       cStr:=Alltrim(Licevoj->Razdel_1)+Alltrim(Licevoj->Razdel_2)
       For I=1 To Len(cStr) Step 19
           cPerem:="Kogo"+AllTrim(Str(PosPerem,1,0))
           PosPerem:=PosPerem+1
           &cPerem:=Substr(cStr,I,19)
       Next
            report(Ddir+"sfl.rpt",Ddir+ReportFile,250)
endcase
return NIL




FUNCTION MakeAbonPl(Tip)
do case
   case tip==1  //---------------------------------------- ���⥦��...
        do case
           case main->tip_plat=0
                report(Ddir+"sfta.rpt",Ddir+ReportFile,250)
           case main->tip_plat=1
                report(Ddir+"sfta.rpt",Ddir+ReportFile,250)
           case main->tip_plat=2
                report(Ddir+"sftpa.rpt",Ddir+ReportFile,250)
           case main->tip_plat=3
                report(Ddir+"sfinca.rpt",Ddir+ReportFile,250)
           case main->tip_plat=4
                report(Ddir+"sftoa.rpt",Ddir+ReportFile,250)
                OCHPL:="06"
           case main->tip_plat=5
                report(Ddir+"sftpoa.rpt",Ddir+ReportFile,250)
                OCHPL:="06"
        endcase
   case tip==2  //------------------------------------ ���-䠪���...
     do case
       case main->tip_plat>=0.and.main->tip_plat<=3
            typepay:="�� �������� ������"
            report(Ddir+"sfa.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=4.and.main->tip_plat<=5
            typepay:="�� �������� ������"
            report(Ddir+"sfao.rpt",Ddir+ReportFile,250)
     endcase
  case tip==3
     do case
       case main->tip_plat>=0.and.main->tip_plat<=3
            typepay:="� ����������� �������"
            report(Ddir+"sfa.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=4.and.main->tip_plat<=5
            typepay:="� ����������� �������"
            report(Ddir+"sfao.rpt",Ddir+ReportFile,250)
       case main->tip_plat>=6.and.main->tip_plat<=7
            typepay:="� ����������� �������"
            report(Ddir+"sfao.rpt",Ddir+ReportFile,250)
     endcase
endcase
return NIL




Function FoundBank(Lic,String)
Local Sel:=Select(),Rec:=Recno(),IsFound:=.F.
Select ToBank
Set Order To 2
Go Top
Seek Lic
IF Found()
   Do While .not.EOF()
      IF Alltrim(Substr(String,1,Len(Tip)))==AllTrim(Tip).and.LIC==Lic_Schet
//         Al_Box({Str(RecNo()),Alltrim(Substr(String,1,Len(Tip))),AllTrim(Tip)})
         IsFound:=.T.
         Exit
      ENDIF
      Skip
   EndDo
EndIf
Set Order To 1
Select(Sel); Go Rec
Return IsFound




Function FiftyDays(CalckType)
LOCAL Sel:=Select(),Rec:=RecNo(),Win:=Win_Save(),Clr:=SetColor()
Local Month,PrevMonth,Summa,MonthSaldo:=0
Private FiftySumma,cMonth:="",Nds,PlMonth,Plat_Dat,SfString:="",DOP_STR:=" "
ClackType:=IF(CalckType==NIL,1,CalckType)
plat_dat:=alltrim(str(day((new_date+1))))+"  "+mesqc(month(new_date+1),1)+;
          ' '+alltrim(str(year(new_date+1)))
month:=month_menu("����� ��� ����")
//cMonth:=IF(Month>9,"","0")+AllTrim(Str(Month))
cMonth:=Mesqc(Month)
Plmonth:=mesqc(Month)
PrevMonth:=IF(Month>1,Month-1,12)
MonthSaldo=GetSaldo(Main->Lic_Schet,PrevMonth)
MonthSaldo=IF(MonthSaldo>0,MonthSaldo,0)
FiftySumma:=Round((GetSum(Main->Lic_Schet,PrevMonth)*FiftyDays),Decimal)
//FiftySumma:=FiftySumma+Round(FiftySumma*schet_nds/100,Decimal)
//Al_Box({Str(MonthSaldo),Str(FiftySumma)})
IF CalckType==1
    IF MonthSaldo<=FiftySumma
       FiftySumma:=MonthSaldo-FiftySumma
       FiftySumma=IF(FiftySumma>0,1,-1)*FiftySumma
    ELSE
       FiftySumma:=0
    ENDIF
ENDIF

SFString:=" ��/� "+AllTrim(Str(Main->Lic_Schet))+" �� "+DTOC(new_date+1)
Nds:=Round((FiftySumma*Schet_Nds)/(100+Schet_Nds),Decimal)
cSumma1=str_chislo(FiftySumma,70)
cSumma1=cSumma1+space(70-len(cSumma1))
cSumma2=mpsum2 +space(70-len(mpsum2))
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
VidBankPlat:=Center(VidBankPlat,10," ",.t.)

DO Case
   CASE atnum("���",MYupper(licevoj->bank))>0
       TmpStr2Plat:=AllTrim(AllTrim(Licevoj->Str2Plat)+" ��� "+AllTrim(InnString)+" "+AllTrim(PotrString))
   OTHERWISE
       TmpStr2Plat:="��� "+AllTrim(InnString)+" "+AllTrim(PotrString)+" "+AllTrim(Licevoj->Str2Plat)
ENDCASE
StrPlat1:=SubStr(TmpStr2Plat,1 ,47)
StrPlat2:=SubStr(TmpStr2Plat,47+1,Len(TmpStr2Plat)-47)

Select Main
IF FiftySumma>0
   IF ChoiceBox("�㬬� � ���⠢����� "+AllTrim(Str(FiftySumma))+" ��.",{" �த������ ","��室"})==1
      Select Tobank
      IF FileLock(0)
         Append Blank
         MyRec:=RecNo()
         Go Bottom
         Schet_=Plat_Treb+1
         Go Myrec
         Replace Plat_Treb With Schet_
         Replace Summa     With FiftySumma
         Replace Data      With new_date+1
         Replace Lic_Schet With Main->Lic_Schet
         Replace Tip       With "������� ��. �� "+PlMonth
         Unlock
      ENDIF
      Select(Sel)
      IF .NOT.Empty(AllTrim(PRFONTNAME))
      		GenFiftyDays2(SCHET_)                                    // ᤥ���� ���⥦�� ��� Windows
      ELSE
      		GenFiftyDays(SCHET_)                                    // ᤥ���� ���⥦��
      ENDIF
   ENDIF
ELSE
   	 ConfirmBox(oMainWindow," ���⠢���� ��祣� ","��������",XBPMB_OK,XBPMB_WARNING+XBPMB_APPMODAL)
ENDIF
Select(Sel)
Go Rec
Win_Rest(Win)
SetColor(Clr)
Return NIL




Function GenFiftyDays(Pos)
Schet_=Pos
Do Case
   Case main->tip_plat=0.or.main->tip_plat=1
        report(Ddir+"15treb.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=2
        report(Ddir+"15trp.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=3
        report(Ddir+"15inc.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=4
        report(Ddir+"15trocb.rpt",Ddir+'otchet.gkv',170)
        OCHPL:="06"
   Case main->tip_plat=5
        report(Ddir+"15trpocb.rpt",Ddir+'otchet.gkv',170)
        OCHPL:="06"
   Case main->tip_plat=6
        report(Ddir+"15trebai.rpt",Ddir+'otchet.gkv',170)
   Case main->tip_plat=7
        report(Ddir+"15trpai.rpt",Ddir+'otchet.gkv',170)
   Otherwise
        Al_Box({"��ଠ ���⠢�塞�� ���⥦�� ��������a"})
EndCase
Return NIL
