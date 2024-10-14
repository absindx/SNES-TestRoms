;--------------------------------------------------
; Test routines
;--------------------------------------------------

;--------------------------------------------------
; Library
;--------------------------------------------------

incsrc	"../Include/Library_Macro.asm"
incsrc	"../Include/Library_Debug.asm"
incsrc	"../Include/IOName_Standard.asm"
incsrc	"../Include/IOName_SA1.asm"

incsrc	"RamMap.asm"



;--------------------------------------------------
; Draw result
;--------------------------------------------------

UpdateScreen:
		JSR	UpdateScreen_Result
		JSR	UpdateScreen_Reset
		JSR	UpdateScreen_Registers

		JMP	TransferTilemap_Main

UpdateScreen_Result:
%DefineLocal(index, ScratchMemory+0, 1)

		; .shortm, .shortx
		LDA	!TestFinished			;\
		INC	A				; |
		INC	A				; | (Result + 3) * 8 - (Result + 3) - 1
		INC	A				; |   Halted  = (-2 + 3) * 8 - (-2 + 3) - 1 = $06
		STA	.index				; |   Failed  = (-1 + 3) * 8 - (-1 + 3) - 1 = $0D
		ASL	A				; |   Running = ( 0 + 3) * 8 - ( 0 + 3) - 1 = $14
		ASL	A				; |   Passed  = ( 1 + 3) * 8 - ( 1 + 3) - 1 = $1B
		ASL	A				; |
		SEC					; |
		SBC	.index				; |
		DEC	A				;/
		TAY
		LDX.b	#6
.Copy		LDA	.Message_Result, Y
		STA	ScreenVramAddress(!TilemapBuffer, $20, $0A, $08), X
		DEY
		DEX
		BPL	.Copy
		RTS

.Message_Result
		db	"HALTED", $0	; -2
		db	"FAILED", $0	; -1
		db	"RUNNING"	; +0
		db	"PASSED", $0	; +1

UpdateScreen_Reset:
		; .shortm, .shortx
		LDA	!BootType			;\
		ASL	A				; |
		ASL	A				; | Result * 5 + 4
		;CLC					; |   Power = 0 * 5 + 4 = $04
		ADC	!BootType			; |   Reset = 1 * 5 + 4 = $09
		ADC	#4				;/
		TAY
		LDX.b	#4
.Copy		LDA	.Message_Result, Y
		STA	ScreenVramAddress(!TilemapBuffer, $20, $18, $08), X
		DEY
		DEX
		BPL	.Copy
		RTS

.Message_Result
		db	"POWER"
		db	"RESET"

		dpbase	!WRAM_WMDATA&$FF00
UpdateScreen_Registers:
		; .shortm, .shortx

		PEA	!WRAM_WMDATA&$FF00
		PLD

		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $0B)>>8
		STA	!WRAM_WMADDM
		STZ	!WRAM_WMADDH

		LDX.b	#$00
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $0B)	;\
		STA	!WRAM_WMADDL						; | A
		JSR	WriteBuffer_Word					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $0C)	;\
		STA	!WRAM_WMADDL						; | X
		JSR	WriteBuffer_Word					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $0D)	;\
		STA	!WRAM_WMADDL						; | Y
		JSR	WriteBuffer_Word					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $0E)	;\
		STA	!WRAM_WMADDL						; | S
		JSR	WriteBuffer_Word					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $0F)	;\
		STA	!WRAM_WMADDL						; | P
		JSR	WriteBuffer_Status					;/
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $10)	;\
		STA	!WRAM_WMADDL						; | D
		JSR	WriteBuffer_Word					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $11)	;\
		STA	!WRAM_WMADDL						; | K
		JSR	WriteBuffer_Byte					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $12)	;\
		STA	!WRAM_WMADDL						; | B
		JSR	WriteBuffer_Byte					;/

		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $14)>>8
		STA	!WRAM_WMADDM
		LDX.b	#$10
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $14)	;\
		STA	!WRAM_WMADDL						; | MR0
		JSR	WriteBuffer_Byte					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $15)	;\
		STA	!WRAM_WMADDL						; | MR1
		JSR	WriteBuffer_Byte					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $16)	;\
		STA	!WRAM_WMADDL						; | MR2
		JSR	WriteBuffer_Byte					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $17)	;\
		STA	!WRAM_WMADDL						; | MR3
		JSR	WriteBuffer_Byte					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $18)>>8
		STA	!WRAM_WMADDM
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $18)	;\
		STA	!WRAM_WMADDL						; | MR4
		JSR	WriteBuffer_Byte					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $19)	;\
		STA	!WRAM_WMADDL						; | OF
		JSR	WriteBuffer_Byte					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $1A)	;\
		STA	!WRAM_WMADDL						; | VDPL
		JSR	WriteBuffer_Byte					;/
		LDA.b	#ScreenVramAddress(!TilemapBuffer, $20, $0B, $1B)	;\
		STA	!WRAM_WMADDL						; | VDPH
		JSR	WriteBuffer_Byte					;/

		PEA	$0000
		PLD
		RTS

