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
incsrc	"MessageID.asm"



;--------------------------------------------------
; Draw result
;--------------------------------------------------

function ShiftByte(value, i)		= ((value)>>(i*8))&$00FF
function ShiftWord(value, i)		= ((value)>>(i*8))&$FFFF
function ScreenWramAddress(x, y)	= ScreenVramAddress(!TilemapBufferWram+!TilemapOffset, 32, x, y)

UpdateScreen:
		JSR	UpdateScreenBuffer

		; Update screen
		JMP	TransferTilemap_Main

UpdateScreenBuffer:
		SEP	#$30
		; .shortm, .shortx

		; Result
		JSR	WriteTestResult

		; SRAM
		JSR	WriteSramSize

		; Test ID
		JSR	WriteTestID

		; Test pattern
		JMP	WriteTestPatternsLine

WriteTestResult:
%DefineLocal(DataSize, 7, 1)

		LDA.b	#ShiftByte(ScreenWramAddress(11, 7), 0)
		STA	!WRAM_WMADDL
		LDA.b	#ShiftByte(ScreenWramAddress(11, 7), 1)
		STA	!WRAM_WMADDM
		LDA.b	#ShiftByte(ScreenWramAddress(11, 7), 2)&$01
		STA	!WRAM_WMADDH

		LDY.b	#.DataSize
		LDA	!DisplayResult
		BNE	+
.Zero		LDX.b	#0*.DataSize
		BRA	.DrawLoop
+		BMI	.Fail
.Pass		LDX.b	#1*.DataSize
		BRA	.DrawLoop
.Fail		LDX.b	#2*.DataSize
.DrawLoop	LDA	.Data, X
		STA	!WRAM_WMDATA
		INX
		DEY
		BNE	.DrawLoop

		RTS

.Data
		db	"RUNNING"
		db	"PASSED", $0
		db	"FAILED", $0

WriteSramSize:
		LDA.b	#ShiftByte(ScreenWramAddress(12, 8), 0)
		STA	!WRAM_WMADDL
		LDA.b	#ShiftByte(ScreenWramAddress(12, 8), 1)
		STA	!WRAM_WMADDM
		LDA.b	#ShiftByte(ScreenWramAddress(12, 8), 2)&$01
		STA	!WRAM_WMADDH
		LDX	!TestSramSizeB
		JSR	DrawHexX
		LDX	!TestSramSizeH
		JSR	DrawHexX
		LDX	!TestSramSizeL
		JMP	DrawHexX

WriteTestID:
		; .shortm, .shortx
		LDA	!DisplayTestID
		STA	!CPU_WRDIVL
		STZ	!CPU_WRDIVH
		LDX.b	#10
		STX	!CPU_WRDIVB
		LDA.b	#ShiftByte(ScreenWramAddress(12, 12), 0)	; 2
		STA	!WRAM_WMADDL					; 6
		LDA.b	#ShiftByte(ScreenWramAddress(12, 12), 1)	; 8
		STA	!WRAM_WMADDM					; 12
		LDA.b	#ShiftByte(ScreenWramAddress(12, 12), 2)&$01	; 14
		STA	!WRAM_WMADDH					; 18
		LDY	!CPU_RDMPYL					; mod
		LDA	!CPU_RDDIVL					; div
		STA	!CPU_WRDIVL
		STX	!CPU_WRDIVB
		LDX	HexAsciiLowNibble, Y				; 4
		CLC							; 6
		NOP							; 8
		NOP							; 10
		NOP							; 12
		NOP							; 14
		NOP							; 16
		LDA	!CPU_RDDIVL					; div (digit *100)
		BEQ	+
		SEC
		TAY
		LDA	HexAsciiLowNibble, Y
+		STA	!WRAM_WMDATA
		LDA	!CPU_RDMPYL					; mod (digit *10)
		BCS	+
		BEQ	.DrawDigit10
+		TAY
		LDA	HexAsciiLowNibble, Y
