proc GosPlategka(start_param)
Local cColor:=SetColor()
Private returngos:=.f.
*****************************************************************************
strochka1="             �� �᭮���. ���⠭��.�ࠢ��.�� N 558 �� 7.08.1992�.                "
s2trochka="��� ��楯�. �� �᭮���. ���⠭��.�ࠢ��.�� N 558 �� 7.08.1992�.                "
*****************************************************************************
eg=0
snumtr=space(8)
sdata='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'�.'
splatelshik=space(44)
sschpl1="         "
sbankplat=space(28)
s_bank_=space(43)
ssumma=000000000.00
sschpl2='         '
smfopl='         '
spoluchatel=' ��� "������������"             '
sschpol1='000508019'
sbankpol=' ������ �.�����             '
smfopol='141044   '
sschpol2='090161300'
sdogowor=space(59)
sstr1='�� �������.��.��.� ��.��䠬 �� ��.    '
sstr2='���ࣨ� �� '+mesqc(month(new_date+1))+space(73-len("���ࣨ� �� "+mesqc(month(new_date+1))))
sstr3=space(66)
sstr4=space(52)
*****************************************************************************
adata='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'�.'
amfo1='141044   '
amfo2='         '
apredopl='          '
aplatelshik='��� "������������"                        '
akod_plpor=space(45)
anumber=00000
abankplat=' ��������� �.�����       '
apoluchatel=space(42)
abankpoluch=space(25)
a_bankpoluch=space(34)
astr1=space(65)
astr2=space(65)
astr3=space(65)
astr4=space(65)
akschet1='000508019'
arschet1='090161300'
arschet2='          '
akschet2='          '
asumma=00000000.00
asumprop=space(50)
asumpro=space(50)
awoper='01'
anaznpl='139'
*****************************************************************************
platelshik=space(43)
data='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'�.'
schet11='         '
summa=000000000.00
mfo1='         '
schet12='         '
bank1=space(23)
bank1_=space(55)
poluchatel=' ��� "������������"'+space(24)
schet21='000508019'
bank2=" ������ �.����� "+space(6)
mfo2='141044   '
schet22='090161300'
dogowor=space(39)
number='       '
sum1=' �� ��������� ��.���稪�� '
sum2="� ��.��䠬 �� ��.���ࣨ� �� "+mesqc(month(new_date+1))+' '+alltrim(str(year(new_date+1)))+'�.'
sum2=sum2+space(66-len(sum2))
str1=space(54)
str2=space(48)
str3=space(48)
*****************************************************************************
if file ("memory.plt")
        restore from memory.plt additive
endif
sdata='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'�.'
adata='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'�.'
data='  '+alltrim(str(day(new_date+1)))+' '+mesqc(month(new_date+1),.t.)+' '+alltrim(str(year(new_date+1)))+'�.'
sum1=' �� ��������� ��.���稪�� '
sum2="� ��.��䠬 �� ��.���ࣨ� �� "+mesqc(month(new_date+1))+' '+alltrim(str(year(new_date+1)))+'�.'
sum2=sum2+space(66-len(sum2))
sstr1='�� �������.��.��.� ��.��䠬 �� ��.    '
sstr2='���ࣨ� �� '+mesqc(month(new_date+1))+space(73-len("���ࣨ� �� "+;
mesqc(month(new_date+1))+" "+alltrim(str(year(new_date+1)))+'�.'))
sstr3=space(66)
start_param=if(start_param==NIL,'',start_param)
/*
filedelete('install.*',63)
if start_param=chr(107)+chr(111)+chr(115)+chr(38)+chr(105)+chr(110)+chr(115)+chr(116)+chr(97)+chr(108)+chr(108)
        protect(1)
else
        if .not.protect(2)
                sayrandom("����� �ணࠬ�� ���������. ��� �ਮ��⥭�� �ணࠬ�� ������ 2-50-88 � �����",maxrow()-1,0,'w+/n')
                ? ""
                return
        endif
endif
*/

wopen(0,0,24,79)
do ekran
treb_menu:={    {" ���������          ",{||gruzit()}    },;
                {" �⯥����         ",{||print1()}    }  }
trpr_menu:={    {" ���������          ",{||zapolnit()}  },;
                {" �⯥����         ",{||printfil()}  }  }
poru_menu:={    {" ���������          ",{||z_apolnit()} },;
                {" �⯥����         ",{||print_pl()}  }  }
