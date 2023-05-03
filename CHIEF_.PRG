


Function TxtDebKr()
LOCAL old_col1:=setcolor(),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1,Is_Choice:={},Scr:=Win_Save()
local first:=.T.,NeskInfo,DebetInfo,Spravochnik
devout("")

SqlFunc:={{" Импорт показаний физлиц   ", {||GetSqlChastn()}},;
	 				{" Импорт показаний юрлиц",     {||GetSqlGos()}}     }


FidersCType:={{" Полный список ",{||Fiders2(3)}},;
              {" Только задолжники ",{||Fiders2(4)}} }

FidersC:={{" По выбранному фидеру   ",FidersCType},;
          {" Краткий отчет ",{||Fiders2(1)}},;
          {" Полный отчет ",{||Fiders2(2)}} }
Fiders:={ {" Сбор данных за текущий месяц ",{||Fiders1()}},;
          {" Печать данных ",FidersC},;
          {" Удалить данные за месяц",{||FidersErase()}},;
          {" Расчет мощности по ТП ",{||FidersMoshn()}},;
          {" SQL ",    SqlFunc}      }

Lgotnik:={ {" Выгрузка данных    ",{||SborSobes()}},;
           {" Привязка по файлу  ",{||WriteLicSo()}},;
           {" Формирование файла собеса ",{||WriteSobes()}},;
           {" Печать данных собеса ",{||SobesEI()}},;
           {"----------------------------",{||EmptyFunction()}},;
           {" Привязка  по адресу ",{||SobesADR()}},;
           {" Формирование файла соцзащиты ",{||SobesWrite()}},;
           {" Некомпенсируемые льготники",{||NoInSz()}},;
           {"----------------------------",{||EmptyFunction()}},;
           {" Отчет для соцзащиты ",{||SzZapoln()}},;
           {" Файл субсидии  ",{||Subsidii()}}                      }

PotrPrizn:={{" Только оплатившие      ",{||ChoicePriznak(1)}},;
            {" Все потребители ",{||ChoicePriznak(2)}}     }


MenuObhod:={{" Печать обходов  ",{||OtchetObhod(1)}},;
	          {" Печать обходов без показаний ",{||OtchetObhod(2)}},; 
            {" Ввод данных обходов    ",{||WriteObhod()}}     }


ChDolgMenu:={{" Все задолжники   ",{||ChNoMonthOpl()}},;
             {" Только льготники ",{||ChMonthDolg()}},;
             {" Льготники для соцзащиты ",{||SubsidiiChMonthDolg()}},;
             {" Задолжники льготники", {||ChDolgMonth()}}    }

Spravochnik:={{" Справочник улиц ",{||ChastnStreet()}},;
             {" Справочник счетчиков",{||EditFsch()}},;
             {" Справочник тарифов",{||EditTarif()}},;
             {" Справочник признаков",{||EditSign()}},;
             {" Выгрузка для Сбербанка   ",{||SberBankOut()}} }


ChastnMenu:={{" Задолжники по дате оплаты ",ChDolgMenu},;
						 {" Выбор по дате последней оплаты ",{||PushChastn()}},;
             {" Счетчики 81 81-91 91-01",{||DataUstan()}},;
             {" Обходы ",MenuObhod},;
             {" Отчет по кол-ву счетчиков ",{||CalckSch()}},;
             {" Потребители с признаком ",PotrPrizn},;
             {" Льготники ",Lgotnik},;
             {" Проверка оплат и начислений ",{||ChastnProv()}},;
             {" Проверка соответствий счетчиков    ",{||ChastnSchProv()}},;
             {" Справочники ",Spravochnik} }

NeskInfo:={  {" Акт в НЭСК    ",  {||NeskAkt()}},;
         {" Акт в НЭСК ДТ/КТ",{||NeskAktDTKT()}},;
         {" Дебеторская за год",{||YearDolg(1)}},;
         {" Кредиторская за год     ",{||YearDolg(2)}},;
         {" Расход помесяно потарифно",{||RashByTarif()}} }

OpInfo:={{" Сведения о предприятии ",{||Svedeniya()}},;
         {" Информация о фактической оплате ",{||OplataInfo()}},;
         {" Форма 52001 ",{||forma52001()}},;
         {" Форма 52002 ",{||forma52002()}},;
         {" Информация по форме 1 ",{||InfoF1()}},;
         {" Информация по форме 2 ",{||InfoF2()}},;
         {" 9 ПС ",{||_9_ps()}},;
         {" Форма 46 ЭС",{||F46EC()}},;
         {" Пофидерный расход",Fiders},;
         {" Расход за год",{||YearEnergy()}},;
         {" Отчет по выбранной форме",{||GetManyReport()}},;
         {" Отчеты в НЭСК",NeskInfo},;
         {" Импорт показаний за месяц ",{||LoadRashGos()}}  }
         	

DebetInfo:={{" Дебеторы за 1 месяц",{||DebetOneMonth()}},;
            {" Дебeторы за ?? месяцев          ",{||big_debet()}},;
            {" Злостные дебеторы               ",{||kolya()}},;
            {" Злостные дебеторы по условию    ",{||kolya(get_potr())}},;
            {" Дебеторы по форме 9ПС           ",{||make1debet9ps()}},;
            {" Дебеторы по бюджетным орган.    ",{||make2debet9ps()}},;
            {" Дебеторы для взаимозачетов",{||kolya2b()}},;
            {" Дебеторы (развернуто)             ",{||DebFull()}}        }

TxtDolg:={{" Дебеторы ",DebetInfo},;
         {" Задолжники пени и повышенной    ",{||debethighpenq()}},;
         {" Кредиторы за ?? месяцев         ",{||big_kred()}},;
         {" График проверки абонентов       ",{||CheckAbon()}},;
         {" Реестр актов сверки ",{||SverkaReestr()}},;
         {" Информация по форме 36",{||Form36()}},;
         {" Справка о задолженности бюджета   ",{||Spravka2Kolya()}},;
         {" Реестр о предприятиях федерального бюджета ",{||Reestr2Kolya()}},;
         {" Справка о задолженности и оплате",{||Spravka2Novoros()}},;
         {" Выбор потребителей с расходом за год ...",{||CalckYearRashod()}}    }

PotrMenu:={{" Потребители без показаний ",{||BezPokazanij(2)}},;
           {" Потребители c показаниями ",{||BezPokazanij(1)}},;
           {" Частный сектор с непонятной оплатой   ",{||NoChOplata()}},;
           {" Потребители не в книге продаж  ",{||NoKnigaProdag()}},;
           {" Установленные потребителям пломбы ",{||SetPlomba()}},;
           {" Потребители, не оплатившие аванс ",{||NoPayAvans()}}    }

cCtvZpe:={{" По всем потребителям      ",{||CtvZpe(1)}},;
          {" Только госсектор     ",{||CtvZpe(2)}},;
          {" Только частный сектор     ",{||CtvZpe(3)}}  }

FoundMenu:={{" Поиск счетчиков с тарифом... ",{||SearchTar()} },;
            {" Сводная тарифная ведомость ",cCtvZpe },;
            {" Отчет для выставления повышенной ",{||HighSpisok()} },;
            {" Отчет для выставления пени ",{||PenqSpisok()}},;
            {" Выбор потребителей",PotrMenu},;
            {" Реестр оплаты ",{||reestr_2()}},;
            {" Бланк расчета пени ",{||Penq2(2)}},;
            {" Бланк расчета потерь ",{||MonthLose(,.t.)}},;
            {" Полный отчет о начислениях ",{||Inna_Otchet()}}}

PrintLimitMenu:={{" Обычный бланк ",{||PrintOneLimit(2)}},;
                 {" Лимит за дебиторскую     ",{||PrintOneLimit(1)}},;
                 {" Расторжение договора     ",{||PrintOneLimit(11)}},;
                 {" Бланк другой формы ",{||PrintDivLimit()}} }

TarLimMenu:={{" Тариф за перерасход       ",{||GetTarLim(1)}},;
             {" Тариф за недорасход       ",{||GetTarLim(2)}}           }

LimitMenu:={{" Раcсчитать лимит ",{||makelimit()}},;
            {" Рассчитать лимит всем потребителям ",{||limitpaket()}},;
            {" Распечатать бланк лимитов ",PrintLimitMenu },;
            {" Список лимитов по потребителям",{||printlimit()}},;
            {" Бланки лимитов по потребителям",{||allprintlimit()}},;
            {" Массовая корректировка лимитов",{||MasKorLim()}},;
            {" Снизить лимиты всем потребителям   ",{||DivideLim()}},;
            {" Сведения об использовании лимитов",{||SvIspLim()}},;
            {" Тарифы по превышению лимитов",TarLimMenu },;
            {" Превышение лимитов бюджетниками",{||AddRashodBudget()}} }

OtchMenu:={{" Просмотреть       ",{||txtview()} },;
           {" Отпечатать",{||Print_Fi()}}}



Spisok:={{" Дебеторы ",TxtDolg},;
         {" Отчеты ",FoundMenu},;
         {" Формы ",OpInfo},;
         {" Лимиты ",LimitMenu},;
         {" Частники ",ChastnMenu},;
         {" Отчет... ",OtchMenu} }

Keyboard Chr(13)
do_menu(Spisok,.t.,,,,1,,)
ClearBuffer()
devout("")
win_rest(Scr)
setcolor(old_col1)
Return NIL



STATIC Function GetTarLim(Par)
Do Case
   Case Par==1
        LimPererashod:=GetVal(" Перерасход считать по тарифу ",LimPererashod,0)
   Case Par==2
        LimNedorashod:=GetVal(" Недорасход считать по тарифу ",LimNedorashod,0)
EndCase
Return NIL





Function NoPayAvans()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),Desc,CrLf:=Chr(13)+Chr(10)
Local oDlg,aSizeDeskTop,aPos,oProgress,cStr:="",anSumma:={0,0,0},saldo:=0,Itog:={0,0}
Local EMonth:=Month_Menu("выбора неплательщиков аванса")
IF EMonth>=1.and.eMonth<13
	 eMonth:=IF(eMonth>1,eMonth-1,13)
	 cStr:=     "-------------------------------------------------------------------------------------------------------"+CrLf
	 cStr:=cStr+"|Договор |            Потребитель                 |  Недоплата |  Оплачено  |  Начислено |   Сальдо   |"+CrLf
	 cStr:=cStr+"-------------------------------------------------------------------------------------------------------"+CrLf
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
   Go Top
   Do While !EOF()
      anSumma:={0,0}
      oProgress:increment()                                                                                                                                                                // Progress Bar Increment
      Saldo:=GetSaldo(Main->Lic_Schet,EMonth)
      anSumma[1]:=CalckPay(EMonth,Main->Lic_Schet,.f.)
      anSumma[2]:=GetSum(Main->Lic_Schet,EMonth)
      anSumma[1]:=anSumma[1]+GetPayData(Main->Lic_Schet,IF(EMonth<12,eMonth+1,1),6)
      IF anSumma[2]*2-(IF(Saldo>0,Saldo,0)+anSumma[1])>0
      	 Itog[1]:=Itog[1]+1
      	 Itog[2]:=Itog[2]+(anSumma[2]*2-(IF(Saldo>0,Saldo,0)+anSumma[1]))
         cStr:=cStr+"|"+Str(Main->Lic_Schet,8,0)+"|"+Substr(AllTrim(Main->potrebitel)+Space(40),1,40)+"|"+Str(anSumma[2]*2-(IF(Saldo>0,Saldo,0)+anSumma[1]),12,2)+"|"+Str(anSumma[1],12,2)+"|"+Str(anSumma[2],12,2)+"|"+str(Saldo,12,2)+"|"+CrLf
      ENDIF
         SKIP
   ENDDO
	 cStr:=cStr+"-------------------------------------------------------------------------------------------------------"+CrLf
	 cStr:=cStr+"Потребителей в отчете "+Str(Itog[1],8,0)+CrLf
	 cStr:=cStr+"Всего недоплачено аванса на сумму "+Str(Itog[2],12,2)+"руб."+CrLf
   Desc:=FCreate(dDir+ReportFile)
   FWrite(Desc,cStr)
   FClose(Desc)
   
   oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
   oDlg:Destroy()
ENDIF
Select(Sel); Go Rec
Win_Rest(Scr); SetColor(Clr)
Return NIL








Function Spravka2Novoros()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),Desc,CrLf:=Chr(13)+Chr(10)
Local cSDate:="",cEDate:="",Stopped:=.F.,sStart:=Seconds(),rCount:=RecCount()+1
Local SMonth:=Month_Menu("начала расчета справки"),EMonth:=Month_Menu("окончания расчета справки")
Local Dolg:={{0,0,0,0,0,0,0,0},;
             {0,0,0,0,0,0,0,0},;
             {0,0,0,0,0,0,0,0},;
             {0,0,0,0,0,0,0,0},;
             {0,0,0,0,0,0,0,0},;
             {0,0,0,0,0,0,0,0}}
