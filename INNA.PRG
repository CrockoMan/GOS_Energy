#include "XBP.CH"
FUNCTION Inna_Otchet()
Local Sel:=Select(),Rec:=Recno(),Win:=Win_Save(),Scr:=SetColor(),RecCount:=0
Local Month:=Month_Menu("§´Ô ‡†·Á•‚† Æ°Æ‡Æ‚≠Æ-·†´Ï§Æ¢Æ© ¢•§Æ¨Æ·‚®"),Desc
Local CrLf:=Chr(13)+Chr(10),TmpStr:="",Mass:={},Kol_Kl:=0,Itog:={},I,Itog1:={}
Local oDlg,aSizeDeskTop,aPos,oProgress,RashNds:=0,ItogNds:={0,0,0,0},Itog1Nds:={0,0,0,0}
RunSaver:=.F.
IF Month==0
   Return NIL
ENDIF

oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop  := AppDesktop():currentSize()
oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} )
oDlg:title    := "ê†·Á•‚ Æ°Æ‡Æ‚≠Æ-·†´Ï§Æ¢Æ© ¢•§Æ¨Æ·‚®"
oDlg:SysMenu     := .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop    := oDlg:currentSize()
aPos                                            := oDlg:CurrentPos()
oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )  // Progress Bar Create
oProgress:create()

//Obrabot("ê†·Á•‚ Æ°Æ‡Æ‚≠Æ© ¢•§Æ¨Æ·‚®")
Select Main
Go Top
Do While !EOF()
   RecCount:=RecCount+1
   Skip
ENDDO
oProgress:minimum := 1
oProgress:maximum := RecCount
Go Top
Desc:=FCreate(DDir+ReportFile)
ASize(Mass,4)
ASize(Itog,4);   AFill(Itog,0); ASize(Itog1,3);   AFill(Itog1,0)
FWrite(Desc,Schet_Cond)
FWrite(Desc,"⁄ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"+CrLf)
FWrite(Desc,"≥ ã/·Á ≥        èÆ‚‡•°®‚•´Ï      ≥    ë†´Ï§Æ    ≥   éØ´†Á•≠Æ  ≥  ç†Á®·´•≠Æ  ≥    ë†´Ï§Æ    ≥"+CrLf)
FWrite(Desc,"√ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"+CrLf)
DO While .not.Eof()
   IF Hot_Inkey()==27
      IF Al_Box({"á†™Æ≠Á®‚Ï ‰Æ‡¨®‡Æ¢†≠®• ¢•§Æ¨Æ·‚®"},2)==1
         Exit
      ENDIF
   ENDIF
   AFill(Mass,0)
   oProgress:increment()                                                                                                                                                                // Progress Bar Increment
//   Kol_Kl=Kol_Kl+39/RecCount
//   ColorWin(12,21,12,21+Kol_Kl,'N/N')
   TmpStr:="≥"+Str(Lic_Schet,6)+"≥"+GetName(Main->Lic_Schet,25)
   Mass[1]:=GetSaldo(Lic_Schet,IF(Month>1,Month-1,13))
   TmpStr:=TmpStr+"≥"+IF(Mass[1]>0,"ä‚",If(Mass[1]<0,"Ñ‚","  "))+Str(IF(Mass[1]>=0,Mass[1],-1*Mass[1]),12,2)
   Mass[2]:=CalckPay(Month,Lic_Schet,.F.)
   TmpStr:=TmpStr+"≥"+Str(Mass[2],13,2)
   Mass[3]:=GetSum(Lic_Schet,Month)
   RashNds:=RashNds+Round(Mass[3]*Schet_Nds/(100+Schet_Nds),2)
//   IF Lic_Schet<=99999
//                TmpStr:=TmpStr+"≥"+Str(Mass[3],13,2)
//   ELSE
                TmpStr:=TmpStr+"≥"+Str(Mass[3],13,2)            // ó†·‚≠Î© ·•™‚Æ‡ çÑë ≠• ≠†Á®·´Ô•‚·Ô
//   ENDIF
   Mass[4]:=GetSaldo(Lic_Schet,Month)
   TmpStr:=TmpStr+"≥"+IF(Mass[4]>0,"ä‚",If(Mass[4]<0,"Ñ‚","  "))+Str(If(Mass[4]>=0,Mass[4],-1*Mass[4]),12,2)+"≥"
   Fwrite(Desc,TmpStr+CrLf)
   IF Mass[1]>0
      Itog[1]:=Itog[1]+Mass[1]
      ItogNds[1]:=ItogNds[1]+Round(Mass[1]*Schet_Nds/(100+Schet_Nds),2)
   ELSE
      Itog1[1]:=Itog1[1]+(-1*Mass[1])
      Itog1Nds[1]:=Itog1Nds[1]+Round(Mass[1]*Schet_Nds/(100+Schet_Nds),2)
   ENDIF
   Itog[2]:=Itog[2]+Mass[2]
   ItogNds[2]:=ItogNds[2]+Round(Mass[2]*Schet_Nds/(100+Schet_Nds),2)
   Itog[3]:=Itog[3]+Mass[3]
   ItogNds[3]:=ItogNds[3]+Round(Mass[3]*Schet_Nds/(100+Schet_Nds),2)
   IF Mass[4]>0
      Itog[4]:=Itog[4]+Mass[4]
   		ItogNds[4]:=ItogNds[4]+Round(Mass[4]*Schet_Nds/(100+Schet_Nds),2)
   ELSE
      Itog1[2]:=Itog1[2]+(-1*Mass[4])
   	  Itog1Nds[2]:=Itog1Nds[2]+Round(Mass[4]*Schet_Nds/(100+Schet_Nds),2)
   ENDIF
