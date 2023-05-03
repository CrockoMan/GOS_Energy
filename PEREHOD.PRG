function NewYear
kniga1='#1#2#3\'
kniga2='#4#5\'
kniga3='#6#7#8\'
kniga4='#9#10#11\'
kniga5='#12\'
path:="c:\gos\               "
path2:=""
//clear screen
row=row()
@ row,0 say "Путь к программе" get path
read
if lastkey()=27
        return NIL
endif
path=alltrim(path)
path=if(substr(path,len(path),1)#"\",path+"\",path)
@ row,1 say ""
path=path+'database\'
path2:=path+alltrim(str(year(date())-1))+'\'
? "Архивация файлов из "+path+" в "+path2
// dirm(path2)
// dirm(path2+kniga1); copyall(path+kniga1,path2+kniga1)
// dirm(path2+kniga2); copyall(path+kniga2,path2+kniga2)
// dirm(path2+kniga3); copyall(path+kniga3,path2+kniga3)
// dirm(path2+kniga4); copyall(path+kniga4,path2+kniga4)
// dirm(path2+kniga5); copyall(path+kniga5,path2+kniga5)
@ row,1 say ""
? ""
for i=1 to 5
        kniga='kniga'+alltrim(str(int(i)))
        for j=1 to 12                           // Показания счетчиков
                do case
                        case j=1
                                db=path+&kniga+"jan.dbf"
                        case j=2
                                db=path+&kniga+"feb.dbf"
                        case j=3
                                db=path+&kniga+"mar.dbf"
                        case j=4
                                db=path+&kniga+"apr.dbf"
                        case j=5
                                db=path+&kniga+"may.dbf"
                        case j=6
                                db=path+&kniga+"jun.dbf"
                        case j=7
                                db=path+&kniga+"jul.dbf"
                        case j=8
                                db=path+&kniga+"aug.dbf"
                        case j=9
                                db=path+&kniga+"sep.dbf"
                        case j=10
                                db=path+&kniga+"oct.dbf"
                        case j=11
                                db=path+&kniga+"nov.dbf"
                        case j=12
                                db=path+&kniga+"dec.dbf"
                                db2=path+&kniga+"dec_.dbf"
                                copy file &db to &db2
                endcase
                mess(db)
                use &db
                do while !eof()
                        replace pokazaniq with 0
                        replace raznica with 0
                        replace koeficient with 0
                        replace tarif with 0
                        if atnum("ПОТЕРИ",upper(kod))==0
                           replace rashod with 0
                        endif
                        replace summa with 0
                        replace subab with 0
                        skip
                enddo
                use
        next
        db=path+&kniga+"obormot.dbf"
        use &db
        mess(db)
        do while !eof()
                for j=1 to 12
                        replace last_debet with debet12
                        replace last_kred with kredit12
                        field='debet'+alltrim(str(int(j)))
                        replace &field with 0
                        field='kredit'+alltrim(str(int(j)))
                        replace &field with 0
                        field='high'+alltrim(str(int(j)))
                        replace &field with 0
                        field='highn'+alltrim(str(int(j)))
                        replace &field with 0
                        field='penq'+alltrim(str(int(j)))
                        replace &field with 0
                        field='penqn'+alltrim(str(int(j)))
                        replace &field with 0
                next j
                skip
        enddo
        use
        for j=1 to 12
                db=path+&kniga+'o'+alltrim(str(j))
                mess(db)
                use &db
                zap
                use
                db=path+&kniga+'p'+alltrim(str(j))
                mess(db)
                use &db
                zap
                use
                db=path+&kniga+'h'+alltrim(str(j))
                mess(db)
                use &db
                zap
                use
        next
next
return NIL


// Вывод сообщения о очистке базы
function mess(char)
@ row(),0 say space(77)
@ row(),0 say 'Очистка "'+char+'"'
return NIL


// Функция копирования всех файлов каталога
function copyall(path1,path2)
local files[adir(path1+"*.*")],len:=adir(path1+"*.*")
adir(path1+"*.*",files)
for i=1 to len
        copy_(path1+files[i],path2+files[i])
//      al_box({path1+files[i],path2+files[i]})
next
return NIL

function dirm(path)
local ret_val:=0
len=len(path)
path=substr(path,1,len-1)
ret_val=dirmake(path)
return ret_val