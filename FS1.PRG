#include "inkey.ch"
#include "appevent.ch"
STATIC SaySemafore:=.T.
STATIC DBEditScr:=""
******
* mode - режим
* f_script - индекс
******
func XSBROWSE
local Msel,Poisk,PreviousData,bStr
Parameters Mode, F_Script
PRIVATE ret_val,codefound,col,row,i,sb,scb,mkdoc,mkkl,tk8,tk9,b,c,mtn
PRIVATE old_col:=setcolor(),go_out,a,kod_otrasli,fi,data,line,aa,old_col1
PRIVATE _koef,_tarif
col=COL()
row=ROW()
//@ MaxRow(),20 Say Str(Memory()/1024,4,0)
IF Select()==188
   bStr:=""
   For i=1 to len(BitStr)
       IF Bit_Test(BitStr,i)
          bStr:=bStr+"1"
       ELSE
          bStr:=bStr+"0"
       ENDIF
   Next
   @ 2,0 Say bStr
   ColorWin(2,0,2,11,"W+/b")
ENDIF
do case
   case select()=43
        ShowPlomba()
   case select()=15
        old_col=setcolor()
        set color to w+/g
        colorwin(9,5,9,5+len(' Прошлый год  Дебет '+alltrim(str(obormot->last_debet))+' Кредит '+alltrim(str(obormot->last_kred))+' '),'n+/n')
        @ 8,4 say ' Прошлый год  Дебет '+alltrim(str(obormot->last_debet))+' Кредит '+alltrim(str(obormot->last_kred))+' '
        setcolor(old_col)
   case select()=77.or.select()=78
        @ 5,0 say Reaktivn
        @ 8,2 say center(SayPlombaNumber(),25," ",.t.)
        @ 8,55 say center(SayLoseStatus(),2," ",.t.)
        if .not.reaktivn
           @ 8,60 say " Активный "
        else
           @ 8,60 say "Реактивный"
        endif
        colorwin(8,60,8,70,'r+/bg')
        colorwin(8,55,8,57,'r/bg')
   Case Select()==41
        IF .not.Reaktivn
            @ 8,67 say " Активный "
        ELSE
            @ 8,67 say "Реактивный"
        ENDIF
        colorwin(8,67,8,76,'r+/bg')
endcase
*  нормальный возврат
ret_val = 1
* coхpанить последнюю клавишу
keystroke = LASTKEY()
//@ 23,0 say Keystroke
//inkey(0)
*  имя поля в пеpеменную
e_field = &field_list[M->f_script]
IF M->prev_rec <> RECNO()
   * указатель записи был пеpеслан
   Prev_Rec = RECNO()
   Force_Rec = .T.
   IF SaySemafore
      IF File(Schet_Share+"Semafore.smf")
         Al_Box({"Обнаружены новые формы документов","для их активизации произведите копирование форм"})
         SaySemafore:=.F.
      ENDIF
   ENDIF
   IF Select()=77.OR.Select()=78
        @ 8,2 SAY Center(SayPlombaNumber(),25," ",.t.)
   ENDIF
   IF Select()==88
      NamePotrebitel:=AllTrim(DelString(Main->Potrebitel,"ИНН"))
      InnPotrebitel:=alltrim(substr(appendstring(Main->potrebitel,"ИНН"),4,11))
