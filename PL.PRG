proc GosPlategka(start_param)
Local cColor:=SetColor()
Private returngos:=.f.
*****************************************************************************
strochka1="             На основан. постанов.правит.РФ N 558 от 7.08.1992г.                "
s2trochka="Без акцепта. На основан. постанов.правит.РФ N 558 от 7.08.1992г.                "
*****************************************************************************
eg=0
snumtr=space(8)
sdata='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'г.'
splatelshik=space(44)
sschpl1="         "
sbankplat=space(28)
s_bank_=space(43)
ssumma=000000000.00
sschpl2='         '
smfopl='         '
spoluchatel=' УМП "Горэлектросеть"             '
sschpol1='000508019'
sbankpol=' Югбанк г.Анапа             '
smfopol='141044   '
sschpol2='090161300'
sdogowor=space(59)
sstr1='По показан.эл.сч.и утв.тарифам за эл.    '
sstr2='энергию за '+mesqc(month(new_date+1))+space(73-len("энергию за "+mesqc(month(new_date+1))))
sstr3=space(66)
sstr4=space(52)
*****************************************************************************
adata='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'г.'
amfo1='141044   '
amfo2='         '
apredopl='          '
aplatelshik='УМП "Горэлектросеть"                        '
akod_plpor=space(45)
anumber=00000
abankplat=' КомЮгбанк г.Анапа       '
apoluchatel=space(42)
abankpoluch=space(25)
a_bankpoluch=space(34)
astr1=space(65)
astr2=space(65)
astr3=space(65)
astr4=space(65)
akschet1='000508019'
arschet1='090161300'
arschet2='          '
akschet2='          '
asumma=00000000.00
asumprop=space(50)
asumpro=space(50)
awoper='01'
anaznpl='139'
*****************************************************************************
platelshik=space(43)
data='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'г.'
schet11='         '
summa=000000000.00
mfo1='         '
schet12='         '
bank1=space(23)
bank1_=space(55)
poluchatel=' УПМ "Горэлектросеть"'+space(24)
schet21='000508019'
bank2=" Югбанк г.Анапа "+space(6)
mfo2='141044   '
schet22='090161300'
dogowor=space(39)
number='       '
sum1=' По показаниям эл.счетчиков '
sum2="и утв.тарифам за эл.энергию за "+mesqc(month(new_date+1))+' '+alltrim(str(year(new_date+1)))+'г.'
sum2=sum2+space(66-len(sum2))
str1=space(54)
str2=space(48)
str3=space(48)
*****************************************************************************
if file ("memory.plt")
        restore from memory.plt additive
endif
sdata='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'г.'
adata='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'г.'
data='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'г.'
sum1=' По показаниям эл.счетчиков '
sum2="и утв.тарифам за эл.энергию за "+mesqc(month(new_date+1))+' '+alltrim(str(year(new_date+1)))+'г.'
sum2=sum2+space(66-len(sum2))
sstr1='По показан.эл.сч.и утв.тарифам за эл.    '
sstr2='энергию за '+mesqc(month(new_date+1))+space(73-len("энергию за "+;
mesqc(month(new_date+1))+" "+alltrim(str(year(new_date+1)))+'г.'))
sstr3=space(66)
start_param=if(start_param==NIL,'',start_param)
/*
filedelete('install.*',63)
if start_param=chr(107)+chr(111)+chr(115)+chr(38)+chr(105)+chr(110)+chr(115)+chr(116)+chr(97)+chr(108)+chr(108)
        protect(1)
else
        if .not.protect(2)
                sayrandom("Копия программы незаконна. Для приобретения программы звоните 2-50-88 в Анапе",maxrow()-1,0,'w+/n')
                ? ""
                return
        endif
endif
*/

wopen(0,0,24,79)
do ekran
treb_menu:={    {" Заполнить          ",{||gruzit()}    },;
                {" Отпечатать         ",{||print1()}    }  }
trpr_menu:={    {" Заполнить          ",{||zapolnit()}  },;
                {" Отпечатать         ",{||printfil()}  }  }
poru_menu:={    {" Заполнить          ",{||z_apolnit()} },;
                {" Отпечатать         ",{||print_pl()}  }  }
main_menu:={    {" Платежное требование ",treb_menu },;
                {" Требование-Поручение ",trpr_menu },;
                {" Поручение ",           poru_menu },;
                {" Выход ",{||exitdos()}            }      }
