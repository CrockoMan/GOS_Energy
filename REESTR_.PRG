proc p_reestr
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_ed,temp1
//Private IsEdit:=.T.
rec_buf=recno()
ord_buf=indexord()
buff=win_save(6,0,maxrow()-1,maxcol())
color_buf=setcolor()
old_sel=select()
if urov<1
        if (.not. file(Ddir+'reestr.dbf'))
                sign(2)
                set color to (color_buf)
                win_rest(buff)
                return
        else
                select reestr
//                if select()#66
//                        select 66
//                endif
endif
******************************************************************************
        temp1=substr(dtoc(new_date+1),1,2)+' '+mesqc(month(new_date+1),1)+' '+;
                alltrim(str(year(new_date+1)))+' года'
**********************  Вычисление текущей даты  *****************************
        itogo=0
        postawshik=SchetNameOrg
        bank='Анапский филиал ОАО АКБ "УРАЛСИБ-ЮГ БАНК" г.Анапа'
        ot=temp1+space(35-len(temp1))
        s_=temp1+space(35-len(temp1))
        schet="40602810300000000005 "
        old_ed=edit
        edit=.t.
endif
do while .t.
        set color to n/w
        declare zgl[6]
        declare fil[6]
        inp='00'
        nm1=loarr('zgl',"Вид оп.",'N докум',"Дата",'    Сумма    ',"       БИК","    Счет пательщика")
        nm2=loarr('fil',"VidOp",'plat_treb',"Data",'summa',"Bik","Schet")
        go top
        t1=7
        l1=1
        b1=23
        r1=78
        fsbrowse(7,1,23,78,'fil','zgl',inp,urov,Edit)
//      fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
        set color to
        if Al_Box({'При выходе данные потеряются !',;
                      'Закончить работу по подготовке',;
                      'текущего реестра ?'},2)==1
                     exit
        endif
enddo
tobank()
select 66
zap
if file(Ddir+"reestr.txt")
        deletefile(Ddir+'reestr.txt')
endif
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
win_rest(buff)
edit=old_ed
keyboard chr(87)
return
*********************************





