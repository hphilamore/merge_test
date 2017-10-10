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
	FNCALL	_main,_loop
	FNROOT	_main
	global	_addvalueTotal
	global	_addvalueTotalL
	global	_VddVal
	global	_addvalueH
	global	_addvalueL
	global	_addvalueTotalH
	global	_CARRY
psect	text100,local,class=CODE,delta=2
global __ptext100
__ptext100:
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
	file	"analog_voltage_interrupt.as"
	line	#
psect cinit,class=CODE,delta=2
global start_initialization
start_initialization:

psect	bssCOMMON,class=COMMON,space=1
global __pbssCOMMON
__pbssCOMMON:
_VddVal:
       ds      2

_addvalueH:
       ds      2

_addvalueL:
       ds      2

_addvalueTotalH:
       ds      2

psect	bssBANK0,class=BANK0,space=1
global __pbssBANK0
__pbssBANK0:
_addvalueTotal:
       ds      2

_addvalueTotalL:
       ds      2

; Clear objects allocated to COMMON
psect cinit,class=CODE,delta=2
	global __pbssCOMMON
	clrf	((__pbssCOMMON)+0)&07Fh
	clrf	((__pbssCOMMON)+1)&07Fh
	clrf	((__pbssCOMMON)+2)&07Fh
	clrf	((__pbssCOMMON)+3)&07Fh
	clrf	((__pbssCOMMON)+4)&07Fh
	clrf	((__pbssCOMMON)+5)&07Fh
	clrf	((__pbssCOMMON)+6)&07Fh
	clrf	((__pbssCOMMON)+7)&07Fh
; Clear objects allocated to BANK0
psect cinit,class=CODE,delta=2
	global __pbssBANK0
	clrf	((__pbssBANK0)+0)&07Fh
	clrf	((__pbssBANK0)+1)&07Fh
	clrf	((__pbssBANK0)+2)&07Fh
	clrf	((__pbssBANK0)+3)&07Fh
psect cinit,class=CODE,delta=2
global end_of_initialization

;End of C runtime variable initialization code

end_of_initialization:
movlb 0
ljmp _main	;jump to C main() function
psect	cstackCOMMON,class=COMMON,space=1
global __pcstackCOMMON
__pcstackCOMMON:
	global	?_loop
?_loop:	; 0 bytes @ 0x0
	global	??_loop
??_loop:	; 0 bytes @ 0x0
	global	?_main
?_main:	; 2 bytes @ 0x0
	ds	3
	global	??_main
??_main:	; 0 bytes @ 0x3
	ds	2
;;Data sizes: Strings 0, constant 0, data 0, bss 12, persistent 0 stack 0
;;Auto spaces:   Size  Autos    Used
;; COMMON          14      5      13
;; BANK0           80      0       4
;; BANK1           21      0       0

;;
;; Pointer list with targets:



;;
;; Critical Paths under _main in COMMON
;;
;;   _main->_loop
;;
;; Critical Paths under _main in BANK0
;;
;;   None.
;;
;; Critical Paths under _main in BANK1
;;
;;   None.

;;
;;Main: autosize = 0, tempsize = 2, incstack = 0, save=0
;;

