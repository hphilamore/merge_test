opt subtitle "HI-TECH Software Omniscient Code Generator (Lite mode) build 10920"

opt pagewidth 120

	opt lm

	processor	12LF1822
clrc	macro
	bcf	3,0
	endm
clrz	macro
	bcf	3,2
	endm
setc	macro
	bsf	3,0
	endm
setz	macro
	bsf	3,2
	endm
skipc	macro
	btfss	3,0
	endm
skipz	macro
	btfss	3,2
	endm
skipnc	macro
	btfsc	3,0
	endm
skipnz	macro
	btfsc	3,2
	endm
indf	equ	0
indf0	equ	0
indf1	equ	1
pc	equ	2
pcl	equ	2
status	equ	3
fsr0l	equ	4
fsr0h	equ	5
fsr1l	equ	6
fsr1h	equ	7
bsr	equ	8
wreg	equ	9
intcon	equ	11
c	equ	1
z	equ	0
pclath	equ	10
	FNCALL	_main,___awdiv
	FNROOT	_main
	global	_addvalueL
	global	_addvalueTotal
	global	_addvalueTotalH
	global	_addvalueTotalL
	global	_addvalueTotalVREF
	global	_addvalueTotalVdd
	global	_addvalueH
	global	_CARRY
psect	maintext,global,class=CODE,delta=2
global __pmaintext
__pmaintext:
_CARRY	set	24
	global	_GIE
_GIE	set	95
	global	_RA4
_RA4	set	100
	global	_RA5
_RA5	set	101
	global	_ADCON0
_ADCON0	set	157
	global	_ADCON1
_ADCON1	set	158
	global	_ADRESH
_ADRESH	set	156
	global	_ADRESL
_ADRESL	set	155
	global	_TRISA
_TRISA	set	140
	global	_ADGO
_ADGO	set	1257
	global	_EEADR
_EEADR	set	401
	global	_ANSELA
_ANSELA	set	396
	global	_EECON1
_EECON1	set	405
	global	_EECON2
_EECON2	set	406
	global	_EEDATA
_EEDATA	set	403
	global	_RD
_RD	set	3240
	global	_WR
_WR	set	3241
	global	_WREN
_WREN	set	3242
	file	"volt_interrupt.as"
	line	#
psect cinit,class=CODE,delta=2
global start_initialization
start_initialization:

psect	bssCOMMON,class=COMMON,space=1
global __pbssCOMMON
__pbssCOMMON:
_addvalueH:
       ds      2

psect	bssBANK0,class=BANK0,space=1
global __pbssBANK0
__pbssBANK0:
_addvalueL:
       ds      2

_addvalueTotal:
       ds      2

_addvalueTotalH:
       ds      2

_addvalueTotalL:
       ds      2

_addvalueTotalVREF:
       ds      2

_addvalueTotalVdd:
       ds      2

; Clear objects allocated to COMMON
psect cinit,class=CODE,delta=2
	global __pbssCOMMON
	clrf	((__pbssCOMMON)+0)&07Fh
	clrf	((__pbssCOMMON)+1)&07Fh
; Clear objects allocated to BANK0
psect cinit,class=CODE,delta=2
	global __pbssBANK0
	clrf	((__pbssBANK0)+0)&07Fh
	clrf	((__pbssBANK0)+1)&07Fh
	clrf	((__pbssBANK0)+2)&07Fh
	clrf	((__pbssBANK0)+3)&07Fh
	clrf	((__pbssBANK0)+4)&07Fh
	clrf	((__pbssBANK0)+5)&07Fh
	clrf	((__pbssBANK0)+6)&07Fh
	clrf	((__pbssBANK0)+7)&07Fh
	clrf	((__pbssBANK0)+8)&07Fh
	clrf	((__pbssBANK0)+9)&07Fh
	clrf	((__pbssBANK0)+10)&07Fh
	clrf	((__pbssBANK0)+11)&07Fh
psect cinit,class=CODE,delta=2
global end_of_initialization

;End of C runtime variable initialization code

end_of_initialization:
movlb 0
ljmp _main	;jump to C main() function
psect	cstackCOMMON,class=COMMON,space=1
global __pcstackCOMMON
__pcstackCOMMON:
	global	?_main
?_main:	; 2 bytes @ 0x0
	global	?___awdiv
