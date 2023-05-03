#include "Xbp.ch"
#include "Common.ch"
#include "Dbedit.ch"


#include "Appbrow.ch"
#include "Appedit.ch"
#include "Appevent.ch"
#include "Gra.ch"
#include 'inkey.ch'
#include 'setcurs.ch'
#define CRLF    CHR(13) + CHR(10)

STATIC aBank:={}

FUNCTION corfnsi(par1)
// собственно корректировка
  LOCAL cOldColor, cSaveScreen,Sel:=Select(),Rec:=RecNo()
  LOCAL nCursor        // запоминаем состояние курсора
  LOCAL getlist := {}
  LOCAL nWorkArea
  // переменные для ввода лицевого счета
  LOCAL cFam
  LOCAL nApp04
  LOCAL nKul
  LOCAL cDm
  LOCAL cKv
  LOCAL nSr
  LOCAL nKfid
  LOCAL nKtt
  LOCAL nSh
  LOCAL dDu
//  LOCAL nNs
  LOCAL dDs5
  LOCAL nPb5
  LOCAL dDop
  LOCAL nSumo
  LOCAL nPs
  LOCAL nPo
  LOCAL nPk
  LOCAL nVo
  LOCAL cGos
  LOCAL nLg012
  LOCAL nLgNor
  LOCAL nLgVet
  LOCAL nLgImp
  LOCAL dLgDat
  LOCAL cComment1
  LOCAL nDiarySum
  LOCAL nDiaryBeg
  LOCAL nDiaryKvt
  LOCAL dDiaryD1
  LOCAL dDiaryD2
  LOCAL nDiaryPok
  LOCAL cDiaryDis
  LOCAL dCountOff
  LOCAL nNumMail
  LOCAL nNumDost
  LOCAL dBook1
  LOCAL nFamily
  LOCAL dCurBeg
  LOCAL dCurEnd

 aTownp:={}       // количество улиц в конкретном городе
 aTownc:={}       // 2-значный код города
 aTowns:={}       // текст кода и наименования улицы
 aCodeCount:={}
 aStreetC:={}
 aStreetS:={}
 aVidPays:={}
 aVidPaysc:={}
 nTownStreet:={}
 cTownStreet:={}

 aVidPayc:={}
 aVidPays:={}
 aVidTar:={}
 aVidTar2:={}
 aVidTar3:={}

//   oXbp:= UpperCaseSLE():new()
//   oXbp:create( , , {220,200}, {200,30} )
//   SetAppFocus( oXbp )

//        Window:=XbpCrt():new(ODlg,Nil,{50,100},10,45,"Быт")
//        Window:create()

  select fnsi
  seek main->lic_schet
  IF .NOT.Found()
     IF NetAppend()
        Replace KA With Main->Lic_Schet
        Replace Ns With Licevoj2->schetchik
        UNLOCK
     ENDIF
  ENDIF


  cFam  := fnsi->Fam
  nApp04 := fnsi->App04
  nKul  := fnsi->Kul
  cDm   := fnsi->Dm
  cKv   := fnsi->Kv
  nSr   := fnsi->Sr
  nKfid := fnsi->Kfid
  nKtt  := fnsi->Ktt
  nSh   := fnsi->Sh
  dDu   := fnsi->Du
  nNs   := fnsi->Ns
  dDs5  := fnsi->Ds5
  nPb5  := fnsi->Pb5
  dDop  := fnsi->Dop
  nSumo := fnsi->Sumo
  nPs   := fnsi->Ps
  nPo   := fnsi->Po
  nPk   := fnsi->Pk
  nVo   := fnsi->Vo
  cGos  := fnsi->Gos
  cComment1 := fnsi->Comment1
  nNumMail  := fnsi->NumMail
  nNumDost  := fnsi->NumDost
  nDiarySum := fnsi->DiarySum
  nDiaryBeg := fnsi->DiaryBeg
  nDiaryKvt := fnsi->DiaryKvt
  dDiaryD1  := fnsi->DiaryD1
  dDiaryD2  := fnsi->DiaryD2
  nDiaryPok := fnsi->DiaryPok
  cDiaryDis := fnsi->DiaryDis
  dCountOff := fnsi->CountOff
  nLg012    := fnsi->Lg012
  nLgNor    := fnsi->LgNor
  nLgVet    := fnsi->LgVet
  nLgImp    := fnsi->LgImp
  dLgDat    := fnsi->LgDat
  dBook1    := fnsi->Book1
  nFamily   := fnsi->Family
  dCurBeg   := fnsi->CurBeg
  dCurEnd   := fnsi->CurEnd
  nCursor := SETCURSOR(SC_NORMAL)
  cOldColor := SETCOLOR()
  cSaveScreen := SAVESCREEN(0,0,MAXROW(),MAXCOL())
  set color to w+/b,gr+/b,,,w+/b

//  SET KEY K_F10 TO pCtrl_F10
  SET KEY K_F5 TO ViewF5()
  SET KEY K_F6 TO ViewF6()
  nWorkArea := SELECT()       // запоминаем рабочую область
  SELECT fnsi
  @ 0,0 CLEAR TO MAXROW() - 1,MAXCOL()
//  @ 0,0 TO MAXROW() - 1,MAXCOL() DOUBLE
  @ MAXROW(),0 SAY PADC('F5-просмотр квитанций, F6-просмотр обходов' + par1, MAXCOL() + 1) COLOR 'W+/N'
  @ 2,25 SAY 'КОРРЕКТИРОВКА ЛИЦЕВЫХ СЧЕТОВ'
  @  3,4 SAY 'Код абонента'
  @ 12,4 SAY 'Номер счетчика'
  set color to gr+/b
  @ 1,1 Say Center(AllTrim(Main->Potrebitel)," ",.t.,79)
  @  3,17 SAY fnsi->Ka
//  @ 12,19 Say Fnsi->Ns
  @ 07,65 Say Str(nPo,6)
  set color to w+/b,n/w,,,w+/b
  bkfccnta()
  Select FNSI
//  @  3,26 SAY 'Фамилия' GET cFam VALID cFam PICTURE 'XXXXXXXXXXXXXXXXXXXX'
  @  3,55 SAY 'Код приложения' Get nApp04 VALID fApp04(nApp04) PICTURE '99'
  @  4,4 SAY 'Код улицы         ' GET nKul WHEN MyKul(@nKul, 2) PICTURE '99999'
  @  5,4 SAY 'Номер дома   ' GET cDm PICTURE 'XXXXXXXXXX'
  @  6,4 SAY 'Квартира           ' GET cKv PICTURE 'XXXX'
//  @  7,4 SAY 'Срок оплаты          ' GET nSr VALID fSroki(nSr) PICTURE '99'
//  @  8,4 SAY 'Код фидера и ТП  ' GET nKfid WHEN fKfid(@nKfid, 2) PICTURE '999999'
//  @  9,4 SAY 'Коэфф.трансформации' GET nKtt VALID bkfccnt361(nKtt) PICTURE '9999'
  @  9,4 SAY 'Коэфф.трансформации' GET nKtt PICTURE '9999'
  @ 10,4 SAY 'Шифр счетчика       ' GET nSh WHEN fSch(@nSh, 2) PICTURE '999'
  @ 11,4 SAY 'Дата уст. счетчика ' GET dDu
  @ 12,4 SAY 'Номер счетчика' GET nNs valid IsNewSch(@nNs)
  @ 13,4 SAY 'Дата обхода    ' GET dDs5 WHEN .F.
  @ 14,4 SAY 'Дата оплаты    ' GET dDop

  @ 4,36 SAY 'Сумма оплаты ' GET nSumo PICTURE '9999999.99'
  @ 5,36 SAY 'Показания при обходе        ' GET nPb5 PICTURE '999999'
  @ 6,36 SAY 'Показания счетчика начальные' GET nPs PICTURE '999999'
//  @ 7,36 SAY 'Показания оплаченные        ' GET nPo PICTURE '999999'
//  @ 8,36 SAY 'Показания с квитанции       ' GET nPk PICTURE '999999'
  @ 7,36 SAY 'Показания оплаченные        '
  @ 9,36 SAY 'Вид оплаты                      ' GET nVo WHEN fVo(@nVo, 2) PICTURE '99'
  @ 10,36 SAY 'Признаки' GET cGos WHEN ffGos(@cGos) VALID fGos(@cGos) PICTURE 'XXXXXXXX'
  @ 10,55 SAY 'Отсут. сч-ка' GET dCountOff
  @ 11,36 SAY 'Льгота                          ' GET nLg012 WHEN f50perc(@nLg012) PICTURE '99'
  @ 12,36 SAY 'Норматив потребления (кВт.ч.)  ' GET nLgNor PICTURE '999'
  @ 13,36 SAY 'Количество льготников          ' GET nLgVet PICTURE '999'
  @ 14,36 SAY 'Количество малообеспеченных    ' GET nLgImp PICTURE '999'
  @ 15,4 SAY 'Последняя дата пользования льготой для малообеспеченных   ' GET dLgDat
//  @ 11,72 SAY CHR(17) + 'F10' + CHR(16) COLOR 'W+/N'
  @ 16,4 SAY 'Дата замены книжки' GET dBook1
  @ 16,36 SAY 'Состав семьи' GET nFamily PICTURE '999'
  @ 17,4 SAY 'Курортный период: начало' GET dCurBeg
  @ 17,40 SAY 'конец'GET dCurEnd
  @ 18,4 SAY 'Примечания' GET cComment1 PICTURE '@kS59'
//  @ 19,4 SAY 'Отделение связи' GET nNumMail WHEN bkfccnt36k(@nNumMail) PICTURE '9999'
  @ 19,36 SAY 'Доставочный участок             ' GET nNumDost PICTURE '99'
  @ 20,4 SAY 'ЖУРНАЛ КОНТРОЛЕРОВ    Сумма оплаты' GET nDiarySum PICTURE '9999999.99'
  @ 20,50 SAY 'Начальная сумма' GET nDiaryBeg PICTURE '9999999.99'
  @ 21,4 SAY 'Квт.ч.' GET nDiaryKvt PICTURE '999999'
  @ 21,23 SAY 'Дата квитанции' GET dDiaryD1
  @ 21,50 SAY 'Дата оплаты' GET dDiaryD2
  @ 22,4 SAY 'Показания оплаченные и с квитанции после оплаты' GET nDiaryPok PICTURE '999999'
  @ 22,60 SAY 'Прошлый месяц' GET cDiaryDis PICTURE 'X'
  READ
  RecLock()
  Replace fnsi->Fam  With cFam
  Replace fnsi->App04 With nApp04
  Replace fnsi->Kul  With nKul
  Replace fnsi->Dm   With cDm
  Replace fnsi->Kv   With cKv
  Replace fnsi->Sr   With nSr
  Replace fnsi->Kfid With nKfid
  Replace fnsi->Ktt  With nKtt
  Replace fnsi->Sh   With nSh
  Replace fnsi->Du   With dDu
  Replace fnsi->Ns   With nNs
  Replace fnsi->Ds5  With dDs5
  Replace fnsi->Pb5  With nPb5
  Replace fnsi->Dop  With dDop
  Replace fnsi->Sumo With nSumo
  Replace fnsi->Ps   With nPs
  Replace fnsi->Po   With nPo
  Replace fnsi->Pk   With nPk
  Replace fnsi->Vo   With nVo
  Replace fnsi->Gos  With cGos
  Replace fnsi->Comment1 With cComment1
  Replace fnsi->NumMail  With nNumMail
  Replace fnsi->NumDost  With nNumDost
  Replace fnsi->DiarySum With nDiarySum
  Replace fnsi->DiaryBeg With nDiaryBeg
  Replace fnsi->DiaryKvt With nDiaryKvt
  Replace fnsi->DiaryD1  With dDiaryD1
  Replace fnsi->DiaryD2  With dDiaryD2
  Replace fnsi->DiaryPok With nDiaryPok
  Replace fnsi->DiaryDis With cDiaryDis
  Replace fnsi->CountOff With dCountOff

  Replace fnsi->Lg012    With nLg012
  Replace fnsi->LgNor    With nLgNor
  Replace fnsi->LgVet    With nLgVet
  Replace fnsi->LgImp    With nLgImp
  Replace fnsi->LgDat    With dLgDat
  Replace fnsi->Book1    With dBook1
  Replace fnsi->Family   With nFamily
  Replace fnsi->CurBeg   With dCurBeg
  Replace fnsi->CurEnd   With dCurEnd
  UNLOCK
  Select FSch
  Seek nSh
  select Fkods
  Seek nKul
  select licevoj2
  replace adres with alltrim(FKods->NUL)+" "+alltrim(cDm)+" "+Alltrim(cKV)
  Replace B With "220"
  Replace A With FSCH->ST
  Replace Tip With FSCH->TS
  Replace Pokazanie With Replicate("0",FSCH->Zns)
  Select Main
  IF reclock()
     replace adress with alltrim(FKods->NUL)+" "+alltrim(cDm)+" "+Alltrim(cKV)
     UnLock
  EndIf

//  SELECT(nWorkArea)           // восстанавливаем рабочую область
  Select(Sel)
  SET KEY K_F5 TO
  SET KEY K_F6 TO
  Go Rec
  SETCURSOR(nCursor)
  SETCOLOR(cOldColor)
  RESTSCREEN(0,0,MAXROW(),MAXCOL(),cSaveScreen)
RETURN NIL




Function IsNewSch(Par1)
Local Sel:=Select(),Rec:=RecNo(),Ret_val:=.T.
Select Licevoj2
Locate for AllTrim(Schetchik)==AllTrim(Par1)
IF .not.Found()
   IF Al_Box({"Добавить новый счетчик"},2)==1
      Append Blank
      Replace Schetchik With Par1
      Replace Lic_Sch With Main->Lic_Schet
   ELSE
      nNs:=FNSI->NS
