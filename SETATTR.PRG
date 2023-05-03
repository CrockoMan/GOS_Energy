FUNCTION SetAttribute()
LOCAL old_col1:=setcolor(),screen:=win_save(9,24,24,79),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1,Dat,Mon,Is_Choice:={}
local first:=.T.
prev_rec=prev_rec-1
DO WHILE pos>0
   spisok:={IF(Kategory==chr(1),"√"," ")+"Абонированная мощность          ",;
            IF(Kategory==chr(0),"√"," ")+'Снять признак "Абонир.мощность"  ',;
            IF(Kniga_Old==7,"√"," ")+"Промышленный потребитель     ",;
            IF(Kniga_Old!=7,"√"," ")+"Непромышленный потребитель   ",;
            ' Снять признак "Бюджет"',;
            ' Снять признак "Народное хозяйство"',;
            IF(IsReak=.T.,"√"," ")+'Рассчитывать реактивные потери',;
            IF(IsReak=.F.,"√"," ")+'Реактивные потери не считать',;
            "──────────────────────────────────────────",;
            " Выход                        "}
   ASize(Is_Choice,Len(Spisok))
   Afill(Is_Choice,.t.); Is_Choice[Len(Spisok)-1]:=.F.
   pos=vert_menu(spisok,"Установить атрибуты",is_choice,10,24,pos,'n/w,n/g,,,r/w',.F.)
   DO CASE
      CASE pos=1
           Dat:=GetVal('Дата начала расчета "Абонированной мощности"',DatKat,new_date+365)
           IF Dat!=new_date+365
              IF reclock(0)
                 replace Kategory With chr(1)
                 replace DatKat With Dat
                 UNLOCK
                 Al_Box({'Установлен признак "Абонированная мощность"'})
                 Ret_Val:=2
              ENDIF
           ENDIF
      CASE pos=2
           IF reclock(0)
              replace Kategory With chr(0)
              UNLOCK
              Al_Box({'Снят признак "Абонированная мощность"'})
              Ret_Val:=2
           ENDIF
      CASE pos=3
           IF reclock(0)
              replace Kniga_Old With 7
              UNLOCK
              Al_Box({'Установлен признак "Промышленный потребитель"'})
              Ret_Val:=2
           ENDIF
      CASE pos=4
           IF reclock(0)
              replace Kniga_Old With 1
              UNLOCK
              Al_Box({'Установлен признак "Непромышленный потребитель"'})
              Ret_Val:=2
           ENDIF
      CASE pos=5
           IF reclock(0)
              replace Lim_Tar1 With 0
              UNLOCK
              Al_Box({'Снят признак "Бюджет"'})
              Ret_Val:=2
           ENDIF
      CASE pos=6
           IF reclock(0)
              replace Lim_Tar2 With 0
              UNLOCK
              Al_Box({'Снят признак "Народное xозяйство"'})
              Ret_Val:=2
           ENDIF
      CASE pos=7
           IF reclock(0)
              replace IsReak With .T.
              UNLOCK
              Al_Box({'Установлен признак "Реактивные потери"'})
              Ret_Val:=2
           ENDIF
      CASE pos=8
           IF reclock(0)
              replace IsReak With .F.
              UNLOCK
              Al_Box({'Снят признак "Реактивные потери"'})
              Ret_Val:=2
           ENDIF
      OTHERWISE
           EXIT
   ENDCASE
ENDDO
win_rest(screen)
setcolor(old_col1)
RETURN NIL