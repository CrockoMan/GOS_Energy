/*
procedure CRCTEST
COMPRESS( 'compr.exe',"compr.cpr" )                && Compress TEST file
unCOMPRESS( 'compr.exe',"compr.cpr" )                && Compress TEST file
UNCOMPRESS( 'compr.CPr', 'compr.EXT' )             && Extract TEST file
COMPRESS( 'compr.exe',"compr.cpr" )                && Compress TEST file
unCOMPRESS( 'compr.cpr',"compr.ext" )                && Compress TEST file
return
*/

FUNCTION COMPRESS(infile,outfile)
LOCAL    Ret_Mess:=.T.
PRIVATE  IS_COMPRESS:=.T.,inhandle,outhandle,FileLen:=0,FilePos:=0
   inhandle=fopen(infile,0)                  && Open file
   FileLen:=Fseek(InHandle,0,2)
   Fseek(InHandle,0)
   if ( inhandle == -1 )                         && Error opening file ??
        al_box({"Ошибка открытия "+infile})
        Ret_Mess:=.F.
   else
        outhandle = fcreate( outfile )             && Create file
        ? "Архивация "+alltrim(upper(token(infile,'\')))+" "+;
           space(15-len(alltrim(upper(token(infile,'\')))))
   &&   Вызов функции 'C' с размером словаря и типом компрессии
   &&   Используется словарь 4K и ASCII компрессия.
        pk_implode(4096 , 1)
        ?? " Ok."
        fclose( inhandle )                            && Close files
        fclose( outhandle )
   endif
return Ret_Mess

FUNCTION UNCOMPRESS(infile, outfile)
LOCAL    Ret_Mess:=.T.
PRIVATE  IS_COMPRESS:=.F.,inhandle,outhandle,WorkStep:=0,FileLen:=0,FilePos:=0
   inhandle = fopen( infile, 0 )                 && Open file
   FileLen:=Fseek(InHandle,0,2)
   Fseek(InHandle,0)
   if ( inhandle == -1 )
        al_box({"Ошибка открытия "+infile})
        Ret_Mess:=.F.
   else
        outhandle = fcreate( outfile )                && Create file
        ?? "Разархивация "+alltrim(upper(token(outfile,"\")))+" "+;
        space(15-len(alltrim(upper(token(outfile,"\")))))
        pk_explode()
        ?? if(WorkStep#0," Ok.",' Файл не является архивным.')
        fclose( inhandle )                            && Close files
        fclose( outhandle )
   endif
return Ret_Mess


FUNCTION R_DATA
private buff, bytesread, size,row:=row(),col:=col()
FilePos:=if((FilePos+4096)<=FileLen,FilePos+4096,FileLen)
@ row,col say if(is_compress,str(round(FilePos*100/FileLen,0),3,0)+"%   ","")
@ row,col say ""
size = pk_getsize()                           && Количество байтов для чтения
buff = space( size )                          && Получение временного буфера
bytesread = fread( inhandle, @buff, size )    && чтение данных из файла
pk_setbuf( @buff, bytesread )                 && копирование содержимого буфера
return bytesread

FUNCTION W_DATA
Local GetBuf:="",GetSize:=0,row:=row(),col:=col()
GetBuf:=pk_getbuf(); GetSize:=pk_getsize()
fwrite( outhandle, GetBuf, GetSize) && Запись на диск
FilePos:=if((FilePos+GetSize)>=FileLen,FileLen,FilePos+4096)
@ row, col say if(.not.is_compress,str(round(FilePos*100/FileLen,0),3,0)+"%","")
@ row, col say ""
WorkStep:=if(.not.is_compress,WorkStep+1,0)
return .t.
