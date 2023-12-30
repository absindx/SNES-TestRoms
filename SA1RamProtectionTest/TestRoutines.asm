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
; Const
;--------------------------------------------------

!Sa1StartTestID		:= !TestID_SA1_IRamProtection_Boot
;!Sa1StartTestID		:= !TestID_SA1_BwRamMirror_400000
;!Sa1StartTestID		:= !TestID_SA1_BwRamProtectOver

!TestMirroringValue	= $AA

;--------------------------------------------------
; Test define
;--------------------------------------------------

!TestDefinedMax		:= 0
macro	TestDefineMain(id, name)
	; defined flag
	!TestDefined_<id>	= 1

	; check id skip
	if !TestDefinedMax+1 < <id>
		; MEMO: warn cannot output multiple outputs.
		print "Is the ID definition being skipped? ", dec(!TestDefinedMax), " -> ", dec(<id>)
	endif

	; update id
	if !TestDefinedMax < <id>
		!TestDefinedMax	:= <id>
	endif

	; define labels
	pushpc
		org	TestResults+<id>
		if <id> >= 100
			TestResults_<id>_<name>:	skip 1
		elseif <id> >= 10
			TestResults_0<id>_<name>:	skip 1
		else
			TestResults_00<id>_<name>:	skip 1
		endif

		org	TestActuals+<id>
		if <id> >= 100
			TestActuals_<id>_<name>:	skip 1
		elseif <id> >= 10
			TestActuals_0<id>_<name>:	skip 1
		else
			TestActuals_00<id>_<name>:	skip 1
		endif

		org	TestExpects+<id>
		if <id> >= 100
			TestExpects_<id>_<name>:	skip 1
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

		; Boot
		%TestDefine(TestID_SNES_IRamProtection_Boot)
		%TestDefine(TestID_SNES_BwRamProtection_Boot)
		%TestDefine(TestID_SA1_Boot_SPL)
		%TestDefine(TestID_SA1_Boot_SPH)
		%TestDefine(TestID_SA1_IRamProtection_Boot)
		%TestDefine(TestID_SA1_BwRamProtection_Boot)
		; I-RAM Protection
		%TestDefine(TestID_SNES_IRamProtection_Unprotect)
		%TestDefine(TestID_SA1_IRamProtection_Unprotect)
		%TestDefine(TestID_SNES_IRamProtection_SNES)
		%TestDefine(TestID_SA1_IRamProtection_SNES)
		%TestDefine(TestID_SNES_IRamProtection_SA1)
		%TestDefine(TestID_SA1_IRamProtection_SA1)
		%TestDefine(TestID_SNES_IRamProtection_Protect)
		%TestDefine(TestID_SA1_IRamProtection_Protect)
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
		; BW-RAM Protection
		%TestDefine(TestID_SNES_BwRamProtection_Unprotect)
		%TestDefine(TestID_SA1_BwRamProtection_Unprotect)
		%TestDefine(TestID_SNES_BwRamProtection_SNES)
		%TestDefine(TestID_SA1_BwRamProtection_SNES)
		%TestDefine(TestID_SNES_BwRamProtection_SA1)
		%TestDefine(TestID_SA1_BwRamProtection_SA1)
		%TestDefine(TestID_SNES_BwRamProtection_Protect)
		%TestDefine(TestID_SA1_BwRamProtection_Protect)
		%TestDefine(TestID_SNES_BwRamProtection_D00)
		%TestDefine(TestID_SNES_BwRamProtection_D01)
		%TestDefine(TestID_SNES_BwRamProtection_D02)
		%TestDefine(TestID_SNES_BwRamProtection_D03)
		%TestDefine(TestID_SNES_BwRamProtection_D04)
		%TestDefine(TestID_SNES_BwRamProtection_D05)
		%TestDefine(TestID_SNES_BwRamProtection_D06)
		%TestDefine(TestID_SNES_BwRamProtection_D07)
		%TestDefine(TestID_SNES_BwRamProtection_D08)
		%TestDefine(TestID_SNES_BwRamProtection_D09)
		%TestDefine(TestID_SNES_BwRamProtection_D0A)
		%TestDefine(TestID_SNES_BwRamProtection_D0B)
		%TestDefine(TestID_SNES_BwRamProtection_D0C)
		%TestDefine(TestID_SNES_BwRamProtection_D0D)
		%TestDefine(TestID_SNES_BwRamProtection_D0E)
		%TestDefine(TestID_SNES_BwRamProtection_D0F)
		%TestDefine(TestID_SNES_BwRamProtection_D10)
		%TestDefine(TestID_SNES_BwRamProtection_D11)
		%TestDefine(TestID_SNES_BwRamProtection_D20)
		%TestDefine(TestID_SNES_BwRamProtection_D21)
		%TestDefine(TestID_SNES_BwRamProtection_D30)
		%TestDefine(TestID_SNES_BwRamProtection_D31)
		%TestDefine(TestID_SNES_BwRamProtection_D40)
		%TestDefine(TestID_SNES_BwRamProtection_D41)
		%TestDefine(TestID_SNES_BwRamProtection_D80)
		%TestDefine(TestID_SNES_BwRamProtection_D81)
		%TestDefine(TestID_SNES_BwRamProtection_E00)
		%TestDefine(TestID_SNES_BwRamProtection_E01)
		%TestDefine(TestID_SNES_BwRamProtection_E02)
		%TestDefine(TestID_SNES_BwRamProtection_E03)
		%TestDefine(TestID_SNES_BwRamProtection_E04)
		%TestDefine(TestID_SNES_BwRamProtection_E05)
		%TestDefine(TestID_SNES_BwRamProtection_E06)
		%TestDefine(TestID_SNES_BwRamProtection_E07)
		%TestDefine(TestID_SNES_BwRamProtection_E08)
		%TestDefine(TestID_SNES_BwRamProtection_E09)
		%TestDefine(TestID_SNES_BwRamProtection_E0A)
		%TestDefine(TestID_SNES_BwRamProtection_E0B)
		%TestDefine(TestID_SNES_BwRamProtection_E0C)
		%TestDefine(TestID_SNES_BwRamProtection_E0D)
		%TestDefine(TestID_SNES_BwRamProtection_E0E)
		%TestDefine(TestID_SNES_BwRamProtection_E0F)
		%TestDefine(TestID_SNES_BwRamProtection_E10)
		%TestDefine(TestID_SNES_BwRamProtection_E11)
		%TestDefine(TestID_SNES_BwRamProtection_E20)
		%TestDefine(TestID_SNES_BwRamProtection_E21)
		%TestDefine(TestID_SNES_BwRamProtection_E30)
		%TestDefine(TestID_SNES_BwRamProtection_E31)
		%TestDefine(TestID_SNES_BwRamProtection_E40)
		%TestDefine(TestID_SNES_BwRamProtection_E41)
		%TestDefine(TestID_SNES_BwRamProtection_E80)
		%TestDefine(TestID_SNES_BwRamProtection_E81)
		%TestDefine(TestID_SA1_BwRamProtection_D00)
		%TestDefine(TestID_SA1_BwRamProtection_D01)
		%TestDefine(TestID_SA1_BwRamProtection_D02)
		%TestDefine(TestID_SA1_BwRamProtection_D03)
		%TestDefine(TestID_SA1_BwRamProtection_D04)
		%TestDefine(TestID_SA1_BwRamProtection_D05)
		%TestDefine(TestID_SA1_BwRamProtection_D06)
		%TestDefine(TestID_SA1_BwRamProtection_D07)
		%TestDefine(TestID_SA1_BwRamProtection_D08)
		%TestDefine(TestID_SA1_BwRamProtection_D09)
		%TestDefine(TestID_SA1_BwRamProtection_D0A)
		%TestDefine(TestID_SA1_BwRamProtection_D0B)
		%TestDefine(TestID_SA1_BwRamProtection_D0C)
		%TestDefine(TestID_SA1_BwRamProtection_D0D)
		%TestDefine(TestID_SA1_BwRamProtection_D0E)
		%TestDefine(TestID_SA1_BwRamProtection_D0F)
		%TestDefine(TestID_SA1_BwRamProtection_D10)
		%TestDefine(TestID_SA1_BwRamProtection_D11)
		%TestDefine(TestID_SA1_BwRamProtection_D20)
		%TestDefine(TestID_SA1_BwRamProtection_D21)
		%TestDefine(TestID_SA1_BwRamProtection_D30)
		%TestDefine(TestID_SA1_BwRamProtection_D31)
		%TestDefine(TestID_SA1_BwRamProtection_D40)
		%TestDefine(TestID_SA1_BwRamProtection_D41)
		%TestDefine(TestID_SA1_BwRamProtection_D80)
		%TestDefine(TestID_SA1_BwRamProtection_D81)
		%TestDefine(TestID_SA1_BwRamProtection_E00)
		%TestDefine(TestID_SA1_BwRamProtection_E01)
		%TestDefine(TestID_SA1_BwRamProtection_E02)
		%TestDefine(TestID_SA1_BwRamProtection_E03)
		%TestDefine(TestID_SA1_BwRamProtection_E04)
		%TestDefine(TestID_SA1_BwRamProtection_E05)
		%TestDefine(TestID_SA1_BwRamProtection_E06)
		%TestDefine(TestID_SA1_BwRamProtection_E07)
		%TestDefine(TestID_SA1_BwRamProtection_E08)
		%TestDefine(TestID_SA1_BwRamProtection_E09)
		%TestDefine(TestID_SA1_BwRamProtection_E0A)
		%TestDefine(TestID_SA1_BwRamProtection_E0B)
		%TestDefine(TestID_SA1_BwRamProtection_E0C)
		%TestDefine(TestID_SA1_BwRamProtection_E0D)
		%TestDefine(TestID_SA1_BwRamProtection_E0E)
		%TestDefine(TestID_SA1_BwRamProtection_E0F)
		%TestDefine(TestID_SA1_BwRamProtection_E10)
		%TestDefine(TestID_SA1_BwRamProtection_E11)
		%TestDefine(TestID_SA1_BwRamProtection_E20)
		%TestDefine(TestID_SA1_BwRamProtection_E21)
		%TestDefine(TestID_SA1_BwRamProtection_E30)
		%TestDefine(TestID_SA1_BwRamProtection_E31)
		%TestDefine(TestID_SA1_BwRamProtection_E40)
		%TestDefine(TestID_SA1_BwRamProtection_E41)
		%TestDefine(TestID_SA1_BwRamProtection_E80)
		%TestDefine(TestID_SA1_BwRamProtection_E81)
		; I-RAM Mirroring
		%TestDefine(TestID_SA1_IRamMirror_000000)
		%TestDefine(TestID_SA1_IRamMirror_003000)
		%TestDefine(TestID_SA1_IRamMirror_800000)
		%TestDefine(TestID_SA1_IRamMirror_803000)
		%TestDefine(TestID_SNES_IRamMirror_003000)
		%TestDefine(TestID_SNES_IRamMirror_803000)
		; I-RAM Mirroring Protection
		%TestDefine(TestID_SA1_IRamProtectMirror_000000)
		%TestDefine(TestID_SA1_IRamProtectMirror_800000)
		%TestDefine(TestID_SA1_IRamProtectMirror_803000)
		%TestDefine(TestID_SNES_IRamProtectMirror_803000)
		; BW-RAM Mirroring
		%TestDefine(TestID_SA1_BwRamMirror_400000)
		%TestDefine(TestID_SA1_BwRamMirror_006000)
		%TestDefine(TestID_SA1_BwRamMirror_806000)
		%TestDefine(TestID_SNES_BwRamMirror_400000)
		%TestDefine(TestID_SNES_BwRamMirror_006000)
		%TestDefine(TestID_SNES_BwRamMirror_806000)
		%TestDefine(TestID_SA1_BwRamProtectOver)
		%TestDefine(TestID_SNES_BwRamProtectOver)
		; BW-RAM Mirroring Protection
		;%TestDefine(TestID_SA1_BwRamProtectMapping_Enable)
		;%TestDefine(TestID_SA1_BwRamProtectMapping_M00P)
		;%TestDefine(TestID_SA1_BwRamProtectMapping_M00)
		;%TestDefine(TestID_SA1_BwRamProtectMapping_M01)
		;%TestDefine(TestID_SNES_BwRamProtectMapping_Enable)
		;%TestDefine(TestID_SNES_BwRamProtectMapping_M00P)
		;%TestDefine(TestID_SNES_BwRamProtectMapping_M00)
		;%TestDefine(TestID_SNES_BwRamProtectMapping_M01)
		; Write order
		;%TestDefine(TestID_SA1_IRamProtectionOrder_CS)
		;%TestDefine(TestID_SA1_IRamProtectionOrder_SC)
		;%TestDefine(TestID_SNES_IRamProtectionOrder_CS)
		;%TestDefine(TestID_SNES_IRamProtectionOrder_SC)
		;%TestDefine(TestID_SA1_BwRamProtectOrder_CSB)
		;%TestDefine(TestID_SA1_BwRamProtectOrder_CBS)
		;%TestDefine(TestID_SA1_BwRamProtectOrder_SCB)
		;%TestDefine(TestID_SA1_BwRamProtectOrder_SBC)
		;%TestDefine(TestID_SA1_BwRamProtectOrder_BCS)
		;%TestDefine(TestID_SA1_BwRamProtectOrder_BSC)
		;%TestDefine(TestID_SNES_BwRamProtectOrder_CSB)
		;%TestDefine(TestID_SNES_BwRamProtectOrder_CBS)
		;%TestDefine(TestID_SNES_BwRamProtectOrder_SCB)
		;%TestDefine(TestID_SNES_BwRamProtectOrder_SBC)
		;%TestDefine(TestID_SNES_BwRamProtectOrder_BCS)
		;%TestDefine(TestID_SNES_BwRamProtectOrder_BSC)
		; Wrong register
		;%TestDefine(TestID_SNES_CIWP)
		;%TestDefine(TestID_SNES_CBWE)
		;%TestDefine(TestID_SA1_SIWP)
		;%TestDefine(TestID_SA1_SBWE)
		;%TestDefine(TestID_SA1_SBWE)
		; SA-1 STP
		;%TestDefine(TestID_SNES_IRamProtection_Stop)
		;%TestDefine(TestID_SNES_IRamProtection_StopChange)
		;%TestDefine(TestID_SNES_BwRamProtection_Stop)
		;%TestDefine(TestID_SNES_BwRamProtection_StopChange)
		; SA-1 STP -> Reboot
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
		LDX	!DisplayBwRamSnesExpected+1
		LDA	!DisplayBwRamSnesExpected+0
		JSR	DrawBwRamProtection

		%ScreenVramAddress($12, $18)
		LDX	!DisplayBwRamSnesActual+1
		LDA	!DisplayBwRamSnesActual+0
		JSR	DrawBwRamProtection

		%ScreenVramAddress($12, $19)
		LDX	!DisplayBwRamSa1Expected+1
		LDA	!DisplayBwRamSa1Expected+0
		JSR	DrawBwRamProtection

		%ScreenVramAddress($12, $1A)
		LDX	!DisplayBwRamSa1Actual+1
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
.Off		LDA.b	#!BwRamBit_Off
		STA	!PPU_VMDATAL
		STA	!PPU_VMDATAL
