proc trpor
private string1,string2,string3,is_high,string4
param is_high
set device to print
set print on
set printer to otchet.gkv
select 77
seek main->lic_schet
for i=1 to 2
setprc(0,0)
string1=''
string2=''
string3=''
string4="л/сч. N"+alltrim(str(main->lic_schet))+if(is_6#kolich,' тариф '+;
         alltrim(str(int(M->schet_1new))),' тариф '+alltrim(str(int(schet_tar1))))
if konec
        vsego=round(rashnds-(rashnds*(schet_nds+schet_dnal)/(100+schet_nds+schet_dnal)),0)
        nds=round(vsego*schet_nds/100,0)
        nalog3=rashnds-vsego-nds
endif
************************************ Дата планового платежа
brtr='c 15.'+alltrim(str(if(day(new_date+1)>20,month(new_date+1),month(new_date+1)-1)))+;
     ' по 01.'+alltrim(str(if(day(new_date+1)>20,month(new_date+1)+1,month(new_date+1))))
************************************ Клею строки для платежки

string1=if(konec,mesqc(mo_nth)+" с 15."+alltrim(str(if(mo_nth-1>=1,mo_nth-1,12)))+' по '+;
substr(alltrim(dtoc(new_date)),1,5),brtr)

if is_6#kolich
         string2='Общий пл.'+alltrim(str(rashnds))+' в т.ч. НДС '+;
         +alltrim(str(round((rashnds)*schet_nds/(100+schet_nds+schet_dnal),0)))+;
         ' CH '+alltrim(str(round((rashnds)*schet_dnal/;
         (100+schet_nds+schet_dnal),0)))

         string3='Окон.плат.'+alltrim(str(rashnds-plan_plateg))+" в т.ч.НДС "+;
         +alltrim(str(round((rashnds-plan_plateg)*schet_nds/(100+schet_nds+schet_dnal),0)))+;
        ' СН '+alltrim(str(round((rashnds-plan_plateg)*schet_dnal/(100+schet_nds+schet_dnal),0)))
else
                vsego=beznds+sum_rashod+nalog3+nds_-_kredit
         string2='Общий пл.'+if(konec,alltrim(str(vsego,12,2)),alltrim(str(beznds+;
                sum_rashod,12,2)))+" руб.  без НДС и СН"+' тариф 36.0'
         string3='Окон.плат.'+if(konec,alltrim(str(vsego,12,2)),alltrim(str(beznds+;
                sum_rashod,12,2)))+" руб.  без НДС и СН"+' тариф 36.0'
endif



@ 00,00 SAY center(schet_osnov,70,.t.,' ')+chr(13)+chr(10)+'Приложение N 1'
@ 01,00 SAY "Посттуп. в банк плат.   ПЛАТЕЖНОЕ ТРЕБОВАНИЕ-ПОРУЧЕНИЕ N"+alltrim(str(schet_treb))   && +kniga+"          0401040"
@ 02,24 SAY alltrim(str(day(new_date+1)))+"  "+mesqc(month(new_date+1),1)+'  '+alltrim(str(year(new_date+1)))+"г."+"             ДЕБЕТ        СУММА"
@ 03,00 SAY "Плательщик"+space(40)+"+--------------+-------------"
*if .not.konec
*       @ 04,00 SAY main->potrebitel+"| "+k_schet+"  |"+str(beznds+rashnds+nalog3,13,2)
*else
*       @ 04,00 SAY main->potrebitel+"| "+k_schet+"  |"+str(rashnds)
*endif
        if .not.konec
*               rashnds=round(sum_rashod+nds_+nalog3,0)
*               @ 04,00 SAY main->potrebitel+"| "+k_schet+"  |"+str(int(beznds+rashnds+nalog3),13,2)
                @ 04,00 SAY main->potrebitel+"| "+k_schet+"  |"+str(int(beznds+sum_rashod+nalog3+nds_-_kredit),13,2)
        else
                @ 04,00 SAY main->potrebitel+"| "+k_schet+"  |"+str(round(rashnds,0),13,2)
        endif
@ 05,33 SAY "+-----------+    | "+r_schet+"  |"
@ 06,00 SAY "Код"+space(30)+"|"+mfo+"|cч N|--------------+"
@ 07,00 SAY "Банк плательщика                 +-----------+----+    КРЕДИТ    |"
@ 08,00 SAY bank+" +--------------+-------------"
@ 09,46 SAY "cч N| 000508019    |"
@ 10,00 SAY "Получатель М.П. Анапское ПГЭС      +-------+------+--------------+-------------"
@ 11,00 SAY "Код"+space(28)+"Код | 141044| сч. N| 700161593    |"
@ 12,00 SAY "Банк получателя   Югбанк г.Анапа   +-------+------+--------------+-------------"
@ 13,00 SAY "+----------+-----------------------------------------------------|"
@ 14,00 SAY "|          |назн.платежа,наим.товара,вып.работ,оказан.услуг,     |Сумма к опл."
@ 15,00 SAY "|   М.П.   |N и дата договора. "+main->dogowor+" от "+dtoc(main->data_dog)+"             +--------------"
@ 16,00 SAY "|          |подписи получателя.                         ДЕБЕТ    |Пеня за   дн."
@ 17,00 SAY "+----------+-----------------------------------------------------+из       %P"
@ 18,00 SAY "(сумма к оплате прописью) По показаниям эл.счетчиков  сч. N      |Сумма с пеней"
@ 19,00 SAY "и утв.тарифам за эл.энергию за "+string1+space(24-len(string1))+"КРЕДИТ    |Вид опер   02"
@ 20,00 SAY ""+string2+space(50-len(string2))+"сч. N          |Назн.плат. 139"
@ 21,00 SAY ""+string3+space(50-len(string3))+"сч. N          |Срок плат."
@ 22,00 SAY string4+space(49-len(string4))+"Проведено банком|Очер.плат."
@ 23,00 SAY "+------------+"+space(35)+"__________19___г|N гр.банка"
@ 24,00 SAY "|            |"+space(51)+"+--------------"
@ 25,00 say "|    М.П.    | "
@ 26,00 say "|            |"
@ 27,00 say "+------------+"+if(i=1,replicate(chr(13)+chr(10),7),chr(13)+chr(10)+chr(12))
next
eject
set printer to
set print off
set device to screen
select 88
return
