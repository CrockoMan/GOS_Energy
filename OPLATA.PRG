proc oplata_otchet
local pos:=1,scr,LenArr,Is_Choice:={}
private month,oldscr,oldclr,rashifrovka,sum,oldsel,path,bazad,choice,desc,;
        vozwrat,type_op:=1,str_op:="Оплата электроэнергии",otchet:={}
spisok1:={" Оплата электроэнергии   ",;
         " Оплата пени             ",;
         " Оплата повышенной       ",;
         " Оплата абонированной",;
         " Оплата по расшифровкам  ",;
         " Оплата по банкам        ",;
         " Оплата по дням          ",;
         " Оплата по потребителю",;
         "────────────────────────────",;
         " Выход"}
//is_choice1:={.t.,.t.,.t.,.t.,.t.,.t.,.F.,.t.}
ASize(Is_Choice,Len(Spisok1))
AFill(Is_Choice,.T.)
//LenArr:=Len(Is_Choice)
Is_Choice[Len(Is_Choice)-1]=.F.
spisok2:={" Полная расшифровка в файл     ",;
          " Краткая расшифровка на экран  ",;
          "───────────────────────────────",;
          " Выход                         "}
is_choice2:={.t.,.t.,.f.,.t.}

oldsel=select()
oldscr=savescreen(9,0,,)
oldclr=setcolor()
type_op=vert_menu(spisok1,"Тип требуемой оплаты",is_choice,9,27,pos,'n/w,n/g,,,r/w',.F.)
Do Case
   Case Type_Op==5
        MakeAllOpl()
        Select(OldSel)
        RestScreen(9,0,24,79,OldScr)
        Setcolor(OldClr)
        Return
   Case Type_Op==6
        MakeAllNum(Month_Menu())
        Select(OldSel)
        RestScreen(9,0,24,79,OldScr)
        Setcolor(OldClr)
        Return
   Case Type_Op==7
        MakeAllDay()
        Select(OldSel)
        RestScreen(9,0,24,79,OldScr)
        Setcolor(OldClr)
        Return
   Case Type_Op==8
        MakeOneOpl(Month_Menu())
        Select(OldSel)
        RestScreen(9,0,24,79,OldScr)
        Setcolor(OldClr)
        Return
   Case Type_Op==0.or.Type_Op==6
        Select(Oldsel)
        Restscreen(9,0,24,79,Oldscr)
        Setcolor(Oldclr)
        Return
