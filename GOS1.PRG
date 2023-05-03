***
*** GOS1 : format file
*** Generated Март 13, 1994
*** No_Intro Быстрая загрузка программы
*** NoDisp   При индексации не показывать картинку индексации (в процентах)
***
#include "Gra.ch"
#include "Xbp.ch"
#include "Common.ch"
#include "Dbedit.ch"
#include "Inkey.ch"
#include "Appevent.ch"
#include "sqlcmd.ch" 

#include "Odbcdbe.ch" 



PROCEDURE DbeSys 

	 IF ! DbeLoad( "ODBCDBE" )
      Alert( "Database engine ODBC not loaded" , {"OK"} )
	 ENDIF
   
   IF ! DbeLoad( "DBFDBE", .T.)
      Alert( "Database engine DBFDBE not loaded" , {"OK"} )
   ENDIF

   IF ! DbeLoad( "NTXDBE",.T.)
      Alert( "Database-Engine NTXDBE not loaded" , {"OK"} )
   ENDIF

   IF ! DbeBuild( "DBFNTX", "DBFDBE", "NTXDBE" )
      Alert( "DBFNTX Database-Engine;is not created" , {"OK"} )
   ENDIF

//   DbeLoad( "ODBCDBE" ) 
//   DbeSetDefault( "ODBCDBE" ) 
   DbeSetDefault( "DBFNTX" ) 
RETURN 




PROCEDURE Main
Local nEvent
LOCAL oMgr 






MainOrder:=1
oDlg := SetAppWindow()
oMainWindow:=oDlg
//oDlg:icon:="ICON1"
oDlg:setTitle("АРМ Госсектор")


oDlg:close    := {|| AppQuit() }
//--------------------------------------------------------------------------------
 
//Set Collation To System
Set Collation To ASCII
SetMouse(.T.)
SET CENTURY ON
SET EPOCH TO 1999
#ifdef WORKWERSION  && Если рабочая версия программы, Alt-C и Ctrl-C выключены.
//        setcancel(.F.)
//#else
//      setcancel(.T.)
#endif
prot=''
param Prot,Prot2
Prot:=IF(Prot==NIL,"",Prot)
Prot2:=IF(Prot2==NIL,"",Prot2)
SAVER:=900              // Секунды до включения хранителя экрана
RunSaver:=.T.           // Фишка возможности включения хранителя
// Режим печати Condensed/Normal для Epson
PRN_COND:=chr(15)       // Portrait
PRN_NORM:=chr(18)       // Landscape
GETCOLOR:="n/w,n/g,,,n/w"
maxrowstart:=maxrow()+1
maxcolstart:=maxcol()+1
IF MaxRowStart-1>24
        IF Al_Box({"Ваш  монитор  сейчас  работает  в  режиме "+alltrim(str(maxcol()+1))+'x'+alltrim(str(maxrow()+1)),;
                   "Хотя можно успешно работать и в этом режиме, но",;
                   "cтандартный  режим  работы  монитора  =>  80x25",;
                   "И все таки:  B каком  режиме  будем  работать ?"},2,;
                {" "+alltrim(str(maxcol()+1))+'x'+alltrim(str(maxrow()+1))+" "," 80x25 "},;
                ,,,,,,"gr+/r+,w/b+,,,gr/r+")=2
                IF .not.setmode(25,80)
                        al_box({"Ошибка переключения режима работы монитора"})
                ENDIF
        ENDIF
ENDIF
public urov,kl,filtr,stile_,_rec,_file,stand_sim,schet_,;
        month_,wosst,edit,schet_treb,schet_,schet_nds,schet_penq,schet_osnov,;
        schet_poluch,schet_bank1,schet_naz1,schet_naz2,schet_naz3,schet_ban2,;
        schet_rsch,schet_ksch,schet_town,schet_disk,schet_reestr,rec88,;
        schet_Adisk:="A:",schet_tar1,schet_tar2,schet_tar3,schet_tar4,schet_tar5,;
        schet_tar6,schet_tar7,schet_tar8,schet_tar9,schet_1old,schet_2old,;
        schet_3old,schet_4old,schet_5old,schet_6old,schet_7old,schet_8old,;
        schet_9old,schet_1new,schet_2new,schet_3new,schet_4new,schet_5new,;
        schet_6new,schet_7new,schet_8new,schet_9new,filedit,schet_nl1,;
        schet_nl2,schet_nl3,schet_nl4,schet_nl5,schet_nl6,schet_nl7,;
        schet_nl8,schet_nl9,schet_nl10,schet_nl11,schet_nl12,schet_nl13,;
        schet_nl14,schet_nl15,schet_nl16,schet_nl17,schet_nl18,schet_sdisk,;
        schet_tdisk,schet_tl1,schet_tl2,schet_tl3,CrCode,schet_tl4,schet_tl5,;
        schet_tl6,schet_tl7,schet_tl8,schet_tl9, schet_share,schet_norm,;
        schet_cond,ShowOnly:=NIL,cSearch:="",FiftyDays:=NIL,NamePotrebitel,;
        HighKoeff:=NIL,InnPotrebitel:="",MyPlanKoeff,Schet_Chastn:=NIL,cNameBoss,cNameBuh
