Function FidersMoshn()
Local Sel:=Select(),Rec:=RecNo(),WorkMonth,Scr:=SaveScreen(0,0,24,79)
Local cTmpField:="Main->Lic_Schet",Desc
Local oDlg,aSizeDeskTop,aPos,oProgress,aFiders:={}

  load("76",SCHET_SHARE+"Fiders.dbf",Schet_Share+"FidersN.ntx",Schet_Share+"FidersC",.f.)
	go top
	Do While !eof()
			AADD(AFiders,{KOD,0,0,Fider})
			Skip
	EndDo
	Close
	Select Main
	oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
	aSizeDesktop  := oMainWindow:currentSize()
	oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
	oDlg:title    := " ���� ��魮�� �� 䨤�ࠬ"
	oDlg:SysMenu	:= .F.
	oDlg:Configure()
	oDlg:Show()
	aSizeDesktop  := oDlg:currentSize()
	aPos					:= oDlg:CurrentPos()
	oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
	oProgress:create()
	oProgress:minimum := 1
	oProgress:maximum := RecCount()
   Go Top
   Do While !EOF()
   	  oProgress:increment()																				// Progress Bar Increment
   	  IF Main->Lic_Schet<100000
   	  	 Select Licevoj
   	  	 Seek Main->Lic_Schet
   	  	 Do While Lic_Sch==Main->Lic_Schet
   	  	    For i=1 to len(aFiders)
   	  	    	IF aFiders[i][1]=KOD
   	  	    		 aFiders[i][2]=aFiders[i][2]+Silowaq
   	  	    		 aFiders[i][3]=aFiders[i][3]+Oswesh
   	  	    		 Exit
   	  	    	ENDIF
   	  	    Next
   	  	 		Skip
   	  	 ENDDO   	  	
   	     Select Main
   	  ENDIF
      Skip
   ENDDO
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
   Desc:=FCreate(DDir+ReportFile)
   For i=1 to Len(aFiders)
   		FWrite(Desc,aFiders[i][4]+" "+Str(aFiders[i][2]+aFiders[i][3],15,0)+" "+Str(aFiders[i][2],15,0)+" "+Str(aFiders[i][3],15,0)+Chr(13)+Chr(10))
   Next
   FClose(Desc)
Select(Sel)
Go Rec
Return NIL


Function FidersErase()
Local Sel:=Select(),Rec:=RecNo(),WorkMonth,Scr:=SaveScreen(0,0,24,79)
Local cTmpField:="Main->Lic_Schet"
Local oDlg,aSizeDeskTop,aPos,oProgress
WorkMonth:=Month_Menu()
IF WorkMonth>0.and.WorkMonth<=12
   WantReplace("�������� ��䨤�୮�� ������ "+Mesqc(WorkMonth),cTmpField,&cTmpField,&cTmpField,.T.)
   Load('199',Schet_Share+'Balans.dbf')

	oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
	aSizeDesktop  := oMainWindow:currentSize()
	oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
	oDlg:title    := Mesqc(WorkMonth)+" 㤠����� ������ ��䨤�୮�� ������"
	oDlg:SysMenu	:= .F.
	oDlg:Configure()
	oDlg:Show()
	aSizeDesktop  := oDlg:currentSize()
	aPos					:= oDlg:CurrentPos()
	oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
	oProgress:create()
	oProgress:minimum := 1
	oProgress:maximum := RecCount()
//   Obrabot(Mesqc(WorkMonth)+" 㤠����� ������")
   Go Top
   temp_=39/RecCount()
   kol_kl=0
   Do While !EOF()
   	  oProgress:increment()																				// Progress Bar Increment
//      kol_kl=kol_kl+temp_
//      colorwin(12,21,12,21+kol_kl,'n/n')
      IF Month==Chr(WorkMonth)
         IF RecLock()
            Delete:=.T.
            DELETE
            UNLOCK
         ENDIF
      ENDIF
      Skip
   ENDDO
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
   Pack
   Select 199
   Close
ENDIF
//RestScreen(0,0,24,79,Scr)
Select(Sel)
Go Rec
Return NIL


Function FiderSchPok()
Local Clr:=SetColor(),Scr:=Win_Save()

