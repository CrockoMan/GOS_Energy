proc arhiv
private choice,scr,clr
scr=savescreen(17,32,21,72)
clr=setcolor()
SET COLOR TO n/w,n/g
colorwin(18,33,21,72,'n+/n')
@ 17,32 SAY "┌────────────────────────────────────╖"
@ 18,32 SAY "│  Сброс данных за год в архив       ║"
@ 19,32 SAY "│  Восстановление данных из архива   ║"
@ 20,32 SAY "╘════════════════════════════════════╝"
do while .t.
	@ 18,33 prompt "  Сброс данных за год в архив       "
	@ 19,33 prompt "  Восстановление данных из архива   "
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