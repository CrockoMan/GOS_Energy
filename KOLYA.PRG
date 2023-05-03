function CheckAbon
LOCAL recno:=recno(),select:=select(),screen:=win_save(),color:=setcolor()
LOCAL work_day:=24,schetchiks:=0,peoples:=1,rec,desc,CrLf:=chr(13)+chr(10)
local sperday:=4,spotr,Mystep:=0,prevlic:=-1,wdblank:=1,sdat:=New_date
LOCAL dat_pr
SET COLOR TO N/W,w/n,,,n/w
colorwin(10,16,16,60,"n+/n")
//@ 09,15,13,59 BOX "         "
@ 09,15 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·"
@ 10,15 SAY "³ Š®«¨ç¥áâ¢® à ¡®ç¨å ¤­¥©                   º"
@ 11,15 SAY "³ Š®«¨ç¥áâ¢® áç¥âç¨ª®¢                      º"
@ 12,15 SAY "³ Š®«¨ç¥áâ¢® ç¥«®¢¥ª                        º"
@ 13,15 SAY "³ ‘ç¥âç¨ª®¢ ¢ ¤¥­ì                          º"
@ 14,15 SAY "³ „ â  ¯¥à¢®© ¯à®¢¥àª¨                      º"
@ 15,15 SAY "ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
select 77
rec=recno()
go top
do while !eof()
   		schetchiks++
   skip
enddo
go rec
@ 11,42 say alltrim(str(schetchiks))
set cursor on
set confirm on
@ 10,42 get work_day picture "@K 999"
@ 12,42 get peoples  picture "@K 999"
@ 13,42 get sperday  picture "@K 999"
@ 14,42 get sdat     picture "@D"
read
if lastkey()=27
   Clear Typeahead
   set cursor off
   set confirm off
   select(select)
   go recno
   setcolor(color)
   win_rest(screen)
   return NIL
endif
Clear Typeahead
set cursor off
set confirm off
desc:=fcreate(Ddir+"otchet.gkv")
fwrite(desc,center("ƒà ä¨ª ¯à®¢¥àª¨ â¥å­¨ç¥áª®£® á®áâ®ï­¨ï ¯à¨¡®à®¢",75," ",.t.)+crlf)
fwrite(desc,center("ãç¥â  í«¥ªâà®í­¥à£¨¨ á "+dtoc(sdat),75," ",.t.)+crlf+crlf)
select(select)
Select main
go top
//step:=peoples*sperday
dat_pr=sdat
do while !eof()
   Select 77
   Seek Main->Lic_Schet
   Do While Lic_Sch==Main->Lic_Schet
      IF Atnum("’…ˆ",MYUpper(Schetchik))==0.and.;
         Atnum("€",MYUpper(Schetchik))==0.and.;
         Atnum("‚‡‚€’",MYUpper(Schetchik))==0.and.;
         Atnum("‘’.",MYUpper(Schetchik))==0
          if Mystep=0
             if dow(dat_pr)=1
                   dat_pr++
             endif
             if dow(dat_pr)=7
                dat_pr=dat_pr+2
             endif
             Mystep:=peoples*sperday
             fwrite(desc,replicate("-",20)+"„¥­ì N"+alltrim(str(wdblank))+;
                         " "+dtoc(dat_pr)+" "+replicate("-",20)+"     ˆá¯®«­¨â¥«ì"+crlf)
             select 88
             fwrite(desc,Str(Main->Lic_Schet,5,0)+" "+main->potrebitel+crlf)
             select 77
             wdblank++
             dat_pr++
          endif
          if prevlic#lic_sch
             prevlic=lic_sch
             select 88
             seek licevoj->lic_sch
             fwrite(desc,main->potrebitel+crlf)
             select 77
          endif
          fwrite(desc,space(4)+schetchik+;
          " "+tip+" "+AllTrim(Adres)+" "+alltrim(Object1)+crlf)
          Mystep=Mystep-1
      ENDIF
    Select Licevoj
    skip
   ENDDO
   Select Main
   skip
enddo
fclose(desc)
select(select)
go recno
setcolor(color)
win_rest(screen)
return NIL




function kolya(FoundString)
LOCAL select:=select(),recno:=recno(),screen:=win_save(8,12,14,67)
LOCAL kol_mes,obr_scr,start_mes,desc,debstr,str_deb,cou_deb,sum_deb
LOCAL crlf:=chr(13)+chr(10),color:=setcolor(),temp_,kol_kl,str_kre,total:=0
LOCAL tot_sum:=0,sel,LenTablica,LenString:=0,opl:=0,CalcMes:=0
//--------------------------------------- ¥à¥¬¥­­ë¥ ¤«ï ä®à¬¨à®¢ ­¨ï â ¡«¨æë
LOCAL Len_Page:=42,Is_Shapka:=.T.,Pres_String:=0,End_Write:=.F.,Pages:=1
LOCAL OneStringLen:=111
//---------------------------------------------------------------------------
start_mes:=month_menu()
kol_mes=start_mes
if start_mes>0
   colorwin(09,13,14,67,'n+/n')
   set color to n/w,n/g
   @ 08,12 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·"
   @ 09,12 say "³"+space(53)+"º"
   @ 10,12 say "³   “ª ¦¨â¥ ¤«¨â¥«ì­®áâì § ¤®«¦¥­­®áâ¨    (¬¥á.)      º"
   @ 11,12 say "³   â áã¬¬ë                   „® áã¬¬ë               º"
   @ 12,12 say "³"+space(53)+"º"
   @ 13,12 say "ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
   min_dolg=0
   max_dolg=9999999
   set cursor on
   @ 10,51 get kol_mes picture "@K 99"
   @ 11,26 get min_dolg picture "@K"
   @ 11,53 get max_dolg picture "@K"
   read
   set cursor off
   setcolor(color)
   if lastkey()#27
    if kol_mes>0
     if kol_mes<=start_mes
        Clear Typeahead
        Delitel:=GetVal("’®ç­®áâì ¢ë¢®¤¨¬ëå ¤ ­­ëå ",1000,0)
        Delitel:=IF(Delitel==0,1,Delitel)
       kol_mes=kol_mes-1
       desc=fcreate(Ddir+"otchet.gkv")