//      Keyboard Chr(K_HOME)+Replicate(Chr(K_DEL),15)
//      +Str(FNSI->NS,15)
//      nNs:=FNSI->NS
//      Ret_Val:=.F.
   ENDIF
ENDIF
Select FNSI
Return Ret_Val




FUNCTION fApp04(par)
  LOCAL lRet := .T.
  IF (par < 0) .OR. (par > 41) .OR. (par == 28)
    Message_Wait('Код должен быть положительным, не более 41 и не равным 28', 12, 2)
    lRet := .F.
  ENDIF
RETURN lRet


FUNCTION fKul(par1,par2)
// par1 - переменная,куда передать значение кода улицы
// par2 = 1 - добавление лиц.счетов
//      = 2 - корректировка лиц.счетов
//      = 3 - уст.пост.реквизитов при добавлении лиц.счетов
//      = 4 - добавление лиц.счетов (почтовые платежи)
  LOCAL cOldColor, cSaveScreen
  LOCAL nI := 0, nJ, nK
  LOCAL cStr1 := '┌─────┬──────────────────────────────┐'
  LOCAL cStr2 := '│ Код │Наименование                  │'
  LOCAL cStr3 := '├─────┴──────────────────────────────┤'
  cOldColor := SETCOLOR('W+/N')
  cSaveScreen := SAVESCREEN(0,0,MAXROW(),MAXCOL())
  DO CASE
    CASE par2 == 1
    @ MAXROW(),0 CLEAR
    CASE par2 == 2
    @ MAXROW(),0 SAY PADC('ESC - прекратить корректировку кода улицы', MAXCOL() + 1)
    CASE par2 == 3
    @ MAXROW(),0 SAY PADC('ESC - не устанавливать код улицы', MAXCOL() + 1)
  ENDCASE
  SETCOLOR('N/W,B/BG')
  @ 4,36 CLEAR TO 19,73
  @ 4,36 TO 19,73
  @ 4,36 SAY cStr1
  @ 5,36 SAY cStr2
  @ 6,36 SAY cStr3
  DO CASE
    CASE (par2 == 1) .OR. (par2 == 4)   //   добавление лиц.счетов
    DO WHILE nI == 0
      nI := ACHOICE(7,37,18,72,aTowns)
    ENDDO
    CASE par2 == 2   //   корректировка лиц.счетов
    nK := ASCAN(aTowns, {|x| VAL(SUBSTR(x, 1, 2) ) == INT(par1 / 1000) } )
    nI := ACHOICE(7,37,18,72,aTowns,.T.,,nK)
    CASE par2 == 3   //   уст.пост.реквизитов при добавлении лиц.счетов
    nI := ACHOICE(7,37,18,72,aTowns)
  ENDCASE
  IF nI != 0
    IF aTownp[nI] == 0
      par1 := aTownc[nI] * 1000
    ELSE
      ASIZE(aStreetc, 0)
      ASIZE(aStreets, 0)
      fkods->(DBSEEK(STR(aTownc[nI] * 1000, 5) ) )
      FOR nJ = 1 TO aTownp[nI]
        fkods->(DBSKIP() )
        AADD(aStreets, STR(fkods->Kul, 5) + ' ' + fkods->Nul)
        AADD(aStreetc, fkods->Kul)
      NEXT
      nJ := 0
      @ 4,36 CLEAR TO 19,73
      @ 4,36 TO 19,73
      @ 4,36 SAY cStr1
      @ 5,36 SAY cStr2
      @ 6,36 SAY cStr3
      DO CASE
        CASE (par2 == 1) .OR. (par2 == 4)
        DO WHILE nJ == 0
          nJ := ACHOICE(7,37,18,72,aStreets)
        ENDDO
        CASE par2 == 2
        nK := ASCAN(aStreets, {|x| VAL(SUBSTR(x, 1, 5) ) == par1 } )
        nJ := ACHOICE(7,37,18,72,aStreets,.T.,,nK)
        CASE par2 == 3
        nJ := ACHOICE(7,37,18,72,aStreets)
      ENDCASE
      IF nJ != 0
        par1 := aStreetc[nJ]
      ENDIF
    ENDIF
  ENDIF
  SETCOLOR(cOldColor)
  RESTSCREEN(0,0,MAXROW(),MAXCOL(),cSaveScreen)
RETURN .F.


FUNCTION fVo(par1, par2)
// par1 - переменная,куда передать значение кода вида оплаты
// par2 = 1 - добавление лиц.счетов
//      = 2 - корректировка лиц.счетов
//      = 3 - уст.пост.реквизитов при добавлении лиц.счетов
//      = 4 - добавление лиц.счетов (почтовые платежи)
  LOCAL cOldColor, cSaveScreen
  LOCAL nI := 0
  LOCAL nJ         // номер строки для старого значения
  cOldColor := SETCOLOR('W+/N')
  cSaveScreen := SAVESCREEN(0,0,MAXROW(),MAXCOL())
  DO CASE
    CASE par2 == 1
    @ MAXROW(),0 CLEAR
    CASE par2 == 2
    @ MAXROW(),0 SAY PADC('ESC - прекратить корректировку вида оплаты', MAXCOL() + 1)
    CASE par2 == 3
    @ MAXROW(),0 SAY PADC('ESC - не устанавливать вид оплаты', MAXCOL() + 1)
  ENDCASE
  SETCOLOR('N/W,N/G')
//  SETCOLOR('N/W,B/BG')
  @ 5,1 CLEAR TO 18,76
  @ 5,1 TO 18,76
  @ 5,1 SAY '┌───┬──────────────────────────────────────────────────────────────────────┐'
  @ 6,1 SAY '│Код│  Вид оплаты                                                          │'
  @ 7,1 SAY '├───┴──────────────────────────────────────────────────────────────────────┤'
  DO CASE
    CASE (par2 == 1) .OR. (par2 == 4)   //   добавление лиц.счетов
    DO WHILE nI == 0
      nI := ACHOICE(8,2,17,75,aVidPays)
    ENDDO
    CASE par2 == 2       // корректировка
    nJ := ASCAN(aVidPays, {|x| VAL(SUBSTR(x, 1, 3) ) == par1 } )
    nI := ACHOICE(8,2,17,75,aVidPays,.T.,,nJ)
    CASE par2 == 3       // уст.пост.реквизитов при добавлении лиц.счетов
    nI := ACHOICE(8,2,17,75,aVidPays)
  ENDCASE
  IF nI != 0
    par1 := aVidPayc[nI]
  ENDIF
  SETCOLOR(cOldColor)
  RESTSCREEN(0,0,MAXROW(),MAXCOL(),cSaveScreen)
RETURN .F.



FUNCTION ffGos(par)
  // заполнение переменной пробелами если пусто
  IF EMPTY(par)
    par := SPACE(8)
  ENDIF
RETURN .T.

FUNCTION fGos(par)
// post-функция при вводе Gos
  LOCAL cStra
  cStra := STRTRAN(par,' ')
  IF LEN(cStra) < 8
    cStra += SPACE(8 - LEN(cStra))
  ENDIF
  par := cStra
RETURN .T.

FUNCTION f50perc(par)
  LOCAL cOldColor, cSaveScreen
  LOCAL nI
  LOCAL nChoice
  LOCAL a3 := {' 0 отсутствует',;
               ' 1 50% тарифа по нормативу',;
               ' 2 50% тарифа за весь объем',;
               ' 3 бесплатно по нормативу',;
               ' 4 бесплатно за весь объем',;
               ' 5 МЖКФ',;
               '10 многодетные'}
  LOCAL a11 := {}
  FOR nI = 1 TO LEN(a3)
    AADD(a11, VAL(a3[nI]) )
  NEXT
  cOldColor := SETCOLOR('N/W,N/G')
  cSaveScreen := SAVESCREEN(0,0,MAXROW(),MAXCOL())
  colorwin(9,5,19,35,"n+/n")
  @ 8,4 CLEAR TO 18,34
  @  8,4 TO 18,34
  @  8,4 SAY '┌─────────────────────────────┐'
  @  9,4 SAY '│           ЛЬГОТА            │'
  @ 10,4 SAY '├─────────────────────────────┤'
  nI := ASCAN(a11, par)
  nChoice := ACHOICE(11,6,17,32,a3,.T.,,nI)
  IF nChoice > 0
    par := a11[nChoice]
  ENDIF
  SETCOLOR(cOldColor)
  RESTSCREEN(0,0,MAXROW(),MAXCOL(),cSaveScreen)
RETURN .F.



FUNCTION fSch(par1,par2)
// par1 - переменная,куда передать значение кода счетчика
// par2 = 1 - добавление лиц.счетов
//      = 2 - корректировка лиц.счетов
//      = 3 - уст.пост.реквизитов при добавлении лиц.счетов
//      = 4 - добавление лиц.счетов (почтовые платежи)
  LOCAL cOldColor, cSaveScreen
  LOCAl nMin
  LOCAl nMax
  LOCAL nJ
  LOCAL nChoice := 0
  cOldColor := SETCOLOR('W+/N')
  cSaveScreen := SAVESCREEN(0,0,MAXROW(),MAXCOL())
  DO CASE
    CASE par2 == 1
    @ MAXROW(),0 CLEAR
    CASE par2 == 2
    @ MAXROW(),0 SAY PADC('ESC - прекратить корректировку кода счетчика', MAXCOL() + 1)
    CASE par2 == 3
    @ MAXROW(),0 SAY PADC('ESC - не устанавливать код счетчика', MAXCOL() + 1)
  ENDCASE
  nMin := 8
  nMax := LEN(aCodeCount) + nMin - 1
  nMax := IF(nMax > 20, 20, nMax)
  SETCOLOR('N/W,N/G')
  @ nMin - 4,43 CLEAR TO nMax + 1,73
  @ nMin - 4,43 TO nMax + 1,73
  @ nMin - 4,43 SAY '┌─────────────────────────────┐'
  @ nMin - 3,43 SAY '│Шифр   Тип        Сила       │'
  @ nMin - 2,43 SAY '│сч-ка  счетчика   тока       │'
  @ nMin - 1,43 SAY '├─────────────────────────────┤'
  DO CASE
    CASE (par2 == 1) .OR. (par2 == 4)   //   добавление лиц.счетов
    DO WHILE nChoice == 0
      nChoice := ACHOICE(nMin,45,nMax,71,aCodeCount)
    ENDDO
    CASE par2 == 2    // корректировка лиц.счетов
    nJ := ASCAN(aCodeCount, {|x| VAL(SUBSTR(x, 1, 3) ) == par1 } )
    nChoice := ACHOICE(nMin,45,nMax,71,aCodeCount,.T.,,nJ)
    CASE par2 == 3    // уст.пост.реквизитов при добавлении лиц.счетов
    nChoice := ACHOICE(nMin,45,nMax,71,aCodeCount)
  ENDCASE
  IF nChoice != 0
    par1 := VAL(SUBSTR(aCodeCount[nChoice], 1, 3) )
  ENDIF
  SETCOLOR(cOldColor)
  RESTSCREEN(0,0,MAXROW(),MAXCOL(),cSaveScreen)
RETURN .F.


PROCEDURE bkfccnta()
// сбор массивов
  LOCAL nI, nJ,Sel:=Select()
  //                  собираем массивы  aTownp aTownc aTowns
  select fkods
  go top
  DO WHILE !EOF()
     IF Kul>0
        AADD(nTownStreet,Kul)
        AADD(cTownStreet," "+str(kul,5,0)+" "+NUL)
     ENDIF
    SKIP
  ENDDO
  select(Sel)
  //                  собираем массивы  aFidp aFidc aFids
//  pUseS('ffid', 'ffid')
//  DO WHILE !EOF()
//    IF (ffid->Kod % 1000) == 0
//      AADD(aFidp, 0)
//      AADD(aFidc, INT(ffid->Kod / 1000) )
//      AADD(aFids, STR(ffid->Kod, 6) + ' ' + ffid->Fider)
//    ELSE
//      nI := INT(ffid->Kod / 1000)
//      nJ := ASCAN(aFidc, nI)
//      IF nJ != 0
//        aFidp[nJ]++
//      ENDIF
//    ENDIF
//    DBSKIP()
//  ENDDO
//  USE
//  //                  собираем массивы  aVidPayc aVidPays
//  pUseS('fvo', 'fvo')
  Select FVO
  go top
  DO WHILE !EOF()
    IF (fvo->Kvo <= 35) .AND. (fvo->Kvo != 5) .AND. (fvo->Kvo != 7) .AND. (fvo->Kvo != 0)
      AADD(aVidPayc, fvo->Kvo)
      AADD(aVidPays, STR(fvo->Kvo, 3) + ' ' + fvo->Oplata)
      AADD(aVidTar,  fvo->Tarif)
      AADD(aVidTar2, fvo->Tarif2)
      AADD(aVidTar3, fvo->Tarif3)
    ENDIF
    SKIP
  ENDDO
//  //                  собираем массив  aCodeCount
  Select fsch
  go top
  DO WHILE !EOF()
    IF KTS>0
       AADD(aCodeCount, STR(fsch->Kts, 3) + ' ' + fsch->Ts + ' ' + fsch->St)
    ENDIF
    SKIP
  ENDDO
RETURN


Function MyKul(Par1,Par2)
Local Sel:=Select(),Rec:=RecNo(),StartPos:=0,Is_Choice:={},Scr
Select FKods
Go Top
DO While !EOF()
   Skip
ENDDO
   For I=1 To Len(nTownStreet)
       IF Par1==nTownStreet[I]
          StartPos:=I
       ENDIF
       AAdd(Is_Choice,.T.)
   Next
   Scr:=Win_Save()
   PoType=vert_menu(cTownStreet,"Улицы",is_choice,01,35,StartPos,'n/w,n/g,,,r/w',.F.)
   Win_Rest(Scr)
   IF PoType>0
      Par1:=nTownStreet[PoType]
   ENDIF
