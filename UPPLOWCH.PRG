//         Функции, заменяющие UPPER, LOWER, ISUPPER, ISLOWER, но
//           работающие и с кириллицей.


function rupper(string)
LOCAL i,outstring:=""
for i=1 to len(string)
        do case
                case asc(substr(string,i,1))>96.and.asc(substr(string,i,1))<123
                        outstring:=outstring+chr(asc(substr(string,i,1))-32)
                case asc(substr(string,i,1))>159.and.asc(substr(string,i,1))<176
                        outstring:=outstring+chr(asc(substr(string,i,1))-32)
                case asc(substr(string,i,1))>223.and.asc(substr(string,i,1))<240
                        outstring:=outstring+chr(asc(substr(string,i,1))-80)
                otherwise
                        outstring:=outstring+substr(string,i,1)
        endcase
next
return outstring


function rlower(string)
LOCAL i,outstring:=""
for i=1 to len(string)
        do case
                case asc(substr(string,i,1))>96-32.and.asc(substr(string,i,1))<123-32
                        outstring:=outstring+chr(asc(substr(string,i,1))+32)
                case asc(substr(string,i,1))>159-32.and.asc(substr(string,i,1))<176-32
                        outstring:=outstring+chr(asc(substr(string,i,1))+32)
                case asc(substr(string,i,1))>223-80.and.asc(substr(string,i,1))<240-80
                        outstring:=outstring+chr(asc(substr(string,i,1))+80)
                otherwise
                        outstring:=outstring+substr(string,i,1)
        endcase
next
return outstring


function risupper(string)
local risupper:=.F.
do case
        case asc(substr(string,i,1))>96-32.and.asc(substr(string,i,1))<123-32
                risupper:=.t.
        case asc(substr(string,i,1))>159-32.and.asc(substr(string,i,1))<176-32
                risupper:=.t.
        case asc(substr(string,i,1))>223-80.and.asc(substr(string,i,1))<240-80
                risupper:=.t.
        otherwise
                risupper:=.F.
endcase
return risupper


function rislower(string)
local risulower:=.F.
do case
        case asc(substr(string,i,1))>96.and.asc(substr(string,i,1))<123
                rislower:=.t.
        case asc(substr(string,i,1))>159.and.asc(substr(string,i,1))<176
                rislower:=.t.
        case asc(substr(string,i,1))>223.and.asc(substr(string,i,1))<240
                rislower:=.t.
        otherwise
                rislower:=.F.
endcase
return rislower