.DrawDigit10	STA	!WRAM_WMDATA
		STX	!WRAM_WMDATA					; (digit *1)
		RTS

WriteTestPatternsLine:
%DefineLocal(access, !ScratchMemory+0, 1)
		REP	#$11
		SEP	#$20
		; .shortm, .longx, CLC
		TDC					; clear A.H

		LDX.w	#ShiftWord(ScreenWramAddress(2, 15), 0)
		STX	!WRAM_WMADDL
		LDA.b	#ShiftByte(ScreenWramAddress(2, 15), 0)&$01
		STA	!WRAM_WMADDH

		LDY.w	#0
.Loop		LDA	TestResult_00_ID, Y
		BEQ	.WriteBlank
		JSR	WriteTestPattern_Cpu
		STZ	!WRAM_WMDATA			; dummy
		JSR	WriteTestPattern_Access
		LDA.b	#':'
		STA	!WRAM_WMDATA
		JSR	WriteTestPattern_Address
		STZ	!WRAM_WMDATA			; dummy
		JSR	WriteTestPattern_Direction
		STZ	!WRAM_WMDATA			; dummy
		JSR	WriteTestPattern_Expected
		LDA.b	#':'
		STA	!WRAM_WMDATA
		JSR	WriteTestPattern_Actual

		STZ	!WRAM_WMDATA			; dummy * 4
		STZ	!WRAM_WMDATA
		STZ	!WRAM_WMDATA
		STZ	!WRAM_WMDATA

		TYA
		CLC
		ADC.b	#!TestPattern_EntrySize
		TAY
		CPY.w	#(!TestResultCount*!TestPattern_EntrySize)
		BCC	.Loop

		RTS

.WriteBlank
		STZ	!WRAM_WMDATA			; 4 * 8 = 32 bytes
		STZ	!WRAM_WMDATA			; => 1 row
		STZ	!WRAM_WMDATA
		STZ	!WRAM_WMDATA
		INY
		CPY.w	#(!TestResultCount*!TestPattern_EntrySize)
		BCC	.WriteBlank
		RTS

WriteTestPattern_Cpu:
		LDA	!TestResult_00_Type, Y
		LSR
		LSR
		AND.b	#$3C
		TAX

		LDA	.Data+0, X
		STA	!WRAM_WMDATA
		LDA	.Data+1, X
		STA	!WRAM_WMDATA
		LDA	.Data+2, X
		STA	!WRAM_WMDATA
		LDA	.Data+3, X
		STA	!WRAM_WMDATA

		RTS

.Data		db	"????"
		db	"SNES"
		db	"SA-1"

WriteTestPattern_Access:
%DefineLocal(access, !ScratchMemory+0, 1)
		LDA	!TestResult_00_Type, Y
		AND.b	#$0F
		STA	.access				;\
		ASL					; | * 5
		ASL					; |
		ADC	.access				;/
		TAX

		LDA	.Data+0, X
		STA	!WRAM_WMDATA
		LDA	.Data+1, X
		STA	!WRAM_WMDATA
		LDA	.Data+2, X
		STA	!WRAM_WMDATA
		LDA	.Data+3, X
		STA	!WRAM_WMDATA
		LDA	.Data+4, X
		STA	!WRAM_WMDATA

		RTS

.Data
		db	"?????"
		db	"READ", $00
		db	"WRITE"

WriteTestPattern_Address:
		LDA.b	#'$'
		STA	!WRAM_WMDATA

		LDA	!TestResult_00_Address+2, Y
		TAX					; because X.H = $00
		LDA	HexAsciiHighNibble, X
		STA	!WRAM_WMDATA
		LDA	HexAsciiLowNibble, X
		STA	!WRAM_WMDATA

		LDA	!TestResult_00_Address+1, Y
		TAX					; because X.H = $00
		LDA	HexAsciiHighNibble, X
		STA	!WRAM_WMDATA
		LDA	HexAsciiLowNibble, X
		STA	!WRAM_WMDATA

		LDA	!TestResult_00_Address+0, Y
		TAX					; because X.H = $00
		LDA	HexAsciiHighNibble, X
		STA	!WRAM_WMDATA
		LDA	HexAsciiLowNibble, X
		STA	!WRAM_WMDATA

		RTS