Select(Sel)
Go Rec
Return .T.



// просмотр дополнительных данных при корректировке

PROCEDURE viewf5
local sel:=Select(),Rec:=RecNo(),cText:="",Scr:=Win_Save(),Desc
Select fyear
go top
seek main->Lic_Schet
cText:=Str(Main->Lic_Schet)+" "+AllTrim(Main->Potrebitel)+Chr(13)+Chr(10)+;
       "  Дата       Показания                 Сумма"+Chr(13)+Chr(10)
Do While KA==Main->Lic_Schet
   cText:=cText+dtoc(Dop)+" "+Str(Po)+" "+Str(Pk)+" "+Str(Kvt)+" "+Str(Sm,12,2)+" "+Vid_Dokum+Chr(13)+Chr(10)
//   cText:=cText+dtoc(Dop)+" "+Str(Po)+" "+Str(Pk)+" "+Str(Kvt)+" "+Str(Sm,12,2)+Chr(13)+Chr(10)
   SKIP
ENDDO
Select fosn
go top
seek main->Lic_Schet
cText:=cText+" -------------------------------------------"+Chr(13)+Chr(10)
Do While KA==Main->Lic_Schet.and.!EOF()
   cText:=cText+dtoc(Dop)+" "+Str(Po)+" "+Str(Kvt)+" "+Str(Sm,12,2)+" "+Vid_Dokum+Chr(13)+Chr(10)
//   cText:=cText+dtoc(Dop)+" "+Str(Po)+" "+Str(Pk)+" "+Str(Kvt)+" "+Str(Sm,12,2)+" "+Str(RecNo())+Chr(13)+Chr(10)
   SKIP
ENDDO
Desc:=FCreate(dDir+"Chastn.Gkv")
FWrite(Desc,cText)
FClose(Desc)
set cursor off
TxtView(dDir+"Chastn.Gkv")
set cursor on
//MemoEdit(cText,1,1,22,78,.f.,,300)
Select(Sel)
Go Rec
Win_Rest(Scr)
RETURN




Function ChastnOplata()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),NoExit:=.T.
Local ChReestr:=00000,NoInput:=.F.,ReestrSum:=0,tRec,ChReestr2:=0
Private MaxPok:=0,EditOplata:=.F.
Select 202
GO Top
IF RecCount()==0
   IF Al_Box({"Ввести новую расшифровку"},2)==1
      ChReestr=GetVal("Номер вводимой расшифровки  ",ChReestr,-1)
      IF ChReestr<=0
         NoInput:=.T.
      ELSEIF ChReestr>99999.or.ChReestr<10001
         Al_Box({"Недопустимый номер расшифровки"})
         NoInput:=.T.
      ENDIF
      IF NoInput==.F.
         ChReestr2:=ChReestr-Val(AllTrim(Str(Int(ChReestr/10),5))+"0")
         ChReestr:= Int(ChReestr/10)
      ENDIF
   ELSE
      NoInput:=.T.
   ENDIF
ELSE
   ChReestr=Reestr
   ChReestr2:=Reestr2
ENDIF
//@ 1,0 Say ChReestr
//@ 2,0 Say ChReestr2
IF NoInput==.T.
      Select(Sel)
      Go Rec
      SetColor(Clr)
      Win_Rest(Scr)
      Return NIL
EndIf
set color to w+/b,gr+/b,,,w+/b
ColorWin(14,07,23,78,"n+/n")
@ 13,06 SAY "┌─"+Str(ChReestr,4,0)+"─────────────────────────────┬───────────────────────────────────╖"
@ 14,06 SAY "│  Дата оплаты                     │"+space(35)+"║"
@ 15,06 SAY "│  Договор                         │"+space(35)+"║"
@ 16,06 SAY "│  Номер документа                 │"+space(35)+"║"
@ 17,06 SAY "│  Показания текущие               │"+space(35)+"║"
@ 18,06 SAY "│  Сумма эл.энергия                │"+space(35)+"║"
@ 19,06 SAY "│  Сумма пеня                      │"+space(35)+"║"
@ 20,06 SAY "│  Расход            Льгота        │"+space(35)+"║"
@ 21,06 SAY "│  К оплате                        │"+space(35)+"║"
@ 22,06 SAY "╘══════════════════════════════════╧═══════════════════════════════════╝"
Set Curs On
Set Conf On
set color to w+/b,n/w,,,w+/b
tData:=New_date
tLic:=Main->Lic_Schet
Sum SummaEl To ReestrSum
@ 22,08 Say Str(ReestrSum,12,2)
Set Key K_F5 to EditOplata
Set Key K_F4 To InsertOplata
Do While NoExit
   @ 20,16 Say Space(8)
   @ 20,34 Say Space(6)
   @ 21,23 say space(15)
   tNum_Dokum:="       "
   tPokazaniq:=0
   tSummaEl:=0
   tSummaP:=0
   tRashod:=0
   tLgota:=0
   @ 14,29 GET tDATA
   @ 15,33 GET tLIC Valid IsLicCorrect(@tLic)
   @ 16,32 GET tNUM_DOKUM
   @ 17,33 GET tPOKAZANIQ Picture  "@K 999999" Valid ProvChastn(@tPokazaniq)
   @ 18,30 GET tSUMMAEL   Picture  "@K 999999.99"
   @ 19,30 GET tSUMMAP    Picture  "@K 999999.99"
   Read
   IF LastKey()==27
      IF Al_Box({"Все квитанции обработаны"},2,{" Нет "," Да "})==2
         NoExit=.F.
      ENDIF
   ELSE
     IF EditOplata==.F.
        Append Blank
     ENDIF
     Replace Lic With tLic
     Replace Vid_Dokum With "Квитанция"
     Replace Num_Dokum With tNum_Dokum
     Replace Pokazaniq with tPokazaniq
     Replace Summael   With tSummaEl
     Replace SummaP    With tSummaP
     Replace Rashod    With tRashod
     Replace Lgota     With tLgota
     Replace Data      With tData
     Replace Reestr    With ChReestr
     Replace Reestr2   With ChReestr2
     replace ChSearch  With TimeKey()+Str(Lic,6)
     Replace Schetchik With Fnsi->NS
     IF EditOplata==.T.
        tRec:=RecNo()
        Sum SummaEl To ReestrSum
        Go tRec
     Else
        ReestrSum:=ReestrSum+tSummaEl
     EndIf
     EditOplata:=.F.
     @ 22,08 Say Str(ReestrSum,12,2)
   ENDIF
EndDo
Set Key K_F5 to
Set Key K_F4 to
Set Curs Off
Set Conf Off
IF Al_Box({"Разнести оплату и произвести начисления"},2,{" Нет "," Да "})==2
   ChastnRaznos()
ENDIF
Select(Sel)
Go Rec
SetColor(Clr)
Win_Rest(Scr)
Return NIL







Function ProvChastn(Par1)
Local Sel:=Select(),Rec:=RecNo(),Clr:=SetCOlor(),IsCorrect:=.T.,ReSum:={}
If EditOplata=.T.
   Return .T.
ENDIF
RetSum:=ChastnSumma(Par1,MaxPok)
//   @ 19,29 Say tSUMMAP    Picture  "@K 999999.99"
   Set Color To "gr+/b"
   @ 21,29 Say RetSum[1]  Picture  "@K 999999.99"
   @ 20,16 Say RetSum[3]  Picture  "999999"
   @ 20,34 Say RetSum[2]  Picture  "99999"
   SetColor(Clr)
SetColor(Clr)
Select(Sel)
Go Rec
Return IsCorrect



Function GetColMonthSZ(LastD,TekDate)
Local nMonthSZ:=1
IF LastD#CTOD("31.12.1999")         // Кол-во месяцев компенсации соцзащиты
   IF .not.Empty(LastD)
      IF Year(TekDate)-Year(LastD)>=1
         nMonthSz:=Month(TekDate)
      ELSE
          nMonthSz:=Month(TekDate)-Month(LastD)
      ENDIF
   ELSE
      nMonthSz:=1
   ENDIF
ENDIF
IF nMonthSz<1
   nMonthSZ:=1
ENDIF
//@ 1,0 Say LastD
//@ 2,0 Say TekDate
//@ 3,0 Say nMonthSz
//Inkey(0)
Return nMonthSz





Function GetKoef(nLic)
Local Sel:=Select(),Rec:=RecNo(),FNSIRec
Local nKoef:=1,Poisk:=""
Select FNSI
FNSIRec:=RecNo()
Seek nLic
IF Found()
   nKoef:=IF(Ktt>0,Ktt,1)
   Poisk:='('+alltrim(str(nLic))+')'+alltrim(FNSI->NS)
   Select Plomba
   Seek nLic
   IF Found()
      DO While nLic==Licevoj
         IF .not.Empty(Plomba->DateOn).and.Empty(DateOff)
            nKoef:=IF(NewKoeff>0,NewKoeff,1)
         ENDIF
         SKIP
      ENDDO
   ENDIF
ENDIF
Select FNSI
Go FNSIRec
Select(Sel)
Go Rec
Return nKoef






#define __TEST__




Function ChastnSumma(Par1,MaxPok,nLic,nMonth)
Local tRashod:=0,Sel:=Select(),Rec:=Recno(),RecFnsi:=0,tLgota:=0,LgotaString:="БВИПРУФХ"
Local CalckSummaEl:=0,SocRashod:=0,tSumma:=0,SocSumma:=0,aCount:={0,0,0,0,0,0,0}
Local LastD:=CtoD("31.12.1999"),MonthSZ:=1,tMonth,nMonthSz:=0,SocTarif:=1.69
IF nLIC!=NIL
   Select FNSI
   RecFnsi=RecNo()
   Seek nLic
ENDIF
nMonth:=IF(nMonth==NIL,Month(New_date),nMonth)
tMonth:=CtoD("01."+AllTrim(Str(nMonth,2))+"."+AllTrim(Str(Year(New_date))))
Select FYear
Seek Main->Lic_Schet
DO While Main->Lic_Schet==KA
   IF LastD<DOP
      LastD=Dop
   ENDIF
   SKIP
ENDDO

nMonthSZ:=GetColMonthSZ(LastD,CtoD("27."+AllTrim(STR(nMonth))+"."+AllTrim(Str(Year(New_date)))) )
ChastnKoef:=GetKoef(nLic)
tRashod=ChastnKoef*Proverka(Par1,MaxPok)

Select FVO
Seek Fnsi->VO

//  Сумма начислений без льгот
CalckSummaEl=Fvo->Tarif*tRashod

// Соц.норма тариф+10коп 250 квт без плит 350 с плитами
DO CASE
   CASE FVO->KVO==11
        SocRashod:=IF(tRashod-350>0,tRashod-350,0)
        SocTarif:=1.69
   CASE FVO->KVO==3
        SocRashod:=IF(tRashod-250>0,tRashod-250,0)
        SocTarif:=1.45
   CASE FVO->Tarif<=1.60
        SocRashod:=IF(tRashod-250>0,tRashod-250,0)
        SocTarif:=1.69
ENDCASE
SocSumma:=Round(SocRashod*(SocTarif-FVO->Tarif),2)
SocSumma:=0
//@ 1,30 Say Str(SocSumma,8,2)
//@ 1,40 Say SocRashod

// Вычитаем льготы
// Вычитаем из общей суммы по алгоритму:
// Сумма=Сумма-(квт_по_льготе*тариф_без_льготы)+(квт_по_льготе*льготный_тариф)

        CalckSummaEl:=CalckSummaEl+SocSumma

/*
DO CASE
   Case FNSI->LG012==0                  // Оплата за весь об`ем 100%
        CalckSummaEl:=CalckSummaEl+SocSumma

   Case FNSI->LG012==1                  // 50% расхода на 1-го льготника

                        IF (AtNum("Л",MyUpper(FNSI->GOS))!=0.or.;
                                  AtNum("К",MyUpper(FNSI->GOS))!=0.or.;
                                  AtNum("Ж",MyUpper(FNSI->GOS))!=0.or.;
                                  AtNum("З",MyUpper(FNSI->GOS))!=0).and.FNSI->Family>0

                                  FOR i=1 to Len(LgotaString)
                                                IF AtNum(Substr(LgotaString,i,1),MyUpper(FNSI->GOS))#0
                                        // кол-во льготников по 50 кВт
                                                        aCount[3]:=aCount[3]+1
                                                ENDIF
                                  NEXT

                                                // кол-во льготников по 50%
                                  aCount[4]:=IF(FNSI->LgVet-aCount[3]>0,FNSI->LgVet-aCount[3],0)


                                                // кВт по 50%
//                                      aCount[1]:=IF(Round(tRashod/FNSI->Family,0)<50,tRashod,Round(tRashod/FNSI->Family,0))
                                        aCount[1]:=IF(Round(tRashod/FNSI->Family,0)<50,50,Round(tRashod/FNSI->Family,0))

                                        aCount[2]:=tRashod-aCount[1]

                                        aCount[5]:=nMonthSZ*FNSI->LgNor*aCount[3]+aCount[4]*aCount[1]
// @ 5,0 Say tLgota
                                        IF aCount[5]>=tRashod
                                                 tLgota:=tRashod
                                        ELSE
                                                 tLgota:=aCount[5]
                                        ENDIF
// @ 1,0 Say aCount[3];  ?? " Льготников по 50 кВт"
// @ 2,0 Say aCount[4];  ?? " Льготников по 50%"
// @ 3,0 Say aCount[1];  ?? " Расход/состав семьи"

                        CalckSummaEl:=(tRashod-tLgota)*Fvo->Tarif+tLgota*Fvo->Tarif4+SocSumma
                        tSumma:=tLgota*Fvo->Tarif4    //+Round(((SocSumma/FNSI->Family)*aCount[4])/2,2)

// @ 4,0 Say SocSumma;  ?? " СоцСумма1"
                        // 50% соцнорматива для 50% льготников
                        SocSumma:=SocSumma-Round(aCount[4]*((SocSumma/FNSI->Family)/2),2)
                        SocSumma:=0
// @ 5,0 Say SocSumma;  ?? " СоцСумма2"
// @ 8,0 Say tLgota


// CalckSummaEl                 Сумма к оплате за эл.энергию
// SocSumma                                     Сумма по соцнормативу
// tLgota                                               кВт по льготному тарифу
// tRashod                                      кВт Всего расход
// tSumma                                               Сумма предоставленных льгот (соцзащите)

                        ELSE                                                                                                                                                                                    // 50% по нормативу

                        If tRashod>(nMonthSZ*FNSI->LgVet*FNSI->LgNor)
                        tLgota:=nMonthSZ*FNSI->LgVet*FNSI->LgNor
                        Else
                        tLgota:=tRashod
                        EndIf
                        CalckSummaEl:=CalckSummaEl-(tLgota*Fvo->Tarif)+(tLgota*Fvo->Tarif4)+;
                                SocSumma
                        tSumma:=(tLgota*Fvo->Tarif4)    // Сумма по льготе для соцзащиты
                        ENDIF



   Case FNSI->LG012==2                  // 50% за Весь об`ем
        SocSumma:=Round(SocSumma/2,Decimal)
        SocSumma:=0


        CalckSummaEl:=tRashod*Fvo->Tarif4+SocSumma
        tLgota:=tRashod
        tSumma:=CalckSummaEl

   Case FNSI->LG012==3                  // бесплатно по нормативу
        If tRashod>(nMonthSZ*FNSI->LgVet*FNSI->LgNor)
           tLgota:=nMonthSZ*FNSI->LgVet*FNSI->LgNor
        Else
           tLgota:=tRashod
        EndIf
                SocSumma:=0
        CalckSummaEl:=CalckSummaEl-(tLgota*Fvo->Tarif)+SocSumma
        tSumma:=0

   Case FNSI->LG012==4                  // бесплатно Весь об`ем
        CalckSummaEl:=0
        tLgota:=tRashod
        SocSumma:=0
        tSumma:=0
ENDCASE
*/
CalckSummaEl:=Round(CalckSummaEl,Decimal)

