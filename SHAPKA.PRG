proc nastrojka
private old_col
old_col=setcolor()
screen=win_save()
set color to +w/bg
@ 02,00,22,79 box "         "
@ 02,01 say "旼컴컴컴컴컴컴컴컴컴컴컴�"+space(27)+"컴컴컴컴컴컴컴컴컴컴컴컴캠"
@ 03,01 say "�                                                                            �"
@ 04,01 say "퀙꼹        :       %                  �.뜝ギ�        %                      �"
@ 05,01 say "퀛���       :       %                                                        �"
@ 06,01 say "퀎ⓤ� 誓㎘舒��� ぎ�Ŀ       (┘飡え�)     뤵筍                               �"
@ 07,01 say "퀎ⓤ� 誓㎘舒��� ぎ�Ŀ       (（―Ł)      Temp                               �"
@ 08,01 say "�                                                                            �"
//@ 08,01 say "쳐컴컴컴컴컴컴컴컴�"+space(39)+"컴컴컴컴컴컴컴컴컴캘"
@ 09,01 say "퀛�ャ�졻�レ :                                                                �"
@ 10,01 say "퀋젺�       :                                                                �"
@ 11,01 say "퀚說�쥯���  :                                                                �"
@ 12,01 say "�                                                                            �"
@ 12,02 say if(schet_vplan=.t.,chr(16)+' � �쳽收┴� �ぎ��졻�レ��． �쳽收쬊 ▲ㄵ� ˚ヮ曄췅 率К� �쳽��¡． �쳽收쬊 '+chr(17),'')
colorwin(12,2,12,77,'n/bg')
colorwin(12,2,12,2,'n*/bg')
colorwin(12,77,12,77,'n*/bg')
@ 13,01 say "�                                                                            �"
@ 14,01 say "� 꽙誓も��   :                          곥鶯젷收�:                           �"
@ 15,01 say "� 뜝㎖젺�� 1 :                                 "+space(30)+"�"
@ 16,01 say "� 뜝㎖젺�� 2 :                                 "+space(30)+"�"
@ 17,01 say "� 뜝㎖젺�� 3 :                                 "+space(30)+"�"
@ 18,01 say "� 걽��       :                                 "+space(30)+"�"
@ 19,01 say "� 맆淞.淞β  :                                 "+space(30)+"�"
@ 20,01 say "� 뒶薛.淞β  :                                                               �"
@ 21,01 say "� 꺇昔�      :                                                               �"
@ 22,01 say "突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠"
set color to r+*/bg
@ 22,03 say chr(16)+' Esc - 귣若� '+chr(17)
set color to +gr/bg
@ 02,27 say "뜝飡昔ø� 췅 ��レ㎜쥯收ワ"
set color to +bg/bg
@ 03,25 say "뇿��キ���� ˇº젰щ� 췅ギ．�"
//@ 08,21 say "뇿��キ���� �젽え ㄻ� �쳽�. 循ⅰ�쥯�⑨"
@ 13,25 say "뇿��キ���� �젽え ㄻ� 淞β�"
NameBoss:=NameBoss+Space(25-Len(NameBoss))
NameBuh:=NameBuh  +Space(25-Len(NameBuh))
schet_osnov:=schet_osnov+Space(60-Len(schet_osnov))	
SchetNameOrg:=SchetNameOrg+Space(35-Len(SchetNameOrg))
SCHETINN=SchetInn+Space(10-Len(SchetInn))
SCHETKPP=SchetKpp+Space(10-Len(SchetKpp))
SCHETADR:=SchetAdr+Space(60-Len(SchetAdr))
	
