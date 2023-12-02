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
; Test define
;--------------------------------------------------

macro	TestDefineMain(id, name)
!TestDefined_<id>	= 1

	pushpc
		org	TestResults+<id>
		if <id> >= 100
TestResults_<id>_<id>:		skip 1
		elseif <id> >= 10
TestResults_0<id>_<name>:	skip 1
		else
TestResults_00<id>_<name>:	skip 1
		endif

		org	TestActuals+<id>
		if <id> >= 100
TestActuals_<id>_<id>:		skip 1
		elseif <id> >= 10
TestActuals_0<id>_<name>:	skip 1
		else
TestActuals_00<id>_<name>:	skip 1
		endif

		org	TestExpects+<id>
		if <id> >= 100
TestExpects_<id>_<id>:		skip 1
		elseif <id> >= 10
TestExpects_0<id>_<name>:	skip 1
		else
TestExpects_00<id>_<name>:	skip 1
		endif
	pullpc

endmacro
macro	TestDefine(id)
		%TestDefineMain(!<id>, <id>)
endmacro

		%TestDefine(TestID_SNES_IRamProtection_Boot)
		%TestDefine(TestID_SNES_BwRamProtection_Boot)
		%TestDefine(TestID_SA1_Boot_SPL)
		%TestDefine(TestID_SA1_Boot_SPH)
		%TestDefine(TestID_SA1_IRamProtection_Boot)
		%TestDefine(TestID_SA1_BwRamProtection_Boot)
		%TestDefine(TestID_SNES_IRamProtection_SNES)
		%TestDefine(TestID_SA1_IRamProtection_SNES)
		%TestDefine(TestID_SNES_IRamProtection_SA1)
		%TestDefine(TestID_SA1_IRamProtection_SA1)
		%TestDefine(TestID_SNES_IRamProtection_D0)
		%TestDefine(TestID_SNES_IRamProtection_D1)
		%TestDefine(TestID_SNES_IRamProtection_D2)
		%TestDefine(TestID_SNES_IRamProtection_D3)
		%TestDefine(TestID_SNES_IRamProtection_D4)
		%TestDefine(TestID_SNES_IRamProtection_D5)
		%TestDefine(TestID_SNES_IRamProtection_D6)
		%TestDefine(TestID_SNES_IRamProtection_D7)
		%TestDefine(TestID_SNES_IRamProtection_DMulti)
		%TestDefine(TestID_SA1_IRamProtection_D0)
		%TestDefine(TestID_SA1_IRamProtection_D1)
		%TestDefine(TestID_SA1_IRamProtection_D2)
		%TestDefine(TestID_SA1_IRamProtection_D3)
		%TestDefine(TestID_SA1_IRamProtection_D4)
		%TestDefine(TestID_SA1_IRamProtection_D5)
		%TestDefine(TestID_SA1_IRamProtection_D6)
		%TestDefine(TestID_SA1_IRamProtection_D7)
		%TestDefine(TestID_SA1_IRamProtection_DMulti)
		%TestDefine(TestID_SNES_BwRamProtection_SNES)
		%TestDefine(TestID_SA1_BwRamProtection_SNES)
		%TestDefine(TestID_SNES_BwRamProtection_SA1)
		%TestDefine(TestID_SA1_BwRamProtection_SA1)
		;%TestDefine(TestID_SNES_BwRamProtection_W00)
		;%TestDefine(TestID_SNES_BwRamProtection_W01)
		;%TestDefine(TestID_SNES_BwRamProtection_W02)
		;%TestDefine(TestID_SNES_BwRamProtection_W03)
		;%TestDefine(TestID_SNES_BwRamProtection_W04)
		;%TestDefine(TestID_SNES_BwRamProtection_W05)
		;%TestDefine(TestID_SNES_BwRamProtection_W06)
		;%TestDefine(TestID_SNES_BwRamProtection_W07)
		;%TestDefine(TestID_SNES_BwRamProtection_W08)
		;%TestDefine(TestID_SNES_BwRamProtection_W09)
		;%TestDefine(TestID_SNES_BwRamProtection_W0A)
		;%TestDefine(TestID_SNES_BwRamProtection_W0B)
		;%TestDefine(TestID_SNES_BwRamProtection_W0C)
		;%TestDefine(TestID_SNES_BwRamProtection_W0D)
		;%TestDefine(TestID_SNES_BwRamProtection_W0E)
		;%TestDefine(TestID_SNES_BwRamProtection_W0F)
		;%TestDefine(TestID_SNES_BwRamProtection_W10)
		;%TestDefine(TestID_SNES_BwRamProtection_W11)
		;%TestDefine(TestID_SNES_BwRamProtection_W20)
		;%TestDefine(TestID_SNES_BwRamProtection_W21)
		;%TestDefine(TestID_SNES_BwRamProtection_W30)
		;%TestDefine(TestID_SNES_BwRamProtection_W31)
		;%TestDefine(TestID_SNES_BwRamProtection_W40)
		;%TestDefine(TestID_SNES_BwRamProtection_W41)
		;%TestDefine(TestID_SNES_BwRamProtection_W80)
		;%TestDefine(TestID_SNES_BwRamProtection_W81)
		;%TestDefine(TestID_SA1_BwRamProtection_SWCW00)
		;%TestDefine(TestID_SA1_BwRamProtection_SWCW01)
		;%TestDefine(TestID_SA1_BwRamProtection_SPCW00)
		;%TestDefine(TestID_SA1_BwRamProtection_SPCW01)
		;%TestDefine(TestID_SA1_IRamMirror_000000)
		;%TestDefine(TestID_SA1_IRamMirror_003000)
		;%TestDefine(TestID_SA1_IRamMirror_800000)
		;%TestDefine(TestID_SA1_IRamMirror_803000)
		;%TestDefine(TestID_SNES_IRamMirror_003000)
		;%TestDefine(TestID_SNES_IRamMirror_803000)
		;%TestDefine(TestID_SA1_IRamProtectMirror_000000)
		;%TestDefine(TestID_SA1_IRamProtectMirror_800000)
		;%TestDefine(TestID_SA1_IRamProtectMirror_803000)
		;%TestDefine(TestID_SNES_IRamProtectMirror_803000)
		;%TestDefine(TestID_SA1_BwRamMirror_400000)
		;%TestDefine(TestID_SA1_BwRamMirror_006000)
		;%TestDefine(TestID_SA1_BwRamMirror_806000)
		;%TestDefine(TestID_SNES_BwRamMirror_400000)
		;%TestDefine(TestID_SNES_BwRamMirror_006000)
		;%TestDefine(TestID_SNES_BwRamMirror_806000)
		;%TestDefine(TestID_SA1_BwRamProtectOver)
		;%TestDefine(TestID_SNES_BwRamProtectOver)
		;%TestDefine(TestID_SA1_BwRamProtectMirror_006000)
		;%TestDefine(TestID_SA1_BwRamProtectMirror_806000)
		;%TestDefine(TestID_SNES_BwRamProtectMirror_006000)
		;%TestDefine(TestID_SNES_BwRamProtectMirror_806000)
		;%TestDefine(TestID_SA1_BwRamProtectMapping_Enable)
		;%TestDefine(TestID_SA1_BwRamProtectMapping_M00)
		;%TestDefine(TestID_SA1_BwRamProtectMapping_M01)
		;%TestDefine(TestID_SNES_BwRamProtectMapping_Enable)
		;%TestDefine(TestID_SNES_BwRamProtectMapping_M00)
		;%TestDefine(TestID_SNES_BwRamProtectMapping_M01)
		;%TestDefine(TestID_SNES_CIWP)
		;%TestDefine(TestID_SNES_CBWE)
		;%TestDefine(TestID_SA1_SIWP)
		;%TestDefine(TestID_SA1_SBWE)
		;%TestDefine(TestID_SA1_SBWE)
		;%TestDefine(TestID_SNES_IRamProtection_Stop)
		;%TestDefine(TestID_SNES_IRamProtection_StopChange)
		;%TestDefine(TestID_SNES_BwRamProtection_Stop)
		;%TestDefine(TestID_SNES_BwRamProtection_StopChange)
		;%TestDefine(TestID_SNES_IRamProtection_Reboot)
		;%TestDefine(TestID_SNES_BwRamProtection_Reboot)
		;%TestDefine(TestID_SA1_Reboot_SPL)
		;%TestDefine(TestID_SA1_Reboot_SPH)
		;%TestDefine(TestID_SA1_IRamProtection_Reboot)
		;%TestDefine(TestID_SA1_BwRamProtection_Reboot)

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
		LDA	!DisplayResult
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
		LDX	!TestSnesStackPointerBootH
		JSR	DrawHexX
		LDX	!TestSnesStackPointerBootL
		JSR	DrawHexX

		%ScreenVramAddress($0D, $0A)
		LDX	!TestSa1StackPointerBootH
		JSR	DrawHexX
		LDX	!TestSa1StackPointerBootL
		JSR	DrawHexX

		; Test ID
		%ScreenVramAddress($0C, $0E)
		LDA	!DisplayTestID
		JSR	DrawByteDecimalRight

		; I-RAM protection
		%ScreenVramAddress($12, $11)
		LDA	!DisplayIRamSnesExpected
		JSR	DrawIRamProtection

		%ScreenVramAddress($12, $12)
		LDA	!DisplayIRamSnesActual
		JSR	DrawIRamProtection

		%ScreenVramAddress($12, $13)
		LDA	!DisplayIRamSa1Expected
		JSR	DrawIRamProtection

		%ScreenVramAddress($12, $14)
		LDA	!DisplayIRamSa1Actual
		JSR	DrawIRamProtection

		; BW-RAM protection
		%ScreenVramAddress($12, $17)
		LDA	!DisplayBwRamSnesExpected+1
		XBA
		LDA	!DisplayBwRamSnesExpected+0
		JSR	DrawBwRamProtection

		%ScreenVramAddress($12, $18)
		LDA	!DisplayBwRamSnesActual+1
		XBA
		LDA	!DisplayBwRamSnesActual+0
		JSR	DrawBwRamProtection

		%ScreenVramAddress($12, $19)
		LDA	!DisplayBwRamSa1Expected+1
		XBA
		LDA	!DisplayBwRamSa1Expected+0
		JSR	DrawBwRamProtection

		%ScreenVramAddress($12, $1A)
		LDA	!DisplayBwRamSa1Actual+1
		XBA
		LDA	!DisplayBwRamSa1Actual+0
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
		JSR	TestPattern_SNES_001
		JMP	TestPattern_SNES_002



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
		LDX	!DisplayResult			; | SA-1 CPU clear reset
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
		JSR	GetStackPointeTestID
		STA	!TestingID
		TAX

		BIT	!DisplayResult
		BMI	+
		;LDA	!TestingID
		STA	!DisplayTestID
