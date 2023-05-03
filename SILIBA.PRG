Func ShiftF8()
     IF al_box({'Удалить текущую запись'},2)==1
        IF IsCorrect("Удаление записи!")
           IF RecLock()
              Delete
              Delete=.T.
              Ret_Val:=2
              UNLOCK
           ENDIF
        ENDIF
     ENDIF
Return NIL



func CTRLF8
Local Kol_Kl:=0,NameInd:=""
IF Select()=88
   IF Al_Box({"Восстановть ВСЕ удаленные данные по потребителю"},2)==1
      del_buf:=obrabot("Восстановление информации по потребителю")
      select 77
      temp_:=39/42
      colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
      RecNo=1
      go RecNo
      Do While !EOF()
         IF Lic_Sch==Main->Lic_Schet
            IF RecLock()
               Recall
               Unlock
            ENDIF
         ENDIF
         RecNo++
         Go RecNo
      EndDo

      for i=1 to 13
          select(i)
          RecNo=1
          go RecNo
          Do While !EOF()
             IF Licevoj==Main->Lic_Schet
                IF RecLock()
                   Recall
                   Unlock
                ENDIF
             ENDIF
             RecNo++
             Go RecNo
          ENDDO
      next

      colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
       select 99
       RecNo=1
       go RecNo
       Do While !EOF()
          IF Licevoj==Main->Lic_Schet
            IF RecLock()
               Recall
               Unlock
            ENDIF
          ENDIF
          RecNo++
          Go RecNo
       ENDDO
      colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
       select 15
       RecNo=1
       go RecNo
       Do While !EOF()
          IF Lic_Schet==Main->Lic_Schet
            IF RecLock()
               Recall
               Unlock
            ENDIF
          ENDIF
          RecNo++
          Go RecNo
       ENDDO
      colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
       select 33
       RecNo=1
       go RecNo
       Do While !EOF()
          IF Lic_Schet==Main->Lic_Schet
            IF RecLock()
               Recall
               Unlock
            ENDIF
          ENDIF
          RecNo++
          Go RecNo
       ENDDO
      colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
       select 44
       for month=1 to 12
              for i=1 to 3
                      do case
                              case i=1
                                      onth='o'+alltrim(str(month))
                                      NameInd:=Schet_Share+'o'+alltrim(str(month))+".Ntx"
                              case i=2
                                      onth='h'+alltrim(str(month))
                                      NameInd:=Schet_Share+'h'+alltrim(str(month))+".Ntx"
                              case i=3
                                      onth='p'+alltrim(str(month))
                                      NameInd:=Schet_Share+'p'+alltrim(str(month))+".Ntx"
                      endcase
                      colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                      IF superload(Schet_Share+onth+".Dbf")
                         Set Index To &NameInd
                         RecNo=1
                         go RecNo
                         Do While !EOF()
                            IF Licevoj==Main->Lic_Schet
                               IF RecLock()
                                  Recall
                                  Unlock
                               ENDIF
                            ENDIF
                            RecNo++
                            Go RecNo
                         ENDDO
                         close
                      ENDIF
              next
       next
       colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
       select 88
       ret_val=2
       win_rest(del_buf)
   ENDIF
ENDIF
if select()=66
        if al_box({'Удалить все записи ?'},2)==1
                zap
                if file(Ddir+'reestr.txt')
                        deletefile(Ddir+'reestr.txt')
                endif
                itogo=0
                go top
                do while !eof()
                        itogo=itogo+summa
                        skip
                enddo
                ret_val=2
                skip
        endif
endif
go recno()
return NIL


