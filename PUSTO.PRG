function pustograph()
LOCAL select:=select(),recno:=recno(),desc,CrLf:=chr(13)+chr(10),cmonth
LOCAL poisk,save:=win_save()
deletefile(M->Ddir+"otchet.gkv")
select 77                            && ������� � ��楢묨 ��⠬�
go top
seek main->lic_schet
if found()
   month:=month_menu()
   smonth=if(month>1,month-1,12)
   if month#0
      message("���� ������� ���⮣�䪨, ����...")
      desc:=fcreate(M->Ddir+"otchet.gkv")
      fwrite(desc,"���ଠ�� � ���������� ���稪�� "+crlf)
      IF Len(alltrim(main->potrebitel)+"   �/� "+alltrim(str(main->lic_schet)))>78
         fwrite(desc,Substr(alltrim(main->potrebitel)+"   �/� "+alltrim(str(main->lic_schet)),1,78)+crlf)
         fwrite(desc,Substr(alltrim(main->potrebitel)+"   �/� "+alltrim(str(main->lic_schet)),79)+crlf)
      ELSE
         fwrite(desc,alltrim(main->potrebitel)+"   �/� "+alltrim(str(main->lic_schet))+crlf)
      ENDIF
//      fwrite(desc,"�� 15 -oe "+mesqc(month,.T.)+" "+str(year(new_date)+IF(Month==1,1,0),4,0)+"�."+crlf+crlf)
      fwrite(desc,"�� 25 -oe "+mesqc(month,.T.)+" "+str(year(new_date)+IF(Month=1,1,0),4,0)+"�."+crlf+crlf)
      fwrite(desc,"���������������������������������������������������������������������������������Ŀ"+crlf)
      fwrite(desc,"�       N        �           ��`���            ��।. �����. � ���- �����䳐��室 �"+crlf)
      fwrite(desc,"�    ���稪�    �            ���            ������.������.������ �     ����.����"+crlf)
      fwrite(desc,"���������������������������������������������������������������������������������Ĵ"+crlf)
//      do while !eof()
      do while lic_sch==main->lic_schet
         if lic_sch=main->lic_schet
            message(" ���������� ������ �� ���稪�  "+schetchik+" ...")
            fwrite(desc,"�"+schetchik+" �"+Substr(ltrim(Alltrim(object1)+" "+Alltrim(adres))+Space(29),1,29)+"�")
            select(smonth)
            poisk='('+alltrim(str(main->lic_schet))+')'+alltrim(licevoj->schetchik)
            seek poisk
            if substr(alltrim(MYupper(num_of_sch)),1,6)#"������"
               if found().and..not.deleted()
                  fwrite(desc,str(pokazaniq,6,0)+"�      �      �"+if(koeficient>0,str(koeficient),"     ")+"�       �")
               else
                  fwrite(desc,"      �      �      �     �       �")
               endif
            else
                 fwrite(desc,"      �      �      �     �"+str(rashod,7,0)+"�")
            endif
            fwrite(desc,crlf)
            select(77)
         endif
         skip
      enddo
      fwrite(desc,"�����������������������������������������������������������������������������������"+crlf)
      fwrite(desc,crlf+crlf+space(11)+"�㪮����⥫� ______________ (____________)"+crlf)
      fclose(desc)
   endif
else
     al_box({"���稪�� �� ��楢��� ���� N"+alltrim(str(main->lic_schet))+;
             "�� �������"},1)
endif
select(select)
goto recno
win_rest(save)
return NIL