function makelimit
local month,select:=select(),recno:=recno(),poisk,ras_hod:=0,sum:=0,lim_m
local dop_path:="c:\1996\database\",dop_load,desc,crlf:=chr(13)+chr(10)
local with_debet:=.F.,tes_kvt:="тыс.квт/ч",tmp_rashod,type_limit,counter:=0
local cycle:=1,stepper:=1
private LIM_STR1,lim_str2,lim_str3,firm,kvartal:="I"
month:=month_menu()
if month=0
   RETURN NIL
endif
// Для базы лимитов и месяца в счетчиках
if (!file(path_copy+"limit!.dbf"))
   copy_(path_copy+"limit.dbf",path_copy+"limit!.dbf")
endif
do case
   case month=1
        lim_m:="JAN"
   case month=2
        lim_m:="FEB"
   case month=3
        lim_m:="MAC"
   case month=4
        lim_m:="APR"
   case month=5
        lim_m:="MAY"
   case month=6
        lim_m:="JUN"
   case month=7
        lim_m:="JUL"
   case month=8
        lim_m:="AUG"
   case month=9
        lim_m:="SEP"
   case month=10
        lim_m:="OCT"
   case month=11
        lim_m:="NOV"
   case month=12
        lim_m:="DEC"
endcase
//-----------------------------------------------------------------
desc:=fcreate(dir+"otchet~.gkv")
fwrite(desc,"Бланк расчета лимита"+crlf)
fwrite(desc,"Счетчики вошедшие в лимит:"+crlf)
fwrite(desc,replicate("ў",40)+crlf)
fwrite(desc,'B основной базе '+crlf)
//-----------------------------------------------------------------
if month=1.or.month=4.or.month=7.or.month=10
   cycle=3
endif
if month>0
 for stepper=1 to cycle
   month=month+stepper-1        // Для движения по кварталу Jan,Feb,Mac...
   select 77
   seek main->lic_schet
   if found()
      do while(main->lic_schet=lic_sch)
         select &month
         poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
         seek poisk
         if found()
            IF ISNONDS(tarif)  && Этот тариф без НДС (жилье)?
               if summa>0.and.drug_nach=.f.
                  IF ISONLIMIT(kod)  && Этот счетчик в лимит?
                    IF IS_ON_HIGH(tarif) && Тариф в лимит?
                       ras_hod=ras_hod+if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0, if(rashod-subab>0,rashod-subab,subab-rashod) ,0)
                       counter++
//-----------------------------------------------------------------
fwrite(desc,licevoj->schetchik+"  Расход "+str(if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0, if(rashod-subab>0,rashod-subab,subab-rashod) ,0))+crlf)
//-----------------------------------------------------------------
                    ENDIF
                  ENDIF
               endif
            ENDIF
         endif
         select 77
         skip
      enddo
// Для загрузки архива 1996 года январь-март
 do case
   case kniga='/13'
        dop_path:=dop_path+"#1#2#3\"
   case kniga='/14'
        dop_path:=dop_path+"#4#5\"
   case kniga='/15'
        dop_path:=dop_path+"#6#7#8\"
   case kniga='/16'
        dop_path:=dop_path+"#9#10#11\"
   case kniga='/17'
        dop_path:=dop_path+"#12\"
 endcase
   dop_load=dop_path+"main.dbf"
//al_box({"Расход по текущей базе "+alltrim(str(ras_hod))+" кBт"})
   select 111
   use &dop_load alias dop_main SHARED
   select 112

   dop_load=dop_path+if(month#3,lim_m,"MAR")+".dbf"
   use &dop_load alias dop_schet SHARED
   select 111
   go top
   do while !eof()
      if val(dogowor)#main->lic_schet
         skip
      else
           select dop_schet
           go top
//-----------------------------------------------------------------
fwrite(desc,'B дополнительной базе '+crlf)
//-----------------------------------------------------------------
           do while(.not.eof())
             if(dop_main->lic_schet=licevoj)
              IF ISNONDS(tarif)  && Этот тариф без НДС (жилье)?
                 if summa>0.and.drug_nach=.f.
                    IF ISONLIMIT(kod)  && Этот счетчик в лимит?
                       IF IS_ON_HIGH(tarif) && Тариф в лимит?
//-----------------------------------------------------------------
fwrite(desc,kod+" расход "+str(if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0, if(rashod-subab>0,rashod-subab,subab-rashod) ,0))+crlf)
//-----------------------------------------------------------------
                          ras_hod=ras_hod+if( if(rashod-subab>0,rashod-subab,subab-rashod) *tarif>0, if(rashod-subab>0,rashod-subab,subab-rashod) ,0)
                          counter++
                       ENDIF
                    ENDIF
                 endif
              ENDIF
             endif
             skip
           enddo
           exit
      endif
   enddo
   select 111
   use
   select 112
   use
   else
        al_box({"Данные по потребителю не найдены"})
   endif
 next
