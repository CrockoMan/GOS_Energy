STATIC Static80:=-1,Static81:= .T.
#Define LEFT_DELIM  "{"
#Define RIGHT_DELIM "}"

#ifdef TEST
    function one
    use licevoj
    PrintForm("File.txt","out.txt")
    close
    return nil
#endif


function PrintForm(Arg1, Arg2, Arg3)
LOCAL bad_line, end_marker, found_one, i_string, meta_symbol
LOCAL meta_type, next_marker, num_lines, rep_with, this_line, the_memo, desc
LOCAL temp_, kol_kl, m_screen_gkv, _set_marker, is_cursor:=csetcurs()
LOCAL rowstart:=if(maxrow()<25,16,int(maxrow()/2)),Sel:=Select(),Rec:=Recno()

   local Local1:= 1, Local2, Local3, Local4, Local5, Local6, ;
      Local7:= {}, Local8:= {}, Local9, Local10
   Arg3:=IF(Arg3==NIL,.F.,Arg3)
   private prnvar[19]
   Arg1:=Memoread(Arg1)
   prnvar[1]:= 0
   prnvar[2]:= 0
   prnvar[3]:= 1
   prnvar[4]:= 57
   prnvar[5]:= 80
   prnvar[6]:= ""
   prnvar[7]:= Arg3
   prnvar[8]:= 0
   prnvar[9]:= 0
   prnvar[10]:= 0
   prnvar[11]:= 0
   prnvar[12]:= 0
   prnvar[13]:= 0
   prnvar[14]:= 0
   prnvar[15]:= 0
   prnvar[16]:= ""
   prnvar[17]:= 0
   prnvar[18]:= 0
   prnvar[19]:= 1
   if (PCount() == 1)
      Arg2:= DDir+ReportFIle
   elseif (PCount() == 2 .AND. ISLOGICAL(Arg2))
      prnvar[7]:= Arg2
      Arg2:= DDir+ReportFIle
   endif
   if ((prnvar[1]:= fcreate(Arg2)) == -1)
      return .F.
   endif
   if is_cursor
      set cursor off
   endif
   vstk_push()
   m_screen_gkv:=obrabot("Подготовка отчета",rowstart)
   temp_=39/mlcount(Arg1, 90)
   kol_kl=0
   Arg1:= Arg1 + Chr(13) + Chr(10)
   Local2:= atnum(Chr(13) + Chr(10), Arg1, 1, 1)
   do while (Local2 != 0)
      kol_kl=kol_kl+temp_
      colorwin(rowstart+2,21,rowstart+2,21+kol_kl,'gr+/gr+')
      Local3:= SubStr(Arg1, Local1, Local2 - Local1)
//----------------------------------------- Расширение метасимволов в строке
      this_line = Local3
      bad_line = .F.
      found_one = .F.
      next_marker = at(LEFT_DELIM, this_line)
      new_marker = at(chr(91), this_line)
      not_space=.F.
      if new_marker#0
          if next_marker=0
              next_marker=new_marker
              not_space=.T.
          else
              if next_marker<new_marker
                      not_space=.F.
              else
                      next_marker=new_marker
                      not_space=.T.
              endif
          endif
      else
              not_space=.F.
      endif
      DO WHILE next_marker != 0 .AND. !bad_line
         found_one = .T.
         end_marker = at(if(!Not_Space,RIGHT_DELIM,chr(93)), this_line)
         IF end_marker = 0
            bad_line = .T.
         ELSE
            * Взятие метасимвола из разделителей
            meta_symbol = alltrim(substr(this_line, next_marker + 1, ;
                                 end_marker - next_marker - 1))
