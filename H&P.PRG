***
*** H&P : format file
*** Generated Œ àâ 12, 1995
***
Function highNpenq
local color:=setcolor(),screen:=savescreen(0,0,24,79),select:=select(),recno:=recno()
select obormot
SET COLOR TO &GetColor
colorwin(3,6,22,78,'n/n')
@ 02,05,21,77 BOX "         "
@ 2,5 say center(alltrim(main->potrebitel),70,' ',.t.)
@ 03,05 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·"
@ 04,05 SAY "³  Œ¥áïæ    ³            ¥­ï             ³          ®¢ëè¥­­ ï         º"
@ 05,05 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶"
@ 06,05 SAY "³ C «ì¤®    ³                             ³                             º"
@ 07,05 SAY "³           ³   ç¨á«¥­®   ³   Ž¯« ç¥­®   ³    ç¨á«¥­®  ³   Ž¯« ç¥­®   º"
@ 08,05 SAY "³ Ÿ­¢ àì    ³              ³              ³              ³              º"
@ 09,05 SAY "³ ”¥à «ì    ³              ³              ³              ³              º"
@ 10,05 SAY "³ Œ àâ      ³              ³              ³              ³              º"
@ 11,05 SAY "³ €¯à¥«ì    ³              ³              ³              ³              º"
@ 12,05 SAY "³ Œ ©       ³              ³              ³              ³              º"
@ 13,05 SAY "³ ˆî­ì      ³              ³              ³              ³              º"
@ 14,05 SAY "³ ˆî«ì      ³              ³              ³              ³              º"
@ 15,05 SAY "³ €¢£ãáâ    ³              ³              ³              ³              º"
@ 16,05 SAY "³ ‘¥­âï¡àì  ³              ³              ³              ³              º"
@ 17,05 SAY "³ Žªâï¡àì   ³              ³              ³              ³              º"
@ 18,05 SAY "³ ®ï¡àì    ³              ³              ³              ³              º"
@ 19,05 SAY "³ „¥ª ¡àì   ³              ³              ³              ³              º"
@ 20,05 SAY "ÔÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
@ 06,23 say SaldoP
@ 06,53 say SaldoH
@ 08,33 say PENQ1
@ 08,63 say HIGH1
@ 09,33 say PENQ2
@ 09,63 say HIGH2
@ 10,33 say PENQ3
@ 10,63 say HIGH3
@ 11,33 say PENQ4
@ 11,63 say HIGH4
@ 12,33 say PENQ5
@ 12,63 say HIGH5
@ 13,33 say PENQ6
@ 13,63 say HIGH6
@ 14,33 say PENQ7
@ 14,63 say HIGH7
@ 15,33 say PENQ8
@ 15,63 say HIGH8
@ 16,33 say PENQ9
@ 16,63 say HIGH9
@ 17,33 say PENQ10
@ 17,63 say HIGH10
@ 18,33 say PENQ11
@ 18,63 say HIGH11
@ 19,33 say PENQ12
@ 19,63 say HIGH12
//if fieldnum('saldop')>0.and.fieldnum('saldoh')>0
//   @ 21,05 say " ¥­ï "+Alltrim(str(saldop))+"  ®¢ëè¥­­ ï "+alltrim(str(saldoh))
//endif

@ 21,05 say "‘ «ì¤® ­  "+dtoc(New_date)+" ¥­ï "+Alltrim(str(GetPenq(Main->Lic_Schet,Month(New_date))))+"  ®¢ëè¥­­ ï "+Alltrim(str(GetHigh(Main->Lic_Schet,Month(New_date))))

set cursor on
set confir on

if reclock()
   do while .t.
        @ 08,18 GET PENQN1
        @ 08,48 GET HIGHN1
        @ 09,18 GET PENQN2
        @ 09,48 GET HIGHN2
        @ 10,18 GET PENQN3
        @ 10,48 GET HIGHN3
        @ 11,18 GET PENQN4
        @ 11,48 GET HIGHN4
        @ 12,18 GET PENQN5
        @ 12,48 GET HIGHN5
        @ 13,18 GET PENQN6
        @ 13,48 GET HIGHN6
        @ 14,18 GET PENQN7
        @ 14,48 GET HIGHN7
        @ 15,18 GET PENQN8
        @ 15,48 GET HIGHN8
        @ 16,18 GET PENQN9
        @ 16,48 GET HIGHN9
        @ 17,18 GET PENQN10
        @ 17,48 GET HIGHN10
        @ 18,18 GET PENQN11
        @ 18,48 GET HIGHN11
        @ 19,18 GET PENQN12
        @ 19,48 GET HIGHN12
        read
        if lastkey()=27
           Clear Typeahead
                exit
        endif
   enddo
   unlock
endif
set curs off
set conf off
select(select)
go recno
setcolor(color)
restscreen(0,0,24,79,screen)
return NIL