.Value		STZ	!PPU_VMDATAL
		LDA.b	#'$'
		STA	!PPU_VMDATAL
		JMP	DrawHexX



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
		LDY	!DisplayResult			; | SA-1 CPU clear reset
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
		ORA	!TestExpects, X
		STA	!TestExpects, X
		RTS

SNESMessage_TestSa1Actual:
		LDA	!Sa1MessageByte
		BIT	!DisplayResult
		BMI	+
		STA	!DisplayGeneralSa1Actual
+		STA	!TestGeneralSa1Actual
		LDX	!TestingID
		ORA	!TestActuals, X
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
		BNE	+
		BRA	SA1TestFinished
+
	else
		; none
	endif

		LDA.b	#!Sa1StartTestID
		JMP	TestSa1Execute

SA1TestFinished:
		SEP	#$30
		; .shortm, .shortx

		%SendSA1Message(!Message_TestFinished, $00)

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
; Return: Mirrored = 1
macro	TestMirror(addr1, addr2, expected)
?TestMirror:
		TAX
		LDA.b	#<expected>
		CMP.l	<addr1>
		BEQ	?.Test2
		CLC
		BCS	?.Return
?.Test2		CMP.l	<addr2>
		CLC
		BNE	?.Return
		SEC
?.Return	TXA
		ROR