; Argument:
;   P = shortm, shortx
;   X = register struct offset
;   WMADD  = draw buffer address
; Effect:
;   X = +1
;   WMDATA = draw string
WriteBuffer_Byte:
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDY	!TestRegisterRst+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | RST.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/

		LDA	!WRAM_WMDATA			;   dummy - separator
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDY	!TestRegisterJmp+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | JMP.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/

		LDA	!WRAM_WMDATA			;   dummy - separator
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDY	!TestRegisterWai+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | WAI.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/

		LDA	!WRAM_WMDATA			;   dummy - separator
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDA	!WRAM_WMDATA			;   dummy - blank
		LDY	!TestRegisterStp+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | STP.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/

		INX

		RTS

; Argument:
;   P = shortm, shortx
;   X = register struct offset
;   WMADD  = draw buffer address
; Effect:
;   X = +2
;   WMDATA = draw string
WriteBuffer_Word:
		LDY	!TestRegisterRst+1, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | RST.H
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/
		LDY	!TestRegisterRst+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | RST.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/

		LDA	!WRAM_WMDATA			;   dummy - separator
		LDY	!TestRegisterJmp+1, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | JMP.H
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/
		LDY	!TestRegisterJmp+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | JMP.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/

		LDA	!WRAM_WMDATA			;   dummy - separator
		LDY	!TestRegisterWai+1, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | WAI.H
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/
		LDY	!TestRegisterWai+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | WAI.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/

		LDA	!WRAM_WMDATA			;   dummy - separator
		LDY	!TestRegisterStp+1, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | STP.H
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/
		LDY	!TestRegisterStp+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | STP.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/

		INX
		INX

		RTS

; Argument:
;   P = shortm, shortx
;   X = register struct offset
;   WMADD  = draw buffer address
; Effect:
;   X = +2
;   WMDATA = draw string
WriteBuffer_Status:
		LDY	!TestRegisterRst+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | RST.P.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/
		LDA	!WRAM_WMDATA			;   dummy - conmma
		LDY	!TestRegisterRst+1, X		;\
		CPY	#$02				; | RST.P.H(e)
		BCC	+				; |
		LDY.b	#$02				; |
+		LDA	.StatusFlag, Y			; |
		STA	!WRAM_WMDATA			;/


		LDA	!WRAM_WMDATA			;   dummy - separator
		LDY	!TestRegisterJmp+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | JMP.P.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/
		LDA	!WRAM_WMDATA			;   dummy - conmma
		LDY	!TestRegisterJmp+1, X		;\
		CPY	#$02				; | JMP.P.H(e)
		BCC	+				; |
		LDY.b	#$02				; |
