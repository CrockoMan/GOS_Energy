#DEFINE BufferSize 25600

#ifdef TEST
FUNCTION Oooops(Par)
Par:=IF(Par==Nil,"0",Par)
If Par=="1"
   DiskRestore("a:")
ELSE
   DiskBackUp({"d:\gos\ose\apr.dbf","d:\gos\ose\aug.dbf",;
               "d:\gos\ose\obormot.dbf"},"a:")
ENDIF
//DiskBackUp({"d:\gos\ose\apr.dbf","d:\gos\ose\aug.dbf",;
//            "d:\gos\ose\obormot.dbf"},"a:")
RETURN NIL
#Endif

// �㭪�� ��࠭���� 䠩��� �� ��᪥� DiskBackUp(Array[],Char)
// ��ࠬ��� - ���ᨢ � ��࠭塞묨 䠩����
//            ��� ���ன�⢠ ��� ��࠭����
FUNCTION DiskBackUp(Files,Drive)
LOCAL DiskNumber:=0,BackName:="DieHard.",BaseName:="BackUp.",FirstStep:=.T.,UseBase:=""
LOCAL DescBack:=0,DescSource:=0,Length:=0,Position:=0,OldClr:=SetColor()
LOCAL Buffer:=space(BufferSize),SavePosition:=0,OldWin:=Win_Save(),Temp
LOCAL DiskSize:=0,DiskWritten:=0,FileSize:=0,FileWritten:=0,rowstart,IsExit:=1
Drive:=Drive+IF(substr(Drive,Len(Drive),1)#"\","\","")
rowstart:=if(maxrow()<25,16,int(maxrow()/2))
Obrabot("������ ��娢���� ��᪠ N 1")
Obrabot("�����⮢�� � ����� ��娢�",rowstart)
Al_Box({"��⠢�� ���� ��� ��� ��砫� �����"},1,{"��� ��⠢���"})
FOR NumBackFile=1 TO Len(Files)
    Obrabot("�����⮢�� � ����� ��娢�",rowstart,,,.T.)
    IF FirstStep.or.SavePosition!=0
       WHILE .NOT.DiskreadyW(Drive)
             IsExit:=Al_Box({"���ன�⢮ �� ��⮢� � �����"},2,{" ������� "," �������� "})
             IF IsExit==2
                EXIT
             ENDIF
       ENDDO
    ENDIF
    IF IsExit==2
       EXIT
    ENDIF
    DO While .T.
       IF FirstStep
          Obrabot("������ ��娢���� ��᪠ N "+alltrim(str(DiskNumber+1)))
          FileDelete(Drive+"*.*")
          DiskSize:=DiskFree(Drive); DiskWritten:=0
          cUserBase:=Drive+BaseName+"#"+Replicate("0",2-len(alltrim(str(DiskNumber))))+;
                   alltrim(str(DiskNumber))
          DbCreate(cUserBase,;
                   {{"FileName","C",40,0},;       // ���� ������ � ���ᠭ���
                   {"FileLen", "N", 7,0},;       // ��࠭����� 䠩���
                   {"FileEnd", "L", 1,0}})       // � �� �����
          DescBack:=Fcreate(Drive+BackName+"#"+;    // ᮧ����� 䠩��, �����
                    Replicate("0",2-;               // �㤥� ᮤ�ঠ��
                   len(alltrim(str(DiskNumber))))+; // ��࠭塞� 䠩��
                   alltrim(str(DiskNumber)))
          FirstStep=.F.
          DiskNumber++
          SELECT 0
          NetUse(cUserBase,,,"UserBase")
       ENDIF
       APPEND BLANK
       REPLACE FileName WITH Files[NumBackFile]
       REPLACE FileLen WITH 0
       REPLACE FileEnd WITH .T.
       COMMIT
       IF SavePosition==0
          FileWritten:=0
          DescSource:=Fopen(Files[NumBackFile])
          IF DescSource<=0
             Al_Box({"�訡�� ������ 䠩��",Files[NumBackFile]},1,{" �ய����� 䠩� "})
             LOOP
          ENDIF
          Length:=Fseek(DescSource,0,2); Fseek(DescSource,0)
          Position:=0
          Buffer:=Space(BufferSize)
       ELSE                       // ������ ��⠭���� ����, ����� ��
          Fwrite(DescBack,Buffer) // �뫠 ����ᠭ� �� �।��騩 ���
          IF NumBackFile==Len(Files).and.DiskFree(Drive)>(Length-FileWritten)
             DiskSize:=Length-FileWritten
          ENDIF
       ENDIF
       Obrabot(Files[NumBackFile],rowstart)
       DO WHILE .T.
          //------------------------ �������� ����ᠭ���� ��᪥��
          DiskWritten:=DiskWritten+Len(Buffer)
          Temp:=Round(DiskWritten*39/DiskSize,0); Temp:=If(Temp>39,39,Temp)
          colorwin(12,21,12,21+Temp,'n/n')
          //------------------------ �������� ����ᠭ���� 䠩��
          FileWritten:=FileWritten+Len(Buffer)
          Temp:=Round(39*FileWritten/Length,0); Temp:=If(Temp>39,39,Temp)
          colorwin(RowStart+2,21,RowStart+2,21+Temp,'gr+/gr+')
          IF Position==Length        // 䠩� ����ᠭ ���������,
             SavePosition:=0         // ����室��� ᤢ�������
             EXIT                    // �� 横�� �� ᫥���騩 䠩�
          ENDIF
          IF (Position+BufferSize)>=Length
             Buffer:=Space(Length-Position)
             Fread(DescSource,@Buffer,(Length-Position))
             Position:=Length
          ELSE
             Fread(DescSource,@Buffer,BufferSize)
             Position:=Position+BufferSize
          ENDIF
          IF DiskFree(Drive)>=Len(Buffer)
             Fwrite(DescBack,Buffer)         // �� ��᪥ �� ����
             SavePosition:=0                 // ᢮������ ����...
          ELSE
             REPLACE FileEnd WITH .F.                 // ��� ��������
             FirstStep=.T.                            // �����뢠� ������
             REPLACE FileLen WITH Fseek(DescBack,0,1) // 䠩�� � �ਧ���
             COMMIT                                   // �������祭����
             FClose(DescBack)                         // �����, ����뢠�
             USE                                      // ���� � 䠩�.
             al_box({"��� N"+alltrim(str(DiskNumber+1))+" �������� ���������",;
                     "��⠢�� ��� N"+alltrim(str(DiskNumber+2))},;
                     1,{" ��� N"+alltrim(str(DiskNumber+2))+" ��⠭����� "})
             Obrabot("������ ��娢���� ��᪠ N "+alltrim(str(DiskNumber+1)))
             SavePosition:=Position
             NumBackFile--          // ��� ������ �� ⥪�騩 䠩�
             exit
          ENDIF
       ENDDO
       IF SavePosition==0                            // ��� �� �� ��������
          REPLACE FileLen WITH Fseek(DescBack,0,1)   // � ���� � 䠩���� ��
          COMMIT                                     // ������
          FCLOSE(DescSource)
       ENDIF
       EXIT
    ENDDO
NEXT NumBackFile
IF IsExit==2
   Al_Box({"��娢�a� ����� �� ᮧ����"})
ELSE
   Fclose(DescBack)
   DO WHILE Temp<39
      colorwin(12,21,12,21+Temp,'n/n')
      Temp++
      inkey(0.5)
   ENDDO
   Al_Box({"�������� ��娢��� ����� �����襭�"})
ENDIF
SetColor(OldClr); Win_Rest(OldWin)
RETURN Nil



FUNCTION DiskRestore(Drive,IsMessage)
LOCAL DiskNumber:=0,BackName:="DieHard.",BaseName:="BackUp.",FirstStep:=.T.,cUseBase:=""
LOCAL OldColor:=SetColor(),OldScreen:=Win_Save(),IsExit:=1,cUserFile:=""
LOCAL DescBack:=0,DescSource:=0,Length:=0,Position:=0,OldClr:=SetColor()
LOCAL RowStart,ArcPosition:=0,NextAppend:=.F.,cUserBase:="",Buffer:=""
LOCAL BackSize:=0,StartPosition:=0
Drive:=Drive+IF(substr(Drive,Len(Drive),1)#"\","\","")
RowStart:=IF(MaxRow()<25,16,INT(MaxRow()/2))
IsMessage:=IF(IsMessage==NIL,.T.,IsMessage)
Obrabot("�⥭�� ��娢���� ��᪠ N 1")
Obrabot("�����⮢�� � �⥭�� ��娢�",rowstart)
Al_Box({"��⠢�� ��娢�� ��� N1"})
DO While .T.
   DO WHILE .T.
      Obrabot("�����⮢�� � �⥭�� ��娢�",rowstart)
      WHILE .NOT.Diskready(Drive)
            IsExit:=Al_Box({"���ன�⢮ �� ��⮢� � �⥭��"},2,{" ������� "," �������� "})
            IF IsExit==2
               EXIT
            ENDIF
      ENDDO
      IF IsExit==2
         EXIT
      ENDIF
      cUserBase:=Drive+BaseName+"#"+Replicate("0",2-Len(AllTrim(Str(DiskNumber))))+;
                 AllTrim(Str(DiskNumber))
      IF File(cUserBase).and.File(Drive+BackName+"#"+;
                                  Replicate("0",2-;
                                  len(alltrim(str(DiskNumber))))+;
                                  alltrim(str(DiskNumber)))
         EXIT
      ELSE
         IsExit:=Al_Box({"��⠢�� ��娢�� ��� N"+alltrim(str(DiskNumber+1))},2,{" ��� ��⠢��� "," �������� "})
         IF IsExit==2
            EXIT
         ENDIF
      ENDIF
   ENDDO
   Obrabot("�⥭�� ��娢���� ��᪠ N "+alltrim(str(DiskNumber+1)))
   IF IsExit==2
      EXIT
   ENDIF
   DO While .T.
      IF FirstStep
         DescBack:=Fopen(Drive+BackName+"#"+;      // ����⨥ 䠩��,
                   Replicate("0",2-;               // ᮤ�ঠ饣�
                  len(alltrim(str(DiskNumber))))+; // ��࠭塞� 䠩��
                  alltrim(str(DiskNumber)))
         BackSize:=Fseek(DescBack,0,2); Fseek(DescBack,0)
         FirstStep:=.F.
         Position:=0
         StartPosition:=0
         ArcPosition:=0              // ��������� 㪠��⥫� � ��娢��� 䠩��
         DiskNumber++
         SELECT 0
         NetUse(cUserBase,,,"UserBase")
      ENDIF
      Buffer:=SPACE(BufferSize)
      cUserFile:=Alltrim(FileName)
      Length:=FileLen
      Obrabot("�⥭�� "+cUserFile,RowStart)
      IF NextAppend     // �������� � �������騩 䠩� ?
//       DescSource:=Fopen(cUserFile)        // ���, ���뢠� 㦥 ᮧ�����
//       Fseek(DescSource,0,2)               // 䠩� � �த����� �����뢠��
         NextAppend:=.F.                     // � ����� 䠩�a
      ELSE
         DescSource:=Fcreate(cUserFile)      // ��, ᮧ��� ���� 䠩�
         NextAppend:=IF(FileEnd,.F.,.T.)     // ���� ����ᠭ �� ���� ???
      ENDIF
      IF DescSource>0
         ArcPosition:=Length
         DO While .T.
            //------------------------ �������� ���⠭���� ��᪥��
            Temp:=Round(Position*39/BackSize,0); Temp:=If(Temp>39,39,Temp)
            colorwin(12,21,12,21+Temp,'n/n')
            //------------------------ �������� ���⠭���� 䠩��
            Temp:=Round((Position-StartPosition)*39/(Length-StartPosition),0)
            Temp:=If(Temp>39,39,Temp)
            colorwin(RowStart+2,21,RowStart+2,21+Temp,'gr+/gr+')
            IF Position==Length
               EXIT
            ENDIF
            IF (Position+BufferSize)>=Length
               Buffer:=Space(Length-Position)
               Fread(DescBack,@Buffer,(Length-Position)); Position:=Length
            ELSE
               Fread(DescBack,@Buffer,BufferSize); Position:=Position+BufferSize
            ENDIF
            IF Fwrite(DescSource,Buffer)!=LEN(Buffer)
               Al_Box({"�訡�� ����� 䠩��"})
            ENDIF
         ENDDO
         IF .NOT.NextAppend
            Fclose(DescSource)
         ENDIF
         IF Recno()==Reccount()
//            Fclose(DescBack)
            FirstStep:=.T.
            IF FileEnd
               DiskNumber=-1            // �ਧ��� ����砭�� ��᪮�
            ENDIF
            USE
            Exit
         ELSE
            StartPosition:=FileLen
            Skip
         ENDIF
      ENDIF
   ENDDO
   Fclose(DescBack)
   IF DiskNumber==-1.or.IsExit==2
      EXIT
   ENDIF
ENDDO
SetColor(OldColor)
Win_Rest(OldScreen)
IF IsExit==2
   IF NextAppend
      Fclose(DescSource)
   ENDIF
   Al_Box({"��娢�� ��� �� �� ��⠭ ���४⭮"})
ENDIF
IF DiskNumber==-1.and.IsMessage
   Al_Box({"��娢��� ���ଠ�� ����⠭������ ���������"})
ENDIF
RETURN NIL
