**********************************************************************
* sb.prg
*
* ����� �஫�����饣� ����

#include "sb.ch"
#include "commands.ch"


* VOID sb_attach(t, l, b, tot_elems, init_elem)
*
* NUMERIC t         - ��砫쭠� ��ப� ���� ��� �஫��஢����
* NUMERIC l         - ��砫�� �⮫��� ���� ��� �஫��஢����
* NUMERIC b         - ����筠� ��ப� ���� ��� �஫��஢����
*                     (������ �⮫��� �ᥣ�� l + 2)
* NUMERIC tot_elems - ��饥 ������⢮ ��ᢥ祭��� ������⮢
* NUMERIC init_elem - �������, ����� ������ ��ᢥ稢�����
*                     ��ࢮ��砫쭮. ����易⥫쭮, �� 㬮�砭�� - 1
* ��ᮥ����� ������ �஫��஢���� � �����
* ����� �஫�����騩 ���� � 梥� 2

STATIC sb_t, sb_l, sb_b, sb_num_blks, sb_num_elems, ;
       sb_num_each_blk, sb_indicator, sb_num_in_win, ;
       colors, save_win

FUNCTION sb_attach(t, l, b, tot_elems, init_elem)

        vstk_push()

//        sb_colors()
        colors = col_split()
        * ������� tot_elems
        tot_elems=tot_elems + (b-1) - (t+1)
        * ���࠭�� ��ࠬ���� ��� ��᫥���饣� �ᯮ�짮����� ...
        sb_t = t+1
        sb_l = l
        sb_b = b-1

        save_win = win_save(sb_t, sb_l, sb_b, sb_l + 2)

        sb_num_elems = tot_elems

        * �����稬 㬮�砭�� ����易⥫쭮�� ��ࠬ����
        DEFAULT init_elem TO 1

        * ������⢮ ������⮢, ���஥ �� ����� ��������
        * � ������� ��ᢥ⪨. �� ����� 祬 ������⢮ ������,
        * ���஥ �� ����� ��ᢥ��� � ������ ���� �஫��஢����
        sb_num_in_win = b - t - 1

        * ������⢮ ������, ���஥ �� ����� ��ᢥ��� � ������
        * ���� �஫��஢����
//        sb_num_blks = (b - t + 1) - 6
        sb_num_blks = (b - t + 1) - 2
        * ������⢮ ��ᢥ祭��� ������⮢ �⭮�⥫쭮 �����
        * ���� �஫��஢����
        sb_num_each_blk = int((sb_num_elems - 1 - sb_num_in_win + ;
                               sb_num_blks - 3) / (sb_num_blks - 2))

        * ��⠭���� ������ �������� � ������� ��� ...
        sb_indicator = pos_indicator(init_elem)

        draw_attachment()
        show_indicator(sb_indicator)

        vstk_pop()

RETURN NIL

STATIC FUNCTION sb_colors
        setcolor("B/R,G/N,,,BG/RB")
RETURN NIL

*         ��ᮥ������� ���� �஫��஢����
**********************************************************************
**********************************************************************

* sb.prg
*
* ����� �஫�����饣� ����

* �����頥� ������ ���� �஫��஢����, ������ �⭮�⥫쭮 ����樨
* ��ꥪ� ������ ����

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

*         ������ ���� �஫��஢����.
**********************************************************************
**********************************************************************

* sb.prg
*
* ����� �஫������饣� ����

STATIC FUNCTION draw_attachment

/*        setcolor(colors[1])

        @ sb_t, sb_l TO sb_b, sb_l + 2

        * �����㥬 㣫�
        @ sb_t, sb_l SAY chr(194)
        @ sb_b, sb_l SAY chr(193)

        * ���㥬 �����, �⤥���騥 ��५�� �஫��஢����
        @ sb_t + 2, sb_l SAY chr(195) + chr(196) + chr(180)
        @ sb_b - 2, sb_l SAY chr(195) + chr(196) + chr(180)

        * ���㥬 ��५��

        @ sb_t + 1, sb_l + 1 SAY chr(24)
        @ sb_b - 1, sb_l + 1 SAY chr(25)
*/
        * ������塞 ������� �஫��஢���� ᨬ����� 䮭�
        setcolor(colors[1])

/*        @ sb_t + 3, sb_l + 1, sb_b -3, sb_l + 1 BOX ;
                                chr(SB_BACK_CHAR)
*/
        @ sb_t, sb_l, sb_b, sb_l BOX chr(SB_BACK_CHAR)

RETURN NIL


*         ��ᮢ���� ������ �஫��஢����
**********************************************************************
**********************************************************************

* sb.prg
*
* ����� �஫�����饣� ����
*
* show_indicator() - �����뢠�� �஫�����騩 ����

* ��ᢥ⨬ �஫�����騩 ���� � ������ ����樨

STATIC FUNCTION show_indicator(indicator_pos)

        vstk_push()

        setcolor(colors[2])

//        @ sb_t + 2 + indicator_pos, sb_l + 1 SAY chr(SB_IND_CHAR)
        @ sb_t + indicator_pos -1, sb_l SAY chr(SB_IND_CHAR)

        vstk_pop()

RETURN NIL


*         ��ᢥ稢���� �஫�����饣� ����

**********************************************************************
**********************************************************************
* sb.prg
*
* ����� ���� �஫��஢����
*
* sb_show() - ��।������ �஫�����騩 ����

* VOID sb_show(rel_pos)
*
* NUMERIC rel_pos - �⭮�⥫쭠� ������ �஫���㥬��� ��ꥪ� �
* ᯨ᪥
*
* �����뢠�� ������ �஫��஢���� ��᫥ ��ᮥ�������

FUNCTION sb_show(rel_pos)

LOCAL new_indicator

        new_indicator = pos_indicator(rel_pos)
        IF sb_indicator != new_indicator
           unshow_indicator(sb_indicator)
           sb_indicator = new_indicator
           show_indicator(sb_indicator)
        ENDIF

RETURN NIL

* ��஫����騩 ���� ���������, ��४஥� ���� 䮭��� ᨬ�����

STATIC FUNCTION unshow_indicator(indicator_pos)

        vstk_push()

        setcolor(colors[1])

//        @ sb_t + 2 + indicator_pos, sb_l + 1 SAY chr(SB_BACK_CHAR)
        @ sb_t + indicator_pos-1, sb_l SAY chr(SB_BACK_CHAR)

        vstk_pop()

RETURN NIL

*         ��।������� �஫�����饣� ���� ��� ��⮤�
*         ��ࢮ�� �������
**********************************************************************
**********************************************************************
* VOID sb_detach()
*
* �᢮������� ��६���� � ����⠭�������� ��࠭

FUNCTION sb_detach
//        win_rest(save_win)
        // �᢮����� ������
        save_win = NIL
RETURN NIL

*         ��ନ��஢���� ���� �஫��஢����
**********************************************************************
**********************************************************************

#include "achoice.ch"
#include "inkey.ch"

FUNCTION handle_sb(mode, cur_elem, rel_pos)

LOCAL ret_val, lkey

//      sb_show(cur_elem - rel_pos)   // ����� ��������
        sb_show(cur_elem)   // ����� ��������

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
