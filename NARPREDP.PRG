// Наряды и предписания
function NaryadPredp()
LOCAL old_col1:=setcolor(),screen:=win_save(9,24,24,79),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1
local first:=.T.
devout("")
spisok:={" Формирование наряда             ",;
         " Формирование предписания ",;
         " Новое предписаниe ",;
         " Новый наряд ",;
         " Просмотр нарядов и предписаний  ",;
         "─────────────────────────────────",;
         " Печать отчета                   "}
prev_rec=prev_rec-1
do while pos>0
   if file(Ddir+'otchet.gkv')
      pos=len(spisok)
      is_choice:={.t.,.t.,.t.,.t.,.t.,.F.,.t.}
   else
      is_choice:={.t.,.t.,.t.,.t.,.t.,.F.,.F.}
   endif
   if first
      pos=1
      first=.F.
   endif
choice=vert_menu(spisok,"Генерировать",is_choice,10,24,pos,'n/w,n/g,,,r/w',.F.)
        pos=choice
        wid=choice
        widsav:=wid
        if wid<8.and.wid>0
//                deletefile(dir+"otchet.gkv")
                pos=choice
        else
                pos=len(spisok)
        endif
        do case
                case wid=1
                     kolya_naryad()
                case wid=2
                     kolya_predpisanie()
                case wid=3
                     predpisanie2()
                case wid=4
                     Naryad2()
                case wid=5
                     view_naryad()
                case wid=len(spisok)
                     do print_fi
//                     copy_(dir+'otchet.gkv')
                otherwise
                     exit
        endcase
        wid=if(file(Ddir+'otchet.gkv'),8,widsav)
enddo
devout("")
win_rest(screen)
setcolor(old_col1)
return NIL



STATIC function kolya_naryad
LOCAL select:=select(),recno:=recno(),month
LOCAL base:=schet_share+"naryad.dbf",ntx:=schet_share+"naryad.ntx"
LOCAL naryad_rec,window:=win_save(07,08,15,74),color:=setcolor(),descr
LOCAL mes,debet:=0,s1:="Отключить за дебиторскую задолженность ",s2:=" ",s3:=" ",tmp_rec
private potreb,dog,phone:="__________"
potreb:=alltrim(delstring(main->potrebitel,"ИНН"))
dog:=alltrim(str(main->lic_schet))
select 15
seek main->lic_schet
month:=month_menu()
if month=0
   setcolor(color)
   select(select)
   go recno
   M->prev_rec=-1
   return NIL
endif
mes='debet'+aLLTRIM(STR(month))
if !found()
     append blank
     replace licevoj with main->lic_schet
endif
debet=&mes
select 77
seek main->lic_schet
adres=IF(Empty(Main->Adress),licevoj->adres,Main->Adress)
phone=if(!EMPTY(licevoj->telefon),licevoj->telefon,phone)
select 0
if file(ntx)
   use &base alias naryad index &ntx
else
   use &base alias naryad
   index on licevoj to &ntx