set conf on
set curs on
set color to +w/bg,gr+/b,,,+w/bg
schet_sdisk=schet_sdisk+space(29-len(schet_sdisk))
schet_tdisk=schet_tdisk+space(29-len(schet_tdisk))
cNameBoss=Substr(cNameBoss+Space(17),1,17)
cNameBuh=Substr(cNameBuh+Space(17),1,17)
do while .t.
        @ 04,02 say "뛾�                 :" get schet_nds picture '99.99'
        @ 04,49 get schet_dnal picture '99.99'
        @ 05,02 say "룯��                :" get schet_penq picture '99.999'
        @ 06,02 say "꽙稅 誓㎘舒��� ぎ�Ŀ " get schet_disk picture 'A:' valid predv1()
        @ 06,48 get schet_sdisk picture "@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        @ 07,02 say "꽙稅 誓㎘舒��� ぎ�Ŀ " get schet_Adisk picture 'A:' valid predv2()
        @ 07,48 get schet_tdisk picture "@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
				@ 08,02 Say "롞짛��쭬與� :" get SchetNameOrg Picture"@KS57"
        @ 09,02 say "룼ャ�졻�レ  :" get schet_poluch picture '@k XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 10,02 say "걽��        :" get schet_bank1 picture '@k XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 11,02 say "롟��쥯���   :" get schet_osnov picture '@kS60'
				@ 13,02 Say "�ㅰα :" get SchetAdr Picture "@KS65"
        @ 14,16 Get NameBoss
        @ 14,52 Get NameBuh
        @ 15,03 say "뜝㎖젺�� 1 :" get schet_naz1 picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 16,03 say "뜝㎖젺�� 2 :" get schet_naz2 picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 17,03 say "뜝㎖젺�� 3 :" get schet_naz3 picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 18,03 say "걽��       :" get schet_ban2 picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 19,03 say "맆淞.淞β  :" get schet_rsch picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 20,03 say "뒶薛.淞β  :" get schet_ksch picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 21,03 say "꺇昔�      :" get schet_town picture '@K XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        @ 15,52 Say "닄�: " Get SchetInn
        @ 16,52 Say "뒒�: " Get SchetKpp
        @ 17,52 Say "�/c: " Get SchetRS
        @ 18,52 Say "K/c: " Get SchetKS
        @ 19,52 Say "걟�: " Get SchetBIK
        @ 20,52 Say "룼ㄿⓤ�1" Get cNameBoss  Picture "@KS15"
        @ 21,52 Say "룼ㄿⓤ�2" Get cNameBuh   Picture "@KS15"
        read
        if lastkey()=27
           Clear Typeahead
/*              if yes_or_not("      궕ヮ�졻� � �ぎ��졻�レ�硫 �쳽收�     ",;
                              "      率К� �쳽��¡． �쳽收쬊 ?           ")
                        schet_vplan=.t.
                else
                        schet_vplan=.f.
                endif */
                if al_box({"      궕ヮ�졻� � �ぎ��졻�レ�硫 �쳽收�     ",;
                           "      率К� �쳽��¡． �쳽收쬊 ?           "},;
                              2,,if(schet_vplan,1,2))=1
                        schet_vplan=.t.
                else
                        schet_vplan=.f.
                endif
                exit
        endif
enddo
NameBoss:=AllTrim(NameBoss)
NameBuh:=AllTrim(NameBuh)
schet_poluch=schet_poluch+space(50-len(schet_poluch))
schet_bank1=schet_bank1+space(50-len(schet_bank1))
schet_osnov=schet_osnov+space(63-len(schet_osnov))
schet_naz1=schet_naz1+space(32-len(schet_naz1))
schet_naz2=schet_naz2+space(32-len(schet_naz2))
schet_naz3=schet_naz3+space(32-len(schet_naz3))
schet_ban2=schet_ban2+space(32-len(schet_ban2))
schet_rsch=schet_rsch+space(32-len(schet_rsch))
schet_ksch=schet_ksch+space(32-len(schet_ksch))
schet_town=schet_town+space(32-len(schet_town))
schet_disk=MYupper(schet_disk)
schet_Adisk=MYupper(schet_Adisk)
            schet_sdisk=schet_sdisk+space(29-len(schet_sdisk))
            schet_tdisk=schet_tdisk+space(29-len(schet_tdisk))
schet_sdisk=alltrim(MYupper(schet_sdisk))
schet_tdisk=alltrim(MYupper(schet_tdisk))
set conf off
set curs off
* set path to &schet_sdisk
* set default to &schet_sdisk
setcolor(old_col)
win_rest(screen)
return



func predv2
private ret_val,old_scr
ret_val=.t.
if updated()
        if disktype(MYupper(schet_Adisk))=0
                Myerror(" 귗�젪蚓� ㄸ稅 � ㄸ稅�¡� "+MYupper(schet_Adisk)+' !')
                ret_val=.f.
        else
                if disktype(MYupper(schet_Adisk))#240.and.disktype(MYupper(schet_Adisk))#249
                        Myerror(" 꽑���� 信循�⒰手� ㄻ� ぎ�Ł ⓤ��レ㎜쥯筍 ��レ㏆ !")
                        ret_val=.f.
                endif
        endif
endif
return ret_val