WriteTestPattern_Direction:
%DefineLocal(access, !ScratchMemory+0, 1)
		LDA	.access
		TAX					; because X.H = $00
		LDA	.Data, X
		STA	!WRAM_WMDATA
		RTS

.Data
		db	"?"
		db	">"				; read
		db	"<"				; write

WriteTestPattern_Expected:
		LDA.b	#'$'
		STA	!WRAM_WMDATA

		CLC
		TYA
		ADC	!BwramExist
		TAX
		LDA	!TestResult_00_ExpectSave, X
		TAX
		LDA	HexAsciiHighNibble, X
		STA	!WRAM_WMDATA
		LDA	HexAsciiLowNibble, X
		STA	!WRAM_WMDATA

		RTS

WriteTestPattern_Actual:
%DefineLocal(access, !ScratchMemory+0, 1)
		LDA	.access
		CMP.b	#!TestPattern_Access_Read
		BNE	.Write

.Read
		LDA.b	#'$'
		STA	!WRAM_WMDATA

		LDA	!TestResult_00_Actual, Y
		TAX
		LDA	HexAsciiHighNibble, X
		STA	!WRAM_WMDATA
		LDA	HexAsciiLowNibble, X
		STA	!WRAM_WMDATA

		RTS

.Write
		LDA.b	#'-'
		STA	!WRAM_WMDATA
		STA	!WRAM_WMDATA
		STA	!WRAM_WMDATA
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
		LDA.b	#$01
		STA	!Sa1Booted

		LDA	!BwramExist
		BEQ	.NoBwram

		LDA	!BwramSize+0
		STA	!TestSramSize+0
		LDA	!BwramSize+1
		STA	!TestSramSize+1
		LDA	!BwramSize+2
		STA	!TestSramSize+2
		RTS

.NoBwram	STZ	!TestSramSize+0
		STZ	!TestSramSize+1
		STZ	!TestSramSize+2
		RTS

SNESMessage_TestFinished:
		LDA.b	#%00000000			;\  disable SA-1 to SNES IRQ
		STA	!SA1_SIE			;/

		RTS



;--------------------------------------------------
; SA-1 routines
;--------------------------------------------------

macro	SetSa1Databus(value)
		LDA.b	#<value>
		STA.l	$400006
		STA.l	$400006
		LDA.l	$000800	; dummy read
endmacro

macro	SendSA1Message(messageType, irq)
		; SA-1 -> SNES IRQ
		; .shortm
		LDA.b	#(<irq><<7)+(<messageType>&$0F)
		STA	!SA1_SCNT
endmacro
macro	SendSnesMessage(messageType, irq)
		; SNES -> SA-1 IRQ
		; .shortm
		LDA.b	#(<irq><<7)+(<messageType>&$0F)
		STA	!SA1_CCNT
endmacro

SA1TestMain:
		SEP	#$30
		; .shortm, .shortx

		JSR	CheckBwRam
		%SendSA1Message(!Message_SA1_SNES_Boot, 1)

.WaitLoop	LDA	!Sa1Booted
		BEQ	.WaitLoop

;;		JSR	TestSa1Execute
;		; fallthrough
;SA1TestFinished:
;		SEP	#$30
;		; .shortm, .shortx
;		%SendSA1Message(!Message_TestFinished, 1)
;.InfLoop
;		%SendSA1Message(!Message_TestFinished, 0)
;		BRA	.InfLoop

.InfLoop
		LDA.b	#$80				;\  accespet IRQ from SNES CPU
		STA	!SA1_CIE			;/
		CLI
		%SendSA1Message(!Message_SA1_SNES_Idle, 0)
		BRA	.InfLoop



SA1ProcessMessage:
		LDA	!SA1_CFR			;\  process message from SNES-CPU
		AND.b	#$0F				;/
		ASL
		TAX

		JSR	(.MessageTable, X)

		RTS