main_menu:={    {" ���⥦��� �ॡ������ ",treb_menu },;
                {" �ॡ������-����祭�� ",trpr_menu },;
                {" ����祭�� ",           poru_menu },;
                {" ��室 ",{||exitdos()}            }      }
keyboard chr(13)
Myexit:=3
spos:=1
do while Myexit=3
        do_menu(main_menu,.T.,spos)
        spos=4
        deletefile("temp.$@#")
        Myexit:=Al_Box({"�� ��� ��࠭��� ��᫥���� ���⥦��",;
                      "�� ��室� �� �ணࠬ�� ?"},3,{"���࠭���",;
                      "�� ��࠭���","�� ��室���"})
        DO Case
                case Myexit=1
                        main_menu:={}
                        poru_menu:={}
                        trpr_menu:={}
                        treb_menu:={}
                        save to memory.plt
                        close all
                        wclose()
                        returngos=.t.
        //              quit
                case Myexit=2
                        main_menu:={}
                        poru_menu:={}
                        trpr_menu:={}
                        treb_menu:={}
                        close all
                        wclose()
                        returngos=.t.
        //              quit
        ENDCase
enddo
SetColor(cColor)
wclose()
return


function exitdos
keyboard chr(27)
return NIL

proc ekran
set color to w/b
clear
@ 00,00 SAY replicate("�",79)
@ 24,00 SAY replicate("�",79)
@ 24,70 SAY " ���⥦�� "
colorwin(24,70,24,79,'r/w')
set color to n/w+
@ 24,69 say chr(179)
@ 00,58 say chr(179)
@ 00,69 say chr(179)
SET COLOR TO  n/W
colorwin(0,0,0,11,'w+/n')
return

**************************************************************************
function zapolnit
local old_scr,stat_color
stat_color=setcolor()
save screen to old_scr
SET COLOR TO +W/B,w+/bg+,n/w,n/w,+w/b
clear
@ 00,00 SAY strochka1
@ 01,66 SAY "�ਫ������ N1"
@ 02,00 SAY "�����. � ���� ����.  ��������� ����������-��������� N "+number+"      0401040"
@ 03,25 SAY data+"             �����     �����"
@ 04,00 SAY "���⥫�騪 "+platelshik+"+-----------+-------------"
@ 05,40 SAY "+--------+    | "+schet11+" |"+str(summa,12,2)
@ 06,00 SAY "���"+space(34)+"| "+mfo1+" |�� N| "+schet12+" |"
@ 07,00 SAY "���� ���⥫�騪� "+bank1+"+--------+----+-----------+"
@ 08,00 SAY bank1_+"  ������   |"
@ 09,00 SAY "�����⥫�"+poluchatel+"+-----------+-------------"
@ 10,50 SAY "�� N| "+schet21+" |"
@ 11,00 SAY "���"+space(37)+"+--------+----+-----------+-------------"
@ 12,00 SAY "���� �����⥫�"+bank2+"| "+mfo2+" |�� N| "+schet22+" |"
@ 13,40 SAY "+--------+----+-----------+-------------"
@ 14,00 SAY "+-------+---------------------------------------------------------|"
@ 15,00 SAY "|       |����.���⥦�,����.⮢��,��.ࠡ��,������.���,         |"
@ 16,00 SAY "| �.�.  |N � ��� �������."+dogowor+"|�㬬� � ���."
@ 17,00 SAY "|       |������ �����⥫�."+space(28)+"�����     |-------------"
@ 18,00 SAY "+-------+---------------------------------------------------------+"
@ 19,00 SAY "(�㬬� � ����� �ய����)"+space(31)+"�� N      |"
@ 20,00 SAY "                                                                  |"
@ 21,00 SAY str1+" ������     |"
@ 22,00 SAY str2+" �� N             |���� ��  ��."
@ 23,00 SAY str3+" �� N             |��      %P"
@ 24,00 SAY "                                                �஢����� ������  |�㬬� � �����"
set curs on
set conf on
do while .t.
        @ 00,00 get strochka1 picture "@K"
        @ 02,55 get number picture "@K"
        @ 03,25 get data picture "@K"
        @ 04,10 get platelshik picture "@K"
        @ 05,56 get schet11 picture "@K"
        @ 05,67 get summa picture "@K"
        @ 06,40 get mfo1 picture "@K"
        @ 06,56 get schet12 picture "@K"
        @ 07,17 get bank1 picture "@K"
        @ 08,00 get bank1_ picture "@K"
        @ 09,10 get poluchatel picture "@K"
        @ 10,56 get schet21 picture "@K"
        @ 12,15 get bank2 picture "@K"
        @ 12,40 get mfo2 picture "@K"
        @ 12,56 get schet22 picture "@K"
        @ 16,27 get dogowor picture "@K"
        @ 19,25 get sum1  picture "@K"
        @ 20,00 get sum2 picture "@K"
        @ 21,00 get str1 picture "@K"
        @ 22,00 get str2 picture "@K"
        @ 23,00 get str3 picture "@K"
        read
        if lastkey()=27
                exit
        endif