endmacro

macro	TestIRamAreaProtect(addr)
?TestIRamAreaProtect:
		TAX
		%TestMemory(<addr>, l)
		BEQ	?.Enable
		%TestMemory(<addr>+$FF, l)
		BEQ	?.Enable
		CLC
		BCC	?.Return
?.Enable
		SEC
?.Return	TXA
		ROR
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

ClearIRam:
		REP	#$20
		SEP	#$10
		; .longm, .shortx

		LDX.b	#$00
.Loop		STZ	$3000, X
		STZ	$3100, X
		STZ	$3200, X
		STZ	$3300, X
		STZ	$3400, X
		STZ	$3500, X
		STZ	$3600, X
		STZ	$3700, X
		INX
		INX
		BNE	.Loop

		RTS

ClearBwRam:
		REP	#$30
		; .longm, .longx

		LDA.w	#$0000
		STA	!SA1_BWRam
		STA	!SA1_BWRam+$010000

		TAX					;\  A = $FFFF (65536 bytes)
		TAY					; | X = $0000 (src)
		INY					; | Y = $0001 (dst)
		DEC	A				;/
                MVN	!SA1_BWRam>>16, !SA1_BWRam>>16			;   dst, src
                MVN	(!SA1_BWRam+$010000)>>16, !SA1_BWRam>>16	;   dst, src

		INC	A				;\
		DEY					; | DB = $00
		MVN	$00, $00			;/

		RTS

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
		%TestBwRam($00, $000000, $0000FF)	; $400000-$4000FF

		; Test BWPA
		CLV

		%TestBwRam($00, $000100, $0001FF)	; $400000-$4001FF
		%TestBwRam($01, $000200, $0003FF)	; $400000-$4003FF
		%TestBwRam($02, $000400, $0007FF)	; $400000-$4007FF
		%TestBwRam($03, $000800, $000FFF)	; $400000-$400FFF
		%TestBwRam($04, $001000, $001FFF)	; $400000-$401FFF
		%TestBwRam($05, $002000, $003FFF)	; $400000-$403FFF
		%TestBwRam($06, $004000, $007FFF)	; $400000-$407FFF
		%TestBwRam($07, $008000, $00FFFF)	; $400000-$40FFFF
		%TestBwRam($08, $010000, $01FFFF)	; $400000-$41FFFF
		%TestBwRam($09, $020000, $03FFFF)	; $400000-$43FFFF
		%TestBwRam($0A, $040000, $07FFFF)	; $400000-$47FFFF
		%TestBwRam($0B, $080000, $0FFFFF)	; $400000-$4FFFFF
		%TestBwRam($0C, $100000, $1FFFFF)	; $400000-$5FFFFF

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
		LDX.b	#(!ClearEnd-!ClearStart+1)
-		STZ	!ClearStart, X
		DEX
		BPL	-
.SkipDisplayBuffer

		; clear test buffer
!ClearStart	:= !TestGeneralSnesExpected
!ClearEnd	:= !TestBwRamSa1Actual
		LDX.b	#(!ClearEnd-!ClearStart+1)
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

.Failed
		LDA	!DisplayResult
		BNE	.SkipWrite
		DEC	!DisplayResult

.SkipWrite
		DEC	!TestResults, X

	if !StopFailed
		JSR	ScreenOn
-		WAI
		JSR	UpdateJoypad
		BIT	JoypadPress+0
		BPL	-
		STZ	!DisplayResult
	endif

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

		BIT	!DisplayResult
		BMI	.Return
		LDA	!TestBwRamSnesExpected+1
		STA	!DisplayBwRamSnesExpected+1
		LDA	!TestBwRamSnesExpected+0
		STA	!DisplayBwRamSnesExpected+0
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

		BIT	!DisplayResult
		BMI	.Return
		LDA	!TestBwRamSnesActual+1
		STA	!DisplayBwRamSnesActual+1
		LDA	!TestBwRamSnesActual+0
		STA	!DisplayBwRamSnesActual+0
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


; BW-RAM Protection test routines
;   called from %TestSa1BwRamProtection()
; SA1:
;   A   = testExpected | id
;   X   = expectedSa1Enable
;   Y   = expectedSa1Area
;   P.V = setCWEN
; SNES:
;   A   = setBWPA
;   X   = expectedSnesEnable
;   Y   = expectedSnesArea
;   P.V = setSWEN
TestSa1BwRamProtection_Sa1:
		SEP	#$30
		; .shortm, .shortx

		TCS								; <id> -> __S__ -> Y -> A
		%SendSA1MessageAcc(!Message_TestReady)

		LDA.b	#$00
		BVC	.ProtectDisable
		ORA.b	#$80