//   IF Lic_Schet<=99999                                                                                          // ó†·‚≠Î© ·•™‚Æ‡ çÑë ≠• ≠†Á®·´Ô•‚·Ô
//                Itog1[3]:=Itog1[3]+Mass[3]+Round(Mass[3]*Schet_Nds/100,2)
//   ELSE
//                Itog1[3]:=Itog1[3]+Mass[3]
//   ENDIF
                Itog1[3]:=Itog1[3]+Mass[3]
   Itog1Nds[3]:=Itog1Nds[3]+Round(Mass[3]*Schet_Nds/(100+Schet_Nds),2)
   Skip
EndDo
FWrite(Desc,"√ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"+CrLf)
Fwrite(Desc,"≥      ≥"+Space(25)+"≥Ñ‚"+Str(Itog1[1],12,2)+;
            "≥"+Str(Itog[2],13,2)+"≥"+Str(Itog1[3],13,2)+"≥Ñ‚"+Str(Itog1[2],12,2)+"≥"+CrLf)
Fwrite(Desc,"≥çÑë   ≥"+Space(25)+"≥  "+Str(Round(Itog1[1]*Schet_Nds/(Schet_Nds+100),Decimal),12,2)+;
            "≥"+Str(Round(Itog[2]*Schet_Nds/(Schet_Nds+100),Decimal),13,2)+"≥"+Str(Itog1[3]-Itog[3],13,2)+"≥  "+Str(Round(Itog1[2]*Schet_Nds/(Schet_Nds+100),Decimal),12,2)+"≥"+CrLf)
Fwrite(Desc,"≥      ≥"+Space(25)+"≥ä‚"+Str(Itog[1],12,2)+;
            "≥"+Space(13)+"≥"+Space(13)+"≥ä‚"+Str(Itog[4],12,2)+"≥"+CrLf)
Fwrite(Desc,"≥çÑë   ≥"+Space(25)+"≥  "+Str(Round(Itog[1]*Schet_Nds/(Schet_Nds+100),Decimal),12,2)+;
            "≥"+Space(13)+"≥"+Space(13)+"≥  "+Str(Round(Itog[4]*Schet_Nds/(Schet_Nds+100),Decimal),12,2)+"≥"+CrLf)

/*
Fwrite(Desc,"≥      ≥"+Space(25)+"≥Ñ‚"+Str(Itog1[1],12,2)+;
            "≥"+Str(Itog[2],13,2)+"≥"+Str(Itog1[3],13,2)+"≥Ñ‚"+Str(Itog1[2],12,2)+"≥"+CrLf)
Fwrite(Desc,"≥çÑë   ≥"+Space(25)+"≥  "+Str(-1*Itog1Nds[1],12,2)+;
            "≥"+Str(ItogNds[2],13,2)+"≥"+Str(Itog1Nds[3],13,2)+"≥  "+Str(-1*Itog1Nds[2],12,2)+"≥"+CrLf)
Fwrite(Desc,"≥      ≥"+Space(25)+"≥ä‚"+Str(Itog[1],12,2)+;
            "≥"+Space(13)+"≥"+Space(13)+"≥ä‚"+Str(Itog[4],12,2)+"≥"+CrLf)
Fwrite(Desc,"≥çÑë   ≥"+Space(25)+"≥  "+Str(ItogNds[1],12,2)+;
            "≥"+Space(13)+"≥"+Space(13)+"≥  "+Str(ItogNds[4],12,2)+"≥"+CrLf)
*/            
FWrite(Desc,"¿ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"+CrLf)
//Fwrite(Desc,"ç†Á®·´•≠Æ "+Str(Itog[3],13,2)+"  çÑë "+Str(Itog1[3]-Itog[3],13,2)+" Ç·•£Æ "+Str(Itog1[3],13,2)+CrLf)
//FWrite(Desc," ë¢•‡≠„‚Æ• ·†´Ï§Æ "+AllTrim(Str(Itog[4],12,2))+" "+AllTrim(Str(Itog1[1]+Itog1[3]-Itog[2]-Itog[1]-Itog1[2],12,2))+;
//                                          "    = "+AllTrim(Str(Itog[4]+(Itog1[1]+Itog1[3]-Itog[2]-Itog[1]-Itog1[2]),12,2))+CrLf)
FWrite(Desc,Schet_Norm+CrLf)
FClose(Desc)
oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
oDlg:Destroy()
	
ConfirmBox(oMainWindow , " ë¢•‡≠„‚Æ• ·†´Ï§Æ "+AllTrim(Str(Itog[4],12,2))+" "+AllTrim(Str(Itog1[1]+Itog1[3]-Itog[2]-Itog[1]-Itog1[2],12,2))+;
                         "    = "+AllTrim(Str(Itog[4]+(Itog1[1]+Itog1[3]-Itog[2]-Itog[1]-Itog1[2]),12,2)), ;
                         "Ç≠®¨†≠®•", XBPMB_OK, XBPMB_WARNING+XBPMB_APPMODAL )
                         
SetColor(Scr); Win_Rest(Win)
Select(Sel); Go Rec
RunSaver:=.T.
RETURN NIL


Function GetName(Lic,Len)
Local String:="",Sel:=Select(),Rec:=Recno()
Lic:=IF(Lic==NIL,Main->Lic_Schet,Lic)
Len:=IF(Len==NIL,Len(Main->Potrebitel),Len)
Select Main
Seek Lic
IF Found()
   String:=DelString(Potrebitel,"àçç"); String:=String+Space(Len-Len(String))
   String:=Substr(String,1,Len)
ELSE
   String:=Space(Len)
ENDIF
Select(Sel); Go Rec
Return String
