func main
base:="d:\gos\alaska\database\pllocal.dbf"
Ind:="d:\gos\alaska\database\pllocal.ntx"
select 1
use (Base) SHARED
index on kod to &Ind
close index
Set index to (Ind)
? "-----------------------------------------------"
Inkey(0)
return nil