+
		LDA	!Sa1MessageByte
		STA	!TestSa1StackPointerBootL
		STA	!TestActuals, X
		JMP	TestSnesExecute

SNESMessage_Boot_SPH:
!TestID		:= !TestID_SA1_Boot_SPH
		JSR	GetStackPointeTestID
		INC	A
		STA	!TestingID
		TAX

		BIT	!DisplayResult
		BMI	+
		;LDA	!TestingID
		STA	!DisplayTestID
+
		LDA	!Sa1MessageByte
		STA	!TestSa1StackPointerBootH
		STA	!TestActuals, X
		JMP	TestSnesExecute

SNESMessage_TestReady:
		LDA	!Sa1MessageByte
		JMP	TestInitialize

SNESMessage_TestSa1Expected:
		LDA	!Sa1MessageByte
		BIT	!DisplayResult
		BMI	+
		STA	!DisplayGeneralSa1Expected
+		STA	!TestGeneralSa1Expected
		LDX	!TestingID
		STA	!TestExpects, X
		RTS

SNESMessage_TestSa1Actual:
		LDA	!Sa1MessageByte
		BIT	!DisplayResult
		BMI	+
		STA	!DisplayGeneralSa1Actual
+		STA	!TestGeneralSa1Actual
		LDX	!TestingID
		STA	!TestActuals, X
		RTS

