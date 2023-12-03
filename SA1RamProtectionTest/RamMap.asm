;--------------------------------------------------
; RAM Map
;--------------------------------------------------

includeonce

incsrc "../Include/Library_Macro.asm"

pushpc

;--------------------------------------------------

;%DefineRam(ScratchMemory,			$0000, 16)
%DefineRam(Stack,				$1F00, 256)

%DefineRam(OamBuffer,				$1C00, 512)
%DefineRam(OamPropertyBuffer,			$1E00, 32)
!SystemMemory		= $1E20
	org	!SystemMemory
%DefineRamNext(PpuMirror_INIDISP,		1)	; $1E20 : !SystemMemory+0
%DefineRamNext(PpuMirror_OBJSEL,		1)	; $1E21 : !SystemMemory+1
%DefineRamNext(PpuMirror_BGMODE,		1)	; $1E22 : !SystemMemory+2
%DefineRamNext(PpuMirror_MOSAIC,		1)	; $1E23 : !SystemMemory+3
%DefineRamNext(PpuMirror_BG1SC,			1)	; $1E24 : !SystemMemory+4
%DefineRamNext(PpuMirror_BG2SC,			1)	; $1E25 : !SystemMemory+5
%DefineRamNext(PpuMirror_BG3SC,			1)	; $1E26 : !SystemMemory+6
%DefineRamNext(PpuMirror_BG4SC,			1)	; $1E27 : !SystemMemory+7
%DefineRamNext(PpuMirror_BG12NBA,		1)	; $1E28 : !SystemMemory+8
%DefineRamNext(PpuMirror_BG34NBA,		1)	; $1E29 : !SystemMemory+9
%DefineRamNext(PpuMirror_BG1HOFS,		1)	; $1E2A : !SystemMemory+10
%DefineRamNext(PpuMirror_BG1VOFS,		1)	; $1E2B : !SystemMemory+11
%DefineRamNext(PpuMirror_BG2HOFS,		1)	; $1E2C : !SystemMemory+12
%DefineRamNext(PpuMirror_BG2VOFS,		1)	; $1E2D : !SystemMemory+13
%DefineRamNext(PpuMirror_BG3HOFS,		1)	; $1E2E : !SystemMemory+14
%DefineRamNext(PpuMirror_BG3VOFS,		1)	; $1E2F : !SystemMemory+15
%DefineRamNext(PpuMirror_BG4HOFS,		1)	; $1E30 : !SystemMemory+16
%DefineRamNext(PpuMirror_BG4VOFS,		1)	; $1E31 : !SystemMemory+17
%DefineRamNext(PpuMirror_M7SEL,			1)	; $1E32 : !SystemMemory+18
%DefineRamNext(PpuMirror_M7A,			2)	; $1E33 : !SystemMemory+19
%DefineRamNext(PpuMirror_M7B,			2)	; $1E35 : !SystemMemory+21
%DefineRamNext(PpuMirror_M7C,			2)	; $1E37 : !SystemMemory+23
%DefineRamNext(PpuMirror_M7D,			2)	; $1E39 : !SystemMemory+25
%DefineRamNext(PpuMirror_M7X,			2)	; $1E3B : !SystemMemory+27
%DefineRamNext(PpuMirror_M7Y,			2)	; $1E3D : !SystemMemory+29
%DefineRamNext(PpuMirror_W12SEL,		1)	; $1E3F : !SystemMemory+31
%DefineRamNext(PpuMirror_W34SEL,		1)	; $1E40 : !SystemMemory+32
%DefineRamNext(PpuMirror_WOBJSEL,		1)	; $1E41 : !SystemMemory+33
%DefineRamNext(PpuMirror_WBGLOG,		1)	; $1E42 : !SystemMemory+34
%DefineRamNext(PpuMirror_WOBJLOG,		1)	; $1E43 : !SystemMemory+35
%DefineRamNext(PpuMirror_TM,			1)	; $1E44 : !SystemMemory+36
%DefineRamNext(PpuMirror_TS,			1)	; $1E45 : !SystemMemory+37
%DefineRamNext(PpuMirror_TMW,			1)	; $1E46 : !SystemMemory+38
%DefineRamNext(PpuMirror_TSW,			1)	; $1E47 : !SystemMemory+39
%DefineRamNext(PpuMirror_CGSWSEL,		1)	; $1E48 : !SystemMemory+40
%DefineRamNext(PpuMirror_CGADSUB,		1)	; $1E49 : !SystemMemory+41
%DefineRamNext(PpuMirror_COLDATA,		2)	; $1E4A : !SystemMemory+42
%DefineRamNext(PpuMirror_SETINI,		1)	; $1E4C : !SystemMemory+44

%DefineRam(VramBuffer,				$7F0000, $2000)
%DefineRam(PaletteBuffer,			$7F0000, 512)	; Temporary buffer

warnings push
warnings disable W1009
%DefineRam(SA1_IRam,				$000000, $0800)
%DefineRam(SA1_IRamImage,			$003000, $0800)
%DefineRam(SA1_BWRam,				$400000, 1)	; Max $200000
%DefineRam(SA1_BWRamImage,			$006000, $2000)
%DefineRam(SA1_Mirror,				$800000, 1)
warnings pull

