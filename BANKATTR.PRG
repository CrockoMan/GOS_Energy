#include "my.ch"
procedure changebankattribute()
local dir
private path1,path2,path3,path4,path5
dir:=substr(exename(),1,len(exename())-len(token(exename(),'\')))
path1:=dir+'database\#1#2#3'
path2:=dir+'database\#4#5'
path3:=dir+'database\#6#7#8'
path4:=dir+'database\#9#10#11'
path5:=dir+'database\#12'
set default to &path1
if file('licevoj.dbf')
      use licevoj
      bankold=bank
      banknew=bank
      korold=k_schet
      kornew=k_schet
      mfoold=mfo
      mfonew=mfo
      close
      set default to
      set color to w+/b,n/w,,,w+/b
      colorwin(10,13,18,69,"n+/n")
      @ 9,12,17,68 box B_MY
      @ 9,  13 say center(" Изменение реквизитов банка ",55,'─',.t.)
      set color to gr+/b
      @ 11, 14 say "Наименование банка "
      @ 14, 14 say "Корр.счет "
      @ 15, 14 say "МФО"
      @ 16, 14 say "Путь "
      set color to g+/b
      @ 16, 19 say dir
      set color to w+/b,n/w,,,w+/b
      do while .t.
         @ 12, 16    get bankold
         @ 13, 16    get banknew
         @ 14, 28    get korold
         @ 14, 40    get kornew
         @ 15, 28    get mfoold
         @ 15, 40    get mfonew
         read
         if lastkey()==27
            exit
         endif
      enddo
      if al_box({"Изменить реквизиты"},2)==1
      for i=1 to 5
          workbase='path'+alltrim(str(int(i)))
          dirchange(&workbase)
          if file('licevoj.dbf')
             set color to g+/b
             @ 16,19 say &workbase+"\licevoj.dbf      "
             set color to w+/b,n/w,,,w+/b
             use licevoj
             go top
             do while !eof()
                @ 16,27+len(&workbase) say str(recno())
                if upper(charrem(" ",bank))=upper(charrem(" ",bankold))
                   replace bank with banknew
                   replace k_schet with kornew
                   replace mfo with mfonew
                endif
                skip
             enddo
             close
          endif
      next
      endif
else
? "File not found "+path1+'licevoj.dbf'
endif
return NIL
