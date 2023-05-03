*reestr_2()

FUNCTION reestr_2()
private scr_buff,ret_,odl_sel,old_ind,rec,itogo
rec=recno()
old_ind=indexord()
old_sel=select()
ret_=.t.
scr_buff=savescreen(10,18,15,65)
month=month_menu()
itogo=0
if month>0
        *set date german
        obrabot('Подготовка реестра оплаты')
//      load('44',dir+'o'+alltrim(str(month))+'.dbf')
        select 44
        if NetUse(Schet_Share+'o'+alltrim(str(month))+'.dbf',,0)
//        pack
        if reccount()>0
                index on data to data
                sum=0
                penq_=0
                go top
                temp_=40/reccount()
                kol_kl=0
                data1=data
                desc=fcreate(Ddir+ReportFile)
                if desc#-1
                        set color to gr+/b+
                        perem=stroka+chr(13)+chr(10)+"┌"+Replicate("─",Len(Dtoc(new_date)))+"┬─────────────────────────────────┐"+chr(13)+chr(10)+"│         │  Госсектор и пром сектор        │"+chr(13)+chr(10)
                        fwrite(desc,perem)
                        perem="│"+Center("Дата",Len(Dtoc(new_date))," ",.T.)+"├─────────────────┬───────────────┤"+chr(13)+chr(10)+"│         │  Всего за день  │   Пеня        │"+chr(13)+chr(10)
                        fwrite(desc,perem)
                        perem="├"+Replicate("─",Len(Dtoc(new_date)))+"┼─────────────────┼───────────────┤"+chr(13)+chr(10)
                        fwrite(desc,perem)
                        do while !eof()
                                if data#data1
                                        if sum#0
                                                perem="│"+dtoc(data1)+" │"+str(round(sum,2),16,2)+" │"+str(round(penq_,2))+space(13-len(str(round(penq_,2))))+"  │"+chr(13)+chr(10)
                                                fwrite(desc,perem)
                                        endif
                                        data1=data
                                        sum=0
                                        penq_=0
                                else
                                        if alltrim(vid_dokum)#"Пеня".and.alltrim(vid_dokum)#"пеня".and.;
                                        alltrim(vid_dokum)#"возврат".and.alltrim(vid_dokum)#"Возврат".and.;
                                        alltrim(vid_dokum)#"н возврат".and.alltrim(vid_dokum)#"н Возврат".and.;
                                        alltrim(vid_dokum)#"о возврат".and.alltrim(vid_dokum)#"о Возврат"
                                                itogo=itogo+summa
                                                sum=sum+summa
                                        else
                                                if alltrim(vid_dokum)="пеня".or.alltrim(vid_dokum)="Пеня"
                                                        penq_=penq_+summa
                                                else
                                                        if alltrim(vid_dokum)='о возврат'.or.alltrim(vid_dokum)='о Возврат'
                                                                sum=sum-summa
                                                                itogo=itogo-summa
                                                        endif
                                                endif
                                        endif
                                        skip
                                        kol_kl=kol_kl+temp_
                                        colorwin(12,21,12,21+kol_kl,'n/n')
                                endif
                        end
                        if sum#0
                                perem="│"+dtoc(data1)+" │"+str(round(sum,2),16,2)+" │"+str(round(penq_,2))+space(13-len(str(round(penq_,2))))+"  │"+chr(13)+chr(10)
                                fwrite(desc,perem)
                        endif
                        perem="└"+Replicate("─",Len(Dtoc(new_date)))+"┴─────────────────┴───────────────┘"+chr(13)+chr(10)+"Итого оплачено "+alltrim(str(itogo,14,2))+chr(13)+chr(10)+chr(26)
                        fwrite(desc,perem)
                        fclose(desc)
                else
                        Al_Box({'Ошибка создания файла отчета ! Проверите диск '+diskname()})
                endif
                restscreen(10,18,15,65,scr_buff)
        else
                Al_Box({'Оплата за  "'+mesqc(month)+'"  мeсяц не поступала '})
                restscreen(10,18,15,65,scr_buff)
        endif
        use
        endif && от Superload
else
        ret_=.f.
endif
select(old_sel)
set order to old_ind
go rec
return ret_