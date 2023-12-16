;--------------------------------------------------
; Library macro
;--------------------------------------------------

includeonce

;--------------------------------------------------
; System

; Usage:
;   %DefineRam(ScratchMemory, $0000, 16)
;   LDA.b	!ScratchMemory	; $00
macro	DefineRam(name, addr, size)
	pushpc
	org <addr>
	<name>:		skip <size>
	!<name>		= <name>
	pullpc
endmacro
; Usage:
;   org $0100
;   %DefineRamNext(ptr1, 2)
;   %DefineRamNext(ptr2, 2)
;   LDA.b	ptr1		; $0100
;   LDA.b	ptr1L		; $0100
;   LDA.b	ptr1H		; $0101
;   LDA.b	ptr2		; $0102
;   LDA.b	ptr2L		; $0102
;   LDA.b	ptr2H		; $0103
macro	DefineRamNext(name, size)
	<name>:		skip <size>
	!<name>		= <name>
	if <size> == 2
		%DefineWord(<name>)
	endif
	if <size> == 3
		%DefineLong(<name>)
	endif
endmacro

; Usage:
;   !WordVariable	= $0100
;   %DefineWord(WordVariable)
;   LDA.b	!WordVariableL	; $0100
;   LDX.b	!WordVariableH	; $0101
macro	DefineWord(name)
	%DefineRam(<name>L, !<name>,   1)
	%DefineRam(<name>H, !<name>+1, 1)
endmacro

; Usage:
;   !LongVariable	= $010000
;   %DefineLong(LongVariable)
;   LDA.b	!LongVariableL	; $010000
;   LDX.b	!LongVariableH	; $010001
;   LDY.b	!LongVariableB	; $010002
macro	DefineLong(name)
	%DefineRam(<name>L, !<name>,   1)
	%DefineRam(<name>H, !<name>+1, 1)
	%DefineRam(<name>B, !<name>+2, 1)
endmacro

; Usage:
;   %DefineLocal(Temp, !ScratchMemory+0, 1)
;   LDA.b	.Temp	; $00
macro	DefineLocal(name, addr, size)
	pushpc
	org <addr>
	.<name>	skip <size>
	pullpc
endmacro

; Usage:
;   %DataAsciiNumber(123, 5, Zero)
;   ; -> db $30, $30, $31, $32, $33	; "00123"
;   %DataAsciiNumber(123, 5, Right)
;   ; -> db $20, $20, $31, $32, $33	; "  123"
;   %DataAsciiNumber(123, 5, Left)
;   ; -> db $31, $32, $33, $20, $20	; "123  "
;   %DataAsciiNumber(123, 5, None)
;   ; -> db $31, $32, $33		; "123"
; NOTE: Negative numbers not supported.
!DataAsciiNumber_PadType_Zero	= 0
!DataAsciiNumber_PadType_Right	= 1
!DataAsciiNumber_PadType_Left	= 2
!DataAsciiNumber_PadType_None	= 3
macro	DataAsciiNumber(value, digit, padtype)
	if     !DataAsciiNumber_PadType_<padtype> == !DataAsciiNumber_PadType_Zero
		db	$30+((<value>/(10**(<digit>-1)))%10)
		if (<digit>-1) > 0
			%DataAsciiNumber(<value>, (<digit>-1), <padtype>)
		endif
	elseif !DataAsciiNumber_PadType_<padtype> == !DataAsciiNumber_PadType_Right
		if (<digit>-1) == 0 || <value> > (10**(<digit>-1))
			db	$30+((<value>/(10**(<digit>-1)))%10)
		else
			db	" "
		endif
		if (<digit>-1) > 0
			%DataAsciiNumber(<value>, (<digit>-1), <padtype>)
		endif
	elseif !DataAsciiNumber_PadType_<padtype> == !DataAsciiNumber_PadType_Left
		if (<digit>-1) == 0 || <value> > (10**(<digit>-1))
			db	$30+((<value>/(10**(<digit>-1)))%10)
		endif
		if (<digit>-1) > 0
			%DataAsciiNumber(<value>, (<digit>-1), <padtype>)
		endif
		if (<digit>-1) == 0 || <value> > (10**(<digit>-1))
			; none
		else
			db	" "
		endif
	else
		if (<digit>-1) == 0 || <value> > (10**(<digit>-1))
			db	$30+((<value>/(10**(<digit>-1)))%10)
		endif
		if (<digit>-1) > 0
			%DataAsciiNumber(<value>, (<digit>-1), <padtype>)
		endif
	endif

endmacro

;--------------------------------------------------

function ScreenVramAddress(base, w, x, y)	= (base+((w*y)+x))

function MakeWordColor(r, g, b)			= (((r&$1F))|((g&$1F)<<5)|((b&$1F)<<10))


