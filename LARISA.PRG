//STATIC Dop_Path:="d:\gos\1996.123\"

FUNCTION makelimit
LOCAL month,select:=select(),recno:=recno(),poisk,ras_hod:=0,sum:=0,lim_m,nlic
LOCAL dop_path:="c:\1996\database\",dop_load,desc,crlf:=chr(13)+chr(10)
LOCAL with_debet:=.F.,tes_kvt:="���.���/�",tmp_rashod,type_limit,counter:=0
LOCAL cycle:=1,stepper:=1,str1:="",str2:="",str3:="",yes:=0,namemonth:="debet"
PRIVATE LIM_STR1,lim_str2,lim_str3,firm,kvartal:="I"
dop_path_:=Substr(Schet_Share,1,Len(Schet_Share)-3)+Substr(AllTrim(Str(Year(New_date)-1)),3)+"\"+Space(20)
//dop_path_:="s:\ose\share."+Substr(AllTrim(Str(Year(new_date)-1)),3)+"\"+Space(20)
Month1:=month_menu("��� �����")
monthdolg:=month_menu("��� ������� ������������")
NameMonth:=NameMonth+alltrim(str(int(monthdolg)))
Dop_Path=InPath(Dop_Path)
IF month1=0.or.monthdolg==0.or.empty(Dop_Path)
   RETURN NIL
ENDIF
// ��� ���� ����⮢ � ����� � ���稪��
if (!file(schet_share+"limit!.dbf"))
   copy_(schet_share+"limit.dbf",schet_share+"limit!.dbf")
endif
//-----------------------------------------------------------------
desc:=fcreate(Ddir+"otchet~.gkv")
fwrite(desc,"����� ���� �����"+crlf)
fwrite(desc,"���稪� ��襤訥 � �����:"+crlf)
fwrite(desc,replicate("�",40)+crlf)
fwrite(desc,'B �᭮���� ���� '+crlf)
//-----------------------------------------------------------------
if month1=1.or.month1=4.or.month1=7.or.month1=10
   cycle=3
endif
nlic=main->lic_schet
@ 1,0 say nlic
if month1>0
 for stepper=1 to cycle
   ras_hod=0
   month=month1+stepper-1        // ��� �������� �� ����⠫� Jan,Feb,Mac...
   do case
      case month=1
           lim_m:="JAN"
      case month=2
           lim_m:="FEB"
      case month=3
           lim_m:="MAC"
      case month=4
           lim_m:="APR"
      case month=5
           lim_m:="MAY"
      case month=6
           lim_m:="JUN"
      case month=7
           lim_m:="JUL"
      case month=8
           lim_m:="AUG"
      case month=9
           lim_m:="SEP"
      case month=10
           lim_m:="OCT"
      case month=11
           lim_m:="NOV"
      case month=12
           lim_m:="DEC"
   endcase
//@ 2,2 say lim_m
//inkey(0)
   select 77
   go top
   seek main->lic_schet
   if found()
      do while(main->lic_schet=lic_sch)
         select &month
         poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
         seek poisk
         if found()
            IF ISNONDS(tarif,Main->Lic_Schet)  && ��� ��� ��� ��� (����)?
               if summa>0.and.drug_nach=.f.
                  IF ISONLIMIT(kod)  && ��� ���稪 � �����?
                    IF IS_ON_HIGH(tarif) && ���� � �����?
                       ras_hod=ras_hod+if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0, if(rashod-subab>0,rashod-subab,subab-rashod) ,0)
                       counter++
//-----------------------------------------------------------------
fwrite(desc,licevoj->schetchik+"  ���室 "+str(if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0, if(rashod-subab>0,rashod-subab,subab-rashod) ,0))+crlf)
//-----------------------------------------------------------------
                    ENDIF
                  ENDIF
               endif
            ENDIF
         endif
         select 77
         skip
      enddo
// ����㧪a ��娢� ��諮�� ����
   dop_load=dop_path+"main.dbf"
//al_box({"���室 �� ⥪�饩 ���� "+alltrim(str(ras_hod))+" �B�"})
   select 111
   netuse(Dop_Load, , 0, "dop_main")
