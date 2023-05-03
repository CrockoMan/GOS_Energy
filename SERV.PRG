function ServPrint
clear screen
NetPort:=2
IF Nnetcapbeg(NetPort)
   IF Nnetsetq(NetPort,"Stack1")
      IF NNetCapSsf(2,,.F.)
      @ 1,0 say NNetCapAct(2)
         IsNetPrint:=.T.
      ELSE
         Al_Box({"Ошибка установки режима сетевого принтера","Печать производится на локальный принтер"})
         return nil
      ENDIF
   ELSE
      Al_Box({"Ошибка инициализации очереди сетевого принтера","Печать производится на локальный принтер"})
      return nil
   ENDIF
ELSE
   Al_Box({"Ошибка захвата сетевого принтера","Печать производится на локальный принтер"})
   return nil
ENDIF
desc:=fopen("d:\gos\database\TmpFile.Tmp")
out:=fcreate("lpt2")
Flen:=Fseek(desc,0,2); fseek(desc,0)
Byte:=" "
I:=0; err:=0
DO While I<Flen
   FRead(Desc,@Byte,1)
   DO While .t.
      tot:=FWrite(Out,Byte)
      IF tot==1
         Exit
      else
         err++
         @ 5,0 say Err
         @ 6,0 say asc(Byte); ?? Byte
      ENDIF
   EndDo
   @ 3,0 say Tot; ?? if(tot!=1,"!!!!!!!!!!!!!","")
   @ 2,0 say str(I*100/FLen)+"%"
   @ 4,0 say I
   @ 5,0 say Err
   I++
EndDo
fclose(desc)
fclose(out)
// NNetCapEnd(NetPort)
// NNetCapFlu(NetPort)
NNetCapEnd(NetPort)
Return Nil