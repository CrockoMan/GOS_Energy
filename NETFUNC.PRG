// ����� � �⥢묨 �㭪�ﬨ

#define NET_WAIT     0.5   // Seconds to wait between between retries
#define NET_SECS     2     // Number of seconds to continue retry

// ���������� ����� � ��
FUNCTION NetAppend( nWaitSeconds )
   LOCAL lForever           // ��᪮���� ����⪨ ?
   LOCAL win:=win_save(maxrow(),1,maxrow(),30),clr:=setcolor()
   nWaitSeconds:=IF(nWaitSeconds==NIL,30,nWaitSeconds)
   set color to g*/r+
   @ maxrow(),1 say "���������� "
   nRetry:=nWaitSeconds
   APPEND BLANK
   IF !NETERR()
      win_rest(win); setcolor(clr)
      RETURN ( .T. )        // ������ ��������� �ᯥ譮 !!!
   ENDIF
   lForever:=(nWaitSeconds==0)
//------------------------- ������ ��⨥ �����஢�� ��� ���������� �����...
   DO WHILE ( lForever .OR. ( nWaitSeconds > 0 ) )
   		@ maxrow(),1 say "��������� "
      APPEND BLANK
      IF !NETERR()
         win_rest(win); setcolor(clr)
         RETURN ( .T. )          // ��������� !!!
      ENDIF
      INKEY( NET_WAIT )          // ��� NET_WAIT ᥪ㭤 ��� ᫥���饩 ����⪨
      nWaitSeconds  -= NET_WAIT
      IF .not.(nWaitSeconds>0)
        IF al_box({"���� ������ ����� ��㣨� ���짮��⥫��",;
                 "������� �������� �᢮�������� ����"},2,;
                 {" ������� "," �⬥���� "})==1
                 nWaitSeconds:=nRetry
        ELSE
           win_rest(win); setcolor(clr)
           return .F. // �� ���������...
        ENDIF
      ENDIF
   ENDDO
   win_rest(win); setcolor(clr)
RETURN ( .F. )       // �� ��������� :-(



// �����஢���� ����� � ��
FUNCTION RecLock( nSeconds )
   LOCAL lForever          // ��᪮���� ����⪨?
   LOCAL nRetry
   LOCAL win:=win_save(maxrow(),1,maxrow(),30),clr:=setcolor()
   nSeconds:=if(nSeconds==NIL,30,nSeconds)
   nRetry:=nSeconds
   set color to g*/r+
   @ maxrow(),1 say "�����஢���� "
   IF RLOCK()
      win_rest(win); setcolor(clr)
      RETURN ( .T. )       // �������஢���.
   ENDIF
   lForever := ( nSeconds == 0 )
//------------------------- ������ ��⨥ �����஢�� ��� ���������� �����...
   DO WHILE ( lForever .OR. ( nSeconds > 0 ) )
      IF RLOCK()
         win_rest(win); setcolor(clr)
         RETURN ( .T. )    // ���������
      ENDIF
   		@ maxrow(),1 say "�����஢�� "
      INKEY( NET_WAIT )    // ��� NET_WAT ᥪ㭤...
      nSeconds -= NET_WAIT
      if .not.(nSeconds>0)
        IF al_box({"���� ������ ����� ��㣨� ���짮��⥫��",;
                 "������� �������� �᢮�������� ����"},2,;
                 {" ������� "," �⬥���� "})==1
                 nSeconds:=nRetry
        ELSE
           win_rest(win); setcolor(clr)
           return .F.     // �� ���������...
        ENDIF
      endif
   ENDDO
   win_rest(win); setcolor(clr)
RETURN ( .F. )          // �� ���������



