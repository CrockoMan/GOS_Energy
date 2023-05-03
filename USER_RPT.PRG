Static IsFiltered:=.F.
Static Potr,Adr,Podkl,TipSch,Dolg:=0.00,Object,NumMon,Dog,TOKENS:=";,"
Static BankSchet


Function UserRpt()
LOCAL Buttons, On_Off, selectables:={}, i, MaxSize,Window:=SaveScreen(0,0,24,79)
LOCAL Clr:=SetColor(),Sel:=Select(),Rec:=Recno(),cDate,Kol_Kl:=0,Desc
Local CrLf:=Chr(13)+Chr(10),Position:={},Head:="",SumR,NumString:=0,Page:=1
LOCAL Itog:={},TmpVal,NumNextMon,cNextDate,InMain:=.T.,NumLic:=-1,Count:=0
LOCAL LenPos:={},Title:={"",""},PagePrefix,Search[4],Chosen
DevOut("")
IF Potr==NIL
   Potr:=Space(100);   Adr:=Space(50);      Podkl:=Space(50)
   TipSch:=Space(50);  Object:=space(50);   NumMon:=Month(new_date)
   Dog:=Space(250);    BankSchet:=Space(50)
ENDIF
NumMon:=IF(NumMon==NIL,Month(new_date),NumMon)
NumNextMon:=IF(NumMon+1<=12,NumMon+1,1)
cDate:=ctod("31."+alltrim(str(NumMon))+"."+substr(alltrim(str(year(new_date))),3,2))
cNextDate:=cToD("01."+alltrim(str(NumNextMon))+"."+substr(alltrim(str(year(new_date))),3,2))
tcDate:="31."+IF(NumMon<10,"0","")+alltrim(str(NumMon))+"."+substr(alltrim(str(year(new_date+3))),3,2)
tcNextDate:="01."+IF(NumMon<10,"0","")+alltrim(str(NumNextMon))+"."+substr(alltrim(str(year(new_date+3))),3,2)
* Распределим и установим кнопки, результат и выбираемость
buttons:={"Договор","Наименование потребителя   ",;
          "Дата договора",;
          "Задолженность за "+CMonth(cDate)+"     ",;
          "Начислено за " +CMonth(cDate),;
          "Расход за "+CMonth(cDate),;
          "Оплата за "+CMonth(cDate),;
          "Сальдо на "+tcDate,;
          "Сальдо на "+tcNextDate,;
          "Пеня "+CMonth(cDate),;
          "Повышенная "+CMonth(cDate),;
          "Срок задолженности",;
          "Лимит на "+CMonth(cDate),;
          "Точка подключения",;
          "Силовая","Освещение",;
          "Ток","В","А",;
          "Тип счетчика","N Счетчика","Год проверки",;
          "Адрес",;
          "Телефон","По объектам","Мощность","Пустое поле"}

* Заполнение массива значениями по умолчанию
ASize(Selectables,Len(Buttons))
ASize(Position,Len(Buttons))
ASize(Itog,Len(Buttons))
ASize(LenPos,Len(Buttons))
afill(LenPos, 0)
afill(Itog, 0)
afill(selectables, .T.)
afill(Position, .F.)
Afill(Search,.F.)

* Заполнение массива названием и длинной элемента
LenPos:={{"Дог.",4},;
         {"Потребитель",30},;
         {"Договор",Len(Dtoc(new_date))},;
         {"Долг",12},;
         {"Начислено",12},;
         {"Расход",12},;
         {"Оплачено",12},;
         {"Сальдо "+TcDate,16},;
         {"Сальдо "+TcNextDate,16},;
         {"Пеня "+CMonth(cDate),16},;
         {"Повышенная "+CMonth(cDate),18},;
         {"Срок задолж",11},;
         {"Лимит",7},;
         {"Подключение",Len(Licevoj->Razdel_1)},;
         {"Cиловая",9},;
         {"Освещение",9},;
         {"Тр/Т",9},;
         {"В",9},;
         {"A",9},;
         {"Тип",9},;
         {"Счетчик",9},;
         {"Проверен",9},;
         {"Адрес",Len(Licevoj->Adres)},;
         {"Телефон",Len(Licevoj->Telefon)},;
         {"",0},;
         {"Мощность",9},;
         {"",30}}


* Невыбираемые кнопки
selectables[2] = .F.

* Начальные выборы
on_off = {1, 2, 5, 9}

MaxSize:=0
for i=1 to len(Buttons)
    MaxSize:=IF(Len(Buttons[i])>MaxSize,Len(Buttons[i])+7,MaxSize)
Next
//chosen = sel_box(3, 10, 3+Len(Buttons)+1, 10+MaxSize, buttons, selectables, ;
chosen = sel_box(3, 10, buttons, selectables, ;
         on_off, 1, 0, .T.,.T.,.F.)

* Теперь высветим возвращенные результаты
FOR I=1 TO LEN(Chosen)
    Position[Chosen[I]]:=.T.
NEXT
IF Al_Box({"Печатать заголовок и окончание"},2,,2)==1
   Title:=GetTitle()
ENDIF
//----------------------------------------- Расчет ожидаемой длинны строки.
Head:="┌"+If(Position[01],Replicate("─",LenPos[1][2])+"┬","")+;
      If(Position[02],Replicate("─",LenPos[2][2])+"┬","")+;
      If(Position[03],Replicate("─",LenPos[3][2])+"┬","")+;
      If(Position[04],Replicate("─",LenPos[4][2])+"┬","")+;
      If(Position[05],Replicate("─",LenPos[5][2])+"┬","")+;
      If(Position[06],Replicate("─",LenPos[6][2])+"┬","")+;
      If(Position[07],Replicate("─",LenPos[7][2])+"┬","")+;
      If(Position[08],Replicate("─",LenPos[8][2])+"┬","")+;
      If(Position[09],Replicate("─",LenPos[9][2])+"┬","")+;
      If(Position[10],Replicate("─",LenPos[10][2])+"┬","")+;
      If(Position[11],Replicate("─",LenPos[11][2])+"┬","")+;
      If(Position[12],Replicate("─",LenPos[12][2])+"┬","")+;
      If(Position[13],Replicate("─",LenPos[13][2])+"┬","")+;
      If(Position[14],Replicate("─",LenPos[14][2])+"┬","")+;
      If(Position[15],Replicate("─",LenPos[15][2])+"┬","")+;
      If(Position[16],Replicate("─",LenPos[16][2])+"┬","")+;
      If(Position[17],Replicate("─",LenPos[17][2])+"┬","")+;
      If(Position[18],Replicate("─",LenPos[18][2])+"┬","")+;
      If(Position[19],Replicate("─",LenPos[19][2])+"┬","")+;
      If(Position[20],Replicate("─",LenPos[20][2])+"┬","")+;
      If(Position[21],Replicate("─",LenPos[21][2])+"┬","")+;
      If(Position[23],Replicate("─",LenPos[23][2])+"┬","")+;
      If(Position[23],Replicate("─",LenPos[23][2])+"┬","")+;
      If(Position[24],Replicate("─",LenPos[24][2])+"┬","")+;
      If(Position[26],Replicate("─",LenPos[26][2])+"┬","")+;
      If(Position[27],Replicate("─",LenPos[27][2])+"┬","")
