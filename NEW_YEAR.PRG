*do NewYear


proc NewYear
private oldclr,oldscr,directoria,file_,files
oldclr=setcolor()
oldscr=savescreen(21,22,24,57)
if al_box({"Вы действительно хотите",;
          'перейти  на  новый  год',;
          'работы по предприятиям?'},2)==1
set color to +w/w,w+/b
colorwin(22,23,24,57,'n+/n')
@ 21,22 say "┌────────────────────────────────╖"
@ 22,22 say "│  Введите прошедший год         ║"
@ 23,22 say "╘════════════════════════════════╝"
old_year=alltrim(str(year(date())-1))
set curs on
set conf on
@ 22,23 say "  Введите прошедший год  " get old_year picture "@K9999"
read
set curs off
set conf off
if lastkey()#27
*       work(23,2)
        commit
        close all
        if dirmake(Ddir+alltrim(old_year))=0
                dirmake(Ddir+alltrim(old_year)+'\#1#2#3')
                dirmake(Ddir+alltrim(old_year)+'\#4#5')
                dirmake(Ddir+alltrim(old_year)+'\#6#7#8')
                dirmake(Ddir+alltrim(old_year)+'\#9#10#11')
                dirmake(Ddir+alltrim(old_year)+'\#12')
                for j=1 to 5
                        do case
                                case j=1
                                        directoria='#1#2#3'
                                case j=2
                                        directoria='#4#5'
                                case j=3
                                        directoria='#6#7#8'
                                case j=4
                                        directoria='#9#10#11'
                                case j=5
                                        directoria='#12'
                        endcase
                        files=adir(dir+directoria+"\*.dbf")
                        decl file_[files]
                        adir(dir+directoria+'\*.dbf',file_)
                        for i=1 to files
                                if copy_(dir+directoria+'\'+file_[i],dir+alltrim(old_year)+'\'+directoria+'\'+file_[i])=0
                                        exit
                                endif
                        next
                        copy_(dir+alltrim(old_year)+'\'+directoria+'\main.dbf',dir+directoria+'\main.dbf')
                        copy_(dir+directoria+'\dec.dbf',dir+directoria+'\dec_.dbf')
                        copy_(dir+alltrim(old_year)+'\'+directoria+'\licevoj.dbf',dir+directoria+'\licevoj.dbf')
                        copy_(dir+alltrim(old_year)+'\'+directoria+'\otrasl.dbf',dir+directoria+'\otrasl.dbf')
                        copy_(dir+alltrim(old_year)+'\'+directoria+'\limit.dbf',dir+directoria+'\limit.dbf')
select 0
db_f=dir+directoria+'\penq.dbf'
use &db_f
zap
use
select 10
db_f=dir+directoria+'\limit.dbf'
use &db_f
go top
select 0
for i=1 to 12
        for kkk=1 to 3
                do case
                        case kkk=1
                                db_f=dir+directoria+'\o'+alltrim(str(int(i)))+'.dbf'
                        case kkk=1
                                db_f=dir+directoria+'\p'+alltrim(str(int(i)))+'.dbf'
                        case kkk=1
                                db_f=dir+directoria+'\h'+alltrim(str(int(i)))+'.dbf'
                endcase
                use &db_f
                zap
                use
        next
        do case
                case i=1
                        db_f=dir+directoria+'\jan.dbf'
                case i=2
                        db_f=dir+directoria+'\feb.dbf'
                case i=3
                        db_f=dir+directoria+'\mar.dbf'
                case i=4
                        db_f=dir+directoria+'\apr.dbf'
                case i=5
                        db_f=dir+directoria+'\may.dbf'
                case i=6
                        db_f=dir+directoria+'\jun.dbf'
                case i=7
                        db_f=dir+directoria+'\jul.dbf'
                case i=8
                        db_f=dir+directoria+'\aug.dbf'
                case i=9
                        db_f=dir+directoria+'\sep.dbf'
                case i=10
                        db_f=dir+directoria+'\oct.dbf'
                case i=11
                        db_f=dir+directoria+'\nov.dbf'
                case i=12
                        db_f=dir+directoria+'\dec.dbf'
        endcase
        select 1
        use &db_f
        go top
********************************  Расчет лимитов
        select 10
        go top
        save screen
        obrabot("Лимиты на "+mesqc(i)+' '+alltrim(str(year(date())))+'г.')
        temp_=39/reccount()
        kol_kl=0
        do while !eof()
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                select 1
                go top
                rash=0
                do while !eof()
                        if limit->lic_schet=licevoj
if isnonds(tarif)  && Тариф без НДС?
        if isonlimit(kod)  && Счетчик включать в лимит?
           if is_on_high(tarif)
                  M->rash=M->rash+if(Rashod-subab>0,rashod-subab,subab-rashod)
           endif
        endif
endif
                        endif
                        skip
                enddo
                select 10
                rash=round(rash/1000,1)
                do case
                        case i=1
                                replace jan with rash
                        case i=2
                                replace feb with rash
                        case i=3
                                replace mac with rash
                        case i=4
                                replace apr with rash
                        case i=5
                                replace may with rash
                        case i=6
                                replace jun with rash
                        case i=7
                                replace jul with rash
                        case i=8
                                replace aug with rash
                        case i=9
                                replace sep with rash
                        case i=10
                                replace oct with rash
                        case i=11
                                replace nov with rash
                        case i=12
                                replace dec with rash
                endcase
                skip
        enddo
        restore screen
        select 1
        go top
************************************* Конец расчета лимитов
        save screen
        obrabot("Потери, коэффициенты и т.д. за "+mesqc(i))
        temp_=39/reccount()
        kol_kl=0
        do while !eof()
                kol_kl=kol_kl+temp_
                colorwin(12,21,12,21+kol_kl,'n/n')
                if substr(alltrim(num_of_sch),1,1)='п'.or.substr(alltrim(num_of_sch),1,1)='П'
                        replace month with 0
                        replace pokazaniq with 0
                        replace raznica with 0
*                       replace rashod with 0
*                       replace koeficient with 0
                        replace tarif with 0
                        replace summa with 0
                        replace percent with 0
                        replace subab with 0
                        replace drug_nach with .f.
                        replace moshn with .f.
                else
                        replace month with 0
                        replace pokazaniq with 0
                        replace raznica with 0
                        replace rashod with 0
                        replace koeficient with 0
                        replace tarif with 0
                        replace summa with 0
                        replace percent with 0
                        replace subab with 0
                        replace drug_nach with .f.
                        replace moshn with .f.
                endif
                skip
        enddo
        restore screen
        use
next
select 10
use
db_f=dir+directoria+'\obormot.dbf'
use &db_f
pack
go top
do while !eof()
        replace last_debet with debet12
        replace last_kred with kredit12
        replace debet12 with 0
        replace kredit12 with 0
        replace debet11 with 0
        replace kredit11 with 0
        replace debet10 with 0
        replace kredit10 with 0
        replace debet9 with 0
        replace kredit9 with 0
        replace debet8 with 0
        replace kredit8 with 0
        replace debet7 with 0
        replace kredit7 with 0
        replace debet6 with 0
        replace kredit6 with 0
        replace debet5 with 0
        replace kredit5 with 0
        replace debet4 with 0
        replace kredit4 with 0
        replace debet3 with 0
        replace kredit3 with 0
        replace debet2 with 0
        replace kredit2 with 0
        replace debet1 with 0
        replace kredit1 with 0
        highnach:=0
        highall:=0
        penqnach:=0
        penqhall:=0
        for hi=1 to 12
            tmpstring:='highn'+alltrim(str(int(hi)))
            highnach:=highnach+&tmpstring
            replace &tmpstring with 0
            tmpstring:='high'+alltrim(str(int(hi)))
            highall:=highall+&tmpstring
            replace &tmpstring with 0
            tmpstring:='penqn'+alltrim(str(int(hi)))
            penqnach:=penqnach+&tmpstring
            replace &tmpstring with 0
            tmpstring:='penq'+alltrim(str(int(hi)))
            penqall:=penqall+&tmpstring
            replace &tmpstring with 0
        next
        replace saldop with highnach-highall
        replace saldon with penqnach-penqall
        skip
enddo
use
                next
                dirchange(dir)
        else
                if dirchange(dir+alltrim(old_year))=0
                        al_box({"Архив данных за "+alltrim(old_year)+'г. уже существует.'})
                else
                        al_box({"Ошибка создания директории !"})
                endif
        endif
endif
endif
setcolor(oldclr)
restscreen(21,22,24,57,oldscr)
return