/*function makedebet9ps()
local debet9ps:=0
debet9ps=al_box({"Тип формируемого отчета дебиторов"},3,;
                 {" По форме 9ПС "," Бюджет "," Выход "})
do case
   case debet9ps=1
        make1debet9ps()
   case debet9ps=2
        make2debet9ps()
endcase
return NIL
*/




function make2debet9ps()
local month,sel:=select(),rec:=recno(),desc,crlf:=chr(13)+chr(10)
local big_dolg1:=0,big_dolg2:=0,big_rashod:=0,big_summa:=0,win:=win_save()
local color:=setcolor(),tot1:=0,tot2:=0,tot3:=0,tot4:=0
month=month_menu()
if month=0
   return NIL
endif
close all
//make9ps(month)
//---------------------------------------------------------------------------
// загрузка баз для 9-ПС
obrabot("Загрузка базы данных Otrasl")
select 0
netuse(schet_share+"otrasl.dbf",,,"otrasl")
go top
obrabot("Загрузка базы данных Main")
select 0
netuse(schet_share+"main.dbf",,,"main_base")
select 0
obrabot("Загрузка базы данных "+MonthBase(month))
netuse(schet_share+monthbase(month),,,"second_base")
index on licevoj to sb_lic
obrabot("Загрузка базы данных Obormot")
select 0
netuse(schet_share+"obormot.dbf",,,"oborotka")
index on lic_schet to sb_obor
select otrasl
go top
//---------------------------------------------------------------------------
debet_pres="debet"+alltrim(str(int(month)))
debet_last=if(month-1>1,"debet"+alltrim(str(int(month-1))),"last_debet")
//---------------------------------------------------------------------------
desc=fcreate(Ddir+"otchet.gkv")
fwrite(desc,"Дебиторская задолженность потребителей электрической энергии"+crlf)
fwrite(desc,"по бюджетным организациям "+if(month=month(New_date),"на "+dtoc(New_date),"за "+mesqc(month)+" месяц")+chr(15)+crlf)
fwrite(desc,replicate("-",116)+crlf)
fwrite(desc," N до-|                  Наименование                    | Задолженность | Кол-во потр.|   Cумма к   |Задолженность"+crlf)
fwrite(desc,"говора|                   потребителя                    | на 1-е число  |    кВтч     |    оплате   |на отчет.дату"+crlf)
fwrite(desc,replicate("-",116)+crlf)
//----------------------------------- Работа с базой отраслей промышленностей
select otrasl
go top
set color to +w/b
obrabot("Расчет задолжников по бюджету")
kol_kl=39/reccount()
temp=0
do while !eof()
  temp=temp+kol_kl
  colorwin(12,21,12,21+temp,'n/n')
   fwrite(desc,otrasl->otrasl+crlf)
//   @ 2,0 say otrasl
//--------------------------------------- расчет задолженности по потребителю
   select main_base
   go top
   tot1=tot1+big_dolg2; tot2=tot2+big_rashod
   tot3=tot3+big_summa; tot4=tot4+big_dolg1
   big_rashod=0;   big_summa=0;   big_dolg1=0;   big_dolg2=0
   do while !eof()
//      @ 3,0 say potrebitel
      if int(lim_tar1)=int(otrasl->kod_otr)
         select oborotka
         seek main_base->lic_schet
         if !found()
            append blank
         endif
         if &debet_pres>0
            big_dolg1=big_dolg1+&debet_pres
            big_dolg2=big_dolg2+&debet_last
            fwrite(desc,str(main_base->lic_schet)+"|"+main_base->potrebitel+"| "+;
                        str(&debet_last,13,2)+" |")
            select second_base
            go top
            seek main_base->lic_schet
            _rashod=0
            _summa=0
            if found()
             do while licevoj=main_base->lic_schet
               if summa>0.and.drug_nach=.f.
                           ras_hod=if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0,;
                           if(rashod-subab>0,rashod-subab,subab-rashod) ,0)
                                 _rashod=_rashod+ras_hod
                                 _summa=_summa+summa
                                 big_rashod=big_rashod+ras_hod
                                 big_summa=big_summa+summa
               endif
               skip
             enddo
            endif
