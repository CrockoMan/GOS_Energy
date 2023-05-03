*_9_ps()

function _9_ps
LOCAL MemStr:="",CrLf:=chr(13)+chr(10),WsegoPotr:=0,TmpStr:="",nLen:=0
LOCAL TmpInd:=Ddir+"Pstmpl.ntx",spisok1:={},is_choice:={},desc2,byte,Clr:=SetColor()
private ret_val,old_col,old_scr,old_scr1,_9ps,kv,kniga1,kniga2,kniga3,kniga4,;
        kniga5,old_col,old_scr,prev_rec,prev_sel,month
devout("")
old_col=setcolor()
old_scr=win_save()
set color to w+/b
spisok1:={" 9-ПС за один месяц       ",;
          " 9-ПС за один квартал     ",;
          " 9-ПС за весь год         ",;
          " 9-ПС считать по...       ",;
          "──────────────────────────",;
          " Выход                   "}
is_choice1:={.t.,.t.,.t.,.t.,.F.,.t.}
do while .t.
        ret_val=.t.
        _9ps=vert_menu(spisok1," Выберите работу по 9-ПС ",is_choice1,15,30,1,'n/w,n/g,,,r/w',.F.)
        do case
                case _9ps=1
                        prev_sel=select()
                        prev_rec=recno()
                        month=month_menu()
                        if month=0
                                ret_val=.f.
                        else
                                if _9ps#0
                                        save screen to prev_scr
//                                        close all
                                        do case
                                                case month=1
                                                        database='jan.dbf'
                                                        cMonth:='JAN'
                                                case month=2
                                                        database='feb.dbf'
                                                        cMonth:='FEB'
                                                case month=3
                                                        database='mar.dbf'
                                                        cMonth:='MAC'
                                                case month=4
                                                        database='apr.dbf'
                                                        cMonth:='APR'
                                                case month=5
                                                        database='may.dbf'
                                                        cMonth:='MAY'
                                                case month=6
                                                        database='jun.dbf'
                                                        cMonth:='JUN'
                                                case month=7
                                                        database='jul.dbf'
                                                        cMonth:='JUL'
                                                case month=8
                                                        database='aug.dbf'
                                                        cMonth:='AUG'
                                                case month=9
                                                        database='sep.dbf'
                                                        cMonth:='SEP'
                                                case month=10
                                                        database='oct.dbf'
                                                        cMonth:='OCT'
                                                case month=11
                                                        database='nov.dbf'
                                                        cMonth:='nov'
                                                case month=12
                                                        database='dec.dbf'
                                                        cMonth:='dec'
                                        endcase
                                        lic_ntx:=DDir+'lic.ntx'
                                        make_ind('0',schet_share+database,TmpInd,'licevoj')
                                        make_ind('0',schet_share+'limit.dbf',schet_share+"index9ps.ntx",'lic_schet')
                                        make_ind('0',schet_share+"main.dbf",Lic_Ntx,'lic_schet')
*************************************************
//                                        close all
//                                        select 0
                                        if !netuse(schet_share+"otrasl.dbf",,0,"otrasl")
//                                           close all
                                           loadgos()
                                           select(prev_sel)
                                           go prev_rec
                                           restore screen from prev_scr
                                           return NIL
                                        endif
                                        go top
                                        select 0
                                        if !netuse(schet_share+"main.dbf",,0,"main_base")
//                                           close all
                                           loadgos()
                                           select(prev_sel)
                                           go prev_rec
                                           restore screen from prev_scr
                                           return NIL
                                        endif
                                        set index to &lic_ntx
                                        select 0
                                        if !netuse(schet_share+"limit.dbf",,0,"limit_base")
//                                           close all
                                           loadgos()
                                           select(prev_sel)
                                           go prev_rec
                                           restore screen from prev_scr
                                           return NIL
                                        endif
                                        set index to (schet_share+"index9ps.ntx")
                                        select 0
                                        if !netuse(schet_share+database,,0,"second_base")
//                                           close all
                                           loadgos()
                                           select(prev_sel)
                                           go prev_rec
                                           restore screen from prev_scr
                                           return NIL
                                        endif
                                        set index to &TmpInd
                                        select otrasl
                                        go top
