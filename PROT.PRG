function protect (i_o_p)
private karet,desc,perem,len,kol_13,pos,stroka,ret_val:=.t.
//loaddir:=diskname()+':'+dirname(diskname())+'\'
fi_le=MYupper(loaddir+'\kos&kos.dbf')
dirchange(substr(loaddir,1,3)); dirchange(loaddir)
//ret_val=.t.
do case
        case i_o_p=1
                desc=fcreate(fi_le)
                fwrite(desc,charnot(charmirr(substr(exename(),len(loaddir)+1))))
                fwrite(desc,charmirr(charnot(str(romcheksum(),8,0))))
                fclose(desc)
        case i_o_p=2
                _open=fopen(fi_le,0); len=fseek(_open,0,2); fseek(_open,0)
                buff=freadstr(_open,len); fclose(_open)
                if len=0
                        ret_val=.f.
                else
                        password=charnot(charmirr(substr(exename(),len(loaddir)+1)))+;
                        charmirr(charnot(str(romcheksum(),8,0)))
                        if buff#password
                                ret_val=.f.
                        endif
                endif
endcase
return ret_val
