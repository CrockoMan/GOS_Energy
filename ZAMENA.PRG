proc zamena_tarifov
save screen
old_color=setcolor()
set color to +w/b,w/bg+,,,+w/b
colorwin(5,2,17,79,'n+/n')
SET COLOR TO N/W,w+/b,,,n/w
@ 04,01,16,78 BOX "         "
@ 04,01 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ‡ ¬¥­  â à¨ä®¢  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·"
@ 05,01 SAY "³"+space(76)+"º"
@ 06,01 SAY "³  ‘â àë©             ®¢ë©             ‘â àë©             ®¢ë©             º"
@ 07,01 SAY "³"+space(76)+"º"
@ 08,01 SAY "³  ‘â àë©             ®¢ë©             ‘â àë©             ®¢ë©             º"
@ 09,01 SAY "³"+space(76)+"º"
@ 10,01 SAY "³  ‘â àë©             ®¢ë©             ‘â àë©             ®¢ë©             º"
@ 11,01 SAY "³"+space(76)+"º"
@ 12,01 SAY "³  ‘â àë©             ®¢ë©             ‘â àë©             ®¢ë©             º"
@ 13,01 SAY "³"+space(76)+"º"
@ 14,01 SAY "³  ‘â àë©             ®¢ë©"+space(50)+"º"
@ 15,01 SAY "³"+space(76)+"º"
@ 16,01 SAY "ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
IF Edit
   Set Color To &GetColor
   set cursor on
   set confirm on
   do while .t.
           @ 06,12 get schet_1old picture "@K 9999.9999"
           @ 06,30 get schet_1new picture "@K 9999.9999"

           @ 06,49 get schet_2old picture "@K 9999.9999"
           @ 06,67 get schet_2new picture "@K 9999.9999"

           @ 08,12 get schet_3old picture "@K 9999.9999"
           @ 08,30 get schet_3new picture "@K 9999.9999"

           @ 08,49 get schet_4old picture "@K 9999.9999"
           @ 08,67 get schet_4new picture "@K 9999.9999"

           @ 10,12 get schet_5old picture "@K 9999.9999"
           @ 10,30 get schet_5new picture "@K 9999.9999"

           @ 10,49 get schet_6old picture "@K 9999.9999"
           @ 10,67 get schet_6new picture "@K 9999.9999"

           @ 12,12 get schet_7old picture "@K 9999.9999"
           @ 12,30 get schet_7new picture "@K 9999.9999"

           @ 12,49 get schet_8old picture "@K 9999.9999"
           @ 12,67 get schet_8new picture "@K 9999.9999"

           @ 14,12 get schet_9old picture "@K 9999.9999"
           @ 14,30 get schet_9new picture "@K 9999.9999"
           read
           if lastkey()=27
              Clear Typeahead
                   exit
           endif
   enddo
   set cursor off
   set confirm off
ELSE
   @ 06,12 say schet_1old picture "@K 9999.9999";   @ 06,30 say schet_1new picture "@K 9999.9999"
   @ 06,49 say schet_2old picture "@K 9999.9999";   @ 06,67 say schet_2new picture "@K 9999.9999"
   @ 08,12 say schet_3old picture "@K 9999.9999";   @ 08,30 say schet_3new picture "@K 9999.9999"
   @ 08,49 say schet_4old picture "@K 9999.9999";   @ 08,67 say schet_4new picture "@K 9999.9999"
   @ 10,12 say schet_5old picture "@K 9999.9999";   @ 10,30 say schet_5new picture "@K 9999.9999"
   @ 10,49 say schet_6old picture "@K 9999.9999";   @ 10,67 say schet_6new picture "@K 9999.9999"
   @ 12,12 say schet_7old picture "@K 9999.9999";   @ 12,30 say schet_7new picture "@K 9999.9999"
   @ 12,49 say schet_8old picture "@K 9999.9999";   @ 12,67 say schet_8new picture "@K 9999.9999"
   @ 14,12 say schet_9old picture "@K 9999.9999";   @ 14,30 say schet_9new picture "@K 9999.9999"
   Inkey(0)
ENDIF
setcolor(old_color)
restore screen
return
