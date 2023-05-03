STATIC filedit:=NIL


function myeditor(menuparam)
local choice,color_buff,screen_buff,oldfile,old_scre,Myexit,dir,fildir
color_buff:=setcolor()
filedit=if(filedit==NIL,TextDir+'Noname.txt',filedit)
if menuparam==NIL
//      do p_edit
else
        desc=fopen(filedit)
        len=fseek(desc,0,2)
        fclose(desc)
do case
        case menuparam=1
                desc=fopen(filedit)
                len=fseek(desc,0,2)
                fclose(desc)
                if len>=30000
                        al_box({" Выбранный файл очень большой для этого редактора "})
                else
                        save screen to old_scre
                        SET COLOR TO N/BG
                        colorwin(10,25,14,63,'n/n')
                        @ 09,23,13,61 BOX "         "
                        @ 09,23 SAY "┌─────────────────────────────────────╖"
                        @ 10,23 SAY "│     Тип редактируемого текста       ║"
                        @ 11,23 SAY "│"+space(37)+"║"
                        @ 12,23 SAY "│ Стандартный               Широкий   ║"
                        @ 13,23 SAY "╘═════════════════════════════════════╝"
                        do while .t.
                                SET COLOR TO N/BG,n/g
                                @ 12,24 prompt " Стандартный "
                                @ 12,48 prompt "   Широкий  "
                                menu to choice
                                do case
                                        case choice=2
                                                Keditor(filedit,200)
                                        case choice=1
                                                Keditor(filedit,79)
                                        otherwise
                                                exit
                                endcase
                        enddo
                        choice=1
                        restore screen from old_scre
                        setcolor(color_buff)
                endif
        case menuparam=11
                if len>=30000
                        al_box({" Выбранный файл очень большой для этого редактора "})
                else
                        Keditor(filedit,79)
                endif
        case menuparam=12
                if len>=30000
                        al_box({" Выбранный файл очень большой для этого редактора "})
                else
                        Keditor(filedit,200)
                endif
        case menuparam=2
                save screen
                colorwin(11,25,14,61,'n/n')
                @ 10,23,13,59 BOX "         "
                @ 10,23 SAY "┌───────────────────────────────────╖"
                @ 11,23 SAY "│     Укажите текст для работы      ║"
                @ 12,23 SAY "│"+space(35)+"║"
                @ 13,23 SAY "╘═══════════════════════════════════╝"
                oldfile=MYupper(filedit)
                oldfile=oldfile+space(35-len(oldfile))
                set color to w+/bg
                set cursor on
                set confirm on
                @ 12,24 get oldfile
                read
                set cursor off
                set confir off
                Clear Typeahead
                if updated()
                        filedit=alltrim(MYUpper(oldfile))
                        if .not.file(filedit)
                                if yes_or_not('   Этот файл на диске отсутсвует !   ',;
                                              '    Хотите создать новый текст ?')
                                        keyboard chr(5)
                                endif
                        else
                                keyboard chr(5)
                        endif
                endif
                restore screen
                setcolor(color_buff)
        case menuparam=3
                if al_box({'Вы действительно хотите удалить файл',;
                           ''+filedit+' ?'},2,,,,,,,,"gr+/r+,w/b+,,,gr/r+")=1
                                deletefile(filedit)
                                Al_Box({'Файл "'+filedit+'" удален'},1)
                                filedit=diskname()+':'+dirname(diskname())+'\TEXT`S\Noname.txt'
                                setcolor(color_buff)
                endif
        case menuparam=4
                tmpfile=GetFile(dir,5)
                filedit=MYupper(if(empty(tmpfile),filedit,tmpfile))
                if .not.empty(tmpfile)
                        keyboard chr(5)+chr(5)+chr(5)+chr(13)+chr(13)
                endif
                setcolor(color_buff)
endcase
endif
return NIL




//----------------- Текстовый редактор
func Keditor(memofile,line_length)
set key 141 to rusH
private prev_val,deja_vu,eresume,altered,update,browse,;
        use_func,ufunc,ins_on,word_wrap,tabsize,prev_scr,prev_col,first,;
        altered_,bell,desc,len,memofil:=memofile
