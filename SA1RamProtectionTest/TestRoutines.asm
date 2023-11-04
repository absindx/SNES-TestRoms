;--------------------------------------------------
; Test routines
;--------------------------------------------------

;--------------------------------------------------
; Library
;--------------------------------------------------

if defined("DEBUG")
	!StopFailed	= 1
else
	!StopFailed	= 0
endif

incsrc	"../Include/Library_Macro.asm"
incsrc	"../Include/Library_Debug.asm"
incsrc	"../Include/IOName_Standard.asm"
incsrc	"../Include/IOName_SA1.asm"

incsrc	"RamMap.asm"
incsrc	"MessageID.asm"

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
		LDA	!TestResult
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

		; SRAM
		%ScreenVramAddress($0D, $08)
		LDX	!TestSramSizeB
		JSR	DrawHexX
		LDX	!TestSramSizeH
		JSR	DrawHexX
		LDX	!TestSramSizeL
		JSR	DrawHexX

		; Stack pointer
		%ScreenVramAddress($0D, $09)
		LDX	!TestSnesStackPointerH
		JSR	DrawHexX
		LDX	!TestSnesStackPointerL
		JSR	DrawHexX

		%ScreenVramAddress($0D, $0A)
		LDX	!TestSa1StackPointerH
		JSR	DrawHexX
		LDX	!TestSa1StackPointerL
		JSR	DrawHexX

		; Test ID
		%ScreenVramAddress($0C, $0E)
		LDA	!TestTestID
		JSR	DrawByteDecimalRight

		; I-RAM protection
		%ScreenVramAddress($12, $11)
		LDA	!TestIRamSnesExpected
		JSR	DrawIRamProtection

		%ScreenVramAddress($12, $12)
		LDA	!TestIRamSnesActual
		JSR	DrawIRamProtection

		%ScreenVramAddress($12, $13)
		LDA	!TestIRamSa1Expected
		JSR	DrawIRamProtection

		%ScreenVramAddress($12, $14)
		LDA	!TestIRamSa1Actual
		JSR	DrawIRamProtection

		; BW-RAM protection
		%ScreenVramAddress($12, $17)
		LDA	!TestBwRamSnesExpected+1
		XBA
		LDA	!TestBwRamSnesExpected+0
		JSR	DrawBwRamProtection

		%ScreenVramAddress($12, $18)
		LDA	!TestBwRamSnesActual+1
		XBA
		LDA	!TestBwRamSnesActual+0
		JSR	DrawBwRamProtection

		%ScreenVramAddress($12, $19)
		LDA	!TestBwRamSa1Expected+1
		XBA
		LDA	!TestBwRamSa1Expected+0
		JSR	DrawBwRamProtection

		%ScreenVramAddress($12, $1A)
		LDA	!TestBwRamSa1Actual+1
		XBA
		LDA	!TestBwRamSa1Actual+0
		JSR	DrawBwRamProtection

		RTS

.Message_Result
	db	"RUNNING"
	db	"PASSED", $0
	db	"FAILED", $0

		; space pad, right align
DrawByteDecimalRight:
		; .shortm, .shortx
		STA	!CPU_WRDIVL
		STZ	!CPU_WRDIVH
		LDX.b	#10
		STX	!CPU_WRDIVB
		NOP					; 2
		NOP					; 4
		NOP					; 6
		NOP					; 8
		NOP					; 10
		NOP					; 12
		NOP					; 14
		NOP					; 16
		LDY	!CPU_RDMPYL			; mod
		LDA	!CPU_RDDIVL			; div
		STA	!CPU_WRDIVL
		STX	!CPU_WRDIVB
		LDX	HexAsciiLowNibble, Y		; 4
		CLC					; 6
		NOP					; 8
		NOP					; 10
		NOP					; 12
		NOP					; 14
		NOP					; 16
		LDA	!CPU_RDDIVL			; div (digit *100)
		BEQ	+
		SEC
		TAY
		LDA	HexAsciiLowNibble, Y