SNESMessage_TestSa1IRamExpected:
		LDA	!Sa1MessageByte
		BIT	!DisplayResult
		BMI	+
		STA	!DisplayIRamSa1Expected
+		STA	!TestIRamSa1Expected
		LDX	!TestingID
		STA	!TestExpects, X
		RTS

SNESMessage_TestSa1IRamActual:
		LDA	!Sa1MessageByte
		BIT	!DisplayResult
		BMI	+
		STA	!DisplayIRamSa1Actual
+		STA	!TestIRamSa1Actual
		LDX	!TestingID
		STA	!TestActuals, X
		RTS

SNESMessage_TestSa1BwRamExpectedE:
		LDA	!Sa1MessageByte
		BIT	!DisplayResult
		BMI	+
		STA	!DisplayBwRamSa1Expected+0
+		STA	!TestBwRamSa1Expected+0
		LDX	!TestingID
		STA	!TestExpects, X
		RTS

SNESMessage_TestSa1BwRamExpectedA:
		LDA	!Sa1MessageByte
		BIT	!DisplayResult
		BMI	+
		STA	!DisplayBwRamSa1Expected+1
+		STA	!TestBwRamSa1Expected+1
		LDX	!TestingID
		STA	!TestExpects, X
		RTS

SNESMessage_TestSa1BwRamActualE:
		LDA	!Sa1MessageByte
		BIT	!DisplayResult
		BMI	+
		STA	!DisplayBwRamSa1Actual+0
+		STA	!TestBwRamSa1Actual+0
		LDX	!TestingID
		ORA	!TestActuals, X
		STA	!TestActuals, X
		RTS

SNESMessage_TestSa1BwRamActualA:
		LDA	!Sa1MessageByte
		BIT	!DisplayResult
		BMI	+
		STA	!DisplayBwRamSa1Actual+1