?___awdiv:	; 2 bytes @ 0x0
	global	___awdiv@divisor
___awdiv@divisor:	; 2 bytes @ 0x0
	ds	2
	global	___awdiv@dividend
___awdiv@dividend:	; 2 bytes @ 0x2
	ds	2
	global	??___awdiv
??___awdiv:	; 0 bytes @ 0x4
	ds	1
	global	___awdiv@counter
___awdiv@counter:	; 1 bytes @ 0x5
	ds	1
	global	___awdiv@sign
___awdiv@sign:	; 1 bytes @ 0x6
	ds	1
	global	___awdiv@quotient
___awdiv@quotient:	; 2 bytes @ 0x7
	ds	2
	global	??_main
??_main:	; 0 bytes @ 0x9
	ds	3
;;Data sizes: Strings 0, constant 0, data 0, bss 14, persistent 0 stack 0
;;Auto spaces:   Size  Autos    Used
;; COMMON          14     12      14
;; BANK0           80      0      12
;; BANK1           32      0       0

;;
;; Pointer list with targets:

;; ?___awdiv	int  size(1) Largest target is 0
;;


;;
;; Critical Paths under _main in COMMON
;;
;;   _main->___awdiv
;;
;; Critical Paths under _main in BANK0
;;
;;   None.
;;
;; Critical Paths under _main in BANK1
;;
;;   None.

;;
;;Main: autosize = 0, tempsize = 3, incstack = 0, save=0
;;

