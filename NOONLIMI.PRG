function noonlimit
LOCAL screen:=win_save(5,21,18,60),color:=setcolor(),NamePer
SET COLOR TO &GetColor
colorwin(6,22,18,60,'n+/n')
@ 05,21,17,59 BOX "ÚÄ·º¼ÍÔ³ "
@ 05,21 SAY "ÚÄÄÄÄÄÄÄ ‘ç¥âç¨ª¨ ­¥ ¢ «¨¬¨â ÄÄÄÄÄÄÄÄÄ·"
set cursor on
set confir on
FOR i=1 to 18
    NamePer:= "Schet_NL"+alltrim(str(int(i)))
    &NamePer:=&NamePer+space(9-len(&NamePer))
NEXT
DO WHILE .T.
        @ 07,28 GET SCHET_NL1 picture "@K XXXXXXXXX"
        @ 07,42 GET SCHET_NL2 picture "@K XXXXXXXXX"
                @ 08,28 GET SCHET_NL3 picture "@K XXXXXXXXX"
                @ 08,42 GET SCHET_NL4 picture "@K XXXXXXXXX"
        @ 09,28 GET SCHET_NL5 picture "@K XXXXXXXXX"
        @ 09,42 GET SCHET_NL6 picture "@K XXXXXXXXX"
                @ 10,28 GET SCHET_NL7 picture "@K XXXXXXXXX"
                @ 10,42 GET SCHET_NL8 picture "@K XXXXXXXXX"
        @ 11,28 GET SCHET_NL9 picture "@K XXXXXXXXX"
        @ 11,42 GET SCHET_NL10 picture "@K XXXXXXXXX"
                @ 12,28 GET SCHET_NL11 picture "@K XXXXXXXXX"
                @ 12,42 GET SCHET_NL12 picture "@K XXXXXXXXX"
        @ 13,28 GET SCHET_NL13 picture "@K XXXXXXXXX"
        @ 13,42 GET SCHET_NL14 picture "@K XXXXXXXXX"
                @ 14,28 GET SCHET_NL15 picture "@K XXXXXXXXX"
                @ 14,42 GET SCHET_NL16 picture "@K XXXXXXXXX"
        @ 15,28 GET SCHET_NL17 picture "@K XXXXXXXXX"
        @ 15,42 GET SCHET_NL18 picture "@K XXXXXXXXX"
        read
        if lastkey()=27
                exit
        endif
ENDDO
Clear Typeahead
set cursor off
set confir off
setcolor(color)
win_rest(screen)
return NIL