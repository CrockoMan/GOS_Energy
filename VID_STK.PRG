***********************************************************************
* PRG........: vid_stk
* CLASS......: ����� �⥪
* DESC.......: ����窠 � �⪠窠 ����� ���ਡ�⮢
* PREFIX.....: vstk
* EXPORT.....: vstk_push()
*              vstk_pop()
* CONSTRUCTOR:
* DESTRUCTOR.:
* USES.......:
* NOTES......: ����室��� �������஢��� � ���箬 /n, ��᪮���
*              �ᯮ������� external static ��६����.


#include "debug.ch"           && ��� ���ॡ���� ������� ASSERT
                              && �� ����� 2
#define LEN_COL_STR 20        && ��᫮ ᨬ�����, �ᯮ��㥬��
                              && ��� ������� 梥�
#define LEN_VID_STK_ENTRY LEN_COL_STR + 3


* ������쭠� ��६�����, �ᯮ��㥬�� ��� �⥪
STATIC vid_stk := ""          && ��������, �� ���樠������
                              && �ந�室�� ⮫쪮 ���� ࠧ,
                              && ���楯�㠫쭮 �� �६� �������樨


* VOID vstk_push()
*
* ������ ������� � ����� �⥪, �� ��࠭塞 ��⠭���� SET CURSOR,
* ⥪�饥 ��������� ����� � ⥪���� ��⠭���� 梥�

FUNCTION vstk_push

        * ��ꥤ������ ��ਡ�⮢ � ���������� � ��砫� vid_stk
        vid_stk = chr(set(_SET_CURSOR)) + ;
                  chr(row()) + chr(col()) + ;
                  pad(setcolor(), LEN_COL_STR) + ;
                  vid_stk

RETURN NIL


* VOID vstk_pop
*
* �뭨���� ������� �� ����� �⥪�
* � ����⠭�������� ����� ��ਡ���

FUNCTION vstk_pop

        * ���� �஢�ઠ, �⥪ �� ������ ���� ����
        ASSERT(len(vid_stk) > 0,qout("���⮩ �⥪"))

        setcursor(asc(substr(vid_stk, 1, 1)))

        * ��⠭���� ��������� �����, ��⥬ �뢮��
        * ���⮩ ��ப� � �ॡ㥬�� ����樨
        @ asc(substr(vid_stk, 2, 1)), ;
          asc(substr(vid_stk, 3, 1)) SAY ""

        setcolor(substr(vid_stk, 4, LEN_COL_STR))

        * ���४�� �⥪�
        vid_stk = substr(vid_stk, LEN_VID_STK_ENTRY + 1)

RETURN NIL

*        �ணࠬ�� 4-2 ����� � ����� �⥪��.
************************************************************************
STATIC FUNCTION sb_colors

        setcolor("B/R,G/N,,,BG/RB")

RETURN NIL
**********************************************************************
* Colors.prg
*
* ����� 梥⮢

* CHARACTER [] col_split(color_to_split)
*
* CHARACTER color_to_split - ���� ��� ࠧ�����. ����易⥫쭮,
*                            �� 㬮�砭�� ��� ⥪�饣� 梥�.
*
* RETURN - ���ᨢ � ࠧ���묨 梥⠬�
*
* ��������� color_to_split �� ���� 梥⮢ � �����頥� �� �
* ���ᨢ�

#include "commands.ch"             // ��� ��⠭���� 㬮�砭��

FUNCTION col_split(color_to_split)

LOCAL color_num, next_comma, colors[5]

        DEFAULT color_to_split TO setcolor()    // ����� 2
        FOR color_num = 1 TO 4
            next_comma = at(",", color_to_split)
            colors[color_num] = substr(color_to_split, 1, ;
                                next_comma - 1)
            color_to_split = substr(color_to_split, next_comma +1)
        NEXT

        colors[5] = color_to_split

RETURN colors

*        �ணࠬ�� 7-2. ��������� ��ப� 梥⮢

**********************************************************************
*******************************************************************************
* PRG...................: ����
* CLASS.................: ���࠭���� � ����⠭������� ����
* PREFIX................: win
* EXPORT................: win_save
*                         win_rest
* CONSTRUCTOR...........:
* DESTUCTOR.............:
* USES..................:
*
* NOTES.................: �������஢��� � /a /m /n /w


#include "windows.ch"
#include "commands.ch"     // ��� DEFAULT TO

* CHARACTER win_save(t, l, b, r)
*
* NUMERIC t, l, b, r  - ���न���� ����. ����易⥫��.
*                       �� 㬮�砭�� 0, 0, maxrow(), maxcol()
* RETURN              - �������஢���� ���न���� � ����

FUNCTION win_save(t, l, b, r)

        DEFAULT t TO 0, ;
                l TO 0, ;
                b TO maxrow(), ;
                r TO maxcol()

RETURN chr(t) + chr(l) + chr(b) + chr(r) + savescreen(t, l, b, r)
//RETURN chr(t) + chr(l) + chr(b) + chr(r) + packscrn(t, l, b, r)

* VOID win_rest(win_str)
*
* CHARACTER win_str - ���न���� ����, �����饭�� �� win_save
*
* ����⠭�������� ����, ��࠭����� � win_save. �⬥���, �� �� ��
* �㦭� ���न���� ���� - ��� ��࠭��� � ᠬ�� ����

FUNCTION win_rest(win_str)

        restscreen(GET_T(win_str), GET_L(win_str), ;
                   GET_B(win_str), GET_R(win_str), ;
                   GET_WIN(win_str))

//          Upacscrn(GET_T(win_str), GET_L(win_str), ;
//                   GET_B(win_str), GET_R(win_str), ;
//                   GET_WIN(win_str))
RETURN NIL

 *       �ணࠬ�� 7-3. ���࠭���� � ����⠭������� ����

**********************************************************************
**********************************************************************
* Shadows.prg
*
* ����� ⥭�

* VOID sha_attr(t, l, b, r, new_attr)
*
* NUMERIC t, l, b, r   - ���न����
*
* NUMERIC new_attr     - ���祭�� ��� ��⠭���� ��ਡ��
*
* ���㦨����� ����ணࠬ�� �⠥� ��ப� � ��࠭�, ������� ��
* ��ਡ��� �� new_attr, ��⥬ ����ᮢ뢠�� ��

STATIC FUNCTION sha_attr(t, l, b, r, new_attr)

LOCAL old_scr_area, new_scr_area, i

        * ���࠭�� ������� ��࠭� � ��६�����
        old_scr_area = savescreen(t, l, b, r)

        * ���樠�����㥬 ����� ������� ��࠭�
        new_scr_area = ""

        * �����㥬 ����� ᨬ��� �� ��࠭����� ������
        * � ����� ��ப� � �����塞 ��ਡ��
        FOR i = 1 TO len(old_scr_area) STEP 2

            new_scr_area = new_scr_area + substr(old_scr_area, ;
                           i, 1) + chr(new_attr)

        NEXT

        * ����⠭�������� ����� ������� � ⮩ �� ����樨 ��࠭�
        restscreen (t, l, b, r, new_scr_area)

RETURN NIL

  *      �ணࠬ�� 7-4. ��������� ��ਡ�⮢ ��ᢥ⪨

**********************************************************************
**********************************************************************
* Shadows.prg
*
* ����� ⥭�

* ����� �८�ࠧ������ 梥�. �८�ࠧ�� ���� "��।��� ����/䮭"
* � ��ਡ��

#define ATTR_CONV(FORE, BACK) (BACK) * 16 + (FORE)

#define BLACK     0
#define WHITE     7
#define DK_GRAY   8

#define COL_SHADOW_ATTRIBUTE ATTR_CONV(DK_GRAY, BLACK)
#define BW_SHADOW_ATTRIBUTE ATTR_CONV(WHITE, BLACK)

* VOID sha_shadow(t, l, b, r)
*
* NUMERIC t, l, b, r   - ���न���� ����, ����� ���ண� ������
*                        ⥭�, �ᯮ������ ���� ��ப� ���� � ����
*                        �⮫��� �ࠢ� �� ����.
*
* ����� ⥭� ����� ����, ������� ��ਡ��� ᨬ�����. �� �ᯮ��㥬
* ���� �� �୮� (07) ��� �����஬��� �����஢ � ⥬�� ��� �� �୮�
* (08) ��� 梥��� �����஢


FUNCTION sha_shadow(t, l, b, r)




LOCAL shadow_attribute

* ���쪮 �᫨ ���� ����
IF r < maxcol() .AND. b < maxrow()
   shadow_attribute = iif(iscolor(), COL_SHADOW_ATTRIBUTE, ;
                                    BW_SHADOW_ATTRIBUTE)

   sha_attr(b + 1, l + 1, b + 1, r + 1, shadow_attribute)
   sha_attr(t + 1, r + 1, b + 1, r + 1, shadow_attribute)
ENDIF

RETURN NIL

   *     �ணࠬ�� 7-5. ��ᮢ���� ⥭��
