proc p_reestr
private rec_buf,ord_buf,buff,color_buf,nm1,nm2,nm3,nm4,t1,l1,b1,r1,old_ed,temp1
//Private IsEdit:=.T.
rec_buf=recno()
ord_buf=indexord()
buff=win_save(6,0,maxrow()-1,maxcol())
color_buf=setcolor()
old_sel=select()
if urov<1
        if (.not. file(Ddir+'reestr.dbf'))
                sign(2)
                set color to (color_buf)
                win_rest(buff)
                return
        else
                select reestr
//                if select()#66
//                        select 66
//                endif
endif
******************************************************************************
        temp1=substr(dtoc(new_date+1),1,2)+' '+mesqc(month(new_date+1),1)+' '+;
                alltrim(str(year(new_date+1)))+' ����'
**********************  ���᫥��� ⥪�饩 ����  *****************************
        itogo=0
        postawshik=SchetNameOrg
        bank='����᪨� 䨫��� ��� ��� "�������-�� ����" �.�����'
        ot=temp1+space(35-len(temp1))
        s_=temp1+space(35-len(temp1))
        schet="40602810300000000005 "
        old_ed=edit
        edit=.t.
endif
do while .t.
        set color to n/w
        declare zgl[6]
        declare fil[6]
        inp='00'
        nm1=loarr('zgl',"��� ��.",'N ����',"���",'    �㬬�    ',"       ���","    ��� ��⥫�騪�")
        nm2=loarr('fil',"VidOp",'plat_treb',"Data",'summa',"Bik","Schet")
        go top
        t1=7
        l1=1
        b1=23
        r1=78
        fsbrowse(7,1,23,78,'fil','zgl',inp,urov,Edit)
//      fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
        set color to
        if Al_Box({'�� ��室� ����� ��������� !',;
                      '�������� ࠡ��� �� �����⮢��',;
                      '⥪�饣� ॥��� ?'},2)==1
                     exit
        endif
enddo
tobank()
select 66
zap
if file(Ddir+"reestr.txt")
        deletefile(Ddir+'reestr.txt')
endif
select(old_sel)
set color to (color_buf)
set order to ord_buf
go rec_buf
win_rest(buff)
edit=old_ed
keyboard chr(87)
return
*********************************