.MessageTable
		dw	SA1Message_TestExecute		; #0
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

SA1Message_TestExecute:
		%SendSA1Message(!Message_SA1_SNES_Running, 0)
		JMP	TestSa1Execute



;--------------------------------------------------
; Test routines
;--------------------------------------------------

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

		LDA.w	#!Sa1OpenBusValue1+(!Sa1OpenBusValue2<<8)
		STA	!SA1_BWRam

		LDA.w	#$FFFD					; $FFFE bytes
		LDX.w	#0
		LDY.w	#2
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

CheckBwRam:
		; .shortm, shortx
		JSR	TestBwRamExists
		JMP	TestBwRamSize

TestBwRamExists:
		; FIXME: Implement details later

		LDA.b	#$AA
		STA	!SA1_BWRam+0
		LDA.b	#$BB
		STA	!SA1_BWRam+1
		LDA	!SA1_BWRam+0
		CMP.b	#$AA
		BNE	.NoBwram

.HasBwram	LDA.b	#$01
		STA	!BwramExist
		RTS

.NoBwram	STZ	!BwramExist
		RTS

TestBwRamSize:
; Get BW-RAM size (from SA-1 CPU)
%DefineLocal(TestPointer, !ScratchMemory+0, 3)
%DefineLocal(PassPointer, !ScratchMemory+3, 3)

		SEP	#$30
		; .shortm, shortx

		;STZ	!TestSramSize+0			;\
		;STZ	!TestSramSize+1			; | clear results
		;STZ	!TestSramSize+2			;/

		LDA.b	#$02				;\
		STA	.TestPointer+0			; | initialize pointers
		STZ	.TestPointer+1			; | .TestPointer = $400002
		STZ	.PassPointer+0			; | .PassPointer = $400000
		STZ	.PassPointer+1			; |
		LDA.b	#$40				; |
		STA	.TestPointer+2			; |
		STA	.PassPointer+2			;/

		;%TestMemory(!SA1_BWRam, l)		;\  check 0 bytes
		;BEQ	.RoughCheck			;/
		;RTS					;   no SRAM, exit test

.RoughCheck	; Check size in powers of 2
		;INC	!TestSramSize+0

.RoughLoop
		LDA.b	#$BB
		STA.b	[.TestPointer]
		LDA.b	#$AA
		STA.l	!SA1_BWRam
		CMP.b	[.TestPointer]
		BEQ	.DetailCheck			;   equal -> memory test fail

		LDA	.TestPointer+0			;   slide pointer
		STA	.PassPointer+0
		LDA	.TestPointer+1
		STA	.PassPointer+1
		LDA	.TestPointer+2
		STA	.PassPointer+2

		CLC
		LDA	.TestPointer+0
		ORA	.TestPointer+1
		BNE	+
		SEC
+		ROL	.TestPointer+0
		ROL	.TestPointer+1
		BCC	.RoughLoop
		LDA	.TestPointer+2			;   next bank
		INC	A
		STA	.TestPointer+2
		CMP	#$50
		BCS	.Exit				;   $500000, exit test
		BRA	.RoughLoop

.DetailCheck
		;CLC
		LDA	.PassPointer+0			;   revert pointer and +1
		ADC.b	#$01
		STA	.TestPointer+0
		LDA	.PassPointer+1
		ADC.b	#$00
		STA	.TestPointer+1
		LDA	.PassPointer+2
		ADC.b	#$00
		STA	.TestPointer+2

.DetailLoop
		LDA.b	#$BB
		STA.b	[.TestPointer]
		LDA.b	#$AA
		STA.l	!SA1_BWRam
		CMP.b	[.TestPointer]
		BEQ	.Exit

		INC	.TestPointer+0
		BNE	+
		INC	.TestPointer+1
		BNE	+
		INC	.TestPointer+2
+
		BRA	.DetailLoop

