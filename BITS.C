
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
* CHARACTER bit_str     - Битовая строка для добавления
* NUMERIC bit_num       - Элемент, добавляемый к множеству
*
* ВОЗВРАТ - Новая битовая строка
*
* Устанавливает bit_num в битовой строке bit_str и возвращает
* новую битовую строку
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
* CHARACTER bit_str     - Битовая строка, из которой удаляется бит
* NUMERIC set_element   - Номер бита для удаления
*
* Сбрасывает bit_num в битовой строке bit_str и возвращает
* новую битовую строку
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
* CHARACTER bit_str     - Битовая строка для проверки
* NUMERIC bit_num       - Элемент для проверки
*
* ВОЗВРАТ: Установлен ли bit_num в строке bit_str
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
* CHARACTER bit_str     - Битовая строка
*
* ВОЗВРАТ: - Первый элемент в bit_str или NO_MORE_ELEMS,
*            если не найден

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
* ВОЗВРАТ: - Следующий элемент в битовой строке, ранее переданной в
*            bit_first, или NO_MORE_ELEMS, если не найден
*/

CLIPPER bit_next()

{
        int cur_bit;
        char *bit_str;

        bit_str = bit_desc.bit_str;

        /* Начнем поиск со следующего элемента */
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
* Вызывается после того, как bit_first или bit_next возвращает
* NO_MORE_ELEM, для освобождения памяти, занятой копией битовой строки.
*/

CLIPPER bit_end()

{
        _xfree(bit_desc.bit_str);
}