// ˆ§¬¥­¥­¨¥ ®à¨¥­â æ¨¨ áâà ­¨æë ¯à¨­â¥à  ­  LANDSCAPE
       fwrite(desc,chr(27)+chr(38)+chr(108)+chr(49)+chr(79))
       fwrite(desc,"‚ë¡®àª  § ¤®«¦­¨ª®¢. ¥à¨®¤ "+mesqc(start_mes-kol_mes)+;
              " - "+mesqc(start_mes)+" â®ç­®çâì 1:"+alltrim(str(Delitel))+crlf)
       fwrite(desc,if(min_dolg#0,"â áã¬¬ë ­¥ ¬¥­¥¥ "+alltrim(str(min_dolg))+" ","")+;
                   if(max_dolg#999999999999,"„® áã¬¬ë ­¥ ¡®«¥¥ "+alltrim(str(max_dolg)),"")+CrLf)
//---------------------------------------------------------------------------
       pres_string=2                   && “¦¥ áâà®ç¥ª ¢ áâà ­¨æ¥ § ¯®«­¥­®...
//---------------------------------------------------------------------------
       LenTablica=54+len(str(main->lic_schet))+len(main->potrebitel)
       obr_scr:=obrabot("‚ë¡®àª  §«®áâ­ëå § ¤®«¦­¨ª®¢ ")
       temp_=39/reccount()
       kol_kl=0
       go top
       do while !eof()
//-------------------------------------------------- „®¡ ¢«¥­¨¥ è ¯ª¨ â ¡«¨æë
          IF IS_SHAPKA
             IF PAGES#1
                fwrite(desc,space(OneStringLen-12)+"‹¨áâ N "+alltrim(str(pages))+crlf)
             ENDIF
             fwrite(desc,"Ú"+replicate("Ä",len(str(main->lic_schet)))+;
                "Â"+replicate("Ä",len(main->potrebitel)-90)+;
                "Â"+replicate("Ä",19)+"Â"+replicate("Ä",23)+"Â"+replicate("Ä",8)+;
                "·"+crlf)

             fwrite(desc,"³"+center("‹/á",len(str(main->lic_schet))," ",.t.)+"³"+;
                    center(" ¨¬¥­®¢ ­¨¥ ®à£ ­¨§ æ¨¨",len(main->potrebitel)-90," ",.t.)+;
                    "³‘ã¬¬  § ¤®«¦¥­­®áâ¨³ ¥à¥ç¥­ì ¯à¨­ïâëå ¬¥à ³¯« ç¥­®º"+crlf)
             IS_SHAPKA=.F.
             END_WRITE=.F.
             pres_string=pres_string+3
          ENDIF
          select 15
          seek main->lic_schet
          kol_kl=kol_kl+temp_
          colorwin(12,21,12,21+kol_kl,'n/n')
          if found()
           IF FoundString==NIL.or.atnum(FoundString,;
              MYupper(alltrim(main->potrebitel)),1)>0
             cou_deb=0
             sum_deb=0
             deb_str=""
             for i=start_mes-kol_mes to start_mes
                 str_deb="debet"+alltrim(str(int(i)))
                 str_kre="kredit"+alltrim(str(int(i)))
                 if(&str_deb>0.and.&str_kre=0)
//*********************************** ‚ë¡®àª  áã¬¬ ®â MIN ¤® MAX
                  if (min_dolg<=&str_deb) .and. (max_dolg>=&str_deb)
                   cou_deb=cou_deb+1
                   if i#start_mes
                      deb_str=str(&str_deb,15,2)
                      sum_deb=sum_deb+&str_deb
                   endif
                  endif
                 endif
             next
             if cou_deb-1=kol_mes
                sel=select()
                CalcMes:=Start_Mes-Kol_Mes
                opl:=0
                do while(CalcMes!=0)
                   select 0
                   netuse(schet_share+"o"+alltrim(str(int(CalcMes)))+".dbf",,0,"oplata")
                   go top
                   do while .not.eof()
                      if main->lic_schet==licevoj
                         opl=opl+summa
                      endif
                      skip
                   enddo
                   use
                   CalcMes++
                   CalcMes=IF(CalcMes>Start_Mes,0,CalcMes)
                enddo
                opl:=round(opl/Delitel,1)
                select 77                       && „«ï ¯®¨áª   ¤à¥á .
                seek main->lic_schet
                select(sel)
//---------------------------------------------------------------------------
                fwrite(desc,"Ã"+replicate("Ä",len(str(main->lic_schet)))+;
                "Å"+replicate("Ä",len(main->potrebitel)-90)+;
                "Å"+replicate("Ä",19)+"Å"+replicate("Ä",23)+"Å"+replicate("Ä",8)+;
                "¶"+crlf)
//---------------------------------------------------------------------------
                LenString=len("|"+str(main->lic_schet)+"|"+delstring(alltrim(main->potrebitel),"ˆ"))+;
                len(main->potrebitel)-;
                len(delstring(alltrim(main->potrebitel),"ˆ"))+;
                len("|   "+str(&str_deb/Delitel,15,2))
                fwrite(desc,"³"+str(main->lic_schet)+"³"+;
                       Substr(delstring(alltrim(main->potrebitel),"ˆ")+;
                       space(len(main->potrebitel)-;
                       len(delstring(alltrim(main->potrebitel),"ˆ"))),1,60)+;
                       "³   "+str(&str_deb/Delitel,15,2)+" ³                       ³ "+str(opl,6,1)+" º"+;  // space(LenTablica-LenString-3)+"º"+;
                       crlf+'³'+space(len(str(main->lic_schet)))+'³'+;
                       alltrim(licevoj->adres)+" ’¥«."+alltrim(licevoj->telefon)+space(len(main->potrebitel)-90-len(alltrim(licevoj->adres)+" ’¥«."+alltrim(licevoj->telefon)))+;
                       "³                   ³                       ³        º"+crlf)
                total=total+1
                tot_sum=tot_sum+&str_deb
//---------------------------------------------------------------------------
                pres_string=pres_string+3              &&  3 áâà®çª¨ § ¯¨á ­®
//---------------------------------------------------------------------------
             endif
           ENDIF
          endif
          select 88
          skip
          IF PRES_STRING>=LEN_PAGE
             PRES_STRING=0
             IS_SHAPKA=.T.
             PAGES++
             fwrite(desc,"Ô"+replicate("Í",len(str(main->lic_schet)))+;
                   "Ï"+replicate("Í",len(main->potrebitel)-90)+;
                   "Ï"+replicate("Í",19)+"Ï"+replicate("Í",23)+;
                   "Ï"+replicate("Í",8)+"¼"+crlf+"à®¤®«¦¥­¨¥ á«¥¤ã¥â"+crlf+chr(12))
             END_WRITE=.T.
          ENDIF
       enddo
       IF !END_WRITE
          fwrite(desc,"Ô"+replicate("Í",len(str(main->lic_schet)))+;
                   "Ï"+replicate("Í",len(main->potrebitel)-90)+;
                   "Ï"+replicate("Í",19)+"Ï"+replicate("Í",23)+;
                   "Ï"+replicate("Í",8)+"¼"+crlf+"‚á¥£® «¨áâ®¢ "+;
                   alltrim(str(pages))+crlf)
       ENDIF
       fwrite(desc,"‚á¥£® § ¤®«¦­¨ª®¢ "+str(total,3,0)+;
                   space(29)+"‡ ¤®«¦¥­­®áâì "+str(tot_sum)+crlf)
       fwrite(desc,"ˆá¯®«­¨â¥«ì ‘â¥¯ç¥­ª® .€.  â¥«.5-45-76"+crlf)
       fwrite(desc,chr(27)+chr(38)+chr(108)+chr(48)+chr(79))
       fclose(desc)
       if total=0
          al_box({"‡ ¤®«¦­¨ª®¢ ­¥ ®¡­ àã¦¥­®."})
       endif
       win_rest(obr_scr)
     else
          al_box({"¥¢¥à­®¥ ª®«¨ç¥áâ¢® ¬¥áïæ¥¢ ª ¢ë¡®àª¥"})
     endif
    endif
   endif
   win_rest(screen)
   select(select)
   fclose(desc)
   go recno
endif
return NIL





function Forma52001
LOCAL win:=win_save(),clr:=setcolor(),sel:=select(),crlf:=chr(13)+chr(10),desc
LOCAL Month,kod, rash, dolg, dolg2, deb1, deb2, opl, rec, TypeOtch:=0,mScr:=SaveScreen(0,0,24,79)
LOCAL oplp:=0, dolgp:=0, dolgp2:=0, rashp:=0,array:="",forma,penq:=0,high:=0
Local Itog[15]
AFill(Itog,0)
rec:=recno()
_month_:=Month_menu()
if _month_==0
   return NIL
endif
select 0
if .not.netuse(schet_share+'o'+alltrim(str(_month_))+'.dbf',,0,"oplata")
   return NIL
endif
Delitel:=GetVal("’®ç­®áâì ¢ë¢®¤¨¬ëå ¤ ­­ëå ",1000,0)
Delitel:=IF(Delitel==0,1,Delitel)

TypeOtch:=al_box({"‚ë¡¥à¨â¥ â¨¯ ®âç¥â "},2,{"52001"," §¢¥à­ãâë©"})
forma:=al_box({"’¨¯ ä®à¬ë 52001"},2,{"¥§ ¯¥­¨","‘ ¯¥­¥©"})
obrabot(" áç¥â ä®à¬ë 52001...")
deb1=if(_month_>1,"debet"+alltrim(str(_month_-1)),"last_debet")
deb2="debet"+alltrim(str(_month_))
desc:=fcreate(Ddir+"otchet.gkv")
fwrite(desc,SCHET_COND+"”®à¬  52001"+Space(155)+Dtoc(New_date)+CrLf)
fwrite(desc,center("¯¥à â¨¢­ ï ¨­ä®à¬ æ¨ï ®¡  ¡®­¥­âáª®© § ¤®«¦¥­­®áâ¨ §  í«¥ªâà¨ç¥áªãî í­¥à£¨î",176," ")+CrLf)
fwrite(desc,center("€­ ¯áª®¥ ¯à¥¤¯à¨ïâ¨¥ £®à®¤áª¨å í«¥ªâà¨ç¥áª¨å á¥â¥©",176," ")+CrLf)
fwrite(desc,center("§  "+mesqc(_month_)+" "+alltrim(str(year(New_date)))+"£.",176,"")+crlf+crlf)
fwrite(desc,"— áâì 1. ˆ§ ¡î¤¦¥â                                                                                                                            (¢ "+AllTrim(Str(Delitel))+" .àã¡)  (á „‘)"+crlf)
if forma==1
   fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"+crlf)
   fwrite(desc,"³                                     ³‡ ¤®«¦¥­­®áâì³ ®¤«¥¦¨â³” ªâ¨ç¥áª¨³                                    ¢  â ® ¬  ç ¨ á « ¥                                  ³‡ ¤®«¦¥­­®áâì³"+crlf)
   fwrite(desc,"³                                     ³  ­  ­ ç «®  ³®¯« â¥ § ³ ®¯« ç¥­® ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´    ­        ³"+crlf)
   fwrite(desc,"³            € ¡ ® ­ ¥ ­ â            ³  ®âç¥â­®£®  ³ ®âç¥â­ë©³   ¢á¥£®  ³          ®¯« ç¥­® (â¥ªãé¨¥ ¯« â¥¦¨)        ³¯« â¥¦¨ ¢ áç¥â § ¤®«¦¥­­®áâ¨ ¯à¥¤ë¤.¯¥à¨®¤®¢³ ®âç¥â­ãî    ³"+crlf)
   fwrite(desc,"³                                     ³    ¬¥áïæ    ³  ¯¥à¨®¤ ³          ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ´    ¤ âã     ³"+crlf)
   fwrite(desc,"³                                     ³             ³         ³          ³¤¥­ì£ ¬¨³  „„  ³¢¥ªá¥«ï¬¨³  ¬ â.   ³¨â®£®  ³¤¥­ì£ ¬¨³  „„  ³¢¥ªá¥«ï¬¨³  ¬ â.   ³¨â®£®  ³             ³"+crlf)
   fwrite(desc,"³                                     ³             ³         ³          ³        ³       ³         ³à¥áãàá ¬¨³¯« â¥¦¨³        ³       ³         ³à¥áãàá ¬¨³¯« â¥¦¨³             ³"+crlf)
   fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+crlf)
else
   fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"+crlf)
   fwrite(desc,"³                                     ³‡ ¤®«¦¥­­®áâì³ ®¤«¥¦¨â³” ªâ¨ç¥áª¨³                                    ¢  â ® ¬  ç ¨ á « ¥                                  ³‡ ¤®«¦¥­­®áâì³"+crlf)
   fwrite(desc,"³                                     ³  ­  ­ ç «®  ³®¯« â¥ § ³ ®¯« ç¥­® ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´    ­        ³"+crlf)
   fwrite(desc,"³            € ¡ ® ­ ¥ ­ â            ³  ®âç¥â­®£®  ³ ®âç¥â­ë©³   ¢á¥£®  ³             èâà ä­ë¥ á ­ªæ¨¨               ³¯« â¥¦¨ ¢ áç¥â § ¤®«¦¥­­®áâ¨ ¯à¥¤ë¤.¯¥à¨®¤®¢³ ®âç¥â­ãî    ³"+crlf)
   fwrite(desc,"³                                     ³    ¬¥áïæ    ³  ¯¥à¨®¤ ³          ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ´    ¤ âã     ³"+crlf)
   fwrite(desc,"³                                     ³             ³         ³          ³   ¯¥­ï ³¯®¢ëè¥­³         ³         ³       ³¤¥­ì£ ¬¨³  „„  ³¢¥ªá¥«ï¬¨³  ¬ â.   ³¨â®£®  ³             ³"+crlf)
   fwrite(desc,"³                                     ³             ³         ³          ³        ³       ³         ³         ³       ³        ³       ³         ³à¥áãàá ¬¨³¯« â¥¦¨³             ³"+crlf)
   fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+crlf)
endif
PosWrite:=fseek(desc,0,1)
select otrasl
go top
temp_:=0
do while !eof()
   temp_=if(len(budget)>0,temp_+1,temp_);   skip
enddo
temp_=39/temp_
kol_kl=0
go top
do while !eof()
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
   if !empty(budget)
      select main
      go top
      rash=0; dolg=0; dolg2=0; opl=0       && ®¡é¨© à áç¥â
      penq:=0; high:=0
      penq2:=0; high2:=0
      array:=""
      do while !eof()
       rashp=0; dolgp=0; dolgp2=0; oplp=0   && ¤«ï à §¢¥à­ãâ®© ä®à¬ë
       if lim_tar1==otrasl->kod_otr
         select obormot
         seek main->lic_schet
         if found()
            if &deb1>0.and.&deb2>0
               dolg=dolg+&deb1
               dolg2=dolg2+&deb2
               dolgp=dolgp+&deb1
               dolgp2=dolgp2+&deb2
               if forma==2
                  tpenq:="penqn"+alltrim(str(_month_)); penq:=penq+&tpenq
                  thigh:="highn"+alltrim(str(_month_)); high:=penq+&thigh
                  penq2:=&tpenq
                  high2:=&thigh
               endif
               select licevoj
               seek main->lic_schet
               do while lic_sch==main->lic_schet
                  kod='('+alltrim(str(licevoj->lic_sch))+')'+alltrim(licevoj->schetchik)
                  select &_month_
                  seek kod
                  if found().and.MYUpper(alltrim(licevoj->schetchik))!="€.Œ™"
                     rash=rash+Round(summa*(100+Schet_Nds)/100,Decimal)
                     rashp=rashp+Round(summa*(100+Schet_Nds)/100,Decimal)
                  endif
                  select licevoj
                  skip
               enddo
               select oplata
               go top
               do while !eof()
                  if licevoj==main->lic_schet
                     opl=opl+summa
                     oplp=oplp+summa
                  endif
                  skip
               enddo
            endif
         endif
//         select main
         IF TypeOtch==2
            array:=array+;
            "³   "+substr(delstring(main->potrebitel,"ˆ"),1,34)+;
            space(34-len(delstring(main->potrebitel,"ˆ")))+"³"+;
            if(dolg!=0,str(round(dolgp/Delitel,2),13,2),space(13))+"³"+;
            if(rash!=0,str(round(rashp/Delitel,2),9,2),space(9))+"³"+;
            if(opl!=0,str(round(oplp/Delitel,2),10,2),space(10))+;
            if(forma==2,;
            "³"+if(penq2!=0,str(round(penq2/Delitel,2),8,2),space(8))+"³"+;
            if(high2!=0,str(round(high2/Delitel,2),7,2),space(7))+"³         ³         ³       ³        ³",;
            "³        ³       ³         ³         ³       ³        ³")+;
            if(opl!=0,str(oplp/Delitel,7,2),space(7))+"³         ³         ³"+;
            if(opl!=0,str(oplp/Delitel,7,2),space(7))+"³"+;
            if(dolg!=0,str(dolgp2/Delitel,13,2),space(13))+"³"+crlf
         ENDIF
       endif
       select main
       skip
      enddo
      select otrasl
//  áç¥â ®¯« âë ¢á¥£® ...
      Itog[3]:=Itog[3]+round(Opl/Delitel,2)
//  áç¥â ®¯« âë ¢á¥£® ...
      fwrite(desc,"³"+substr(budget,1,37)+space(37-len(budget))+"³"+;
      if(dolg!=0,str(round(dolg/Delitel,2),13,2),space(13))+"³"+;
      if(rash!=0,str(round(rash/Delitel,2),9,2),space(9))+"³"+;
      if(opl!=0,str(round(opl/Delitel,2),10,2),space(10))+;
      if(forma==2,;
      "³"+if(penq!=0,str(round(penq/Delitel,2),8,2),space(8))+"³"+;
      if(high!=0,str(round(high/Delitel,2),7,2),space(7))+"³         ³         ³       ³        ³",;
      "³        ³       ³         ³         ³       ³        ³")+;
      if(opl!=0,str(opl/Delitel,7,2),space(7))+"³         ³         ³"+;
      if(opl!=0,str(opl/Delitel,7,2),space(7))+"³"+;
      if(dolg!=0,str(dolg2/Delitel,13,2),space(13))+"³"+crlf+array)
   endif
   Itog[1]:=Itog[1]+round(dolg/Delitel,2)
   Itog[2]:=Itog[2]+round(Rash/Delitel,2)
//   Itog[3]:=Itog[3]+round(Opl/Delitel,2)
   Itog[4]:=Itog[4]+round(Penq/Delitel,2)
   Itog[5]:=Itog[5]+round(High/Delitel,2)
   Itog[6]:=Itog[6]+round(Dolg2/Delitel,2)
//   @ 1,0 say Itog[3]
//   @ 2,0 say Opl
//   Inkey(0)
   skip
enddo
fwrite(desc,"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"+SCHET_NORM+crlf)
select oplata
close
fseek(desc,PosWrite+39,0)
      fwrite(desc,if(Itog[1]!=0,str(Itog[1],13,2),space(13))+"³"+;
      if(Itog[2]!=0,str(Itog[2],9,2),space(9))+"³"+;
      if(Itog[3]!=0,str(Itog[3],10,2),space(10))+;
      if(forma==2,"³"+if(Itog[4]!=0,str(Itog[4],8,2),space(8))+"³"+;
      if(Itog[5]!=0,str(Itog[5],7,2),space(7))+"³         ³         ³       ³        ³",;
      "³        ³       ³         ³         ³       ³        ³")+;
      if(Itog[3]!=0,str(Itog[3],7,2),space(7))+"³         ³         ³"+;
      if(Itog[3]!=0,str(Itog[3],7,2),space(7))+"³"+;
      if(Itog[6]!=0,str(Itog[6],13,2),space(13))+"³"+crlf)

fclose(desc)
select(sel)
go rec
setcolor(clr)
win_rest(win)
RestScreen(0,0,24,79,mScr)
return NIL




function Forma52002()
LOCAL win:=win_save(),clr:=setcolor(),sel:=select(),crlf:=chr(13)+chr(10),desc
LOCAL Month,kod, rash, dolg, dolg2, deb1, deb2, opl, rec, PosWrite:=0
LOCAL Itog[15],forma,penq:=0,high:=0,mScr:=SaveScreen(0,0,24,79)
rec:=recno()
_month_:=Month_menu()
if _month_==0
   return NIL
endif
select 0
if .not.netuse(schet_share+'o'+alltrim(str(_month_))+'.dbf',,0,"oplata")
   return NIL
endif
Delitel:=GetVal("’®ç­®áâì ¢ë¢®¤¨¬ëå ¤ ­­ëå ",1000,0)
Delitel:=IF(Delitel==0,1,Delitel)

forma:=al_box({"’¨¯ ä®à¬ë 52002"},2,{"¥§ ¯¥­¨","‘ ¯¥­¥©"})
obrabot(" áç¥â ä®à¬ë 52002...")
deb1=if(_month_>1,"debet"+alltrim(str(_month_-1)),"last_debet")
deb2="debet"+alltrim(str(_month_))
desc:=fcreate(Ddir+"otchet.gkv")
fwrite(desc,SCHET_COND+"”®à¬  52002"+Space(155)+Dtoc(New_date)+CrLf)
fwrite(desc,center("¯¥à â¨¢­ ï ¨­ä®à¬ æ¨ï ®¡  ¡®­¥­âáª®© § ¤®«¦¥­­®áâ¨ §  í«¥ªâà¨ç¥áªãî í­¥à£¨î",176," ")+CrLf)
fwrite(desc,center("€­ ¯áª®¥ ¯à¥¤¯à¨ïâ¨¥ £®à®¤áª¨å í«¥ªâà¨ç¥áª¨å á¥â¥©",176," ")+CrLf)
fwrite(desc,center("§  "+mesqc(_month_)+" "+alltrim(str(year(New_date)))+"£.",176,"")+crlf+crlf)
fwrite(desc,"— áâì 1. ® ®âà á«ï¬ ­ à®¤­®£® å®§ï©áâ¢                                                                                                                              (¢ "+alltrim(str(Delitel))+".àã¡)  (á „‘)"+crlf)
if forma==1
   fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"+crlf)
   fwrite(desc,"³                                     ³‡ ¤®«¦¥­­®áâì³¢ â.ç ³ ®¤«¥¦¨â³” ªâ¨ç¥áª¨³                                    ¢  â ® ¬  ç ¨ á « ¥                                  ³‡ ¤®«¦¥­­®áâì³"+crlf)
   fwrite(desc,"³                                     ³  ­  ­ ç «®  ³¯®¤â¢ ³®¯« â¥ § ³ ®¯« ç¥­® ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´    ­        ³"+crlf)
   fwrite(desc,"³            € ¡ ® ­ ¥ ­ â            ³  ®âç¥â­®£®  ³ ªâ ¬¨³ ®âç¥â­ë©³   ¢á¥£®  ³          ®¯« ç¥­® (â¥ªãé¨¥ ¯« â¥¦¨)        ³¯« â¥¦¨ ¢ áç¥â § ¤®«¦¥­­®áâ¨ ¯à¥¤ë¤.¯¥à¨®¤®¢³ ®âç¥â­ãî    ³"+crlf)
   fwrite(desc,"³                                     ³    ¬¥áïæ    ³á¢¥à®ª³  ¯¥à¨®¤ ³          ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ´    ¤ âã     ³"+crlf)
   fwrite(desc,"³                                     ³             ³      ³         ³          ³¤¥­ì£ ¬¨³  „„  ³¢¥ªá¥«ï¬¨³  ¬ â.   ³¨â®£®  ³¤¥­ì£ ¬¨³  „„  ³¢¥ªá¥«ï¬¨³  ¬ â.   ³¨â®£®  ³             ³"+crlf)
   fwrite(desc,"³                                     ³             ³      ³         ³          ³        ³       ³         ³à¥áãàá ¬¨³¯« â¥¦¨³        ³       ³         ³à¥áãàá ¬¨³¯« â¥¦¨³             ³"+crlf)
   fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+crlf)
