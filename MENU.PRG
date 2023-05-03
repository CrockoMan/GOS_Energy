#include "commands.ch"      // Для DEFAULT TO
#include "inkey.ch"
STATIC tmpcolors,colors,is_my_first_level:=.T.,exit_next:=.F.,key_pressed
STATIC is_enter:=.F., is_cursor, IsShowMenuOnly:=.F.

/*      proc main
        keyboard chr(K_ENTER)
        third_menu:={   {" Хорошо         ",{||chrs()}   },;
                        {" Не очень       ",{||chrs()}   },;
                        {" Иди в жопу !   ",{||chrs()}   };
                    }
        second_menu:={  {" Буду отвечать          ",third_menu},;
                        {" Не буду отвечать       ",third_menu},;
                        {" Жми кнопки, не думай!  ",third_menu};
                     }
        main_menu:={    {" Как дела ",second_menu      },;
                        {" Как настроенье ",second_menu},;
                        {" Как работа ",second_menu    },;
                        {" Пошли всех ",second_menu    },;
                        {" Выход ",{||exitdos()}       };
                   }
        save screen
        set color to w+/b
        clear
        colorwin(24,0,24,80,'w+/w+')
        do_menu(main_menu)
        set color to
        restore screen
        return

        function chrs
        ?? chr(7)
        return NIL

        function exitdos
        if al_box({"   Закончить работу и выйти в DOS ?   "},2)=1
                return "Exit"
        endif
        return NIL
*/

* VOID do_menu(prompts, colors,shadow,top,left,right)
*
* ARRAY prompts            - Массив, структурированный как меню
* Logical ESCexit          - Выходить из меню по ESC, по умолчанию - .F.
* Numeric Tmp_New_Pos      - Начальная позиция меню, по умолчанию - 1
* Char Colors              - Цвет меню. По умолчанию - n/w,n/g,,,n/w
* Logical SHADOW           - Рисовать тень вокруг бокса?
*                            Необязательно, по умолчанию .T.
* Numeric Top              - Координата строки вывода меню первого
*                            уровня, по умолчанию 0
* Numeric Left             - Координата столбца вывода меню первого
*                            уровня, по умолчанию 0
* Numeric Right            - Координата последнего столбца вывода меню
*                            первого уровня, по умолчанию - maxcol()
* Данный массив, содержащий двухразмерное меню, издает подсказки
* верхнего уровня, затем либо вызывает меню нижнего уровня, либо
* вызывает блок кода.

FUNCTION do_menu(mprompts, escexit, tmp_new_pos, colors,shadow,top,left,right,MakeOnly)

LOCAL num_prompts, prompt_num, save_win, choice:=1, cols
LOCAL tmp_old_pos:=0,ReturnVal:=NIL
&&PRIVATE tmpcolors

        DEFAULT MakeOnly TO .F.
        DEFAULT shadow TO .T.
        DEFAULT colors TO "n/w,n/g,,,n/w"
        DEFAULT top TO 0
        DEFAULT left TO 0
        DEFAULT right TO maxcol()
        DEFAULT escexit TO .F.
        DEFAULT tmp_new_pos TO 1

        IsShowMenuOnly:=MakeOnly

        vstk_push()
        setcolor(colors)
        tmpcolors=col_split()

        num_prompts = len(mprompts)
        exit_next=.F.
        key_pressed=""
        IF csetcurs()
                is_cursor=.T.
                set cursor off
        ELSE
                is_cursor=.F.
        ENDIF

        * Мы должны подсчитать, с какого столбца начинается любая
        * подсказка нижнего уровня. Таким образом, мы должны отслеживать
        * начальные столбцы каждой горизонтальной подсказки. Массив
        * cols делает это.

        cols = array(num_prompts)

        * Меню верхнего уровня имеет ширину экрана и обрамлено.
        * Подсказки появляются на строке 2. Сохраним область, которую мы
        * будем перекрывать.
        IF .not.escexit
