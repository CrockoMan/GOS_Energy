***
*** III : format file
*** Generated ๎ซ์ 5, 1994
***
*do tarif_nds

proc tarif_nds
private old_clr:=setcolor(),old_scr:=savescreen(5,19,14,61)
//SET COLOR TO N/W,w+/b,,,n/w
colorwin(6,20,14,61,'n+/n')
SET COLOR TO N/W,w+/b,,,n/w
@ 05,19,13,60 BOX "         "
@ 05,19 SAY "ฺฤฤฤฤฤฤฤฤฤฤฤ ’ เจไ๋ กฅง ‘ ฤฤฤฤฤฤฤฤฤฤฤฤฤท"
@ 06,19 SAY "ณ"+space(40)+"บ"
@ 07,19 SAY "ณ"+space(40)+"บ"
@ 08,19 SAY "ณ"+space(40)+"บ"
@ 09,19 SAY "ณ"+space(40)+"บ"
@ 10,19 SAY "ณ"+space(40)+"บ"
@ 11,19 SAY "ณ"+space(40)+"บ"
@ 12,19 SAY "ณ"+space(40)+"บ"
@ 13,19 SAY "ิออออออออออออออออออออออออออออออออออออออออผ"
set curs on
set conf on
do while .t.
        @ 7,22 get schet_tar1 picture "999.99999"
        @ 7,35 get schet_tar2 picture "999.99999"
        @ 7,50 get schet_tar3 picture "999.99999"
        @ 9,22 get schet_tar4 picture "999.99999"
        @ 9,35 get schet_tar5 picture "999.99999"
        @ 9,50 get schet_tar6 picture "999.99999"
        @ 11,22 get schet_tar7 picture "999.99999"
        @ 11,35 get schet_tar8 picture "999.99999"
        @ 11,50 get schet_tar9 picture "999.99999"
        read
        if lastkey()=27
           Clear Typeahead
                exit
        endif
enddo
set curs off
set conf off
&&save all like schet_* to publics
setcolor(old_clr)
restscreen(5,19,14,61,old_scr)
return