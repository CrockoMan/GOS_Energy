**********************************************************************
* �������஢��� � ���箬 /n.
* ������� ���� �� ⥪�⮢��� 䠩��, ��⥬ ����饭�� ���� ��६�����
* ��� ����� �� �� ॠ��� ���祭��. �᪫�祭�� ��⠢���� ��६����
* ⨯� STATIC � LOCAL. �� ��६���� ����� �ᯮ�짮���� � �����.
* ����� ������ ���� ��६���� � ������� ������ ":=",
* ������ "=" ���ਭ������� ��� �ࠢ�����. ��ப�, ᮤ�ঠ騥
* �訡��� ����� � ���� �� ���������.
* �᫨ ����饭�� �� �ந��諮, � ᫥���騩 �஡�� 㤠�����.
* ��ப�, ��稭��騥�� � ᨬ���� NO_PRINT_STRING � ��室��� 䠩� ��
* ���������, �� ����⢨� ���ᠭ�� � ��� ᮢ�������.
*
* report(in_file, out_file, width)
*
#define LEFT_DELIM chr(123)        && {
#define RIGHT_DELIM chr(125)       && }
#define NO_PRINT_STRING '#'        && ��ப� ���������
#define PRINT_AS_IS "@"            && ��ப�, ���⠥��� ��� ����

**********************************************************************
* ������� ��।���� ⥪�⮢� 䠩� ����饭��� ���� ��६�����, ���㦥����
* ࠧ����⥫ﬨ LEFT_DELIM � RIGHT_DELIM, ⥪�騬 ���祭��� ��६����� ��� ����
* � ⥪�饩 �����.
* �㭪�� ࠡ�⠥� ��⥬ �����筮�� �⥭�� ⥪��, ���᪠ � ������
* ��ப� ����, �����祭��� � ࠧ����⥫�. ����� ⠪�� ���
* �������, ��� ����頥��� ⥪�騬 ��� ���祭���.
* STATIC � LOCAL ��६���� � ���� �뢥���� �� ����, ������� - Clipper!
FUNCTION report(input_file, out_file, width,ejectpage)

LOCAL bad_line, end_marker, found_one, i_string, meta_symbol
LOCAL meta_type:="", next_marker, num_lines, rep_with, this_line, the_memo, desc
LOCAL temp_, kol_kl, m_screen_gkv, _set_marker, is_cursor:=csetcurs()
LOCAL rowstart:=if(maxrow()<25,16,int(maxrow()/2)),AsIs:=.F.
Local oDlg,aSizeDeskTop,aPos,oProgress

* ��६���� �� 㬮�砭��
input_file := if(input_file==NIL,"report.rpt",input_file)
out_file := if(out_file == NIL,"otchet.prn", out_file)
width := if(width == NIL,120,width)
ejectpage:=if(ejectpage==NIL,.f.,ejectpage)
if is_cursor
        set cursor off
endif

IF file(input_file)
        the_memo=memoread(input_file)
        desc=fcreate(out_file)

        num_lines = mlcount(the_memo, width)
//      m_screen_gkv:=savescreen(0,0,24,79)
        vstk_push()
//        m_screen_gkv:=obrabot("�����⮢�� ����",rowstart)

                                m_screen_gkv:=Win_Save()
                                oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
                                aSizeDesktop  := oMainWindow:currentSize()
                                oDlg:create(oMainWindow ,, {100,150}, {aSizeDeskTop[1]-200,90} )
                                oDlg:title    := "�����⮢�� ����"
                                oDlg:SysMenu    := .F.
                                oDlg:Configure()
                                oDlg:Show()
                                aSizeDesktop  := oDlg:currentSize()
                                aPos                                    := oDlg:CurrentPos()
                                oProgress               := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

                                oProgress:create()
                                oProgress:minimum := 1
                                oProgress:maximum := Num_Lines
//        obrabot(rowstart)
//        temp_=39/num_lines
//        kol_kl=0

        * ����७�� � ����� ������ ��ப�
        FOR i_string = 1 TO num_lines

                                oProgress:increment()                                                                                                                                                           // Progress Bar Increment
//            kol_kl=kol_kl+temp_
//            colorwin(rowstart+2,21,rowstart+2,21+kol_kl,'gr+/gr+')

            this_line = memoline(the_memo, width, i_string)

            * ����७�� ��⠤����� ��। ������

            * �᫨ ��ப� "�����", �.�. ᮤ�ন� ��ᮯ��⠢���
            * ࠧ����⥫� ��� ��������� ����� �����, � �� �� ������
            bad_line = .F.

            * �᫨ ���� �� �ࠩ��� ��� ���� ���ᨬ���, �� ��ப�
            * ��᫥ ���७�� ����, � �� �� ������
            found_one = .F.

            next_marker = at(LEFT_DELIM, this_line)
