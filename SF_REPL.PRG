func one
set date german
if .not.netuse("sfkniga.dbf")
   ? "Sfkniga.dbf  Error opening database"
   quit
endif
go top
do while !eof()
   reclock()
   if type>0
      replace month with month(data)
   endif
/*   do case
      case data>=ctod("01.01.97").and.data<=ctod("31.01.97").and.type>0
           replace month with 1
      case data>=ctod("01.02.97").and.data<=ctod("28.02.97").and.type>0
           replace month with 2
      case data>=ctod("01.03.97").and.data<=ctod("31.03.97").and.type>0
           replace month with 3
      case data>=ctod("01.04.97").and.data<=ctod("30.04.97").and.type>0
           replace month with 4
   endcase */
   unlock
   skip
enddo
return NIL