;;
;;Call Graph Tables:
;;
;; ---------------------------------------------------------------------------------
;; (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;; ---------------------------------------------------------------------------------
;; (0) _main                                                 3     3      0     300
;;                                              9 COMMON     3     3      0
;;                            ___awdiv
;; ---------------------------------------------------------------------------------
;; (1) ___awdiv                                              9     5      4     300
;;                                              0 COMMON     9     5      4
;; ---------------------------------------------------------------------------------
;; Estimated maximum stack depth 1
;; ---------------------------------------------------------------------------------

;; Call Graph Graphs:

;; _main (ROOT)
;;   ___awdiv
;;

;; Address spaces:

;;Name               Size   Autos  Total    Cost      Usage
;;BIGRAM              70      0       0       0        0.0%
;;EEDATA             100      0       0       0        0.0%
;;NULL                 0      0       0       0        0.0%
;;CODE                 0      0       0       0        0.0%
;;BITCOMMON            E      0       0       1        0.0%
;;BITSFR0              0      0       0       1        0.0%
;;SFR0                 0      0       0       1        0.0%
;;COMMON               E      C       E       2      100.0%
;;BITSFR1              0      0       0       2        0.0%
;;SFR1                 0      0       0       2        0.0%
;;BITSFR2              0      0       0       3        0.0%
;;SFR2                 0      0       0       3        0.0%
;;STACK                0      0       1       3        0.0%
;;BITSFR3              0      0       0       4        0.0%
;;SFR3                 0      0       0       4        0.0%
;;ABS                  0      0      1A       4        0.0%
;;BITBANK0            50      0       0       5        0.0%
;;BITSFR4              0      0       0       5        0.0%
;;SFR4                 0      0       0       5        0.0%
;;BANK0               50      0       C       6       15.0%
;;BITSFR5              0      0       0       6        0.0%
;;SFR5                 0      0       0       6        0.0%
;;BITBANK1            20      0       0       7        0.0%
;;BITSFR6              0      0       0       7        0.0%
;;SFR6                 0      0       0       7        0.0%
;;BANK1               20      0       0       8        0.0%
;;BITSFR7              0      0       0       8        0.0%
;;SFR7                 0      0       0       8        0.0%
;;BITSFR8              0      0       0       9        0.0%
;;SFR8                 0      0       0       9        0.0%
;;DATA                 0      0      1B       9        0.0%
;;BITSFR9              0      0       0      10        0.0%
;;SFR9                 0      0       0      10        0.0%
;;BITSFR10             0      0       0      11        0.0%
;;SFR10                0      0       0      11        0.0%
;;BITSFR11             0      0       0      12        0.0%
;;SFR11                0      0       0      12        0.0%
;;BITSFR12             0      0       0      13        0.0%
;;SFR12                0      0       0      13        0.0%
;;BITSFR13             0      0       0      14        0.0%
;;SFR13                0      0       0      14        0.0%
;;BITSFR14             0      0       0      15        0.0%
;;SFR14                0      0       0      15        0.0%
;;BITSFR15             0      0       0      16        0.0%
;;SFR15                0      0       0      16        0.0%
;;BITSFR16             0      0       0      17        0.0%
;;SFR16                0      0       0      17        0.0%
;;BITSFR17             0      0       0      18        0.0%
;;SFR17                0      0       0      18        0.0%
;;BITSFR18             0      0       0      19        0.0%
;;SFR18                0      0       0      19        0.0%
;;BITSFR19             0      0       0      20        0.0%
;;SFR19                0      0       0      20        0.0%
;;BITSFR20             0      0       0      21        0.0%
;;SFR20                0      0       0      21        0.0%
;;BITSFR21             0      0       0      22        0.0%
;;SFR21                0      0       0      22        0.0%
;;BITSFR22             0      0       0      23        0.0%
;;SFR22                0      0       0      23        0.0%
;;BITSFR23             0      0       0      24        0.0%
;;SFR23                0      0       0      24        0.0%
;;BITSFR24             0      0       0      25        0.0%
;;SFR24                0      0       0      25        0.0%
;;BITSFR25             0      0       0      26        0.0%
;;SFR25                0      0       0      26        0.0%
;;BITSFR26             0      0       0      27        0.0%
;;SFR26                0      0       0      27        0.0%
;;BITSFR27             0      0       0      28        0.0%
;;SFR27                0      0       0      28        0.0%
;;BITSFR28             0      0       0      29        0.0%
;;SFR28                0      0       0      29        0.0%
;;BITSFR29             0      0       0      30        0.0%
;;SFR29                0      0       0      30        0.0%
;;BITSFR30             0      0       0      31        0.0%
;;SFR30                0      0       0      31        0.0%
;;BITSFR31             0      0       0      32        0.0%
;;SFR31                0      0       0      32        0.0%

	global	_main
psect	maintext

;; *************** function _main *****************
;; Defined at:
;;		line 18 in file "C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\volt_interrupt.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2  1158[COMMON] int 
;; Registers used:
;;		wreg, status,2, status,0, btemp+1, pclath, cstack
;; Tracked objects:
;;		On entry : 17F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1
;;      Params:         0       0       0
;;      Locals:         0       0       0
;;      Temps:          3       0       0
;;      Totals:         3       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels required when called:    1
;; This function calls:
;;		___awdiv
;; This function is called by:
;;		Startup code after reset
;; This function uses a non-reentrant model
;;
psect	maintext
	file	"C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\volt_interrupt.c"
	line	18
	global	__size_of_main
	__size_of_main	equ	__end_of_main-_main
	
_main:	
	opt	stack 15
; Regs used in _main: [wreg+status,2+status,0+btemp+1+pclath+cstack]
	line	24
	
l3586:	
;volt_interrupt.c: 24: TRISA = 0b00000001;
	movlw	(01h)
	movlb 1	; select bank1
	movwf	(140)^080h	;volatile
	line	29
;volt_interrupt.c: 29: ANSELA = 0b0000001;
	movlw	(01h)
	movlb 3	; select bank3
	movwf	(396)^0180h	;volatile
	line	35
;volt_interrupt.c: 35: ADCON1 = 0b0111011;
	movlw	(03Bh)
	movlb 1	; select bank1
	movwf	(158)^080h	;volatile
	line	40
;volt_interrupt.c: 40: ADCON0= 0b01111101;
	movlw	(07Dh)
	movwf	(157)^080h	;volatile
	line	43
;volt_interrupt.c: 43: _delay((unsigned long)((1)*(500000/4000.0)));
	opt asmopt_off
movlw	41
movwf	(??_main+0)+0,f
u2377:
decfsz	(??_main+0)+0,f
	goto	u2377
	clrwdt
opt asmopt_on

	line	48
	
l3588:	
;volt_interrupt.c: 48: ADGO = 1;
	movlb 1	; select bank1
	bsf	(1257/8)^080h,(1257)&7
	line	58
;volt_interrupt.c: 58: while (ADGO==1);
	goto	l1159
	
l1160:	
	
l1159:	
	btfsc	(1257/8)^080h,(1257)&7
	goto	u2311
	goto	u2310
u2311:
	goto	l1159
u2310:
	goto	l3590
	
l1161:	
	line	69
	
l3590:	
;volt_interrupt.c: 69: addvalueH = ADRESH;
	movf	(156)^080h,w	;volatile
	movwf	(??_main+0)+0
	clrf	(??_main+0)+0+1
	movf	0+(??_main+0)+0,w
	movwf	(_addvalueH)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueH+1)
	line	70