Local StrDate,Found:=.F.,tDolg:=0,Kol_Kl:=0,Shapka:="",sSeconds:=0
Local AOrg:={{14,37,132,419,432,531,144,729,788,844,1103,124,74,679,153,29,182},;
             {26,27,78,198,237,508,951,1170,1237,442},;
             {46,117,119,128,364,497,578,648,1175,1184,1190,1200,1215,1251,1412,1413,1414,1417,1418,270,201,1385,1410,1411,1415,1416},;
             {12,116,134,345,447},;
             {1,3,5,7,11,18,45,48,51,56,59,62,63,64,89,92,104,114,115,120,130,139,177,196,209,222,224,226,245,246,287,288,289,330,;
              407,517,532,535,562,575,576,631,686,694,704,729,754,841,969,981}},AText:={"","","","",""}
IF SMonth==0.or.EMonth==0
   Return NIL
ENDIF
IF eMonth!=Month(New_date)
   StrDate:=Alltrim(Str(LastDayOM(eMonth)))+"."+IF(eMonth<10,"0","")+;
            Alltrim(Str(eMonth))+"."+Alltrim(Str(Year(New_date)))
ELSE
   StrDate:=DToC(New_date)
ENDIF
cSDate:="01."+IF(sMonth<10,"0","")+AllTrim(Str(sMonth))+"."+IF(Len(Str(Year(New_date)))>2,Substr(Str(Year(New_date)),3,2),Str(Year(New_date)))
cEDate:=IF(LastDayOm(eMonth)<10,"0","")+AllTrim(Str(LastDayOm(eMonth)))+"."+IF(eMonth<10,"0","")+AllTrim(Str(eMonth))+"."+IF(Len(Str(Year(New_date)))>2,Substr(Str(Year(New_date)),3,2),Str(Year(New_date)))
Obrabot2("Справка за период с "+cSDate+" по "+cEDate)
Go Top
RunSaver:=.F.
@ 11,30 Say Time()
@ 11,55 Say Substr(SecToTime(Seconds()+rCount),1,5)
DO WHILE .not.EOF()
   sStart:=Seconds()
   rCount:=rCount-1
   kol_kl=kol_kl+(39/Reccount())
   colorwin(12,21,12,21+kol_kl,'n/n')
   Found:=.F.
   tDolg:=Round(GetDolg(Lic_Schet,sMonth-1)/1000,2)
      For I=1 To Len(AOrg[1])
          IF Lic_Schet==AOrg[1][I]
             Dolg[1][2]:=Dolg[1][2]+Round(GetDolg(Lic_Schet,eMonth)/1000,2)
             Dolg[1][1]:=Dolg[1][1]+Round(GetDolg(Lic_Schet,sMonth-1)/1000,2)
             For J=sMonth to eMonth
//                 Dolg[1][4]:=Dolg[1][4]+Round((GetSum(Main->Lic_Schet,J)*(100+Schet_Nds)/100)/1000,2)
             Next J
             For J=sMonth to eMonth
                 Dolg[1][5]:=Dolg[1][5]+Round(CalckPay(J,Main->Lic_Schet,.F.,1)/1000,2)
                 Dolg[1][6]:=Dolg[1][6]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"зачет")/1000,2)
                 Dolg[1][7]:=Dolg[1][7]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"РОКБ")/1000,2)
             Next J
             Dolg[1][8]:=Dolg[1][5]-Dolg[1][7]-Dolg[1][6]
             Dolg[1][3]:=Dolg[1][2]-Dolg[1][1]
             Found:=.T.
             Exit
          ENDIF
      NEXT
      IF .not.Found
         For I=1 To Len(AOrg[2])
             IF Lic_Schet==AOrg[2][I]
                Dolg[2][2]:=Dolg[2][2]+Round(GetDolg(Main->Lic_Schet,eMonth)/1000,2)
                Dolg[2][1]:=Dolg[2][1]+Round(GetDolg(Main->Lic_Schet,sMonth-1)/1000,2)
                For J=sMonth to eMonth
//                    Dolg[2][4]:=Dolg[2][4]+Round((GetSum(Main->Lic_Schet,J)*(100+Schet_Nds)/100)/1000,2)
                Next J
                For J=sMonth to eMonth
                    Dolg[2][5]:=Dolg[2][5]+Round(CalckPay(J,Main->Lic_Schet,.F.,1)/1000,2)
                    Dolg[2][6]:=Dolg[2][6]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"зачет")/1000,2)
                    Dolg[2][7]:=Dolg[2][7]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"РОКБ")/1000,2)
                Next J
                Dolg[2][8]:=Dolg[2][5]-Dolg[2][7]-Dolg[2][6]
                Dolg[2][3]:=Dolg[2][2]-Dolg[2][1]
                Found:=.T.
                Exit
             ENDIF
         NEXT
      ENDIF
      IF .not.Found
         For I=1 To Len(AOrg[3])
             IF Lic_Schet==AOrg[3][I]
                Dolg[3][2]:=Dolg[3][2]+Round(GetDolg(Main->Lic_Schet,eMonth)/1000,2)
                Dolg[3][1]:=Dolg[3][1]+Round(GetDolg(Main->Lic_Schet,sMonth-1)/1000,2)
                For J=sMonth to eMonth
//                    Dolg[3][4]:=Dolg[3][4]+Round((GetSum(Main->Lic_Schet,J)*(100+Schet_Nds)/100)/1000,2)
                Next J
                For J=sMonth to eMonth
                    Dolg[3][5]:=Dolg[3][5]+Round(CalckPay(J,Main->Lic_Schet,.F.,1)/1000,2)
                    Dolg[3][6]:=Dolg[3][6]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"зачет")/1000,2)
                    Dolg[3][7]:=Dolg[3][7]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"РОКБ")/1000,2)
                Next J
                Dolg[3][8]:=Dolg[3][5]-Dolg[3][7]-Dolg[3][6]
                Dolg[3][3]:=Dolg[3][2]-Dolg[3][1]
                Found:=.T.
                Exit
             ENDIF
         NEXT
      ENDIF
      IF .not.Found
         For I=1 To Len(AOrg[4])
             IF Lic_Schet==AOrg[4][I]
                Dolg[4][2]:=Dolg[4][2]+Round(GetDolg(Main->Lic_Schet,eMonth)/1000,2)
                Dolg[4][1]:=Dolg[4][1]+Round(GetDolg(Main->Lic_Schet,sMonth-1)/1000,2)
                For J=sMonth to eMonth
//                    Dolg[4][4]:=Dolg[4][4]+Round((GetSum(Main->Lic_Schet,J)*(100+Schet_Nds)/100)/1000,2)
                Next J
                For J=sMonth to eMonth
                    Dolg[4][5]:=Dolg[4][5]+Round(CalckPay(J,Main->Lic_Schet,.F.,1)/1000,2)
                    Dolg[4][6]:=Dolg[4][6]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"зачет")/1000,2)
                    Dolg[4][7]:=Dolg[4][7]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"РОКБ")/1000,2)
                Next J
                Dolg[4][8]:=Dolg[4][5]-Dolg[4][7]-Dolg[4][6]
                Dolg[4][3]:=Dolg[4][2]-Dolg[4][1]
                Found:=.T.
                Exit
             ENDIF
         NEXT
      ENDIF
      IF .not.Found
         For I=1 To Len(AOrg[5])
             IF Lic_Schet==AOrg[5][I]
                Dolg[5][2]:=Dolg[5][2]+Round(GetDolg(Main->Lic_Schet,eMonth)/1000,2)
                Dolg[5][1]:=Dolg[5][1]+Round(GetDolg(Main->Lic_Schet,sMonth-1)/1000,2)
                For J=sMonth to eMonth
//                    Dolg[5][4]:=Dolg[5][4]+Round((GetSum(Main->Lic_Schet,J)*(100+Schet_Nds)/100)/1000,2)
                Next J
                For J=sMonth to eMonth
                    Dolg[5][5]:=Dolg[5][5]+Round(CalckPay(J,Main->Lic_Schet,.F.,1)/1000,2)
                    Dolg[5][6]:=Dolg[5][6]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"зачет")/1000,2)
                    Dolg[5][7]:=Dolg[5][7]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"РОКБ")/1000,2)
                Next J
                Dolg[5][8]:=Dolg[5][5]-Dolg[5][7]-Dolg[5][6]
                Dolg[5][3]:=Dolg[5][2]-Dolg[5][1]
                Found:=.T.
                Exit
             ENDIF
         NEXT
      ENDIF
   IF tDolg>0.and.!Found
         Dolg[6][2]:=Dolg[6][2]+Round(GetDolg(Main->Lic_Schet,eMonth)/1000,2)
         Dolg[6][1]:=Dolg[6][1]+Round(GetDolg(Main->Lic_Schet,sMonth-1)/1000,2)
         For J=sMonth to eMonth
//             Dolg[6][4]:=Dolg[6][4]+Round((GetSum(Main->Lic_Schet,J)*(100+Schet_Nds)/100)/1000,2)
         Next J
         For J=sMonth to eMonth
             Dolg[6][5]:=Dolg[6][5]+Round(CalckPay(J,Main->Lic_Schet,.F.,1)/1000,2)
             Dolg[6][6]:=Dolg[6][6]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"зачет")/1000,2)
             Dolg[6][7]:=Dolg[6][7]+Round(CalckPay(J,Main->Lic_Schet,.F.,1,"РОКБ")/1000,2)
         Next J
         Dolg[6][8]:=Dolg[6][5]-Dolg[6][7]-Dolg[6][6]
         Dolg[6][3]:=Dolg[6][2]-Dolg[6][1]
   ENDIF
   Skip
   IF InKey()==27
      IF Al_Box({"Закончить расчет справки"},2)==1
         Stopped:=.T.
         Exit
      ENDIF
   ENDIF
   @ 11,30 Say Time()
   sSeconds:=sSeconds+(Seconds()-sStart)
   @ 11,53 Say SecToTime(Int((Seconds()+(sSeconds/(RecCount()-rCount))*rCount)/10)*10)
ENDDO
For I=1 To 6
    Dolg[i][4]:=Dolg[i][3]+Dolg[i][5]
Next
Desc:=FCreate(DDir+ReportFile)
FWrite(Desc,Chr(27)+Chr(77)+"                                             С В Е Д Е Н И Я"+CrLf)
FWrite(Desc,"                     о дебиторской задолженности и оплате за потребленную электроэнергию"+CrLf)
FWrite(Desc,'          на '+cEDate+'г. УМП "Горэлектросеть" города-курорта Анапа Новороссийского МРО Энергосбыта'+CrLf)
FWrite(Desc,"                            (для рассмотрения на краевой чрезвычайной комиссии)"+CrLf)
FWrite(Desc,"                                                                                                        с НДС (в тыс.руб)"+CrLf)
FWrite(Desc,"┌────────────────────────────────┬─────────────────────┬─────────────┬───────────┬───────────────────────────────────────┐"+CrLf)
FWrite(Desc,"│Наименование предприятий и групп│  Задолженность на   │Увеличение(+)│Отпущено с │Оплачено с "+cSDate+" по "+cEDate+"        │"+CrLf)
FWrite(Desc,"│потребителей                    │ "+cSDate+" │ "+cEDate+" │Снижение (-) │"+cSDate+" по│ВСЕГО     │В том числе:                │"+CrLf)
FWrite(Desc,"│                                │          │          │             │"+cEDate+"   │          │деньгами │  РОКБ  │проведено│"+CrLf)
FWrite(Desc,"│                                │ тыс. руб │  тыс. руб│             │ тыс.руб   │ тыс. руб │         │        │зачетами │"+CrLf)
FWrite(Desc,"├────────────────────────────────┼──────────┼──────────┼─────────────┼───────────┼──────────┼─────────┼────────┼─────────┤"+CrLf)
FWrite(Desc,"│Дебиторская задолженность всего │"+Str(Dolg[1][1]+Dolg[2][1]+Dolg[3][1]+Dolg[4][1]+Dolg[5][1]+Dolg[6][1],10,2)+"│"+Str(Dolg[1][2]+Dolg[2][2]+Dolg[3][2]+Dolg[4][2]+Dolg[5][2]+Dolg[6][2],10,2)+;
"│ "+Str(Dolg[1][3]+Dolg[2][3]+Dolg[3][3]+Dolg[4][3]+Dolg[5][3]+Dolg[6][3],10,2)+"  │"+Str(Dolg[1][4]+Dolg[2][4]+Dolg[3][4]+Dolg[4][4]+Dolg[5][4]+Dolg[6][4],11,2)+"│"+Str(Dolg[1][5]+Dolg[2][5]+Dolg[3][5]+;
Dolg[4][5]+Dolg[5][5]+Dolg[6][5],10,2)+"│"+;
Str(Dolg[1][8]+Dolg[2][8]+Dolg[3][8]+Dolg[4][8]+Dolg[5][8]+Dolg[6][8],9,2)+"│"+Str(Dolg[1][7]+Dolg[2][7]+Dolg[3][7]+Dolg[4][7]+Dolg[5][7]+Dolg[6][7],8,2)+"│"+Str(Dolg[1][6]+Dolg[2][6]+Dolg[3][6]+Dolg[4][6]+Dolg[5][6]+Dolg[6][6],9,2)+"│"+CrLf)
FWrite(Desc,"│в том числе:                    │          │          │             │           │          │         │        │         │"+CrLf)
FWrite(Desc,"│Оптовые потребители-перепродавцы│          │          │             │           │          │         │        │         │"+CrLf)
FWrite(Desc,"│Промышленные потребители всего  │"+Str(Dolg[5][1],10,2)+"│"+Str(Dolg[5][2],10,2)+"│ "+Str(Dolg[5][3],10,2)+"  │"+Str(Dolg[5][4],11,2)+"│"+;
       Str(Dolg[5][5],10,2)+"│"+Str(Dolg[5][8],9,2)+"│"+Str(Dolg[5][7],8,2)+"│"+Str(Dolg[5][6],9,2)+"│"+CrLf)