else
   fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"+crlf)
   fwrite(desc,"³                                     ³‡ ¤®«¦¥­­®áâì³¢ â.ç ³ ®¤«¥¦¨â³” ªâ¨ç¥áª¨³                                    ¢  â ® ¬  ç ¨ á « ¥                                  ³‡ ¤®«¦¥­­®áâì³"+crlf)
   fwrite(desc,"³                                     ³  ­  ­ ç «®  ³¯®¤â¢ ³®¯« â¥ § ³ ®¯« ç¥­® ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´    ­        ³"+crlf)
   fwrite(desc,"³            € ¡ ® ­ ¥ ­ â            ³  ®âç¥â­®£®  ³ ªâ ¬¨³ ®âç¥â­ë©³   ¢á¥£®  ³          èâà ä­ë¥ á ­ªæ¨¨                  ³¯« â¥¦¨ ¢ áç¥â § ¤®«¦¥­­®áâ¨ ¯à¥¤ë¤.¯¥à¨®¤®¢³ ®âç¥â­ãî    ³"+crlf)
   fwrite(desc,"³                                     ³    ¬¥áïæ    ³á¢¥à®ª³  ¯¥à¨®¤ ³          ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ´    ¤ âã     ³"+crlf)
   fwrite(desc,"³                                     ³             ³      ³         ³          ³ ¯¥­ï   ³¯®¢ëè¥­³         ³         ³       ³¤¥­ì£ ¬¨³  „„  ³¢¥ªá¥«ï¬¨³  ¬ â.   ³¨â®£®  ³             ³"+crlf)
   fwrite(desc,"³                                     ³             ³      ³         ³          ³        ³       ³         ³         ³       ³        ³       ³         ³à¥áãàá ¬¨³¯« â¥¦¨³             ³"+crlf)
   fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+crlf)
