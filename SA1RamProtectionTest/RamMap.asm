;--------------------------------------------------
; RAM Map
;--------------------------------------------------

includeonce

incsrc "../Include/Library_Macro.asm"

pushpc

;--------------------------------------------------

;%DefineRam(ScratchMemory,	$0020, 16)
%DefineRam(Stack,		$1F00, 256)

%DefineRam(OamBuffer,		$1C00, 512)
%DefineRam(OamPropertyBuffer,	$1E00, 32)
!SystemMemory			= $1E20
	org	!SystemMemory
%DefineRamNext(PpuMirror_INIDISP,	1)	; $1E20 : !SystemMemory+0
%DefineRamNext(PpuMirror_OBJSEL,	1)	; $1E21 : !SystemMemory+1
%DefineRamNext(PpuMirror_BGMODE,	1)	; $1E22 : !SystemMemory+2
%DefineRamNext(PpuMirror_MOSAIC,	1)	; $1E23 : !SystemMemory+3
%DefineRamNext(PpuMirror_BG1SC,		1)	; $1E24 : !SystemMemory+4
%DefineRamNext(PpuMirror_BG2SC,		1)	; $1E25 : !SystemMemory+5
%DefineRamNext(PpuMirror_BG3SC,		1)	; $1E26 : !SystemMemory+6
%DefineRamNext(PpuMirror_BG4SC,		1)	; $1E27 : !SystemMemory+7
%DefineRamNext(PpuMirror_BG12NBA,	1)	; $1E28 : !SystemMemory+8
%DefineRamNext(PpuMirror_BG34NBA,	1)	; $1E29 : !SystemMemory+9
%DefineRamNext(PpuMirror_BG1HOFS,	1)	; $1E2A : !SystemMemory+10
%DefineRamNext(PpuMirror_BG1VOFS,	1)	; $1E2B : !SystemMemory+11
%DefineRamNext(PpuMirror_BG2HOFS,	1)	; $1E2C : !SystemMemory+12
%DefineRamNext(PpuMirror_BG2VOFS,	1)	; $1E2D : !SystemMemory+13
%DefineRamNext(PpuMirror_BG3HOFS,	1)	; $1E2E : !SystemMemory+14
%DefineRamNext(PpuMirror_BG3VOFS,	1)	; $1E2F : !SystemMemory+15
%DefineRamNext(PpuMirror_BG4HOFS,	1)	; $1E30 : !SystemMemory+16
%DefineRamNext(PpuMirror_BG4VOFS,	1)	; $1E31 : !SystemMemory+17
%DefineRamNext(PpuMirror_M7SEL,		1)	; $1E32 : !SystemMemory+18
%DefineRamNext(PpuMirror_M7A,		2)	; $1E33 : !SystemMemory+19
%DefineRamNext(PpuMirror_M7B,		2)	; $1E35 : !SystemMemory+21
%DefineRamNext(PpuMirror_M7C,		2)	; $1E37 : !SystemMemory+23
%DefineRamNext(PpuMirror_M7D,		2)	; $1E39 : !SystemMemory+25
%DefineRamNext(PpuMirror_M7X,		2)	; $1E3B : !SystemMemory+27
%DefineRamNext(PpuMirror_M7Y,		2)	; $1E3D : !SystemMemory+29
%DefineRamNext(PpuMirror_W12SEL,	1)	; $1E3F : !SystemMemory+31
%DefineRamNext(PpuMirror_W34SEL,	1)	; $1E40 : !SystemMemory+32
%DefineRamNext(PpuMirror_WOBJSEL,	1)	; $1E41 : !SystemMemory+33
%DefineRamNext(PpuMirror_WBGLOG,	1)	; $1E42 : !SystemMemory+34
%DefineRamNext(PpuMirror_WOBJLOG,	1)	; $1E43 : !SystemMemory+35
%DefineRamNext(PpuMirror_TM,		1)	; $1E44 : !SystemMemory+36
%DefineRamNext(PpuMirror_TS,		1)	; $1E45 : !SystemMemory+37
%DefineRamNext(PpuMirror_TMW,		1)	; $1E46 : !SystemMemory+38
%DefineRamNext(PpuMirror_TSW,		1)	; $1E47 : !SystemMemory+39
%DefineRamNext(PpuMirror_CGSWSEL,	1)	; $1E48 : !SystemMemory+40
%DefineRamNext(PpuMirror_CGADSUB,	1)	; $1E49 : !SystemMemory+41
%DefineRamNext(PpuMirror_COLDATA,	2)	; $1E4A : !SystemMemory+42
%DefineRamNext(PpuMirror_SETINI,	1)	; $1E4C : !SystemMemory+44

%DefineRam(VramBuffer,		$7F0000, $2000)
%DefineRam(PaletteBuffer,	$7F0000, 512)	; Temporary buffer

warnings push
warnings disable W1009
%DefineRam(SA1_IRam,		$000000, $0800)
%DefineRam(SA1_IRamImage,	$003000, $0800)
%DefineRam(SA1_BWRam,		$400000, 1)	; Max $200000
%DefineRam(SA1_BWRamImage,	$006000, $2000)
%DefineRam(SA1_Mirror,		$800000, 1)
warnings pull

;--------------------------------------------------

	org	$0000
%DefineRamNext(TestFinished,		1)	; $0000 0=Running, 1=Passed, 255=Failed
%DefineRamNext(TestResult,		1)	; $0001 0=Running, 1=Passed, 255=Failed
%DefineRamNext(TestTestID,		1)	; $0002 First failed test ID
%DefineRamNext(TestSramSize,		3)	; $0003
%DefineRamNext(TestGeneralSnesExpected,	1)	; $0006
%DefineRamNext(TestGeneralSnesActual,	1)	; $0007
%DefineRamNext(TestGeneralSa1Expected,	1)	; $0008
%DefineRamNext(TestGeneralSa1Actual,	1)	; $0009
%DefineRamNext(TestIRamSnesExpected,	1)	; $000A
%DefineRamNext(TestIRamSnesActual,	1)	; $000B
%DefineRamNext(TestIRamSa1Expected,	1)	; $000C
%DefineRamNext(TestIRamSa1Actual,	1)	; $000D
%DefineRamNext(TestBwRamSnesExpected,	2)	; $000E +0=Enable, +1=Area
%DefineRamNext(TestBwRamSnesActual,	2)	; $0010
%DefineRamNext(TestBwRamSa1Expected,	2)	; $0012
%DefineRamNext(TestBwRamSa1Actual,	2)	; $0014
%DefineRamNext(TestSnesStackPointer,	2)	; $0016
%DefineRamNext(TestSa1StackPointer,	2)	; $0018

	org	$0020
%DefineRamNext(ScratchMemory,		16)	; $0020
%DefineRamNext(Sa1MessageType,		1)	; $0030
%DefineRamNext(Sa1MessageByte,		1)	; $0031
%DefineRamNext(TestingID,		1)	; $0032

	org	$0200
%DefineRamNext(TestResults,		256)
%DefineRamNext(TestActuals,		256)
%DefineRamNext(TestExpects,		256)

;	org	$0500
%DefineRamNext(Initialized,		1)
%DefineRamNext(DuringNMI,		1)

%DefineRam(SnesInitialStackPointer,	$4379, 2)	; !DMA_A2A7H


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