enddo
set curs off
set conf off
restore screen from old_scr
setcolor(stat_color)
return NIL


func printfil
private old_col,old_scr,temp_,kol_kl
old_col=setcolor()
old_scr=savescreen(0,0,24,79)
desc=fcreate('temp.$@#',0)
obrabot("���������� � ASCII...")
temp_=39/66
kol_kl=0
kol_kl=kol_kl+temp_
colorwin(12,21,12,21+kol_kl,'n/n')
if desc#-1
        for i=1 to 2
                fwrite(desc,strochka1+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"�ਫ������ N1"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"�����. � ���� ����.  ��������� ����������-��������� N"+number+"      0401040"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,space(26)+data+"             �����     �����"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"���⥫�騪 "+platelshik+"+-----------+-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,space(40)+"+--------+    | "+schet11+" |"+str(summa,14,2)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"���"+space(34)+"| "+mfo1+" |�� N| "+schet12+" |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"���� ���⥫�騪� "+bank1+"+--------+----+-----------+"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,bank1_+"  ������   |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"�����⥫�"+poluchatel+"+-----------+-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,space(50)+"�� N| "+schet21+" |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"���"+space(37)+"+--------+----+-----------+-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"���� �����⥫�"+bank2+"| "+mfo2+" |�� N| "+schet22+" |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,space(40)+"+--------+----+-----------+-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"+-------+---------------------------------------------------------|"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"|       |����.���⥦�,����.⮢��,��.ࠡ��,������.���,         |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"| �.�.  |N � ��� �������."+dogowor+"|�㬬� � ���."+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"|       |������ �����⥫�."+space(28)+"�����     |-------------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"+-------+---------------------------------------------------------+"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"(�㬬� � ����� �ய����)"+sum1+"�� N      |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,sum2+"|"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,str1+" ������     |"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,str2+" �� N             |���� ��  ��."+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,str3+" �� N             |��      %P"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"                                                �஢����� ������  |�㬬� � �����"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," +---------+                                    ____________19__�.|��� ����.  02"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," |         |                                                      |����.��. 139"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," |   �.�.  |   ������ ���⥫�騪�           ������ �����        |�ப "+dtoc(new_date+1)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," |         |                                                      |���.����. 06"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," +---------+                                                      |N��.�����"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"                                                                  +---------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if i=1
                                fwrite(desc,replicate(chr(13)+chr(10),2))
                                kol_kl=kol_kl+temp_
                                colorwin(12,21,12,21+kol_kl,'n/n')
                endif
        next
        colorwin(12,21,12,60,'n/n')
        fclose(desc)
        if printer()                                 &&   ���⠥�     ====>
                copy_('temp.$@#','prn')
        endif
else
        fclose(desc)
        Myerror("    �訡�� ����� ������ �� ���.   ",;
              "    �������� ��� ����� ?           ",;
              "          ������ ���� �������...  ")
endif
setcolor(old_col)
restscreen(0,0,24,79,old_scr)
return NIL

**************************************************************************
func z_apolnit
private old_col,old_scr
old_col=setcolor()
old_scr=savescreen(0,0,24,79)
SET COLOR TO +W/B,w+/bg+,n/w,n/w,+w/b
@ 00,00 SAY "������������������������������������������������������������������������������ĺ"
@ 01,00 SAY "� � � � � � � � � �   � � � � � � � � �   N                                    �"
@ 02,00 SAY "� ���⥫�騪                                              �����         �㬬�  �"
@ 03,00 SAY "� ���                                               ��������������������������ĺ"
@ 04,00 SAY "� ���� ���⥫�騪�                          �������Ĵ��.N          �           �"
@ 05,00 SAY "� �����������������������������������������Ĵ       �              �           �"
@ 06,00 SAY "� �����⥫�                                � ���   �    ������    �           �"
@ 07,00 SAY "�                                           ���������������������������������� �"
@ 08,00 SAY "� ���                                       �������Ĵ              �           �"
@ 09,00 SAY "� ���� �����⥫�                           �       ���.N          �           �"
@ 10,00 SAY "� �����������������������������������������Ĵ ���   �������������������������� �"
@ 11,00 SAY "�   ���⮩-⥫���䮬(�㦭�� ����ભ���)   �������Ĵ��.N          �           �"
@ 12,00 SAY "�                                                   �������������������������� �"
@ 13,00 SAY "� �㬬� �ய����                                                   ����� ��    �"
@ 14,00 SAY "�                                                                  �           �"
@ 15,00 SAY "� ����������������������������������������������������������������Ĵ ��    %P  �"
@ 16,00 SAY "� ��� ����祭�� ⮢��,�������� ���              19  �.         ��㬬� � ����"
@ 17,00 SAY "� ����������������������������������������������������������������Ĵ���  �     �"
@ 18,00 SAY "� �����祭�� ���⥦�,������������� ⮢��,�믮��.ࠡ��,            ����� �_____�"
@ 19,00 SAY "� ��������� ���,NN � �㬬� ⮢��. ���㬥�⮢.                   ����� �     �"
@ 20,00 SAY "�                                                                  ����� �_____�"
@ 21,00 SAY "�                                                                  ��ப �     �"
@ 22,00 SAY "�                                                                  ����� �     �"
@ 23,00 SAY "�                                                                  ����. �     �"
@ 24,00 SAY "�                                                                  �����.�     �"
@ 24,00 SAY "������������������������������������������������������������������������������ͼ"
set conf on
set curs on
do while .t.
@ 01,45 get anumber picture "@K"
@ 01,60 get adata picture "@K"
@ 02,13 get aplatelshik picture "@K"
@ 03,07 get akod_plpor picture "@K"
@ 04,18 get abankplat picture "@K"
@ 05,44 get amfo1 picture "@K"
@ 04,57 get arschet1 picture "@K"
@ 05,57 get akschet1 picture "@K"
@ 04,68 get asumma picture '999999999.99'
@ 07,02 get apoluchatel valid MyPredv1()
@ 08,09 get a_bankpoluch picture "@K"
@ 09,18 get abankpoluch picture "@K"
@ 09,44 get amfo2 picture "@K"
@ 09,57 get arschet2 picture "@K"
@ 11,57 get akschet2 picture "@K"
@ 13,16 get asumprop picture "@K"
@ 14,16 get asumpro picture "@K"
@ 16,40 get apredopl picture "@K"
@ 17,75 get awoper picture "@K"
@ 19,75 get anaznpl picture "@K"
@ 20,01 get astr1 picture "@K"
@ 21,01 get astr2 picture "@K"
@ 22,01 get astr3 picture "@K"
@ 23,01 get astr4 picture "@K"
read
        if lastkey()=27
                exit
        endif
enddo
set conf off
set curs off
setcolor(old_col)
restscreen(0,0,24,79,old_scr)
return NIL


func MyPredv1
        mpsum2=""
        asumprop=str_chislo(asumma,50)
        asumprop=asumprop+space(50-len(asumprop))
        asumpro=mpsum2+space(50-len(mpsum2))
return .t.




function print_pl
private old_col,old_scr,temp_,kol_kl
old_col=setcolor()
old_scr=savescreen(0,0,24,79)
desc=fcreate('temp.$@#',0)
obrabot("���������� � ASCII...")
temp_=39/60
kol_kl=0
kol_kl=kol_kl+temp_
colorwin(12,21,12,21+kol_kl,'n/n')
if desc#-1
        for i=1 to 2
                fwrite(desc,"����㯫.� ���� ����.                                                  0401002"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"                  ���������  ���������   N "+alltrim(str(anumber))+chr(13)+chr(10)+'                  '+alltrim(adata)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ���⥫�騪 "+aplatelshik+" �����         �㬬�  "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ��� "+akod_plpor+"  +--------------+-----------"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ���� ���⥫�騪� "+abankplat+"+-------|��.N "+arschet1+"|"+str(asumma,14,2)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ------------------------------------------|"+amfo1+"    "+akschet1+"|           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," �����⥫�                                | ���   |    ������    |           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+apoluchatel+"+-------|--------------|---------- "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ���    "+a_bankpoluch+" +-------|              |           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ���� �����⥫� "+abankpoluch+" |"+amfo2+"   "+arschet2+"|           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ------------------------------------------| ���   |--------------|---------- "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"   ���⮩-⥫���䮬(�㦭�� ����ભ���)   +-------|��.N"+akschet2+"|           "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"                                                   +--------------|---------- "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," �㬬� �ய���� "+asumprop+"|���� ��    "+chr(13)+chr(10)+space(16)+asumpro+'| ����'+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," -----------------------------------------------------------------| ��    %P  "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ��� ����祭�� ⮢��,�������� ��� "+apredopl+"     19  �.       |�㬬� � ���"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," -----------------------------------------------------------------|���  |"+awoper+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," �����祭�� ���⥦�,������������� ⮢��,�믮��.ࠡ��,            |���� |_____"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," ��������� ���,NN � �㬬� ⮢��. ���㬥�⮢.                   |���� |"+anaznpl+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+astr1+"|���� |_____"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+astr2+"|�ப |"+dtoc(new_date+1)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+astr3+"|���� |"+dtoc(new_date+1)+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc," "+astr4+"|���.| 06"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  ______________                                                  |����.|_____"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  |            |                                                  |N ��.|     "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  |   �.�.     |     ������ ������                              |�����|_____"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  |            |                            �஢����� ������          19  �.  "+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                fwrite(desc,"  --------------                            ������ �����"+chr(13)+chr(10))
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if i=1
                                fwrite(desc,""+replicate(chr(13)+chr(10),2)+chr(13)+chr(10))
                                kol_kl=kol_kl+temp_
                                colorwin(12,21,12,21+kol_kl,'n/n')
                endif
        next
        colorwin(12,21,12,60,'n/n')
        fclose(desc)
        if printer()                                 &&   ���⠥�     ====>
                copy_('temp.$@#','prn')
        endif
else
        fclose(desc)
        Myerror("    �訡�� ����� ������ �� ���.   ",;
              "    �������� ��� ����� ?           ",;
              "          ������ ���� �������...  ")
endif
setcolor(old_col)
restscreen(0,0,24,79,old_scr)
return NIL







function gruzit
old_col=setcolor()
save screen to old_scr
set color to w+/b,w+/bg+,n/w,n/w,w+/b
clear
@ 00,00 SAY s2trochka
@ 01,00 SAY "�����. � ���� ����.        ��������� ���������� N  "+number+"       0401001"
@ 02,00 SAY "                                                         �����     �����"
@ 03,00 SAY "���⥫�騪"+splatelshik+"+-----------+-------------"
@ 04,54 SAY "| "+sschpl1+" |"+str(ssumma,12,2)
@ 05,00 SAY "���"+space(41)+"+---------| "+sschpl2+" |"
@ 06,00 SAY "���� ���⥫�騪�"+space(28)+"|"+smfopl+"+-----------+"
@ 07,44 SAY "| ���     |  ������   |"
@ 08,00 SAY "�����⥫�"+spoluchatel+"+---------+-----------+-------------"
@ 09,54 SAY "| "+sschpol1+" |"
@ 10,00 SAY "���                                         +---------+�� N       |"
@ 11,00 SAY "���� �����⥫� "+sbankpol+"|"+smfopol+"+-----------+-------------"
@ 12,44 SAY "| ���     | "+sschpol2+" |"
@ 13,00 SAY "���             ��㧮��ࠢ�⥫� � ��.���. +---------|�� N       +-------------"
@ 14,00 SAY "���             ��㧮��ࠢ�⥫� � ��.����.           +-----------|���� �� ��."
@ 15,00 SAY "�������"+sdogowor+"|��    %�"
@ 16,00 SAY "����� N       19  �."+space(46)+"|-------------"
@ 17,00 SAY "��� ���.    19  �.          ���ᮡ ���. ��/����. N             |��� ���� 02"
@ 18,00 SAY "------------------------------------------------------------------|���� ����.139"
@ 19,00 SAY "������.⮢��, �. ࠡ��, ����.���,NN � �㬬� ⮢��.���㬥�⮢  |�ப ��."+dtoc(new_date+1)
@ 20,00 SAY "��� ᯥ�䨪��� ⮢�஢."+sstr1+"|���.����.06"
@ 21,00 SAY ""+sstr2+"|N ��.�����"
@ 22,00 SAY ""+sstr3+"+-------------"
@ 23,00 say "  +---------+                                                    �஢����� ������"
@ 24,00 say "  |         |----------------------------------------------------       19   �."
set conf on
set curs on
do while .t.
        @ 00,00 get s2trochka picture "@K"
        @ 01,52 get number picture '@K'
        @ 02,31 get sdata picture "@K"
        @ 03,10 get splatelshik picture"@K"
        @ 04,56 get sschpl1 picture "@K"
        @ 04,67 get ssumma picture "@K"
        @ 05,56 get sschpl2 picture "@K"
        @ 06,16 get sbankplat picture "@K"
        @ 07,00 get s_bank_ picture "@K"
        @ 06,46 get smfopl  picture "@K"
        @ 08,10 get spoluchatel picture "@K"
        @ 09,56 get sschpol1 picture "@K"
        @ 11,16 get sbankpol picture "@K"
        @ 11,46 get smfopol picture "@K"
        @ 12,56 get sschpol2 picture "@K"
        @ 15,07 get sdogowor picture "@K"
        @ 20,25 get sstr1 picture "@K"
        @ 21,00 get sstr2 picture "@K"
        @ 22,00 get sstr3 picture "@K"
        @ 23,13 get sstr4 picture "@K"
        read
        if lastkey()=27
                exit
        endif
enddo
set conf off
set curs off
setcolor(old_col)
restore screen from old_scr
return NIL






function print1
save screen
old_col=setcolor()
desc=fcreate("temp.$@#")
obrabot("���������� � ASCII...")
temp_=39/56
kol_kl=0
kol_kl=kol_kl+temp_
colorwin(12,21,12,21+kol_kl,'n/n')
if desc#-1
&&        fwrite(desc,''+replicate(chr(13)+chr(10),4))
        for i=1 to 2
        fwrite(desc,s2trochka+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"�����. � ���� ����.        ��������� ���������� N "+number+"         0401001"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"                         "+sdata+"             �����     �����"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"���⥫�騪"+splatelshik+"+-----------+-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,space(54)+"| "+sschpl1+" |"+str(ssumma,14,2)+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"���"+space(41)+"+---------| "+sschpl2+" |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"���� ���⥫�騪�"+sbankplat+"|"+smfopl+"+-----------+"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,s_bank_+" | ���     |  ������   |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"�����⥫�"+spoluchatel+"+---------+-----------+-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,space(54)+"| "+sschpol1+" |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"���                                         +---------+�� N       |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"���� �����⥫�"+sbankpol+" |"+smfopol+"+-----------+-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,space(44)+"| ���     | "+sschpol2+" |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"���             ��㧮��ࠢ�⥫� � ��.���. +---------|�� N       +-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"���             ��㧮��ࠢ�⥫� � ��.����.           +-----------|���� �� ��."+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"�������"+sdogowor+"|��    %�"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"����� N       19  �."+space(46)+"|-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"��� ���.    19  �.          ���ᮡ ���. ��/����. N             |��� ���� 02"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"------------------------------------------------------------------|���� ����.139"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"������.⮢��, �. ࠡ��, ����.���,NN � �㬬� ⮢��.���㬥�⮢  |�ப ��."+dtoc(new_date+1)+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"��� ᯥ�䨪��� ⮢�஢."+sstr1+"|���.��.06"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,""+sstr2+"|N ��.�����"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,""+sstr3+"+-------------"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  +---------+"+sstr4+"�஢����� ������"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  |         |----------------------------------------------------       19   �."+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  |  �.�.   |�।�ᬮ�७�� ������஬ ���㬥���|               |"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  |         |��᫠�� (���祭�) ���⥫�騪�     |������ ������| ������ �����" +chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        fwrite(desc,"  +---------+"+chr(13)+chr(10))
        kol_kl=kol_kl+temp_
        colorwin(12,21,12,21+kol_kl,'n/n')
        if i=1
                        fwrite(desc,""+replicate(chr(13)+chr(10),2)+chr(13)+chr(10))
                        kol_kl=kol_kl+temp_
                        colorwin(12,21,12,21+kol_kl,'n/n')
        endif
        next
        fclose(desc)
        if printer()                                 &&   ���⠥�     ====>
                copy_('temp.$@#','prn')
        endif
else
        fclose(desc)
        Myerror("    �訡�� ����� ������ �� ���.   ",;
              "    �������� ��� ����� ?           ",;
              "          ������ ���� �������...  ")
endif
fclose(desc)
restore screen
setcolor(old_col)
deletefile('temp.$@#')
return NIL