ENDCASE
Month:=Month_Menu()
if month#0
       rashifrovka=0
       sum=0
       vozwrat=0
       rashifrovka:=GetVal("Требуемый номер расшифровки  ",0,-1)
       if Rashifrovka#-1
          do case
             case type_op==1
                     baza=schet_share+'o'+alltrim(str(month))+'.dbf'
                     str_op:="Оплата электроэнергии"
             case type_op==2
                     baza=schet_share+'p'+alltrim(str(month))+'.dbf'
                     str_op:="Оплата пени"
             case type_op==3
                     baza=schet_share+'h'+alltrim(str(month))+'.dbf'
                     str_op:="Оплата повышенной"
             case type_op==4
                     baza=schet_share+'a'+alltrim(str(month))+'.dbf'
                     str_op:="Оплата абонированной"
             otherwise
                     type_op=0
           endcase
           if type_op>0
                choice=vert_menu(spisok2,"Вывод расшифровки N"+alltrim(str(rashifrovka)),is_choice2,11+Type_Op+1,30,pos,'n/w,n/g,,,r/w',.F.)
                if choice#0.and.choice#4
                   work(24,0)
                   if choice=1
                      desc=fcreate(Ddir+'otchet.gkv')
                      fwrite(desc,str_op+chr(13)+chr(10))
                      fwrite(desc,'Расшифровка N'+alltrim(str(rashifrovka))+' за '+mesqc(month)+" месяц"+chr(13)+chr(10))
                      Fwrite(desc,'┌'+replicate('─',6)+'┬'+;
                      replicate('─',10)+'┬'+replicate('─',7)+'┬'+;
                      replicate('─',15)+'┬'+replicate('─',Len(Dtoc(New_date)))+'┐'+;
                      chr(13)+chr(10))

                      Fwrite(desc,'│'+'Лицев.'+'│'+;
                      'Вид.докум.'+'│'+'N док. '+'│'+;
                      ' Сумма оплаты  '+'│'+Center("Дата",Len(Dtoc(New_date))," ",.t.)+'│'+;
                      chr(13)+chr(10))

                      Fwrite(desc,'├'+replicate('─',6)+'┼'+;
                      replicate('─',10)+'┼'+replicate('─',7)+'┼'+;
                      replicate('─',15)+'┼'+replicate('─',Len(Dtoc(New_date)))+'┤'+;
                      chr(13)+chr(10))
                   endif
                   select 0
                   message(" Идет поиск оплат по номеру расшифровки ")
                   if superload(baza,,,.F.)
                      go top
                      if reccount()#0
                         DO WHILE .not.Eof()
                            IF Rashifrovka<10000.and.Rashifrovka==Reestr
                               if alltrim(vid_dokum)='о возврат'.or.;
                                  alltrim(vid_dokum)='о Возврат'.or.;
                                  alltrim(vid_dokum)='Возврат'
                                       sum=sum-summa
                                       vozwrat=vozwrat+summa
                               else
                                       sum=sum+summa
                               endif
                               if choice=1
                                       fwrite(desc,'│'+str(licevoj)+"│"+vid_dokum+'│'+num_dokum+'│'+str(summa,15,2)+'│'+dtoc(data)+'│'+chr(13)+chr(10))
                               endif
                            ELSE
//  Частный сектор расшифровка с номером больше 4-х знаков
                               IF Rashifrovka>10000
                                  IF Reestr ==Int(Rashifrovka/10).and.;
                                     Reestr2==(Rashifrovka-Val(AllTrim(Str( Int(Rashifrovka/10) ,5))+"0"))
                                     if alltrim(vid_dokum)='о возврат'.or.;
                                        alltrim(vid_dokum)='о Возврат'.or.;
                                        alltrim(vid_dokum)='Возврат'
                                             sum=sum-summa
                                             vozwrat=vozwrat+summa
                                     else
                                             sum=sum+summa
                                     endif
                                     if choice=1
                                             fwrite(desc,'│'+str(licevoj)+"│"+vid_dokum+'│'+num_dokum+'│'+str(summa,15,2)+'│'+dtoc(data)+'│'+chr(13)+chr(10))
                                     endif
                                  ENDIF
                               ENDIF
                            endif
                            skip
                         ENDDO
                      endif
                      use
                   endif   // от Superload
                   if choice=1
                      Fwrite(desc,'└'+replicate('─',6)+'┴'+;
                      replicate('─',10)+'┴'+replicate('─',7)+'┴'+;
                      replicate('─',15)+'┴'+replicate('─',Len(Dtoc(New_date)))+'┘'+;
                      chr(13)+chr(10))
                      if vozwrat#0
                              fwrite(desc,'Возвращено '+str(vozwrat)+chr(13)+chr(10))
                              fwrite(desc,'Всего      '+str(sum+vozwrat)+chr(13)+chr(10))
                      endif
                      fwrite(desc,'Итого      '+str(sum)+chr(13)+chr(10))
                      fclose(desc)
                      if sum=0
                              deletefile(Ddir+'otchet.gkv')
                      endif
                   endif
                endif
                restscreen(9,0,24,79,oldscr)
                if choice=2
                   if vozwrat=0
                      otchet:={str_op," По расшфровке N"+alltrim(str(rashifrovka))+;
                               " найдена сумма ",alltrim(str(sum))+"руб. "}
                   else
                      otchet:={str_op," По расшфровке N"+alltrim(str(rashifrovka))+;
                               " найдены следующие суммы:",;
                               "Всего      "+str(sum+vozwrat),;
                               "Возвращено "+str(vozwrat),;
                               "Итого      "+alltrim(str(sum)) }
                   endif
                   al_box(otchet)
                endif
         endif
        endif
