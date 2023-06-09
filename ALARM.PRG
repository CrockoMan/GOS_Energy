**********************************************************************
*
* PRG..........: alarm
* CLASS........: ᨣ����� ����
* PREFIX.......: al
* EXPORT.......: al_box()
* CONSTRUCTOR..:
* DESTRUCTOR...:
* USES.........: Windows
*                line split
*                spacing
*                colors
*                shadows
*                video stack
* NOTES........: �������஢��� � /a /m /n /w
* �������������: al_box(���ᨢ_��ப_ᮮ�饭��,������⢮_������_�롮�,;
*                       ���ᨢ_��ப_������_�롮�,�����_��ࢮ��_�㭪�_�롮�,;
*                       TOP,LEFT,BOTTOM,RIGHT, �ᮢ���_⥭�(.T. ��� .F.),梥�)
*
**********************************************************************

#include "windows.ch"
#include "commands.ch"     // ��� DEFAULT TO

/*proc main
        ? al_box({" �ਢ�⨪, ��� ���� ? "},3)
        ? al_box({" �ਢ�⨪, ��� ���� ? "},3,,,,,,,,'w+/b,W+/B,,,w/b')
//      ? al_box({" �ਢ�⨪, ��� ���� ? "},3,{" ���� "," �� �祭� "," ��� � ���� "})
//      ? al_box({" �ਢ�⨪, ��� ���� ? "},2,{" ���� "," �� �祭� "})
//      ? al_box({" �ਢ�⨪, ��� ���� ? "},1,{" ���� "})
return*/

FUNCTION al_box(message, num_buttons, buttons, ;
                start_button, t, l, b, r, shadow, color_choice)

LOCAL num_disp_lines, act_num_lines, cur_button, button_num, ;
        lkey, mess_width, colors, txt_lines, cols, line_num, ;
        save_win, save_curs, max_len_string, color, row_start:=row(),;
        col_start:=col()

        * ���࠭���� ��⠭��� �����
        save_curs:=csetcurs()
        if save_curs
                set cursor off
        endif

        * �����稬 㬮�砭�� ��� ��� ����易⥫��� ��ࠬ��஢
        message:=if(message==NIL,{""},message)

        * ������ ������⢠ ��ப
        act_num_lines = len(message)

        * ���� ᠬ�� ������� ��ப� ���ᨢ�
        max_len_string:=0
        for line_num = 1 to act_num_lines
                max_len_string=if(max_len_string<len(message[line_num]),;
                                len(message[line_num])+6, max_len_string)
        next

        num_buttons:=if(num_buttons== NIL, 1,num_buttons)
        t:=if(t==NIL,maxrow()/2 - act_num_lines/2 - 2,t)
        b:=if(b==NIL,maxrow()/2 + act_num_lines/2 + 3,b)
        l:=if(l==NIL,round((maxcol()/2) - if(max_len_string/2 < 20,17,;
                        max_len_string/2) - 3,0),l)
        r:=if(r==NIL,round((maxcol()/2) + if(max_len_string/2 < 20,17,;
                        max_len_string/2) + 3,0),r)
        shadow:=if(shadow==NIL,.T.,shadow)
        start_button:=if(start_button==NIL,1,start_button)
        color_choice:=if(color_choice==NIL,"N/W,W+/G,,,N/W",color_choice)
//      color_choice:=if(color_choice==NIL,"N/W,W+/B,,,N/W",color_choice)
        color:=setcolor()
        IF buttons = NIL .OR. len(buttons) = 0
           DO CASE
              CASE num_buttons = 1
                   buttons = {"   OK   "}
              CASE num_buttons = 2
                   buttons = {"  ��  ", "  ���  "}
              CASE num_buttons = 3
                   buttons = {"  ��  ", "  ���  ", " �⬥���� "}
           ENDCASE
        ELSE
           * ���ᨢ ������ ��।��. ���쬥� ��� ����� �����
           * ��ࠬ��� num_buttons
           num_buttons = len(buttons)
        ENDIF

        * ������⢮ ��ப ��� ��ᢥ⪨ ⥪�� - ��
        * ���� ���� ��� ����� ࠬ��, ��� ��ப�, �ਬ몠�饩 �
        * ���設� ࠬ��, ��� ����, ����室����� ��� ������ (3 ��ப�)
        num_disp_lines =if(b - t - 5 < 2, 2, b - t - 5)

        IF b >= maxrow() .OR. r >= maxcol()
           shadow = .F.
        ENDIF

        setcolor(color_choice)
//        al_colors()
        colors = col_split()
        col_ten_on:='n/'+token(colors[1],"/",2)
        col_ten_off:=token(colors[1],'/',2)+'/'+token(colors[1],'/',2)
