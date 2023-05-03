function menupokaz()
LOCAL old_col1:=setcolor(),screen:=win_save(11,26,24,79),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1
local first:=.T.
spisok:={" C показаниями         ",;
         " Без показаний         ",;
         " Не в книге продаж     ",;
         "──────────────────────────",;
         " Печать отчета         "}
prev_rec=prev_rec-1
do while pos>0
   if file(Ddir+'otchet.gkv')
      pos=len(spisok)
      is_choice:={.t.,.t.,.t.,.F.,.t.}
   else
      is_choice:={.t.,.t.,.t.,.F.,.F.}
   endif
   if first
      pos=1
      first=.F.
   endif
choice=vert_menu(spisok,"Выбрать",is_choice,11,26,pos,'n/w,n/g,,,r/w',.F.)
        pos=choice
        wid=choice
        widsav:=wid
        if wid<8.and.wid>0
                deletefile(Ddir+"otchet.gkv")
                pos=choice
        else
                pos=len(spisok)
        endif
        do case
                case wid=1
                     BezPokazanij(1)
                case wid=2
                     BezPokazanij(2)
                case wid=3
                     NoKnigaProdag()
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



FUNCTION BezPokazanij(type_,month)
LOCAL OldOrd,IndMonth:=schet_share+"LicMonth.ntx",Dress
private oldsel,oldscr,oldclr,oldrec
oldrec=recno()
oldsel=select()
oldscr=savescreen(9,0,24,79)
oldclr=setcolor()
IF month==NIL
   month=month_menu(.t.)
ENDIF
if type_#3
 if month#0
   obrabot("Сортировка показаний счетчиков")
   select(month)
   index on licevoj to &IndMonth
   select(oldsel)
   if type_=2
        obrabot("Выборка лицевых без показаний")
   else
        obrabot("Выборка лицевых c показаниями")
   endif
   temp_=39/reccount()
   kol_kl=0
   go top
   desc=fcreate(Ddir+'otchet.gkv')
   if type_=2
        fwrite(desc,'Предприятия, не начисленные за '+mesqc(month)+chr(13)+chr(10)+chr(13)+chr(10))
   else
        fwrite(desc,'Предприятия, начисленные за '+mesqc(month)+chr(13)+chr(10)+chr(13)+chr(10))
   endif
   do while .not.eof().and.Main->lic_schet<=99999
      if inkey()#0
         if al_box({"Прервать расчет"},2)==1
            exit
         endif
      endif
      kol_kl=kol_kl+temp_
      colorwin(12,21,12,21+kol_kl,'n/n')
      rash=0
      select(month)
      seek main->lic_schet
      dress:=""
      do while licevoj==main->lic_schet
         if licevoj=main->lic_schet
            IF num_of_sch!="По ст."
               rash=rash+summa
            ENDIF
         endif
         IF Empty(Dress)
            SELECT Licevoj
            SEEK Main->Lic_Schet
            Dress:=Adres
            select(month)
         ENDIF
         skip
      enddo
      if rash=0.and.type_=2
         fwrite(desc,rangerepl("Н","Н",alltrim(str(main->lic_schet))+' '+main->potrebitel,'H')+" "+Dress+chr(13)+chr(10))
      endif
      if rash#0.and.type_=1
         fwrite(desc,rangerepl("Н","Н",alltrim(str(main->lic_schet))+' '+alltrim(main->potrebitel),'H')+chr(13)+chr(10))
      endif
      select 88
      skip
   enddo
   FClose(Desc)
   Select(Month)
   Close
   DeleteFile(IndMonth)
   LoadMonth(Month)
 endif
endif
select(oldsel)
go oldrec
restscreen(9,0,24,79,oldscr)
setcolor(oldclr)
M->PREV_REC:=-1
return NIL


FUNCTION NoKnigaProdag()
LOCAL rec:=recno(),sel:=select(),scr:=SaveScreen(0,0,24,79),temp_,kol_kl,desc
LOCAL Nachisleno,CrLf:=chr(13)+chr(10),Kod:="",Rashod:=0,Raznica:=0
LOCAL Writed
NumMonth=month_menu(.t.)
IF NumMonth==0
   return NIL
ENDIF
obrabot("Потребители не в книге продаж")
temp_=39/reccount()
kol_kl=0
desc:=fcreate(Ddir+"otchet.gkv")
select sfkniga
set order to 2
do while !eof()
//   @ 1,0 say str(main->lic_schet)
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
   select obormot
   seek main->lic_schet
   IF found()
      Rashod:=GetSum(Main->Lic_Schet,NumMonth)
      Nachisleno:=Rashod
//      Nachisleno:=Rashod+round(Rashod*Schet_Nds/100,Decimal)
//      al_box({str(main->lic_schet)+" Начислено "+str(Nachisleno)})
      select sfkniga
      seek main->lic_schet
      DO while number==main->lic_schet
         IF month==NumMonth.and.type==0
            Writed:=WsegoSNds
            EXIT
         ENDIF
         skip
      ENDDO
      IF number==main->lic_schet.and.month==NumMonth.and.type==0
         IF Round(Writed/Nachisleno,Decimal)!=1.00
            fwrite(desc,str(main->lic_schet,4)+" "+main->potrebitel+;
            " Разница "+alltrim(str(int(if(WsegoSNds-Nachisleno>0,;
            WsegoSNds-Nachisleno,Nachisleno-WsegoSNds))))+CrLf)
            Raznica:=Raznica+if(WsegoSNds-Nachisleno>0,;
                     WsegoSNds-Nachisleno,Nachisleno-WsegoSNds)
         ENDIF
      ELSE
         IF Rashod>0
            fwrite(desc,str(main->lic_schet,4)+" "+main->potrebitel+" нет в книге продаж. Начислено "+Alltrim(Str(Rashod,14,Decimal))+CrLf)
            Raznica:=Raznica+Rashod
         ENDIF
      ENDIF
   ELSE
      fwrite(desc,str(main->lic_schet,4)+" "+main->potrebitel+" нет в оборотке"+CrLf)
   ENDIF
   select main
   skip
   IF inkey()==27
      IF Al_Box({"Закончить расчет"},2)==1
         EXIT
      ENDIF
   ENDIF
enddo
fwrite(desc,"Всего расхождений "+alltrim(str(Raznica))+CrLf)
select sfkniga
set order to 1
fclose(desc)
select(sel)
go rec
RestScreen(0,0,24,79,scr)
RETURN NIL
