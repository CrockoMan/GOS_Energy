param prot
***************************************** <=
set date german
setcursor(2,7,.t.)
set scoreboard off
set deleted on
set confirm on
set cursor off
set century off
setcancel(.f.)
set decimals to 2
schet_grugu=0
loaddir=substr(exename(),1,len(exename())-1-len('arm.exe'))
quitdir=diskname()+':'+dirname()
if len(quitdir)=2
        quitdir=quitdir+'\'
endif
dirchange(substr(loaddir,1,3))
dirchange(loaddir)
*       ? loaddir+chr(13)+chr(10)
*       inkey(0)
dir=diskname()+':'+dirname(diskname())+'\DATABASE\'
is_arhiv=.f.
***************************************** <=
? chr(40)+chr(99)+chr(41)+chr(32)+chr(70)+chr(108)+chr(97)+chr(110)+chr(32)+;
chr(76)+chr(116)+chr(100)+chr(46)+chr(32)+chr(67)+chr(111)+chr(114)+chr(112)+;
chr(111)+chr(114)+chr(97)+chr(116)+chr(105)+chr(111)+chr(110)+chr(13)+chr(10)
if .not.isat()
        set color to bg+/r+
        ? "������ �⠭�� �� ���� IBM AT, �த������� ࠡ��� ���������� !"
        set color to
        deletefile('kos&kos.dbf')
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        release all
        quit
endif
*endif
if pcount()=0
        i_i=protect(2)
else
        if prot=chr(107)+chr(111)+chr(115)+chr(38)+chr(105)+chr(110)+chr(115)+chr(116)+chr(97)+chr(108)+chr(108)
                i_i=protect(1)
        else
                i_i=protect(2)
        endif
endif
if i_i=.f.
dirchange(substr(quitdir,1,3))
dirchange(quitdir)
set color to g+/n
? " ����� �ணࠬ�� ���������!  ��業���� �� ��� �ணࠬ�� �������� ����᪮� ����"
? ''
        do wizitka
        set key 28 to
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        release all
        quit
endif
***
*** II : format file
*** Generated ������� 4, 1993
***
if diskfree(diskname())<1000000
        Myerror(" �������� ����࠭�⢮ ��᪠ "+diskname()+': �� '+alltrim(str(1000000-diskfree(diskname())))+' ����')
        close all
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        release all
        quit
endif
dir=diskname()+':'+dirname(diskname())+'\DATABASE\'
if dirchange(substr(dir,1,len(dir)-1))#0
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        quit
endif
dirchange(substr(dir,1,len(dir)-10))
if dirchange(substr(dir,1,len(dir)-9)+'TEXT`S')#0
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        quit
endif
dirchange(substr(dir,1,len(dir)-10))
set path to &dir
set default to &dir
screenfile(Ddir+'screen.gkv')
*dsetqfile(.t.)
set cursor off
*set color to                   ===========
*clear                          ===========
*set color to g+*/n
*@ 08,06 SAY "���  ����  ���        ������    ��      ��  ������������  ��������"
*@ 09,08 SAY "��  ��  ��        ��    ��    ��    ����       ��       ��"
*@ 10,09 SAY "�� �� ��       ��      ��    ��   �� ��       ��       ��"
*@ 11,10 SAY "������       ��       ��    ��  ��  ��       ��       �����"
*@ 12,09 SAY "�� �� ��      ��       ��    �� ��   ��       ��       ��"
*@ 13,08 SAY "��  ��  ��     ��       ��    ����    ��       ��       ��"
*@ 14,06 SAY "���  ����  ���   �����������    ��      ��       ��       ��������"
*@ 15,21 SAY "��           ��"
sound(25,5)
old_date=date()
new_date=date()
save screen
set color to w+/bg
wope(9,25,14,50,'g+/bg+','bg+/r+')
colorwin(10,26,15,51,'bg+/n')
@ 09,25 say "����������������������Ŀ"
@ 10,25 say "�                      �"
@ 11,25 say "�                      �"
@ 12,25 say "�                      �"
@ 13,25 say "�                      �"
@ 14,25 say "������������������������"
set color to  /bg
@ 10,26 say "                      "
@ 11,26 say "    ������  ���     "
@ 12,26 say "      11.11.11        "
@ 13,26 say "                      "
set conf on
set curs on
@ 12,32 get new_date picture "@K D"
read
set conf off
set curs off
if .not.setdate(new_date,.t.)
*       Myerror(" ����� ���� ����� ��।����� ��� ��⥬��� !!!")
endif
wclo(9,25,14,50)
restore screen
if lastkey()=27
        dirchange(substr(quitdir,1,3))
        dirchange(quitdir)
        commit
        close all
        set color to
        quit