endif
PosWrite:=fseek(desc,0,1)
select otrasl
go top
temp_:=0
do while !eof()
   temp_=if(len(budget)>0,temp_+1,temp_);   skip
enddo
temp_=39/temp_
kol_kl=0
go top
for i=1 to 15
    Itog[i]:=0 // ¡­ã«¥­¨¥ áç¥âç¨ª  ¨â®£®¢
next
fwrite(desc,"³ ‚‘…ƒ  …ƒ‘ˆ‘’…Œ…             ³             ³      ³         ³          ³        ³       ³         ³         ³       ³        ³       ³         ³         ³       ³             ³ "+crlf)
do while !eof()
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
   if !empty(narod)
      select main
      go top
      rash=0
      dolg=0
      dolg2=0
      opl=0
      do while !eof()
       if lim_tar2==otrasl->kod_otr
         select obormot
         seek main->lic_schet
         if found()
            if &deb1>0.and.&deb2>0
               dolg=dolg+&deb1
               dolg2=dolg2+&deb2
               if forma==2
                  penq:="penqn"+alltrim(str(_month_)); penq:=&penq
                  high:="highn"+alltrim(str(_month_)); high:=&high
               endif
               select licevoj
               seek main->lic_schet
               do while lic_sch==main->lic_schet
                  kod='('+alltrim(str(licevoj->lic_sch))+')'+alltrim(licevoj->schetchik)
                  select &_month_
                  seek kod
                  if found().and.MYUpper(alltrim(licevoj->schetchik))!="€.Œ™"
                     rash=rash+Round(summa*(100+Schet_Nds)/100,Decimal)
                  endif
                  select licevoj
                  skip
               enddo
               select oplata
               go top
               do while !eof()
                  if licevoj==main->lic_schet
                     opl=opl+summa
                  endif
                  skip
               enddo
            endif
         endif
       endif
       select main
       skip
      enddo
      select otrasl
      fwrite(desc,"³"+substr(narod,1,37)+space(37-len(substr(narod,1,37)))+"³"+;
      if(dolg!=0,str(round(dolg/Delitel,2),13,2),space(13))+"³      ³"+;
      if(rash!=0,str(round(Rash/Delitel,2),9,2),space(9))+"³"+;
      if(opl!=0,str(round(opl/Delitel,2),10,2),space(10))+;
      if(forma==2,"³"+if(penq!=0,str(round(penq/Delitel,2),8,2),space(8))+"³"+;
      if(high!=0,str(round(high/Delitel,2),7,2),space(7))+"³         ³         ³       ³        ³",;
      "³        ³       ³         ³         ³       ³        ³")+;
      if(opl!=0,str(opl/Delitel,7,2),space(7))+"³         ³         ³"+;
      if(opl!=0,str(opl/Delitel,7,2),space(7))+"³"+;
      if(dolg!=0,str(dolg2/Delitel,13,2),space(13))+"³"+crlf)
      itog[2]:=Itog[2]+dolg