schet_sdisk:=diskname()+':'+dirname(diskname())+"\DATABASE\"




schet_tdisk:=schet_sdisk
filedit=diskname()+':'+dirname(diskname())+'\TEXT`S\Noname.txt'
textdir:=diskname()+':'+dirname()+'\TEXT`S\'
//ReadConfigFile()
schet_share:="s:\ose\share\"
Ddir:=schet_sdisk
is_arhiv=.f.
urov=0
wosst=.f.
MyPassword:="NIL"
eg=0
es=0
edit=.f.
schet_norm:=chr(18)
schet_cond:=chr(15)
MaxRashod:=NIL
MaxRashSum:=NIL
Decimal:=NIL
LenBank:=NIL
NetPrint:=NIL
NetPort:=NIL
NetFont:=NIL
NetPortr=NIL
NetLand=NIL
NetCondens=NIL
NetNormal=NIL
PrintPort=NIL
ReportFile:=NIL
FontFile:=NIL
Station:=NIL
AskPort:=NIL
SectorBuff:=NIL
Rec88:=NIL
LimPererashod:=NIL
LimNedorashod:=NIL
OtherTar1:=NIL
MyPlanKoeff:=NIL
PrStrHigh:=NIL
PrCharHigh:=NIL
PrCharWidth:=NIL
PrFontName:=NIL
NameBoss:=Nil
NameBuh:=Nil
SchetNameOrg:=NIL
SchetInn:=NIL
SchetKPP:=NIL
SchetAdr:=NIL
SchetRS:=NIL
SchetKS:=NIL
SchetBIK:=NIL	
cNameBoss:=NIL	
cNameBuh:=NIL	





setpos(maxrow()-4,0)
set date german
setcursor(2,7,.t.)
set scoreboard off
IF MYUpper(AllTrim(Prot))=="DELETED".or.MYUpper(AllTrim(Prot2))=="DELETED"
   set deleted off
ELSE
   set deleted on
ENDIF
set confirm on
set cursor off
set decimals to 2
schet_grugu=0
loaddir=substr(exename(),1,len(exename())-1-len('arm.exe'))
quitdir=diskname()+':'+dirname()
if len(quitdir)=2
   quitdir=quitdir+"\"
endif

dirchange(substr(loaddir,1,3))
dirchange(loaddir)
***************************************** <=
IF MYUpper(Prot)!="NO_INTRO"
   clear screen
//   ClearToMid(10)
//   presentation()
ENDIF

screenfile(Ddir+'screen.gkv')
set color to w+/b
clear screen
SET COLOR TO N/W
set cursor off
@ 00,00 SAY ""+space(80)+""
//@ 24,00 SAY ""+space(80)+""
@ maxrow(),00 SAY space(80)
if prot='Архив'
   @ maxrow(),1 say "Архивная информация"
endif
@ maxrow(),59 SAY '│   АРМ "Госсектор"  '
//@ 00,59 SAY "│ Die Hard 2:5063/37 "
@ 00,59 SAY '│ (c) Lexx ltd. 2004'
devout("")
@ maxrow(),59 SAY '│   АРМ "Госсектор"  '
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Подготовка к работе..."
//------------------------------------- Отрисовка экрана
knig_menu:={    {" Отпуск электроэнергии       ",{||level1a(1)} },;
                {" Прием электроэнергии        ",{||level1a(2)} }  }
arch_menu:={    {" Запись в архив           ",{||level1b(1)} },;
                {" Чтение из архива         ",{||level1b(2)} }  }
util_menu:={    {" Платежка                  ",{||level1c(1)}  },;
                {" Текстовый редактор        ",;
        {       {" Редактировать             ",;
           {    {" Машинописная страница     ",{||myeditor(11)}},;
                {" Широкая страница          ",{||myeditor(12)}}  }},;
                {" Выбрать                   ",{||myeditor(2)}},;
                {" Удалить                   ",{||myeditor(3)}},;
                {" Готовые тексты            ",{||myeditor(4)}} }        },;
                {" Настройка на пользователя ",{||level1c(3)}  },;
                {" Диспетчер файлов          ",{||GetFile(,5,'bg+/b,n/g')}},;
                {" Временный выход в DOS     ",{||level1c(2)}  }  }
