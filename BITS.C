
#include "bits.h"
#include "bits.ch"
#include "extend.h"

#include "memory.h"

typedef struct
{
  char *bit_str;
  unsigned int bit_strlen;
  unsigned int bit_cur;
} BIT_DESC;

BIT_DESC bit_desc;

//STATIC BIT_DESC bit_desc;

/***
* CHARACTER bit_set(bit_str, bit_num)
*
* CHARACTER bit_str     - ��⮢�� ��ப� ��� ����������
* NUMERIC bit_num       - �������, ������塞� � ��������
*
* ������� - ����� ��⮢�� ��ப�
*
* ��⠭�������� bit_num � ��⮢�� ��ப� bit_str � �����頥�
* ����� ��⮢�� ��ப�
*/

CLIPPER bit_set()

{
        char *bit_str;
        unsigned bit_num;

        bit_str = _parc(1);
        bit_num = _parni(2);

        if (bit_num < _parclen(1) * BITS_ELEM)
            bit_str[BYTE_NUM(bit_num)] |=
                             1 << BIT_NUM(bit_num);
        _retclen(bit_str, _parclen(1));
}

/***
* CHARACTER bit_reset(bit_str, bit_num)

*
* CHARACTER bit_str     - ��⮢�� ��ப�, �� ���ன 㤠����� ���
* NUMERIC set_element   - ����� ��� ��� 㤠�����
*
* ����뢠�� bit_num � ��⮢�� ��ப� bit_str � �����頥�
* ����� ��⮢�� ��ப�
*/

CLIPPER bit_reset()

{
        char *bit_str;
        unsigned bit_num;

        bit_str = _parc(1);
        bit_num = _parni(2);

        if (bit_num < _parclen(1) * BITS_ELEM)
            bit_str[BYTE_NUM(bit_num)] &=
                             ~(1 << BIT_NUM(bit_num));
        _retclen(bit_str, _parclen(1));
}

/***
* LOGICAL bit_test(bit_str, bit_num)
*
* CHARACTER bit_str     - ��⮢�� ��ப� ��� �஢�ન
* NUMERIC bit_num       - ������� ��� �஢�ન
*
* �������: ��⠭����� �� bit_num � ��ப� bit_str
*/

CLIPPER bit_test()

{
        char *bit_str;
        unsigned bit_num;

        bit_str = _parc(1);
        bit_num = _parni(2);

        if (bit_num < _parclen(1) * BITS_ELEM)
            _retl(bit_str[BYTE_NUM(bit_num)] &
                             1 << BIT_NUM(bit_num));
        else
            _retl(FALSE);
}

/***
* NUMERIC bit_first(bit_str)
*
* CHARACTER bit_str     - ��⮢�� ��ப�
*
* �������: - ���� ������� � bit_str ��� NO_MORE_ELEMS,
*            �᫨ �� ������

*/

CLIPPER bit_first()

{
        char *bit_str;
        unsigned bit_num;
        int cur_bit;

        bit_str = _parc(1);

        bit_desc.bit_str = _xgrab(_parclen(1));
        bit_desc.bit_strlen = _parclen(1) * BITS_ELEM;
        memcpy(bit_desc.bit_str, bit_str, _parclen(1));

        cur_bit = 0;
        while (!(bit_str[BYTE_NUM(cur_bit)] & 1
            << BIT_NUM(cur_bit)) && cur_bit <
            _parclen(1) * BITS_ELEM)
            cur_bit++;

        if (cur_bit != _parclen(1) * BITS_ELEM)
        {
            bit_desc.bit_cur = cur_bit;
        }

                _retni((cur_bit == _parclen(1) * BITS_ELEM)
                ? NO_MORE_ELEMS : cur_bit);
}

/***
* NUMERIC bit_next()
*
* �������: - ������騩 ������� � ��⮢�� ��ப�, ࠭�� ��।����� �
*            bit_first, ��� NO_MORE_ELEMS, �᫨ �� ������
*/

CLIPPER bit_next()

{
        int cur_bit;
        char *bit_str;

        bit_str = bit_desc.bit_str;

        /* ��筥� ���� � ᫥���饣� ������� */
        cur_bit = bit_desc.bit_cur + 1;

        while (!(bit_str[BYTE_NUM(cur_bit)] & 1
                << BIT_NUM(cur_bit)) &&
                cur_bit < bit_desc.bit_strlen)
            cur_bit++;

        if (cur_bit != bit_desc.bit_strlen)
        {
            bit_desc.bit_cur = cur_bit;
        }

                _retni((cur_bit == bit_desc.bit_strlen)
                ? NO_MORE_ELEMS : cur_bit);
}

/***
* VOID bit_end()
*
* ��뢠���� ��᫥ ⮣�, ��� bit_first ��� bit_next �����頥�
* NO_MORE_ELEM, ��� �᢮�������� �����, ����⮩ ������ ��⮢�� ��ப�.
*/

CLIPPER bit_end()

{
        _xfree(bit_desc.bit_str);
}