//      ? col_ten_on
//      ? col_ten_off

        IF shadow
           save_win = win_save(t, l, b + 1, r + 1)
           colorwin(t+1,l+1,b+1,r+1,'n+/n')             && ���� �� ࠬ��
        ELSE
           save_win = win_save(t, l, b, r)
        ENDIF

        @ t, l CLEAR TO b, r
        @ t, l TO b, r

/*        IF shadow
           sha_shadow(t, l, b, r)
        ENDIF
*/

        * ��।���� ���ᨢ �⮣� ࠧ��� ��� ��࠭���� ��ப ��᫥
        * ࠧ������
        txt_lines = array(num_disp_lines)

        * �����쥬 ��ப� � ��ᢥ⨬ ��
        mess_width = r - l -3

           * ���쪮 ���� ��ப�, ���⮬� �業���㥬 ��
           FOR line_num = 1 TO act_num_lines
//             if act_num_lines=1
                   @ t + 2 +(line_num-1), l + 2 + int(( r - l - 3 - ;
                                len(message[line_num])) / 2) ;
                                SAY message[line_num]
/*             else
                       @ t + 2 + (line_num - 1), l + 2 ;
                              SAY message[line_num]
               endif */
           NEXT

        * ��।���� ��砫�� �⮫��� ��� ������ ������
//        cols = spa_spacing(buttons, l + 2, r - 2)
        cols = spa_spacing(buttons, l + 1, r - 1)

        setcolor(colors[5])

        * ��ᢥ⨬ �� ������
        FOR button_num = 1 TO num_buttons
            @ b - 2, cols[button_num] SAY ' '+buttons[button_num]+' '
        NEXT

        * ������ ��ࠡ�⠥� ������ �������, ��।����� ���ᢥ��,
        * �� �� ��� ���� �� ����� ������ Enter
        cur_button = start_button

        * ���ᢥ⨬ ⥪���� ������
        setcolor(colors[2])
        @ b - 2, cols[cur_button] SAY "<"+buttons[cur_button]+">"
*---------
        setcolor(col_ten_on)
//        setcolor('n'+substr(colors[1],2,2))
//      set color to n/w
        @ b - 1, cols[cur_button]+1 SAY replicate(chr(223),;
                                        len(buttons[cur_button])+2)
        @ b - 2, cols[cur_button]+2+len(buttons[cur_button]) SAY chr(219)
        setcolor(colors[2])
*---------

        lkey = hot_inkey(0)

        DO WHILE lkey != 13
           * ���६ ���ᢥ�� � ⥪�饩 ������
           setcolor(colors[5])
           @ b - 2, cols[cur_button] SAY ' '+buttons[cur_button]+' '
*---------
//           setcolor(substr(colors[1],3,1)+substr(colors[1],2,2))
           setcolor(col_ten_off)
//         set color to w/w
           @ b - 1, cols[cur_button]+1 SAY replicate(chr(20),;
                                        len(buttons[cur_button])+2)
           @ b - 2, cols[cur_button]+2+len(buttons[cur_button]) SAY chr(20)
           setcolor(colors[5])
*---------
           DO CASE
              CASE lkey = 19
//                   cur_button = max(cur_button - 1, 1)
                   cur_button = if(cur_button=1, num_buttons, cur_button-1)

              CASE lkey = 4
//                   cur_button = min(cur_button + 1, num_buttons)
                   cur_button = if(cur_button=num_buttons, 1, cur_button+1)

            ENDCASE

            * ���ᢥ⨬ ⥪���� ������
            setcolor(colors[2])
            @ b - 2, cols[cur_button] SAY "<"+buttons[cur_button]+">"
*-------
//          set color to n/w
            setcolor(col_ten_on)
            @ b - 1, cols[cur_button]+1 SAY replicate(chr(223),;
                                        len(buttons[cur_button])+2)
            @ b - 2, cols[cur_button]+2+len(buttons[cur_button]) SAY chr(219)
            setcolor(colors[2])
*-------
            lkey = hot_inkey(0)

        ENDDO

        if save_curs
                set cursor on
        endif
        setcolor(color)
        clear typeahead

        win_rest(save_win)
        @ row_start, col_start say ""
//        vstk_pop()

RETURN cur_button

STATIC FUNCTION al_colors
//        setcolor("N/G,W+/R,,,N+/G")
        setcolor("N/W,W+/G,,,N/W")
//        setcolor("N/W,W+/B,,,N/W")
RETURN NIL

