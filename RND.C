
#include <stdlib.h>
#include <time.h>
#include <dos.h>
#include "extend.h"

CLIPPER NextRnd()
{
        unsigned int i,Value;
        if(_parinfo(1)!=2)  Value=100;
        else Value=_parni(1);
        i=rand()%Value;
        _retni(i);
}

CLIPPER InitRnd()
{
        randomize();
        _ret();
}

CLIPPER Pause()
{
        unsigned int TimeDelay;
        if(_parinfo(1)!=2)  TimeDelay=100;
        else TimeDelay=_parni(1);
        delay(TimeDelay);
        _ret();
}