FWrite(Desc,"│Бюджетные организации всего     │"+Str(Dolg[1][1]+Dolg[2][1]+Dolg[3][1],10,2)+"│"+Str(Dolg[1][2]+Dolg[2][2]+Dolg[3][2],10,2)+;
"│ "+Str(Dolg[1][3]+Dolg[2][3]+Dolg[3][3],10,2)+"  │"+Str(Dolg[1][4]+Dolg[2][4]+Dolg[3][4],11,2)+"│"+Str(Dolg[1][5]+Dolg[2][5]+Dolg[3][5],10,2)+"│"+;
Str(Dolg[1][8]+Dolg[2][8]+Dolg[3][8],9,2)+"│"+Str(Dolg[1][7]+Dolg[2][7]+Dolg[3][7],8,2)+"│"+Str(Dolg[1][6]+Dolg[2][6]+Dolg[3][6],9,2)+"│"+CrLf)
FWrite(Desc,"│в том числе:                    │          │          │             │           │          │         │        │         │"+CrLf)
FWrite(Desc,"│Федеральный бюджет              │"+Str(Dolg[1][1],10,2)+"│"+Str(Dolg[1][2],10,2)+"│ "+Str(Dolg[1][3],10,2)+"  │"+Str(Dolg[1][4],11,2)+"│"+;
       Str(Dolg[1][5],10,2)+"│"+Str(Dolg[1][8],9,2)+"│"+Str(Dolg[1][7],8,2)+"│"+Str(Dolg[1][6],9,2)+"│"+CrLf)
FWrite(Desc,"│Краевой бюджет                  │"+Str(Dolg[2][1],10,2)+"│"+Str(Dolg[2][2],10,2)+"│ "+Str(Dolg[2][3],10,2)+"  │"+Str(Dolg[2][4],11,2)+"│"+;
      Str(Dolg[2][5],10,2)+"│"+Str(Dolg[2][8],9,2)+"│"+Str(Dolg[2][7],8,2)+"│"+Str(Dolg[2][6],9,2)+"│"+CrLf)
FWrite(Desc,"│Местный бюджет                  │"+Str(Dolg[3][1],10,2)+"│"+Str(Dolg[3][2],10,2)+"│ "+Str(Dolg[3][3],10,2)+"  │"+Str(Dolg[3][4],11,2)+"│"+;
      Str(Dolg[3][5],10,2)+"│"+Str(Dolg[3][8],9,2)+"│"+Str(Dolg[3][7],8,2)+"│"+Str(Dolg[3][6],9,2)+"│"+CrLf)

FWrite(Desc,"│Жилищно-коммунальное хозяйство  │"+Str(Dolg[4][1],10,2)+"│"+Str(Dolg[4][2],10,2)+"│ "+Str(Dolg[4][3],10,2)+"  │"+Str(Dolg[4][4],11,2)+"│"+;
      Str(Dolg[4][5],10,2)+"│"+Str(Dolg[4][8],9,2)+"│"+Str(Dolg[4][7],8,2)+"│"+Str(Dolg[4][6],9,2)+"│"+CrLf)


FWrite(Desc,"│в том числе:                    │          │          │             │           │          │         │        │         │"+CrLf)
FWrite(Desc,"│Сельское хозяйство всего:       │          │          │             │           │          │         │        │         │"+CrLf)
FWrite(Desc,"│в том числе:                    │          │          │             │           │          │         │        │         │"+CrLf)
FWrite(Desc,"│Население                       │          │          │             │           │          │         │        │         │"+CrLf)
FWrite(Desc,"│Прочие                          │"+Str(Dolg[6][1],10,2)+"│"+Str(Dolg[6][2],10,2)+"│ "+Str(Dolg[6][3],10,2)+"  │"+Str(Dolg[6][4],11,2)+"│"+;
      Str(Dolg[6][5],10,2)+"│"+Str(Dolg[6][8],9,2)+"│"+Str(Dolg[6][7],8,2)+"│"+Str(Dolg[6][6],9,2)+"│"+CrLf)




FWrite(Desc,"└────────────────────────────────┴──────────┴──────────┴─────────────┴───────────┴──────────┴─────────┴────────┴─────────┘"+CrLf)
FWrite(Desc,CrLf+CrLf+Space(30)+"Директор                                "+AllTrim(NameBoss)+Chr(27)+Chr(80)+CrLf)
FClose(Desc)
IF Stopped
   DeleteFile(DDir+ReportFile)
EndIf
RunSaver:=.T.

Select(Sel); Go Rec
Win_Rest(Scr); SetColor(Clr)
Return NIL






FUNCTION Spravka2Kolya()
LOCAL Rec:=RecNo(),Sel:=Select(),Win:=Win_Save(),Clr:=SetColor(),Desc
Local oDlg,aSizeDeskTop,aPos,oProgress
Local tOpl:=0,tPrevDolg:=0,tNach:=0,RecCount:=1
Local CrLf:=Chr(13)+Chr(10),Month:=Month_Menu("расчета справки о задолженности")
Local Dolg:={0,0,0,0,0},StrDate,Found:=.F.,tDolg:=0,Kol_Kl:=0,Shapka:=""
Local AOrg:={{14,13,26,198,237,280,332,508,1036,1120,1332,1847,37,132,419,432,1237,531,144,788,1103,124,679,153,29,182,750,1000,568,840,77,35,211,60,215,695,1170,1709,100,2386},;
             {27,258,951,442,1693,441,401,1417,1247,2246},;
             {74,2118,2006,497,2710,46,117,201,364,1175,1184,1200,1215,1412,1413,1414,1226,;
             1617,1669,1751,1773,1774,1780,1781,1784,1785,1786,1787,1790,1793,1798,1799,1801,1802,;
             1803,1804,1806,1807,1808,1809,1810,1811,1820,1821,1824,1830,1841,1843,1789,1796,1226,2002,;
             1418,270,1410,1411,1415,1416,258,564},;
             {12,78,134,345,1965,116}},AText:={"","","","",""}
IF Month==0
   Return NIL
ENDIF
//Obrabot("Расчет справки...")

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := AppDesktop():currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := "Расчет справки о задолженности бюджета"
oDlg:SysMenu     := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos                                            := oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
oProgress:create()
oProgress:minimum := 1

IF Month!=Month(New_date)
   StrDate:=Alltrim(Str(LastDayOM(Month)))+"."+IF(Month<10,"0","")+;
            Alltrim(Str(Month))+"."+Alltrim(Str(Year(New_date)))
ELSE
   StrDate:=DToC(New_date)
ENDIF
Desc:=Fcreate(DDir+ReportFile)
Fwrite(Desc,Center("С П Р А В К А",80," ")+CrLf)
Fwrite(Desc,Center("о задолженности потребителей за потребленную электроэнергию",80," ")+CrLf)
Fwrite(Desc,Center(SchetNameOrg,80," ")+CrLf)
Fwrite(Desc,Center("(по состоянию на "+StrDate+" г.)",80," ")+CrLf)
Shapka:="───────────────────────────────────────────────────────────────────────────────────────────────────────────────────"+CrLf+;
        " Наименование организации                               Долг нач. Начислено Оплачено Долг конец Срок задол Принятые"+CrLf+;
        "                                                         месяца                        месяца    женности    меры"+CrLf+;
        "───────────────────────────────────────────────────────────────────────────────────────────────────────────────────"+CrLf
FOR I=1 TO Len(AText)
    AText[i]:=Shapka
NEXT
Go Top
DO WHILE .not.eof()
   IF Lic_Schet<99999
      RecCount:=RecCount+1
   ENDIF
   skip
ENDDO
oProgress:maximum := RecCount
go top
DO WHILE Lic_Schet<99999.and..not.eof()
   oProgress:increment()                                                                                                                                                                // Progress Bar Increment

//   kol_kl=kol_kl+(39/Reccount)
//   colorwin(12,21,12,21+kol_kl,'n/n')
   Found:=.F.
   tPrevDolg:=Round(GetDolg(Lic_Schet,IF(Month==1,13,Month-1))/1000,2)
   tDolg:=Round(GetDolg(Lic_Schet,Month)/1000,2)
   tOpl:=Round(CalckPay(Month,Lic_Schet,.f.)/1000,2)
//   tPrevDolg:=Round(GetDolg(Lic_Schet,IF(Month==1,Month-1,12))/1000,2)

//   tNach:=Round(((GetSum(Lic_Schet,Month)*(100+Schet_Nds))/100)/1000,2)
   tNach:=Round(GetSum(Lic_Schet,Month)/1000,2)
   SrokDolg:=SrokDolg(Lic_Schet,Month)
      For I=1 To Len(AOrg[1])
          IF Lic_Schet==AOrg[1][I]
             AText[1]:=AText[1]+str(Lic_Schet,4,0)+" "+PadRight(Substr(DelString(DelString(Potrebitel,"ИНН"),"л/с"),1,48),48)+" "+;
                       IF(tPrevDolg>0,Str(tPrevDolg,10,2),Space(10))+;
                       IF(tNach>0,Str(tNach,10,2),Space(10))+;
                       IF(tOpl>0,Str(tOpl,10,2),Space(10))+;
                       IF(tDolg>0,Str(tDolg,10,2),Space(10))+;
                       IF(SrokDolg>0,Str(SrokDolg,10,0),Space(10))+"  "+Work+CrLf
             Dolg[1]:=Dolg[1]+tDolg
             Found:=.T.
             Exit
          ENDIF
      NEXT
      IF .not.Found
         For I=1 To Len(AOrg[2])
             IF Lic_Schet==AOrg[2][I]
                AText[2]:=AText[2]+str(Lic_Schet,4,0)+" "+PadRight(Substr(DelString(DelString(Potrebitel,"ИНН"),"л/с"),1,48),48)+" "+;
                       IF(tPrevDolg>0,Str(tPrevDolg,10,2),Space(10))+;
                       IF(tNach>0,Str(tNach,10,2),Space(10))+;
                       IF(tOpl>0,Str(tOpl,10,2),Space(10))+;
                       IF(tDolg>0,Str(tDolg,10,2),Space(10))+;
                       IF(SrokDolg>0,Str(SrokDolg,10,0),Space(10))+" "+Work+CrLf
                Dolg[2]:=Dolg[2]+tDolg
                Found:=.T.
                EXIT
             ENDIF
         NEXT
      ENDIF
      IF .not.Found
         For I=1 To Len(AOrg[3])
             IF Lic_Schet==AOrg[3][I]
                AText[3]:=AText[3]+str(Lic_Schet,4,0)+" "+PadRight(Substr(DelString(Potrebitel,"ИНН"),1,48),48)+" "+;
                       IF(tPrevDolg>0,Str(tPrevDolg,10,2),Space(10))+;
                       IF(tNach>0,Str(tNach,10,2),Space(10))+;
                       IF(tOpl>0,Str(tOpl,10,2),Space(10))+;
                       IF(tDolg>0,Str(tDolg,10,2),Space(10))+;
                       IF(SrokDolg>0,Str(SrokDolg,10,0),Space(10))+" "+Work+CrLf
                Dolg[3]:=Dolg[3]+tDolg
                Found:=.T.
                EXIT
             ENDIF
         NEXT
      ENDIF
      IF .not.Found
         For I=1 To Len(AOrg[4])
             IF Lic_Schet==AOrg[4][I]
                AText[4]:=AText[4]+str(Lic_Schet,4,0)+" "+PadRight(Substr(DelString(Potrebitel,"ИНН"),1,48),48)+" "+;
                       IF(tPrevDolg>0,Str(tPrevDolg,10,2),Space(10))+;
                       IF(tNach>0,Str(tNach,10,2),Space(10))+;
                       IF(tOpl>0,Str(tOpl,10,2),Space(10))+;
                       IF(tDolg>0,Str(tDolg,10,2),Space(10))+;
                       IF(SrokDolg>0,Str(SrokDolg,10,0),Space(10))+" "+Work+CrLf
                Dolg[4]:=Dolg[4]+tDolg
                Found:=.T.
                EXIT
             ENDIF
         NEXT
      ENDIF
   IF tDolg>0.and.!Found
      Dolg[5]:=Dolg[5]+tDolg
      IF tDolg>2
         AText[5]:=AText[5]+str(Lic_Schet,4,0)+" "+PadRight(Substr(DelString(Potrebitel,"ИНН"),1,48),48)+" "+;
                       IF(tPrevDolg>0,Str(tPrevDolg,10,2),Space(10))+;
                       IF(tNach>0,Str(tNach,10,2),Space(10))+;
                       IF(tOpl>0,Str(tOpl,10,2),Space(10))+;
                       Str(tDolg,10,2)+;
                       IF(SrokDolg>0,Str(SrokDolg,10,0),Space(10))+" "+Work+CrLf
      ENDIF
   ENDIF
   Skip
