FUNCTION filelist(maska,path,color,left,right)
Local i,old_screen:=win_save(0,0,maxrow(),maxcol()),old_color:=setcolor(),;
      start_row:=row(), start_col:=col(), flist:={},;
      top, bottom, my_dir:=diskname()+":"+dirname(), exit_dir, exit_file:=''
left:=int(if(left==NIL,maxcol()/2-12,left))
right:=int(if(right==NIL,left+24,right))
maska:=if(maska==NIL,"*.*",maska)
color:=if(color==NIL,"w+/b,n/w",color)
path :=if(path==NIL,my_dir,path)
dirchange(path)
Do While .T.
   FList:=Directory(maska,"D")
   top:=int(if(len(Flist)>maxrow()-1,1, maxrow()/2-len(Flist)/2))
   bottom:=int(if(len(Flist)>maxrow()-1,maxrow()-2, maxrow()/2+len(Flist)/2+1))
   bottom:=if(bottom+1>=maxrow(),bottom-1,bottom)
//   top:=if(len(Flist)>14,maxrow()/2-7, maxrow()/2-len(Flist)/2)
//   bottom:=if(len(Flist)>14,maxrow()/2+7, maxrow()/2+len(Flist)/2+1)
   For i:=1 to Len(FList)
       FList[i]:=if(FList[i,5]#"D",chr(255)+lower(FList[i,1]),;
                chr(32)+FList[i,1])
                
   next
   SetColor(color)
   colorwin(top+1,left+1,bottom+1,right+1,'n+/n')
   @ top, left, bottom, right BOX "ÚÄ·º¼ÍÔ³ "
   asort(Flist)
   IF Len(Flist)#0
//         sb_attach(top, left+24, bottom,len(Flist))
           sb_attach(top, right, bottom,len(Flist))
           i:=aChoice(top+1, left+1, bottom-1, right-1, FList, .T., 'handle_sb')
           sb_detach()
           IF i#0
                   IF substr(FList[i],1,1)==chr(32)
                        dirchange(alltrim(FList[i]))
                   ELSE
                        exit_dir:=diskname()+":"+dirname()
                        exit
                   ENDIF
           ELSE
                exit_dir:=diskname()+":"+dirname()
                exit
           ENDIF
   ENDIF
   win_rest(old_screen)
Enddo
dirchange(my_dir)
exit_file:=If(i==0, '',;
        if(substr(alltrim(exit_dir),-1)#'\',;
         MYupper(exit_dir+'\'+Alltrim(substr(Flist[i],2))),;
         MYupper(exit_dir+Alltrim(substr(Flist[i],2)))))
Flist={}
win_rest(old_screen)
setcolor(old_color)
@ start_row, start_col say ""
RETURN exit_file



* ”ã­ªæ¨ï ¯à®à¨á®¢ª¨ ¢¥àâ¨ª «ì­®£® ¬¥­î
function vert_menu(spisok,say_string,is_choice,top,left,pos,color,is_save)
local len:=0,bottom,right,old_clr:=setcolor(),scr,my_choice,tmpclr
spisok:=if(spisok==NIL,{},spisok)
say_string:=if(say_string==NIL,"",say_string)
is_choice:=if(is_choice==NIL,.T.,is_choice)
top:=if(top==NIL,row(),top)
left:=if(left==NIL,col(),left)
pos:=if(pos==NIL,1,pos)
color:=if(color==NIL,setcolor(),color)
is_save:=if(is_save==NIL,.T.,is_save)
for i=1 to len(spisok)
    len=if(len(spisok[i])>len,len(spisok[i]),len)
next
len=len+2
bottom:=top+1+if(top+1+len(spisok)<=23,len(spisok),23)
right:=left+len
if is_save
           scr=win_save(top,left,bottom+1,right+1)
endif
colorwin(top+1,left+1,bottom+1,right+1,'n+/n')
setcolor(color)
@ top, left, bottom, right BOX "ÚÄ·º¼ÍÔ³ "
say_string=substr(' '+alltrim(say_string)+' ',1,(right-left-2))
say_string=center(say_string,(right-left-2),chr(196),.T.)
@ top, left+1 say say_string
sb_attach(top, right, bottom,len(spisok))
Keyboard Chr(32)
my_choice:=aChoice(top+1, left+1, bottom-1, right-1, spisok, is_choice, 'handle_sb',pos)
sb_detach()
IF my_choice>0
   tmpclr:=substr(color,5,3)
   setcolor(tmpclr)
   @ row(),col()-Len(spisok[my_choice]) say spisok[my_choice]+space(len-len(spisok[my_choice])-1)
ENDIF
setcolor(old_clr)
if is_save
           win_rest(scr)
endif
Clear Typeahead
return my_choice