endif
select(oldsel)
restscreen(9,0,24,79,oldscr)
setcolor(oldclr)
return




//---------------------------------------------------------------------------
STATIC Function MakeAllOpl
LOCAL Opl:="Opl.Dbf",High:="High.Dbf",Penq:="Penq.Dbf",DbfPath,Base,NameDbf
LOCAL NumReestr:={},NameIdx:=Ddir+'reestr.ntx',desc,temp_,kol_kl,First:=.T.
LOCAL Win:=obrabot("Поиск и сортировка всей оплаты"),CrLf:=chr(13)+chr(10)
LOCAL Itog1:=0,Itog2:=0,Itog3:=0,Itog4:=0,Itog10:=0,Itog11:=0,Itog12:=0
Month:=Month_Menu()
select 0
if netuse(schet_share+"oplata.dbf",.t.,,"alloplata")
   select alloplata
   zap
   temp_=39/3
   kol_kl=0
   For j=1 to 3
      Do Case
         Case j=1
              Base="O"
         Case j=2
              Base="P"
         Case j=3
              Base="H"
      EndCase
      kol_kl=kol_kl+temp_
      colorwin(12,21,12,21+kol_kl,'n/n')
      DbfPath:=Schet_share
      NameDbf:=DbfPath+Base+alltrim(str(month))+".Dbf"
      select 0
      if netuse(NameDbf,.f.,,"monopl")
         select monopl
         Do While !Eof()
            Select AllOplata
            Append Blank
            Replace vid_dokum with monopl->vid_dokum
            Replace num_dokum with monopl->num_dokum
            Replace licevoj   with monopl->licevoj
            Replace summa     with if(alltrim(monopl->vid_dokum)="о возврат",;
                                   -1*monopl->summa,monopl->summa)
            Replace data      with monopl->data
            Replace reestr    with monopl->reestr
            Replace type_opl  with J       // << тип оплаты >>
            Select monopl
            Skip
         Enddo
         select monopl
         Use
      else
         al_box({"В доступе к базе "+NameDbf+" отказано"})
      endif
   Next
   select alloplata
   set unique on
   index on reestr to &NameIdx
   go top
   do while !eof()
      aadd(NumReestr,reestr)
      skip
   enddo
   set unique off
   close index
   deletefile(NameIdx)
   go top
   win_rest(win)
   Message("Всего расшифровок найдено "+alltrim(str(len(NumReestr))))
   inkey(2)
   temp_=39/(3*len(NumReestr))
   kol_kl=0
   obrabot("Формирование списка расшифровок")
   desc:=fcreate(Ddir+"otchet.gkv")
   FOR i=1 TO Len(NumReestr)
       fwrite(desc,"Расшифровка N "+alltrim(str(NumReestr[i]))+crlf)
       FOR j=1 TO 3
           kol_kl=kol_kl+temp_
           colorwin(12,21,12,21+kol_kl,'n/n')
           GO Top
           First=.T.
           Itog1:=0
           DO WHILE !Eof()
              IF NumReestr[I]==reestr.and.Type_Opl==J
                 IF First                             // Запись шапки оплаты
                    DO CASE
                       CASE j=1
                            fwrite(desc,"Электроэнергия"+crlf)
                       CASE j=2
                            fwrite(desc,"Пеня"+crlf)
                       CASE j=3
                            fwrite(desc,"Повышенная"+crlf)
                    ENDCASE
                    First=.F.
                    Fwrite(desc,'┌'+replicate('─',6)+'┬'+;
                    replicate('─',10)+'┬'+replicate('─',7)+'┬'+;
                    replicate('─',15)+'┬'+replicate('─',Len(Dtoc(New_date)))+'┐'+CrLf)
                    Fwrite(desc,'│'+'Лицев.'+'│'+;
                    'Вид.докум.'+'│'+'N док. '+'│'+;
                    ' Сумма  оплаты '+'│'+Center('Дата',Len(Dtoc(New_date))," ",.t.)+'│'+CrLf)
                    Fwrite(desc,'├'+replicate('─',6)+'┼'+;
                    replicate('─',10)+'┼'+replicate('─',7)+'┼'+;
                    replicate('─',15)+'┼'+replicate('─',Len(Dtoc(New_date)))+'┤'+CrLf)
                 ENDIF
                 fwrite(desc,'│'+str(licevoj)+"│"+vid_dokum+'│'+num_dokum+;
                        '│'+str(summa)+'│'+dtoc(data)+'│'+CrLf)
                Itog1=Itog1+Summa
              ENDIF
              skip
           ENDDO
           IF .not.First        // Конец таблицы
              Fwrite(desc,'└'+replicate('─',6)+'┴'+;
              replicate('─',10)+'┴'+replicate('─',7)+'┴'+;
              replicate('─',15)+'┴'+replicate('─',Len(Dtoc(New_date)))+'┘'+CrLf+;
              "Всего "+alltrim(str(Itog1))+CrLf)
           ENDIF
           Itog2=Itog2+Itog1
           DO CASE
              CASE j=1
                   Itog10:=Itog1
              CASE j=2
                   Itog11:=Itog1
                   Itog3=Itog3+Itog1
              CASE j=3
                   Itog12:=Itog1
                   Itog4=Itog4+Itog1
           ENDCASE
       NEXT
   fwrite(desc,"Всего по расшифровке  "+str(Itog10+Itog11+Itog12,17,2)+CrLf+;
               "       Электроэнергия "+str(Itog10,17,2)+CrLf+;
               "                 Пеня "+str(Itog11,17,2)+CrLf+;
               "           Повышенная "+str(Itog12,17,2)+CrLf+CrLf)
   NEXT
   Fwrite(desc,replicate("-",80)+crlf)
   fwrite(desc,"Всего по расшифровкам "+str(Itog2,17,2)+CrLf+;
               "       Электроэнергия "+str(Itog2-Itog3-Itog4,17,2)+CrLf+;
               "                 Пеня "+str(Itog3,17,2)+CrLf+;
               "           Повышенная "+str(Itog4,17,2)+CrLf)
   fclose(desc)
   use