if FNSI->LG012==4                  // бесплатно Весь об`ем
        CalckSummaEl:=0
        tLgota:=tRashod
        SocSumma:=0
        tSumma:=0
ENDIF



IF RecFnsi#0
   Select Fnsi
   Go RecFnsi
ENDIF
Select(Sel)
Go Rec
//@ 2,30 Say Str(SocSumma,8,2)
//@ 2,40 Say SocRashod
//Inkey(0)
Return {CalckSummaEl,tLgota,tRashod,tSumma,SocSumma,SocRashod,ChastnKoef}




Procedure InsertOplata
Local AddedOplata:={},RecNo:={},Rec:=RecNo(),Choice,Scr:=Win_Save(),IsChoice:={},Clr:=SetColor()
Set Key K_F5 To
Set Key K_F4 To
//@ 1,0 Say Len(aBank)
//Inkey(0)
For I=1 To Len(aBank)
   AADD(AddedOplata,IF(aBank[i][5]==.T.," ","+")+Str(aBank[i][1],8,0)+" "+Str(aBank[i][2],10,2)+" "+" "+Str(aBank[i][4],7,0))
   AADD(IsChoice,IF(aBank[i][5]==.T.,.T.,.F.))
//   AADD(IsChoice,aBank[i][5])
Next
//   @ 2,1 clear to 10,78
//   colorwin(3,2,11,79,"n+/n")
//   Choice := ACHOICE(2,1,10,78,AddedOplata)
choice=vert_menu(AddedOplata,"Список оплат банка",isChoice,2,25,1,'n/w,n/g,,,r/w',.T.)
IF Choice>0
         aBank[Choice][5]=.F.
   ClearBuffer()
//   EditOplata:=.F.
   M->tLic:=aBank[Choice][1]
   M->tNum_Dokum:=""
   M->tPokazaniq:=aBank[Choice][4]
   M->tSummaEl:=aBank[Choice][2]
ENDIF
Win_Rest(Scr)
SetColor(Clr)
Set Key K_F5 To EditOplata
Set Key K_F4 To InsertOplata
Return








Procedure EditOplata
Local AddedOplata:={},RecNo:={},Rec:=RecNo(),Choice,Scr:=Win_Save(),IsChoice:={},Clr:=SetColor()
Set Key K_F5 To
Set Key K_F4 To
Select COpl
Go Top
Do While !Eof()
   AADD(AddedOplata,Str(Lic,8,0)+" "+Str(SummaEl,10,2)+" "+Str(SummaP,10,2)+" "+Str(Pokazaniq,7,0)+" "+Str(Rashod,7,0)+" "+Str(Lgota,7,0)+" "+DTOC(Data))
   AADD(RecNo,RecNo())
   AADD(IsChoice,.T.)
   Skip
EndDo
IF Len(RecNo)>0
//   @ 2,1 clear to 10,78
//   colorwin(3,2,11,79,"n+/n")
//   Choice := ACHOICE(2,1,10,78,AddedOplata)
   choice=vert_menu(AddedOplata,"Список введенных оплат",isChoice,2,5,1,'n/w,n/g,,,r/w',.T.)
   IF Choice>0
      Go RecNo[Choice]
      IF Al_Box({"Какое действие произвести с оплатой"},2,{" Изменить "," Удалить "})==1
         ClearBuffer()
         EditOplata:=.F.
         M->tLic:=Copl->Lic
         M->tNum_Dokum:=Num_Dokum
         M->tPokazaniq:=Pokazaniq
         M->tSummaEl:=SummaEl
         M->tSummaP:=SummaP
         M->tRashod:=Rashod
         M->tLgota:=Lgota

//         @ 14,32 say tLIC
//         @ 15,32 say tNUM_DOKUM
//         @ 16,33 say tPOKAZANIQ Picture  "@K 999999"
//         @ 17,30 say tSUMMAEL   Picture  "@K 999999.99"
//         @ 18,30 say tSUMMAP    Picture  "@K 999999.99"
//         @ 20,16 say tRASHOD    Picture  "999999"
//         @ 20,34 say tLGOTA     Picture  "99999"
//         @ 16,29 say tDATA
//         Inkey(0)
         delete
         pack
      ELSE
         Delete
         Pack
      ENDIF
   Else
      Go Rec
   ENDIF
   Win_Rest(Scr)
Else
Go Rec
ENDIF
SetColor(Clr)
Set Key K_F5 To EditOplata
Set Key K_F4 To InsertOplata
Return







Function ChastnRaznos()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),aMass:={}
Local tMonth:=Month_Menu(),NameDbf:="",RecFNSI,PokTekMonth:=0,Poisk:=""
Local aOplLic:={},NameInd:="",nR:={}
Local oDlg,aSizeDeskTop,aPos,oProgress
If tMonth>0.and.tMonth<13
//   obrabot("Разноска оплаты")
   NameDbf:=Schet_Share+"o"+alltrim(str(tmonth))+".Dbf"
   select 0
   if netuse(NameDbf,.f.,,"oplel")
      NameInd:=Schet_Share+"o"+alltrim(str(tmonth))+".Ntx"
      Set Index To &NameInd
      NameDbf:=Schet_Share+"p"+alltrim(str(tmonth))+".Dbf"
      select 0
      if netuse(NameDbf,.f.,,"oplp")
         NameInd:=Schet_Share+"p"+alltrim(str(tmonth))+".Ntx"
         Set Index To &NameInd
         Select COpl
         Set Order To 0



                                oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
                                aSizeDesktop  := oMainWindow:currentSize()
                                oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
        oDlg:title    := "Обработано"
                        oDlg:SysMenu     := .F.
                        oDlg:Configure()
        oDlg:Show()
        aSizeDesktop    := oDlg:currentSize()
        aPos                                            := oDlg:CurrentPos()
                        oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
                        oProgress:create()
                        oProgress:minimum := 1
                        oProgress:maximum := RecCount()
//         temp_=39/reccount()
//         kol_kl=0
         Go Top
         Do While !Eof()
                                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
                                nR:={0,0}
//            Kol_Kl=Kol_Kl+Temp_
//            ColorWin(12,21,12,21+kol_kl,'n/n')
            If SummaEl>0
               Select OplEl
               IF NetAppend(0)
                  Replace Vid_Dokum With COpl->Vid_Dokum
                  Replace Num_Dokum With COpl->Num_Dokum
                  Replace Licevoj   With COpl->Lic
                  Replace Summa     With COpl->SummaEl
                  Replace Data      With COpl->Data
                  Replace Reestr    With COpl->Reestr
                  Replace Reestr2   With COpl->Reestr2
                  Replace ChSearch  With COpl->ChSearch
                  Replace Pokazaniq With COpl->Pokazaniq
                  UNLOCK
                  nR[1]:=RecNo()
               ENDIF
               Select Fosn
               IF NetAppend(0)
                  Replace KA        With COpl->Lic
                  Replace DOP       With COpl->Data
                  Replace PO        With Copl->Pokazaniq
                  Replace Sm        With Copl->SummaEl
                  Replace Kvt       With COpl->Rashod
                  Replace Kvt1      With COpl->Lgota
                  Replace Vo        With VidOpl(COpl->Lic)
                  Replace Vid_Dokum With COpl->Vid_Dokum
                  Replace Num_Dokum With COpl->Num_Dokum
                  Replace Reestr    With COpl->Reestr
                  Replace ChSearch  With COpl->ChSearch
                  Replace SCHETCHIK With COpl->SCHETCHIK
                  Replace KOD       With '('+alltrim(str(COpl->lic))+')'+alltrim(Copl->schetchik)
                  Replace USER      With STATION
                  UNLOCK
                  nR[2]:=RecNo()
               EndIf
               Select OplEl
               Go nR[1]
               IF RecLock()
                        Replace Temporary With AllTrim(Str(nR[2],8))+";"
                        UNLOCK
               ENDIF
               Select FNSI
               RecFNSI:=RecNo()
               Seek Copl->Lic
               IF RecLock(0)
               // Считаю, что чем больше дата оплаты, тем выше показания
               // счетчика => последние показания==дате последней оплаты
                  DO CASE
                     CASE DOP<COpl->Data
                          Replace Sumo With Copl->SummaEl
                          if !Empty(Copl->Pokazaniq)
                             Replace PO   With COpl->Pokazaniq
                          ENDIF
                          Replace Dop  With COpl->Data
                     CASE DOP==COpl->Data
                          Replace Sumo With Copl->SummaEl
                          if !Empty(Copl->Pokazaniq)
                             Replace PO   With COpl->Pokazaniq
                          ENDIF
                          Replace Dop  With COpl->Data
                  ENDCASE
                  UNLOCK
               ENDIF
               Go RecFNSI
               Select COpl
            ELSE
               Select Fosn
               IF NetAppend(0)
                  Replace KA        With COpl->Lic
                  Replace DOP       With COpl->Data
                  Replace PO        With Copl->Pokazaniq
                  Replace Sm        With Copl->SummaEl
                  Replace Kvt       With COpl->Rashod
                  Replace Kvt1      With COpl->Lgota
                  Replace ChSearch  With COpl->ChSearch
                  Replace SCHETCHIK With COpl->SCHETCHIK
                  Replace KOD       With '('+alltrim(str(COpl->lic))+')'+alltrim(Copl->schetchik)
                  Replace Vo        With VidOpl(COpl->Lic)
                  UNLOCK
               EndIf
               Select FNSI
               RecFNSI:=RecNo()
               Seek Copl->Lic
               IF RecLock(0)
               // Считаю, что чем больше дата оплаты, тем выше показания
               // счетчика => последние показания==дате последней оплаты
                  DO CASE
                     CASE DOP<COpl->Data
                          Replace Sumo With Copl->SummaEl
                          if !Empty(Copl->Pokazaniq)
                             Replace PO   With COpl->Pokazaniq
                          ENDIF
                          Replace Dop  With COpl->Data
                     CASE DOP==COpl->Data
                          Replace Sumo With Copl->SummaEl
                          if !Empty(Copl->Pokazaniq)
                             Replace PO   With COpl->Pokazaniq
                          ENDIF
                          Replace Dop  With COpl->Data
                  ENDCASE
                  UNLOCK
               ENDIF
               Go RecFNSI
               Select Copl
            ENDIF
            IF SummaP>0
               Select OplP
               Append Blank
               Replace Vid_Dokum With COpl->Vid_Dokum
               Replace Num_Dokum With COpl->Num_Dokum
               Replace Licevoj   With COpl->Lic
               Replace Summa     With COpl->SummaP
               Replace Data      With COpl->Data
               Replace Reestr    With COpl->Reestr
               Replace Type_Opl  With 2
            EndIf
            select Main
            Seek COpl->Lic
            Select Licevoj
            Seek COpl->Lic
            AADD(aOplLic,COpl->Lic)
//            Do WHile Lic_sch==COpl->Lic
//               Skip
//            ENDDO
            Select Main
//            WriteChastnRash()
//            DO Outex With tMonth
            Select COpl
            Delete
            Skip
         ENDDO
                         oProgress:destroy()                                                                                                                                                                                    // Progress Bar Destroy
                         oDlg:destroy()
         Select COpl
         Set Order To 1
         Pack
         Select OplP
         Use
         Select OplEl
         Use

        oDlg          := XbpDialog():new()
        aSizeDesktop    := oMainWindow:currentSize()
        oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
        oDlg:title    := "Начисление и расчет сальдо"
                        oDlg:SysMenu     := .F.
                        oDlg:Configure()
        oDlg:Show()
        aSizeDesktop    := oDlg:currentSize()
        aPos                                            := oDlg:CurrentPos()
                        oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
                        oProgress:create()
                        oProgress:minimum := 1
                        oProgress:maximum := Len(aOplLic)