+		STA	!PPU_VMDATAL
		LDA	!CPU_RDMPYL			; mod (digit *10)
		BCS	+
		BEQ	.DrawDigit10
+		TAY
		LDA	HexAsciiLowNibble, Y
.DrawDigit10	STA	!PPU_VMDATAL
		STX	!PPU_VMDATAL			; (digit *1)
		RTS

DrawIRamProtection:
!IRamBit_On	= '*'
!IRamBit_Off	= '-'
!IRamBit_Hex	= '$'
		; .shortm, .shortx
		; A = value
		LDX	#$08
		PHA
.Loop		ASL
		LDY.b	#!IRamBit_Off
		BCC	+
		LDY.b	#!IRamBit_On
+		STY	!PPU_VMDATAL
		DEX
		BNE	.Loop

		STZ	!PPU_VMDATAL
		LDA.b	#!IRamBit_Hex
		STA	!PPU_VMDATAL
		PLX
		JMP	DrawHexX

DrawBwRamProtection:
!BwRamBit_Commonn	= 'O'
!BwRamBit_On		= 'N'
!BwRamBit_Off		= 'F'
		ASL
		LDA.b	#!BwRamBit_Commonn
		STA	!PPU_VMDATAL
		BCC	.Off
.On		LDA.b	#!BwRamBit_On
		STA	!PPU_VMDATAL
		STZ	!PPU_VMDATAL
		BRA	.Value
		RTS
.Off		LDA.b	#!BwRamBit_Off
		STA	!PPU_VMDATAL
		STA	!PPU_VMDATAL
.Value		STZ	!PPU_VMDATAL
		LDA.b	#'$'
		STA	!PPU_VMDATAL
		XBA
		JMP	DrawHexA



;--------------------------------------------------
; Initial test
;--------------------------------------------------

TestInitial:
		JSR	TestPattern_SNES_01
		JMP	TestPattern_SNES_02



;--------------------------------------------------
; SNES CPU, SA-1 Synchronization
; 
;   Test execution is controlled by SA-1.
; 
; SA-1 -> SNES CPU
;   * Notify execution request and test result by IRQ.
;   * Notify the type with the message port.
;   * Additional information is signaled in the lower byte of the IRQ vector.
; 
; SNES CPU -> SA-1
;   * Output execution status to message port.
; 
;   Message port
;     not 1: Idle
;     eq  1: Running
; 
;     SA-1 detects status change from running to idle before proceeding to next test.
; 
;--------------------------------------------------

;--------------------------------------------------
; SNES CPU -> SA-1

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

		;LDX.b	#$80				;\  unlock BW-RAM protection from SNES-CPU
		;STX	!SA1_SBWE			;/
		;LDX.b	#$FF				;\  unlock I-RAM protection from SNES-CPU
		;STX	!SA1_SIWP			;/

		LDX.b	#%00000000			;\
		LDX	!TestResult			; | SA-1 CPU clear reset
		BEQ	+				; |   message = SNES initialize test result
		LDX	#!SNESStatus_BootFailed		; |
+		STX	!SA1_CCNT			;/

		RTS

SetSnesStatus:
		; A = SNES Status
		AND.b	#$0F
		STA	!SA1_CCNT
		RTS

SendSA1CpuIrq:
		; A = Message
		AND.b	#$0F				;\
		ORA.b	#%10000000			; | Send SA-1 IRQ
		STA	!SA1_CCNT			;/
		RTS

SNESProcessMessage:
		; .shortm, .shortx

		STX	!Sa1MessageType
		STA	!Sa1MessageByte

		LDA.b	#!SNESStatus_TestRunning
		JSR	SetSnesStatus

		TXA
		ASL
		TAX
		JSR	(.MessageTable, X)

		LDA.b	#!SNESStatus_Idle
		JSR	SetSnesStatus
		RTS

