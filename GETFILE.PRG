#include "my.ch"
#include "inkey.ch"
//#include "directry.ch"
//# define B_FILL "╞═╣┬╧"

#ifndef WORKWERSION
func startfunc()
clear screen
set color to 'w+/b,n/g,,,r/w'
//@ 10,0 say GetFile(,,5)
file:=GetFile(,5,'bg+/b,n/g')
@ 0,0 say file
return NIL
#endif


function GetFile(Mask,LenCol,cColor,Posx1,Posy1)
LOCAL Posx2,Posy2,i,j,k,Files,cFile:="",x,y,name,ext,pos,KeyPres,x_,y_,cScr
LOCAL color,tmpclr,maxx,maxy,screen:=win_save(),Files2:={},NoWrite
LOCAL Path:=""
LOCAL FirstFil:=1     //---------------------- Какой файл в начале списка ???
LOCAL CurFil:=1       //---------------------- Какой файл подсвечен ???
LOCAL RefreshWin:=.T. //---------------------- Надо перерисовать окно ???
LOCAL ReReadDir:=.T.  //---------------------- Надо перечитать каталог ???
//-------------------------------------------------- Для массива устройств...
LOCAL Drives:={},Choic:={.t.},CurDir:=1
LOCAL ExitAll:=.F.,PrevDir:=.F.
LOCAL IsCursor:=cSetCurs(),IsScoreBoard:=cSetScor(),SysColor:=setcolor()
cColor:=if(cColor==NIL,setcolor(),cColor)
setcolor(cColor)
color:=setcolor()
DO CASE
   CASE Numdiskf()==2
        Drives:={"     A:","     B:"}
   CASE Numdiskf()==1
        Drives:={"     A:"}
ENDCASE
IF IsCursor
   set cursor off
ENDIF
IF IsScoreBoard
   set scoreboard off
ENDIF
LenCol:=if(LenCol==NIL,int(maxcol()/13),;
        if(LenCol>int(maxcol()/13),int(maxcol()/13),LenCol))