Else
   Al_Box({"В доступе отказано"})
EndIf
Return NIL
//---------------------------------------------------------------------------




STATIC Function MakeAllNum(mon)
LOCAL old_sel:=select(),old_rec:=recno(),win:=win_save()
LOCAL ind:=Ddir+"oplata.ntx",dbf
LOCAL Bank:={},Sum:={},Inc:=0,num,desc,CrLf:=chr(13)+chr(10)
Local oDlg,aSizeDeskTop,aPos,oProgress
Num:=GetVal("Требуемый номер расшифровки  ",0,-1)
IF Num==-1
   Return NIL
ENDIF

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Обработано" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
Dbf:=Schet_share+'o'+alltrim(str(int(mon)))+".dbf"
Select 0
//obrabot("Сортировка всех расшифровок")
IF netuse(dbf)
   set unique on
   index on reestr to &ind
   go top
//   temp_=39/(9900/100)
//   kol_kl=0
   FOR Inc=0 TO 9900 STEP 100                   // Выбор расшифровок
//       kol_kl=kol_kl+temp_
//       colorwin(12,21,12,21+kol_kl,'n/n')
       SEEK Inc+Num
       IF Found()
             aadd(Bank,REESTR)
       ENDIF
   NEXT
   set unique off
   close index
   index on reestr to &ind
   ASIZE(Sum,LEN(Bank))
