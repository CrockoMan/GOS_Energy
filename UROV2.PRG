*******************************************************************************
*      Файл с процедурами второго уровня вызываются после главной базы        *
*               Годовая таблица и таблица лицевого счета                      *
*******************************************************************************
#include "inkey.ch"
#include "xbtscan.ch"

PROC Raschet
LOCAL scr:=win_save(),is_choice,choic,spisok,pos:=1,select:=select()
LOCAL recno:=recno()
private old_cl,screen,go_out,_kod
old_cl=setcolor()
go_out=.f.
spisok:={" Показания счетчика за год    ",;
         " Таблицу лицевого счета       ",;
         " Таблицу бытового абонента    ",;
         " Оплаты бытового абонента     ",;
         " Расчет потерь                ",;
         " Пломбировка счетчика         ",;
         "──────────────────────────────",;
         " Выход                        "}
//         " Расчет потерь до границы раздела  ",;
//         " Расчет потерь в трасформаторе ",;
IF AtNum("ПОТЕРИ",MYUpper(AllTrim(Schetchik)))!=0.or.AtNum("ДОНАЧ",MYUpper(AllTrim(Schetchik)))!=0
   is_choice:={.t.,.t.,.t.,.F.,.F.,.F.,.F.,.t.}
ELSE
   is_choice:={.t.,.t.,.t.,.t.,.t.,.t.,.F.,.t.}
ENDIF
IF Main->Lic_Schet<100000
   is_choice[3]=.F.
   is_choice[4]=.F.
ENDIF
do while .not.go_out
   choic=vert_menu(spisok,"Просмотреть",is_choice,10,25,pos,'n/w,n/g,,,r/w',.F.)
   pos:=choic
   do case
        case choic=6
                Plombirovka()
        case choic=5
        		 LoseMenu()        
        case choic=4
                ChastnKvit()
        case choic=3
                CorFnsi("")
        case choic=2
                do write_schet
        case choic=1
                _kod='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
                do _year_tablica
                win_rest(scr)
                IF Lastkey()=13
//                   Keyboard Chr(27)+IF(Recno()!=Reccount(),Chr(24)+chr(10)+chr(13),"")
                ELSE
//                   Keyboard Chr(27)+IF(Recno()!=Reccount(),Chr(24),"")
                ENDIF
        otherwise
                go_out=.t.
   endcase
enddo
win_rest(scr)
select(select)
go recno
setcolor(old_cl)
return





Function LoseMenu()
LOCAL scr:=win_save(),is_choice,choic,spisok,pos:=1,select:=select()
LOCAL recno:=recno()
Local old_cl,screen,go_out,_kod
old_cl=setcolor()
go_out=.f.
spisok:={" Расчет потерь до границы раздела  ",;
		     " Расчет потерь до границы раздела  2006г.",;
         " Расчет потерь в трасформаторе ",;
         " Расчет потерь в трасформаторе 2006г."}
IF AtNum("ПОТЕРИ",MYUpper(AllTrim(Schetchik)))!=0.or.AtNum("ДОНАЧ",MYUpper(AllTrim(Schetchik)))!=0.or.;
	 Main->Lic_Schet>=100000
   is_choice:={.f.,.f.,.f.,.f.}
ELSE
   is_choice:={.t.,.t.,.t.,.t.}
ENDIF
do while .not.go_out
   choic=vert_menu(spisok,"Пoтери",is_choice,16,27,pos,'n/w,n/g,,,r/w',.F.)
   pos:=choic
   do case
        case choic=1
                WriteLose()
        case choic=2
                WriteLose2()
        case choic=3
                WriteLoseTrans()
        case choic=4
                WriteLoseTrans2()
        otherwise
                go_out=.t.
   endcase
enddo
win_rest(scr)
select(select)
go recno
setcolor(old_cl)
return NIL






Function WriteLoseTrans()       //      Потери в трасформаторе
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),Kod
Local tmpPO,tmpLENGTH,tmpSQUARE,tmpSMENA,tmpTYPE,tmpKOEFF
_Kode='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
Select LoseTran
Seek _Kode
IF .Not.Found()
   IF Al_Box({"Данные для расчета потерь в трасформаторе не найдены"},2,{" Ввести "," Выход "})==1
      IF NetAppend()
         IsRecalc:=.T.
         Replace Kod With _Kode
         Replace Licevoj With licevoj2->lic_sch
         UnLock
      ENDIF
   ELSE
      Select(Sel)
      Go Rec
      Return NIL
   ENDIF
ENDIF
Set Color To &GetColor
ColorWin(9,19,15,63,"n+/n")
@ 08,18 SAY "┌──────────────────────────────────────────╖"
@ 09,18 SAY "│ Потери холостого хода               кВт  ║"
@ 10,18 SAY "│ Время нах. под напряжением          час. ║"
@ 11,18 SAY "│ Потери мощности КЗ                  кВт  ║"
@ 12,18 SAY "│ Время работы под нагрузкой          час. ║"
@ 13,18 SAY "│ Мощность                            ква  ║"
@ 14,18 SAY "╘══════════════════════════════════════════╝"

@ 09,48 Say Pxx
MyTmpStr:="To"
@ 10,48 Say &MyTmpStr
@ 11,48 Say Pkz
@ 12,50 Say Tp
@ 13,48 Say Snomt

IF RecLock()
   set curs on
   set conf on
//   SET Key 32 TO HelpWrite
   Do While .t.
      @ 09,48 Get Pxx
      @ 10,48 Get &MyTmpStr
      @ 11,48 Get Pkz
      @ 12,50 Get Tp
      @ 13,48 Get Snomt
      read
      IF LastKey()==27
         Clear Typeahead
         IsRecalc:=.T.
         Exit
      ENDIF
   enddo
//   SET Key 32 TO
   set curs off
   set conf off
   UNLOCK
ENDIF
SetColor(Clr)
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL



