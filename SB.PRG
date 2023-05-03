**********************************************************************
* sb.prg
*
* Класс скроллирующего бокса

#include "sb.ch"
#include "commands.ch"


* VOID sb_attach(t, l, b, tot_elems, init_elem)
*
* NUMERIC t         - Начальная строка бокса для скроллирования
* NUMERIC l         - Начальный столбец бокса для скроллирования
* NUMERIC b         - Конечная строка бокса для скроллирования
*                     (конечный столбец всегда l + 2)
* NUMERIC tot_elems - Общее количество высвеченных элементов
* NUMERIC init_elem - Элемент, который должен высвечиваться
*                     первоначально. Необязательно, по умолчанию - 1
* Присоединяет полосу скроллирования к боксу
* Рисует скроллирующий бокс в цвете 2

STATIC sb_t, sb_l, sb_b, sb_num_blks, sb_num_elems, ;
       sb_num_each_blk, sb_indicator, sb_num_in_win, ;
       colors, save_win

FUNCTION sb_attach(t, l, b, tot_elems, init_elem)

        vstk_push()

//        sb_colors()
        colors = col_split()
        * Изменим tot_elems
        tot_elems=tot_elems + (b-1) - (t+1)
        * Сохраним параметры для последующего использования ...
        sb_t = t+1
        sb_l = l
        sb_b = b-1

        save_win = win_save(sb_t, sb_l, sb_b, sb_l + 2)

        sb_num_elems = tot_elems

        * Назначим умолчание необязательному параметру
        DEFAULT init_elem TO 1

        * Количество элементов, которое мы можем поместить
        * в область высветки. Это больше чем количество блоков,
        * которое мы можем высветить в области бокса скроллирования
        sb_num_in_win = b - t - 1

        * Количество блоков, которое мы можем высветить в области
        * бокса скроллирования
//        sb_num_blks = (b - t + 1) - 6
        sb_num_blks = (b - t + 1) - 2
        * Количество высвеченных элементов относительно блока
        * бокса скроллирования
        sb_num_each_blk = int((sb_num_elems - 1 - sb_num_in_win + ;
                               sb_num_blks - 3) / (sb_num_blks - 2))

        * Установим позицию индикатора и покажем его ...
        sb_indicator = pos_indicator(init_elem)

        draw_attachment()
        show_indicator(sb_indicator)

        vstk_pop()

RETURN NIL

STATIC FUNCTION sb_colors
        setcolor("B/R,G/N,,,BG/RB")
RETURN NIL

*         Присоединение бокса скроллирования
**********************************************************************
**********************************************************************

* sb.prg
*
* Класс скроллирующего бокса

* Возвращает позицию бокса скроллирования, данную относительно позиции
* объекта вверху окна

STATIC FUNCTION pos_indicator(rel_pos)

LOCAL pos_indicator

        DO CASE
           CASE rel_pos = 1
                pos_indicator = 1

           CASE rel_pos >= sb_num_elems - sb_num_in_win + 1
                pos_indicator = sb_num_blks

           OTHERWISE
                pos_indicator = int((rel_pos - 1 + sb_num_each_blk ;
                                     - 1) / sb_num_each_blk) + 1
        ENDCASE

RETURN pos_indicator

*         Позиция бокса скроллирования.
**********************************************************************
**********************************************************************

* sb.prg
*
* Класс скроллиирующего бокса

STATIC FUNCTION draw_attachment

/*        setcolor(colors[1])

        @ sb_t, sb_l TO sb_b, sb_l + 2

        * Фиксируем углы
        @ sb_t, sb_l SAY chr(194)
        @ sb_b, sb_l SAY chr(193)

        * Рисуем линии, отделяющие стрелки скроллирования
        @ sb_t + 2, sb_l SAY chr(195) + chr(196) + chr(180)
        @ sb_b - 2, sb_l SAY chr(195) + chr(196) + chr(180)

        * Рисуем стрелки

        @ sb_t + 1, sb_l + 1 SAY chr(24)
        @ sb_b - 1, sb_l + 1 SAY chr(25)
*/
        * Заполняем область скроллирования символом фона
        setcolor(colors[1])

/*        @ sb_t + 3, sb_l + 1, sb_b -3, sb_l + 1 BOX ;
                                chr(SB_BACK_CHAR)
*/
        @ sb_t, sb_l, sb_b, sb_l BOX chr(SB_BACK_CHAR)

RETURN NIL


*         Рисование полосы скроллирования
**********************************************************************
**********************************************************************

* sb.prg
*
* Класс скроллирующего бокса
*
* show_indicator() - Показывает скроллирующий бокс

* Высветим скроллирующий бокс в данной позиции

STATIC FUNCTION show_indicator(indicator_pos)

        vstk_push()

        setcolor(colors[2])

//        @ sb_t + 2 + indicator_pos, sb_l + 1 SAY chr(SB_IND_CHAR)
        @ sb_t + indicator_pos -1, sb_l SAY chr(SB_IND_CHAR)

        vstk_pop()

RETURN NIL


*         Высвечивание скроллирующего бокса

**********************************************************************
**********************************************************************
* sb.prg
*
* Класс бокса скроллирования
*
* sb_show() - Передвигает скроллирующий бокс

* VOID sb_show(rel_pos)
*
* NUMERIC rel_pos - Относительная позиция скроллируемого объекта в
* списке
*
* Показывает полосу скроллирования после присоединения

FUNCTION sb_show(rel_pos)

LOCAL new_indicator

        new_indicator = pos_indicator(rel_pos)
        IF sb_indicator != new_indicator
           unshow_indicator(sb_indicator)
           sb_indicator = new_indicator
           show_indicator(sb_indicator)
        ENDIF

RETURN NIL

* Скролирующий бокс двигается, перекроем старый фоновым символом

STATIC FUNCTION unshow_indicator(indicator_pos)

        vstk_push()

        setcolor(colors[1])

//        @ sb_t + 2 + indicator_pos, sb_l + 1 SAY chr(SB_BACK_CHAR)
        @ sb_t + indicator_pos-1, sb_l SAY chr(SB_BACK_CHAR)

        vstk_pop()

RETURN NIL

*         Передвижение скроллирующего бокса для метода
*         первого элемента
**********************************************************************
**********************************************************************
* VOID sb_detach()
*
* Освобождает переменные и восстанавливает экран

FUNCTION sb_detach
//        win_rest(save_win)
        // Освободим память
        save_win = NIL
RETURN NIL

*         Терминирование бокса скроллирования
**********************************************************************
**********************************************************************

#include "achoice.ch"
#include "inkey.ch"

FUNCTION handle_sb(mode, cur_elem, rel_pos)

LOCAL ret_val, lkey

//      sb_show(cur_elem - rel_pos)   // Показ поплавка
        sb_show(cur_elem)   // Показ поплавка

        DO CASE
           CASE mode = AC_EXCEPT
                lkey = lastkey()
                DO CASE
                   CASE lkey = K_ESC
                        ret_val = AC_ABORT

                   CASE lkey = K_ENTER
                        ret_val = AC_SELECT

                   OTHERWISE
                        ret_val = AC_CONT
                ENDCASE
                OTHERWISE
                     ret_val = AC_CONT
           ENDCASE

RETURN ret_val
