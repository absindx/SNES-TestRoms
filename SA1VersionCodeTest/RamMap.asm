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
%DefineRamNext(TestVersionVC,			1)	; $0001 (SNES) $230E VC
%DefineRamNext(TestVersionVCTrue,		1)	; $0002 (????) $???? True VC

	org	!SA1_IRamImage+$00
%DefineRamNext(TestSnesSFR,			2)	; $3000
%DefineRamNext(TestSnesCFR,			2)	; $3002
%DefineRamNext(TestSnesHCRL,			2)	; $3004
%DefineRamNext(TestSnesHCRH,			2)	; $3006
%DefineRamNext(TestSnesVCRL,			2)	; $3008
%DefineRamNext(TestSnesVCRH,			2)	; $300A
%DefineRamNext(TestSnesMR0,			2)	; $300C
%DefineRamNext(TestSnesMR1,			2)	; $300E
%DefineRamNext(TestSnesMR2,			2)	; $3010
%DefineRamNext(TestSnesMR3,			2)	; $3012
%DefineRamNext(TestSnesMR4,			2)	; $3014
%DefineRamNext(TestSnesOF,			2)	; $3016
%DefineRamNext(TestSnesVDPL,			2)	; $3018
%DefineRamNext(TestSnesVDPH,			2)	; $301A
%DefineRamNext(TestSnesVC,			2)	; $301C
%DefineRamNext(TestSnesUndefined,		2)	; $301E
%DefineRamNext(TestSnesMirror,			2)	; $3020
	skip align 32
%DefineRamNext(TestSa1SFR,			2)	; $3040
%DefineRamNext(TestSa1CFR,			2)	; $3042
%DefineRamNext(TestSa1HCRL,			2)	; $3044
%DefineRamNext(TestSa1HCRH,			2)	; $3046
%DefineRamNext(TestSa1VCRL,			2)	; $3048
%DefineRamNext(TestSa1VCRH,			2)	; $304A
%DefineRamNext(TestSa1MR0,			2)	; $304C
%DefineRamNext(TestSa1MR1,			2)	; $304E
%DefineRamNext(TestSa1MR2,			2)	; $3050
%DefineRamNext(TestSa1MR3,			2)	; $3052
%DefineRamNext(TestSa1MR4,			2)	; $3054
%DefineRamNext(TestSa1OF,			2)	; $3056
%DefineRamNext(TestSa1VDPL,			2)	; $3058
%DefineRamNext(TestSa1VDPH,			2)	; $305A
%DefineRamNext(TestSa1VC,			2)	; $305C
%DefineRamNext(TestSa1Undefined,		2)	; $305E
%DefineRamNext(TestSa1Mirror,			2)	; $3060

!TestMemoryLength	= 17
!TestSnesRegister	= TestSnesSFR
!TestSa1Register	= TestSa1SFR


	org	$0080
%DefineRamNext(ScratchMemory,			16)	; $0080
	;org	$0090
%DefineRamNext(Sa1MessageType,			1)	; $0090
;%DefineRamNext(Sa1MessageByte,			1)	; $0091
	org	$00A0
%DefineRamNext(Initialized,			1)	; $00A0
%DefineRamNext(DuringNMI,			1)	; $00A1
%DefineRamNext(FrameCounter,			1)	; $00A2
%DefineRamNext(JoypadInput,			2)	; $00A3 High   +1, Low    +0
%DefineRamNext(JoypadPress,			2)	; $00A5 BYsS udlr, AXLR 0123

%DefineRam(Sa1Stack,				$0100, 256)
%DefineRam(Sa1StackBottom,			$01FF, 1)

;!TestAddress		= $2300
!TestAddress		= $2300
!SnesOpenBusValue	= $AA
!Sa1OpenBusValue1	= $BB
!Sa1OpenBusValue2	= $CC



;--------------------------------------------------
; VRAM Map
;--------------------------------------------------

; +-------------+-----------------------+
; | ADDRESS     | USAGE			|
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
