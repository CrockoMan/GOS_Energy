? "Утилита изменения кор. счета банка."+chr(13)+chr(10)
? ""
dir=diskname()+':'+dirname()+'\database\'
row=row()
col=col()
old_k_schet=space(11)
new_k_schet=space(11)
@ row,0 say "Изменить кор. счет "
@ row,22 get old_k_schet
@ row,35 say " на "
@ row,40 get new_k_schet
read
? chr(13)+chr(10)
if lastkey()#27
	@ row,0 say "Изменяется кор. счет "+alltrim(old_k_schet)+' на '+alltrim(new_k_schet)
	? chr(13)+chr(10)
	for i=1 to 5
		do case
			case i=1
				database=dir+"#1#2#3\licevoj.dbf"
			case i=2
				database=dir+"#4#5\licevoj.dbf"
			case i=3
				database=dir+"#6#7#8\licevoj.dbf"
			case i=4
				database=dir+"#9#10#11\licevoj.dbf"
			case i=5
				database=dir+"#12\licevoj.dbf"
		endcase
		use &database
		go top
		do while !eof()
			if alltrim(k_schet)=alltrim(old_k_schet)
				replace k_schet with new_k_schet
			endif
			skip
		enddo
		use
	next
else
	@ row,0 say "Кор.счет не изменен."
endif
* ? dir
? chr(13)+chr(10)
