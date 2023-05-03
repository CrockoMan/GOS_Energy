function first
set date german
set deleted on
base:="S:\OSE\temp\sfkniga.dbf"
ntx:="S:\OSE\temp\sflic.ntx"
desc:=fcreate("text.txt")
prev:=-1
use &base
pack
index on number to &ntx
go top
row:=row()
col:=col()
fwrite(desc," Лиц.счет  Номер              Потребитель        Дата "+chr(13)+chr(10))
do while !eof()
   if type==0
      if number==prev.and.data>=ctod("20.03.97")
         @ row,col say Potrebitel
         fwrite(desc," "+str(number)+" "+str(lic_schet)+" "+potrebitel+" "+dtoc(data)+" "+str(type)+chr(13)+chr(10))
      endif
      prev=number
   endif
   skip
enddo
fclose(desc)
deletefile(ntx)
return NIL