//   use &dop_load alias dop_main SHARED
   select 112
   dop_load=dop_path+if(month#3,lim_m,"MAR")+".dbf"
//   use &dop_load alias dop_schet SHARED
   netuse(Dop_Load, , 0, "dop_schet")
   select 111
   go top
   do while !eof()
      if val(main->dogowor)#main->lic_schet
         skip
      else
           select dop_schet
           go top
//-----------------------------------------------------------------
fwrite(desc,'B �������⥫쭮� ���� '+crlf)
//-----------------------------------------------------------------
           do while(.not.eof())
             if(dop_main->lic_schet=licevoj)
              IF ISNONDS(tarif,Licevoj)  && ��� ��� ��� ��� (����)?
                 if summa>0.and.drug_nach=.f.
                    IF ISONLIMIT(kod)  && ��� ���稪 � �����?
                       IF IS_ON_HIGH(tarif) && ���� � �����?
//-----------------------------------------------------------------
fwrite(desc,kod+" ��室 "+str(if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0, if(rashod-subab>0,rashod-subab,subab-rashod) ,0))+crlf)
//-----------------------------------------------------------------
                          ras_hod=ras_hod+if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0, if(rashod-subab>0,rashod-subab,subab-rashod) ,0)
                          counter++
                       ENDIF
                    ENDIF
                 endif
              ENDIF
             endif
             skip
           enddo
           exit
      endif
   enddo
   select 111
   use
   select 112
   use
   else
        al_box({"����� �� ���ॡ�⥫� �� �������"})
   endif
//-- ����� ����⮢
   ras_hod=ras_hod/1000    // ��� ��।������ ����� ����� ��室 �� 1000
 // � ���� ���� ����⮢ �������� ������������� ������
   select 88
 //-----------------------------------------------------------------
   fwrite(desc,replicate("�",40)+crlf)
   fwrite(desc,"�⮣� "+str(ras_hod)+crlf)
 //-----------------------------------------------------------------
   tmp_rashod=ras_hod
   if lim_tar1=0  // ���쪮 ��� �� ����� �࣠����権
      select 15 && ����⪠
//      if(debet10>0)
      if(&NameMonth>0)
 //-----------------------------------------------------------------
