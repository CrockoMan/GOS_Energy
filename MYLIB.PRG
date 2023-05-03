Function ColorWin(Posx1,Posy1,Posx2,Posy2,Color)
Local LCol:=SetColor(),LPosx:=Row(),LPosY:=Col()
SetColor(Color)
@ PosX1,PosY1 Clear To PosX2,PosY2
SetColor(LCol)
Return NIL