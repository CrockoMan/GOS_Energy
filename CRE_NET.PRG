function create_net
LOCAL row,col,col2
set deleted on
files:={}
dir:=diskname()+':'+dirname(diskname())+'\DATABASE\'
netdir:=dir
path1="#1#2#3\"
path2="#6#7#8\"
path3="#12\"
files:=directory(Ddir+path1+"*.dbf")
for i=1 to len(files)
    files[i]:=files[i][1]
    ? "Create file "+netdir+files[i]
    row:=row(); col:=col()
    file1:=dir+path1+files[i]
    file2:=netdir+files[i]
    select 1
    if superload(file1,,,.t.)
       @ row,col say " Упаковка базы дaнных"
       pack
       @ row,col say " Копирование структуры"+space(79-col())
       copy structure to &file2
       @ row,col say " Обновление базы данных "; col2:=col(); ?? space(79-col())
//----------------------------------------------------- Запись базы данных...
       select 1
       close
       for j=1 to 3
           path:="path"+alltrim(str(int(j)))
           file1:=dir+&path+files[i]
           use &file1
           @ row,col say " Упаковка базы дaнных"+space(79-col())
           pack
           @ row,col say " Обновление базы данных "+space(79-col())
           select 2
           use &file2 alias NewBase
           select 1
           go top
           do while !eof()
              select NewBase
              append blank
              select 1
              pos:=1
              do while .t.
                 @ row,col2 say "("+alltrim(str(j))+") "+alltrim(str(recno()*100/reccount(),3,0))+"% "+str(pos,3,0)+" "+str(recno(),4)
                 FName:=Fieldname(pos)
                 IF .not.empty(FName)
                    replace NewBase->&FName with &FName
                 ELSE
                    exit
                 ENDIF
                 pos++
              enddo
             skip
           enddo
           select 2
           close
//----------------------------------------------------- Запись базы данных...
           @ row,col say space(10-(col%10))+"(Ok.)"+space(79-col())
           select 1
           close
       next
    else
           @ row,col say space(10-(col%10))+"(Error)"+chr(7)+space(79-col())
    endif
next
return NIL