prev_col=setcolor()
prev_scr=win_save(0,0,maxrow(),maxcol())

desc=fopen(memofile)
len=fseek(desc,0,2)
fclose(desc)
//IF len>30000
//   Al_Box({"Извините, но этот файл слишком велик"},1,{" Закончить "})
//   Return NIL
//ENDIF

setcursor(6,7,.t.)
setlastkey(19)
prev_memo = ""
ret_val = 0
deja_vu = .F.
eresume = .F.
altered = .F.

update = .T.
browse = .T.
&& line_length = 200
use_func = .T.
ufunc = "mfunc"
ins_on = .F.
scrl_on = .F.
word_wrap = .T.
tabsize = 8
set cursor on
Myexit=.f.

if .not.csetbell()
        SET BELL ON
        bell=.f.
endif
*SET SCOREBOARD OFF

DO WHILE .T.
        altered=.f.
        IF .NOT. eresume
                IF MyExit = .t.
                        exit
                ENDIF
                IF use_func
                        ufunc = "mfunc"
                ELSE
                        IF browse
                                ufunc = ""
                        ELSE
                                ufunc = .F.
                        ENDIF
                ENDIF
                IF .NOT. (prev_memo == memofile)
                        usr_memo = MEMOREAD(memofile)
                        prev_memo = memofile
                        line_num = 1
                        col_num = 0
                        rel_row = 0
                        rel_col = 0
                        altered = .F.
                ENDIF

                set color to n/w
                @ 0,0 say space(80)
                @ maxrow(),00 say space(80)
                @ maxrow(),0 SAY center(LOWER(memofile),80,' ',.t.)
                if line_length>79
                        @ 0,68 say '[Скроллинг]'
                else
                        @ 0,68 say '[         ]'
                endif
                set color to +w/b
                @ 1,0 clear to maxrow()-1,maxcol()
        ENDIF
        init_count = 1
        deja_vu = .F.
        eresume = .F.
        altered=.f.
        altered_=.f.
        usr_memo = MEMOEDIT(usr_memo,1,0,maxrow()-1,maxcol(), update, ufunc,line_length,;
                               tabsize,line_num, 0, rel_row, rel_col)

        IF .NOT. memofile == "none" .AND. .NOT. EMPTY(usr_memo) .AND. ret_val = 23
                altered = .F.
                IF .NOT. MEMOWRIT(memofile,hardcr(usr_memo))
                        al_box({'Ошибка записи файла '+MemoFile})
//                        al_box({'Ошибка записи на диск '+diskname()})
                        exit
                ENDIF
                if Myexit=.f.
                        set color to n/w
                        @ 0,0 say space(80)
                        set color to +w/b
                        keyboard chr(19)
                endif
        ENDIF
        if lastkey()=27
                exit
        endif
ENDDO
if .not.bell
        set bell off
endif
setcursor(2,7,.t.)
win_rest(prev_scr)
setcolor(prev_col)
set cursor off
set key 141 to
return NIL



****
*       mfunc()
*
*       memoedit user function
****
FUNCTION mfunc

PARAMETERS mode, line, col
PRIVATE keypress
keypress=lastkey()
if isdata(keypress).or.keypress=32.or.keypress=7.or.keypress=8.or.keypress=13;
                   .or.keypress=25.or.keypress=20
        if !altered_
                if keypress#13
                        set cursor off
                        set color to g+/w
                        @ 00,37 say chr(16)+chr(15)+chr(17)
                        colorwin(0,38,0,38,'*r+/w')
                        set color to w+/b
                        set cursor on
                        altered_=.t.
                else
                        if ins_on
                                set cursor off
                                set color to g+/w
                                @ 00,37 say chr(16)+chr(15)+chr(17)
                                colorwin(0,38,0,38,'*r+/w')
                                set color to w+/b
                                set cursor on
                                altered_=.t.
                        endif
                endif
        endif