//   obrabot("Расчет суммы по банкам")
//   temp_=39/LEN(Bank)
//   kol_kl=0
	 oProgress:maximum := LEN(Bank)
   FOR I=1 to LEN(Bank)
   	  oProgress:increment()																				// Progress Bar Increment
//       kol_kl=kol_kl+temp_
//       colorwin(12,21,12,21+kol_kl,'n/n')
       go top
       Sum[I]=0
       SEEK Bank[I]
       DO WHILE Reestr==Bank[i]
          IF Reestr==Bank[i]
             Sum[i]=Sum[i]+Summa
          ENDIF
          SKIP
       ENDDO
   NEXT
   USE
   DeleteFile(ind)
   desc:=fcreate(Ddir+"otchet.gkv")
   Fwrite(desc,"Расшифровка по банкам N"+alltrim(str(num))+crlf)
   Fwrite(desc,"┌"+replicate("─",20)+"┬"+replicate("─",17)+"╖"+crlf)
   inc=0
   select bank_kod
   FOR i=1 to LEN(Bank)
       seek Bank[i]-Num
       IF Found()
          fwrite(desc,"│"+Bank_Name+"│"+str(Sum[i],17,2)+"║"+crlf)
       ELSE
          fwrite(desc,"│ "+str(Bank[i],5,0)+" "+Replicate("?",13)+"│"+str(Sum[i],17,2)+"║"+crlf)
       ENDIF
       IF I!=Len(Bank)
          fwrite(desc,"├"+replicate("─",20)+"┼"+replicate("─",17)+"╢"+crlf)
       ENDIF
       inc=inc+Sum[i]
   NEXT
   fwrite(desc,"╘"+replicate("═",20)+"╧"+replicate("═",17)+"╝"+crlf)
   Fwrite(desc,"Всего банков    "+alltrim(str(len(Bank)))+crlf)
   fwrite(desc,"Итого по банкам "+str(Inc)+crlf)
   Fclose(desc)
endif
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
win_rest(win)
select(old_sel)
go old_rec
Return NIL






Function Kod_Bank()
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,name
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
if (.not. file(Schet_Share+'Bank_Kod.dbf'))
        sign(2)
        set color to (color_buf)
        restscreen(0,0,24,79,buff)
        return Nil
else
        if select()#100
                select 100
        endif
endif
endif
colorwin(6,0,21,79,'w/w')
set color to n/w
name='Справочник банков'
@ 6,(79-len(name))/2 say name
declare zgl[2]
declare fil[2]
nm1=loarr('zgl','Kод банка',"Название банка")
nm2=loarr('fil','Bank_Kod',"Bank_Name")
inp='10'
go top
******* Begin make box
t1=7
l1=1
b1=20
r1=78
******** End make box
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
return NIL
*********************************





STATIC Function MakeAllDay()
LOCAL old_sel:=select(),old_rec:=recno(),win:=win_save(),color:=setcolor()
LOCAL ind:=Ddir+"opl.ntx",dbf:=Ddir+"opl.dbf",tmp_dbf,_temp_
LOCAL Inc:=0,Snum:=0,Enum:=0,desc,CrLf:=chr(13)+chr(10)
LOCAL PNum:={},HNum:={},Sum:={},Bank:={},ANum:={},Inc4:=0,aCount:={},nCount:=0
Local oDlg,aSizeDeskTop,aPos,oProgress
Mon:=Month_Menu("для выбора оплаты")
set color to &GetColor
colorwin(12,20,15,60,'n+/n')
@ 11,19 say "┌──────────────────────────────────────╖"
@ 12,19 say "│  Номер начальной расшифровки         ║"
@ 13,19 say "│  Номер конечной  расшифровки         ║"
@ 14,19 say "╘══════════════════════════════════════╝"
set cursor on
set confir on
@ 12,52 get SNum picture "@K 9999"
@ 13,52 get ENum picture "@K 9999"
read
set cursor off
set confir off
setcolor(color)
win_rest(win)
IF LastKey()==27
   Clear Typeahead
   Return NIL