func predv1
private ret_val,old_scr
ret_val=.t.
if updated()
        save screen to old_scr
        message('   넠ⓥ�,  Ħβ  �昔´夕�  丞젳젺��．  췅ぎ�ⓥ�ワ   ')
        set cursor off
//        if disktype(upper(substr(schet_disk,1,1)))#248
//                error(' 맆㏅θ�� 獸レぎ ┘飡え� ㄸ稅 (˘�曄飡��) !!! ')
//                ret_val=.f.
//        else
                if diskfree(schet_disk)<2500000
                        al_box({'뀶ぎ飡� ㄸ稅� '+schet_disk+' М┘� 〓筍 �ⅳ�飡졻�嶺�'})
                endif
                if dirchange(schet_disk+'\REZERV.DBF')#0
                        if dirmake(schet_disk+'\rezerv.dbf')=0
                                al_box({'롨Æ첓 뫌ℓ젺⑨ ㄸ誓も�黍� ㄻ� 誓㎘舒��� ぎ�Ŀ 줎� 쩆��音'})
                        else
                                al_box({'뫌ℓ젺� ㄸ誓も�黍� ㄻ� 誓㎘舒��� ぎ�Ŀ 줎� 쩆��音'})
                        endif
                endif
                dirchange(substr(Ddir,1,len(Ddir)-10))
//        endif
        set cursor on
        restore screen from old_scr
endif
return ret_val



Function MakeVal()
LOCAL Scr:=Win_Save(),Clr:=SetColor()
Set Color To &GetColor()
ColorWin(5,9,20,74,"n+/n")
@ 04,08 SAY "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캠"
@ 05,08 SAY "��‘�ⓣ�쥯�췅� М邀�飡�:           뒶庄�. ㄻ� ���泣�����         �"
@ 06,08 SAY "퀗젶歲쵟レ�硫 �졹若�               뒶庄�.�쳽�.� �ぎ��졻.         �"
@ 07,08 SAY "퀞졷ⓧ 쭬 �誓�泣����               뒶庄.�쳽��¡． �쳽收쬊        �"
@ 08,08 SAY "냐컴컴컴컴컴<닱Д����� 쩆��音 ˙⑨β 췅 Д獸ㄸゃ �졹曄獸�>컴컴컴캤"
@ 09,08 SAY "퀕�エ曄飡¡ ㄵ碎殊嶺音 ㎛젶��  "+space(34)+"�"
@ 10,08 SAY "냐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캤"
@ 11,08 SAY "퀓э 飡젺與�                     "+space(32)+"�"
@ 12,08 SAY "�"+space(64)+"�"
@ 13,08 SAY "퀓э �젵쳽 �洵β�           "+space(37)+"�"
@ 14,08 SAY "�"+space(64)+"�"
@ 15,08 SAY "퀌吟��� 飡昔え                                                   �"
@ 16,08 SAY "퀌吟��� 歲Б�쳽                                                  �"
@ 17,08 SAY "퀤ⓣÞ� 歲Б�쳽                                                  �"
@ 18,08 SAY "퀓э 歪ⓧ�� �黍�收��                                             �"
@ 19,08 SAY "突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠"
MaxRashSum:=Round(MaxRashSum,Decimal)
Station:=Station+Space(20-Len(Station))
NetPrint:=NetPrint+Space(10-Len(NetPrint))
ReportFile:=ReportFile+Space(12-Len(ReportFile))
PrFontName:=PrFontName+Space(30-Len(PrFontName))
Set Cursor On
Set Confirm On
@ 06,29 Get MaxRashod Picture "@K"
@ 07,29 Get MaxRashSum Picture "@K9999999.99"
@ 05,66 Get HighKoeff Picture "99.9"
@ 06,66 Get MyPlanKoeff Picture "99.9"
@ 07,66 Get FiftyDays  Picture "99.99"
@ 09,38 Get Decimal Picture "@K"
@ 11,21 Get Station Picture "@K"
@ 13,26 Get ReportFile Picture "@K"
@ 15,30 Get PrStrHigh  Picture "99"
@ 16,30 Get PrCharHigh    Picture "99"
@ 17,30 Get PrCharWidth   Picture "99"
@ 18,30 Get PrFontName   Picture "@K"
Read
Set Confirm Off
Set Cursor Off
Clear Typeahead
PrFontName:=AllTrim(PrFontName)
Station:=Alltrim(Station)
NetPrint:=Alltrim(NetPrint)
ReportFile:=Alltrim(ReportFile)
WriteCfg(DDir+"Config.arm")
SetColor(Clr); Win_Rest(Scr)
Return NIL