+		LDA	.StatusFlag, Y			; |
		STA	!WRAM_WMDATA			;/

		LDA	!WRAM_WMDATA			;   dummy - separator
		LDY	!TestRegisterWai+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | WAI.P.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/
		LDA	!WRAM_WMDATA			;   dummy - conmma
		LDY	!TestRegisterWai+1, X		;\
		CPY	#$02				; | WAI.P.H(e)
		BCC	+				; |
		LDY.b	#$02				; |
+		LDA	.StatusFlag, Y			; |
		STA	!WRAM_WMDATA			;/

		LDA	!WRAM_WMDATA			;   dummy - separator
		LDY	!TestRegisterStp+0, X		;\
		LDA	HexAsciiHighNibble, Y		; |
		STA	!WRAM_WMDATA			; | STP.P.L
		LDA	HexAsciiLowNibble, Y		; |
		STA	!WRAM_WMDATA			;/
		LDA	!WRAM_WMDATA			;   dummy - conmma
		LDY	!TestRegisterStp+1, X		;\
		CPY	#$02				; | STP.P.H(e)
		BCC	+				; |
		LDY.b	#$02				; |
+		LDA	.StatusFlag, Y			; |
		STA	!WRAM_WMDATA			;/

		INX
		INX

		RTS

.StatusFlag
		db	'N', 'E', '?'

		dpbase	$0000



;--------------------------------------------------
; SNES routines
;--------------------------------------------------

InitializeSA1:
		REP	#$20
		SEP	#$10
		; longm, .shortx

		LDA.w	#SA1RESET			;\  reset vector address
		STA	!SA1_CRVL			;/
		LDA.w	#SA1NMI				;\  NMI vector address
		STA	!SA1_CNVL			;/
		LDA.w	#SA1IRQ				;\  IRQ vector address
		STA	!SA1_CIVL			;/

		; Super MMC mapping (use default setting)
		; ADDR : ROM     => Setting
		; $Cx  : $00-$0F => $00
		; $Dx  : $10-$1F => $01
		; $Ex  : $20-$2F => $02
		; $Fx  : $30-$3F => $03

		; SNES BW-RAM mapping (use default setting)
		; ADDR        : BW-RAM      => Setting
		; $6000-$7FFF : $0000-$1FFF => $00

		; SA-1 BW-RAM mapping (use default setting)
		; ADDR        : BW-RAM      => Setting
		; $6000-$7FFF : $0000-$1FFF => $00

		LDX.b	#%10000000			;\  enable SA-1 to SNES IRQ
		STX	!SA1_SIE			;/

		LDX.b	#$80				;\  unlock BW-RAM protection from SNES-CPU
		STX	!SA1_SBWE			;/
		LDX.b	#$FF				;\  unlock I-RAM protection from SNES-CPU
		STX	!SA1_SIWP			;/

		JSR	ClearIRam

		RTS

SNESProcessMessage:
		; .shortm, .shortx

		STA	!Sa1MessageType
		ASL
		TAX
		JMP	(.MessageTable, X)

.MessageTable
		dw	SNESMessage_Boot		; #0
		dw	SNESMessage_NOP			; #1
		dw	SNESMessage_NOP			; #2
		dw	SNESMessage_NOP			; #3
		dw	SNESMessage_NOP			; #4
		dw	SNESMessage_NOP			; #5
		dw	SNESMessage_NOP			; #6
		dw	SNESMessage_NOP			; #7
		dw	SNESMessage_NOP			; #8
		dw	SNESMessage_NOP			; #9
		dw	SNESMessage_NOP			; #10
		dw	SNESMessage_NOP			; #11
		dw	SNESMessage_NOP			; #12
		dw	SNESMessage_NOP			; #13
		dw	SNESMessage_NOP			; #14
		dw	SNESMessage_TestFinished	; #15

SNESMessage_NOP:
		RTS

SNESMessage_Boot:
		RTS

