function double(base)
LOCAL prev:=-1,desc
if base==NIL
   ? "�⨫�� 㤠����� ������� ��楢�� � ���� ������"
   ? "���� ����⨢訩�� ��楢�� ��࠭����, ��⠫�� 㤠������"
   ? "�ᯮ�짮�����: Doubdel ���_����_������"
   quit
endif
use &base
index on lic_schet to i
go top
? "������ ��楢�"
do while !eof()
   if lic_schet=prev
      ? lic_schet
      delete
*      go top
      prev:=-1
   endif
   prev=lic_schet
   skip
enddo
pack
return nil