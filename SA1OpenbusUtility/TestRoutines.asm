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
;		SEP	#$30
;		; .shortm, .shortx

		JSR	WriteMemoryLines
		JMP	TransferTilemap_Main

WriteMemoryLines:
		REP	#$30
		; .longm, .longx

		LDA.w	#(!TestAddressCount-1)
		STA	!ScratchMemory+0
		LDX.w	#(!TilemapBuffer+(10*32+$0C))
		LDY.w	#0

.RowLoop
		JSR	WriteMemoryValue
		TXA
		ADC.w	#5
		TAX

		JSR	WriteMemoryValue
		TXA
		ADC.w	#6
		TAX

		JSR	WriteMemoryValue
		TXA
		ADC.w	#5
		TAX

		JSR	WriteMemoryValue
		TXA
		ADC.w	#16
		TAX

		DEC	!ScratchMemory+0
		BPL	.RowLoop
		RTS

; Argument:
;   X = output memory offset
;   Y = input memory address
; Effect:
;   Y = +1
WriteMemoryValue:
		SEP	#$20
		; .shortm, .longx
		PHY
		TDC
		LDA	!TestAddressResult, Y
		TAY
		LDA	HexAsciiLowNibble, Y
		XBA
		LDA	HexAsciiHighNibble, Y
		REP	#$21
		; .longm, .longx, CLC
		STA	$00, X
		PLY
		INY
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
		JSR	ClearBwRam

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

		LDA.b	#$01
		STA	!TestFinished

		RTS



;--------------------------------------------------
; SA-1 routines
;--------------------------------------------------

macro	SetSa1Databus(value)
		LDA.b	#<value>
		;STA.l	$400000
		STA.l	$400006
		STA.l	$400006
		LDA.l	$000800	; dummy read
endmacro

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

	skip align	$40
incsrc	"TestPattern.asm"


TestSnesInitialize:
		; set address list to tilemap buffer
		REP	#$10
		SEP	#$20
		; .shortm, .longx

		LDA.b	#(!TestAddressCount-1)
		STA	!ScratchMemory+0
		LDY.w	#TestAddressList
		STY	!ScratchMemory+1
		LDX.w	#(10*32+3)

.SetRow
		TDC

		LDY.w	#2
		LDA	(!ScratchMemory+1), Y
		TAY
		LDA	HexAsciiHighNibble, Y
		STA	!TilemapBuffer+0, X
		LDA	HexAsciiLowNibble, Y
		STA	!TilemapBuffer+1, X

		LDY.w	#1
		LDA	(!ScratchMemory+1), Y
		TAY
		LDA	HexAsciiHighNibble, Y
		STA	!TilemapBuffer+2, X
		LDA	HexAsciiLowNibble, Y
		STA	!TilemapBuffer+3, X

		LDY.w	#0
		LDA	(!ScratchMemory+1), Y
		TAY
		LDA	HexAsciiHighNibble, Y
		STA	!TilemapBuffer+4, X
		LDA	HexAsciiLowNibble, Y
		STA	!TilemapBuffer+5, X

		REP	#$21
		; .longm, .longx, CLC
		TXA
		ADC.w	#$20
		TAX
		SEP	#$20
		; .shortm, .longx
		LDA	!ScratchMemory+1
		ADC	#3
		STA	!ScratchMemory+1
		DEC	!ScratchMemory+0
		BPL	.SetRow

		STZ	!TestFinished
		RTS

TestSa1Initialize:
		SEP	#$10
		; .shortx
		LDX.b	#%00000000			;\  SA-1 CPU clear reset
		STX	!SA1_CCNT			;/  Message = $0
		RTS

StopSa1:
		SEP	#$10
		; .shortx
		LDX.b	#%00100000			;\  SA-1 CPU reset
		STX	!SA1_CCNT			;/  Message = $0
		RTS

TestSnesExecute:
		REP	#$20
		; .longm, .shortx
		LDA.w	#TestAddressResult
		STA	!TestResultPointer

		JMP	TestExecute

TestSa1Execute:
		REP	#$20
		; .longm, .shortx
		LDA.w	#TestAddressResult+2
		STA	!TestResultPointer

		LDX.b	#!TestBitmapMode
		STA	!SA1_BBF

		JMP	TestExecute

TestExecute:
		SEP	#$30
		; .shortm, .shortx

		TDC
		STZ	!TestResultPointerB
		STZ	!TestAccessPointerL
		LDA.b	#!SnesOpenBusValue
		STA	!TestAccessPointerH
		STZ	!TestExecuteCounter

		REP	#$10
		; .shortm, .longx

.LoopTest
		LDA	!TestExecuteCounter
		ASL	A				;   CLC
		ADC	!TestExecuteCounter
		TAX
		LDA	TestAddressList+0, X		;\
		STA	!TestAddressPointerL		; |
		LDA	TestAddressList+1, X		; | copy pointer
		STA	!TestAddressPointerH		; |
		LDA	TestAddressList+2, X		; |
		STA	!TestAddressPointerB		;/

		JSR	TestAddressRead

		LDA	!TestExecuteCounter
		INC	A
		STA	!TestExecuteCounter
		CMP.b	#!TestAddressCount
		BCC	.LoopTest

		RTS

; Argument:
;   !TestAddressPointer
;   !TestResultPointer
;   !TestAccessPointer = #$AA00
; Effect:
;   !TestResultPointer = +4
;   !TestCalculatePointer
TestAddressRead:
		; .shortm, .longx
		PHB

		SEC					;\
		LDA	!TestAddressPointerL		; |
		SBC.b	#$00				; | ScratchMemory[6-8] = ScratchMemory[0-2] - #$00AA00
		STA	!TestCalculatePointerL		; |
		LDA	!TestAddressPointerH		; |
		SBC.b	#!SnesOpenBusValue		; |
		STA	!TestCalculatePointerH		; |
		LDA	!TestAddressPointerB		; |
		SBC.b	#$00				; |
		STA	!TestCalculatePointerB		;/

		LDY	!TestCalculatePointer

		%SetSa1Databus(!Sa1OpenBusValue1)
		LDA	!TestAddressPointerB
		PHA
		PLB
		LDA	(!TestAddressPointer)
		STA	[!TestResultPointer]
		INC.b	!TestResultPointerL

		%SetSa1Databus(!Sa1OpenBusValue1)
		LDA	!TestCalculatePointerB
		PHA
		PLB
		LDA	(!TestAccessPointer), Y
		STA	[!TestResultPointer]
		PLB

		CLC
		LDA	!TestResultPointerL
		ADC.b	#3
		STA	!TestResultPointerL

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

ClearBwRam:
		PHP
		PHB

		REP	#$30
		; .longm, .longx

		LDA.w	#!Sa1OpenBusValue2
		STA	!SA1_BWRam

		LDA.w	#$FFFE					; $FFFF bytes
		LDX.w	#0
		LDY.w	#1
		MVN	bank(!SA1_BWRam)+0, bank(!SA1_BWRam)	; dst, src

		; A = $FFFF
		; Y = $0000
		TYX
		MVN	bank(!SA1_BWRam)+1, bank(!SA1_BWRam)	; dst, src
		MVN	bank(!SA1_BWRam)+2, bank(!SA1_BWRam)	; dst, src
		MVN	bank(!SA1_BWRam)+3, bank(!SA1_BWRam)	; dst, src

		PLB
		PLP
		RTS


