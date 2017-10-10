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
	global	_PORTA
psect	text76,local,class=CODE,delta=2
global __ptext76
__ptext76:
_PORTA	set	12
	global	_CARRY
_CARRY	set	24
	global	_GIE
_GIE	set	95
	global	_RA2
_RA2	set	98
	global	_RA4
_RA4	set	100
	global	_RA5
_RA5	set	101
	global	_TRISA
_TRISA	set	140
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
	file	"digital_voltage_interrupt.as"
	line	#
psect cinit,class=CODE,delta=2
global start_initialization
start_initialization:

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
	ds	2
	global	??_main
??_main:	; 0 bytes @ 0x2
;;Data sizes: Strings 0, constant 0, data 0, bss 0, persistent 0 stack 0
;;Auto spaces:   Size  Autos    Used
;; COMMON          14      2       2
;; BANK0           80      0       0
;; BANK1           32      0       0

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
;;Main: autosize = 0, tempsize = 0, incstack = 0, save=0
;;

;;
;;Call Graph Tables:
;;
;; ---------------------------------------------------------------------------------
;; (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;; ---------------------------------------------------------------------------------
;; (0) _main                                                 0     0      0       0
;;                               _loop
;; ---------------------------------------------------------------------------------
;; (1) _loop                                                 2     2      0       0
;;                                              0 COMMON     2     2      0
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
;;COMMON               E      2       2       2       14.3%
;;BITSFR1              0      0       0       2        0.0%
;;SFR1                 0      0       0       2        0.0%
;;BITSFR2              0      0       0       3        0.0%
;;SFR2                 0      0       0       3        0.0%
;;STACK                0      0       1       3        0.0%
;;BITSFR3              0      0       0       4        0.0%
;;SFR3                 0      0       0       4        0.0%
;;ABS                  0      0       0       4        0.0%
;;BITBANK0            50      0       0       5        0.0%
;;BITSFR4              0      0       0       5        0.0%
;;SFR4                 0      0       0       5        0.0%
;;BANK0               50      0       0       6        0.0%
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
;;DATA                 0      0       0       9        0.0%
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
;;		line 13 in file "C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\digital_voltage_interrupt.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2  1146[COMMON] int 
;; Registers used:
;;		wreg, status,2, status,0, pclath, cstack
;; Tracked objects:
;;		On entry : 17F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMMON   BANK0   BANK1
;;      Params:         0       0       0
;;      Locals:         0       0       0
;;      Temps:          0       0       0
;;      Totals:         0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels required when called:    1
;; This function calls:
;;		_loop
;; This function is called by:
;;		Startup code after reset
;; This function uses a non-reentrant model
;;
psect	maintext
	file	"C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\digital_voltage_interrupt.c"
	line	13
	global	__size_of_main
	__size_of_main	equ	__end_of_main-_main
	
_main:	
	opt	stack 15
; Regs used in _main: [wreg+status,2+status,0+pclath+cstack]
	line	18
	
l3491:	
;digital_voltage_interrupt.c: 18: PORTA = 0;
	movlb 0	; select bank0
	clrf	(12)	;volatile
	line	19
	
l3493:	
;digital_voltage_interrupt.c: 19: TRISA = 0b00001100;
	movlw	(0Ch)
	movlb 1	; select bank1
	movwf	(140)^080h	;volatile
	line	24
	
l3495:	
;digital_voltage_interrupt.c: 24: ANSELA = 0b0000000;
	movlb 3	; select bank3
	clrf	(396)^0180h	;volatile
	goto	l3499
	line	26
;digital_voltage_interrupt.c: 26: while (1)
	
l1147:	
	line	30
;digital_voltage_interrupt.c: 27: {
;digital_voltage_interrupt.c: 30: while (RA2 == 1)
	goto	l3499
	
l1149:	
	line	38
	
l3497:	
;digital_voltage_interrupt.c: 32: {
;digital_voltage_interrupt.c: 38: loop();
	fcall	_loop
	goto	l3499
	line	44
	
l1148:	
	line	30
	
l3499:	
	movlb 0	; select bank0
	btfsc	(98/8),(98)&7
	goto	u2151
	goto	u2150
u2151:
	goto	l3497
u2150:
	goto	l3499
	
l1150:	
	goto	l3499
	line	46
	
l1151:	
	line	26
	goto	l3499
	
l1152:	
	line	47
	
l1153:	
	global	start
	ljmp	start
	opt stack 0
GLOBAL	__end_of_main
	__end_of_main:
;; =============== function _main ends ============

	signat	_main,90
	global	_loop
psect	text77,local,class=CODE,delta=2
global __ptext77
__ptext77:

;; *************** function _loop *****************
;; Defined at:
;;		line 52 in file "C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\digital_voltage_interrupt.c"
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
;;      Temps:          2       0       0
;;      Totals:         2       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text77
	file	"C:\Users\h-philamore\PhD\Robot brain\IPMC_switch_3\digital_voltage_interrupt.c"
	line	52
	global	__size_of_loop
	__size_of_loop	equ	__end_of_loop-_loop
	
_loop:	
	opt	stack 15
; Regs used in _loop: [wreg]
	line	53
	
l3475:	
;digital_voltage_interrupt.c: 53: RA4 = 0;
	movlb 0	; select bank0
	bcf	(100/8),(100)&7
	line	54
;digital_voltage_interrupt.c: 54: RA5 = 0;
	bcf	(101/8),(101)&7
	line	55
	
l3477:	
;digital_voltage_interrupt.c: 55: _delay((unsigned long)((100)*(500000/4000.0)));
	opt asmopt_off
movlw	17
movwf	((??_loop+0)+0+1),f
	movlw	58
movwf	((??_loop+0)+0),f
u2167:
	decfsz	((??_loop+0)+0),f
	goto	u2167
	decfsz	((??_loop+0)+0+1),f
	goto	u2167
	clrwdt
opt asmopt_on

	line	57
	
l3479:	
;digital_voltage_interrupt.c: 57: RA4 = 1;
	movlb 0	; select bank0
	bsf	(100/8),(100)&7
	line	58
	
l3481:	
;digital_voltage_interrupt.c: 58: RA5 = 0;
	bcf	(101/8),(101)&7
	line	59
;digital_voltage_interrupt.c: 59: _delay((unsigned long)((100)*(500000/4000.0)));
	opt asmopt_off
movlw	17
movwf	((??_loop+0)+0+1),f
	movlw	58
movwf	((??_loop+0)+0),f
u2177:
	decfsz	((??_loop+0)+0),f
	goto	u2177
	decfsz	((??_loop+0)+0+1),f
	goto	u2177
	clrwdt
opt asmopt_on

	line	62
	
l3483:	
;digital_voltage_interrupt.c: 62: RA4 = 0;
	movlb 0	; select bank0
	bcf	(100/8),(100)&7
	line	63
	
l3485:	
;digital_voltage_interrupt.c: 63: RA5 = 0;
	bcf	(101/8),(101)&7
	line	64
;digital_voltage_interrupt.c: 64: _delay((unsigned long)((100)*(500000/4000.0)));
	opt asmopt_off
movlw	17
movwf	((??_loop+0)+0+1),f
	movlw	58
movwf	((??_loop+0)+0),f
u2187:
	decfsz	((??_loop+0)+0),f
	goto	u2187
	decfsz	((??_loop+0)+0+1),f
	goto	u2187
	clrwdt
opt asmopt_on

	line	67
	
l3487:	
;digital_voltage_interrupt.c: 67: RA4 = 0;
	movlb 0	; select bank0
	bcf	(100/8),(100)&7
	line	68
	
l3489:	
;digital_voltage_interrupt.c: 68: RA5 = 1;
	bsf	(101/8),(101)&7
	line	69
;digital_voltage_interrupt.c: 69: _delay((unsigned long)((100)*(500000/4000.0)));
	opt asmopt_off
movlw	17
movwf	((??_loop+0)+0+1),f
	movlw	58
movwf	((??_loop+0)+0),f
u2197:
	decfsz	((??_loop+0)+0),f
	goto	u2197
	decfsz	((??_loop+0)+0+1),f
	goto	u2197
	clrwdt
opt asmopt_on

	line	74
	
l1156:	
	return
	opt stack 0
GLOBAL	__end_of_loop
	__end_of_loop:
;; =============== function _loop ends ============

	signat	_loop,88
psect	text78,local,class=CODE,delta=2
global __ptext78
__ptext78:
	global	btemp
	btemp set 07Eh

	DABS	1,126,2	;btemp
	global	wtemp0
	wtemp0 set btemp
	end