//      Al_Box({InnPotrebitel})
   ENDIF
   IF Select()=101
      IF FoundBlankOut()
         Set Color to w+/bg
         @ 22,17 say DTOC(OutBlank->Date)+" "+AllTrim(OutBlank->User)
         SetColor(Old_Col)
      ELSE
         @ 22,17 say Replicate("═",30)
      ENDIF
   ENDIF
   if select()=200
      IF PokOff!=0
         @ 21,30 say "Показания "+Str(PokOff,6,0)+" Коэф. "+Str(KoeffOff,5,0)+" Расход "+Str(RashOff,9,0)
      ELSE
         @ 21,30 say space(Len("Показания "+Str(PokOff,6,0)+" Коэф. "+Str(KoeffOff,5,0)+" Расход "+Str(RashOff,9,0)))
      EndIf
      colorwin(21,30,21,76,'n/w')
      DO CASE
         CASE IsNewValue==.T.
              @ 21,5 say "Показания "+Str(NewValue)+"     "
              colorwin(21,5,21,26,'n/w')
         CASE IsLastMont
              @ 21,5 say "Начислено по мощности   "
              colorwin(21,5,21,5+len('Начислено по мощности   '),'n*/w')
         CASE Moshn
              @ 21,5 say "Начислено по прошлому"
              colorwin(21,5,21,5+len('Начислено по прошлому'),'n*/w')
         OTHERWISE
              @ 21,5 say Space(Len('Начислено по прошлому      '))
              Colorwin(21,5,21,5+len('Начислено по прошлому      '),'w/w')
      ENDCASE
   endif
   if select()=55
      IF Kod_Otr!=main->kod_otr.and.kod_otr!=main->lim_tar1.and.kod_otr!=main->lim_tar2
         @ 2,0 say "             Выберите  отрасль  производства  данного  предприятия           "
         colorwin(2,0,2,79,'gr+/b')
      ELSE
        @ 2,0 say "            Курсор  указывает на отрасль производства данного предприятия     "
        colorwin(2,0,2,79,'w+/b')
      ENDIF
   endif
   if select()=66
      @ 23,50 say "═════════════════════"
      @ 23,50 say "Итого :"+alltrim(str(itogo,14,2))
   endif
   if select()=88
      select licevoj
      seek main->lic_schet
      select main
      clr:=setcolor()
      set color to w+/b
      @ 4,0 say space(80)
      @ 3,0 say space(80)
      @ 1,0 say space(80)
      @ 2,0 say space(80)
      @ 4,0 say licevoj->bank
      @ 5,0 say space(80)
      if main->lim_tar1#0
         @ 5,1 say alltrim(secondname)+" Бюджетная организация"+if(kategory==chr(1),"  ▓▒░ Абон.Мощн. ░▒▓","")
      else
         @ 5,1 say alltrim(secondname)+if(kategory==chr(1),"  ▓▒░ Абон.Мощн. ░▒▓","")
      endif
      IF Main->Lic_Schet>99999
         Select FNSI
         Seek Main->Lic_Schet
         Select FKODS
         Seek FNSI->KUL
         IF Found()
            @ 5,1 Say AllTrim(FKODS->Nul)+" "+AllTrim(FNSI->Dm)+;
                      IF(!Empty(AllTrim(FNSI->Kv))," кв "+FNSI->Kv,"")
         ENDIF
         SELECT Main
      ENDIF
      IF Year(New_date)-Year(Data_Dog)>2
         Set Color to r+/b
         @ 3,0 say "Необходимо перезаключение договора"
         Set Color to w+/b
      ENDIF
      setcolor(clr)
      if main->lic_schet#0
         select 33
         seek main->lic_schet
         if !found()
            if netappend()
               replace lic_schet with main->lic_schet
               unlock
            endif
         endif
      endif
      select 88
      old_col=setcolor()
      select 15
      seek main->lic_schet

      if .not.found()
         set color to n/bg
         @ maxrow()-1,2 say replicate('═',40)
         setcolor(old_col)
         if .not.is_append
            if netappend()
               replace lic_schet with main->lic_schet
               unlock
            endif
         endif
         select 88
      else
         set color to n/bg
         @ maxrow()-1,2 say replicate('═',40)
         select 88
         debet_='debet'+alltrim(str(month(New_date)))
         kredit_='kredit'+alltrim(str(month(New_date)))
         if empty(obormot->&debet_).and.empty(obormot->&kredit_)
            set color to n/bg
            @ maxrow()-1,2 say replicate('═',40)
            set color to g+/bg
            @ maxrow()-1,2 say 'Дебет 0  Кредит 0'
            setcolor(old_col)
         else
            set color to g+/bg
            if empty(obormot->&debet_)
               @ maxrow()-1,2 say "Кредит "+str(obormot->&kredit_)
            else
               @ maxrow()-1,2 say "Дебет "+str(obormot->&debet_)
            endif
         endif
      endif
      if .not.empty(main->lic_schet)
         select 99
         seek main->lic_schet
         if .not.found()
            if netappend()
               replace licevoj with main->lic_schet
               unlock
            endif
         endif
         select 88
      endif
      setcolor(old_col)
   endif
   IF Select()=88
      ShowPotrInfo(.F.)
   ENDIF
ENDIF

DO CASE
   CASE M->mode = 1
        * начало файла
        IF M->is_append
           * no more append mode..refresh if any new records
           ret_val =  2
           is_append = .F.
           any_append = .F.
        ENDIF
        force_rec = .T.
   CASE M->mode = 2 .and.select()#200.and.select()#15.and.select()#33.and.;
        select()#222.and.select()#99.and.edit.and.select()#43.and.Select()#76;
        .and.if(select()=88,if(empty(dbfilter()),.t.,.f.),.t.)
        *  конец файла
        IF M->is_append
           *  pеж. добавить активен
           IF M->keystroke = 24 .AND. .NOT. EOF()
               * down arrow...do it again
               ret_val = 3
           ELSE
              IF M->keystroke = 30
                 * ^PgDn..no more append mode..refresh if any new records
                 ret_val = IF(M->any_append, 2, 3)
                 is_append = .F.
                 any_append = .F.
              ENDIF
           ENDIF
        ELSE
           IF M->keystroke = 24
              * enter append mode
              ret_val = 3
              is_append = .T.
           ENDIF
        ENDIF
        force_rec = .T.
   CASE M->mode = 3
           * file is empty
           IF M->keystroke = 24
              * enter append mode
              ret_val = 3
              is_append = .T.
              force_rec = .T.
           ENDIF
   CASE M->mode = 4
                * keystroke exception
        DO CASE
           CASE type(e_field)='C'
                colorwin(row,col,row,col+len(&e_field)-1,'w/b')
           CASE type(e_field)='N'
                colorwin(row,col,row,col+len(STR(&e_field))-1,'w/b')
           CASE type(e_field)='D'
                colorwin(row,col,row,col+Len(DtoC(New_date))-1,'w/b')
        ENDCASE
//        @ 1,0 Say " "+Str(M->KeyStroke)+"   "
        DO CASE
                case m->keystroke = 404.and.select()=88.and..not.is_append.and.edit
                     ShowPotrInfo(.T.)

                case m->keystroke = K_TAB.and.select()=88.and..not.is_append.and.edit
                        if al_box({'Изменить номер лицевого счета'},2)==1
                                lic_replace()
                        endif

                CASE M->keystroke = K_INS.and.edit.and.select()#200
                     DO CASE
                        Case Select()=43.and..not.is_append
                             InstallPlomba()
                        Case Select()=76.and..not.is_append
                             AppendFider()
                        Otherwise
                             IF Al_Box({"Добавить новую запись"},2)=1
                                Is_Append=.T.
                                DbAppend()
                                   DO CASE
                                      Case Select()==44
                                           IF Reclock()
                                              Replace Licevoj With Main->Lic_Schet
                                              UNLOCK
                                           ENDIF
                                      Case Select()==34
                                           IF Reclock()
                                              Replace Licevoj With Main->Lic_Schet
                                              UNLOCK
                                           ENDIF
                                      Case Select()==75
                                           IF Reclock()
                                              Replace Kod With Fiders->KOD
                                              UNLOCK
                                           ENDIF
                                   ENDCASE
                                go recno()
                                ret_val=2
                             ENDIF
                     ENDCASE

                CASE M->keystroke = 1.and.edit.and..not.is_append
                     DO Case
                        Case Select()==43
                             ShowPlomba(3)
                     ENDCASE

                CASE M->keystroke = K_SH_F11.and.edit.and..not.is_append
                		 ServMenu()


                CASE M->keystroke = 254.and.edit.and..not.is_append
                     DO Case
                        Case Select()==43
                             ShowPlomba(3)
                        Case Select()==200
                             EditField:=.T.
                     ENDCASE

                CASE M->keystroke = K_DEL.and.select()=43.and.edit.and..not.is_append
                     RemovePlomba()

                CASE M->keystroke = K_ALT_F3.and.select()=88.and.edit.and..not.is_append
                        secondname()

                CASE M->keystroke = K_CTRL_F5.and.select()=88.and.edit.and..not.is_append
                        do noonlimit

                CASE M->keystroke = K_SH_F5.and.select()=88.and..not.is_append
                        highmenu()

                CASE M->keystroke = K_SH_F6.and.select()=88.and..not.is_append
                     Limit2()
