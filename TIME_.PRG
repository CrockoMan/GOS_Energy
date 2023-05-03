proc time_out
local color:=setcolor(),screen:=win_save(),curs:=csetcurs()
local posy:=row(),posx:=col(),key
IF .not.RunSaver
   Return
ENDIF
if curs
        set cursor off
endif

SET COLOR TO               && Ausgabe weiб auf schwart

set color to g/n
clear
        VGAtime(substr(time(),1,1),;
                substr(time(),2,1),;
                substr(time(),4,1),;
                substr(time(),5,1),;
                substr(time(),7,1),;
                substr(time(),8,1))
                @ 13,47 say"ЫЫ"
                @ 13,26 say"ЫЫ"

key:=inkey()

do while if(key=0,.T.,if(key#255,.F.,.T.))
        @ 1,1 say time()
        @ 2,1 say str(seconds(),8,2)
        @ 1,79-len(dtoc(new_date)) say dtoc(new_date)
        @ 2,79-len(dtoc(old_date)) say dtoc(old_date)
        VGAtime(substr(time(),1,1),;
                substr(time(),2,1),;
                substr(time(),4,1),;
                substr(time(),5,1),;
                substr(time(),7,1),;
                substr(time(),8,1))
        Key:=Inkey()
enddo
if curs
        set cursor on
endif
set color to
clear
setcolor(color)
win_rest(screen)
@ posy,posx say ""
RETURN

*-------------------------


*-------------------------

STATIC FUNCTION COLORON(cColor)
/* VGAPALETTE('w', redw, greenw, bluew)   && alte Einstellungen
 VGAPALETTE('b', redb, greenb, blueb)   && alte Einstellungen
 VGAPALETTE('g', redg, greeng, blueg)   && alte Einstellungen
 VGAPALETTE('r', redr, greenr, bluer)   && alte Einstellungen
 VGAPALETTE('bg', redbg, greenbg, bluebg)   && alte Einstellungen
*/RETURN(NIL)

*-------------------------

STATIC FUNCTION COLORDARK(cColor, nMilliSecs)
LOCAL i, n

 FOR i = 82 TO 0 STEP -1     && 63 ist der Wert vorher
  n := i /83
  VGAPALETTE('w', n *redw, n *greenw, n *bluew)
  VGAPALETTE('b', n *redb, n *greenb, n *blueb)
  VGAPALETTE('g', n *redg, n *greeng, n *blueg)
  VGAPALETTE('r', n *redr, n *greenr, n *bluer)
  VGAPALETTE('bg', n *redbg, n *greenbg, n *bluebg)
*  MILLISEC(nMilliSecs /63)
  NEXT i
RETURN(NIL)

*-------------------------

STATIC FUNCTION COLORLIGHT(cColor, nMilliSecs)
LOCAL i, n

 FOR i = 1 TO 83       &&  0 ist der Wert vorher
   n := i /83
   VGAPALETTE('w', n *redw, n *greenw, n *bluew)
   VGAPALETTE('b', n *redb, n *greenb, n *blueb)
   VGAPALETTE('g', n *redg, n *greeng, n *blueg)
   VGAPALETTE('r', n *redr, n *greenr, n *bluer)
   VGAPALETTE('bg', n *redbg, n *greenbg, n *bluebg)
        VGAtime(substr(time(),1,1),;
                substr(time(),2,1),;
                substr(time(),4,1),;
                substr(time(),5,1),;
                substr(time(),7,1),;
                substr(time(),8,1))
        @ 1,1 say time()
        @ 2,1 say str(seconds(),8,2)
        @ 1,79-len(dtoc(new_date)) say dtoc(new_date)
        @ 2,79-len(dtoc(old_date)) say dtoc(old_date)
NEXT i
RETURN(NIL)




******************** ‘ҐЄг­¤л ¬« ¤иЁ© а §ап¤ ************************
STATIC function VGAtime(hours1,hours2,minutes1,minutes2,seconds1,seconds2)
for i=1 to 6
        do case
                case i=1
                        see:=hours1
                        posy:=08
                case i=2
                        see:=hours2
                        posy:=17
                case i=3
                        see:=minutes1
                        posy:=29
                case i=4
                        see:=minutes2
                        posy:=38
                case i=5
                        see:=seconds1
                        posy:=50
                case i=6
                        see:=seconds2
                        posy:=59
        endcase
                if see='0'
                        @ 09,posy say "ЫЫЫЫЫЫЫ"
                        @ 10,posy say "ЫЫ   ЫЫ"
                        @ 11,posy say "ЫЫ   ЫЫ"
                        @ 12,posy say "ЫЫ   ЫЫ"
                        @ 13,posy say "ЫЫЫЫЫЫЫ"
                endif
                if see='1'
                        @ 09,posy say "    ЬЫЫ"
                        @ 10,posy say "     ЫЫ"
                        @ 11,posy say "     ЫЫ"
                        @ 12,posy say "     ЫЫ"
                        @ 13,posy say "     ЫЫ"
                endif
                if see='2'
                        @ 09,posy say "ЫЫЫЫЫЫЫ"
                        @ 10,posy say "     ЫЫ"
                        @ 11,posy say "ЫЫЫЫЫЫЫ"
                        @ 12,posy say "ЫЫ     "
                        @ 13,posy say "ЫЫЫЫЫЫЫ"
                endif
                if see='3'
                        @ 09,posy say "ЫЫЫЫЫЫЫ"
                        @ 10,posy say "     ЫЫ"
                        @ 11,posy say " ЫЫЫЫЫЫ"
                        @ 12,posy say "     ЫЫ"
                        @ 13,posy say "ЫЫЫЫЫЫЫ"
                endif
                if see='4'
                        @ 09,posy say "ЫЫ   ЫЫ"
                        @ 10,posy say "ЫЫ   ЫЫ"
                        @ 11,posy say "ЫЫ   ЫЫ"
                        @ 12,posy say "ЫЫЫЫЫЫЫ"
                        @ 13,posy say "     ЫЫ"
                endif
                if see='5'
                        @ 09,posy say "ЫЫЫЫЫЫЫ"
                        @ 10,posy say "ЫЫ     "
                        @ 11,posy say "ЫЫЫЫЫЫЫ"
                        @ 12,posy say "     ЫЫ"
                        @ 13,posy say "ЫЫЫЫЫЫЫ"
                endif
                if see='6'
                        @ 09,posy say "ЫЫЫЫЫЫЫ"
                        @ 10,posy say "ЫЫ     "
                        @ 11,posy say "ЫЫЫЫЫЫЫ"
                        @ 12,posy say "ЫЫ   ЫЫ"
                        @ 13,posy say "ЫЫЫЫЫЫЫ"
                endif
                if see='7'
                        @ 09,posy say "ЫЫЫЫЫЫЫ"
                        @ 10,posy say "   ЬЫЫЯ"
                        @ 11,posy say " ЬЫЫЯ  "
                        @ 12,posy say " ЫЫ    "
                        @ 13,posy say " ЫЫ    "
                endif
                if see='8'
                        @ 09,posy say "ЫЫЫЫЫЫЫ"
                        @ 10,posy say "ЫЫ   ЫЫ"
                        @ 11,posy say "ЫЫЫЫЫЫЫ"
                        @ 12,posy say "ЫЫ   ЫЫ"
                        @ 13,posy say "ЫЫЫЫЫЫЫ"
                endif
                if see='9'
                        @ 09,posy say "ЫЫЫЫЫЫЫ"
                        @ 10,posy say "ЫЫ   ЫЫ"
                        @ 11,posy say "ЫЫЫЫЫЫЫ"
                        @ 12,posy say "     ЫЫ"
                        @ 13,posy say "ЫЫЫЫЫЫЫ"
                endif
next
Return NIL