;--------------------------------------------------

	org	$0000
%DefineRamNext(TestFinished,			1)	; $0000 0=Running, 1=Passed, 255=Failed
%DefineRamNext(TestingID,			1)	; $0001
%DefineRamNext(TestSramSize,			3)	; $0002

	org	$0010
	skip	2
;%DefineRamNext(TestResult,			1)	; $0010
;%DefineRamNext(TestTestID,			1)	; $0011
%DefineRamNext(TestGeneralSnesExpected,		1)	; $0012
%DefineRamNext(TestGeneralSnesActual,		1)	; $0013
%DefineRamNext(TestGeneralSa1Expected,		1)	; $0014
%DefineRamNext(TestGeneralSa1Actual,		1)	; $0015
%DefineRamNext(TestIRamSnesExpected,		1)	; $0016
%DefineRamNext(TestIRamSnesActual,		1)	; $0017
%DefineRamNext(TestIRamSa1Expected,		1)	; $0018 
%DefineRamNext(TestIRamSa1Actual,		1)	; $0019
%DefineRamNext(TestBwRamSnesExpected,		2)	; $001A +0=Enable, +1=Area
%DefineRamNext(TestBwRamSnesActual,		2)	; $001C
%DefineRamNext(TestBwRamSa1Expected,		2)	; $001E
%DefineRamNext(TestBwRamSa1Actual,		2)	; $0020
%DefineRamNext(TestSnesStackPointerBoot,	2)	; $0022
%DefineRamNext(TestSa1StackPointerBoot,		2)	; $0024
%DefineRamNext(TestSnesStackPointerReboot,	2)	; $0026
%DefineRamNext(TestSa1StackPointerReboot,	2)	; $0028

	org	$0030
%DefineRamNext(DisplayResult,			1)	; $0030 0=Running, 1=Passed, 255=Failed
%DefineRamNext(DisplayTestID,			1)	; $0031 First failed test ID
%DefineRamNext(DisplayGeneralSnesExpected,	1)	; $0032
%DefineRamNext(DisplayGeneralSnesActual,	1)	; $0033
%DefineRamNext(DisplayGeneralSa1Expected,	1)	; $0034
%DefineRamNext(DisplayGeneralSa1Actual,		1)	; $0035
%DefineRamNext(DisplayIRamSnesExpected,		1)	; $0036
%DefineRamNext(DisplayIRamSnesActual,		1)	; $0037
%DefineRamNext(DisplayIRamSa1Expected,		1)	; $0038
%DefineRamNext(DisplayIRamSa1Actual,		1)	; $0039
%DefineRamNext(DisplayBwRamSnesExpected,	2)	; $003A +0=Enable, +1=Area
%DefineRamNext(DisplayBwRamSnesActual,		2)	; $003C
%DefineRamNext(DisplayBwRamSa1Expected,		2)	; $003E
%DefineRamNext(DisplayBwRamSa1Actual,		2)	; $0040
;%DefineRamNext(DisplaySnesStackPointerBoot,	2)	; $0042
;%DefineRamNext(DisplaySa1StackPointerBoot,	2)	; $0044
;%DefineRamNext(DisplaySnesStackPointerReboot,	2)	; $0046
;%DefineRamNext(DisplaySa1StackPointerReboot,	2)	; $0048


	org	$0050
%DefineRamNext(ScratchMemory,			16)	; $0050
	;org	$0060
%DefineRamNext(Sa1MessageType,			1)	; $0060
%DefineRamNext(Sa1MessageByte,			1)	; $0061
	org	$0070
%DefineRamNext(Initialized,			1)	; $0070
%DefineRamNext(DuringNMI,			1)	; $0071
%DefineRamNext(FrameCounter,			1)	; $0072
%DefineRamNext(JoypadInput,			2)	; $0073 High   +1, Low    +0
%DefineRamNext(JoypadPress,			2)	; $0075 BYsS udlr, AXLR 0123

	org	$0200
%DefineRamNext(TestResults,			256)
%DefineRamNext(TestActuals,			256)
%DefineRamNext(TestExpects,			256)

%DefineRam(SnesInitialStackPointer,		$4379, 2)	; !DMA_A2A7H


;--------------------------------------------------
; VRAM Map
;--------------------------------------------------

; +-------------+-----------------------+
; | ADDRESS     | 			|
; +-------------+-----------------------+
; | $0000-$0FFF | Layer 1 Tilemap	|
; | $1000-$1FFF | Layer 2 Tilemap	|
; | $2000-$3FFF | Unused		|
; | $4000-$5FFF | Unused		|
; | $6000-$7FFF | Unused		|
; | $8000-$9FFF | Unused (Object GFX)	|
; | $A000-$BFFF | Unused		|
; | $C000-$DFFF | Layer 1&2 GFX (4bpp)	|
; | $E000-$FFFF | Unused		|
; +-------------+-----------------------+

!VRAM_Layer1Tilemap	= $0000
!VRAM_Layer2Tilemap	= $1000
!VRAM_CommonGraphics	= $C000

;--------------------------------------------------

pullpc