LenPage:=GetVal("Количество строк на листе ",IF(Len(Head)<150,62,42),-1)
Head:=""
IF LenPage<=0
   RestScreen(0,0,24,79,Window)
   SetColor(Clr)
   Return NIL
ENDIF
SELECT Main
GO Top
Obrabot("Отчет по выбранному условию")
Desc:=FCreate(DDir+ReportFile)
FWrite(Desc,Head)
DevOut("")
DO WHILE .Not.EOF()
   IF Hot_Inkey()==27.and.Al_Box({"Прекратить формирование документа"},2)==1
      EXIT
   ENDIF
   IF NumString==0
      IF Page!=1
         TmpVal:="Страница  N "+AllTrim(str(Page))
         LenTitle:=0
      ELSE
         TmpVal:=""
         FWrite(Desc,Title[1])
         LenTitle:=MlCount(Title[1])
      ENDIF
      NumString:=NumString+4+LenTitle
      Head:="┌"+If(Position[01],Replicate("─",LenPos[1][2])+"┬","")+;
            If(Position[02],Replicate("─",LenPos[2][2])+"┬","")+;
            If(Position[03],Replicate("─",LenPos[3][2])+"┬","")+;
            If(Position[04],Replicate("─",LenPos[4][2])+"┬","")+;
            If(Position[05],Replicate("─",LenPos[5][2])+"┬","")+;
            If(Position[06],Replicate("─",LenPos[6][2])+"┬","")+;
            If(Position[07],Replicate("─",LenPos[7][2])+"┬","")+;
            If(Position[08],Replicate("─",LenPos[8][2])+"┬","")+;
            If(Position[09],Replicate("─",LenPos[9][2])+"┬","")+;
            If(Position[10],Replicate("─",LenPos[10][2])+"┬","")+;
            If(Position[11],Replicate("─",LenPos[11][2])+"┬","")+;
            If(Position[12],Replicate("─",LenPos[12][2])+"┬","")+;
            If(Position[13],Replicate("─",LenPos[13][2])+"┬","")+;
            If(Position[14],Replicate("─",LenPos[14][2])+"┬","")+;
            If(Position[15],Replicate("─",LenPos[15][2])+"┬","")+;
            If(Position[16],Replicate("─",LenPos[16][2])+"┬","")+;
            If(Position[17],Replicate("─",LenPos[17][2])+"┬","")+;
            If(Position[18],Replicate("─",LenPos[18][2])+"┬","")+;
            If(Position[19],Replicate("─",LenPos[19][2])+"┬","")+;
            If(Position[20],Replicate("─",LenPos[20][2])+"┬","")+;
            If(Position[21],Replicate("─",LenPos[21][2])+"┬","")+;
            If(Position[22],Replicate("─",LenPos[22][2])+"┬","")+;
            If(Position[23],Replicate("─",LenPos[23][2])+"┬","")+;
            If(Position[24],Replicate("─",LenPos[24][2])+"┬","")+;
            If(Position[26],Replicate("─",LenPos[26][2])+"┬","")+;
            If(Position[27],Replicate("─",LenPos[27][2])+"┬","")
      Head:=Substr(Head,1,Len(Head)-1)+"┐"+CrLf
      Head:=IF(Len(Head)>82,Schet_Cond,"")+;
            Space(Len(Head)-Len(TmpVal)-3)+TmpVal+CrLf+Head
      NumString:=NumString+IF(Len(Head)>82,LenTitle,0)
      Head:=Head+"│"+If(Position[01],Center(LenPos[1][1],LenPos[1][2]," ",.t.)+"│","")+;
            If(Position[02],Center(LenPos[2][1],LenPos[2][2]," ",.t.)+"│","")+;
            If(Position[03],Center(LenPos[3][1],LenPos[3][2]," ",.t.)+"│","")+;
            If(Position[04],Center(LenPos[4][1],LenPos[4][2]," ",.t.)+"│","")+;
            If(Position[05],Center(LenPos[5][1],LenPos[5][2]," ",.t.)+"│","")+;
            If(Position[06],Center(LenPos[6][1],LenPos[6][2]," ",.t.)+"│","")+;
            If(Position[07],Center(LenPos[7][1],LenPos[7][2]," ",.t.)+"│","")+;
            If(Position[08],Center(LenPos[8][1],LenPos[8][2]," ",.t.)+"│","")+;
            If(Position[09],Center(LenPos[9][1],LenPos[9][2]," ",.t.)+"│","")+;
            If(Position[10],Center(LenPos[10][1],LenPos[10][2]," ",.t.)+"│","")+;
            If(Position[11],Center(LenPos[11][1],LenPos[11][2]," ",.t.)+"│","")+;
            If(Position[12],Center(LenPos[12][1],LenPos[12][2]," ",.t.)+"│","")+;
            If(Position[13],Center(LenPos[13][1],LenPos[13][2]," ",.t.)+"│","")+;
            If(Position[14],Center(LenPos[14][1],LenPos[14][2]," ",.t.)+"│","")+;
            If(Position[15],Center(LenPos[15][1],LenPos[15][2]," ",.t.)+"│","")+;
            If(Position[16],Center(LenPos[16][1],LenPos[16][2]," ",.t.)+"│","")+;
            If(Position[17],Center(LenPos[17][1],LenPos[17][2]," ",.t.)+"│","")+;
            If(Position[18],Center(LenPos[18][1],LenPos[18][2]," ",.t.)+"│","")+;
            If(Position[19],Center(LenPos[19][1],LenPos[19][2]," ",.t.)+"│","")+;
            If(Position[20],Center(LenPos[20][1],LenPos[20][2]," ",.t.)+"│","")+;
            If(Position[21],Center(LenPos[21][1],LenPos[21][2]," ",.t.)+"│","")+;
            If(Position[22],Center(LenPos[22][1],LenPos[22][2]," ",.t.)+"│","")+;
            If(Position[23],Center(LenPos[23][1],LenPos[23][2]," ",.t.)+"│","")+;
            If(Position[24],Center(LenPos[24][1],LenPos[24][2]," ",.t.)+"│","")+;
            If(Position[26],Center(LenPos[26][1],LenPos[26][2]," ",.t.)+"│","")+;
            If(Position[27],Center(LenPos[27][1],LenPos[27][2]," ",.t.)+"│","")
      Head:=Substr(Head,1,Len(Head)-1)+"│"+CrLf
      Head:=Head+"├"+If(Position[01],Replicate("─",LenPos[1][2])+"┼","")+;
            If(Position[02],Replicate("─",LenPos[2][2])+"┼","")+;
            If(Position[03],Replicate("─",LenPos[3][2])+"┼","")+;
            If(Position[04],Replicate("─",LenPos[4][2])+"┼","")+;
            If(Position[05],Replicate("─",LenPos[5][2])+"┼","")+;
            If(Position[06],Replicate("─",LenPos[6][2])+"┼","")+;
            If(Position[07],Replicate("─",LenPos[7][2])+"┼","")+;
            If(Position[08],Replicate("─",LenPos[8][2])+"┼","")+;
            If(Position[09],Replicate("─",LenPos[9][2])+"┼","")+;
            If(Position[10],Replicate("─",LenPos[10][2])+"┼","")+;
            If(Position[11],Replicate("─",LenPos[11][2])+"┼","")+;
            If(Position[12],Replicate("─",LenPos[12][2])+"┼","")+;
            If(Position[13],Replicate("─",LenPos[13][2])+"┼","")+;
            If(Position[14],Replicate("─",LenPos[14][2])+"┼","")+;
            If(Position[15],Replicate("─",LenPos[15][2])+"┼","")+;
            If(Position[16],Replicate("─",LenPos[16][2])+"┼","")+;
            If(Position[17],Replicate("─",LenPos[17][2])+"┼","")+;
            If(Position[18],Replicate("─",LenPos[18][2])+"┼","")+;
            If(Position[19],Replicate("─",LenPos[19][2])+"┼","")+;
            If(Position[20],Replicate("─",LenPos[20][2])+"┼","")+;
            If(Position[21],Replicate("─",LenPos[21][2])+"┼","")+;
            If(Position[22],Replicate("─",LenPos[22][2])+"┼","")+;
            If(Position[23],Replicate("─",LenPos[23][2])+"┼","")+;
            If(Position[24],Replicate("─",LenPos[24][2])+"┼","")+;
            If(Position[26],Replicate("─",LenPos[26][2])+"┼","")+;
            If(Position[27],Replicate("─",LenPos[27][2])+"┼","")
      Head:=Substr(Head,1,Len(Head)-1)+"┤"+CrLf
      FWrite(Desc,Head)
      Page++
   ENDIF
   Head:=""
   Kol_Kl=Kol_Kl+(39/RecCount())
   ColorWin(12,21,12,21+kol_kl,'n/n')
   IF Position[1]
      Head:=Head+"│"+str(Main->Lic_schet,LenPos[1][2],0)
   ENDIF
   IF Position[2]
      Head:=Head+"│"+Substr(Delstring(Main->Potrebitel,"ИНН"),1,LenPos[2][2])+Space(LenPos[2][2]-Len(Substr(Delstring(Main->Potrebitel,"ИНН"),1,LenPos[2][2])))
   ENDIF
   IF Position[3]
      Head:=Head+"│"+dtoc(Data_Dog)+space(LenPos[3][2]-Len(DTOC(Data_Dog)))
   ENDIF
   IF Position[4]
      TmpVal:=GetDolg(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[4][2],Decimal)
      Itog[4]:=Itog[4]+TmpVal
   ENDIF
   IF Position[5]
