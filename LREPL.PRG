proc lrepl
use licevoj
go top
do while !eof()
   @ row(),0 say recno()
   do case
      case k_schet='700161289'
           replace mfo with '040304789'
      case k_schet='700161292'
           replace mfo with '040304792'
      case k_schet='700161593'
           replace mfo with '040304793'
      case k_schet='800161736'
           replace mfo with '040304836'
      case k_schet='800161037'
           replace mfo with '040304837'
      case k_schet='800161367'
           replace mfo with '040304867'
      case k_schet='800161095'
           replace mfo with '040304895'
      case k_schet='900161924'
           replace mfo with '040304924'
      case k_schet='600164577'
           replace mfo with '040304677'
      case empty(k_schet)
           replace mfo with '040304000'
   endcase
   skip
enddo
return