SET COLOR TO n/w
colorwin(5,19,20,53,"n+/n")
@ 04,18 SAY "�������������������������������ķ"
@ 05,18 SAY "�           ��������� ���室    �"
@ 06,18 SAY "�  ��.���                       �"
@ 07,18 SAY "�  ������                       �"
@ 08,18 SAY "�  ���ࠫ�                      �"
@ 09,18 SAY "�  ����                         �"
@ 10,18 SAY "�  ��५�                       �"
@ 11,18 SAY "�  ���                          �"
@ 12,18 SAY "�  ���                         �"
@ 13,18 SAY "�  ���                         �"
@ 14,18 SAY "�  ������                       �"
@ 15,18 SAY "�  �������                     �"
@ 16,18 SAY "�  ������                      �"
@ 17,18 SAY "�  �����                       �"
@ 18,18 SAY "�  �������                      �"
@ 19,18 SAY "�������������������������������ͼ"

SET COLOR TO &GetColor
IF RecLock()
   Set Cursor on
   set confirm on
   @ 06,31 GET LASTDEC
   @ 07,31 GET JAN Valid ShowRash()
   @ 08,31 GET FEB Valid ShowRash()
   @ 09,31 GET MAR Valid ShowRash()
   @ 10,31 GET APR Valid ShowRash()
   @ 11,31 GET MAY Valid ShowRash()
   @ 12,31 GET JUN Valid ShowRash()
   @ 13,31 GET JUL Valid ShowRash()
   @ 14,31 GET AUG Valid ShowRash()
   @ 15,31 GET SEP Valid ShowRash()
   @ 16,31 GET OCT Valid ShowRash()
   @ 17,31 GET NOV Valid ShowRash()
   @ 18,31 GET DEC Valid ShowRash()
   read
   set cursor off
   set confirm off
   Clear Typeahead
   UNLOCK
ENDIF
Win_Rest(scr)
SetColor(Clr)
Return NIL



STATIC Function ShowRash(WorkMonth)
Local VarName,rVal:=0
VarName:=IF(WorkMonth==NIL,ReadVar(),"")
Do Case
   Case VarName=="JAN".or.WorkMonth==1
        IF WorkMonth==NIL
           @ 7,42 SAY Str(Proverka(Jan,LastDec)*KOEFF,6)
        ELSE
           RVal:=Proverka(Jan,LastDec)*KOEFF
        ENDIF
   Case VarName=="FEB".or.WorkMonth==2
        IF WorkMonth==NIL
           @ 8,42 SAY Str(Proverka(FEB,Jan)*KOEFF,6)
        ELSE
           RVal:=Proverka(FEB,Jan)*KOEFF
        ENDIF
   Case VarName=="MAR".or.WorkMonth==3
        IF WorkMonth==NIL
           @ 9,42 SAY Str(Proverka(MAR,FEB)*KOEFF,6)
        ELSE
           RVal:=Proverka(MAR,FEB)*KOEFF
        ENDIF
   Case VarName=="APR".or.WorkMonth==4
        IF WorkMonth==NIL
           @ 10,42 SAY Str(Proverka(APR,MAR)*KOEFF,6)
        ELSE
           RVal:=Proverka(APR,MAR)*KOEFF
        ENDIF
   Case VarName=="MAY".or.WorkMonth==5
        IF WorkMonth==NIL
           @ 11,42 SAY Str(Proverka(MAY,APR)*KOEFF,6)
        ELSE
           RVal:=Proverka(MAY,APR)*KOEFF
        ENDIF
   Case VarName=="JUN".or.WorkMonth==6
        IF WorkMonth==NIL
           @ 12,42 SAY Str(Proverka(JUN,MAY)*KOEFF,6)
        ELSE
           RVal:=Proverka(JUN,MAY)*KOEFF
        ENDIF
   Case VarName=="JUL".or.WorkMonth==7
        IF WorkMonth==NIL
           @ 13,42 SAY Str(Proverka(JUL,JUN)*KOEFF,6)
        ELSE
           RVal:=Proverka(JUL,JUN)*KOEFF
        ENDIF
   Case VarName=="AUG".or.WorkMonth==8
        IF WorkMonth==NIL
           @ 14,42 SAY Str(Proverka(AUG,JUL)*KOEFF,6)
        ELSE
           RVal:=Proverka(AUG,JUL)*KOEFF
        ENDIF
   Case VarName=="SEP".or.WorkMonth==9
        IF WorkMonth==NIL
           @ 15,42 SAY Str(Proverka(SEP,AUG)*KOEFF,6)
        ELSE
           RVal:=Proverka(SEP,AUG)*KOEFF
        ENDIF
   Case VarName=="OCT".or.WorkMonth==10
        IF WorkMonth==NIL
           @ 16,42 SAY Str(Proverka(OCT,SEP)*KOEFF,6)
        ELSE
           RVal:=Proverka(OCT,SEP)*KOEFF
        ENDIF
   Case VarName=="NOV".or.WorkMonth==11
        IF WorkMonth==NIL
           @ 17,42 SAY Str(Proverka(NOV,OCT)*KOEFF,6)
        ELSE
           RVal:=Proverka(NOV,OCT)*KOEFF
        ENDIF
   Case VarName=="DEC".or.WorkMonth==12
        IF WorkMonth==NIL
           @ 18,42 SAY Str(Proverka(DEC,NOV)*KOEFF,6)
        ELSE
           RVal:=Proverka(DEC,NOV)*KOEFF
        ENDIF
