#include "my.ch"
#include "inkey.ch"
#define SnakeColor "gr+/g"

function Snake
LOCAL color:=setcolor(),CursRow:=row(),CursCol:=col(),Win:=Win_Save()
LOCAL Curs:=cSetCurs(),I,SnakeX:={},SnakeY:={},PlusX:=-1,PlusY:=0
LOCAL RabbitX:=0,RabbitY:=0,Key:=0,OK:=.T.,Delay:=120,Restart:=-1
LOCAL Money:=0,Inten:=csetinte()
SnakeY:={int(maxcol()/2)-1,int(maxcol()/2),int(maxcol()/2)+1}
SnakeX:={int(maxrow()/2),int(maxrow()/2),int(maxrow()/2)}
RabbitX:=NextRnd(maxrow()-2)
RabbitY:=NextRnd(maxcol()-2)
IF Curs
   Set Cursor Off
ENDIF
IF .not.Inten
   SET INTENSITY ON
ENDIF
Clear Screen
DO WHILE .T.
   IF RESTART!=0
      IF RESTART==1
         IF Al_Box({"Ошибочка, однако.","Попробуем еще раз"},2)==2
            EXIT
         ENDIF
      ENDIF
      asize(SnakeX,3)
      asize(SnakeY,3)
      Delay:=120
      SnakeY:={int(maxcol()/2)-1,int(maxcol()/2),int(maxcol()/2)+1}
      SnakeX:={int(maxrow()/2),int(maxrow()/2),int(maxrow()/2)}
      PlusX:=0;PlusY:=-1
      RabbitX:=NextRnd(maxrow()-2)
      RabbitY:=NextRnd(maxcol()-2)
      set color to w/g+
      @ 0,0,MaxRow(),MaxCol() box B_NORTON
      set color to n/w
      @ 24,0 say center("Сожрано потребителей электроэнергии "+alltrim(str(Money)),80," ",.t.)
      set color to SnakeColor
      @ RabbitX,RabbitY say "$"
      set color to w/g+
      FOR i=1 TO Len(SnakeY)
          IF i=1
             @ SnakeX[i],SnakeY[i] Say chr(2)
          ELSE
             @ SnakeX[i],SnakeY[i] Say "O"
          ENDIF
      NEXT
      RESTART:=0
   ENDIF
   Pause(If(PlusX#0,round(Delay*1.2,0),Delay))
   Key:=Inkey()
//   @ 24,0 say alltrim(str(PlusX))+" "+alltrim(str(PlusY))+" "
   IF Key!=0
      DO CASE
         CASE Key==K_ESC
              IF al_box({"Неужели это и все, а ?"},2)==1
                 Exit
              ENDIF
         CASE Key==K_UP
              IF PlusY=0 .and.  PlusX=1
                 sound(1000,5)
              ELSE
                 PlusY:=0;  PlusX:=-1
              ENDIF
         CASE Key==K_DOWN
              IF PlusY=0.and.PlusX=-1
                 sound(1000,5)
              ELSE
                 PlusY:=0;  PlusX:=1
              ENDIF
         CASE Key==K_LEFT
              IF PlusY=1.and. PlusX=0
                 sound(1000,5)
              ELSE
                 PlusY:=-1; PlusX:=0
              ENDIF
         CASE Key==K_RIGHT
              IF PlusY=-1.and.PlusX=0
                 sound(1000,5)
              ELSE
                 PlusY:=1;  PlusX:=0
              ENDIF
      ENDCASE
   ENDIF
//----------------------------------------------------- Движение тела змеи
   @ SnakeX[Len(SnakeX)],SnakeY[Len(SnakeY)] say " "
   FOR I=Len(SnakeX)-1 TO 1 STEP -1
       SnakeX[I+1]=SnakeX[I]
       SnakeY[I+1]=SnakeY[I]
   NEXT
   SnakeX[1]:=SnakeX[2]+PlusX
   SnakeY[1]:=SnakeY[2]+PlusY
   @ SnakeX[1],SnakeY[1] Say chr(2)
   @ SnakeX[2],SnakeY[2] Say "O"
   @ SnakeX[Len(SnakeX)],SnakeY[Len(SnakeY)] Say "O"
//----------------------------------------------------- Прикосновение змеи
   IF SnakeX[1]==RabbitX.and.SnakeY[1]==RabbitY      // к объекту
// Удлиннение змеи
      sound(500,3)
      sound(700,3)
      sound(900,3)
      asize(SnakeX,Len(SnakeX)+2)
      asize(SnakeY,Len(SnakeY)+2)
      MONEY:=MONEY+2
      DELAY:=IF(DELAY-1>0,DELAY-1,0)            // Изменение времени задержки
      SnakeX[Len(SnakeX)]=SnakeX[Len(SnakeX)-1]
      SnakeX[Len(SnakeX)-1]=SnakeX[Len(SnakeX)-2]
      SnakeY[Len(SnakeY)]=SnakeY[Len(SnakeY)-1]
      SnakeY[Len(SnakeY)-1]=SnakeY[Len(SnakeY)-2]
// Поиск новой координаты объекта
      DO WHILE .T.
         OK:=.F.
         RabbitX:=NextRnd(maxrow()-2)
         RabbitY:=NextRnd(maxcol()-2)
         IF RabbitX>0.and.RabbitY>0
            OK:=.T.
            FOR i=1 to len(SnakeX)-2
                IF RabbitX==SnakeX[I].and.RabbitY==SnakeY[I]
                   OK:=.F.
                ENDIF
            NEXT
         ENDIF
         IF OK
            exit
         ENDIF
      ENDDO
//      @ 24,10 say str(RabbitX,2)+" "+str(RabbitY,2)
//-------------------------------------------------- Перерисовка объекта
      set color to n/w
      @ 24,0 say center("Сожрано потребителей электроэнергии "+alltrim(str(Money)),80," ",.t.)
      set color to SnakeColor
      @ RabbitX,RabbitY say "$"
      set color to w/g+
   ENDIF
//-------------------------------------------------- к границе поля
   IF SnakeX[1]==0.or.SnakeY[1]==0.or.;
      SnakeY[1]==79.or.SnakeX[1]==24
      Restart:=1
   ENDIF
//-------------------------------------------------- к своему телу
   FOR i=2 to len(SnakeX)
       IF SnakeX[1]==SnakeX[I].and.SnakeY[1]==SnakeY[i]
          Restart:=1
       ENDIF
   NEXT
   IF Restart==1
      for i=50 to 40 step -1
          sound(i,3)
      next
   ENDIF
ENDDO
//---------------------------------------------------------
IF .not.Inten
   SET INTENSITY Off
ENDIF
clear screen
IF Curs
   Set Cursor On
ENDIF
Win_Rest(Win)
setcolor(color)
@ CursRow,CursCol say ""
return NIL