+		STA	!TestBwRamSa1Actual+1
		LDX	!TestingID
		ORA	!TestActuals, X
		STA	!TestActuals, X
		RTS

SNESMessage_TestSnesExecute:
		JMP	TestSnesExecute

SNESMessage_TestCheck:
		JMP	TestResultCheck

SNESMessage_TestFinished:
		LDA	!DisplayResult
		BNE	+
		INC	!DisplayResult
+
		LDA.b	#!SNESStatus_TestFinished
		JSR	SetSnesStatus

		LDA.b	#%00000000			;\  disable SA-1 to SNES IRQ
		STA	!SA1_SIE			;/

		JSR	TestBwRamSize

		LDA	!DisplayResult
		STA	!TestFinished

		RTS

GetStackPointeTestID:
		; .shortm, .shortx
		LDA	!TestingID
		CMP.b	#!TestID_SA1_Boot_SPH+1		;   !TestID_SA1_Boot_SPL
		BCS	+
		LDA.b	#!TestID_SA1_Boot_SPL
		RTS
+		LDA.b	#$FF				;   Invalid
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
macro	JumpSA1TestRoutine(id)
	if defined("TestDefined_<id>")
		if <id> >= 100
				JMP	TestPattern_SA1_<id>
			TestReturn_SA1_<id>:
		elseif <id> >= 10
				JMP	TestPattern_SA1_0<id>
			TestReturn_SA1_0<id>:
		else
				JMP	TestPattern_SA1_00<id>
			TestReturn_SA1_00<id>:
		endif
	endif
endmacro

SA1TestMain:
		; X = Initial stack pointer
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

		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_Boot)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtection_Boot)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_SNES)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_SNES)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_SA1)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_SA1)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_D0)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_D1)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_D2)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_D3)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_D4)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_D5)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_D6)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_D7)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_DMulti)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_D0)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_D1)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_D2)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_D3)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_D4)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_D5)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_D6)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_D7)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_DMulti)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_SNES)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtection_SNES)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_SA1)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtection_SA1)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W00)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W01)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W02)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W03)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W04)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W05)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W06)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W07)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W08)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W09)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W0A)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W0B)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W0C)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W0D)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W0E)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W0F)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W10)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W11)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W20)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W21)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W30)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W31)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W40)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W41)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W80)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_W81)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtection_SWCW00)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtection_SWCW01)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtection_SPCW00)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtection_SPCW01)
		%JumpSA1TestRoutine(!TestID_SA1_IRamMirror_000000)
		%JumpSA1TestRoutine(!TestID_SA1_IRamMirror_003000)
		%JumpSA1TestRoutine(!TestID_SA1_IRamMirror_800000)
		%JumpSA1TestRoutine(!TestID_SA1_IRamMirror_803000)
		%JumpSA1TestRoutine(!TestID_SNES_IRamMirror_003000)
		%JumpSA1TestRoutine(!TestID_SNES_IRamMirror_803000)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtectMirror_000000)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtectMirror_800000)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtectMirror_803000)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtectMirror_803000)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamMirror_400000)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamMirror_006000)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamMirror_806000)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamMirror_400000)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamMirror_006000)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamMirror_806000)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtectOver)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtectOver)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtectMirror_006000)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtectMirror_806000)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtectMirror_006000)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtectMirror_806000)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtectMapping_Enable)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtectMapping_M00)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtectMapping_M01)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtectMapping_Enable)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtectMapping_M00)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtectMapping_M01)
		%JumpSA1TestRoutine(!TestID_SNES_CIWP)
		%JumpSA1TestRoutine(!TestID_SNES_CBWE)
		%JumpSA1TestRoutine(!TestID_SA1_SIWP)
		%JumpSA1TestRoutine(!TestID_SA1_SBWE)
		%JumpSA1TestRoutine(!TestID_SA1_SBWE)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_Stop)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_StopChange)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_Stop)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_StopChange)
		%JumpSA1TestRoutine(!TestID_SNES_IRamProtection_Reboot)
		%JumpSA1TestRoutine(!TestID_SNES_BwRamProtection_Reboot)
		%JumpSA1TestRoutine(!TestID_SA1_Reboot_SPL)
		%JumpSA1TestRoutine(!TestID_SA1_Reboot_SPH)
		%JumpSA1TestRoutine(!TestID_SA1_IRamProtection_Reboot)
		%JumpSA1TestRoutine(!TestID_SA1_BwRamProtection_Reboot)

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
		CLV
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
;   if write enable, protection area is return $00.
;   if write full protect, protection area is return $0F.
TestBwRam:
		SEP	#$60
		REP	#$10
		; .shortm, .longx, SEV

		; %TestBwRam(bwp, addr1, addr2)	; bwp = previous area

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
		; .shortm, .shortx
		STA	!TestingID

		BIT	!DisplayResult
		BMI	.SkipDisplayBuffer

		STA	!DisplayTestID

		; clear display buffer
