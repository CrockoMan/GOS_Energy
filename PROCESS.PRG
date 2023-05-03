#Include "My.Ch"

FUNCTION WriteProcess(JobNumber,SetOrClear)
Local Sel:=Select(),Rec:=RecNo(),Old_Scr:=Win_Save()
IF File(Schet_Share+"Process.Dbf")
   Load("20",Schet_Share+"Process.Dbf")
   DO Case
      Case SetOrClear==SET_ON
           Go JobNumber
           Replace UserName With Station
      Case SetOrClear==SET_OFF
           Go JobNumber
           Replace UserName With ""
   ENDCASE
   Close
ELSE
   Al_Box({"Отсутствует справочник производимых работ"})
ENDIF
Win_Rest(Old_Scr)
Select(Sel)
Go Rec
return NIL



FUNCTION ReadProcess(JobNumber)
Local Sel:=Select(),Rec:=RecNo(),JobUser:="",OldScr:=Win_Save()
IF File(Schet_Share+"Process.Dbf")
   Load("20",Schet_Share+"Process.Dbf")
   Go JobNumber
   JobUser:=UserName
   Close
ELSE
   Al_Box({"Отсутствует справочник производимых работ"})
ENDIF
Win_Rest(OldScr)
Select(Sel)
Go Rec
return JobUser