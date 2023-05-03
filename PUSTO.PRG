function pustograph()
LOCAL select:=select(),recno:=recno(),desc,CrLf:=chr(13)+chr(10),cmonth
LOCAL poisk,save:=win_save()
deletefile(M->Ddir+"otchet.gkv")
select 77                            && Ž¡« áâì á «¨æ¥¢ë¬¨ áç¥â ¬¨
go top
seek main->lic_schet
if found()
   month:=month_menu()
   smonth=if(month>1,month-1,12)
   if month#0
      message("ˆ¤¥â £¥­¥à æ¨ï ¯ãáâ®£à äª¨, ¦¤¨â¥...")
      desc:=fcreate(M->Ddir+"otchet.gkv")
      fwrite(desc,"ˆ­ä®à¬ æ¨ï ® ¯®ª § ­¨ïå áç¥âç¨ª®¢ "+crlf)
      IF Len(alltrim(main->potrebitel)+"   «/á "+alltrim(str(main->lic_schet)))>78
         fwrite(desc,Substr(alltrim(main->potrebitel)+"   «/á "+alltrim(str(main->lic_schet)),1,78)+crlf)
         fwrite(desc,Substr(alltrim(main->potrebitel)+"   «/á "+alltrim(str(main->lic_schet)),79)+crlf)
      ELSE
         fwrite(desc,alltrim(main->potrebitel)+"   «/á "+alltrim(str(main->lic_schet))+crlf)
      ENDIF
//      fwrite(desc,"­  15 -oe "+mesqc(month,.T.)+" "+str(year(new_date)+IF(Month==1,1,0),4,0)+"£."+crlf+crlf)
      fwrite(desc,"­  25 -oe "+mesqc(month,.T.)+" "+str(year(new_date)+IF(Month=1,1,0),4,0)+"£."+crlf+crlf)
      fwrite(desc,"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄ¿"+crlf)
      fwrite(desc,"³       N        ³           Ž¡`¥ªâ            ³à¥¤. ³ áâ. ³  §- ³Š®íää³ áå®¤ ³"+crlf)
      fwrite(desc,"³    áç¥âç¨ª     ³            ãç¥â             ³¯®ª §.³¯®ª §.³­®áâì ³     ³ª¢â.ª¢ ³"+crlf)
      fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÄÄ´"+crlf)
//      do while !eof()
      do while lic_sch==main->lic_schet
         if lic_sch=main->lic_schet
            message(" ‡ ¯®«­¥­¨¥ ¤ ­­ëå ¯® áç¥âç¨ªã  "+schetchik+" ...")
            fwrite(desc,"³"+schetchik+" ³"+Substr(ltrim(Alltrim(object1)+" "+Alltrim(adres))+Space(29),1,29)+"³")
            select(smonth)
            poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
            seek poisk
            if substr(alltrim(MYupper(num_of_sch)),1,6)#"Ž’…ˆ"
               if found().and..not.deleted()
                  fwrite(desc,str(pokazaniq,6,0)+"³      ³      ³"+if(koeficient>0,str(koeficient),"     ")+"³       ³")
               else
                  fwrite(desc,"      ³      ³      ³     ³       ³")
               endif
            else
                 fwrite(desc,"      ³      ³      ³     ³"+str(rashod,7,0)+"³")
            endif
            fwrite(desc,crlf)
            select(77)
         endif
         skip
      enddo
      fwrite(desc,"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÙ"+crlf)
      fwrite(desc,crlf+crlf+space(11)+"ãª®¢®¤¨â¥«ì ______________ (____________)"+crlf)
      fclose(desc)
   endif
else
     al_box({"‘ç¥âç¨ª®¢ ¯® «¨æ¥¢®¬ã áç¥âã N"+alltrim(str(main->lic_schet))+;
             "­¥ ­ ©¤¥­®"},1)
endif
select(select)
goto recno
win_rest(save)
return NIL