//              save_win = win_save(top, left, top, right)
                save_win = win_save(top, left, top, maxcol())
        ENDIF

        * Сначала обрамим и почистим область ...
           @ top, left CLEAR TO top, right

        * До тех пор пока пользователь не откажется ...
        DO WHILE choice != 0
           * Установим позицию курсора для рисования меню
           @ top, left SAY ""

           * Издадим каждую подсказку на строке 1, отделенную
           * двумя пробелами. Сохраним начальный столбец в массиве
           * cols
           FOR prompt_num = 1 TO num_prompts
               cols[prompt_num] = col()
               @ top, col() SAY mprompts[prompt_num, 1]
           NEXT

           * Вызовем меню, начиная с текущей подсказки
           * Первоначально это 1
                DO WHILE .T.
                        IF tmp_old_pos#tmp_new_pos
                                if tmp_old_pos#0
                                        @ top, cols[tmp_old_pos] SAY mprompts[tmp_old_pos,1]
                                endif
                                setcolor(tmpcolors[2])
                                @ top, cols[tmp_new_pos] SAY mprompts[tmp_new_pos,1]
                                setcolor(colors)
                                tmp_old_pos=tmp_new_pos
                        ELSE
                                IF is_enter
                                    IF valtype(mprompts[tmp_new_pos, 2]) # "B"
                                                keyboard chr(K_ENTER)
                                    ENDIF
                                ENDIF
                        ENDIF
                        IF exit_next
                              IF empty(key_pressed)
                                      IF valtype(mprompts[tmp_new_pos, 2]) # "B"
                                        keyboard chr(K_ENTER)
                                      ENDIF
                                      exit_next:=.F.
                              ELSE
                                      keyboard key_pressed
                                      key_pressed=""
                                      exit_next:=.T.
                              ENDIF
                        ENDIF
                        // Если надо только нарисовать меню и выйти
                        IF IsShowMenuOnly
                           EXIT
                        ENDIF
                        tmp_key=hot_inkey()
                        do case
                                case tmp_key=K_LEFT
                                        tmp_new_pos=if(tmp_new_pos=1,;
                                           num_prompts, tmp_new_pos-1)
                                case tmp_key=K_RIGHT
                                        tmp_new_pos=if(tmp_new_pos=num_prompts,;
                                           1, tmp_new_pos+1)
                                case tmp_key=K_ESC
                                        choice=0
                                        IF escexit=.T.
                                                exit
                                        ENDIF
                                case tmp_key=K_ENTER
                                        choice=tmp_new_pos
                                        exit
                        endcase
                ENDDO

           tmp_old_pos=0
           * Ecли пользователь не отказался от меню ...
           IF choice > 0
              * Если соответствующий вход являетя блоком, вычислить его,
              * вызывая его функцию
              IF valtype(mprompts[choice, 2]) = "B"
                IF is_cursor
                        set cursor on
                ENDIF
                  ReturnVal:=eval(mprompts[choice, 2])
                  ReturnVal:=if(ReturnVal==NIL,"",Alltrim(MYUpper(Xtoc(ReturnVal))))
                  * Если вызванная функция возвратила строку "Exit" -
                  * выход из меню
                  IF ReturnVal=="EXIT"
                        Exit
                  ENDIF
                IF is_cursor
                        set cursor off
                ENDIF
               ELSE
                  * В противном случае вызовем подпрограмму выпадающего
                  * меню нижнего уровня
                  * Мы должны передать ей массив подсказок/блоков и
                  * начальные строку и столбец меню.
                  * Это верхний левый угол бокса выпадающего меню.
                  is_enter:=.T.
                  do_pull_down(mprompts[choice, 2], top+1, ;
                               cols[choice], shadow)
               ENDIF
           ELSE
                if escexit
                   exit
                endif
           ENDIF
        ENDDO

        *Восстановим область, перекрытую горизонтальным меню
        IF .not.escexit
            win_rest(save_win)
        ENDIF
//        IF .not.IsShowMenu
           vstk_pop()
//        ENDIF

RETURN NIL

*         Меню верхнего уровня
**********************************************************************
**********************************************************************
* Вызывает выпадающее меню, чья структура определена подсказками, на
* строке t, в столбце l.

FUNCTION do_pull_down(mprompts, t, l, shadow)