//                        do limitpercent

                CASE M->keystroke = K_CTRL_F6.and.select()=88.and..not.is_append
                        SetAttribute()

                CASE M->keystroke = K_ALT_F6.and.select()=88.and..not.is_append
                        ShowFiders()

                case m->keystroke = K_CTRL_F2.and.select()=88.and..not.is_append
//                        do inna_otchet

                case m->keystroke = K_SH_F7.and.select()=88.and..not.is_append

                case m->keystroke = K_CTRL_F1.and.select()=88.and..not.is_append
                     OtherTarif()
//                        menupokaz()

                case m->keystroke = K_ALT_F12.and..not.is_append
                     Calculator()

                case m->keystroke = K_SH_F12.and..not.is_append
                     AdmFunction()

                case m->keystroke = K_CTRL_F12.and.select()=88.and..not.is_append
                        win:=win_save()
                        if al_box({"Пересчитать сальдо этому потребителю на "+dtoc(New_date)},2)==1
                                mon_the=month(New_date)
                                do outex with month(New_date)
                                al_box({"Cальдо пересчитано"})
                                M->prev_rec=M->prev_rec+10
                                M->ret_val=2
                        end

                case m->keystroke = K_F1.and..not.is_append
                        do case
                                case select()=88
                                     main_help(1)
                                Case Select()==20
                                     IF RecLock()
                                        Replace Prefix With EditContens(Prefix)
                                     ENDIF
                                Otherwise
                                     @ 23,0 say PostAppEvent(xbeK_RIGHT)
//                                     TbApplyKey(oTBrowse,4)
//                                     Keyboard Chr(4)
//                                SetLastKey(KeyStroke)
                        endcase

                case m->keystroke = K_CTRL_F10.and..not.is_append.and.select()=88
                     Blank()
//                     limits()

                case m->keystroke = K_ALT_F10.and..not.is_append.and.select()=88
                     txtdebkr()

                case m->keystroke = K_SH_F10.and..not.is_append.and.select()=88
                     NaryadPredp()

                case m->keystroke = K_F10.and..not.is_append
                        do case
                                case select()=88
                                        do tarif_nds
                        endcase


                case m->keystroke = K_SH_F1.and.select()=88.and..not.is_append
                        do zamena_tarifov

                case m->keystroke = -41.and.select()=88.and..not.is_append
                        do oplata_otchet

                case m->keystroke = K_ALT_F2.and.select()=88
//                        ctvzpe()

                CASE M->keystroke = K_ESC
                        if select()=44
                                set filter to
                                go top
                        endif
                        ret_val = 0

                CASE M->keystroke = K_ALT_F8.and..not.is_append
                     DO CASE
                        CASE select()=18.or.Select()=19
                             IF Al_Box({"Удалить все записи в книге за месяц"},2)==1
                                Alt_F8()
                             ENDIF
                        CASE select()=88
                             Kod_Bank()
                        CASE select()=77.or.select()=78
                             IF IsCorrect("Удаление счетчика N"+Alltrim(Schetchik))
                                alt_f8()
                             ELSE
                                Al_Box({"В удалении отказано"})
                             ENDIF
                     ENDCASE


                CASE M->keystroke = K_CTRL_F3.and.select()=88.and..not.is_append
                     tipplatbank()

                CASE M->keystroke = K_SH_F2.and.select()=88.and..not.is_append

                CASE M->keystroke = K_SH_F3.and.select()=88.and..not.is_append.and.Select()==88
                     SetBitAtribute()
//                     WorkWithSchet()

                CASE select()=88.and.f_script=7 &&.and.lastkey()=4
                        if edit
                                aa=&e_field
                                do otrasl
                                if aa#&e_field
                                        keyboard chr(29)+chr(24)
                                endif
                        endif

                CASE M->keystroke = K_TAB.and..not.is_append.and.edit.and.select()=15
                             do debkred

                CASE M->keystroke = K_ALT_ENTER.and..not.is_append.and.edit
                      DO CASE
                        case select()=15
                             do debkred
                        case select()=88
                             nachisl()
                     endcase

                CASE M->keystroke = K_CTRL_ENTER.and..not.is_append
                        DO CASE
                           Case Select()=75
                                FiderSchPok()
                           Case Select()=76
                                FiderSchetchik()
                           Case Select()=40
                                 CountEnergy()
                           CASE Select()=200.AND.Edit.And.PlombaIsOut==.F..And.!IsMonthLocked(Month)
                                if al_box({"Вы действительно хотите ввести сумму вручную"},2)=1
                                   Tmp_Sum:=GetVal("Введите сумму : ",Summa,-999)
                                   IF Tmp_Sum!=-999
                                      Change=.T.
                                      Replace Summa With Tmp_Sum
                                   ENDIF
                                endif
                           CASE Select()=55.AND.Edit
                                   colorwin(2,0,2,79,'n/n')
                                   replace_otrasl()
                                   keyboard chr(27)

                           CASE Select()=88
                                   IF MainOrder==2
                                      MainOrder:=1
                                      Set Order To MainOrder
                                      Go RecNo()
                                      Ret_val:=2
                                   ENDIF
                                   urov=urov+1
                                   ew=recno()
                                   schet=lic_schet
                                   sele 77
                                   set index to (schet_Share+"lic_sch.ntx")
                                   seek schet
                                   found=found()
                                   do licevoj
                                   Select Main
