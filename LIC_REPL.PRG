function lic_replace
Local MyOldSel,Poisk:="",NameInd:=""
private prev_sel,prev_rec,prev_ord,prev_scr,prev_col,mold_lic,mnew_lic,pos1,;
        new_kod,i,kol_kl,temp_
prev_sel=select()
prev_rec=recno()
prev_ord=indexord()
save screen to prev_scr
prev_col=setcolor()
mold_lic=0
mnew_lic=0
mold_lic=main->lic_schet
mnew_lic=main->lic_schet

set color to n/w,n/g
colorwin(12,16,14,63,'n/n')
set cursor on
set confirm on
@ 11,15,13,62 box "         "
@ 11,15 say "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캠"
@ 12,15 say "� 닱Д�ⓥ� エ璵¡� 淞β N        췅 N          �"
@ 13,15 say "突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠"
@ 12,40 say mold_lic
@ 12,52 GET mnew_lic picture "@K 999999"
read
set cursor off
set confirm off
IF LastKey()#27
   Seek mNew_Lic
   IF Found()
      Al_Box({"떒璵¡� 淞β "+AllTrim(Str(mNew_Lic,6))+" 拾� 率耀飡㏂β"})
      Go Prev_Rec
   ELSE
      Go Prev_Rec
        IF Mold_Lic#mNew_Lic
                obrabot('닱Д�禎 エ璵¡� 淞β '+alltrim(str(mold_lic))+' 췅 '+alltrim(str(mnew_lic)))
                temp_=39/29
                kol_kl=0
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                select main
                if reclock(0)
                   replace lic_schet with M->mnew_lic
                   unlock
                endif

                Select FNSI
                Seek M->mOld_Lic
                IF Found()
                      IF RecLock()
                         Replace KA With M->mNew_Lic
                         UNLOCK
                      ENDIF

                   Select FOSN
                   Seek M->mOld_Lic
                   IF Found()
                      DO While KA==M->mOld_Lic
                         IF RecLock()
                            Replace KA With M->mNew_Lic
                            Replace KOD With '('+alltrim(str(M->mNew_lic))+')'+alltrim(FOSN->schetchik)
                            UNLOCK
                         ENDIF
                         SKIP
                      ENDDO
                   ENDIF

                   Select FYEAR
                   Seek M->mOld_Lic
                   IF Found()
                      DO While KA==M->mOld_Lic
                         IF RecLock()
                            Replace KA With M->mNew_Lic
                            UNLOCK
                         ENDIF
                         SKIP
                      ENDDO
                   ENDIF

                   Select COPL
                   Go Top
                   Do While .not.EOF()
                      IF Lic==M->mOld_Lic
                         Replace Lic With M->mNew_Lic
                      ENDIF
                      SKIP
                   ENDDO
                ENDIF

                select licevoj
                set filter to
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                nextRec=1
                go nextRec
                do while !eof()
                        if licevoj->lic_sch=M->mold_lic
                           MyOldSel:=Select()
                           Select Licevoj
                           FOR i=1 To 13  //  묊β葉え
                               Select(i)
                               Go TOp
                               Poisk:='('+alltrim(str(M->mOld_lic))+')'+alltrim(licevoj->schetchik)
                               Seek Poisk
                               IF Found()
                                  IF RecLock()
                                     Poisk:='('+alltrim(str(M->mNew_lic))+')'+alltrim(licevoj->schetchik)
                                     Replace Licevoj With M->mNew_Lic
                                     Replace Kod With Poisk
                                     UNLOCK
                                  ENDIF
                               ENDIF
                           Next
                           Select Plomba        // 룶�Аⓣ�˚�
                           Poisk:='('+alltrim(str(M->mOld_lic))+')'+alltrim(licevoj->schetchik)
                           Seek Poisk
                           IF Found()
                              Do While AllTrim(Kod)=AllTrim(Poisk)
                                 IF RecLOck()
                                    Replace Licevoj With M->mNew_Lic
                                    Replace KOD With '('+alltrim(str(M->mNew_lic))+')'+alltrim(licevoj->schetchik)
                                    UNLOCK
                                 ENDIF
                                 SKIP
                              ENDDO
                           ENDIF

                           Select Lose //룼收黍 � エ�Ŀ
                           Poisk:='('+alltrim(str(M->mOld_lic))+')'+alltrim(licevoj->schetchik)
                           seek Poisk
                           IF Found()
                              IF Reclock(0)
                                 Replace Licevoj With M->mNew_Lic
                                 replace kod with '('+alltrim(str(M->mNew_lic))+')'+alltrim(licevoj->schetchik)
                                 unlock
                              ENDIF
                           ENDIF

                           Select LoseTran //룼收黍 � 循젺宋�席졻�誓
                           Poisk:='('+alltrim(str(M->mOld_lic))+')'+alltrim(licevoj->schetchik)
                           seek Poisk
                           IF Found()
                              IF Reclock(0)
                                 Replace Licevoj With M->mNew_Lic
                                 replace kod with '('+alltrim(str(M->mNew_lic))+')'+alltrim(licevoj->schetchik)
                                 unlock
                              ENDIF
                           ENDIF

                           Select Licevoj
                           IF reclock(0)
                              replace lic_sch with M->mnew_lic
                              unlock
                           ENDIF
                           Select(MyOldSel)
                        endif
                        nextRec=nextRec+1
                        go nextRec
                enddo
                select 33
                go top
                locate for lic_schet=mold_lic
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if found()
                   if reclock(0)
                      replace lic_schet with mnew_lic
                      unlock
                   endif
                endif
                select 15
                go top
                locate for lic_schet=mold_lic
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if found()
                   if reclock(0)
                      replace lic_schet with mnew_lic
                      unlock
                   endif
                endif
                select 99
                nextRec=1
                go nextRec
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                do while !eof()
                        if licevoj=mold_lic
                           if reclock(0)
                              replace licevoj with mnew_lic
                              unlock
                           endif
                        endif
                        nextRec=nextRec+1
                        go nextRec
                enddo
                for i=1 to 12
                    select 0
                    for j=1 to 3
                        do case
                           case j=1
                                   tmp=Schet_Share+'o'+alltrim(str(int(i)))+".dbf"
                                   NameInd:=Schet_Share+'o'+alltrim(str(int(i)))+".Ntx"
                           case j=2
                                   tmp=Schet_Share+'p'+alltrim(str(int(i)))+".dbf"
                                   NameInd:=Schet_Share+'p'+alltrim(str(int(i)))+".Ntx"
                           case j=3
                                   tmp=Schet_Share+'h'+alltrim(str(int(i)))+".dbf"
                                   NameInd:=Schet_Share+'h'+alltrim(str(int(i)))+".Ntx"
                        endcase
                        IF NetUse(Tmp,.F.)
                           Set Index to &NameInd