;volt_interrupt.c: 70: addvalueL = ADRESL;
	movf	(155)^080h,w	;volatile
	movwf	(??_main+0)+0
	clrf	(??_main+0)+0+1
	movf	0+(??_main+0)+0,w
	movlb 0	; select bank0
	movwf	(_addvalueL)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueL+1)
	line	72
;volt_interrupt.c: 72: addvalueTotalH = addvalueH << 2;
	movf	(_addvalueH+1),w
	movwf	(??_main+0)+0+1
	movf	(_addvalueH),w
	movwf	(??_main+0)+0
	movlw	02h
u2325:
	lslf	(??_main+0)+0,f
	rlf	(??_main+0)+1,f
	decfsz	wreg,f
	goto	u2325
	movf	0+(??_main+0)+0,w
	movwf	(_addvalueTotalH)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueTotalH+1)
	line	73
	
l3592:	
;volt_interrupt.c: 73: addvalueTotalL = addvalueL >> 6;
	movf	(_addvalueL+1),w
	movwf	(??_main+0)+0+1
	movf	(_addvalueL),w
	movwf	(??_main+0)+0
	movlw	06h
	movwf	btemp+1
u2335:
	rlf	(??_main+0)+1,w
	rrf	(??_main+0)+1,f
	rrf	(??_main+0)+0,f
	decfsz	btemp+1,f
	goto	u2335
	movf	0+(??_main+0)+0,w
	movwf	(_addvalueTotalL)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueTotalL+1)
	line	78
	
l3594:	
;volt_interrupt.c: 78: addvalueTotalVREF = addvalueH + addvalueL;
	movf	(_addvalueL),w
	addwf	(_addvalueH),w
	movwf	(_addvalueTotalVREF)
	movf	(_addvalueL+1),w
	addwfc	(_addvalueH+1),w
	movwf	1+(_addvalueTotalVREF)
	goto	l3596
	line	82
;volt_interrupt.c: 82: while (1)
	
l1162:	
	line	89
	
l3596:	
;volt_interrupt.c: 83: {
;volt_interrupt.c: 89: ADCON0= 0b00000001;
	movlw	(01h)
	movlb 1	; select bank1
	movwf	(157)^080h	;volatile
	line	100
	
l3598:	
;volt_interrupt.c: 100: _delay((unsigned long)((1)*(500000/4000.0)));
	opt asmopt_off
movlw	41
movwf	(??_main+0)+0,f
u2387:
decfsz	(??_main+0)+0,f
	goto	u2387
	clrwdt
opt asmopt_on

	line	106
	
l3600:	
;volt_interrupt.c: 106: ADGO = 1;
	movlb 1	; select bank1
	bsf	(1257/8)^080h,(1257)&7
	line	116
;volt_interrupt.c: 116: while (ADGO==1);
	goto	l1163
	
l1164:	
	
l1163:	
	btfsc	(1257/8)^080h,(1257)&7
	goto	u2341
	goto	u2340
u2341:
	goto	l1163
u2340:
	goto	l3602
	
l1165:	
	line	127
	
l3602:	
;volt_interrupt.c: 127: addvalueH = ADRESH;
	movf	(156)^080h,w	;volatile
	movwf	(??_main+0)+0
	clrf	(??_main+0)+0+1
	movf	0+(??_main+0)+0,w
	movwf	(_addvalueH)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueH+1)
	line	128
;volt_interrupt.c: 128: addvalueL = ADRESL;
	movf	(155)^080h,w	;volatile
	movwf	(??_main+0)+0
	clrf	(??_main+0)+0+1
	movf	0+(??_main+0)+0,w
	movlb 0	; select bank0
	movwf	(_addvalueL)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueL+1)
	line	130