//                                   select 88
//                                   set index to (Schet_share+"lic.ntx"),(Schet_share+"potrebit.ntx")
                                   go ew
                                   urov=urov-1

                           CASE Select()=77.Or.Select()=78
                                   DO Raschet
//                                   IF Edit
//                                      Commit
//                                      DO Outex WITH Month(New_date)
//                                   ENDIF
                           CASE Select()=20.and..not.is_append
                                Title[1]:=Prefix
                                Title[2]:=Suffix
                                Ret_Val:=0
                        ENDCASE


                CASE M->keystroke = K_ALT_F1 .AND. LASTREC() <> 0.and.select()=88
                        IF AL_BOX({"Освободить все занятые блокировки"},2)==1
                           UNLOCK ALL
                           GO RECNO()
                           sound(878,15)
                        ENDIF
//                        do plan_plus

                CASE M->keystroke = K_SH_F8.AND.LASTREC()<>0.and.select()=88.and.edit
                     ShiftF8()

                CASE M->keystroke = K_CTRL_F8 .AND. LASTREC() <> 0.and.edit
                                CTRLF8()

                CASE M->keystroke = -40.AND.LASTREC()<>0.and.select()=88
                                do f11

                CASE M->keystroke = K_F8 .AND. .NOT. EOF() .AND. LASTREC() <> 0.and. select()#200.and.select()#15;
                .and.select()#33.and.select()#222.and.select()#99;
                .and.select()#48.and..not.is_append
                       if .not.edit
                          al_box({"Корректировки невозможны"})
                       else
                          if select()=55
                             Myerror("   Внимание !  Данные удалить невозможно   !!!  ")
                          else
                             IF Select()!=66
                                IF IsCorrect("Удаление")
                                   F8()
                                   if select()=44.or.Select()==45
                                      change=.t.
                                   endif
                                ELSE
                                   Al_Box({"В удалении отказано"})
                                ENDIF
                             ELSE
                                if select()=66
                                   rec=recno()
                                   go RecNo()
                                   go top
                                   itogo:=0
                                   do while !eof()
                                      itogo=itogo+summa
                                      skip
                                   enddo
                                   go rec
                                endif
                             ENDIF
                          endif
                       endif

                CASE  M->keystroke = K_F5 .AND. LASTREC()<>0.and.;
                (select()=88.or.select()=66.or.select()=200.or.;
                select()=101)
                   do case
                         case select()=88.and..not.is_append
                              old_sel=select()
                              Obormot()
                              select(old_sel)
                         case Select()=101.and..not.is_append
                             BlankToOtchet()
                        case select()=66
                             do reestr
                        case select()=200.and.edit.and..not.is_append
                             IF PlombaIsOut==.F.
                                do po_moshnosty
                             ELSE
                                IF Al_Box({" Пломба с расчетного счетчика снята"},2,{" OK "," Начислить "})==2
                                   do po_moshnosty
                                ENDIF
                             ENDIF
                   end

                CASE  M->keystroke = K_F2 .AND. LASTREC()<>0
                do case
                   Case Select()=40.and.(.not.is_append)
                        EnergyMenu()
                   Case Select()=101.and.(.not.is_append)
                        IF RecLock()
                           Replace BlankText With EditContens(BlankText,BlankName,23)
                           UNLOCK
                        ENDIF
                        Devout("")
                   case select()=88.and.(.not.is_append)
                        menuonmain()
                   case select()=66
                        do print
                   case select()=19.and.(.not.is_append)
                   			ReportBookSale()
                   case select()=18.and.(.not.is_append)
                        IF Al_Box({"Тип формируемого документа"},2,{"Счет - Фактура","Книга продаж"})==1
                        	IF SFKNIGA->TYPE==3
                        		 SFAvans()
                        	ELSE
                           	 BookPaySchet()
                          ENDIF
                        ELSE
                           makeknigasf()
                        ENDIF
                   Case Select()==20.and.(.not.is_append)
                        If Reclock()
                           Replace Suffix with EditContens(Suffix)
                        Endif
                endcase

                CASE  M->keystroke = K_CTRL_F7 .AND. LASTREC()<>0.and.;
                select()=88.and..not.is_append

                CASE  M->keystroke = K_ALT_F7 .AND. LASTREC()<>0.and.;
                select()=88.and..not.is_append

                CASE  M->keystroke = K_F7 .AND. LASTREC()<>0.and.;
                (select()=88.or.select()=200).and..not.is_append
                        if select()=88
                                ChoiceOplata()
                                prev_rec=prev_rec-1
                        else
                                if !IsMonthLocked(Month).And.Al_Box({'Произвести начисление по расходу прошлого месяца'},2)==1
                                   IF PlombaIsOut==.F.
                                      do poproshlomy
                                   ELSE
                                      IF Al_Box({" Пломба с расчетного счетчика снята"},2,{" OK "," Начислить "})==2
                                         do poproshlomy
                                      ENDIF
                                   ENDIF
                                endif
                        endif

                CASE  M->keystroke = K_F3 .AND. LASTREC()<>0.and.;
                .not.is_append
                      DO Case
                         Case Select()==88
                              do otrasl
                         Case Select()==40
                              NameFiders()
                      ENDCASE


                CASE M->keystroke = K_ALT_F9 .and. lastrec()#0
                		 Do Case
                		 		Case select()=88
                         		 ViewProdag(2)
                     ENDCASE

                CASE M->keystroke = K_F9 .and. lastrec()#0
                		 Do Case
                		 		Case select()=88
                         		 viewprodag(1)
                        Case Select()=101.and..not.is_append
                             AllBlankToOtchet()
                     ENDCASE