SNESMessage_TestFinished:
		LDA.b	#%00000000			;\  disable SA-1 to SNES IRQ
		STA	!SA1_SIE			;/

		JMP	CheckResult



;--------------------------------------------------
; SA-1 routines
;--------------------------------------------------

macro	SendSA1Message(messageType, irq)
		; .shortm
		LDA.b	#(<irq><<7)+(<messageType>&$0F)
		STA	!SA1_SCNT
endmacro

!Message_Boot		= 0
!Message_TestFinished	= 15

SA1TestMain:
		;JMP	SA1ProcessMessage

SA1ProcessMessage:
		LDA	!SA1_CFR			;\  process message from SNES-CPU
		AND.b	#$0F				;/
		ASL
		TAX

		LDA.b	#(%01000000|$01)		;   IRQ message accepted
		STA	!SA1_SCNT

		JSR	(.MessageTable, X)

		LDA.b	#(%01000000|$00)		;   IRQ message processed
		STA	!SA1_SCNT
		RTS

.MessageTable
		dw	SA1Message_NOP			; #0
		dw	WaitSa1_JMP			; #1
		dw	WaitSa1_WAI			; #2
		dw	WaitSa1_STP			; #3
		dw	WaitSa1_STP			; #4
		dw	SA1Message_NOP			; #5
		dw	SA1Message_NOP			; #6
		dw	SA1Message_NOP			; #7
		dw	SA1Message_NOP			; #8
		dw	SA1Message_NOP			; #9
		dw	SA1Message_NOP			; #10
		dw	SA1Message_NOP			; #11
		dw	SA1Message_NOP			; #12
		dw	SA1Message_NOP			; #13
		dw	SA1Message_NOP			; #14
		dw	SA1Message_NOP			; #15

SA1Message_NOP:
		RTS



;--------------------------------------------------
; Test routines
;--------------------------------------------------

TestSnesInitialize:
		JSR	DetectReset
		;JMP	TestSnesExecute

;TestSa1Initialize:
;		LDX.b	#%00000000			;\  SA-1 CPU clear reset
;		STX	!SA1_CCNT			;/  Message = $0
;		RTS

TestSnesExecute:
		JSR	ScreenOn
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#!Sa1TestRst			;\  test RST
		JSR	TestSa1Pattern			;/

		LDA.b	#!Sa1TestJmp			;\  test JMP
		JSR	TestSa1Pattern			;/

		LDA.b	#!Sa1TestWai			;\  test WAI
		JSR	TestSa1Pattern			;/

		LDA.b	#!Sa1TestStp			;\  test STP
		JSR	TestSa1Pattern			;/

		JMP	CheckResult

TestSa1Pattern:
		; .shortm, .shortx

		LDX	!TestFinished
		BEQ	.Exec
		RTS
.Exec

		JSR	ClearTestMemory
		;ORA.b	#%00000000			;\  SA-1 CPU clear reset
		STA	!SA1_CCNT			;/

		INC	A				;\
		ASL					; | Y = (A + 1) * $20 - 1
		ASL					; |   (RST) A = $01 -> Y = $3F
		ASL					; |   (JMP) A = $02 -> Y = $5F
		ASL					; |   (WAI) A = $03 -> Y = $7F
		ASL					; |   (STP) A = $04 -> Y = $9F
		DEC	A				; |
		DEC	A				; |
		TAY					;/
		LDX.b	#!TestRegisterTmp-2

		STZ	AliveCounter
.Wait		LDA	!TestSa1Waiting			;   wait SA-1 response
		BEQ	.Wait
		STZ	AliveCounter

		LDA	$00FFEE				;   IRQ vector address(low) -> additional message byte
		STA	!TestRegisterTmp_AL

		;LDA.b	#%01000000			;\  pause SA-1 cpu
		LDA.b	#%00100000			;\  stop SA-1 cpu
		STA	!SA1_CCNT			;/

		REP	#$20
		; .longm, .shortx
