;--------------------------------------------------
; Assemble random
; A pseudo-random number calculated at assembly time and embedded in the ROM
;--------------------------------------------------

includeonce

;--------------------------------------------------
; Random

; Usage:
;   %SetAssembleRandomSeed(1234567)	; initialize seed
;   %SetAssembleRandomStep()		; next seed
;   db !AssembleRandom_State		; get random
;   %SetAssembleRandomStep()		; repeat...
;   db !AssembleRandom_State

!AssembleRandom_State		= 1234567
!AssembleRandom_Temporary	= 1

macro	SetAssembleRandomSeed(seed)
	if <seed> == 0
		warn	"The seed value is 0. The pseudo-random numbers may be biased."
	endif
	!AssembleRandom_State	#= <seed>
endmacro

macro	AssembleRandomStep()
	; Xorshift32
	!AssembleRandom_Temporary	#= ((!AssembleRandom_State<<13))&$FFFFFFFF
	!AssembleRandom_Temporary	#= (!AssembleRandom_Temporary^(!AssembleRandom_State>>17))&$FFFFFFFF
	!AssembleRandom_Temporary	#= (!AssembleRandom_Temporary^(!AssembleRandom_State<<5))&$FFFFFFFF
	!AssembleRandom_State		#= (!AssembleRandom_Temporary)
endmacro

; Usage:
;   %FillRandom(16)
macro	FillRandom(length)
	if (<length>) >= 4
		%AssembleRandomStep()
		dd	!AssembleRandom_State
		%FillRandom(((<length>)-4))
	elseif (<length>) >= 3
		%AssembleRandomStep()
		dl	!AssembleRandom_State
	elseif (<length>) >= 2
		%AssembleRandomStep()
		dw	!AssembleRandom_State
	elseif (<length>) >= 1
		%AssembleRandomStep()
		db	!AssembleRandom_State
	endif
endmacro
