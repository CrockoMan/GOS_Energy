Function ChoiceOplata()
LOCAL old_col1:=setcolor(),screen:=win_save(11,28,24,79),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1
local first:=.T.
spisok:={" Электроэнергия        ",;
         " Пеня                  ",;
         " Повышенная            ",;
         " Абонированная        ",;
         " Пеня и повышенная     ",;
         " Просмотр начислений пени и повышенной     ",;
         " Корректировка сальдо пени и повышенной",;
         " Разноска оплаты       ",;
         " Разноска оплаты частного сектора",;
         " Загрузка оплат из реестра банка"}
prev_rec=prev_rec-1
do while pos>0
   if first
      pos=1
      first=.F.
   endif
   choice=vert_menu(spisok,"Оплата",,11,28,pos,'n/w,n/g,,,r/w',.F.)
        pos=choice
        wid=choice
        widsav:=wid
        do case
                case wid=1
                     Oplata()
                case wid=2
                     penqoplata()
                case wid=3
                     highoplata()
                case wid=4
                     AbonOplata()
                case wid=5
                     highNpenq()
                case wid=6
                     ViewPenHigh()
                case wid=7
                     CorPenWHigh()
                case wid=8
                     Raznoska()
                case wid=9
                     ChastnOplata()
                case wid=10
                     ReadBank()
                otherwise
                     Exit
        endcase
        wid=if(file(Ddir+'otchet.gkv'),8,widsav)
enddo
M->prev_rec=-1
win_rest(screen)
setcolor(old_col1)
Return NIL



STATIC Function CorPenWHigh()
Local Clr:=SetColor(), Scr:=Win_Save(), Sel:=Select(),SumKorP:=0.00, SumKorH:=0.00
ColorWin(11,23,14,57,"n+/n")
Set Color To &GetColor

@ 10,22 SAY "┌───── Сальдо на начало года ─────╖"
//@ 10,22 SAY "┌─────────────────────────────────╖"
@ 11,22 SAY "│ Пеня                            ║"
@ 12,22 SAY "│ Повышенная                      ║"
@ 13,22 SAY "╘═════════════════════════════════╝"

Select Obormot
Seek Main->Lic_Schet
IF Found()
   SumKorP:=SaldoP
   SumKorH:=SaldoH
   Select(Sel)
ENDIF

Set Cursor On
Set Confirm On
@ 11,41 Get SumKorP PICTURE "@K99999999.99"
@ 12,41 Get SumKorH PICTURE "@K99999999.99"
READ
Set Cursor off
Set Confirm Off
IF LastKey()!=27
   IF Al_Box({"Внести корректировки"},2)==1
      Select Obormot
      Seek Main->Lic_Schet
      IF Found()
         IF RecLock()
            Replace SaldoP With SumKorP
            Replace SaldoH With SumKorH
            UNLOCK
         ENDIF
      EndIf
   ENDIF
ENDIF
Clear Typeahead
Select(Sel)
SetColor(Clr)
Win_Rest(Scr)
Return NIL



****************************************************************
Static Function oplata()
Local aOplata:={0,0,0,0,0,0,0,.t.},NextRec:=0,MaxRec:=0
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,;
name,month,go_out,change,sum,debet_pres,kredit_pres,debet_last,kredit_last,scr1,;
what_pay
change=.f.
go_out=.f.
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=win_save()
color_buf=setcolor()
what_pay=1
if urov<1
endif
do while .t.
   month_=month_menu(1)
   if month_>0
      message(" Идет поиск оплат по потребителю ")
      month=Schet_Share+'o'+alltrim(str(month_))+".dbf"
      if select()#44
              select 44
      endif
      Load("44",Month, Schet_Share+'o'+alltrim(str(month_))+".ntx" ,,.f.)
//      NetUse(month,,0)
      Select 45
      zap
      select 44
      seek main->lic_schet
      Do While Licevoj==main->lic_schet
         Select 44
         aOplata[1]:=Vid_Dokum
         aOplata[2]:=Num_Dokum
         aOplata[3]:=Licevoj
         aOplata[4]:=Summa
         aOplata[5]:=Data
         aOplata[6]:=Reestr
         aOplata[7]:=RecNo()
         select 45
         Append Blank
         Replace Vid_Dokum With aOplata[1]
         Replace Num_Dokum With aOplata[2]
         Replace Licevoj   With aOplata[3]
         Replace Summa     With aOplata[4]
         Replace Data      With aOplata[5]
         Replace Reestr    With aOplata[6]
         Replace RecNo     With aOplata[7]
         Select 44
         Skip
      ENDDO
      Select 45