endif
ret_val = 0
DO CASE
        CASE mode = 3
                * initialization..global variables "init_count" and "deja_vu"
                *        control the initialization process..note that this is
                *        much simpler when the parameters passed to MEMOEDIT
                *        are known in advance (which is usually true)

                IF init_count = 1
                        * set initial insert mode
                        ins_mode = READINSERT()

                        IF (ins_on .AND. .NOT. ins_mode) .OR.;
                           (.NOT. ins_on .AND. ins_mode)
                                * toggle insert mode
                                ret_val = 22
                        ELSE
                                * insert mode correct
                                init_count = 2
                                set color to n/w
                                @ 0,58 SAY IF(ins_on,"<Вставка>", "<Замена > ")
                                set color to +w/b
                        ENDIF
                ENDIF

                IF init_count = 2
                        * set initial scroll state (defaults ON if update OFF)

                        IF ((.NOT. scrl_on .AND. .NOT. update) .OR.;
                                (scrl_on .AND. update)) .AND. .NOT. deja_vu
                                * need to toggle
                                deja_vu = .T.
                                ret_val = 35
                        ELSE
                                * scroll state correct
                                set color to n+/w
                                init_count = 3
                                deja_vu = .F.
                                @ 0,49 SAY IF(scrl_on,chr(23),chr(25))
                                set color to +w/b
                        ENDIF
                ENDIF

                IF init_count = 3
                        * set initial word wrap..always defaults ON

                        IF .NOT. word_wrap .AND. .NOT. deja_vu
                                * need to toggle
                                deja_vu = .T.
                                ret_val = 34

                        ELSE
                                * word wrap correct
                                set color to n+/w
                                init_count = 4
                                deja_vu = .F.
                                @ 0,45 SAY IF(word_wrap,chr(31),chr(4))
                                set color to +w/b

                        ENDIF
                ENDIF

                IF init_count = 4
                        * finished initialization..note that if all defaults are
                        *       correct we reach this point on the first call
                        if col_num#0
                                keyboard replicate(chr(4),col_num)
                        endif
                        ret_val = 0

                ENDIF

        CASE mode = 0
                * idle
                set cursor off
                set color to n/w
                @ 0,0 SAY "Line " + pad1(LTRIM(STR(line)), 4)
                @ 0,10 SAY "Col " + pad1(LTRIM(STR(col+1)), 3)
                set color to +w/b
                set cursor on

        OTHERWISE
                * обработка нажатых клавиш

                * запоминаю переменные для возможного возврата в редактор
                line_num = line
                col_num = col
                rel_row = ROW()-1
                rel_col = COL()-1

                IF mode = 2
                        altered = .T.
                ENDIF
                Clear Typeahead
                DO CASE
                        CASE keypress=2
                                ret_val=100
*                               keyboard chr(100)
                        CASE keypress=26
                                ret_val=26
*                               keyboard chr(26)
                        CASE keypress =28
                                save screen
                                set color to n/w
                                set cursor off
                                colorwin(7,4,18,76,"n+/n")
                                @ 06,03,17,75 BOX "         "
                                @ 06,03 SAY "┌────────── В редакторе поддерживаются следующие клавиши : ─────────────┐"
                                @ 07,03 SAY "│"+space(71)+"│"
                                @ 08,03 SAY "│    Ctrl+Y  - Удалить строку        F2 - Записать текст и продолжить   │"
                                @ 09,03 SAY "│    CtrL+T  - Удалить строку справа      редактирование                │"
                                @ 10,03 SAY "│    Ctrl+I  - Вставить строку       F5 - Печать текущего текста        │"
                                @ 11,03 SAY "│    Ctrl+"+chr(27)+"- - Слово влево           F6 - Циклический сдвиг вкл/выкл.   │"
                                @ 12,03 SAY "│    Ctrl+-"+chr(26)+" - Слово вправо          F7 - Перенос слов вкл/выкл         │"
                                @ 13,03 SAY "│"+space(71)+"│"
                                @ 14,03 SAY "│   "+chr(24)+" - Строчку вверх   "+chr(27)+" - Символ влево    Ins - Режим вставки/замены  │"
                                @ 15,03 SAY "│   "+chr(25)+" - Строчку вниз    "+chr(26)+" - Символ вправо   Esc - закончить работу      │"
                                @ 16,03 SAY "│"+space(71)+"│"
                                @ 17,03 SAY "└───────────────────────────────────────────────────────────────────────┘"
                                hot_inkey(0)
                                set cursor on
                                set color to +w/b
                                restore screen
                        CASE keypress =-4
                                set cursor off
                                if !altered
                                * ^W..ignore (disable)
                                   Clear Typeahead
                                   print_fi(,memofil)
                                   ret_val = 32
                                   Keyboard chr(27)