LOCAL save_win, len_longest, num_prompts, b, r, prompt_num, choice
LOCAL tmp_old_pos:=0, tmp_new_pos:=1, local_level

        * Ширина окна определяется самой длинной подсказкой
        len_longest = len_l_prompt(mprompts)

        * Высота окна определяется количеством подсказок
        num_prompts = len(mprompts)

        * Установим номер нижней строки для рамки ...
        b = t + num_prompts + 1

        * Установим номер конечного столбца для рамки ...
        r = l + len_longest + 1

        * Сначала сохраним область, которую будем перекрывать
        IF shadow .AND. b < maxrow() .AND. r < maxcol()
           save_win = win_save(t, l, b +1, r + 1)
           sha_shadow(t, l, b, r)
        ELSE
           save_win = win_save(t, l, b, r)
        ENDIF

        * Теперь обрамим ее
        @ t, l, b, r BOX "┌─╖║╝═╘│ "

        * Начнем с первой подсказки
        choice = 1

        * До тех пор, пока пользователь не откажется ...
        DO WHILE choice != 0
           * Издадим каждую подсказку, дополняя пробелами до ширины
           * самой длинной из них
           FOR prompt_num = 1 TO num_prompts
               @ t + prompt_num, l + 1 SAY ;
                   pad(mprompts[prompt_num, 1], len_longest)
           NEXT

           * Вызовем меню, начиная с текущей подсказки
           * Первоначально, это 1
                DO WHILE .T.
                        IF tmp_old_pos#tmp_new_pos
                                setcolor(tmpcolors[1])
                                if tmp_old_pos#0
                                       @ t + tmp_old_pos, l + 1 SAY ;
                                           pad(mprompts[tmp_old_pos, 1], len_longest)
                                endif
                                setcolor(tmpcolors[2])
                                @ t + tmp_new_pos, l + 1 SAY ;
                                   pad(mprompts[tmp_new_pos, 1], len_longest)
                                setcolor(tmpcolors[1])
                                tmp_old_pos=tmp_new_pos
                        ENDIF
                        IF IsShowMenuOnly
                           Choice:=0
                           EXIT
                        ENDIF
                        tmp_key=hot_inkey()
                        do case
                                case tmp_key=K_LEFT .and. is_my_first_level
                                        exit_next=.T.
                                        keyboard chr(K_ESC)
                                        key_pressed=chr(K_LEFT)
                                case tmp_key=K_RIGHT .and. is_my_first_level
                                        exit_next=.T.
                                        keyboard chr(K_ESC)
                                        key_pressed=chr(K_RIGHT)
                                case tmp_key=K_UP
                                        tmp_new_pos=if(tmp_new_pos=1,;
                                           num_prompts, tmp_new_pos-1)
                                case tmp_key=K_DOWN
                                        tmp_new_pos=if(tmp_new_pos=num_prompts,;
                                           1, tmp_new_pos+1)
                                case tmp_key=K_HOME
                                        tmp_new_pos=1
                                case tmp_key=K_END
                                        tmp_new_pos=num_prompts
                                case tmp_key=K_PGUP
                                        tmp_new_pos=1
                                case tmp_key=K_PGDN
                                        tmp_new_pos=num_prompts
                                case tmp_key=K_ESC
                                        choice=0
                                        is_enter=if(empty(key_pressed),.F.,.T.)
                                        exit
                                case tmp_key=K_ENTER
                                        choice=tmp_new_pos
                                        exit
                        endcase
                ENDDO

tmp_old_pos=0

           * Если пользователь не отказался ...
           IF choice > 0
              * Если соответствующий вход является блоком,вычислить его,
              * вызывая его функцию
              IF valtype(mprompts[choice, 2]) = "B"
                IF is_cursor
                        set cursor on
                ENDIF
                 eval(mprompts[choice, 2])
                IF is_cursor
                        set cursor off
                ENDIF
              ELSE
                 * В противном случае вызовем подпрограмму выпадающего
                 * меню нижнего уровня
                 * Мы передаем ей массив подсказок/блоков и
                 * начальные строку и столбец меню.
                 * Это верхний левый угол рамки бокса выпадающего меню.
                 * Мы начинаем с двух третьих пути вдоль выбранной
                 * родительской подсказки на строке ниже
                 local_level=is_my_first_level
                 is_my_first_level=.F.
                 do_pull_down(mprompts[choice, 2], ;
                              choice + t + 1, ;
                              l + 1 + (len_longest/3), ;
                              shadow)
//                              l + 1 + 2*(len_longest/3), ;
                 is_my_first_level=local_level
              ENDIF
           ENDIF
        ENDDO

        * Теперь восстановим сохраненное нами окно
        IF .NOT.IsShowMenuOnly
           win_rest(save_win)
        ENDIF

RETURN NIL

STATIC FUNCTION len_l_prompt(mprompts)
LOCAL longer, i
        longer = mprompts[1, 1]
        FOR i = 1 TO len(mprompts)
            IF len(longer) < len(mprompts[i, 1])
               longer = mprompts[i, 1]
            ENDIF
        NEXT
RETURN len(longer)
************
STATIC FUNCTION menu_colors
        setcolor('n/w,n/g,,,n/w')
RETURN NIL