!ClearStart	:= !DisplayGeneralSnesExpected
!ClearEnd	:= !DisplayBwRamSa1Actual
		LDX.b	#(!ClearEnd-!ClearStart)
-		STZ	!ClearStart, X
		DEX
		BPL	-
.SkipDisplayBuffer

		; clear test buffer
!ClearStart	:= !TestGeneralSnesExpected
!ClearEnd	:= !TestBwRamSa1Actual
		LDX.b	#(!ClearEnd-!ClearStart)
-		STZ	!ClearStart, X
		DEX
		BPL	-

		RTS

TestResultCheck:
		; .shortm, .shortx
		LDX	!TestingID

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

		INC	!TestResults, X
		RTS

.Failed		LDA	!DisplayResult
		BNE	.SkipWrite
		DEC	!DisplayResult
.SkipWrite	DEC	!TestResults, X
		RTS

WriteTestGeneralSnesExpected:
		LDX	!TestingID
		STA	!TestExpects, X
		STA	!TestGeneralSnesExpected
		BIT	!DisplayResult
		BMI	.Return
		STA	!DisplayGeneralSnesExpected
.Return		RTS
WriteTestGeneralSnesActual:
		LDX	!TestingID
		STA	!TestActuals, X
		STA	!TestGeneralSnesActual
		BIT	!DisplayResult
		BMI	.Return
		STA	!DisplayGeneralSnesActual
.Return		RTS
WriteTestIRamSnesExpected:
		LDX	!TestingID
		STA	!TestExpects, X
		STA	!TestIRamSnesExpected
		BIT	!DisplayResult
		BMI	.Return
		STA	!DisplayIRamSnesExpected
.Return		RTS
WriteTestIRamSnesActual:
		LDX	!TestingID
		STA	!TestActuals, X
		STA	!TestIRamSnesActual
		BIT	!DisplayResult
		BMI	.Return
		STA	!DisplayIRamSnesActual
.Return		RTS
WriteTestBwRamSnesExpected:
		LDX	!TestingID
		STA	!TestBwRamSnesExpected+1
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		STA	!TestBwRamSnesExpected+0
		ORA	!TestBwRamSnesExpected+1
		STA	!TestExpects, X
		LDA	!TestBwRamSnesExpected+1

		BIT	!DisplayResult
		BMI	.Return
		STA	!DisplayBwRamSnesExpected+1
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		STA	!DisplayBwRamSnesExpected+0
.Return		RTS
WriteTestBwRamSnesActual:
		LDX	!TestingID
		STA	!TestBwRamSnesActual+1
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		STA	!TestBwRamSnesActual+0
		ORA	!TestBwRamSnesActual+1
		STA	!TestActuals, X
		LDA	!TestBwRamSnesExpected+1

		BIT	!DisplayResult
		BMI	.Return
		STA	!DisplayBwRamSnesActual+1
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		STA	!DisplayBwRamSnesActual+0
.Return		RTS

WriteTestExpectsMessageByte:
		LDX	!TestingID
		LDA	!Sa1MessageByte
		STA	TestExpects, X
		RTS


SetSnesIRam:
		SEP	#$30
		; .shortm, .shortx

		LDA	!Sa1MessageByte
		STA	!SA1_SIWP
		RTS

TestSnesIRam:
		SEP	#$30
		; .shortm, .shortx

		LDA	!Sa1MessageByte
		STA	!SA1_SIWP

		JSR	WriteTestIRamSnesExpected
		JSR	TestIRam
		JSR	WriteTestIRamSnesActual
		JMP	TestResultCheck

TestSnesBwRam:
		LDA	!Sa1MessageByte
		JSR	WriteTestBwRamSnesExpected
		JSR	TestBwRam
		JSR	WriteTestBwRamSnesActual
		JMP	TestResultCheck


;--------------------------------------------------

macro	TestPattern(target, id)
		!TestID		:= <id>

		if <id> >= 100
			TestPattern_<target>_<id>:
		elseif <id> >= 10
			TestPattern_<target>_0<id>:
		else
			TestPattern_<target>_00<id>:
		endif
endmacro
macro	TestPattern_ID(id)
		!TestID		:= <id>
endmacro
macro	TestPattern_SNES()
		%TestPattern(SNES, !TestID)
endmacro
macro	TestPattern_SA1()
		%TestPattern(SA1, !TestID)
endmacro