//         obrabot("Начисление и расчет сальдо")
//         temp_=39/Len(aOplLic)
//         kol_kl=0
        For I=1 To Len(aOplLic)
                                 oProgress:increment()                                                                                                                                                          // Progress Bar Increment
//             Kol_Kl=Kol_Kl+Temp_
//             ColorWin(12,21,12,21+kol_kl,'n/n')
             Select Main
             Seek aOplLic[i]
             @ 1,0 say Str(i,6,0)+" "+Str(Len(aOplLic),6,0)+" "+Str(aOplLic[i],6,0)
             Do OutEx With tMonth
        Next
                  oProgress:destroy()                                                                                                                                                                                   // Progress Bar Destroy
                  oDlg:Destroy()
      ELSE
         Al_Box({"Ошибка открытия файла оплат"})
      ENDIF
   ELSE
      Al_Box({"Ошибка открытия файла оплат"})
   ENDIF
ELSE
   Al_Box({"Не выбран месяц. Оплата не разнесена"})
ENDIF
Select(Sel)
Go Rec
SetColor(Clr)
Win_Rest(Scr)
Return NIL








Function WriteChastnRash(nLic,nMonth)
Local Sel:=Select(),Rec:=RecNo(),PrevPok:={}
Local PrevRecFnsi:=0,RecFnsi:=0,Poisk:="",aSumma:={},PokMonth:=0

PrevPok:=GetPrevPok(nLic,nMonth)
MaxPok :=GetMaxPok( nLic,nMonth)
Select Licevoj
go top
Seek nLic
Do While nLic==Licevoj->Lic_Sch
   Select FNSI
   RecFNSI:=RecNo()
   Seek nLic
   Do While KA==nLic
      IF Alltrim(Licevoj->Schetchik)==AllTrim(Fnsi->NS)
         Select FNSI
//         @ 5,0 Say MaxPok
         IF FNSI->PO#MaxPok[1]
            IF RecLOCK()
               Replace FNSI->PO  With MaxPok[1]
               Replace FNSI->DOP With MaxPok[2]
               UNLOCK
            ENDIF
         ENDIF
         PokMonth:=FNSI->PO
//--------------------------
//         @ 2,00 Say "Лицевой "
//         ?? nLic
//         @ 3,00 Say "Прошлй месяц "
//         ?? PrevPok[1]

//         @ 4,0 say "Текущий месяц"
//         ?? PokMonth
         Select FOSN
         Seek nLic
         IF .not.Found()
            PokMonth:=PrevPok[1]
//            @ 5,0 say "Лицевой не нашел "
//            ?? Alias()
         ENDIF
//         @ 4,30 Say "После функции"
//         ?? PokMonth
//--------------------------

         aSumma:=ChastnSumma(PokMonth,PrevPok[1],Licevoj->Lic_Sch,nMonth)
//         @ 1,20 Say FNSI->PO
//         @ 2,20 Say PrevPok[1]
//         @ 3,20 Say Licevoj->Lic_Sch
//         @ 4,20 Say PokMonth
//         @ 1,1 say aSumma[1]
//         @ 2,1 say aSumma[2]
//         @ 3,1 say aSumma[3]
//         Poisk:='('+alltrim(str(nLic))+')'+alltrim(licevoj->schetchik)
         Poisk:='('+alltrim(str(nLic))+')'+alltrim(FNSI->NS)
//         @ 4,0 Say Poisk
//         @ 4,20 Say nMonth
//         inkey(0)
         Select(nMonth)
         Seek Poisk
         IF Found()
            IF RecLock(0)
               Replace Pokazaniq   With FNSI->PO
//               Replace Koeficient  With FNSI->KTT
               Replace Koeficient  With aSumma[7]
               if aSumma[3]/aSumma[7]<=99999
                        Replace Raznica     With aSumma[3]/aSumma[7]
               else
                        Replace Raznica     With 99999
               endif
               Replace Rashod      With aSumma[3]
               Replace Tarif       With FVO->Tarif
               Replace Summa       With aSumma[1]
               Replace Info        With AllTrim(Str(aSumma[2],12,0))+";"+;
                                        AllTrim(Str(aSumma[4],12,2))+";"+;
                                        AllTrim(Str(aSumma[5],12,2))+";"+;
                                        AllTrim(Str(aSumma[6],12,0))+";"
               UNLOCK
            ENDIF
         ELSE
            IF NetAppend(0)
               Replace KOD         With Poisk
               Replace Moshn       With .F.
               Replace Drug_Nach   With .F.
               Replace IsNewValue  With .F.
               Replace IsLastMont  With .F.
               Replace Pokazaniq   With FNSI->PO
               Replace Koeficient  With aSumma[7]
               Replace Raznica     With aSumma[3]/aSumma[7]
               Replace Rashod      With aSumma[3]
               Replace Tarif       With FVO->Tarif
               Replace Summa       With aSumma[1]
               Replace Num_Of_Sch  With licevoj->schetchik
               Replace Info        With AllTrim(Str(aSumma[2],12,0))+";"+;
                                        AllTrim(Str(aSumma[4],12,2))+";"+;
                                        AllTrim(Str(aSumma[5],12,2))+";"+;
                                        AllTrim(Str(aSumma[6],12,0))+";"
               UNLOCK
            ENDIF
         ENDIF
         Select FNSI
      ENDIF
      Skip
   ENDDO
   Go RecFnsi
   Select Licevoj
   Skip
EndDO
//Inkey(1)
Select(Sel)
Go Rec
Return NIL







Function ChastnSchProv()
Local Sel:=Select(),Rec:=RecNo(),nMonth,cOpl:="",Temp_:=0,Kol_Kl:=0,Desc,NameInd:=""
Local Scr:=Win_Save(),aSizeDeskTop,oDlg,nCount:={0,0},CrLf:=Chr(13)+Chr(10),Poisk:="",NotFound:=.T.
Local aPos,oProgress

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := "Обработано"
oDlg:SysMenu     := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos                                            := oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
//oProgress := ProgressBar():new(oMainWindow ,, {5,1}, {aSizeDeskTop[1]-2,35},, .F. )   // Progress Bar Create
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
Select Main
Go Top
Desc:=FCreate(dDir+ReportFile)
Do While .not.EOF()
         oProgress:increment()                                                                                                                                                          // Progress Bar Increment
         NotFound:=.T.
         Select FNSI
         Seek Main->Lic_Schet
         IF Found()
                  nCount[1]:=nCount[1]+1
                        Select Licevoj
                        Seek Main->Lic_Schet
                        Do While Licevoj->Lic_Sch==Main->Lic_Schet
                                 IF Alltrim(Licevoj->Schetchik)==AllTrim(Fnsi->NS)
                                                NotFound:=.F.
                                 ENDIF
                                 Skip
                        EndDO
         ENDIF
         IF Main->lic_Schet>99999.and.NotFound
                  nCount[2]:=nCount[2]+1
                        FWrite(Desc,Str(Main->Lic_Schet,6)+" "+Fnsi->FAM+" "+FNSI->NS+CrLf)
         ENDIF
         Select Main
         Skip
EndDO
FClose(Desc)
IF nCount[2]>0
                ConfirmBox( oMainWindow," Всего лицевых частного сектора "+AllTrim(Str(nCount[1]),10)+CrLF+;
                                                                                                                " Найдено несоответствий - "+AllTrim(Str(nCount[2],10)), ;
                       "Внимание", ;
                        XBPMB_OK , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE)
ELSE
                ConfirmBox( oMainWindow," Всего лицевых частного сектора "+AllTrim(Str(nCount[1]),10)+CrLF+;
                                                                                                                                        " Несоответствий не найдено", ;
                       "Внимание", ;
                        XBPMB_OK , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE)
ENDIF
oProgress:destroy()                                                                                                                                                             // Progress Bar Increment
oDlg:destroy()
Select(Sel)
Go Rec
Return NIL






Function ChastnProv()
Local Sel:=Select(),Rec:=RecNo(),nMonth,cOpl:="",Temp_:=0,Kol_Kl:=0,Desc,NameInd:=""
Local Scr:=Win_Save(),aSizeDeskTop,oDlg,nCount:={0,0,0},CrLf:=Chr(13)+Chr(10),oDraw,aPos:={}
nMonth:=Month_Menu("для выбора несоответствий")
IF nMonth>0
   cOpl:=Schet_Share+"o"+alltrim(str(nMonth))+".Dbf"
   select 0
   IF netuse(cOpl,.f.,,"oplel")
//      NameInd:=Schet_Share+"o"+alltrim(str(nMonth))+".Ntx"
//      Set Index To &NameInd
      Go Top
//              temp_=39/reccount()
//              kol_kl=0
//      Obrabot("Анализ поступивших оплат")


                        oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
                        aSizeDesktop  := oMainWindow:currentSize()
                        oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
      oDlg:title    := "Обработано"
                oDlg:SysMenu    := .F.
                oDlg:Configure()
      oDlg:Show()
      aSizeDesktop  := oDlg:currentSize()
      aPos                                      := oDlg:CurrentPos()
                oProgress               := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )    // Progress Bar Create

//              oProgress := ProgressBar():new(oMainWindow ,, {5,1}, {aSizeDeskTop[1]-2,35},, .F. )     // Progress Bar Create
                oProgress:create()
                oProgress:minimum := 1
                oProgress:maximum := RecCount()
//        oProgress:increment()                                                                                                                                                         // Progress Bar Increment
//              oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
//              oDlg:Destroy()

      Desc:=FCreate(dDir+ReportFile)
      Do While !EOF()
         oProgress:increment()                                                                                                                                                          // Progress Bar Increment
//               Kol_Kl=Kol_Kl+Temp_
//               ColorWin(12,21,12,21+kol_kl,'n/n')
         IF OplEl->Licevoj>99999
                 nCount[2]:=nCount[2]+1
         ELSE
                 nCount[1]:=nCount[1]+1
         ENDIF
         Select Fosn
         Set Order To 2
         Seek OplEl->ChSearch
         IF .not.Found()
                  IF OplEl->Licevoj>99999.and..not.Empty(OplEl->ChSearch)
                         nCount[3]=nCount[3]+1
                         Select FNSI
                         Seek OplEl->Licevoj
                                FWrite(Desc,Str(OplEl->Licevoj)+"|"+Fnsi->FAM+"|"+Str(OplEl->Summa)+"|"+;
                                                        DTOC(OplEl->Data)+"|"+Str(OplEl->Reestr)+"("+Str(OplEl->Reestr2,1)+")"+;
                                                        Chr(13)+Chr(10))
                  ENDIF
         ENDIF
         Set Order To 1
         Select OplEl
         Skip
      ENDDO
      Fclose(Desc)
      Select OplEl
      Close
                oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
                oDlg:Destroy()

                IF nCount[3]>0
                                        ConfirmBox( oMainWindow," Оплат частного сектора "+AllTrim(Str(nCount[2]),10)+CrLF+;
                                                                                                                                        " Оплат госсектора "+AllTrim(Str(nCount[1]),10)+CrLF+;
                                                                                                                                        " Найдено несоответствий - "+AllTrim(Str(nCount[3],10)), ;
                       "Внимание", ;
                        XBPMB_OK , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE)
      ELSE
                                        ConfirmBox( oMainWindow," Оплат частного сектора "+AllTrim(Str(nCount[2]),10)+CrLF+;
                                                                                                                                        " Оплат госсектора "+AllTrim(Str(nCount[1]),10)+CrLF+;
                                                                                                                                        " Несоответствий не найдено", ;
                       "Внимание", ;
                        XBPMB_OK , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE)
                ENDIF

   ENDIF
ENDIF
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL






Function VidOpl(tLic)
Local VidOplat:=0,Sel:=Select(),Rec:=RecNo(),Rec1,Rec2
Select FNSI
Rec1:=RecNo()
Seek tLic
Select FVO
Rec2:=RecNo()
Seek FNSI->VO
VidOplat:=KVO
Go Rec2
Select FNSI
Go Rec1
Select(Sel)
Go Rec
Return VidOplat





Function IsLicCorrect(Par)
Local Sel:=Select(),Rec:=RecNo(),Clr:=SetCOlor(),LastD:=CTOD("01.01.1900")
Local PokOpl:=0,tIsCorrect:=.T.,LastD2,PokOpl2:=0,PresMonth:=0,RecCopl
Local Poisk:="",nMc:=Len(AllTrim(Main->LockMonth))+1,nMonthSz:=1,SumOpl2:=0
Local PrevPok
LastD2:=LastD
@ 14,44 Clear To 21,76
Select Main
seek Par
IF Found()
   Select FNSI
   Seek Par
   IF Found()
      PrevPok:=GetPrevPok(Par,Month(New_date))
