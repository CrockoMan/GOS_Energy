func optimizaciq
Local MyOldSel,NameInd:=""
private ret_val,old_scr,nm1,_i,old_col,file,file_,old_scr_,trtt
old_col=setcolor()
ret_val=.f.
declare name_of_db[12]
nm1=loarr('name_of_db','Jan.dbf','Feb.dbf','Mac.dbf','Apr.dbf','May.dbf','Jun.dbf',;
'Jul.dbf','Aug.dbf','Sep.dbf','Oct.dbf','Nov.dbf','Dec.dbf')
trtt=.f.
if memory(0)>=30
*       ?? chr(7)
*       if schet_grugu#0
                if Al_Box({'Произвести оптимизацию'},2)==1
                        trtt=.t.
                else
                        trtt=.f.
                endif
*       endif
if trtt
                save screen to old_scr
        for i=1 to 12
*               save screen
                do sob with name_of_db[i]
                select(i)
                pack
                reindex
*               restore screen
        next i
        select 77
        save screen to old_scr_
&&file_=dir+'temp.dbf'
file_=schet_tdisk+'temp.dbf'
copy structure to &file_
load('250',dir+'temp.dbf')
select 77
obrabot('Оптимизация базы Licevoj.dbf')
if reccount()#0
        temp_=40/reccount()
        kol_kl=0
        go top
        do while .not.eof()
                select 250
                append blank
                replace lic_sch with Licevoj->lic_sch
                replace delo    with Licevoj->delo
                replace potreb  with Licevoj->potreb
                replace r_schet with Licevoj->r_schet
                replace k_schet with Licevoj->k_schet
                replace mfo     with Licevoj->mfo
                replace object1 with Licevoj->object1
                replace object2 with Licevoj->object2
                replace adres   with Licevoj->adres
                replace kl      with Licevoj->kl
                replace pl      with Licevoj->pl
                replace transf  with Licevoj->transf
                replace tok     with Licevoj->tok
                replace data_ust with Licevoj->data_ust
                replace schetchik with Licevoj->schetchik
                replace silowaq with Licevoj->silowaq
                replace oswesh  with Licevoj->oswesh
                replace tip     with Licevoj->tip
                replace b       with Licevoj->b
                replace a       with Licevoj->a
                replace pokazanie with Licevoj->pokazanie
                replace god_prow with Licevoj->god_prow
                replace telefon with Licevoj->telefon
                replace bank    with Licevoj->bank
                replace last_year with Licevoj->last_year
                replace reaktivn with Licevoj->reaktivn
*               replace drug_nach with Licevoj->drug_nach
                select 77
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                skip
        enddo
        select 77
        use
        select 250
        use
        copy_(Ddir+'temp.dbf',path_copy+'licevoj.dbf')
        make_ind('0','licevoj.dbf',schet_tdisk+'lic_sch.ntx','lic_sch',schet_tdisk+'schetchi.ntx','schetchik')
        load('77','licevoj.dbf','lic_sch.ntx','schetchi.ntx')
        deletefile(file_)
endif
deletefile(Ddir+'temp.dbf')
restore screen from old_scr_
        save screen
        do sob with 'Licevoj.dbf'
        pack
        reindex
        restore screen

        save screen
        select 110
        do sob with "Bank.dbf"
        pack
        reindex
        select 88
        do sob with 'Main.dbf'
        pack
        reindex
        select 15
        do sob with 'Obormot.dbf'
        pack
        reindex
        select 33
        do sob with 'Limit.dbf'
        pack
        reindex
        do sob with 'Otrasl.dbf'
        pack
        reindex
        do sob with 'Penq.dbf'
        pack
        reindex
        for i=1 to 12
                do sob with alltrim(str(i))+'.dbf'
                select 44
                for j=1 to 3
                        do case
                                case j=1
                                        _i='o'+alltrim(str(i))
                                case j=2
                                        _i='p'+alltrim(str(i))
                                case j=3
                                        _i='h'+alltrim(str(i))
                        endcase
//                      use &_i
                        if superload(_i)
                                pack
                                use
                        endif
                next
        next
        restore screen
        set color to
        restore screen from old_scr
******************** Создание индексов для баз данных *************************
        do servis2
*******************************************************************************
//      tone(440.00,0.5)
        ?? chr(7)
        ret_val=.t.
endif
for i=1 to 12
        adel(name_of_db,i)
next
else
        ret_val=.f.
        Myerror(' Свободной памяти недостаточно для оптимизации ! ')
endif
setcolor(old_col)
return ret_val
*
*****
**************
**************************



proc servis2
Local oDlg,aSizeDeskTop,aPos,oProgress
private temp_,kol_kl
save screen
commit
close all
//temp_=39/48
//kol_kl=0
//obrabot("Выполняется загрузка данных")
//        kol_kl=kol_kl+temp_
//        colorwin(12,21,12,21+kol_kl,'n/n')



oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
aSizeDesktop    := oMainWindow:currentSize()
//aSizeDesktop  := AppDesktop():currentSize()
oDlg:create(oMainWindow ,, {100,150}, {aSizeDeskTop[1]-200,90} ) 
oDlg:title    := "Выполняется загрузка данных" 
oDlg:SysMenu	:= .F.
oDlg:Configure()
oDlg:Show()
aSizeDesktop  := oDlg:currentSize()
aPos					:= oDlg:CurrentPos()
oProgress 		:= ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )
  														
oProgress:create()
oProgress:minimum := 1
oProgress:maximum := 58
	