desc=fcreate(Ddir+'otchet.gkv')
fwrite(desc,' Кому высылается                              Hовороссийское отд.Энергонадзор'+chr(13)+chr(10))
fwrite(desc,'                                              ул.Сакко и Ванцетти,2'+chr(13)+chr(10)+chr(13)+chr(10))
fwrite(desc,center('С Т А Т И С Т И Ч Е С К А Я   О Т Ч Е Т H О С Т Ь',79,' ',.t.)+chr(13)+chr(10))
fwrite(desc,center('О Т Ч Е Т',79,' ')+chr(13)+chr(10))
fwrite(desc,center('энергосбыта о выполнении плана отпуска эл.энергии',79,' ')+chr(13)+chr(10))
fwrite(desc,center('за '+rangerepl('Н','Н',mesqc(month),'H')+' '+alltrim(str(year(New_date)))+'г. по Анапскому ПГЭС',79,' ')+CrLf+CrLf)
fwrite(desc,space(80)+CrLf)
obrabot('Формирование отчета "9-ПС"')
temp=0
kol_kl=39/reccount()
wsego_po_otrasli=0
wsego_po_planu=0
if desc#0
        do while !eof()  && Работа с базой кодов отраслей промышленности
                temp=temp+kol_kl
                colorwin(12,21,12,21+temp,'n/n')
                if wsego_po_otrasli>0
                        fwrite(desc,chr(13)+chr(10))
                endif
                TmpStr:=substr(alltrim(rangerepl('Н','Н',otrasl->otrasl,'H')),1,50)
                TmpStr:=TmpStr+space(50-len(TmpStr))
                fwrite(desc,TmpStr)
                wsego_po_otrasli=0
                wsego_po_planu=0
                wsego_plan=0
                plan_9ps:="??????"
                found_predp=.F.
                @ 2,0 say otrasl->otrasl
                select main_base
                go top
                MemStr:=""
                desc2:=fcreate(Ddir+"TmpTxt.swp")
                fwrite(desc2,space(54)+"План      Факт   Разница"+CrLf)
                @ 5,0 say "Использовано памяти: "+alltrim(str(len(MemStr)))+" байт    "+space(45)
                do while !eof()    &&  Работа с базой MAIN.DBF на совпадение отрасли
                        if Main_base->Lic_Schet<99999.and.otrasl->kod_otr==main_base->kod_otr
                                 @ 3,0 say DelString(main_base->potrebitel,"ИНН")
                           TmpStr:=str(main_base->lic_schet,4,0)+" "+delstring(main_base->potrebitel,"ИНН")+" "+alltrim(main_base->secondname)
                           TmpStr:=substr(TmpStr,1,50)+space(50-len(TmpStr))
                           IF len(MemStr)<15000
                              MemStr:=MemStr+TmpStr
                           ENDIF
                           fwrite(desc2,TmpStr)
                           select second_base
                           go top
                           _rashod=0
                           seek main_base->lic_schet
                           if found()
//---------------------------------     && Работа с показаниями счетчиков
                              do while second_base->licevoj==main_base->lic_schet
//                                 IF Second_Base->Licevoj==2453
//                                    Al_Box({"Лицевой 2453!"})
//                                 ENDIF
                                 @ 4,0 say num_of_sch
//                                 if summa>=0.and.drug_nach=.f.
                                    if isonlimit(kod)
                                       if isnonds(tarif,Main_Base->Lic_Schet)
                                         IF IS_ON_HIGH(tarif)
                                            IF Rashod>0
                                               ras_hod=if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0,;
                                               if(rashod-subab>0,rashod-subab,subab-rashod) ,0)
                                               If Second_Base->Licevoj!=2455.and.Second_Base->Licevoj!=2456
                                                    _rashod=_rashod+ras_hod
                                                    wsego_po_otrasli=wsego_po_otrasli+ras_hod
                                               ENDIF
//                                                 IF Second_Base->Licevoj==2453
//                                                    Al_Box({"???  "+Str(Ras_Hod)})
//                                                 ENDIF
                                            ELSE
                                                    ras_hod=rashod
                                                    If Second_Base->Licevoj!=2455.and.Second_Base->Licevoj!=2456
                                                       _rashod=_rashod+ras_hod
                                                       wsego_po_otrasli=wsego_po_otrasli+ras_hod
                                                    ENDIF
