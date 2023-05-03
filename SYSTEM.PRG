#include "nt2sys.ch"

FUNCTION CardName()
Local CardName
do case
	CASE ISVGA()
	   CardName ="VGA"
	CASE ISEGA()
	   CardName ="EGA " +NTOC(64 *MAXFONT()) +" KB"
	CASE ISMCGA()
	   CardName ="MCGA"
	CASE ISHERCULES()
	   CardName ="Hercules"
	CASE ISCGA()
	   CardName ="CGA"
	OTHERWISE
	   CardName ="??"
endcase
RETURN CardName

FUNCTION CPUNAME()
LOCAL CpuType
do case
	CASE CPUTYPE()=CPU_8088
		CpuType:="8088"
	CASE CPUTYPE()=CPU_8086
		CpuType:="8086"
	CASE CPUTYPE()=CPU_V20
		CpuType:="V20"
	CASE CPUTYPE()=CPU_V30
		CpuType:="V30"
	CASE CPUTYPE()=CPU_80188
		CpuType:="80188"
	CASE CPUTYPE()=CPU_80186
		CpuType:="80186"
	CASE CPUTYPE()=CPU_80286
		CpuType:="80286"
	CASE CPUTYPE()=CPU_80386
		CpuType:="80386"
	CASE CPUTYPE()=CPU_80486
		CpuType:="80486"
	OTHERWISE
		CpuType:="??"
endcase
RETURN CpuType

FUNCTION KBDNAME()
LOCAL kbdname
do case
	case KBDTYPE()=0
		kbdname:="PC"
	case KBDTYPE()=1
		kbdname:="AT"
	case KBDTYPE()=2
		kbdname:="101/102 Keys"
endcase
RETURN kbdname

FUNCTION PCNAME()
LOCAL pcname
DO CASE
	CASE Pctype()= PC_NORMAL
		pcname:="IBM PC"
	CASE Pctype()= PC_XT
		pcname:="IBM XT"
	CASE Pctype()= PC_JUNIOR
		pcname:="PC Junior"
	CASE Pctype()= PC_MODEL30
		pcname:="PC Model 30"
	CASE Pctype()= PC_XT_2
		pcname:="XT/2"
	CASE Pctype()= PC_LAPTOP
		pcname:="Laptop"
	CASE Pctype()= PC_AT
		pcname:="PC AT"
	CASE Pctype()= PC_MODEL80
		pcname:="PC Model 80"
	CASE Pctype()= PC_COMPAQP
		pcname:="Compaq Portable"
	CASE Pctype()= PC_COMPAQPP
		pcname:="Compaq Portable Plus"
	OTHERWISE
		pcname:="??"
ENDCASE
RETURN pcname