FUNC ALT_F8
LOCAL mes,founded:=0,recno:=recno(),Sel:=select(),Count:=0,Kol_Kl:=0
LOCAL Win:=Win_Save()
Local oDlg,aSizeDeskTop,aPos,oProgress
DO Case
   Case Select()=18.or.Select()=19

				oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
				aSizeDesktop  := oMainWindow:currentSize()
				oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
      	oDlg:title    := "Удаление записей" 
   			oDlg:SysMenu	 := .F.
   			oDlg:Configure()
      	oDlg:Show()
      	aSizeDesktop    := oDlg:currentSize()
      	aPos						:= oDlg:CurrentPos()
  			oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
   			oProgress:create()
   			oProgress:minimum := 1
//        Obrabot("Подготовка к удалению записей")
        Go Top
        Do While .not.Eof()
           Count++
           Skip
        EndDo
//        Obrabot("Удалениe записей")
   		  oProgress:maximum := Count
        Go Top
        Do While .not.Eof()
   	  		 oProgress:increment()																				// Progress Bar Increment
//           kol_kl=kol_kl+39/Count
//           colorwin(12,21,12,21+kol_kl,'n/n')
           IF RecLock()
              Delete
              UnLock
              Delete=.T.
           EndIf
           Skip
        EndDo
   			oProgress:destroy()																							// Progress Bar Destroy
   			oDlg:Destroy()
   Case select()=78
     if al_box({" Действительно удалить этот счетчик ",;
                " без удаления показаний за месяц ?"},2)=1
         poisk="("+alltrim(str(main->lic_schet))+")"+alltrim(licevoj2->schetchik)
         WantReplace("УДАЛЕНИЕ "+Poisk,,"","")
         for mes=1 to 13
             select(mes)
             seek poisk
             if found()
                founded++
             endif
         next
         if founded>0
                if al_box({"Найдены показания по данному счетчику за "+;
                           alltrim(str(founded))+" месяц"+;
                           if(founded>1,"ев","")},2,;
                          {" Удалить счетчик "," Не удалять "})=1
                          select 78
                          go recno
                          if reclock()
                             delete
                             unlock
                             delete=.t.
                          endif
                          ret_val=2
                endif
         else
              if reclock()
                delete
                unlock
                delete=.t.
              endif
              ret_val=2
         endif
     endif
     select 78
     if !delete
        go recno
     endif
OtherWise
     al_box({"Этот режим здесь недоступен"},1,{" Угу "})
ENDCASE
Ret_Val:=2
Win_Rest(Win)
Select(Sel)
go recno()
return NIL