proc reestr
Local IsCentury:=CSetCent()
old_col=setcolor()
save screen
Set Century Off
if Al_Box({'�� ����⢨⥫쭮 ��� ᣥ���஢��� ॥���'},2)==1
        rec=recno()
        go top
        count=0
        do while !eof()
                if !deleted()
                        count=count+1
                endif
                skip
        enddo
        obrabot()
        temp_=40/count
        kol_kl=0
        go top
        mpsum2=''
        desc=fcreate(Ddir+'reestr.txt')
        if desc=-1
                Myerror('  ���������� ᮧ���� 䠩� ����, �������� ��� ����� !!!  ')
                fclose(desc)
                restore screen
                setcolor(old_col)
                return
        endif
        mpsum1=str_chislo(itogo)
        Perem:=chr(27)+chr(77)+"                                                                           --------"+chr(13)+chr(10)
        perem:=Perem+"                                         ������                            |0401014|"+chr(13)+chr(10)
        Perem:=Perem+"                  ���������� �� ������� ��������� ����������               --------"+chr(13)+chr(10)
        Perem:=Perem+"                            N "+AllTrim(Schet_Reestr)+" �� "+AllTrim(Ot)+chr(13)+chr(10)
        perem:=Perem+"���⠢騪 (���᪠⥫�) "+postawshik+chr(13)+chr(10)
        fwrite(desc,perem)
        perem="���㦨���騩 ���� "+alltrim(bank)+chr(13)+chr(10)
        fwrite(desc,perem)
        perem="�।�⠢�塞 �� ������ ���⥦�� ���㬥��� � ������⢥ "+str(count,3,0)+" �� �㬬� "+alltrim(str(itogo,14,2))+chr(13)+chr(10)
        fwrite(desc,perem)
        perem="�㬬� �ய���� "+AllTrim(MpSum1)+chr(13)+chr(10)+AllTrim(MpSum2)+chr(13)+chr(10)
        FWrite(Desc,Perem)
        FWrite(Desc,"------------------------------------------------------------------------------------------"+chr(13)+chr(10))
        FWrite(Desc,"|  N |��� ��| N �  ��� ���㬥�� |�㬬� ����.|        ���         |       ���         |"+chr(13)+chr(10))
        FWrite(Desc,"------------------------------------------------------------------------------------------"+chr(13)+chr(10))
        count=0
        perem=''
        do while .not.eof()
           Count++
           FWrite(Desc,"|"+STR(Count,4,0)+"| "+VidOp+"|"+Plat_Treb+" "+Dtoc(Data)+"|"+Str(Summa,12,2)+"|"+BIK+"|"+Schet+"|"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                skip
        enddo
        fwrite(desc,"                                      ������                             �⬥⪨ �����"+chr(13)+chr(10))
        fwrite(desc,"                                      ________________________"+chr(13)+chr(10))
        fwrite(desc,"           �.�."+chr(13)+chr(10))
        fwrite(desc,"                                      ________________________"+chr(13)+chr(10)+chr(27)+chr(80))
        colorwin(12,21,12,21+40,'n/n')
        fclose(desc)
else
        restore screen
        setcolor(old_col)
        return
endif
go rec
set color to r+/n
AL_Box({'�����⮢�� ॥��� �����祭�'})
restore screen
setcolor(old_col)
Set Century On
return



proc print
if Al_Box({'��  ����⢨⥫쭮  ���','�⯥���� �����⮢����� ॥���'},2)==1
   if file(Ddir+'reestr.txt')
      Print_Fi(.F.,Ddir+'reestr.txt')
//                   copy_(Ddir+'reestr.txt','prn')
   else
      Al_Box({'������ �� �����㦥�'})
   endif
endif
Clear Typeahead
return


proc nastroYka
Local TypeBank,OScr
save screen
if .not.file(Ddir+"reestr.txt")
   schet_reestr=substr(alltrim(str(int(val(schet_reestr)+1)))+space(29),1,29)
endif
old_color=setcolor()
set color to &GetColor
colorwin(0,0,9,45,'b/n')
@ 00,00,08,44 box "         "
@ 00,01 say "�����������������������������������������ͻ"
@ 01,01 say "� ������  N"+space(31)+"�"
@ 02,01 say "� ���⠢騪                               �"
@ 03,01 say "� ���� ���⠢騪�                         �"
@ 04,01 say "� ��"+space(38)+"�"
@ 05,01 say "� �� ⮢�ࠬ,���饭��, ��稭�� �        �"
@ 06,01 say "�"+space(41)+"�"
@ 07,01 say "� N ��� ���⠢騪�                      �"
@ 08,01 say "�����������������������������������������ͼ"
@ 01,13 say schet_reestr
@ 02,13 say Alltrim(postawshik)
@ 03,19 say substr(bank,1,22)
@ 04,06 say ot
@ 06,03 say s_
@ 07,22 say schet

//TypeBank:=al_box({"������ ���� ��� �ନ஢���� ॥���"},2,{" ������ "," ��� 1804 "," �ࠩ�����⡠�� "})

spisok:={" ������                  ",;
         " ���",;
         " �ࠩ������",;
         " ���ப������     "}
is_choice:={.t.,.t.,.t.,.t.}
OScr:=Win_SAve()
TypeBank=vert_menu(spisok,"�롥�� ����",is_choice,9,28,1,'n/w,n/g,,,r/w',.F.)
Win_Rest(OScr)
DO Case
   Case TypeBank=2
        M->bank="��� 1804 �.�����      "
        M->schet="40702810630040100367 "
   CASE TypeBank=3
        M->bank='��� "�ࠩ�����⡠��" �.��᭮���'
        M->schet="40702810400070000029 "
   CASE TypeBank=4
        M->bank='��� "������������" � �.������ᨩ᪥ �.������ᨩ�'
        M->schet="40702810400120100263 "
   OTHERWISE
        M->bank='����᪨� 䨫��� ��� ��� "�������-�� ����" �.����� '
        M->schet="40602810300000000005 "
ENDCASE


set cursor on
set confirm on
set color to &GetColor
do while lastkey()#27
   @ 01,13 get schet_reestr picture('@K NNNNNNNNNNNNNNNNNNNNNNNNNNNN')
   @ 02,13 get postawshik picture('@K XXXXXXXXXXXXXXXXXXXXXXXXXXXX')
   @ 03,19 get M->bank picture ("@S22")
   @ 04,06 get ot picture('@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
   @ 06,03 get s_ picture('@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
   @ 07,22 get M->schet picture('@K XXXXXXXXXXXXXXXXXXXXX')
   read
enddo
Clear Typeahead
set confirm off
set cursor off
setcolor(old_color)
restore screen
return



/* �㭪樨 ࠡ��� � ����� ������ ॣ����樨 ���⥦�� TOBANK */

// ���� ���⥦�� �� TOBANK �� �� ������ � ���������� ��������� ४����⮢
function tobank()
LOCAL select:=select(),screen:=obrabot("������ ��ࠢ������ ���⥦��")
LOCAL temp_:=39/reccount(),kol_kl:=0
go top
do while !eof()
        colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
        select tobank
        seek val(alltrim(reestr->plat_treb))
        if !found()
           if netappend()
//               replace tobank->plat_treb with val(alltrim(reestr->plat_treb))
               replace plat_treb with val(alltrim(reestr->plat_treb))
               unlock
           endif
        ELSE
          if reclock()
//             replace tobank->summa with reestr->summa
//             replace tobank->reestr with space(10-len(substr(alltrim(schet_reestr),;
//                                     1,10)))+substr(alltrim(schet_reestr),1,10)
             replace summa with reestr->summa
             replace reestr with space(10-len(substr(alltrim(schet_reestr),;
                                     1,10)))+substr(alltrim(schet_reestr),1,10)
             unlock
          endif
        endif
        select(select)
        skip
enddo
select(select)
win_rest(screen)
return NIL

/****************************************************************************/
/*         ������ ᣥ���஢����� ���⥦�� � ���� ������                    */
/****************************************************************************/
function writetobank(licevojschet,writestring)
LOCAL select:=select(),recno:=recno()
licevojschet:=if(licevojschet==NIL,main->lic_schet,licevojschet)
writestring:=if(writestring==NIL,'',writestring)
select tobank
if netappend()
   replace lic_schet with licevojschet
   replace tip with writestring
   replace plat_treb with M->schet_treb
   replace data with new_date+1
   unlock
else
     al_box({"���⥦�� ��  ��ॣ����஢���  �  ��ࠢ������",;
             "�� �⪠������ ������� �᢮�������� ���� ������"})
endif
select(select)
go recno
return NIL


FUNCTION MenuToBank()
LOCAL screen:=win_save(18,40,22,72)
colorwin(19,41,22,72,'n+/n')
@ 18,40,21,71 BOX "�ķ���Գ "
do while .t.
        @ 19,41 prompt " ���� �� ���ॡ�⥫�         "
        @ 20,41 prompt " �������� �ᯮ����⥫���     "
        menu to menutobank
        do case
                case menutobank=1
                        OtchetToBank()
                case menutobank=2
                        if al_box({"�� ����⢨⥫쭮 ��� 㤠���� ���⥦��,",;
                                   "����� ���뫨 ��ࠢ���� � ����?"},2,;
                                  {" ������� "," �� 㤠���� "},,,,,,,;
                                  "gr+/r+,w/b+,,,gr/r+")=1
                                DeleteToBank()
                        endif
                otherwise
                        exit
        endcase
enddo
win_rest(screen)
RETURN NIL



FUNCTION DeleteToBank()
LOCAL select:=select(),recno:=recno(),temp_,kol_kl,total:=0
LOCAL screen:=obrabot("�������� ����ࠢ������ ���⥦��")
select tobank
go top
temp_:=39/reccount()
kol_kl:=0
DO WHILE .not.eof()
        colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
        if empty(tobank->reestr).and.empty(tobank->summa)
           if reclock()
                DELETE=.T.
                delete
                total++
                unlock
           endif
        endif
        skip
ENDDO
go recno()
al_box({"�ᥣ� 㤠����  ����ࠢ������ ���⥦�� - "+alltrim(str(total))+"��."},,,,,,,,,"gr+/r+,w/b+,,,gr/r+")
win_rest(screen)
select(select)
go recno
RETURN NIL


FUNCTION OtchetToBank()
LOCAL select:=select(),recno:=recno(),temp_,kol_kl,total:=0,desc
LOCAL screen:=win_save(20,50,23,76),startdate:=new_date,enddate:=new_date
LOCAL cCrLf:=chr(13)+chr(10),color:=setcolor(),allsumma:=0
startdate:=EndDate-10
colorwin(21,51,23,76,'n+/n'); setcolor("n/w,n/g,,,n/w")
@ 20,50,22,75 BOX "�ķ���Գ "
set curs on; set conf on
@ 21,51 say " �" get startdate
@ 21,63 say "��" get enddate
read
set curs off; set conf off
setcolor(color); win_rest(screen)
IF Lastkey()!=27
        select tobank;  go top
        temp_:=39/reccount();   kol_kl:=0
        screen:=obrabot("��ࠢ����� ���⥦�� c "+dtoc(startdate)+'�� '+dtoc(enddate))
        desc:=fcreate(Ddir+'otchet.gkv')
        fwrite(desc,"   ���⥦��, ��ࠢ����� � ���� � ��ਮ� � "+alltrim(dtoc(startdate))+;
        ' �� '+alltrim(dtoc(enddate))+cCrLf)
        fwrite(desc,center("���ॡ�⥫� : "+alltrim(main->potrebitel),70,' ')+cCrLf)
        fwrite(desc,"----------------------------------------------------------------------"+cCrLf)
        fwrite(desc,"  NN   |    C㬬�     |   ���   |  ������ N  |    ��� ���⥦�        "+cCrLf)
        fwrite(desc,"-------|--------------|----------|------------|-----------------------"+cCrLf)
        DO WHILE .not.eof()
                colorwin(12,21,12,21+(kol_kl:=kol_kl+temp_),'n/n')
                if tobank->data>=startdate.and.tobank->data<=enddate.and.;
                   tobank->lic_schet=main->lic_schet
                        fwrite(desc,str(Plat_Treb,6,0)+" | "+str(summa,12,2)+;
                        " | "+dtoc(data)+" | "+reestr+" | "+tip+cCrLf)
                        total++
                        AllSumma:=AllSumma+Summa
                endif
                skip
        ENDDO
        fwrite(desc,"----------------------------------------------------------------------"+cCrLf)
        fclose(desc);   win_rest(screen)
        if total=0
                deletefile(Ddir+'otchet.gkv')
        endif
        select(select);         go recno
        al_box({"�ᥣ� ��ࠢ���o ���⥦�� c "+dtoc(startdate)+" �� "+;
                dtoc(enddate)+" - "+alltrim(str(total))+"��.","�� ����� �㬬� "+Alltrim(Str(AllSumma))+" �㡫��"})
ENDIF
RETURN NIL