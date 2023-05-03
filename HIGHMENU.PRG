function highmenu()
private old_clr:=setcolor(),old_scr:=win_save(5,19,14,61)
colorwin(6,20,14,61,'n+/n')
SET COLOR TO N/W,w+/b,,,n/w
@ 05,19,13,60 BOX "         "
@ 05,19 SAY "ฺฤฤฤฤฤฤฤฤฤฤ ’ เจไ๋ ญฅ ข ซจฌจโ ฤฤฤฤฤฤฤฤฤฤฤท"
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
        @ 7,22 get schet_tl1 picture "99999.99"
        @ 7,35 get schet_tl2 picture "99999.99"
        @ 7,50 get schet_tl3 picture "99999.99"
        @ 9,22 get schet_tl4 picture "99999.99"
        @ 9,35 get schet_tl5 picture "99999.99"
        @ 9,50 get schet_tl6 picture "99999.99"
        @ 11,22 get schet_tl7 picture "99999.99"
        @ 11,35 get schet_tl8 picture "99999.99"
        @ 11,50 get schet_tl9 picture "99999.99"
        read
        if lastkey()=27
                exit
        endif
enddo
Clear Typeahead
set curs off
set conf off
&&save all like schet_* to publics
setcolor(old_clr)
win_rest(old_scr)
return NIL



function is_on_high(tarif)
local boolean:=.F.
if schet_tl1#tarif.and.schet_tl2#tarif.and.schet_tl3#tarif.and.;
   schet_tl4#tarif.and.schet_tl5#tarif.and.schet_tl6#tarif.and.;
   schet_tl7#tarif.and.schet_tl8#tarif.and.schet_tl9#tarif
   boolean:=.T.
else
   boolean:=.F.
endif
return boolean