Function WriteLoseTrans2()       //      Потери в трасформаторе
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),Kod
Local tmpPO,tmpLENGTH,tmpSQUARE,tmpSMENA,tmpTYPE,tmpKOEFF
_Kode='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
Select LoseTran
Seek _Kode
IF .Not.Found()
   IF Al_Box({"Данные для расчета потерь в трасформаторе не найдены"},2,{" Ввести "," Выход "})==1
      IF NetAppend()
         IsRecalc:=.T.
         Replace Kod With _Kode
         Replace Licevoj With licevoj2->lic_sch
         UnLock
      ENDIF
   ELSE
      Select(Sel)
      Go Rec
      Return NIL
   ENDIF
ENDIF
Set Color To &GetColor
ColorWin(9,19,16,63,"n+/n")
@ 08,18 SAY "┌──────────────────────────────────────────╖"
@ 09,18 SAY "│ Потери холостого хода               кВт  ║"
@ 10,18 SAY "│ Время нах. под напряжением          час. ║"
@ 11,18 SAY "│ Потери мощности КЗ                  кВт  ║"
@ 12,18 SAY "│ Время работы под нагрузкой          час. ║"
@ 13,18 SAY "│ Коэффициент мощности                     ║"
@ 14,18 SAY "│ Коэффициент формы графика                ║"
@ 15,18 SAY "╘══════════════════════════════════════════╝"

@ 09,48 Say Pxx
MyTmpStr:="To"
@ 10,48 Say &MyTmpStr
@ 11,48 Say Pkz
@ 12,50 Say Tp
@ 13,48 Say KMoshn
@ 14,48 Say KGR

IF RecLock()
   set curs on
   set conf on
//   SET Key 32 TO HelpWrite
   Do While .t.
      @ 09,48 Get Pxx
      @ 10,48 Get &MyTmpStr
      @ 11,48 Get Pkz
      @ 12,50 Get Tp
      @ 13,48 Get KMoshn
      @ 14,48 Get KGr
      read
      IF LastKey()==27
         Clear Typeahead
         IsRecalc:=.T.
         Exit
      ENDIF
   enddo
//   SET Key 32 TO
   set curs off
   set conf off
   UNLOCK
ENDIF
SetColor(Clr)
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL





Function WriteLose2()    // Потери в линии
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),Kod
Local tmpPO,tmpLENGTH,tmpSQUARE,tmpSMENA,tmpTYPE,tmpKOEFF
_Kode='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
Select Lose
Seek _Kode
IF .Not.Found()
   IF Al_Box({"Данные для расчета потерь по счетчику "+alltrim(licevoj2->schetchik)+" не найдены"},2,{" Ввести "," Выход "})==1
      IF NetAppend()
         IsRecalc:=.T.
         Replace Kod With _Kode
         Replace Licevoj With licevoj2->lic_sch
         
//         Replace Smena With 1
         DO Case
            CASE AtNum("220",Licevoj2->B)>0
                 Replace NPHASE With 1
            CASE AtNum("380",Licevoj2->B)>0
                 Replace NPHASE With 3
         ENDCASE
         
         UnLock
      ENDIF
   ELSE
      Select(Sel)
      Go Rec
      Return NIL
   ENDIF
ENDIF
Set Color To &GetColor
ColorWin(8,19,18,63,"n+/n")
@ 07,18 SAY "┌──────────────────────────────────────────╖"
@ 08,18 SAY "│ Удельное сопротивление              Ом   ║"
@ 09,18 SAY "│ Длина проводника                    м.   ║"
@ 10,18 SAY "│ Количество дней работы                   ║"
@ 11,18 SAY "│ Количество часов работы                  ║"
@ 12,18 SAY "│ Площадь сечения проводника          мм¤  ║"
@ 13,18 SAY "│ Коэффициент формы графика                ║"
@ 14,18 SAY "│ Коэффициент мощности                     ║"
@ 15,18 SAY "│ Уровень напряжения                       ║"
@ 16,18 SAY "│ Количество фаз ввода                     ║"
@ 17,18 SAY "╘══════════════════════════════════════════╝"

@ 08,48 Say PO
@ 09,48 Say LENGTH2
@ 10,48 Say Days
@ 11,48 Say Hours
@ 12,48 Say SQUARE
@ 13,48 Say KGR
@ 14,48 Say KMOSHN
@ 15,48 Say UNapr
@ 16,48 Say NPHASE

IF RecLock()
   set curs on
   set conf on
   SET Key 32 TO HelpWrite
   Do While .t.

			@ 08,48 Get PO
			@ 09,48 Get LENGTH2
			@ 10,48 Get Days
			@ 11,48 Get Hours
			@ 12,48 Get SQUARE
			@ 13,48 Get KGR
			@ 14,48 Get KMOSHN
			@ 15,48 Get UNapr
			@ 16,48 Get NPHASE

      READ

      IF LastKey()==27
         Clear Typeahead
         IsRecalc:=.T.
         Exit
      ENDIF
   enddo
   SET Key 32 TO
   set curs off
   set conf off
   UNLOCK
ENDIF
SetColor(Clr)
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL







Function WriteLose()    // Потери в линии
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),Kod
Local tmpPO,tmpLENGTH,tmpSQUARE,tmpSMENA,tmpTYPE,tmpKOEFF
_Kode='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
Select Lose
Seek _Kode
IF .Not.Found()
   IF Al_Box({"Данные для расчета потерь по счетчику "+alltrim(licevoj2->schetchik)+" не найдены"},2,{" Ввести "," Выход "})==1
      IF NetAppend()
         IsRecalc:=.T.
         Replace Kod With _Kode
         Replace Licevoj With licevoj2->lic_sch
         Replace Smena With 1
         DO Case
            CASE AtNum("220",Licevoj2->B)>0
                 Replace Koeff With 0.0225
            CASE AtNum("380",Licevoj2->B)>0
                Replace Koeff With 0.0076
         ENDCASE
         UnLock
      ENDIF
   ELSE
      Select(Sel)
      Go Rec
      Return NIL
   ENDIF
