Function SetBitAtribute()
Local Clr:=SetColor(),Scr:=Win_Save(),Selectables:={},On_Off:={},Chosen:={}
Local BitString:=""

Buttons:={"Бюджетная организация     ",;
          "Бюджетник с обязательствами    "}
* Невыбираемые кнопки
//    Selectables[I] = Bit_Test(BitStr,I)

BitString:=Replicate(Chr(0),Len(BitStr))

* Начальные выборы
For I=1 TO Len(Buttons)
    IF Bit_Test(BitStr,I)
       AADD(On_Off,i)
    ENDIF
Next
//      On_Off = {1, 2, 5, 9}

Chosen = Sel_Box(3, 20, Buttons, Selectables, On_Off, 1, 0, .T.,.T.,.F.)

* Теперь высветим возвращенные результаты
For I=1 TO Len(Chosen)
    BitString:=Bit_Set(BitString,Chosen[I])
Next
IF BitStr!=BitString
   IF RecLock()
      Replace BitStr With BitString
      UNLOCK
   ENDIF
ENDIF
Win_Rest(Scr)
SetColor(Clr)
Return NIL



Function OtherTarif()
Local Sel:=Select(),Rec:=RecNo(),Clr:=SetCOlor(),Scr:=Win_Save()
Local TmpValue:=OtherTar1
TmpValue:=GetVal("Тариф для бюджетников с обязательствами ",OtherTar1,-1)
IF TmpValue>=0
   OtherTar1:=TmpValue
   DIRECTMEMW(Ddir+"Config.arm","OtherTar1=",OtherTar1)
ENDIF
Select(Sel)
Go Rec
SetColor(Clr)
Win_Rest(Scr)
Return NIL
