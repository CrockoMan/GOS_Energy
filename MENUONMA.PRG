function menuonmain()
LOCAL old_col1:=setcolor(),screen:=win_save(5,28,24,79),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1
local first:=.T.
spisok:={" C��                  ",;
         " ���⥦�� �� ���������ࣨ�",;
         " ���⥦�� �� �����஢�����",;
         " ����襭��� �����a     ",;
         " ���� �� �����         ",;
         " �����᫥��� �� ����� ",;
         " ���⥦�� � ����       ",;
         " ���⮣�䪠           ",;
         " ��� ᢥન            ",;
         " ���������� ����� �த��  ",;
         "�����������������������������",;
         " ����� ����               "}
prev_rec=prev_rec-1
do while pos>0
   if file(Ddir+'otchet.gkv')
      pos=len(spisok)
      is_choice:={.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.F.,.t.}
   else
      is_choice:={.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.F.,.F.}
   endif
   if first
      pos=1
      first=.F.
   endif
choice=vert_menu(spisok,"�����஢���",is_choice,8,28,pos,'n/w,n/g,,,r/w',.F.)
        pos=choice
        wid=choice
        widsav:=wid
        if wid<10.and.wid>0
                deletefile(Ddir+"otchet.gkv")
                pos=choice
        else
                pos=len(spisok)
        endif
        do case
                case wid=1
                        if otchet()
                                ret_val=2
                        endif
                case wid=2
                     VystSumma()
//                     VidPlat:=Al_Box({"��� ���⠢�塞�� ���᫥��� ���ॡ�⥫�"},2,{"�����⥫��","�������","�⬥��"})
//                     DO CASE
//                        CASE VidPlat==1
//                             if schetfaktura(1)
//                                ret_val=2
//                             endif
//                        CASE VidPlat==2
//                             FiftyDays()
//                     ENDCASE
                     ret_val=2
                case wid=3
                        if schetfaktura(2)
                                ret_val=2
                         endif
                case wid=4
                        && ����襭��� �����
                        do high_money
                        ret_val=2
                case wid=5
                        && ����
                        do penq2
                        ret_val=2
                case wid=6
                        do debet_nachisl
                case wid=7
                        menutobank()
                case wid=8
                        pustograph()
                case wid=9
                        sverka()
                case wid=10
                        MakeSfKniga()
                case wid=len(spisok)
                        do print_fi
                otherwise
                        exit
        endcase
        wid=if(file(Ddir+'otchet.gkv'),8,widsav)
enddo
M->prev_rec=-1
win_rest(screen)
setcolor(old_col1)
return NIL



Function VystSumma()
LOCAL scr:=win_save(),is_choice,choic,spisok,pos:=1,select:=select()
LOCAL recno:=recno()
Local old_cl,screen,go_out
old_cl=setcolor()
go_out=.f.
spisok:={" �����⥫�� ���⥦ ",;
         " ������� ���⥦ � ��⮬ ᠫ줮     ",;
         " ������� ���⥦ ��� ��� ᠫ줮 ",;
         "�������������������������������������",;
         " ��室                        "}
is_choice:={.t.,.t.,.t.,.F.,.t.}
do while .not.go_out
   choic=vert_menu(spisok,"��ᬮ����",is_choice,11,30,pos,'n/w,n/g,,,r/w',.F.)
   pos:=choic
   do case
        case choic=1
             SchetFaktura(1)
        case choic=2
             FiftyDays(1)
        case choic=3
             FiftyDays(2)
        otherwise
                go_out=.t.
   endcase
enddo
win_rest(scr)
select(select)
go recno
setcolor(old_cl)
Return NIL




proc debet_nachisl
local old_sel:=select(),old_rec:=recno(),month:=month_menu()
local wsego:=0,osn_tarif:=0,scr,kol_kl:=0,temp_,debet:=0
private data_pl,mes_name,debet_summa,nds,sn
if month>0
   select 15
   debet_pres='debet'+alltrim(str(month))
   kredit_pres='kredit'+alltrim(str(month))
   if &debet_pres=0
      al_box({"���᫥��� �� ��������� �������������",;
              "�� �ந��������, ������������ ���.    "})
   else
        debet:=&debet_pres
        scr:=obrabot("����� ���� �� �����")
        select(month)
        temp_=39/reccount()
        go top
        do while !eof()
           kol_kl=kol_kl+temp_
           colorwin(12,21,12,21+kol_kl,'n/n')
           if licevoj=main->lic_schet
              wsego++
              if tarif=schet_1new.or.tarif=0
                 osn_tarif++
              endif
           endif
           skip
        enddo
        win_rest(scr)
&& debet - 123%
&& x     - 100%
&& x=(debet*100)/123
        if osn_tarif=wsego
           debet_summa=(schet_1new-schet_1old)*(((debet*100)/121.5)/schet_1old)
           debet_summa=round(debet_summa,0)
           if al_box({"���� �� ������������ "+alltrim(str(debet_summa,14,2)),;
                      "��ନ஢��� ���⥦�� ?"},2)=1
data_pl="�� "+alltrim(str(day((New_date+1))))+"  "+cmonth(New_date+1)+'  '+alltrim(str(year(New_date+1)))
mes_name=cmonth(New_date+1)
if schet_treb>999998
        schet_trreb=1
else
        schet_treb=int(schet_treb+1)
endif
select 77
seek main->lic_schet
nds=round(debet_summa*schet_nds/100,0)
sn=round(debet_summa*schet_dnal/100,0)
full_summa:=debet_summa
debet_summa=debet_summa+nds+sn
beginDate:='01.'+alltrim(str(month))+'.'+alltrim(str(year(New_date)))
endDate  :=+alltrim(str(lastdayom(New_date)))+'.'+alltrim(str(month))+'.'+alltrim(str(year(New_date)))
              if main->tip_plat#3
                 if !main->is_poruch
                    report(Ddir+"tre_deb.rpt",Ddir+'otchet.gkv',120)
                 else
                    report(Ddir+"trp_deb.rpt",Ddir+'otchet.gkv',120)
                 endif
              else
                 report(Ddir+"inc_deb.rpt",Ddir+'otchet.gkv',120)
              endif
           endif
        else
           al_box({"���� �� ������������ �� ���᫥�,",;
                   "�����㦥�� ��᪮�쪮 ��䮢."})
        endif
   endif
   select(old_sel)
   go old_rec
endif
return
