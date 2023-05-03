proc F11
Local oDlg,aSizeDeskTop,aPos,oProgress
private recno,index,select,temp_,kol_kl,scr
monthe=0
*month_=month(new_date)
select=select()
index=indexord()
recno=recno()
scr=savescreen(1,1,22,79)

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Полный перерасчет всех начислений" 
oDlg:SysMenu	 := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos						:= oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := RecCount()
go top
do while .not.eof()
   if monthe=0
           monthe=month_menu()
   endif
   if monthe=0
           exit
   endif
   oProgress:increment()																				// Progress Bar Increment
//   kol_kl=kol_kl+temp_
//   colorwin(12,21,12,21+kol_kl,'n/n')
&&*oraschet(.f.,.f.)
   do outex with monthe
   skip
   if inkey()#0
           if al_box({'Прервать расчет ?'},2)==1
                   exit
           endif
   endif
enddo
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
select(select)
set order to index
go recno
restscreen(1,1,22,79,scr)
return