//      Select FYear
//      Seek Par
//      Do While KA==Par
//         LastD :=DOP
//         IF LastD<CTOD("01.11.2005")
//            PokOpl:=Pk
//         ELSE
//            PokOpl:=PO
//         ENDIF
//         skip
//      ENDDO
      PokOpl:=PrevPok[1]
      LastD:=PrevPok[2]
      LastD2:=LastD

      nMonthSZ:=GetColMonthSZ(LastD,New_date )
      Select FOSN
      Seek Par
      Do While KA==Par
         PresMonth=PresMonth+1
         IF LastD2<=DOP
            LastD2 :=DOP
            PokOpl2:=PO
         ENDIF
         skip
      ENDDO
      Select COpl
      RecCopl:=RecNo()
      Go TOp
      Do While !EOF()
         IF Lic==Par
            LastD2 :=Data
            PokOpl2:=IF(Pokazaniq>PokOpl2,Pokazaniq,PokOpl2)
            PresMonth=PresMonth+1
         ENDIF
         Skip
      ENDDO

      Poisk:='('+alltrim(str(FNSI->KA))+')'+alltrim(FNSI->NS)
      Select(nMc)
      Seek Poisk
      IF FOund()
         IF ISNewValue
            PokOpl:=NewValue
         ENDIF
      ENDIF
      Select COpl

      @ 16,45 Say "Дата оплаты"
      @ 17,45 Say "Признаки"
      @ 18,45 Say "Вид оплаты"
      IF Fnsi->LgVet>0.or.Fnsi->LgNor>0
         @ 19,45 Say "Льготников      Норматив"
      ENDIF
      IF PresMonth>0
         IF (LastD+25)<LastD2
            @ 20,45 Say "Текущих оплат"
         ENDIF
         MaxPok:=PokOpl2
      Else
         MaxPok:=PokOpl
      EndIf
      set color to gr+/b
      @ 14,45 SAY Substr(AllTrim(Main->Potrebitel),1,30)
      @ 15,39 Say "  "
      IF FNSI->LG012==1.or.FNSI->LG012==2.or.FNSI->LG012==3.or.FNSI->LG012==4
         @ 15,39 Say Str(nMonthSZ,2)
      ENDIF
      set color to gr+/b
      IF Empty(FNSI->NS)
         @ 15,45 Say "Отсутствует номер счетчика"
         tIsCorrect:=.F.
      ELSE
         @ 15,45 Say Substr(AllTrim(Main->Adress),1,30)
      ENDIF
      @ 16,57 SAY DTOC(LastD) + " " + Str(PokOpl,6,0)
      @ 17,56 SAY FNSI->GOS
      @ 18,57 SAY FNSI->VO
      IF Fnsi->LgVet>0.or.Fnsi->LgNor>0
         @ 19,57 SAY Str(Fnsi->LgVet,3,0)
         @ 19,70 Say Str(Fnsi->LgNor,3,0)
      ENDIF
      IF PresMonth>0
         @ 20,60 SAY Str(PresMonth,2,0)
         @ 21,45 Say DTOC(LastD2) +" "+ Str(PokOpl2,6,0)
      EndIf
   ELSE
      @ 17,50 Say "Проверьте договор"
      Set Color To bg+/b
      @ 15,33 Say Str(Par,6)
      ?? Chr(7)
      inkey(0)
      tIsCorrect:=.F.
   ENDIF
ELSE
   Set Color To bg+/b
   @ 17,50 Say "Проверьте договор"
   @ 15,33 Say Str(Par,6)
   ?? Chr(7)
   inkey(0)
   tIsCorrect:=.F.
ENDIF
SetColor(Clr)
Select(Sel)
Go Rec
Return tIsCorrect




Function GetMaxPok(nLic,nMonth,lShow)
Local Sel:=Select(),Rec:=RecNo(),aStart:={0,CTOD("01.01.2000")}

aStart:=GetPrevPok(nLic,nMonth,lShow)
// aStart[1] -- Оплаченные показания
// aStart[2] -- Дата оплаты

Select FOSN
Seek nLic
Do While nLic==KA
   IF DOP>=aStart[2]
      aStart[1]:=PO
      aStart[2]:=DOP
   ENDIF
   SKIP
ENDDO
Select(Sel)
Go Rec
Return aStart






Function GetPrevPok(nLic,nMonth,lShow)
Local nPrevPok:=0,Sel:=Select(),Rec:=RecNo(),FYRec,LastD:=CTOD("01.01.1999")
Local PokOpl:=0,RecFnsi:=0,Poisk:="",IsEditValue:=.F.
IF nMonth==NIL
   nMonth:=Len(AllTrim(Main->LockMonth))
ENDIF
nMonth:=IF(nMonth=0,1,nMonth)
Select FNSI
RecFnsi:=RecNo()
Seek nLic
Poisk:='('+alltrim(str(nLic))+')'+alltrim(FNSI->NS)
Select(nMonth)
Seek Poisk
IF Found()
   IF IsNewValue
      PokOpl:=NewValue
      IsEditValue:=IsNewValue
   ENDIF
ENDIF
IF .Not.IsEditValue
   Select FYear
   FYRec:=RecNo()
   Go Top
   Seek nLic
   Do WHile nLic==KA
      IF LastD<DOP
         LastD :=DOP
         IF LastD<CTOD("01.11.2005")
            PokOpl:=Pk
         ELSE
            PokOpl:=PO
         ENDIF
      ENDIF
      Skip
   ENDDO
   IF PokOpl==0
      PokOpl:=FNSI->PS
   ENDIF
   Go FYRec
EndIf
IF lShow==NIL
         @ 22,25 Say DTOC(LastD)+" "+AllTrim(Str(PokOpl,8,0))
ENDIF
Select FNSI
Go RecFnsi
Select(Sel)
Go Rec
Return {PokOpl,LastD}





Function PotrebitelSearch()
Local Sel:=Select(),Rec:=RecNo()
ClearBuffer()
IF MainOrder==1
   MainOrder=2
   Set Order To MainOrder
Else
   MainOrder=1
   Set Order To MainOrder
ENDIF
Ret_Val:=2
Select(Sel)
Go Rec
Return NIL