EndCase
IF WorkMonth==NIL
   RVal:=.T.
ENDIF
Return RVal



Function FiderSchetchik()
LOCAL typ:=0
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,name
private code
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
   if (.not. file(schet_share+"Fiderssc.Dbf"))
      sign(2)
      set color to (color_buf)
      restscreen(0,0,24,79,buff)
      return NIL
   else
      load("75",SCHET_SHARE+"Fiderssc.dbf",Schet_Share+"FidersSN.ntx",,.f.)
   endif
endif
colorwin(8,37,22,78,'w/n')
set color to n/w
name='  ��ࠢ�筨� ���稪��  '
@ 7,38+(39-len(name))/2 say name
********************************************************************
*       ��।���� ���ᨢ� �������� ����� � ���ᨢ ������ �����ᮢ
********************************************************************
declare zgl[2]
declare fil[2]
nm1=loarr('zgl',"����� ���稪�","����")
nm2=loarr('fil','Schetchik','koeff')
//code=main->kod_otr
inp='00'
Set Filter To Kod==Fiders->Kod
go top
set color to n/w
******* Begin make box
t1=8
l1=36
b1=21
r1=77
******** End make box
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
Select 75
Set Filter To
Close
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
Return NIL


Function AppendFider
Local Scr:=Win_Save(),Clr:=SetColor(),NewFid:=Space(Len(Fider)),FidKod
IF Al_Box({"�������� ���� 䨤��"},2)==1
   NewFid:=GetVal("������������ 䨤�� ",NewFid,"")
   IF Len(NewFid)>0
      Go Bottom
      FidKod=Kod
      FidKod=FidKod+5
      Go Top
      IF NetAppend()
         Replace Fider With NewFid
         Replace Kod With FidKod
         UNLOCK
         Ret_Val:=2
      ENDIF
   ENDIF
ENDIF
Win_Rest(Scr)
SetColor(Clr)
Return NIL


Function ShowFiders()
LOCAL typ:=0
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_sel,name
private code
old_sel=select()
rec_buf=recno()
ord_buf=indexord()
buff=savescreen(0,0,24,79)
color_buf=setcolor()
if urov<1
   if (.not. file(schet_share+"Fiders.Dbf"))
      sign(2)
      set color to (color_buf)
      restscreen(0,0,24,79,buff)
      return NIL
   else
      load("76",SCHET_SHARE+"Fiders.dbf",Schet_Share+"FidersN.ntx",Schet_Share+"FidersC",.f.)
   endif
endif
colorwin(8,2,22,35,'w/n')
set color to n/w
name='  ��ࠢ�筨� 䨤�஢  '
@ 7,(35-len(name))/2 say name
********************************************************************
*       ��।���� ���ᨢ� �������� ����� � ���ᨢ ������ �����ᮢ
********************************************************************
declare zgl[1]
declare fil[1]
nm1=loarr('zgl',"�a���������� 䨤��")
nm2=loarr('fil','Fider')
//code=main->kod_otr
inp='2'
go top
set color to n/w
******* Begin make box
t1=8
l1=1
b1=21
r1=34
******** End make box
fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
Select 76
Close
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
restscreen(0,0,24,79,buff)
Return NIL