//        fwrite(desc,"���e��᪠� "+str(debet10)+crlf)
        fwrite(desc,"���e��᪠� "+str(&NameMonth)+crlf)
 //-----------------------------------------------------------------
        sum=(&NameMonth/schet_1new)/1000
        sum=sum/3   && ���� ������ ���� �� 3 ���
 //-----------------------------------------------------------------
        fwrite(desc,"����⭠� ����稭�: "+alltrim(str(&NameMonth))+"/"+;
               alltrim(str(schet_1new))+"/1000/3="+alltrim(str(sum))+crlf)
 //-----------------------------------------------------------------
        with_debet:=.T.
      endif
 //-----------------------------------------------------------------
      fwrite(desc,"����� "+alltrim(str(sum))+"-"+;
              alltrim(str(ras_hod))+"="+alltrim(str(sum-ras_hod))+crlf)
 //-----------------------------------------------------------------
      ras_hod=if(sum-ras_hod>0,sum-ras_hod,ras_hod-sum)
   endif
 // ����� ���������� ������������ ������
   ras_hod=round(ras_hod,1)                      // ���㣫�� �� ��ࢮ�� �����
 //-----------------------------------------------------------------
   fwrite(desc,"����祭�� ����� "+str(ras_hod)+crlf)
 //-----------------------------------------------------------------
 // �஢�ઠ ������ ���� ��� ������� ���ॡ�⥫�
   select 33
   seek main->lic_schet
   if !found()
      if netappend() //append blank
         replace lic_schet with main->lic_schet
         unlock
      endif
   else
      select 0
      dop_load=schet_share+"limit!.dbf"
      use &dop_load alias LIMIT02 SHARED
      locate for lic_schet=main->lic_schet
   //-----------------------------------------------------------------
      fwrite(desc,"����� ��諮�� ���� "+str(&lim_m)+crlf)
   //-----------------------------------------------------------------
      use
      select 33
   endif
    if( (tmp_rashod*70/100)>ras_hod)
       type_limit:=al_box({"���o����� ����� �� ������ �࠭�� �� �����"},3,;
                           {" 70% "," 30% "," ��⠢��� "})
       do case
          case type_limit=1
               ras_hod=tmp_rashod*70/100
   //-----------------------------------------------------------------
               fwrite(desc,"����� ���a���� �� �࠭�� 70% "+str(ras_hod)+crlf)
   //-----------------------------------------------------------------
          case type_limit=2
               ras_hod=tmp_rashod*30/100
   //-----------------------------------------------------------------
               fwrite(desc,"����� ���a���� �� �࠭�� 30% "+str(ras_hod)+crlf)
   //-----------------------------------------------------------------
       endcase
   endif
   // ������ ����祭���� १���� � ���� LIMIT
   //al_box({"����� "+str(ras_hod)})
    if counter=0
      al_box({'�����⠭�� ����� "0"  �� ����ᠭ',;
              '�।���������� �訡��� १����',;
              "�ந������ ���� ����� ������"})
       select(select)
       go recno
       return NIL
    endif
    if (ras_hod#0)
      select limit; go recno()
      if reclock(0)
         replace &lim_m with if(ras_hod>0,ras_hod,-1*ras_hod)
         unlock
      endif
    else
      al_box({'�����⠭�� ����� "0"  �� ����ᠭ',;
              '�।���������� �訡��� १����',;
              "�ந������ ���� ����� ������"})
    endif
//-----------------------------------------------------------------
 next
endif
//-----------------------------------------------------------------
fclose(desc)
//-----------------------------------------------------------------

select licevoj                  // ��� ���᪠ ���� � ����� ����⮢
seek main->lic_schet
if found()
   dress=adres
endif
if ras_hod#0
   if stepper>1
      do case
         case month>=1.and.month<=3
              STR1:="������   "+str(limit->jan,7,2)
              STR2:="�������  "+str(limit->feb,7,2)
              STR3:="����     "+str(limit->mac,7,2)
         case month>=4.and.month<=6
              STR1:="������   "+str(limit->apr,7,2)
              STR2:="���      "+str(limit->may,7,2)
              STR3:="����     "+str(limit->jun,7,2)
         case month>=7.and.month<=9
              STR1:="����     "+str(limit->jul,7,2)
              STR2:="������   "+str(limit->aug,7,2)
              STR3:="�������� "+str(limit->sep,7,2)
         case month>=10.and.month<=12
              STR1:="�������  "+str(limit->oct,7,2)
              STR2:="������   "+str(limit->nov,7,2)
              STR3:="�������  "+str(limit->dec,7,2)
      endcase
      yes=al_box({"����� �� ����⠫ ",str1,str2,str3,replicate("�",20),;
                  "��ନ஢��� ����� ����⮢"},2,{" ��� "," �� "})
   else
      yes=al_box({"���� �� ����� "+alltrim(str(ras_hod)),;
                  "��ନ஢��� ����� ����⮢"},2,{" ��� "," �� "})
   endif
endif

if yes=2
//---------------------------------------------------- ��� ���᫥��� ����⠫�
   do case
      case month>=1.and.month<=3
           kvartal="I"
           LIM_STR1:="������     "+str(limit->jan,7,2)
           LIM_STR2:="�������    "+str(limit->feb,7,2)
           LIM_STR3:="����       "+str(limit->mac,7,2)
      case month>=4.and.month<=6
           kvartal="II"
           LIM_STR1:="������     "+str(limit->apr,7,2)
           LIM_STR2:="���        "+str(limit->may,7,2)
           LIM_STR3:="����       "+str(limit->jun,7,2)
      case month>=7.and.month<=9
           kvartal="III"
           LIM_STR1:="����       "+str(limit->jul,7,2)
           LIM_STR2:="������     "+str(limit->aug,7,2)
           LIM_STR3:="��������   "+str(limit->sep,7,2)
      case month>=10.and.month<=12
           kvartal="IV"
           LIM_STR1:="�������    "+str(limit->oct,7,2)
           LIM_STR2:="������     "+str(limit->nov,7,2)
           LIM_STR3:="�������    "+str(limit->dec,7,2)
   endcase
   firm:=delstring(main->potrebitel,"���")
   if with_debet
      report(Ddir+"limit1.rpt",Ddir+'otchet.gkv',80)
   else
      report(Ddir+"limit2.rpt",Ddir+'otchet.gkv',80)
   endif
else
     copy_(Ddir+'otchet~.gkv',Ddir+"otchet.gkv")
endif
select(select)
go recno
return NIL






FUNCTION LimitPaket()
Local month,select:=select(),recno:=recno(),poisk,ras_hod:=0,sum:=0,lim_m
Local dop_path_:="",dop_load,tdesc,crlf:=chr(13)+chr(10)
Local with_debet:=.F.,tes_kvt:="���.���/�",tmp_rashod,type_limit,counter:=0
Local cycle:=1,stepper:=1,str1:="",str2:="",str3:="",yes:=0,desc2,filelen
Local temp_,kol_kl,window,monthdolg:=0,startlic:=0
Private LIM_STR1,lim_str2,lim_str3,firm,kvartal:="I",NoAsk:=2,IsPercent:=1
dop_path_:=Substr(Schet_Share,1,Len(Schet_Share)-3)+Substr(AllTrim(Str(Year(New_date)-1)),3)+"\"+Space(20)
//dop_path_:="s:\share."+Substr(AllTrim(Str(Year(new_date)-1)),3)+"\"+Space(20)
// if al_box({"�������� ����� �ᥬ ���ॡ�⥫�?"},2)==2
//    return NIL
// endif
startlic=getval("��楢�� ��砫� ����  ",main->lic_schet,-1)
if startlic<=0.or.lastkey()==27
   return NIL
endif
//NoAsk:=Al_Box({"������� ������ � ��⠭������ �� 㬮�砭��"},2)
month1:=month_menu("��� ���� ����⮢")
monthdolg:=month_menu("��� ������� ������������")
dop_path_=inpath(dop_path_)
if month1=0.or.monthdolg==0.or.empty(Dop_Path_)
   RETURN NIL
endif
IsPercent:=Al_Box({"������� ����� �� ����稨 ������������"},2)
// ��� ���� ����⮢ � ����� � ���稪��
if (!file(schet_share+"limit!.dbf"))
   copy_(schet_share+"limit.dbf",schet_share+"limit!.dbf")
endif
go top
tdesc=fcreate(Ddir+"otchet.gkv")
temp_=39/reccount()
kol_kl=0
Window:=obrabot("����� ����⮢ �� �ᥬ ���ॡ�⥫�")
RunSaver:=.F.                            // ����� ����祭�� �࠭�⥫� ��࠭�
do while !eof()
   IF Hot_Inkey()==27
      If Al_Box({"��ࢠ�� ����"},2)==1
         Exit
      ENDIF
   ENDIF
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
   if startlic>0
      if lic_schet>=startlic
         lim_pak2(month1,dop_path_,monthdolg,lic_schet)
         IF atnum("���������",MYUpper(Main->Potrebitel))==0.and.atnum("������",MYUpper(Main->Potrebitel))==0
            cStr:=memoread(Ddir+"otchet~.gkv")
            fwrite(tdesc,cStr)
         ENDIF
         select 88
      endif
   else
        lim_pak2(month1,dop_path_,monthdolg,lic_schet)
        IF atnum("���������",MYUpper(Main->Potrebitel))==0.and.atnum("������",MYUpper(Main->Potrebitel))==0
           cStr:=memoread(Ddir+"otchet~.gkv")
           fwrite(tdesc,cStr)
        ENDIF
        select 88
   endif
   skip
enddo
fclose(tdesc)
win_rest(window)
select(select)
go recno
M->PREV_REC=-1
RunSaver:=.T.
return NIL




FUNCTION Lim_Pak2(Month1,Dop_Path_,Monthdolg,Num_Lic)
LOCAL Month,Select:=Select(),Recno:=Recno(),Poisk,Ras_Hod:=0,Sum:=0,Lim_M
LOCAL dop_load,desc,crlf:=chr(13)+chr(10),MyTmpRashod:=0,MyMonthDolg,MyMonthPay
LOCAL with_debet:=.F.,tes_kvt:="���.���/�",tmp_rashod,type_limit,counter:=0
LOCAL cycle:=1,stepper:=1,str1:="",str2:="",str3:="",yes:=0,namemonth:="debet"
PRIVATE LIM_STR1,lim_str2,lim_str3,firm,kvartal:="I",MonthName:=Mesqc(MonthDolg)
NameMonth:=namemonth+alltrim(str(int(monthdolg)))
IF month1=1.or.month1=4.or.month1=7.or.month1=10
   cycle=3
ENDIF
IF Month1>0
    dop_path=dop_path_
    counter=0
//@ 2,2 say alltrim(str(main->lic_schet))
  for stepper=1 to cycle
   ras_hod=0
   month=month1+stepper-1        // ��� �������� �� ����⠫� Jan,Feb,Mac...
   do case
      case month=1
           lim_m:="JAN"
      case month=2
           lim_m:="FEB"
      case month=3
           lim_m:="MAC"
      case month=4
           lim_m:="APR"
      case month=5
           lim_m:="MAY"
      case month=6
           lim_m:="JUN"
      case month=7
           lim_m:="JUL"
      case month=8
           lim_m:="AUG"
      case month=9
           lim_m:="SEP"
      case month=10
           lim_m:="OCT"
      case month=11
           lim_m:="NOV"
      case month=12
           lim_m:="DEC"
   endcase
   SELECT Licevoj
   SEEK Num_Lic
   IF Found()
//    ����㧪a ��娢� ��諮�� ����
      dop_load=dop_path+"main.dbf"
//    al_box({"���室 �� ⥪�饩 ���� "+alltrim(str(ras_hod))+" �B�"})
      select 111
      netuse(dop_load,,,"dop_main")
//      use &dop_load alias dop_main  SHARED
      select 112
      dop_load=dop_path+if(month#3,lim_m,"MAR")+".dbf"
//      use &dop_load alias dop_schet SHARED
      netuse(dop_load,,,"dop_schet")
      select 111
      go top
      do while !eof()
         if Lic_Schet#Num_Lic
            skip
         else
              select dop_schet
              go top
              do while(.not.eof())
                if(dop_main->lic_schet=licevoj)
                 IF ISNONDS(tarif,Licevoj)  && ��� ��� ��� ��� (����)?
                    if summa>0.and.drug_nach=.f.
                       IF ISONLIMIT(kod)  && ��� ���稪 � �����?
                          IF IS_ON_HIGH(tarif) && ���� � �����?
                             ras_hod=ras_hod+if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0, if(rashod-subab>0,rashod-subab,subab-rashod) ,0)
                             counter++
                          ENDIF
                       ENDIF
                    endif
                 ENDIF
                endif
                skip
              enddo
              exit
         endif
      enddo
      select 111
      use
      select 112
      use
   else
//        Message_Wait("�� �/�� N"+Alltrim(Str(Main->Lic_Schet))+" ����� �� ������� ",1)
//        al_box({"����� �� ���ॡ�⥫� �� �������"})
   endif
//---------------------------------------------------------- ����� ����⮢
   ras_hod=Round(ras_hod/1000,1)    // ��� ��।������ ����� ����� ��室 �� 1000
//   al_box({"����祭�� ��室 �� ����� "+str(ras_hod)+" "+str(ras_hod*1000)})
 // �஢�ઠ ������ ���� ��� ������� ���ॡ�⥫�
   select 33
   seek main->lic_schet
   IF !Found()
      IF NetAppend(0)                           // Append Blank
         replace lic_schet with main->lic_schet
         unlock
      ENDIF
   ELSE
//      select 0
//      dop_load=schet_share+"limit!.dbf"
//      netuse(dop_load,,,"limit2")
//      locate for lic_schet=main->lic_schet
//      old_lim:=&lim_m
//      use
//      select 33
   ENDIF
   MyMonthDolg:=GetDolg(Num_Lic,MonthDolg)
   MyMonthPay:= CalckPay(MonthDolg,Num_Lic,.f.)
   DO Case
      Case IsPercent==1
           DO CASE
              CASE FulLimit(Main->Lic_Schet)
                   Ras_Hod:=Ras_Hod
              CASE main->lim_tar1#0             // ��⭠� �࣠������
                   Ras_Hod:=Ras_Hod
              CASE PartLimit(Main->Lic_Schet)
//                   Ras_Hod:=Round(Ras_Hod*70/100,2)
              CASE MyMonthDolg!=0.AND.MyMonthPay!=0
                   Ras_Hod:=Ras_Hod
              CASE MyMonthDolg!=0.AND.MyMonthPay==0
                   Ras_Hod:=0
           ENDCASE
           IF Ras_Hod=0
              Ras_Hod:=0.5
           ENDIF
           IF RecLock(0)
              IF (atnum("���������",MYUpper(Main->Potrebitel))!=0.or.;
                 atnum("������",MYUpper(Main->Potrebitel))!=0).and.Ras_Hod==0.and.MyMonthDolg==0
                 replace &lim_m with  0.5
              ELSE
                 replace &lim_m with  ras_hod
              ENDIF
              UNLOCK
           ENDIF
      Case IsPercent==2
           IF Ras_Hod=0
              Ras_Hod:=0.5
           ENDIF
           IF RecLock(0)
              IF (atnum("���������",MYUpper(Main->Potrebitel))!=0.or.;
                 atnum("������",MYUpper(Main->Potrebitel))!=0).and.Ras_Hod==0
                 replace &lim_m with  0.5
              ELSE
                 replace &lim_m with  ras_hod
              ENDIF
              UNLOCK
           ENDIF
   ENDCASE
//-----------------------------------------------------------------
  NEXT
ENDIF
//------------------------------------------------- ��ନ஢���� ����
select licevoj                  // ��� ���᪠ ���� � ����� ����⮢
seek main->lic_schet
if found()
   dress=adres
endif
do case
   case month>=1.and.month<=3
        kvartal="I"
        LIM_STR1:="������     "+str(limit->jan,7,2)
        LIM_STR2:="�������    "+str(limit->feb,7,2)
        LIM_STR3:="����       "+str(limit->mac,7,2)
   case month>=4.and.month<=6
        kvartal="II"
        LIM_STR1:="������     "+str(limit->apr,7,2)
        LIM_STR2:="���        "+str(limit->may,7,2)
        LIM_STR3:="����       "+str(limit->jun,7,2)
   case month>=7.and.month<=9
        kvartal="III"
        LIM_STR1:="����       "+str(limit->jul,7,2)
        LIM_STR2:="������     "+str(limit->aug,7,2)
        LIM_STR3:="��������   "+str(limit->sep,7,2)
   case month>=10.and.month<=12
        kvartal="IV"
        LIM_STR1:="�������    "+str(limit->oct,7,2)
        LIM_STR2:="������     "+str(limit->nov,7,2)
        LIM_STR3:="�������    "+str(limit->dec,7,2)
endcase
firm:=delstring(main->potrebitel,"���")
IF atnum("���������",MYUpper(Main->Potrebitel))==0.and.atnum("������",MYUpper(Main->Potrebitel))==0
   DO Case
      Case IsPercent==1
           IF Ras_Hod==0
              Report(Ddir+"limit11.rpt",Ddir+'otchet~.gkv',80)
           ELSE
              Report(Ddir+"limit2.rpt",Ddir+'otchet~.gkv',80)
           ENDIF
      Case IsPercent==2
           Report(Ddir+"limit2.rpt",Ddir+'otchet~.gkv',80)
   EndCase
ELSE
   DeleteFile(Ddir+'otchet~.gkv')
ENDIF
select(select)
go recno
return NIL




STATIC Function FulLimit(LicSchet)
Local IsFulLimit:=.F.
LOCAL FulLimit :="12,116,134,345"
FOR I=1 TO NumToken(FulLimit,",;")
    IF Val(Token(FulLimit,",;",I))==LicSchet
       IsFulLimit:=.T.
       Exit
    ENDIF
NEXT
Return IsFulLimit


STATIC Function PartLimit(LicSchet)
Local IsPartLimit:=.F.
LOCAL PartLimit:="46,117,128,198,364,447,497,648,1175,1184,1190,1200,1215,1251,1410,1411,1412,1413,1414,1415,1416,1417,1418"
FOR I=1 TO NumToken(PartLimit,",;")
    IF Val(Token(PartLimit,",;",I))==LicSchet
       IsPartLimit:=.T.
       Exit
    ENDIF
NEXT
Return IsPartLimit



FUNCTION InPath(Path)
local OldColor:=setcolor(),OldScr:=Win_Save(10,23,14,59)
Path=Path+space(29-len(Path))
set color to "n/w"
colorwin(11,24,14,59,'n+/n')
@ 10,23 SAY "���������������������������������ķ"
@ 11,23 SAY "�  ���� � ���� ������ "+alltrim(str(year(New_date)-1))+" ����   �"
@ 12,23 SAY "�                                 �"
@ 13,23 SAY "���������������������������������ͼ"
set color to &GetColor
set cursor on
set confirm on
@ 12,26 get Path Picture "@KS27"
read
set cursor off
set confirm off
Clear Typeahead
setcolor(OldColor)
Win_Rest(OldScr)
RETURN Alltrim(Path)







Function SvIspLim()
Local Sel:=Select(),Rec:=Recno(),Scr,Clr:=SetColor(),Kol_Kl:=0,CrLf:=Chr(13)+Chr(10)
Local KB:={258,1417,1693,441,401,1332,508,951,78,442,27}
Local MB:={46,201,2006,117,270,364,1226,2002,1184,1215,497,1410,1411,1412,1413,1414,1415,1416,1418,1175,564,1226,;
           1617,1669,1751,1773,1774,1780,1781,1784,1785,1786,1787,1790,1793,1798,1799,1801,1802,1803,;
           1804,1806,1807,1808,1809,1810,1811,1820,1821,1824,1830,1841,1843,1789,1796,1200}
Local FB:={14,26,29,35,37,74,77,100,124,132,144,153,182,198,211,237,332,419,432,531,568,679,750,788,840,1000,1103,1847,;
           60,215,695,1036,1120,1170,1709,1237,13}
Local KBstr:={},MBstr:={},Month,Desc,Symbols:=34,EMonth,TmpArr:={0,0,0,0,0}
Month:=Month_Menu("��� ��砫� ���� ᢥ����� � ������")
eMonth:=Month_Menu("��� ����砭�� ���� ᢥ����� � ������")
IF Month<0.or.Month>12.or.eMonth<0.or.eMonth>12
   Return NIL
ENDIF
Scr:=Obrabot("����� ᢥ����� � �ᯮ�짮����� ����⮢")
Go Top
Do While !EOF()
   kol_kl=kol_kl+(39/reccount())
   colorwin(12,21,12,21+kol_kl,'n/n')
   For i=1 to Len(KB)
       IF KB[i]==Lic_Schet
          TmpArr:={0,0,0,0,0}
          For j=Month To eMonth
              TmpArr[1]:=TmpArr[1]+GetLimit(j,Main->Lic_Schet)
              IF Bit_Test(BitStr,2)
                 TmpArr[2]:=TmpArr[2]+Round(GetLimit(j,Main->Lic_Schet)*OtherTar1*(100+Schet_NDS)/100,1)
              ELSE
                 TmpArr[2]:=TmpArr[2]+Round(GetLimit(j,Main->Lic_Schet)*Schet_1New*(100+Schet_NDS)/100,1)
              ENDIF
              TmpArr[3]:=TmpArr[3]+GetRashod(Main->Lic_Schet,j)
              TmpArr[4]:=TmpArr[4]+GetSum(Main->Lic_Schet,j)
              TmpArr[5]:=TmpArr[5]+CalckPay(j,Main->Lic_Schet,.f.)
          Next
          AADD(KBstr,{SubStr(Str(Lic_Schet,4,0)+" "+Delstring(Potrebitel,"���")+Space(Symbols),1,Symbols),;
                      TmpArr[1],TmpArr[2],;
                      Round(TmpArr[3]/1000,1),Round(TmpArr[4]/1000,1),Round(TmpArr[5]/1000,1)})
          Exit
       ENDIF
   Next
   For i=1 to Len(MB)
       IF MB[i]==Lic_Schet
          TmpArr:={0,0,0,0,0}
          For j=Month To eMonth
              TmpArr[1]:=TmpArr[1]+GetLimit(j,Main->Lic_Schet)
              IF Bit_Test(BitStr,2)
                 TmpArr[2]:=TmpArr[2]+Round(GetLimit(j,Main->Lic_Schet)*OtherTar1*(100+Schet_NDS)/100,1)
              ELSE
                 TmpArr[2]:=TmpArr[2]+Round(GetLimit(j,Main->Lic_Schet)*Schet_1New*(100+Schet_NDS)/100,1)
              ENDIF
              TmpArr[3]:=TmpArr[3]+GetRashod(Main->Lic_Schet,j)
              TmpArr[4]:=TmpArr[4]+GetSum(Main->Lic_Schet,j)
              TmpArr[5]:=TmpArr[5]+CalckPay(j,Main->Lic_Schet,.f.)
          Next
          AADD(MBstr,{SubStr(Str(Lic_Schet,4,0)+" "+Delstring(Potrebitel,"���")+Space(Symbols),1,Symbols),;
                      TmpArr[1],TmpArr[2],;
                      Round(TmpArr[3]/1000,1),Round(TmpArr[4]/1000,1),Round(TmpArr[5]/1000,1)})
          Exit
       ENDIF
   Next
   Skip
ENDDO
Desc:=Fcreate(DDir+ReportFile)
FWrite(Desc,Center("� � � � � � � �",70)+CrLf)
FWrite(Desc,Center("�� �ᯮ�짮����� ����⮢ �����ய��ॡ����� ���ॡ�⥫ﬨ,",70)+CrLf)
FWrite(Desc,Center("䨭����㥬묨 �� �ࠥ����, ���⭮�� ��⮢",70)+CrLf)
IF Month==eMonth
   FWrite(Desc,Center("�� "+Mesqc(Month)+' '+alltrim(str(Year(New_date)))+'�. �� '+SchetNameOrg,70)+CrLf)
ELSE
   FWrite(Desc,Center("�� "+Mesqc(Month)+'-'+Mesqc(eMonth)+' '+Alltrim(Str(Year(New_date)))+'�. �� '+SchetNameOrg,70)+CrLf)
ENDIF
FWrite(Desc,"�����������������������������������������������������������������������������Ŀ"+CrLf)
FWrite(Desc,"�                                  ������ �����ள                  �����.���.�"+CrLf)
FWrite(Desc,"�    ������������ ���ॡ�⥫�      � ���ॡ����� �    �����᪨    �� ���,����"+CrLf)
FWrite(Desc,"�                                  ��� ���.��ਮ��                  �����,�।�"+CrLf)
FWrite(Desc,"�                                  � ���/� ��  � ���/� �  ��     � ������. �"+CrLf)
FWrite(Desc,"�����������������������������������������������������������������������������Ĵ"+CrLf)
FWrite(Desc,"� �����                            �"+Str(SumArr(KBstr,2)+SumArr(MBstr,2),6,1)+"�"+Str(SumArr(KBstr,3)+SumArr(MBstr,3),6,1)+"�"+;
           Str(SumArr(KBstr,4)+SumArr(MBstr,4),7,1)+"�"+Str(SumArr(KBstr,5)+SumArr(MBstr,5),10,1)+"�"+;
           Str(SumArr(KBstr,6)+SumArr(MBstr,6),9,1)+"�"+CrLf)
FWrite(Desc,"�   �ࠥ��� ��� �ᥣ�           �"+Str(SumArr(KBstr,2),6,1)+"�"+Str(SumArr(KBstr,3),6,1)+"�"+;
           Str(SumArr(KBstr,4),7,1)+"�"+Str(SumArr(KBstr,5),10,1)+"�"+;
           Str(SumArr(KBstr,6),9,1)+"�"+CrLf)
FWrite(Desc,"�  � ⮬ �᫥:                    �      �      �       �          �         �"+CrLf)

FOR i=1 TO Len(KBstr)
    FWrite(Desc,"�"+KBstr[i][1]+"�"+Str(KBstr[i][2],6,1)+"�"+Str(KBstr[i][3],6,1)+"�"+;
           Str(KBstr[i][4],7,1)+"�"+Str(KBstr[i][5],10,1)+"�"+;
           Str(KBstr[i][6],9,1)+"�"+CrLf)
NEXT
FWrite(Desc,"�   ����� ��� �ᥣ�           �"+Str(SumArr(MBstr,2),6,1)+"�"+Str(SumArr(MBstr,3),6,1)+"�"+;
           Str(SumArr(MBstr,4),7,1)+"�"+Str(SumArr(MBstr,5),10,1)+"�"+;
           Str(SumArr(MBstr,6),9,1)+"�"+CrLf)
FWrite(Desc,"�  � ⮬ �᫥:                    �      �      �       �          �         �"+CrLf)
FOR i=1 TO Len(MBstr)
    FWrite(Desc,"�"+MBstr[i][1]+"�"+Str(MBstr[i][2],6,1)+"�"+Str(MBstr[i][3],6,1)+"�"+Str(MBstr[i][4],7,1)+"�"+Str(MBstr[i][5],10,1)+"�"+Str(MBstr[i][6],9,1)+"�"+CrLf)
NEXT
FWrite(Desc,"�������������������������������������������������������������������������������"+CrLf)
FWrite(Desc,CrLf+CrLf+"  ��४��  "+SchetNameOrg+"           �.�.������"+CrLf)
FClose(Desc)
Select(Sel)
Go Rec
SetColor(Clr)
Win_Rest(Scr)
Return NIL



Function SumArr(Array,Pos)
Local SumArr:=0
For I=1 to Len(Array)
    SumArr:=SumArr+Array[i][Pos]
Next
Return SumArr