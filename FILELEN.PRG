#include "fileio.ch"

FUNCTION Filelen(maska)
LOCAL filelen:=0, files:={},i,desc,path
maska:=if(maska==NIL,'*.*',maska)
path:=if(rat("\",maska)#0,substr(maska,1,rat("\",maska)),'')
files=directory(maska)
For i=1 to len(files)
	desc:=fopen(path+Files[i,1])
	if desc#-1
		filelen=filelen+Fseek(desc,FS_SET,FS_END)
	endif
	fclose(desc)
Next
asize(files,1)
RETURN filelen