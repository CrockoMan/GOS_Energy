//      Kniga_old!=7
func ctvzpe()
LOCAL Tarifs:={}
LOCAL month_,perem,desc,base,count,cou,tarif,summ,rash,sele,ind,rec,sel,scr
LOCAL rmonth,balabala,mesqc
rec=recno()
balabala=0
sele=select()
ind=indexord()
save screen to scr
month_=month_menu()
mesq='o'+alltrim(str(month_))+'.dbf'
if month_>0
   rmonth=mesqc(month_)
   do case
      case month_=1
              base='Jan'
      case month_=2
              base="Feb"
      case month_=3
              base='Mar'
      case month_=4
              base='Apr'
      case month_=5
              base="May"
      case month_=6
              base='Jun'
      case month_=7
              base='Jul'
      case month_=8
              base='Aug'
      case month_=9
              base='Sep'
      case month_=10
              base='Oct'
      case month_=11
              base='Nov'
      case month_=12
              base='Dec'
   endcase
   index=dir+'temp.ntx'
   database=path_copy+base+'.dbf'
   select(month_)
   index on tarif to &index unique
   go top
   count=0
   do while !eof()
      count=count+1
      skip
   enddo
   declare mass[count]
   go top
   cou=0
   Myerror('   �ᥣ� ��䮢 ������� :'+alltrim(str(count))+' ! ���� ���஢�� ...',1)
   do while !eof()
      cou=cou+1
      mass[cou]=tarif
      skip
   enddo
   ASort(Mass)
   Tarifs:=[count][count][count]
   use
//   close index
//   select(month_)
//   use &base SHARED
//------------ ����⨥ ���� � �����ᮬ � ������ ��������� ���稪��...
   LoadMonth(Month_)
   go top
   desc=fcreate(Ddir+'otchet.gkv')
   perem="  ������� ��䭠� ��������� �� ���ॡ������"+chr(13)+chr(10)+;
   center("  ���������ࣨ� �� "+rmonth+" ����� "+alltrim(str(year(new_date)))+;
   " �.",44,' ',.t.)+chr(13)+chr(10)+stroka+chr(13)+chr(10)
   fwrite(desc,perem)
   perem="�������������������������������������������Ŀ"+chr(13)+chr(10)+;
         "�    ����    �   ���室    �  �㬬�        �"+chr(13)+chr(10)
   fwrite(desc,perem)
   perem="�������������������������������������������Ĵ"+chr(13)+chr(10)
   fwrite(desc,perem)
   for i=1 to count
       message('  ����, ���� ������ ��室�, �㬬� � ������ ��� ��� '+str(mass[i]))
       rash=0
       summ=0
       select main
       go top
       do while .not.eof()
          select licevoj
          seek main->lic_schet
          do while lic_sch==Main->lic_schet
             select(Month_)
             seek main->lic_schet
             if found()
                if mass[i]=tarif
                   if summa#0
                      if rashod>0
                         rash=rash+if(rashod-subab>0,rashod-subab,subab-rashod)
                         summ=summ+summa
                      else
                         rash=rash+rashod
                         summ=summ+summa
                      endif
                   endif
                endif
             endif
             select licevoj
             skip
          enddo
       perem="�  "+str(mass[i])+"  � "+str(round(rash,0))+"  � "+str(round(summ,2))+" �"+chr(13)+chr(10)
       fwrite(desc,perem)
       balabala=balabala+summ
   next
   use
   perem="���������������������������������������������"+chr(13)+chr(10)+' �ᥣ�      : '+str(round(balabala,2),15,2)+' ��.'+chr(13)+chr(10)
   message(" ���� ���� ������ ������ � ������ ������ �㬬 ")
   sele 44
   use &mesq
   go top
   tt_tt=0
   do while !eof()
           if alltrim(vid_dokum)='� ������'.or.alltrim(vid_dokum)='� ������'
              tt_tt=tt_tt+summa
           endif
           skip
   enddo
   use
   load(alltrim(str(month_)),base+'.dbf',base+'_kod.ntx')
   perem=perem+' �����饭� : '+str(tt_tt,15,2)+chr(13)+chr(10)+' �⮣�      :   '+str(balabala-tt_tt,15,2)+' ��.'+chr(13)+chr(10)
   fwrite(desc,perem)
   fclose(desc)
   deletefile(Ddir+'temp.ntx')
endif
select(sele)
set order to ind
go rec
al_box({'����� "������� ��䭮� ��������" �����祭'})
restore screen from scr
return NIL