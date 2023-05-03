
#include <dos.h>
#include "extend.h"

CLIPPER ChkBios()
{
        unsigned int far *addres=MK_FP(0xf000,0);
        unsigned int offset;
        unsigned long sum=0;
        for(offset=0;offset<=0x1f00;offset++)
                sum+=addres[offset];
        _retnl(sum);
}
