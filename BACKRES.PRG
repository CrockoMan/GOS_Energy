#DEFINE BufferSize 25600

#ifdef TEST
FUNCTION Oooops(Par)
Par:=IF(Par==Nil,"0",Par)
If Par=="1"
   DiskRestore("a:")
ELSE
   DiskBackUp({"d:\gos\ose\apr.dbf","d:\gos\ose\aug.dbf",;
               "d:\gos\ose\obormot.dbf"},"a:")
ENDIF
//DiskBackUp({"d:\gos\ose\apr.dbf","d:\gos\ose\aug.dbf",;
//            "d:\gos\ose\obormot.dbf"},"a:")
RETURN NIL
#Endif

// Функция сохранения файлов на дискете DiskBackUp(Array[],Char)
// Параметр - Массив с сохраняемыми файлами
//            Имя устройства для сохранения
FUNCTION DiskBackUp(Files,Drive)
LOCAL DiskNumber:=0,BackName:="DieHard.",BaseName:="BackUp.",FirstStep:=.T.,UseBase:=""
LOCAL DescBack:=0,DescSource:=0,Length:=0,Position:=0,OldClr:=SetColor()
LOCAL Buffer:=space(BufferSize),SavePosition:=0,OldWin:=Win_Save(),Temp
LOCAL DiskSize:=0,DiskWritten:=0,FileSize:=0,FileWritten:=0,rowstart,IsExit:=1
Drive:=Drive+IF(substr(Drive,Len(Drive),1)#"\","\","")
rowstart:=if(maxrow()<25,16,int(maxrow()/2))
Obrabot("Запись архивного диска N 1")
Obrabot("Подготовка к записи архива",rowstart)
Al_Box({"Вставьте чистый диск для начала записи"},1,{"Диск вставлен"})
FOR NumBackFile=1 TO Len(Files)
    Obrabot("Подготовка к записи архива",rowstart,,,.T.)
    IF FirstStep.or.SavePosition!=0
       WHILE .NOT.DiskreadyW(Drive)
             IsExit:=Al_Box({"Устройство не готово к записи"},2,{" Повторить "," Закончить "})
             IF IsExit==2
                EXIT
             ENDIF
       ENDDO
    ENDIF
    IF IsExit==2
       EXIT
    ENDIF
    DO While .T.
       IF FirstStep
          Obrabot("Запись архивного диска N "+alltrim(str(DiskNumber+1)))
          FileDelete(Drive+"*.*")
          DiskSize:=DiskFree(Drive); DiskWritten:=0
          cUserBase:=Drive+BaseName+"#"+Replicate("0",2-len(alltrim(str(DiskNumber))))+;
                   alltrim(str(DiskNumber))
          DbCreate(cUserBase,;
                   {{"FileName","C",40,0},;       // база данных с описанием
                   {"FileLen", "N", 7,0},;       // сохраненных файлов
                   {"FileEnd", "L", 1,0}})       // и их длинн
          DescBack:=Fcreate(Drive+BackName+"#"+;    // создание файла, который
                    Replicate("0",2-;               // будет содержать
                   len(alltrim(str(DiskNumber))))+; // сохраняемые файлы
                   alltrim(str(DiskNumber)))
          FirstStep=.F.
          DiskNumber++
          SELECT 0
          NetUse(cUserBase,,,"UserBase")
       ENDIF
       APPEND BLANK
       REPLACE FileName WITH Files[NumBackFile]
       REPLACE FileLen WITH 0
       REPLACE FileEnd WITH .T.
       COMMIT
       IF SavePosition==0
          FileWritten:=0
          DescSource:=Fopen(Files[NumBackFile])
          IF DescSource<=0
             Al_Box({"Ошибка открытия файла",Files[NumBackFile]},1,{" Пропустить файл "})
             LOOP
          ENDIF
          Length:=Fseek(DescSource,0,2); Fseek(DescSource,0)
          Position:=0
          Buffer:=Space(BufferSize)
       ELSE                       // запись считанного буфера, которая не
          Fwrite(DescBack,Buffer) // была записана на предыдущий диск
          IF NumBackFile==Len(Files).and.DiskFree(Drive)>(Length-FileWritten)
             DiskSize:=Length-FileWritten
          ENDIF
       ENDIF
       Obrabot(Files[NumBackFile],rowstart)
       DO WHILE .T.
          //------------------------ Поплавок записанности дискеты
          DiskWritten:=DiskWritten+Len(Buffer)
          Temp:=Round(DiskWritten*39/DiskSize,0); Temp:=If(Temp>39,39,Temp)
          colorwin(12,21,12,21+Temp,'n/n')
          //------------------------ Поплавок записанности файла
          FileWritten:=FileWritten+Len(Buffer)
          Temp:=Round(39*FileWritten/Length,0); Temp:=If(Temp>39,39,Temp)
          colorwin(RowStart+2,21,RowStart+2,21+Temp,'gr+/gr+')
          IF Position==Length        // файл записан полностью,
             SavePosition:=0         // необходимо сдвинуться
             EXIT                    // по циклу на следующий файл
          ENDIF
          IF (Position+BufferSize)>=Length
             Buffer:=Space(Length-Position)
             Fread(DescSource,@Buffer,(Length-Position))
             Position:=Length
          ELSE
             Fread(DescSource,@Buffer,BufferSize)
             Position:=Position+BufferSize
          ENDIF
          IF DiskFree(Drive)>=Len(Buffer)
             Fwrite(DescBack,Buffer)         // на диске еще есть
             SavePosition:=0                 // свободное место...
          ELSE
             REPLACE FileEnd WITH .F.                 // Диск заполнен
             FirstStep=.T.                            // записываю длинну
             REPLACE FileLen WITH Fseek(DescBack,0,1) // файла и признак
             COMMIT                                   // незаконченности
             FClose(DescBack)                         // записи, закрываю
             USE                                      // базу и файл.
             al_box({"Диск N"+alltrim(str(DiskNumber+1))+" заполнен полностью",;
                     "Вставьте диск N"+alltrim(str(DiskNumber+2))},;
                     1,{" Диск N"+alltrim(str(DiskNumber+2))+" установлен "})
             Obrabot("Запись архивного диска N "+alltrim(str(DiskNumber+1)))
             SavePosition:=Position
             NumBackFile--          // для возврата на текущий файл
             exit
          ENDIF
       ENDDO
       IF SavePosition==0                            // Диск еще не заполнен
          REPLACE FileLen WITH Fseek(DescBack,0,1)   // и база с файлами не
          COMMIT                                     // закрыта
          FCLOSE(DescSource)
       ENDIF
       EXIT
    ENDDO
NEXT NumBackFile
IF IsExit==2
   Al_Box({"Архивнaя копия не создана"})
ELSE
   Fclose(DescBack)
   DO WHILE Temp<39
      colorwin(12,21,12,21+Temp,'n/n')
      Temp++
      inkey(0.5)
   ENDDO
   Al_Box({"Создание архивной копии завершено"})
ENDIF
SetColor(OldClr); Win_Rest(OldWin)
RETURN Nil



FUNCTION DiskRestore(Drive,IsMessage)
LOCAL DiskNumber:=0,BackName:="DieHard.",BaseName:="BackUp.",FirstStep:=.T.,cUseBase:=""
LOCAL OldColor:=SetColor(),OldScreen:=Win_Save(),IsExit:=1,cUserFile:=""
LOCAL DescBack:=0,DescSource:=0,Length:=0,Position:=0,OldClr:=SetColor()
LOCAL RowStart,ArcPosition:=0,NextAppend:=.F.,cUserBase:="",Buffer:=""
LOCAL BackSize:=0,StartPosition:=0
Drive:=Drive+IF(substr(Drive,Len(Drive),1)#"\","\","")
RowStart:=IF(MaxRow()<25,16,INT(MaxRow()/2))
IsMessage:=IF(IsMessage==NIL,.T.,IsMessage)
Obrabot("Чтение архивного диска N 1")
Obrabot("Подготовка к чтению архива",rowstart)
Al_Box({"Вставьте архивный диск N1"})
DO While .T.
   DO WHILE .T.
      Obrabot("Подготовка к чтению архива",rowstart)
      WHILE .NOT.Diskready(Drive)
            IsExit:=Al_Box({"Устройство не готово к чтению"},2,{" Повторить "," Закончить "})
            IF IsExit==2
               EXIT
            ENDIF
      ENDDO
      IF IsExit==2
         EXIT
      ENDIF
      cUserBase:=Drive+BaseName+"#"+Replicate("0",2-Len(AllTrim(Str(DiskNumber))))+;
                 AllTrim(Str(DiskNumber))
      IF File(cUserBase).and.File(Drive+BackName+"#"+;
                                  Replicate("0",2-;
                                  len(alltrim(str(DiskNumber))))+;
                                  alltrim(str(DiskNumber)))
         EXIT
      ELSE
         IsExit:=Al_Box({"Вставьте архивный диск N"+alltrim(str(DiskNumber+1))},2,{" Диск вставлен "," Закончить "})
         IF IsExit==2
            EXIT
         ENDIF
      ENDIF
   ENDDO
   Obrabot("Чтение архивного диска N "+alltrim(str(DiskNumber+1)))
   IF IsExit==2
      EXIT
   ENDIF
   DO While .T.
      IF FirstStep
         DescBack:=Fopen(Drive+BackName+"#"+;      // открытие файла,
                   Replicate("0",2-;               // содержащего
                  len(alltrim(str(DiskNumber))))+; // сохраняемые файлы
                  alltrim(str(DiskNumber)))
         BackSize:=Fseek(DescBack,0,2); Fseek(DescBack,0)
         FirstStep:=.F.
         Position:=0
         StartPosition:=0
         ArcPosition:=0              // Положение указателя в архивном файле
         DiskNumber++
         SELECT 0
         NetUse(cUserBase,,,"UserBase")
      ENDIF
      Buffer:=SPACE(BufferSize)
      cUserFile:=Alltrim(FileName)
      Length:=FileLen
      Obrabot("Чтение "+cUserFile,RowStart)
      IF NextAppend     // Добавить в существующий файл ?
//       DescSource:=Fopen(cUserFile)        // Нет, открываю уже созданный
//       Fseek(DescSource,0,2)               // файл и продолжаю записывать
         NextAppend:=.F.                     // в конец файлa
      ELSE
         DescSource:=Fcreate(cUserFile)      // Да, создаю новй файл
         NextAppend:=IF(FileEnd,.F.,.T.)     // Файл записан до конца ???
      ENDIF
      IF DescSource>0
         ArcPosition:=Length
         DO While .T.
            //------------------------ Поплавок прочитанности дискеты
            Temp:=Round(Position*39/BackSize,0); Temp:=If(Temp>39,39,Temp)
            colorwin(12,21,12,21+Temp,'n/n')
            //------------------------ Поплавок прочитанности файла
            Temp:=Round((Position-StartPosition)*39/(Length-StartPosition),0)
            Temp:=If(Temp>39,39,Temp)
            colorwin(RowStart+2,21,RowStart+2,21+Temp,'gr+/gr+')
            IF Position==Length
               EXIT
            ENDIF
            IF (Position+BufferSize)>=Length
               Buffer:=Space(Length-Position)
               Fread(DescBack,@Buffer,(Length-Position)); Position:=Length
            ELSE
               Fread(DescBack,@Buffer,BufferSize); Position:=Position+BufferSize
            ENDIF
            IF Fwrite(DescSource,Buffer)!=LEN(Buffer)
               Al_Box({"Ошибка записи файла"})
            ENDIF
         ENDDO
         IF .NOT.NextAppend
            Fclose(DescSource)
         ENDIF
         IF Recno()==Reccount()
//            Fclose(DescBack)
            FirstStep:=.T.
            IF FileEnd
               DiskNumber=-1            // Признак окончания дисков
            ENDIF
            USE
            Exit
         ELSE
            StartPosition:=FileLen
            Skip
         ENDIF
      ENDIF
   ENDDO
   Fclose(DescBack)
   IF DiskNumber==-1.or.IsExit==2
      EXIT
   ENDIF
ENDDO
SetColor(OldColor)
Win_Rest(OldScreen)
IF IsExit==2
   IF NextAppend
      Fclose(DescSource)
   ENDIF
   Al_Box({"Архивный диск не был считан корректно"})
ENDIF
IF DiskNumber==-1.and.IsMessage
   Al_Box({"Архивная информация восстановлена полностью"})
ENDIF
RETURN NIL
