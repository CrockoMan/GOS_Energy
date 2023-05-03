* Функция форматирования дисков
* DiskFormat([<Drive>],[<Drive Type>],[<Volume Label>],[<Top>],[<Left>])
*********************************************************************
*cls
#include "INKEY.CH"

#define COLOR_NORM  1
#define COLOR_HIGH  2
#define COLOR_TITEL 3
#define COLOR_TABL  4

#define MONO1  "W/N"
#define MONO2  "+W/N"
#define MONO3  "N/W"
#define MONO4  "+W/N"

#define COLOR1 "+W/B"
#define COLOR2 "R+/B"
#define COLOR3 "GR+/B"
#define COLOR4 "GR+/W"

#define BOOTSECTOR chr(13)+chr(10)+chr(218)+replicate(chr(196),27)+chr(191)+chr(13)+chr(10)+;
		    chr(179)+" (c) Flan Ltd. Corporation "+chr(179)+chr(13)+chr(10)+;
		    chr(179)+" To get any programms call "+chr(179)+chr(13)+chr(10)+;
		    chr(179)+" (861-33) 5-50-88 in Anapa "+chr(179)+chr(13)+chr(10)+;
		    chr(192)+replicate(chr(196),27)+chr(217)+chr(13)+chr(10)+;
    chr(13)+chr(10)+"This  disk  is not  bootable"+chr(13)+chr(10)+;
		    "Please  insert  system  disk"+chr(13)+chr(10)+;
		    "and press any key when ready"+chr(13)+chr(10)

* Verwendung als UDF in einer Applikation (s. Bemerkungen!)

FUNCTION DF(cDrive, nFormat, FmtOption, Top, Left)
LOCAL cDosScreen
LOCAL cDosColor   := SETCOLOR()
LOCAL cDosCursor  := ROW()*256 + COL()
LOCAL aDefFormats := { 360, 1200, 720, 1440 }
LOCAL lVol        := .F.
LOCAL lDriveLegal := .F.
LOCAL lErrCode, vName

PRIVATE lTrk80
PRIVAT aColorTable := IF(ISCOLOR(),{COLOR1,COLOR2,COLOR3,COLOR4},;
                                   {MONO1,MONO2,MONO3,MONO4})

*** Optionale Parameter prБfen und ggf. mit Vorgabewerten belegen
*
  MyTop :=if(Top ==NIL,int(maxrow()/2-5), Top )
  MyLeft:=if(Left==NIL,int(maxcol()/2-22),Left)
  cDosScreen := WIN_SAVE(MyTop, MyLeft, MyTop+10, MyLeft+47)
  IF VALTYPE(cDrive) <> "C"
   cDrive := "A:"                   // Default Laufwerk
  ELSE
   cDrive := UPPER(SUBSTR(cDrive, 1, 1)) + ":"
  ENDIF

  IF VALTYPE(nFormat) <> "N"
   nFormat := 0
  ENDIF

  IF VALTYPE(FmtOption) = "C"      // Optionen prБfen
   lVol := "V" $ UPPER(FmtOption)
  ENDIF

  lDriveLegal := cDrive $ "A:B:"

  IF lDriveLegal
   IF nFormat = 0                   // Default-Formate
    nFormat := aDefFormats[FLOPPYTYPE(cDrive)]
   ELSEIF nFormat = 4
    nFormat := aDefFormats[1]
   ENDIF
  ENDIF

  IF lDriveLegal .AND.;
     "|" + NTOC(nFormat, 10, 4) $;
     "| 160| 180| 320| 360| 720|1200|1440"

   lTrk80 := nFormat > 360

   colorwin(MyTop+1,MyLeft+2,MyTop+10,MyLeft+46,'n+/n')
   SETCOLOR(aColorTable[COLOR_NORM])
    @ MyTop,MyLeft TO MyTop+9,MyLeft+45 DOUBLE
    @ MyTop+1,MyLeft+1 CLEAR TO MyTop+8,MyLeft+44

   SETCOLOR(aColorTable[COLOR_TITEL])
     @ MyTop,MyLeft+10 SAY "[ Форматирование  диска ]"
   SETCOLOR(aColorTable[COLOR_NORM])

   @ MyTop+2,MyLeft+2 SAY "0"
   @ MyTop+3,MyLeft+2 SAY "1"

   DO WHILE LASTKEY() <> K_ESC
     SETCOLOR(aColorTable[COLOR_TABL])
      @ MyTop+2,MyLeft+4,MyTop+3,MyLeft+43 BOX REPLICATE(" ", 9)
     SETCOLOR(aColorTable[COLOR_NORM])

     IF lTrk80
       @ MyTop+1,MyLeft+4 SAY "0....1....2....3....4....5....6....7...."
     ELSE
       @ MyTop+1,MyLeft+4 SAY "0....+....1....+....2....+....3....+...."
     ENDIF

      @ MyTop+5,MyLeft+2 CLEAR TO MyTop+8,MyLeft+43
      @ MyTop+5,MyLeft+2 SAY " Bставьте диск в дисковод " + cDrive + "  (" +;
                 IIF(nFormat < 1000, STR(nFormat, 3) + "kB",;
                                     STR(nFormat /1000, 3, 1) + "MB") + ")"
     @ MyTop+6,MyLeft+2 SAY " Нажмите любую клавишу для начала"
     @ MyTop+8,MyLeft+3 SAY "[ESC]-Выход"

     lErrCode = IF(HOT_INKEY(0) == K_ESC, -3, 0)

     IF lErrCode = 0
       @ MyTop+5,MyLeft+1 CLEAR TO MyTop+7,MyLeft+44
        @ MyTop+5,MyLeft+2 SAY "Форматируется диск в дисководе     (     )"
       @ MyTop+6,MyLeft+2 SAY "Сторона   Дорожка   "

      SETCOLOR(aColorTable[COLOR_HIGH])
       @ MyTop+5,MyLeft+34 SAY cDrive
       @ MyTop+5,MyLeft+38 SAY IIF(nFormat < 1000,;
                   STR(nFormat, 3) + "kB", STR(nFormat/1000, 3, 1) + "MB")

       lErrCode := DISKFORMAT(cDrive, nFormat, "CONTROL", BOOTSECTOR, 5)

       IF lErrCode = 0
         SETCOLOR(aColorTable[COLOR_NORM])
         IF lVol
           SOUND(400, 2, .T.)
           @ MyTop+5,MyLeft+1 CLEAR TO MyTop+7,MyLeft+44
           vName := SPACE(11)
           @ MyTop+5,MyLeft+3 SAY "Метка дискеты  :" GET vName PICT "@!"
           READ
           @ MyTop+5,MyLeft+1 CLEAR TO MyTop+7,MyLeft+44

           vName := CHARREM(" .", vName)
           IF .NOT. EMPTY(vName)
             VOLUME(cDrive + vName)
           ENDIF
         ENDIF

	 If al_box({"Форматирование диска завершено.",;
		    "Рабочая емкость диска "+alltrim(str(disktotal(substr(cdrive,1,1))/1000))+' Кб',;
		    "oтформатировать еще один диск ?"},2)=2
           EXIT
         ENDIF
       ELSEIF lErrCode = -2
	al_box({"В Н И М А Н И Е !","Дисковод не поддерживает данный формат.",;
		" Работа остановлена. "},,,,,,,,,"gr+/r+,w/b+,,,gr/r+")
       ELSEIF lErrCode = -3
         IF al_box({'Форматирование диска остановлено оператором'},1)=2
           EXIT
         ENDIF
       ELSEIF lErrCode = -4
	  al_box({"Дисковод не отвечает, или отсутствует диск в кармане"},;
	  	,,,,,,,,"gr+/r+,w/b+,,,gr/r+")
       ELSE
         EXIT
       ENDIF
     ENDIF
   ENDDO

   WIN_REST(cDosScreen)
   SETCOLOR(cDosColor)
   @ cDosCursor/256, cDosCursor % 256 SAY ""
  ELSE
   lErrCode = -9
  ENDIF
