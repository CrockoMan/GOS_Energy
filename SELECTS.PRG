* PRG..........: selects
* CLASS........: ���� �롮�
* PREFIX.......: sel
* EXPORT.......: sel_box()
* CONSTRUCTOR..:
* DESTRUCTOR...:
* USES.........: scroll bar
*                video stack
*                colors
*                shadows
*                windows
* NOTES........: �������஢��� � /a /m /n /w /dSEL_TEST ��� ���஢����

#include "inkey.ch"
#include "selects.ch"
#include "achoice.ch"
#include "commands.ch"     // ��� DEFAULT TO

#define TICK_CHAR 251


// ���⮢�� �㭪�� ��� �ࢥન ࠡ��ᯮᮡ���� ���� �롮�
#ifdef TEST
       FUNCTION sel_test
       LOCAL buttons, on_off, selectables:={}, i, chosen,MaxSize

               set color to n/b
               CLEAR SCREEN

               * ���।���� � ��⠭���� ������, १���� �
               * �롨ࠥ�����
               buttons:={"��楢�� ���","������������ ���ॡ�⥫�",;
                         "�����������","���室 �� �����","��窠 ������祭��",;
                         "����","����䮭"}

               ASize(Selectables,Len(Buttons))
               afill(selectables, .T.)
               * ���롨ࠥ�� ������
               selectables[2] = .F.

               * ��砫�� �롮��
               on_off = {1, 2, 6}

               MaxSize:=0
               for i=1 to len(Buttons)
                   MaxSize:=IF(Len(Buttons[i])>MaxSize,Len(Buttons[i])+7,MaxSize)
               Next
               chosen = sel_box(3, 10, 3+Len(Buttons)+1, 10+MaxSize, buttons, selectables, ;
                        on_off, 1, 0, .T.)

               * ������ ��ᢥ⨬ �����饭�� १�����
               CLEAR SCREEN
               aeval(chosen,{|elem| qout(elem)})
               inkey(0)

       RETURN NIL
#endif


* NUMERIC [] sel_box(t, l, b, r, buttons, selectables, init_sels, ;
*                    init_highlight, init_rel_highlight, scroll_bar, ;
*                    shadow)
*
* NUMERIC t, l, b, r          - ���न���� ���� �롮�, ������
*                               ������� ���� �஫��஢����, �᫨
*                               �ᯮ������
*
* CHARACTER buttons[]         - ������ ��� ����祭�� - �몫�祭��
* LOGICAL selectables[]       - .T. ����砥�, �� ᮮ⢥������� ������
*                               �롨ࠥ��, .F. -���롨ࠥ��.
*                               ����易⥫쭮, �� 㬮�砭�� �� .T.
* NUMERIC init_sels[]         - ����� ������⮢ ��砫쭮 ��࠭���
*                               ��ꥪ⮢
* NUMERIC init_highlight      - ��砫�� ������� ��� ��ᢥ⪨.
*                               ����易⥫쭮, �� 㬮�砭�� - 1
* NUMERIC init_rel_hightlight - ��砫쭠� �⭮�⥫쭠� ������
*                               init_highlight ����� ����.
*                               ����易⥫쭮, �� 㬮�砭�� - 0, ��ࢠ�
*                               ������ ����� ����.
* LOGICAL scroll_bar          - ����易⥫쭮, �� 㬮�砭�� - .T.
* LOGICAL shadow              - ����易⥫쭮, �� 㬮�砭�� - .T.
* LOGICAL RestoreScreen       -  ����易⥫쭮, �� 㬮�砭�� - .T.
*
* RETURN                       - ���ᨢ ��࠭��� ������⮢
*
* �।�⠢��� ���� �롮�. �������� ����� ��ꥪ� �����襩 Enter.
* ��室 �� ������ Esc. ���� � 梥� 1, ��ᢥ祭�� ��ꥪ� � 梥� 2,
* ��㣨� �롨ࠥ�� ��ꥪ�� � 梥� 1, ���롨ࠥ�� ��ꥪ�� � 梥� 5

FUNCTION sel_box(t, l, buttons, selectables, init_sels, ;
            init_highlight, init_rel_highlight, scroll_bar, ;
            shadow,RestoreScreen)

LOCAL cur_button, button_num, new_r, lkey, save_win, ar_size,b:=0,r:=0

* Privates ��-�� ������� �஡��� achoice � ���������� ...

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

        * �����⨬ �஡�� ���।� ������� �������
        ar_size = len(temp_buttons)
        FOR button_num = 1 TO ar_size
            temp_buttons[button_num] = " " + buttons[button_num]
            * ����� �ࠢ�� ���न����
            R:=IF((L+2+Len(temp_buttons[button_num]))>r,;
               L+Len(temp_buttons[button_num])+2,r)
        NEXT
        * ����� ������ ���न����
        B:=IF(T+Len(Buttons)+1>MaxRow()-T,MaxRow()-T,T+Len(Buttons)+1)

        * �����⨬ ������ ���।� ������� ��ࢮ��砫쭮 ��࠭����
        * �������
        * init_sels ᮤ�ন� ����� ������⮢
        ar_size = len(init_sels)
        FOR button_num = 1 TO ar_size
            temp_buttons[init_sels[button_num]] = chr(TICK_CHAR) + ;
                                buttons[init_sels[button_num]]
        NEXT

        * ������㥬 ���ᨢ ��ࢮ��砫쭮 ��࠭��� ������⮢,
        * �.�. �� ����� �������� ���
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

        * �.�. ACHOICE �� ����� ०��� ��ॢ�ᢥ⪨, �� ������ ����ﭭ�
        * ����୮ �室��� ��� ��ᢥ⪨ ������ ������������ ���ᨢ�

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

* �� PRIVATE ��६���� ��᫥������ �� sel_box

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
                        * �᫨ ��ꥪ� 㦥 ��࠭, �⬥���� ��� �롮�
                        IF (where_sel_item := ascan(chosen,;
                                                    cur_elem)) != 0
                           adel(chosen, where_sel_item)
                           asize(chosen, len(chosen) - 1)
                           temp_buttons[cur_elem] = " " + ;
                               substr(temp_buttons[cur_elem], 2)
                        ELSE
                           * �롥६ ���� ��ꥪ�
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
