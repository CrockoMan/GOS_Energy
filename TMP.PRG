proc first
set color to n/w
?? delstring("1234567890Костя1234567890","Костя")
set color to
?
set color to n/w
?? delstring("1234567890Костя1234567890","Костя",.f.)
set color to
return

function delstring(string1,string2,is_all)
LOCAL ret_string:=string1,len,
is_all:=if(is_all==NIL,.T.,is_all)
len1=len(string1)
len2=len(string2)
for i=1 to len1
    if substr(string1,i,len2)=string2
       if is_all
          ret_string=substr(string1,1,i-1)
       else
          ret_string=substr(string1,1,i-1)
          ret_string=ret_string+substr(string1,i+len2)
       endif
       exit
    endif
next
return ret_string
