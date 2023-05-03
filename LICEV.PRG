// Счетчики по потребителю
PROCEDURE Licevoj
LOCAL pos,old_sel:=select(),TmpRecNo
LOCAL Ba:="",Rs:="",Ks:="",Mf:=""
Local oDlg,aSizeDeskTop,aPos,oProgress
PRIVATE rec_buff,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,name
PRIVATE IsRecalc:=.F.,PlombaIsOut:=.F.,PlombaIsPresent:=.F.
rec_buff=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
   if (.not. file(schet_Share+'licevoj.dbf')).or.(.not. file(schet_Share+'lic_sch.ntx')).or.(.not.file(shet_share+'schetchi.ntx'))
      sign(2)
      set color to (color_buf)
      restscreen(0,0,24,79,buff)
      return
   else
      select 77
   endif
else
   if (.not. file(schet_share+'licevoj.dbf')).or.(.not. file(schet_share+'lic_sch.ntx')).or.;
      (.not.file(schet_share+'schetchi.ntx')).or.(.not.file(DDir+'licevoj2.dbf'))
      sign(2)
      set color to (color_buf)
      restscreen(0,0,24,79,buff)
      return
   else
      if select()#77
         select 77
      endif
   endif
endif
if .not.found
   if al_box({'По потребителю счетчиков не найдено'},2,;
             {' Продолжить '," Выход "})==1
      dalshe=.t.
   else
      dalshe=.f.
   endif
else
   dalshe=.t.
endif
if dalshe
   message("Ждите, идет поиск счетчиков ...")
   select licevoj2
   zap
   select licevoj
   seek main->lic_schet
   if found()
      Ba:=Bank; Rs:=R_Schet; Ks:=K_Schet; Mf:=Mfo
      restscreen(0,0,24,79,buff)
      do while lic_sch==main->lic_schet
         message("  Анализ счетчика "+alltrim(schetchik)+space(len(schetchik)-len(alltrim(schetchik))))
         select licevoj2
         append blank
         select licevoj
         TmpRecNo:=RecNo()
         Select Licevoj2
         replace recno with TmpRecNo
         Select Licevoj
         pos=1
         do while .t.
            FName:=Fieldname(pos)
            IF .not.empty(FName)
            Select Licevoj2
               replace &FName with Licevoj->&FName
               Select Licevoj
            ELSE
               exit
            ENDIF
            pos++
         enddo
         Select Licevoj2
         Replace Bank With Ba
         Replace R_Schet With Rs
         Replace K_Schet With Ks
         Replace Mfo With Mf
         Select Licevoj
         skip
      enddo
   endif
   select licevoj2
//   set filter to lic_sch=schet
   colorwin(6,0,23,79,'bg/bg')
   name=alltrim('Счетчики потребителя '+main->potrebitel)
   @ 6,0 say Center(Name,79," ",.t.)
   declare zgl[1]
   declare fil[1]
   nm1=loarr('zgl','Номер счетчика')
   nm2=loarr('fil','schetchik')
   inp='0'
   go top
   t1=7
   l1=1
   b1=23
   r1=78
   FClose(FCreate(DDir+ReportFile))
   fsbrowse(7,20,20,48,'fil','zgl',inp,urov,kl)
   restscreen(0,0,24,79,buff)
   select licevoj2
   set deleted off
   temp_=39/reccount()
   kol_kl=0
   go top
//   IF IsRecalc
//      obrabot("Перерасчет сальдо текущего месяца")
//      do outex with month(new_date)
//   ENDIF
//   obrabot("Очистка временного буфера")

	 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
	 aSizeDesktop  := oMainWindow:currentSize()
	 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
   oDlg:title    := "Очистка временного буфера" 
   oDlg:SysMenu	 := .F.
   oDlg:Configure()
   oDlg:Show()
   aSizeDesktop    := oDlg:currentSize()
   aPos						:= oDlg:CurrentPos()
   oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
   oProgress:create()
   oProgress:minimum := 1
   oProgress:maximum := RecCount()
   do while !eof()
   	  oProgress:increment()																				// Progress Bar Increment
//      kol_kl=kol_kl+temp_
//      colorwin(12,21,12,21+kol_kl,'n/n')
      RecDeleted:=deleted()
      select licevoj
      if licevoj2->recno!=0
         go licevoj2->recno
      else
         if netappend(0)
            unlock
         endif
      endif
//--------------------- Изменение полей в базе данных LICEVOJ полями LICEVOJ2
      if reclock()
         pos=1
         do while .t.
            FName:=Fieldname(pos)
            IF .not.empty(FName)
               IF (licevoj->&FName)!=(licevoj2->&FName)
                  replace &FName with licevoj2->&FName
               ENDIF
            ELSE
               exit
            ENDIF
            pos++
         enddo
         if RecDeleted
            delete
         endif
         unlock
      endif
//------------------------------------------------------------------------
      select licevoj2
      skip
   enddo
   set deleted on
   zap
   IF IsRecalc
//      obrabot("Перерасчет сальдо текущего месяца")
      do outex with month(New_date)
   ENDIF
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
//   set filter to
endif
IF Dalshe==.F.
//	oProgress:destroy()																							// Progress Bar Destroy
//	oDlg:Destroy()
ENDIF
//commit
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buff
restscreen(0,0,24,79,buff)
return
*********************************