//                                do penq

                CASE M->keystroke = K_F6 .AND. LASTREC()<>0
                        do case
                           Case Select()=41.and..not.is_append
                                IF .not.Reaktivn
                                   IF RecLock()
                                      Replace Reaktivn With .T.
                                   ENDIF
                                ELSE
                                   IF RecLock()
                                      Replace Reaktivn With .F.
                                   ENDIF
                                ENDIF
                                IF .not.Reaktivn
                                    @ 8,67 say " Активный "
                                ELSE
                                    @ 8,67 say "Реактивный"
                                ENDIF
                                colorwin(8,67,8,76,'r+/bg')
                           case select()=77.or.select()=78.and.edit.and..not.is_append
                                ClearBuffer()
                                DO Case
                                   Case .not.Reaktivn
                                        replace reaktivn with .Y.
                                        @ 8,60 say "Реактивный"
                                   Case Reaktivn
                                        replace reaktivn with .N.
                                        @ 8,60 say " Активный "
                                ENDCASE
                                for jj=1 to 12
                                    select(jj)
                                    poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj2->schetchik)
                                    seek poisk
                                    if found()
                                       IF Reclock()
                                          replace drug_nach with Licevoj2->Reaktivn
                                          unlock
                                       ENDIF
                                    endif
                                next
                                select 78
                                colorwin(8,60,8,70,'r+/bg')

                           case select()=66.and.edit
                                do nastroYka

                           case select()=88.and..not.is_append
                                do limit

                           case select()=200.And.Edit.And.PlombaIsOut==.F..And.!IsMonthLocked(Month).and..not.is_append
                                LYOstatok()
                        endcase


                CASE M->keystroke = K_F5 .AND. LASTREC()<>0;
                .and.select()=33
                        limit_raschet()


                CASE M->keystroke = K_F4 .AND. LASTREC()<>0;
                .and.select()#15.and.select()#33.and.select()#200
                         SEARCH()

                CASE M->keystroke=K_ALT_F4.and.lastrec()<>0.and.select()=88
//                         search_()
                         All_search()


                CASE M->keystroke=K_CTRL_F4.and.lastrec()<>0.and.select()=88
                         PotrebitelSearch()

                CASE M->keystroke=K_SH_F4.and.lastrec()<>0.and.select()=88
                     BigSearch()

                CASE M->keystroke=254.and.select()=200
                     PlombaIsOut=IF(PlombaIsOut==.T.,.F.,.T.)


                CASE M->keystroke=K_CTRL_F4.and.lastrec()<>0.and.select()=88
//                         viewprodag(1)
//                         viewprodag(2)