ENDIF
Clear Typeahead
Select 0
//obrabot("Сортировка всех расшифровок")

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:Title    := "Сортировка расшифровок"
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
IF netuse(dbf,.t.,,"El_En")
   zap
//   _temp_=39/4
//   kol_kl=0
   FOR I=1 TO 4
       DO CASE
          CASE I=1
               tmp_dbf:=schet_share+"o"+alltrim(str(mon))+".dbf"
          CASE I=2
               tmp_dbf:=schet_share+"p"+alltrim(str(mon))+".dbf"
          CASE I=3
               tmp_dbf:=schet_share+"h"+alltrim(str(mon))+".dbf"
          CASE I=4
               tmp_dbf:=schet_share+"a"+alltrim(str(mon))+".dbf"
       ENDCASE
       SELECT 0
       IF NETUSE(Tmp_Dbf,,,"temp_base")
//          temp_=_temp_/reccount()
          Go Top
          DO WHILE !Eof()
//             kol_kl=kol_kl+temp_
//             colorwin(12,21,12,21+kol_kl,'n/n')
             SELECT El_En
             APPEND BLANK
             REPLACE type with I
             REPLACE vid_dokum WITH temp_base->vid_dokum
             REPLACE num_dokum WITH temp_base->num_dokum
             REPLACE licevoj WITH temp_base->licevoj
             REPLACE summa WITH temp_base->summa
             REPLACE data WITH temp_base->data
             REPLACE reestr WITH temp_base->reestr
             SELECT Temp_Base
             SKIP
          ENDDO
          Select Temp_Base
          Use
       ENDIF
       SELECT El_En
   NEXT
   set unique on
   index on reestr to &ind
   go top
	 oProgress:maximum := (ENum+1-SNum)
//   temp_=39/(ENum+1-SNum)
//   kol_kl=0
//   obrabot("Выбор расшифровок")
//	 oDlg:setTitle("Сортировка расшифровок")
   FOR Inc=SNum TO ENum                   // Выбор расшифровок
   	  oProgress:increment()																				// Progress Bar Increment
//       kol_kl=kol_kl+temp_
//       colorwin(12,21,12,21+kol_kl,'n/n')
       SEEK Inc
       IF Found()
             aadd(Bank,REESTR)
       ENDIF
   NEXT
   set unique off
   close index
   index on reestr to &ind
   ASIZE(Sum,LEN(Bank))
   ASIZE(PNum,LEN(Bank))
   ASIZE(HNum,LEN(Bank))
   ASIZE(ANum,LEN(Bank))
   ASize(aCount,Len(Bank))
   oProgress:destroy()																							// Progress Bar Destroy
	 oDlg:SetTitle("Расчет поступивших оплат по  расшфровкам с "+AllTrim(Str(SNum,4))+" по "+AllTrim(Str(ENum,4))+" за "+Mesqc(Mon))
//   obrabot("Расчет суммы по банкам")
//   temp_=39/LEN(Bank)
//   kol_kl=0
	 oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
	 oProgress:create()
	 oProgress:minimum := 1
	 oProgress:maximum := LEN(Bank)
   FOR I=1 to LEN(Bank)
   	  oProgress:increment()																				// Progress Bar Increment