//      Itog[3]:=Itog[3]+rash
      Itog[3]:=Itog[3]+Round(Rash*(100+Schet_Nds)/100,2)
      Itog[4]:=Itog[4]+opl
      if forma==2
         Itog[5]:=Itog[5]+penq
         Itog[6]:=Itog[6]+penq
      endif
      Itog[11]:=Itog[11]+opl
      Itog[14]:=Itog[14]+opl
      Itog[15]:=Itog[15]+dolg2
   endif
   skip
enddo
fwrite(desc,"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"+SCHET_NORM+crlf)
fseek(desc,PosWrite,0)
fwrite(desc,"³ ‚‘…ƒ  …ƒ‘ˆ‘’…Œ…              ³"+;
      if(itog[2]!=0,str(round(itog[2]/Delitel,2),13,2),space(13))+"³      ³"+;
      if(itog[3]!=0,str(round(itog[3]/Delitel,2),9,2),space(9))+"³"+;
      if(itog[4]!=0,str(round(itog[4]/Delitel,2),10,2),space(10))+;
      if(forma==2,"³"+str(round(Itog[5]/Delitel,2),8,2)+"³"+;
      str(round(Itog[6]/Delitel,2),7,2)+"³         ³         ³       ³        ³",;
      "³        ³       ³         ³         ³       ³        ³")+;
      if(itog[11]!=0,str(itog[11]/Delitel,7,2),space(7))+"³         ³         ³"+;
      if(itog[14]!=0,str(itog[14]/Delitel,7,2),space(7))+"³"+;
      if(itog[15]!=0,str(itog[15]/Delitel,13,2),space(13))+"³"+crlf)