.Copy		LDA	!TestRegisterTmp, X
		STA	!TestRegisterTmp, Y
		DEY
		DEY
		DEX
		DEX
		BPL	.Copy

		SEP	#$30
		RTS

ClearTestMemory:
		PHA
		PHP
		REP	#$20
		SEP	#$10
		; .longm, .shortx
		LDX.b	#(!TestRegisterTmp+!TestRegisterSize-2)
-		STZ	!TestSa1StatusTemporary, X
		DEX
		DEX
		BPL	-
		LDA.w	#$BBAA
		STA	!TestSa1MemoryLengthTest
		PLP
		PLA
		RTS

ClearIRam:
		PHP
		REP	#$20
		SEP	#$10
		; .longm, .shortx

		LDX.b	#$00
.Loop		STZ	!SA1_IRamImage+$000, X
		STZ	!SA1_IRamImage+$100, X
		STZ	!SA1_IRamImage+$200, X
		STZ	!SA1_IRamImage+$300, X
		STZ	!SA1_IRamImage+$400, X
		STZ	!SA1_IRamImage+$500, X
		STZ	!SA1_IRamImage+$600, X
		STZ	!SA1_IRamImage+$700, X
		INX
		INX
		BNE	.Loop

		PLP
		RTS

macro	PatchTilemapByte(y, value)
		org	Tilemap_Main+(<y>*$20)+7
		%DataAsciiHex(<value>, 2, Zero)
endmacro
macro	PatchTilemapWord(y, value)
		org	Tilemap_Main+(<y>*$20)+5
		%DataAsciiHex(<value>, 4, Zero)
endmacro
macro	PatchTilemapStatus(y, flags, emulation)
		org	Tilemap_Main+(<y>*$20)+5
		%DataAsciiHex(<flags>, 2, Zero)
		db	','
		if <emulation> == 0
		db	'N'
		else
		db	'E'
		endif
endmacro

		pushpc
		%PatchTilemapWord($0B, $AABB)		; A
		%PatchTilemapWord($0C, $CCDD)		; X
		%PatchTilemapWord($0D, $EEFF)		; Y
		%PatchTilemapWord($0E, $1234)		; S
		%PatchTilemapStatus($0F, $CB, 0)	; P
		%PatchTilemapWord($10, $5678)		; D
		%PatchTilemapByte($11, $80)		; K
		%PatchTilemapByte($12, $88)		; B
		%PatchTilemapByte($14, $11)		; MR1
		%PatchTilemapByte($15, $22)		; MR2
		%PatchTilemapByte($16, $33)		; MR3
		%PatchTilemapByte($17, $44)		; MR4
		%PatchTilemapByte($18, $55)		; MR5
		%PatchTilemapByte($19, $00)		; OF
		%PatchTilemapByte($1A, $66)		; VDPL
		%PatchTilemapByte($1B, $77)		; VDPH
		pullpc

macro	WaitSa1()
?WaitSa1:
		REP	#$30
		; .longm, .longx

		JSR	SetCumulativeSum

		; A = $AABB
		; X = $CCDD
		; Y = $EEFF
		; S = $1234
		; P = $CB	; NVmxDiZCe
		; D = $5678
		; K = $80
		; B = $88

		JML	?.SetPBR|$800000
?.SetPBR
		PEA	$FF88
		PLB
		LDX.w	#$1234
		TXS
		LDA.w	#$5678
		TCD

		LDA.w	#$AABB
		LDX.w	#$CCDD
		LDY.w	#$EEFF

		;	  NVmxDiZC
		REP	#%00110100
		SEP	#%11001011

		STA.l	!TestSa1Waiting

endmacro

WaitSa1_JMP:
		%WaitSa1()
.InfLoop	JMP	.InfLoop

WaitSa1_WAI:
		%WaitSa1()
		WAI