ENDIF
Set Color To &GetColor
ColorWin(8,19,15,63,"n+/n")
@ 07,18 SAY "┌──────────────────────────────────────────╖"
@ 08,18 SAY "│ Удельное сопротивление              Ом   ║"
@ 09,18 SAY "│ Длина проводника                    м.   ║"
@ 10,18 SAY "│ Площадь сечения проводника          мм¤  ║"
@ 11,18 SAY "│ Количество дней работы                   ║"
@ 12,18 SAY "│ Количество часов работы                  ║"
@ 13,18 SAY "│ Расчетный коэффициент                    ║"
@ 14,18 SAY "╘══════════════════════════════════════════╝"

@ 08,48 Say PO
@ 09,48 Say LENGTH
@ 10,48 Say SQUARE
@ 11,48 Say Days
@ 12,48 Say Hours
@ 13,48 Say KOEFF
SayLoseType(KOEFF)

IF RecLock()
   set curs on
   set conf on
   SET Key 32 TO HelpWrite
   Do While .t.
      @ 08,48 Get PO
      @ 09,48 Get LENGTH
      @ 10,48 Get SQUARE
      @ 11,48 Get Days
      @ 12,48 Get Hours
      @ 13,48 Get KOEFF  Valid SayLoseType(KOEFF)
      read
      IF LastKey()==27
         Clear Typeahead
         IsRecalc:=.T.
         Exit
      ENDIF
   enddo
   SET Key 32 TO
   set curs off
   set conf off
   UNLOCK
ENDIF
SetColor(Clr)
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL



Procedure HelpWrite
Local VarName:=ReadVar(),PoType,Spisok,Is_Choice:={},Scr:=Win_Save()
Local StartPos:=1,I
Set Key 32 To
Spisok:={" Абазовик В.В. "," Бородай Ю.Ю. " ," Веккер Л.В. "," Калинин А.В. " ," Морозова Л.В. ",;
         " Кишишьян О.М." ," Литвинова Л.М."," Мак В.Г. "   ," Степченко Н.А."," Шестиглазов Г.В. ",;
         " Огненко А.М. " ," Телебзда М.Н. "," Яровой П.Б. "," Авакян И.Н. "  ," Маслихин А.В.",;
         " Власенко И.Т. "," Мелентьева Т.П."}
Do Case
   Case VarName=="NAMEON".or.VarName=="TNAME"
        For I=1 To Len(Spisok)
            AAdd(Is_Choice,.T.)
        Next
        PoType=vert_menu(spisok,"Инспектор",is_choice,11,38,1,'n/w,n/g,,,r/w',.F.)
        IF PoType>0
           DO Case
              Case VarName=="NAMEON"
                   Replace NameOn With Spisok[PoType]
              Case VarName=="TNAME"
                   M->TNAME:=Spisok[PoType]+Space(30-Len(Spisok[PoType]))
           ENDCASE
        ENDIF
   Case VarName=="NAMEOFF"
        For I=1 To Len(Spisok)
            AAdd(Is_Choice,.T.)
        Next
        PoType=vert_menu(spisok,"Инспектор",is_choice,11,38,1,'n/w,n/g,,,r/w',.F.)
        IF PoType>0
           Replace NameOff With Spisok[PoType]
        ENDIF
   Case VarName=="PO"
        Spisok:={" Алюминий "," Медь "," Другой материал "}
        Is_Choice:={.t.,.t.,.t.}
        StartPos:=IF(PO==0.0182,2,1)
        PoType=vert_menu(spisok,"Материал провода",is_choice,9,48,StartPos,'n/w,n/g,,,r/w',.F.)
        tmpPO=PO
        DO Case
           Case PoType==1
                tmpPO=0.0295
           Case PoType==2
                tmpPO=0.0182
        EndCase
        Replace Po With tmpPO
        KeyBoard Chr(13)
   Case VarName=="KOEFF"
        Spisok:={" 220B "," 380B "," 6  кВ "," 10 кВ"}
        Is_Choice:={.t.,.t.,.t.,.t.}
        Do Case
           Case KOEFF==0.0076
                StartPos=2
           Case KOEFF==0.000031
                StartPos=3
           Case KOEFF==0.000011
                StartPos=4
           OtherWise
                StartPos=1
        ENDCASE
        tmpKoeff:=KOEFF
        TypeKOEFF=vert_menu(spisok," Cеть ",is_choice,13,45,StartPos,'n/w,n/g,,,r/w',.F.)
        Do Case
           Case TypeKoeff==1
                tmpKoeff=0.04545
           Case TypeKoeff==2
                tmpKoeff=0.0076
           Case TypeKoeff==3
                tmpKoeff=0.000031
           Case TypeKoeff==4
                tmpKoeff=0.000011
        EndCase
        Replace KOEFF With tmpKOEFF
        SayLoseType(tmpKOEFF)
        KeyBoard Chr(13)
EndCase
Win_Rest(Scr)
Set Key 32 To HelpWrite
Return


Function SayLoseType(nType)
Local Value:=.T.
Do Case
   Case nType=0.04545
        @ 13,57 Say "220B"
   Case nType=0.0076
        @ 13,57 Say "380B"
   Case nType=0.000031
        @ 13,57 Say "6 кB"
   Case nType=0.000011
        @ 13,57 Say "10кB"
   Case nType=0.000000
        @ 13,57 Say "????"
   OtherWise
        Value=.F.
EndCase
Return Value


Function IsEditField()
Local ReturnValue:=.F.
DO CASE
   Case select()==200
//        @ 1,0 say PlombaIsOut
//        @ 1,1 say IsMonthLocked(Month)
        IF PlombaIsOut==.F..and.IsMonthLocked(Month)==.F.
           ReturnValue:=.T.
        ENDIF
       IF EditField==.T.
          ReturnValue:=.T.
       ENDIF
   OTHERWISE
       ReturnValue:=.T.
ENDCASE
Return ReturnValue