keyboard chr(13)
Myexit:=3
spos:=1
do while Myexit=3
        do_menu(main_menu,.T.,spos)
        spos=4
        deletefile("temp.$@#")
        Myexit:=Al_Box({"Вы хотите сохранить последние платежки",;
                      "при выходе из программы ?"},3,{"Сохранить",;
                      "Не сохранять","Не выходить"})
        DO Case
                case Myexit=1
                        main_menu:={}
                        poru_menu:={}
                        trpr_menu:={}
                        treb_menu:={}
                        save to memory.plt
                        close all
                        wclose()
                        returngos=.t.
        //              quit
                case Myexit=2
                        main_menu:={}
                        poru_menu:={}
                        trpr_menu:={}
                        treb_menu:={}
                        close all
                        wclose()
                        returngos=.t.
        //              quit
        ENDCase
enddo
SetColor(cColor)
wclose()
return


function exitdos
keyboard chr(27)
return NIL

proc ekran
set color to w/b
clear
@ 00,00 SAY replicate("█",79)
@ 24,00 SAY replicate("█",79)
@ 24,70 SAY " Платежка "
colorwin(24,70,24,79,'r/w')
set color to n/w+
@ 24,69 say chr(179)
@ 00,58 say chr(179)
@ 00,69 say chr(179)
SET COLOR TO  n/W
colorwin(0,0,0,11,'w+/n')
return

**************************************************************************
function zapolnit
local old_scr,stat_color
stat_color=setcolor()
save screen to old_scr
SET COLOR TO +W/B,w+/bg+,n/w,n/w,+w/b
clear
@ 00,00 SAY strochka1
@ 01,66 SAY "Приложение N1"
@ 02,00 SAY "Поступ. в банк плат.  ПЛАТЕЖНОЕ ТРЕБОВАНИЕ-ПОРУЧЕНИЕ N "+number+"      0401040"
@ 03,25 SAY data+"             ДЕБЕТ     СУММА"
@ 04,00 SAY "Плательщик "+platelshik+"+-----------+-------------"
@ 05,40 SAY "+--------+    | "+schet11+" |"+str(summa,12,2)
@ 06,00 SAY "Код"+space(34)+"| "+mfo1+" |сч N| "+schet12+" |"
@ 07,00 SAY "Банк плательщика "+bank1+"+--------+----+-----------+"
@ 08,00 SAY bank1_+"  КРЕДИТ   |"
@ 09,00 SAY "Получатель"+poluchatel+"+-----------+-------------"
@ 10,50 SAY "сч N| "+schet21+" |"
@ 11,00 SAY "Код"+space(37)+"+--------+----+-----------+-------------"
@ 12,00 SAY "Банк получателя"+bank2+"| "+mfo2+" |сч N| "+schet22+" |"
@ 13,40 SAY "+--------+----+-----------+-------------"
@ 14,00 SAY "+-------+---------------------------------------------------------|"
@ 15,00 SAY "|       |назн.платежа,наим.товара,вып.работ,оказан.услуг,         |"
@ 16,00 SAY "| М.П.  |N и дата договора."+dogowor+"|Сумма к опл."
@ 17,00 SAY "|       |подписи получателя."+space(28)+"ДЕБЕТ     |-------------"
@ 18,00 SAY "+-------+---------------------------------------------------------+"
@ 19,00 SAY "(сумма к оплате прописью)"+space(31)+"сч N      |"
@ 20,00 SAY "                                                                  |"
@ 21,00 SAY str1+" КРЕДИТ     |"
@ 22,00 SAY str2+" сч N             |пеня за  дн."
@ 23,00 SAY str3+" сч N             |из      %P"
@ 24,00 SAY "                                                Проведено банком  |сумма с пеней"
set curs on
set conf on
do while .t.
        @ 00,00 get strochka1 picture "@K"
        @ 02,55 get number picture "@K"
        @ 03,25 get data picture "@K"
        @ 04,10 get platelshik picture "@K"
        @ 05,56 get schet11 picture "@K"
        @ 05,67 get summa picture "@K"
        @ 06,40 get mfo1 picture "@K"
        @ 06,56 get schet12 picture "@K"
        @ 07,17 get bank1 picture "@K"
        @ 08,00 get bank1_ picture "@K"
        @ 09,10 get poluchatel picture "@K"
        @ 10,56 get schet21 picture "@K"
        @ 12,15 get bank2 picture "@K"
        @ 12,40 get mfo2 picture "@K"
        @ 12,56 get schet22 picture "@K"
        @ 16,27 get dogowor picture "@K"
        @ 19,25 get sum1  picture "@K"
        @ 20,00 get sum2 picture "@K"
        @ 21,00 get str1 picture "@K"
        @ 22,00 get str2 picture "@K"
        @ 23,00 get str3 picture "@K"
        read
        if lastkey()=27
                exit
        endif
