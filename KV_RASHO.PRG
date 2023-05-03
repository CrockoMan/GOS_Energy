func kvart_rashod
param kvart
private first,last,count,old_sel,old_col,uve
if empty(main->lim_tar1)
        Myerror(' Тариф для расчета по лимитам не введен !!! ')
        return ''
endif
old_sel=select()
old_col=setcolor()
do case
        case kvart=1
                first=1
                last=3
        case kvart=2
                first=4
                last=6
        case kvart=3
                first=7
                last=9
        case kvart=4
                first=10
                last=12
endcase
save screen
obrabot()
count=0
for i=first to last
        select(i)
        count=count+reccount()
next
temp_=40/count
uve=0
set color to w/b
@ 11,21 say 'Всего к обработке '+alltrim(str(count))
@ 11,45 say 'Обработано'
kol_kl=0
go top
sum_rashod=0
for i=first to last
        select(i)
        go top
        do while .not.eof()
                if licevoj=main->lic_schet
                        sum_rashod=sum_rashod+prov_tarif(tarif)
                endif
                kol_kl=kol_kl+temp_
                set color to g+/b
                @ 11,56 say alltrim(str(uve))
                set color to
                @ 12,21 say replicate(" ",kol_kl)
                skip
                uve=uve+1
        enddo
next
@ 12,21 say replicate(' ',40)
sum_rashod=int(sum_rashod)
message_wait("Суммарный расход за "+alltrim(str(kvart))+"-й квартал "+ltrim(str(sum_rashod))+' кВт/ч.')
restore screen
select(old_sel)
setcolor(old_col)
return ''