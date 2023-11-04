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

;--------------------------------------------------

function ScreenVramAddress(base, w, x, y)	= (base+((w*y)+x))

function MakeWordColor(r, g, b)			= (((r&$1F))|((g&$1F)<<5)|((b&$1F)<<10))