enddo
set curs off
set conf off
restore screen from old_scr
setcolor(stat_color)
return NIL


func printfil
private old_col,old_scr,temp_,kol_kl
old_col=setcolor()
old_scr=savescreen(0,0,24,79)
desc=fcreate('temp.$@#',0)
obrabot("Конвертирую в ASCII...")
temp_=39/66
kol_kl=0
kol_kl=kol_kl+temp_
colorwin(12,21,12,21+kol_kl,'n/n')
if desc#-1
        for i=1 to 2
                fwrite(desc,strochka1+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"Приложение N1"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"Поступ. в банк плат.  ПЛАТЕЖНОЕ ТРЕБОВАНИЕ-ПОРУЧЕНИЕ N"+number+"      0401040"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,space(26)+data+"             ДЕБЕТ     СУММА"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"Плательщик "+platelshik+"+-----------+-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,space(40)+"+--------+    | "+schet11+" |"+str(summa,14,2)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"Код"+space(34)+"| "+mfo1+" |сч N| "+schet12+" |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"Банк плательщика "+bank1+"+--------+----+-----------+"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,bank1_+"  КРЕДИТ   |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"Получатель"+poluchatel+"+-----------+-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,space(50)+"сч N| "+schet21+" |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"Код"+space(37)+"+--------+----+-----------+-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"Банк получателя"+bank2+"| "+mfo2+" |сч N| "+schet22+" |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,space(40)+"+--------+----+-----------+-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"+-------+---------------------------------------------------------|"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"|       |назн.платежа,наим.товара,вып.работ,оказан.услуг,         |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"| М.П.  |N и дата договора."+dogowor+"|Сумма к опл."+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"|       |подписи получателя."+space(28)+"ДЕБЕТ     |-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"+-------+---------------------------------------------------------+"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"(сумма к оплате прописью)"+sum1+"сч N      |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,sum2+"|"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,str1+" КРЕДИТ     |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,str2+" сч N             |пеня за  дн."+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,str3+" сч N             |из      %P"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"                                                Проведено банком  |сумма с пеней"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," +---------+                                    ____________19__г.|Вид опер.  02"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," |         |                                                      |Назн.пл. 139"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," |   М.П.  |   Подписи плательщика           Подписи банка        |Срок "+dtoc(new_date+1)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," |         |                                                      |Очер.плат. 06"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," +---------+                                                      |Nгр.банка"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"                                                                  +---------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if i=1
                                fwrite(desc,replicate(chr(13)+chr(10),2))
                                kol_kl=kol_kl+temp_
                                colorwin(12,21,12,21+kol_kl,'n/n')
                endif
        next
        colorwin(12,21,12,60,'n/n')
        fclose(desc)
        if printer()                                 &&   Печатаем     ====>
                copy_('temp.$@#','prn')
        endif
else
        fclose(desc)
        Myerror("    Ошибка записи данных на диск.   ",;
              "    Возможно диск полон ?           ",;
              "          Нажмите любую клавишу...  ")
endif
setcolor(old_col)
restscreen(0,0,24,79,old_scr)
return NIL

**************************************************************************
func z_apolnit
private old_col,old_scr
old_col=setcolor()
old_scr=savescreen(0,0,24,79)
SET COLOR TO +W/B,w+/bg+,n/w,n/w,+w/b
@ 00,00 SAY "┌──────────────────────────────────────────────────────────────────────────────║"
@ 01,00 SAY "│ П Л А Т Е Ж Н О Е   П О Р У Ч Е Н И Е   N                                    ║"
@ 02,00 SAY "│ Плательщик                                              ДЕБЕТ         Сумма  ║"
@ 03,00 SAY "│ Код                                               ┌──────────────┬───────────║"
@ 04,00 SAY "│ Банк плательщика                          ┌───────┤сч.N          │           ║"
@ 05,00 SAY "│ ──────────────────────────────────────────┤       │              │           ║"
@ 06,00 SAY "│ Получатель                                │ Код   │    КРЕДИТ    │           ║"
@ 07,00 SAY "│                                           └───────┼──────────────┼────────── ║"
@ 08,00 SAY "│ Код                                       ┌───────┤              │           ║"
@ 09,00 SAY "│ Банк получателя                           │       │сч.N          │           ║"
@ 10,00 SAY "│ ──────────────────────────────────────────┤ Код   ├──────────────┼────────── ║"
@ 11,00 SAY "│   почтой-телеграфом(нужное подчеркнуть)   └───────┤сч.N          │           ║"
@ 12,00 SAY "│                                                   └──────────────┼────────── ║"
@ 13,00 SAY "│ Сумма прописью                                                   │Пеня за    ║"
@ 14,00 SAY "│                                                                  │           ║"
@ 15,00 SAY "│ ─────────────────────────────────────────────────────────────────┤ из    %P  ║"
@ 16,00 SAY "│ Дата получения товара,оказания услуг              19  г.         │Сумма с пен║"
@ 17,00 SAY "│ ─────────────────────────────────────────────────────────────────┤Вид  │     ║"
@ 18,00 SAY "│ Назначение платежа,наименованние товара,выполн.работ,            │опер │_____║"
@ 19,00 SAY "│ оказанных услуг,NN и суммы товарн. документов.                   │Назн │     ║"
@ 20,00 SAY "│                                                                  │плат │_____║"
@ 21,00 SAY "│                                                                  │Срок │     ║"
@ 22,00 SAY "│                                                                  │плат │     ║"
@ 23,00 SAY "│                                                                  │Оер. │     ║"
@ 24,00 SAY "│                                                                  │плат.│     ║"
@ 24,00 SAY "╘══════════════════════════════════════════════════════════════════════════════╝"
set conf on
set curs on
do while .t.
@ 01,45 get anumber picture "@K"
@ 01,60 get adata picture "@K"
@ 02,13 get aplatelshik picture "@K"
@ 03,07 get akod_plpor picture "@K"
@ 04,18 get abankplat picture "@K"
@ 05,44 get amfo1 picture "@K"
@ 04,57 get arschet1 picture "@K"
@ 05,57 get akschet1 picture "@K"
@ 04,68 get asumma picture '999999999.99'
@ 07,02 get apoluchatel valid MyPredv1()
@ 08,09 get a_bankpoluch picture "@K"
@ 09,18 get abankpoluch picture "@K"
@ 09,44 get amfo2 picture "@K"
@ 09,57 get arschet2 picture "@K"
@ 11,57 get akschet2 picture "@K"
@ 13,16 get asumprop picture "@K"
@ 14,16 get asumpro picture "@K"
@ 16,40 get apredopl picture "@K"
@ 17,75 get awoper picture "@K"
@ 19,75 get anaznpl picture "@K"
@ 20,01 get astr1 picture "@K"
@ 21,01 get astr2 picture "@K"
@ 22,01 get astr3 picture "@K"
@ 23,01 get astr4 picture "@K"
read
        if lastkey()=27
                exit
        endif
enddo
set conf off
set curs off
setcolor(old_col)
restscreen(0,0,24,79,old_scr)
return NIL


func MyPredv1
        mpsum2=""
        asumprop=str_chislo(asumma,50)
        asumprop=asumprop+space(50-len(asumprop))
        asumpro=mpsum2+space(50-len(mpsum2))
return .t.




function print_pl
private old_col,old_scr,temp_,kol_kl
old_col=setcolor()
old_scr=savescreen(0,0,24,79)
desc=fcreate('temp.$@#',0)
obrabot("Конвертирую в ASCII...")
temp_=39/60
kol_kl=0
kol_kl=kol_kl+temp_
colorwin(12,21,12,21+kol_kl,'n/n')
if desc#-1
        for i=1 to 2
                fwrite(desc,"Поступл.в банк плат.                                                  0401002"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"                  ПЛАТЕЖНОЕ  ПОРУЧЕНИЕ   N "+alltrim(str(anumber))+chr(13)+chr(10)+'                  '+alltrim(adata)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," Плательщик "+aplatelshik+" ДЕБЕТ         Сумма  "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," Код "+akod_plpor+"  +--------------+-----------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," Банк плательщика "+abankplat+"+-------|сч.N "+arschet1+"|"+str(asumma,14,2)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ------------------------------------------|"+amfo1+"    "+akschet1+"|           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," Получатель                                | Код   |    КРЕДИТ    |           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+apoluchatel+"+-------|--------------|---------- "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," Код    "+a_bankpoluch+" +-------|              |           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," Банк получателя "+abankpoluch+" |"+amfo2+"   "+arschet2+"|           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ------------------------------------------| Код   |--------------|---------- "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"   почтой-телеграфом(нужное подчеркнуть)   +-------|сч.N"+akschet2+"|           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"                                                   +--------------|---------- "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," Сумма прописью "+asumprop+"|Пеня за    "+chr(13)+chr(10)+space(16)+asumpro+'| дней'+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," -----------------------------------------------------------------| из    %P  "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," Дата получения товара,оказания услуг "+apredopl+"     19  г.       |Сумма с пен"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," -----------------------------------------------------------------|Вид  |"+awoper+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," Назначение платежа,наименованние товара,выполн.работ,            |опер |_____"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," оказанных услуг,NN и суммы товарн. документов.                   |Назн |"+anaznpl+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+astr1+"|плат |_____"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+astr2+"|Срок |"+dtoc(new_date+1)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+astr3+"|плат |"+dtoc(new_date+1)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+astr4+"|Очер.| 06"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  ______________                                                  |плат.|_____"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  |            |                                                  |N гр.|     "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  |   М.П.     |     Подписи клиента                              |Банка|_____"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  |            |                            Проведено банком          19  г.  "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  --------------                            Подписи банка"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if i=1
                                fwrite(desc,""+replicate(chr(13)+chr(10),2)+chr(13)+chr(10))
                                kol_kl=kol_kl+temp_
                                colorwin(12,21,12,21+kol_kl,'n/n')
                endif
        next
        colorwin(12,21,12,60,'n/n')
        fclose(desc)
        if printer()                                 &&   Печатаем     ====>
                copy_('temp.$@#','prn')
        endif
else
        fclose(desc)
        Myerror("    Ошибка записи данных на диск.   ",;
              "    Возможно диск полон ?           ",;
              "          Нажмите любую клавишу...  ")
endif
setcolor(old_col)
restscreen(0,0,24,79,old_scr)
return NIL







function gruzit
old_col=setcolor()
save screen to old_scr
set color to w+/b,w+/bg+,n/w,n/w,w+/b
clear
@ 00,00 SAY s2trochka
@ 01,00 SAY "Поступ. в банк плат.        ПЛАТЕЖНОЕ ТРЕБОВАНИЕ N  "+number+"       0401001"
@ 02,00 SAY "                                                         ДЕБЕТ     СУММА"
@ 03,00 SAY "Плательщик"+splatelshik+"+-----------+-------------"
@ 04,54 SAY "| "+sschpl1+" |"+str(ssumma,12,2)
@ 05,00 SAY "Код"+space(41)+"+---------| "+sschpl2+" |"
@ 06,00 SAY "Банк плательщика"+space(28)+"|"+smfopl+"+-----------+"
@ 07,44 SAY "| Код     |  КРЕДИТ   |"
@ 08,00 SAY "Получатель"+spoluchatel+"+---------+-----------+-------------"
@ 09,54 SAY "| "+sschpol1+" |"
@ 10,00 SAY "Код                                         +---------+сч N       |"
@ 11,00 SAY "Банк получателя "+sbankpol+"|"+smfopol+"+-----------+-------------"
@ 12,44 SAY "| Код     | "+sschpol2+" |"
@ 13,00 SAY "Код             Грузоотправитель и ст.отпр. +---------|сч N       +-------------"
@ 14,00 SAY "Код             Грузоотправитель и ст.назн.           +-----------|Пеня за дн."
@ 15,00 SAY "Договор"+sdogowor+"|из    %Р"
@ 16,00 SAY "Заказ N       19  г."+space(46)+"|-------------"
@ 17,00 SAY "Дата отгр.    19  г.          Способ отпр. кв/накл. N             |Вид опер 02"
@ 18,00 SAY "------------------------------------------------------------------|Назн плат.139"
@ 19,00 SAY "Наимен.товара, в. работ, оказ.услуг,NN и суммы товарн.документов  |Срок пл."+dtoc(new_date+1)
@ 20,00 SAY "или спецификация товаров."+sstr1+"|Очер.плат.06"
@ 21,00 SAY ""+sstr2+"|N гр.банка"
@ 22,00 SAY ""+sstr3+"+-------------"
@ 23,00 say "  +---------+                                                    Проведено банком"
@ 24,00 say "  |         |----------------------------------------------------       19   г."
set conf on
set curs on
do while .t.
        @ 00,00 get s2trochka picture "@K"
        @ 01,52 get number picture '@K'
        @ 02,31 get sdata picture "@K"
        @ 03,10 get splatelshik picture"@K"
        @ 04,56 get sschpl1 picture "@K"
        @ 04,67 get ssumma picture "@K"
        @ 05,56 get sschpl2 picture "@K"
        @ 06,16 get sbankplat picture "@K"
        @ 07,00 get s_bank_ picture "@K"
        @ 06,46 get smfopl  picture "@K"
        @ 08,10 get spoluchatel picture "@K"
        @ 09,56 get sschpol1 picture "@K"
        @ 11,16 get sbankpol picture "@K"
        @ 11,46 get smfopol picture "@K"
        @ 12,56 get sschpol2 picture "@K"
        @ 15,07 get sdogowor picture "@K"
        @ 20,25 get sstr1 picture "@K"
        @ 21,00 get sstr2 picture "@K"
        @ 22,00 get sstr3 picture "@K"
        @ 23,13 get sstr4 picture "@K"
        read
        if lastkey()=27
                exit
        endif
enddo
set conf off
set curs off
setcolor(old_col)
restore screen from old_scr
return NIL






function print1
save screen
old_col=setcolor()
desc=fcreate("temp.$@#")
obrabot("Конвертирую в ASCII...")
temp_=39/56
kol_kl=0
kol_kl=kol_kl+temp_
colorwin(12,21,12,21+kol_kl,'n/n')
if desc#-1
&&        fwrite(desc,''+replicate(chr(13)+chr(10),4))
        for i=1 to 2
        fwrite(desc,s2trochka+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Поступ. в банк плат.        ПЛАТЕЖНОЕ ТРЕБОВАНИЕ N "+number+"         0401001"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"                         "+sdata+"             ДЕБЕТ     СУММА"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Плательщик"+splatelshik+"+-----------+-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,space(54)+"| "+sschpl1+" |"+str(ssumma,14,2)+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Код"+space(41)+"+---------| "+sschpl2+" |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Банк плательщика"+sbankplat+"|"+smfopl+"+-----------+"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,s_bank_+" | Код     |  КРЕДИТ   |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Получатель"+spoluchatel+"+---------+-----------+-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,space(54)+"| "+sschpol1+" |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Код                                         +---------+сч N       |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Банк получателя"+sbankpol+" |"+smfopol+"+-----------+-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,space(44)+"| Код     | "+sschpol2+" |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Код             Грузоотправитель и ст.отпр. +---------|сч N       +-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Код             Грузоотправитель и ст.назн.           +-----------|Пеня за дн."+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Договор"+sdogowor+"|из    %Р"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Заказ N       19  г."+space(46)+"|-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Дата отгр.    19  г.          Способ отпр. кв/накл. N             |Вид опер 02"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"------------------------------------------------------------------|Назн плат.139"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"Наимен.товара, в. работ, оказ.услуг,NN и суммы товарн.документов  |Срок пл."+dtoc(new_date+1)+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"или спецификация товаров."+sstr1+"|Очер.пл.06"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,""+sstr2+"|N гр.банка"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,""+sstr3+"+-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  +---------+"+sstr4+"Проведено банком"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  |         |----------------------------------------------------       19   г."+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  |  М.П.   |Предусмотренные договором документы|               |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  |         |отосланы (вручены) плательщику     |Подписи клиента| Подписи банка" +chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  +---------+"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        if i=1
                        fwrite(desc,""+replicate(chr(13)+chr(10),2)+chr(13)+chr(10))
                        kol_kl=kol_kl+temp_
                        colorwin(12,21,12,21+kol_kl,'n/n')
        endif
        next
        fclose(desc)
        if printer()                                 &&   Печатаем     ====>
                copy_('temp.$@#','prn')
        endif
else
        fclose(desc)
        Myerror("    Ошибка записи данных на диск.   ",;
              "    Возможно диск полон ?           ",;
              "          Нажмите любую клавишу...  ")
endif
fclose(desc)
restore screen
setcolor(old_col)
deletefile('temp.$@#')
return NIL