********************************************************************
* LOGICAL netuse(cdatabase, lopenmode, nseconds)
* CHARACTER cdatabase - ��� ���� ������
* LOGICAL lopenmode   - ����� ������. .T. ���������, .F. ࠧ���塞�
* NUMERIC nseconds    - ��᫮ ᥪ㭤 �������� (0 = ����� �� 㯮�)
* ������� - .T., �᫨ �ᯥ譠, .F., �᫨ ���
* Nantucket �㭪�� netuse � ����������⢨�� � ���짮��⥫��, �᫨ USE
* �����訫��� ���਩��
* ��ࠧ�� �맮��:  IF netuse("calls", .F., 5)
*
FUNCTION netuse(cDatabase, lOpenMode, nSeconds, cAlias,lAsk)
LOCAL forever, restart, Wait_Time
LOCAL win:=win_save(maxrow(),1,maxrow(),MaxCol()),clr:=setcolor()
    lOpenMode:=if(lOpenMode==NIL,.F.,lOpenMode)
    nSeconds:=if(nSeconds==NIL,30,nSeconds)
    cAlias:=if(cAlias==NIL,"",cAlias)
    lAsk:=if(lAsk==NIL,.T.,lAsk)
    restart = .T.
    forever = (nseconds = 0)
    DO WHILE restart
        Wait_Time = nSeconds
        DO WHILE (forever .OR. Wait_Time > 0)
   				 @ maxrow(),1 say "����⨥ "+cDatabase
           IF !Empty(cAlias)
            IF lOpenMode
                USE (cdatabase) EXCLUSIVE Alias &cAlias
            ELSE
                USE (cdatabase) SHARED Alias &cAlias
            ENDIF
           ELSE
            IF lOpenMode
                USE (cdatabase) EXCLUSIVE
            ELSE
                USE (cdatabase) SHARED
            ENDIF
           ENDIF
           IF !neterr()
           		 win_rest(win); setcolor(clr)
               RETURN .T.
           ENDIF
           inkey(0.3)
           Wait_Time --
        ENDDO
        * �����஢���� �� 㤠����, ��ᨬ ���짮��⥫�, �த������ ��
        IF lAsk
           restart = IF(Al_Box({"�訡�� �����஢�� (������) " + cdatabase },2,;
                               {" ������� "," ��室 "})==1,.T.,.F.)
        ELSE
           Restart:=.F.
        ENDIF
    ENDDO
    win_rest(win); setcolor(clr)
RETURN .F.



********************************************************************
* LOGICAL fillock(nseconds)
* NUMERIC nseconds
* ������� - .T., �᫨ �ᯥ譠, .F., �᫨ ���
* ��楤�� �����஢���� 䠩�� � ����������⢨�� � ���짮��⥫��, �᫨
* �����஢���� �� 㤠����
* ��ࠧ�� �맮��:
* IF fillock(5)
*
FUNCTION FileLock(nseconds)
LOCAL lforever, restart, wait_time
LOCAL win:=win_save(maxrow(),1,maxrow(),MaxCol()),clr:=setcolor()
    nSeconds:=IF(nSeconds=NIL,0,nSeconds)
    set color to g*/r+
    @ maxrow(),1 say "�����஢���� "
//    sound(700,2)
    IF flock()
       win_rest(win); setcolor(clr)
       RETURN (.T.)            && �������஢��
    ENDIF
    Wait_Time:=nSeconds
    restart = .T.
    lforever = IF(nSeconds=0,.T.,.F.)
    DO WHILE restart
        wait_time = nseconds
        DO WHILE (lforever .OR. wait_time > 0)
            inkey(.5)            && ����� 1/2 ᥪ㭤�
            wait_time = wait_time - .5
            IF flock()
               win_rest(win); setcolor(clr)
               RETURN (.T.)     && �������஢��
            ENDIF
        ENDDO
        * �����p������ �� 㤠����, ��ᨬ ���짮��⥫�, �த������ ��
        restart = IF(Al_Box({"�訡�� �����஢�� 䠩�� " + cdatabase },2,;
                            {" ������� "," ��室 "}),.T.,.F.)
    ENDDO
   win_rest(win); setcolor(clr)
RETURN (.F.)                     && �� �������஢��