Function Fiders1()
Local Sel1:=Select(),Rec:=RecNo(),WorkMonth,Temp_:=0,Kol_Kl:=0
Local SumR:=0,SumM:=0,_Kod,ij,Abonent
Local Scr:=SaveScreen(0,0,MaxRow(),MaxCol())
Local cTmpField:="Main->Lic_Schet",cFosns:=Schet_Share +'fosns.dbf'
Local oDlg,aSizeDeskTop,aPos,oProgress
Private KodC:={},KodN:={},KodCh:={}
IF Al_Box({"��� �ᯥ譮�� ᡮ� ������ ����室���",;
           "�४���� �� ࠡ��� �� ���ᥪ��� � ��⭮�� ᥪ���",;
           " ",;
           "����� ᡮ� ������ � ��室� �� ⥪�騩 �����"},2,{" ���, ���᫥��� �� �� ����祭� ", " �� "})==2
   WorkMonth:=Month_Menu()
   IF WorkMonth>0
      WantReplace("���� ��䨤�୮�� ������ "+Mesqc(WorkMonth),cTmpField,&cTmpField,&cTmpField,.T.)
//      For i=103 to 108
//          Select(i)
//          Close
//      Next
      load("76",SCHET_SHARE+"Fiders.dbf",Schet_Share+"FidersN.ntx",Schet_Share+"FidersC",.f.)
//      load("76",SCHET_SHARE+"Fiders.dbf",,,.f.)
      Go Top
      Do While !EOF()
         IF KOD!=0
//            AADD(KodC,FIDER)
            AADD(KodN,KOD)
            AADD(KodCh,CHASTNFID)
//            AADD(KodRec,RecNo())
         ENDIF
         Skip
      ENDDO
      Close
//----------------------------------------------- ���ᥪ��
      Select Fosn
			Copy Structure to &cFosns
			make_ind('0',Schet_Share +'fosns.dbf',Schet_Share +'fosns.ntx','KA',,,.t.,.t.)
      load("197",SCHET_SHARE+"Fosns.dbf",SCHET_SHARE+'FOSNs.ntx',,  .f.)
      Load('199',Schet_Share+'Balans.dbf')
      Locate For Month==Chr(WorkMonth)
      IF .not.Found()
         SborSobes()
//         Obrabot("���� ������ �� ���ॡ�⥫�")

					oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
					aSizeDesktop  := oMainWindow:currentSize()
					oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
					oDlg:title    := "���� ������ �� ���ॡ�⥫�" 
					oDlg:SysMenu	:= .F.
					oDlg:Configure()
					oDlg:Show()
					aSizeDesktop  := oDlg:currentSize()
					aPos					:= oDlg:CurrentPos()
					oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
					oProgress:create()
					oProgress:minimum := 1
         Select Main
         Go Top
					oProgress:maximum := RecCount()
//         temp_=39/RecCount()
//         kol_kl=0
         Do While !EOF()
			   	  oProgress:increment()																				// Progress Bar Increment
//            kol_kl=kol_kl+temp_
//            colorwin(12,21,12,21+kol_kl,'n/n')
            Sumr:=0
            SumM:=0
            Select Licevoj
            Seek Main->Lic_Schet
            DO While Lic_Sch==Main->Lic_Schet
               IF .not.reaktivn
                  IF val(substr(licevoj->schetchik,3,7))>0.or.val(substr(licevoj->schetchik,2,7))>0
                     _Kod='('+alltrim(str(Main->lic_schet))+')'+alltrim(licevoj->schetchik)
                     Select(WorkMonth)
                     Seek _Kod
                     IF Found()
                        SumR=Rashod
                        SumM=Summa
                     ENDIF
