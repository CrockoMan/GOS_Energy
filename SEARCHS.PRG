function All_search()
LOCAL old_col1:=setcolor(),screen:=win_save(),fi:='',wid:=1,widsav:=1
LOCAL temptime:={},timecreate:={},spisok,pos:=1,sel:=select(),Is_Choice:={}
local first:=.T.,IsExit:=.F.
spisok:={" èÆ ≠Æ¨•‡„ ·Á•‚Á®™†    ",;
         " èÆ ‡†·Á•‚≠Æ¨„ ·Á•‚„       ",;
         " èÆ ≠Æ¨•‡„ ‚•´•‰Æ≠†    ",;
         " èÆ †§‡•·„             ",;
         "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ",;
         " ÇÎÂÆ§                 "}
ASize(Is_Choice,Len(Spisok))
AFill(Is_Choice,.t.)
Is_Choice[Len(Spisok)-1]:=.F.
do while pos>0
        choice=vert_menu(spisok,"Ç®§ ØÆ®·™†",is_choice,11,28,pos,'n/w,n/g,,,r/w',.F.)
        pos=choice
        wid=choice
        widsav:=wid
        do case
           case wid=1
                if search_()
                   pos:=0
                   exit
                endif
           case wid=2
                if FoundSchet()
                   pos:=0
                   exit
                endif
           case wid=3
                if FoundPhone()
                   pos:=0
                   exit
                endif
           case wid=4
                if FoundAdress()
                   pos:=0
                   exit
                endif
           otherwise
                   IsExit:=.T.
                   exit
        endcase
enddo
IF Pos==0.and.IsExit==.F.
   Win_Rest(Screen)
   MessageBox({AllTrim(Main->Potrebitel)})
   inkey(1)
   Win_Rest(Screen)
ENDIF
M->prev_rec=-1
win_rest(screen)
setcolor(old_col1)
return NIL



function FoundPhone()
LOCAL IsFound:=.F.,Scr:=Win_Save(),Clr:=setcolor(),old_rec,Num_Off:=space(9)
LOCAL LicFou:=main->lic_schet
colorwin(7,20,9,57,'n+/n')
set color to "n/w"
@ 06,19 say " ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ∑ "
@ 07,19 say " ≥ í‡•°„ÓÈ®©·Ô ≠Æ¨•‡                 ∫ "
@ 08,19 say " ‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº "
set color to &GetColor
@ 07,45 get Num_off picture "@K"
set curs on
read
set curs off
if lastkey()==27
   Clear Typeahead
   Win_Rest(Scr)
   return .f.
endif
obrabot("èÆ®·™ †°Æ≠•≠‚† · ‚•´•‰Æ≠Æ¨ "+Num_Off)
Num_Off:=val(charrem("-/\()",Alltrim(Num_Off)))
select licevoj
old_rec:=recno()
go top
temp_=39/reccount()
kol_kl=0
do while !eof()
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
   if val(charrem("-\/()",alltrim(Telefon)))==Num_Off
      IsFound:=.T.
      Lic_Fou:=Lic_Sch
      exit
   endif
   skip
enddo
go old_rec
select main
If IsFound
   seek lic_fou
ELSE
   MessageBox({"ç• ≠†©§•≠Æ "+Num_Off})
   inkey(0.6)
Endif
Win_Rest(Scr)
return IsFound



function FoundSchet()
LOCAL IsFound:=.F.,Scr:=Win_Save(),Clr:=setcolor(),old_rec,Num_Off:=space(9)
LOCAL LicFou:=main->lic_schet,tSchet:=Space(20)
tSchet:=GetVal("í‡•°„ÓÈ®©·Ô ‡†·Á•‚≠Î© ·Á•‚",Space(20),"")
tSchet:=AllTrim(tSchet)
IF Len(tSchet)==0
   Win_Rest(Scr)
   Return .F.
ENDIF
obrabot("èÆ®·™ ‡†·Á•‚≠Æ£Æ ·Á•‚† "+tSchet)
select licevoj
old_rec:=recno()
go top
temp_=39/reccount()
kol_kl=0
do while !eof()
   kol_kl=kol_kl+temp_
   colorwin(12,21,12,21+kol_kl,'n/n')
   if ATNUM(tSchet,R_SCHET)!=0
      IsFound:=.T.
      Lic_Fou:=Lic_Sch
      exit
   endif
   skip
enddo
go old_rec
select main
If IsFound
   seek lic_fou
ELSE
   MessageBox({"ç• ≠†©§•≠Æ "+tSchet})
   inkey(0.6)
Endif
Win_Rest(Scr)
return IsFound




function FoundAdress()
RETURN NIL