WaitSa1_STP:
		%WaitSa1()
		STP

SetCumulativeSum:
		; MR1  = $11
		; MR2  = $22
		; MR3  = $33
		; MR4  = $44
		; MR5  = $55
		; OF   = $00
		; VDPL = $00
		; VDPH = $00

		PHP
		SEP	#$20
		; .shortx, .longx

		LDA.b	#%00000010			;   cumulative sum
		STA	!SA1_MCNT

		; set cumulative = 0x5544332211
		; 0x7FFF * 0x7FFF * 0x0155
		; => + 0x553EAB0155 (remaining: 0x00058820BC)
		;
		; 0x7FFF * 0x0B10
		; => + 0x000587F4F0 (remaining: 0x0000002BCC)
		;
		; 0x2BCC * 0x0001
		; => + 0x0000002BCC
		LDX.w	#$0155-1
		LDY.w	#$7FFF
		STY	!SA1_MAL
.Mr4		STY	!SA1_MBL			; 5 (3+2) = 8
		DEX					; 2
		BPL	.Mr4				; 3/2
		LDY.w	#$0B10				; 3
		STY	!SA1_MBL			; 5 (3+2) = 11
		LDY.w	#$2BCC				; 3
		STY	!SA1_MAL			; 5 (3+2) = 6
		LDY.w	#$0001
		STY	!SA1_MBL

		; VDP
!VdpTarget	= .VdpValue+6
		LDA.b	#$00				; fixed, 16bit read
		STA	!SA1_VBD
		LDX.w	#!VdpTarget			;\
		STX	!SA1_VDAL			; | VDA = .VdpValue + 6
		LDA.b	#!VdpTarget>>16			; |
		STA	!SA1_VDAB			;/

		PLP

		RTS

		skip align 2
.VdpValue
		db	$00, $11, $22, $33, $44, $55, $66, $77
		db	$88, $99, $AA, $BB, $CC, $DD, $EE, $FF


DetectReset:
		SEP	#$30
		; .shortm, .shortx

		LDX.b	#!ResetSignatureLength-1
.LoopCheck	LDA	.RomResetSignature, X
		CMP	!ResetSignature, X
		BNE	.CheckBreak
		DEX
		BPL	.LoopCheck
		LDA.b	#$01
		BRA	.CheckEnd
.CheckBreak	LDA.b	#$00
.CheckEnd	STA	!BootType

		LDX.b	#!ResetSignatureLength-1
.LoopCopy	LDA	.RomResetSignature, X
		STA	!ResetSignature, X
		DEX
		BPL	.LoopCopy

		RTS

.RomResetSignature
		skip	!ResetSignatureLength
		pushpc
		org	.RomResetSignature
		;	 0123456789ABCDEF
		db	"SA-1 REBOOT TEST"
		pullpc

CheckResult:
		SEP	#$70
		; .shortm, .shortx, SEV

		LDA	!BootType						;\
		BNE	.BootReset						; | RST
.BootPower	LDX.b	#ExpectedRegisters_Power-ExpectedRegisters_Start	; |
		BRA	.BootActual						; |
.BootReset	LDX.b	#ExpectedRegisters_Reset-ExpectedRegisters_Start	; |
.BootActual	LDY.b	#!TestRegisterRst-!TestRegisterTmp			; |
		JSR	CompareRegisterResult					;/

		LDX.b	#ExpectedRegisters_Reboot-ExpectedRegisters_Start	;\
		LDY.b	#!TestRegisterJmp-!TestRegisterTmp			; | JMP
		JSR	CompareRegisterResult					;/

		LDX.b	#ExpectedRegisters_Reboot-ExpectedRegisters_Start	;\
		LDY.b	#!TestRegisterWai-!TestRegisterTmp			; | WAI
		JSR	CompareRegisterResult					;/

		LDX.b	#ExpectedRegisters_Reboot-ExpectedRegisters_Start	;\
		LDY.b	#!TestRegisterStp-!TestRegisterTmp			; | STP
		JSR	CompareRegisterResult					;/


		BVC	.Failed