//----------------------------- ������ ������ ���稪� � ����
//                     IF (SumR!=0.or.SumM!=0)           // .and.Licevoj->KOD>0
//                      IF !Empty(Licevoj->Kod)
                        Select 199
                        Append Blank
                        Replace Potrebitel With AllTrim(DelString(Main->Potrebitel,"���")+Licevoj->Object1)+" "+AllTrim(Licevoj->Schetchik)
                        Replace Licevoj With Main->Lic_Schet
                        Replace Month With Chr(WorkMonth)
                        Replace Rashod With SumR
                        Replace Summa With SumM
                        Replace Kod With IF(Licevoj->Kod==0,500000,Licevoj->Kod)
                        IF Main->Lic_Schet>99999
                           Select FNSI
                           Seek Main->LIc_Schet
                           IF Found()
                              Select 199
                              Replace Potrebitel With Fnsi->FAM+AllTrim(ReadAddr(FNSI->KUL))+" "+AllTrim(Fnsi->Dm)+" "+FnSi->Kv
                           ENDIF
                        ENDIF
//                      ENDIF
//                     ENDIF
//-----------------------------
                  ENDIF
               ENDIF
               Select Licevoj
               Skip
            ENDDO
            Select Main
            Skip
         ENDDO
         Go Rec
   				oProgress:destroy()																							// Progress Bar Destroy
   				oDlg:Destroy()
      ELSE
         AL_BOX({"����� �� ��� ����� 㦥 �뫨 ����ᠭ�"})
      ENDIF
   ENDIF
ENDIF
//load("104",SCHET_SHARE+"FOSN.dbf",SCHET_SHARE+'FOSN.ntx',,  .f.)
//load("105",SCHET_SHARE+"FYear.dbf",SCHET_SHARE+'FYear.ntx',,  .f.)
//load("106",SCHET_SHARE+"Fkods.dbf",SCHET_SHARE+'Fkods.ntx',,  .f.)
//load("107",SCHET_SHARE+"Fsch.dbf",SCHET_SHARE+'Fsch.ntx',,  .f.)
//load("108",SCHET_SHARE+"Fvo.dbf",SCHET_SHARE+'Fvo.ntx',,  .f.)
For ij=196 To 199
    select(ij)
    Close
Next
Select(Sel1)
Go Rec
RestScreen(0,0,MaxRow(),MaxCol(),Scr)
Return NIL




Function ReadAddr(SearchKod)
Local Sel:=Select(),Rec:=RecNo(),RetVal:="��� 㫨�� "+AllTrim(Str(SearchKod))+"? "
//select 196
Select FKODS
//if empty(fieldname(1))
//   load("196",SCHET_Chastn+"Fkods.dbf",SCHET_Chastn+"FkodsKul.ntx",,  .f.)
//   Loaded:=.T.
//endif
Go Top
Seek SearchKod
IF Found()
   RetVal:=FKODS->NUL
ENDIF
//If Loaded
//   Select 196
//   Close
//ENDIF
Select(Sel)
Go Rec
Return RetVal


Function AiFider(NumFider)
Local cStr:=500000,I,Fid,IsAiComplete:=.F.
FOR Fid=1 To Len(KodN)
    FOR I=1 TO NumToken(KodCh[Fid],";,")
        IF Val(Token(KodCh[Fid],";,",I))==NumFider
           cStr:=KodN[Fid]
           IsAiComplete:=.T.
           Exit
        ENDIF
    NEXT
    IF IsAiComplete
       Exit
    ENDIF
NEXT
Return cStr



Function Fiders2(RptVid)
Local Sel:=Select(),Rec:=RecNo(),WorkMonth,Temp_:=0,Kol_Kl:=0,Fider:={},Kod:={}
Local SumR:=0,SumM:=0,_Kod,KodC:={},KodN:={},KodR:={},KodS:={},AllFidRash:=0
Local Scr:=SaveScreen(0,0,MaxRow(),MaxCol()),CrLf:=Chr(13)+Chr(10),TmpKodC:=0
Local Itog1:=0,Itog2:=0,i,Poisk,KodGos:={},KodChastn:={},FidRash:=0,OldData
Local DelLic:={1.230,1.500},IsDelLic:=.F.,Calculate,LenDl,Iks:=0
Local oDlg,aSizeDeskTop,aPos,oProgress,nPoints:={0,0,0,0}
WorkMonth:=Month_Menu("��� �ନ஢���� ����")
IF Al_Box({"��ନ஢��� ����� �� ���ॡ�⥫�"},2,{" �� "," ��� 10�� "})==2
   IsDelLic:=.T.