//       kol_kl=kol_kl+temp_
//       colorwin(12,21,12,21+kol_kl,'n/n')
       go top
       Sum[I]=0; PNum[I]=0; HNum[I]=0; ANum[I]:=0; aCount[i]:=0
       SEEK Bank[I]
       DO WHILE Reestr==Bank[i]
          IF Reestr==Bank[i]
             DO CASE
                CASE Type==1
                     Sum[i]=Sum[i]+Summa
                CASE Type==2
                     PNum[i]=PNum[i]+Summa
                CASE Type==3
                     HNum[i]=HNum[i]+Summa
                CASE Type==4
                     ANum[i]=ANum[i]+Summa
             ENDCASE
             aCount[i]:=aCount[i]+1
          ENDIF
          SKIP
       ENDDO
   NEXT
   zap
   USE
   DeleteFile(ind)
   desc:=fcreate(Ddir+"otchet.gkv")
   Fwrite(desc,"Расшифровки с N"+alltrim(str(Snum))+" по N"+alltrim(str(Enum))+" за "+Mesqc(Mon)+" месяц"+crlf)
   Fwrite(desc,"┌"+replicate("─",4)+"┬"+replicate("─",16)+"┬"+replicate("─",14)+"┬"+replicate("─",14)+"┬"+replicate("─",13)+"┬"+replicate("─",14)+"╖"+crlf)
   fwrite(desc,"│ NN │ Электроэнергия │    Пеня      │  Повышенная  │Абонированная│     Итого    ║"+crlf)
   Fwrite(desc,"├"+replicate("─",4)+"┼"+replicate("─",16)+"┼"+replicate("─",14)+"┼"+replicate("─",14)+"┼"+replicate("─",13)+"┼"+replicate("─",14)+"╢"+crlf)
   inc=0;  inc2:=0; inc3:=0
   select bank_kod
//   obrabot("Запись полученных данных")
//   temp_=39/LEN(Bank)
//   kol_kl=0
   FOR i=1 to LEN(Bank)
//       kol_kl=kol_kl+temp_
//       colorwin(12,21,12,21+kol_kl,'n/n')
       fwrite(desc,"│"+str(Bank[i],4,0)+"│"+str(Sum[i],16,2)+"│"+str(PNum[i],14,2)+"│"+str(HNum[i],14,2)+"│"+str(ANum[i],13,2)+"│"+str(+Sum[i]+ANum[i]+PNum[i]+HNum[i],14,2)+"║"+Str(aCount[i],3,0)+crlf)
       IF I!=Len(Bank)
          Fwrite(desc,"├"+replicate("─",4)+"┼"+replicate("─",16)+"┼"+replicate("─",14)+"┼"+replicate("─",14)+"┼"+replicate("─",13)+"┼"+replicate("─",14)+"╢"+crlf)
       ENDIF
       nCount:=nCount+aCount[i]
       inc=inc+Sum[i]
       inc2:=inc2+PNum[i]
       inc3:=inc3+HNum[i]
       inc4:=Inc4+ANum[i]
   NEXT
   Fwrite(desc,"╘"+replicate("═",4)+"╧"+replicate("═",16)+"╧"+replicate("═",14)+"╧"+replicate("═",14)+"╧"+replicate("═",13)+"╧"+replicate("═",14)+"╝"+crlf)
   Fwrite(desc,"Всего расшифровок     "+alltrim(str(len(Bank)))+"    квитанций     "+str(nCount,17,0)+crlf)
   fwrite(desc,"Итого по расшифровкам Элекроэнергия "+str(Inc,17,2)+CrLf)
   Fwrite(desc,"                      Пеня          "+str(Inc2,17,2)+CrLf)
   Fwrite(desc,"                      Повышенная    "+str(Inc3,17,2)+crlf)
   Fwrite(desc,"                      Абонированная "+str(Inc4,17,2)+crlf)
   Fwrite(desc,"                      Итого         "+str(Inc+Inc2+Inc3+Inc4,17,2)+CrLf)
   Fclose(desc)
endif
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
win_rest(win)
select(old_sel)
go old_rec
Return NIL




STATIC Function MakeOneOpl(Mon)
LOCAL Sel:=Select(),Rec:=Recno(),Win:=Win_Save(),Clr:=SetColor(),Writed:=.F.
LOCAL Desc,String:="",Itog:=0,CrLf:=Chr(13)+Chr(10),TmpStr:="",Kol_Kl:=0
Local oDlg,aSizeDeskTop,aPos,oProgress,cInd:=""
IF Mon==0
   Return NIL