endif
 ras_hod=ras_hod/1000    // Для определения лимита делим расход на 1000
 // В формулу расчета лимитов добавляю задолженность октября
 select 88
 //-----------------------------------------------------------------
 fwrite(desc,replicate("ў",40)+crlf)
 fwrite(desc,"Итого "+str(ras_hod)+crlf)
 //-----------------------------------------------------------------
 tmp_rashod=ras_hod
 if lim_tar1#0  // Только для не бюджетных организаций
    select 15 && Оборотка
    if(debet10>0)
 //-----------------------------------------------------------------
 fwrite(desc,"Дебиторская "+str(debet10)+crlf)
 //-----------------------------------------------------------------
      sum=(debet10/schet_1new)/1000
      sum=sum/3   && долг октября делю на 3 части
 //-----------------------------------------------------------------
 fwrite(desc,"Расчетная величина: "+alltrim(str(debet10))+"/"+;
             alltrim(str(schet_1new))+"/1000/3="+alltrim(str(sum))+crlf)
 //-----------------------------------------------------------------
      with_debet:=.T.
    endif
 //-----------------------------------------------------------------
 fwrite(desc,"Вычитаю "+alltrim(str(sum))+"-"+;
            alltrim(str(ras_hod))+"="+alltrim(str(sum-ras_hod))+crlf)
 //-----------------------------------------------------------------
    ras_hod=sum-ras_hod
 endif
 // Конец добавления задолженности октября
 ras_hod=round(ras_hod,1)                        &&Округляю до первого знака
 //-----------------------------------------------------------------
 fwrite(desc,"Полученный лимит "+str(ras_hod)+crlf)
 //-----------------------------------------------------------------
 // Проверка наличия поля для данного потребителя
 select 33
 seek main->lic_schet
 if !found()
    append blank
    replace lic_schet with main->lic_schet
 else
    select 0
    dop_load=path_copy+"limit!.dbf"
    use &dop_load alias LIMIT2 SHARED
    locate for lic_schet=main->lic_schet
 //-----------------------------------------------------------------
    fwrite(desc,"Лимит прошлого года "+str(&lim_m)+crlf)
 //-----------------------------------------------------------------
    use
    select 33
 endif
 if( (tmp_rashod*70/100)>ras_hod)
     type_limit:=al_box({"Вырaвнять лимит по нижней границе не менее"},3,;
                         {" 70% "," 30% "," Оставить "})
     do case
        case type_limit=1
             ras_hod=tmp_rashod*70/100
 //-----------------------------------------------------------------
 fwrite(desc,"Лимит вырaвнен по границе 70% "+str(ras_hod)+crlf)
 //-----------------------------------------------------------------
        case type_limit=2
             ras_hod=tmp_rashod*30/100
 //-----------------------------------------------------------------
 fwrite(desc,"Лимит вырaвнен по границе 30% "+str(ras_hod)+crlf)
 //-----------------------------------------------------------------
     endcase
 endif
 // запись полученного результата в базу LIMIT
 //al_box({"Лимит "+str(ras_hod)})
 //-----------------------------------------------------------------
fclose(desc)
//-----------------------------------------------------------------
if counter=0
  al_box({'Рассчитанный лимит "0"  не записан',;
          'Предполагается ошибочный результат',;
          "Произведите ввод лимита вручную"})
   select(select)
   go recno
   return NIL
endif
if (ras_hod#0)
  replace &lim_m with ras_hod
  if al_box({"Лимт "+alltrim(str(ras_hod)),;
           "Сформировать бланк лимитов"},2,{" Нет "," Да "})=2
 // Для вычисления квартала
   do case
      case month>=1.and.month<=3
           kvartal="I"
           LIM_STR1:="ЯНВАРЬ     "+str(limit->jan,7,2)
           LIM_STR2:="ФЕВРАЛЬ    "+str(limit->feb,7,2)
           LIM_STR3:="МАРТ       "+str(limit->mac,7,2)
      case month>=4.and.month<=6
           kvartal="II"
           LIM_STR1:="АПРЕЛЬ     "+str(limit->apr,7,2)
           LIM_STR2:="МАЙ        "+str(limit->may,7,2)
           LIM_STR3:="ИЮНЬ       "+str(limit->jun,7,2)
      case month>=7.and.month<=9
           kvartal="III"
           LIM_STR1:="ИЮЛЬ       "+str(limit->jul,7,2)
           LIM_STR2:="АВГУСТ     "+str(limit->aug,7,2)
           LIM_STR3:="СЕНТЯБРЬ   "+str(limit->sep,7,2)
      case month>=10.and.month<=12
           kvartal="IV"
           LIM_STR1:="ОКТЯБРЬ    "+str(limit->oct,7,2)
           LIM_STR2:="НОЯБРЬ     "+str(limit->nov,7,2)
           LIM_STR3:="ДЕКАБРЬ    "+str(limit->dec,7,2)
   endcase
   firm:=delstring(main->potrebitel,"ИНН")
   if with_debet
      report(dir+"limit1.rpt",dir+'otchet.gkv',80)
   else
      report(dir+"limit2.rpt",dir+'otchet.gkv',80)
   endif
  endif
else
  al_box({'Рассчитанный лимит "0"  не записан',;
          'Предполагается ошибочный результат',;
          "Произведите ввод лимита вручную"})
endif
select(select)
go recno
return NIL