;volt_interrupt.c: 130: addvalueTotalH = addvalueH << 2;
	movf	(_addvalueH+1),w
	movwf	(??_main+0)+0+1
	movf	(_addvalueH),w
	movwf	(??_main+0)+0
	movlw	02h
u2355:
	lslf	(??_main+0)+0,f
	rlf	(??_main+0)+1,f
	decfsz	wreg,f
	goto	u2355
	movf	0+(??_main+0)+0,w
	movwf	(_addvalueTotalH)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueTotalH+1)
	line	131
	
l3604:	
;volt_interrupt.c: 131: addvalueTotalL = addvalueL >> 6;
	movf	(_addvalueL+1),w
	movwf	(??_main+0)+0+1
	movf	(_addvalueL),w
	movwf	(??_main+0)+0
	movlw	06h
	movwf	btemp+1
u2365:
	rlf	(??_main+0)+1,w
	rrf	(??_main+0)+1,f
	rrf	(??_main+0)+0,f
	decfsz	btemp+1,f
	goto	u2365
	movf	0+(??_main+0)+0,w
	movwf	(_addvalueTotalL)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueTotalL+1)
	line	136
	
l3606:	
;volt_interrupt.c: 136: addvalueTotalVdd = addvalueH + addvalueL;
	movf	(_addvalueL),w
	addwf	(_addvalueH),w
	movwf	(_addvalueTotalVdd)
	movf	(_addvalueL+1),w
	addwfc	(_addvalueH+1),w
	movwf	1+(_addvalueTotalVdd)
	line	141
	
l3608:	
;volt_interrupt.c: 141: addvalueTotal = addvalueTotalVREF / addvalueTotalVdd;
	movf	(_addvalueTotalVdd+1),w
	clrf	(?___awdiv+1)
	addwf	(?___awdiv+1)
	movf	(_addvalueTotalVdd),w
	clrf	(?___awdiv)
	addwf	(?___awdiv)

	movf	(_addvalueTotalVREF+1),w
	clrf	1+(?___awdiv)+02h
	addwf	1+(?___awdiv)+02h
	movf	(_addvalueTotalVREF),w
	clrf	0+(?___awdiv)+02h
	addwf	0+(?___awdiv)+02h

	fcall	___awdiv
	movf	(1+(?___awdiv)),w
	movlb 0	; select bank0
	clrf	(_addvalueTotal+1)
	addwf	(_addvalueTotal+1)
	movf	(0+(?___awdiv)),w
	clrf	(_addvalueTotal)
	addwf	(_addvalueTotal)

	line	145
;volt_interrupt.c: 145: while (1.8 > addvalueTotal > 3)
	goto	l3596
	
l1167:	
	line	150