new_marker = at(chr(91), this_line)
not_space=.F.
        if new_marker#0
            if next_marker=0
                next_marker=new_marker
                not_space=.T.
            else
                if next_marker<new_marker
                        not_space=.F.
                else
                        next_marker=new_marker
                        not_space=.T.
                endif
            endif
        else
                not_space=.F.
        endif

            * ����७�� ��� ���ᨬ����� � ��ப�
            DO WHILE next_marker != 0 .AND. !bad_line

               found_one = .T.
               end_marker = at(if(!not_space,RIGHT_DELIM,chr(93)), this_line)

               * �᫨ �� ������ �������騩 ࠧ����⥫�
               * ��������� �஡����
               IF end_marker = 0
                  bad_line = .T.
               ELSE
                  * ���⨥ ���ᨬ���� �� ࠧ����⥫��
//                  meta_symbol = substr(this_line, next_marker + 1, ;
//                                       end_marker - next_marker - 1)
                  meta_symbol = alltrim(substr(this_line, next_marker + 1, ;
                                       end_marker - next_marker - 1))

//                  Rep_With = ">"+Meta_Symbol+"<"
                  * �᫨ ���� ��।�����, �������� ��� ⥪�饥
                  * ���祭�� � ��ப�
                  Meta_Type=""
                  DO Case
                     Case AllTrim(MYUpper(Meta_Symbol))=="�����������"
                          Meta_Symbol="�����������"
                          Meta_Type="MyFunc"
                     Case AllTrim(MYUpper(Meta_Symbol))=="�������"
                          Meta_Symbol="Main->Lic_Schet"
                     Case AllTrim(MYUpper(Meta_Symbol))=="���".or.AllTrim(MYUpper(Meta_Symbol))=="�HH"
                          Meta_Symbol="InnPotrebitel"
                     Case AllTrim(MYUpper(Meta_Symbol))=="����"
                          Meta_Symbol="new_date"
                     Case AllTrim(MYUpper(Meta_Symbol))=="�����"
                          Meta_Symbol="Day(new_date)"
                     Case AllTrim(MYUpper(Meta_Symbol))=="�����"
                          Meta_Symbol="CMonth(new_date)"
                     Case AllTrim(MYUpper(Meta_Symbol))=="�����2"
                          Meta_Symbol="�����2"
                          Meta_Type:="MyFunc"
                     Case AllTrim(MYUpper(Meta_Symbol))=="���"
                          Meta_Symbol="Year(new_date)"
                     Case AllTrim(MYUpper(Meta_Symbol))=="���������".or.AllTrim(MYUpper(Meta_Symbol))=="H��������"
                          Meta_Symbol="���������"
                          Meta_Type="MyFunc"
                     Case AllTrim(MYUpper(Meta_Symbol))=="��������".or.AllTrim(MYUpper(Meta_Symbol))=="������H�"
                          Meta_Symbol="��������"
                          Meta_Type="MyFunc"
                     Case AllTrim(MYUpper(Meta_Symbol))=="������"
                          Meta_Symbol="������"
                          Meta_Type="MyFunc"
                     Case AllTrim(MYUpper(Meta_Symbol))=="���������"
                          Meta_Symbol="���������"
                          Meta_Type="MyFunc"
                     Case AllTrim(MYUpper(Meta_Symbol))=="����"
                          Meta_Symbol="Chr(12)"
                  ENDCASE
//                  @ 1,0 say Meta_Type
//                  @ 2,0 Say Empty(Meta_Type)
                  Meta_Type = IF(Empty(Meta_Type),Type(Meta_Symbol),Meta_Type)
//                  Al_Box({Meta_Symbol+" "+Meta_Type})
//                  meta_type = type(meta_symbol)

                  DO CASE
                     Case Meta_Type = "MyFunc"
                          Rep_With:=MyFuncMeta(Meta_Symbol)
//                     Case Meta_Type = "MyTypeC"
//                          Rep_With = AllTrim()
                     CASE meta_type = "C"    && ⨯ character
                          if at(":=", meta_symbol) = 0
                                  rep_with = trim(&meta_symbol)+' '
                          else
                                  rep_with = ""
                          endif

                     CASE meta_type = "D"    && ⨯ date
                          if at(":=", meta_symbol) = 0
                                  rep_with = dtoc(&meta_symbol)+' '
                          else
                                  rep_with = ""
                          endif

                     CASE meta_type = "N"    && ⨯ numeric
                          if at(":=", meta_symbol) = 0
                                  rep_with = ltrim(str(&meta_symbol))+' '
                          else
                                  rep_with = ""
                          endif

                     CASE meta_type = "B"    && ⨯ Block
                          tmp_rep_with:=eval(&meta_symbol)
                          do case
                             CASE type(tmp_rep_with) = "C"    && ⨯ character
                                  rep_with = trim(tmp_rep_with)
                             CASE type(tmp_rep_with) = "D"    && ⨯ date
                                  rep_with = dtoc(tmp_rep_with)
                             CASE type(tmp_rep_with) = "N"    && ⨯ numeric
                                  rep_with = ltrim(str(tmp_rep_with))
                          endcase