;;
;;Call Graph Tables:
;;
;; ---------------------------------------------------------------------------------
;; (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;; ---------------------------------------------------------------------------------
;; (0) _main                                                 2     2      0       0
;;                                              3 COMMON     2     2      0
;;                               _loop
;; ---------------------------------------------------------------------------------
;; (1) _loop                                                 3     3      0       0
;;                                              0 COMMON     3     3      0
;; ---------------------------------------------------------------------------------
;; Estimated maximum stack depth 1
;; ---------------------------------------------------------------------------------

;; Call Graph Graphs:

;; _main (ROOT)
;;   _loop
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
;;COMMON               E      5       D       2       92.9%
;;BITSFR1              0      0       0       2        0.0%
;;SFR1                 0      0       0       2        0.0%
;;BITSFR2              0      0       0       3        0.0%
;;SFR2                 0      0       0       3        0.0%
;;STACK                0      0       1       3        0.0%
;;BITSFR3              0      0       0       4        0.0%
;;SFR3                 0      0       0       4        0.0%
;;ABS                  0      0      11       4        0.0%
;;BITBANK0            50      0       0       5        0.0%
;;BITSFR4              0      0       0       5        0.0%
;;SFR4                 0      0       0       5        0.0%
;;BANK0               50      0       4       6        5.0%
;;BITSFR5              0      0       0       6        0.0%
;;SFR5                 0      0       0       6        0.0%
;;BITBANK1            15      0       0       7        0.0%
;;BITSFR6              0      0       0       7        0.0%
;;SFR6                 0      0       0       7        0.0%
;;BANK1               15      0       0       8        0.0%
;;BITSFR7              0      0       0       8        0.0%
;;SFR7                 0      0       0       8        0.0%
;;BITSFR8              0      0       0       9        0.0%
;;SFR8                 0      0       0       9        0.0%
;;DATA                 0      0      12       9        0.0%
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
psect	maintext,global,class=CODE,delta=2
global __pmaintext
__pmaintext:

;; *************** function _main *****************
;; Defined at:
;;		line 25 in file "C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\analog_voltage_interrupt.c"
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
;;      Temps:          2       0       0
;;      Totals:         2       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels required when called:    1
;; This function calls:
;;		_loop
;; This function is called by:
;;		Startup code after reset
;; This function uses a non-reentrant model
;;
psect	maintext
	file	"C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\analog_voltage_interrupt.c"
	line	25
	global	__size_of_main
	__size_of_main	equ	__end_of_main-_main
	
_main:	
	opt	stack 15
; Regs used in _main: [wreg+status,2+status,0+btemp+1+pclath+cstack]
	line	31
	
l3547:	
;analog_voltage_interrupt.c: 31: TRISA = 0b00000000;
	movlb 1	; select bank1
	clrf	(140)^080h	;volatile
	line	36
;analog_voltage_interrupt.c: 36: ANSELA = 0b0000000;
	movlb 3	; select bank3
	clrf	(396)^0180h	;volatile
	line	42
	
l3549:	
;analog_voltage_interrupt.c: 42: ADCON1 = 0b0111000;
	movlw	(038h)
	movlb 1	; select bank1
	movwf	(158)^080h	;volatile
	line	47
	
l3551:	
;analog_voltage_interrupt.c: 47: ADCON0= 0b01111101;
	movlw	(07Dh)
	movwf	(157)^080h	;volatile
	line	58
	
l3553:	
;analog_voltage_interrupt.c: 58: _delay((unsigned long)((1)*(500000/4000.0)));
	opt asmopt_off
movlw	41
movwf	(??_main+0)+0,f
u2237:
decfsz	(??_main+0)+0,f
	goto	u2237
	clrwdt
opt asmopt_on

	goto	l3555
	line	63
;analog_voltage_interrupt.c: 63: while (1)
	
l1159:	
	line	65
	
l3555:	
;analog_voltage_interrupt.c: 64: {
;analog_voltage_interrupt.c: 65: ADGO = 1;
	movlb 1	; select bank1
	bsf	(1257/8)^080h,(1257)&7
	line	73
;analog_voltage_interrupt.c: 73: while (ADGO==1);
	goto	l1160
	
l1161:	
	
l1160:	
	btfsc	(1257/8)^080h,(1257)&7
	goto	u2191
	goto	u2190
u2191:
	goto	l1160
u2190:
	goto	l3557
	
l1162:	
	line	81
	
l3557:	
;analog_voltage_interrupt.c: 81: addvalueH = ADRESH;
	movf	(156)^080h,w	;volatile
	movwf	(??_main+0)+0
	clrf	(??_main+0)+0+1
	movf	0+(??_main+0)+0,w
	movwf	(_addvalueH)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueH+1)
	line	82
;analog_voltage_interrupt.c: 82: addvalueL = ADRESL;
	movf	(155)^080h,w	;volatile
	movwf	(??_main+0)+0
	clrf	(??_main+0)+0+1
	movf	0+(??_main+0)+0,w
	movwf	(_addvalueL)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueL+1)
	line	87