ENDIF
IF WorkMonth>0

	
   Desc:=FCreate(DDir+ReportFile)
   load("75",SCHET_SHARE+"Fiderssc.dbf",Schet_Share+"FidersSN.ntx",,.f.)
   load("76",SCHET_SHARE+"Fiders.dbf",Schet_Share+"FidersN.ntx",Schet_Share+"FidersC",.f.)
   Select Fiders
   Go Top
   Do While !EOF()
      IF Fiders->KOD>0
         AADD(KodC,Fiders->FIDER)
         AADD(KodN,Fiders->KOD)
         AADD(KodR,0)
         AADD(KodS,0)
         AADD(KodGos,0)
         AADD(KodChastn,0)
      ENDIF
      Skip
   ENDDO
//--------------------------------------------------------
   IF RptVid==3.or.RptVid==4
      PoType=vert_menu(KodC,"�����",,0,18,1,'n/w,n/g,,,r/w',.T.)
      KodC:={KodC[IF(PoType==0,1,PoType)]}
      KodN:={KodN[IF(PoType==0,1,PoType)]}
   ENDIF
//--------------------------------------------------------
//   Close

	 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
	 aSizeDesktop  := oMainWindow:currentSize()
	 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
	 oDlg:title    := "����� ������ �� �窠� ������祭��" 
	 oDlg:SysMenu	:= .F.
	 oDlg:Configure()
	 oDlg:Show()
	 aSizeDesktop  := oDlg:currentSize()
	 aPos					:= oDlg:CurrentPos()
	 oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
	 oProgress:create()
	 oProgress:minimum := 1

   make_ind('0',schet_Share+'Balans.Dbf',schet_share+'Balans.ntx','KOD',,,.t.,.T.)
//   Close
//   Select 105
//   Close
//   Select 198
//   load("198",SCHET_Share+"Fyear.dbf",SCHET_Share+'FYear.ntx',,  .f.)
   Load('199',Schet_Share+'Balans.dbf',schet_share+'Balans.ntx')
   Select Balans
//   Obrabot("����� ������ �� �窠� ������祭��")
//   temp_=39/Len(KodC)
//   kol_kl=0
	 oProgress:maximum := Len(KodC)
   FOR i=1 To Len(KodC)
       Select 75
       go top
       FidRash:=0
       Seek KodN[i]
       IF Found()
          DO WHILE KodN[i]==FidersSc->Kod
             FidRash:=FidRash+ShowRash(WorkMonth)
             AllFidRash:=AllFidRash+FidRash
             Skip
          ENDDO
       ENDIF
       FWrite(Desc,KODC[i]+" <"+Str(FidRash)+">"+CrLf)
       IF RptVid==3.or.RptVid==4
           Select Balans
           Go Top
           Poisk:=KodN[i]
           Seek Poisk
           Do While BALANS->KOD==Poisk
              TmpKodC:=TmpKodC+1
              Skip
           ENDDO
//           temp_=39/TmpKodC
	 				 oProgress:maximum := TmpKodC
       ENDIF
       Select Balans
       Go Top
       Poisk:=KodN[i]
       Seek Poisk
       Do While BALANS->KOD==Poisk
   	  		oProgress:increment()																				// Progress Bar Increment
          IF RptVid==3.or.RptVid==4
//             kol_kl=kol_kl+temp_
//             colorwin(12,21,12,21+kol_kl,'n/n')
          ENDIF
          IF Month==Chr(WorkMonth)
//------------------------------------------------------------
           IF IsDelLic
            Calculate:=.T.
            For LenDl=1 To Len(DelLic)
                IF DelLic[LenDl]==Round(Summa/Rashod,3)
                   Calculate:=.F.
                ENDIF
            Next
           ELSE
            Calculate:=.T.
           ENDIF
           IF Calculate==.T.
             KodR[i]=KodR[i]+Rashod
             KodS[i]=KodS[i]+Summa
             IF Licevoj<99999
                KodGos[i]=KodGos[i]+Rashod
                nPoints[1]:=nPoints[1]+1
                nPoints[3]:=nPoints[3]+1
             ELSE
                KodChastn[i]=KodChastn[i]+Rashod
                nPoints[2]:=nPoints[2]+1
                nPoints[4]:=nPoints[4]+1
             ENDIF
           ENDIF