.Exit
		LDA	.TestPointer+0
		STA	!BwramSize+0
		LDA	.TestPointer+1
		STA	!BwramSize+1
		LDA	.TestPointer+2
		AND.b	#$3F
		STA	!BwramSize+2

		RTS

WaitSa1Boot:
		PHP
		SEP	#$20
		CLI
		; .shortm
.Loop		LDA	!Sa1Booted
		BEQ	.Loop
		PLP
		RTS

WaitSa1TestPattern:
		; .shortm
.LoopProcess	LDA	!SA1_SFR
		AND.b	#$0F
		CMP.b	#!Message_SA1_SNES_Idle
		BEQ	.LoopProcess
.LoopIdle	LDA	!SA1_SFR
		AND.b	#$0F
		CMP.b	#!Message_SA1_SNES_Idle
		BNE	.LoopIdle
		RTS


;; Argument:
;;   !TestAddressPointer
;;   !TestResultPointer
;;   !TestAccessPointer = #$AA00
;; Effect:
;;   !TestResultPointer = +4
;;   !TestCalculatePointer
;TestAddressRead:
;		; .shortm, .longx
;		PHB
;
;		SEC					;\
;		LDA	!TestAddressPointerL		; |
;		SBC.b	#$00				; | ScratchMemory[6-8] = ScratchMemory[0-2] - #$00AA00
;		STA	!TestCalculatePointerL		; |
;		LDA	!TestAddressPointerH		; |
;		SBC.b	#!SnesOpenBusValue		; |
;		STA	!TestCalculatePointerH		; |
;		LDA	!TestAddressPointerB		; |
;		SBC.b	#$00				; |
;		STA	!TestCalculatePointerB		;/
;
;		LDY	!TestCalculatePointer
;
;		%SetSa1Databus(!Sa1OpenBusValue1)
;		LDA	!TestAddressPointerB
;		PHA
;		PLB
;		LDA	(!TestAddressPointer)
;		STA	[!TestResultPointer]
;		INC.b	!TestResultPointerL
;
;		%SetSa1Databus(!Sa1OpenBusValue1)
;		LDA	!TestCalculatePointerB
;		PHA
;		PLB
;		LDA	(!TestAccessPointer), Y
;		STA	[!TestResultPointer]
;		PLB
;
;		CLC
;		LDA	!TestResultPointerL
;		ADC.b	#3
;		STA	!TestResultPointerL
;
;		RTS

;--------------------------------------------------

TestSnesInitialize:
		REP	#$10
		SEP	#$20
		; .shortm, .longx

		STZ	!TestFinished

		LDA.b	#0
		STA	!LastTestPatternID
		LDX.w	#0
		STX	!LastTestPatternOffset

		JSR	NextTestPattern

		RTS

TestSa1Initialize:
		SEP	#$10
		; .shortx
		LDX.b	#%00000000			;\  SA-1 CPU clear reset
		STX	!SA1_CCNT			;/  Message = $0
		RTS

; SNES CPU
TestMainloop:
.TestLoop
		SEP	#$20
		REP	#$10
		; .shortm, .longx

		LDX	!LastTestPatternOffset
		LDA	!TestAddressResult, X
		BNE	.ValidPattern
.JudgePattern
		JSR	JudgeTestPattern
		JSR	NextTestPattern
		BVC	.TestLoop
		JMP	TestPatternFinished

.ValidPattern
		CMP.b	!TestPattern_CPU_SNES
		BNE	.PatternSa1

.PatternSnes
		JSR	TestSnesExecute
		JSR	NextSubTestPattern
		BRA	.TestLoop

.PatternSa1
		%SendSnesMessage(!Message_SNES_SA1_TestExecute, 1)
		JSR	WaitSa1TestPattern
		JSR	NextSubTestPattern
		BRA	.TestLoop

TestPatternFinished:
		LDA	!DisplayResult
		BNE	.SkipPass
		LDA.b	#$01
.SkipPass	STA	!DisplayResult
		STA	!TestFinished

		RTS