.ProtectDisable	STA	!SA1_CBWE						; <setCWEN> -> CBWE

		TXA
		%SendSA1MessageAcc(!Message_TestSa1BwRamExpectedE)		; <expectedSa1Enable> -> TestBwRamSa1Expected+0
		TYA
		%SendSA1MessageAcc(!Message_TestSa1BwRamExpectedA)		; <expectedSa1Area> -> TestBwRamSa1Expected+1
		XBA
		%SendSA1MessageAcc(!Message_TestSnesExecute)			; <testExcepts> -> TestExpects

		TSC
		TAY								; <id> -> S -> __Y__ -> A
		%SoftwareJSR(TestBwRam)
		%SendSA1MessageAcc(!Message_TestSa1BwRamActualA)		; TestBwRamSa1Actual+1
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		%SendSA1MessageAcc(!Message_TestSa1BwRamActualE)		; TestBwRamSa1Actual+0
		%SendSA1Message(!Message_TestCheck, $00)

		;%TestReturn_SA1()
		TYA								; <id> -> S -> Y -> __A__
		INC	A
		JMP	TestSa1Execute

TestSa1BwRamProtection_Snes:
		STA	!SA1_BWPA						; <setBWPA> -> BWPA

		LDA.b	#$00
		BVC	.ProtectDisable
		ORA.b	#$80
.ProtectDisable	STA	!SA1_SBWE						; <setSWEN> -> SBWE

		LDA	!Sa1MessageByte
		JMP	WriteTestExpectsMessageByte

TestSnesBwRamProtection_Sa1:
		SEP	#$30
		; .shortm, .shortx

		TAX								; <id> -> __X__ -> A
		%SendSA1MessageAcc(!Message_TestReady)				; <id> -> !TestingID

		LDA.b	#$00
		BVC	.ProtectDisable
		ORA.b	#$80
.ProtectDisable	STA	!SA1_CBWE						; <setCWEN> -> CBWE

		XBA
		%SendSA1MessageAcc(!Message_TestSnesExecute)			; <testExcepts> -> !TestBwRamSnesExpected+1

		;%TestReturn_SA1()
		TXA								; <id> -> X -> __A__
		INC	A
		JMP	TestSa1Execute

TestSnesBwRamProtection_Snes:
		STA	!SA1_BWPA

		LDA.b	#$00
		BVC	.ProtectDisable
		ORA.b	#$80
.ProtectDisable	STA	!SA1_SBWE						; <setSWEN> -> SBWE

		CLV					;\
		TXA					; | X -> P.V
		BEQ	+				; |
		SEP	#$40				; |
+							;/
		TYA
		JSR	WriteTestBwRamSnesExpected				; <expectedSnesEnable>, <expectedSnesArea> -> !TestBwRamSnesExpected
		JSR	WriteTestExpectsMessageByte
		JSR	TestBwRam
		JSR	WriteTestBwRamSnesActual
		JMP	TestResultCheck

!IRamMirror_Area_000000	= %00000001
!IRamMirror_Area_000800	= %00000010
!IRamMirror_Area_003000	= %00000100
!IRamMirror_Area_003800	= %00001000
!IRamMirror_Area_800000	= %00010000
!IRamMirror_Area_800800	= %00100000
!IRamMirror_Area_803000	= %01000000
!IRamMirror_Area_803800	= %10000000

; Argument:
;   A = TestID
;   X = Expected
TestIRamMirror_Sa1:
		; .shortm, .shortx
		TAY

		%SendSA1MessageAcc(!Message_TestReady)

		LDA.b	#%11111111
		STA	!SA1_CIWP

		TXA
		%SendSA1MessageAcc(!Message_TestSa1IRamExpected)
		%SendSA1Message(!Message_TestSnesExecute, $00)

		%SoftwareJSR(ClearIRam)
		SEP	#$30
		; .shortm, .shortx

		TYA
		SEC
		SBC.b	#!TestID_SA1_IRamMirror_000000
		TAX
		LDA.b	#!TestMirroringValue
		CPX.b	#$00				;\
		BNE	+				; | X = $00
		STA.l	$000000				; | Target address = $000000
		BRA	.Write				;/
+		DEX					;\
		BNE	+				; | X = $01
		STA.l	$003000				; | Target address = $003000
		BRA	.Write				;/
+		DEX					;\
		BNE	+				; | X = $02
		STA.l	$800000				; | Target address = $800000
		BRA	.Write				;/
+		;DEX					;\
		;BNE	+				; | X = $03
		STA.l	$803000				; | Target address = $803000
		;BRA	.Write				;/
.Write

		%SoftwareJSR(TestIRamMirrorCheck_Sa1)
		%SendSA1MessageAcc(!Message_TestSa1IRamActual)

		%SendSA1Message(!Message_TestSnesExecute, $01)

		;%TestReturn_SA1()
		TYA
		INC	A
		JMP	TestSa1Execute

; Argument:
;   A = Expected
TestIRamMirror_Snes:
		; .shortm, .shortx
		LDX	!Sa1MessageByte
		BNE	.Call2

.Call1		LDA.b	#%11111111
		STA	!SA1_SIWP
		RTS

.Call2
		JSR	WriteTestIRamSnesExpected
		JSR	TestIRamMirrorCheck_Snes
		JSR	WriteTestIRamSnesActual
		JMP	TestResultCheck

; Argument:
;   A = TestID
;   X = Expected
TestBwRamMirror_Sa1:
		; .shortm, .shortx
		TAY
		%SendSA1MessageAcc(!Message_TestReady)
		TXA
		%SendSA1MessageAcc(!Message_TestSa1BwRamExpectedA)
		%SendSA1Message(!Message_TestSnesExecute, $00)

		%SoftwareJSR(TestBwRamMirrorCheck)
		%SendSA1MessageAcc(!Message_TestSa1BwRamActualA)
		%SendSA1Message(!Message_TestSnesExecute, $01)

		;%TestReturn_SA1()
		TYA
		INC	A
		JMP	TestSa1Execute

; Return:
;   A = Result (bit=1: mirrored)
TestIRamMirrorCheck_Sa1:
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#$00
		%TestMirror($000000, $3F0000, !TestMirroringValue)
		%TestMirror($000800, $3F0800, !TestMirroringValue)
		%TestMirror($003000, $3F3000, !TestMirroringValue)
		%TestMirror($003800, $3F3800, !TestMirroringValue)
		%TestMirror($800000, $BF0000, !TestMirroringValue)
		%TestMirror($800800, $BF0800, !TestMirroringValue)
		%TestMirror($803000, $BF3000, !TestMirroringValue)
		%TestMirror($803800, $BF3800, !TestMirroringValue)

		RTS

; Return:
;   A = Result (bit=1: mirrored)
TestIRamMirrorCheck_Snes:
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#$00
		;;%TestMirror($000000, $3F0000, !TestMirroringValue)
		;LSR
		;;%TestMirror($000800, $3F0800, !TestMirroringValue)
		;LSR
		%TestMirror($003000, $3F3000, !TestMirroringValue)
		%TestMirror($003800, $3F3800, !TestMirroringValue)
		;%TestMirror($800000, $BF0000, !TestMirroringValue)
		LSR
		;%TestMirror($800800, $$BF0800, !TestMirroringValue)
		LSR
		%TestMirror($803000, $BF3000, !TestMirroringValue)
		%TestMirror($803800, $BF3800, !TestMirroringValue)
		RTS