.MessageTable
		dw	SNESMessage_Boot_SPL			; #0
		dw	SNESMessage_Boot_SPH			; #1
		dw	SNESMessage_TestReady			; #2
		dw	SNESMessage_TestSa1Expected		; #3
		dw	SNESMessage_TestSa1Actual		; #4
		dw	SNESMessage_TestSa1IRamExpected		; #5
		dw	SNESMessage_TestSa1IRamActual		; #6
		dw	SNESMessage_TestSa1BwRamExpectedE	; #7
		dw	SNESMessage_TestSa1BwRamExpectedA	; #8
		dw	SNESMessage_TestSa1BwRamActualE		; #9
		dw	SNESMessage_TestSa1BwRamActualA		; #10
		dw	SNESMessage_TestSnesExecute		; #11
		dw	SNESMessage_TestCheck			; #12
		dw	SNESMessage_NOP				; #13
		dw	SNESMessage_NOP				; #14
		dw	SNESMessage_TestFinished		; #15

SNESMessage_NOP:
		RTS

SNESMessage_Boot_SPL:
!TestID		:= !TestID_SA1_Boot_SPL

		BIT	!TestResult
		BMI	+
		LDA.b	#!TestID
		STA	!TestTestID
+
		LDA	!Sa1MessageByte
		STA	!TestSa1StackPointerL
		STA	!TestResults+!TestID
		RTS

SNESMessage_Boot_SPH:
!TestID		:= !TestID_SA1_Boot_SPH

		BIT	!TestResult
		BMI	+
		LDA.b	#!TestID
		STA	!TestTestID
+
		LDA	!Sa1MessageByte
		STA	!TestSa1StackPointerH
		STA	!TestResults+!TestID
		RTS

SNESMessage_TestReady:
		LDA	!Sa1MessageByte
		JSR	TestInitialize
		RTS

SNESMessage_TestSa1Expected:
		LDA	!Sa1MessageByte
		BIT	!TestResult
		BMI	+
		STA	!TestGeneralSa1Expected
+		RTS

SNESMessage_TestSa1Actual:
		LDA	!Sa1MessageByte
		BIT	TestResult
		BMI	+
		STA	!TestGeneralSa1Actual
+		LDX	!TestingID
		STA	!TestResults, X
		RTS

SNESMessage_TestSa1IRamExpected:
		LDA	!Sa1MessageByte
		BIT	!TestResult
		BMI	+
		STA	!TestIRamSa1Expected
+		RTS

SNESMessage_TestSa1IRamActual:
		LDA	!Sa1MessageByte
		BIT	!TestResult
		BMI	+
		STA	!TestIRamSa1Actual
+		LDX	!TestingID
		STA	!TestResults, X
		RTS

SNESMessage_TestSa1BwRamExpectedE:
		LDA	!Sa1MessageByte
		BIT	!TestResult
		BMI	+
		STA	!TestBwRamSa1Expected+0
+		RTS

SNESMessage_TestSa1BwRamExpectedA:
		LDA	!Sa1MessageByte
		BIT	!TestResult
		BMI	+
		STA	!TestBwRamSa1Expected+1
+		RTS

SNESMessage_TestSa1BwRamActualE:
		LDA	!Sa1MessageByte
		BIT	!TestResult
		BMI	+
		STA	!TestBwRamSa1Actual+0
+		LDX	!TestingID
		ORA	!TestResults, X
		STA	!TestResults, X
		RTS

SNESMessage_TestSa1BwRamActualA:
		LDA	!Sa1MessageByte
		BIT	!TestResult
		BMI	+
		STA	!TestBwRamSa1Actual+1
+		LDX	!TestingID
		ORA	!TestResults, X
		STA	!TestResults, X
		RTS

SNESMessage_TestSnesExecute:
		JMP	TestSnesExecute

SNESMessage_TestCheck:
		JSR	TestResultCheck
		RTS

SNESMessage_TestFinished:
		LDA	!TestResult
		BNE	+
		INC	!TestResult
+
		LDA.b	#!SNESStatus_TestFinished
		JSR	SetSnesStatus

		LDA.b	#%00000000			;\  disable SA-1 to SNES IRQ
		STA	!SA1_SIE			;/

		RTS


