func oraschet
private _para
paramet _para
* ����⪠ - 15 �������
* �����   - 44 �������
* ���稪� - 1-12 �������
* month_   - ��६����� � ����楬 ���� �./��.
sele_old=select()
buff_old=indexord()
numrec=recno()
if pcount()<2
        colorwin(0,0,5,79,'n/n')
endif
debet=0
kredit=0
beznds=0
**************** ���� ᪮�쪮 ����५� �� ���稪�� **************
sele(month_)
go top
do while !eof()
        if licevoj=main->lic_schet
                if tarif#6
                        debet=debet+summa
                else
                        beznds=beznds+summa
                endif
        endif
        skip
enddo
**************** ���� ������ � �����⠬� ************************
if _para=.t.
        sele 44
else
        mm=alltrim(str(month_))
        sele 44
        use &mm
endif
go top
w_ozw1=0
w_ozw2=0
w_ozw3=0
do while !eof()
        if licevoj=main->lic_schet
                if alltrim(vid_dokum)#'� ������'.and.alltrim(vid_dokum)#'� ������';
                .and.alltrim(vid_dokum)#'����'.and.alltrim(vid_dokum)#'����';
                .and.alltrim(vid_dokum)#'������'.and.alltrim(vid_dokum)#'������';
                .and.alltrim(vid_dokum)#'� ������'.and.alltrim(vid_dokum)#'� ������'
                        kredit=kredit+summa
                else
                        if alltrim(vid_dokum)='� ������'.or.alltrim(vid_dokum)='� ������'
                                        w_ozw1=w_ozw1+summa
                        else
                                if alltrim(vid_dokum)='������'.or.alltrim(vid_dokum)='������'
                                        w_ozw2=w_ozw2+summa
                                else
                                        if alltrim(vid_dokum)='� ������'.or.alltrim(vid_dokum)='� ������'
                                                w_ozw3=w_ozw3+summa
                                        endif
                                endif
                        endif
                endif
        endif
        skip
enddo
if .not._para
        use
endif
**************** ���� H�� � ����祭��� �㬬� *********************
* debet+bez_nds - ����५� �� ���稪��
* w_ozw         - �㬬� ������ �� ���᫥���
nds=round(debet*schet_nds/100,0)
debet=(debet+nds+beznds+w_ozw1)-w_ozw2-w_ozw3
kredit=kredit-w_ozw2
**************** ������ ���� �����/�।�� *********************
sele 15
seek main->lic_schet
d_last=if(month_>1,'obormot->debet'+alltrim(str(month_-1)),'obormot->last_debet')
k_last=if(month_>1,'obormot->kredit'+alltrim(str(month_-1)),'obormot->last_kred')
if !empty(&d_last).and.!empty(&k_last)
        Myerror("�� ���� "+alltrim(str(main->lic_schet))+" ���� ����� � �।��")
        return .f.
endif
**************** ������ �����騩 �����/�।�� *******************
d_pres='obormot->debet'+alltrim(str(month_))
k_pres='obormot->kredit'+alltrim(str(month_))
**************** ������ १���� � ��⮬ ��諮�� ����� *******
debet=debet+&d_last
kredit=kredit+&k_last
**************** �����뢠� �����騩 �����/�।�� ******************
sele 15
seek main->lic_schet
do case
        case debet>kredit
                if &d_pres#round(debet-kredit,0).and.&k_pres#0
                        if pcount()<2
                                Myerror("H�ᮢ������� ������ �� ���� "+str(main->lic_schet))
                        endif
                endif
                replace &d_pres with round(debet-kredit,0)
                replace &k_pres with 0
        case debet<kredit
                if &k_pres#round(kredit-debet,0).and.&d_pres#0
                        if pcount()<2
                                Myerror("H�ᮢ������� ������ �� ���� "+str(main->lic_schet))
                        endif
                endif
                replace &k_pres with round(kredit-debet,0)
                replace &d_pres with 0
        case debet=kredit
                if &d_pres#0.and.&k_pres#0
                        if pcount()<2
                                Myerror("H�ᮢ������� ������ �� ���� "+str(main->lic_schet))
                        endif
                endif
                replace &d_pres with 0
                replace &k_pres with 0
endcase
**************** ����� �ᥬ ���⠬, �����뢠� १���� **********
select(sele_old)
set order to buff_old
go numrec
return .t.