ENDDO
FWrite(Desc,CrLf+"Задолженность потребителей всего :"+Str(Dolg[1]+Dolg[2]+Dolg[3]+Dolg[4]+Dolg[5],14,2)+CrLf)
FWrite(Desc,"В том числе:"+CrLf)
FWrite(Desc,"Задолженность организаций федерального бюджета: "+Str(Dolg[1],14,2)+CrLf)
FWrite(Desc,AText[1]+CrLf+CrLf)
FWrite(Desc,"Задолженность организаций краевого бюджета: "+Str(Dolg[2],14,2)+CrLf)
FWrite(Desc,AText[2]+CrLf+CrLf)
FWrite(Desc,"Задолженность организаций местного бюджета: "+Str(Dolg[3],14,2)+CrLf)
FWrite(Desc,AText[3]+CrLf+CrLf)
FWrite(Desc,"Задолженность организаций коммунального хозяства: "+Str(Dolg[4],14,2)+CrLf)
FWrite(Desc,AText[4]+CrLf+CrLf)
FWrite(Desc,"Задолженность прочих потребителей (кроме населения): "+Str(Dolg[5],14,2)+CrLf)
FWrite(Desc,"В том числе некоторые:"+CrLf)
FWrite(Desc,AText[5]+Replicate(CrLf,4)+;
            SchetNameOrg+CrLf+;
            'Директор                                              '+AllTrim(NameBoss)+CrLf+CrLf)
Fwrite(Desc,"Гл.Бухгалтер                                          "+AllTrim(NameBuh)+CrLf+CrLf)
Fwrite(Desc,"Исполнитель"+CrLf+Chr(12))
Fclose(Desc)
oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
oDlg:Destroy()
Win_Rest(Win)
SetColor(Clr)
Select(Sel)
Go Rec
Return NIL





FUNCTION Reestr2Kolya()
LOCAL Rec:=RecNo(),Sel:=Select(),Win:=Win_Save(),Clr:=SetColor(),Desc,Kvart:=.F.
Local CrLf:=Chr(13)+Chr(10),Month:=Month_Menu("расчета справки о задолженности")
Local Dolg:={0,0,0,0,0,0,0,0,0},StrDate,Found:=.F.,tDolg:=0,Kol_Kl:=0,Shapka:=""
Local AOrg:={{26,132,531,788,419,729},;
             {844,1237,144},;
             {14,1103,37,432},;
             {29,182,508},;
             {153,27,951,78},;
             {1170},;
             {74,124},;
             {679},;
             {198,237}}
Local AText:={"МинОбороны"+CrLf,"ФСБ"+CrLf,"ФПС"+CrLf,"МинЗдрав"+CrLf,"МВД"+CrLf,;
              "ГНС"+CrLf,"МинОбразования"+CrLf,"МинФин"+CrLf,"МинЮст"+CrLf}
IF Month==0
   Return NIL
ENDIF
Do Case
   Case Month==1
        IF Al_Box({"Укажите период расчета"},2,{" Месяц "," Квартал "})==2
           Kvart=.T.
           cKvart:="I квартал"
        ENDIF
   Case Month==4
        IF Al_Box({"Укажите период расчета"},2,{" Месяц "," Квартал "})==2
           Kvart=.T.
           cKvart:="II квартал"
        ENDIF
   Case Month==7
        IF Al_Box({"Укажите период расчета"},2,{" Месяц "," Квартал "})==2
           Kvart=.T.
           cKvart:="III квартал"
        ENDIF
   Case Month==9
        IF Al_Box({"Укажите период расчета"},2,{" Месяц "," Квартал "})==2
           Kvart=.T.
           cKvart:="IV квартал"
        ENDIF
EndCase
Obrabot("Расчет реестра бюджетных предприятий")
IF Month!=Month(New_date)
   StrDate:=Alltrim(Str(LastDayOM(Month)))+"."+IF(Month<10,"0","")+;
            Alltrim(Str(Month))+"."+Alltrim(Str(Year(New_date)))
ELSE
   StrDate:=DToC(New_date)
ENDIF
Desc:=Fcreate(DDir+ReportFile)
Fwrite(Desc,Center("Р Е Е С Т Р",100,.t.," ")+CrLf)
Fwrite(Desc,Center("о наличии актов сверки задолженности электроэнергии, финансируемых",100,.t.," ")+CrLf)
Fwrite(Desc,Center("из средств федерального бюджета за "+IF(!Kvart,Mesqc(Month,.t.)+" месяц ",cKvart+" ")+Alltrim(Str(Year(New_date))),100,.t.," ")+"г."+CrLf)
Fwrite(Desc,Center('по '+SchetNameOrg,100,.t.," ")+CrLf+CrLf)
Fwrite(Desc,Center('товарная продукция с НДС',100,.t.," ")+CrLf)
FWrite(Desc,"───────────────────────────────────────────────────────────────────────────────────────────────────────────"+CrLf)
FWrite(Desc," Наименование организации  Задолженность   Фактически отпущено  Фактически оплачено   Задолжен.  Кроме того"+CrLf)
FWrite(Desc,"                           на "+Mesqc(Month)+Space(13-Len(Mesqc(Month)))+" за месяц  (квартал)  за месяц (квартал)   на конец   пени"+CrLf)
FWrite(Desc,"                           (тыс.руб.)                  c НДС    Всего   в т.ч деньги  отчетного"+CrLf)
FWrite(Desc,"                                           тыс.кВтч   тыс.руб   тыс.руб  +банк.векс.   периода    тыс.руб."+CrLf)
FWrite(Desc,"───────────────────────────────────────────────────────────────────────────────────────────────────────────"+CrLf)
Go Top
DO WHILE .not.EOF()
   kol_kl=kol_kl+(39/Reccount())
   colorwin(12,21,12,21+kol_kl,'n/n')
   IF .NOT.Kvart
      For J=1 to Len(AOrg)
         tDolg:=Round(-1*GetSaldo(Lic_Schet,Month-1)/1000,2)
         For I=1 To Len(AOrg[J])
             IF Lic_Schet==AOrg[J][I]
//                          Str(Round(GetSum(Main->Lic_Schet,Month)*(100+Schet_Nds)/100/1000,2),10,2)+" "+;
                AText[J]:=AText[J]+Str(Main->Lic_Schet,5,0)+" "+;
                          DelString(DelString(Potrebitel,"ИНН"),"л/с")+CrLf+;
                          Space(26)+Str(tDolg,10,2)+"  "+;
                          Str(GetRashod(Main->Lic_Schet,Month)/1000,10,2)+" "+;
                          Str(Round(GetSum(Main->Lic_Schet,Month)/1000,2),10,2)+" "+;
                          Str(CalckPay(Month,Main->Lic_Schet,.f.,1)/1000,10,2)+" "+;
                          Str(CalckPay(Month,Main->Lic_Schet,.f.,1)/1000,10,2)+" "+;
                          Str(-1*GetSaldo(Main->Lic_Schet,Month)/1000,10,2)+" "+;
                          Str(GetPenq(Main->Lic_Schet,Month)/1000,10,2)+" "+CrLf
                Dolg[J]:=Dolg[J]+tDolg
                Found:=.T.
                Exit
             ENDIF
         NEXT I
      NEXT J
   ELSE
      For J=1 to Len(AOrg)
         tDolg:=Round(-1*GetSaldo(Lic_Schet,Month-1)/1000,2)
         For I=1 To Len(AOrg[J])
             IF Lic_Schet==AOrg[J][I]
                AText[J]:=AText[J]+Str(Main->Lic_Schet,5,0)+" "+;
                          DelString(DelString(Potrebitel,"ИНН"),"л/с")+CrLf+;
                          Space(26)+Str(tDolg,10,2)+"  "+;
                          Str((GetRashod(Main->Lic_Schet,Month)+GetRashod(Main->Lic_Schet,Month+1)+GetRashod(Main->Lic_Schet,Month+2))/1000,10,2)+" "+;
                          Str(Round((GetSum(Main->Lic_Schet,Month)+GetSum(Main->Lic_Schet,Month+1)+GetSum(Main->Lic_Schet,Month+2)),2)/1000,10,2)+" "+;
                          Str((CalckPay(Month,Main->Lic_Schet,.f.,1)+CalckPay(Month+1,Main->Lic_Schet,.f.,1)+CalckPay(Month+2,Main->Lic_Schet,.f.,1))/1000,10,2)+" "+;
                          Str((CalckPay(Month,Main->Lic_Schet,.f.,1)+CalckPay(Month+1,Main->Lic_Schet,.f.,1)+CalckPay(Month+2,Main->Lic_Schet,.f.,1))/1000,10,2)+" "+;
                          Str(-1*GetSaldo(Main->Lic_Schet,Month+2)/1000,10,2)+" "+;
                          Str(GetPenq(Main->Lic_Schet,Month+2)/1000,10,2)+" "+CrLf
                Dolg[J]:=Dolg[J]+tDolg
                Found:=.T.
                Exit
             ENDIF
         NEXT I
      NEXT J
   ENDIF
   Skip
ENDDO
For I=1 To Len(AText)
    FWrite(Desc,AText[I])
Next
Fclose(Desc)
Win_Rest(Win)
SetColor(Clr)
Select(Sel)
Go Rec
Return NIL





FUNCTION Get_Potr()
LOCAL Win:=WIN_SAVE(),color:=setcolor(),String
colorwin(11,13,13,61,"n+/n")
String:=substr(main->potrebitel,1,46)
String:=String+space(46-Len(String))
set color to &getcolor
@ 10,12 SAY "┌───────────── Поиск по подстроке ───────────────╖"
@ 11,12 SAY "│"+space(48)+"║"
@ 12,12 SAY "╘════════════════════════════════════════════════╝"
@ 11,14 get string picture "@K"
set cursor on
set confirm on
read
set confirm off
set cursor off
IF Lastkey()==27
   String:=NIL
ELSE
   String:=MYUpper(Alltrim(String))
ENDIF
Clear Typeahead
setcolor(color)
win_rest(Win)
RETURN String




STATIC Function debethighpenq()
LOCAL select:=select(),recno:=recno(),color:=setcolor(),win_save
LOCAL temp_:=39/reccount(),kol_kl:=0,desc,CrLf:=chr(13)+chr(10)
LOCAL obor_otpenq,oborotpenq,obor_othigh,oborothigh
LOCAL penq_total:=0,high_total:=0,Month,Abon_Total:=0,SaldoA:=0,Sal:=0
if al_box({"Произвести выбор задолжников пени и повышенной"},2)==1
   Month:=Month_Menu("для выбора задолжников")
   win_save:=obrabot("Выбор задолжников пени и повышенной")
   desc:=fcreate(Ddir+'otchet.gkv')
//   fwrite(desc,stroka+CrLf+"Задолжники оплаты пени и повышенной"+CrLf)
   fwrite(desc,CrLf+"Задолжники оплаты пени и повышенной"+CrLf)
   fwrite(desc,replicate('-',len(str(main->lic_schet)))+"-"+;
          replicate('-',40)+"-"+;
          replicate('-',52)+CrLf)
   fwrite(desc,center("Лиц.сч.",len(str(main->lic_schet)),' ',.T.)+"|"+;
          center("Потребитель",40,' ',.T.)+"|"+;
          center("Пеня",11,' ',.T.)+"|"+;
          center("Повышенная",11,' ',.T.)+"|"+;
          center("Абонированная",13," ",.t.)+"|"+;
          Center("Сальдо",14," ",.t.)+"|"+CrLf)
   fwrite(desc,replicate('-',len(str(main->lic_schet)))+"-"+;
          replicate('-',40)+"-"+;
          replicate('-',52)+CrLf)
   go top
   do while !eof()
      kol_kl=kol_kl+temp_
      colorwin(12,21,12,21+kol_kl,'n/n')
      select 15
      seek main->lic_schet
      if found()
        SaldoA:=GetAbonSaldo(Main->Lic_Schet,Month)
        Sal:=GetSaldo(Main->Lic_Schet,Month)
        Sal:=IF(Sal<0,"Дт "+Str(-1*Sal,11,2),"Кт "+Str(Sal,11,2))
        obor_otpenq=0
        oborotpenq=obormot->saldop
        for i=1 to 12
                klk='penq'+alltrim(str(int(i)))
                obor_otpenq=obor_otpenq+obormot->&klk
                klk='penqn'+alltrim(str(int(i)))
                oborotpenq=oborotpenq+obormot->&klk
        next
        obor_othigh=0
        oborothigh=obormot->saldoh
        for i=1 to 12
                klk='high'+alltrim(str(int(i)))
                obor_othigh=obor_othigh+obormot->&klk
                klk='highn'+alltrim(str(int(i)))
                oborothigh=oborothigh+obormot->&klk
        next
        if (oborotpenq-obor_otpenq)!=0.or.(oborothigh-obor_othigh)!=0.or.SaldoA!=0
           fwrite(desc,str(main->lic_schet)+"|"+Substr(main->potrebitel,1,40)+"|"+;
                  str(oborotpenq-obor_otpenq,11,0)+"|"+;
                  str(oborothigh-obor_othigh,11,0)+"|"+;
                  If(SaldoA<0,"Дт "+Str(-1*SaldoA,10,2),"Кт "+Str(SaldoA,10,2))+"|"+;
                  Sal+"|"+CrLf)
           penq_total:=penq_total+(oborotpenq-obor_otpenq)
           high_total:=high_total+(oborothigh-obor_othigh)
           Abon_total:=Abon_Total+SaldoA
        endif
      else
           fwrite(desc,"По лицевому счету "+alltrim(str(main->lic_schet))+;
                       "данные в оборотке не найдены"+CrLf)
      endif
      select(select)
      skip
      if hot_inkey()#0
         if al_box({"Прервать расчет ?"},2)==1
            exit
         endif
      endif
   enddo
   fwrite(desc,replicate('-',len(str(main->lic_schet)))+"-"+;
          replicate('-',40)+"-"+;
          replicate('-',52)+CrLf)
   fwrite(desc,space(len(str(main->lic_schet)))+" "+;
          space(40)+" "+;
          str(penq_total,11,0)+" "+;
          str(high_total,11,0)+" "+str(Abon_Total,13,0)+" "+CrLf)
   fclose(desc)
   win_rest(win_save)