//            Rep_With=LEFT_DELIM+meta_symbol+RIGHT_DELIM
            Rep_With = ">"+Meta_Symbol+"<"
            Meta_Type=Type(Meta_Symbol)
            DO CASE
               CASE meta_type = "C"    && тип character
                    if at(":=", meta_symbol) = 0
                            rep_with = trim(&meta_symbol)+' '
                    endif
               CASE meta_type = "D"    && тип date
                    if at(":=", meta_symbol) = 0
                            rep_with = dtoc(&meta_symbol)+' '
                    endif
               CASE meta_type = "N"    && тип numeric
                    if at(":=", meta_symbol) = 0
                            rep_with = ltrim(str(&meta_symbol))+' '
                    endif
               CASE meta_type = "B"    && тип Block
                    tmp_rep_with:=eval(&meta_symbol)
                    do case
                       CASE type(tmp_rep_with) = "C"    && тип character
                            rep_with = trim(tmp_rep_with)
                       CASE type(tmp_rep_with) = "D"    && тип date
                            rep_with = dtoc(tmp_rep_with)
                       CASE type(tmp_rep_with) = "N"    && тип numeric
                            rep_with = ltrim(str(tmp_rep_with))
                    endcase
               CASE meta_type = "UE" .or.;
                    meta_type = "UI" .or.;
                    meta_type = "U"   && неопределенный тип
                    bad_line = .T.
               OTHERWISE
            ENDCASE
            IF rep_with == ""
              this_line = substr(this_line, 1, ;
                          next_marker - 1) ;
                          + if(substr(this_line, end_marker + 1)=' ',;
                               substr(this_line, end_marker + 2),;
                               substr(this_line, end_marker + 1))
            ELSE
              rep_with=substr(rep_with, 1, end_marker - ;
                           next_marker - 1+2)
              if !not_space
                      rep_with=alltrim(rep_with)+space(end_marker - ;
                           next_marker - 1 - len(alltrim(rep_with))+2)
              else
                      rep_with=alltrim(rep_with)
              endif
              this_line = substr(this_line, 1, ;
                          next_marker - 1) + rep_with + ;
                          + substr(this_line, end_marker + 1)
            ENDIF
            next_marker = at(LEFT_DELIM, this_line)
            new_marker = at(chr(91), this_line)
            not_space=.F.
            if new_marker#0
                if next_marker=0
                    next_marker=new_marker
                    not_space=.T.
                else
                    if next_marker<new_marker
                            not_space=.F.
                    else
                            next_marker=new_marker
                            not_space=.T.
                    endif
                endif
            else
                    not_space=.F.
            endif
         ENDIF
      ENDDO
      Local3 = This_Line
