#include "commands.ch"      // ��� DEFAULT TO
#include "inkey.ch"
STATIC tmpcolors,colors,is_my_first_level:=.T.,exit_next:=.F.,key_pressed
STATIC is_enter:=.F., is_cursor, IsShowMenuOnly:=.F.

/*      proc main
        keyboard chr(K_ENTER)
        third_menu:={   {" ����         ",{||chrs()}   },;
                        {" �� �祭�       ",{||chrs()}   },;
                        {" ��� � ���� !   ",{||chrs()}   };
                    }
        second_menu:={  {" ��� �⢥���          ",third_menu},;
                        {" �� ��� �⢥���       ",third_menu},;
                        {" ��� ������, �� �㬠�!  ",third_menu};
                     }
        main_menu:={    {" ��� ���� ",second_menu      },;
                        {" ��� ����஥�� ",second_menu},;
                        {" ��� ࠡ�� ",second_menu    },;
                        {" ��諨 ��� ",second_menu    },;
                        {" ��室 ",{||exitdos()}       };
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
        if al_box({"   �������� ࠡ��� � ��� � DOS ?   "},2)=1
                return "Exit"
        endif
        return NIL
*/

* VOID do_menu(prompts, colors,shadow,top,left,right)
*
* ARRAY prompts            - ���ᨢ, �������஢���� ��� ����
* Logical ESCexit          - ��室��� �� ���� �� ESC, �� 㬮�砭�� - .F.
* Numeric Tmp_New_Pos      - ��砫쭠� ������ ����, �� 㬮�砭�� - 1
* Char Colors              - ���� ����. �� 㬮�砭�� - n/w,n/g,,,n/w
* Logical SHADOW           - ��ᮢ��� ⥭� ����� ����?
*                            ����易⥫쭮, �� 㬮�砭�� .T.
* Numeric Top              - ���न��� ��ப� �뢮�� ���� ��ࢮ��
*                            �஢��, �� 㬮�砭�� 0
* Numeric Left             - ���न��� �⮫�� �뢮�� ���� ��ࢮ��
*                            �஢��, �� 㬮�砭�� 0
* Numeric Right            - ���न��� ��᫥����� �⮫�� �뢮�� ����
*                            ��ࢮ�� �஢��, �� 㬮�砭�� - maxcol()
* ����� ���ᨢ, ᮤ�ঠ騩 ����ࠧ��୮� ����, ������ ���᪠���
* ���孥�� �஢��, ��⥬ ���� ��뢠�� ���� ������� �஢��, ����
* ��뢠�� ���� ����.

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

        * �� ������ ��������, � ������ �⮫�� ��稭����� ��
        * ���᪠��� ������� �஢��. ����� ��ࠧ��, �� ������ ��᫥������
        * ��砫�� �⮫��� ������ ��ਧ��⠫쭮� ���᪠���. ���ᨢ
        * cols ������ ��.

        cols = array(num_prompts)

        * ���� ���孥�� �஢�� ����� �ਭ� ��࠭� � ��ࠬ����.
        * ���᪠��� ������� �� ��ப� 2. ���࠭�� �������, ������ ��
        * �㤥� ��४�뢠��.
        IF .not.escexit
//              save_win = win_save(top, left, top, right)
                save_win = win_save(top, left, top, maxcol())
        ENDIF

        * ���砫� ��ࠬ�� � ����⨬ ������� ...
           @ top, left CLEAR TO top, right

        * �� �� ��� ���� ���짮��⥫� �� �⪠����� ...
        DO WHILE choice != 0
           * ��⠭���� ������ ����� ��� �ᮢ���� ����
           @ top, left SAY ""

           * ������� ������ ���᪠��� �� ��ப� 1, �⤥������
           * ���� �஡�����. ���࠭�� ��砫�� �⮫��� � ���ᨢ�
           * cols
           FOR prompt_num = 1 TO num_prompts
               cols[prompt_num] = col()
               @ top, col() SAY mprompts[prompt_num, 1]
           NEXT

           * �맮��� ����, ��稭�� � ⥪�饩 ���᪠���
           * ��ࢮ��砫쭮 �� 1
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
                        // �᫨ ���� ⮫쪮 ���ᮢ��� ���� � ���
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
           * Ec�� ���짮��⥫� �� �⪠����� �� ���� ...
           IF choice > 0
              * �᫨ ᮮ⢥�����騩 �室 ��� ������, ���᫨�� ���,
              * ��뢠� ��� �㭪��
              IF valtype(mprompts[choice, 2]) = "B"
                IF is_cursor
                        set cursor on
                ENDIF
                  ReturnVal:=eval(mprompts[choice, 2])
                  ReturnVal:=if(ReturnVal==NIL,"",Alltrim(MYUpper(Xtoc(ReturnVal))))
                  * �᫨ �맢����� �㭪�� �����⨫� ��ப� "Exit" -
                  * ��室 �� ����
                  IF ReturnVal=="EXIT"
                        Exit
                  ENDIF
                IF is_cursor
                        set cursor off
                ENDIF
               ELSE
                  * � ��⨢��� ��砥 �맮��� ����ணࠬ�� �믠���饣�
                  * ���� ������� �஢��
                  * �� ������ ��।��� �� ���ᨢ ���᪠���/������ �
                  * ��砫�� ��ப� � �⮫��� ����.
                  * �� ���孨� ���� 㣮� ���� �믠���饣� ����.
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

        *����⠭���� �������, ��४����� ��ਧ��⠫�� ����
        IF .not.escexit
            win_rest(save_win)
        ENDIF