*************************
FUNC F8
LOCAL color_buf:=SETCOLOR(),del_buf,kol_kl:=0,temp_,NameInd,cFieldName,Founded:=0
PRIVATE choice,month,onth
do prover
do case
  case select()=88
        if al_box({'Удалить все данные по потребителю?'},2)==1
                del_buf:=obrabot("Удаление информации по потребителю")
                	cFieldName:="Lic_Schet"
         				 WantReplace("УДАЛЕНИЕ договора ",,"","")
                delete=.t.
                select 77
                temp_:=39/42
                go top
                seek main->lic_schet
                colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                IF Found()
                do while lic_sch==main->lic_schet
                  if lic_sch=main->lic_schet
                         _kod='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
                         for i=1 to 12
                                select(i)
                                go top
                                seek _kod
                                IF Found()
                                   if reclock(0)
                                      delete
                                      unlock
                                   endif
                                ELSE
                                   do while kod==_kod
                                      if kod=_kod
                                         if reclock(0)
                                            delete
                                            unlock
                                         endif
                                      endif
                                      skip
                                   enddo
                                ENDIF
                         next
                         select 77
                   endif
                   skip
                 enddo
                ENDIF
                 go top
                 seek main->lic_schet
                 do while lic_sch=main->lic_schet
                    if lic_sch=main->lic_schet
                       if reclock()
                          delete
                          unlock
                       endif
                    endif
                    skip
                 enddo
                colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                 select 99
                 seek main->lic_schet
                 if reclock(0)
                    delete
                    unlock
                 endif
                colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                 select 15
                 go top
                 do while !eof()
                    if lic_schet=main->lic_schet
                       if reclock()
                          delete
                          unlock
                       endif
                    endif
                    skip
                 enddo
                colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                 select 33
                 go top
                 do while !eof()
                    if lic_schet=main->lic_schet
                       if reclock()
                          delete
                          unlock
                       endif
                    endif
                    skip
                 enddo
                colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                 select 44
                 for month=1 to 12
                        for i=1 to 3
                                do case
                                        case i=1
                                                onth='o'+alltrim(str(month))
                                                NameInd:=Schet_Share+'o'+alltrim(str(month))+".Ntx"
                                        case i=2
                                                onth='h'+alltrim(str(month))
                                                NameInd:=Schet_Share+'h'+alltrim(str(month))+".Ntx"
                                        case i=3
                                                onth='p'+alltrim(str(month))
                                                NameInd:=Schet_Share+'p'+alltrim(str(month))+".Ntx"
                                endcase
                                colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                                IF superload(Schet_Share+onth+".Dbf")
                                   Set Index To &NameInd
                                   go top
                                   do while !eof()
                                      if licevoj=main->lic_schet
                                         if reclock()
                                            delete
                                            unlock
                                         endif
                                      endif
                                      skip
                                   enddo
                                   close
                                ENDIF
                        next
                 next
                 colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                 select 88
                 if reclock(0)
                    delete
                    unlock
                 endif
                 ret_val=2
                 win_rest(del_buf)
        endif
      case select()=78
                if al_box({'Удалить все данные по счетчику?'},2)==1
                  poisk='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
	         				for mes=1 to 13
             					select(mes)
             					seek poisk
             					if found()
             						 IF Summa#0
                				 		founded++
                				 ENDIF
             					endif
         					next
         					Select 78
         					IF Founded==0
                         del_buf:=obrabot("Удаление информации по счетчику")
                        temp_:=39/14
                         delete=.t.
                         _kod='('+alltrim(str(licevoj2->lic_sch))+')'+alltrim(licevoj2->schetchik)
         					 				WantReplace("УДАЛЕНИЕ "+_kod,,"","")
                         for i=1 to 13
                                colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                                select(i)
                                Seek _Kod
                                IF Found()
                                   if reclock(0)
                                      delete
                                      unlock
                                   endif
                                ELSE
                                   go top
                                   DO WHILE !eof()
                                      if kod=_kod
                                         if reclock(0)
                                            delete
                                            unlock
                                         endif
                                      endif
                                      skip
                                   enddo
                                ENDIF
                         next
                         colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                         select 78
                         reclock(0)
                         delete
                         unlock
                         skip
                         ret_val=2
                         win_rest(del_buf)
                  ELSE
                  		Al_Box({" Найдены начисления, удалить невозможно "})
                  ENDIF
                endif
    otherwise
      IF Select()==44.and.Licevoj>99999
           if al_box({"Вы действительно хотите удалить эту оплату"},2)==1
                  Temp_:=CHSearch
                  Select FOSN
                  Seek Temp_
                  IF Found()
                     IF RecLock()
                        Delete
                        UNLOCK
                     ENDIF
                  ENDIF
                  Select 44

                  if reclock(0)
                     DELETE
                     unlock
                     Change:=.T.
                     delete=.T.
                     skip
                  endif
                  ret_val=2
           endif
      ELSE
        if select()#99
           if al_box({"Вы действительно хотите",'удалить эту запись'},2)==1
                  if reclock(0)
                     DELETE
                     unlock
                     delete=.t.
                     skip
                  endif
                  ret_val=2
           endif
        endif
      ENDIF
endcase
go recno()
SET COLOR TO (color_buf)
RETURN NIL


proc KONTR
if h1#0
   al_box({'Удалить нельзя'})
   pr51=1
endif
return


