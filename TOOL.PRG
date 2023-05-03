******************************************************************************
* ReadCfg()  - Чтение файла конфигурации и объявление переменных, описанных
*              в файле как глобальных
* WriteCfg() - Запись в файл конфигурации переменных с обновленными значе-
*              ниями.
******************************************************************************
* PrepareMem()
* Функция подготовки для записи переменных в файл в текстовом виде
* Используется совместно с WriteMem()
* PrepareMem('CONFIG.FIL','FILES=','90')
******************************************************************************
* WriteMem()
* Функция записи подготовленного в буфере файла на диск
* WriteMem()
******************************************************************************
* DirectMemW()
* Функция записи переменных в файл в текстовом виде
* DirectMemW('CONFIG.FIL','FILES=','90')
******************************************************************************
* ReadMem()
* Функция чтения переменной из файла текстовго вида
* ReadMem('CONFIG.FIL','DIRECTORY=')
******************************************************************************
STATIC cConfigFile:=""
STATIC lIsReading:=.F.
STATIC cCfgFileName:=""

/*
procedure main
ReadCfg()
files++
WriteCfg()
&& DirectMemW('CONFIG.CFG','files=',90)
&& DirectMemW('CONFIG.CFG','directory=','C:\')
//PrepareMem('CONFIG.CFG','files=',90)
//PrepareMem('CONFIG.CFG','directory=','C:\')
//WriteMem()
//? READMEM('CONFIG.cfg','files=')
//? ReadMem('config.cfg','directory=')
return
*/


Function WriteMem()
IF FILE( TOKEN(cCfgFileName, "." ,1) + ".BAK")
    DELETEFILE(TOKEN(cCfgFileName, "." ,1) + ".BAK")
ENDIF
RENAMEFILE(cCfgFileName, TOKEN(cCfgFileName, "." ,1) + ".BAK")
desc=FCREATE(cCfgFileName)
IF desc#-1
   FWRITE(desc,cConfigFile)
endif
FCLOSE(desc)
Return NIL