//                     CASE meta_type = "U"     && ����।������ ⨯
                     CASE meta_type = "UE" .or.;
                          meta_type = "UI" .or.;
                          meta_type = "U"   && ����।������ ⨯
                          rep_with = ""
                          bad_line = .T.

                     OTHERWISE
                          rep_with = ""

                  ENDCASE

                  IF rep_with == ""
                  * �᫨ �� �ந��諮 ����饭�� ���ᨬ���� �� �����,
                  * �� ����� 㤠���� �஡��, ࠭�� ��⠭�������
                  * �� ���ᨬ�����. ��� �⮣� ����室��� ᤥ����
                  * ��ன substr ��稭�� � end_marker + 2

                    this_line = substr(this_line, 1, ;
                                next_marker - 1) ;
                                + if(substr(this_line, end_marker + 1)=' ',;
                                     substr(this_line, end_marker + 2),;
                                     substr(this_line, end_marker + 1))
//                                + substr(this_line, end_marker + 1)
                  ELSE
                   IF Substr(This_Line,1,1)!=PRINT_AS_IS
                  * ������ ��६����� �� �ଠ�� �࠭���� ��થ஢
                    rep_with=substr(rep_with, 1, end_marker - ;
                                 next_marker - 1+2)
//                               next_marker - 1)
                    if !not_space
                            rep_with=alltrim(rep_with)+space(end_marker - ;
                                 next_marker - 1 - len(alltrim(rep_with))+2)
//                               next_marker - 1 - len(alltrim(rep_with)))
                    else
                            rep_with=alltrim(rep_with)
                    endif

                    this_line = substr(this_line, 1, ;
                                next_marker - 1) + rep_with + ;
                                + substr(this_line, end_marker + 1)
                   ELSE
                     This_Line:=Rep_With
                   ENDIF
                  ENDIF

                  * ������ �饬 ᫥���騩 ���� ��થ� ...
                  next_marker = at(LEFT_DELIM, this_line)
new_marker = at(chr(91), this_line)
not_space=.F.
        if new_marker#0
            if next_marker==0
                next_marker:=new_marker
                not_space:=.T.
            else
                if next_marker<new_marker
                        not_space:=.F.
                else
                        next_marker:=new_marker
                        not_space:=.T.
                endif
            endif
        else
                not_space:=.F.
        endif

               ENDIF
            ENDDO

               * �⮡ࠦ���� ��ப� � ��砥 �᫨:
               * 1 - � ��� �� �뫮 ��⠤����� ���
               * 2 - ��⠤���� �뫨, �� ����� �뫨 ���४��
               * � ���७��� ��ப� �� ����

               IF !found_one .OR. (!empty(this_line) .AND. !bad_line)
                IF substr(this_line,1,1)#NO_PRINT_STRING
//                  fwrite(desc,substr(rtrim(this_line),1,width)+chr(13)+chr(10))
                  fwrite(desc,rtrim(this_line)+if(i_string#num_lines,;
                         chr(13)+chr(10),if(ejectpage,chr(12),"")+chr(26)))
                ENDIF
               ENDIF
        NEXT
        fclose(desc)
//      restscreen(0,0,24,79,m_screen_gkv)
                        oProgress:destroy()                                                                                                                                                                                     // Progress Bar Destroy
                        oDlg:Destroy()
        win_rest(m_screen_gkv)
        vstk_pop()
ELSE
        Al_box({"���� 蠡���� ���� "+alltrim(input_file)+" ���������"})
ENDIF
if is_cursor
   set cursor on
endif
RETURN NIL


Function MyFuncMeta(Meta)
Local ReturnValue:="",Val
Do Case
   Case Meta="�����������"
        ReturnValue:=AllTrim(Delstring(Main->Potrebitel,"���"))
   Case Meta="�����2"
        ReturnValue:=AllTrim(Mesqc(Month(new_date),.t.))
   Case Meta="���������"
        Val:=GetSum(Main->Lic_Schet,Month(new_date))
        ReturnValue=Alltrim(Str(Val,15,2))
   Case Meta="��������"
        Val:=CalckPay(Month(new_date),Main->Lic_Schet,.F.,1)
        ReturnValue=Alltrim(Str(Val,15,2))
   Case Meta="������"
        Val:=GetSaldo(Main->Lic_Schet,Month(new_date))
        ReturnValue=IF(Val<0,"��","��")+" "+Alltrim(Str(IF(Val<0,-1*Val,Val),15,2))
   Case Meta="���������"
        Val:=GetRashod(Main->Lic_Schet,Month(new_date))
        ReturnValue=Alltrim(Str(Val,15,0))
EndCase
//        Al_Box({Meta+" = "+Str(ReturnValue)})
Return ReturnValue