//        IF .not.IsShowMenu
           vstk_pop()
//        ENDIF

RETURN NIL

*         ���� ���孥�� �஢��
**********************************************************************
**********************************************************************
* ��뢠�� �믠���饥 ����, ��� ������� ��।����� ���᪠�����, ��
* ��ப� t, � �⮫�� l.

FUNCTION do_pull_down(mprompts, t, l, shadow)

LOCAL save_win, len_longest, num_prompts, b, r, prompt_num, choice
LOCAL tmp_old_pos:=0, tmp_new_pos:=1, local_level

        * ��ਭ� ���� ��।������ ᠬ�� ������� ���᪠����
        len_longest = len_l_prompt(mprompts)

        * ���� ���� ��।������ ������⢮� ���᪠���
        num_prompts = len(mprompts)

        * ��⠭���� ����� ������ ��ப� ��� ࠬ�� ...
        b = t + num_prompts + 1

        * ��⠭���� ����� ����筮�� �⮫�� ��� ࠬ�� ...
        r = l + len_longest + 1

        * ���砫� ��࠭�� �������, ������ �㤥� ��४�뢠��
        IF shadow .AND. b < maxrow() .AND. r < maxcol()
           save_win = win_save(t, l, b +1, r + 1)
           sha_shadow(t, l, b, r)
        ELSE
           save_win = win_save(t, l, b, r)
        ENDIF

        * ������ ��ࠬ�� ��
        @ t, l, b, r BOX "�ķ���Գ "

        * ��筥� � ��ࢮ� ���᪠���
        choice = 1

        * �� �� ���, ���� ���짮��⥫� �� �⪠����� ...
        DO WHILE choice != 0
           * ������� ������ ���᪠���, �������� �஡����� �� �ਭ�
           * ᠬ�� ������� �� ���
           FOR prompt_num = 1 TO num_prompts
               @ t + prompt_num, l + 1 SAY ;
                   pad(mprompts[prompt_num, 1], len_longest)
           NEXT

           * �맮��� ����, ��稭�� � ⥪�饩 ���᪠���
           * ��ࢮ��砫쭮, �� 1
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

           * �᫨ ���짮��⥫� �� �⪠����� ...
           IF choice > 0
              * �᫨ ᮮ⢥�����騩 �室 ���� ������,���᫨�� ���,
              * ��뢠� ��� �㭪��
              IF valtype(mprompts[choice, 2]) = "B"
                IF is_cursor
                        set cursor on
                ENDIF
                 eval(mprompts[choice, 2])
                IF is_cursor
                        set cursor off
                ENDIF
              ELSE
                 * � ��⨢��� ��砥 �맮��� ����ணࠬ�� �믠���饣�
                 * ���� ������� �஢��
                 * �� ��।��� �� ���ᨢ ���᪠���/������ �
                 * ��砫�� ��ப� � �⮫��� ����.
                 * �� ���孨� ���� 㣮� ࠬ�� ���� �믠���饣� ����.
                 * �� ��稭��� � ���� ����� ��� ����� ��࠭���
                 * த�⥫�᪮� ���᪠��� �� ��ப� ����
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

        * ������ ����⠭���� ��࠭����� ���� ����
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