.Passed		LDA.b	#!TestFinished_Passed
		STA	!TestFinished
		RTS

.Failed		LDA.b	#!TestFinished_Failed
		STA	!TestFinished
		RTS

; Argument:
;   P = shortm, shortx
;   X = expected registers (ROM), ExpectedRegisters_Start offset
;   Y = actual registers (RAM), !TestRegisterTmp offset
; Effect:
;   X = +32
;   Y = +32
;   P.V = check result (0=failed, 1=passed)
CompareRegisterResult:
!ExpectedRegistersLength	= $20
%DefineLocal(counter, ScratchMemory+0, 1)

		LDA.b	#!ExpectedRegistersLength-1
		STA	.counter

.Loop		LDA	!TestRegisterTmp, Y
		EOR	ExpectedRegisters_Start, X
		AND	ExpectedRegisters_Start+!ExpectedRegistersLength, X
		BEQ	.Equal
.NotEqual	CLV
.Equal		INX
		INY
		DEC	.counter
		BPL	.Loop

		RTS


	fillbyte	$00
macro	ExpectedRegisters(a, x, y, s, p, d, k, b, mr1, mr2, mr3, mr4, mr5, of, vdp)
	dw	<a>	; +$00
	dw	<x>	; +$02
	dw	<y>	; +$04
	dw	<s>	; +$06
	dw	<p>	; +$08 +0=P, +1=E
	dw	<d>	; +$0A
	db	<k>	; +$0C
	db	<b>	; +$0D
	fill	align 16
	db	<mr1>	; +$10
	db	<mr2>	; +$11
	db	<mr3>	; +$12
	db	<mr4>	; +$13
	db	<mr5>	; +$14
	db	<of>	; +$15
	dw	<vdp>	; +$16
	fill	align 16
endmacro

; NOTE: No strict checking.
;       This is because there are registers whose values are indeterminate for electrical reasons.

	skip align !ExpectedRegistersLength
ExpectedRegisters_Start:
ExpectedRegisters_Power:	; RST(Power)
	;                  A,     X,     Y,     S,     P,     D,     K,   B,   MR1, MR2, MR3, MR4, MR5, OF,  VDP
	%ExpectedRegisters($0000, $0000, $0000, $01FD, $0134, $0000, $00, $00, $FF, $FF, $00, $80, $00, $00, $0000)	; values
	%ExpectedRegisters($FFFF, $FFFF, $FFFF, $FF00, $01FF, $FFFF, $FF, $FF, $00, $00, $00, $00, $00, $00, $0000)	; masks

ExpectedRegisters_Reset:	; RST(Reset)
	;                  A,     X,     Y,     S,     P,     D,     K,   B,   MR1, MR2, MR3, MR4, MR5, OF,  VDP
	%ExpectedRegisters($AABB, $00DD, $00FF, $0134, $01F7, $0000, $00, $00, $00, $00, $00, $00, $00, $00, $7766)	; values
	%ExpectedRegisters($FFFF, $FFFF, $FFFF, $FFF0, $01FF, $FFFF, $FF, $FF, $00, $00, $00, $00, $00, $00, $FFFF)	; masks

ExpectedRegisters_Reboot:	; JMP, WAI, STP
	;                  A,     X,     Y,     S,     P,     D,     K,   B,   MR1, MR2, MR3, MR4, MR5, OF,  VDP
	%ExpectedRegisters($AABB, $00DD, $00FF, $0134, $01F7, $0000, $00, $00, $11, $22, $33, $44, $55, $00, $7766)	; values
	%ExpectedRegisters($FFFF, $FFFF, $FFFF, $FFF0, $01FF, $FFFF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FFFF)	; masks


