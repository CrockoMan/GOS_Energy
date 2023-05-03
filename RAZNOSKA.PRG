/*                      Разноска оплаты по всем книгам                  */
#include "my.ch"

FUNCTION Raznoska
LOCAL scrbuf:=win_save(2,3,17,79),raznoska,saveobr:="",temp_,kol_kl,;
      selkniga,oplname:='',alias:='',mykniga,typeoplata:=1,;
      recbuf,ordbuf,colorbuf,tmp,month_,database,menuscr:="",tmpstring:='',;
      nextrec:=0,reccount:=0,Spisok:={},Lic
PRIVATE nm1,nm2,nm3,nm4,t1,l1,b1,r1,inp
sele=select()
recbuf=recno()
ordbuf=indexord()
colorbuf=setcolor()
month_=month_menu(1)
IF Month_==0
   Return NIL
ELSE
   IF Substr(Main->LockMonth,Month_,1)==Chr(Month_)
      Al_Box({"Работа с этим месяцем запрещена"})
      Return NIL
   ENDIF
ENDIF

menuscr:=win_save(17,31,MaxRow(),MaxCol())
spisok:={" Оплата электроэнергии   ",;
         " Оплата повышенной       ",;
         " Оплата пени        "}
typeoplata=vert_menu(spisok,"Оплата",,17,31,,'n/w,n/g,,,r/w',.F.)
win_rest(menuscr)
setcolor(colorbuf)
IF month_>0.and.typeoplata#4.and.typeoplata#0
        do case
                case typeoplata=1
                        oplname:=Schet_Share+'o'+alltrim(str(int(month_)))+".dbf"
                        tmpstring:="электроэнергии"
                        raznoska:="R.Dbf"
                case typeoplata=3
                        oplname:=Schet_Share+'p'+alltrim(str(int(month_)))+".dbf"
                        tmpstring:="пени"
                        raznoska:="Rp.Dbf"
                case typeoplata=2
                        oplname:=Schet_Share+'h'+alltrim(str(int(month_)))+".dbf"
                        tmpstring:="повышенной"
                        raznoska:="Rh.Dbf"
        endcase
        IF .not. file(Ddir+raznoska)
                copy_(Schet_Share+"o1.dbf",Ddir+raznoska)
                Select 48
                Use (DDir+raznoska) Exclusive
                zap
                Close
        ENDIF
        Select 48
        Use (DDir+raznoska) Exclusive
        GO TOP
        set color to n/w
        declare zgl[6]
        declare fil[6]
        colorwin(2,3,16,78,'n+/n')
        name='Справочник оплаты '+tmpstring+' за '+mesqc(month_)+' месяц'
        @ 2,3 SAY center(name,75," ",.t.)
        nm1=loarr('zgl','Лиц.сч.','Вид док.','Номер док.','Сумма оплаты','Дата оплаты','N Реестра')
        nm2=loarr('fil','licevoj','vid_dokum','num_dokum','summa','data','reestr')
        inp='0000000'
        ************ Begin make box
        t1=3   && Up
        l1=3   && Left
        b1=15  && Down
        r1=77  && Right
        *************  End make
        fsbrowse(7,1,20,78,'fil','zgl',inp,urov,kl)
        win_rest(scrbuf)
        Select Main
        Rec:=Recno()
        IF reccount()>0
           IF al_box({"Разнести внесенную оплату по всем предприятиям?"},2)=1
              saveobr:=win_save()
              Select 48
              pack
              Go Top
              NextRec:=1
              If reccount()>0
                 obrabot("Запись оплаты и расчет сальдо")
                 temp_=39/(reccount()-1)
                 kol_kl=0
                 DO WHILE .not.eof()
                    Go NextRec
                    IF .not.Deleted()
                       IF PutOplata(Licevoj,Vid_Dokum,Num_Dokum,Summa,Data,Reestr,OplName)
                          Lic:=Licevoj
                          Select Main
                          Seek Lic
                          DO OutEx With Month_
                          Select 48
                          Delete
                       ENDIF
                    ENDIF
                    NextRec++
                    kol_kl=kol_kl+temp_; colorwin(12,21,12,21+kol_kl,'n/n')
                 ENDDO
                 PACK
                 IF reccount()>0
                      al_box({"Оплaты с неизвестными лицевыми - "+alltrim(str(reccount()))})
                 ENDIF
              Endif
              win_rest(saveobr)
           ENDIF
        ENDIF
        Select Main; GoBase(Rec)
        SELECT(sele)
        SET COLOR TO (colorbuf)
        GoBase(recbuf)
ENDIF
win_rest(scrbuf)
RETURN NIL



Function PutOplata(_Licevoj,_Vid_Dokum,_Num_Dokum,_Summa,_Data,_Reestr,Base)
Local IsWrited:=.F.,Sel:=select(),RecMain,BaseName
Select Main
RecMain:=Recno()
Seek _Licevoj
IF Found()
   Select 0
   IF NetUse(Base,,0)
      IF RecLock(0)
         Append Blank
         Replace Licevoj With _Licevoj
         Replace Vid_Dokum With _Vid_Dokum
         Replace Num_Dokum With _Num_Dokum
         Replace Summa With _Summa
         Replace Data With _Data
         Replace Reestr With _Reestr
         UNLOCK
         IsWrited:=.T.
      ENDIF
      Use
   ENDIF
ENDIF
Select Main
GoBase(RecMain)
Select(Sel)
Return IsWrited