STATIC proc _year_tablica
local flock_scr,temp_,kol_kl,oldsel:=select()
Local oDlg,aSizeDeskTop,aPos,oProgress
private rec_bu,ord_bu,buf,color_bu,nm1,nm2,nm3,nm4,t1,l1,b1,r1,found
private change,name,EditField:=.F.,FsKeyboard:=""
rec_bu=recno()
ord_bu=indexord()
buf=win_save()
color_bu=setcolor()
change=.f.

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Поиск показаний счетчика за год" 
oDlg:SysMenu	 := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos						:= oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := 24
//temp_=39/24
kol_kl=0
set color to
select 200
zap
found=.f.
//al_box({_kod})
for i=1 to 12
   	oProgress:increment()																				// Progress Bar Increment
    select(i)
    seek _kod
//    kol_kl=kol_kl+temp_
//    colorwin(12,21,12,21+kol_kl,'n/n')
    if found() .and. .not.deleted()
       found=.t.
    endif
next
if .not.found
        if al_box({'По счетчику данные не найдены.'},2,{" Продолжить "," Выход "})==1
                      select 200
                      for i=1 to 12
                        append blank
                        replace month with i
   											oProgress:increment()																				// Progress Bar Increment
//                        kol_kl=kol_kl+temp_
//                        colorwin(12,21,12,21+kol_kl,'n/n')
                      next
        else
								oProgress:destroy()																							// Progress Bar Destroy
								oDlg:Destroy()
                select(oldsel)
                return
        endif
else
        for i=1 to 12
   					oProgress:increment()																				// Progress Bar Increment
//            kol_kl=kol_kl+temp_
//            colorwin(12,21,12,21+kol_kl,'n/n')
            select(i)
            go top
            seek _kod

            if found()
               select 200
               append blank
               select(i)
               if reclock()
                    replace all_mont->month     with i
                    replace all_mont->Info      with Info
                    replace all_mont->pokazaniq with pokazaniq
                    replace all_mont->pokoff    with pokoff
                    replace all_mont->raznica   with raznica
                    replace all_mont->koeficient with koeficient
                    replace all_mont->koeffoff  with koeffoff
                    replace all_mont->rashod    with rashod
                    replace all_mont->rashoff   with rashoff
                    replace all_mont->tarif     with tarif
                    replace all_mont->summa     with summa
                    replace all_mont->recno     with recno()
                    replace all_mont->percent   with percent
                    replace all_mont->subab     with subab
                    replace all_mont->moshn     with moshn
                    replace All_Mont->IsLastMont with IsLastMont
                    replace drug_nach           with licevoj2->reaktivn
                    replace All_Mont->NewValue  with NewValue
                    replace All_Mont->IsNewValue with IsNewValue
                    replace All_Mont->DaysHigh  with DaysHigh
                    unlock
               else
                    al_box({"За "+mesqc(i)+" показания не записаны"})
               endif
            else
                    select 200
                    append blank
            endif
        next
        select 13
        Seek _kod
endif
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
if select()#200
        select 200
endif
colorwin(2,0,21,79,'w/b')
colorwin(5,0,21,79,'w/w')
set color to g+/b
name=alltrim('Предприятие '+main->potrebitel)
@ 2,(79-len(name))/2 say name
set color to w+/b
        name='Остаток за прошлый год: '+alltrim(str(dec_->pokazaniq))+if(dec_->drug_nach,'      За Дек.начислено по мощности','')
@ 3,(79-len(name))/2 say name
name= 'Г о д о в о й   с п р а в о ч н и к   с ч е т ч и к а '+licevoj2->schetchik
@ 4,(79-len(name))/2 say name
declare zgl[6]
declare fil[6]
nm1=loarr('zgl','Показан.','Разн.','Коэфф.','Расход','Субаб.','Тариф')
nm2=loarr('fil','pokazaniq','raznica','koeficient','rashod','subab','tarif')
inp='00000'
go top
set color to n/w
for i=1 to 12
        do case
                case month=1
                        @ 7+i,0 say 'Январь'
                case month=2
                        @ 7+i,0 say 'Февраль'
                case month=3
                        @ 7+i,0 say 'Март'
                case month=4
                        @ 7+i,0 say 'Апрель'
                case month=5
                        @ 7+i,0 say 'Май'
                case month=6
                        @ 7+i,0 say 'Июнь'
                case month=7
                        @ 7+i,0 say 'Июль'
                case month=8
                        @ 7+i,0 say 'Август'
                case month=9
                        @ 7+i,0 say 'Сентябрь'
                case month=10
                        @ 7+i,0 say 'Октябрь'
                case month=11
                        @ 7+i,0 say 'Ноябрь'
                case month=12
                        @ 7+i,0 say 'Декабрь'
        endcase
        set color to b/w
        @ 7+i,67 say str(summa,13,DECIMAL)
        set color to u/w
        skip
next
set color to n/w
go Top
//go month(new_date)-1
//ClearBuffer()
//Clear Typeahead
KeyBoard Replicate(Chr(K_DOWN),(month(new_date)-1))
//FsKeyboard:=replicate(KS_DOWN,(month(new_date)-1))
*************  Make box
t1=5   && Up
l1=6   && Left
b1=20  && Down
r1=67  && Right
*************  End make
@ 22,16 say Center(Licevoj2->UserInfo,40," ",.t.)
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
win_rest(buf)
if change
   IsRecalc=.T.
        if al_box({"В Н И М А Н И Е !","Данные в справочнике показаний счетчика",;
                   "были изменены. Сохранить изменения ?"},2,{" Сохранить ",;
                   " Не сохранять "},1,,,,,,"w+/b+,n/w,,,w/b+")=2
                      zap
        else

						oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
						aSizeDesktop  := oMainWindow:currentSize()
						oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
      			oDlg:title    := "Запись показаний счетчика" 
   					oDlg:SysMenu	 := .F.
   					oDlg:Configure()
      			oDlg:Show()
      			aSizeDesktop    := oDlg:currentSize()
      			aPos						:= oDlg:CurrentPos()
  					oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
   					oProgress:create()
   					oProgress:minimum := 1
   					oProgress:maximum := 12
//                obrabot("Запись показаний счетчика за год")
//                temp_=39/12
//                kol_kl=0
                go top
                for i=1 to 12
   	  							oProgress:increment()																				// Progress Bar Increment
