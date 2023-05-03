function tipplatbank()
local old_scr:=win_save(10,17,23,70),plategka,position
do case
        case tip_plat==0
             position:=1
        case tip_plat==3
             position:=3
        case tip_plat==4
             position:=4
        case tip_plat==5
             position:=5
        case tip_plat==6
             position:=6
//        case tip_plat==7
//             position:=8
        case tip_plat==8
             position:=8
        case tip_plat==1 .or. .not.is_poruch
             position:=1
        case tip_plat==2 .or. is_poruch
             position:=2
endcase
spisok:={" Требование                               ",;
         " Требование-Поручение                     ",;
         " Инкассовое поручение                     ",;
         " Требование через Сбербанк                ",;
         " Требование-Поручение через Сбербанк      ",;
         ' Требование через "Крайинвестбанк" ',;
         ' Требование-Поручение  через "Крайинвестбанк"  ',;
         ' Требование через ФКБ "Петрокоммерц"'}
//is_choice:={.t.,.t.,.t.,.t.}
is_choice:={.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}
plategka=vert_menu(spisok,"Тип выставляемой платежки",is_choice,10,17,position,'n/w,n/g,,,n/w',.F.)
if reclock()
   do case
        case plategka=1
              replace is_poruch with .f.
              replace tip_plat with 1
        case plategka=2
              replace is_poruch with .t.
              replace tip_plat with 2
        case plategka=3
              replace tip_plat with 3
        case plategka=4
              replace tip_plat with 4
        case plategka=5
              replace tip_plat with 5
        case plategka=6
              replace tip_plat with 6
        case plategka=7
              replace tip_plat with 7
        case plategka=8
              replace tip_plat with 8
   endcase
   unlock
else
   al_box({"Изменить не удалось"})
endif
win_rest(old_scr)
return NIL