; Argument:
;   A = TestID
TestSa1Execute:
		; TODO: Implements
		RTS

		REP	#$30
		; .longm, .longx
		AND.w	#$00FF
		DEC	A

;		CMP.w	#!TestDefinedMax
;		BCC	+
;		JMP	SA1TestFinished
;+		ASL
;		ASL
;		TAX
;		LDX.w	#$0000
;		JMP	(TestHandlerTable, X)

TestSnesExecute:
		; TODO: Implements
		RTS

		REP	#$30
		; .longm, .longx
;		LDA	!TestingID
;		AND.w	#$00FF
;		DEC	A
;		ASL
;		ASL					; CLC
;		ADC.w	#$02
;		TAX
;		LDX.w	#$0000
;		JMP	(TestHandlerTable, X)

;TestHandlerTable:
;		pushpc
;		dw	TestSA1_001, TestSNES_001
;		pullpc


JudgeTestPattern:
%DefineLocal(basePointer,  !ScratchMemory+0, 2)
%DefineLocal(failCount, !ScratchMemory+2, 1)

		SEP	#$21
		; .shortm, .longx, SEC

		LDX.w	#!TestAddressResult
		STX	.basePointer

		TDC
		;SEC
		LDA.b	#(!TestResult_00_ExpectNone-TestResult_00_ID)
		SBC	!BwramExist
		TAX

.LoopEntry	LDY.w	#(!TestResult_00_ID-TestResult_00_ID)
		LDA	(.basePointer), Y
		BEQ	.Return

		LDY.w	#(!TestResult_00_Actual-TestResult_00_ID)
		LDA	(.basePointer), Y
		TXY
		CMP	(.basePointer), Y
		BEQ	.DetectPass
.DetectFail	INC	.failCount
.DetectPass	CLC
		LDA	.basePointer
		ADC.b	#!TestPattern_EntrySize
		STA	.basePointer
		BRA	.LoopEntry

.Return
		SEP	#$30
		; .shortm, .shortx
		LDX	!LastTestPatternID
		LDY	.failCount
		BNE	.JudgeFail
.JudgePass
		LDA.b	#$01
		STA	!TestResults, X
		RTS

.JudgeFail
		LDA.b	#$FF
		STA	!TestResults, X
		STA	!DisplayResult

		if !Debug
		JSR	DebugWait
		endif

		RTS

NextSubTestPattern:
		PHP
		REP	#$31
		; .longm, .longx, CLC

		LDA	!LastTestPatternOffset
		ADC.w	#0008
		STA	!LastTestPatternOffset

		PLP
		RTS

NextTestPattern:
%DefineLocal(counter, !ScratchMemory+0, 2)

		REP	#$10
		SEP	#$20
		; .shortm, .longx

		LDA.b	#!TestResultCount-1
		STA	.counter+0
		STZ	.counter+1

		LDA	!LastTestPatternID
		INC	A
		LDX.w	#0
		JSR	GetTestPatternOffset

		REP	#$70
		; .longm, .longx, CLV

		LDX.w	#!TestAddressResult

		LDA	TestPatternTable, Y
		AND.w	#$00FF
		BNE	.ValidPattern

.FinishPattern
		SEP	#$60
		; .shortm, .longx, SEV
		LDA	!LastTestPatternID		;\
		DEC	A				; | revert increment
		STA	!LastTestPatternID		; |
		STA	!DisplayTestID			;/
		RTS

.ValidPattern

.Loop		LDA	TestPatternTable, Y
		EOR	!LastTestPatternID
		AND.w	#$00FF
		BNE	.Clear
.Copy		LDA	TestPatternTable+0, Y
		STA	$00, X
		LDA	TestPatternTable+2, Y
		STA	$02, X
		LDA	TestPatternTable+4, Y
		STA	$04, X
		LDA	TestPatternTable+6, Y
		STA	$06, X

		CLC					;\
		TXA					; | X += 8
		ADC.w	#$0008				; |
		TAX					;/
		;CLC					;\
		TYA					; | Y += 8
		ADC.w	#$0008				; |
		TAY					;/

		DEC	.counter
		BPL	.Loop
		RTS

