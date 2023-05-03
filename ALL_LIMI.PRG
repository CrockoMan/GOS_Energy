function NewYear
kniga1='#1#2#3\'
kniga2='#4#5\'
kniga3='#6#7#8\'
kniga4='#9#10#11\'
kniga5='#12\'
path:="c:\gos\               "
row=row()
@ row,0 say "Путь к программе" get path
read
if lastkey()=27
        return NIL
endif
path=alltrim(path)
path=if(substr(path,len(path),1)#"\",path+"\database\",path+'database\')
db=path+kniga1+'limit.dbf'
USE &DB SHARED
for i=1 to 5
    if i==1
       copy_(path+kniga1+'limit.dbf','c:\limit.dbf')
       select 0
       use c:\limit.dbf alias one
       go top
    else
         db=path+'kniga'+alltrim(str(int(i)))+'limit.dbf'
         select 0
         use &db alias two
         go top
         do while !eof()
            select one
            append blank
            select two
            replace one->lic_schet with lic_schet
            replace one->jan with jan
            replace one->feb with feb
            replace one->mac with mac
            replace one->apr with apr
            replace one->may with may
            replace one->jun with jun
            replace one->jul with jul
            replace one->aug with aug
            replace one->sep with sep
            replace one->oct with oct
            replace one->nov with nov
            replace one->dec with dec
            skip
         enddo
         use
    endif
next i
return NIL