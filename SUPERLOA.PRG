/*  Блок кода BEGIN SEQUENCE для открытия баз данных и индексов без вылетов  */
#include "error.ch"

function superload(dbf,index1,index2,is_exclusive)
LOCAL is_load:=.T.,oError
   bSaveHandler := errorblock( { |x| break(x) } )
   is_exclusive:=if(is_exclusive==NIL,.F.,is_exclusive)
        BEGIN SEQUENCE
                do case
                        case dbf#NIL.and.index1#NIL.and.index2#NIL
                             if .not.is_exclusive
//                                al_box({dbf})
                                Use (dbf) Shared
                                if !neterr()
                                   set index to &index1, &index2
                                else
                                   al_box({dbf+" заблокирован"})
                                endif
                             else
                                Use (dbf) index (index1), (index2) EXCLUSIVE
                             endif
                        case dbf#NIL.and.index1#NIL.and.index2=NIL
                             if .not.is_exclusive
                                Use (dbf) Shared
                                if !neterr()
                                   set index to &index1
                                else
                                   al_box({dbf+" заблокирован"})
                                endif
                             else
                                Use (dbf) index (index1) EXCLUSIVE
                             endif
                        case dbf#NIL.and.index1==NIL
                             if .not.is_exclusive
                                Use (dbf) Shared
                                if neterr()
                                   al_box({dbf+" заблокирован"})
                                endif
                             else
                                Use (dbf) EXCLUSIVE
                             endif
                        otherwise
                                is_load:=.F.
                endcase
                RECOVER USING oError
                is_load:=.F.
                do case
                        case oError:genCode == EG_OPEN
                                if al_box({"Ошибка открытия информационного файла",;
                                        alltrim(dbf)},2,{"Повторить","Пропустить"})=2
                                endif
                        case oError:genCode == EG_CORRUPTION
                                al_box({"Обнаружено разрушение информационного файла",;
                                        alltrim(dbf)})
                        otherwise
                                al_box({"Неопределенная ошибка при открытии файла",;
                                        alltrim(dbf),;
                                        "Код ошибки "+alltrim(str(oError:genCode))})
                endcase
        END
errorblock( bSaveHandler )
return is_load