//                                                 IF Second_Base->Licevoj==2453
//                                                    Al_Box({"!  "+Str(Ras_Hod)})
//                                                 ENDIF
                                            ENDIF
                                         endif
                                       endif
//                                    endif
//                                 ELSE
//                                   IF Rashod>0
                                 endif
                                 skip
                              enddo
                           endif
                           @ 4,0 say space(15)
//--------------------------------------------------------------------------
                           select limit_base
                           seek main_base->lic_schet
                           if found()
                              plan_9ps:=str(&cMonth*1000,8,0)
                              wsego_po_planu:=wsego_po_planu+(&cMonth*1000)
                              wsego_plan=wsego_plan+&cMonth
                           else
                              plan_9ps:="??????"
                           endif
//--------------------------------------------------------------------------
                           IF len(MemStr)<32000
                              @ 5,0 say "Использовано памяти: "+alltrim(str(len(MemStr)))+" байт    "
                              MemStr:=MemStr+plan_9ps+"  "+str(_rashod,8,0)+" "+str(_rashod-val(Plan_9ps),8,0)+CrLf
                           ELSE
                              @ 5,0 say "Пeрегрузка памяти, использован SWAP "+Ddir+"TmpTxt.Swp"
                           ENDIF
//                           IF _rashod!=0.and.Val(Plan_9ps)!=0
                              fwrite(desc2,plan_9ps+"  "+str(_rashod,8,0)+" "+str(_rashod-val(Plan_9ps),8,0)+CrLf)
//                           ENDIF
                           select main_base
                        endif
                        skip
                enddo
                if wsego_po_otrasli!=0
                   WsegoPotr=WsegoPotr+wsego_po_otrasli
//                        fwrite(desc," Всего: "+alltrim(str(wsego_po_otrasli,15,0))+" КВт/ч   План "+alltrim(str(wsego_po_planu,15,0))+CrLf)
                        fwrite(desc,str(wsego_po_planu,8,0)+"  "+str(wsego_po_otrasli,8,0)+CrLf)
                        IF LEN(MemStr)>0
                           @ 5,0 say "Сброс буферов"+space(60)
                           nLen:=Flen(desc2)
                           Fseek(desc2,0)
                           FOR i=1 to nLen
                               byte:=FreadStr(desc2,1)
                               str(fwrite(desc,byte))
                               @ 5,15 say str(i*100/nLen,3,0)+"%"
                           NEXT
                           Fwrite(desc,CrLf)
                        ELSE
                           FWrite(desc,MemStr)
                        ENDIF
                        MemStr:=""
                else
                     fwrite(desc,CrLf)
                endif
                fclose(desc2)
                select otrasl
                skip
                if inkey()=27
                   if al_box({"Прервать расчет ?"},2)==1
                      exit
                   endif
                endif
        enddo
        fwrite(desc,"Потреблено электроэнергии всего "+alltrim(str(WsegoPotr))+" КВт/ч"+replicate(CrLf,5))
        fseek(desc,402,0)
        fwrite(desc,"Потреблено электроэнергии всего "+alltrim(str(WsegoPotr))+" КВт/ч")
        fseek(desc,0,2)
        fwrite(desc,space(20)+'Директор                                     '+AllTrim(NameBoss)+CrLf+CrLf)
        fwrite(desc,space(20)+"Начальник ОСЭ                                 Бородай Ю.Ю."+CrLf)
        @ 2,0 say space(79)
        @ 3,0 say space(79)
        @ 4,0 say space(79)
        colorwin(12,21,12,21+39,'n/n')
else
        al_box({'Ошибка создания файла отчета по форме "9-ПС"',;
                'возможен физический деффект диска.',;
                'Работа по созданию отчета прекращена.'})
