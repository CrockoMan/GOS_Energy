FUNC SIGN(kr)
LOCAL color_buf,tr
do case
        case kr=1
Myerror(' ���p��樨 � ⠪�� ���箬 � �p���筨�� ���  !!! ',5)
        case kr=2
Myerror(' ���� ��� ��᪠ ?! �p������ ��⨬����� ���  !!!  ',10)
        case kr=3
Myerror(' ���p���� � ⠪�� ���箬 㦥 �������  !!!  ',5)
        case kr=4
Myerror(' ������ �����/�।�� �� �⮬� �।����� ���.������ ����  !!!  ',5)
        case kr=5
Myerror('  ���p������ �����    !!!  ')
        case kr=6
Myerror(' ����� �p娢 ��������� �� ��᪥  !!! ')
        case kr=7
Myerror('  ��� ���� ��� �p娢� �� ��᪥   !!! ')
        case kr=8
Myerror('  ����⪠ ���p㧨�� �p㣮� �p娢  !!! ')
        case kr=9
Myerror(' ��� ����� �� ��᪥ ��� ᮧ����� �p娢�  !!!')
        case kr=10
Myerror(' �����/�।�� � ������� �।����� ������� ! �஢���� ����� !!!',5)
        case kr=13
Myerror(' �������, �����প� ����� ����������, ��-�� ������⢨� 䠩�� �����  ',5)
endcase
RETURN .T.