ENDIF

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := oMainWindow:currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Обработано" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := 4
	
Desc:=Fcreate(DDir+ReportFIle)

Fwrite(Desc,"Сбор поступивших оплат за "+Mesqc(Mon)+" "+Alltrim(Str(Year(New_date)))+"г."+CrLf)
FWrite(Desc,"Л/с "+Alltrim(Str(Main->Lic_Schet))+" "+AllTrim(Delstring(Main->Potrebitel,"ИНН"))+CrLf)
//Obrabot("Расчет оплаты по потребителю")
FOR I=1 To 4
   	  oProgress:increment()																				// Progress Bar Increment
//    Kol_Kl=Kol_Kl+39/4
//    ColorWin(12,21,12,21+Kol_Kl,'n/n')
    Itog:=0
    TmpStr:="┌"+Replicate("─",Len(Dtoc(New_date)))+"┬"+Replicate("─",14)+"┬"+Replicate("─",4)+"┬"+Replicate("─",7)+"┐"+CrLf
    TmpStr:=TmpStr+"│"+Center("Дата",Len(Dtoc(New_date))," ",.t.)+"│"+Center("Сумма",14," ",.t.)+"│Реес│"+Center("N док",7," ",.t.)+"│"+CrLf
    TmpStr:=TmpStr+"├"+Replicate("─",Len(Dtoc(New_date)))+"┼"+Replicate("─",14)+"┼"+Replicate("─",4)+"┼"+Replicate("─",7)+"┤"+CrLf
    DO CASE
       Case I==1
            TmpStr:="Оплата за эл.энергию"+CrLf+TmpStr
            String:=Schet_Share+"O"+Alltrim(Str(Mon))+".dbf"
            cInd  :=Schet_Share+"O"+Alltrim(Str(Mon))+".ntx"
       Case I==2
            TmpStr:="Оплата пени"+CrLf+TmpStr
            String:=Schet_Share+"P"+Alltrim(Str(Mon))+".dbf"
            cInd  :=Schet_Share+"P"+Alltrim(Str(Mon))+".ntx"
       Case I==3
            TmpStr:="Оплата повышенной"+CrLf+TmpStr
            String:=Schet_Share+"H"+Alltrim(Str(Mon))+".dbf"
            cInd  :=Schet_Share+"H"+Alltrim(Str(Mon))+".ntx"
       Case I==4
            TmpStr:="Оплата абонированной"+CrLf+TmpStr
            String:=Schet_Share+"A"+Alltrim(Str(Mon))+".dbf"
            cInd  :=Schet_Share+"A"+Alltrim(Str(Mon))+".ntx"
    ENDCASE
    Writed:=.F.
    Select 0
    IF NetUse(String,,40)
    	 Set Index to &cInd
       Seek Main->Lic_Schet
       DO While Licevoj==Main->Lic_Schet
          IF Licevoj==Main->Lic_Schet
             IF .not.Writed
                FWrite(Desc,TmpStr)
                Writed:=.T.
             ENDIF
             Fwrite(Desc,"│"+Dtoc(Data)+"│"+Str(Summa,14,2)+"│"+Str(Reestr,4,0)+"│"+Num_Dokum+"│"+CrLf)
             Itog:=Itog+Summa
          ENDIF
          Skip
       EndDo
       IF Writed
          Fwrite(Desc,"└"+Replicate("─",Len(Dtoc(New_date)))+"┴"+Replicate("─",14)+"┴"+Replicate("─",4)+"┴"+Replicate("─",7)+"┘"+CrLf)
          Fwrite(Desc,"Всего "+Alltrim(Str(Itog,15,2))+CrLf)
       ENDIF
       Use
    ENDIF
NEXT
FClose(Desc)
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
SetColor(Clr); Win_Rest(Win)
Select(Sel);   Go rec
Return NIL
