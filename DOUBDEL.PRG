function double(base)
LOCAL prev:=-1,desc
if base==NIL
   ? "Утилита удаления двойных лицевых в базе данных"
   ? "Первый встретившийся лицевой сохраняется, остальные удаляются"
   ? "Использование: Doubdel Имя_Базы_Данных"
   quit
endif
use &base
index on lic_schet to i
go top
? "Двойные лицевые"
do while !eof()
   if lic_schet=prev
      ? lic_schet
      delete
*      go top
      prev:=-1
   endif
   prev=lic_schet
   skip
enddo
pack
return nil