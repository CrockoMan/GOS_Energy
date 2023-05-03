
#include "extend.h"  

CLIPPER romcheksum()
{
        unsigned long checksum = 0;
        unsigned int offset;
        unsigned char far *ptr;
        ptr = ((unsigned char far *) (0xFE00L << 16));
        for(offset = 0; offset <= 0x1FFF; offset++)
                checksum += *(ptr + offset);
        _retnl(checksum);
}