!BwRamMirror_Area_006000	= %00000001
!BwRamMirror_Area_400000	= %00000010
!BwRamMirror_Area_440000	= %00000100
!BwRamMirror_Area_500000	= %00001000
!BwRamMirror_Area_700000	= %00010000
!BwRamMirror_Area_7E0000	= %00100000
!BwRamMirror_Area_806000	= %01000000
!BwRamMirror_Area_F00000	= %10000000

; Return:
;   A = Result (bit=1: mirrored)
TestBwRamMirrorCheck:
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#$00
		%TestMirror($006000, $3F6000, !TestMirroringValue)
		%TestMirror($400000, $400000, !TestMirroringValue)
		%TestMirror($440000, $4C0000, !TestMirroringValue)
		%TestMirror($500000, $5C0000, !TestMirroringValue)
		%TestMirror($700000, $7C0000, !TestMirroringValue)
		%TestMirror($7E0000, $7E0000, !TestMirroringValue)
		%TestMirror($806000, $BF6000, !TestMirroringValue)
		%TestMirror($F00000, $FC0000, !TestMirroringValue)

		RTS



;--------------------------------------------------

macro	ClearResult()
	if !Debug == 1
		STZ	!DisplayResult
	endif
endmacro

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

!TestHandlerMax	:= 0
macro	TestHandlerDefine(id)
	; check id skip
	if !TestHandlerMax+1 < <id>
		; can't use warn. f
		print "Is the test pattern definition being skipped? ", dec(!TestHandlerMax), " -> ", dec(<id>)
	endif

	; update id
	if !TestHandlerMax < <id>
		!TestHandlerMax	:= <id>
	endif

	; define data
	if defined("TestDefined_<id>")
		org	TestHandlerTable+((<id>-1)*4)
		if <id> >= 100
			dw	TestPattern_SA1_<id>
			dw	TestPattern_SNES_<id>
		elseif <id> >= 10
			dw	TestPattern_SA1_0<id>
			dw	TestPattern_SNES_0<id>
		else
			dw	TestPattern_SA1_00<id>
			dw	TestPattern_SNES_00<id>
		endif
	endif
endmacro

macro	TestReturn_SA1()
		LDA.b	#(!TestID+1)
		JMP	TestSa1Execute
endmacro

; Argument:
;   A = TestID
TestSa1Execute:
		REP	#$30
		; .longm, .longx
		AND.w	#$00FF
		DEC	A
		CMP.w	#!TestDefinedMax
		BCC	+
		JMP	SA1TestFinished
+		ASL
		ASL
		TAX
		JMP	(TestHandlerTable, X)

TestSnesExecute:
		REP	#$30
		; .longm, .longx
		LDA	!TestingID
		AND.w	#$00FF
		DEC	A
		ASL
		ASL				; CLC
		ADC.w	#$02
		TAX
		JMP	(TestHandlerTable, X)

TestHandlerTable:
		pushpc
		%TestHandlerDefine(!TestID_SNES_IRamProtection_Boot)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_Boot)
		%TestHandlerDefine(!TestID_SA1_Boot_SPL)
		%TestHandlerDefine(!TestID_SA1_Boot_SPH)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_Boot)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_Boot)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_Unprotect)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_Unprotect)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_SNES)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_SNES)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_SA1)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_SA1)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_Protect)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_Protect)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_D0)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_D1)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_D2)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_D3)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_D4)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_D5)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_D6)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_D7)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_DMulti)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_D0)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_D1)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_D2)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_D3)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_D4)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_D5)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_D6)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_D7)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_DMulti)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_Unprotect)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_Unprotect)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_SNES)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_SNES)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_SA1)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_SA1)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_Protect)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_Protect)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D00)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D01)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D02)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D03)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D04)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D05)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D06)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D07)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D08)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D09)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D0A)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D0B)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D0C)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D0D)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D0E)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D0F)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D10)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D11)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D20)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D21)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D30)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D31)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D40)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D41)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D80)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_D81)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E00)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E01)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E02)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E03)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E04)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E05)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E06)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E07)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E08)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E09)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E0A)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E0B)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E0C)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E0D)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E0E)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E0F)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E10)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E11)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E20)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E21)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E30)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E31)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E40)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E41)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E80)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_E81)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D00)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D01)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D02)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D03)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D04)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D05)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D06)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D07)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D08)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D09)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D0A)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D0B)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D0C)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D0D)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D0E)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D0F)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D10)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D11)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D20)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D21)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D30)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D31)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D40)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D41)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D80)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_D81)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E00)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E01)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E02)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E03)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E04)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E05)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E06)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E07)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E08)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E09)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E0A)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E0B)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E0C)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E0D)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E0E)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E0F)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E10)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E11)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E20)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E21)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E30)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E31)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E40)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E41)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E80)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_E81)
		%TestHandlerDefine(!TestID_SA1_IRamMirror_000000)
		%TestHandlerDefine(!TestID_SA1_IRamMirror_003000)
		%TestHandlerDefine(!TestID_SA1_IRamMirror_800000)
		%TestHandlerDefine(!TestID_SA1_IRamMirror_803000)
		%TestHandlerDefine(!TestID_SNES_IRamMirror_003000)
		%TestHandlerDefine(!TestID_SNES_IRamMirror_803000)
		%TestHandlerDefine(!TestID_SA1_IRamProtectMirror_000000)
		%TestHandlerDefine(!TestID_SA1_IRamProtectMirror_800000)
		%TestHandlerDefine(!TestID_SA1_IRamProtectMirror_803000)
		%TestHandlerDefine(!TestID_SNES_IRamProtectMirror_803000)
		%TestHandlerDefine(!TestID_SA1_BwRamMirror_400000)
		%TestHandlerDefine(!TestID_SA1_BwRamMirror_006000)
		%TestHandlerDefine(!TestID_SA1_BwRamMirror_806000)
		%TestHandlerDefine(!TestID_SNES_BwRamMirror_400000)
		%TestHandlerDefine(!TestID_SNES_BwRamMirror_006000)
		%TestHandlerDefine(!TestID_SNES_BwRamMirror_806000)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectOver)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectOver)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectMapping_Enable)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectMapping_M00P)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectMapping_M00)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectMapping_M01)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectMapping_Enable)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectMapping_M00P)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectMapping_M00)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectMapping_M01)
		%TestHandlerDefine(!TestID_SA1_IRamProtectionOrder_CS)
		%TestHandlerDefine(!TestID_SA1_IRamProtectionOrder_SC)
		%TestHandlerDefine(!TestID_SNES_IRamProtectionOrder_CS)
		%TestHandlerDefine(!TestID_SNES_IRamProtectionOrder_SC)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectOrder_CSB)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectOrder_CBS)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectOrder_SCB)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectOrder_SBC)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectOrder_BCS)
		%TestHandlerDefine(!TestID_SA1_BwRamProtectOrder_BSC)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectOrder_CSB)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectOrder_CBS)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectOrder_SCB)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectOrder_SBC)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectOrder_BCS)
		%TestHandlerDefine(!TestID_SNES_BwRamProtectOrder_BSC)
		%TestHandlerDefine(!TestID_SNES_CIWP)
		%TestHandlerDefine(!TestID_SNES_CBWE)
		%TestHandlerDefine(!TestID_SA1_SIWP)
		%TestHandlerDefine(!TestID_SA1_SBWE)
		%TestHandlerDefine(!TestID_SA1_BWPA)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_Stop)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_StopChange)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_Stop)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_StopChange)
		%TestHandlerDefine(!TestID_SNES_IRamProtection_Reboot)
		%TestHandlerDefine(!TestID_SNES_BwRamProtection_Reboot)
		%TestHandlerDefine(!TestID_SA1_Reboot_SPL)
		%TestHandlerDefine(!TestID_SA1_Reboot_SPH)
		%TestHandlerDefine(!TestID_SA1_IRamProtection_Reboot)
		%TestHandlerDefine(!TestID_SA1_BwRamProtection_Reboot)
		pullpc
		skip	!TestID_Count*4

