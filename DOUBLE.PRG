function double(base)
LOCAL prev:=-1,desc
if base==NIL
   ? "�⨫�� ���᪠ ������� ��楢�� � ���� ������"
   ? "�������� ��楢� �����뢠���� � 䠩� Double.Txt"
   ? "�ᯮ�짮�����: Doubdel ���_����_������"
   quit
endif
use &base
index on lic_schet to i
go top
desc:=fcreate("double.txt")
? "������ ��楢�"
fwrite(desc,"������ ��楢�"+chr(13)+chr(10))
do while !eof()
   if lic_schet=prev
      ? lic_schet
      fwrite(desc,str(lic_schet)+chr(13)+chr(10))
   endif
   prev=lic_schet
   skip
enddo
fclose(desc)
return nil