//                    kol_kl=kol_kl+temp_
//                    colorwin(12,21,12,21+kol_kl,'n/n')
                    if .not.empty(recno)
                       select(i)
                       go all_mont->recno
                    else
                       select(i)
                       if netappend()
                          unlock
                       else
                           al_box({"За "+mesqc(i)+" показания не записаны"})
                           loop
                       endif
                    endif
                    if reclock()
                       replace kod with _kod
                       replace pokazaniq with all_mont->pokazaniq
                       replace pokoff with all_mont->pokoff
                       replace raznica with all_mont->raznica
                       replace koeficient with all_mont->koeficient
                       replace koeffoff with all_mont->koeffoff
                       replace rashod with all_mont->rashod
                       replace rashoff with all_mont->rashoff
                       replace tarif with all_mont->tarif
                       replace summa with all_mont->summa
                       replace percent with all_mont->percent
                       replace num_of_sch with licevoj2->schetchik
                       replace licevoj with licevoj2->lic_sch
                       replace subab with all_mont->subab
                       replace moshn with all_mont->moshn
                       replace IsLastMont with all_mont->IsLastMont
                       replace drug_nach with licevoj2->reaktivn
                       replace NewValue with All_Mont->NewValue
                       replace IsNewValue with All_Mont->IsNewValue
                       replace DaysHigh with All_Mont->DaysHigh
                       replace Info with All_Mont->Info
                       unlock
                    else
                           al_box({"За "+mesqc(i)+" показания не записаны"})
                    endif
                    select 200
                    skip
                next
   							oProgress:destroy()																							// Progress Bar Destroy
   							oDlg:Destroy()
        endif
endif
select(oldsel)
set color to (color_bu)
set order to ord_bu
go rec_bu
win_rest(buf)
EditField:=.F.
return
*********************************








STATIC procedure write_schet
Private KodC:={},KodN:={}
private screen,old_col,select,rec,_lic,found,_r_schet,_k_schet, _delo,_mfo,_bank,found
save screen to screen
old_col=setcolor()
***
*** SCHET : format file
*** Generated Апрел 13, 1993
***
sob(,'Поиск информации о счетчике "'+alltrim(schetchik)+'"')
select=select()
rec=recno()
_lic=main->lic_schet
found=.f.
if select()#77
        select 77
endif
seek lic_sch
if found().and..not.deleted()
        found=.t.
        _r_schet=r_schet
        _k_schet=k_schet
        _delo=delo
        _mfo=mfo
        _bank=bank
        _adres=adres
        _object1=object1
        _object2=object2
        _b=b
        _a=a
endif
select(select)
go rec
if reclock()
/*
   if found.and.empty(r_schet).and.empty(k_schet).and.empty(mfo)
        replace r_schet with _r_schet
        replace k_schet with _k_schet
        replace mfo with _mfo
        replace bank with _bank
        replace adres with _adres
        replace object1 with _object1
        replace object2 with _object2
        replace tip with 'СА4У-И672'
        replace mfo with '141044'
        replace b with _b
        replace a with _a
   endif
*/
   if alltrim(delo)!=alltrim(str(main->lic_schet))
      replace delo with alltrim(str(main->lic_schet))
   endif
   unlock
endif
set color to w+/b,gr+/b,,,w+/b
clear screen
@ 00,30 say "Лицевой счет N"
//@ 02,53 say "Дело N"
@ 01,00 say "Потребитель"
@ 02,00 say "K.счет"
@ 03,00 say "P.счет"
@ 04,00 say "МФО"
@ 04,72 say "банке"
@ 04,28 say "в"
@ 05,00 say "Субсчет"
@ 06,00 say "Наименование об`екта                    ┌───┬───┬────Трансформаторы тока───────┐"
@ 07,40 say "│Кл.│Пл.│N тран.│Ток   │Дата │ N счет. │"
@ 08,00 say "Адрес"+space(35)+"├───┼───┼───────┼──────┼─────┼─────────┤"
@ 09,00 say "Телефон"
@ 09,40 say "│   │   │       │      │     │         │"
@ 10,00 say "┌─────────┬───────┬──────────┐          └───┴───┴───────┴──────┴─────┴─────────┘"
@ 11,00 say "│Установл.│       │          │"
@ 12,00 say "│Мощность │Силовая│Освещение │"
//@ 14,37 say "Телефон"
@ 13,00 say "│  квт.   │       │          │"
@ 14,00 say "└─────────┴───────┴──────────┘ Инфо "
@ 15,00 say "┌───────────┬────────┬──────┬──────────┬──────────┬───────────┬─────────────┐"
@ 16,00 say "│    Тип    │  В     │  А   │N счетчика│Показание │Дата устан.│Год проверки │"
@ 17,00 say "├───────────┼────────┼──────┼──────────┼──────────┼───────────┼─────────────┤"
@ 18,00 say "│           │        │      │          │          │           │             │"
@ 19,00 say "└───────────┴────────┴──────┴──────────┴──────────┴───────────┴─────────────┘"
@ 20,00 say " Граница раздела "
@ 22,00 Say "Фидер"
@ 23,00 say  "Часов"
@ 23,20 say  "Дней"
load("76",SCHET_SHARE+"Fiders.dbf",Schet_Share+"FidersN.ntx",Schet_Share+"FidersC",.f.)
//load("76",SCHET_SHARE+"Fiders.dbf",,,.f.)
Go Top
Do While !EOF()
   IF KOD!=0
      AADD(KodC,FIDER)
      AADD(KodN,KOD)
   ENDIF
   Skip