FUNCTION PREPAREMEM(cFileName,cNewString,cFilesNew)
LOCAL cTempString,cTypeMem
  cFileName := MYupper(IF(cFileName==NIL, "CONFIG.CFG",cFileName ))
  cNewString:= MYupper(IF(cNewString==NIL,"FILES=",    cNewString))
  cFilesNew :=      (IF(cFilesNew==NIL, "90",        cFilesNew ))
  cTempString:=""
  cCrLf := CHR(13) + CHR(10)
  cTypeMem  := ValType(cFilesNew)
  cCfgFileName=cFileName
  DO CASE
     CASE cTypeMem="D"
          cFilesNew:=dtoc(cFilesNew)
     CASE cTypeMem="N"
          cFilesNew:=str(cFilesNew)
     CASE cTypeMem="L"
          IF cFilesNew
             cFilesNew:=".T."
          ELSE
             cFilesNew:=".F."
          ENDIF
  ENDCASE
  If .not.lIsReading
     lIsReading:=.T.
     If File(cFileName)
        cConfigFile = FILESTR(cFileName)
     Else
        cConfigFile="* "+substr(cFileName,1,1)+;
                    lower(substr(cFileName,2))+" *"+;
                    " Configuration File From "+;
                    substr(MYUpper(token(exename(),'\')),1,1)+;
                    substr(Lower(token(exename(),'\')),2)+cCrLf+;
                    "{"+cTypeMem+"} "+cNewString+cFilesNew+cCrLf
     EndIf
  Endif
  lFound := .F.
  TOKENINIT(@cConfigFile, cCrLf, 2)
  DO WHILE .NOT. TOKENEND()
     cLine := TOKENNEXT(cConfigFile)
     position:=ATNUM(cNewString,MYUPPER(cLine),1)
     IF position#0
            cLine="{"+cTypeMem+"} "+substr(cLine,position,LEN(cNewString)) + cFilesNew
            lFound:=.T.
     endif
     cTempString=cTempString+cLine+cCrLf
  ENDDO
  IF .NOT.lFound   /* Если строчка не найдена, добавляю в конец файла */
     cConfigFile=cConfigFile+"{"+cTypeMem+"} "+cNewString+cFilesNew+cCrLf
  ELSE
     cConfigFile=cTempString
  ENDIF
RETURN NIL




FUNCTION DIRECTMEMW(cFileName,cNewString,cFilesNew)
  cFileName := MYupper(IF(cFileName==NIL, "CONFIG.CFG",cFileName ))
  cNewString:= MYupper(IF(cNewString==NIL,"FILES=",    cNewString))
  cFilesNew :=      (IF(cFilesNew==NIL, "90",        cFilesNew ))
  cCrLf := CHR(13) + CHR(10)
  cTypeMem  := ValType(cFilesNew)
  DO CASE
     CASE cTypeMem="D"
          cFilesNew:=dtoc(cFilesNew)
     CASE cTypeMem="N"
          cFilesNew:=str(cFilesNew)
     CASE cTypeMem="L"
          IF cFilesNew
             cFilesNew:=".T."
          ELSE
             cFilesNew:=".F."
          ENDIF
  ENDCASE
  lFound := .F.
  IF FILE(cFileName)
    cFileText = FILESTR(cFileName)
    IF FILE( TOKEN(CfILEnAME, "." ,1) + ".BAK")
        DELETEFILE(TOKEN(cFileName, "." ,1) + ".BAK")
    ENDIF
    RENAMEFILE(cFileName, TOKEN(cFileName, "." ,1) + ".BAK")
    desc=FCREATE(cFileName)
     IF desc#-1
      TOKENINIT(@cFileText, cCrLf, 2)
      DO WHILE .NOT. TOKENEND()
         cLine := TOKENNEXT(cFileText)
         position:=ATNUM(cNewString,MYUPPER(cLine),1)
         IF position#0
                cLine="{"+cTypeMem+"} "+substr(cLine,position,LEN(cNewString)) + cFilesNew
                lFound:=.T.
         endif
         FWRITE(desc,cLine+cCrLf)
      ENDDO
      IF .NOT.lFound   /* Если строчка не найдена, добавляю в конец файла */
         FWRITE(desc,"{"+cTypeMem+"} "+cNewString+cFilesNew+cCrLf)
      ENDIF
     ENDIF
     FCLOSE(DESC)
    ELSE
       desc=FCREATE(cFileName)
       IF desc#-1
          FWRITE(desc,"* "+substr(cFileName,1,1)+;
                     lower(substr(cFileName,2))+" *"+;
                     " Configuration File From "+;
                     substr(MYUpper(token(exename(),'\')),1,1)+;
                     substr(Lower(token(exename(),'\')),2)+cCrLf+;
                     "{"+cTypeMem+"} "+cNewString+cFilesNew+cCrLf)
       ENDIF
       FCLOSE(desc)
    ENDIF
RETURN NIL



FUNCTION READMEM(cFileName,cMemVar)
  cFileName := MYUPPER(IF(cFileName==NIL, "CONFIG.CFG",cFileName ))
  cMemVar   := MYUPPER(IF(cMemVar  ==NIL,"FILES=",     cMemVar))
  cCrLf     := CHR(13) + CHR(10)
  Value     := NIL
  Type      := NIL  && Тип возвращаемой переменной
  IF FILE(cFileName)
    cFileText = FILESTR(cFileName)
    TOKENINIT(@cFileText, cCrLf, 2)
    DO WHILE .NOT. TOKENEND()
       cLine := TOKENNEXT(cFileText)
       position:=ATNUM(MYUPPER(cMemVar),MYUPPER(cLine),1)
       IF position>0
             Value=substr(cLine,position+LEN(cMemVar))
             Type=substr(alltrim(cLine),2,1)
       endif
    ENDDO
  ENDIF
  do case
     case Type="N"
          Value:=VAL(Value)
     case Type="D"
          Value:=CTOD(Value)
     case Type="L"
          IF MYUpper(Value)=".T."
             Value=.T.
          ELSE
             Value=.F.
          ENDIF
  endcase
RETURN Value



FUNCTION MakeVar(MyVar,Value)
  PUBLIC &MyVar
  &MyVar:=Value
RETURN NIL


FUNCTION ReadCfg(cFileName)
LOCAL TmpStr:=NIL,MyVar:=NIL,Value:=NIL,Lines:=NIL,cCfg,I
LOCAL Type:=NIL  && Тип возвращаемой переменной
  cFileName := MYUPPER(IF(cFileName==NIL, "CONFIG.CFG",cFileName ))
  IF FILE(cFileName)
     cCfg:=MEMOREAD(cFileName)
     Lines:=MLCOUNT(cCfg,250,8,.F.)
     FOR I=1 TO Lines
         TmpStr:=alltrim(memoline(cCfg,250,I,9,.F.))
         IF substr(TmpStr,1,1)#'*'.and.substr(TmpStr,1,1)#'#'.and.;
            substr(TmpStr,1,1)#';'                       // Комментарий ?
            Type:=MYupper(substr(TmpStr,2,1))              // Тип переменной
            IF Type#"N".and.Type#"C".and.Type#"L".and.Type#"D"
               LOOP                                      // Бред в конфиге
            ELSE
               IF NumToken(TmpStr,"=")==0                // Бред в конфиге
                  LOOP
               ELSE
                  MyVar:=alltrim(substr(TmpStr,4,Atnum("=",TmpStr,1)-4)) // Имя
                  Value:=substr(TmpStr,Atnum("=",TmpStr,1)+1)     // Значение
                  DO CASE
                     CASE Type=="C"
                          Value:=IF(Empty(Value),"",Value)
                     CASE Type="N"
                          Value:=VAL(Value)
                     CASE Type="D"
                          Value:=CTOD(Value)
                     CASE Type="L"
                          IF MYUpper(Value)=".T."
                             Value=.T.
                          ELSE
                             Value=.F.
                          ENDIF
                  ENDCASE
                  IF .not.empty(MyVar)
                     MakeVar(MyVar,Value)
                  ENDIF
               ENDIF
            ENDIF
         ELSE
            LOOP
         ENDIF
     NEXT
  ENDIF
RETURN Value



FUNCTION WriteCfg(cFileName)
LOCAL TmpStr:=NIL,MyVar:=NIL,Value:=NIL,Lines:=NIL,cCfg,I,TmpStr2:="",cStr:=""
LOCAL DESC:=NIL,CrLf:=Chr(13)+chr(10),Len,Temp_:=0,Kol_Kl:=0,scr:=Win_Save()
LOCAL Type:=NIL  && Тип возвращаемой переменной
Local oDlg,aSizeDeskTop,aPos,oProgress
  cFileName := MYUPPER(IF(cFileName==NIL, "CONFIG.CFG",cFileName ))
  IF FILE(cFileName)
     cCfg:=MEMOREAD(cFileName)
     Lines:=MLCOUNT(cCfg,250,8,.F.)
//     scr:=obrabot("Запись служебной информации")
//     Temp_=39/Lines

			oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
			aSizeDesktop  := oMainWindow:currentSize()
			oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
      oDlg:title    := "Запись служебной информации" 
   		oDlg:SysMenu	 := .F.
   		oDlg:Configure()
      oDlg:Show()
      aSizeDesktop    := oDlg:currentSize()
      aPos						:= oDlg:CurrentPos()
  		oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
   		oProgress:create()
   		oProgress:minimum := 1
   		oProgress:maximum := Lines
     FOR I=1 TO Lines
   	  	oProgress:increment()																				// Progress Bar Increment
//         kol_kl=kol_kl+temp_
//         colorwin(12,21,12,21+kol_kl,'n/n')
         MyVar=NIL; Value:=NIL; cStr:=""
         TmpStr:=alltrim(memoline(cCfg,250,I,9,.F.))
         IF substr(TmpStr,1,1)#'*'.and.substr(TmpStr,1,1)#'#'.and.;
            substr(TmpStr,1,1)#';'                       // Комментарий ?
            Type:=MYupper(substr(TmpStr,2,1))              // Тип переменной
            IF Type#"N".and.Type#"C".and.Type#"L".and.Type#"D"
               LOOP                                      // Бред в конфиге
            ELSE
               IF NumToken(TmpStr,"=")==0                // Бред в конфиге
                  LOOP
               ELSE
                  MyVar:=alltrim(Token(substr(TmpStr,4),"=",1)) // Имя
                  IF type(MyVar)=="U".or.type(MyVar)=="UI".or.type(MyVar)=="UE"
                     LOOP
                  ENDIF
                  Value:=&MyVar
                  cStr:="{"
                  DO CASE
                     CASE Type(MyVar)="C"
                          cStr:=cStr+"C"+"} "+MyVar+"="+Value
                     CASE Type(MyVar)="N"
                          cStr:=cStr+"N"+"} "+MyVar+"="+str(Value)
                     CASE Type(MyVar)="D"
                          cStr:=cStr+"D"+"} "+MyVar+"="+dtoc(Value)
                     CASE Type(MyVar)="L"
                          cStr:=cStr+"L"+"} "+MyVar+"="
                          IF Value
                             cStr:=cStr+".T."
                          ELSE
                             cStr:=cStr+".F."
                          ENDIF
                  ENDCASE
                  TmpStr2:=TmpStr2+cStr+CrLf
               ENDIF
            ENDIF
         ELSE
            TmpStr2:=TmpStr2+TmpStr+CrLf
            LOOP
         ENDIF
     NEXT
   	 oProgress:destroy()																							// Progress Bar Destroy
   	 oDlg:Destroy()
     RenameFile(cFileName, Token(cFileName, "." ,1) + ".BAK")
     MemoWrit(cFileName,TmpStr2)
     win_rest(scr)
  ENDIF
RETURN Value