proc PROVER
h1=0
do case
        case select()=12
                mdata=data
                dw=recno()
                sele 7
                seek mkrcz+substr(dtoc(mdata),7,2)+substr(dtoc(mdata),4,2)+substr(dtoc(mdata),1,2)
                if found()
                        h1=1
                else
                        h1=0
                endif
                do kontr
                sele 12
                go dw
        case sele()=11
                hkdoc=kdocd
                dw=recno()
                sele 6
                set order to 2
                seek hkdoc
                if found()
                        h1=1
                endif
                set order to 1
                do kontr
                sele 11
                go dw
endcase
return


FUNC BRSHELP
PARAM t
PRIVATE color_buf
color_buf=SETCOLOR()
set color to
@ 21,06 SAY ", , , , gUp, gDn, ome, nd,  gUp,  gDn - Перемещение по окну ввода"
@ 22,2 say 'sc - Выход'
if t=21
        @ 22,17 say 'nter - Взять из справочника'
else
        @ 22,15 say space(64)
endif
set color to bg+/n
if t=21
        @ 22,15 say "^E"
endif
@ 22,1 say 'E'
@ 21,05 SAY ""+chr(24)+""
@ 21,07 SAY ""+chr(25)+""
@ 21,09 SAY ""+chr(26)+""
@ 21,11 SAY ""+chr(27)+""
@ 21,13 SAY "P"
@ 21,18 SAY "P"
@ 21,23 SAY "H"
@ 21,28 SAY "E"
@ 21,32 SAY "^"
@ 21,33 SAY "P"
@ 21,38 SAY "^P"
do case
        case select()=33.or.select()=15.or.select()=55
                fkeys('Помощь','','','','','','','','','Кальку')
        case select()=88
                if edit
                        fkeys('Помощь','Генери','Отрасл','Поиск','Деб/Кр','Лимиты','Оплата','Удалит','Пеня','Кальк')
                else
                        fkeys('Помощь','','','Поиск','','Лимиты','','','','Кальк')
                endif
        case select()=77
                fkeys('Помощь','','','Поиск','','Счетчи','','Удалит','','Кальк')
        case select()=66
                fkeys('Помощь','Печать','','Поиск','Реестр','Настро','','Удалит','','Кальк')
        case select()=200
                fkeys('Помощь','','','','Мощно.','Остато','','','','Кальк')
        case select()=222
                fkeys('','','','','','','','','','Кальк')
        otherwise
                fkeys('Помощь','','','Поиск','','','','Удалит','','Кальк')
endcase
SET COLOR TO (color_buf)
RETURN ''

**************************************
FUNC CODEFOUND
PRIVATE r
IF .NOT. is_append
   rn=RECNO()
   GO TOP
ENDIF
SEEK get_data
DO WHILE .T.
   IF FOUND()
      IF .NOT. is_append
         IF rn<>RECNO()
            r=.T.
            ret_val= 2
            SIGN(3)
            EXIT
         ELSE
            SKIP
            LOOP
         ENDIF
      ELSE
        is_append=.f.
         r=.T.
         SIGN(3)
         ret_val=2
         EXIT
      ENDIF
   ELSE
      IF .NOT. is_append
         GO rn
         ret_val=2
      ENDIF
      r=.F.
      EXIT
   ENDIF
ENDDO
RETURN r

FUNC predv
PARAM fp,par
PRIVATE r,par
r=.t.
do case
        case select()=44
                do case
                        case fp=4
                                if par>new_date.or.year(par)#year(new_date)
                                        al_box({'Дата  неверна'})
                                        r=.f.
                                endif
                endcase
        case select()=77
                if fp=1
                        poisk='('+alltrim(str(main->lic_schet))+')'+get_data
                        select 1
                        seek poisk
                        if found()
                                al_box({"Счетчик "+alltrim(get_data)+' уже существует'})
                                r=.f.
                        else
                                if empty(get_data)
                                        r=.f.
                                else
                                        r=.t.
                                endif
                        endif
                        select 77
                endif
endcase
RETURN r