//                {" Форматирование диска "+schet_Adisk,{||DF(schet_Adisk)}},;
main_menu:={    {" Вид расчетов ",     knig_menu },;
                {" Работа с архивом ",arch_menu },;
                {" Утилиты ",         util_menu },;
                {" Выход ",{||exittodos()}      }}

//------------------------------------- Чтение конфигурационного файла
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Чтение конфигурации..."
ReadCfg(Ddir+"Config.arm")               // Чтение конфигурации
IF PrStrHigh==NIL
   DIRECTMEMW(DDir+"Config.arm","PrStrHigh=",48)
   PrStrHigh:=48
ENDIF
IF cNameBoss==NIL
   DIRECTMEMW(DDir+"Config.arm","cNameBoss=","Нач.ОСЭ          ")
   cNameBoss:="Нач.ОСЭ          "
ENDIF
IF cNameBuh==NIL
   DIRECTMEMW(DDir+"Config.arm","cNameBuh=","Экономист ОСЭ     ")
   cNameBuh:="Экономист ОСЭ     "
ENDIF
IF NameBoss==NIL
   DIRECTMEMW(DDir+"Config.arm","NameBoss=","Бесплеменов В.А. ")
   NameBoss:="Бесплеменов В.А."
ENDIF
IF NameBuh==NIL
   DIRECTMEMW(DDir+"Config.arm","NameBuh=", "Цырянова И.Р.    ")
   NameBuh:="Цырянова И.Р."
ENDIF
IF PrCharHigh==NIL
   DIRECTMEMW(DDir+"Config.arm","PrCharHigh=",28)
   PrCharHigh:=28
ENDIF
IF PrCharWidth==NIL
   DIRECTMEMW(DDir+"Config.arm","PrCharWidth=",20)
   PrCharWidth:=20
ENDIF
IF SchetAdr==NIL
   DIRECTMEMW(DDir+"Config.arm","SchetAdr=","353440, Краснодарский край, Анапа г, Лермонтова ул, д. 117")
   SchetAdr:="353440, Краснодарский край, Анапа г, Лермонтова ул, д. 117"
ENDIF
IF PrFontName==NIL
   DIRECTMEMW(DDir+"Config.arm","PrFontName=","Lucida Console")
   PrFontName:="Lucida Console"
ENDIF
IF HighKoeff==NIL
   DIRECTMEMW(DDir+"Config.arm","HighKoeff=",2)
   HighKoeff:=2
