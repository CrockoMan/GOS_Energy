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
   Myerror('   Всего тарифов найдено :'+alltrim(str(count))+' ! Идет сортировка ...',1)
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
//------------ Открытие базы с индексом в области показаний счетчиков...
   LoadMonth(Month_)
   go top
   desc=fcreate(Ddir+'otchet.gkv')
   perem="  Сводная тарифная ведомость за потребленную"+chr(13)+chr(10)+;
   center("  электроэнергию за "+rmonth+" месяц "+alltrim(str(year(new_date)))+;
   " г.",44,' ',.t.)+chr(13)+chr(10)+stroka+chr(13)+chr(10)
   fwrite(desc,perem)
   perem="┌─────────────┬─────────────┬───────────────┐"+chr(13)+chr(10)+;
         "│    Тариф    │   Расход    │  Сумма        │"+chr(13)+chr(10)
   fwrite(desc,perem)
   perem="├─────────────┼─────────────┼───────────────┤"+chr(13)+chr(10)
   fwrite(desc,perem)
   for i=1 to count
       message('  Ждите, идет подсчет расхода, суммы и возврата для тарифа '+str(mass[i]))
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
       perem="│  "+str(mass[i])+"  │ "+str(round(rash,0))+"  │ "+str(round(summ,2))+" │"+chr(13)+chr(10)
       fwrite(desc,perem)
       balabala=balabala+summ
   next
   use
   perem="└─────────────┴─────────────┴───────────────┘"+chr(13)+chr(10)+' Всего      : '+str(round(balabala,2),15,2)+' руб.'+chr(13)+chr(10)
   message(" Ждите идет подсчет оплаты и анализ возврата сумм ")
   sele 44
   use &mesq
   go top
   tt_tt=0
   do while !eof()
           if alltrim(vid_dokum)='н возврат'.or.alltrim(vid_dokum)='н Возврат'
              tt_tt=tt_tt+summa
           endif
           skip
   enddo
   use
   load(alltrim(str(month_)),base+'.dbf',base+'_kod.ntx')
   perem=perem+' Возвращено : '+str(tt_tt,15,2)+chr(13)+chr(10)+' Итого      :   '+str(balabala-tt_tt,15,2)+' руб.'+chr(13)+chr(10)
   fwrite(desc,perem)
   fclose(desc)
   deletefile(Ddir+'temp.ntx')
endif
select(sele)
set order to ind
go rec
al_box({'Расчет "Сводной тарифной ведомости" закончен'})
restore screen from scr
return NIL