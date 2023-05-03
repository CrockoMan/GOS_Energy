STATIC first_time:=.T., save_curs, NULLC, save_screen, color, rowstart
STATIC valperstep:=0, pospaint:=0
#include "fileio.ch"
#include "setcurs.ch"
#define NTX_EXPR_SIZE 256
#define NTX_KEY_START 22

FUNCTION Indexing(fieldname,filename,database)
Local aSizeDesktop,oProgress,oDlg,aPos
private Myfield:=fieldname,file:=filename,dbffile:=database
IF fieldname#NIL.and.filename#NIL
        do case
                case valtype(&Myfield)='C'
                        NULLC:=""
                        IF Upper(AllTrim(Prot))=="NODISP"
                           index on &Myfield to (filename)
                        ELSE
      											oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
      											aSizeDesktop    := oMainWindow:currentSize()
      											oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
      											oDlg:title    := "Обработано" 
   													oDlg:SysMenu	 := .F.
   													oDlg:Configure()
      											oDlg:Show()
      											aSizeDesktop    := oDlg:currentSize()
      											aPos						:= oDlg:CurrentPos()
  													oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
   												 oProgress:create()
   												 oProgress:minimum := 1
   												 oProgress:maximum := RecCount()
   												 	
                           DbCreateIndex(FileName,Myfield,{|| oProgress:increment(),&MyField})
   												 oProgress:destroy()																							// Progress Bar Destroy
   												 oDlg:Destroy()
                        ENDIF
                        close indexes
                case valtype(&Myfield)='D'
                        index on &Myfield to (filename)
                        close indexes
                case valtype(&Myfield)='L'
                        index on &Myfield to (filename)
                        close indexes
                case valtype(&Myfield)='N'
                        NULLC:=0
                        IF Upper(AllTrim(Prot))=="NODISP"
                           index on &Myfield to (filename)
                        ELSE
      											oDlg          := XbpDialog():new(AppDesktop(),SetAppWindow(),,,,.F.)
      											aSizeDesktop    := oMainWindow:currentSize()
      											oDlg:create(oMainWindow ,, {100,50}, {aSizeDeskTop[1]-200,90} ) 
      											oDlg:title    := "Обработано" 
   													oDlg:SysMenu	 := .F.
   													oDlg:Configure()
      											oDlg:Show()
      											aSizeDesktop    := oDlg:currentSize()
      											aPos						:= oDlg:CurrentPos()
  													oProgress := ProgressBar():new(oDlg ,, {5,10}, {aSizeDeskTop[1]-18,30},, .F. )	// Progress Bar Create
  														
   												 oProgress:create()
   												 oProgress:minimum := 1
   												 oProgress:maximum := RecCount()
                           DbCreateIndex(FileName,Myfield,{|| oProgress:increment(),&MyField})
   												 oProgress:destroy()																							// Progress Bar Destroy
   												 oDlg:Destroy()

                        ENDIF
                        close indexes
        endcase
ENDIF
RETURN NIL


FUNCTION ip_start
         rowstart:=if(maxrow()<25,16,int(maxrow()/2))
         save_curs = set(_SET_CURSOR, SC_NONE)
         save_screen:=win_save(rowstart,12,rowstart+6,maxcol())
         color:=setcolor()
         first_time = .T.
//         @ 10, 10 SAY "Indexing     % complete"
         obrabot('Сортировка файла "'+MYupper(substr(dbffile,rat("\",dbffile)+1))+'"', rowstart)
         valperstep=39/reccount()
         pospaint=0
RETURN NIL


FUNCTION ip_disp()
//Do Case
//   Case Type=="C"
//        Nal:=""
//   Case Type=="N"
//        Nal:=0
//EndCase
         IF first_time
            first_time = .F.
         ELSE
//            @ 10, 19 SAY str(recno() / reccount() * 100, 4)
//            inkey(0)
                pospaint=pospaint+valperstep
                IF Int(PosPaint)==Round(PosPaint,1)
                   colorwin(rowstart+2,21,rowstart+2,21+pospaint,'gr+/gr+')
                ENDIF
         ENDIF
RETURN NULLC


FUNCTION ip_end(f_name)
LOCAL buff, ntx_expr, ntx_handle, where_at
         set(_SET_CURSOR, save_curs)
         ntx_expr = space(NTX_EXPR_SIZE)
//         ntx_handle = fopen(path_copy+f_name, FO_READWRITE)
         ntx_handle = fopen(f_name, FO_READWRITE)
         if ntx_handle=-1
            al_box({"Ошибка открытия файла "+path_copy+f_name})
         endif
         * Ищем начало индексного выражения...
         fseek(ntx_handle, NTX_KEY_START, FS_SET)
         fread(ntx_handle, @ntx_expr, NTX_EXPR_SIZE)
         * Удаляем заключительные пробелы
         ntx_expr = trim(ntx_expr)
         * Ищем + ip_disp()
         where_at = at("+ip_disp()", ntx_expr)
         * Записываем его обратно без + ip_disp(), заменяя его
         * на chr(0) для терминирования выражения...
         * Ищем начало индексного выражения
         fseek(ntx_handle, NTX_KEY_START, FS_SET)
         fwrite(ntx_handle, pad(substr(ntx_expr, 1, where_at - 1) +;
                                chr(0), NTX_EXPR_SIZE))
         fclose(ntx_handle)
         win_rest(save_screen)
         setcolor(color)
RETURN NIL
