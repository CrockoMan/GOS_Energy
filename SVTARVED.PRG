FUNCTION CtvZpe(nType)
LOCAL OldSel,lic,tmp_sum:=0,summ:=0,CrLf:=chr(13)+chr(10),KolKl:=0,Kod
Local lCalck:=.F.,cObrabot:="",MainCount:=0
Local oDlg,aSizeDeskTop,aPos,oProgress,nSumTar:=0
PRIVATE month_,perem,desc,base,count,cou,tarif,TmpRash,sele,ind,rec,sel,scr
PRIVATE rmonth,balabala,mesqc,Mass:={},SumTar:={0,0},Tarifs:={}
RunSaver:=.F.
rec=recno()
balabala=0
sele=select()
ind=indexord()
save screen to scr
month_=month_menu()
mesq='o'+alltrim(str(month_))+'.dbf'
DO CASE
   CASE nType==1
        cObrabot:="®«­ ï â à¨ä­ ï ¢¥¤®¬®áâì"
   CASE nType==2
        cObrabot:="’ à¨ä­ ï ¢¥¤®¬®áâì £®áá¥ªâ®à "
   CASE nType==3
        cObrabot:="’ à¨ä­ ï ¢¥¤®¬®áâì ç áâ­®£® á¥ªâ®à "
ENDCASE
if month_>0
		  oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
			aSizeDesktop  := oMainWindow:currentSize()
			oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
			oDlg:title    := cObrabot 
			oDlg:SysMenu	:= .F.
			oDlg:Configure()
			oDlg:Show()
			aSizeDesktop  := oDlg:currentSize()
			aPos					:= oDlg:CurrentPos()
			oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )

//   Obrabot("®¨áª â à¨ä®¢ ")
      rmonth=mesqc(month_)
      do case
              case month_=1
                      base='Jan'
              case month_=2
                      base="Feb"
              case month_=3
                      base='Mar'
              case month_=4
                      base='Apr'
              case month_=5
                      base="May"
              case month_=6
                      base='Jun'
              case month_=7
                      base='Jul'
              case month_=8
                      base='Aug'
              case month_=9
                      base='Sep'
              case month_=10
                      base='Oct'
              case month_=11
                      base='Nov'
              case month_=12
                      base='Dec'
      endcase
      index=Ddir+'temp.ntx'
      DeleteFile(Index)
      database=path_copy+base+'.dbf'
      select(month_)
      Go Top

  														
//      Obrabot("‘®àâ¨à®¢ª  â à¨ä®¢")

      cou=0
      count=0
      Do While !EOF()
         AppendTarif=.T.
         For i=1 To Len(Tarifs)
             IF Tarif==Tarifs[i]
                AppendTarif:=.F.
             ENDIF
         Next
         IF AppendTarif
            cou++
            Count++
            AADD(Tarifs,Tarif)
            aadd(mass,{tarif,0,0,0,0})
         ENDIF
         Skip
      ENDDO
//      ASORT(Mass)
//      For i=1 To Cou
//          ? Mass[i][1]
//      Next
//      index on tarif to &index unique
//      go top
//      do while !eof()
//         count++
//         skip
//      enddo
//      go top
//      cou=0
//      Obrabot("‘®àâ¨à®¢ª  â à¨ä®¢")
//      do while !eof()
//         cou++
//         Count++
//         aadd(mass,{tarif,0,0,0,0})
//         skip
//      enddo
      use
//--------------- âªàëâ¨¥ ¡ §ë á ¨­¤¥ªá®¬ ¢ ®¡« áâ¨ ¯®ª § ­¨© áç¥âç¨ª®¢...
      LoadMonth(month_)
      go top
      desc=fcreate(Ddir+'otchet.gkv')
        tmp_sum:=tmp_sum+summ
        summ:=0
        balabala:=0
        perem=Center(cObrabot+" §  ¯®âà¥¡«¥­­ãî",81," ",.t.)+chr(13)+chr(10)+;
        center("í«¥ªâà®í­¥à£¨î §  "+rmonth+" ¬¥áïæ "+alltrim(str(year(new_date)))+;
        " £.",81,' ',.t.)+chr(13)+chr(10)+chr(13)+chr(10)
        fwrite(desc,perem)
        IF nType==1.or.nType==2
           Perem="                           ƒ®áá¥ªâ®à                       à®¬á¥ªâ®à"+crlf
        ELSE
           Perem:=""
        ENDIF
        Perem:=Perem+"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"+chr(13)+chr(10)+;
              "³    ’ à¨ä    ³      áå®¤     ³  ‘ã¬¬         ³      áå®¤     ³  ‘ã¬¬         ³"+chr(13)+chr(10)
        fwrite(desc,perem)
        perem="ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+chr(13)+chr(10)
        fwrite(desc,perem)
//        Obrabot(cObrabot)
			  oProgress:create()
			  oProgress:minimum := 1
        Select Main
        Go Top
			  oProgress:maximum := RecCount()
//            KolKl=KolKl+39/Count
//            colorwin(12,21,12,21+KolKl,'n/n')
            rash=0
            summ=0
            go top
            do while .not.eof()
   	  			   oProgress:increment()																				// Progress Bar Increment
               DO CASE
                  Case nType==1
                       lCalck:=.T.
                  Case nType==2
                       IF Main->Lic_Schet<99999
                          lCalck:=.T.
                       ELSE
                          lCalck:=.F.
                       ENDIF
                  Case nType==3
                       IF Main->Lic_Schet>99999
                          lCalck:=.T.
                       ELSE
                          lCalck:=.F.
                       ENDIF
               ENDCASE
               IF lCalck
                  Select Licevoj
                  Seek Main->Lic_Schet
