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
        obrabot('�����⮢�� ॥��� ������')
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
                        perem=stroka+chr(13)+chr(10)+"�"+Replicate("�",Len(Dtoc(new_date)))+"���������������������������������Ŀ"+chr(13)+chr(10)+"�         �  ���ᥪ�� � �஬ ᥪ��        �"+chr(13)+chr(10)
                        fwrite(desc,perem)
                        perem="�"+Center("���",Len(Dtoc(new_date))," ",.T.)+"���������������������������������Ĵ"+chr(13)+chr(10)+"�         �  �ᥣ� �� ����  �   ����        �"+chr(13)+chr(10)
                        fwrite(desc,perem)
                        perem="�"+Replicate("�",Len(Dtoc(new_date)))+"���������������������������������Ĵ"+chr(13)+chr(10)
                        fwrite(desc,perem)
                        do while !eof()
                                if data#data1
                                        if sum#0
                                                perem="�"+dtoc(data1)+" �"+str(round(sum,2),16,2)+" �"+str(round(penq_,2))+space(13-len(str(round(penq_,2))))+"  �"+chr(13)+chr(10)
                                                fwrite(desc,perem)
                                        endif
                                        data1=data
                                        sum=0
                                        penq_=0
                                else
                                        if alltrim(vid_dokum)#"����".and.alltrim(vid_dokum)#"����".and.;
                                        alltrim(vid_dokum)#"������".and.alltrim(vid_dokum)#"������".and.;
                                        alltrim(vid_dokum)#"� ������".and.alltrim(vid_dokum)#"� ������".and.;
                                        alltrim(vid_dokum)#"� ������".and.alltrim(vid_dokum)#"� ������"
                                                itogo=itogo+summa
                                                sum=sum+summa
                                        else
                                                if alltrim(vid_dokum)="����".or.alltrim(vid_dokum)="����"
                                                        penq_=penq_+summa
                                                else
                                                        if alltrim(vid_dokum)='� ������'.or.alltrim(vid_dokum)='� ������'
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
                                perem="�"+dtoc(data1)+" �"+str(round(sum,2),16,2)+" �"+str(round(penq_,2))+space(13-len(str(round(penq_,2))))+"  �"+chr(13)+chr(10)
                                fwrite(desc,perem)
                        endif
                        perem="�"+Replicate("�",Len(Dtoc(new_date)))+"�����������������������������������"+chr(13)+chr(10)+"�⮣� ����祭� "+alltrim(str(itogo,14,2))+chr(13)+chr(10)+chr(26)
                        fwrite(desc,perem)
                        fclose(desc)
                else
                        Al_Box({'�訡�� ᮧ����� 䠩�� ���� ! �஢��� ��� '+diskname()})
                endif
                restscreen(10,18,15,65,scr_buff)
        else
                Al_Box({'����� ��  "'+mesqc(month)+'"  �e��� �� ����㯠�� '})
                restscreen(10,18,15,65,scr_buff)
        endif
        use
        endif && �� Superload
else
        ret_=.f.
endif
select(old_sel)
set order to old_ind
go rec
return ret_