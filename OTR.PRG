proc otr
local dbf:="s:\ose\share\otrasl.dbf"
if netuse(dbf)
   go top
   set device to print
   set print on
   do while !eof()
      ? kod_otr
      ?? " |"
      ?? otrasl
      skip
   enddo
   set print off
   set device to screen
   use
endif
return