TestPattern_Pass:
		SEP	#$30
		; .shortm, .shortx
		LDX	!TestingID
		INC	!TestResults, X
		RTS

;--- Boot
%TestPattern_ID(!TestID_SNES_IRamProtection_Boot)	;-----
%TestPattern_SA1()
		%TestReturn_SA1()
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
%TestPattern_SA1()
		%TestReturn_SA1()
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
%TestPattern_SA1()
		%TestReturn_SA1()
%TestPattern_SNES()
		JMP	TestPattern_Pass

%TestPattern_ID(!TestID_SA1_Boot_SPH)	; Boot stack pointer	;----
%TestPattern_SA1()
		%TestReturn_SA1()
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

%TestPattern_SNES()
		; NOP

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

%TestPattern_SNES()
		; NOP

;--- I-RAM Protection
%TestPattern_ID(!TestID_SNES_IRamProtection_Unprotect)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%11111111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %11111111)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	TestSnesIRam

%TestPattern_ID(!TestID_SA1_IRamProtection_Unprotect)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%11111111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1IRamExpected, %11111111)
		%SendSA1Message(!Message_TestSnesExecute, %11111111)
		%SoftwareJSR(TestIRam)
		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	SetSnesIRam

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

%TestPattern_ID(!TestID_SA1_IRamProtection_SNES)	;-----
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

%TestPattern_ID(!TestID_SNES_IRamProtection_SA1)	;----
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

%TestPattern_ID(!TestID_SNES_IRamProtection_Protect)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00000000
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %00000000)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	TestSnesIRam

%TestPattern_ID(!TestID_SA1_IRamProtection_Protect)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00000000
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1IRamExpected, %00000000)
		%SendSA1Message(!Message_TestSnesExecute, %00000000)
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

		%TestReturn_SA1()

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

		%TestReturn_SA1()

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
macro	TestSa1BwRamProtection(id, target, setSWEN, setCWEN, setBWPA, expectedSnesEnable, expectedSnesArea, expectedSa1Enable, expectedSa1Area, testExcepts)
; target: 0=SNES, 1=SA-1
; SA1:
;   A   = testExcepts | id
;   X   = expectedSa1Enable
;   Y   = expectedSa1Area
;   P.V = setCWEN
; SNES:
;   A   = setBWPA
;   X   = expectedSnesEnable
;   Y   = expectedSnesArea
;   P.V = setSWEN
%TestPattern_ID(<id>)	;-----
%TestPattern_SA1()
	if <setCWEN> == 0
		;	  nvmxdizc
		REP	#%01100000
		SEP	#%00010000
		; .longm, .shortx, CLV
	else
		;	  nvmxdizc
		REP	#%00100000
		SEP	#%01010000
		; .longm, .shortx, SEV
	endif

		LDA.w	#(<testExcepts><<8)|<id>
		LDX.b	#(<expectedSa1Enable><<7)
		LDY.b	#<expectedSa1Area>

	if <target> == 0
		; Target: SNES
		JMP	TestSnesBwRamProtection_Sa1
	else
		; Target: SA-1
		JMP	TestSa1BwRamProtection_Sa1
	endif

%TestPattern_SNES()
	if <setSWEN> == 0
		;	  nvmxdizc
		REP	#%01000000
		SEP	#%00110000
		; .shortm, .shortx, CLV
	else
		;	  nvmxdizc
		REP	#%00000000
		SEP	#%01110000
		; .shortm, .shortx, SEV
	endif

		LDA.b	#<setBWPA>
		LDX.b	#(<expectedSnesEnable><<7)
		LDY.b	#<expectedSnesArea>

	if <target> == 0
		; Target: SNES
		JMP	TestSnesBwRamProtection_Snes
	else
		; Target: SA-1
		JMP	TestSa1BwRamProtection_Snes
	endif
endmacro