//      set filter to licevoj=main->lic_schet
      go top
      set color to n/w
      colorwin(1,3,3,77,'w/w')
      declare zgl[5]
      declare fil[5]
      name='Справочник оплаты счетов за '+mesqc(month_)+' месяц'
      @ 1,3 say replicate(' ',73)
      @ 1,(79-len(name))/2 say name
      name=alltrim(main->potrebitel)+;
      IF(Asc(Substr(Main->LockMonth,Month_,1))==Month_," >> ПРОСМОТР <<","")
      @ 2,(79-len(name))/2 say name
      nm1=loarr('zgl','Вид док.','Номер док.','Сумма оплаты','Дата оплаты','N Реестра')
      nm2=loarr('fil','vid_dokum','num_dokum','summa','data','reestr')
      inp='0000'
      ************ Begin make box
      t1=3   && Up
      l1=3   && Left
      b1=18  && Down
      r1=77  && Right
      *************  End make
      colorwin(3,3,19,78,'n+/n')
//      DbEdit(3,3,18,77,Fil,,,,Zgl)
      fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl,IF(Asc(Substr(Main->LockMonth,Month_,1))==Month_,.f.,.t.))
      win_rest(buff)
//      set filter to
//      use
      if change

         select 45
         MaxRec:=RecCount()
         go top
         For NextRec=1 To MaxRec
            Select 45
            Go NextRec
            aOplata[1]:=Vid_Dokum
            aOplata[2]:=Num_Dokum
            aOplata[3]:=Licevoj
            aOplata[4]:=Summa
            aOplata[5]:=Data
            aOplata[6]:=Reestr
            aOplata[7]:=RecNo
            aOplata[8]:=Deleted()
            select 44
            IF aOplata[7]==0
               IF NetAppend()
                  aOplata[7]:=RecNo()
                  UNLOCK
               ENDIF
            ENDIF
            Go aOplata[7]
            IF RecLock()
               Replace Vid_Dokum With aOplata[1]
               Replace Num_Dokum With aOplata[2]
               Replace Licevoj   With aOplata[3]
               Replace Summa     With aOplata[4]
               Replace Data      With aOplata[5]
               Replace Reestr    With aOplata[6]
               IF aOplata[8]==.T.
                  Delete
               ENDIF
               UNLOCK
            ENDIF
         Next
         Select 45

         aaa=savescreen(9,7,13,74)
         message(" Данные были изменены !  Ждите,идет расчет !!! ")
         Select Main
         do outex with month_
         restscreen(9,7,13,74,aaa)
         select 44
         Close
      endif
      change=.f.
   else
         exit
   endif
enddo
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
win_rest(buff)
return NIL
*********************************



Static Function highoplata
private recbuf,ordbuf,scrbuf,colorbuf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,tmp,month_,database
sele=select()
recbuf=recno()
ordbuf=indexord()
scrbuf=win_save()
colorbuf=setcolor()
do while .t.
        month_=month_menu(1)
        if month_>0
                database=Schet_Share+'h'+alltrim(str(month_))+'.dbf'
                select 44
                Load("44",Database, Schet_Share+'h'+alltrim(str(month_))+".ntx" ,,.f.)
//                NetUse(database,,0)
                set color to
                set filter to licevoj=main->lic_schet
                go top
                set color to n/w
                declare zgl[5]
                declare fil[5]
                colorwin(1,3,19,78,'n+/n')
                name='Справочник оплаты повышенной за '+mesqc(month_)+' месяц'
                @ 1,3 say replicate(' ',75)
                @ 2,3 say replicate(' ',75)
                @ 1,(79-len(name))/2 say name
                name=alltrim(main->potrebitel)
                @ 2,(79-len(name))/2 say name
                nm1=loarr('zgl','Вид док.','Номер док.','Сумма оплаты','Дата оплаты','N Реестра')
                nm2=loarr('fil','vid_dokum','num_dokum','summa','data','reestr')
                inp='00000'
                ************ Begin make box
                t1=3   && Up
                l1=3   && Left
                b1=18  && Down
                r1=77  && Right
                *************  End make
                fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
                win_rest(scrbuf)
                set filter to
                go top
                use
        else
                exit
        endif
enddo
select(sele)
set color to (colorbuf)
set order to ordbuf
go recbuf
win_rest(scrbuf)
return NIL




Static Function AbonOplata
private recbuf,ordbuf,scrbuf,colorbuf,nm1,nm2,nm3,nm4,t1,l1,b1,r1
Private tmp,month_,database,Change:=.F.
sele=select()
recbuf=recno()
ordbuf=indexord()
scrbuf=win_save()
colorbuf=setcolor()
do while .t.
   month_=month_menu(1)
   if month_>0
      database=Schet_Share+'a'+alltrim(str(month_))+'.dbf'
      select 44
      Load("44",Database, Schet_Share+'a'+alltrim(str(month_))+".ntx" ,,.f.)
