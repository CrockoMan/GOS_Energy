function CheckAbon
LOCAL recno:=recno(),select:=select(),screen:=win_save(),color:=setcolor()
LOCAL work_day:=24,schetchiks:=0,peoples:=1,rec,desc,CrLf:=chr(13)+chr(10)
local sperday:=4,spotr,Mystep:=0,prevlic:=-1,wdblank:=1,sdat:=New_date
LOCAL dat_pr
SET COLOR TO N/W,w/n,,,n/w
colorwin(10,16,16,60,"n+/n")
//@ 09,15,13,59 BOX "         "
@ 09,15 SAY "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
@ 10,15 SAY "� 뒶エ曄飡¡ �젩�葉� ㄽⅸ                   �"
@ 11,15 SAY "� 뒶エ曄飡¡ 淞β葉ぎ�                      �"
@ 12,15 SAY "� 뒶エ曄飡¡ 曄ギ´�                        �"
@ 13,15 SAY "� 묊β葉ぎ� � ㄵ��                          �"
@ 14,15 SAY "� 꽑�� ��舒�� �昔´夕�                      �"
@ 15,15 SAY "突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴�"
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
fwrite(desc,center("꺺졽Ø �昔´夕� 收耶①αぎ． 貰飡�輾⑨ �黍‘昔�",75," ",.t.)+crlf)
fwrite(desc,center("晨β� 姉ⅹ循�子�薯Ŀ � "+dtoc(sdat),75," ",.t.)+crlf+crlf)
select(select)
Select main
go top
//step:=peoples*sperday
dat_pr=sdat
do while !eof()
   Select 77
   Seek Main->Lic_Schet
   Do While Lic_Sch==Main->Lic_Schet
      IF Atnum("룑뭶릦",MYUpper(Schetchik))==0.and.;
         Atnum("�걥�",MYUpper(Schetchik))==0.and.;
         Atnum("굨뇗���",MYUpper(Schetchik))==0.and.;
         Atnum("룑몤.",MYUpper(Schetchik))==0
          if Mystep=0
             if dow(dat_pr)=1
                   dat_pr++
             endif
             if dow(dat_pr)=7
                dat_pr=dat_pr+2
             endif
             Mystep:=peoples*sperday
             fwrite(desc,replicate("-",20)+"꽖�� N"+alltrim(str(wdblank))+;
                         " "+dtoc(dat_pr)+" "+replicate("-",20)+"     댾��キⓥ�レ"+crlf)
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
//--------------------------------------- 룯誓Д��瑜 ㄻ� 兒席ⓣ�쥯�⑨ �젩エ劣
LOCAL Len_Page:=42,Is_Shapka:=.T.,Pres_String:=0,End_Write:=.F.,Pages:=1
LOCAL OneStringLen:=111
//---------------------------------------------------------------------------
start_mes:=month_menu()
kol_mes=start_mes
if start_mes>0
   colorwin(09,13,14,67,'n+/n')
   set color to n/w,n/g
   @ 08,12 say "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
   @ 09,12 say "�"+space(53)+"�"
   @ 10,12 say "�   벆젲ⓥ� ㄻⓥ�レ��飡� 쭬ㄾウ����飡�    (Д�.)      �"
   @ 11,12 say "�   롡 率К�                   꽡 率К�               �"
   @ 12,12 say "�"+space(53)+"�"
   @ 13,12 say "突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴�"
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
        Delitel:=GetVal("뮢嶺�飡� �猶�ㄸщ� 쩆��音 ",1000,0)
        Delitel:=IF(Delitel==0,1,Delitel)
       kol_mes=kol_mes-1
       desc=fcreate(Ddir+"otchet.gkv")