;volt_interrupt.c: 146: {
;volt_interrupt.c: 150: RA4 = 0;
	bcf	(100/8),(100)&7
	line	151
;volt_interrupt.c: 151: RA5 = 0;
	bcf	(101/8),(101)&7
	line	152
	
l3610:	
;volt_interrupt.c: 152: _delay((unsigned long)((2000)*(500000/4000.0)));
	opt asmopt_off
movlw  2
movwf	((??_main+0)+0+2),f
movlw	69
movwf	((??_main+0)+0+1),f
	movlw	169
movwf	((??_main+0)+0),f
u2397:
	decfsz	((??_main+0)+0),f
	goto	u2397
	decfsz	((??_main+0)+0+1),f
	goto	u2397
	decfsz	((??_main+0)+0+2),f
	goto	u2397
	nop2
opt asmopt_on

	line	156
	
l3612:	
;volt_interrupt.c: 156: RA4 = 1;
	movlb 0	; select bank0
	bsf	(100/8),(100)&7
	line	157
	
l3614:	
;volt_interrupt.c: 157: RA5 = 0;
	bcf	(101/8),(101)&7
	line	158
;volt_interrupt.c: 158: _delay((unsigned long)((2000)*(500000/4000.0)));
	opt asmopt_off
movlw  2
movwf	((??_main+0)+0+2),f
movlw	69
movwf	((??_main+0)+0+1),f
	movlw	169
movwf	((??_main+0)+0),f
u2407:
	decfsz	((??_main+0)+0),f
	goto	u2407
	decfsz	((??_main+0)+0+1),f
	goto	u2407
	decfsz	((??_main+0)+0+2),f
	goto	u2407
	nop2
opt asmopt_on

	line	162
	
l3616:	
;volt_interrupt.c: 162: RA4 = 0;
	movlb 0	; select bank0
	bcf	(100/8),(100)&7
	line	163
	
l3618:	
;volt_interrupt.c: 163: RA5 = 0;
	bcf	(101/8),(101)&7
	line	164
;volt_interrupt.c: 164: _delay((unsigned long)((2000)*(500000/4000.0)));
	opt asmopt_off
movlw  2
movwf	((??_main+0)+0+2),f
movlw	69
movwf	((??_main+0)+0+1),f
	movlw	169
movwf	((??_main+0)+0),f
u2417:
	decfsz	((??_main+0)+0),f
	goto	u2417
	decfsz	((??_main+0)+0+1),f
	goto	u2417
	decfsz	((??_main+0)+0+2),f
	goto	u2417
	nop2
opt asmopt_on

	line	168
	
l3620:	
;volt_interrupt.c: 168: RA4 = 0;
	movlb 0	; select bank0
	bcf	(100/8),(100)&7
	line	169
	
l3622:	
;volt_interrupt.c: 169: RA5 = 1;
	bsf	(101/8),(101)&7
	line	170
;volt_interrupt.c: 170: _delay((unsigned long)((2000)*(500000/4000.0)));
	opt asmopt_off
movlw  2
movwf	((??_main+0)+0+2),f
movlw	69
movwf	((??_main+0)+0+1),f
	movlw	169
movwf	((??_main+0)+0),f
u2427:
	decfsz	((??_main+0)+0),f
	goto	u2427
	decfsz	((??_main+0)+0+1),f
	goto	u2427
	decfsz	((??_main+0)+0+2),f
	goto	u2427
	nop2
opt asmopt_on

	goto	l3596
	line	171
	
l1166:	
	goto	l3596
	line	145
	
l1168:	
	goto	l3596
	line	175
	
l1169:	
	line	82
	goto	l3596
	
l1170:	
	line	176
	
l1171:	
	global	start
	ljmp	start
	opt stack 0
GLOBAL	__end_of_main
	__end_of_main:
;; =============== function _main ends ============

	signat	_main,90
	global	___awdiv
psect	text88,local,class=CODE,delta=2
global __ptext88
__ptext88:

;; *************** function ___awdiv *****************
;; Defined at:
;;		line 5 in file "C:\Program Files (x86)\HI-TECH Software\PICC\9.83\sources\awdiv.c"
;; Parameters:    Size  Location     Type
;;  divisor         2    0[COMMON] int 
;;  dividend        2    2[COMMON] int 
;; Auto vars:     Size  Location     Type
;;  quotient        2    7[COMMON] int 
;;  sign            1    6[COMMON] unsigned char 
;;  counter         1    5[COMMON] unsigned char 
;; Return value:  Size  Location     Type
;;                  2    0[COMMON] int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1
;;      Params:         4       0       0
;;      Locals:         4       0       0
;;      Temps:          1       0       0
;;      Totals:         9       0       0
;;Total ram usage:        9 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text88
	file	"C:\Program Files (x86)\HI-TECH Software\PICC\9.83\sources\awdiv.c"
	line	5
	global	__size_of___awdiv
	__size_of___awdiv	equ	__end_of___awdiv-___awdiv
	
___awdiv:	
	opt	stack 15
; Regs used in ___awdiv: [wreg+status,2+status,0]
	line	9
	
l3546:	
	clrf	(___awdiv@sign)
	line	10
	btfss	(___awdiv@divisor+1),7
	goto	u2211
	goto	u2210
u2211:
	goto	l3550
u2210:
	line	11
	
l3548:	
	comf	(___awdiv@divisor),f
	comf	(___awdiv@divisor+1),f
	incf	(___awdiv@divisor),f
	skipnz
	incf	(___awdiv@divisor+1),f
	line	12
	clrf	(___awdiv@sign)
	bsf	status,0
	rlf	(___awdiv@sign),f
	goto	l3550
	line	13
	
l2396:	
	line	14
	
l3550:	
	btfss	(___awdiv@dividend+1),7
	goto	u2221
	goto	u2220
u2221:
	goto	l3556
u2220:
	line	15
	
l3552:	
	comf	(___awdiv@dividend),f
	comf	(___awdiv@dividend+1),f
	incf	(___awdiv@dividend),f
	skipnz
	incf	(___awdiv@dividend+1),f
	line	16
	
l3554:	
	movlw	(01h)
	movwf	(??___awdiv+0)+0
	movf	(??___awdiv+0)+0,w
	xorwf	(___awdiv@sign),f
	goto	l3556
	line	17
	
l2397:	
	line	18
	
l3556:	
	clrf	(___awdiv@quotient)
	clrf	(___awdiv@quotient+1)
	line	19
	
l3558:	
	movf	(___awdiv@divisor+1),w
	iorwf	(___awdiv@divisor),w
	skipnz
	goto	u2231
	goto	u2230
u2231:
	goto	l3578
u2230:
	line	20
	
l3560:	
	clrf	(___awdiv@counter)
	bsf	status,0
	rlf	(___awdiv@counter),f
	line	21
	goto	l3566
	
l2400:	
	line	22
	
l3562:	
	movlw	01h
	
u2245:
	lslf	(___awdiv@divisor),f
	rlf	(___awdiv@divisor+1),f
	decfsz	wreg,f
	goto	u2245
	line	23
	
l3564:	
	movlw	(01h)
	movwf	(??___awdiv+0)+0
	movf	(??___awdiv+0)+0,w
	addwf	(___awdiv@counter),f
	goto	l3566
	line	24
	
l2399:	
	line	21
	
l3566:	
	btfss	(___awdiv@divisor+1),(15)&7
	goto	u2251
	goto	u2250
u2251:
	goto	l3562
u2250:
	goto	l3568
	
l2401:	
	goto	l3568
	line	25
	
l2402:	
	line	26
	
l3568:	
	movlw	01h
	
u2265:
	lslf	(___awdiv@quotient),f
	rlf	(___awdiv@quotient+1),f
	decfsz	wreg,f
	goto	u2265
	line	27
	movf	(___awdiv@divisor+1),w
	subwf	(___awdiv@dividend+1),w
	skipz
	goto	u2275
	movf	(___awdiv@divisor),w
	subwf	(___awdiv@dividend),w
u2275:
	skipc
	goto	u2271
	goto	u2270
u2271:
	goto	l3574
u2270:
	line	28
	
l3570:	
	movf	(___awdiv@divisor),w
	subwf	(___awdiv@dividend),f
	movf	(___awdiv@divisor+1),w
	subwfb	(___awdiv@dividend+1),f
	line	29
	
l3572:	
	bsf	(___awdiv@quotient)+(0/8),(0)&7
	goto	l3574
	line	30
	
l2403:	
	line	31
	
l3574:	
	movlw	01h
	
u2285:
	lsrf	(___awdiv@divisor+1),f
	rrf	(___awdiv@divisor),f
	decfsz	wreg,f
	goto	u2285
	line	32
	
l3576:	
	movlw	low(01h)
	subwf	(___awdiv@counter),f
	btfss	status,2
	goto	u2291
	goto	u2290
u2291:
	goto	l3568
u2290:
	goto	l3578
	
l2404:	
	goto	l3578
	line	33
	
l2398:	
	line	34
	
l3578:	
	movf	(___awdiv@sign),w
	skipz
	goto	u2300
	goto	l3582
u2300:
	line	35
	
l3580:	
	comf	(___awdiv@quotient),f
	comf	(___awdiv@quotient+1),f
	incf	(___awdiv@quotient),f
	skipnz
	incf	(___awdiv@quotient+1),f
	goto	l3582
	
l2405:	
	line	36
	
l3582:	
	movf	(___awdiv@quotient+1),w
	clrf	(?___awdiv+1)
	addwf	(?___awdiv+1)
	movf	(___awdiv@quotient),w
	clrf	(?___awdiv)
	addwf	(?___awdiv)

	goto	l2406
	
l3584:	
	line	37
	
l2406:	
	return
	opt stack 0
GLOBAL	__end_of___awdiv
	__end_of___awdiv:
;; =============== function ___awdiv ends ============

	signat	___awdiv,8314
psect	text89,local,class=CODE,delta=2
global __ptext89
__ptext89:
	global	btemp
	btemp set 07Eh

	DABS	1,126,2	;btemp
	global	wtemp0
	wtemp0 set btemp
	end