macro	TestSnesHandlerDef(id)
	if defined("TestDefined_<id>")
		org	.TestRoutineTable+((<id>-1)*2)
		if <id> >= 100
			dw	TestPattern_SNES_<id>
		elseif <id> >= 10
			dw	TestPattern_SNES_0<id>
		else
			dw	TestPattern_SNES_00<id>
		endif
	endif
endmacro
macro	TestSnesHandlerNop(id)
		org	.TestRoutineTable+((<id>-1)*2)
		dw	TestPattern_SNES_NOP
endmacro

macro	TestReturn_SA1Main(id)
		if <id> >= 100
			JMP	TestReturn_SA1_<id>
		elseif <id> >= 10
			JMP	TestReturn_SA1_0<id>
		else
			JMP	TestReturn_SA1_00<id>
		endif
endmacro
macro	TestReturn_SA1()
		%TestReturn_SA1Main(!TestID)
endmacro

TestSnesExecute:
		REP	#$30
		; .longm, .longx
		LDA	!TestingID
		AND.w	#$00FF
		DEC	A
		ASL
		TAX
		JMP	(.TestRoutineTable, X)

.TestRoutineTable
		pushpc
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_Boot)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_Boot)
		%TestSnesHandlerDef(!TestID_SA1_Boot_SPL)
		%TestSnesHandlerDef(!TestID_SA1_Boot_SPH)
		%TestSnesHandlerNop(!TestID_SA1_IRamProtection_Boot)
		%TestSnesHandlerNop(!TestID_SA1_BwRamProtection_Boot)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_SNES)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_SNES)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_SA1)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_SA1)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_D0)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_D1)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_D2)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_D3)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_D4)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_D5)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_D6)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_D7)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_DMulti)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_D0)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_D1)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_D2)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_D3)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_D4)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_D5)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_D6)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_D7)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_DMulti)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_SNES)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtection_SNES)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_SA1)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtection_SA1)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W00)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W01)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W02)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W03)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W04)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W05)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W06)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W07)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W08)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W09)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W0A)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W0B)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W0C)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W0D)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W0E)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W0F)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W10)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W11)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W20)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W21)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W30)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W31)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W40)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W41)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W80)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_W81)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtection_SWCW00)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtection_SWCW01)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtection_SPCW00)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtection_SPCW01)
		%TestSnesHandlerDef(!TestID_SA1_IRamMirror_000000)
		%TestSnesHandlerDef(!TestID_SA1_IRamMirror_003000)
		%TestSnesHandlerDef(!TestID_SA1_IRamMirror_800000)
		%TestSnesHandlerDef(!TestID_SA1_IRamMirror_803000)
		%TestSnesHandlerDef(!TestID_SNES_IRamMirror_003000)
		%TestSnesHandlerDef(!TestID_SNES_IRamMirror_803000)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtectMirror_000000)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtectMirror_800000)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtectMirror_803000)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtectMirror_803000)
		%TestSnesHandlerDef(!TestID_SA1_BwRamMirror_400000)
		%TestSnesHandlerDef(!TestID_SA1_BwRamMirror_006000)
		%TestSnesHandlerDef(!TestID_SA1_BwRamMirror_806000)
		%TestSnesHandlerDef(!TestID_SNES_BwRamMirror_400000)
		%TestSnesHandlerDef(!TestID_SNES_BwRamMirror_006000)
		%TestSnesHandlerDef(!TestID_SNES_BwRamMirror_806000)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtectOver)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtectOver)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtectMirror_006000)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtectMirror_806000)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtectMirror_006000)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtectMirror_806000)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtectMapping_Enable)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtectMapping_M00)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtectMapping_M01)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtectMapping_Enable)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtectMapping_M00)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtectMapping_M01)
		%TestSnesHandlerDef(!TestID_SNES_CIWP)
		%TestSnesHandlerDef(!TestID_SNES_CBWE)
		%TestSnesHandlerDef(!TestID_SA1_SIWP)
		%TestSnesHandlerDef(!TestID_SA1_SBWE)
		%TestSnesHandlerDef(!TestID_SA1_SBWE)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_Stop)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_StopChange)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_Stop)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_StopChange)
		%TestSnesHandlerDef(!TestID_SNES_IRamProtection_Reboot)
		%TestSnesHandlerDef(!TestID_SNES_BwRamProtection_Reboot)
		%TestSnesHandlerDef(!TestID_SA1_Reboot_SPL)
		%TestSnesHandlerDef(!TestID_SA1_Reboot_SPH)
		%TestSnesHandlerDef(!TestID_SA1_IRamProtection_Reboot)
		%TestSnesHandlerDef(!TestID_SA1_BwRamProtection_Reboot)
		pullpc
		skip	!TestID_Count*2

TestPattern_SNES_NOP:
		RTS