ENDDO
Close
@ 24,0 say Space(78)
select(select)
set color to gr+/b
@ 18,30 say schetchik
@ 00,45 say lic_sch
@ 09,71 say schetchik
@ 01,12 say main->potrebitel
@ 22,07 Say Str(Kod,4,0)
GetFider(Kod,1)
//@ 02,60 say alltrim(str(main->lic_schet))
set color to g+*/b
@ 24,01 say chr(16)+' Esc-выход '+chr(17)
set color to gr+/b
@ 18,56 say data_ust
set color to w+/b,n/w,,,w+/b
IF M->Edit==.t.
   set cursor on
   set confir on
   if reclock()
     do while .t.
           @ 02,07 get k_schet picture '@k'
           @ 03,07 get r_schet picture '@k'
           @ 04,07 get mfo picture '@k'
           @ 04,30 get bank picture '@kS40'
           @ 05,10 get str2plat picture "@k"
           @ 06,21 get object1 picture '@k'
           @ 07,00 get object2 picture '@k'
           @ 08,06 get adres picture '@k'
           @ 09,09 get telefon picture '@k'
           @ 09,41 get kl picture '@k'
           @ 09,45 get pl picture '@k'
           @ 09,49 get transf picture '@k'
           @ 09,57 get tok picture '@k'
           @ 09,64 get data_ust picture '@k' valid dataus()
           @ 11,36 get Info1
           @ 12,36 get Info2
           @ 13,36 get Info3
           @ 14,36 get UserInfo
           @ 13,11 get silowaq picture '@k'
           @ 13,21 get oswesh picture '@k'
           @ 18,01 get tip picture '@k'
           @ 18,13 get b picture '@k'
           @ 18,22 get a picture '@k'
           @ 18,40 get pokazanie picture '@k'
           @ 18,66 get god_prow picture '@k'
           @ 20,18 get razdel_1 picture '@k'
           @ 21,18 get razdel_2 picture '@k'
           @ 22,07 Get Kod Valid GetFider(Kod,2)
					 @ 23,08 Get Hour picture "@K99"
					 @ 23,28 Get Day  picture "@K99"
           read
           if lastkey()=27
              Clear Typeahead
              exit
           endif
      enddo
      unlock
   else
        al_box({"Отказ блокировки"})
   endif
   set cursor off
   set confirm off
ELSE
   @ 02,07 say k_schet picture '@k';   @ 03,07 say r_schet picture '@k'
   @ 04,07 say mfo picture '@k';       @ 04,30 say bank picture '@k'
   @ 06,21 say object1 picture '@k';   @ 07,00 say object2 picture '@k'
   @ 08,06 say adres picture '@k';     @ 09,41 say kl picture '@k'
   @ 09,45 say pl picture '@k';        @ 09,49 say transf picture '@k'
   @ 09,57 say tok picture '@k';       @ 09,63 say data_ust picture '@k'
   @ 12,46 say telefon picture '@k';   @ 13,11 say silowaq picture '@k'
   @ 13,21 say oswesh picture '@k';    @ 18,01 say tip picture '@k'
   @ 18,11 say b picture '@k';         @ 18,20 say a picture '@k'
   @ 18,36 say pokazanie picture '@k'; @ 18,62 say god_prow picture '@k'
   @ 20,18 say razdel_1 picture '@k'
   @ 21,18 say razdel_2 picture '@k'
   @ 05,10 say str2plat picture "@k"
   inkey(0)
ENDIF
restore screen from screen
setcolor(old_col)
return


Function GetFider(tmpKOD,Action)
Local Is_Choice:={},Scr:=Win_Save(),Clr:=SetColor(),StartPos:=1
IF Action==2
   For I=1 To Len(KodC)
       AAdd(Is_Choice,.T.)
       IF KodN[i]==KOD
          StartPos:=I
       ENDIF
   Next
   PoType=vert_menu(KodC,"Фидер",is_choice,0,38,StartPos,'n/w,n/g,,,r/w',.T.)
   IF PoType>0
      Replace Kod With KodN[PoType]
   ENDIF
   IF LastKey()==27
      KeyBoard Chr(1)
      Inkey(0.5)
   ENDIF
//   Win_Rest(Scr)
ENDIF
IF Kod!=0
   For I=1 To Len(KodN)
       IF KodN[i]==KOD
          set color to gr+/b
          @ 22,15 say KodC[i]
          SetColor(Clr)
       ENDIF
   Next
ELSE
   @ 22,15 Say "Не указан"
ENDIF
Return .T.

function dataus()
if updated()
        set color to gr+/b
        @ 20,56 say ""+data_ust
        set color to w+/b,n/w,,,w+/b
endif
return .t.


proc po_moshnosty
Local color_buff,scr_buff,old_rec,_tarif,koef,pokaz,dney,po_sil,chasy,po_osv
Local Vid,Desc,CrLf:=Chr(13)+Chr(10)
Color_Buff=Setcolor()
Scr_Buff=SaveScreen(0,0,24,66)
Old_Rec=Recno()
IF !IsMonthLocked(Month)
   Vid:=Al_Box({"Произвести начисление по установленной мощности"},3,{" Начислить "," Бланк "," Выход "})
ELSE
   Vid:=Al_Box({"Произвести начисление по установленной мощности"},2,{" Бланк "," Выход "})
   Vid:=IF(Vid==1,2,3)
ENDIF
IF Vid==3
   Return
ENDIF
IF Licevoj2->Silowaq=0.AND.Licevoj2->Oswesh=0
        Al_Box({"Начислить по мощности невозможно",;
                " отсутствуют коэффициенты"})
ELSE
        Desc:=FOpen(DDir+ReportFile,2)
        FSeek(Desc,0,2)               // На конец файла
        Dney=IF(!Empty(Licevoj2->Day),Licevoj2->Day,lastdayom(all_mont->Month))
        Chasy:=IF(!empty(Licevoj2->hour),Licevoj2->hour,8)
        DaysHigh:=Dney
        IF Vid==1
           skip -1
           _tarif=TarFunc(tarif)
           koef=koeficient
           pokaz=pokazaniq
           go old_rec
           replace tarif with _tarif
           replace DaysHigh with Dney
           replace koeficient with koef
           replace pokazaniq with pokaz
        ENDIF
        set color to &GetColor
//        @ 11,17,13,61 box "         "
        colorwin(12,19,16,62,'n+/n')
        @ 11,18 say "┌─────────────────────────────────────────╖"
        @ 12,18 say "│ Тариф для начисления         :          ║"
        @ 13,18 say "│ Количество часов работы      :          ║"
        @ 14,18 say "│ Количество дней для расчета  :          ║"
        @ 15,18 say "╘═════════════════════════════════════════╝"
        set color to &GetColor