endif
wope(0,0,24,79,'w/b','bg+/b')
SET COLOR TO W/B
clear
@ 00,01,24,78 BOX "�ķ���Գ "
@ 04,01 SAY "�            ��� ���쥩襩 ࠡ��� ��� ����室��� ����� �����."
SET COLOR TO +GR/B
@ 02,16 SAY "�� '��� ���������ࣨ� ���ᥪ��' ����㦥�!"
showtime(0,70,.f.,'w/n')
do kartinka
@ 9,33 say "�롮� �����"
@ 11,28 say "      ����� 1,2,3      "
@ 12,28 say "      ����� 4,5        "
@ 13,28 say "      ����� 6,7,8      "
@ 14,28 say "      ����� 9,10,11    "
@ 15,28 say "      ����� 12         "
@ 16,28 say "      ��室 � DOS      "
do wizitka
do while .t.
*clear
set color to n/w,n/g
clear typeahead
@ 9,33 say "�롮� �����"
@ 11,28 prompt "      ����� 1          "
@ 12,28 prompt "      ����� 2          "
@ 13,28 prompt "      ����� 3,4        "
@ 14,28 prompt "      ����� 5,6        "
@ 15,28 prompt "      ����� 7          "
@ 16,28 prompt "      ����� � ��娢�  "
@ 17,28 prompt "      ��室 � DOS      "
menu to kniga
if kniga>0.and.kniga<6
*       work(23,2)
        sound(1300,5)
        sound(2600,3)
        sound(3900,2)
        sound(5200,5)
endif
if file(Ddir+"otchet.gkv")
*       deletefile(Ddir+"otchet.gkv")
endif
do case
        case kniga=1
                if kkk(Ddir+'#1#2#3\',Ddir)
                        do servis2
                        set color to
                        clear
                        do first with '/13','����� 1'
                        commit
                        close all
*                       work(23,2)
                        kkk(dir,dir+'#1#2#3\')
                        filedelete(dir+'*.dbf')
                        filedelete(dir+'*.ntx')
                        do kartinka
                endif
        case kniga=2
                if kkk(dir+'#4#5\',dir)
                        do servis2
                        set color to
                        clear
                        do first with '/14','����� 2'
                        commit
                        close all
*                       work(23,2)
                        kkk(dir,dir+'#4#5\')
                        filedelete(dir+'*.dbf')
                        filedelete(dir+'*.ntx')
                        do kartinka
                endif
        case kniga=3
                if kkk(dir+'#6#7#8\',dir)
                        do servis2
                        set color to
                        clear
                        do first with '/15','����� 3,4'
                        commit
                        close all
*                       work(23,2)
                        kkk(dir,dir+'#6#7#8\')
                        filedelete(dir+'*.dbf')
                        filedelete(dir+'*.ntx')
                        do kartinka
                endif
        case kniga=4
                if kkk(dir+'#9#10#11\',dir)
                        do servis2
                        set color to
                        clear
                        do first with '/16','����� 5,6'
                        commit
                        close all
*                       work(23,2)
                        kkk(dir,dir+'#9#10#11\')
                        filedelete(dir+'*.dbf')
                        filedelete(dir+'*.ntx')
                        do kartinka
                endif
        case kniga=5
                if kkk(dir+'#12\',dir)
                        do servis2
                        set color to
                        clear
                        do first with '/17','����� 7'
                        commit
                        close all
*                       work(23,2)
                        kkk(dir,dir+'#12\')
                        filedelete(dir+'*.dbf')
                        filedelete(dir+'*.ntx')
                        do kartinka
                endif
        case kniga = 6
                do arhiv
*               do kartinka
        otherwise
                if yes_or_not("      �� ����⢨⥫쭮 ���      ",;
                              "      �������� ࠡ��� � ���?      ")
                        exit
                endif
endcase
setdate(old_date,.t.)
colorwin(24,0,24,0,'n/n')
colorwin(23,2,23,15,'b/b')
enddo
close all
showtime()
wope(0,0,24,79,'b+/b+','bg+/bg+')
*wope(0,0,24,79,'bg+/bg+','b+/b+')
*wclo(0,0,24,79,'b+/b+')
wclo(0,0,24,79,'w/n')
filescreen(dir+'screen.gkv')
deletefile(dir+'screen.gkv')
dirchange(substr(quitdir,1,3))
dirchange(quitdir)
release all
quit


proc kartinka
SET COLOR TO W/B
@ 00,01,24,78 BOX "�ķ���Գ "
@ 04,02 SAY "             ��� ���쭥�襩 ࠡ��� ��� ����室��� ����� �����."
SET COLOR TO +GR/B
@ 02,16 SAY "�� '��� ���������ࣨ� ���ᥪ��' ����㦥�!"
SET COLOR TO n/w+
colorwin(9,27,19,53,'n/n')
@ 08,27,18,51 BOX "�Ŀ����� "
@ 10,27 say "�"+replicate('�',23)+"�"
return



func kkk
private _ppp,volume
param otkuda,kuda
kolvo=adir(otkuda+'*.dbf')
volume=.t.
if kolvo#0
        decl _files[kolvo]
        adir (otkuda+'*.dbf',_files)
        for i=1 to kolvo
                if copy_(otkuda+_files[i],kuda+_files[i])=0
                        volume=.f.
                endif
        next
else
        Myerror(" ������ ����� �� ��᪥ �� �����㦥�� ! ")
        volume=.f.
*       zagr=.f.
endif
return volume



function work
param _x,_y
@ _x,_y say chr(16)+" ����� "+chr(17)
colorwin(_x,_y,_x,_y+9,'g*/r+')
return .t.