//      TmpVal:=GetSum(Main->Lic_Schet,NumMon); TmpVal:=TmpVal+Round(TmpVal*Schet_Nds/100,Decimal)
      TmpVal:=GetSum(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+IF(.not.Position[25],str(TmpVal,LenPos[5][2],Decimal),Space(LenPos[4][2]))
      Itog[5]:=Itog[5]+If(.not.Position[25],TmpVal,0)
   ENDIF
   IF Position[6]
      Sumr:=GetRashod(Main->Lic_Schet,NumMon)
//      ; Sumr:=Sumr+Round(Sumr*Schet_Nds/100,Decimal)
      Head:=Head+"│"+IF(.not.Position[25],str(Sumr,LenPos[6][2],Decimal),Space(LenPos[6][2]))
      Itog[6]:=Itog[6]+IF(.not.Position[25],Sumr,0)
   ENDIF
   IF Position[7]
      TmpVal:=CalckPay(NumMon,Main->Lic_Schet,.f.)
      Head:=Head+"│"+str(TmpVal,LenPos[7][2],Decimal)
      Itog[7]:=Itog[7]+TmpVal
   ENDIF
   IF Position[8]
      TmpVal:=GetSaldo(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[8][2],Decimal)
      Itog[8]:=Itog[8]+TmpVal
   ENDIF
   IF Position[9]
      TmpVal:=GetSaldo(Main->Lic_Schet,NumNextMon)
      Head:=Head+"│"+str(TmpVal,LenPos[9][2],Decimal)
      Itog[9]:=Itog[9]+TmpVal
   ENDIF
   IF Position[10]
      TmpVal:=GetPenq(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[10][2],Decimal)
      Itog[10]:=Itog[10]+TmpVal
   ENDIF
   IF Position[11]
      TmpVal:=GetHigh(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[11][2],Decimal)
      Itog[11]:=Itog[11]+TmpVal
   ENDIF
   IF Position[12]
      TmpVal:=SrokDolg(Main->Lic_Schet,NumMon)
      Head:=Head+"│"+str(TmpVal,LenPos[12][2],0)
   ENDIF
   IF Position[13]
      TmpVal:=GetLimit(NumMon,Main->Lic_Schet)
      Head:=Head+"│"+str(TmpVal,LenPos[13][2],Decimal)
      Itog[13]:=Itog[13]+TmpVal
   ENDIF
   IF Position[14]
      Select Licevoj
      Seek Main->Lic_Schet
      Head:=Head+"│"+IF(Position[25],Space(LenPos[14][2]),Razdel_1)
      Select Main
   ENDIF
   IF Position[15]
//      IF .not.Position[25]
         TmpVal:=GetSil(Main->Lic_Schet,1)
         Head:=Head+"│"+Str(TmpVal,LenPos[15][2],2)
         Itog[15]:=Itog[15]+TmpVal
//      ELSE
//         Head:=Head+"│"+Space(LenPos[15][2])
//      ENDIF
   ENDIF
   IF Position[16]
//      IF .not.Position[25]
         TmpVal:=GetSil(Main->Lic_Schet,2)
         Head:=Head+"│"+Str(TmpVal,LenPos[16][2],2)
         Itog[16]:=Itog[16]+TmpVal
//      ELSE
//         Head:=Head+"│"+Space(LenPos[16][2])
//      ENDIF
   ENDIF
   IF Position[17]
      Head:=Head+"│"+space(LenPos[17][2])
   ENDIF
   IF Position[18]
      Head:=Head+"│"+space(LenPos[18][2])
   ENDIF
   IF Position[19]
      Head:=Head+"│"+space(LenPos[19][2])
   ENDIF
   IF Position[20]
      Head:=Head+"│"+space(LenPos[20][2])
   ENDIF
   IF Position[21]
      Head:=Head+"│"+space(LenPos[21][2])
   ENDIF
   IF Position[22]
      Head:=Head+"│"+space(LenPos[22][2])
   ENDIF
   IF Position[23]
      Head:=Head+"│"+Adress+Space(LenPos[23][2]-Len(Adress))
   ENDIF
   IF Position[24]
      Select Licevoj
      Seek Main->Lic_Schet
      Head:=Head+"│"+Telefon+Space(LenPos[24][2]-Len(Telefon))
      Select Main
   ENDIF
   IF Position[26]
      TmpVal:=GetSil(Main->Lic_Schet,1)+GetSil(Main->Lic_Schet,2)
      Head:=Head+"│"+Str(TmpVal,LenPos[26][2],2)
//         Itog[27]:=Itog[27]+TmpVal
   ENDIF
   IF Position[27]
      Head:=Head+"│"+Space(LenPos[27][2])
      Select Main
   ENDIF
   FWrite(Desc,Head+"│"+CrLf)
   NumString++
// Выборка по счетчикам ----------------------------------------------------
   IF Position[25]
      DevOut("")
      Select LICEVOJ
      Seek Main->Lic_Schet
      DO While Lic_Sch==Main->Lic_Schet
         AFill(Search,.F.)
         IF .not.Empty(Podkl)
            FOR I=1 TO NumToken(Podkl,TOKENS)
                IF Atnum(Token(Podkl,TOKENS,I),MYUpper(Razdel_1))!=0
                   Search[1]:=.T.
                   EXIT
                ENDIF
                IF Atnum(Token(Podkl,TOKENS,I),MYUpper(Razdel_2))!=0
                   Search[1]:=.T.
                   EXIT
                ENDIF
            NEXT
         ELSE
            Search[1]:=.T.
         ENDIF
         IF .not.Empty(Adr)
            IF Atnum(Token(Adr,TOKENS,I),Alltrim(MYUpper(Adres)))!=0
               Search[2]:=.T.
               EXIT
            ENDIF
         ELSE
            Search[2]:=.T.
         ENDIF
         IF .Not.Empty(Object)
            FOR I=1 TO NumToken(Object,TOKENS)
                IF Atnum(Token(Object,TOKENS,I),Alltrim(MYUpper(Object1)))!=0
                   Search[3]:=.T.
                   EXIT
                ENDIF
                IF Atnum(Token(Object,TOKENS,I),Alltrim(MYUpper(Object2)))!=0
                   Search[3]:=.T.
                   EXIT
                ENDIF
            NEXT
         ELSE
            Search[3]:=.T.
         ENDIF
         IF .Not.Empty(TipSch)
            FOR I=1 TO NumToken(TipSch,TOKENS)
                IF Atnum(Token(TipSch,TOKENS,I),Alltrim(MYUpper(Tip)))!=0
                   Search[4]:=.T.
                   EXIT
                ENDIF
            NEXT
         ELSE
            Search[4]:=.T.
         ENDIF
         IF .not.Search[1].or..not.Search[2].or..not.Search[3].or.;
            .not.Search[4]
            SKIP
            LOOP
         ENDIF
//         IF Alltrim(Upper(Schetchik))=="ВОЗВРАТ".or.;
//            Alltrim(Upper(Schetchik))=="АБОН.МОЩН".or.;
//            Alltrim(Upper(Schetchik))=="ДОНАЧ".or.;
//            Alltrim(Upper(Schetchik))=="ПО АКТУ"
//            SKIP
//            LOOP
//         ENDIF
         IF NumString==0
            TmpVal:=IF(Page!=1,"Страница  N "+AllTrim(str(Page)),"")
            NumString:=NumString+4
            Head:="┌"+If(Position[01],Replicate("─",LenPos[1][2])+"┬","")+;
                  If(Position[02],Replicate("─",LenPos[2][2])+"┬","")+;
                  If(Position[03],Replicate("─",LenPos[3][2])+"┬","")+;
                  If(Position[04],Replicate("─",LenPos[4][2])+"┬","")+;
                  If(Position[05],Replicate("─",LenPos[5][2])+"┬","")+;
                  If(Position[06],Replicate("─",LenPos[6][2])+"┬","")+;
                  If(Position[07],Replicate("─",LenPos[7][2])+"┬","")+;
                  If(Position[08],Replicate("─",LenPos[8][2])+"┬","")+;
                  If(Position[09],Replicate("─",LenPos[9][2])+"┬","")+;
                  If(Position[10],Replicate("─",LenPos[10][2])+"┬","")+;
                  If(Position[11],Replicate("─",LenPos[11][2])+"┬","")+;
                  If(Position[12],Replicate("─",LenPos[12][2])+"┬","")+;
                  If(Position[13],Replicate("─",LenPos[13][2])+"┬","")+;
                  If(Position[14],Replicate("─",LenPos[14][2])+"┬","")+;
                  If(Position[15],Replicate("─",LenPos[15][2])+"┬","")+;
                  If(Position[16],Replicate("─",LenPos[16][2])+"┬","")+;
                  If(Position[17],Replicate("─",LenPos[17][2])+"┬","")+;
                  If(Position[18],Replicate("─",LenPos[18][2])+"┬","")+;
                  If(Position[19],Replicate("─",LenPos[19][2])+"┬","")+;
                  If(Position[20],Replicate("─",LenPos[20][2])+"┬","")+;
                  If(Position[21],Replicate("─",LenPos[21][2])+"┬","")+;
                  If(Position[22],Replicate("─",LenPos[22][2])+"┬","")+;
                  If(Position[23],Replicate("─",LenPos[23][2])+"┬","")+;
                  If(Position[24],Replicate("─",LenPos[24][2])+"┬","")+;
                  If(Position[26],Replicate("─",LenPos[26][2])+"┬","")+;
                  If(Position[27],Replicate("─",LenPos[27][2])+"┬","")
            Head:=Substr(Head,1,Len(Head)-1)+"┐"+CrLf
            Head:=IF(Len(Head)>82,Schet_Cond,"")+;
                  Space(Len(Head)-Len(TmpVal)-3)+TmpVal+CrLf+Head
            Head:=Head+"│"+If(Position[01],Center(LenPos[1][1],LenPos[1][2]," ",.t.)+"│","")+;
                  If(Position[02],Center(LenPos[2][1],LenPos[2][2]," ",.t.)+"│","")+;
                  If(Position[03],Center(LenPos[3][1],LenPos[3][2]," ",.t.)+"│","")+;
                  If(Position[04],Center(LenPos[4][1],LenPos[4][2]," ",.t.)+"│","")+;
                  If(Position[05],Center(LenPos[5][1],LenPos[5][2]," ",.t.)+"│","")+;
                  If(Position[06],Center(LenPos[6][1],LenPos[6][2]," ",.t.)+"│","")+;
                  If(Position[07],Center(LenPos[7][1],LenPos[7][2]," ",.t.)+"│","")+;
                  If(Position[08],Center(LenPos[8][1],LenPos[8][2]," ",.t.)+"│","")+;
                  If(Position[09],Center(LenPos[9][1],LenPos[9][2]," ",.t.)+"│","")+;
                  If(Position[10],Center(LenPos[10][1],LenPos[10][2]," ",.t.)+"│","")+;
                  If(Position[11],Center(LenPos[11][1],LenPos[11][2]," ",.t.)+"│","")+;
                  If(Position[12],Center(LenPos[12][1],LenPos[12][2]," ",.t.)+"│","")+;
                  If(Position[13],Center(LenPos[13][1],LenPos[13][2]," ",.t.)+"│","")+;
                  If(Position[14],Center(LenPos[14][1],LenPos[14][2]," ",.t.)+"│","")+;
                  If(Position[15],Center(LenPos[15][1],LenPos[15][2]," ",.t.)+"│","")+;
                  If(Position[16],Center(LenPos[16][1],LenPos[16][2]," ",.t.)+"│","")+;
                  If(Position[17],Center(LenPos[17][1],LenPos[17][2]," ",.t.)+"│","")+;
                  If(Position[18],Center(LenPos[18][1],LenPos[18][2]," ",.t.)+"│","")+;
                  If(Position[19],Center(LenPos[19][1],LenPos[19][2]," ",.t.)+"│","")+;
                  If(Position[20],Center(LenPos[20][1],LenPos[20][2]," ",.t.)+"│","")+;
                  If(Position[21],Center(LenPos[21][1],LenPos[21][2]," ",.t.)+"│","")+;
                  If(Position[22],Center(LenPos[22][1],LenPos[22][2]," ",.t.)+"│","")+;
                  If(Position[23],Center(LenPos[23][1],LenPos[23][2]," ",.t.)+"│","")+;
                  If(Position[24],Center(LenPos[24][1],LenPos[24][2]," ",.t.)+"│","")+;
                  If(Position[26],Center(LenPos[26][1],LenPos[26][2]," ",.t.)+"│","")+;
                  If(Position[27],Center(LenPos[27][1],LenPos[27][2]," ",.t.)+"│","")
            Head:=Substr(Head,1,Len(Head)-1)+"│"+CrLf
            Head:=Head+"├"+If(Position[01],Replicate("─",LenPos[1][2])+"┼","")+;
                  If(Position[02],Replicate("─",LenPos[2][2])+"┼","")+;
                  If(Position[03],Replicate("─",LenPos[3][2])+"┼","")+;
                  If(Position[04],Replicate("─",LenPos[4][2])+"┼","")+;
                  If(Position[05],Replicate("─",LenPos[5][2])+"┼","")+;
                  If(Position[06],Replicate("─",LenPos[6][2])+"┼","")+;
                  If(Position[07],Replicate("─",LenPos[7][2])+"┼","")+;
                  If(Position[08],Replicate("─",LenPos[8][2])+"┼","")+;
                  If(Position[09],Replicate("─",LenPos[9][2])+"┼","")+;
                  If(Position[10],Replicate("─",LenPos[10][2])+"┼","")+;
                  If(Position[11],Replicate("─",LenPos[11][2])+"┼","")+;
                  If(Position[12],Replicate("─",LenPos[12][2])+"┼","")+;
                  If(Position[13],Replicate("─",LenPos[13][2])+"┼","")+;
                  If(Position[14],Replicate("─",LenPos[14][2])+"┼","")+;
                  If(Position[15],Replicate("─",LenPos[15][2])+"┼","")+;
                  If(Position[16],Replicate("─",LenPos[16][2])+"┼","")+;
                  If(Position[17],Replicate("─",LenPos[17][2])+"┼","")+;
                  If(Position[18],Replicate("─",LenPos[18][2])+"┼","")+;
                  If(Position[19],Replicate("─",LenPos[19][2])+"┼","")+;
                  If(Position[20],Replicate("─",LenPos[20][2])+"┼","")+;
                  If(Position[21],Replicate("─",LenPos[21][2])+"┼","")+;
                  If(Position[22],Replicate("─",LenPos[22][2])+"┼","")+;
                  If(Position[23],Replicate("─",LenPos[23][2])+"┼","")+;
                  If(Position[24],Replicate("─",LenPos[24][2])+"┼","")+;
                  If(Position[26],Replicate("─",LenPos[26][2])+"┼","")+;
                  If(Position[27],Replicate("─",LenPos[27][2])+"┼","")
            Head:=Substr(Head,1,Len(Head)-1)+"┤"+CrLf
            FWrite(Desc,Head)
            Page++
         ENDIF
         Head:=""
         IF Position[1]
            Head:=Head+"│"+space(LenPos[1][2])
         ENDIF
         IF Position[2]
            Head:=Head+"│"+Space(LenPos[2][2]-Len(Substr(Alltrim(Object1),1,LenPos[2][2])))+;
                           Substr(Alltrim(Object1),1,LenPos[2][2])
         ENDIF
         IF Position[3]
            Head:=Head+"│"+space(LenPos[3][2])
         ENDIF
         IF Position[4]
            Head:=Head+"│"+space(LenPos[4][2])
         ENDIF
         IF Position[5]
            TmpVal:=GetSl(Main->Lic_Schet,Schetchik,NumMon)
            TmpVal:=TmpVal+Round(TmpVal*Schet_Nds/100,Decimal)
            Head:=Head+"│"+Str(TmpVal,LenPos[5][2],Decimal)
            Itog[5]:=Itog[5]+TmpVal
         ENDIF
         IF Position[6]
            Sumr:=GetRl(Main->Lic_Schet,Schetchik,NumMon)
            Head:=Head+"│"+Str(Sumr,LenPos[6][2],Decimal)
            Itog[6]:=Itog[6]+Sumr
         ENDIF
         IF Position[7]
            Head:=Head+"│"+space(LenPos[7][2])
         ENDIF
         IF Position[8]
            Head:=Head+"│"+space(LenPos[8][2])
         ENDIF
         IF Position[9]
            Head:=Head+"│"+space(LenPos[9][2])
         ENDIF
         IF Position[10]
            Head:=Head+"│"+space(LenPos[10][2])
         ENDIF
         IF Position[11]
            Head:=Head+"│"+space(LenPos[11][2])
         ENDIF
         IF Position[12]
            Head:=Head+"│"+space(LenPos[12][2])
         ENDIF
         IF Position[13]
            Head:=Head+"│"+space(LenPos[13][2])
         ENDIF
         IF Position[14]
            Head:=Head+"│"+Razdel_1+Space(LenPos[14][2]-Len(Razdel_1))
         ENDIF
         IF Position[15]
            Head:=Head+"│"+Str(Silowaq,LenPos[15][2],Decimal)
            Itog[15]:=Itog[15]+Silowaq
         ENDIF
         IF Position[16]
            Head:=Head+"│"+Str(Oswesh,LenPos[16][2],Decimal)
            Itog[16]:=Itog[16]+Oswesh
         ENDIF
         IF Position[17]
            Head:=Head+"│"+center(Tok,LenPos[17][2]," ",.t.)
         ENDIF
         IF Position[18]
            Head:=Head+"│"+center(B,LenPos[18][2]," ",.t.)
         ENDIF
         IF Position[19]
            Head:=Head+"│"+center(A,LenPos[19][2]," ",.t.)
         ENDIF
         IF Position[20]
            Head:=Head+"│"+center(Tip,LenPos[20][2]," ",.t.)
         ENDIF
         IF Position[21]
            Head:=Head+"│"+center(Schetchik,LenPos[21][2]," ",.t.)
         ENDIF
         IF Position[22]
            Head:=Head+"│"+center(God_Prow,LenPos[22][2]," ",.t.)
         ENDIF
         IF Position[23]
            Head:=Head+"│"+Adres+Space(LenPos[23][2]-Len(Adres))
         ENDIF
         IF Position[24]
            Head:=Head+"│"+Telefon+Space(LenPos[24][2]-Len(Telefon))
         ENDIF
         IF Position[26]
            Head:=Head+"│"+Space(LenPos[26][2])
         ENDIF
         IF Position[27]
            Head:=Head+"│"+Space(LenPos[27][2])
         ENDIF
         FWrite(Desc,Head+"│"+CrLf)
         NumString++
         IF NumString>=LenPage-1
            NumString:=0
            Head:="└"+If(Position[01],Replicate("─",LenPos[1][2])+"┴","")+;
                  If(Position[02],Replicate("─",LenPos[2][2])+"┴","")+;
                  If(Position[03],Replicate("─",LenPos[3][2])+"┴","")+;
                  If(Position[04],Replicate("─",LenPos[4][2])+"┴","")+;
                  If(Position[05],Replicate("─",LenPos[5][2])+"┴","")+;
                  If(Position[06],Replicate("─",LenPos[6][2])+"┴","")+;
                  If(Position[07],Replicate("─",LenPos[7][2])+"┴","")+;
                  If(Position[08],Replicate("─",LenPos[8][2])+"┴","")+;
                  If(Position[09],Replicate("─",LenPos[9][2])+"┴","")+;
                  If(Position[10],Replicate("─",LenPos[10][2])+"┴","")+;
                  If(Position[11],Replicate("─",LenPos[11][2])+"┴","")+;
                  If(Position[12],Replicate("─",LenPos[12][2])+"┴","")+;
                  If(Position[13],Replicate("─",LenPos[13][2])+"┴","")+;
                  If(Position[14],Replicate("─",LenPos[14][2])+"┴","")+;
                  If(Position[15],Replicate("─",LenPos[15][2])+"┴","")+;
                  If(Position[16],Replicate("─",LenPos[16][2])+"┴","")+;
                  If(Position[17],Replicate("─",LenPos[17][2])+"┴","")+;
                  If(Position[18],Replicate("─",LenPos[18][2])+"┴","")+;
                  If(Position[19],Replicate("─",LenPos[19][2])+"┴","")+;
                  If(Position[20],Replicate("─",LenPos[20][2])+"┴","")+;
                  If(Position[21],Replicate("─",LenPos[21][2])+"┴","")+;
                  If(Position[22],Replicate("─",LenPos[22][2])+"┴","")+;
                  If(Position[23],Replicate("─",LenPos[23][2])+"┴","")+;
                  If(Position[24],Replicate("─",LenPos[24][2])+"┴","")+;
                  If(Position[26],Replicate("─",LenPos[26][2])+"┴","")+;
                  If(Position[27],Replicate("─",LenPos[27][2])+"┴","")
            Head:=Substr(Head,1,Len(Head)-1)+"┘"+CrLf
            Head:=IF(Len(Head)>82,Head+Schet_Norm,Head)+chr(12)
            FWrite(Desc,Head)
         ENDIF
         SKIP
      ENDDO
      Select Main
   ENDIF                && От выборки по счетчикам
//--------------------------------------------------------------------------
   IF NumString>=LenPage-1
      DevOut("")
      NumString:=0
      Head:="└"+If(Position[01],Replicate("─",LenPos[1][2])+"┴","")+;
            If(Position[02],Replicate("─",LenPos[2][2])+"┴","")+;
            If(Position[03],Replicate("─",LenPos[3][2])+"┴","")+;
            If(Position[04],Replicate("─",LenPos[4][2])+"┴","")+;
            If(Position[05],Replicate("─",LenPos[5][2])+"┴","")+;
            If(Position[06],Replicate("─",LenPos[6][2])+"┴","")+;
            If(Position[07],Replicate("─",LenPos[7][2])+"┴","")+;
            If(Position[08],Replicate("─",LenPos[8][2])+"┴","")+;
            If(Position[09],Replicate("─",LenPos[9][2])+"┴","")+;
            If(Position[10],Replicate("─",LenPos[10][2])+"┴","")+;
            If(Position[11],Replicate("─",LenPos[11][2])+"┴","")+;
            If(Position[12],Replicate("─",LenPos[12][2])+"┴","")+;
            If(Position[13],Replicate("─",LenPos[13][2])+"┴","")+;
            If(Position[14],Replicate("─",LenPos[14][2])+"┴","")+;
            If(Position[15],Replicate("─",LenPos[15][2])+"┴","")+;
            If(Position[16],Replicate("─",LenPos[16][2])+"┴","")+;
            If(Position[17],Replicate("─",LenPos[17][2])+"┴","")+;
            If(Position[18],Replicate("─",LenPos[18][2])+"┴","")+;
            If(Position[19],Replicate("─",LenPos[19][2])+"┴","")+;
            If(Position[20],Replicate("─",LenPos[20][2])+"┴","")+;
            If(Position[21],Replicate("─",LenPos[21][2])+"┴","")+;
            If(Position[22],Replicate("─",LenPos[22][2])+"┴","")+;
            If(Position[23],Replicate("─",LenPos[23][2])+"┴","")+;
            If(Position[24],Replicate("─",LenPos[24][2])+"┴","")+;
            If(Position[26],Replicate("─",LenPos[26][2])+"┴","")+;
            If(Position[27],Replicate("─",LenPos[27][2])+"┴","")
      Head:=Substr(Head,1,Len(Head)-1)+"┘"+CrLf
      Head:=IF(Len(Head)>82,Head+Schet_Norm,Head)+Chr(12)
      FWrite(Desc,Head)
   ENDIF
   Count++
   Skip
ENDDO
DevOut("")
IF NumString!=0
   Head:="└"+If(Position[01],Replicate("─",LenPos[1][2])+"┴","")+;
         If(Position[02],Replicate("─",LenPos[2][2])+"┴","")+;
         If(Position[03],Replicate("─",LenPos[3][2])+"┴","")+;
         If(Position[04],Replicate("─",LenPos[4][2])+"┴","")+;
         If(Position[05],Replicate("─",LenPos[5][2])+"┴","")+;
         If(Position[06],Replicate("─",LenPos[6][2])+"┴","")+;
         If(Position[07],Replicate("─",LenPos[7][2])+"┴","")+;
         If(Position[08],Replicate("─",LenPos[8][2])+"┴","")+;
         If(Position[09],Replicate("─",LenPos[9][2])+"┴","")+;
         If(Position[10],Replicate("─",LenPos[10][2])+"┴","")+;
         If(Position[11],Replicate("─",LenPos[11][2])+"┴","")+;
         If(Position[12],Replicate("─",LenPos[12][2])+"┴","")+;
         If(Position[13],Replicate("─",LenPos[13][2])+"┴","")+;
         If(Position[14],Replicate("─",LenPos[14][2])+"┴","")+;
         If(Position[15],Replicate("─",LenPos[15][2])+"┴","")+;
         If(Position[16],Replicate("─",LenPos[16][2])+"┴","")+;
         If(Position[17],Replicate("─",LenPos[17][2])+"┴","")+;
         If(Position[18],Replicate("─",LenPos[18][2])+"┴","")+;
         If(Position[19],Replicate("─",LenPos[19][2])+"┴","")+;
         If(Position[20],Replicate("─",LenPos[20][2])+"┴","")+;
         If(Position[21],Replicate("─",LenPos[21][2])+"┴","")+;
         If(Position[22],Replicate("─",LenPos[22][2])+"┴","")+;
         If(Position[23],Replicate("─",LenPos[23][2])+"┴","")+;
         If(Position[24],Replicate("─",LenPos[24][2])+"┴","")+;
         If(Position[26],Replicate("─",LenPos[26][2])+"┴","")+;
         If(Position[27],Replicate("─",LenPos[27][2])+"┴","")
   Head:=Substr(Head,1,Len(Head)-1)+"┘"+CrLf
   Head:=IF(Len(Head)>82,Head+Schet_Norm,Head)
   FWrite(Desc,Head)
ENDIF
/*Head:=" "+If(Position[01],Replicate(" ",LenPos[1][2])+" ","")+;
      If(Position[02],"Всего "+Alltrim(Str(Count))+;
         Space(LenPos[2][2]-Len("Всего "+Alltrim(Str(Count))))+" ","")+;
      If(Position[03],space(LenPos[3][2])+" ","")+;
      If(Position[04],Str(Itog[4],LenPos[4][2],Decimal)+" ","")+;
      If(Position[05],Str(Itog[5],LenPos[5][2],Decimal)+" ","")+;
      If(Position[06],Str(Itog[6],LenPos[6][2],Decimal)+" ","")+;
      If(Position[07],Str(Itog[7],LenPos[7][2],Decimal)+" ","")+;
      If(Position[08],Str(Itog[8],LenPos[8][2],Decimal)+" ","")+;
      If(Position[09],Str(Itog[9],LenPos[9][2],Decimal)+" ","")+;
      If(Position[10],Str(Itog[10],LenPos[10][2],Decimal)+" ","")+;
      If(Position[11],Str(Itog[11],LenPos[11][2],Decimal)+" ","")+;
      If(Position[12],Replicate(" ",LenPos[12][2])+" ","")+;
      If(Position[13],Str(Itog[13],LenPos[13][2],Decimal)+" ","")+;
      If(Position[14],Replicate(" ",LenPos[14][2])+" ","")+;
      If(Position[15],Str(Itog[15],LenPos[15][2],Decimal)+" ","")+;
      If(Position[16],Str(Itog[16],LenPos[16][2],Decimal)+" ","")+;
      If(Position[17],Replicate(" ",LenPos[17][2])+" ","")+;
      If(Position[18],Replicate(" ",LenPos[18][2])+" ","")
Head:=Substr(Head,1,Len(Head)-1)+" "+CrLf
*/
Head:=IF(Len(Head)>82,Schet_Cond+Head+Schet_Norm,Head)+title[2]
FWrite(Desc,Head+Chr(12))
Fclose(Desc)
RestScreen(0,0,24,79,Window)
SetColor(Clr)
Select(Sel)
Go Rec
Return NIL

/*


Function UserRpt()
Local Sel:=Select(),Rec:=Recno(),Scr,Clr:=SetColor(),Kol_Kl:=0,CrLf:=Chr(13)+Chr(10)
Local Group:={},Month,Desc,Symbols:=34,EMonth,TmpArr:={0,0,0,0},LenGroup:=1
Month:=Month_Menu("для начала расчета отчета")
eMonth:=Month_Menu("для окончания расчета отчета")
IF Month<0.or.Month>12.or.eMonth<0.or.eMonth>12
   Return NIL
ENDIF
LenGroup:=GetVal("Количество групп признаков   ",4,-1)
IF LenGroup<=0
   Return NIL
EndIf
For I=1 To LenGroup
    AADD(Group,{Space(20),Space(5120)})
    Group[i][1]:=GetVal("Наименование группы N "+AllTrim(Str(i)),"Группа N"+AllTrim(Str(i))+Group[i][1],"")
    Group[i][2]:=GetVal("Лицевые группы N "+AllTrim(Str(i)),Group[i][2],"")
    IF Group[i][1]=="".or.Group[i][1]==""
       Return NIL
    ENDIF
Next
AL_BOX({"!!!!"})
Return NIL




Scr:=Obrabot("Расчет сведений о использовании лимитов")
Go Top
Do While !EOF()
   kol_kl=kol_kl+(39/reccount())
   colorwin(12,21,12,21+kol_kl,'n/n')
   For i=1 to Len(KB)
       IF KB[i]==Lic_Schet
          TmpArr:={0,0,0,0}
          For j=Month To eMonth
              TmpArr[1]:=TmpArr[1]+GetLimit(j,Main->Lic_Schet)
              TmpArr[2]:=TmpArr[2]+GetRashod(Main->Lic_Schet,j)
              TmpArr[3]:=TmpArr[3]+GetSum(Main->Lic_Schet,j)
              TmpArr[4]:=TmpArr[4]+CalckPay(j,Main->Lic_Schet,.f.)
          Next
          AADD(KBstr,{SubStr(Str(Lic_Schet,4,0)+" "+Delstring(Potrebitel,"ИНН")+Space(Symbols),1,Symbols),;
                      TmpArr[1],Round(TmpArr[2]/1000,1),;
                      Round(TmpArr[3]/1000,1),Round(TmpArr[4]/1000,1)})
          Exit
       ENDIF
   Next
   For i=1 to Len(MB)
       IF MB[i]==Lic_Schet
          TmpArr:={0,0,0,0}
          For j=Month To eMonth
              TmpArr[1]:=TmpArr[1]+GetLimit(j,Main->Lic_Schet)
              TmpArr[2]:=TmpArr[2]+GetRashod(Main->Lic_Schet,j)
              TmpArr[3]:=TmpArr[3]+GetSum(Main->Lic_Schet,j)
              TmpArr[4]:=TmpArr[4]+CalckPay(j,Main->Lic_Schet,.f.)
          Next
          AADD(MBstr,{SubStr(Str(Lic_Schet,4,0)+" "+Delstring(Potrebitel,"ИНН")+Space(Symbols),1,Symbols),;
                      TmpArr[1],Round(TmpArr[2]/1000,1),;
                      Round(TmpArr[3]/1000,1),Round(TmpArr[4]/1000,1)})
          Exit
       ENDIF
   Next
   Skip
ENDDO
Desc:=Fcreate(DDir+ReportFile)
FWrite(Desc,Center("С В Е Д Е Н И Я",70)+CrLf)
FWrite(Desc,Center("об использовании лимитов электропотребления потребителями,",70)+CrLf)
FWrite(Desc,Center("финансируемыми из краевого, местного бюджетов",70)+CrLf)
IF Month==eMonth
   FWrite(Desc,Center("за "+Mesqc(Month)+' по '+SchetNameOrg,70)+CrLf)
ELSE
   FWrite(Desc,Center("за "+Mesqc(Month)+'-'+Mesqc(eMonth)+' по '+SchetNameOrg,70)+CrLf)
ENDIF
FWrite(Desc,"┌──────────────────────────────────┬───────┬──────────────────┬─────────┐"+CrLf)
FWrite(Desc,"│    Наименование потребителя      │Лимит  │    Фактически    │ Оплачено│"+CrLf)
FWrite(Desc,"│                                  │       │ кВт/ч │  руб     │         │"+CrLf)
FWrite(Desc,"├──────────────────────────────────┼───────┼───────┼──────────┼─────────┤"+CrLf)
FWrite(Desc,"│ ВСЕГО                            │"+Str(SumArr(KBstr,2)+SumArr(MBstr,2),7,1)+"│"+;
           Str(SumArr(KBstr,3)+SumArr(MBstr,3),7,1)+"│"+Str(SumArr(KBstr,4)+SumArr(MBstr,4),10,1)+"│"+;
           Str(SumArr(KBstr,5)+SumArr(MBstr,5),9,1)+"│"+CrLf)
FWrite(Desc,"│  в том числе Краевой бюджет      │"+Str(SumArr(KBstr,2),7,1)+"│"+;
           Str(SumArr(KBstr,3),7,1)+"│"+Str(SumArr(KBstr,4),10,1)+"│"+;
           Str(SumArr(KBstr,5),9,1)+"│"+CrLf)
FWrite(Desc,"│  в том числе:                    │       │       │          │         │"+CrLf)
FOR i=1 TO Len(KBstr)
    FWrite(Desc,"│"+KBstr[i][1]+"│"+Str(KBstr[i][2],7,1)+"│"+;
           Str(KBstr[i][3],7,1)+"│"+Str(KBstr[i][4],10,1)+"│"+;
           Str(KBstr[i][5],9,1)+"│"+CrLf)
NEXT
FWrite(Desc,"│  В том числе местный бюджет      │"+Str(SumArr(MBstr,2),7,1)+"│"+;
           Str(SumArr(MBstr,3),7,1)+"│"+Str(SumArr(MBstr,4),10,1)+"│"+;
           Str(SumArr(MBstr,5),9,1)+"│"+CrLf)
FWrite(Desc,"│  в том числе:                    │       │       │          │         │"+CrLf)
FOR i=1 TO Len(MBstr)
    FWrite(Desc,"│"+MBstr[i][1]+"│"+Str(MBstr[i][2],7,1)+"│"+Str(MBstr[i][3],7,1)+"│"+Str(MBstr[i][4],10,1)+"│"+Str(MBstr[i][5],9,1)+"│"+CrLf)
NEXT
FWrite(Desc,"└──────────────────────────────────┴───────┴───────┴──────────┴─────────┘"+CrLf)
FWrite(Desc,CrLf+CrLf+"       Директор УМП ГЭС                В.М.Волков"+CrLf)
FClose(Desc)
Select(Sel)
Go Rec
SetColor(Clr)
Win_Rest(Scr)
Return NIL

*/