//      NetUse(database,,0)
      set color to
      set filter to licevoj=main->lic_schet
      go top
      set color to n/w
      declare zgl[5]
      declare fil[5]
      colorwin(1,3,19,78,'n+/n')
      name='Справочник оплаты абонированной за '+mesqc(month_)+' месяц'
      @ 1,3 say replicate(' ',75)
      @ 2,3 say replicate(' ',75)
      @ 1,(79-len(name))/2 say name
      name=alltrim(main->potrebitel)
      @ 2,(79-len(name))/2 say name
      nm1=loarr('zgl','Вид док.','Номер док.','Сумма оплаты','Дата оплаты','N Реестра')
      nm2=loarr('fil','vid_dokum','num_dokum','summa','data','reestr')
      inp='00000'
      ************ Begin make box
      t1=3   && Up
      l1=3   && Left
      b1=18  && Down
      r1=77  && Right
      *************  End make
      fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
      win_rest(scrbuf)
      set filter to
      go top
      use
      IF Change
         Select Main
         aaa=savescreen(9,7,13,74)
         message(" Данные были изменены !  Ждите,идет расчет !!! ")
         Do OutEx With Month_
         restscreen(9,7,13,74,aaa)
      ENDIF
   else
           exit
   endif
enddo
select(sele)
set color to (colorbuf)
set order to ordbuf
go recbuf
win_rest(scrbuf)
return NIL




Static Function penqoplata
private recbuf,ordbuf,scr,colorbuf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,tmp,month_,database
sele=select()
recbuf=recno()
ordbuf=indexord()
scr=win_save()
colorbuf=setcolor()
do while .t.
        month_=month_menu(1)
        if month_>0
                database=Schet_Share+'p'+alltrim(str(month_))+'.dbf'
                select 44
                Load("44",Database, Schet_Share+'p'+alltrim(str(month_))+".ntx" ,,.f.)
//                NetUse(database,,0)
                set color to
                set filter to licevoj=main->lic_schet
                go top
                set color to n/w
                declare zgl[5]
                declare fil[5]
                colorwin(1,3,19,78,'n+/n')
                name='Справочник оплаты пени за '+mesqc(month_)+' месяц'
                @ 1,3 say replicate(' ',75)
                @ 2,3 say replicate(' ',75)
                @ 1,(79-len(name))/2 say name
                name=alltrim(main->potrebitel)
                @ 2,(79-len(name))/2 say name
                nm1=loarr('zgl','Вид док.','Номер док.','Сумма оплаты','Дата оплаты','N Реестра')
                nm2=loarr('fil','vid_dokum','num_dokum','summa','data','reestr')
                inp='00000'
                ************ Begin make box
                t1=3   && Up
                l1=3   && Left
                b1=18  && Down
                r1=77  && Right
                *************  End make
                colorwin(3,3,16,78,'n+/n')
                fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
                win_rest(scr)
                set filter to
                go top
                use
        else
                exit
        endif
enddo
select(sele)
set color to (colorbuf)
set order to ordbuf
go recbuf
win_rest(scr)
return NIL



****************************************************************
Static Function ViewPenHigh()
PRIVATE recbuf,ordbuf,buff,colorbuf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,inp
recbuf=recno()
ordbuf=indexord()
buff=win_save(1,0,maxrow(),maxcol())
colorbuf=setcolor()
Sel=Select()
if urov<1
        if (.not. file(schet_Share+'PH.dbf')) .or. (.not. file(schet_Share+'PH.ntx'))
                sign(2)
                Select(Sel)
                set color to (colorbuf)
                win_rest(buff)
                return NIL
        else
                select 34
                if empty(fieldname(1))
                   wosst=.T.
                   al_box({"База данных не определена"})
                   return NIL
                endif
        endif
endif
devout("")
set color to n/w
@ 6, 0 clear to maxrow()-1,maxcol()
set color to n/w
@ 6, 1 say Center('Начисленные штрафные санкции '+Alltrim(Main->Potrebitel),77," ",.t.)
declare zgl[6]
declare fil[6]
nm1=loarr('zgl','Лиц.счет','Пеня','Повышенная','Р/мес.',"Примечание","М/н") &&,'Отрасль')
nm2=loarr('fil','licevoj','PenqN','HighN','Month','Text','MN') &&,'kod_otr')
inp='1000000000'
Set Filter To Licevoj==Main->Lic_Schet
Seek Main->Lic_Schet
go RecNo()
t1=7
l1=1
b1=maxrow()-1
r1=maxcol()
*********
fsbrowse(7,1,23,78,'fil','zgl',inp,urov,kl)
devout("")
set color to (colorbuf)
set order to ordbuf
Set Filter To
Go Top
Select(Sel)
go recbuf
win_rest(buff)
return NIL
*********************************