;--------------------------------------------------
; SA-1 Routines

; JSR macros that do not update memory. (up to 1 time)
macro	SoftwareJSR(addr)
		REP	#$20
		; .longm
		LDA.w	#(?+)-1
		TCS
		JMP	<addr>
?+ ?-	dw	(?-)+1
endmacro

macro	SendSA1MessageAcc(messageType)
		; .shortm
		STA	!SA1_SIVL			;   SNES IRQ low byte
		LDA.b	#%11000000+(<messageType>&$0F)	;   raise IRQ, override IRQ vector
		STA	!SA1_SCNT
?-		LDA	!SA1_CFR			;   waiting for SNES CPU
		AND.b	#$0F
		CMP.b	#!SNESStatus_TestRunning
		BNE	?-
?-		LDA	!SA1_CFR
		AND.b	#$0F
		CMP.b	#!SNESStatus_TestRunning
		BEQ	?-
endmacro
macro	SendSA1Message(messageType, messageValue)
		; .shortm
		LDA.b	#<messageValue>
		%SendSA1MessageAcc(<messageType>)
endmacro

SA1TestMain:
		REP	#$30				;\
		TXA					; | send SA-1 initial stack pointer
		SEP	#$30				; |
		; .shortm, .shortx			; |
		%SendSA1MessageAcc(!Message_Boot_SPL)	; |
		XBA					; |
		%SendSA1MessageAcc(!Message_Boot_SPH)	;/

		SEP	#$30
		; .shortm, .shortx
if !StopFailed
		LDA	!SA1_CFR			;\  process message from SNES-CPU
		AND.b	#$0F				;/
		CMP.b	#!SNESStatus_BootFailed
		BEQ	SA1TestFinished
else
		; none
endif

		JMP	TestPattern_SA1_05
TestReturn_SA1_05:
		JMP	TestPattern_SA1_06
TestReturn_SA1_06:

SA1TestFinished:

		%SendSA1MessageAcc(!Message_TestFinished)

		REP	#$20
		; .longm, .shortx
		LDA.w	#!StopSP_SA1
		TCS

.InfLoop	SEP	#$30
		; .shortm, .shortx
		LDA.b	#!Message_TestFinished
		STA	!SA1_SCNT
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

macro	TestMemory(addr, access)
		LDA.<access>	<addr>
		EOR.b		#$FF
		STA.<access>	<addr>
		CMP.<access>	<addr>
endmacro
macro	TestMemoryX(addr, access)
		LDA.<access>	<addr>, X
		EOR.b		#$FF
		STA.<access>	<addr>, X
		CMP.<access>	<addr>, X
endmacro

macro	TestBwRam(bwp, addr1, addr2)	; bwp = previous area
?TestBwRam:
		%TestMemory(!SA1_BWRam+<addr1>, l)
		BEQ	?.Enable
		%TestMemory(!SA1_BWRam+<addr2>, l)
		BNE	?.Disable
?.Enable	LDA.b	#<bwp>
		RTS
?.Disable
endmacro

; Return:
;   A = Protection status
TestIRam:
		REP	#$20
		SEP	#$10
		; .longm, .shortx

		LDA.w	#!SA1_IRamImage
		TCD
		LDY.b	#$80
		LDX.b	#$00
		SEP	#$30
		; .shortm, .shortx

.LoopPage
.LoopByte	%TestMemoryX($00, b)
		BNE	+
		SEP	#$40				; set V flag
+		INX
		BNE	.LoopByte

		TDC					;\
		XBA					; | D next page
		INC	A				; |
		XBA					; |
		TCD					;/

		TYA
		CLC					;\
		BVC	+				; | V flag to C flag
		SEC					; |
+		ROR	A				;/
		TAY

		BCC	.LoopPage

		TAX
		REP	#$20
		; .longm, .shortx
		LDA.w	#$0000
		TCD
		SEP	#$30
		; .shortm, .shortx
		TXA

		RTS