//        set color to +bg/b,w+/bg,,,+bg/b
        @ 12,51 get all_mont->tarif
        @ 13,51 get chasy picture "@K 999"
        @ 14,51 get DaysHigh Valid IF(DaysHigh<=LastDayOm(All_Mont->Month).and.DaysHigh>0,.T.,.F.)
        set conf on
        set curs on
        read
        Clear Typeahead
//        Dney:=IF(DaysHigh==0,LastDayOm(All_Mont->Month),DaysHigh)
        set conf off
        set curs off
        IF Vid==2
           FWrite(Desc,DelString(Main->potrebitel,"ИНН"))
           FWrite(Desc,AllTrim(Licevoj2->Object1+" "+Licevoj2->Object2)+CrLf)
           FWrite(Desc,AllTrim(Licevoj2->Adres)+" N сч. "+Licevoj2->Schetchik+CrLf)
           FWrite(Desc,"Начисление по установленной мощности за "+Mesqc(RecNo())+CrLf)
        ENDIF
        po_sil=licevoj2->silowaq*dney*if(chasy=0,1,chasy)
        IF Vid==2
           FWrite(Desc,"Количество дней в месяце "+AllTrim(Str(Dney))+CrLf)
           FWrite(Desc,"Силовая "+AllTrim(Str(licevoj2->silowaq))+CrLf)
           FWrite(Desc,"Количество часов работы "+AllTrim(Str(Chasy))+CrLf)
           FWrite(Desc,AllTrim(Str(Licevoj2->Silowaq))+"*"+AllTrim(Str(Dney))+"*"+AllTrim(Str(Chasy))+"="+AllTrim(Str(Po_Sil))+CrLf)
        ENDIF
        FWrite(Desc,"Освещение "+AllTrim(Str(Licevoj2->Oswesh))+CrLf)
        do case
                case all_mont->month=1
                        po_osv=licevoj2->oswesh*501
                case all_mont->month=2
                        po_osv=licevoj2->oswesh*476
                case all_mont->month=3
                        po_osv=licevoj2->oswesh*377
                case all_mont->month=4
                        po_osv=licevoj2->oswesh*265
                case all_mont->month=5
                        po_osv=licevoj2->oswesh*245
                case all_mont->month=6
                        po_osv=licevoj2->oswesh*201
                case all_mont->month=7
                        po_osv=licevoj2->oswesh*223
                case all_mont->month=8
                        po_osv=licevoj2->oswesh*279
                case all_mont->month=9
                        po_osv=licevoj2->oswesh*377
                case all_mont->month=10
                        po_osv=licevoj2->oswesh*420
                case all_mont->month=11
                        po_osv=licevoj2->oswesh*467
                case all_mont->month=12
                        po_osv=licevoj2->oswesh*521
        endcase
        IF Vid==2
           FWrite(Desc,"Коэффициент для "+Mesqc(RecNo(),.t.)+" "+AllTrim(Str(Po_Osv/Licevoj2->Oswesh))+CrLf)
           FWrite(Desc,AllTrim(Str(licevoj2->oswesh))+"*"+AllTrim(Str(Po_Osv/Licevoj2->Oswesh))+"="+AllTrim(Str(Po_Osv))+CrLf)
           FWrite(Desc,"Итого "+AllTrim(Str(Po_Sil))+"+"+AllTrim(Str(Po_Osv))+"="+AllTrim(Str(Round(po_osv+po_sil,0)))+CrLf)
           FWrite(Desc,"Тариф "+AllTrim(Str(Tarif))+CrLf)
           FWrite(Desc,"Всего "+AllTrim(Str(Round(Po_Sil+Po_Osv,0)))+"*"+AllTrim(Str(Tarif))+"="+AllTrim(Str(Round(Round(Po_Sil+Po_Osv,0)*Tarif,Decimal)))+CrLf)
           FWrite(Desc,"--------------------------------------------------------"+CrLf+CrLf)
        ENDIF
        IF LastKey()!=27
          IF Vid==1
           change=.t.
           replace rashod with round(po_osv+po_sil,DECIMAL)
           replace summa with round(rashod*tarif,DECIMAL)
           Replace IsLastMont With .T.
           Replace Moshn With .F.
           @ row,67 say str(all_mont->summa,13,DECIMAL)
          ENDIF
        ENDIF
endif
IF Vid==2
   FClose(Desc)
ENDIF
GO Old_Rec
SetColor(Color_Buff)
RestScreen(0,0,24,66,Scr_Buff)
IF IsLastMont
   @ 21,5 Say "Начислено по мощности"
   Colorwin(21,5,21,5+len('Начислено по мощности'),'n*/w')
   SET Color To gr+/w+
ENDIF
RETURN