//                  IF Found()
                     Do While Lic_Sch==Main->Lic_schet
                        Kod:="("+Alltrim(Str(Main->Lic_Schet))+")"+Alltrim(Schetchik)
                        Select(Month_)
                        Seek Kod
                        IF Found()
                          IF alltrim(MYupper(Licevoj->schetchik))!="€.Œ™"
                          for i=1 to count
                           if mass[i][1]==tarif
                                 rash:=0; Summ:=0
                                 if summa#0
                                    IF rashod>0
                                       TmpRash=if((rashod-subab)>0,rashod-subab,subab-rashod)
                                    ELSE
                                    	 TmpRash:=rashod
                                    ENDIF
                                       nSumTar:=nSumTar+TmpRash
                                       IF MAIN->Kniga_old#7
                                          Mass[i][2]:=Mass[i][2]+TmpRash
                                          Mass[i][3]:=Mass[i][3]+summa
                                          SumTar[1]:=SumTar[1]+summa
                                       ELSE
                                          Mass[i][4]:=Mass[i][4]+TmpRash
                                          Mass[i][5]:=Mass[i][5]+summa
                                          SumTar[2]:=SumTar[2]+summa
                                       ENDIF
/*                                 else
                                       IF MAIN->Kniga_old#7
                                          Mass[i][2]:=Mass[i][2]+rashod
                                          Mass[i][3]:=Mass[i][3]+summa
                                          SumTar[1]:=SumTar[1]+summa
                                       ELSE
                                          Mass[i][4]:=Mass[i][4]+rashod
                                          Mass[i][5]:=Mass[i][5]+summa
                                          SumTar[2]:=SumTar[2]+summa
                                       ENDIF
*/
                                 endif
//                                  endif
                           endif
                          NEXT
                          ENDIF
                        ENDIF
                        Select Licevoj
                        Skip
                     ENDDO
//                  ENDIF
               ENDIF
               Select Main
               skip
            ENDDO
            FOR i:=1 To Count
            		perem="³   "+str(mass[i][1])+"  ³ "+str(round(mass[i][2],Decimal))+"  ³"+str(round(mass[i][3],Decimal),15,2)+"³ "+str(round(mass[i][4],Decimal))+"  ³"+str(round(mass[i][5],Decimal),15,2)+"³"+chr(13)+chr(10)
            		fwrite(desc,perem)
            Next
//            balabala=balabala+summ
//        next
      fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+chr(13)+chr(10))
      fwrite(desc,"³             ³                ³"+str(round(SumTar[1],Decimal),15,2)+"³                ³"+str(round(SumTar[2],Decimal),15,2)+"³"+chr(13)+chr(10))
      fwrite(desc,"ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+chr(13)+chr(10))
      fwrite(desc,'³ ‚á¥£®  '+str(round(SumTar[1]+SumTar[2],2),17,2)+' àã¡.                                                 ³'+chr(13)+chr(10))
      fwrite(desc,"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"+chr(13)+chr(10))
      FWrite(Desc,Str(nSumTar,15)+chr(13)+chr(10))
      perem=""
//      use
//      loadmonth(month_)
      fwrite(desc,perem)
      fclose(desc)
      deletefile(Ddir+'temp.ntx')
   		oProgress:destroy()																							// Progress Bar Destroy
   		oDlg:Destroy()
endif
select(sele)
set order to ind
go rec
restore screen from scr
RunSaver:=.T.
return NIL





function loadmonth(month1)
do case
  case month1=1
       load('1',Schet_Share+'jan.dbf',Schet_Share+'jan_kod.ntx',,.f.)
  case month1=2
       load('2',Schet_Share+'feb.dbf',Schet_Share+'feb_kod.ntx',,.f.)
  case month1=3
       load('3',Schet_Share+'mar.dbf',Schet_Share+'mar_kod.ntx',,.f.)
  case month1=4
       load('4',Schet_Share+'apr.dbf',Schet_Share+'apr_kod.ntx',,.f.)
  case month1=5
       load('5',Schet_Share+'may.dbf',Schet_Share+'may_kod.ntx',,.f.)
  case month1=6
       load('6',Schet_Share+'jun.dbf',Schet_Share+'jun_kod.ntx',,.f.)
  case month1=7
       load('7',Schet_Share+'jul.dbf',Schet_Share+'jul_kod.ntx',,.f.)
  case month1=8
       load('8',Schet_Share+'aug.dbf',Schet_Share+'aug_kod.ntx',,.f.)
  case month1=9
       load('9',Schet_Share+'sep.dbf',Schet_Share+'sep_kod.ntx',,.f.)
  case month1=10
       load('10',Schet_Share+'oct.dbf',Schet_Share+'oct_kod.ntx',,.f.)
  case month1=11
       load('11',Schet_Share+'nov.dbf',Schet_Share+'nov_kod.ntx',,.f.)
  case month1=12
       load('12',Schet_Share+'dec.dbf',Schet_Share+'dec_kod.ntx',,.f.)
endcase
return NIL
