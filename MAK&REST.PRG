/*
        Функции создания и восстановления резервной копии на/с винта
*/

func makecopy
LOCAL DBFfiles[adir(Schet_Share+'*.db*')],rezervdir,i,copylen
adir(Schet_Share+'*.db*',DBFfiles)
IF founddir(schet_disk+'\REZERV.DBF')
        close all
        save screen
        obrabot()
        FOR i=1 to len(DBFfiles)
                copylen=copy_(Schet_Share+DBFfiles[i],schet_disk+'\REZERV.DBF\'+DBFfiles[i])
                if copylen=0
                   exit
                endif
                if inkey()#0
                   if al_box({"Желаете прервать копирование"},2)==1
                      exit
                   endif
                endif
        NEXT
        restore screen
        LoadGos()
ELSE
        Al_Box({"Ошибка поиска директории резервной копии"})
ENDIF
return NIL



func restcopy
private rezervdir,i,copylen,is_oplata:=.F.
is_oplata=al_box({"Восстановить всю информацию"},2,{" Да "," Только оплату "})
is_oplata=if(is_oplata=1,.F.,.T.)
PRIVATE DBFfiles[adir(schet_disk+"\REZERV.DBF\*.db*")]
adir(schet_disk+'\REZERV.DBF\*.db*',DBFfiles)
IF founddir(schet_disk+'\REZERV.DBF')
        IF len(DBFfiles)>0
                close all
                save screen
                obrabot()
                FOR i=1 to len(DBFfiles)
                      if .not.is_oplata
                        copylen=copy_(schet_disk+'\REZERV.DBF\'+DBFfiles[i],Schet_Share+DBFfiles[i])
                      else
                        if val(substr(DBFfiles[i],2,1))#0.or.;
                           alltrim(upper(DBFfiles[i]))="OBORMOT.DBF"
                          copylen=copy_(schet_disk+'\REZERV.DBF\'+DBFfiles[i],Schet_Share+DBFfiles[i])
                        else
                         copylen=1
                        endif
                      endif
                        if copylen=0
                                exit
                        endif
                        if inkey()#0
                           if Al_Box({"Желаете прервать копирование"},2)==1
                              exit
                           endif
                        endif
                NEXT
                restore screen
                if copylen#0
                        do servis2
                else
                        error=.t.
                        wosst=.t.
                        zagruzka=.f.
                endif
        ELSE
                Al_Box({"Резервная копия баз данных на диске не обнаружена"})
        ENDIF
ELSE
        Al_Box({"Ошибка поиска директории резервной копии"})
ENDIF
Return NIL



FUNCTION FoundDir(Directory)
PRIVATE localdir:=diskname()+':'+dirname(),dirpresent:=.F.
//                                              e_rror(Directory)
IF dirchange(Directory)=0
        dirpresent:=.T.
        dirchange(localdir)
ELSE
        IF dirmake(Directory)=0
                dirpresent:=.T.
        ENDIF
        dirchange(localdir)
ENDIF
RETURN dirpresent
