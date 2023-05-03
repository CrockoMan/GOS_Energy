FUNCTION AdmFunction()
LOCAL old_col1:=setcolor(),screen:=win_save(11,20,24,79),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok:={},pos:=1,Sel:=Select(),Rec:=Recno()
LOCAL first:=.T.,Ps:=0,Mon,Scr,Asked:=.T.,cLockMonth:="",i
IF .not.IsCorrect("Доступ к сeрвисным функциям")
   RETURN Nil
ENDIF
spisok:={" Закрытие месяца от перерасчета           ",;
         " Открытие месяца для перерасчета ",;
         " Просмотр совершенных действий",;
         " Сброс данных частного сектора"}
prev_rec=prev_rec-1
do while pos>0
   is_choice:={.t.,.t.,.t.,.t.}
   if first
      pos=1
      first=.F.
   endif
   choice=vert_menu(spisok,"Администрирование",is_choice,12,20,pos,'n/w,n/g,,,r/w',.F.)
   pos=choice
   wid=choice
   widsav:=wid
   Ps:=0
   do case
      case wid=1
              Mon:=Month_Menu("для закрытия данных")
              Scr:=Obrabot("Закрытие месяца")
              IF IsCorrect("Закрытие от расчетов "+Mesqc(Mon),.F.)
                 Go top
                 For I=1 To  Mon
                     cLockMonth:=cLockMonth+Chr(i)
                 Next
                 Do While .NOT.Eof()
                    Ps=Ps+39/Reccount()
                    ColorWin(12,21,12,21+Ps,'n/n')
                    IF RecLock()
//                       replace LockMonth With Substr(LockMonth,1,Mon-1)+Chr(Mon)+Substr(LockMonth,Mon+1)
                       replace LockMonth With cLockMonth
                       Unlock
                    Endif
                    Skip
                 Enddo
              ENDIF
              Win_Rest(Scr)
      case wid=2
              Mon:=Month_Menu("для открытия данных")
              Scr:=Obrabot("Открытие месяца")
              IF IsCorrect("Открытие для перерасчетов "+Mesqc(Mon),.F.)
                 Go top
                 Do While .NOT.Eof()
                    Ps=Ps+39/Reccount()
                    ColorWin(12,21,12,21+Ps,'n/n')
                    IF RecLock()
                       replace LockMonth With Substr(LockMonth,1,Mon-1)+Chr(0)+Substr(LockMonth,Mon+1)
                       Unlock
                    Endif
                    Skip
                 Enddo
              ENDIF
              Win_Rest(Scr)
      case wid=3
           ViewAdmBase()
      case wid=4
           IF IsCorrect("Сброс данных частного сектора в годовой файл",.F.)
              WriteChastnBase()
           ENDIF
      otherwise
           exit
   endcase
enddo
M->prev_rec=-1
win_rest(screen)
setcolor(old_col1)
Select(Sel); Go Rec
RETURN NIL


Function ViewAdmBase()
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,;
name,month,go_out,change,sum,debet_pres,kredit_pres,debet_last,kredit_last,scr1,;
what_pay,SetFilter:=.F.
change=.f.
go_out=.f.
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=win_save()
color_buf=setcolor()
IF Al_Box({"Выберите вид просмотра действий"},2,{" Все "," Текущий "})==2
   SetFilter=.T.
ENDIF
   Select 0
   NetUse(Schet_Share+"Access.Dbf")
   IF SetFilter
      Set Filter to Licevoj==Main->Lic_Schet
   ENDIF
   go top
   set color to n/w
   colorwin(1,3,3,77,'w/w')
   declare zgl[6]
   declare fil[6]
   name='Просмотр совершенных операций'
   @ 1,3 say replicate(' ',73)
   @ 1,(79-len(name))/2 say name
   name=" >> ДОСТУПЕН ТОЛЬКО ПРОСМОТР <<"
   @ 2,(79-len(name))/2 say name
   nm1=loarr('zgl','Пользователь','Совершенное действие','Лицевой','Сальдо','Дата',"Время")
   nm2=loarr('fil','user','work','Licevoj','Saldo','Date',"Time")
   inp='0000'
   ************ Begin make box
   t1=3   && Up
   l1=3   && Left
   b1=18  && Down
   r1=77  && Right
   *************  End make
   colorwin(3,3,19,78,'n+/n')
//   DbEdit(3,3,18,77,Fil,,,,Zgl)
   fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl,.f.)
   Close
   win_rest(buff)
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
win_rest(buff)
Return NIL