; Return:
;   A = Protection area
;   V flag = Protection status(0=Protect, 1=Enable)
TestBwRam:
		SEP	#$60
		REP	#$10
		; .shortm, .longx, SEV

		; Test CBWE
		%TestBwRam($00, $000000, $0000FF)

		; Test BWPA
		CLV

		%TestBwRam($00, $000100, $0001FF)
		%TestBwRam($01, $000200, $0003FF)
		%TestBwRam($02, $000400, $0007FF)
		%TestBwRam($03, $000800, $000FFF)
		%TestBwRam($04, $001000, $001FFF)
		%TestBwRam($05, $002000, $003FFF)
		%TestBwRam($06, $004000, $007FFF)
		%TestBwRam($07, $008000, $00FFFF)
		%TestBwRam($08, $010000, $01FFFF)
		%TestBwRam($09, $020000, $03FFFF)
		%TestBwRam($0A, $040000, $07FFFF)
		%TestBwRam($0B, $080000, $0FFFFF)
		%TestBwRam($0C, $100000, $1FFFFF)

		LDA.b	#$0F

		RTS

TestBwRamSize:
; Get BW-RAM size (from SNES CPU)
%DefineLocal(TestPointer, !ScratchMemory+0, 3)
%DefineLocal(PassPointer, !ScratchMemory+3, 3)

		SEP	#$30
		; .shortm, shortx

		LDA.b	#%10000000			;\  disable BW-RAM protection from SNES CPU
		STA	!SA1_SBWE			;/

		STZ	!TestSramSize+0			;\
		STZ	!TestSramSize+1			; | clear results
		STZ	!TestSramSize+2			;/

		LDA.b	#$02				;\
		STA	.TestPointer+0			; | initialize pointers
		STZ	.TestPointer+1			; | .TestPointer = $400002
		STZ	.PassPointer+0			; | .PassPointer = $400000
		STZ	.PassPointer+1			; |
		LDA.b	#$40				; |
		STA	.TestPointer+2			; |
		STA	.PassPointer+2			;/

		%TestMemory(!SA1_BWRam, l)		;\  check 0 bytes
		BEQ	.RoughCheck			;/
		RTS					;   no SRAM, exit test

.RoughCheck	; Check size in powers of 2
		INC	!TestSramSize+0

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
		STA	!TestSramSize+0
		LDA	.TestPointer+1
		STA	!TestSramSize+1
		LDA	.TestPointer+2
		AND.b	#$3F
		STA	!TestSramSize+2

		RTS

TestInitialize:
!TestInitialize_ClearStart	:= !TestGeneralSnesExpected
!TestInitialize_ClearEnd	:= !TestSnesStackPointer-1

		; .shortm, .shortx
		STA	!TestingID
		BIT	!TestResult
		BMI	.SkipTestDisplay
		STA	!TestTestID

		LDX.b	#(!TestInitialize_ClearEnd-!TestInitialize_ClearStart)
-		STZ	!TestInitialize_ClearStart, X
		DEX
		BPL	-
.SkipTestDisplay
		RTS

TestResultCheck:
		; .shortx

		LDA	!TestGeneralSnesExpected
		CMP	!TestGeneralSnesActual
		BNE	.Failed

		LDA	!TestGeneralSa1Expected
		CMP	!TestGeneralSa1Actual
		BNE	.Failed

		LDA	!TestIRamSnesExpected
		CMP	!TestIRamSnesActual
		BNE	.Failed

		LDA	!TestIRamSa1Expected
		CMP	!TestIRamSa1Actual
		BNE	.Failed

		LDA	!TestBwRamSnesExpected+0
		CMP	!TestBwRamSnesActual+0
		BNE	.Failed
		LDA	!TestBwRamSnesExpected+1
		CMP	!TestBwRamSnesActual+1
		BNE	.Failed

		LDA	!TestBwRamSa1Expected+0
		CMP	!TestBwRamSa1Actual+0
		BNE	.Failed
		LDA	!TestBwRamSa1Expected+1
		CMP	!TestBwRamSa1Actual+1
		BNE	.Failed

		RTS