select oplata
close
fclose(desc)
select(sel)
go rec
setcolor(clr)
win_rest(win)
RestScreen(0,0,24,79,mScr)
return NIL


function kolya2b(FoundString)
LOCAL select:=select(),recno:=recno(),screen:=win_save(8,12,14,67)
LOCAL kol_mes,obr_scr,start_mes,desc,debstr,str_deb,cou_deb,sum_deb
LOCAL crlf:=chr(13)+chr(10),color:=setcolor(),temp_,kol_kl,str_kre,total:=0
LOCAL tot_sum:=0,sel,LenTablica,LenString:=0,opl:=0,CalcMes:=0
//--------------------------------------- ¥à¥¬¥­­ë¥ ¤«ï ä®à¬¨à®¢ ­¨ï â ¡«¨æë
LOCAL Len_Page:=42,Is_Shapka:=.T.,Pres_String:=0,End_Write:=.F.,Pages:=1
LOCAL OneStringLen:=111,penq:=0,penq1,high:=0,high1,str_ob:="",tmp_rec
//---------------------------------------------------------------------------
start_mes:=month_menu()
kol_mes=start_mes
if start_mes>0
   colorwin(09,13,14,67,'n+/n')
   set color to n/w,n/g
   @ 08,12 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·"
   @ 09,12 say "³"+space(53)+"º"
   @ 10,12 say "³   “ª ¦¨â¥ ¤«¨â¥«ì­®áâì § ¤®«¦¥­­®áâ¨    (¬¥á.)      º"
   @ 11,12 say "³   â áã¬¬ë                   „® áã¬¬ë               º"
   @ 12,12 say "³"+space(53)+"º"
   @ 13,12 say "ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
   min_dolg=0
   max_dolg=999999999999
   set cursor on
   @ 10,51 get kol_mes picture "@K 99"
   @ 11,26 get min_dolg picture "@K"
   @ 11,53 get max_dolg picture "@K"
   read
   set cursor off
   setcolor(color)
   if lastkey()#27
    if kol_mes>0
     if kol_mes<=start_mes
        Clear Typeahead
        Delitel:=GetVal("’®ç­®áâì ¢ë¢®¤¨¬ëå ¤ ­­ëå ",1000,0)
        Delitel:=IF(Delitel==0,1,Delitel)
       kol_mes=kol_mes-1
       desc=fcreate(Ddir+"otchet.gkv")
