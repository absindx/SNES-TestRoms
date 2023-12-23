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

macro ScreenVramAddress(x, y)
		LDX.b	#(ScreenVramAddress($0000, 32, <x>, <y>))
		STX	!PPU_VMADDL
		LDX.b	#(ScreenVramAddress($0000, 32, <x>, <y>)>>8)
		STX	!PPU_VMADDH
endmacro

UpdateScreen:
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00000000			;   Increment at $2118, No remap, Increment 1 word
		STA	!PPU_VMAINC

		; Result
		%ScreenVramAddress($0C, $07)
		LDY.b	#datasize(UpdateScreen_Message_Result)/3
		LDX.b	#(datasize(UpdateScreen_Message_Result)/3)*0
		LDA	!TestFinished
		BEQ	.DrawStatus
		BMI	+
		LDX.b	#(datasize(UpdateScreen_Message_Result)/3)*1
		BRA	.DrawStatus
+		LDX.b	#(datasize(UpdateScreen_Message_Result)/3)*2
.DrawStatus -	LDA	.Message_Result, X
		STA	!PPU_VMDATAL
		INX
		DEY
		BNE	-

		; Result - Version code 1 (SNES $230E VC)
		%ScreenVramAddress($15, $07)
		LDX.b	#'$'
		STX	!PPU_VMDATAL
		LDX	!TestVersionVC
		JSR	DrawHexX

		; Result - Version code 2 (???? $???? ??)
		%ScreenVramAddress($1B, $07)
		LDX.b	#'$'
		STX	!PPU_VMDATAL
		LDX	!TestVersionVCTrue
		JSR	DrawHexX

		; Registers
		;%ScreenVramAddress($13, $0B+Y)
		LDY.b	#$00
.LoopRegistor	REP	#$20
		; .longm, .shortx
		TYA
		;ASL
		ASL
		ASL
		ASL
		ASL
		ADC.w	#($0A*32)+$13
		STA	!PPU_VMADDL
		JSR	DrawMemory
		INY
		INY
		CPY.b	#(!TestMemoryLength*2)
		BCC	.LoopRegistor

		RTS

.Message_Result
		db	"RUNNING"
		db	"PASSED", $0
		db	"FAILED", $0

DrawMemory:
		SEP	#$30
		; .shortm, .shortx
		PHY
		JSR	DrawMemoryValue

		LDA	!PPU_VMDATALREAD		;\
		LDA	!PPU_VMDATALREAD		; | forward 3 tiles
		LDA	!PPU_VMDATALREAD		;/

		TYA
		CLC
		ADC.b	#!TestSa1Register-!TestSnesRegister
		TAY
		JSR	DrawMemoryValue
		PLY
		RTS

DrawMemoryValue:
		LDA	!TestSnesRegister+1, Y
		CMP	!TestSnesRegister+0, Y
		BEQ	.DrawValue
.CheckOpenbus	CMP.b	#!OpenBusValue
		BEQ	.DrawOpenbus

		LDA	!TestSnesRegister+0, Y
.DrawValue	STZ	!PPU_VMDATAL
		LDX.b	#'$'
		STX	!PPU_VMDATAL
		TAX
		JSR	DrawHexX
		RTS

.DrawOpenbus	LDA.b	#'O'
		STA	!PPU_VMDATAL
		LDA.b	#'P'
		STA	!PPU_VMDATAL
		LDA.b	#'E'
		STA	!PPU_VMDATAL
		LDA.b	#'N'
		STA	!PPU_VMDATAL
		RTS



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
		dw	SNESMessage_Boot			; #0
		dw	SNESMessage_NOP				; #1
		dw	SNESMessage_NOP				; #2
		dw	SNESMessage_NOP				; #3
		dw	SNESMessage_NOP				; #4
		dw	SNESMessage_NOP				; #5
		dw	SNESMessage_NOP				; #6
		dw	SNESMessage_NOP				; #7
		dw	SNESMessage_NOP				; #8
		dw	SNESMessage_NOP				; #9
		dw	SNESMessage_NOP				; #10
		dw	SNESMessage_NOP				; #11
		dw	SNESMessage_NOP				; #12
		dw	SNESMessage_NOP				; #13
		dw	SNESMessage_NOP				; #14
		dw	SNESMessage_TestFinished		; #15

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
		SEP	#$30
		; .shortm, .shortx

		%SendSA1Message(!Message_Boot, 1)

		JSR	TestSa1Initialize
		JSR	TestSa1Execute

		; fallthrough

SA1TestFinished:
		SEP	#$30
		; .shortm, .shortx

		%SendSA1Message(!Message_TestFinished, 1)

.InfLoop
		%SendSA1Message(!Message_TestFinished, 0)
		BRA	.InfLoop

SA1ProcessMessage:
		LDA	!SA1_CFR			;\  process message from SNES-CPU
		AND.b	#$0F				;/
		ASL
		TAX

		LDA.b	#$0B				;   IRQ message accepted
		STA	!SA1_SCNT

		JSR	(.MessageTable, X)

		LDA.b	#$0C				;   IRQ message processed
		STA	!SA1_SCNT
		RTS

.MessageTable
		dw	SA1Message_NOP			; #0
		dw	SA1Message_NOP			; #1
		dw	SA1Message_NOP			; #2
		dw	SA1Message_NOP			; #3
		dw	SA1Message_NOP			; #4
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
		JMP	TestSnesExecute

TestSa1Initialize:
		LDX.b	#%00000000			;\  SA-1 CPU clear reset
		STX	!SA1_CCNT			;/  Message = $0
		RTS

TestSnesExecute:
		REP	#$10
		SEP	#$20
		; .shortm, .longx

		LDY.w	#!TestSnesRegister
		JSR	TestReadRegisters

		SEP	#$30
		; .shortm, .shortx
		RTS

TestSa1Execute:
		REP	#$10
		SEP	#$20
		; .shortm, .longx

		;LDA	#%00000010			;\  Arithmetic mode = Cumulative sum
		;STA	!SA1_MCNT			;/  -> MR0-MR4 initialized
		STZ	!SA1_SFR
		STZ	!SA1_VC

		LDY.w	#!TestSa1Register
		JSR	TestReadRegisters

		SEP	#$30
		; .shortm, .shortx
		RTS

TestReadRegisters:
%DefineLocal(Counter, !ScratchMemory+0, 1)
		; .shortm, .longx

		LDA.b	#!TestMemoryLength
		STA	.Counter

		LDX.w	#$0000

.LoopTest	JSR	TestReadRegister
		DEC	.Counter
		BNE	.LoopTest

		RTS

; Argument:
;   X = test target ($2300 offset)
;   Y = output result address
; Effect:
;   X = +1
;   Y = +2
TestReadRegister:
		; .shortm, .longx

		PHX
		LDA	!TestAddress, X
		STA.w	$00, Y
		INY

		REP	#$31
		; .longm, .longx, CLC
		TXA
		ADC.w	#!TestAddress-!OpenBusValue
		TAX

		SEP	#$20
		; .shortm, .longx

		LDA.b	!OpenBusValue, X
		STA.w	$00, Y
		INY

		PLX
		INX

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

CheckResult:
		; .shortm, .shortx

		LDA	!TestSnesVC
		STA	!TestVersionVC

		LDA	!TestSnesVC			; TODO: Check result
		STA	!TestVersionVCTrue


		BRA	.Failed				; TODO: Implements
		INC	!TestFinished
		BRA	.Finish
.Failed		DEC	!TestFinished
.Finish

		RTS