//------------------------------------Конец расширения метасимволов в строке
      Local4:= token(Local3, " ", 1)
      if (SubStr(Local4, 1, 1) == "!")
         Local4:= MYUpper(Local4)
         do case
         case Local4 == "!PAGETITLE"
            AAdd(Local7, {1})
         case Local4 == "!PAGEDOWN"
            AAdd(Local7, {2})
         case Local4 == "!TABLETITLE"
            AAdd(Local7, {3})
         case Local4 == "!TABLEDOWN"
            AAdd(Local7, {4})
         case Local4 == "!TEXT"
            AAdd(Local7, {5})
         case Local4 == "!BODY"
            AAdd(Local7, {6})
         case Local4 == "!GROUPTITLE"
            AAdd(Local7, {7, token(Local3, " ", 2)})
         case Local4 == "!GROUPDOWN"
            AAdd(Local7, {8})
         case Local4 == "!NEWPAGE"
            AAdd(Local7, {9})
         case Local4 == "!TABLE"
            AAdd(Local7, {10, token(Local3, " ", 2)})
         case Local4 == "!ENDTABLE"
            AAdd(Local7, {11})
         case Local4 == "!WIDTH"
            prnvar[5]:= Val(token(Local3, " ", 2))
         case Local4 == "!HEIGHT"
            prnvar[4]:= Val(token(Local3, " ", 2))
         case Local4 == "!USERFUNC"
            prnvar[6]:= token(Local3, " ", 2)
         case Local4 == "!FIELD"
            do while (.T.)
               Local1:= Local2 + 2
               Local2:= atnum(Chr(13) + Chr(10), Arg1, 1, Local1)
               if (Local2 == 0)
                  exit
               endif
               Local3:= alltrim(SubStr(Arg1, Local1, Local2 - Local1))
               if (SubStr(Local3, 1, 1) == "!")
                  exit
               endif
               if (!Empty(Local3))
                  AAdd(Local8, Local3)
               endif
            enddo
            loop
         endcase
      else
         AAdd(Local7, {""})
         Local6:= Len(Local7)
         Local5:= atnum("_", Local3, 1, 1)
         do while (Local5 != 0)
            Local9:= "_"
            AAdd(Local7[Local6], Local5)
            AAdd(Local7[Local6], "")
            do while (.T.)
               Local3:= posrepl(Local3, " ", Local5)
               Local5++
               Local10:= SubStr(Local3, Local5, 1)
               if (Local10 != "_" .AND. Local10 != "." .AND. Local10 ;
                     != "/")
                  exit
               endif
               Local9:= Local9 + Local10
            enddo
            AAdd(Local7[Local6], Local9)
            Local5:= atnum("_", Local3, 1, 1)
         enddo
         Local7[Local6][1]:= Local3
      endif
      Local1:= Local2 + 2
      Local2:= atnum(Chr(13) + Chr(10), Arg1, 1, Local1)
   enddo
   Local6:= 1
   Local2:= Len(Local7)
   for Local1:= 1 to Local2
      if (ValType(Local7[Local1][1]) != "N")
         prnvar[19]:= 1
         do while (.T.)
            prnvar[19]:= prnvar[19] + 3
            if (Len(Local7[Local1]) < prnvar[19])
               exit
            endif
            Local3:= Local8[Local6++]
            Local7[Local1][prnvar[19] - 1]:= token(Local3, ";", 1)
            if (Empty(token(Local3, ";", 2)))
               if (!("/" $ Local7[Local1][prnvar[19]]))
                  if (Local7[Local1][prnvar[19]] == "__.__.__")
                     Local7[Local1][prnvar[19]]:= "@D"
                  elseif ("." $ Local7[Local1][prnvar[19]])
                     Local7[Local1][prnvar[19]]:= charrepl("_", ;
                        Local7[Local1][prnvar[19]], "9")
                     if (SubStr(Local7[Local1][prnvar[19]], -1, 1) ;
                           == ".")
                        Local7[Local1][prnvar[19]]:= ;
                           posdel(Local7[Local1][prnvar[19]], 1)
                     endif
                  else
                     Local7[Local1][prnvar[19]]:= "@S" + ;
                        LTrim(Str(Len(Local7[Local1][prnvar[19]]), ;
                        2, 0))
                  endif
               else
                  Local7[Local1][prnvar[19]]:= ""
               endif
            else
               Local7[Local1][prnvar[19]]:= token(Local3, ";", 2)
            endif
         enddo
      endif
   next
   Local8:= {}
   prnvar[19]:= 1
   AAdd(Local7, {0})
   do while (ValType(Local7[prnvar[19]][1]) != "N")
      prnvar[19]++
   enddo
   workform(.F., Local7, "")
   fclose(prnvar[1])
   if is_cursor
      set cursor off
   endif
   Select(Sel); Go Rec
   Vstk_pop()
   Win_Rest(m_screen_gkv)
return .T.


Function IsLogical(Var)
LOCAL IsLogical:=.F.
IF Type(Var)=="L"
   IsLogical:=.T.
ENDIF
Return IsLogical