;			id,						tg,sSEn,sCEn,sSAr,eSEn,eSAr,eCEn,eCAr,Exc
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_Unprotect,		0, 1,   1,   $00, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_Unprotect,		1, 1,   1,   $00, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_SNES,		0, 0,   1,   $FF, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_SNES,		1, 0,   1,   $FF, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_SA1,		0, 1,   0,   $FF, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_SA1,		1, 1,   0,   $FF, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_Protect,		0, 0,   0,   $FF, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_Protect,		1, 0,   0,   $FF, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D00,		0, 0,   0,   $00, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D01,		0, 0,   0,   $01, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D02,		0, 0,   0,   $02, 0,   $02, 0,   $02, $02)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D03,		0, 0,   0,   $03, 0,   $03, 0,   $03, $03)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D04,		0, 0,   0,   $04, 0,   $04, 0,   $04, $04)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D05,		0, 0,   0,   $05, 0,   $05, 0,   $05, $05)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D06,		0, 0,   0,   $06, 0,   $06, 0,   $06, $06)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D07,		0, 0,   0,   $07, 0,   $07, 0,   $07, $07)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D08,		0, 0,   0,   $08, 0,   $08, 0,   $08, $08)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D09,		0, 0,   0,   $09, 0,   $09, 0,   $09, $09)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D0A,		0, 0,   0,   $0A, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D0B,		0, 0,   0,   $0B, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D0C,		0, 0,   0,   $0C, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D0D,		0, 0,   0,   $0D, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D0E,		0, 0,   0,   $0E, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D0F,		0, 0,   0,   $0F, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D10,		0, 0,   0,   $10, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D11,		0, 0,   0,   $11, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D20,		0, 0,   0,   $20, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D21,		0, 0,   0,   $21, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D30,		0, 0,   0,   $30, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D31,		0, 0,   0,   $31, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D40,		0, 0,   0,   $40, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D41,		0, 0,   0,   $41, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D80,		0, 0,   0,   $80, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_D81,		0, 0,   0,   $81, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E00,		0, 1,   1,   $00, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E01,		0, 1,   1,   $01, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E02,		0, 1,   1,   $02, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E03,		0, 1,   1,   $03, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E04,		0, 1,   1,   $04, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E05,		0, 1,   1,   $05, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E06,		0, 1,   1,   $06, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E07,		0, 1,   1,   $07, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E08,		0, 1,   1,   $08, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E09,		0, 1,   1,   $09, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E0A,		0, 1,   1,   $0A, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E0B,		0, 1,   1,   $0B, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E0C,		0, 1,   1,   $0C, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E0D,		0, 1,   1,   $0D, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E0E,		0, 1,   1,   $0E, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E0F,		0, 1,   1,   $0F, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E10,		0, 1,   1,   $10, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E11,		0, 1,   1,   $11, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E20,		0, 1,   1,   $20, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E21,		0, 1,   1,   $21, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E30,		0, 1,   1,   $30, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E31,		0, 1,   1,   $31, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E40,		0, 1,   1,   $40, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E41,		0, 1,   1,   $41, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E80,		0, 1,   1,   $80, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SNES_BwRamProtection_E81,		0, 1,   1,   $81, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D00,		1, 0,   0,   $00, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D01,		1, 0,   0,   $01, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D02,		1, 0,   0,   $02, 0,   $02, 0,   $02, $02)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D03,		1, 0,   0,   $03, 0,   $03, 0,   $03, $03)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D04,		1, 0,   0,   $04, 0,   $04, 0,   $04, $04)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D05,		1, 0,   0,   $05, 0,   $05, 0,   $05, $05)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D06,		1, 0,   0,   $06, 0,   $06, 0,   $06, $06)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D07,		1, 0,   0,   $07, 0,   $07, 0,   $07, $07)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D08,		1, 0,   0,   $08, 0,   $08, 0,   $08, $08)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D09,		1, 0,   0,   $09, 0,   $09, 0,   $09, $09)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D0A,		1, 0,   0,   $0A, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D0B,		1, 0,   0,   $0B, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D0C,		1, 0,   0,   $0C, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D0D,		1, 0,   0,   $0D, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D0E,		1, 0,   0,   $0E, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D0F,		1, 0,   0,   $0F, 0,   $0F, 0,   $0F, $0F)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D10,		1, 0,   0,   $10, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D11,		1, 0,   0,   $11, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D20,		1, 0,   0,   $20, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D21,		1, 0,   0,   $21, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D30,		1, 0,   0,   $30, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D31,		1, 0,   0,   $31, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D40,		1, 0,   0,   $40, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D41,		1, 0,   0,   $41, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D80,		1, 0,   0,   $80, 0,   $00, 0,   $00, $00)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_D81,		1, 0,   0,   $81, 0,   $01, 0,   $01, $01)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E00,		1, 1,   1,   $00, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E01,		1, 1,   1,   $01, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E02,		1, 1,   1,   $02, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E03,		1, 1,   1,   $03, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E04,		1, 1,   1,   $04, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E05,		1, 1,   1,   $05, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E06,		1, 1,   1,   $06, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E07,		1, 1,   1,   $07, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E08,		1, 1,   1,   $08, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E09,		1, 1,   1,   $09, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E0A,		1, 1,   1,   $0A, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E0B,		1, 1,   1,   $0B, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E0C,		1, 1,   1,   $0C, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E0D,		1, 1,   1,   $0D, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E0E,		1, 1,   1,   $0E, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E0F,		1, 1,   1,   $0F, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E10,		1, 1,   1,   $10, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E11,		1, 1,   1,   $11, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E20,		1, 1,   1,   $20, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E21,		1, 1,   1,   $21, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E30,		1, 1,   1,   $30, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E31,		1, 1,   1,   $31, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E40,		1, 1,   1,   $40, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E41,		1, 1,   1,   $41, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E80,		1, 1,   1,   $80, 1,   $00, 1,   $00, $80)
%TestSa1BwRamProtection(!TestID_SA1_BwRamProtection_E81,		1, 1,   1,   $81, 1,   $00, 1,   $00, $80)


;--- I-RAM Mirroring
macro	TestSa1IRamMirror(id, sa1Expected, snesExpected)
%TestPattern_ID(<id>)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#<id>
		LDX.b	#<sa1Expected>
		JMP	TestIRamMirror_Sa1

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#<snesExpected>
		JMP	TestIRamMirror_Snes
endmacro

%TestSa1IRamMirror(!TestID_SA1_IRamMirror_000000, %01010101, %01000100)	; TODO: A reset will be reported as $FF. ($000800 also mirrored) Open bus?
%TestSa1IRamMirror(!TestID_SA1_IRamMirror_003000, %01010101, %01000100)
%TestSa1IRamMirror(!TestID_SA1_IRamMirror_800000, %01010101, %01000100)
%TestSa1IRamMirror(!TestID_SA1_IRamMirror_803000, %01010101, %01000100)

%TestPattern_ID(!TestID_SNES_IRamMirror_003000)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%11111111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1IRamExpected, %01010101)
		%SoftwareJSR(ClearIRam)
		SEP	#$30
		; .shortm, .shortx
		%SendSA1Message(!Message_TestSnesExecute, $00)

		%SoftwareJSR(TestIRamMirrorCheck_Sa1)
		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestSnesExecute, $01)

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx

		LDA	!Sa1MessageByte
		BNE	.Call2

.Call1		LDA.b	#%11111111
		STA	!SA1_SIWP

		LDA.b	#!TestMirroringValue
		STA.l	$003000

		RTS

.Call2
		LDA.b	#%01000100
		JSR	WriteTestIRamSnesExpected
		JSR	TestIRamMirrorCheck_Snes
		JSR	WriteTestIRamSnesActual
		JMP	TestResultCheck

%TestPattern_ID(!TestID_SNES_IRamMirror_803000)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%11111111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1IRamExpected, %01010101)
		%SoftwareJSR(ClearIRam)
		SEP	#$30
		; .shortm, .shortx
		%SendSA1Message(!Message_TestSnesExecute, $00)

		%SoftwareJSR(TestIRamMirrorCheck_Sa1)
		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestSnesExecute, $01)

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx

		LDA	!Sa1MessageByte
		BNE	.Call2

.Call1		LDA.b	#%11111111
		STA	!SA1_SIWP

		LDA.b	#!TestMirroringValue
		STA.l	$803000

		RTS

.Call2
		LDA.b	#%01000100
		JSR	WriteTestIRamSnesExpected
		JSR	TestIRamMirrorCheck_Snes
		JSR	WriteTestIRamSnesActual
		JMP	TestResultCheck


;--- I-RAM Mirroring Protection
%TestPattern_ID(!TestID_SA1_IRamProtectMirror_000000)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00000011
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %11111111)
		%SendSA1Message(!Message_TestSa1IRamExpected, %00000011)

		%TestIRamAreaProtect($000000)
		%TestIRamAreaProtect($000100)
		%TestIRamAreaProtect($000200)
		%TestIRamAreaProtect($000300)
		%TestIRamAreaProtect($000400)
		%TestIRamAreaProtect($000500)
		%TestIRamAreaProtect($000600)
		%TestIRamAreaProtect($000700)

		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	SetSnesIRam

%TestPattern_ID(!TestID_SA1_IRamProtectMirror_800000)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00000111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %11111111)
		%SendSA1Message(!Message_TestSa1IRamExpected, %00000111)

		%TestIRamAreaProtect($800000)
		%TestIRamAreaProtect($800100)
		%TestIRamAreaProtect($800200)
		%TestIRamAreaProtect($800300)
		%TestIRamAreaProtect($800400)
		%TestIRamAreaProtect($800500)
		%TestIRamAreaProtect($800600)
		%TestIRamAreaProtect($800700)

		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	SetSnesIRam

