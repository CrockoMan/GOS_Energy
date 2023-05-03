proc nastrojka
private old_col
old_col=setcolor()
screen=win_save()
set color to +w/bg
@ 02,00,22,79 box "         "
@ 02,01 say "┌────────────────────────"+space(27)+"─────────────────────────╖"
@ 03,01 say "│                                                                            ║"
@ 04,01 say "│НДС        :       %                  С.Налог        %                      ║"
@ 05,01 say "│Пеня       :       %                                                        ║"
@ 06,01 say "│Диск резервной копии       (жесткий)     Путь                               ║"
@ 07,01 say "│Диск резервной копии       (гибкий)      Temp                               ║"
@ 08,01 say "│                                                                            ║"
//@ 08,01 say "├──────────────────"+space(39)+"───────────────────╢"
@ 09,01 say "│Получатель :                                                                ║"
@ 10,01 say "│Банк       :                                                                ║"
@ 11,01 say "│Основание  :                                                                ║"
@ 12,01 say "│                                                                            ║"
@ 12,02 say if(schet_vplan=.t.,chr(16)+' В платежке окончательного платежа будет включена сумма планового платежа '+chr(17),'')
colorwin(12,2,12,77,'n/bg')
colorwin(12,2,12,2,'n*/bg')
colorwin(12,77,12,77,'n*/bg')
@ 13,01 say "│                                                                            ║"
@ 14,01 say "│ Директор   :                          Бухгалтер:                           ║"
@ 15,01 say "│ Название 1 :                                 "+space(30)+"║"
@ 16,01 say "│ Название 2 :                                 "+space(30)+"║"
@ 17,01 say "│ Название 3 :                                 "+space(30)+"║"
@ 18,01 say "│ Банк       :                                 "+space(30)+"║"
@ 19,01 say "│ Расч.счет  :                                 "+space(30)+"║"
@ 20,01 say "│ Корр.счет  :                                                               ║"
@ 21,01 say "│ Город      :                                                               ║"
@ 22,01 say "╘════════════════════════════════════════════════════════════════════════════╝"
set color to r+*/bg
@ 22,03 say chr(16)+' Esc - Выход '+chr(17)
set color to +gr/bg
@ 02,27 say "Настройка на пользователя"
set color to +bg/bg
@ 03,25 say "Заполнение взимаемых налогов"
//@ 08,21 say "Заполнение шапки для плат. требования"
@ 13,25 say "Заполнение шапки для счета"
NameBoss:=NameBoss+Space(25-Len(NameBoss))
NameBuh:=NameBuh  +Space(25-Len(NameBuh))
schet_osnov:=schet_osnov+Space(60-Len(schet_osnov))	
SchetNameOrg:=SchetNameOrg+Space(35-Len(SchetNameOrg))
SCHETINN=SchetInn+Space(10-Len(SchetInn))
SCHETKPP=SchetKpp+Space(10-Len(SchetKpp))
SCHETADR:=SchetAdr+Space(60-Len(SchetAdr))
	
set conf on
set curs on
set color to +w/bg,gr+/b,,,+w/bg
schet_sdisk=schet_sdisk+space(29-len(schet_sdisk))
schet_tdisk=schet_tdisk+space(29-len(schet_tdisk))
cNameBoss=Substr(cNameBoss+Space(17),1,17)
cNameBuh=Substr(cNameBuh+Space(17),1,17)
do while .t.
        @ 04,02 say "НДС                 :" get schet_nds picture '99.99'
        @ 04,49 get schet_dnal picture '99.99'
        @ 05,02 say "Пеня                :" get schet_penq picture '99.999'
        @ 06,02 say "Диск резервной копии " get schet_disk picture 'A:' valid predv1()
        @ 06,48 get schet_sdisk picture "@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        @ 07,02 say "Диск резервной копии " get schet_Adisk picture 'A:' valid predv2()
        @ 07,48 get schet_tdisk picture "@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
				@ 08,02 Say "Организация :" get SchetNameOrg Picture"@KS57"
        @ 09,02 say "Получатель  :" get schet_poluch picture '@k XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 10,02 say "Банк        :" get schet_bank1 picture '@k XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 11,02 say "Основание   :" get schet_osnov picture '@kS60'
				@ 13,02 Say "Адрес :" get SchetAdr Picture "@KS65"
        @ 14,16 Get NameBoss
        @ 14,52 Get NameBuh
        @ 15,03 say "Название 1 :" get schet_naz1 picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 16,03 say "Название 2 :" get schet_naz2 picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 17,03 say "Название 3 :" get schet_naz3 picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 18,03 say "Банк       :" get schet_ban2 picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 19,03 say "Расч.счет  :" get schet_rsch picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 20,03 say "Корр.счет  :" get schet_ksch picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 21,03 say "Город      :" get schet_town picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 15,52 Say "ИНН: " Get SchetInn
        @ 16,52 Say "КПП: " Get SchetKpp
        @ 17,52 Say "Р/c: " Get SchetRS
        @ 18,52 Say "K/c: " Get SchetKS
        @ 19,52 Say "БИК: " Get SchetBIK
        @ 20,52 Say "Подпись1" Get cNameBoss  Picture "@KS15"
        @ 21,52 Say "Подпись2" Get cNameBuh   Picture "@KS15"
        read
        if lastkey()=27
           Clear Typeahead
/*              if yes_or_not("      Включать в окончательный платеж     ",;
                              "      сумму планового платежа ?           ")
                        schet_vplan=.t.
                else
                        schet_vplan=.f.
                endif */
                if al_box({"      Включать в окончательный платеж     ",;
                           "      сумму планового платежа ?           "},;
                              2,,if(schet_vplan,1,2))=1
                        schet_vplan=.t.
                else
                        schet_vplan=.f.
                endif
                exit
        endif