Function NoChOplata()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save()
Local nMonth:=Month_Menu("для поиска неоднозначности"),NameDbf:=""
Local NameInd:="",Desc,CrLf:=Chr(13)+Chr(10),Temp_,Kol_KL:=0
Local OldOrd
IF nMonth>=1.and.nMonth<=12
   Obrabot("Поиск неоднозначностей")
   NameDbf:=Schet_Share+"o"+alltrim(str(nMonth))+".Dbf"
   NameInd:=Schet_Share+"o"+alltrim(str(nMonth))+".Ntx"
   Select 0
   IF NetUse(NameDbf,.f.,,"oplel")
      Index On Licevoj To &NameInd
      Desc:=FCreate(dDir+ReportFile)
      Select FOSN
      OldOrd:=IndexOrd()
      Set Order To 0
      GO Top
      temp_=39/reccount()
      kol_kl=0
      Do While !EOF()
         kol_kl=kol_kl+temp_
         colorwin(12,21,12,21+kol_kl,'n/n')
         IF Sm>0
            Select OplEl
            Found:=.F.
            Seek Fosn->KA
            DO While Fosn->KA==Licevoj
               IF Summa==FOSN->SM.and.DATA==FOSN->DOP
                  Found:=.T.
               ENDIF
               Skip
            ENDDO
            IF .not.Found
               Select FNSI
               Seek FOSN->KA
               FWrite(Desc,Str(FOSN->KA,6,0)+" "+Fnsi->Fam+" "+;
                           FOSN->Vid_Dokum+""+DTOC(FOSN->DOP)+" "+;
                           Str(FOSN->SM)+" "+;
                           IF(Fosn->Reestr#0,Str(FOSN->Reestr,5,0),"")+CrLf)
            ENDIF
         ENDIF
         Select FOSN
         SKIP
      ENDDO
      Select Fosn
      Set Order To OldOrd
      Select OplEl
      Close
      DeleteFile(NameInd)
      FClose(Desc)
   ENDIF
ENDIF
Select(Sel)
Go Rec
Win_Rest(Scr)
Return NIL







Function ChoicePriznak(IsAll)
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Priznak:="",Desc
Local strSpisok:={},ChoicedElement:=0,nMonth:=0,Kol_Kl:=0,Temp_:=0
Local top:=3,Left:=10,Bottom:=21,Right:=69,CrLf:=Chr(13)+Chr(10)
Local cText:="",Lgota:={0,0},SLimit:={0,0,},cPriznak:="",IsCalck:=.f.
Local nSumma,nOplata,aItog:={0,0,0,0,0,0,0,0,0},nRashod:=0,IsFilter:=.F.
Local cFilter:='FNSI->DU>=CTOD("01.01.2005").and.FNSI->DU<=CTOD("31.12.2005")'+Space(5)
Local oDlg,aSizeDeskTop,aPos,oProgress


Clear Typeahead
load("180",Schet_Share+"Fsign.dbf",Schet_Share+"Fsign.ntx",,  .f.)
Go Top
Do While !Eof()
   IF !Empty(Fsign->Symbol)
      aadd(StrSpisok," "+Fsign->Symbol+" "+Alltrim(Fsign->Name))
   EndIf
   Skip
EndDO

Clear Typeahead
ColorWin(Top+1,Left+1,Bottom+1,Right+1,'n+/n')
@ Top, Left, Bottom, Right BOX "┌─╖║╝═╘│ "
Sb_Attach(Top, Right, Bottom,len(strSpisok))
ChoicedElement:=aChoice(top+1, left+1, bottom-1, right-1, strSpisok, .T., 'handle_sb')
Sb_Detach()
Clear Typeahead
IF ChoicedElement#0
   nMonth:=Month_Menu('для выбора признака "'+Substr(strSpisok[ChoicedElement],2,1)+'"')
   IF nMonth>0
                        IF Al_Box({" Использовать дополнительные условия поиска "},2,,2)==1
                                cFilter:=AllTrim(GetVal("Фильтр ",cFilter,""))
                        ELSE
                                cFilter:=""
                        ENDIF
                        IF Len(AllTrim(cFilter))>0
                                cFilter:=&('{|| IF('+AllTrim(cFilter)+',.t.,.f.) }')
                                IsFilter:=.T.
                        ENDIF

                        oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
                        aSizeDesktop  := oMainWindow:currentSize()
                  oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
      oDlg:title    := "Обработано"
                oDlg:SysMenu     := .F.
                oDlg:Configure()
      oDlg:Show()
      aSizeDesktop    := oDlg:currentSize()
      aPos                                              := oDlg:CurrentPos()
                oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
                oProgress:create()
                oProgress:minimum := 1
//      Obrabot('Выбор потребителей с признаком "'+Substr(strSpisok[ChoicedElement],2,1)+'"')
      cPriznak:=IF(Substr(strSpisok[ChoicedElement],2,1)#"Я",Substr(strSpisok[ChoicedElement],2,1),"")
      Select Main
      Go Top
                oProgress:maximum := RecCount()
//      Kol_Kl:=0
//      temp_=39/RecCount()
      Desc:=FCreate(Ddir+ReportFIle)
      FWrite(Desc," "+strSpisok[ChoicedElement]+" "+Mesqc(nMonth)+CrLf)
      FWrite(Desc,"┌──────┬────────────────────┬─────────────────────────┬───────────┬───────────┬───────────┬────────────────┬─────────────────┬────────┐"+CrLf)
      FWrite(Desc,"│Догов.│      Портебитель   │         Адрес           │ Начислено │ Начислено │  Оплачено │     Льгота     │  Соц. норматив  │Признаки│"+CrLf)
      FWrite(Desc,"│      │                    │                         │           │           │           ├──────┬─────────┼───────┬─────────┤        │"+CrLf)
      FWrite(Desc,"│      │                    │                         │   кВт/ч   │    руб.   │    руб.   │ кВт/ч│  руб    │ кВт/ч │  руб.   │        │"+CrLf)
      FWrite(Desc,"├──────┼────────────────────┼─────────────────────────┼───────────┼───────────┼───────────┼──────┼─────────┼───────┼─────────┼────────┤"+CrLf)

      Do While !Eof()
                 oProgress:increment()                                                                                                                                                          // Progress Bar Increment
//         kol_kl=kol_kl+temp_
//         colorwin(12,21,12,21+kol_kl,'n/n')
         Select FNSI
         Seek Main->Lic_Schet
         IF Found()
//            IF AtNum(Substr(strSpisok[ChoicedElement],2,1),FNSI->Gos)#0
            IF cPriznak=="".or.AtNum(Substr(strSpisok[ChoicedElement],2,1),FNSI->Gos)#0
               IsCalck:=.F.
               nSumma:=GetSum(Main->Lic_Schet,nMonth)
               nOplata:=CalckPay(nMonth,Main->Lic_Schet,.f.)
               nRashod:=GetRashod(Main->Lic_Schet,nMonth)
               DO Case
                  Case IsAll==1
                        IF nSumma!=0.or.nOplata!=0
                                  IF IsFilter
                                          IF Eval(cFilter)
                                 IsCalck:=.T.
                                ENDIF
                        ELSE
                                 IsCalck:=.T.
                        ENDIF
                       ENDIF
                  Case IsAll==2
                                 IF IsFilter
                                                IF Eval(cFilter)
                                                 IsCalck:=.T.
                                        ENDIF
                         ELSE
                                                IsCalck:=.T.
                         ENDIF
               ENDCASE
               IF IsCalck
                  Lgota :=GetLgota(   Main->Lic_Schet,nMonth)
                  sLimit:=GetSocLimit(Main->Lic_Schet,nMonth)
                  cText:="│"+Str(Main->Lic_Schet,6)+"│"+Space(20-Len(Substr(Main->Potrebitel,1,20)))+Substr(Main->Potrebitel,1,20)+"│"+;
                         Padr(AllTrim(GetcUl(FNSI->KUL))+" "+;
                         AllTrim(FNSI->Dm)+" "+AllTrim(FnSi->Kv),25," ")+;
                         "│"+Str(nRashod,11,0)+;
                         "│"+Str(nSumma,11,2)+"│"+Str(nOplata,11,2)+"│"+;
                         Str(Lgota[1],6,0)+"│"+Str(Lgota[2],9,2)+"│"+;
                         Str(SLimit[1],7,0)+"│"+Str(SLimit[2],9,2)+"│"+;
                         FNSI->GOS+"│"+CrLF
                  FWrite(Desc,cText)
                  aItog[1]:=aItog[1]+nSumma
                  aItog[2]:=aItog[2]+nOplata
                  aItog[3]:=aItog[3]+Lgota[1]
                  aItog[4]:=aItog[4]+Lgota[2]
                  aItog[5]:=aItog[5]+Slimit[1]
                  aItog[6]:=aItog[6]+Slimit[2]
                  aItog[7]:=aItog[7]+nRashod
                  aItog[8]:=aItog[8]+1
               ENDIF
            ENDIF
         ENDIF
         Select Main
         Skip
      ENDDO
      FWrite(Desc,"├──────┼────────────────────┼─────────────────────────┼───────────┼───────────┼───────────┼──────┼─────────┼───────┼─────────┼────────┤"+CrLf)
      FWrite(Desc,"│"+Str(aItog[8],6)+"│                    │                         │"+;
                         Str(aItog[7],11,0)+"│"+Str(aItog[1],11,2)+"│"+;
                         Str(aItog[2],11,2)+"│"+;
                         Str(aItog[3],6,0)+"│"+Str(aItog[4],9,2)+"│"+;
                         Str(aItog[5],7,0)+"│"+Str(aItog[6],9,2)+"│        │"+CrLF)
      FWrite(Desc,"└──────┴────────────────────┴─────────────────────────┴───────────┴───────────┴───────────┴──────┴─────────┴───────┴─────────┴────────┘"+CrLf)
      Fclose(Desc)
                oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
                oDlg:Destroy()
   ENDIF
ENDIF
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL



Function GetcUl(nUl)
Local cUl:="",Rec:=RecNo(),Sel:=Select()
Select Fkods
Seek nUl
IF Found()
   cUl:=FKODS->nUl
ENDIF
Select(Sel)
Go Rec
Return cUl


Function GetLgota(nLic,nMonth)
Local aLgota:={0,0},Sel:=Select(),Rec:=RecNo(),Poisk:=""
Select Licevoj
Seek nLic
IF Found()
   Do While nLic==Lic_Sch
      Poisk='('+alltrim(str(nLic))+')'+alltrim(licevoj->schetchik)
      Select(nMonth)
      Seek Poisk
      IF Found()
         IF .not.Empty(Info)
            aLgota[1]=aLgota[1]+Val(GetStrToken(Info,1,";"))
            aLgota[2]=aLgota[2]+Val(GetStrToken(Info,2,";"))
         ENDIF
      ENDIF
      Select Licevoj
      SKIP
   ENDDO
ENDIF
Return aLgota


Function GetSocLimit(nLic,nMonth)
Local aLgota:={0,0},Sel:=Select(),Rec:=RecNo(),Poisk:=""
Select Licevoj
Seek nLic
IF Found()
   Do While nLic==Lic_Sch
      Poisk='('+alltrim(str(nLic))+')'+alltrim(licevoj->schetchik)
      Select(nMonth)
      Seek Poisk
      IF Found()
         IF .not.Empty(Info)
            aLgota[1]=aLgota[1]+Val(GetStrToken(Info,4,";"))
            aLgota[2]=aLgota[2]+Val(GetStrToken(Info,3,";"))
         ENDIF
      ENDIF
      Select Licevoj
      SKIP
   ENDDO
ENDIF
Return aLgota


Function ChastnKvit()
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,name
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
   if (.not. file(Schet_Share+'fosn.dbf'))
        sign(2)
        set color to (color_buf)
        restscreen(0,0,24,79,buff)
        return Nil
//        Go Top
   endif
endif
colorwin(6,0,21,79,'w/w')
set color to n/w
name='Справочник введенных квитанций'
@ 6,(79-len(name))/2 say name
declare zgl[4]
declare fil[4]
nm1=loarr('zgl','Лицевой',"Дата","Показания","Сумма")
nm2=loarr('fil','Ka',"DOP","PO","SM")
inp='10'
select FOSN
Seek Main->Lic_Schet
//Set Filter To Ka=Main->Lic_Schet
//go top
******* Begin make box
t1=7
l1=1
b1=20
r1=78
******** End make box
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
Set Filter To
Go Top
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
return NIL
*********************************




Function WriteChastnBase()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Temp_:=0,Kol_Kl:=0
IF Al_Box({"Другие пользователи должны выйти из программы"},2)==1
   Obrabot("Запись поступивших квитанций")
   Select FOSN
   Go Top
   temp_=39/reccount()
   kol_kl=0
   Do While !EOF()
      Kol_Kl=Kol_Kl+Temp_
      ColorWin(12,21,12,21+kol_kl,'n/n')
      Select FYear
      IF NetAppend()
         Replace KA        With FOSN->KA
         Replace DOP       With Fosn->DOP
         Replace VO        With Fosn->VO
         Replace PO        With Fosn->PO
         Replace SM        With Fosn->SM
         Replace KOD       With Fosn->KOD
         Replace Vid_Dokum With Fosn->Vid_Dokum
         Replace Num_Dokum With Fosn->Num_Dokum
         Replace Reestr    With Fosn->Reestr
         Replace User      With Fosn->User
         UNLOCK
      ENDIF
      Select FOSN
      Skip
   ENDDO
   Select FOSN
   Close
   Select 104
   Obrabot("Попытка блокировки базы данных")
   IF NetUse(SCHET_SHARE+"FOSN.dbf",.t.,10)
      ZAP
      Close
      make_ind('0',schet_share+'Fosn.dbf',schet_share+'Fosn.ntx','KA',,,.t.,.t.)
      make_ind('0',schet_share+'Fosn.dbf',schet_share+'FosnCS.ntx','CHSearch',,,.t.,.t.)
      make_ind('0',schet_share+'Fosn.dbf',schet_share+'FosnKOD.ntx','KOD',,,.t.,.t.)
      load("104",SCHET_SHARE+"FOSN.dbf",SCHET_SHARE+'FOSN.ntx',SCHET_SHARE+'FOSNCS.ntx',  .f.,SCHET_SHARE+'FOSNKOD.ntx')
   ENDIF
ENDIF
Select(Sel)
Go Rec
Win_Rest(Scr)
Return NIL




/*

Function EditFsch()
      LOCAL nEvent, mp1, mp2, obj,aSize
      LOCAL oEdit, oBrowse,oldFocus:=SetAppFocus()

         aSize := oMainWindow:currentSize()
//         aSize := { aSize[5] - aSize[3], ;
//                    aSize[6] - aSize[4]  }

      Select FSch
      GO Top

//          SIZE 23,68 ;
      APPBROWSE INTO oBrowse ;
      PARENT oMainWindow;
      SIZE {550,aSize[2]-80};
          TITLE "Справочник счетчиков" ;
                POSITION LEFT, TOP ;
          FONT "Lucida Console";
          STYLE 3D

        APPFIELD KTS            INTO oBrowse    CAPTION "Код"
        APPFIELD ZNS            INTO oBrowse    CAPTION "Значность"
        APPFIELD TS                     INTO oBrowse    CAPTION "Тип"
        APPFIELD ST                     INTO oBrowse    CAPTION "Ток"
        APPFIELD SRPOV  INTO oBrowse    CAPTION "Срок поверки"

        APPEDIT INTO oEdit;
        STYLE 3D+APPSTYLE_RAISED;
        SIZE    15,70;
                POSITION RIGHT, TOP ;
        FONT                     "Lucida Console";
        CAPTION COLOR GRA_CLR_BLUE ALIGN RIGHT;
        TRIGGER "ConfirmAppend1" ON UPDATE;
        TRIGGER "ConfirmAppend1" ON INSERT;
        TRIGGER "ConfirmAppend1" ON DELETE

        APPFIELD KTS            INTO oEdit      CAPTION "Код"
        APPFIELD ZNS            INTO oEdit      CAPTION "Значность"
        APPFIELD TS                     INTO oEdit      CAPTION "Тип"
        APPFIELD ST                     INTO oEdit      CAPTION "Ток"
        APPFIELD SRPOV  INTO oEdit      CAPTION "Срок поверки"

        APPDISPLAY oBrowse MODELESS
        APPDISPLAY oEdit MODELESS

      DO WHILE nEvent <> xbeP_Close
         nEvent := AppEvent( @mp1, @mp2, @obj )
         obj:handleEvent( nEvent, mp1, mp2 )
      ENDDO

      oBrowse:Destroy()
      oEdit:Destroy()
      Select Main
      SetAppFocus(oldFocus)
Return NIL


Function ConfirmAppend1()
IsCorrect("Изменение спр. счетчиков",.f.)
Return APPOP_PROCEED





Function EditTarif()
      LOCAL nEvent, mp1, mp2, obj,aSize
      LOCAL oEdit, oBrowse,oldFocus:=SetAppFocus()

         aSize := oMainWindow:currentSize()
      Select FVO
      GO Top

//          SIZE 23,78 ;
      APPBROWSE INTO oBrowse ;
      PARENT oMainWindow;
      TITLE "Справочник тарифов" ;
      SIZE {620,aSize[2]-80};
                POSITION LEFT, TOP ;
          FONT "Lucida Console";
          STYLE 3D

        APPFIELD KVO            INTO oBrowse    CAPTION "Код"
        APPFIELD OPLATA INTO oBrowse    CAPTION "Вид оплаты"


//        HEADING "Редактирование тарифов" ;
//              POSITION  CENTER ;
        APPEDIT INTO oEdit;
        STYLE 3D ;
        SIZE    15,70;
                POSITION RIGHT, TOP ;
        FONT                     "Lucida Console";
        CAPTION COLOR GRA_CLR_BLUE ALIGN RIGHT;
        TRIGGER "ConfirmAppend" ON UPDATE;
        TRIGGER "ConfirmAppend" ON INSERT;
        TRIGGER "ConfirmAppend" ON DELETE

        APPFIELD KVO            INTO oEdit      CAPTION "Код"
        APPFIELD OPLATA INTO oEdit      CAPTION "Вид оплаты"
        APPFIELD TARIF  INTO oEdit      CAPTION "Основной тариф"
        APPFIELD TARIF4 INTO oEdit      CAPTION "Льготный тариф"


        APPDISPLAY oBrowse MODELESS
        APPDISPLAY oEdit MODELESS

      DO WHILE nEvent <> xbeP_Close
         nEvent := AppEvent( @mp1, @mp2, @obj )
         obj:handleEvent( nEvent, mp1, mp2 )
      ENDDO

      oBrowse:Destroy()
      oEdit:Destroy()
      Select Main
      SetAppFocus(oldFocus)

Return NIL


Function ConfirmAppend()
IsCorrect("Изменение тарифа",.f.)
Return APPOP_PROCEED

*/



Function EditFsch()
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,name
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
   if (.not. file(Schet_Share+'fsch.dbf'))
        sign(2)
        set color to (color_buf)
        restscreen(0,0,24,79,buff)
        return Nil
//        Go Top
   else
                  Select FSCH
                  Go Top
   endif
endif
colorwin(6,0,21,79,'w/w')
set color to n/w
name='Справочник типов счетчиков'
@ 6,(79-len(name))/2 say name
declare zgl[5]
declare fil[5]
nm1=loarr('zgl','Код',"Значность","Тип","Ток","Поверка")
nm2=loarr('fil','KTS',"ZNS","TS","ST","SRPOV")
inp='000000000'
//select FOSN
//Seek Main->Lic_Schet
//Set Filter To Ka=Main->Lic_Schet
//go top
******* Begin make box
t1=7
l1=1
b1=20
r1=78
******** End make box
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
Set Filter To
Go Top
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
Return NIL








Function EditTarif()
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,name
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
   if (.not. file(Schet_Share+'fvo.dbf'))
        sign(2)
        set color to (color_buf)
        restscreen(0,0,24,79,buff)
        return Nil
//        Go Top
   else
//                              load("180",Schet_Share+"Fsign.dbf",Schet_Share+"Fsign.ntx",,  .f.)
                  Select Fvo
                  Go Top
   endif
endif
colorwin(6,0,21,79,'w/w')
set color to n/w
name='Справочник тарифов'
@ 6,(79-len(name))/2 say name
declare zgl[4]
declare fil[4]
nm1=loarr('zgl','Код',"Вид оплаты","Тариф","Тариф льгот")
nm2=loarr('fil','KVO',"OPLATA","TARIF","TARIF4")
inp='000000000'
//select FOSN
//Seek Main->Lic_Schet
//Set Filter To Ka=Main->Lic_Schet
//go top
******* Begin make box
t1=7
l1=1
b1=20
r1=78
******** End make box
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
Set Filter To
Go Top
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
Return NIL






Function EditSign()
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,name
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
   if (.not. file(Schet_Share+'Fsign.dbf').or..not.file(Schet_Share+'Fsign.ntx'))
        sign(2)
        set color to (color_buf)
        RestScreen(0,0,24,79,buff)
        Return Nil
   else
                                load("187",Schet_Share+"Fsign.dbf",Schet_Share+"Fsign.ntx",,  .f.)
                  Select Fsign
                  Go Top
   endif
endif
colorwin(6,0,21,79,'w/w')
set color to n/w
name='Справочник признаков'
@ 6,(79-len(name))/2 say name
Declare zgl[2]
Declare fil[2]
nm1=loarr('zgl','Симовл',"Признак")
nm2=loarr('fil','Symbol',"Name")
inp='00'
******* Begin make box
t1=7
l1=1
b1=20
r1=78
******** End make box
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
Select Fsign
Close
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
Return NIL






Function SberBankOut()
Local oDlg,aSizeDeskTop,aPos,oProgress,PrevPok:={},Desc,CrLf:=Chr(13)+Chr(10),cStr:="",cOutFile:=""
Local Sel:=Select(),Rec:=Recno(),nMc:=Len(AllTrim(Main->LockMonth))+1,Count:=0,cService:="5737"
Local nFileSum:=0,nSaldo:=0,nChoice:=3
// nChoice:=ChoiceBox('Выгрузить данные для Сбербанка',{" 5737 "," 6561 "," Отказ "})
nChoice:=ChoiceBox('Выгрузить данные для Сбербанка',{" Выгрузить"," Отказ "})
IF nChoice#2
        cService:=IF(nChoice==1,"5737","6561")
        oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
        aSizeDesktop  := oMainWindow:currentSize()
        oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
        oDlg:title    := "Выгрузка данных для Сберанка за "+Mesqc(nMc)
        oDlg:SysMenu     := .F.
        oDlg:Configure()
        oDlg:Show()
        aSizeDesktop    := oDlg:currentSize()
        aPos                                            := oDlg:CurrentPos()
        oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
        oProgress:create()
        oProgress:minimum := 1
        oProgress:maximum := RecCount()
        Select Main
        Go Top
        Do While !EOF()
         oProgress:increment()                                                                                  // Progress Bar Increment
         IF Main->Lic_Schet>99999
                        Select FNSI
                        Seek Main->Lic_Schet
                        PrevPok:=GetPrevPok(Main->Lic_Schet,nMc)
                        IF Found()
                                 Count:=Count+1
                                 nSaldo:=0
//                               nSaldo:=GetSaldo(Main->Lic_Schet,nMc)
                                 nFileSum:=nFileSum+nSaldo
                                 cText:=MyUpper(AllTrim(Main->Potrebitel))+";Анапа, "+;
                                              MyUpper(AllTrim(AllTrim(GetCul(FNSI->KUL))+", "+AllTrim(FNSI->DM)+", "+AllTrim(FNSI->KV)))+";"+;
                                              AllTrim(Str(Main->Lic_Schet,6))+";"+;
                                              AllTrim(Str(nSaldo,12,2))+";;;;"+"5737:"+;
                                              AllTrim(Str(PrevPok[1],8))+":"+;
                                              CharRepl(".",DTOC(PrevPok[2]),"/")+CrLf
                                 cOutFile:=cOutFile+ConvToAnsiCP(cText)

                        ENDIF
                        Select Main
         ENDIF
//       IF Count==20
//                      Exit
//       ENDIF
                 Skip
        ENDDO
        Desc:=FCreate(dDir+"Bank5737.txt")
        FWrite(Desc,"#FILESUM "+AllTrim(Str(nFileSum,12,2))+CrLf)
        FWrite(Desc,"#SERVICE 5737"+CrLf)
        FWrite(Desc,"#TYPE    7"+CrLf)
        FWrite(Desc,ConvToAnsiCP('#NOTE    Реестр Анапского филиала "НЭСК"')+CrLf)
  FWrite(Desc,cOutFile)
        FClose(Desc)

        Desc:=FCreate(dDir+"Bank6561.txt")
        FWrite(Desc,"#FILESUM "+AllTrim(Str(nFileSum,12,2))+CrLf)
        FWrite(Desc,"#SERVICE 6561"+CrLf)
        FWrite(Desc,"#TYPE    7"+CrLf)
        FWrite(Desc,ConvToAnsiCP('#NOTE    Реестр Анапского филиала "НЭСК"')+CrLf)
  FWrite(Desc,cOutFile)
        FClose(Desc)
  oProgress:destroy()                                                                                                                                                                                   // Progress Bar Destroy
  oDlg:Destroy()
ENDIF
Select(Sel)
Go Rec
Return NIL



Function EmptyFunction()
Return NIL




Function ReadBank()
Local cStr,cStr1,cStr2,nLic,nSum,dDat,nPok
aBank:={}
BankFile:=FileList("*.txt",Schet_Share )
IF Empty(BankFile)
   Al_Box({"Не выбран реестр банка. Загрузка прервана"})
   Return NIL
ENDIF

cStr:=ConvToOemCP(Memoread(BankFile))
For I=13 To MlCount(cStr,350)
    cStr1:=MemoLine(cStr,350,I)
    nLic:=Val(GetStrToken(cStr1,3,";"))   // Лицевой счет
        nSum:=Val(GetStrToken(cStr1,4,";"))   // Сумма Оплаты
        dDat:=CTOD(GetStrToken(cStr1,9,";"))  // Дата Оплаты
        cStr2:=GetStrToken(cStr1,8,";")                 // Выбор подстроки с показаниями
    cStr2:=cStr2+":0"
    IF Val(Substr(cStr2,1,5))==57371
         cStr2:="0:"+cStr2
    ENDIF
//    @ 2,0 Say cStr2+Space(20)
//    Inkey(0)
        nPok:=Val(GetStrToken(cStr2,3,":"))      // Показания
        AADD(aBank,{nLic,nSum,dDat,nPok,.T.,0})
Next
Return NIL




Function DataUstan()
Local Sel:=Select(),Rec:=RecNo(),aSch:={0,0,0},Desc,CrLf:=Chr(13)+Chr(10),aStr:={"","",""}
Local oDlg,aSizeDeskTop,aPos,oProgress

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := "Обработано"
oDlg:SysMenu    := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos                                    := oDlg:CurrentPos()
oProgress               := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()

Do While !EOF()
         Select FNSI
         Seek Main->Lic_Schet
         Do While Main->Lic_Schet==KA
                        Select Licevoj
                        Seek Main->Lic_Schet
                        Select FNSI
                        DO Case
                                 CASE Year(DU)<1981
                                                        aSch[1]=aSch[1]+1
                                                        aStr[1]:=aStr[1]+Str(Main->Lic_Schet,6)+" "+FNSI->FAM+" "+Licevoj->Adres+CrLf
                                 CASE Year(DU)>=1981.and.Year(DU)<1991
                                                        aSch[2]=aSch[2]+1
                                                        aStr[1]:=aStr[1]+Str(Main->Lic_Schet,6)+" "+FNSI->FAM+" "+Licevoj->Adres+CrLf
                                 CASE Year(DU)>=1991.and.Year(DU)<2001
                                                        aSch[3]=aSch[3]+1
                                                        aStr[1]:=aStr[1]+Str(Main->Lic_Schet,6)+" "+FNSI->FAM+" "+Licevoj->Adres+CrLf
                        ENDCASE
                        SKIP
         ENDDO
         Select Main
         Skip
ENDDO
Desc:=Fcreate(dDir+ReportFile)
FWrite(Desc,"До 1981г"+CrLf+aStr[1]+CrLf)
FWrite(Desc,"1981-1991г"+CrLf+aStr[2]+CrLf)
FWrite(Desc,"1991-2001г"+CrLf+aStr[3])
FClose(Desc)

oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
oDlg:Destroy()

Al_Box({"Всего счетчиков до 1981г.    - "+AllTrim(Str(aSch[1])),;
                          "Всего счетчиков 1981-1991г.  - "+AllTrim(Str(aSch[2])),;
                          "Всего счетчиков 1991-2001г.  - "+AllTrim(Str(aSch[3]))  })

Select(Sel)
Go Rec
Return NIL






FUNCTION CrtBox( nT, nL, nB, nR, cTitle, bAction )
   LOCAL oAppWindow, cColor, nCursor, oError
   LOCAL oCrt, nRowCount, nColCount, nX, nY, xReturn

   oAppWindow := SetAppWindow()

   IF .NOT. oAppWindow:isDerivedFrom( "XbpCrt" )
     /*
      * This function requires SetAppWindow() to return a XbpCrt window
      */
      oError               := Error():new()
      oError:description   := "SetAppwindow() must return an XbpCrt window"
      oError:canDefault    := .F.
      oError:canRetry      := .F.
      oError:canSubstitute := .F.
      oError:operation     := "CrtBox"
      oError:args          := { nT, nL, nB, nR, cTitle, bAction }
      Break( oError )
   ENDIF

   DEFAULT nT      TO 0        , ;
           nL      TO 0        , ;
           nB      TO MaxRow() , ;
           nR      TO MaxCol() , ;
           cTitle  TO " "

  /*
   * Calculate graphical coordinates from text coordinates (row/col -> x/y)
   */
   nRowCount  := nB - nT + 1
   nColCount  := nR - nL + 1
   nX         := nL * oAppWindow:fontWidth
   nY         := ( MaxRow() - nB ) * oAppWindow:fontHeight
   nX         += oAppWindow:currentPos()[1]
   nY         += oAppWindow:currentPos()[2]
   cColor     := SetColor()
   nCursor    := SetCursor()

  /*
   * Create new XbpCrt window
   */
   oCrt := XbpCrt():new( AppDeskTop(), oAppWindow, {nX,nY}, nRowCount, nColCount, cTitle )
   oCrt:minmax       := .F.
   oCrt:sysmenu      := .F.
   oCrt:closeable    := .F.
   oCrt:clipChildren := .F.
   oCrt:border       := XBPDLG_RECESSEDBORDERTHICK_FIXED
   oCrt:fontName     := oAppwindow:fontName
   oCrt:fontHeight   := oAppWindow:fontHeight
   oCrt:fontWidth    := oAppWindow:fontWidth
   oCrt:create()

   SetAppWindow( oCrt )
   SetColor( "N/W" )
   CLS

   SetColor ( cColor  )
   SetCursor( nCursor )
   SetMouse ( .T. )

  /*
   * Switch to modal state and give focus
   */
   oCrt:setModalState( XBP_DISP_APPMODAL )
   SetAppFocus( oCrt )

  /*
   * Procedure is called from the received code block
   */
   xReturn := Eval( bAction )

  /*
   * Clean up
   */
   ClearBuffer()
   Clear Typeahead
   oCrt:setModalState( XBP_DISP_MODELESS )
   oCrt:destroy()

   SetAppWindow( oAppWindow )
   SetAppFocus ( oAppWindow )
   ClearBuffer()
   Clear Typeahead
RETURN xReturn





Function DateChastn(EndDate)
Local oXbp2
oXbp2 := XbpPushButton():new()
oXbp2:caption := "Ok"
oXbp2:create(,,{150,1},{99,30})
oXbp2:activate := {|| Button2(xbeK_RETURN) }
Set Cursor On
@ 1,1 say "Дата   " Get EndDate Picture "@D99.99.9999"
Read
Set Cursor Off
oXbp2:destroy()
Return EndDate


Function Button2(cEvent)
//Keyboard Chr(13)+Chr(13)
PostAppEvent(xbeK_RETURN)
Return NIL



Function GetNMonth()
Local oXbp2,EndDate:=New_Date
oXbp2 := XbpPushButton():new()
oXbp2:caption := "Ok"
oXbp2:create(,,{150,1},{99,30})
oXbp2:activate := {|| Button2(xbeK_RETURN) }
Set Cursor On
@ 1,1 say "Задолжник с " Get EndDate Picture "@D99.99.9999"
Read
Set Cursor Off
oXbp2:destroy()
Return EndDate






Function ChDolgMonth()
Local Rec:=RecNo(),Sel:=Select()
Local oDlg,aSizeDeskTop,aPos,oProgress
Local EndDate,cStr:="",Desc,CrLf:=Chr(13)+Chr(10),AMaxPok:={0,0},nDolg,nLic
load("181",Schet_Share +"Subsidii.dbf",,,  .f.)

cStr:=     " ----------------------------------------------------------------------------------------------------------------"+CrLf
cStr:=cStr+"|  Л/с |          Ф И О                         |            Адрес                       |  Дата    |    Сумма   |"+CrLf
cStr:=cStr+"|      |                                        |                                        | оплаты   |    долга   |"+CrLf
cStr:=cStr+" ----------------------------------------------------------------------------------------------------------------"+CrLf


CrtBox(10,10,13,37,"Задолжник",{|| EndDate:=GetNMonth()})
//IF EndDate>0


//        Select Main
        Go Top

        oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
        aSizeDesktop  := oMainWindow:currentSize()
        oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
        oDlg:title    := "Выбор задолжников с "+DTOC(EndDate)
        oDlg:SysMenu    := .F.
        oDlg:Configure()
        oDlg:Show()
        aSizeDesktop  := oDlg:currentSize()
        aPos                                    := oDlg:CurrentPos()
        oProgress               := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

        oProgress:create()
        oProgress:minimum := 1
        oProgress:maximum := RecCount()
        Do While !EOF()
        		oProgress:increment()                                                                                   // Progress Bar Increment
		    		nLic=Val(Glava)
        		select Main
        		seek nLic
        		IF Found()
        			IF Main->Lic_Schet>99999
                  nDolg=GetDolg(Main->Lic_Schet,Month(New_Date))
                        IF nDolg>0
                                 aMaxPok:=GetMaxPok(Main->Lic_Schet,Month(New_Date),.T.)
                                 IF aMaxPok[2]<EndDate
                                    cStr:=cStr+"|"+Str(Main->Lic_Schet,6,0)+"|"+Substr(AllTrim(Main->Potrebitel)+Space(40),1,40)+;
                                    	    "|"+Substr(AllTrim(Main->Adress)+Space(40),1,40)+"|"+;
                                          DTOC(aMaxPok[2])+"|"+Str(nDolg,12,2)+"|"+CrLf
                                 ENDIF
                        ENDIF
        			ENDIF
        		ENDIF
        		Select 181
        		Skip
        ENDDO
        Select 181
        Close
//ENDIF
cStr:=cStr+" ----------------------------------------------------------------------------------------------------------------"+CrLf
Desc:=FCreate(dDir+ReportFile)
FWrite(Desc,cStr)
Fclose(Desc)
oProgress:destroy()                                                                                                             // Progress Bar Destroy
oDlg:Destroy()
Select(Sel)
Go Rec
Return NIL



Function PushChastn()
Local Rec:=RecNo(),Sel:=Select()
Local oDlg,aSizeDeskTop,aPos,oProgress
//Private EndDate:=Date()
Local EndDate

CrtBox(10,10,13,30,"Дата выбора",{|| EndDate:=DateChastn(Date())})

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := "Выбор показаний до "+DTOC(EndDate)
oDlg:SysMenu    := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos                                    := oDlg:CurrentPos()
oProgress               := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
Do While !EOF()
   oProgress:increment()                                                                                        // Progress Bar Increment
         Skip
ENDDO
oProgress:destroy()                                                                                                             // Progress Bar Destroy
oDlg:Destroy()
Select(Sel)
Go Rec
Return NIL