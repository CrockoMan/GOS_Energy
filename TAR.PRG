function tarif_limit
***
*** TAR : format file
*** Generated ��� 18, 1993
***
private old_scr,old_col
old_scr=savescreen(10,22,16,55)
old_col=setcolor()
SET COLOR TO N/W
colorwin(11,23,16,55,'n+/n')
@ 10,22,15,54 BOX "         "
@ 10,23 SAY "����������������������������ķ"
@ 11,23 SAY "� �ॢ�襭�� ����� �����  �"
@ 12,23 SAY "� ��   ᫥���騬   ��䠬 : �"
@ 13,23 SAY "�"+space(28)+"�"
@ 14,23 SAY "�"+space(28)+"�"
@ 15,23 SAY "����������������������������ͼ"
set color to g+*/w
@ 15,24 say chr(16)+' Esc-��室 '+chr(17)
colorwin(11,24,13,51,'b/w')
SET COLOR TO N/W,r/bg,n/w,n/w,n/w
set cursor on
set conf on
IF RecLock()
   do while .t.
        @ 14,25 GET main->LIM_TAR1 picture '##.#####'
        @ 14,34 GET main->LIM_TAR2 picture '##.#####'
        @ 14,43 GET main->LIM_TAR3 picture '##.#####'
        read
        if lastkey()=27
           Clear Typeahead
                exit
        endif
   enddo
   UNLOCK
ENDIF
set curs off
set conf off
restscreen(10,22,16,55,old_scr)
setcolor(old_col)
return ''
