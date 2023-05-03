***********************************************************************
* PRG........: vid_stk
* CLASS......: Видео стек
* DESC.......: Накачка и откачка видео аттрибутов
* PREFIX.....: vstk
* EXPORT.....: vstk_push()
*              vstk_pop()
* CONSTRUCTOR:
* DESTRUCTOR.:
* USES.......:
* NOTES......: Необходимо компилировать с ключом /n, поскольку
*              используются external static переменные.


#include "debug.ch"           && Нам потребуется команда ASSERT
                              && из главы 2
#define LEN_COL_STR 20        && Число символов, используемых
                              && для задания цвета
#define LEN_VID_STK_ENTRY LEN_COL_STR + 3


* Символьная переменная, используемая как стек
STATIC vid_stk := ""          && Запомните, эта инициализация
                              && происходит только один раз,
                              && концептуально во время компиляции


* VOID vstk_push()
*
* Помещая элемент в видео стек, мы сохраняем установку SET CURSOR,
* текущее положение курсора и текущую установку цвета

FUNCTION vstk_push

        * Объединение атрибутов и добавление в начало vid_stk
        vid_stk = chr(set(_SET_CURSOR)) + ;
                  chr(row()) + chr(col()) + ;
                  pad(setcolor(), LEN_COL_STR) + ;
                  vid_stk

RETURN NIL


* VOID vstk_pop
*
* Вынимаем элемент из видео стека
* и восстанавливаем видео атрибуты

FUNCTION vstk_pop

        * Общая проверка, стек не должен быть пуст
        ASSERT(len(vid_stk) > 0,qout("Пустой стек"))

        setcursor(asc(substr(vid_stk, 1, 1)))

        * Установка положения курсора, путем вывода
        * пустой строки в требуемой позиции
        @ asc(substr(vid_stk, 2, 1)), ;
          asc(substr(vid_stk, 3, 1)) SAY ""

        setcolor(substr(vid_stk, 4, LEN_COL_STR))

        * Коррекция стека
        vid_stk = substr(vid_stk, LEN_VID_STK_ENTRY + 1)

RETURN NIL

*        Программа 4-2 Работа с видео стеком.
************************************************************************
STATIC FUNCTION sb_colors

        setcolor("B/R,G/N,,,BG/RB")

RETURN NIL
**********************************************************************
* Colors.prg
*
* Класс цветов

* CHARACTER [] col_split(color_to_split)
*
* CHARACTER color_to_split - Цвет для разбивки. Необязательно,
*                            по умолчанию для текущего цвета.
*
* RETURN - Массив с разбитыми цветами
*
* Разбивает color_to_split на пять цветов и возвращает их в
* массиве

#include "commands.ch"             // Для установки умолчаний

FUNCTION col_split(color_to_split)

LOCAL color_num, next_comma, colors[5]

        DEFAULT color_to_split TO setcolor()    // Глава 2
        FOR color_num = 1 TO 4
            next_comma = at(",", color_to_split)
            colors[color_num] = substr(color_to_split, 1, ;
                                next_comma - 1)
            color_to_split = substr(color_to_split, next_comma +1)
        NEXT

        colors[5] = color_to_split

RETURN colors

*        Программа 7-2. Разбиение строки цветов

**********************************************************************
*******************************************************************************
* PRG...................: Окна
* CLASS.................: Сохранение и восстановление окна
* PREFIX................: win
* EXPORT................: win_save
*                         win_rest
* CONSTRUCTOR...........:
* DESTUCTOR.............:
* USES..................:
*
* NOTES.................: Компилировать с /a /m /n /w


#include "windows.ch"
#include "commands.ch"     // Для DEFAULT TO

* CHARACTER win_save(t, l, b, r)
*
* NUMERIC t, l, b, r  - Координаты окна. Необязательные.
*                       По умолчанию 0, 0, maxrow(), maxcol()
* RETURN              - Комбинированные координаты и окно

FUNCTION win_save(t, l, b, r)

        DEFAULT t TO 0, ;
                l TO 0, ;
                b TO maxrow(), ;
                r TO maxcol()

RETURN chr(t) + chr(l) + chr(b) + chr(r) + savescreen(t, l, b, r)
//RETURN chr(t) + chr(l) + chr(b) + chr(r) + packscrn(t, l, b, r)

* VOID win_rest(win_str)
*
* CHARACTER win_str - Координаты окна, возвращенные из win_save
*
* Восстанавливает окно, сохраненное в win_save. Отметьте, что ей не
* нужны координаты окна - они сохранены в самом окне

FUNCTION win_rest(win_str)

        restscreen(GET_T(win_str), GET_L(win_str), ;
                   GET_B(win_str), GET_R(win_str), ;
                   GET_WIN(win_str))

//          Upacscrn(GET_T(win_str), GET_L(win_str), ;
//                   GET_B(win_str), GET_R(win_str), ;
//                   GET_WIN(win_str))
RETURN NIL

 *       Программа 7-3. Сохранение и восстановление окон

**********************************************************************
**********************************************************************
* Shadows.prg
*
* Класс тени

* VOID sha_attr(t, l, b, r, new_attr)
*
* NUMERIC t, l, b, r   - Координаты
*
* NUMERIC new_attr     - Значение для установки атрибута
*
* Обслуживающая подпрограмма читает строку с экрана, изменяет все
* атрибуты на new_attr, затем перерисовывает ее

STATIC FUNCTION sha_attr(t, l, b, r, new_attr)

LOCAL old_scr_area, new_scr_area, i

        * Сохраним область экрана в переменной
        old_scr_area = savescreen(t, l, b, r)

        * Инициализируем новую область экрана
        new_scr_area = ""

        * Копируем каждый символ из сохраненной области
        * в новую строку и изменяем атрибут
        FOR i = 1 TO len(old_scr_area) STEP 2

            new_scr_area = new_scr_area + substr(old_scr_area, ;
                           i, 1) + chr(new_attr)

        NEXT

        * Восстановливаем новую область с той же позиции экрана
        restscreen (t, l, b, r, new_scr_area)

RETURN NIL

  *      Программа 7-4. Изменение атрибутов высветки

**********************************************************************
**********************************************************************
* Shadows.prg
*
* Класс тени

* Макрос преобразования цвета. Преобразует пару "передний план/фон"
* в атрибут

#define ATTR_CONV(FORE, BACK) (BACK) * 16 + (FORE)

#define BLACK     0
#define WHITE     7
#define DK_GRAY   8

#define COL_SHADOW_ATTRIBUTE ATTR_CONV(DK_GRAY, BLACK)
#define BW_SHADOW_ATTRIBUTE ATTR_CONV(WHITE, BLACK)

* VOID sha_shadow(t, l, b, r)
*
* NUMERIC t, l, b, r   - Координаты бокса, вокруг которого рисуется
*                        тень, использующая одну строку ниже и один
*                        столбец справа от бокса.
*
* Рисует тень вокруг бокса, изменяя атрибуты символов. Мы используем
* белый на черном (07) для монохромных адаптеров и темно серый на черном
* (08) для цветных адаптеров


FUNCTION sha_shadow(t, l, b, r)




LOCAL shadow_attribute

* Только если есть место
IF r < maxcol() .AND. b < maxrow()
   shadow_attribute = iif(iscolor(), COL_SHADOW_ATTRIBUTE, ;
                                    BW_SHADOW_ATTRIBUTE)

   sha_attr(b + 1, l + 1, b + 1, r + 1, shadow_attribute)
   sha_attr(t + 1, r + 1, b + 1, r + 1, shadow_attribute)
ENDIF

RETURN NIL

   *     Программа 7-5. Рисование теней