endif
fclose(desc)
close all
deletefile(lic_ntx)
deletefile(TmpInd)
deletefile(schet_share+"index9ps.ntx")
deletefile(Ddir+"TmpTxt.Swp")
loadgos()
select(prev_sel)
go prev_rec
                                        restore screen from prev_scr
                                endif
                        endif
                case _9ps=2
                        old_scr1=savescreen(19,39,24,54)
                        set color to n/w,w/b
                        @ 19,39 say "┌──────────────╖"
                        @ 20,39 say "│    Первый    ║"
                        @ 21,39 say "│    Второй    ║"
                        @ 22,39 say "│    Третий    ║"
                        @ 23,39 say "│   Четвертый  ║"
                        @ 24,39 say "╘══════════════╝"
                        do while .t.
                                @ 20,40 prompt "    Первый    "
                                @ 21,40 prompt "    Второй    "
                                @ 22,40 prompt "    Третий    "
                                @ 23,40 prompt "   Четвертый  "
                                menu to kv
                                do case
                                        case kv>=1.and.kv<=4
                                                do case
                                                        case kv=1
                                                                wibor(20,41,4,'w+*/b')
                                                                kvart_rashod(1)
                                                        case kv=2
                                                                wibor(21,41,4,'w+*/b')
                                                                kvart_rashod(2)
                                                        case kv=3
                                                                wibor(22,41,4,'w+*/b')
                                                                kvart_rashod(3)
                                                        case kv=4
                                                                wibor(23,41,4,'w+*/b')
                                                                kvart_rashod(4)
                                                endcase
                                        otherwise
                                                exit
                                endcase
                        enddo
                        restscreen(19,39,24,54,old_scr1)
                        set color to w/b+,w+/n
                case _9ps=3
                        wibor(19,37,7)
                        SetColor(Clr)
                        old_sel=select()
                        old_col=setcolor()
                        save screen
                        obrabot()
                        count=0
                        for i=1 to 12
                                select(i)
                                count=count+reccount()
                        next
                        temp_=40/count
                        kol_kl=0
                        uve=0
//                        set color to w/b
                        @ 11,21 say 'Всего к обработке '+alltrim(str(count))
                        @ 11,45 say 'Обработано'
                        go top
                        sum_rashod=0
                        for i=1 to 12
                                if empty(main->lim_tar1)
                                        MyError(' Тариф для расчета по лимитам не введен !!! ')
                                        exit
                                endif
                                select(i)
                                go top
                                do while .not.eof()
                                        if licevoj=main->lic_schet
                                                sum_rashod=sum_rashod+prov_tarif(tarif)
                                        endif
                                        kol_kl=kol_kl+temp_
                                        set color to g+/b
                                        uve=uve+1
                                        @ 11,56 say alltrim(str(uve))
                                        set color to
                                        @ 12,21 say replicate(" ",kol_kl)
                                        SetColor(Clr)
                                        skip
                                enddo
                        next
                        @ 12,21 say replicate(' ',40)
                        sum_rashod=int(sum_rashod)
                        message_wait(' Расход за год по предприятию '+alltrim(str(sum_rashod))+' кВт/ч.')
                        restore screen
                        select(old_sel)
                        setcolor(old_col)

                case _9ps=4
                        tarif_limit()
                otherwise
                        ret_val=.f.
                        exit
        endcase
enddo
setcolor(old_col)
win_rest(old_scr)
return ret_val





function on_limit(name_sch)
local on_limit:=.F.
if name_sch#schet_nl1.and.name_sch#schet_nl2.and.name_sch#schet_nl3.and.;
   name_sch#schet_nl4.and.name_sch#schet_nl5.and.name_sch#schet_nl6.and.;
   name_sch#schet_nl7.and.name_sch#schet_nl8.and.name_sch#schet_nl9.and.;
   name_sch#schet_nl10.and.name_sch#schet_nl11.and.name_sch#schet_nl12.and.;
   name_sch#schet_nl13.and.name_sch#schet_nl14.and.name_sch#schet_nl15.and.;
   name_sch#schet_nl16.and.name_sch#schet_nl17.and.name_sch#schet_nl18
   on_limit=.T.
endif
return on_limit



Function Flen(Pointer)
LOCAL Len:=0,Pos:=0
Pos:=Fseek(Pointer,1,0)
Fseek(Pointer,0)
Len:=Fseek(Pointer,0,2)
Fseek(Pointer,0,Pos)
Return Len