//------------------------------------------------------------
             IF RptVid>=2
//                Select 198
                Select FYEAR
                LastData:=DOP
                PresData:=CTOD("01."+Str(WorkMonth,2,0)+"."+AllTrim(Str(Year(New_date))))
                lSuccess := .T.
                fyear->(DBSEEK(Balans->Licevoj) )
                DO WHILE fyear->Ka ==Balans->Licevoj
                   IF DOP<PresData
                      LastData=DOP
                   ENDIF
                  Skip
                ENDDO

                select Balans
                IF RptVid==4
                   IF Rashod==0
                      IF Calculate==.T.
                         FWrite(Desc,Str(Licevoj,10,0)+" "+Potrebitel+" "+Str(Rashod,12,0)+;
                                  IF(Licevoj>99999.and.Rashod==0," => "+DTOC(LastData),"")+CrLf)
                      ENDIF
                   ENDIF
                ELSE
                   IF Calculate==.T.
                      FWrite(Desc,Str(Licevoj,10,0)+" "+Potrebitel+" "+Str(Rashod,12,0)+;
                               IF(Licevoj>99999.and.Rashod==0," => "+DTOC(LastData),"")+CrLf)
                   ENDIF
                ENDIF
             ENDIF
          ENDIF
          Select Balans
          Skip
       EndDo
       IF RptVid=1
          FSeek(Desc,-2,2)
       ENDIF
       IF RptVid>=2
          FWrite(Desc,"���ᥪ�� "+Str(KodGos[i],12,0)+"  ����� ᥪ�� "+Str(KodChastn[i],12,0)+"  ")
       ENDIF
       FWrite(Desc,IF(RptVid==2,"�⮣� ","   ")+Str(KodR[i],12,0))
       IF RptVid==1
// KodR[i] - ����祭�
// FidRash - ����祭�
					Iks:=Round(KodR[i]*100/FidRash,1)
//					Iks:=IF(Iks>100,0,Iks)
					IF FidRash>KodR[i]
						Iks:=IF(Iks>100,0,100-Iks)
					ELSE
						Iks:=0
					ENDIF
       		FWrite(Desc,"   "+Str(nPoints[1],5)+"   "+Str(nPoints[2],5)+"  "+IF(Iks==0,"      ",Str(Iks,5,1)+"%")+"    "+IF(KodR[i]>FidRash,"",Str(FidRash-KodR[i],12,0)) )
       		nPoints[1]:=0
       		nPoints[2]:=0
       ENDIF
       FWrite(Desc,CrLf)
       Itog1:=Itog1+KodR[i]
       Itog2:=Itog2+KodS[i]
//       kol_kl=kol_kl+temp_
//       colorwin(12,21,12,21+kol_kl,'n/n')
   NEXT
   FWrite(Desc,"�ᥣ�  <"+IF(RptVid==3,AllTrim(Str(FidRash,12,0)),AllTrim(Str(AllFidRash,12,0)))+"> "+Str(Itog1,12,0)+CrLf)
   Fwrite(Desc,"�� "+AllTrim(Str(nPoints[3]))+"    �� "+AllTrim(Str(nPoints[4]))+CrLf)
   FClose(Desc)
//   Select 198
//   Close
   Select 199
   Close
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
ENDIF
Select Fiders
Close
Select FidersSc
Close
//load("105",SCHET_SHARE+"FYear.dbf",SCHET_SHARE+'FYear.ntx',,  .f.)
Select(Sel)
Go Rec
//@ 3,0 say Select()
//@ 4,0 say Recno()
//Inkey(0)
RestScreen(0,0,MaxRow(),MaxCol(),Scr)
Return NIL




FUNCTION Fiders
LOCAL Sel:=Select(),Rec:=RecNo(),Win:=SaveScreen(0,0,24,79),Clr:=SetColor()
LOCAL Desc,Kol_Kl:=0,CrLf:=Chr(13)+Chr(10),Rash,Mon,Poisk,Itog:=0,sMon:=""
LOCAL eMon:="",Itog2:=0
Local oDlg,aSizeDeskTop,aPos,oProgress
Mon:=Month_Menu("��� ���� ��室� �� 䨤�ࠬ")
IF Mon==0
   Return NIL