make_ind('0',DDir+'BSmain.dbf',DDir+'BS1.ntx','lic_schet',DDir+'BS2.ntx','MyUpper(potrebitel)',.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'main.dbf',schet_share+'lic.ntx','lic_schet',schet_share+'potrebit.ntx','MyUpper(potrebitel)',.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'licevoj.dbf',schet_share+'lic_sch.ntx','lic_sch',schet_share+'schetchi.ntx','schetchik',.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'jan.dbf',schet_share+'jan_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'feb.dbf',schet_share+'feb_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'mar.dbf',schet_share+'mar_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'apr.dbf',schet_share+'apr_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'may.dbf',schet_share+'may_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'jun.dbf',schet_share+'jun_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'jul.dbf',schet_share+'jul_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'aug.dbf',schet_share+'aug_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'sep.dbf',schet_share+'sep_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'oct.dbf',schet_share+'oct_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'nov.dbf',schet_share+'nov_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'dec.dbf',schet_share+'dec_kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'dec_.dbf',schet_share+'dec__kod.ntx','kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'obormot.dbf',schet_share+'lic_obor.ntx','lic_schet',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'limit.dbf',schet_share+'lic_limi.ntx','lic_schet',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'limit2.dbf',schet_share+'limit2.ntx','lic_schet',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'penq.dbf',schet_share+'lic_penq.ntx','licevoj',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'tobank.dbf',  schet_share+'tobank.ntx',  'plat_treb',schet_share+'tobankl.ntx',"Lic_schet",.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'bank_kod.dbf',schet_share+'bank_kod.ntx','bank_kod',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind("0",schet_share+"SFKNIGA.DBF", schet_share+"SFKNIGA.NTX", "lic_schet", schet_share+"SFKNIGAL.NTX", "number",.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind("0",schet_share+"SFKNIGAP.DBF",schet_share+"SFKNIGAP.NTX","lic_schet",,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind("0",schet_share+"NARYAD.DBF",  schet_share+"NARYAD.NTX",  "licevoj",,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'PH.Dbf',schet_share+'PH.ntx','Licevoj',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Plomba.Dbf',schet_share+'Plomba.ntx','Kod',schet_share+'PlZagim.ntx',"Zagim",.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Plomba.Dbf',schet_share+'PlA.ntx','PhaseA',schet_share+'PlB.ntx',"PhaseB",.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Plomba.Dbf',schet_share+'PlC.ntx','PhaseC',schet_share+'PlVvod.ntx',"VvodPlomba",.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',DDir+'PlLocal.Dbf',DDir+'PlLocal.ntx','Kod',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'OutBlank.Dbf',schet_share+'OutBlank.ntx','Licevoj',,,.t.,.f.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Lose.dbf',schet_share+'LoseLic.ntx','licevoj',schet_share+'LoseKod.ntx','Kod',.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'LoseTran.dbf',schet_share+'LoseTLic.ntx','licevoj',schet_share+'LoseTKod.ntx','Kod',.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Fnsi.dbf',schet_share+'Fnsi.ntx','KA',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Fnsi.dbf',schet_share+'FnsiKUL.ntx','KUL',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Fosn.dbf',schet_share+'Fosn.ntx','KA',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Fosn.dbf',schet_share+'FosnCS.ntx','CHSearch',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Fosn.dbf',schet_share+'FosnKOD.ntx','KOD',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment

        For I=1 To 12
						oProgress:increment()																				// Progress Bar Increment

            Close All
            oInd:=Schet_Share+"O"+AllTrim(Str(i,2))+".Ntx"
            oBase:=Schet_Share+"O"+AllTrim(Str(i,2))+".DBF"
            make_ind('0',oBase,oInd,'Licevoj',,,.t.,.t.)

            oInd:=Schet_Share+"P"+AllTrim(Str(i,2))+".Ntx"
            oBase:=Schet_Share+"P"+AllTrim(Str(i,2))+".DBF"
            make_ind('0',oBase,oInd,'Licevoj',,,.t.,.t.)

            oInd:=Schet_Share+"H"+AllTrim(Str(i,2))+".Ntx"
            oBase:=Schet_Share+"H"+AllTrim(Str(i,2))+".DBF"
            make_ind('0',oBase,oInd,'Licevoj',,,.t.,.t.)

            oInd:=Schet_Share+"A"+AllTrim(Str(i,2))+".Ntx"
            oBase:=Schet_Share+"A"+AllTrim(Str(i,2))+".DBF"
            make_ind('0',oBase,oInd,'Licevoj',,,.t.,.t.)
        Next

make_ind('0',schet_share+'Obhod.dbf',schet_share+'Obhod.ntx','Licevoj',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Fyear.dbf',schet_share+'FyearKOD.ntx','KOD',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Fyear.dbf',schet_share+'Fyear.ntx','KA',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'FSch.dbf',schet_share+'FSch.ntx','KTS',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'FSign.dbf',schet_share+'FSign.ntx','Symbol',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Fkods.dbf',schet_share+'Fkods.ntx','Kul',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',schet_share+'Fvo.dbf',schet_share+'Fvo.ntx','Kvo',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
make_ind('0',DDir+'Copl.dbf',DDir+'Copl.ntx','Lic',,,.t.,.t.)
oProgress:increment()																				// Progress Bar Increment
CLOSE ALL
oProgress:destroy()																							// Progress Bar Destroy
oDlg:Destroy()
loadgos()
restore screen
return