ENDIF
IF Schet_Chastn==NIL
   DIRECTMEMW(DDir+"Config.arm","Schet_Chastn=",'S:\Chastn\AnapaPn3\global\')
   Schet_Chastn:='S:\Chastn\AnapaPn3\global\'
ENDIF
IF MyPlanKoeff==NIL
   DIRECTMEMW(DDir+"Config.arm","MyPlanKoeff=",1)
   MyPlanKoeff:=1
ENDIF
IF FiftyDays==NIL
   DIRECTMEMW(DDir+"Config.arm","FiftyDays=",0.5)
   FiftyDays:=0.5
ENDIF
IF LimPererashod==NIL
   DIRECTMEMW(DDir+"Config.arm","LimPererashod=",1.43)
   LimPererashod:=1.43
ENDIF
IF OtherTar1==NIL
   DIRECTMEMW(DDir+"Config.arm","OtherTar1=",0.60)
   OtherTar1:=0.60
ENDIF
IF LimNedorashod==NIL
   DIRECTMEMW(DDir+"Config.arm","LimNedorashod=",0.09)
   LimNedorashod:=0.09
ENDIF
IF Rec88==NIL
   DIRECTMEMW(DDir+"Config.arm","Rec88=",0)
   Rec88:=0
ENDIF
IF AskPort==NIL
   DIRECTMEMW(DDir+"Config.arm","AskPort=",.T.)
   AskPort:=.T.
ENDIF
IF SectorBuff==NIL
   DIRECTMEMW(DDir+"Config.arm","SectorBuff=",2)
   SectorBuff:=2
ENDIF
IF FontFile==NIL
   DIRECTMEMW(DDir+"Config.arm","FontFile=",Schet_SDisk+"DieHard.Fnt")
   ReportFile:="Otchet.Gkv"
ENDIF
IF SchetINN==NIL
   DIRECTMEMW(DDir+"Config.arm","SchetInn=","2308091759")
   SchetInn:="2308091759"
ENDIF
IF SchetKPP==NIL
   DIRECTMEMW(DDir+"Config.arm","SchetKpp=","230801001")
   SchetKpp:="230801001"
ENDIF
IF SchetRS==NIL
   DIRECTMEMW(DDir+"Config.arm","SchetRS=","40702810900000003933")
   SchetRS:="40702810900000003933"
ENDIF
IF SchetKS==NIL
   DIRECTMEMW(DDir+"Config.arm","SchetKS=","30101810500000000793")
   SchetKS:="30101810500000000793"
ENDIF
IF SchetBIK==NIL	
   DIRECTMEMW(DDir+"Config.arm","SchetBIK=","040304793")
   SchetBIK:="040304793"
ENDIF

IF SchetNameOrg==NIL
   DIRECTMEMW(DDir+"Config.arm","SchetNameOrg=",'ФИЛИАЛ ОАО "НЭСК" "АНАПСКИЕ ГЭС"')
   SchetNameOrg:='ФИЛИАЛ ОАО "НЭСК" "АНАПСКИЕ ГЭС"'
ENDIF
IF LenBank==NIL
   DIRECTMEMW(DDir+"Config.arm","LenBank=",64)
   LenBank:=64
ELSE
   IF LenBank!=64
      DIRECTMEMW(DDir+"Config.arm","LenBank=",64)
      LenBank=64
   ENDIF
ENDIF
IF ReportFile==NIL
   DIRECTMEMW(DDir+"Config.arm","ReportFile=","Otchet.Gkv")
   ReportFile:="Otchet.Gkv"
ENDIF
IF PrintPort==NIL
   DIRECTMEMW(DDir+"Config.arm","PrintPort=","LPT1")
   PrintPort:="LPT1"
ENDIF
IF NetPortr==NIL
   DIRECTMEMW(DDir+"Config.arm","NetPortr=","&l0O")
   NetPortr="&l0O"
ENDIF
IF Station==NIL
   Station:=Alltrim(GetVal("Введите ваше имя   ",Space(20),""))
   DIRECTMEMW(DDir+"Config.arm","Station=",Station)
ENDIF
IF NetLand==NIL
   DIRECTMEMW(DDir+"Config.arm","NetLand=","&l26A&l1O")
   NetLand="&l26A&l1O"
ENDIF
IF NetCondens==NIL
   DIRECTMEMW(DDir+"Config.arm","NetCondens=","&k4S")
   NetCondens="&k4S"
ENDIF
IF NetNormal==NIL
   DIRECTMEMW(DDir+"Config.arm","NetNormal=","&k0S")
   NetNormal="&k0S"
ENDIF
IF NetPrint==NIL                                    // Очередь сетевой печати
   DIRECTMEMW(DDir+"Config.arm","NetPrint=","Stack1")
   NetPrint="Stack1"
ENDIF
IF NetPort==NIL                                  // Номер порта поддержки
   DIRECTMEMW(DDir+"Config.arm","NetPort=",2)     // сетевой печати
   NetPort=2
ENDIF
IF Decimal==NIL
   DIRECTMEMW(DDir+"Config.arm","Decimal=",   0)
   Decimal=0
ENDIF
IF MaxRashod==NIL
   DIRECTMEMW(DDir+"Config.arm","MaxRashod=",2)
   MaxRashod=2
ENDIF
IF MaxRashSum==NIL
   DIRECTMEMW(DDir+"Config.arm","MaxRashSum=",13600)
   MaxRashSum=13600
ENDIF
IF ShowOnly==NIL
   DIRECTMEMW(DDir+"Config.arm","ShowOnly=",.F.)
   ShowOnly:=.F.
ENDIF


//--------------------------------------------------------------------
//ReadBank()
//--------------------------------------------------------------------




//----------------------------------------------------------------- <=
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Проверка версии операционной системы..."
IF val(alltrim(osver()))<3.3
        ? ""
        set color to bg+/r+
        sayrandom("Работа с установленной операционной системой невозможна.",maxrow(),0)
        set color to
        ? ''
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        setmode(maxrowstart,maxcolstart)
        filescreen(schet_sdisk+'screen.gkv')
        deletefile(schet_sdisk+'screen.gkv')
        release all
        quit
ENDIF
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Проверка совместимости компьютера..."
IF .NOT.isat()
        ? ""
        set color to bg+/r+
        sayrandom("Данная станция не является IBM AT, продолжение работы невозможно !",maxrow(),0)
        set color to
        ? ''
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        setmode(maxrowstart,maxcolstart)
        filescreen(schet_sdisk+'screen.gkv')
        deletefile(schet_sdisk+'screen.gkv')
        release all
        quit
ENDIF
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Проверка системных ресурсов..."
i_i=.t.
IF pcount()=0
//        i_i=protect(2)
ELSE
        IF prot=chr(107)+chr(111)+chr(115)+chr(38)+chr(105)+chr(110)+chr(115)+chr(116)+chr(97)+chr(108)+chr(108)
//           i_i=protect(1)
        ELSE
//          i_i=protect(2)
        ENDIF
ENDIF
IF alltrim(MYupper(prot))!="NO_INTRO".and.volserial()!=5634.and..not.File("c:\windows\win.386")
   if i_i=.f.
      dirchange(substr(quitdir,1,3))
      dirchange(quitdir)
      al_box({"Ошибка распределения памяти"})
//      do wizitka
//      set key 28 to
      dirchange(substr(quitdir,1,3))
      dirchange(quitdir)
      setmode(maxrowstart,maxcolstart)
      filescreen(schet_sdisk+'screen.gkv')
      deletefile(schet_sdisk+'screen.gkv')
      release all
      quit
   endif
endif
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Проверка свободного дискового пространства..."
if diskfree(diskname())<5000000
        al_box({"   В Н И М А Н И Е !",;
                "Для работы программы необходимо увеличить свободное",;
                "пространство диска "+diskname()+': на '+alltrim(str(5000000-diskfree(diskname())))+' байт. Удалите ненужную',;
                "информацию и запустите программу еще раз."},1,;
                ,,,,,,,"gr+/r,w+/r,,,gr+/r")
        close all
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        setmode(maxrowstart,maxcolstart)
        filescreen(schet_sdisk+'screen.gkv')
        deletefile(schet_sdisk+'screen.gkv')
        release all
        quit
endif
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Проверка существующих директорий..."
if dirchange(substr(Ddir,1,len(Ddir)-1))#0
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        setmode(maxrowstart,maxcolstart)
endif
dirchange(substr(Ddir,1,len(Ddir)-10))
if dirchange(substr(Ddir,1,len(dDir)-9)+'TEXT`S')#0
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        setmode(maxrowstart,maxcolstart)
endif
dirchange(substr(Ddir,1,len(Ddir)-10))
set path to &Ddir
set default to &Ddir
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Установка системной даты..."
//screenfile(DDir+'screen.gkv')
old_date=date()
new_date=if(prot#'Архив',date(),ctod('30.12.'+alltrim(str(year(date())-1))))
save screen

set color to  /bg
//saycenter( "┌──────────────────────┐",09,09,if(UPPER(Prot)=="NO_INTRO",.F.,.T.))
//saycenter( "│                      │",10,10,if(UPPER(Prot)=="NO_INTRO",.F.,.T.))
//saycenter( "│    Текущая  дата     │",11,11,if(UPPER(Prot)=="NO_INTRO",.F.,.T.))
//saycenter( "│                      │",12,12,if(UPPER(Prot)=="NO_INTRO",.F.,.T.))
//sayrandom(substr( dtoc(new_date),1,len(dtoc(new_date))-1),12,34,'n/w')
//saycenter( "│                      │",13,13,if(UPPER(Prot)=="NO_INTRO",.F.,.T.))
//saycenter( "└──────────────────────┘",14,14,if(UPPER(Prot)=="NO_INTRO",.F.,.T.))
saycenter( "┌──────────────────────┐",09,09,.f.)
saycenter( "│                      │",10,10,.f.)
saycenter( "│    Текущая  дата     │",11,11,.f.)
saycenter( "│                      │",12,12,.f.)
sayrandom(substr( dtoc(new_date),1,len(dtoc(new_date))-1),12,34,'n/w')
saycenter( "│                      │",13,13,.f.)
saycenter( "└──────────────────────┘",14,14,.f.)
set conf on
set curs on
@ 12,34 get new_date picture "@K D"
read
set conf off
set curs off
Clear Typeahead
//wclo(9,25,14,50)
restore screen
set color to n/w
if lastkey()=27
//        setdate(old_date,.t.)
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        commit
        close all
        setmode(maxrowstart,maxcolstart)
        set color to
        filescreen(schet_sdisk+'screen.gkv')
        deletefile(schet_sdisk+'screen.gkv')
        quit
endif

//if .not.setdate(new_date,.t.)
//   Al_Box({"Ошибка установки системной даты"})
//endif


/* -----------------------------------------------------------------------------
=       Если клавиши на клавиатуре не нажимаются, то через 300 сек.
=       после нажатия последней клавиши включится хранитель экрана
----------------------------------------------------------------------------- */
DeleteFile(Schet_Share+"Semafore.smf")

Set Key 406 To PrintWorkScreen
//set key 255 to time_out
//keysec(255,SAVER,-1,.t.)


******************************************************************************
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Поиск сервера или активной сети..."
//IF NetWork()
//   IF .not.NNetLogged()
//      IF AL_BOX({"Регистрация в сети не была произведена"},2,{" Перезагрузить "," Продолжить "})==1
//         filescreen(schet_sdisk+'screen.gkv')
//         deletefile(schet_sdisk+'screen.gkv')
//         BOOTCOLD()
//      ENDIF
//   ENDIF
//ELSE
//   IF AL_BOX({"Сеть не найдена, активные серверы не определены"},2,{" Продолжить работу "," Закончить "})==2
//      filescreen(schet_sdisk+'screen.gkv')
//      deletefile(schet_sdisk+'screen.gkv')
//      Quit
//   ENDIF
//ENDIF

//DO While .t.
//   IF .not.File(Schet_Share+"Main.Dbf")
//
//   ENDIF
//ENDDO


IF .not.File(diskname()+':'+dirname(diskname())+"\Arm32.dll")
ENDIF


//-----------------------------------------------------
IF AllTrim(Station)=="123"
   Station:="Катерина"
   DIRECTMEMW(DDir+"Config.arm","Station=",Station)
ENDIF
IF Empty(Alltrim(Station))
   DO While Empty(Alltrim(Station))
      Station:=Alltrim(GetVal("Введите ваше имя   ",Space(20),""))
   ENDDO
   DIRECTMEMW(DDir+"Config.arm","Station=",Station)
ENDIF
@ maxrow(),0 SAY space(58)
@ MaxRow(),1 say "Инициализация пользовательского режима..."
if alltrim(MYupper(prot))!="NO_INTRO".and.volserial()!=5634
   oscr:=win_save()
   SET COLOR TO &GetColor
   colorwin(12,24,14,57,"n+/n")
   @ 11,23,13,56 BOX "         "
   @ 11,23 SAY "┌────────────────────────────────╖"
   @ 12,23 SAY "│ Введите пароль                 ║"
   @ 13,23 SAY "╘════════════════════════════════╝"
   set cursor on
   set confirm on
   IF MyPassword=="NIL"
      MyPassword:=Space(10)
      @ 11,23 Say "┌───── Ваш пароль не найден ─────╖"
      @ 12,42 Get MyPassword
      READ
      Clear Typeahead
      Edit:=.T.
      DIRECTMEMW(DDir+"Config.arm","MyPassword=",Crypt(Mypassword,"(c)DieHard"))
      MyPassword:=Crypt(MyPassword,"(c)DieHard")
   ELSE
      @ 11,23 SAY "┌──── Введите личный пароль ─────╖"
      tmppass:=space(10)
      @ 12,42 say ""
      tmppass:=getsecret(space(10))
      tmppass:=crypt(tmppass,"(c)DieHard")
      edit=if(alltrim(tmppass)==alltrim(MyPassword),.t.,.f.)
   ENDIF
   set cursor off
   set confirm off
   SET COLOR TO N/W
   IF .not.Edit
      al_box({"Режим редактирования "+if(edit,"включен","отключен")},,,,,,,,,if(.not.edit,"gr+/r+,w/b+,,,gr/r+",NIL))
   ENDIF
   win_rest(oscr)
else
   Edit=.T.
endif
IF ShowOnly
   Edit:=.F.
ENDIF
//---------------------------------------- Основное тело для вызова функций
SET COLOR TO N/W
CrCode:="DieHard 8121972"
set cursor off
@ 00,00 SAY ""+space(80)+""
//@ 24,00 SAY ""+space(80)+""
@ maxrow(),00 SAY space(80)
if prot='Архив'
        @ maxrow(),1 say "Архивная информация"
endif
oDlg:setTitle(AllTrim(SchetNameOrg))
IF .Not.Edit
   Set Color To N/W
   @ maxrow(),59 SAY '│АРМ "Госсектор" Demo'
   @ 00,59 SAY "│Die Hard 2:5063/37.0"
   @ 00,59 SAY '│ (c) Lexx ltd. 2004'
ELSE
   @ maxrow(),59 SAY '│   АРМ "Госсектор"  '
   @ 00,59 SAY "│ Die Hard 2:5063/37 "
   @ 00,59 SAY '│ (c) Lexx ltd. 2004'
   @ maxrow(),59 SAY '│'+SchetNameOrg
EndIf
devout("")
keyboard chr(13)
do_menu(main_menu,,,,,,,58)
return


function exittodos
//IF Alert( 'Вы действиетльно хотите закончить работу с программой'   ,  {" Угу "," Нет"} ) ==1
if al_box({"Bы действительно хотите","закончить работу ?"},2,{" Угу "," Нет "})==1
//        keysec()
        Set Key 406 To
        set key 255 to
//        setdate(old_date,.t.)
//      colorwin(24,0,24,0,'n/n')
//      colorwin(23,2,23,15,'b/b')
        close all
        showtime()
//        wope(0,0,maxrow(),maxcol(),'b+/b+','bg+/bg+')
//        wclo(0,0,maxrow(),maxcol(),'w/n')
        filescreen(schet_sdisk+'screen.gkv')
        deletefile(schet_sdisk+'screen.gkv')
        filedelete(DDir+"*.ntx")
//        filedelete(DDir+"*.bak")
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
//      setscrmode(scr_mode)
        setmode(maxrowstart,maxcolstart)
        release all
        quit
endif
return NIL



STATIC function level1c(menuparam)
local clr1:=setcolor(),scr1
devout("")
do case
        case menuparam=3
                do nastrojka
                WriteCfg(DDir+"Config.arm")
        case menuparam=1
                do GosPlategka
        case menuparam=2
                scr1:=win_save(0,0,maxrow(),maxcol())
                set color to
                @ 0,0 clear to maxrow(),maxcol()
                ? replicate(chr(248),maxcol())
                ? center("Для возврата в программу наберите EXIT и нажмите Enter",79,' ',.t.)
                ? center('Всего доступно памяти для программ   => '+alltrim(str(memory(2)))+" KBytes",79,' ',.t.)+' '
                ? replicate(chr(248),maxcol())
                set cursor on
                DiskExit:=diskname()+":"
                DirExit:=DiskExit+dirname()
                run command.com
                run cd &DiskExit
                dirchange(DirExit)
                set cursor off
                setcolor(clr1)
                win_rest(scr1)
endcase
return NIL



STATIC function level1b(menuparam)
devout("")
do case
   case menuparam=1.and.prot#"Архив"
        do NewYear
   case menuparam=2.and.prot#"Архив"
endcase
return NIL



STATIC function level1a(menuparam)
local default:=Ddir,Pos:=21,TmpScr:="",nStep:=1,ELevel:=-1
Private oSayInfoDlg:=NIL
//rec88=0
devout("")
do case
   case menuparam=1
        file_path=Ddir+','+schet_tdisk+','+schet_share
        path_copy=Ddir
        set path to &file_path
        set default to &path_copy
        IF MYUpper(Prot)=="NO_INTRO"
           if al_box({"Переиндексировать базы даныых"},2)==1
              do servis2
           else
                loadgos()
           endif
        ELSE
           IF .not.File(Schet_Share+"Ind.Smf")
              Desc:=Fcreate(Schet_Share+"Ind.Smf")
              Fwrite(Desc,Station); Fclose(Desc)
              do servis2
              Do While ELevel!=0
                 ELevel:=DeleteFile(Schet_Share+"Ind.Smf")
                 IF ELevel!=0
                    @ MaxRow(),1 say "Ошибка снятия семафора !"
                 ELSE
                    @ MaxRow(),1 say Space(50)
                 ENDIF
                 Inkey(0.5)
              ENDDO
           ELSE
              oScr:=Obrabot("Сортировку проводит "+MemoRead(Schet_Share+"Ind.Smf"))
              TmpScr:=SaveScreen(12,20,12,65)
              Do While File(Schet_Share+"Ind.Smf")
                 RestScreen(12,20,12,65,TmpScr)
                 IF nStep>0
                    pos=if(pos<60,pos+1,21)
                    nStep:=IF(Pos==60,-1,nStep)
                 ELSE
                    pos=if(pos>21,pos-1,21)
                    nStep:=IF(Pos==21,1,nStep)
                 ENDIF
                 colorwin(12,pos,12,pos,'n/rb+')
                 Hot_Inkey(0.1)
                 DO CASE
                    CASE LastKey()==27
                         IF Al_Box({"Прервать загрузку баз данных"},2)==1
//                            DeleteFile(Schet_Share+"Ind.Smf")
                            nStep:=0
                            Exit
                         ENDIF
                    CASE LastKey()==96
                         IF Al_Box({"Прервать загрузку баз данных и удалить семафор"},2)==1
                            DeleteFile(Schet_Share+"Ind.Smf")
                            nStep:=0
                            Exit
                         ENDIF
                 ENDCASE
              ENDDO
              Win_Rest(oScr)
              IF nStep!=0
                 do servis2
              ENDIF
           ENDIF
        ENDIF
        set default to &path_copy
        IF nStep!=0
           do kostya2 with '/17','Отпуск электроэнергии'
           IF oSayInfoDlg!=NIL
							oSayInfoDlg:Destroy()
           ENDIF
        ENDIF
   case menuparam=2
        file_path=Ddir+','+schet_tdisk+','+schet_share
        path_copy=Ddir
        set path to &file_path
        set default to &path_copy
//        file_path=dir+','+dir+'#4#5\'+','+schet_tdisk+','+Schet_Share
//        path_copy=dir+'#4#5\'
//        set path to &file_path
//        set default to &path_copy
        Energy()
        set default to &path_copy
endcase
Close All
return NIL




Function IsCorrect(Type,AskPassword)
LOCAL oscr:=win_save(),Color:=Setcolor(),Sel:=Select(),Correct:=.F.
AskPassword:=IF(AskPassword==NIL,.T.,AskPassword)
IF AskPassword
   SET COLOR TO &GetColor
   colorwin(12,24,14,59,"n+/n")
   @ 11,23 SAY "┌──────────────────────────────────╖"
   @ 12,23 SAY "│ Код доступа                      ║"
   @ 13,23 SAY "╘══════════════════════════════════╝"
   set cursor on
   set confirm on
   Secret:=space(15)
   @ 12,40 say ""
   Secret:=getsecret(space(15))
   set cursor off
   set confirm off
   SetColor(Color)
   Win_Rest(OScr)
   IF Lastkey()==27
      Return Correct
   ENDIF
   Correct:=If(lower(Alltrim(Secret))=="администратор",.T.,.F.)
ELSE
   Correct:=.T.
ENDIF
IF Correct
   Select 0
   IF NetUse(Schet_Share+"Access.dbf")
      IF NetAppend()
         Replace User With Station
         Replace Licevoj With Main->Lic_Schet
         Replace Date With New_date
         Replace Time With Time()
         Replace Work With Type+" "+Substr(Main->Potrebitel,1,20)+" в ["+Alltrim(Alias(Sel))+"]"
         Replace Saldo With GetSaldo(Main->Lic_Schet,Month(New_date))
         Unlock
      ENDIF
      Use
   ENDIF
ENDIF
Select(Sel)
Return Correct



Function WantReplace(Type,bField,Previos,Present,Type2)
LOCAL oscr:=win_save(),Color:=Setcolor(),Sel:=Select(),Correct:=.F.,TypeField:=.T.
Local cPrevious:="",cPresent:=""
//@ 1,0 say Field
//? Previos
//? Present
//? ValType(&Field)
IF !Empty(bField)
	DO Case
   	Case ValType(&bField)=="C"
        	cPrevious:=AllTrim(Previos)
        	cPresent:=AllTrim(Present)
   	Case ValType(&bField)=="N"
        	cPrevious:=AllTrim(Str(Previos,14,2))
        	cPresent:=AllTrim(Str(Present,14,2))
   	Case ValType(&bField)=="D"
        	cPrevious:=DTOC(Previos)
        	cPresent:=DTOC(Present)
	ENDCASE
ELSE
   TypeField:=.F.
ENDIF
//@ 10,0 say Substr(Main->Potrebitel,1,20)
//? Field
//? cPrevious
//? cPresent
//? Alltrim(Alias(Sel))
DO CASE
   CASE Previos!=Present
     Select 0
     IF NetUse(Schet_Share+"Access.dbf")
        IF NetAppend()
           Replace User With Station
           Replace Licevoj With Main->Lic_Schet
           Replace Date With New_date
           Replace Time With Time()
           IF TypeField
           		Replace Work With AllTrim(Substr(DelString(Main->Potrebitel,"ИНН"),1,20))+" ("+bField+" с "+cPrevious+" на "+cPresent+") в ["+Alltrim(Alias(Sel))+"]"
           ELSE
           		Replace Work With Type+AllTrim(Substr(DelString(Main->Potrebitel,"ИНН"),1,20))+" в ["+Alltrim(Alias(Sel))+"]"
           ENDIF
           Replace Saldo With GetSaldo(Main->Lic_Schet,Month(New_date))
           Unlock
        ENDIF
        Use
     ENDIF
   CASE Type2!=NIL
     Select 0
     IF NetUse(Schet_Share+"Access.dbf")
        IF NetAppend()
           Replace User With Station
           Replace Licevoj With Main->Lic_Schet
           Replace Date With New_date
           Replace Time With Time()
           Replace Work With Upper(Type)
           Replace Saldo With GetSaldo(Main->Lic_Schet,Month(New_date))
           Unlock
        ENDIF
        Use
     ENDIF
ENDCase
Select(Sel)
Return Correct



Procedure PrintWorkScreen
Local Desc,WorkScreen,SavedScreen,PosCrLf:=0
WorkScreen:=SaveScreen(0,0,MaxRow(),MaxCol())
SavedScreen:=M->Station+" "+DTOC(date())+" "+Time()+Chr(13)+Chr(10)
For ScrPos=1 to Len(WorkScreen) Step 2
    PosCrLf=PosCrLf+1
    SavedScreen:=SavedScreen+Substr(WorkScreen,ScrPos,1)
    IF PosCrLf=80
       SavedScreen:=SavedScreen+Chr(13)+Chr(10)
       PosCrLf=0
    ENDIF
Next
Desc:=Fcreate(DDir+"Screen.Gkv")
FWrite(Desc,SavedScreen)
//FWrite(Desc,WorkScreen)
Fclose(Desc)
print_fi(,DDir+"Screen.Gkv")
Return
