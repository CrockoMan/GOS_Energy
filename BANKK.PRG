*
*   Банк - банкрот (вывод его дебиторов)
*
proc bank
clear
gos="S:\OSE\SHARE\      "
bmfo="700161183  "
month=01
total=0
@ 1,0 say "Путь к программе" get gos
@ 2,0 say "К/счет банка    " get bmfo
//@ 3,0 say "Месяц поиска    " get month
read
if lastkey()=27
   return
endif
@ 5,0 say ""
gos=alltrim(upper(gos))
month=alltrim(str(int(month)))
cmonth="DEBET"+alltrim(month)
desc=fcreate("otchet.gkv")
//fwrite(desc,"Дебиторы месяца N"+month+" к/с "+bmfo+chr(13)+chr(10))
gos_dbf=gos
    if file(gos_dbf+"b1.ntx")
       deletefile(gos_dbf+"b1.ntx")
    endif
    if file(gos_dbf+"b2.ntx")
       deletefile(gos_dbf+"b2.ntx")
    endif
    if file(gos_dbf+"b3.ntx")
       deletefile(gos_dbf+"b3.ntx")
    endif
    base1=gos_dbf+"main.dbf"
    @ 5,0 say "Индексация "+base1
    select 1
    netuse(base1)
    index on lic_schet to b1
    base3=gos_dbf+"licevoj.dbf"
    @ 5,0 say "Индексация "+base3+space(20)
    select 3
    netuse(base3)
    index on lic_sch to b3
    base2=gos_dbf+"obormot.dbf"
    @ 5,0 say "Индексация "+base2+space(20)
    select 2
    netuse(base2)
    index on lic_schet to b2
    go top
    select 1
    go top
    @ 5,0 say space(78)
    do while !eof()
       @ 5,0 say recno()
       M_lic=lic_schet
       m_naim=potrebitel
       select 3
       seek m_lic
       if found()
          if k_schet=bmfo
             select 2
             seek m_lic
             if found()
//                if &cmonth#0
                   fwrite(desc,alltrim(str(m_lic))+" "+M_naim+" "+chr(13)+chr(10))
//                   total=total+&cmonth
//                endif
             endif
          endif
       endif
       select 1
       skip
    enddo
//fwrite(desc,"Общая сумма задолженности "+alltrim(str(total))+chr(13)+chr(10))
fclose(desc)
deletefile(gos_dbf+"b1.ntx")
deletefile(gos_dbf+"b2.ntx")
deletefile(gos_dbf+"b3.ntx")
copy_("otchet.gkv","prn")
deletefile("otchet.gkv")
return