;analog_voltage_interrupt.c: 87: addvalueTotalH = addvalueH << 2;
	movf	(_addvalueH+1),w
	movwf	(??_main+0)+0+1
	movf	(_addvalueH),w
	movwf	(??_main+0)+0
	movlw	02h
u2205:
	lslf	(??_main+0)+0,f
	rlf	(??_main+0)+1,f
	decfsz	wreg,f
	goto	u2205
	movf	0+(??_main+0)+0,w
	movwf	(_addvalueTotalH)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueTotalH+1)
	line	88
	
l3559:	
;analog_voltage_interrupt.c: 88: addvalueTotalL = addvalueL >> 6;
	movf	(_addvalueL+1),w
	movwf	(??_main+0)+0+1
	movf	(_addvalueL),w
	movwf	(??_main+0)+0
	movlw	06h
	movwf	btemp+1
u2215:
	rlf	(??_main+0)+1,w
	rrf	(??_main+0)+1,f
	rrf	(??_main+0)+0,f
	decfsz	btemp+1,f
	goto	u2215
	movf	0+(??_main+0)+0,w
	movlb 0	; select bank0
	movwf	(_addvalueTotalL)
	movf	1+(??_main+0)+0,w
	movwf	(_addvalueTotalL+1)
	line	93
	
l3561:	
;analog_voltage_interrupt.c: 93: addvalueTotal = addvalueTotalH + addvalueTotalL;
	movf	(_addvalueTotalL),w
	addwf	(_addvalueTotalH),w
	movwf	(_addvalueTotal)
	movf	(_addvalueTotalL+1),w
	addwfc	(_addvalueTotalH+1),w
	movwf	1+(_addvalueTotal)
	line	97
	
l3563:	
;analog_voltage_interrupt.c: 97: VddVal = addvalueTotal*1048576;
	movf	(_addvalueTotal+1),w
	clrf	(_VddVal+1)
	addwf	(_VddVal+1)
	movf	(_addvalueTotal),w
	clrf	(_VddVal)
	addwf	(_VddVal)

	goto	l3569
	line	101
	
l3565:	
	goto	l3569
	
l1163:	
	line	103
