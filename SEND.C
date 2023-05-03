
#include "extend.h"


CLIPPER SendByte()
{
	unsigned char Byte,Error;
	unsigned int Port;
	Byte=_parni(1);
	Port=_parni(2);
	asm{
		 mov ah,0
		 mov al,Byte
		 mov dx,Port
		 int 17h
		 mov Error,ah
	   }
	_retni(Error);
}