endif
select(select)
go recno
setcolor(color)
return  NIL




STATIC function big_debet
LOCAL select:=select(),recno:=recno(),screen:=win_save(8,12,14,67)
LOCAL kol_mes,obr_scr,start_mes,desc,debstr,str_deb,cou_deb,sum_deb
LOCAL crlf:=chr(13)+chr(10),color:=setcolor(),temp_,kol_kl,str_kre,total:=0
LOCAL tot_sum:=0,sel
start_mes:=month_menu()
kol_mes=start_mes
if start_mes>0
   colorwin(09,13,14,67,'n+/n')
   set color to n/w,n/g
   @ 08,12 say "┌─────────────────────────────────────────────────────╖"
   @ 09,12 say "│"+space(53)+"║"
   @ 10,12 say "│   Укажите длительность задолженности    (мес.)      ║"
   @ 11,12 say "│   От суммы                   До суммы               ║"
   @ 12,12 say "│"+space(53)+"║"
   @ 13,12 say "╘═════════════════════════════════════════════════════╝"
   min_dolg=0
   max_dolg=999999999999
   set cursor on
   @ 10,51 get kol_mes picture "@K 99"
   @ 11,26 get min_dolg
   @ 11,53 get max_dolg
   read
   set cursor off
   setcolor(color)
   if lastkey()#27
    if kol_mes>0
     if kol_mes<=start_mes
       kol_mes=kol_mes-1
       desc=fcreate(Ddir+"otchet.gkv")
       fwrite(desc,"Выборка задолжников. Период "+mesqc(start_mes)+;
                " - "+mesqc(start_mes-kol_mes)+crlf)
       fwrite(desc,if(min_dolg#0,"От суммы не менее "+alltrim(str(min_dolg))+" ","")+;
                   if(max_dolg#999999999999,"До суммы не более "+alltrim(str(max_dolg)),"")+CrLf+CrLf)
       obr_scr:=obrabot("Выборка задолжников за "+alltrim(str(kol_mes+1))+;
                " месяцев.")
       temp_=39/reccount()
       kol_kl=0
       go top
       do while !eof()
          select 15
          seek main->lic_schet
          kol_kl=kol_kl+temp_
          colorwin(12,21,12,21+kol_kl,'n/n')
          if found()
             cou_deb=0
             sum_deb=0
             deb_str=""
             for i=start_mes-kol_mes to start_mes
                 str_deb="debet"+alltrim(str(int(i)))
                 str_kre="kredit"+alltrim(str(int(i)))
                 if(&str_deb>0.and.&str_kre=0)
//*********************************** Выборка сумм от MIN до MAX
                  if (min_dolg<=&str_deb) .and. (max_dolg>=&str_deb)
                   cou_deb=cou_deb+1
                   if i#start_mes
                      deb_str=deb_str+str(&str_deb)+"  "
                      sum_deb=sum_deb+&str_deb
                   endif
                  endif
                 endif
             next
             if cou_deb-1=kol_mes
                sel=select()
                select 77                       && Для поиска адреса.
                seek main->lic_schet
                select(sel)
                fwrite(desc,str(main->lic_schet)+" ("+alltrim(main->dogowor)+;
                       ") "+delstring(alltrim(main->potrebitel),"ИНН")+" "+alltrim(licevoj->adres)+crlf+;
                            chr(15)+deb_str+"  ["+alltrim(str(&str_deb))+"]"+;
                            chr(18)+crlf)
                total=total+1
                tot_sum=tot_sum+&str_deb
             endif
          endif
          select 88
          skip
       enddo
       fwrite(desc,crlf+"Всего задолжников "+alltrim(str(total))+;
                   "  Задолженность "+str(tot_sum)+crlf)
       fclose(desc)
       if total=0
          al_box({"Задолжников не обнаружено."})
       endif
       win_rest(obr_scr)
     else
          al_box({"Неверное количество месяцев к выборке"})
     endif
    endif
   endif
   win_rest(screen)
   select(select)
   fclose(desc)
   go recno
endif
return NIL





STATIC function big_kred
LOCAL select:=select(),recno:=recno(),screen:=win_save(8,12,14,67)
LOCAL kol_mes,obr_scr,start_mes,desc,debstr,str_deb,cou_deb,sum_deb
LOCAL crlf:=chr(13)+chr(10),color:=setcolor(),temp_,kol_kl,str_kre,total:=0
LOCAL tot_sum:=0,sel
start_mes:=month_menu()
kol_mes=start_mes
if start_mes>0
   colorwin(09,13,14,67,'n+/n')
   set color to n/w,n/g
   @ 08,12 say "┌─────────────────────────────────────────────────────╖"
   @ 09,12 say "│"+space(53)+"║"
   @ 10,12 say "│   Укажите длительность кредиторской     (мес.)      ║"
   @ 11,12 say "│   От суммы                   До суммы               ║"
   @ 12,12 say "│"+space(53)+"║"
   @ 13,12 say "╘═════════════════════════════════════════════════════╝"
   min_dolg=0
   max_dolg=999999999999
   set cursor on
   @ 10,51 get kol_mes picture "@K 99"
   @ 11,26 get min_dolg
   @ 11,53 get max_dolg
   read
   set cursor off
   setcolor(color)
   if lastkey()#27
    if kol_mes>0
     if kol_mes<=start_mes
       kol_mes=kol_mes-1
       desc=fcreate(Ddir+"otchet.gkv")
       fwrite(desc,"Выборка кредиторов. Период "+mesqc(start_mes)+;
                " - "+mesqc(start_mes-kol_mes)+crlf)
       fwrite(desc,if(min_dolg#0,"От суммы не менее "+alltrim(str(min_dolg))+" ","")+;
                   if(max_dolg#999999999999,"До суммы не более "+alltrim(str(max_dolg)),"")+CrLf+CrLf)
       obr_scr:=obrabot("Выборка кредиторов за "+alltrim(str(kol_mes+1))+;
                " месяцев.")
       temp_=39/reccount()
       kol_kl=0
       go top
       do while !eof()
          select 15
          seek main->lic_schet
          kol_kl=kol_kl+temp_
          colorwin(12,21,12,21+kol_kl,'n/n')
          if found()
             cou_deb=0
             sum_deb=0
             deb_str=""
             for i=start_mes-kol_mes to start_mes
                 str_deb="debet"+alltrim(str(int(i)))
                 str_kre="kredit"+alltrim(str(int(i)))
                 if(&str_kre>0.and.&str_deb=0)
//*********************************** Выборка сумм от MIN до MAX
                  if (min_dolg<=&str_kre) .and. (max_dolg>=&str_kre)
                   cou_deb=cou_deb+1
                   if i#start_mes
                      deb_str=deb_str+str(&str_kre,12,2)+"|"
                      sum_deb=sum_deb+&str_kre
                   endif
                  endif
                 endif
             next
             if cou_deb-1=kol_mes
                sel=select()
                select 77                       && Для поиска адреса.
                seek main->lic_schet
                select(sel)
                fwrite(desc,str(main->lic_schet,6)+"|"+;
                       Substr(delstring(alltrim(main->potrebitel),"ИНН")+Space(30),1,30)+"|"+;
                       deb_str+str(&str_kre,12,2)+"|"+crlf)
                total=total+1
                tot_sum=tot_sum+&str_kre
             endif
          endif
          select 88
          skip
       enddo
       fwrite(desc,crlf+"Всего кредиторов "+alltrim(str(total))+;
                   "  Кредиторская "+str(tot_sum)+crlf)
       fclose(desc)
       if total=0
          al_box({"Кредиторов не обнаружено."})
       endif
       win_rest(obr_scr)
     else
          al_box({"Неверное количество месяцев к выборке"})
     endif
    endif
   endif
   win_rest(screen)
   select(select)
   go recno
endif
return NIL



STATIC Function DebFull()
Local MainSum:=0,Rec:=Recno(),Sel:=Select(),Win,Desc
Local Str_Deb:="Debet",Temp_:=39/Reccount(),Kol_Kl:=0.00
Local CrLf:=Chr(13)+Chr(10),TPenq:="",THigh:="",nMonth
MinSum:=GetVal("Минимальная сумма долга",0.00,-1)
If MinSum<=0
   Return Nil
Endif
nMonth:=Month_Menu()
IF nMonth==0
   Return NIL
ENDIF
Go Top
Desc:=Fcreate(DDir+ReportFile)
FWrite(Desc,replicate("-",81)+CrLf)
FWrite(Desc," Л/с |"+Center("Потребитель",30," ",.t.)+"|"+Center("Эл.Эн",14," ",.t.)+"|"+;
       Center("Превышен.",14," ",.t.)+"|"+Center("Пеня",14," ",.t.)+"|"+CrLf)
FWrite(Desc,replicate("-",81)+CrLf)
SumDeb :=0
SumHigh:=0
SumPenq:=0
Win:=Obrabot("Идет обработка данных")
Do While !Eof()
   Select 15
   Seek Main->Lic_Schet
   Kol_Kl=Kol_Kl+Temp_
   Colorwin(12,21,12,21+Kol_Kl,'n/n')
   If Found()
      Str_Deb="debet"+AllTrim(str(int(nMonth)))
      IF &Str_Deb>=MinSum
         Deb:=0; SPenq:=0; SHigh:=0
         SumDeb=SumDeb+&Str_Deb
         Deb:=&Str_Deb
         For I=1 To 12
             TPenq:="Penq"+alltrim(Str(i))
             SPenq:=SPenq-&TPenq
             TPenq:="PenqN"+alltrim(Str(i))
             SPenq:=SPenq+&TPenq

             THigh:="High"+alltrim(Str(i))
             SHigh:=SHigh-&THigh
             THigh:="HighN"+alltrim(Str(i))
             SHigh:=SHigh+&THigh
         Next
         SumHigh:=SumHigh+SHigh; SumPenq:=SumPenq+SPenq
         FWrite(Desc,Str(Main->Lic_Schet,5,0)+"|"+Center(Substr(Delstring(Main->Potrebitel,"ИНН"),1,30),30," ",.t.)+;
                   "|"+Str(Deb,14,2)+"|"+Str(SHigh,14,2)+"|"+Str(SPenq,14,2)+"|"+CrLf+Space(36)+;
                   "|"+Str(Deb*Schet_Nds/(100+Schet_Nds),14,2)+"|"+Str(SHigh*Schet_Nds/(100+Schet_Nds),14,2)+;
                   "|"+Str(SPenq*Schet_Nds/(100+Schet_Nds),14,2)+"|"+CrLf)
      EndIf
   Endif
   Select 88
   Skip
Enddo
FWrite(Desc,replicate("-",81)+CrLf)
Fwrite(Desc,"Всего:"+CrLf)
FWrite(Desc,"Эл.Энергия "+str(SumDeb,15,2)+"  НДС "+ str(SumDeb *Schet_Nds/(100+Schet_Nds),15,2)+CrLf)
FWrite(Desc,"Превышение "+str(SumPenq,15,2)+"  НДС "+str(SumPenq*Schet_Nds/(100+Schet_Nds),15,2)+CrLf)
FWrite(Desc,"Пеня       "+str(SumHigh,15,2)+"  НДС "+str(SumHigh*Schet_Nds/(100+Schet_Nds),15,2)+CrLf)
FClose(Desc)
Select(Sel)
Go Rec
Win_Rest(Win)
Return Nil



STATIC FUNCTION SverkaReestr()
LOCAL Sel:=Select(), Rec:=Recno(),Win:=Win_Save(),Clr:=SetColor()
LOCAL Pos:=0,Debet:=0,DebetPenq:=0,Str:="Debet",Month,Desc,Str2,Penq
LOCAL CrLf:=Chr(13)+Chr(10),TmpStr,Sum1:=0,Sum2:=0,Dolg:=0
Month:=Month_Menu("Реестр актов сверки")
IF Month<=0
   Return NIL
ENDIF
Str:=Str+Alltrim(Str(Month))
Select Main
Go Top
Obrabot("Реестр актов сверки по бюджету")
Desc:=Fcreate(DDir+ReportFile)
Fwrite(Desc,"┌──────────────────────────────┬─────────────────────────┬────────────────────┐"+CrLf)
Fwrite(Desc,"│         Наименование         │         Сумма           │ Сумма задолженности│"+CrLf)
Fwrite(Desc,"│         потребителя          │     задолженности       │   подтвержденная   │"+CrLf)
Fwrite(Desc,"│                              ├────────────┬────────────┤    актом сверки    │"+CrLf)
Fwrite(Desc,"│                              │  за эл.эн. │    пени    │                    │"+CrLf)
Fwrite(Desc,"├──────────────────────────────┼────────────┼────────────┼────────────────────┤"+CrLf)
Do While .Not.Eof()
   Pos=Pos+(39/Reccount())
   Colorwin(12,21,12,21+Pos,'n/n')
   IF .NOT.Empty(Lim_Tar1)
      Dolg:=GetDolg(Lic_Schet,Month)
      Select Obormot
      Seek Main->Lic_Schet
      IF Found()
         Penq:=0
         For i=1 to Month
             Str:="Penq"+alltrim(str(i))
             Penq:=Penq-&Str
             Str:="Penqn"+alltrim(str(i))
             Penq:=Penq+&Str
         Next
         IF Dolg#0.or.Penq#0
            TmpStr:=Substr(Delstring(Main->Potrebitel,"ИНН"),1,30)
            fwrite(Desc,"│"+TmpStr+Space(30-Len(TmpStr))+"│"+str(Dolg,12,2)+"│"+str(Penq,12,2)+"│                    │"+CrLf)
            Sum1:=Sum1+Dolg
            Sum2:=Sum2+Penq
         ENDIF
      ENDIF
   ENDIF
   Select Main
   Skip
EndDO
Fwrite(Desc,"└──────────────────────────────┴────────────┴────────────┴────────────────────┘"+CrLf)
FWrite(Desc,"                                "+str(Sum1,12,2)+" "+str(Sum2,12,2)+CrLf)
Fclose(Desc)
Select(Sel)
Go Rec
SetColor(Clr)
Win_Rest(Win)
Return NIL




STATIC FUNCTION Svedeniya()
LOCAL Sel:=Select(),Rec:=Recno(),Win:=Win_Save(),Clr:=SetColor()
LOCAL Month:=Month_Menu("для расчетов сведений"),Pos:=0,Poisk:="",Dolg
PRIVATE Count:=0,Sum:=0,Str:="Debet",Energy:=0,Oplata:=0,Mon:=Month
PRIVATE Bud:=0,BudSum:=0
IF Month==0
   Return NIL
ENDIF
Str:=Str+Alltrim(Str(Month))
Obrabot("Сбор информации о дебеторах и отпуске")
GO Top
DO WHILE .NOT.Eof()
   Pos=Pos+(39/Reccount())
   Colorwin(12,21,12,21+Pos,'n/n')
   IF (Dolg:=GetDolg(Lic_Schet,Month))!=0
      Sum:=Sum+Dolg
      Count++
   ENDIF
   Energy:=Energy+GetSum(Lic_Schet,Month)
   IF .NOT.Empty(Lim_Tar1)
      Bud++
      BudSum:=BudSum+GetSum(Lic_Schet,Month)
   ENDIF
   Skip
ENDDO
//Energy:=Energy+Round(Energy*100/Schet_Nds,Decimal)
Obrabot("Сбор информации об оплате")
Select 0
pos:=0
Str:=Schet_Share+"o"+Alltrim(Str(Month))+".Dbf"
NetUse(Str)
GO Top
DO While .Not.Eof()
   Pos=Pos+(39/Reccount())
   Colorwin(12,21,12,21+Pos,'n/n')
   Oplata:=Oplata+Summa
   Skip
EndDo
Close
Win_Rest(Win)
Report(DDir+"Sveden.rpt",DDir+ReportFile,200)
Select(Sel)
Go rec
Win_Rest(Win)
SetColor(Clr)
Return NIL



STATIC Function OplataInfo()
LOCAL Sel:=Select(),Rec:=Recno(),Win:=Win_Save(),Clr:=SetColor()
LOCAL Month:=Month_Menu("информации об оплате"),Pos:=0
PRIVATE Energy:=0,Oplata:=0,Neopl:=0,SDat,EDat
IF Month==0
   Return NIL
ENDIF
SDat:="01."+IF(Month<10,"0","")+alltrim(Str(Month))+"."+Substr(Alltrim(Str(Year(New_date))),3)
EDat:=Alltrim(Str(LastDayOm(Month)))+"."+IF(Month<10,"0","")+alltrim(Str(Month))+"."+Substr(Alltrim(Str(Year(New_date))),3)
go top
Obrabot("Информация о фактической оплате")
DO WHILE .NOT.Eof()
   Pos=Pos+(39/Reccount())
   Colorwin(12,21,12,21+Pos,'n/n')
   Energy:=Energy+GetSum(Lic_Schet,Month)
   Oplata:=Oplata+CalckPay(Month,Lic_Schet,.f.)
   IF .Not.Empty(Lim_Tar1)
      Neopl:=Neopl+GetSum(Lic_Schet,Month)
   ENDIF
   SKIP
ENDDO
//Energy:=Round(Energy*(100+Schet_Nds)/100,2)
Report(DDir+"OplInfo.Rpt",DDir+ReportFile)
Select(Sel)
Go Rec
Win_Rest(Win)
SetColor(Clr)
Return NIL



STATIC Function InfoF1()
LOCAL Sel:=Select(),Rec:=Recno(),Win:=Win_Save(),Clr:=SetColor()
LOCAL Month:=Month_Menu("для генерации Формы N1"),TmpVal,Pos:=0
PRIVATE Dolg:=0,Energy:=0,Oplata:=0,String1:="",String2:=0,String3:=0
PRIVATE String4:=0,SDat,EDat
IF Month==0
   Return NIL
ENDIF
SDat:="01."+IF(Month<10,"0","")+alltrim(Str(Month))+"."+Substr(Alltrim(Str(Year(New_date))),3)
EDat:=Alltrim(Str(LastDayOm(Month)))+"."+IF(Month<10,"0","")+alltrim(Str(Month))+"."+Substr(Alltrim(Str(Year(New_date))),3)
go top
Obrabot("Расчет Формы N1")
DO WHILE .NOT.EOF()
   IF Hot_Inkey()==27.and.al_box({"Прекратить расчет"},2)==1
      EXIT
   ENDIF
   Pos=Pos+(39/Reccount())
   Colorwin(12,21,12,21+Pos,'n/n')
   TmpVal:=GetDolg(Lic_Schet,Month)
   Energy:=Energy+GetSum(Lic_Schet,Month)
   Dolg:=Dolg+TmpVal
   Oplata:=Oplata+CalckPay(Month,Lic_Schet,.f.)
   IF String2<TmpVal
      String1:=Substr(Delstring(Potrebitel,"ИНН"),1,15)
      String2:=TmpVal
      String3:=GetSum(Lic_Schet,Month)
      String4:=CalckPay(Month,Lic_Schet,.f.)
   ENDIF
   SKIP
ENDDO
Report(DDir+"InfoF1.Rpt",DDir+ReportFile)
Select(Sel)
Go Rec
Win_Rest(Win)
SetColor(Clr)
Return NIL



STATIC Function DebetOneMonth()
LOCAL Sel:=Select(),Rec:=Recno(),Clr:=SetColor(),Win,Month,Pos:=0,Desc
LOCAL Sum:=0,CrLf:=Chr(13)+Chr(10),TmpVal
Month:=Month_Menu("для выбора дебеторов")
IF Month==0
   Return NIL
ENDIF
Win:=Obrabot("Выборка дебеторов за текущий месяц")
Desc:=FCreate(DDir+ReportFile)
Select Main
GO Top
FWrite(Desc,Center(SchetNameOrg,78," ",.t.)+CrLf)
IF Month==Month(New_date)
   FWrite(Desc,"Дебеторы на "+DToC(New_date)+CrLf)
ELSE
   IF Month+1<13
      FWrite(Desc,"Дебеторы на 01."+IF(Month+1<10,"0","")+Alltrim(Str(Month+1))+"."+Alltrim(Str(Year(New_date)))+CrLf)
   ELSE
      FWrite(Desc,"Дебеторы на 01.01."+Alltrim(Str(Year(New_date)+1))+CrLf)
   ENDIF
ENDIF
FWrite(Desc,"┌"+Replicate("─",4)+"┬"+Replicate("─",Len(Potrebitel))+"┬"+Replicate("─",14)+"┐"+CrLf)
FWrite(Desc,"│Л.сч│"+Center("Потребитель",Len(Potrebitel)," ",.t.)+"│ Задолженность│"+CrLf)
FWrite(Desc,"├"+Replicate("─",4)+"┼"+Replicate("─",Len(Potrebitel))+"┼"+Replicate("─",14)+"┤"+CrLf)
DO While .Not.Eof()
   Pos=Pos+(39/Reccount())
   Colorwin(12,21,12,21+Pos,'n/n')
   TmpVal:=GetDolg(Main->Lic_Schet,Month)
   IF TmpVal!=0
      FWrite(Desc,"│"+Str(Main->Lic_Schet,4,0)+"│"+Main->Potrebitel+"│"+Str(TmpVal,14,Decimal)+"│"+CrLf)
      Sum:=Sum+TmpVal
   ENDIF
   SKIP
ENDDO
FWrite(Desc,"└"+Replicate("─",4)+"┴"+Replicate("─",Len(Potrebitel))+"┴"+Replicate("─",14)+"┘"+CrLf)
Fwrite(Desc,"Итого: "+Str(Sum,14,Decimal)+CrLf)
FClose(Desc)
Win_Rest(Win)
Select(Sel); Go Rec
Return NIL



STATIC Function F46EC()
LOCAL Sel:=Select(),Rec:=Recno(),Win:=Win_Save(),Clr:=SetColor()
LOCAL Month:=Month_Menu("для расчета формы"),DataBase:="",Index:=dir+'temp.ntx'
LOCAL Count:=0,Cou:=0,Kol_Kl:=0,Tmp_Sum:=0,Summ:=0
Private Mass:={}
Select(Month)
Al_Box({"Sorry, Under Construction"},1,{" Call Programmer "})
do case
        case month=1
                base='Jan'
        case month=2
                base="Feb"
        case month=3
                base='Mar'
        case month=4
                base='Apr'
        case month=5
                base="May"
        case month=6
                base='Jun'
        case month=7
                base='Jul'
        case month=8
                base='Aug'
        case month=9
                base='Sep'
        case month=10
                base='Oct'
        case month=11
                base='Nov'
        case month=12
                base='Dec'
endcase
Obrabot("Поиск тарифов")
DataBase=Schet_Share+base+'.dbf'
Select(Month)
Index On Tarif To &Index Unique
Go Top
Count=0
Do While !Eof()
   Count++
   Skip
Enddo
Go Top
Cou=0
Obrabot("Сортировка тарифов")
do while !eof()
   kol_kl=kol_kl+39/Count
   colorwin(12,21,12,21+kol_kl,'n/n')
   cou++
   aadd(mass,{tarif,0,0,0,0})
   skip
enddo
use
//----------------- Открытие базы с индексом в области показаний счетчиков...
Loadmonth(month)
go top
tmp_sum:=tmp_sum+summ
summ:=0; Kol_Kl:=0
Obrabot("Расчет расхода и начисления")
for i=1 to count
    kol_kl=kol_kl+39/Count
    colorwin(12,21,12,21+kol_kl,'n/n')
    rash=0
    summ=0
    go top
    do while .not.eof()
       if mass[i][1]=tarif
          select:=select()
          lic:=licevoj
          select main
          seek lic
          select(select)
          rash:=0; Summ:=0
             if summa#0
                if rashod>0
                   rash=if(rashod-subab>0,rashod-subab,subab-rashod)
                   summ=summa
                   IF MAIN->Kniga_old#7
                      Mass[i][2]:=Mass[i][2]+rash
                      Mass[i][3]:=Mass[i][3]+summ
                   ELSE
                      Mass[i][4]:=Mass[i][4]+rash
                      Mass[i][5]:=Mass[i][5]+summ
                   ENDIF
                else
                   rash=rashod
                   summ=summa
                   IF MAIN->Kniga_old#7
                      Mass[i][2]:=Mass[i][2]+rash
                      Mass[i][3]:=Mass[i][3]+summ
                   ELSE
                      Mass[i][4]:=Mass[i][4]+rash
                      Mass[i][5]:=Mass[i][5]+summ
                   ENDIF
                endif
             endif
       endif
       skip
    enddo
next
for i=1 to count
    for j=2 to 5
        Mass[i][j]=Round(Mass[i][j]/1000,1)
    next
Next
use
loadmonth(month)
Pos11:=Mass[8][4]+Mass[9][4]+2.8
Pos12:=Mass[8][5]+Mass[9][5]+Mass[12][5]
Pos21:=Mass[10][4]
Pos22:=Mass[10][5]
Pos51:=Mass[10][2]
Pos52:=Mass[10][3]
Pos61:=Mass[7][2]
Pos62:=Mass[7][3]
Pos71:=Mass[6][2]+Mass[6][4]+Mass[5][2]
Pos72:=Mass[6][3]+Mass[6][5]+Mass[5][3]
Report(DDir+"Fn46Ec.Rpt",DDir+ReportFile,180)
Select(Sel); Go Rec
SetColor(Clr); Win_Rest(Win)
Return NIL


STATIC Function InfoF2()
Al_Box({"Sorry, Under Construction"},1,{" Call Programmer "})
Return NIL


STATIC Function Form36()
LOCAL Sel:=Select(),Rec:=RecNo(),Win:=Win_Save(),Clr:=SetColor(),Desc
LOCAL CrLf:=Chr(13)+Chr(10),Mass601[8],Mass1[8],Mass[8]
Local Post601:={26,132,531,729,788,419,14,844,1237,1103,144,37,432,29,182,508,153,27,951,78,14,117,124,74,679}
Local Post1:={12,46,48,65,134,270,345,575,1175,1184,1190,1200,1215,1251}
Local Month,KolKl:=0
AFill(Mass601,0); AFill(Mass1,0); AFill(Mass,0)
Month:=Month_Menu("расчета формы N36")
IF Month==0
   Return Nil
Endif
Select Main
go top
Obrabot("Расчет Формы N36")
DO WHILE .NOT.Eof()
   KolKl=KolKl+39/reccount()
   colorwin(12,21,12,21+KolKl,'n/n')
   For i=1 to Len(Post601)
       IF Post601[i]==Lic_Schet
          Mass601[1]:=Mass601[1]+1
//          Mass601[2]:=Mass601[2]+Round(GetRashod(Main->Lic_Schet,Month)/1000000,1)
          Mass601[2]:=Mass601[2]+Round(GetLimit(Month,Main->Lic_Schet)/1000,1)
          Mass601[3]:=Mass601[3]+Round(GetSum(Main->Lic_Schet,Month)/1000,1)
          Mass601[4]:=Mass601[4]+Round((GetSil(Main->Lic_Schet,1)+GetSil(Main->Lic_Schet,2))/1000,1)
          IF GetDolg(Main->Lic_Schet,Month)>2000
             Mass601[5]:=Mass601[5]+1
             Mass601[6]:=Mass601[6]+Round(GetDolg(Main->Lic_Schet,Month)/1000,1)
             Mass601[7]:=Mass601[7]+Round(GetLimit(Month,Main->Lic_Schet)/1000,1)
             Mass601[8]:=Mass601[8]+Round((GetSil(Main->Lic_Schet,1)+GetSil(Main->Lic_Schet,2))/1000,1)
          ENDIF
       ENDIF
   Next
   For i=1 to Len(Post1)
       IF Post1[i]==Lic_Schet
          Mass1[1]:=Mass1[1]+1
//          Mass1[2]:=Mass1[2]+Round(GetRashod(Main->Lic_Schet,Month)/1000000,1)
          Mass1[2]:=Mass1[2]+Round(GetLimit(Month,Main->Lic_Schet)/1000,1)
          Mass1[3]:=Mass1[3]+Round(GetSum(Main->Lic_Schet,Month)/1000,1)
          Mass1[4]:=Mass1[4]+Round((GetSil(Main->Lic_Schet,1)+GetSil(Main->Lic_Schet,2))/1000,1)
          IF GetDolg(Main->Lic_Schet,Month)>2000
             Mass1[5]:=Mass1[5]+1
             Mass1[6]:=Mass1[6]+Round(GetDolg(Main->Lic_Schet,Month)/1000,1)
             Mass1[7]:=Mass1[7]+Round(GetLimit(Month,Main->Lic_Schet)/1000,1)
             Mass1[8]:=Mass1[8]+Round((GetSil(Main->Lic_Schet,1)+GetSil(Main->Lic_Schet,2))/1000,1)
          ENDIF
       ENDIF
   Next
   Mass[1]:=Mass[1]+1
//   Mass[2]:=Mass[2]+Round(GetRashod(Main->Lic_Schet,Month)/1000000,1)
   Mass[2]:=Mass[2]+Round(GetLimit(Month,Main->Lic_Schet)/1000,1)
   Mass[3]:=Mass[3]+Round(GetSum(Main->Lic_Schet,Month)/1000,1)
   Mass[4]:=Mass[4]+Round((GetSil(Main->Lic_Schet,1)+GetSil(Main->Lic_Schet,2))/1000,1)
   IF GetDolg(Main->Lic_Schet,Month)>2000
      Mass[5]:=Mass[5]+1
      Mass[6]:=Mass[6]+Round(GetDolg(Main->Lic_Schet,Month)/1000,1)
      Mass[7]:=Mass[7]+Round(GetLimit(Month,Main->Lic_Schet)/1000,1)
      Mass[8]:=Mass[8]+Round((GetSil(Main->Lic_Schet,1)+GetSil(Main->Lic_Schet,2))/1000,1)
   ENDIF
   Skip
ENDDO
Desc:=Fcreate(DDir+ReportFile)
FWrite(Desc,"                   И Н Ф О Р М А Ц И Я"+CrLf+"       о работе с потребителями энергии"+CrLf)
FWrite(Desc,'        '+SchetNameOrg+CrLf)
FWrite(Desc,"------------------------------------------------------------"+CrLf)
FWrite(Desc,"         Информация о потребителях           |     Э/Э"+CrLf)
FWrite(Desc,"------------------------------------------------------------"+CrLf)
FWrite(Desc,"1. Количество всего, в том числе          (шт)"+str(Mass[1],12)+CrLf)
FWrite(Desc,"1.1 Неотключаемых (пост.N601)             (шт)"+Str(Mass601[1],12)+CrLf)
FWrite(Desc,"1.2 Попадающих под действие Пост.N1       (шт)"+Str(Mass1[1],12)+CrLf)
FWrite(Desc,"1.3 Остальных                             (шт)"+Str(Mass[1]-Mass601[1]-Mass1[1],12)+CrLf)
FWrite(Desc,"2. Месячное потребление энергии, в т.ч. (мВтч)"+Str(Mass[2],12,2)+CrLf)
FWrite(Desc,"                                     (тыс.руб)"+Str(Mass[3],12,2)+CrLf)
FWrite(Desc,"2.1 Неотключаемыми                      (мВтч)"+Str(Mass601[2],12,2)+CrLf)
FWrite(Desc,"                                     (тыс.руб)"+Str(Mass601[3],12,2)+CrLf)
FWrite(Desc,"2.2 Попадающими под действие Пост.N1    (мВтч)"+Str(Mass1[2],12,2)+CrLf)
FWrite(Desc,"                                     (тыс.руб)"+Str(Mass1[3],12,2)+CrLf)
FWrite(Desc,"2.3 Остальными                          (мВтч)"+Str(Mass[2]-Mass601[2]-Mass1[2],12,2)+CrLf)
FWrite(Desc,"                                     (тыс.руб)"+Str(Mass[3]-Mass601[3]-Mass1[3],12,2)+CrLf)
FWrite(Desc,"3. Договорная мощность потребит. в т.ч.  (мВт)"+Str(Mass[4],12,2)+CrLf)
FWrite(Desc,"3.1 Неоключаемых (Пост.N601)             (мВт)"+Str(Mass601[4],12,2)+CrLf)
FWrite(Desc,"3.2 Попадающих под действие Пос.тN1      (мВт)"+Str(Mass1[4],12,2)+CrLf)
FWrite(Desc,"3.3 Остальных                            (мВт)"+Str(Mass[4]-Mass1[4]-Mass601[4],12,2)+CrLf)
FWrite(Desc,"3.4 Аварийная бронь потребителей         (мВт)"+CrLf)
FWrite(Desc,"ПОДЛЕЖАТ ОТКЛЮЧЕНИЮ ИЗ-ЗА НАРУШЕНИЯ СРОКОВ ОПЛАТЫ"+CrLf)
FWrite(Desc,"4. Кол-во неплательщ.всего в т.ч.         (шт)"+Str(Mass[5],12)+CrLf)
FWrite(Desc,"4.1 Попадающих под действие Пост N1       (шт)"+Str(Mass1[5],12)+CrLf)
FWrite(Desc,"4.2 Остальных (по договору электронабж.)  (шт)"+Str(Mass[5]-Mass1[5]-Mass601[5],12)+CrLf)
FWrite(Desc,"4.3 Неотключаемых (Пост. N601)            (шт)"+Str(Mass601[5],12)+CrLf)
FWrite(Desc,"5 Долг неплательщ. всего в том числе    (мВтч)"+Str(Mass[7],12,2)+CrLf)
FWrite(Desc,"                                     (тыс.руб)"+Str(Mass[6],12,2)+CrLf)
FWrite(Desc,"5.1 Попадающих под действие Пост.N1     (мВтч)"+Str(Mass1[7],12,2)+CrLf)
FWrite(Desc,"                                     (тыс.руб)"+Str(Mass1[6],12,2)+CrLf)
FWrite(Desc,"5.2 Остальных                           (мВтч)"+Str(Mass[7]-Mass1[7]-Mass601[7],12,2)+CrLf)
FWrite(Desc,"                                     (тыс.руб)"+Str(Mass[6]-Mass1[6]-Mass601[6],12,2)+CrLf)
FWrite(Desc,"5.3 Неотключаемых (Пост N601)           (мВтч)"+Str(Mass601[7],12,2)+CrLf)
FWrite(Desc,"                                     (тыс.руб)"+Str(Mass601[6],12,2)+CrLf)
FWrite(Desc,"6. Договор.мощн.всего в т.ч.             (мВт)"+Str(Mass[8],12,2)+CrLf)
FWrite(Desc,"6.1 Попадающих под действие Пост.N1      (мВт)"+Str(Mass1[8],12,2)+CrLf)
FWrite(Desc,"6.2 Остальных (по договору энергоснабж.) (мВт)"+Str(Mass[8]-Mass1[8]-Mass601[8],12,2)+CrLf)
FWrite(Desc,"6.3 Неотключаемых (Пост. N601)           (мВт)"+Str(Mass601[8],12,2)+CrLf)
FWrite(Desc,"6.4 Аварийная бронь подлежащих отключ.   (мВт)"+CrLf)
FWrite(Desc,"       ОГРАНИЧЕНО НЕПЛАТЕЛЬЩИКОВ"+CrLf)
FWrite(Desc,"7. Количество всего, в тч.                (шт)"+CrLf)
FWrite(Desc,"7.1 Попадающих под действие Пост N1       (шт)"+CrLf)
FWrite(Desc,"7.2 Остальных (по договору нергоснабж.)   (шт)"+CrLf)
FWrite(Desc,"8 Долг всего, в т.ч.                 (тыс.руб)"+CrLf)
FWrite(Desc,"8.1 Попадающих под действие Пост.N1  (тыс.руб)"+CrLf)
FWrite(Desc,"8.2 Остальных                        (тыс.руб)"+CrLf)
FWrite(Desc,"9 Огранич. мощн., всего в т.ч.           (мВт)"+CrLf)
FWrite(Desc,"9.1 Попадающих по действие Пост N1       (мВт)"+CrLf)
FWrite(Desc,"9.2 Остальных                            (мВт)"+CrLf)
FWrite(Desc,"9.3 Аварийная бронь ограничен.потребит.  (мВт)"+CrLf)
FWrite(Desc,"        ОТКЛЮЧЕНО НЕПЛАТЕЛЬЩИКОВ"+CrLf)
FWrite(Desc,"10 Количество всего, в точ числе          (шт)"+CrLf)
FWrite(Desc,"10.1 Попадающих под действие Пост N1      (шт)"+CrLf)
FWrite(Desc,"10.2 Остальных                            (шт)"+CrLf)
FWrite(Desc,"11 Долг всего, в т.ч.                 (тыс.руб)"+CrLf)
FWrite(Desc,"11.1 Попадающих под действие Пост N1  (тыс.руб)"+CrLf)
FWrite(Desc,"11.2 Остальных                        (тыс.руб)"+CrLf)
FWrite(Desc,"12   Отключен.мощн.всего в т.ч.           (мВт)"+CrLf)
FWrite(Desc,"12.1 Плпадающих под действие Пост N1      (мВт)"+CrLf)
FWrite(Desc,"12.2 Остальных                            (мВт)"+CrLf)
FWrite(Desc,"12.3 Отключенная аварийная бронь          (мВт)"+replicate(CrLf,5))
FWrite(Desc,"13 Кол-во потребит. частного сектора       (шт)"+CrLf)
FWrite(Desc,"13.1 Их месячное потребление          (тыс.руб)"+CrLf)
FWrite(Desc,"13.2 Их долг                          (тыс.руб)"+CrLf)
FWrite(Desc,"13.3 Отключено за неуплату                 (шт)"+replicate(CrLf,3))
FWrite(Desc,"_________________ Подпись исполнителя"+Replicate(CrLf,2))
FWrite(Desc,"_________________ Подпись ответственного должностного лица"+CrLf)
Fclose(Desc)
Select(Sel);   Go Rec
Win_Rest(Win); SetCOlor(Clr)
Return Nil



Function YearEnergy()
Local Sel:=Select(),Rec:=RecNo(),Clr:=SetCOlor(),Scr:=Win_Save(),Count:=0
Local Desc:=Fcreate(DDir+ReportFile),CrLf:=Chr(13)+Chr(10),KolKl:=0
Select Main
Go Top
Do While !Eof()
   Count++
   Skip
EndDo
Obrabot("Расчет годового потребления")
Go Top
FWrite(Desc,"|")
For i=1 to 12
    FWrite(Desc,Center(Mesqc(i),12," ",.t.)+"|")
Next
FWrite(Desc,CrLf)
Do While !Eof()
   KolKl=KolKl+39/Count
   colorwin(12,21,12,21+KolKl,'n/n')
   FWrite(Desc," "+Str(Main->Lic_Schet,4,0)+" "+DelString(Main->Potrebitel,"ИНН")+CrLf+"|")
   For i=1 to 12
       FWrite(Desc,Str(GetRashod(Main->Lic_Schet,i),12,0)+"|")
   Next
   FWrite(Desc,CrLf+"|")
   For i=1 to 12
       FWrite(Desc,Str(GetSum(Main->Lic_Schet,i),12,2)+"|")
   Next
   FWrite(Desc,CrLf)
   Skip
EndDo
Fclose(Desc)
Select(Sel)
Go Rec
SetColor(Clr)
Win_Rest(Scr)
Return NIL




Function Blank
LOCAL show,spisok,is_ch,stri,cho,Sel,rec,ordbuf,buff:=Win_Save(),colorbuf
PRIVATE nm1,nm2,nm3,nm4,t1,l1,b1,r1,inp,Title:={"",""}
Sel:=Select(); Rec=Recno()
Ordbuf=Indexord()
Colorbuf=Setcolor()
IF Urov<1
   IF (.Not. File(schet_share+'Blank.Dbf')) .or.;
      (.Not. File(schet_share+'Blank.Dbt'))
           sign(2)
           select(sel); go rec
           RETURN Nil
   ELSE
      Select 101
      IF Empty(FieldName(1))
         Wosst=.T.
         Al_Box({"База данных не определена"})
         select(sel); go rec
         RETURN Nil
      ENDIF
   ENDIF
ENDIF
Colorwin(8,16,23,67,"n+/n")
Set Color To N/W
//@ 7,43  Say Center('Список готовых бланков',40," ",.t.)
go top
declare zgl[2]
declare fil[2]
nm1=loarr('zgl','Название бланка',"Копии")
nm2=loarr('fil','BlankName',"Copy")
inp='0'; t1=7; l1=15; b1=22; r1=65
*********
//message("F1 - Редактирование заголовка; F2 - редактирования окончания",2,15)
//message("Ctrl+Enter - Вставка текущего фрагмента в отчет",5,15)
FsBrowse(7,44,22,77,'fil','zgl',inp,urov,kl)
PREV_REC:=-1
RET_VAL:=2
Select(Sel)
Set Order To Ordbuf
Go Rec
Set Color To (Colorbuf)
Win_Rest(buff)
Return NIL






Function AllBlankToOtchet()
Local Desc,I,Sel:=Select(),Rec:=RecNo(),FoundBlank:=.F.,LastDate
Local Scr:=Win_Save(),cText:=""
Local oDlg,aSizeDeskTop,aPos,oProgress
//LastDate:=CTOD("01.01.1900")
Clear Typeahead
Select Main
Go Top

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
Do While .not.EOF()
        oProgress:increment()                                                                                                                                                           // Progress Bar Increment
                Select Blank
//              MessageBox({"Запись информации о выдаче бланка"})
                Desc:=FCreate(DDir+"Tmp.Rpt")
                For i=1 To Copy
                    FWrite(Desc,BlankText+Chr(13)+Chr(10))
                Next
                FClose(Desc)
                Select OutBlank
                IF FoundBlankOut()
                IF RecLock()
                      Replace Date With New_date
                Replace User With Station
                UNLOCK
                ENDIF
                ELSE
                IF NetAppend()
                      Replace Licevoj With Main->Lic_Schet
                Replace BlankName With Blank->BlankName
                Replace Date With New_date
                Replace User With Station
                UNLOCK
                ENDIF
                ENDIF
                Report(DDir+"Tmp.Rpt",DDir+ReportFile)
                cText:=cText+MemoRead(DDir+ReportFile)+Chr(13)+Chr(10)

                Select(Sel)
                Go Rec
//              Win_Rest(Scr)

                Select Main
                Skip
ENDDO
Desc:=FCreate(DDir+ReportFile)
FWrite(Desc,cText)
FClose(Desc)
oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
oDlg:Destroy()
Select(Sel)
Go Rec
Win_Rest(Scr)
//IF RecLock()
//   Replace Date With New_date
//   Unlock
//ENDIF
Ret_Val:=2
Return NIL








Function BlankToOtchet()
Local Desc,I,Sel:=Select(),Rec:=RecNo(),FoundBlank:=.F.,LastDate
Local Scr:=Win_Save()
//LastDate:=CTOD("01.01.1900")
MessageBox({"Запись информации о выдаче бланка"})
Desc:=FCreate(DDir+"Tmp.Rpt")
For i=1 To Copy
    FWrite(Desc,BlankText+Chr(13)+Chr(10))
Next
FClose(Desc)
Select OutBlank
IF FoundBlankOut()
   IF RecLock()
      Replace Date With New_date
      Replace User With Station
      UNLOCK
   ENDIF
ELSE
   IF NetAppend()
      Replace Licevoj With Main->Lic_Schet
      Replace BlankName With Blank->BlankName
      Replace Date With New_date
      Replace User With Station
      UNLOCK
   ENDIF
ENDIF
Select(Sel)
Go Rec
Win_Rest(Scr)
//IF RecLock()
//   Replace Date With New_date
//   Unlock
//ENDIF
Report(DDir+"Tmp.Rpt",DDir+ReportFile)
Ret_Val:=2
Return NIL





Function FoundBlankOut
Local Sel:=Select(),Rec:=RecNo(),FoundBlank:=.F.
Select OutBlank
Go Top
Seek Main->Lic_Schet
Do While Licevoj==Main->Lic_Schet
   IF Blank->BlankName==BlankName
      FoundBlank=.t.
      EXIT
   ENDIF
   Skip
ENDDO
Select(Sel)
Go Rec
Return FoundBlank



Function CalckYearRashod()
Local Sel:=Select(),Rec:=RecNo(),I:=0,MinRashod:=0,MaxRashod:=0,Clr:=SetColor()
Local StartMonth:=1,EndMonth:=12,Desc,LicRashod:=0,CrLf:=Chr(13)+Chr(10)
Local Temp_:=0,Kol_Kl:=0,Scr:=Win_Save()
Set Color to &GetColor
ColorWin(14,19,17,58,"n+/n")
@ 13,18 SAY "┌──────────────────────────────────────╖"
@ 14,18 SAY "│ Минимальный  расход            кВт   ║"
@ 15,18 SAY "│ Максимальный расход            кВт   ║"
@ 16,18 SAY "╘══════════════════════════════════════╝"
@ 14,40 Get MinRashod
@ 15,40 Get MaxRashod
Read
SetColor(Clr)
IF LastKey()#27
   Clear Typeahead
   StartMonth:=Month_Menu("начала периода")
   IF StartMonth>0.and.StartMonth<=12
      EndMonth:=Month_Menu("окончания периода")
      IF EndMonth>=StartMonth.and.EndMonth<=12
         Desc:=FCreate(dDir+ReportFile)
         FWrite(Desc,"  Выбор потребителей с расходом "+AllTrim(Str(MinRashod))+"-"+;
         AllTrim(Str(MaxRashod))+"кВт  за "+Mesqc(StartMonth)+"-"+Mesqc(EndMonth)+CrLf)
         Select Main
         Go Top
         temp_=39/reccount()
         kol_kl=0
         Obrabot("выбор потребителей")
         Do WHile !eof()
            kol_kl=kol_kl+temp_
            colorwin(12,21,12,21+kol_kl,'n/n')
            LicRashod:=0
            For I=StartMonth To EndMonth
                LicRashod:=LicRashod+GetRashod(Main->Lic_Schet,I)
            Next
            IF LicRashod>=MinRashod
               IF LicRashod<=MaxRashod
                  FWrite(Desc,Str(Main->Lic_Schet,8,0)+" "+;
                  Substr(DelString(Main->Potrebitel,"ИНН")+Space(45),1,45)+" "+Str(LicRashod,10,0)+CrLf)
               ENDIF
            ENDIF
            Skip
         EndDO
         Fclose(Desc)
      EndIf
   ENDIF
ENDIF
Clear Typeahead
Win_Rest(Scr)
Select(Sel)
Go Rec
Return NIL





Function RashByTarif()
Local Sel:=Select(),Rec:=RecNo(),Scr:=Win_Save(),Clr:=SetColor(),Desc,CrLf:=Chr(13)+Chr(10),Itog:=0
Local oDlg,aSizeDeskTop,aPos,oProgress,cStr:="",Poisk:="",aTarif[4][6],lFound:=.F.,IsBudget:=.F.
Local aBudget:={14,13,26,198,237,280,332,508,1036,1120,1332,1847,37,132,419,432,1237,531,144,788,1103,124,679,153,29,182,750,1000,568,840,77,35,211,60,215,695,1170,1709,100,2386,;
             27,258,951,442,1693,441,401,1417,1247,2246,;
             74,2118,2006,497,2710,46,117,201,364,1175,1184,1200,1215,1412,1413,1414,1226,;
             1617,1669,1751,1773,1774,1780,1781,1784,1785,1786,1787,1790,1793,1798,1799,1801,1802,;
             1803,1804,1806,1807,1808,1809,1810,1811,1820,1821,1824,1830,1841,1843,1789,1796,1226,2002,;
             1418,270,1410,1411,1415,1416,258,564}
Local EMonth:=Month_Menu("выбора расходов")
IF EMonth>=1.and.eMonth<13
	 cStr:=     "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"+CrLf
	 cStr:=cStr+"|Договор |            Потребитель                                 |Заявленная|При присоединении|Наименование|К шинам|Уровень| Всего за |Наим.сетевой| Прочие |Бюджетные|Население|"+CrLf
	 cStr:=cStr+"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"+CrLf
   oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
   aSizeDesktop  := oMainWindow:currentSize()
   oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
   oDlg:title    := "Обработано"
   oDlg:SysMenu  := .F.
   oDlg:Configure()
   oDlg:Show()
   aSizeDesktop  := oDlg:currentSize()
   aPos          := oDlg:CurrentPos()
   oProgress     := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

   oProgress:create()
   oProgress:minimum := 1
   oProgress:maximum := RecCount()
   Go Top
   Do While !EOF()
      oProgress:increment()               // Progress Bar Increment
      For i=1 to 4
      		aTarif[i]={0,0,0,0,0,0,0,0,0,0}
      Next
      aTarif[1][1]:="ВН "
      aTarif[2][1]:="СН1"
      aTarif[3][1]:="СН2"
      aTarif[4][1]:="НН "
      IsBudget:=.F.
      For i=1 to Len(aBudget)
      		IF Main->Lic_Schet==aBudget[i]
      				IsBudget=.T.
      				Exit
      		ENDIF
      Next
      Select Licevoj
      Seek Main->Lic_Schet
      Do While Lic_sch==Main->Lic_schet	
      	 poisk='('+alltrim(str(Main->lic_schet))+')'+alltrim(licevoj->schetchik)
      	 
      	 aTarif[1][6]=aTarif[1][6]+(Licevoj->Silowaq+Licevoj->Oswesh) // Мощность
      	 
      	 Select(EMonth)
      	 Seek Poisk
      	 IF Found().and.Rashod>0.and.Summa>0
      	 		I=4
      	 	  Do Case
      	 	  	 Case Tarif=1.16
      	 	  	 			i=1
      	 	  	 Case Tarif=1.26
      	 	  	 			i=2
      	 	  	 Case Tarif=1.35.or.Tarif=1.60.or.Tarif=1.47
      	 	  	 			i=3
      	 	  EndCase
      	 		    	 aTarif[i][2]=aTarif[i][2]+Rashod		// Всего расход по тарифу
      	 		    	 DO Case
      	 		    	 		Case IsBudget==.T.
      	 		    	 					aTarif[i][4]=aTarif[i][4]+Rashod		// Бюджет
      	 		    	 		Case Tarif==1.356.or.Tarif==1.627.or.Tarif==1.314.or.Tarif==1
      	 		    	 					aTarif[i][5]=aTarif[i][5]+Rashod   // Население
      	 		    	 		Otherwise
      	 		    	 					aTarif[i][3]=aTarif[i][3]+Rashod		// Прочие потребители
      	 		    	 ENDCASE
      	 ENDIF
      	 select Licevoj
         Skip
      EndDo
      Itog=0
    	For i=1 to 4
//    	 		"|Договор |            Потребитель                                 |Заявленная|При присоединении|Наименование|К шинам|Уровень| Всего за                                                        |Наим.сетевой| Прочие |Бюджетные|Население|"
      		cStr:=cStr+"|"+Str(Main->Lic_Schet,8,0)+"|"+Substr(AllTrim(Main->Potrebitel)+Space(56),1,56)+"|          |                 |            |       |  "+aTarif[i][1]+"  |"+Str(aTarif[i][2],10,0)+'|ОАО "НЭСК"  |'+Str(aTarif[i][3],8,0)+"|"+Str(aTarif[i][4],9,0)+"|"+Str(aTarif[i][5],9,0)+"|"+CrLf
      		Itog=Itog+aTarif[i][2]
      Next
   		cStr:=cStr+"|"+Str(Main->Lic_Schet,8,0)+"|"+Substr('ОАО "НЭСК"  ИТОГО:'+Space(56),1,56)+"|"+Str(aTarif[1][6],10,0)+"|"+Str(aTarif[1][6],17,0)+"|            |       |       |"+Str(Itog,10,0)+"|            |        |         |         |"+CrLf
      Select Main
      SKIP
   ENDDO
	 cStr:=cStr+"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"+CrLf
   Desc:=FCreate(dDir+ReportFile)
   FWrite(Desc,cStr)
   FClose(Desc)
   
   oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
   oDlg:Destroy()
ENDIF
Select(Sel); Go Rec
Win_Rest(Scr); SetColor(Clr)

Return NIL