;analog_voltage_interrupt.c: 102: {
;analog_voltage_interrupt.c: 103: while (VddVal>1800)
	goto	l3569
	
l1165:	
	line	105
	
l3567:	
;analog_voltage_interrupt.c: 104: {
;analog_voltage_interrupt.c: 105: loop();
	fcall	_loop
	goto	l3569
	line	107
	
l1164:	
	line	103
	
l3569:	
	movf	(_VddVal+1),w
	xorlw	80h
	movwf	btemp+1
	movlw	(high(0709h))^80h
	subwf	btemp+1,w
	skipz
	goto	u2225
	movlw	low(0709h)
	subwf	(_VddVal),w
u2225:

	skipnc
	goto	u2221
	goto	u2220
u2221:
	goto	l3567
u2220:
	goto	l3555
	
l1166:	
	goto	l3555
	line	113
	
l1167:	
	line	63
	goto	l3555
	
l1168:	
	line	114
	
l1169:	
	global	start
	ljmp	start
	opt stack 0
GLOBAL	__end_of_main
	__end_of_main:
;; =============== function _main ends ============

	signat	_main,90
	global	_loop
psect	text101,local,class=CODE,delta=2
global __ptext101
__ptext101:

;; *************** function _loop *****************
;; Defined at:
;;		line 119 in file "C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\analog_voltage_interrupt.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;		None               void
;; Registers used:
;;		wreg
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1
;;      Params:         0       0       0
;;      Locals:         0       0       0
;;      Temps:          3       0       0
;;      Totals:         3       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text101
	file	"C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\analog_voltage_interrupt.c"
	line	119
	global	__size_of_loop
	__size_of_loop	equ	__end_of_loop-_loop
	
_loop:	
	opt	stack 15
; Regs used in _loop: [wreg]
	line	122
	
l3531:	
;analog_voltage_interrupt.c: 122: RA4 = 0;
	movlb 0	; select bank0
	bcf	(100/8),(100)&7
	line	123
;analog_voltage_interrupt.c: 123: RA5 = 0;
	bcf	(101/8),(101)&7
	line	124
	
l3533:	
;analog_voltage_interrupt.c: 124: _delay((unsigned long)((2000)*(500000/4000.0)));
	opt asmopt_off
movlw  2
movwf	((??_loop+0)+0+2),f
movlw	69
movwf	((??_loop+0)+0+1),f
	movlw	169
movwf	((??_loop+0)+0),f
u2247:
	decfsz	((??_loop+0)+0),f
	goto	u2247
	decfsz	((??_loop+0)+0+1),f
	goto	u2247
	decfsz	((??_loop+0)+0+2),f
	goto	u2247
	nop2
opt asmopt_on

	line	126
	
l3535:	
;analog_voltage_interrupt.c: 126: RA4 = 1;
	movlb 0	; select bank0
	bsf	(100/8),(100)&7
	line	127
	
l3537:	
;analog_voltage_interrupt.c: 127: RA5 = 0;
	bcf	(101/8),(101)&7
	line	128
;analog_voltage_interrupt.c: 128: _delay((unsigned long)((2000)*(500000/4000.0)));
	opt asmopt_off
movlw  2
movwf	((??_loop+0)+0+2),f
movlw	69
movwf	((??_loop+0)+0+1),f
	movlw	169
movwf	((??_loop+0)+0),f
u2257:
	decfsz	((??_loop+0)+0),f
	goto	u2257
	decfsz	((??_loop+0)+0+1),f
	goto	u2257
	decfsz	((??_loop+0)+0+2),f
	goto	u2257
	nop2
opt asmopt_on

	line	131
	
l3539:	
;analog_voltage_interrupt.c: 131: RA4 = 0;
	movlb 0	; select bank0
	bcf	(100/8),(100)&7
	line	132
	
l3541:	
;analog_voltage_interrupt.c: 132: RA5 = 0;
	bcf	(101/8),(101)&7
	line	133
;analog_voltage_interrupt.c: 133: _delay((unsigned long)((2000)*(500000/4000.0)));
	opt asmopt_off
movlw  2
movwf	((??_loop+0)+0+2),f
movlw	69
movwf	((??_loop+0)+0+1),f
	movlw	169
movwf	((??_loop+0)+0),f
u2267:
	decfsz	((??_loop+0)+0),f
	goto	u2267
	decfsz	((??_loop+0)+0+1),f
	goto	u2267
	decfsz	((??_loop+0)+0+2),f
	goto	u2267
	nop2
opt asmopt_on

	line	136
	
l3543:	
;analog_voltage_interrupt.c: 136: RA4 = 0;
	movlb 0	; select bank0
	bcf	(100/8),(100)&7
	line	137
	
l3545:	
;analog_voltage_interrupt.c: 137: RA5 = 1;
	bsf	(101/8),(101)&7
	line	138
;analog_voltage_interrupt.c: 138: _delay((unsigned long)((2000)*(500000/4000.0)));
	opt asmopt_off
movlw  2
movwf	((??_loop+0)+0+2),f
movlw	69
movwf	((??_loop+0)+0+1),f
	movlw	169
movwf	((??_loop+0)+0),f
u2277:
	decfsz	((??_loop+0)+0),f
	goto	u2277
	decfsz	((??_loop+0)+0+1),f
	goto	u2277
	decfsz	((??_loop+0)+0+2),f
	goto	u2277
	nop2
opt asmopt_on

	line	140
	
l1172:	
	return
	opt stack 0
GLOBAL	__end_of_loop
	__end_of_loop:
;; =============== function _loop ends ============

	signat	_loop,88
psect	text102,local,class=CODE,delta=2
global __ptext102
__ptext102:
	global	btemp
	btemp set 07Eh

	DABS	1,126,2	;btemp
	global	wtemp0
	wtemp0 set btemp
	end