***************** Начисление по расходу прошлого месяца ***********************
proc poproshlomy
private old,pokaz,razni,koefi,tari_,summa_
old=setcolor()
if recno()>1
        change=.t.
        skip -1
        pokaz=pokazaniq
        razni=raznica
        koefi=koeficient
        tari_=tarif
        skip
        replace raznica with razni
        replace koeficient with koefi
        IF Len(AllTrim(Licevoj2->Pokazanie))<Len(AllTrim(Str(Round(pokaz+razni,0))))
           Replace Pokazaniq With (pokaz+razni)-Val(Replicate("9",Len(AllTrim(Licevoj2->Pokazanie))))
        ELSE
           replace pokazaniq with pokaz+razni
         ENDIF
        replace rashod with if(koeficient#0,koeficient*raznica,raznica)
        replace tarif with tarfunc(tari_)
        replace moshn with .t.
        summa_=round(rashod*tarif,DECIMAL)
        replace summa with Round(summa_,DECIMAL)
        set color to gr+/w
        @ row,66 say replicate(' ',14)
        @ row,66 say str(summa,14,DECIMAL)
        keyboard chr(29)+chr(24)
else
        old_s=select()
        _kod='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
        select 13
        seek _kod
        if found()
                change=.t.
                pokaz=pokazaniq
                razni=raznica
                koefi=koeficient
                tari_=tarif
                select(old_s)
                replace pokazaniq with pokaz+razni
                replace raznica with razni
                replace koeficient with koefi
                replace rashod with if(koeficient#0,koeficient*raznica,raznica)
                replace tarif with tarfunc(tari_)
                replace moshn with .t.
                Replace IsLastMont With .F.
                summa_=round(rashod*tarif,DECIMAL)
                replace summa with Round(summa_,DECIMAL)
                set color to gr+/w
                @ row,66 say replicate(' ',14)
                @ row,66 say str(summa,14,DECIMAL)
*       keyboard chr(29)+chr(24)
        else
                select(old_s)
                al_box({"Расход Декабря месяца неизвестен"})
        endif
endif
if moshn
   @ 21,5 say "Начислено по прошлому"
   colorwin(21,5,21,5+len('Начислено по прошлому'),'n*/w')
endif
setcolor(old)
return
********************** Конец процедуры начисления ***************************




Function LYOstatok()
Local Old_Color:=SetColor(),OldScr:=Win_Save(),LYea:=-1,String:=""
Local Sel:=Select(),TypeNewValue:=2,Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
IF RecNo()==1
   Spisok:={" Прошлый год "," Месяц "," Снятие счетчика      "}
   Is_Choice:={.t.,.t.,.t.}
   TypeNewValue=vert_menu(spisok,"Уточнение показаний",is_choice,9,48,1,'n/w,n/g,,,r/w',.F.)
//   TypeNewValue:=AL_Box({"Какие показания хотите уточнить"},3,{" Прошлый год "," Месяц "," Отказ"})
   DO Case
      Case TypeNewValue==1
           Lyea=dec_->pokazaniq
           String:="Введите показания за прошлый год"
      Case TypeNewValue==2
           Lyea=NewValue
           String:="Начальные расчетные показания"
   ENDCASE
ELSE
   Spisok:={" Месяц "," Снятие счетчика             "}
   Is_Choice:={.t.,.t.,.t.}
   TypeNewValue=vert_menu(spisok,"Уточнение показаний",is_choice,Row()+1,20,1,'n/w,n/g,,,r/w',.F.)
   TypeNewValue:=IF(TypeNewValue!=0,TypeNewValue+1,TypeNewValue)
   Lyea=NewValue
   String:="Начальные расчетные показания"
ENDIF
IF TypeNewValue==0
   Win_Rest(OldScr)
   Return NIL
ENDIF
IsRecalc=.T.
IF TypeNewValue<3
   LYea:=GetVal(String,LYea,-99999)
ENDIF
IF TypeNewValue==3
   Replace KoeffOff With Koeficient
   Set Color To &GetColor
   ColorWin(10,21,13,56,"n+/n")
   @ 09,20 SAY "┌─────────────────────────────────╖"
   @ 10,20 SAY "│ Показания при снятии            ║"
   @ 11,20 SAY "│ Расчетный коэффициент           ║"
   @ 12,20 SAY "╘═════════════════════════════════╝"
   Set Cursor On
   Set Confirm On

   Do While .T.
      @ 10,45 GET POKOFF
      @ 11,45 GET KOEFFOFF
      Read
      IF LastKey()==27
         Clear Typeahead
         Exit
      EndIf
   EndDo
   Set Cursor Off
   Set Confirm Off

ENDIF
Win_Rest(OldScr)
IF LYea!=-99999.and.TypeNewValue!=3
   @ 21,5 say "Показания "+Str(NewValue)+" "
   ColorWin(21,5,21,21,'n*/w')
   change=.T.
   Ret_Val:=2
   Prev_Rec:=0
   DO Case
      Case TypeNewValue==1
           select licevoj
           if reclock()
              replace last_year with lyea
              unlock
           endif
           SELECT 13
           SEEK Poisk
           IF Found()
              IF Reclock()
                 Replace Pokazaniq With LYea
                 Unlock
              ENDIF
           ENDIF
           select 200
           Commit
      CASE TypeNewValue==2
          if reclock()
             replace NewValue with lyea
             Replace IsNewValue With IF(LYea>=0,.T.,.F.)
             Replace Info With " "
             unlock
          endif
   ENDCASE
ENDIF
Select(Sel)
setcolor(old_color)
Return NIL


Function IsMonthLocked(MonthCheck)
Local IsLock:=.F.
IF Asc(Substr(Main->LockMonth,MonthCheck,1))==MonthCheck
   IsLock:=.T.
ENDIF
Return IsLock


Function SayLoseStatus()
Local Sel:=Select(),Rec:=RecNo(),MyStat:=""
_Kode='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
Select Lose
Seek _Kode
IF Found()
   MyStat:="П"
ENDIF
_Kode='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
Select LoseTran
Seek _Kode
IF Found()
   MyStat:=MyStat+"Т"
ENDIF
MyStat:=MyStat+Space(2-Len(MyStat))
Select(Sel)
Go Rec
Return MyStat





/*
save screen
private old_color
old_color=setcolor()
private color_buf
colorwin(8,21,10,66,'n+/n')
@ 07,20 say "┌───────────────────────────────────────────╖"
@ 08,20 say "│   Введите остаток за прошлый год:         ║"
@ 09,20 say "╘═══════════════════════════════════════════╝"
set color to n/w
lastyear=licevoj->last_year
set cursor on
@ 08,57 get lastyear picture '999999'
read
Clear Typeahead
lyea:=lastyear
if lastkey()#27
   select licevoj
   if reclock()
      replace last_year with lyea
      unlock
   endif
   Poisk:="("+alltrim(str(Main->Lic_Schet))+")"+Alltrim(Licevoj2->Schetchik)
   SELECT 13
   SEEK Poisk
   IF Found()
      IF Reclock()
         Replace Pokazaniq With LYea
         Unlock
      ENDIF
   ENDIF
   select 200
   Commit
else
        clear typeahead
endif
set cursor off
restore screen
*/