RETURN(lErrCode)


***********************************
* Die Kontroll-UDF von DISKFORMAT()
*
FUNCTION CONTROL(nTrack, nHead)
LOCAL ret_val
  IF nTrack >= 0
    SETCOLOR(aColorTable[COLOR_TABL])

     IF lTrk80
      @ MyTop+2+nHead,MyLeft+4+(nTrack/2) SAY IF(int(nTrack/2)#nTrack/2,"▐","█")
     ELSE
      @ MyTop+2 +nHead, MyLeft+4 +nTrack SAY "█"
     ENDIF

    SETCOLOR(aColorTable[COLOR_HIGH])
     @ MyTop+6, MyLeft+9 SAY nHead PICTURE "99"
     @ MyTop+6, MyLeft+20 SAY nTrack PICTURE "99"

    ret_val := if(hot_inkey() == K_ESC, 2, 0)
  ELSE
    MSG("Запись системной информации...")
    ret_val := 0
  ENDIF
RETURN(ret_val)


*****************************************************
* Ausgabe von Meldungen und Abfrage von BestДtigungen
*
STATIC FUNCTION MSG(msg, val_keys)
LOCAL ret_val, old_color := SETCOLOR(aColorTable[COLOR_NORM])

 IF val_keys <> NIL
  SOUND(200, 2, .T.)
  val_keys := val_keys + chr(K_ESC)
 ENDIF

 @ MyTop+5, MyLeft+1 CLEAR TO MyTop+7, MyLeft+44

 IF ";" $ msg
  @ MyTop+5, MyLeft+3 SAY SUBSTR(msg, 1, at(";", msg) -1)
  @ MyTop+6, MyLeft+3 SAY SUBSTR(msg, at(";", msg) +1)
 ELSE
  @ MyTop+5, MyLeft+3 SAY msg
 ENDIF

 ret_val := " "
 IF val_keys <> NIL
  DO WHILE .T.
   ret_val := UPPER(CHR(HOT_INKEY(0)))
   IF VALTYPE(val_keys) == "C"
     IF ret_val $ val_keys
      EXIT
     ENDIF
   ELSE
     EXIT
   ENDIF
  ENDDO
 ENDIF

 SETCOLOR(old_color)
RETURN(ret_val)
