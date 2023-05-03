#include "inkey.ch"
//do calk

proc calculator
set key K_ALT_F12 to
priv old_col,old_scr,cdeci,cursor,recn,index,select
recn=recno()
index=indexord()
select=select()
save screen to old_scr
cdeci=csetdeci()
cursor=csetcurs()
if cursor
        set cursor off
endif
//set decimals to 6
*en='è†¨Ô‚Ï '+alltrim(str(eg))
es='0'
eo='0'
ex=''
ey=''
ew=0
ep=0
epr=0
Winit()
wopen(0,0,17,32)
do while .t.
old_col=SETCOLOR("n/w")
colorwin(0,0,17,32,'n/n')
@ 0,0,16,31 BOX "⁄ƒø≥Ÿƒ¿≥ "
@ 0,19 SAY "¬"
@ 1,1 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞Y≥ ⁄Esc∑⁄F1ƒ∑"
@ 2,1 SAY "±±±±±±±±±±±±±±±±±X≥ ≥   ∫≥   ∫"
@ 3,0 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ ‘ÕÕÕº‘ÕÕÕº"
SET COLOR TO +GR/B
@ 5,2 SAY " 7    8    9 "
@ 8,2 SAY " 4    5    6 "
@ 11,2 SAY " 1    2    3 "
@ 14,2 say " 0    .   /-/"
SET COLOR TO n/G
@ 5,17 SAY " + "
@ 8,17 SAY " -   è"+chr(26)+"x  x"+chr(26)+"è"
@ 11,17 SAY " *    ä    % "
@ 14,17 SAY " /   1/X  X-Y"
SET COLOR TO +W/R
@ 2,22 SAY "¢ÎÂ"
@ 5,22 SAY " C "
SET COLOR TO +gr/N
@ 2,27 SAY "àçî"
@ 5,27 SAY " = "
SET COLOR TO n/w
ed=0
ej=1
do while ed<6
        do while ej<5
                @ ej*3+1,ed*5+1,ej*3+3,ed*5+5 BOX "⁄ƒ∑∫ºÕ‘≥"
                ej=ej+1
        enddo
        ed=ed+1
        ej=1
enddo
ed=0
ej=1
do while .t.
        @ 1,1 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞Y≥ "
        @ 2,1 SAY "±±±±±±±±±±±±±±±±±X≥ "