ENDIF
sMon:="Pok"+AllTrim(Str(Mon))
eMon:="Pok"+AllTrim(Str(IF(Mon>1,Mon-1,12)))
Select 40
   Go Top

	 oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
	 aSizeDesktop  := oMainWindow:currentSize()
	 oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
	 oDlg:title    := "��ࠡ�⠭�" 
	 oDlg:SysMenu	:= .F.
	 oDlg:Configure()
	 oDlg:Show()
	 aSizeDesktop  := oDlg:currentSize()
	 aPos					:= oDlg:CurrentPos()
	 oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
	 oProgress:create()
	 oProgress:minimum := 1
	 oProgress:maximum := RecCount()
//   Obrabot("����� ��室� �� 䨤�ࠬ")
   Desc:=FCreate(DDir+ReportFile)
   FWrite(Desc,"�"+replicate("�",Len(Name))+ "�������������������������������Ŀ"+CrLf)
   FWrite(Desc,"�"+Center("�����",Len(Name)," ",.t.)+"�     ���室    �"+"   ����祭�    �"+CrLf)
   FWrite(Desc,"�"+replicate("�",Len(Name))+ "�������������������������������Ĵ"+CrLf)
   Do While .not.Eof()
   	  oProgress:increment()																				// Progress Bar Increment
//      Kol_Kl:=Kol_Kl+39/RecCount()
//      colorwin(12,21,12,21+kol_kl,'n/n')
      Select Licevoj
      Go Top
      Rash:=0
      DO WHILE .Not.EOF()
         IF .not.Empty(AllTrim(Razdel_1)).or..not.Empty(AllTrim(Razdel_2))
            FOR I=1 TO NumToken(NameIn->Fiders,";,")
                IF Atnum(Token(MYUpper(NameIn->Fiders),";,",I),MYUpper(Razdel_1))!=0.or.;
                   Atnum(Token(MYUpper(NameIn->Fiders),";,",I),MYUpper(Razdel_2))!=0
                   IF .Not.Reaktivn
                      Poisk:="("+Alltrim(Str(Lic_Sch))+")"+Alltrim(Schetchik)
                      Select(Mon)
                      Seek Poisk
                      IF Found()
                         Rash:=Rash+Rashod
                      ENDIF
                      Select Licevoj
                   ENDIF
                ENDIF
            NEXT
         ENDIF
         Skip
      ENDDO
      Select CountIn
      Seek NameIn->Number
      Select NameIn
      FWrite(Desc,"�"+Name+"�"+Str(Rash,15,0)+"�"+Str(CountIn->&sMon-CountIn->&eMon,15,2)+"�"+CrLf)
      Itog:=Itog+Rash
      Itog2:=Itog2+(CountIn->&sMon-CountIn->&eMon)
      Skip
   EndDo
   Select NameIn
   FWrite(Desc,"�"+replicate("�",Len(Name))+ "���������������������������������"+CrLf)
   FWrite(Desc," "+Space(Len(Name))+" "+Str(Itog,15,0)+" "+Str(Itog2,15,2)+CrLf)
   Close
   FClose(Desc)
   oProgress:destroy()																							// Progress Bar Destroy
   oDlg:Destroy()
RestScreen(0,0,24,79,Win)
SetColor(Clr)
Select(Sel)
Go Rec
RETURN Nil




Function NameFiders()
Local Win:=Win_Save(),Clr:=SetColor()
Set Color To &GetColor
ColorWin(11,05,13,76,"n+/n")
@ 10,04 SAY "�����������������������������������������������������������������������ķ"
@ 11,04 SAY "�"+space(71)+"�"
@ 12,04 SAY "�����������������������������������������������������������������������ͼ"
@ 11,06 SAY SubStr(Fiders,1,68)
@ 10,05 SAY Center("������祭�� ���ॡ�⥫� � "+AllTrim(Name),69,"�",.t.)
IF RecLock()
   Set Cursor On
   @ 11,06 get Fiders Picture "@S68"
   Read
   Set Cursor Off
   UNLOCK
ENDIF
Win_Rest(Win)
SetColor(Clr)
Return NIL