//                                response:=al_box({" Выберите тип печати текста"},;
//                                                3,{"Нормальная","Плотная","Выход"})
//                                        do case
//                                                case response=1
//                                                        copy_(memofil,'prn',1)
//                                                case response=2
//                                                        copy_(memofil,'prn')
//                                        endcase
                                else
                                        Myerror(' Текст не записан ! Печать невозможна ! ')
                                endif
                                restore screen
                                set color to w+/b
                                set cursor on

                        CASE keypress = -1
                                * Alt-W..write file
                                IF .NOT. altered_
                                        * no changes to write
                                        set color to n/w
                                        @ maxrow(),0 SAY SPACE(80)
                                        @ maxrow(),0 SAY center("Записан " + LOWER(memofil) + "",80,' ',.t.)
                                        set color to w+/b
                                        ret_val=32
                                ELSE
                                        * write and resume
                                        set color to n/w
                                        @ maxrow(),0 SAY SPACE(80)
                                        @ maxrow(),0 SAY center("Записываю " + LOWER(memofil) + "...",80,' ',.t.)
                                        set color to w+/b
                                        ret_val = 23
                                ENDIF

                        CASE keypress = 301 .OR. keypress = 27
                                * Esc/Alt-X..exit
                                IF .NOT. altered_
                                        * no change
                                        ret_val = 27
                                        Myexit=.t.
                                ELSE
                                        * changes have been made to memo
                                        set cursor off
                                        response:=al_box({"Текст был изменен, выберите дальнейшее действие"};
                                        ,3,{" Сохранить "," Не сохранять "," Не выходить "})
                                        DO CASE

                                                CASE response = 3
                                                        * ignore
                                                        ret_val = 32

                                                case response = 1
                                                        * save and exit
                                                        Myexit=.t.
                                                        Myerror('  Записываю редактируемый файл ...',1)
                                                        ret_val = 23
                                                        setlastkey(27)

                                                case response = 2
                                                        * abort
                                                        ret_val = 27
                                                        setlastkey(27)

                                        ENDCASE
                                        restore screen
                                        set color to w+/b
                                        set cursor on
                                ENDIF

                        CASE keypress = 289
                                * Alt-F..display file name
                                set color to n/w
                                @ maxrow(),0 SAY center(LOWER(memofil),80,' ',.t.)

                        CASE keypress = 25
                                * F3..delete line
                                altered_=.t.
                                ret_val = 25

                        CASE keypress = 9
                                * Ctrl+I - insert line
                                altered_=.t.
                                ret_val = 14

                        CASE keypress=20
                                altered_=.t.
                                ret_val=20

                        CASE keypress = -5 .AND. update
                                * F5..toggle word wrap
                                word_wrap = .NOT. word_wrap
                                ret_val = 34
                                set color to n+/w
                                @ 0,45 SAY IF(word_wrap,chr(31),chr(4))
                                set color to +w/b

                        CASE keypress = -6
                                * F6..toggle scroll lock
                                scrl_on = .NOT. scrl_on
                                ret_val = 35
                                set color to n+/w
                                @ 0,49 SAY IF(scrl_on,chr(23),chr(25))
                                set color to +w/b

                        CASE (keypress = 279 .OR. keypress = 22) .AND. update
                                * ^V/Ins/Alt-I..toggle insert mode
                                ins_on = .NOT. ins_on
                                ret_val = 22
                                set color to n/w
                                @ 0,58 SAY IF(ins_on,"<Вставка>", "<Замена > ")
                                set color to +w/b
                ENDCASE
ENDCASE
RETURN ret_val


****
*       pad()
*
*       pad with spaces
****
FUNCTION pad1

PARAMETERS string, length
RETURN SUBSTR(string + SPACE(length), 1, length)

proc rusH
keyboard chr(72)
return

Function SetLastKey(KeyNum)
clear typeahead
keyboard chr(KeyNum)
Return NIL


* eof me.prg