*       @ 16,5 say en
        if ew=1
                set color to r*/w
                ?? chr(7)
                ey='!!!! ÇçàåÄçàÖ !!!!'
                ex='!!!!! éòàÅäÄ !!!!!'
                ew=0
                epr=1
        endif
        if len(ex)>17.or.len(ey)>17
                set color to r*/w
                ey='!!!! ÇçàåÄçàÖ !!!!'
                ex='** èÖêÖèéãçÖçàÖ **'
                ?? chr(7)
                epr=1
        endif
        @ 1,1 SAY ey
        @ 2,1 SAY ex
        set color to n/w
        @ 4,22 say'='
        @ 4,27 say'ƒŸ'
        @ 7,22 say'F2'
        @ 7,27 say'F3'
        @ 10,22 say'F4'
        @ 10,27 say'F5'
        @ 13,22 say'F6'
        @ 13,27 say'-'
        ev=inkey(0)
        @ ej*3+1,ed*5+1,ej*3+3,ed*5+5 BOX "⁄ƒ∑∫ºÕ‘≥"
        ev=if(epr=1,127,ev)
        do case
                case ev=46
                        ej=4
                        ed=1
                        if at(".",ex)#0
                                ew=1
                                exit
                        endif
                        ex=ex+chr(ev)
                case ev>47.and.ev<58
                        do case
                                case ev=48
                                     ej=4
                                     ed=0
                                case ev=49
                                     ej=3
                                     ed=0
                                case ev=50
                                     ej=3
                                     ed=1
                                case ev=51
                                     ej=3
                                     ed=2
                                case ev=52
                                     ej=2
                                     ed=0
                                case ev=53
                                     ej=2
                                     ed=1
                                case ev=54
                                     ej=2
                                     ed=2
                                case ev=55
                                     ej=1
                                     ed=0
                                case ev=56
                                     ej=1
                                     ed=1
                                case ev=57
                                     ej=1
                                     ed=2
                                endcase
                        if ep=1
                                ex=''
                                ey=''
                                ep=0
                        endif
                        ex=ex+chr(ev)
                case ev=32
                        ej=4
                        ed=2
                        ex=iif(left(ex,1)='-',stuff(ex,1,1,''),'-'+ex)
                case ev=127.or.ev=8
                        ej=1
                        ed=4
                        ex=''
                        ey=''
                        eo='0'
                        ep=0
                        epr=0
                case ev=43
                        ej=1
                        ed=3
                        if !eo='0'
                                do rav with eo,ex,ey
                        endif
                        eo='ey+ex'
                        ey=ex
                        ex=''
                        ep=0
                case ev=45
                        ej=2
                        ed=3
                        if val(ex)=0
                                ex=iif(left(ex,1)='-',stuff(ex,1,1,''),'-'+ex)
                                loop
                        endif
                        if !eo='0'
                                do rav with eo,ex,ey
                        endif
                        eo='ey-ex'
                        ey=ex
                        ex=''
                        ep=0
                case ev=42
                        ej=3
                        ed=3
                        if !eo='0'
                                do rav with eo,ex,ey
                        endif
                        eo='ey*ex'
                        ey=ex
                        ex=''
                        ep=0
                case ev=47
                        ej=4
                        ed=3
                        if !eo='0'
                                if val(ex)=0
                                        ew=1
                                else
                                        do rav with eo,ex,ey
                                endif
                        endif
                        eo='ey/ex'
                        ey=ex
                        ex=''
                        ep=0
                case ev=-1
                        ej=2
                        ed=4
                        ex=es
                        ep=1
                case ev=-2
                        ej=2
                        ed=5
                        es=ex
                        eg=val(ex)
                        @ 16,5,16,30 box 'ƒƒƒƒƒƒƒ'
                        en='è†¨Ô‚Ï '+ltrim(str(eg,18,iif(int(eg)=eg,0,6)))
                        ep=1
                case ev=-3
                        ej=3
                        ed=4
                        if val(ex)<0
                                ew=1
                        else
                                eo='sqrt(ex)'
                                do rav with eo,ex,ey
                        endif
                        ep=1
                case ev=-4
                        ej=3
                        ed=5
                        if val(ey)=0
                                eo='abs(ey*ex/100)'
                                ey=ex
                                ex=''
                                ep=0
                        else
                                eo='ex*100/ey'
                                do rav with eo,ex,ey
                                ep=1
                        endif
                case ev=-5
                        ej=4
                        ed=4
                        if val(ex)=0
                                ew=1
                        else
                                eo='1/ex'
                                do rav with eo,ex,ey
                        endif
                        ep=1
                case ev=9
                        ej=4
                        ed=5
                        el=ey
                        ey=ex
                        ex=el
                        ep=iif(len(ex)>1,1,0)
                case ev=13.or.ev=61
                        ej=1
                        ed=5
                        if !eo='0'
                                if at("/",eo)#0.and.val(ex)=0
                                        ex="owaptdvywoapyyyyyyyyyyyyyyy"
                                        ew=1
                                else
                                        do rav with eo,ex,ey
                                endif
                        endif
                        ep=1
                case ev=27
                        set color to (old_col)
                        wclose()
                        restore screen from old_scr
//                        set key K_ALT_F12 to calk
                        set fixed off
//                        set decimals to cdeci
                        if cursor
                                set cursor on
                        endif
                        select(select)
                        go recn
                        set order to index
                        return
                otherwise
                        loop
        endcase
        @ ej*3+1,ed*5+1,ej*3+3,ed*5+5 BOX "⁄ƒø≥Ÿƒ¿≥"
        enddo
enddo
Return

proc rav
parameters eo,ex,ey
ex=val(ex)
ey=val(ey)
ex=&eo
ey=''
et=iif(int(ex)=ex,0,6)
ex=ltrim(str(ex,30,et))
eo='0'
return
**********