// 닱Д����� �黍���졿Ŀ 飡�젺ⓩ� �黍�收�� 췅 LANDSCAPE
       fwrite(desc,chr(27)+chr(38)+chr(108)+chr(49)+chr(79))
       fwrite(desc,"귣‘夕� 쭬ㄾウ�Ø��. 룯黍�� "+mesqc(start_mes-kol_mes)+;
              " - "+mesqc(start_mes)+" 獸嶺�譽� 1:"+alltrim(str(Delitel))+crlf)
       fwrite(desc,if(min_dolg#0,"롡 率К� �� Д�ⅴ "+alltrim(str(min_dolg))+" ","")+;
                   if(max_dolg#999999999999,"꽡 率К� �� ‘ゥ� "+alltrim(str(max_dolg)),"")+CrLf)
//---------------------------------------------------------------------------
       pres_string=2                   && 벀� 飡昔曄� � 飡�젺ⓩ� 쭬��キ���...
//---------------------------------------------------------------------------
       LenTablica=54+len(str(main->lic_schet))+len(main->potrebitel)
       obr_scr:=obrabot("귣‘夕� ㎙�飡�音 쭬ㄾウ�Ø�� ")
       temp_=39/reccount()
       kol_kl=0
       go top
       do while !eof()
//-------------------------------------------------- 꽡줎˙���� �젽え �젩エ劣
          IF IS_SHAPKA
             IF PAGES#1
                fwrite(desc,space(OneStringLen-12)+"떒飡 N "+alltrim(str(pages))+crlf)
             ENDIF
             fwrite(desc,"�"+replicate("�",len(str(main->lic_schet)))+;
                "�"+replicate("�",len(main->potrebitel)-90)+;
                "�"+replicate("�",19)+"�"+replicate("�",23)+"�"+replicate("�",8)+;
                "�"+crlf)

             fwrite(desc,"�"+center("�/�",len(str(main->lic_schet))," ",.t.)+"�"+;
                    center("뜝º���쥯��� �薯젺�쭬與�",len(main->potrebitel)-90," ",.t.)+;
                    "퀝僧쵟 쭬ㄾウ����飡㉢ 룯誓曄�� �黍�汀音 Д� 퀚�쳽曄���"+crlf)
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
//*********************************** 귣‘夕� 率К �� MIN ㄾ MAX
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
                select 77                       && 꽞� ��ⓤ첓 젮誓��.
                seek main->lic_schet
                select(sel)
//---------------------------------------------------------------------------
                fwrite(desc,"�"+replicate("�",len(str(main->lic_schet)))+;
                "�"+replicate("�",len(main->potrebitel)-90)+;
                "�"+replicate("�",19)+"�"+replicate("�",23)+"�"+replicate("�",8)+;
                "�"+crlf)
//---------------------------------------------------------------------------
                LenString=len("|"+str(main->lic_schet)+"|"+delstring(alltrim(main->potrebitel),"닄�"))+;
                len(main->potrebitel)-;
                len(delstring(alltrim(main->potrebitel),"닄�"))+;
                len("|   "+str(&str_deb/Delitel,15,2))
                fwrite(desc,"�"+str(main->lic_schet)+"�"+;
                       Substr(delstring(alltrim(main->potrebitel),"닄�")+;
                       space(len(main->potrebitel)-;
                       len(delstring(alltrim(main->potrebitel),"닄�"))),1,60)+;
                       "�   "+str(&str_deb/Delitel,15,2)+" �                       � "+str(opl,6,1)+" �"+;  // space(LenTablica-LenString-3)+"�"+;
                       crlf+'�'+space(len(str(main->lic_schet)))+'�'+;
                       alltrim(licevoj->adres)+" 뮙�."+alltrim(licevoj->telefon)+space(len(main->potrebitel)-90-len(alltrim(licevoj->adres)+" 뮙�."+alltrim(licevoj->telefon)))+;
                       "�                   �                       �        �"+crlf)
                total=total+1
                tot_sum=tot_sum+&str_deb
//---------------------------------------------------------------------------
                pres_string=pres_string+3              &&  3 飡昔囹� 쭬�ⓤ젺�
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
             fwrite(desc,"�"+replicate("�",len(str(main->lic_schet)))+;
                   "�"+replicate("�",len(main->potrebitel)-90)+;
                   "�"+replicate("�",19)+"�"+replicate("�",23)+;
                   "�"+replicate("�",8)+"�"+crlf+"뤲�ㄾウ���� 笹ⅳ濕�"+crlf+chr(12))
             END_WRITE=.T.
          ENDIF
       enddo
       IF !END_WRITE
          fwrite(desc,"�"+replicate("�",len(str(main->lic_schet)))+;
                   "�"+replicate("�",len(main->potrebitel)-90)+;
                   "�"+replicate("�",19)+"�"+replicate("�",23)+;
                   "�"+replicate("�",8)+"�"+crlf+"귗ⅲ� エ飡�� "+;
                   alltrim(str(pages))+crlf)
       ENDIF
       fwrite(desc,"귗ⅲ� 쭬ㄾウ�Ø�� "+str(total,3,0)+;
                   space(29)+"뇿ㄾウ����飡� "+str(tot_sum)+crlf)
       fwrite(desc,"댾��キⓥ�レ 묅��曄�ぎ �.�.  收�.5-45-76"+crlf)
       fwrite(desc,chr(27)+chr(38)+chr(108)+chr(48)+chr(79))
       fclose(desc)
       if total=0
          al_box({"뇿ㄾウ�Ø�� �� �∼졷拾���."})
       endif
       win_rest(obr_scr)
     else
          al_box({"뜢´惜�� ぎエ曄飡¡ Д碎璵� � �濡�夕�"})
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
Delitel:=GetVal("뮢嶺�飡� �猶�ㄸщ� 쩆��音 ",1000,0)
Delitel:=IF(Delitel==0,1,Delitel)

TypeOtch:=al_box({"귣‥黍收 殊� �洵β�"},2,{"52001","맆㎖�惜呻硫"})
forma:=al_box({"뮜� 兒席� 52001"},2,{"겈� ����","� ���ⅸ"})
obrabot("맆淞β 兒席� 52001...")
deb1=if(_month_>1,"debet"+alltrim(str(_month_-1)),"last_debet")
deb2="debet"+alltrim(str(_month_))
desc:=fcreate(Ddir+"otchet.gkv")
fwrite(desc,SCHET_COND+"뵰席� 52001"+Space(155)+Dtoc(New_date)+CrLf)
fwrite(desc,center("렞��졻Ð췅� Þ兒席졿⑨ �� 젩����恂ぎ� 쭬ㄾウ����飡� 쭬 姉ⅹ循①αゃ� 子�薯⑧",176," ")+CrLf)
fwrite(desc,center("�췅�稅�� �誓ㄿ黍汀�� ．昔ㅱえ� 姉ⅹ循①αえ� 醒收�",176," ")+CrLf)
fwrite(desc,center("쭬 "+mesqc(_month_)+" "+alltrim(str(year(New_date)))+"�.",176,"")+crlf+crlf)
fwrite(desc,"뿞飡� 1. 닱 √ㄶβ�                                                                                                                           (� "+AllTrim(Str(Delitel))+" .說�)  (� 뛾�)"+crlf)
if forma==1
   fwrite(desc,"旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴쩡컴컴컴컴쩡컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴커"+crlf)
   fwrite(desc,"�                                     퀒젮�ウ����飡爾 룼ㄻⅵⓥ퀠젶殊曄稅㉢                                    �  � � �  � � � � �                                  퀒젮�ウ����飡爾"+crlf)
   fwrite(desc,"�                                     �  췅 췅�젷�  낟�쳽收 쭬� ��쳽曄�� 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�    췅       �"+crlf)
   fwrite(desc,"�            � � � � � � �            �  �洵β��．  � �洵β�硫�   ㏇ⅲ�  �          ��쳽曄�� (收ゃ蟯� �쳽收┬)        날쳽收┬ � 淞β 쭬ㄾウ����飡� �誓ㅻ�.��黍�ㄾ∏ �洵β�莘    �"+crlf)
   fwrite(desc,"�                                     �    Д碎��   �  ��黍�� �          쳐컴컴컴컫컴컴컴컫컴컴컴컴컫컴컴컴컴컫컴컴컴컵컴컴컴컴쩡컴컴컴쩡컴컴컴컴쩡컴컴컴컴쩡컴컴컴�    쩆栒     �"+crlf)
   fwrite(desc,"�                                     �             �         �          낀��二젹㉢  룄�  끼ⅹ醒ワЖ�  쵟�.   낏獸．  낀��二젹㉢  룄�  끼ⅹ醒ワЖ�  쵟�.   낏獸．  �             �"+crlf)
   fwrite(desc,"�                                     �             �         �          �        �       �         녀α侁�젹㉢�쳽收┬�        �       �         녀α侁�젹㉢�쳽收┬�             �"+crlf)
   fwrite(desc,"쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴탠컴컴컴컴탠컴컴컴컴컵컴컴컴컴탠컴컴컴탠컴컴컴컴탠컴컴컴컴탠컴컴컴탠컴컴컴컵컴컴컴컵컴컴컴컴컵컴컴컴컴컵컴컴컴컵컴컴컴컴컴컴캑"+crlf)
else
   fwrite(desc,"旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴쩡컴컴컴컴쩡컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴커"+crlf)
   fwrite(desc,"�                                     퀒젮�ウ����飡爾 룼ㄻⅵⓥ퀠젶殊曄稅㉢                                    �  � � �  � � � � �                                  퀒젮�ウ����飡爾"+crlf)
   fwrite(desc,"�                                     �  췅 췅�젷�  낟�쳽收 쭬� ��쳽曄�� 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�    췅       �"+crlf)
   fwrite(desc,"�            � � � � � � �            �  �洵β��．  � �洵β�硫�   ㏇ⅲ�  �             外�졽�瑜 �젺ゆĿ               날쳽收┬ � 淞β 쭬ㄾウ����飡� �誓ㅻ�.��黍�ㄾ∏ �洵β�莘    �"+crlf)
   fwrite(desc,"�                                     �    Д碎��   �  ��黍�� �          쳐컴컴컴컫컴컴컴컫컴컴컴컴컫컴컴컴컴컫컴컴컴컵컴컴컴컴쩡컴컴컴쩡컴컴컴컴쩡컴컴컴컴쩡컴컴컴�    쩆栒     �"+crlf)
   fwrite(desc,"�                                     �             �         �          �   ���� 날��泣���         �         �       낀��二젹㉢  룄�  끼ⅹ醒ワЖ�  쵟�.   낏獸．  �             �"+crlf)
   fwrite(desc,"�                                     �             �         �          �        �       �         �         �       �        �       �         녀α侁�젹㉢�쳽收┬�             �"+crlf)
   fwrite(desc,"쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴탠컴컴컴컴탠컴컴컴컴컵컴컴컴컴탠컴컴컴탠컴컴컴컴탠컴컴컴컴탠컴컴컴탠컴컴컴컵컴컴컴컵컴컴컴컴컵컴컴컴컴컵컴컴컴컵컴컴컴컴컴컴캑"+crlf)
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
      rash=0; dolg=0; dolg2=0; opl=0       && �↓Ł �졹曄�
      penq:=0; high:=0
      penq2:=0; high2:=0
      array:=""
      do while !eof()
       rashp=0; dolgp=0; dolgp2=0; oplp=0   && ㄻ� �젳´惜呻�� 兒席�
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
                  if found().and.MYUpper(alltrim(licevoj->schetchik))!="�걥�.뙉솉"
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
            "�   "+substr(delstring(main->potrebitel,"닄�"),1,34)+;
            space(34-len(delstring(main->potrebitel,"닄�")))+"�"+;
            if(dolg!=0,str(round(dolgp/Delitel,2),13,2),space(13))+"�"+;
            if(rash!=0,str(round(rashp/Delitel,2),9,2),space(9))+"�"+;
            if(opl!=0,str(round(oplp/Delitel,2),10,2),space(10))+;
            if(forma==2,;
            "�"+if(penq2!=0,str(round(penq2/Delitel,2),8,2),space(8))+"�"+;
            if(high2!=0,str(round(high2/Delitel,2),7,2),space(7))+"�         �         �       �        �",;
            "�        �       �         �         �       �        �")+;
            if(opl!=0,str(oplp/Delitel,7,2),space(7))+"�         �         �"+;
            if(opl!=0,str(oplp/Delitel,7,2),space(7))+"�"+;
            if(dolg!=0,str(dolgp2/Delitel,13,2),space(13))+"�"+crlf
         ENDIF
       endif
       select main
       skip
      enddo
      select otrasl
// 맆淞β ��쳽瞬 ㏇ⅲ� ...
      Itog[3]:=Itog[3]+round(Opl/Delitel,2)
// 맆淞β ��쳽瞬 ㏇ⅲ� ...
      fwrite(desc,"�"+substr(budget,1,37)+space(37-len(budget))+"�"+;
      if(dolg!=0,str(round(dolg/Delitel,2),13,2),space(13))+"�"+;
      if(rash!=0,str(round(rash/Delitel,2),9,2),space(9))+"�"+;
      if(opl!=0,str(round(opl/Delitel,2),10,2),space(10))+;
      if(forma==2,;
      "�"+if(penq!=0,str(round(penq/Delitel,2),8,2),space(8))+"�"+;
      if(high!=0,str(round(high/Delitel,2),7,2),space(7))+"�         �         �       �        �",;
      "�        �       �         �         �       �        �")+;
      if(opl!=0,str(opl/Delitel,7,2),space(7))+"�         �         �"+;
      if(opl!=0,str(opl/Delitel,7,2),space(7))+"�"+;
      if(dolg!=0,str(dolg2/Delitel,13,2),space(13))+"�"+crlf+array)
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
fwrite(desc,"읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴좔컴컴컴컴좔컴컴컴컴컨컴컴컴컴좔컴컴컴좔컴컴컴컴좔컴컴컴컴좔컴컴컴좔컴컴컴컨컴컴컴컨컴컴컴컴컨컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴켸"+SCHET_NORM+crlf)
select oplata
close
fseek(desc,PosWrite+39,0)
      fwrite(desc,if(Itog[1]!=0,str(Itog[1],13,2),space(13))+"�"+;
      if(Itog[2]!=0,str(Itog[2],9,2),space(9))+"�"+;
      if(Itog[3]!=0,str(Itog[3],10,2),space(10))+;
      if(forma==2,"�"+if(Itog[4]!=0,str(Itog[4],8,2),space(8))+"�"+;
      if(Itog[5]!=0,str(Itog[5],7,2),space(7))+"�         �         �       �        �",;
      "�        �       �         �         �       �        �")+;
      if(Itog[3]!=0,str(Itog[3],7,2),space(7))+"�         �         �"+;
      if(Itog[3]!=0,str(Itog[3],7,2),space(7))+"�"+;
      if(Itog[6]!=0,str(Itog[6],13,2),space(13))+"�"+crlf)

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
Delitel:=GetVal("뮢嶺�飡� �猶�ㄸщ� 쩆��音 ",1000,0)
Delitel:=IF(Delitel==0,1,Delitel)

forma:=al_box({"뮜� 兒席� 52002"},2,{"겈� ����","� ���ⅸ"})
obrabot("맆淞β 兒席� 52002...")
deb1=if(_month_>1,"debet"+alltrim(str(_month_-1)),"last_debet")
deb2="debet"+alltrim(str(_month_))
desc:=fcreate(Ddir+"otchet.gkv")
fwrite(desc,SCHET_COND+"뵰席� 52002"+Space(155)+Dtoc(New_date)+CrLf)
fwrite(desc,center("렞��졻Ð췅� Þ兒席졿⑨ �� 젩����恂ぎ� 쭬ㄾウ����飡� 쭬 姉ⅹ循①αゃ� 子�薯⑧",176," ")+CrLf)
fwrite(desc,center("�췅�稅�� �誓ㄿ黍汀�� ．昔ㅱえ� 姉ⅹ循①αえ� 醒收�",176," ")+CrLf)
fwrite(desc,center("쭬 "+mesqc(_month_)+" "+alltrim(str(year(New_date)))+"�.",176,"")+crlf+crlf)
fwrite(desc,"뿞飡� 1. 룼 �循졹ワ� 췅昔ㄽ�． 若㏆⒰手�                                                                                                                             (� "+alltrim(str(Delitel))+".說�)  (� 뛾�)"+crlf)
if forma==1
   fwrite(desc,"旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴�"+crlf)
   fwrite(desc,"�                                     퀒젮�ウ����飡爾� �.� � 룼ㄻⅵⓥ퀠젶殊曄稅㉢                                    �  � � �  � � � � �                                  퀒젮�ウ����飡爾"+crlf)
   fwrite(desc,"�                                     �  췅 췅�젷�  날�ㅲ� 낟�쳽收 쭬� ��쳽曄�� 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�    췅       �"+crlf)
   fwrite(desc,"�            � � � � � � �            �  �洵β��．  퀬も젹㉢ �洵β�硫�   ㏇ⅲ�  �          ��쳽曄�� (收ゃ蟯� �쳽收┬)        날쳽收┬ � 淞β 쭬ㄾウ����飡� �誓ㅻ�.��黍�ㄾ∏ �洵β�莘    �"+crlf)
   fwrite(desc,"�                                     �    Д碎��   녁´昔こ  ��黍�� �          쳐컴컴컴컫컴컴컴컫컴컴컴컴컫컴컴컴컴컫컴컴컴컵컴컴컴컴쩡컴컴컴쩡컴컴컴컴쩡컴컴컴컴쩡컴컴컴�    쩆栒     �"+crlf)
   fwrite(desc,"�                                     �             �      �         �          낀��二젹㉢  룄�  끼ⅹ醒ワЖ�  쵟�.   낏獸．  낀��二젹㉢  룄�  끼ⅹ醒ワЖ�  쵟�.   낏獸．  �             �"+crlf)
   fwrite(desc,"�                                     �             �      �         �          �        �       �         녀α侁�젹㉢�쳽收┬�        �       �         녀α侁�젹㉢�쳽收┬�             �"+crlf)
   fwrite(desc,"쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴탠컴컴컵컴컴컴컴컵컴컴컴컴컴탠컴컴컴컵컴컴컴컵컴컴컴컴컵컴컴컴컴컵컴컴컴컵컴컴컴컴탠컴컴컴탠컴컴컴컴탠컴컴컴컴탠컴컴컴탠컴컴컴컴컴컴�"+crlf)
else
   fwrite(desc,"旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴�"+crlf)
   fwrite(desc,"�                                     퀒젮�ウ����飡爾� �.� � 룼ㄻⅵⓥ퀠젶殊曄稅㉢                                    �  � � �  � � � � �                                  퀒젮�ウ����飡爾"+crlf)
   fwrite(desc,"�                                     �  췅 췅�젷�  날�ㅲ� 낟�쳽收 쭬� ��쳽曄�� 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�    췅       �"+crlf)
   fwrite(desc,"�            � � � � � � �            �  �洵β��．  퀬も젹㉢ �洵β�硫�   ㏇ⅲ�  �          外�졽�瑜 �젺ゆĿ                  날쳽收┬ � 淞β 쭬ㄾウ����飡� �誓ㅻ�.��黍�ㄾ∏ �洵β�莘    �"+crlf)
   fwrite(desc,"�                                     �    Д碎��   녁´昔こ  ��黍�� �          쳐컴컴컴컫컴컴컴컫컴컴컴컴컫컴컴컴컴컫컴컴컴컵컴컴컴컴쩡컴컴컴쩡컴컴컴컴쩡컴컴컴컴쩡컴컴컴�    쩆栒     �"+crlf)
   fwrite(desc,"�                                     �             �      �         �          � ����   날��泣���         �         �       낀��二젹㉢  룄�  끼ⅹ醒ワЖ�  쵟�.   낏獸．  �             �"+crlf)
   fwrite(desc,"�                                     �             �      �         �          �        �       �         �         �       �        �       �         녀α侁�젹㉢�쳽收┬�             �"+crlf)
   fwrite(desc,"쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴탠컴컴컵컴컴컴컴컵컴컴컴컴컴탠컴컴컴컵컴컴컴컵컴컴컴컴컵컴컴컴컴컵컴컴컴컵컴컴컴컴탠컴컴컴탠컴컴컴컴탠컴컴컴컴탠컴컴컴탠컴컴컴컴컴컴�"+crlf)
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
    Itog[i]:=0 // 렊�乘���� 淞β葉첓 ⓥ�．�
next
fwrite(desc,"� 굫뀇� 룑 쓭뀗깕몚몤뀒�             �             �      �         �          �        �       �         �         �       �        �       �         �         �       �             � "+crlf)
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
                  if found().and.MYUpper(alltrim(licevoj->schetchik))!="�걥�.뙉솉"
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
      fwrite(desc,"�"+substr(narod,1,37)+space(37-len(substr(narod,1,37)))+"�"+;
      if(dolg!=0,str(round(dolg/Delitel,2),13,2),space(13))+"�      �"+;
      if(rash!=0,str(round(Rash/Delitel,2),9,2),space(9))+"�"+;
      if(opl!=0,str(round(opl/Delitel,2),10,2),space(10))+;
      if(forma==2,"�"+if(penq!=0,str(round(penq/Delitel,2),8,2),space(8))+"�"+;
      if(high!=0,str(round(high/Delitel,2),7,2),space(7))+"�         �         �       �        �",;
      "�        �       �         �         �       �        �")+;
      if(opl!=0,str(opl/Delitel,7,2),space(7))+"�         �         �"+;
      if(opl!=0,str(opl/Delitel,7,2),space(7))+"�"+;
      if(dolg!=0,str(dolg2/Delitel,13,2),space(13))+"�"+crlf)
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
fwrite(desc,"읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴좔컴컴컨컴컴컴컴컨컴컴컴컴컴좔컴컴컴컨컴컴컴컨컴컴컴컴컨컴컴컴컴컨컴컴컴컨컴컴컴컴좔컴컴컴좔컴컴컴컴좔컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴�"+SCHET_NORM+crlf)
fseek(desc,PosWrite,0)
fwrite(desc,"� 굫뀇� 룑 쓭뀗깕몚몤뀒�              �"+;
      if(itog[2]!=0,str(round(itog[2]/Delitel,2),13,2),space(13))+"�      �"+;
      if(itog[3]!=0,str(round(itog[3]/Delitel,2),9,2),space(9))+"�"+;
      if(itog[4]!=0,str(round(itog[4]/Delitel,2),10,2),space(10))+;
      if(forma==2,"�"+str(round(Itog[5]/Delitel,2),8,2)+"�"+;
      str(round(Itog[6]/Delitel,2),7,2)+"�         �         �       �        �",;
      "�        �       �         �         �       �        �")+;
      if(itog[11]!=0,str(itog[11]/Delitel,7,2),space(7))+"�         �         �"+;
      if(itog[14]!=0,str(itog[14]/Delitel,7,2),space(7))+"�"+;
      if(itog[15]!=0,str(itog[15]/Delitel,13,2),space(13))+"�"+crlf)
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
//--------------------------------------- 룯誓Д��瑜 ㄻ� 兒席ⓣ�쥯�⑨ �젩エ劣
LOCAL Len_Page:=42,Is_Shapka:=.T.,Pres_String:=0,End_Write:=.F.,Pages:=1
LOCAL OneStringLen:=111,penq:=0,penq1,high:=0,high1,str_ob:="",tmp_rec
//---------------------------------------------------------------------------
start_mes:=month_menu()
kol_mes=start_mes
if start_mes>0
   colorwin(09,13,14,67,'n+/n')
   set color to n/w,n/g
   @ 08,12 say "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
   @ 09,12 say "�"+space(53)+"�"
   @ 10,12 say "�   벆젲ⓥ� ㄻⓥ�レ��飡� 쭬ㄾウ����飡�    (Д�.)      �"
   @ 11,12 say "�   롡 率К�                   꽡 率К�               �"
   @ 12,12 say "�"+space(53)+"�"
   @ 13,12 say "突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴�"
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
        Delitel:=GetVal("뮢嶺�飡� �猶�ㄸщ� 쩆��音 ",1000,0)
        Delitel:=IF(Delitel==0,1,Delitel)
       kol_mes=kol_mes-1
       desc=fcreate(Ddir+"otchet.gkv")
// 닱Д����� �黍���졿Ŀ 飡�젺ⓩ� �黍�收�� 췅 LANDSCAPE
       fwrite(desc,SCHET_COND)
       fwrite(desc,"귣‘夕� 誓ぎД�ㅳ�щ� 쭬ㄾウ�Ø�� ㄻ� ˇ젴Л音 쭬曄獸�. 룯黍�� "+mesqc(start_mes-kol_mes)+;
              " - "+mesqc(start_mes)+"  獸嶺�飡� 1:"+alltrim(str(Delitel))+crlf)
       fwrite(desc,if(min_dolg#0,"롡 率К� �� Д�ⅴ "+alltrim(str(min_dolg))+" ","")+;
                   if(max_dolg#999999999999,"꽡 率К� �� ‘ゥ� "+alltrim(str(max_dolg)),"")+CrLf)
//---------------------------------------------------------------------------
       pres_string=2                   && 벀� 飡昔曄� � 飡�젺ⓩ� 쭬��キ���...
//---------------------------------------------------------------------------
       LenTablica=54+len(str(main->lic_schet))+len(main->potrebitel)
       obr_scr:=obrabot("귣‘夕� 쭬ㄾウ�Ø�� ㄻ� ˇ젴М쭬曄獸�")
       temp_=39/reccount()
       kol_kl=0
       go top
       do while !eof()
          penq1:=0; high1:=0; max_rash:=0
//-------------------------------------------------- 꽡줎˙���� �젽え �젩エ劣
          IF IS_SHAPKA
             IF PAGES#1
                fwrite(desc,space(OneStringLen-12)+"떒飡 N "+alltrim(str(pages))+crlf)
             ENDIF
             fwrite(desc,"�"+replicate("�",len(str(main->lic_schet)))+;
                "�"+replicate("�",len(main->potrebitel))+;
                "�"+replicate("�",9)+"�"+replicate("�",11)+"�"+replicate("�",8)+;
                "�"+replicate("�",15)+"�"+replicate("�",8)+"�"+crlf)

             fwrite(desc,"�"+center("�/�",len(str(main->lic_schet))," ",.t.)+"�"+;
                    center("뜝º���쥯��� �薯젺�쭬與�",len(main->potrebitel)," ",.t.)+;
                    "퀝誓�.�졹約꽡ィ 쭬 姉.� 섃�졽� � 뤲Þ汀瑜 Д贍 퀚�쳽曄���"+crlf)
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
//*********************************** 귣‘夕� 率К �� MIN ㄾ MAX
                  if (min_dolg<=&str_deb) .and. (max_dolg>=&str_deb)
//----------------------------------------------------------- 룯��
                     str_ob="penqn"+alltrim(str(int(i)))
                     penq1=penq1+&str_ob; penq=penq+&str_ob
                     str_ob="penq"+alltrim(str(int(i)))
                     penq1=penq1-&str_ob; penq=penq-&str_ob
//----------------------------------------------------------- 룼�泣��췅�
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
                select 77                       && 꽞� ��ⓤ첓 젮誓��.
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
             fwrite(desc,"�"+replicate("�",len(str(main->lic_schet)))+;
                "�"+replicate("�",len(main->potrebitel))+;
                "�"+replicate("�",9)+"�"+replicate("�",11)+"�"+replicate("�",8)+;
                "�"+replicate("�",15)+"�"+replicate("�",8)+"�"+crlf)
//---------------------------------------------------------------------------
                LenString=len("|"+str(main->lic_schet)+"|"+delstring(alltrim(main->potrebitel),"닄�"))+;
                len(main->potrebitel)-;
                len(delstring(alltrim(main->potrebitel),"닄�"))+;
                len("|   "+str(&str_deb/Delitel,15,2))

                fwrite(desc,"�"+str(main->lic_schet)+"�"+;
                       delstring(alltrim(main->potrebitel),"닄�")+;
                       space(len(main->potrebitel)-;
                       len(delstring(alltrim(main->potrebitel),"닄�")))+;
                       "�"+str(max_rash/Delitel,9,2)+;
                       "� "+str(&str_deb/Delitel,9,2)+" �"+;
                       str((penq1+high1)/Delitel,8,1)+;
                       "�               � "+str(opl,6,1)+" �"+crlf+;
                       '�'+space(len(str(main->lic_schet)))+'�'+;
                       alltrim(licevoj->adres)+" 뮙�."+;
                       alltrim(licevoj->telefon)+;
                       space(len(main->potrebitel)-;
                       len(alltrim(licevoj->adres)+" 뮙�."+;
                       alltrim(licevoj->telefon)))+;
                       "�         �           �        �               �        �"+crlf)
                total=total+1
                tot_sum=tot_sum+&str_deb
//---------------------------------------------------------------------------
                pres_string=pres_string+3              &&  3 飡昔囹� 쭬�ⓤ젺�
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
             fwrite(desc,"�"+replicate("�",len(str(main->lic_schet)))+;
                "�"+replicate("�",len(main->potrebitel))+;
                "�"+replicate("�",9)+"�"+replicate("�",11)+"�"+replicate("�",8)+;
                "�"+replicate("�",15)+"�"+replicate("�",8)+"�"+crlf+"뤲�ㄾウ���� 笹ⅳ濕�"+crlf+chr(12))
             END_WRITE=.T.
          ENDIF
       enddo
       IF !END_WRITE
             fwrite(desc,"�"+replicate("�",len(str(main->lic_schet)))+;
                "�"+replicate("�",len(main->potrebitel))+;
                "�"+replicate("�",9)+"�"+replicate("�",11)+"�"+replicate("�",8)+;
                "�"+replicate("�",15)+"�"+replicate("�",8)+"�"+crlf+"귗ⅲ� エ飡�� "+;
                   alltrim(str(pages))+crlf)
       ENDIF
       fwrite(desc,"귗ⅲ� 쭬ㄾウ�Ø�� "+str(total,3,0)+crlf+;
                   "  뇿ㄾウ����飡� �� 姉.子�薯Ŀ "+str(round(tot_sum/Delitel,2))+crlf+;
                   "  뇿ㄾウ����飡� �� ����       "+str(round(penq/Delitel,2))+crlf+;
                   "  뇿ㄾウ����飡� �� ���泣����� "+str(round(high/Delitel,2))+crlf)
       fwrite(desc,"댾��キⓥ�レ 묅��曄�ぎ �.�.  收�.5-45-76"+crlf)
       fwrite(desc,SCHET_NORM)
       fclose(desc)
       if total=0
          al_box({"뇿ㄾウ�Ø�� �� �∼졷拾���."})
       endif
       win_rest(obr_scr)
     else
          al_box({"뜢´惜�� ぎエ曄飡¡ Д碎璵� � �濡�夕�"})
     endif
    endif
   endif
   win_rest(screen)
   select(select)
   fclose(desc)
   go recno
endif
return NIL