* NUMERIC[]  spa_spacing(texts, l, r)
*
* CHARACTER texts[]       - ������ ��� ࠧ�浪�
* NUMERIC l, r            - ����� �⨬� ���� �⮫�栬�
*
* RETURN: ���ᨢ ��砫��� �������
*
* ��।���� ��砫��� ������� ��� ������� ⥪��, ࠧ�裂�� ��
* ����� l � r.

FUNCTION spa_spacing(texts, l, r)
LOCAL sum_lens, text_num, spaces_between, ;
      cols := array(len(texts))

        * ��।���� ����� ����� ᮮ�饭��
        sum_lens = 0
        FOR text_num = 1 TO len(texts)
            sum_lens = sum_lens + len(texts[text_num])
        NEXT

        * ������⢮ �஡���� ����� ������⠬�
        spaces_between = int(((r - l +1) - sum_lens) / ;
                              (len(texts) + 1))

        * ��ࢠ� ������ ⥯��� �����⭠
        cols[1] = l +spaces_between

        * ��।���� ��㣨�
        FOR text_num = 2 TO len(texts)
            cols[text_num] = cols[text_num - 1] + ;
                             len(texts[text_num - 1]) + ;
                             spaces_between
        NEXT

RETURN cols





FUNCTION MessageBox(message, num_buttons, buttons, ;
                start_button, t, l, b, r, shadow, color_choice)

LOCAL num_disp_lines, act_num_lines, cur_button, button_num, ;
        lkey, mess_width, colors, txt_lines, cols, line_num, ;
        save_win, save_curs, max_len_string, color, row_start:=row(),;
        col_start:=col()

        * ���࠭���� ��⠭��� �����
        save_curs:=csetcurs()
        if save_curs
                set cursor off
        endif

        * �����稬 㬮�砭�� ��� ��� ����易⥫��� ��ࠬ��஢
        message:=if(message==NIL,{""},message)

        * ������ ������⢠ ��ப
        act_num_lines = len(message)

        * ���� ᠬ�� ������� ��ப� ���ᨢ�
        max_len_string:=0
        for line_num = 1 to act_num_lines
                max_len_string=if(max_len_string<len(message[line_num]),;
                                len(message[line_num])+6, max_len_string)
        next

        num_buttons:=if(num_buttons== NIL, 1,num_buttons)
        t:=if(t==NIL,maxrow()/2 - act_num_lines/2 - 2,t)
        b:=if(b==NIL,maxrow()/2 + act_num_lines/2 + 1,b)
        l:=if(l==NIL,round((maxcol()/2) - if(max_len_string/2 < 20,17,;
                        max_len_string/2) - 3,0),l)
        r:=if(r==NIL,round((maxcol()/2) + if(max_len_string/2 < 20,17,;
                        max_len_string/2) + 3,0),r)
        shadow:=if(shadow==NIL,.T.,shadow)
        start_button:=if(start_button==NIL,1,start_button)
        color_choice:=if(color_choice==NIL,"N/W,W+/G,,,N/W",color_choice)
        color:=setcolor()


        * ������⢮ ��ப ��� ��ᢥ⪨ ⥪�� - ��
        * ���� ���� ��� ����� ࠬ��, ��� ��ப�, �ਬ몠�饩 �
        * ���設� ࠬ��, ��� ����, ����室����� ��� ������ (3 ��ப�)
        num_disp_lines =if(b - t - 5 < 2, 2, b - t - 5)

        IF b >= maxrow() .OR. r >= maxcol()
           shadow = .F.
        ENDIF

        setcolor(color_choice)
        colors = col_split()
        col_ten_on:='n/'+token(colors[1],"/",2)
        col_ten_off:=token(colors[1],'/',2)+'/'+token(colors[1],'/',2)

        IF shadow
           save_win = win_save(t, l, b + 1, r + 1)
           colorwin(t+1,l+1,b+1,r+1,'n+/n')             && ���� �� ࠬ��
        ELSE
           save_win = win_save(t, l, b, r)
        ENDIF

        @ t, l CLEAR TO b, r
        @ t, l TO b, r


        * ��।���� ���ᨢ �⮣� ࠧ��� ��� ��࠭���� ��ப ��᫥
        * ࠧ������
        txt_lines = array(num_disp_lines)

        * �����쥬 ��ப� � ��ᢥ⨬ ��
        mess_width = r - l -3

           * ���쪮 ���� ��ப�, ���⮬� �業���㥬 ��
           FOR line_num = 1 TO act_num_lines
                   @ t + 2 +(line_num-1), l + 2 + int(( r - l - 3 - ;
                                len(message[line_num])) / 2) ;
                                SAY message[line_num]
           NEXT

        setcolor(colors[5])

        if save_curs
                set cursor on
        endif
        setcolor(color)

//        win_rest(save_win)
        @ row_start, col_start say ""
RETURN cur_button