Posx1:=int(if(Posx1==NIL,maxrow()/8,Posx1))
Posy1:=int(if(Posy1==NIL,(maxcol()-1-(13*LenCol))/2,Posy1))
Posx2=maxrow()-Posx1
Posy2:=Posy1+(13*LenCol)
Mask:=MYupper(if(Mask==NIL,"*.*",Mask))
Path:=if(Mask="*.*",diskname()+":"+Dirname()+"\",Mask)
//---------------------------------------------------------- Рисование окошка
colorwin(Posx1+1,Posy1+1,Posx2+1,Posy2+1,"n+/n")
DO WHILE .T.
  IF ReReadDir
     ReReadDir=.F.
     @ Posx1,Posy1,Posx2,Posy2 box B_MY
     @ Posx2-2,Posy1 say substr(B_FILL,1,1)+;
                        replicate(substr(B_FILL,2,1),Posy2-Posy1-1)+;
                        substr(B_FILL,3,1)
//------------------------------------------------------ Рисуем перегородочки
     FOR i=Posx1 TO Posx2-2
         FOR J=Posy1+13 TO Posy2-13 STEP 13
             DO CASE
                CASE i==Posx1
                     @ i,j say substr(B_FILL,4,1)
                CASE i==(Posx2-2)
                     @ i,j say substr(B_FILL,5,1)
                OTHERWISE
                     @ i,j say substr(B_FILL,6,1)
             ENDCASE
         NEXT
     NEXT
     DO WHILE .t.
//------------------------------------------------ Читаем содержимое каталога
        @ Posx2-1,Posy1+1 say MyCenter("Идет чтение каталога",Posy2-Posy1-1,' ')
        Files:=DIRECTORY(Path,"D")
        IF len(Files)==0
           j=Al_Box({'Ошибка чтения содержимого устройства '+Path+"*.*"},3,;
                     {" Повторить "," Выбрать устройство "," Отмена "})
           DO CASE
              CASE j==2
                   IF Len(Drives)=NumDiskf()
                      FOR i=67 to 90
                          IF DiskReady(chr(i)+":")
                             aadd(Drives,"     "+chr(i)+":     ")
                             aadd(Choic,.T.)
                          ENDIF
                      NEXT
                   ENDIF
                   cScr:=win_save()
                   i=vert_menu(Drives,"Устройство",Choic,;
                                      Posx1+int((Posx2-Posx1-len(Drives))/2),;
                                      Posy1+int((Posy2-Posy1-12)/2),;
                                      CurDir,'n/w,n/g,,,r/w',.F.)
                   win_rest(cScr)
                   IF i>0
                      Path:=alltrim(Drives[i])+"\"
                      ReReadDir:=.T.
                      x=Posx1+1
                      y=Posy1+1
                      RefreshWin=.T.
                      CurFil=1
                      FirstFil=1
                      CurDir:=i
                      loop
                   ELSE
                      ExitAll:=.T.
                      cFile=""
                      exit
                   ENDIF
              CASE j==3
                     cFile=""
                     ExitAll:=.T.
                     exit
           ENDCASE
        ELSE
           exit
        ENDIF
     ENDDO
//-------------------------- Выход из всей функции -------vvvvvvvvvvvvvvvvvv
     IF ExitAll
        cFile=""
        exit
     ENDIF
//------------------------ C возвратом пустого файла -----^^^^^^^^^^^^^^^^^^
     @ Posx2-1,Posy1+1 say MyCenter("Сортировка файлов и каталогов",Posy2-Posy1-1,' ')
     FOR i=1 TO LEN(Files)
//--------------------------- Директории большими буквами, файлы - маленькими
      Files[i][1]:=if(Files[i,5]#"D",chr(255)+Lower(Files[i,1]),MYUpper(Files[i,1]))
//---------------------------- Разбор имени и формирование строки а-ля Нортон
         IF alltrim(Files[i][1])!=".".and.alltrim(Files[i][1])!=".."
            pos:=atnum('.',Files[i][1])
            name:=substr(Files[i][1],1,pos-1)
            name:=name+space(if(Files[i,5]#"D",9,8)-len(name))
            ext:=substr(Files[i][1],pos+1)
            ext:=ext+space(3-len(ext))
            Files[i][1]:=ltrim(name+" "+ext)
         ENDIF
         Files[i]:=Files[i][1]
     NEXT
//-- Сoртировка имен файлов и удаление из списка указателя корневого каталога
     Files:=asort(Files)
     IF alltrim(Files[1])=="."
        FOR i=1 TO len(Files)-1
            Files[i]=if(substr(files[i+1],1,1)==chr(255),substr(files[i+1],2),Files[i+1])
            Files[i]=Files[i]+space(12-len(Files[i]))
        NEXT
        asize(Files,len(Files)-1)
     ELSE
        FOR i=1 TO len(Files)
            Files[i]=if(substr(files[i],1,1)==chr(255),substr(files[i],2),Files[i])
            Files[i]=Files[i]+space(12-len(Files[i]))
        NEXT
     ENDIF
//------------------------------------------------------
     PrevDir:=.F.
     FOR i=1 TO LEN(Files)
         IF alltrim(Files[i])=='..'
            PrevDir:=.T.
         ENDIF
     NEXT
     IF PrevDir
        Files2:={}
        IF PrevDir
           AADD(Files2,".."+space(10))
        ENDIF
        FOR i=1 TO len(Files)
            IF alltrim(Files[i])!='.'.and.alltrim(Files[i])!='..'
               AADD(Files2,Files[i])
            ENDIF
        NEXT
        ASize(Files,Len(Files2))
        Files:=AClone(Files2)
     ENDIF
     //---------------------------------------- Вывод списка файлов в колонки
     x=Posx1+1
     y=Posy1+1
     RefreshWin=.t.
  ENDIF
//DO WHILE .T.
   IF RefreshWin
      RefreshWin:=.F.
      x_=Posx1+1
      y_=Posy1+1
      FOR i=FirstFil TO len(Files)
          IF x_>=Posx2-2
             x_=Posx1+1
             y_=y_+13
             if y_>Posy2-12
                exit
             endif
          endif
          maxx:=x_
          maxy:=y_
          @ x_,y_ say Files[i]
          x_++
      NEXT
      setcolor(token(color,',',2))          // Подсветка
      @ x,y say Files[CurFil]               // курсором
      setcolor(color)                       // файла
   ENDIF
//   @ 0,25 say "Color="+color
//   @ 1,25 say "ShowColor="+token(color,',',2)
//   @ 1,0 say "Posx2-3-Posx1="+alltrim(str(Posx2-3-Posx1))+"  "
//   @ 0,0 say "CurFil="+alltrim(str(CurFil))+"   "
//   @ 24,0 say "X="+alltrim(str(maxx))+"  "
//   @ 24,10 say "Y="+alltrim(str(maxy))+"  "
//   @ 23,0 say "FirstFil="+alltrim(str(FirstFil))+"  "
//   @ 23,20 say "Len(Files)"+alltrim(str(len(Files)))+"   "
   cFile:=IF(empty(alltrim(substr(Files[CurFil],10))),alltrim(Files[CurFil]),;
          alltrim(substr(Files[CurFil],1,8))+'.'+alltrim(substr(Files[CurFil],10)))
   @ Posx2-1,Posy1+1 say space(Posy2-Posy1-2)
   @ Posx2-1,Posy1+1 say if(len(Path+cFile)+1<=Posy2-Posy1,;
     Path+cFile,'...'+;
     substr(Path+cFile,len(Path+cFile)+5-(Posy2-Posy1) ))
//---------------------------------------------------- Жду нажатия клавиши...
   KeyPres:=Hot_Inkey(0)
//   KeyPres:=Inkey(0)
   DO CASE
//--------------------------------------------- Клавиша F1 - помощь
      CASE KeyPres==K_F1
           HelpDir(Posx1)
//--------------------------------------------- Клавиша F3 - просмотр файла
      CASE KeyPres==K_F3.and..not.IsDir(Path+cFile).and.;
           alltrim(cFile)!="..".and.alltrim(cFile)!="."
//              TxtView(Path+cFile,,,,,"n/w",31,center('Просмотр файла '+Path+cFile,maxcol(),.t.)," ESC, F10 - Выход")
//----------------------------------------- Клавиша F4 - редактирование файла
      CASE KeyPres==K_F4.and..not.IsDir(Path+cFile).and.;
           alltrim(cFile)!="..".and.alltrim(cFile)!="."
           KEditor(Path+cFile,255)
//----------------------------------------- Клавиша F8 - редактирование файла
      CASE (KeyPres==K_F8.or.KeyPres=K_DEL).and.;
           (.not.IsDir(Path+cFile).and.;
           alltrim(cFile)!="..".and.alltrim(cFile)!=".")
           IF Al_Box({"Удалить файл ",'"'+Path+cFile+'"'},2)==1
              IF deletefile(Path+cFile)=0
                 ReReadDir:=.T.
//                 x=Posx1+1
//                 y=Posy1+1
                 RefreshWin=.T.
                 CurFil:=1
                 FirstFil=1
              ELSE
                 Al_Box({"Ошибка удаления файла",'"'+Path+cFile+'"'})
              ENDIF
           ENDIF
//--------------------------------------------- Клавиша F2 - выбор устройства
      CASE KeyPres==K_F2
           IF Len(Drives)==NumDiskf()
              FOR i=67 to 90
                  IF DiskReady(chr(i))
//                  IF DiskType(chr(i))>0
                     aadd(Drives,"     "+chr(i)+":     ")
                     aadd(Choic,.T.)
                  ENDIF
              NEXT
           ENDIF
           cScr:=win_save()
           i=vert_menu(Drives,"Устройство",Choic,;
                              Posx1+int((Posx2-Posx1-len(Drives))/2),;
                              Posy1+int((Posy2-Posy1-12)/2),;
                              CurDir,'n/w,n/g,,,r/w',.F.)
           win_rest(cScr)
           IF i>0
              Path:=alltrim(Drives[i])+"\"
              ReReadDir:=.T.
              x=Posx1+1
              y=Posy1+1
              RefreshWin=.T.
              CurFil=1
              FirstFil=1
              CurDir:=i
              loop
//           ELSE
//              cFile=""
//              exit
           ENDIF
      CASE KeyPres=K_ESC
           cFile=""
           exit
      CASE KeyPres=K_ENTER
           cFile:=IF(empty(alltrim(substr(Files[CurFil],10))),alltrim(Files[CurFil]),;
                  alltrim(substr(Files[CurFil],1,8))+'.'+alltrim(substr(Files[CurFil],10)))
           DO CASE
              CASE cFile==".."
                   Path:=substr(Path,1,len(Path)-1)
                   Path:=substr(Path,1,atnum("\",Path))
                   ReReadDir:=.T.
                   x=Posx1+1
                   y=Posy1+1
                   RefreshWin=.T.
                   CurFil=1
                   FirstFil=1
              CASE .not.IsDir(Path+cFile)          // выбран файл !!!
                        exit
              CASE IsDir(Path+cFile)               // это каталог
                   Path=Path+cFile+"\"
                   ReReadDir:=.T.
                   x=Posx1+1
                   y=Posy1+1
                   RefreshWin=.T.
                   CurFil=1
                   FirstFil=1
//              OTHERWISE
           ENDCASE
      CASE KeyPres=K_PGUP
           IF CurFil-((LenCol*2)*(Posx2-3-Posx1))+1>0
              CurFil=CurFil-(LenCol*(Posx2-3-Posx1))+1
              FirstFil=if(FirstFil-(LenCol*(Posx2-3-Posx1))+1>1,;
                          FirstFil-(LenCol*(Posx2-3-Posx1))+1,1)
              RefreshWin=.T.
           ELSE
              RefreshWin=.T.
              x=Posx1+1
              y=Posy1+1
              CurFil=1
              FirstFil=1
           ENDIF
      CASE KeyPres=K_PGDN
           IF CurFil+((LenCol*2)*(Posx2-3-Posx1))+1<len(Files)
              CurFil=CurFil+(LenCol*(Posx2-3-Posx1))+1
              FirstFil=if(FirstFil+(LenCol*(Posx2-3-Posx1))+1<len(Files),;
                          FirstFil+(LenCol*(Posx2-3-Posx1))+1,len(Files))
              RefreshWin=.T.
           ELSE
              RefreshWin=.T.
              x=maxx
              y=maxy
              FirstFil=if((len(Files)-(LenCol*(Posx2-3-Posx1))+1)>0,;
                       len(Files)-(LenCol*(Posx2-3-Posx1))+1,1)
              CurFil=len(Files)
           ENDIF
      CASE KeyPres=K_HOME
           x=Posx1+1
           y=Posy1+1
           RefreshWin=.T.
           CurFil=1
           FirstFil=1
      CASE KeyPres=K_END
           RefreshWin=.T.
           x=maxx
           y=maxy
           FirstFil=if((len(Files)-(LenCol*(Posx2-3-Posx1))+1)>0,;
                    len(Files)-(LenCol*(Posx2-3-Posx1))+1,1)
           CurFil=len(Files)
      CASE KeyPres=K_UP
           DO CASE
              CASE CurFil-1>0
                   @ x,y say Files[CurFil]
                   DO CASE
                      CASE x-1>Posx1
                           x--
                      CASE x-1<=Posx2
                           IF y-13>Posy1
                              y=y-13
                              x=Posx2-3
                           ELSE
                              FirstFil--
                              RefreshWin=.T.
                           ENDIF
                   ENDCASE
                   CurFil--
           ENDCASE
      CASE KeyPres=K_DOWN
           DO CASE
              CASE CurFil+1<=Len(Files)
                   @ x,y say Files[CurFil]
                   DO CASE
                      CASE x+1<Posx2-2
                           x++
                      CASE x+1>=Posx2-2
                           IF y+13<=Posy2
                              x=Posx1+1
                              y=y+13
                           ELSE
                              FirstFil++
                              RefreshWin=.T.
                           ENDIF
                   ENDCASE
                   CurFil++
           ENDCASE
      CASE KeyPres=K_LEFT
           DO CASE
              CASE CurFil-(Posx2-3-Posx1)>0
                   @ x,y say Files[CurFil]
                   IF y-13>Posy1
                      y=y-13
                   ELSE
                      FirstFil=if(FirstFil-15>1,;
                               FirstFil-15,1)
                      RefreshWin=.T.
                   ENDIF
                   CurFil=CurFil-(Posx2-3-Posx1)
              OTHERWISE
                   @ x,y say Files[CurFil]
                   x=Posx1+1
                   y=Posy1+1
                   CurFil=1
                   FirstFil=1
                   RefreshWin=.T.
           ENDCASE
      CASE KeyPres=K_RIGHT
           DO CASE
              CASE CurFil+(Posx2-3-Posx1)<=Len(Files)
                   @ x,y say Files[CurFil]
                   IF y+13<Posy2
                         y=y+13
                   ELSE
                      FirstFil=if((FirstFil+15)<(len(Files)-(LenCol*(Posx2-3-Posx1))+1),;
                               FirstFil+15,len(Files))
                        RefreshWin=.T.
                   ENDIF
                   CurFil=CurFil+(Posx2-3-Posx1)
              OTHERWISE
                      @ x,y say Files[CurFil]
                      x=maxx
                      y=maxy
//                      x=Posx1+15
//                      y=Posy2-12
                      CurFil=Len(Files)
                      FirstFil=CurFil-(LenCol*(Posx2-3-Posx1))+1
                      FirstFil=if(FirstFil>0,FirstFil,1)
                      RefreshWin=.T.
           ENDCASE
           IF FirstFIl>CurFil
              x=maxx
              y=maxy
              FirstFil:=CurFil-(LenCol*(Posx2-3-Posx1))+1
              FirstFil:=IF(FirstFil>0,FirstFil,1)
              CurFil=Len(Files)
           ENDIF
   ENDCASE
//------------------------------------- Подсветка курсором текущего файла
   setcolor(token(color,',',2))
   @ x,y say Files[CurFil]
   setcolor(color)
ENDDO
IF IsCursor
   set cursor on
ENDIF
IF IsScoreBoard
   set scoreboard on
ENDIF
setcolor(SysColor)
win_rest(screen)
return if(!empty(cFile),Path+cFile,cFile)


//-------------------------- Функция проверки имени на файл или директорию...
FUNCTION IsDir(cFile)
RETURN IF(FileAttr(cFile)==16,.T.,.F.)

//------------------------- Центрирование строки
STATIC FUNCTION MyCenter(cString,len,char)
IF len(cString)<=len
   cString:=center(cString,len,char)
ELSE
   cString:=center(substr(cString,1,len),len,char)
ENDIF
RETURN cString


STATIC Function HelpDir()
LOCAL scr:=win_save(),clr:=setcolor(),Posx1:=int((maxrow()-10)/2)
set color to n/w
set cursor off
colorwin(Posx1+1,4,Posx1+10,76,"n+/n")
//@ Posx1,03,Posx1+8,75 BOX B_MY
@ Posx1,03 SAY "┌────────────────── Поддерживаются следующие клавиши ───────────────────┐"
@ Posx1+1,03 SAY "│"+space(71)+"│"
@ Posx1+2,03 SAY "│   F1 - Помощь                       F5 -                              │"
@ Posx1+3,03 SAY "│   F2 - Изменить устройство          F6 -                              │"
@ Posx1+4,03 SAY "│   F3 - Просмотреть файл             F7 -                              │"
@ Posx1+5,03 SAY "│   F4 - Редактировать файл           F8 - Удалить файл                 │"
@ Posx1+6,03 SAY "│"+space(71)+"│"
@ Posx1+7,03 SAY "├───────────────────────────────────────────────────────────────────────┤"
@ Posx1+8,03 SAY "│   ESC - Выход                       Enter - Выбрать файл              │"
@ Posx1+9,03 SAY "└───────────────────────────────────────────────────────────────────────┘"
hot_inkey(0)
setcolor(clr)
win_rest(scr)
RETURN NIL