.Clear		TXA
.ClearLoop	STZ	$00, X
		STZ	$02, X
		STZ	$04, X
		STZ	$06, X

		CLC
		ADC.w	#$0008
		TAX

		DEC	.counter
		BPL	.ClearLoop
		RTS

; Argument:
;   A = TestID
;   X = TestSubNumber
; Return:
;   Y = TestPatternTable offset
GetTestPatternOffset:
		PHP
		; .shortx, .longx
		CMP	!LastTestPatternID
		BEQ	.Cached
		STA	!LastTestPatternID

		LDA	!DisplayResult			;\
		BNE	.SkipUpdateDisplayID		; |
		LDA	!LastTestPatternID		; |
		STA	!DisplayTestID			; |
.SkipUpdateDisplayID					;/

		LDY	!LastTestPatternOffset
.LoopSearch	LDA	TestPatternTable, Y
		BEQ	.Finish
		CMP	!LastTestPatternID
		BEQ	.Finish
		INY
		INY
		INY
		INY
		INY
		INY
		INY
		INY
		BRA	.LoopSearch

.Finish		STY	!LastTestPatternOffset

.Cached
		TXA					;\
		ASL					; | X * 8
		ASL					; |
		ASL					;/
		REP	#$31				;\
		; .longm, .longx, CLC			; | Y = base + offset
		AND.w	#$00FF				; |
		ADC	!LastTestPatternOffset		; |
		TAY					;/
		PLP
		RTS



; index    cpu r/w  address                    expected          actual
; iiiiiiii ccccwwww aaaaaaaa aaaaaaaa aaaaaaaa eeeeeeee eeeeeeee rrrrrrrr

macro	DefineTestPatternLabel(testID, subID, suffix)
	if <testID> >= 100
		TestPattern_<testID>_<subID>_<suffix>:
	elseif <testID> >= 10
		TestPattern_0<testID>_<subID>_<suffix>:
	else
		TestPattern_00<testID>_<subID>_<suffix>:
	endif
endmacro
macro	DefineTestResultLabel(testID)
	pushpc
	org	!TestResults+<testID>
	if <testID> >= 100
		TestResult_<testID>:	skip 1
	elseif <testID> >= 10
		TestResult_0<testID>:	skip 1
	else
		TestResult_00<testID>:	skip 1
	endif
	pullpc
endmacro
macro	NextTestPattern(testID)
	if !MaxTestPatternID+1 != <testID>
		; MEMO: warn cannot output multiple outputs.
		print "Is the ID definition being skipped? ", dec(!MaxTestPatternID), " -> ", dec(<testID>)
	endif
	!MaxTestPatternID	:= <testID>
	!TestPatternSubID	:= 0
	%DefineTestResultLabel(<testID>)
endmacro
macro	TestPattern(cpu, access, address, expectSave, expectNone)
	fill align	!TestPattern_EntrySize
	%DefineTestPatternLabel(!MaxTestPatternID, !TestPatternSubID, ID)
		db	!MaxTestPatternID
	%DefineTestPatternLabel(!MaxTestPatternID, !TestPatternSubID, Type)
		db	(!TestPattern_CPU_<cpu><<4)|!TestPattern_Access_<access>
	%DefineTestPatternLabel(!MaxTestPatternID, !TestPatternSubID, Address)
		dl	<address>
	%DefineTestPatternLabel(!MaxTestPatternID, !TestPatternSubID, ExpectSave)
		db	<expectSave>
	%DefineTestPatternLabel(!MaxTestPatternID, !TestPatternSubID, ExpectNone)
		db	<expectNone>
	fill align	!TestPattern_EntrySize
	!TestPatternSubID	#= !TestPatternSubID+1
endmacro

	skip align	!TestPattern_EntrySize
	fillbyte	$00
TestPatternTable:
	incsrc		"TestPattern.asm"
	db		$00				;   sentinel
	fillbyte	!BlankByte

