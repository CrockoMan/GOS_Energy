function double(base)
LOCAL prev:=-1,desc
if base==NIL
   ? "Утилита поиска двойных лицевых в базе данных"
   ? "Найденные лицевые записываются в файл Double.Txt"
   ? "Использование: Doubdel Имя_Базы_Данных"
   quit
endif
use &base
index on lic_schet to i
go top
desc:=fcreate("double.txt")
? "Двойные лицевые"
fwrite(desc,"Двойные лицевые"+chr(13)+chr(10))
do while !eof()
   if lic_schet=prev
      ? lic_schet
      fwrite(desc,str(lic_schet)+chr(13)+chr(10))
   endif
   prev=lic_schet
   skip
enddo
fclose(desc)
return nil