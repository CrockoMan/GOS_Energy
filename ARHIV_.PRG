proc arhiv
private choice,scr,clr
scr=savescreen(17,32,21,72)
clr=setcolor()
SET COLOR TO n/w,n/g
colorwin(18,33,21,72,'n+/n')
@ 17,32 SAY "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캠"
@ 18,32 SAY "�  몼昔� 쩆��音 쭬 ．� � 졷夜�       �"
@ 19,32 SAY "�  궙遜�젺�˙���� 쩆��音 �� 졷夜쥯   �"
@ 20,32 SAY "突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠"
do while .t.
	@ 18,33 prompt "  몼昔� 쩆��音 쭬 ．� � 졷夜�       "
	@ 19,33 prompt "  궙遜�젺�˙���� 쩆��音 �� 졷夜쥯   "
	menu to choice
	do case
		case choice=1
			do NewYear
		case choice=2
		otherwise
*			restscreen(17,32,21,72,scr)
*			setcolor(clr)
			exit
	endcase
enddo
restscreen(17,32,21,72,scr)
setcolor(clr)
return
