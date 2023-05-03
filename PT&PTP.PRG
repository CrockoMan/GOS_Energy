Function Pt(Number,Pl)
Local Old_Sel:=Select()
Private Str1,Sm_String,Tratata,A_Aas,Mes_Name,cSumma1:="",cSumma2:=""
Private StrPlat1,StrPlat2,OCH_PL:="06"
plat_dat:=alltrim(str(day((new_date+1))))+"  "+mesqc(month(new_date+1),1)+;
          ' '+alltrim(str(year(new_date+1)))
If Penq=0
   Deletefile(Ddir+ReportFile)
   Return NIL
Else
// ‘ã¬¬  ¯¥­¨ ¯à®¯¨áìî
   cSumma1=str_chislo(Penq,70)
   cSumma1=cSumma1+space(70-len(cSumma1))
   cSumma2=mpsum2 +space(70-len(mpsum2))
// ------------------------------------------------------------------------
   a_aas=xtoc(new_date+1)
   select licevoj
   seek main->lic_schet
   data_pl:=Pl
//   Al_Box({Data_Pl})
   mes_name:=mesqc(month_)
   POTRSTRING=delstring(main->potrebitel,"ˆ")
   POTRSTRING=Delstring(delstring(main->potrebitel,"ˆ"),"Š")
   INNSTRING=Alltrim(Substr(appendstring(main->potrebitel,"ˆ"),4,11))
   KPPSTRING=Alltrim(Substr(appendstring(main->potrebitel,"Š"),4,11))
   TOWNSTRING=substr(appendstring(MYupper(licevoj->bank),MYupper("£.")),3)
   TOWNSTRING=substr(townstring,1,1)+lower(substr(townstring,2))
   TmpStr2Plat:="ˆ "+AllTrim(InnString)+" "+AllTrim(PotrString)+" "+AllTrim(Licevoj->Str2Plat)
   StrPlat1:=SubStr(TmpStr2Plat,1 ,LenBank-10)
//   StrPlat2:=SubStr(TmpStr2Plat,LenBank-10+1,Len(TmpStr2Plat)-LenBank-10)
   StrPlat2:=SubStr(TmpStr2Plat,LenBank-10+1)
//   @ 1,0 say StrPlat1
//   @ 2,0 Say StrPlat2
//   Inkey(0)
   IF atnum("žƒ€Š",MYupper(licevoj->bank))>0
      OCHPL:="05"
   ELSE
      OCHPL:="06"
   ENDIF
   if atnum("€€€",MYupper(licevoj->bank))>0
      gruzpol:=alltrim(alltrim(potrstring)+" "+alltrim(main->adress))
      VidBankPlat:=""
   else
//      VidBankPlat:="®çâ®©"
      VidBankPlat:="      "
      gruzpol:=alltrim(alltrim(LICEVOJ->object1)+" "+alltrim(LICEVOJ->object2)+alltrim(main->adress))
   endif
   VidBankPlat:=Center(VidBankPlat,10," ",.t.)
   do case
      case main->tip_plat=0
           report(ddir+"penqtreb.rpt",ddir+ReportFile,170)
      case main->tip_plat=1
           report(ddir+"penqtreb.rpt",ddir+ReportFile,170)
      case main->tip_plat=2
           report(ddir+"penqtrp.rpt",ddir+ReportFile,170)
      case main->tip_plat=3
           report(ddir+"penqinc.rpt",ddir+ReportFile,170)
      case main->tip_plat=4
           report(ddir+"ptr_ocb.rpt",ddir+ReportFile,170)
           OCHPL:="06"
      case main->tip_plat=5
           report(Ddir+"ptrp_ocb.rpt",Ddir+ReportFile,170)
           OCHPL:="06"
      case main->tip_plat=6
           report(Ddir+"penqtrai.rpt",Ddir+ReportFile,170)
      case main->tip_plat=7
           report(Ddir+"penqtrpa.rpt",Ddir+ReportFile,170)
      otherwise
           al_box({"”®à¬  ¢ëáâ ¢«ï¥¬®© ¯« â¥¦ª¨ ­¥¨§¢¥áâ­a"})
   endcase
        Clear Typeahead
        IF .NOT.Empty(AllTrim(PRFONTNAME))
           PenqPlatTreWin()
        ENDIF
   IF Al_Box({"‘ä®à¬¨à®¢ âì áç¥â - ä ªâãàã"},2)==1
      Copy_(DDir+ReportFile,DDir+"TmpFile.Tmp")
      MakeSFPenq(Data_Pl)
      IF File(DDir+ReportFile)
         IF  Al_Box({"Žâ¯¥ç â âì áç¥â - ä ªâãàã"},2)==1
            Print_Fi(.t.)
//            Copy_(DDir+ReportFile,"LPT1")
         ENDIF
      ENDIF
      Copy_(DDir+"TmpFile.Tmp",DDir+ReportFile)
      DeleteFile(DDir+"TmpFile.Tmp")
   ENDIF
   select(old_sel)
endif
return NIL


Function MakeSfPenq(PlD)
OldSel:=Select()
a_aas=xtoc(new_date+1)
select licevoj
seek main->lic_schet
data_pl:=PlD
mes_name:=mesqc(month_)
POTRSTRING=delstring(main->potrebitel,"ˆ")
INNSTRING=appendstring(main->potrebitel,"ˆ")
TOWNSTRING=substr(appendstring(MYupper(licevoj->bank),MYupper("£.")),3)
TOWNSTRING=substr(townstring,1,1)+lower(substr(townstring,2))
IF atnum("€€€",MYupper(licevoj->bank))>0
   Gruzpol:=alltrim(alltrim(potrstring)+" "+alltrim(main->adress))
      VidBankPlat:=""
ELSE
//      VidBankPlat:="®çâ®©"
      VidBankPlat:="      "
   gruzpol:=alltrim(alltrim(LICEVOJ->object1)+" "+alltrim(LICEVOJ->object2)+alltrim(main->adress))
ENDIF
DO Case
   CASE atnum("Š–",MYupper(licevoj->bank))>0
       TmpStr2Plat:=AllTrim(AllTrim(Licevoj->Str2Plat)+" ˆ "+AllTrim(InnString)+" "+AllTrim(PotrString))
   OTHERWISE
       TmpStr2Plat:="ˆ "+AllTrim(InnString)+" "+AllTrim(PotrString)+" "+AllTrim(Licevoj->Str2Plat)
ENDCASE
StrPlat1:=SubStr(TmpStr2Plat,1 ,LenBank)
StrPlat2:=SubStr(TmpStr2Plat,LenBank+1,Len(TmpStr2Plat)-LenBank)
VidBankPlat:=Center(VidBankPlat,10," ",.t.)
IF Main->Tip_Plat>=4
   report(Ddir+"SFPocb.rpt",Ddir+ReportFile,170)
ELSE
   report(Ddir+"SFP.rpt",Ddir+ReportFile,170)
ENDIF
Select(OldSel)
Return NIL
