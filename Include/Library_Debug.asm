;--------------------------------------------------
; Library debug macro
;--------------------------------------------------

includeonce

;--------------------------------------------------

!Release	= not(defined("DEBUG"))
!Debug		=     defined("DEBUG")

; Set memory access breakpoints in debug builds
; Usage:
;   %BreakPoint()
; Setting emulator memory access breakpoints:
;   Break on:	Read
;   Address:	$FFFFFF
macro	BreakPoint()
if	!Debug
		PHP
		PHA
		LDA	$FFFFFF
		PLA
		PLP
endif
endmacro

; Set memory access breakpoints with ID in debug builds
; Usage:
;   %BreakPointId(1)
; Setting emulator memory access breakpoints:
;   Break on:	Read
;   Address:	$FFFFFF
;   Condition:	a == <id>
macro	BreakPointId(id)
if	!Debug
		PHP
		PHA
		REP	#$20
		LDA.w	#<id>
		SEP	#$20
		LDA	$FFFFFF
		REP	#$20
		PLA
		PLP
endif
endmacro
