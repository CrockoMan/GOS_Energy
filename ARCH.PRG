/*-----------------------------------------------------------------------------
Archcreate - Функция создания архивного файла OUTPUT
             из массива имен входных файлов FILES
Arcextract - Функция разархивации архивного файла NAMEARCFILE
-----------------------------------------------------------------------------*/
#include "fileio.ch"
#define BUFF_SIZE 512*20
#define INIT_STRING replicate(chr(255),8)
#Define MYCOPYRIGHT chr(13)+chr(10)+center("(c) К.Гурашкин AKA -= Die Hard =- 2:5063/37@FidoNet. Voice in Anapa 5-50-88",79,' ')+chr(13)+chr(10)+chr(13)+chr(10)

#ifdef DEMO
        function demoarch(is_arch,file,mask)
        if pcount()#0
                is_arch:=if(is_arch==NIL,"",lower(alltrim(is_arch)))
                file:=alltrim(if(file==NIL,'compress.crc',file))
                file:=if(at('.',file)=0,file+'.crc',file)
                mask:=alltrim(if(mask==NIL,"*.*",mask))
                filearch:=directory(mask)
                for i=1 to len(filearch)
                        filearch[i]:=filearch[i,1]
                next
                do case
                        case is_arch="a"
                                if len(filearch)#0
                                        qout(MYCOPYRIGHT)
                                        qout("Создание архива "+Upper(file)+chr(13)+chr(10))
                                        archcreate(filearch,file)
                                else
                                        qout('Файл(ы) "'+mask+'" не найдены.')
                                endif
                                qout("")
                        case is_arch="e"
                                qout(MYCOPYRIGHT)
                                archextract(file)
                                qout("")
                        otherwise
                                qout(MYCOPYRIGHT)
                                qqout("Архиватор файлов. Использование: Arch.exe a compress.crc *.* - Архивация")
                                 qout("                                 Arch.exe e compress.crc     - Разархивация")
                endcase
        else
                qout(MYCOPYRIGHT)
                qqout("Архиватор файлов. Использование: Arch.exe a compress.crc *.* - Архивация")
                 qout("                                 Arch.exe e compress.crc     - Разархивация")
        endif
        return
#endif

/*-----------------------------------------------------------------------------
Функция разархивации архивного файла NAMEARCFILE
-----------------------------------------------------------------------------*/
function archextract(namearcfile)
LOCAL desc,buffer:=space(BUFF_SIZE), next_file:="",len_file,lenarcfile
LOCAL newposition:=0,col:=0,NewFileLen:=0
namearcfile:=if(namearcfile==NIL,'compress.crc',alltrim(namearcfile))
if !file(namearcfile)
   al_box({"  Архивный файл не найден"})
   return NIL
endif
desc=fopen(namearcfile)
if desc=-1
   al_box({" Ошибка открытия файла"+namearcfile})
   return NIL
endif
// Определяю длину архивного файла
lenarcfile:=fseek(desc,FS_SET,FS_END);  fseek(desc,FS_SET,FS_SET)
IF freadstr(desc,len(MYCOPYRIGHT))#MYCOPYRIGHT
   al_box({'Файл "'+namearcfile+'" не является архивным'})
ELSE
        //seek_len=len(MYCOPYRIGHT)
        // Пропускаю символы Copyright
        newposition=fseek(desc,len(MYCOPYRIGHT),FS_SET)
        DO WHILE newposition<lenarcfile
           IF Col()!=0
              ? ""
           ELSE
              ?? ""
           ENDIF
        // Выделяю имя архивного файла
                len_fname:=val(freadstr(desc,2))
                next_file:=freadstr(desc,len_fname)
                next_file:=alltrim(next_file)
        // Выделяю его длину
                len_file:=val(freadstr(desc,8))
        // Изменяю положение указателя файла
                newposition=newposition+len_fname+10
        // Выделяю архивный файл из архива во временный файл
                crcfile:=diskname()+":"+dirname()+"\"+tempfile()
                ?? "Создание временного файла  "
                ofile:=fopen(crcfile,FO_READWRITE)
                col:=col(); NewFileLen:=0
                if len_file<=BUFF_SIZE
                        num_read = fread(desc, @buffer, len_file)
                        fwrite(ofile, buffer, len_file)
                else
                        num_read = fread(desc, @buffer, BUFF_SIZE)
                        DO WHILE num_read = BUFF_SIZE
                                fwrite(ofile, buffer, BUFF_SIZE)
                                if len_file-num_read>=BUFF_SIZE
                                        num_read = fread(desc, @buffer, BUFF_SIZE)
                                else
                                        num_read=fread(desc,@buffer,len_file-num_read)
                                endif
                        ENDDO
                        fwrite(ofile, buffer, num_read)
                endif
                @ row(),0 say ""
                fclose(ofile)
        // Разархивирую временный файл в файл с его настоящим именем
                uncompress(crcfile,next_file)
        // Удаляю временный файл
                filedelete(crcfile,63)
        // Перемещаю указатель файла на положение следующего архивного файла
                newposition=fseek(desc,newposition+len_file,FS_SET)
        ENDDO
ENDIF
fclose(desc)
return NIL


/*-----------------------------------------------------------------------------
Функция создания архивного файла OUTPUT из массива имен входных файлов FILES
-----------------------------------------------------------------------------*/
function archcreate(files,output)
if files==NIL
        files=directory("*.*")
        for i=1 to len(files)
                files[i]=files[i,1]
        next
endif
output:=if(output==NIL,'compress.crc',output)
filedelete(output,63)
for i=1 to len(files)
        IF file(files[i])
                IF UPPER(ALLTRIM(files[i]))#UPPER(ALLTRIM(output))
                        crcfile:=tempfile()
                        compress(files[i],crcfile)
                        fcopy(crcfile,output,alltrim(files[i]))
                        filedelete(crcfile,63)
                ENDIF
        ENDIF
next
return NIL


FUNCTION fcopy(source,target,namefil)
LOCAL buffer, ofile, ifile, num_read,inplen
        buffer = space(BUFF_SIZE)
        ifile = FOPEN(source)
        IF ferror() != 0
           ? source, " could not be opened"
        ELSE
                inplen=str(fseek(ifile,0,2),8,0)
                fseek(ifile,0,0)
        ENDIF
        if .not.file(target)
                ofile = FCREATE(target)
                fwrite(ofile, MYCOPYRIGHT+str(len(namefil),2,0)+namefil+inplen)
        else
                ofile = FOPEN(target,FO_READWRITE)
                fseek(ofile,0,2)
                fwrite(ofile,str(len(namefil),2,0)+namefil+inplen)
        endif
        IF ferror() != 0
           ? target, " could not be created"
        ENDIF
        num_read = fread(ifile, @buffer, BUFF_SIZE)
        DO WHILE num_read = BUFF_SIZE
           if fwrite(ofile, buffer, BUFF_SIZE)=BUFF_SIZE
                num_read = fread(ifile, @buffer, BUFF_SIZE)
           else
                exit
           endif
        ENDDO
        fwrite(ofile, buffer, num_read)
        fclose(ifile)
        fclose(ofile)
RETURN NIL