%TestPattern_ID(!TestID_SA1_IRamProtectMirror_803000)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%00011111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %11111111)
		%SendSA1Message(!Message_TestSa1IRamExpected, %00011111)

		LDA.b	#$00
		%TestIRamAreaProtect($803000)
		%TestIRamAreaProtect($803100)
		%TestIRamAreaProtect($803200)
		%TestIRamAreaProtect($803300)
		%TestIRamAreaProtect($803400)
		%TestIRamAreaProtect($803500)
		%TestIRamAreaProtect($803600)
		%TestIRamAreaProtect($803700)

		%SendSA1MessageAcc(!Message_TestSa1IRamActual)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		JMP	SetSnesIRam

%TestPattern_ID(!TestID_SNES_IRamProtectMirror_803000)	;----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#%11111111
		STA	!SA1_CIWP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, %00111111)

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx

		LDA	!Sa1MessageByte
		STA	!SA1_SIWP

		JSR	WriteTestIRamSnesExpected

		LDA.b	#$00
		%TestIRamAreaProtect($803000)
		%TestIRamAreaProtect($803100)
		%TestIRamAreaProtect($803200)
		%TestIRamAreaProtect($803300)
		%TestIRamAreaProtect($803400)
		%TestIRamAreaProtect($803500)
		%TestIRamAreaProtect($803600)
		%TestIRamAreaProtect($803700)

		JSR	WriteTestIRamSnesActual
		JMP	TestResultCheck

;--- BW-RAM Mirroring
macro	TestSa1BwRamMirror(id, target, sa1Expected, snesExpected)
%TestPattern_ID(<id>)	;-----
%TestPattern_SA1()
		%SoftwareJSR(ClearBwRam)

		SEP	#$30
		; .shortm, .shortx

		LDA.b	#!TestMirroringValue
		STA.l	<target>

		LDA.b	#<id>
		LDX.b	#<sa1Expected>
		JMP	TestBwRamMirror_Sa1

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx

		LDA	!Sa1MessageByte
		BNE	.Call2

.Call1		LDA.b	#$80
		STA	!SA1_SBWE
		STZ	!SA1_BWPA
		RTS

.Call2		LDA.b	#<snesExpected>
		JSR	WriteTestBwRamSnesExpected
		JSR	TestBwRamMirrorCheck
		JSR	WriteTestBwRamSnesActual
		JMP	TestResultCheck
endmacro

macro	TestSnesBwRamMirror(id, target, sa1Expected, snesExpected)
%TestPattern_ID(<id>)	;-----
%TestPattern_SA1()
		%SoftwareJSR(ClearBwRam)

		SEP	#$30
		; .shortm, .shortx

		LDA.b	#<id>
		LDX.b	#<sa1Expected>
		JMP	TestBwRamMirror_Sa1

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx

		LDA	!Sa1MessageByte
		BNE	.Call2

.Call1		LDA.b	#$80
		STA	!SA1_SBWE
		STZ	!SA1_BWPA

		LDA.b	#!TestMirroringValue
		STA.l	<target>

		RTS

.Call2		LDA.b	#<snesExpected>
		JSR	WriteTestBwRamSnesExpected
		JSR	TestBwRamMirrorCheck
		JSR	WriteTestBwRamSnesActual
		JMP	TestResultCheck
endmacro

%TestSa1BwRamMirror(!TestID_SA1_BwRamMirror_400000,	$400000, %01001111, %01000111)
%TestSa1BwRamMirror(!TestID_SA1_BwRamMirror_006000,	$006000, %01001111, %01000111)
%TestSa1BwRamMirror(!TestID_SA1_BwRamMirror_806000,	$806000, %01001111, %01000111)
%TestSnesBwRamMirror(!TestID_SNES_BwRamMirror_400000,	$400000, %01001111, %01000111)
%TestSnesBwRamMirror(!TestID_SNES_BwRamMirror_006000,	$006000, %01001111, %01000111)
%TestSnesBwRamMirror(!TestID_SNES_BwRamMirror_806000,	$806000, %01001111, %01000111)

%TestPattern_ID(!TestID_SA1_BwRamProtectOver)	;-----
%TestPattern_SA1()
		SEP	#$70
		; .shortm, .shortx, SEV

		LDA.b	#$00
		STA	!SA1_CBWE
		LDA.b	#$00
		STA	!SA1_BMAP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSa1BwRamExpectedE, %10000000)
		%SendSA1Message(!Message_TestSnesExecute, $00)

		; TODO: Failed
		%TestMemory($806000, l)
		BEQ	+
		CLV
+		%TestMemory($BF7FFF, l)
		BEQ	+
		CLV
+
		LDA.b	#$00
		BVC	+
		ORA.b	#$80
+		%SendSA1MessageAcc(!Message_TestSa1BwRamActualE)
		%SendSA1Message(!Message_TestCheck, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx
		LDA.b	#$00
		STA	!SA1_SBWE
;		LDA.b	#$FF
		LDA.b	#$10
		STA	!SA1_BWPA
		LDA.b	#$00
		STA	!SA1_BMAPS
		RTS

%TestPattern_ID(!TestID_SNES_BwRamProtectOver)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#$00
		STA	!SA1_SBWE
		LDA.b	#$00
		STA	!SA1_BMAP

		%SendSA1Message(!Message_TestReady, !TestID)
		%SendSA1Message(!Message_TestSnesExecute, $00)

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$70
		; .shortm, .shortx, SEV

		LDA.b	#$00
		STA	!SA1_SBWE
		LDA.b	#$FF
		STA	!SA1_BWPA
		LDA.b	#$00
		STA	!SA1_BMAPS

		LDA.b	#$00
		JSR	WriteTestBwRamSnesExpected

		SEP	#$70
		; .shortm, .shortx, SEV
		%TestMemory($806000, l)
		BEQ	+
		CLV
+		%TestMemory($BF7FFF, l)
		BEQ	+
		CLV
+		LDA.b	#$00
		JSR	WriteTestBwRamSnesActual

		JMP	TestResultCheck

macro	TestBwRamProtectMapping(id, target, setWEN, setBMAP, sa1Expected, snesExpected)
%TestPattern_ID(<id>)	;-----
%TestPattern_SA1()
		SEP	#$30
		; .shortm, .shortx

	if setWEN == 0
		STZ	!SA1_CBWE
	else
		LDA.b	#%10000000
		STA	!SA1_CBWE
	endif

		LDA.b	#<setBMAP>
		STA	!SA1_BMAPS
		%SendSA1MessageAcc(!Message_TestSnesExecute)

	if target == 0
		; TODO: Implements
		%SendSA1Message(!Message_TestCheck, $00)
	else
		; NOP
	endif

		%TestReturn_SA1()

%TestPattern_SNES()
		SEP	#$30
		; .shortm, .shortx

	if setWEN == 0
		STZ	!SA1_SBWE
	else
		LDA.b	#%10000000
		STA	!SA1_SBWE
	endif
		STZ	!SA1_BWPA

		LDA	!Sa1MessageByte
		STA	!SA1_BMAPS

	if target == 0
		RTS
	else
		; TODO: Implements
		JMP	TestResultCheck
	endif


;%TestPattern_ID()	;-----
;%TestPattern_SA1()
;%TestPattern_SNES()