function WORKFORM(Arg1, Arg2, Arg3)

   local Local1
   do while (.T.)
      prnvar[18]:= Arg2[prnvar[19]][1]
      do case
      case Arg2[prnvar[19]][1] == 1
         prnvar[9]:= ++prnvar[19]
         do while (ValType(Arg2[prnvar[19]][1]) != "N")
            prnvar[19]++
         enddo
         prnvar[11]:= prnvar[19] - prnvar[9]
         loop
      case Arg2[prnvar[19]][1] == 2
         prnvar[8]:= ++prnvar[19]
         do while (ValType(Arg2[prnvar[19]][1]) != "N")
            prnvar[19]++
         enddo
         prnvar[10]:= prnvar[19] - prnvar[8]
         loop
      case Arg2[prnvar[19]][1] == 5 .OR. Arg2[prnvar[19]][1] == 11
         prnvar[19]++
         if (ValType(Arg2[prnvar[19]][1]) != "N" .AND. ;
               writeblock(Arg2, .F., prnvar[19]) == .F.)
            return Nil
         endif
      case Arg2[prnvar[19]][1] == 6
         prnvar[19]++
         if (ValType(Arg2[prnvar[19]][1]) != "N")
            do while (.T.)
               if (Empty(prnvar[6]))
                  if (deff_userf() == .F.)
                     exit
                  endif
               else
                  Local1:= prnvar[6]
                  if (&Local1 == .F.)
                     exit
                  endif
               endif
               writeblock(Arg2, .F., prnvar[19])
            enddo
         endif
         prnvar[15]:= 0
         prnvar[14]:= 0
         prnvar[17]:= 0
      case Arg2[prnvar[19]][1] == 9
         do while (.T.)
            if (prnvar[2] + prnvar[10] + prnvar[14] >= prnvar[4])
               if (prnvar[14] != 0)
                  writeblock(Arg2, .T., prnvar[12])
               endif
               if (prnvar[10] != 0)
                  writeblock(Arg2, .T., prnvar[8])
               endif
               writestr("")
               prnvar[2]:= 0
               exit
            endif
            writestr("")
         enddo
      case Arg2[prnvar[19]][1] == 10
         if (Len(Arg2[prnvar[19]]) > 1)
            prnvar[16]:= Arg2[prnvar[19]][2]
         endif
         Local1:= prnvar[19]
         prnvar[19]++
         if (ValType(Arg2[prnvar[19]][1]) != "N")
            writeblock(Arg2, .F., prnvar[19])
         endif
         prnvar[19]:= Local1
         do while (Arg2[prnvar[19]][1] != 0 .AND. ;
               Arg2[prnvar[19]][1] != 11)
            prnvar[19]++
            if (Arg2[prnvar[19] - 1][1] == 3)
               prnvar[13]:= prnvar[19]
               do while (ValType(Arg2[prnvar[19]][1]) != "N")
                  prnvar[19]++
               enddo
               prnvar[15]:= prnvar[19] - prnvar[13]
            elseif (Arg2[prnvar[19] - 1][1] == 4)
               prnvar[12]:= prnvar[19]
               do while (ValType(Arg2[prnvar[19]][1]) != "N")
                  prnvar[19]++
               enddo
               prnvar[14]:= prnvar[19] - prnvar[12]
            elseif (Arg2[prnvar[19] - 1][1] == 6)
               prnvar[17]:= prnvar[19]
               do while (ValType(Arg2[prnvar[19]][1]) != "N")
                  prnvar[19]++
               enddo
               prnvar[17]:= prnvar[19] - prnvar[17]
            else
               do while (ValType(Arg2[prnvar[19]][1]) != "N")
                  prnvar[19]++
               enddo
            endif
         enddo
         prnvar[19]:= Local1
      case Arg2[prnvar[19]][1] == 0
         return Nil
      endcase
      prnvar[19]++
      do while (ValType(Arg2[prnvar[19]][1]) != "N")
         prnvar[19]++
      enddo
   enddo
   return .T.

********************************
static function WRITEBLOCK(Arg1, Arg2, Arg3)

   local Local1, Local2, Local3
   if (!Arg2 .AND. prnvar[17] != 0 .AND. prnvar[2] + prnvar[10] + ;
         prnvar[14] + prnvar[17] >= prnvar[4])
      if (prnvar[14] != 0)
         writeblock(Arg1, .T., prnvar[12])
      endif
      Local3:= prnvar[4] - prnvar[2] - prnvar[10]
      do while (Local3 != 0)
         writestr("")
         Local3--
      enddo
      if (prnvar[10] != 0)
         writeblock(Arg1, .T., prnvar[8])
      endif
      writestr("")
      prnvar[2]:= 0
   endif
   if (!Arg2 .AND. prnvar[2] == 0)
      if (prnvar[11] != 0)
         writeblock(Arg1, .T., prnvar[9])
      endif
      if (prnvar[15] != 0)
         writeblock(Arg1, .T., prnvar[13])
      endif
   endif
   do while (ValType(Arg1[Arg3][1]) != "N")
      Local2:= 2
      Local1:= Arg1[Arg3][1]
      do while (Local2 <= Len(Arg1[Arg3]))
         Local1:= posrepl(Local1, ;
            Transform(&(Arg1[Arg3][Local2 + 1]), ;
            Arg1[Arg3][Local2 + 2]), Arg1[Arg3][Local2])
         Local2:= Local2 + 3
      enddo
      if (!Arg2 .AND. prnvar[2] + prnvar[10] + prnvar[14] >= ;
            prnvar[4])
         if (prnvar[14] != 0)
            writeblock(Arg1, .T., prnvar[12])
         endif
         if (prnvar[10] != 0)
            writeblock(Arg1, .T., prnvar[8])
         endif
         writestr("")
         prnvar[2]:= 0
      endif
      if (!Arg2 .AND. prnvar[2] == 0)
         if (prnvar[11] != 0)
            writeblock(Arg1, .T., prnvar[9])
         endif
         if (prnvar[15] != 0)
            writeblock(Arg1, .T., prnvar[13])
         endif
      endif
      writestr(Local1)
      Arg3++
   enddo
   return .T.

static function WRITESTR(Arg1)
LOCAL Meta_Symbol:="",Meta_Type:=""
   if (Arg1 == "")
      prnvar[2]:= 0
      prnvar[3]++
   endif
   prnvar[2]++
   if (SubStr(Arg1, 1, 1) == "@")
      Arg1:= center(alltrim(posdel(Arg1, 1, 1)), prnvar[5])
   endif
   if (prnvar[7])
      dispbegin()
      if (++Static80 > MaxRow())
         Static80:= MaxRow()
         Scroll(0, 0, MaxRow(), MaxCol(), 1)
      endif
      @ Static80,  0 say Arg1
      dispend()
   endif
   IF (SubStr(Arg1, 1, 1) != "#")
      IF (Fwrite(Prnvar[1], Arg1 + Chr(13) + Chr(10)) != Len(Arg1) + 2)
         Return .F.
      ENDIF
   ENDIF
   return .T.

static function DEFF_USERF
   if (Static81)
      Static81:= .F.
   else
//      skip
   endif
   if (EOF())
      Static81:= .T.
   endif
return !EOF()                                                                                                               l be the pre-compiled header
//  stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"
                                                                                                                                                                                                                                                              
                                                                                                                                              while (first1 != last1 && first2 != last2)
    {
        if (*first1 < *first2)
            *result++ = *first1++;
        else if (*first2 < *first1)
            *result++ = *first2++;
        else
        {
            ++first1;
            ++first2;
        }
    }
    return copy(first2, last2, copy(first1, last1, result));
}

template <class InputIterator1, class InputIterator2, class OutputIterator,
          class Compare>
OutputIterator set_symmetric_difference (InputIterator1 first1,
                                         InputIterator1 last1,
                                         InputIterator2 first2,
                                         InputIterator2 last2,
                                         OutputIterator result, Compare comp)
{
    while (first1 != last1 && first2 != last2)
    {
        if (comp(*first1, *first2))
            *result++ = *first1++;
        else if (comp(*first2, *first1))
            *result++ = *first2++;
        else
        {
            ++first1;
            ++first2;
        }
    }
    return copy(first2, last2, copy(first1, last1, result));
}

//
// Heap operations.
//

template <class RandomAccessIterator, class Distance, class T>
void __push_heap (RandomAccessIterator first, Distance holeIndex,
                  Distance topIndex, T value)
{
    Distance parent = (holeIndex - 1) / 2;
    while (holeIndex > topIndex && *(first + parent) < value)
    {
        *(first + holeIndex) = *(first + parent);
        holeIndex = parent;
        parent = (holeIndex - 1) / 2;
    }
    *(first + holeIndex) = value;
}

template <class RandomAccessIterator, class Distance, class T>
inline void __push_heap_aux (RandomAccessIterator first,
                             RandomAccessIterator last, Distance*, T*)
{
    __push_heap(first, Distance((last-first)-1), Distance(0), T(*(last-1)));
}

template <class RandomAccessIterator>
inline void push_heap (RandomAccessIterator first, RandomAccessIterator last)
{
   if (!(first == last))
       __push_heap_aux(first, last, distance_type(first),
                       RWSTD_VALUE_TYPE(first));
}

template <class RandomAccessIterator, class Distance, class T, class Compare>
void __push_heap (RandomAccessIterator first, Distance holeIndex,
                  Distance topIndex, T value, Compare comp)
{
    Distance parent = (holeIndex - 1) / 2;
    while (holeIndex > topIndex && comp(*(first + parent), value))
    {
        *(first + holeIndex) = *(first + parent);
        holeIndex = parent;
        parent = (holeIndex - 1) / 2;
    }
    *(first + holeIndex) = value;
}

template <class RandomAccessIterator, class Compare,  class Distance, class T>
inline void __push_heap_aux (RandomAccessIterator first,
                             RandomAccessIterator last, Compare comp,
                 Distance*, T*)
{
    __push_heap(first, Distance((last-first)-1), Distance(0),
        T(*(last - 1)), comp);
}

template <class RandomAccessIterator, class Co