endif
seek main->lic_schet
if found()
   do while licevoj=main->lic_schet
      tmp_rec=recno()
      skip
   enddo
   go tmp_rec
   s1=if(stroka1#replicate("_",52),stroka1," ")
   s2=if(stroka2#replicate("_",52),stroka2," ")
   s3=if(stroka3#replicate("_",52),stroka3," ")
endif
if !netappend()        //---------------------------------------------------
   setcolor(color)
   select(select)
   go recno
   M->prev_rec=-1
endif
naryad_rec=recno()
replace licevoj with main->lic_schet
replace number with "1"
   //replace stroka1 with "Отключить КЛ 0.4кВ в РУ 0.4 кВ ТП N    фидер N"
replace stroka1 with s1
replace stroka2 with s2
replace stroka3 with s3
replace date with New_date
replace type with 1
replace summa with debet
set color to n/w,n/g,,,n/w
@ 07,08,14,73 box "         "
colorwin(8,9,15,74,"n+/n")
@ 07,08 say "┌───────────────────                     ────────────────────────╖"
@ 08,08 SAY "│ Договор N                Наряд N               Дата            ║"
@ 09,08 SAY "│ Cумма"+space(58)+"║"
@ 10,08 SAY "├─────────────────────── Работы по наряду ────────────────────── ║"
@ 11,08 SAY "│"+space(64)+"║"
@ 12,08 SAY "│"+space(64)+"║"
@ 13,08 SAY "│"+space(64)+"║"
@ 14,08 SAY "╘════════════════════════════════════════════════════════════════╝"
@ 08,20 SAY alltrim(str(licevoj))
set color to r/w
@ 07,29 SAY "Формирование наряда "
SET COLOR TO n/w,n/g,,,n/w
set cursor on
set confirm on
do while .t.
   @ 08,43 get number
   @ 08,62 get date
   @ 09,18 get summa
   @ 11,11 get stroka1
   @ 12,11 get stroka2
   @ 13,11 get stroka3
   read
   if lastkey()=27
      if empty(stroka1)
         replace stroka1 with replicate("_",52)
      endif
      if empty(stroka2)
         replace stroka2 with replicate("_",52)
      endif
      if empty(stroka3)
         replace stroka3 with replicate("_",52)
      endif
      exit
   endif
enddo
unlock
clear typeahead
set cursor off
set confirm off
win_rest(window)
//go naryad_rec
if al_box({"Сформировать бланк"},2,{" Сформировать "," Удалить "},1)==1
   itognaryad++
   if itognaryad>=2
      if al_box({"Выполнить прогон листа ("+alltrim(str(itognaryad))+")"},2)==1
         report(Ddir+"naryad.rpt",Ddir+"otchet.gkv",100,.t.)
      endif
      itognaryad=0
   else
      report(Ddir+"naryad.rpt",Ddir+"otchet.gkv",100)
   endif
//   report(dir+"naryad.rpt",dir+"otchet.gkv")
   replace stroka1 with if(stroka1#replicate("_",52),stroka1,"")
   replace stroka2 with if(stroka2#replicate("_",52),stroka2,"")
   replace stroka3 with if(stroka3#replicate("_",52),stroka3,"")
else
   IF RecLock()
      delete
      UNLOCK
   ENDIF
endif
//pack
use
setcolor(color)
select(select)
go recno
M->prev_rec=-1
return NIL



STATIC function view_naryad()
local base:=schet_share+"naryad.dbf",ntx:=schet_share+"naryad.ntx",sel:=select()
PRIVATE recbuf,ordbuf,buff,colorbuf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,inp
recbuf=recno()
ordbuf=indexord()
buff=win_save(1,0,maxrow(),maxcol())
colorbuf=setcolor()

select 0
if !file(base)
   al_box({"База данных "+schet_share+" не найдена"})
   return NIL
endif
if file(ntx)
   use &base alias naryad index &ntx
else
   use &base alias naryad
   index on licevoj to &ntx
endif

set color to n/w
@ 6, 0 clear to maxrow()-1,maxcol()
set color to n/w
@ 6, 14 say 'Справочник нарядов и предписаний'
declare zgl[8]
declare fil[8]
nm1=loarr('zgl','Договор',"N",'Что сделать','Что сделать','Что сделать','Сумма','Дата','Тип')
nm2=loarr('fil','licevoj','number','stroka1','stroka2','stroka3','summa','date','type')
inp='10000000'
t1=7
l1=1
b1=maxrow()-1
r1=maxcol()
seek main->lic_schet
if !found()
   go top
endif
*********
fsbrowse(7,1,23,78,'fil','zgl',inp,urov,kl)
use
select(sel)
set color to (colorbuf)
set order to ordbuf
go recbuf
win_rest(buff)
return NIL



STATIC function kolya_predpisanie
LOCAL color:=setcolor(),select:=select(),recno:=recno(),tmp_str,month
PRIVATE potr,lic,adres:="Адрес неизвестен",debet,phone:="неизвестен"
// Потребитель
potr=alltrim(delstring(main->potrebitel,"ИНН"))+" Дог.N "+alltrim(str(main->lic_schet))
// Дебиторская
month:=month_menu()
if month=0
   setcolor(color)
   select(select)
   go recno
   M->prev_rec=-1
   return NIL
endif
tmp_str="debet"+alltrim(str(month))
select 15
seek main->lic_schet
if !found()
     append blank
     replace licevoj with main->lic_schet
endif
debet=&tmp_str
if debet>0
   // Адрес-----------------
   select 77
   seek main->lic_schet
   if found()
     adres=IF(Empty(Main->Adress),licevoj->adres,Main->Adress)
     phone=if(!EMPTY(licevoj->telefon),licevoj->telefon,phone)
   endif
   if al_box({"Сформировать предписание"},2)==1
      report(Ddir+"predp.rpt",Ddir+"otchet.gkv")
   endif
else
     al_box({"Задолженности не обнаружено"})
     deletefile(Ddir+'otchet.gkv')
endif
setcolor(color)
select(select)
go recno
M->prev_rec=-1
return NIL



STATIC Function Predpisanie2()
LOCAL Sel:=Select(),rec:=recno(),Clr:=Setcolor(),Scr:=Win_Save(),CrLf:=Chr(13)+Chr(10)
LOCAL Spisok:={},PosNum:={},Position:={},Chosen:={},Selectables:={},kol_kl:=0
PRIVATE StringToPrint:="",Dolg:=0,Potr:=""
IF GetDolg(Main->Lic_Schet,Month(New_date))==0
   IF Al_Box({"Задолженность за текущий месяц не обнаружена"},2,{" Выход "," Продолжить "})==1
      Select(Sel); Go Rec
      SetColor(Clr); Win_Rest(Scr)
      Return NIL
   ENDIF
ENDIF
Select Licevoj
GO TOP
Seek Main->Lic_Schet
IF Found()
   DO While Lic_Sch=Main->Lic_Schet
//      IF Lic_Sch==Main->Lic_Schet
         AADD(Spisok,IF(Empty(Alltrim(Object1)),"Сч N"+Alltrim(Schetchik),' "'+Alltrim(Object1)+'" ')+' '+Alltrim(Adres)+" "+Alltrim(Razdel_1)+Space(5))
         AADD(PosNum,Recno())
//      ENDIF
      Skip
   ENDDO
   Win_Rest(Scr)
   IF Len(Spisok)!=0
      ASize(Position,Len(Spisok)); AFill(Position,.F.)
      ASize(Selectables,Len(Spisok)); AFill(Selectables,.T.)
//      Chosen = Sel_Box(3, 11, Spisok, selectables,, 1, 0, .T.,.T.,.F.)
      Chosen = Sel_Box(3, 11, Spisok, selectables,,,,,,.F.)
* Теперь высветим возвращенные результаты
      FOR I=1 TO LEN(Chosen)
          Position[Chosen[I]]:=.T.
      NEXT
      FOR I=1 To Len(Position)
          IF Position[i]
             Go PosNum[I]
             StringToPrint:=StringToPrint+Substr(space(5)+;
                            Alltrim(Object1)+" "+Alltrim(Adres)+" "+;
                            Alltrim(Razdel_1),1,77)+CrLf
          ENDIF
      NEXT
      Dolg:=GetDolg(Main->Lic_Schet,Month(New_date))
      Potr:=Delstring(Main->Potrebitel,"ИНН")
      Select(Sel); Go Rec
      Report(DDir+"Predp2.Rpt",DDir+ReportFile)
   ELSE
      Al_Box({"Объекты по потребителю не найдены"})
   ENDIF
ELSE
   Al_Box({"Объекты по потребителю не найдены"})
ENDIF
Select(Sel); Go Rec
SetColor(Clr); Win_Rest(Scr)
Return NIL


STATIC Function Naryad2()
LOCAL Sel:=Select(),rec:=recno(),Clr:=Setcolor(),Scr:=Win_Save(),CrLf:=Chr(13)+Chr(10)
LOCAL Spisok:={},PosNum:={},Position:={},Chosen:={},Selectables:={},kol_kl:=0
PRIVATE StringToPrint:="",Dolg:=0,Potr:=""
IF GetDolg(Main->Lic_Schet,Month(New_date))==0
   IF Al_Box({"Сформировать наряд"},2)==2
      Select(Sel); Go Rec
      SetColor(Clr); Win_Rest(Scr)
      Return NIL
   ENDIF
ENDIF
potreb:=alltrim(delstring(main->potrebitel,"ИНН"))
adres=IF(Empty(Main->Adress),licevoj->adres,Main->Adress)
phone=if(!EMPTY(licevoj->telefon),licevoj->telefon,"   ")
Select Licevoj
GO TOP
Seek Main->Lic_Schet
IF Found()
   DO While Lic_Sch=Main->Lic_Schet
//      IF Lic_Sch==Main->Lic_Schet
         AADD(Spisok,IF(Empty(Alltrim(Object1)),"Сч N"+Alltrim(Schetchik),' "'+Alltrim(Object1)+'" ')+' '+Alltrim(Adres)+" "+Alltrim(Razdel_1)+Space(5))
         AADD(PosNum,Recno())
//      ENDIF
      Skip
   ENDDO
   Win_Rest(Scr)
   IF Len(Spisok)!=0
      ASize(Position,Len(Spisok)); AFill(Position,.F.)
      ASize(Selectables,Len(Spisok)); AFill(Selectables,.T.)
//      Chosen = Sel_Box(3, 11, Spisok, selectables,, 1, 0, .T.,.T.,.F.)
      Chosen = Sel_Box(3, 11, Spisok, selectables,,,,,,.F.)
* Теперь высветим возвращенные результаты
      FOR I=1 TO LEN(Chosen)
          Position[Chosen[I]]:=.T.
      NEXT
      FOR I=1 To Len(Position)
          IF Position[i]
             Go PosNum[I]
             StringToPrint:=StringToPrint+Substr(space(11)+Alltrim(Object1)+;
                          " "+Alltrim(Adres)+" "+Alltrim(Razdel_1),1,77)+CrLf
          ENDIF
      NEXT
      Dolg:=GetDolg(Main->Lic_Schet,Month(New_date))
      Potr:=Delstring(Main->Potrebitel,"ИНН")
      Select(Sel); Go Rec
      Report(DDir+"Naryad2.Rpt",DDir+ReportFile)
   ELSE
      Al_Box({"Объекты по потребителю не найдены"})
   ENDIF
ELSE
   Al_Box({"Объекты по потребителю не найдены"})
ENDIF
Select(Sel); Go Rec
SetColor(Clr); Win_Rest(Scr)
Return NIL