//                         use &tmp SHARED
                           nextRec=1
                           go nextRec
                           do while !eof()
                              if licevoj=mold_lic
                                 if reclock(0)
                                    replace licevoj with mnew_lic
                                    unlock
                                 endif
                              endif
                              nextRec=nextRec+1
                              go nextRec
                           enddo
                           use
                        ENDIF
                    next
                    kol_kl=kol_kl+temp_
                    colorwin(12,21,12,21+kol_kl,'n/n')
                next
                colorwin(12,21,12,21+39,'n/n')
        else
                al_box({"뜢¡㎚�┃� �㎚��ⓥ� エ璵¡� 淞β �젹 췅 醒∽"})
        endif
   ENDIF
else
        al_box({'떒璵¡� 淞β �� �㎚����'})
endif
Clear Typeahead
ClearBuffer()
prev_rec=-1
select(prev_sel)
set order to prev_ord
seek mnew_lic
restore screen from prev_scr
setcolor(prev_col)
ret_val=2
return .t.



FUNCTION ReplaceSchet()
LOCAL Sel:=Select(),Rec:=Recno(),Scr:=Win_Save(),MonBase,OldName,Poisk,LRec
LOCAL OldNum,OldOrd
obrabot("닱Д����� ��Д�� 淞β葉첓")
temp_=39/14
kol_kl=0
LRec:=licevoj2->recno
IF .not.empty(licevoj2->recno)
   select Licevoj
   go Lrec
   OldName:=Schetchik
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
//   Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(OldName)
   FOR MonBase=1 TO 13
       kol_kl=kol_kl+temp_
       colorwin(12,21,12,21+kol_kl,'n/n')
       select(MonBase)
       Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(OldName)
       seek Poisk
       IF found()
          Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(Licevoj2->schetchik)
          IF Reclock(0)
             replace kod with Poisk
             replace num_of_sch with licevoj2->schetchik
             unlock
          ENDIF
       ENDIF
   NEXT
//   Select Plomba        // 룶�Аⓣ�˚�
//   Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(OldName)
//   Seek Poisk
//   IF Found()
//      Do While AllTrim(Kod)=AllTrim(Poisk)
//         IF RecLOck()
//            Replace KOD With '('+alltrim(str(main->lic_schet))+')'+alltrim(Licevoj2->schetchik)
//            UNLOCK
//         ENDIF
//         SKIP
//      ENDDO
//   ENDIF

   Select 42
   OldOrd:=IndexOrd()
   Set Order To 1
   go top
   Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(OldName)
   seek Poisk
   IF Found()
      DO While KOD=='('+alltrim(str(main->lic_schet))+')'+alltrim(OldName)
         IF RECLOCK(0)
            REPLACE Kod WITH '('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj2->schetchik)
            UNLOCK
         ENDIF
         SKIP
      ENDDO
   ENDIF
   Set Order To OldOrd

   Select Lose
   Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(OldName)
   seek Poisk
   IF Found()
      Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(Licevoj2->schetchik)
      IF Reclock(0)
         replace kod with Poisk
         unlock
      ENDIF
   ENDIF

   Select LoseTran
   Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(OldName)
   seek Poisk
   IF Found()
      Poisk:='('+alltrim(str(main->lic_schet))+')'+alltrim(Licevoj2->schetchik)
      IF Reclock(0)
         replace kod with Poisk
         unlock
      ENDIF
   ENDIF
ELSE
  IF Al_Box({"뜮Д� 淞β葉첓 �㎚��ⓥ� ��レ㏆"},2,{" 뱾젷ⓥ� "," 뤲�ㄾウⓥ� "})==1
     select(sel)
     go rec
     F8()
  ELSE
     select licevoj
     go licevoj2->recno
     OldNum:=Schetchik
     select licevoj2
     replace schetchik with OldNum
  ENDIF
ENDIF
win_rest(scr)
select(sel)
go rec
RETURN NIL
