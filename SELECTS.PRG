* PRG..........: selects
* CLASS........: бокс выбора
* PREFIX.......: sel
* EXPORT.......: sel_box()
* CONSTRUCTOR..:
* DESTRUCTOR...:
* USES.........: scroll bar
*                video stack
*                colors
*                shadows
*                windows
* NOTES........: Компилировать с /a /m /n /w /dSEL_TEST для тестирования

#include "inkey.ch"
#include "selects.ch"
#include "achoice.ch"
#include "commands.ch"     // Для DEFAULT TO

#define TICK_CHAR 251


// Тестовая функция для прверки работоспособности бокса выбора
#ifdef TEST
       FUNCTION sel_test
       LOCAL buttons, on_off, selectables:={}, i, chosen,MaxSize

               set color to n/b
               CLEAR SCREEN

               * Распределим и установим кнопки, результат и
               * выбираемость
               buttons:={"Лицевой счет","Наименование потребителя",;
                         "Задолжность","Расход за месяц","Точка подключения",;
                         "Адрес","Телефон"}

               ASize(Selectables,Len(Buttons))
               afill(selectables, .T.)
               * Невыбираемые кнопки
               selectables[2] = .F.

               * Начальные выборы
               on_off = {1, 2, 6}

               MaxSize:=0
               for i=1 to len(Buttons)
                   MaxSize:=IF(Len(Buttons[i])>MaxSize,Len(Buttons[i])+7,MaxSize)
               Next
               chosen = sel_box(3, 10, 3+Len(Buttons)+1, 10+MaxSize, buttons, selectables, ;
                        on_off, 1, 0, .T.)

               * Теперь высветим возвращенные результаты
               CLEAR SCREEN
               aeval(chosen,{|elem| qout(elem)})
               inkey(0)

       RETURN NIL
#endif


* NUMERIC [] sel_box(t, l, b, r, buttons, selectables, init_sels, ;
*                    init_highlight, init_rel_highlight, scroll_bar, ;
*                    shadow)
*
* NUMERIC t, l, b, r          - Координаты бокса выбора, включая
*                               область бокса скроллирования, если
*                               используется
*
* CHARACTER buttons[]         - Кнопки для включения - выключения
* LOGICAL selectables[]       - .T. означает, что соответствующая кнопка
*                               выбираема, .F. -невыбираема.
*                               Необязательно, по умолчанию все .T.
* NUMERIC init_sels[]         - Номера элементов начально выбранных
*                               объектов
* NUMERIC init_highlight      - Начальный элемент для высветки.
*                               Необязательно, по умолчанию - 1
* NUMERIC init_rel_hightlight - Начальная относительная позиция
*                               init_highlight внутри окна.
*                               Необязательно, по умолчанию - 0, первая
*                               позиция внутри окна.
* LOGICAL scroll_bar          - Необязательно, по умолчанию - .T.
* LOGICAL shadow              - Необязательно, по умолчанию - .T.
* LOGICAL RestoreScreen       -  Необязательно, по умолчанию - .T.
*
* RETURN                       - Массив выбранных элементов
*
* Представляет бокс выбора. Позволяет выбрать объект клавишей Enter.
* Выход по клавише Esc. Бокс в цвете 1, высвеченный объект в цвете 2,
* другие выбираемые объекты в цвете 1, невыбираемые объекты в цвете 5

FUNCTION sel_box(t, l, buttons, selectables, init_sels, ;
            init_highlight, init_rel_highlight, scroll_bar, ;
            shadow,RestoreScreen)

LOCAL cur_button, button_num, new_r, lkey, save_win, ar_size,b:=0,r:=0

* Privates из-за нелепых проблем achoice с диапазоном ...