//---------------- Запись полученного расхода, суммы к оплате и задолженности
            big_summa=big_summa+round(_summa+(_summa*schet_nds/100),0)
            _summa=_summa+round(_summa*schet_nds/100,0)
            fwrite(desc,str(_rashod,13,2)+"|"+str(_summa,13,2)+"|"+;
                        str(oborotka->&debet_pres,13,2)+"|"+crlf)
         endif
      endif
      select main_base
      skip
   enddo
   fwrite(desc,space(40)+"Bсего по отрасли "+str(big_dolg2,16,2)+"|"+;
               str(big_rashod,13,2)+"|"+str(big_summa,13,2)+"|"+;
               str(big_dolg1,13,2)+"|"+crlf)
   if big_dolg2=0.and.big_rashod=0.and.big_summa=0.and.big_dolg1=0
      fseek(desc,-170,1)
   endif
   select otrasl
  skip
enddo
fwrite(desc,replicate("-",116)+crlf)
fwrite(desc,space(52)+"Всего "+str(tot1,15,2)+"|"+;
            str(tot2,13,2)+"|"+str(tot3,13,2)+"|"+;
            str(tot4,15,2)+"|"+crlf+chr(18))
fclose(desc)
close all
//do servis2
loadgos()
win_rest(win)
select(sel)
go rec
setcolor(color)
ret_val=2
return NIL








function make1debet9ps()
local month,sel:=select(),rec:=recno(),desc,crlf:=chr(13)+chr(10)
local big_dolg1:=0,big_dolg2:=0,big_rashod:=0,big_summa:=0,win:=win_save()
local color:=setcolor(),tot1:=0,tot2:=0,tot3:=0,tot4:=0,PotrBezInn:=""
month=month_menu()
if month=0
   return NIL
endif
close all
//make9ps(month)
//---------------------------------------------------------------------------
// загрузка баз для 9-ПС
obrabot("Загрузка базы данных Otrasl")
select 0
netuse(schet_share+"otrasl.dbf",,,"otrasl")
go top
obrabot("Загрузка базы данных Main")
select 0
netuse(schet_share+"main.dbf",,,"main_base")
select 0
obrabot("Загрузка базы данных "+MonthBase(month))
netuse(schet_share+monthbase(month),,,"second_base")
index on licevoj to sb_lic
obrabot("Загрузка базы данных Obormot")
select 0
netuse(schet_share+"obormot.dbf",,,"oborotka")
index on lic_schet to sb_obor
select otrasl
go top
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
debet_pres="debet"+alltrim(str(int(month)))
debet_last=if(month-1>1,"debet"+alltrim(str(int(month-1))),"last_debet")
//---------------------------------------------------------------------------
desc=fcreate(Ddir+"otchet.gkv")
fwrite(desc,"Дебиторская задолженность потребителей электрической энергии"+crlf)
fwrite(desc,"по отраслям промышленности "+if(month=month(New_date),"на "+dtoc(New_date),"за "+mesqc(month)+" месяц")+chr(15)+crlf)
fwrite(desc,replicate("-",116)+crlf)
fwrite(desc," N до-|                  Наименование                    | Задолженность | Кол-во потр.|   Cумма к   |Задолженность"+crlf)
fwrite(desc,"говора|                   потребителя                    | на 1-е число  |    кВтч     |    оплате   |на отчет.дату"+crlf)
fwrite(desc,replicate("-",116)+crlf)
//----------------------------------- Работа с базой отраслей промышленностей
select otrasl
go top
set color to +w/b
obrabot("Расчет задолжников по порме 9-ПС")
kol_kl=39/reccount()
temp=0
do while !eof()
  temp=temp+kol_kl
  colorwin(12,21,12,21+temp,'n/n')
  if !empty(otrasl->otrasl)
   fwrite(desc,otrasl->otrasl+crlf)
   @ 2,0 say otrasl
//--------------------------------------- расчет задолженности по потребителю
   select main_base
   go top
   tot1=tot1+big_dolg2; tot2=tot2+big_rashod
   tot3=tot3+big_summa; tot4=tot4+big_dolg1
   big_rashod=0;   big_summa=0;   big_dolg1=0;   big_dolg2=0
   do while !eof()
      @ 3,0 say main_base->potrebitel
      if main_base->kod_otr=otrasl->kod_otr
         select oborotka
         seek main_base->lic_schet
         if !found()
            append blank
         endif
         if &debet_pres>0
            big_dolg1=big_dolg1+&debet_pres
            big_dolg2=big_dolg2+&debet_last
            PotrBezInn:=Delstring(main_base->potrebitel,"  .")
            PotrBezInn:=AllTrim(Delstring(AllTrim(PotrBezInn),"ИНН"))
            PotrBezInn:=SubStr(PotrBezInn+Space(1+Len(Main_Base->Potrebitel)-Len(PotrBezInn)),1,50)
            fwrite(desc,str(main_base->lic_schet)+"|"+PotrBezInn+"| "+;
                        str(&debet_last,13,2)+" |")
            select second_base
            go top
            seek main_base->lic_schet
            _rashod=0
            _summa=0
            if found()
             do while licevoj=main_base->lic_schet
               if summa!=0.and.drug_nach=.f.
                           ras_hod=if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0,;
                           if(rashod-subab>0,rashod-subab,subab-rashod) ,0)
                                 _rashod=_rashod+ras_hod
                                 _summa=_summa+summa
                                 big_rashod=big_rashod+ras_hod
                                 big_summa=big_summa+summa
               endif
               skip
             enddo
            endif
