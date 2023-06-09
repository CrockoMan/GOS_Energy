#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "extend.h"

unsigned char NameNum[256];
unsigned int num[4];

static void num2char(unsigned long);
static void arr2char(unsigned int, unsigned char *, unsigned char);


CLIPPER long2char(void)
//void main()
{
        unsigned long number;
        number=_parnl(1);
//      printf("\n%ld",number);
        num2char(number);
//      printf("\n%s",NameNum);
        _retc(NameNum);
}

/*unsigned int main()
{
        unsigned long number;
        number=4294967295;
        printf("\n");
        num2char(number);
        printf("%s",NameNum);
        return 0;
} */


static void num2char(unsigned long Number)
{
        char tmpstr[40],temp[4];
        unsigned char len=1,i,j,count=0,end;
        unsigned int newnum;
        ultoa(Number,tmpstr,10);
        i=strlen(tmpstr);
        if(i<=3) len=2;
        while(len!=0)
        {
                temp[0]=0;
                if(len!=2)
                {
                        if(i-3>0) end=3;
                        else end=i;
                        for(j=0;j!=end;j++)
                        {
                                if(i-3>0)       temp[j]=tmpstr[i+j-3];
                                else            temp[j]=tmpstr[i+j-1];
                        }
                }
                else
                {
                        end=i;
                        for(j=0;j!=end;j++)
                        {
                                temp[j]=tmpstr[j];
                        }
                }
                temp[end]=0;
                newnum=atoi(temp);
                num[count]=newnum;
//              printf("%d) %d\n",count,num[count]);
                count++;
                if(len==2) len=0;
                else
                {
                        if(i-3>1)
                        {
                                i=i-3;
                                if(i>3) len=1;
                                else    len=2;
                        }
                        else
                        {
                                len=2;
                                switch(i)
                                {
                                        case 4:
                                        case 1: i=1;   break;
                                        case 5:
                                        case 2: i=2;   break;
                                        case 6:
                                        case 3: i=3;   break;
                                        case 0: len=2; break;
                                }
                        }
                }
        }
        NameNum[0]=0;
        i=count;
        do{
          i--;
          arr2char(num[i],tmpstr,i);
          strcat(NameNum,tmpstr);
          itoa(num[i],tmpstr,10);
          if(num[i]>0)                          // �᫨ � ࠧ�拉 ��� ��� �㫥�...
          {
                switch(i)
                {
                        case 1: if(tmpstr[strlen(tmpstr)-2]-48==1) {strcat(NameNum,"����� "); break;}
                                        if(tmpstr[strlen(tmpstr)-1]-48>4 || tmpstr[strlen(tmpstr)-1]-48==0)
                                                  strcat(NameNum,"����� ");
                                        else
                                        {
                                                if(tmpstr[strlen(tmpstr)-1]-48==1) strcat(NameNum,"�����a ");
                                                else  strcat(NameNum,"����� ");
                                        } break;
                        case 2: if(tmpstr[strlen(tmpstr)-2]-48==1) {strcat(NameNum,"��������� "); break;}
                                        if(tmpstr[strlen(tmpstr)-1]-48>4 || tmpstr[strlen(tmpstr)-1]-48==0)
                                                  strcat(NameNum,"��������� ");
                                        else
                                        {
                                                if(tmpstr[strlen(tmpstr)-1]-48==1)  strcat(NameNum,"������� ");
                                                else  strcat(NameNum,"�������a ");
                                        }
                                        break;
                        case 3: if(tmpstr[strlen(tmpstr)-2]-48==1) {strcat(NameNum,"������म� "); break;}
                                        if(tmpstr[strlen(tmpstr)-1]-48>4 || tmpstr[strlen(tmpstr)-1]-48==0)
                                                  strcat(NameNum,"������म� ");
                                        else
                                        {
                                                if(tmpstr[strlen(tmpstr)-1]-48==1)  strcat(NameNum,"������� ");
                                                else  strcat(NameNum,"�������a ");
                                        }
                }
          }
        }while(i!=0);
}



static void arr2char(unsigned int number, unsigned char *str,unsigned char pos)
{
        unsigned char string[25],len;
        unsigned char *StrNum1[]= {"","���� ","��� ","�� ","����� ","���� ",
                                                           "����� ","���� ","��ᥬ� ","������ ","������ "};
        unsigned char *StrNum11[]={"","���� ","��� ","�� ","����� ","���� ",
                                                           "����� ","���� ","��ᥬ� ","������ ","������ "};
        unsigned char *StrNum2[]= {"������ ","���������� ","��������� ",
                                                           "�ਭ����� ","����ୠ���� ","��⭠���� ",
                                                           "���⭠���� ","��������� ","��ᥬ������ ",
                                                           "����⭠���� ","������� "};
        unsigned char *StrNum3[]= {"������ ","������� ","�ਤ��� ","��ப ",
                                                           "���줥��� ","����줥��� ","���줥��� ",
                                                           "��ᥬ줥��� ","���ﭮ�� ","�� "};
        unsigned char *StrNum4[]= {"�� ","����� ","���� ","������� ",
                                                          "������ ","������� ","������ ","��ᥬ��� ",
                                                          "�������� "};
        itoa(number, string, 10);
        len=strlen(string);
        if(len==1)                                                                                      // �������
                if(pos!=1) strcpy(str,StrNum1[number]);
                else       strcpy(str,StrNum11[number]);
        else
        {
                if(len==2)                                                                              //����⪨
                {
                        if(number<21 && number>9)
                                           strcpy(str,StrNum2[number-10]);  // 10-20
                        else
                        {
                                strcpy(str,StrNum3[string[0]-49]);              // 21-100
                                strcat(str,StrNum11[string[1]-48]);
                        }
                }
                else                                                                                    // 100-999
                {
                                strcpy(str,StrNum4[string[0]-49]);
                                number=number%100;
                                if(number<=10 && number>0)
                                {
                                        if(pos!=0) strcat(str,StrNum11[number]);
                                        else       strcat(str,StrNum1[number]);
                                }
                                if(number<21 && number>9)  strcat(str,StrNum2[number-10]);
                                if(number>20)
                                {
                                        strcat(str,StrNum3[string[1]-49]);
                                        if(pos!=0) strcat(str,StrNum11[string[2]-48]);
                                        else       strcat(str,StrNum1[string[2]-48]);
                                }
                }
        }
}