PRIVATE chosen, cur_highlight, cur_rel_highlight, ;
        sb_scrool_bar, temp_buttons

        DEFAULT selectables TO .T.
        DEFAULT init_sels TO {}
        DEFAULT init_highlight TO 1
        DEFAULT init_rel_highlight TO 0
        DEFAULT scroll_bar TO .T.
        DEFAULT shadow TO .T.
        DEFAULT RestoreScreen TO .T.

        IF b >= maxrow() .OR. r >= maxcol()
           shadow = .F.
        ENDIF

        sb_scroll_bar = scroll_bar
        temp_buttons = array(len(buttons))

        * Поместим пробел впереди каждого элемента
        ar_size = len(temp_buttons)
        FOR button_num = 1 TO ar_size
            temp_buttons[button_num] = " " + buttons[button_num]
            * Расчет правой координаты
            R:=IF((L+2+Len(temp_buttons[button_num]))>r,;
               L+Len(temp_buttons[button_num])+2,r)
        NEXT
        * Расчет нижней координаты
        B:=IF(T+Len(Buttons)+1>MaxRow()-T,MaxRow()-T,T+Len(Buttons)+1)

        * Поместим галочку впереди каждого первоначально выбранного
        * элемента
        * init_sels содержит номера элементов
        ar_size = len(init_sels)
        FOR button_num = 1 TO ar_size
            temp_buttons[init_sels[button_num]] = chr(TICK_CHAR) + ;
                                buttons[init_sels[button_num]]
        NEXT

        * Скопируем массив первоначально выбранных элементов,
        * т.к. мы можем изменить его
        chosen = aclone(init_sels)

        vstk_push()
        sel_colors()

        IF shadow
           save_win = win_save(t, l, b + 1, r + 1)
        ELSE
           save_win = win_save(t, l, b, r)
        ENDIF

        IF sb_scroll_bar
           @ t, l TO b, r - 2
           sb_attach(t, r - 2 , b, len(buttons), ;
                     init_highlight - init_rel_highlight)
           new_r = r - 3
        ELSE
           @ t, l TO b, r
           new_r = r - 1
        ENDIF

        cur_highlight = init_highlight
        cur_rel_highlight = init_rel_highlight

        IF shadow
           sha_shadow(t, l, b, r-2)
        ENDIF

        * Т.к. ACHOICE не имеет режима перевысветки, мы должны постоянно
        * повторно входить для высветки нового обновленного массива

        lkey = 0
        DO WHILE lkey != K_ESC
           cur_button = achoice(t +1, l+ 1, b - 1, new_r,  ;
                                 temp_buttons, selectables, ;
                                 "handle_select", cur_highlight, ;
                                 cur_rel_highlight)
           lkey = lastkey()
        ENDDO

        IF sb_scroll_bar
           @ t, l TO b, r - 2
           sb_detach()
        ENDIF
        IF RestoreScreen
           win_rest(save_win)
        ENDIF

        vstk_pop()

RETURN asort(chosen)


FUNCTION handle_select(mode, cur_elem, rel_pos)

LOCAL ret_val, lkey, where_sel_item

* Эти PRIVATE переменные наследуются из sel_box

MEMVAR cur_highlight, cur_rel_highlight, ;
       sb_scroll_bar, init_sels, chosen, temp_buttons

        cur_highlight = cur_elem
        cur_rel_highlight = rel_pos

        IF sb_scroll_bar
           sb_show(cur_elem - rel_pos)
        ENDIF
        lkey = lastkey()
        DO CASE
           CASE mode = AC_EXCEPT
                DO CASE
                   CASE lkey = K_ESC
                        ret_val = AC_SELECT
                   CASE lkey = K_ENTER
                        * если объект уже выбран, отменить его выбор
                        IF (where_sel_item := ascan(chosen,;
                                                    cur_elem)) != 0
                           adel(chosen, where_sel_item)
                           asize(chosen, len(chosen) - 1)
                           temp_buttons[cur_elem] = " " + ;
                               substr(temp_buttons[cur_elem], 2)
                        ELSE
                           * Выберем новый объект
                           aadd(chosen, cur_elem)
                           temp_buttons[cur_elem]=chr(TICK_CHAR) ;
                               + substr(temp_buttons[cur_elem], 2)
                        ENDIF
                        Clear Typeahead
                        ret_val = AC_SELECT

                   OTHERWISE
                        ret_val = AC_CONT
                ENDCASE
           OTHERWISE
                ret_val = AC_CONT
        ENDCASE
RETURN ret_val


STATIC FUNCTION sel_colors
        setcolor("n/w,n/g,,,b/w")
RETURN NIL

**********************************************************************