.Failed		LDA	!TestResult
		BNE	.Return
		DEC	!TestResult
.Return		RTS

WriteTestGeneralSnesExpected:
		BIT	!TestResult
		BMI	.Return
		STA	!TestGeneralSnesExpected
.Return		RTS
WriteTestGeneralSnesActual:
		BIT	!TestResult
		BMI	.Return
		STA	!TestGeneralSnesActual
.Return		RTS
WriteTestIRamSnesExpected:
		BIT	!TestResult
		BMI	.Return
		STA	!TestIRamSnesExpected
.Return		RTS
WriteTestIRamSnesActual:
		BIT	!TestResult
		BMI	.Return
		STA	!TestIRamSnesActual
.Return		RTS
WriteTestBwRamSnesExpected:
		BIT	!TestResult
		BMI	.Return
		STA	!TestBwRamSnesExpected+1
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		STA	!TestBwRamSnesExpected+0
.Return		RTS
WriteTestBwRamSnesActual:
		BIT	!TestResult
		BMI	.Return
		STA	!TestBwRamSnesActual+1
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		STA	!TestBwRamSnesActual+0
.Return		RTS



;--------------------------------------------------

TestSnesExecute:
		REP	#$30
		; .longm, .longx
		LDA	!Sa1MessageByte
		ASL
		TAX
		JMP	(.TestRoutineTable, X)
		RTS

.TestRoutineTable
		dw	TestPattern_SNES_NOP		; 0
		dw	TestPattern_SNES_NOP		; 1
		dw	TestPattern_SNES_NOP		; 2
		dw	TestPattern_SNES_NOP		; 3
		dw	TestPattern_SNES_NOP		; 4
		dw	TestPattern_SNES_NOP		; 5
		dw	TestPattern_SNES_NOP		; 6

TestPattern_SNES_NOP:
		RTS

!TestID		:= 0

TestPattern_SNES_01:	; Boot I-RAM protection (SNES)
!TestID		:= !TestID_SNES_IRamProtection_Boot
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#!TestID
		JSR	TestInitialize

		LDA.b	#%00000000
		JSR	WriteTestIRamSnesExpected

		JSR	TestIRam
		STA	!TestResults+!TestID
		JSR	WriteTestIRamSnesActual

		JMP	TestResultCheck

TestPattern_SNES_02:	; Boot BW-RAM protection (SNES)
!TestID		:= !TestID_SNES_BwRamProtection_Boot
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#!TestID
		JSR	TestInitialize

		CLV
		LDA.b	#$0F
		JSR	WriteTestBwRamSnesExpected

		JSR	TestBwRam
		PHA
		BCS	+
		ORA.b	#$80
+		STA	!TestResults+!TestID
		PLA
		JSR	WriteTestBwRamSnesActual

		JMP	TestResultCheck

;TestPattern_SA1_03:	; Boot stack pointer
;TestPattern_SA1_04:	; Boot stack pointer

TestPattern_SA1_05:	; Boot I-RAM protection (SA-1)
!TestID		:= !TestID_SA1_IRamProtection_Boot
		SEP	#$30
		; .shortm, .shortx

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1IRamExpected, $00)

		%SoftwareJSR(TestIRam)
		%SendSA1MessageAcc(!Message_TestSa1IRamActual)

		%SendSA1Message(!Message_TestCheck, $00)

		JMP	TestReturn_SA1_05

TestPattern_SA1_06:	; Boot BW-RAM protection (SA-1)
!TestID		:= !TestID_SA1_BwRamProtection_Boot
		SEP	#$30
		; .shortm, .shortx

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1BwRamExpectedE, $00)
		%SendSA1Message(!Message_TestSa1BwRamExpectedA, $0F)

		%SoftwareJSR(TestBwRam)
		%SendSA1MessageAcc(!Message_TestSa1BwRamActualA)

		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		%SendSA1MessageAcc(!Message_TestSa1BwRamActualE)

		%SendSA1Message(!Message_TestCheck, $00)

		JMP	TestReturn_SA1_06