//                (M->is_append .OR. (.NOT. EOF() .AND. LASTREC() <> 0)).and.;
//                edit.and.select()#222.and.if(select()#77,.t.,if(empty(&e_field),.t.,.f.)).and.;
//                CASE (M->keystroke=K_ENTER.OR.ISDATA(keystroke))
//                     @ 1,0 say select()
//                     inkey(0)

                CASE (M->keystroke=K_ENTER.OR.ISDATA(keystroke)).AND.;
                (M->is_append .OR. (.NOT. EOF() .AND. LASTREC() <> 0));
                .and.select()#222.and.if(select()#77,.t.,if(empty(&e_field),.t.,.f.)).and.;
                if(select()#88,.t.,if(f_script=1,if(empty(&e_field),.t.,.f.),.t.)) .and.;
                select()#15.and.select()#43.and.IsEditField()
                //.and.Select()#33
                        ntx_expr = INDEXKEY(0)
                        IF .NOT. EMPTY(M->ntx_expr)
                                ntx_eval = &ntx_expr
                        ENDIF
                        IF keystroke<>13
                                KEYBOARD CHR(keystroke)
                        ENDIF
                        SET CURSOR ON
                        SET CONF ON
                        get_data = &e_field
                        readexit(.t.)
                        color=setcolor()
                        set color to n/bg,w+/r
                        IF Reclock()
                           IF e_field!='substr(potrebitel,1,55)'
                              @ ROW,COL GET get_data VALID PREDV(f_script,get_data)
                           ELSE
                              get_data:=Potrebitel
                              @ ROW,COL GET get_data VALID PREDV(f_script,get_data) picture "@S55"
                           ENDIF
                           READ
                           Unlock
                           Clear Typeahead
                        ENDIF
                        setcolor(color)
                        readexit(.f.)
                        keystroke = LASTKEY()
                        IF Select()==88.and.Is_Append.and.Keystroke!=K_ESC
                           IF .not.IsCorrect("Добавление новой записи",.F.)
                              Keystroke:=K_ESC
                           ENDIF
                        ENDIF
                        DO CASE
                                CASE  M->keystroke = -7 .AND. LASTREC()<>0.and.edit
                                 if select()=55
                                    al_box({"Удалить невозможно"})
                                 else
                                    F8()
                                    if select()=44.or.Select()==45
                                       change=.t.
                                    endif
                                 endif

                           CASE  M->keystroke = -3 .AND. LASTREC()<>0
                                   SEARCH()
                           CASE M->keystroke = 10.and..not.is_append.and.edit
                                do case
                                    case select()=55
                                         colorwin(2,0,2,79,'n/n')
                                         Select(Main)
                                         KOtr:=Kod_Otr
                                         rlock()
                                         replace kod_otr with KOtr
                                         unlock
                                         Select 55
                                         message_wait(' Код отрасли данного предприятия изменен !')
                                         keyboard chr(27)

                                    case select()=88
                                         urov=urov+1
                                         ew=recno()
                                         schet=lic_schet
                                         sele 77
                                         set index to lic_sch
                                         seek schet
                                         found=found()
                                         do licevoj
                                         sele 88
                                         set index to lic,potrebit
                                         go ew
                                         urov=urov-1
                                case select()=77
                                     do raschet
                             endcase

                        OTHERWISE
                                IF M->keystroke <> 27 .AND. UPDATED()
                                codefound=.F.
                                IF f_script=1.and.select()=88
                                        codefound=CODEFOUND()
                                ENDIF
                                IF M->is_append .AND. EOF()
                                   IF .NOT. codefound
                                    IF reclock()
                                      DO CASE
                                         CASE select()=213.and.edit
                                              if recno()=1
                                                 replace raznica with pokaz_sch-ostatok
                                              else
                                                 go recno()-1
                                                 _ostatok=pokaz_sch
                                                 _tarif:=tarfunc(tarif)
                                                 _koef=koeficient
                                                 skip
                                                 _ostatok=pokaz_sch-_ostatok
                                                 replace raznica with _ostatok
                                                 replace tarif with _tarif
                                                 replace koeficient with _koef
                                              endif
                                              replace summa with raznica*koeficient*rashod*tarif
                                              Replace Moshn With .F.
                                              Replace IsLastMont With .F.
                                              @ 0,0 say str(raznica*koeficient*rashod*tarif)
                                         CASE select()=44.or.select()==45.and.edit
                                                 change=.t.
                                      ENDCASE
                                      UNLOCK
                                     ENDIF
//                                     IF netappend()
                                         any_append = .T.
//                                         unlock
//                                     ENDIF
                                   ENDIF
                                ENDIF
                                * put it there
                                IF Select()==41.and.f_script==5
                                   codefound=.T.
                                ENDIF
                                IF .NOT. codefound
                                  IF Edit
                                     PreviousData:=&e_field
                                     IF reclock()
                                        IF e_field!='substr(potrebitel,1,55)'
                                           REPLACE &e_field WITH M->get_data
                                        ELSE
                                           REPLACE Potrebitel WITH M->get_data
                                           Replace BitStr With Chr(0)
                                        ENDIF
                                        unlock
                                        ret_val =  2
                                        any_append = .T.
                                     ENDIF
                                     WantReplace("Изменение",e_field,PreviousData,&e_Field)
                                  else
                                     al_box({"Возможность редактирования отключена"})
                                  ENDIF
// Анализ текущего алиаса
                                   DO CASE
                                      Case Select()=101
                                           IF Copy==0
                                              IF RecLock()
                                                 Replace Copy With 1
                                                 UNLOCK
                                              ENDIF
                                           ENDIF
                                      Case Select()==75
                                           IF Reclock()
                                              Replace Kod With Fiders->KOD
                                           ENDIF
                                      Case Select()==41
                                           IF RecLock()
                                              Replace Number With NameIn->Number
                                              UNLOCK
                                           ENDIF
                                      Case Select()==34
                                           IF Empty(Licevoj)
                                              IF RecLock()
                                                 Replace Licevoj With Main->Lic_Schet
                                                 Replace Month   With Month(New_date)
                                                 Replace MN      With Month(New_date)
                                                 Replace Text    With "Ручная корректировка ("+DTOC(New_date)+")"
                                                 UNLOCK
                                               ENDIF
                                           ENDIF
                                      CASE Alias()="MASLIM".AND.F_Script==1.and.edit
                                           IsFound:=.F.
                                           select main
                                           seek maslim->lic_schet
                                           if found()
                                              Select MasLim
//                                              replace maslim->potrebitel with delstring(Main->POTREBITEL,"ИНН")
                                              replace potrebitel with delstring(Main->POTREBITEL,"ИНН")
                                              Select Main
                                              IsFound:=.T.
                                           endif
                                           select limit
                                           seek maslim->lic_schet
                                           if found()
                                              IsFound:=.T.
                                           endif
                                           select maslim
                                           IF .NOT.IsFound
                                              al_box({"Потребитель не найден, запись будет удалена"},1,{" Удалить "})
                                              delete
                                           ELSE
                                                keyboard replicate(chr(2),if(month(New_date)<=11,month(New_date)+1,0))+chr(4)+chr(4)
                                           ENDIF
                                           RET_VAL:=2
                                   ENDCASE
// Анализ текущего номера рабочей области
                                   DO CASE
                                      CASE select()=78.and.edit
                                           If is_append
//                                              replace licevoj2->lic_sch with main->lic_schet
                                              replace lic_sch with main->lic_schet
                                           Else
                                              ReplaceSchet()
                                           Endif
                                      Case select()=55.and.edit
                                           if empty(kod_otr)
                                              if recno()=1
                                                 IF reclock()
                                                  replace kod_otr with 1
                                                  unlock
                                                 ENDIF
                                              else
                                                  go recno()-1
                                                  kod_otrasli=kod_otr+1
                                                  go recno()+1
                                                  IF reclock()
                                                     replace kod_otr with kod_otrasli
                                                     unlock
                                                  ENDIF
                                              endif
                                           endif
                                      case select()=66.and.edit
                                           IF Empty(AllTrim(BIK)).or.Empty(AllTrim(SCHET))
                                              NumLic:=GetVal("Номер договора потребителя",1,-1)
                                              IF NumLic>-1
                                                 Sel:=Select()
                                                 Rec:=RecNo()
                                                 Select Licevoj
                                                 SEEK NumLic
                                                 IF Found()
                                                    Select Reestr
                                                    IF RecLock()
                                                       Replace BIK With Licevoj->MFO
                                                       Replace Schet With Licevoj->R_SCHET
                                                       UNLOCK
                                                    ENDIF
                                                 ELSE
                                                    AL_BOX({"Договор с таким номером не найден"})
                                                 ENDIF
                                                 Select(Sel)
                                                 Go Rec
                                              ENDIF
                                           ENDIF
//                                              if f_script=2
                                                      rec=recno()
                                                      go RecNo()
                                                      go top
                                                      itogo:=0
                                                      do while .not.eof()
                                                              itogo=itogo+summa
                                                              skip
                                                      enddo
                                                      go rec
                                                      keyboa chr(19)+chr(24)
//                                              endif
                                      case select()=44.or.Select()==45.and.edit
                                           if empty(reestr)
                                              if reclock(0)
                                                 replace reestr with 0
                                                 unlock
                                              endif
                                           endif
                                           if empty(licevoj)
                                              if reclock(0)
                                                   replace licevoj with main->lic_schet
                                                   unlock
                                              endif
                                           endif
                                           change=.t.
                                      case select()=33.and.edit
                                              if empty(lic_schet)
                                                 if reclock(0)
                                                      replace lic_schet with main->lic_schet
                                                      unlock
                                                 endif
                                              endif

                                      CASE select()=200.and.edit
                                              Replace Info With " "
                                              SayPlombaNumber()
                                              change=.t.
                                              if len(alltrim(licevoj2->pokazanie))<len(alltrim(str(pokazaniq)))
                                                 al_box({"Проверьте значность счетчика"})
                                              endif
                                              if f_script=1
                                                 IF moshn=.T.
                                                    Replace moshn with .F.
                                                    Colorwin(21,5,21,5+len('Начислено по прошлому'),'w/w')
                                                 ENDIF
                                              endif
                                              if recno()=1
                                                 select 13
                                                 _kod='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
                                                 seek _kod
                                                 if found()
                                                    lyea=pokazaniq
                                                    select licevoj2
                                                    if reclock()
                                                       replace last_year with lyea
                                                       unlock
                                                    endif
                                                    select 13
                                                 endif
                                                 select 200
                                                 if empty(tarif)
                                                    replace tarif with tarfunc(dec_->tarif)
                                                 endif
                                                 if empty(koeficient)
                                                    replace koeficient with dec_->koeficient
                                                 endif
                                                 IF .Not.PlombaIsOut.and.!Empty(Plomba->DateOn)
                                                    IF Year(Plomba->DateOn)==Year(New_date)
                                                       IF RecNo()>=Month(Plomba->DateOn)
                                                          IF Koeficient!=Plomba->NewKoeff
                                                             Replace Koeficient With Plomba->NewKoeff
                                                          ENDIF
                                                       ENDIF
                                                    ELSE
                                                       IF Koeficient!=Plomba->NewKoeff
                                                          Replace Koeficient With Plomba->NewKoeff
                                                       ENDIF
                                                    ENDIF
                                                 ENDIF
                                                    IF PokOff>0
                                                      IF PokOff-licevoj2->last_year>=0
                                                              replace RashOff with (PokOff-licevoj2->last_year)*IF(KoeffOff==0,1,KoeffOff)
                                                      ELSE
                                                              replace RashOff with proverka(PokOff,licevoj2->last_year)*IF(KoeffOff==0,1,KoeffOff)
                                                      ENDIF
                                                    ENDIF
                                                 lastyear=IF(IsNewValue==.F.,licevoj2->last_year,NewValue)
                                                      if .not.empty(lastyear)
                                                         if pokazaniq-lastyear>=0
                                                            replace raznica with pokazaniq-lastyear
                                                         else
                                                            perem=proverka(pokazaniq,lastyear)
                                                                        IF Len(AllTrim(Str(perem,10)))>5
                                                                                MsgBox(" Неверная значность счетчика ("+AllTrim(Str(Perem,10))+") "," Ошибка")
                                                                                Change=.F.
                                                                        ELSE
                                                              replace raznica with perem
                                                            ENDIF
                                                                endif
                                                      else
                                                         save screen
                                                         private old_color
                                                         old_color=setcolor()
                                                         private color_buf
                                                         colorwin(8,21,10,66,'n+/n')
                                                         @ 07,20 say "┌────────────────────────────────────────────╖"
                                                         @ 08,20 say "│   Введите остаток за прошлый год:          ║"
                                                         @ 09,20 say "╘════════════════════════════════════════════╝"
                                                         set color to n/w
                                                         lastyear=0
                                                         if reclock()
                                                            @ 08,57 get lastyear picture '999999'
                                                            read
                                                            unlock
                                                            Clear Typeahead
                                                         endif
                                                         msel:=select()
                                                         lyea:=lastyear
                                                         select licevoj2
                                                         if reclock()
                                                            replace last_year with lyea
                                                            unlock
                                                         endif
                                                         select(msel)
                                                         if pokazaniq-licevoj->last_year>=0
                                                                 replace raznica with pokazaniq-licevoj2->last_year
                                                         else
                                                                 replace raznica with proverka(pokazaniq,licevoj2->last_year)
                                                         endif
                                                         restore screen
                                                         setcolor(old_color)
                                                      endif
                                              else
                                                      go recno()-1
                                                      _ostatok=pokazaniq
                                                      _tarif:=tarfunc(tarif)
                                                      _koef=koeficient
                                                      skip
                                                      if f_script#6.and.f_script#3
                                                              replace tarif with _tarif
                                                              replace koeficient with _koef
                                                      endif
                                                      IF .Not.PlombaIsOut.and.!Empty(Plomba->DateOn)
//                                                         @ 1,0 say Plomba->DateOn
//                                                         @ 2,0 Say New_date
                                                         IF Year(Plomba->DateOn)==Year(New_date)
                                                            IF RecNo()>=Month(Plomba->DateOn)
                                                               IF Koeficient!=Plomba->NewKoeff
                                                                  Replace Koeficient With Plomba->NewKoeff
                                                               ENDIF
                                                            ENDIF
                                                         ELSE
                                                            IF Koeficient!=Plomba->NewKoeff
                                                               Replace Koeficient With Plomba->NewKoeff
                                                            ENDIF
                                                         ENDIF
//                                                         Select 200
                                                      ENDIF
                                                      IF PokOff>0
                                                         IF PokOff-_ostatok>=0
                                                                 replace RashOff with (PokOff-_ostatok)*IF(KoeffOff==0,1,KoeffOff)
                                                         ELSE
                                                                 replace RashOff with proverka(PokOff,_ostatok)*IF(KoeffOff==0,1,KoeffOff)
                                                         ENDIF
                                                      ENDIF
                                                      IF IsNewValue==.T.
                                                         _Ostatok=NewValue
                                                      ENDIF
                                                      IF Len(AllTrim(Str(Proverka(pokazaniq,_ostatok),10)))>5
                                                         IF Len(AllTrim(Str(proverka(pokazaniq,_ostatok),10)))>5
                                                            MsgBox(" Неверная значность счетчика "," Ошибка")
                                                            Change=.F.
                                                         ENDIF
                                                      ELSE
                                                        if pokazaniq-_ostatok>=0
                                                              replace raznica with pokazaniq-_ostatok
                                                        else
                                                              replace raznica with proverka(pokazaniq,_ostatok)
                                                        endif
                                                      ENDIF
/*                                                      
                                                      if pokazaniq-_ostatok>=0
                                                              replace raznica with pokazaniq-_ostatok
                                                      else
                                                              replace raznica with proverka(pokazaniq,_ostatok)
                                                      endif
*/
                                              endif
                                              if val(substr(licevoj2->schetchik,3,7))>0.or.val(substr(licevoj2->schetchik,2,7))>0
                                                      if empty(koeficient)
                                                              replace rashod with raznica+RashOff
                                                      else
                                                              replace rashod with raznica*koeficient+RashOff
                                                      endif
                                              endif
                                              _summa=round((if(rashod>=subab,rashod-subab,subab-rashod))*tarif,DECIMAL)
                                              if rashod>=0

                                                      replace summa with _summa
                                              else
                                                      replace summa with -1*_summa
                                              endif
                                              Replace Moshn With .F.
                                              Replace IsLastMont With .F.
                                              old=setcolor()
                                              set color to gr+/w
                                              @ row,67 say replicate(' ',12)
                                              @ row,67 say str(summa,13,DECIMAL)
                                              setcolor(old)
                                      CASE select()=77.or.select()=78.and.edit
                                           if reclock()
                                              replace lic_sch with schet
                                              replace potreb with main->potrebitel
                                              unlock
                                           endif
                                   ENDCASE
                                ENDIF
                                ENDIF
                        ENDCASE
                        SET CURSOR OFF
                        SET CONF   OFF
//----------------------------------------------------- Сброс буферов на диск
                        GO RECNO()
                        IF .NOT. EMPTY(M->ntx_expr) .AND. .NOT. M->is_append
                                IF M->ntx_eval <> (&ntx_expr)
                                        ret_val = 2
                                ENDIF
                        ENDIF
                        IF M->ret_val <> 2
                           DO CASE
                                   CASE M->keystroke = 5
                                           IF M->is_append
                                                   ret_val = IF(M->any_append, 2, 3)
                                                   is_append = .F.
                                                   any_append = .F.
                                           ELSE
                                                   KEYBOARD CHR(5)
                                           ENDIF
                                   CASE M->keystroke = 18
                                           * PgUp
                                           IF M->is_append
                                                   ret_val = IF(M->any_append, 2, 3)
                                                   is_append = .F.
                                                   any_append = .F.
                                           ELSE
                                                   KEYBOARD CHR(5)
                                           ENDIF
                                   CASE M->keystroke = 24
                                           KEYBOARD CHR(24)
                                           any_append=.f.
                                   CASE M->keystroke = 3 .AND. .NOT. M->is_append
                                           KEYBOARD CHR(24)
                                   CASE M->keystroke = 13.and.edit
                                           IF f_script<LEN(&field_list)
                                                   KEYBOARD CHR(4)
                                           ELSE
                                                   KEYBOARD CHR(1)+CHR(24)
                                                   any_append=.f.
                                           ENDIF
                           ENDCASE
                        ENDIF
        ENDCASE
ENDCASE
RETURN M->ret_val




function tarfunc(tari)
local _tarif
//@ 1,0 Say "         "
do case
        case schet_1old=tari
                _tarif=schet_1new
        case schet_2old=tari
                _tarif=schet_2new
        case schet_3old=tari
                _tarif=schet_3new
        case schet_4old=tari
                _tarif=schet_4new
        case schet_5old=tari
                _tarif=schet_5new
        case schet_6old=tari
                _tarif=schet_6new
        case schet_7old=tari
                _tarif=schet_7new
        case schet_8old=tari
                _tarif=schet_8new
        case schet_9old=tari
                _tarif=schet_9new
        otherwise
                _tarif=tari
//                @ 1,0 Say "Непонятки"
endcase
if month(New_date)==1
//   @ 1,0 say _tarif
endif
return _tarif
