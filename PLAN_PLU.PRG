*schet_plan=0
*schet_bplan=0
*do plan_plus

proc plan_plus
private old_clr,old_scr
old_clr=setcolor()
save screen to old_scr
SET COLOR TO +W/B,w+/bg+,,,w+/b
colorwin(8,25,13,52,'n+/n')
@ 07,23,12,50 BOX "         "
@ 07,23 SAY "旼컴컴컴컴컴컴컴컴컴컴컴컴캠"
@ 08,23 SAY "� 뒶庄十與��� 瑟�エ曄�⑨   �"
@ 09,23 SAY "� �쳽��¡．      �쳽收쬊   �"
@ 10,23 SAY "� 롟��˛��                 �"
@ 11,23 SAY "� 곷�                      �"
@ 12,23 SAY "突袴袴袴袴袴袴袴袴袴袴袴袴暠"
set curs on
set conf on
@ 10,35 get M->schet_plan picture "@K 99.999"
@ 11,35 get M->schet_bplan picture "@K 99.999"
read
set curs off
set conf off
restore screen from old_scr
setcolor(old_clr)
Clear Typeahead
return
