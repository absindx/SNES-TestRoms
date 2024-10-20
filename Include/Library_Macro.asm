;--------------------------------------------------
; Library macro
;--------------------------------------------------

includeonce

;--------------------------------------------------
; Define

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

;--------------------------------------------------
; Data byte

function	NumberToAscii(value)	= select(less(value, 10), $30, $37)+value

!DataAsciiNumber_PadType_Zero	= 0
!DataAsciiNumber_PadType_Right	= 1
!DataAsciiNumber_PadType_Left	= 2
!DataAsciiNumber_PadType_None	= 3

macro	DataAsciiBase(value, base, digit, padtype)
	if     !DataAsciiNumber_PadType_<padtype> == !DataAsciiNumber_PadType_Zero
		db	NumberToAscii((<value>/(<base>**(<digit>-1)))%<base>)
		if (<digit>-1) > 0
			%DataAsciiBase(<value>, <base>, (<digit>-1), <padtype>)
		endif
	elseif !DataAsciiNumber_PadType_<padtype> == !DataAsciiNumber_PadType_Right
		if (<digit>-1) == 0 || <value> > (<base>**(<digit>-1))
			db	NumberToAscii((<value>/(<base>**(<digit>-1)))%<base>)
		else
			db	" "
		endif
		if (<digit>-1) > 0
			%DataAsciiBase(<value>, <base>, (<digit>-1), <padtype>)
		endif
	elseif !DataAsciiNumber_PadType_<padtype> == !DataAsciiNumber_PadType_Left
		if (<digit>-1) == 0 || <value> > (<base>**(<digit>-1))
			db	NumberToAscii((<value>/(<base>**(<digit>-1)))%<base>)
		endif
		if (<digit>-1) > 0
			%DataAsciiBase(<value>, <base>, (<digit>-1), <padtype>)
		endif
		if (<digit>-1) == 0 || <value> > (<base>**(<digit>-1))
			; none
		else
			db	" "
		endif
	else
		if (<digit>-1) == 0 || <value> > (<base>**(<digit>-1))
			db	NumberToAscii((<value>/(<base>**(<digit>-1)))%<base>)
		endif
		if (<digit>-1) > 0
			%DataAsciiBase(<value>, <base>, (<digit>-1), <padtype>)
		endif
	endif
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
macro	DataAsciiNumber(value, digit, padtype)
	%DataAsciiBase(<value>, 10, <digit>, <padtype>)
endmacro

; Usage:
;   %DataAsciiHex(123, 4, Zero)
;   ; -> db $30, $30, $37, $42		; "007B"
;   %DataAsciiHex(123, 4, Right)
;   ; -> db $20, $20, $37, $42		; "  7B"
;   %DataAsciiHex(123, 4, Left)
;   ; -> db $37, $42			; "7B  "
;   %DataAsciiHex(123, 4, None)
;   ; -> db $37, $42			; "7B"
; NOTE: Negative numbers not supported.
macro	DataAsciiHex(value, digit, padtype)
	%DataAsciiBase(<value>, 16, <digit>, <padtype>)
endmacro

; Usage:
;   %CRLF(1, 1)
;   ; -> db $0D, $0A		; <CR>, <LF>
;   %CRLF(2, 2)
;   ; -> db $0D, $0A, $0D, $0A	; <CR>, <LF>, <CR>, <LF>
;   %CRLF(2, 1)
;   ; -> db $0D, $0A, $0D	; <CR>, <LF>, <CR>
;   %CRLF(2, 0)
;   ; -> db $0D, $0D		; <CR>, <CR>
macro	CRLF(crCount, lfCount)
	if	<crCount> > 0
		db	$0D
	endif
	if	<lfCount> > 0
		db	$0A
	endif
	if	<crCount> > 0 || <lfCount> > 0
		%CRLF((<crCount>-1), (<lfCount>-1))
	endif

endmacro

; Usage:
;   %NewLine(CRLF, 1)
;   ; -> db $0D, $0A		; <CR>, <LF>
;   %NewLine(CRLF, 2)
;   ; -> db $0D, $0A, $0D, $0A	; <CR>, <LF>, <CR>, <LF>
;   %NewLine(CR, 2)
;   ; -> db $0D, $0D		; <CR>, <CR>
;   %NewLine(LF, 2)
;   ; -> db $0A, $0A		; <LF>, <LF>
!NewLine_CRLF	= 0
!NewLine_CR	= 1
!NewLine_LF	= 2
macro	NewLine(type, count)
	if     !NewLine_<type> == !NewLine_CR
		%CRLF(<count>, 0)
	elseif !NewLine_<type> == !NewLine_LF
		%CRLF(0, <count>)
	else   ;!NewLine_<type> == !NewLine_CRLF
		%CRLF(<count>, <count>)
	endif
endmacro

;--------------------------------------------------
; Functions

function ScreenVramAddress(base, w, x, y)	= (base+((w*y)+x))

function MakeWordColor(r, g, b)			= (((r&$1F))|((g&$1F)<<5)|((b&$1F)<<10))