// ˆ§¬¥­¥­¨¥ ®à¨¥­â æ¨¨ áâà ­¨æë ¯à¨­â¥à  ­  LANDSCAPE
       fwrite(desc,SCHET_COND)
       fwrite(desc,"‚ë¡®àª  à¥ª®¬¥­¤ã¥¬ëå § ¤®«¦­¨ª®¢ ¤«ï ¢§ ¨¬­ëå § ç¥â®¢. ¥à¨®¤ "+mesqc(start_mes-kol_mes)+;
              " - "+mesqc(start_mes)+"  â®ç­®áâì 1:"+alltrim(str(Delitel))+crlf)
       fwrite(desc,if(min_dolg#0,"â áã¬¬ë ­¥ ¬¥­¥¥ "+alltrim(str(min_dolg))+" ","")+;
                   if(max_dolg#999999999999,"„® áã¬¬ë ­¥ ¡®«¥¥ "+alltrim(str(max_dolg)),"")+CrLf)
//---------------------------------------------------------------------------
       pres_string=2                   && “¦¥ áâà®ç¥ª ¢ áâà ­¨æ¥ § ¯®«­¥­®...
//---------------------------------------------------------------------------
       LenTablica=54+len(str(main->lic_schet))+len(main->potrebitel)
       obr_scr:=obrabot("‚ë¡®àª  § ¤®«¦­¨ª®¢ ¤«ï ¢§ ¨¬®§ ç¥â®¢")
       temp_=39/reccount()
       kol_kl=0
       go top
       do while !eof()
          penq1:=0; high1:=0; max_rash:=0
//-------------------------------------------------- „®¡ ¢«¥­¨¥ è ¯ª¨ â ¡«¨æë
          IF IS_SHAPKA
             IF PAGES#1
                fwrite(desc,space(OneStringLen-12)+"‹¨áâ N "+alltrim(str(pages))+crlf)
             ENDIF
             fwrite(desc,"Ú"+replicate("Ä",len(str(main->lic_schet)))+;
                "Â"+replicate("Ä",len(main->potrebitel))+;
                "Â"+replicate("Ä",9)+"Â"+replicate("Ä",11)+"Â"+replicate("Ä",8)+;
                "Â"+replicate("Ä",15)+"Â"+replicate("Ä",8)+"·"+crlf)

             fwrite(desc,"³"+center("‹/á",len(str(main->lic_schet))," ",.t.)+"³"+;
                    center(" ¨¬¥­®¢ ­¨¥ ®à£ ­¨§ æ¨¨",len(main->potrebitel)," ",.t.)+;
                    "³‘à¥¤.à áå³„®«£ §  í«.³ ˜âà äë ³ à¨­ïâë¥ ¬¥àë ³¯« ç¥­®º"+crlf)
             IS_SHAPKA=.F.
             END_WRITE=.F.
             pres_string=pres_string+3
          ENDIF
          select 15
          seek main->lic_schet
          kol_kl=kol_kl+temp_
          colorwin(12,21,12,21+kol_kl,'n/n')
          if found()
           IF FoundString==NIL.or.atnum(FoundString,;
              MYupper(alltrim(main->potrebitel)),1)>0
             cou_deb=0
             sum_deb=0
             deb_str=""
             for i=start_mes-kol_mes to start_mes
                 str_deb="debet"+alltrim(str(int(i)))
                 str_kre="kredit"+alltrim(str(int(i)))
//*********************************** ‚ë¡®àª  áã¬¬ ®â MIN ¤® MAX
                  if (min_dolg<=&str_deb) .and. (max_dolg>=&str_deb)
//----------------------------------------------------------- ¥­ï
                     str_ob="penqn"+alltrim(str(int(i)))
                     penq1=penq1+&str_ob; penq=penq+&str_ob
                     str_ob="penq"+alltrim(str(int(i)))
                     penq1=penq1-&str_ob; penq=penq-&str_ob
//----------------------------------------------------------- ®¢ëè¥­­ ï
                     str_ob="highn"+alltrim(str(int(i)))
                     high1=high1+&str_ob; high=high+&str_ob
                     str_ob="high"+alltrim(str(int(i)))
                     high1=high1-&str_ob; high=high-&str_ob
                 if(&str_deb>0.and.&str_kre=0)
                   cou_deb=cou_deb+1
                   if i#start_mes
                      deb_str=str(&str_deb,15,2)
                      sum_deb=sum_deb+&str_deb
                   endif
                  endif
                 endif
             next
             if cou_deb-1=kol_mes
                sel=select()
                CalcMes:=Start_Mes-Kol_Mes
                opl:=0
                do while(CalcMes!=0)
                   select 0
                   netuse(schet_Share+"o"+alltrim(str(int(CalcMes)))+".dbf",,0,"oplata")
                   go top
                   do while .not.eof()
                      if main->lic_schet==licevoj
                         opl=opl+summa
                      endif
                      skip
                   enddo
                   use
                   CalcMes++
                   CalcMes=IF(CalcMes>Start_Mes,0,CalcMes)
                enddo
                opl:=round(opl/Delitel,1)
                select 77                       && „«ï ¯®¨áª   ¤à¥á .
                seek main->lic_schet
                max_rash:=0
                   for i=start_mes-kol_mes to start_mes
                       sum_rashod:=0; power:=0; reaktiv:=0; sum_reak:=0
                       donsum:=0; donpow:=0; wozwsum:=0; wozwpow:=0
                       SumAbon:=0; RashAbon:=0
                       CalcEnergy(i,.f.)
                       max_rash=max_rash+(sum_rashod+sum_reak)
                   next
                max_rash=round(((max_rash*100/(100+schet_nds))/if(kol_mes==0,1,kol_mes)),2)
                select(sel)
//---------------------------------------------------------------------------
             fwrite(desc,"Ã"+replicate("Ä",len(str(main->lic_schet)))+;
                "Å"+replicate("Ä",len(main->potrebitel))+;
                "Å"+replicate("Ä",9)+"Å"+replicate("Ä",11)+"Å"+replicate("Ä",8)+;
                "Å"+replicate("Ä",15)+"Å"+replicate("Ä",8)+"¶"+crlf)
//---------------------------------------------------------------------------
                LenString=len("|"+str(main->lic_schet)+"|"+delstring(alltrim(main->potrebitel),"ˆ"))+;
                len(main->potrebitel)-;
                len(delstring(alltrim(main->potrebitel),"ˆ"))+;
                len("|   "+str(&str_deb/Delitel,15,2))

                fwrite(desc,"³"+str(main->lic_schet)+"³"+;
                       delstring(alltrim(main->potrebitel),"ˆ")+;
                       space(len(main->potrebitel)-;
                       len(delstring(alltrim(main->potrebitel),"ˆ")))+;
                       "³"+str(max_rash/Delitel,9,2)+;
                       "³ "+str(&str_deb/Delitel,9,2)+" ³"+;
                       str((penq1+high1)/Delitel,8,1)+;
                       "³               ³ "+str(opl,6,1)+" º"+crlf+;
                       '³'+space(len(str(main->lic_schet)))+'³'+;
                       alltrim(licevoj->adres)+" ’¥«."+;
                       alltrim(licevoj->telefon)+;
                       space(len(main->potrebitel)-;
                       len(alltrim(licevoj->adres)+" ’¥«."+;
                       alltrim(licevoj->telefon)))+;
                       "³         ³           ³        ³               ³        º"+crlf)
                total=total+1
                tot_sum=tot_sum+&str_deb
//---------------------------------------------------------------------------
                pres_string=pres_string+3              &&  3 áâà®çª¨ § ¯¨á ­®
//---------------------------------------------------------------------------
             endif
           ENDIF
          endif
          select 88
          skip
          IF PRES_STRING>=LEN_PAGE
             PRES_STRING=0
             IS_SHAPKA=.T.
             PAGES++
             fwrite(desc,"Ô"+replicate("Í",len(str(main->lic_schet)))+;
                "Ï"+replicate("Í",len(main->potrebitel))+;
                "Ï"+replicate("Í",9)+"Ï"+replicate("Í",11)+"Ï"+replicate("Í",8)+;
                "Ï"+replicate("Í",15)+"Ï"+replicate("Í",8)+"¼"+crlf+"à®¤®«¦¥­¨¥ á«¥¤ã¥â"+crlf+chr(12))
             END_WRITE=.T.
          ENDIF
       enddo
       IF !END_WRITE
             fwrite(desc,"Ô"+replicate("Í",len(str(main->lic_schet)))+;
                "Ï"+replicate("Í",len(main->potrebitel))+;
                "Ï"+replicate("Í",9)+"Ï"+replicate("Í",11)+"Ï"+replicate("Í",8)+;
                "Ï"+replicate("Í",15)+"Ï"+replicate("Í",8)+"¼"+crlf+"‚á¥£® «¨áâ®¢ "+;
                   alltrim(str(pages))+crlf)
       ENDIF
       fwrite(desc,"‚á¥£® § ¤®«¦­¨ª®¢ "+str(total,3,0)+crlf+;
                   "  ‡ ¤®«¦¥­­®áâì ¯® í«.í­¥à£¨¨ "+str(round(tot_sum/Delitel,2))+crlf+;
                   "  ‡ ¤®«¦¥­­®áâì ¯® ¯¥­¥       "+str(round(penq/Delitel,2))+crlf+;
                   "  ‡ ¤®«¦¥­­®áâì ¯® ¯®¢ëè¥­­®© "+str(round(high/Delitel,2))+crlf)
       fwrite(desc,"ˆá¯®«­¨â¥«ì ‘â¥¯ç¥­ª® .€.  â¥«.5-45-76"+crlf)
       fwrite(desc,SCHET_NORM)
       fclose(desc)
       if total=0
          al_box({"‡ ¤®«¦­¨ª®¢ ­¥ ®¡­ àã¦¥­®."})
       endif
       win_rest(obr_scr)
     else
          al_box({"¥¢¥à­®¥ ª®«¨ç¥áâ¢® ¬¥áïæ¥¢ ª ¢ë¡®àª¥"})
     endif
    endif
   endif
   win_rest(screen)
   select(select)
   fclose(desc)
   go recno
endif
return NIL
