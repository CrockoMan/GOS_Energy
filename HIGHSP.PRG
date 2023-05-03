********************************************
* Формирование отчета о превышении лимитов *
********************************************
Function HighSpisok()
private recno,old_screen,select,month,poisk,seekbase,kol_kl,_temp,ras_hod
month=month_menu()
if month>0
        limit=0
        save screen to old_screen
        obrabot("Отчет о превышении лимитов")
        desc=fcreate(Ddir+'otchet.gkv')
        fwrite(desc,stroka+" за "+mesqc(month)+" "+alltrim(str(year(New_date)))+chr(13)+chr(10))
        fwrite(desc,'Основной тариф '+alltrim(str(schet_1new))+"      Коэффициент "+alltrim(str(HighKoeff))+chr(13)+chr(10))
        fwrite(desc,center('Л/сч',len(str(main->lic_schet)),' ',.t.)+'| '+;
        center('Потребитель',40,' ',.t.)+'|'+;
        center('Лимит',len(str(limit,6,1)),' ',.t.)+'|'+;
        center('Расх',len(str(limit,6,1)),' ',.t.)+'|'+;
        center('Прев',len(str(limit,6,1)),' ',.t.)+'|'+chr(13)+chr(10)+chr(13)+chr(10))
        temp_=39/reccount()
        kol_kl=0
        recno=recno()
        select=select()
        go top
        do while !eof()
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                ras_hod=round(GetRasHigh(Lic_Schet,Month)/1000,1)
                Limit:=GetLimit(Month,Lic_Schet)
                IF Ras_Hod>Limit.And.round(Ras_Hod-Limit,1)>0.1.and.main->lim_tar1=0.and.Main->Lic_Schet!=723.and.Main->Lic_Schet!=2102
                        write_string=rangerepl('Н','Н',str(main->lic_schet)+;
                        '| '+substr(main->potrebitel,1,40)+'|'+str( limit,6,1)+'|'+;
                        str(ras_hod,6,1)+'|'+str(ras_hod-limit,6,1)+'|'+str(round(schet_1new*1000*HighKoeff*(ras_hod-limit),0)),'H')
                        fwrite(desc,write_string+chr(13)+chr(10))
                ENDIF
                ras_hod=0
                select(select)
                skip
                if inkey()=27
                   IF Al_Box({"Прервать расчет"},2)==1
                      exit
                   ENDIF
                endif
        enddo
        fclose(desc)
        select(select)
        go recno
        restore screen from old_screen
endif
RETURN NIL