proc reestr
Local IsCentury:=CSetCent()
old_col=setcolor()
save screen
Set Century Off
if Al_Box({'Вы действительно хотите сгенерировать реестр'},2)==1
        rec=recno()
        go top
        count=0
        do while !eof()
                if !deleted()
                        count=count+1
                endif
                skip
        enddo
        obrabot()
        temp_=40/count
        kol_kl=0
        go top
        mpsum2=''
        desc=fcreate(Ddir+'reestr.txt')
        if desc=-1
                Myerror('  Невозможно создать файл отчета, возможно диск полон !!!  ')
                fclose(desc)
                restore screen
                setcolor(old_col)
                return
        endif
        mpsum1=str_chislo(itogo)
        Perem:=chr(27)+chr(77)+"                                                                           --------"+chr(13)+chr(10)
        perem:=Perem+"                                         РЕЕСТР                            |0401014|"+chr(13)+chr(10)
        Perem:=Perem+"                  ПЕРЕДАННЫХ НА ИНКАССО РАСЧЕТНЫХ ДОКУМЕНТОВ               --------"+chr(13)+chr(10)
        Perem:=Perem+"                            N "+AllTrim(Schet_Reestr)+" от "+AllTrim(Ot)+chr(13)+chr(10)
        perem:=Perem+"Поставщик (взыскатель) "+postawshik+chr(13)+chr(10)
        fwrite(desc,perem)
        perem="Обслуживающий банк "+alltrim(bank)+chr(13)+chr(10)
        fwrite(desc,perem)
        perem="Представляем на инкассо платежные документы в количестве "+str(count,3,0)+" на сумму "+alltrim(str(itogo,14,2))+chr(13)+chr(10)
        fwrite(desc,perem)
        perem="Сумма прописью "+AllTrim(MpSum1)+chr(13)+chr(10)+AllTrim(MpSum2)+chr(13)+chr(10)
        FWrite(Desc,Perem)
        FWrite(Desc,"------------------------------------------------------------------------------------------"+chr(13)+chr(10))
        FWrite(Desc,"|  N |Вид оп| N и  дата документа |Сумма докум.|        БИК         |       Счет         |"+chr(13)+chr(10))
        FWrite(Desc,"------------------------------------------------------------------------------------------"+chr(13)+chr(10))
        count=0
        perem=''
        do while .not.eof()
           Count++
           FWrite(Desc,"|"+STR(Count,4,0)+"| "+VidOp+"|"+Plat_Treb+" "+Dtoc(Data)+"|"+Str(Summa,12,2)+"|"+BIK+"|"+Schet+"|"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                skip
        enddo
        fwrite(desc,"                                      Подписи                             Отметки банка"+chr(13)+chr(10))
        fwrite(desc,"                                      ________________________"+chr(13)+chr(10))
        fwrite(desc,"           М.П."+chr(13)+chr(10))
        fwrite(desc,"                                      ________________________"+chr(13)+chr(10)+chr(27)+chr(80))
        colorwin(12,21,12,21+40,'n/n')
        fclose(desc)
else
        restore screen
        setcolor(old_col)
        return
endif
go rec
set color to r+/n
AL_Box({'Подготовка реестра закончена'})
restore screen
setcolor(old_col)
Set Century On
return



proc print
if Al_Box({'Вы  действительно  хотите','отпечатать подготовленный реестр'},2)==1
   if file(Ddir+'reestr.txt')
      Print_Fi(.F.,Ddir+'reestr.txt')
//                   copy_(Ddir+'reestr.txt','prn')
   else
      Al_Box({'Реестр не обнаружен'})
   endif
endif
Clear Typeahead
return


proc nastroYka
Local TypeBank,OScr
save screen
if .not.file(Ddir+"reestr.txt")
   schet_reestr=substr(alltrim(str(int(val(schet_reestr)+1)))+space(29),1,29)
endif
old_color=setcolor()
set color to &GetColor
colorwin(0,0,9,45,'b/n')
@ 00,00,08,44 box "         "
@ 00,01 say "╔═════════════════════════════════════════╗"
@ 01,01 say "║ Реестр  N"+space(31)+"║"
@ 02,01 say "║ Поставщик                               ║"
@ 03,01 say "║ Банк поставщика                         ║"
@ 04,01 say "║ От"+space(38)+"║"
@ 05,01 say "║ По товарам,отпущенным, начиная с        ║"
@ 06,01 say "║"+space(41)+"║"
@ 07,01 say "║ N счета поставщика                      ║"
@ 08,01 say "╚═════════════════════════════════════════╝"
@ 01,13 say schet_reestr
@ 02,13 say Alltrim(postawshik)
@ 03,19 say substr(bank,1,22)
@ 04,06 say ot
@ 06,03 say s_
@ 07,22 say schet

//TypeBank:=al_box({"Ваберите банк для формирования реестра"},2,{" Югбанк "," ОСБ 1804 "," Крайинвестбанк "})

spisok:={" ЮгБанк                  ",;
         " ОСБ",;
         " Крайинвест",;
         " Петрокоммерц     "}
is_choice:={.t.,.t.,.t.,.t.}
OScr:=Win_SAve()
TypeBank=vert_menu(spisok,"Выберите банк",is_choice,9,28,1,'n/w,n/g,,,r/w',.F.)
Win_Rest(OScr)
DO Case
   Case TypeBank=2
        M->bank="ОСБ 1804 г.Анапа      "
        M->schet="40702810630040100367 "
   CASE TypeBank=3
        M->bank='ОАО "Крайинвестбанк" г.Краснодар'
        M->schet="40702810400070000029 "
   CASE TypeBank=4
        M->bank='ФКБ "ПЕТРОКОММЕРЦ" в г.Новороссийске г.Новороссийск'
        M->schet="40702810400120100263 "
   OTHERWISE
        M->bank='Анапский филиал ОАО АКБ "УРАЛСИБ-ЮГ БАНК" г.Анапа '
        M->schet="40602810300000000005 "
ENDCASE


set cursor on
set confirm on
set color to &GetColor
do while lastkey()#27
   @ 01,13 get schet_reestr picture('@K NNNNNNNNNNNNNNNNNNNNNNNNNNNN')
   @ 02,13 get postawshik picture('@K XXXXXXXXXXXXXXXXXXXXXXXXXXXX')
   @ 03,19 get M->bank picture ("@S22")
   @ 04,06 get ot picture('@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
   @ 06,03 get s_ picture('@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
   @ 07,22 get M->schet picture('@K XXXXXXXXXXXXXXXXXXXXX')
   read
enddo
Clear Typeahead
set confirm off
set cursor off
setcolor(old_color)
restore screen
return



/* Функции работы с базой данных регистрации платежек TOBANK */

// Поиск платежки из TOBANK по ее номеру и дополнение недостающих реквизитов
function tobank()
LOCAL select:=select(),screen:=obrabot("Запись отправленных платежек")
LOCAL temp_:=39/reccount(),kol_kl:=0
go top
do while !eof()
        colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
        select tobank
        seek val(alltrim(reestr->plat_treb))
        if !found()
           if netappend()
//               replace tobank->plat_treb with val(alltrim(reestr->plat_treb))
               replace plat_treb with val(alltrim(reestr->plat_treb))
               unlock
           endif
        ELSE
          if reclock()
//             replace tobank->summa with reestr->summa
//             replace tobank->reestr with space(10-len(substr(alltrim(schet_reestr),;
//                                     1,10)))+substr(alltrim(schet_reestr),1,10)
             replace summa with reestr->summa
             replace reestr with space(10-len(substr(alltrim(schet_reestr),;
                                     1,10)))+substr(alltrim(schet_reestr),1,10)
             unlock
          endif
        endif
        select(select)
        skip
enddo
select(select)
win_rest(screen)
return NIL

/****************************************************************************/
/*         Запись сгенерированной платежки в базу данных                    */
/****************************************************************************/
function writetobank(licevojschet,writestring)
LOCAL select:=select(),recno:=recno()
licevojschet:=if(licevojschet==NIL,main->lic_schet,licevojschet)
writestring:=if(writestring==NIL,'',writestring)
select tobank
if netappend()
   replace lic_schet with licevojschet
   replace tip with writestring
   replace plat_treb with M->schet_treb
   replace data with new_date+1
   unlock
else
     al_box({"Платежка не  зарегистрирована  в  отправленных",;
             "Вы отказались ожидать освобождения базы данных"})
endif
select(select)
go recno
return NIL


FUNCTION MenuToBank()
LOCAL screen:=win_save(18,40,22,72)
colorwin(19,41,22,72,'n+/n')
@ 18,40,21,71 BOX "┌─╖║╝═╘│ "
do while .t.
        @ 19,41 prompt " Отчет по потребителю         "
        @ 20,41 prompt " Удаление вспомогательных     "
        menu to menutobank
        do case
                case menutobank=1
                        OtchetToBank()
                case menutobank=2
                        if al_box({"Вы действительно хотите удалить платежки,",;
                                   "которые небыли отправлены в банк?"},2,;
                                  {" Удалить "," Не удалять "},,,,,,,;
                                  "gr+/r+,w/b+,,,gr/r+")=1
                                DeleteToBank()
                        endif
                otherwise
                        exit
        endcase
enddo
win_rest(screen)
RETURN NIL



FUNCTION DeleteToBank()
LOCAL select:=select(),recno:=recno(),temp_,kol_kl,total:=0
LOCAL screen:=obrabot("Удаление неотправленных платежек")
select tobank
go top
temp_:=39/reccount()
kol_kl:=0
DO WHILE .not.eof()
        colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
        if empty(tobank->reestr).and.empty(tobank->summa)
           if reclock()
                DELETE=.T.
                delete
                total++
                unlock
           endif
        endif
        skip
ENDDO
go recno()
al_box({"Всего удалено  неотправленных платежек - "+alltrim(str(total))+"шт."},,,,,,,,,"gr+/r+,w/b+,,,gr/r+")
win_rest(screen)
select(select)
go recno
RETURN NIL


FUNCTION OtchetToBank()
LOCAL select:=select(),recno:=recno(),temp_,kol_kl,total:=0,desc
LOCAL screen:=win_save(20,50,23,76),startdate:=new_date,enddate:=new_date
LOCAL cCrLf:=chr(13)+chr(10),color:=setcolor(),allsumma:=0
startdate:=EndDate-10
colorwin(21,51,23,76,'n+/n'); setcolor("n/w,n/g,,,n/w")
@ 20,50,22,75 BOX "┌─╖║╝═╘│ "
set curs on; set conf on
@ 21,51 say " с" get startdate
@ 21,63 say "по" get enddate
read
set curs off; set conf off
setcolor(color); win_rest(screen)
IF Lastkey()!=27
        select tobank;  go top
        temp_:=39/reccount();   kol_kl:=0
        screen:=obrabot("Отправленные платежки c "+dtoc(startdate)+'по '+dtoc(enddate))
        desc:=fcreate(Ddir+'otchet.gkv')
        fwrite(desc,"   Платежки, отправленные в банк в период с "+alltrim(dtoc(startdate))+;
        ' по '+alltrim(dtoc(enddate))+cCrLf)
        fwrite(desc,center("Потребитель : "+alltrim(main->potrebitel),70,' ')+cCrLf)
        fwrite(desc,"----------------------------------------------------------------------"+cCrLf)
        fwrite(desc,"  NN   |    Cумма     |   Дата   |  Реестр N  |    Тип платежа        "+cCrLf)
        fwrite(desc,"-------|--------------|----------|------------|-----------------------"+cCrLf)
        DO WHILE .not.eof()
                colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                if tobank->data>=startdate.and.tobank->data<=enddate.and.;
                   tobank->lic_schet=main->lic_schet
                        fwrite(desc,str(Plat_Treb,6,0)+" | "+str(summa,12,2)+;
                        " | "+dtoc(data)+" | "+reestr+" | "+tip+cCrLf)
                        total++
                        AllSumma:=AllSumma+Summa
                endif
                skip
        ENDDO
        fwrite(desc,"----------------------------------------------------------------------"+cCrLf)
        fclose(desc);   win_rest(screen)
        if total=0
                deletefile(Ddir+'otchet.gkv')
        endif
        select(select);         go recno
        al_box({"Всего отправленo платежек c "+dtoc(startdate)+" по "+;
                dtoc(enddate)+" - "+alltrim(str(total))+"шт.","На общую сумму "+Alltrim(Str(AllSumma))+" рублей"})
ENDIF
RETURN NIL