!TestID		:= 0

TestPattern_Pass:
		SEP	#$30
		; .shortm, .shortx
		LDX	!TestingID
		INC	!TestResults, X
		RTS

;--- Boot
%TestPattern_ID(!TestID_SNES_IRamProtection_Boot)	;-----
%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#!TestID
		JSR	TestInitialize
		LDA.b	#%00000000
		JSR	WriteTestIRamSnesExpected
		JSR	TestIRam
		JSR	WriteTestIRamSnesActual

		JMP	TestResultCheck

%TestPattern_ID(!TestID_SNES_BwRamProtection_Boot)	;----
%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#!TestID
		JSR	TestInitialize
		CLV
		LDA.b	#$0F
		JSR	WriteTestBwRamSnesExpected
		JSR	TestBwRam
		JSR	WriteTestBwRamSnesActual

		JMP	TestResultCheck

%TestPattern_ID(!TestID_SA1_Boot_SPL)	; Boot stack pointer	;----
%TestPattern_SNES()
		JMP	TestPattern_Pass
%TestPattern_ID(!TestID_SA1_Boot_SPH)	; Boot stack pointer	;----
%TestPattern_SNES()
		JMP	TestPattern_Pass

%TestPattern_ID(!TestID_SA1_IRamProtection_Boot)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1IRamExpected, $00)
		%SoftwareJSR(TestIRam)
		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_ID(!TestID_SA1_BwRamProtection_Boot)	;----
%TestPattern_SA1()
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

		%TestReturn_SA1()

;--- I-RAM Protection
%TestPattern_ID(!TestID_SNES_IRamProtection_SNES)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%11111111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %00000000)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	TestSnesIRam

%TestPattern_ID(!TestID_SNES_IRamProtection_SA1)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%11111111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1IRamExpected, %11111111)
		%SendSA1Message(!Message_TestSnesExecute, %00000000)
		%SoftwareJSR(TestIRam)
		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	SetSnesIRam

%TestPattern_ID(!TestID_SA1_IRamProtection_SNES)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00000000
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %11111111)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	TestSnesIRam

%TestPattern_ID(!TestID_SA1_IRamProtection_SA1)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00000000
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %11111111)
		%SendSA1Message(!Message_TestSa1IRamExpected, %00000000)
		%SoftwareJSR(TestIRam)
		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	SetSnesIRam


macro	TestSnesIRamProtectionDx(id, expected)
%TestPattern_ID(<id>)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%11111111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, <id>)
		%SendSA1Message(!Message_TestSnesExecute, <expected>)

		%TestReturn_SA1Main(<id>)

%TestPattern_SNES()
		JMP	TestSnesIRam
endmacro

%TestSnesIRamProtectionDx(!TestID_SNES_IRamProtection_D0, %00000001)
%TestSnesIRamProtectionDx(!TestID_SNES_IRamProtection_D1, %00000010)
%TestSnesIRamProtectionDx(!TestID_SNES_IRamProtection_D2, %00000100)
%TestSnesIRamProtectionDx(!TestID_SNES_IRamProtection_D3, %00001000)
%TestSnesIRamProtectionDx(!TestID_SNES_IRamProtection_D4, %00010000)
%TestSnesIRamProtectionDx(!TestID_SNES_IRamProtection_D5, %00100000)
%TestSnesIRamProtectionDx(!TestID_SNES_IRamProtection_D6, %01000000)
%TestSnesIRamProtectionDx(!TestID_SNES_IRamProtection_D7, %10000000)
%TestSnesIRamProtectionDx(!TestID_SNES_IRamProtection_DMulti, %00110101)

macro	TestSa1IRamProtectionDx(id, expected)
%TestPattern_ID(<id>)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#<expected>
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, <id>)
		%SendSA1Message(!Message_TestSnesExecute, %11111111)
		%SendSA1Message(!Message_TestSa1IRamExpected, <expected>)
		%SoftwareJSR(TestIRam)
		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1Main(<id>)

%TestPattern_SNES()
		JMP	SetSnesIRam
endmacro

%TestSa1IRamProtectionDx(!TestID_SA1_IRamProtection_D0, %00000001)
%TestSa1IRamProtectionDx(!TestID_SA1_IRamProtection_D1, %00000010)
%TestSa1IRamProtectionDx(!TestID_SA1_IRamProtection_D2, %00000100)
%TestSa1IRamProtectionDx(!TestID_SA1_IRamProtection_D3, %00001000)
%TestSa1IRamProtectionDx(!TestID_SA1_IRamProtection_D4, %00010000)
%TestSa1IRamProtectionDx(!TestID_SA1_IRamProtection_D5, %00100000)
%TestSa1IRamProtectionDx(!TestID_SA1_IRamProtection_D6, %01000000)
%TestSa1IRamProtectionDx(!TestID_SA1_IRamProtection_D7, %10000000)
%TestSa1IRamProtectionDx(!TestID_SA1_IRamProtection_DMulti, %11001010)

