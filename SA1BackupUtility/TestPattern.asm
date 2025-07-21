;--------------------------------------------------
; Test pattern
;--------------------------------------------------

includeonce

incsrc	"AssembleRandom.asm"

;--------------------------------------------------

	;skip align 256
MemoryTestIRam:
		;	 0123456789ABCDEF
		db	"SA-1 Backup test"	; 0
		%FillRandom(!TestMemorySize-16)

MemoryTestBwRam:
		;	 0123456789ABCDEF
		db	"SA-1 Backup test"	; 0
		%FillRandom(!TestMemorySize-16)