enddo
NameBoss:=AllTrim(NameBoss)
NameBuh:=AllTrim(NameBuh)
schet_poluch=schet_poluch+space(50-len(schet_poluch))
schet_bank1=schet_bank1+space(50-len(schet_bank1))
schet_osnov=schet_osnov+space(63-len(schet_osnov))
schet_naz1=schet_naz1+space(32-len(schet_naz1))
schet_naz2=schet_naz2+space(32-len(schet_naz2))
schet_naz3=schet_naz3+space(32-len(schet_naz3))
schet_ban2=schet_ban2+space(32-len(schet_ban2))
schet_rsch=schet_rsch+space(32-len(schet_rsch))
schet_ksch=schet_ksch+space(32-len(schet_ksch))
schet_town=schet_town+space(32-len(schet_town))
schet_disk=MYupper(schet_disk)
schet_Adisk=MYupper(schet_Adisk)
            schet_sdisk=schet_sdisk+space(29-len(schet_sdisk))
            schet_tdisk=schet_tdisk+space(29-len(schet_tdisk))
schet_sdisk=alltrim(MYupper(schet_sdisk))
schet_tdisk=alltrim(MYupper(schet_tdisk))
set conf off
set curs off
* set path to &schet_sdisk
* set default to &schet_sdisk
setcolor(old_col)
win_rest(screen)
return



func predv2
private ret_val,old_scr
ret_val=.t.
if updated()
        if disktype(MYupper(schet_Adisk))=0
                Myerror(" Вставьте диск в дисковод "+MYupper(schet_Adisk)+' !')
                ret_val=.f.
        else
                if disktype(MYupper(schet_Adisk))#240.and.disktype(MYupper(schet_Adisk))#249
                        Myerror(" Данное устройство для копий использовать нельзя !")
                        ret_val=.f.
                endif
        endif
endif
return ret_val



func predv1
private ret_val,old_scr
ret_val=.t.
if updated()
        save screen to old_scr
        message('   Ждите,  идет  проверка  указанного  накопителя   ')
        set cursor off
//        if disktype(upper(substr(schet_disk,1,1)))#248
//                error(' Разрешен только жесткий диск (винчестер) !!! ')
//                ret_val=.f.
//        else
                if diskfree(schet_disk)<2500000
                        al_box({'Емкости диска '+schet_disk+' может быть недостаточно'})
                endif
                if dirchange(schet_disk+'\REZERV.DBF')#0
                        if dirmake(schet_disk+'\rezerv.dbf')=0
                                al_box({'Ошибка Создания директории для резервной копии баз данных'})
                        else
                                al_box({'Создана директория для резервной копии баз данных'})
                        endif
                endif
                dirchange(substr(Ddir,1,len(Ddir)-10))
//        endif
        set cursor on
        restore screen from old_scr
endif
return ret_val



Function MakeVal()
LOCAL Scr:=Win_Save(),Clr:=SetColor()
Set Color To &GetColor()
ColorWin(5,9,20,74,"n+/n")
@ 04,08 SAY "┌────────────────────────────────────────────────────────────────╖"
@ 05,08 SAY "│Абонированная мощность:           Коэфф. для повышенной         ║"
@ 06,08 SAY "│Максимальный расход               Коэфф.план.в окончат.         ║"
@ 07,08 SAY "│Тариф за превышение               Коэф.планового платежа        ║"
@ 08,08 SAY "│───────────<Изменение данных влияет на методику расчетов>───────║"
@ 09,08 SAY "│Количество десятичных знаков  "+space(34)+"║"
@ 10,08 SAY "│────────────────────────────────────────────────────────────────║"
@ 11,08 SAY "│Имя станции                     "+space(32)+"║"
@ 12,08 SAY "│"+space(64)+"║"
@ 13,08 SAY "│Имя файла отчета           "+space(37)+"║"
@ 14,08 SAY "│"+space(64)+"║"
@ 15,08 SAY "│Высота строки                                                   ║"
@ 16,08 SAY "│Высота символа                                                  ║"
@ 17,08 SAY "│Ширина символа                                                  ║"
@ 18,08 SAY "│Имя шрифта принтера                                             ║"
@ 19,08 SAY "╘════════════════════════════════════════════════════════════════╝"
MaxRashSum:=Round(MaxRashSum,Decimal)
Station:=Station+Space(20-Len(Station))
NetPrint:=NetPrint+Space(10-Len(NetPrint))
ReportFile:=ReportFile+Space(12-Len(ReportFile))
PrFontName:=PrFontName+Space(30-Len(PrFontName))
Set Cursor On
Set Confirm On
@ 06,29 Get MaxRashod Picture "@K"
@ 07,29 Get MaxRashSum Picture "@K9999999.99"
@ 05,66 Get HighKoeff Picture "99.9"
@ 06,66 Get MyPlanKoeff Picture "99.9"
@ 07,66 Get FiftyDays  Picture "99.99"
@ 09,38 Get Decimal Picture "@K"
@ 11,21 Get Station Picture "@K"
@ 13,26 Get ReportFile Picture "@K"
@ 15,30 Get PrStrHigh  Picture "99"
@ 16,30 Get PrCharHigh    Picture "99"
@ 17,30 Get PrCharWidth   Picture "99"
@ 18,30 Get PrFontName   Picture "@K"
Read
Set Confirm Off
Set Cursor Off
Clear Typeahead
PrFontName:=AllTrim(PrFontName)
Station:=Alltrim(Station)
NetPrint:=Alltrim(NetPrint)
ReportFile:=Alltrim(ReportFile)
WriteCfg(DDir+"Config.arm")
SetColor(Clr); Win_Rest(Scr)
Return NIL