;--- BW-RAM Protection
%TestPattern_ID(!TestID_SNES_BwRamProtection_SNES)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%10000000
		STA	!SA1_CBWE

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %00001111)		; TestExpects

		%TestReturn_SA1()

%TestPattern_SNES()
		CLV
		SEP	#$30
		STZ	!SA1_SBWE
		; .shortm, .shortx
		LDA.b	#%11111111
		STA	!SA1_BWPA

		JMP	TestSnesBwRam

%TestPattern_ID(!TestID_SA1_BwRamProtection_SNES)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%10000000
		STA	!SA1_CBWE

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1BwRamExpectedE, %10000000)	; TestBwRamSa1Expected
		%SendSA1Message(!Message_TestSa1BwRamExpectedA, %00000000)	; TestBwRamSa1Actual
		%SendSA1Message(!Message_TestSnesExecute, %10000000)		; TestExpects
		%SoftwareJSR(TestBwRam)
		%SendSA1MessageAcc(!Message_TestSa1BwRamActualA)
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		%SendSA1MessageAcc(!Message_TestSa1BwRamActualE)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx
		STZ	!SA1_SBWE
		LDA.b	#%11111111
		STA	!SA1_BWPA
		JMP	WriteTestExpectsMessageByte


%TestPattern_ID(!TestID_SNES_BwRamProtection_SA1)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00000000
		STA	!SA1_CBWE

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %00000000)		; TestExpects

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$70
		; .shortm, .shortx, SEV
		LDA.b	#%10000000
		STA	!SA1_SBWE
		STZ	!SA1_BWPA

		JMP	TestSnesBwRam

%TestPattern_ID(!TestID_SA1_BwRamProtection_SA1)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00000000
		STA	!SA1_CBWE

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1BwRamExpectedE, %00000000)	; TestBwRamSa1Expected
		%SendSA1Message(!Message_TestSa1BwRamExpectedA, %00000000)	; TestBwRamSa1Actual
		%SendSA1Message(!Message_TestSnesExecute, %00000000)		; TestExpects
		%SoftwareJSR(TestBwRam)
		%SendSA1MessageAcc(!Message_TestSa1BwRamActualA)
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		%SendSA1MessageAcc(!Message_TestSa1BwRamActualE)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx
		LDA.b	#%10000000
		STA	!SA1_SBWE
		STZ	!SA1_BWPA
		JMP	WriteTestExpectsMessageByte


macro	TestSnesBwRamProtectionWxx(id, setSWEN, setBWPA, expectedBWPA)
%TestPattern_ID(<id>)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%10000000
		STA	!SA1_CBWE

		%SendSA1Message(!Message_TestReady, <id>)
		%SendSA1Message(!Message_TestSnesExecute, <expectedBWPA>)	; TestExpects

		%TestReturn_SA1()

%TestPattern_SNES()
		if <setSWEN> != 0
			SEP	#$70
			; .shortm, .shortx, SEV
			LDA.b	#$80
			STA	!SA1_SBWE
		else
			CLV
			SEP	#$30
			; .shortm, .shortx
			STZ	!SA1_SBWE
		endif
		LDA.b	#<setBWPA>
		STA	!SA1_BWPA
		JMP	TestSnesBwRam
endmacro

macro	TestSa1BwRamProtectionWxx(id, setSWEN, setBWPA)
%TestPattern_ID(<id>)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		STZ	!SA1_CBWE

		%SendSA1Message(!Message_TestReady, <id>)
		%SendSA1Message(!Message_TestSa1BwRamExpectedE, %00000000)	; TestBwRamSa1Expected
		%SendSA1Message(!Message_TestSa1BwRamExpectedA, %00000000)	; TestBwRamSa1Actual
		%SendSA1Message(!Message_TestSnesExecute, %00000000)		; TestExpects
		%SoftwareJSR(TestBwRam)
		%SendSA1MessageAcc(!Message_TestSa1BwRamActualA)
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		%SendSA1MessageAcc(!Message_TestSa1BwRamActualE)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx, SEV
		if <setSWEN> != 0
			LDA.b	#$80
			STA	!SA1_SBWE
		else
			STZ	!SA1_SBWE
		endif
		LDA.b	#<setBWPA>
		STA	!SA1_BWPA
		JMP	WriteTestExpectsMessageByte
endmacro


;%TestPattern_ID()	;-----
;%TestPattern_SA1()
;%TestPattern_SNES()