//---------------- Запись полученного расхода, суммы к оплате и задолженности
            big_summa=big_summa+round(_summa+(_summa*schet_nds/100),0)
            _summa=_summa+round(_summa*schet_nds/100,0)
            fwrite(desc,str(_rashod,13,2)+"|"+str(_summa,13,2)+"|"+;
                        str(oborotka->&debet_pres,13,2)+"|"+crlf)
         endif
      endif
      select main_base
      skip
   enddo
   fwrite(desc,space(40)+"Bсего по отрасли "+str(big_dolg2,16,2)+"|"+;
               str(big_rashod,13,2)+"|"+str(big_summa,13,2)+"|"+;
               str(big_dolg1,13,2)+"|"+crlf)
   if big_dolg2=0.and.big_rashod=0.and.big_summa=0.and.big_dolg1=0
      fseek(desc,-170,1)
   endif
   select otrasl
  endif
  skip
enddo
fwrite(desc,replicate("-",116)+crlf)
fwrite(desc,space(52)+"Всего "+str(tot1,15,2)+"|"+;
            str(tot2,13,2)+"|"+str(tot3,13,2)+"|"+;
            str(tot4,15,2)+crlf+chr(18))
fclose(desc)
close all
//do servis2
loadgos()
win_rest(win)
select(sel)
go rec
setcolor(color)
ret_val=2
return NIL



STATIC function make9ps(month)
do case
        case month=1
                database='jan.dbf'
                cMonth:='JAN'
        case month=2
                database='feb.dbf'
                cMonth:='FEB'
        case month=3
                database='mar.dbf'
                cMonth:='MAC'
        case month=4
                database='apr.dbf'
                cMonth:='APR'
        case month=5
                database='may.dbf'
                cMonth:='MAY'
        case month=6
                database='jun.dbf'
                cMonth:='JUN'
        case month=7
                database='jul.dbf'
                cMonth:='JUL'
        case month=8
                database='aug.dbf'
                cMonth:='AUG'
        case month=9
                database='sep.dbf'
                cMonth:='SEP'
        case month=10
                database='oct.dbf'
                cMonth:='OCT'
        case month=11
                database='nov.dbf'
                cMonth:='nov'
        case month=12
                database='dec.dbf'
                cMonth:='dec'
endcase
copy_(schet_share+"obormot.dbf",dir+'ps_oborm.dbf')
copy_(schet_share+database,dir+'ps_tmp.dbf')
copy_(schet_share+'main.dbf',dir+'ps_tmp1.dbf')
copy_(schet_share+'limit.dbf',dir+'ps_tmp2.dbf')
make_ind('0',dir+'ps_tmp2.dbf',dir+"index9ps.ntx",'lic_schet')
*************************************************
close all
return NIL



STATIC function monthbase(month)
do case
        case month=1
                database='jan.dbf'
                cMonth:='JAN'
        case month=2
                database='feb.dbf'
                cMonth:='FEB'
        case month=3
                database='mar.dbf'
                cMonth:='MAC'
        case month=4
                database='apr.dbf'
                cMonth:='APR'
        case month=5
                database='may.dbf'
                cMonth:='MAY'
        case month=6
                database='jun.dbf'
                cMonth:='JUN'
        case month=7
                database='jul.dbf'
                cMonth:='JUL'
        case month=8
                database='aug.dbf'
                cMonth:='AUG'
        case month=9
                database='sep.dbf'
                cMonth:='SEP'
        case month=10
                database='oct.dbf'
                cMonth:='OCT'
        case month=11
                database='nov.dbf'
                cMonth:='nov'
        case month=12
                database='dec.dbf'
                cMonth:='dec'
endcase
return database
