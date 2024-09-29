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

%DefineRam(TilemapBuffer,			$1000, $3C0)
!TilemapBufferWram	= $7E0000+TilemapBuffer

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
%DefineRamNext(TestingType,			1)	; $0001 1=JMP, 2=WAI, 3=STP

macro DefineRamRegister(name, addr)
	org	<addr>
	%DefineRam(<name>,			<addr>, 1)
	%DefineRamNext(<name>_A,		2)	; +$00
	%DefineRamNext(<name>_X,		2)	; +$02
	%DefineRamNext(<name>_Y,		2)	; +$04
	%DefineRamNext(<name>_S,		2)	; +$06
	%DefineRamNext(<name>_P,		2)	; +$08 +0=P, +1=E
	%DefineRamNext(<name>_D,		2)	; +$0A
	%DefineRamNext(<name>_K,		1)	; +$0C
	%DefineRamNext(<name>_B,		1)	; +$0D
	skip align 16
	%DefineRamNext(<name>_MR1,		1)	; +$10
	%DefineRamNext(<name>_MR2,		1)	; +$11
	%DefineRamNext(<name>_MR3,		1)	; +$12
	%DefineRamNext(<name>_MR4,		1)	; +$13
	%DefineRamNext(<name>_MR5,		1)	; +$14
	%DefineRamNext(<name>_OF,		1)	; +$15
	%DefineRamNext(<name>_VDP,		2)	; +$16
endmacro

	org	!SA1_IRamImage
%DefineRamNext(TestSa1StatusTemporary,		1)	; $3000
%DefineRamNext(TestSa1MemoryLengthTest,		2)	; $3001
%DefineRamNext(TestSa1Waiting,			2)	; $3003

%DefineRamRegister(TestRegisterTmp,	!SA1_IRamImage+$20)
%DefineRamRegister(TestRegisterRst,	!SA1_IRamImage+$40)
%DefineRamRegister(TestRegisterJmp,	!SA1_IRamImage+$60)
%DefineRamRegister(TestRegisterWai,	!SA1_IRamImage+$80)
%DefineRamRegister(TestRegisterStp,	!SA1_IRamImage+$A0)
!TestRegisterSize	= $20

	org	$00C0
%DefineRamNext(ScratchMemory,			16)	; $00C0
	;org	$00D0
%DefineRamNext(Sa1MessageType,			1)	; $00D0
;%DefineRamNext(Sa1MessageByte,			1)	; $00D1
	org	$00E0
%DefineRamNext(Initialized,			1)	; $00E0
%DefineRamNext(DuringNMI,			1)	; $00E1
%DefineRamNext(FrameCounter,			1)	; $00E2
%DefineRamNext(JoypadInput,			2)	; $00E3 High   +1, Low    +0
%DefineRamNext(JoypadPress,			2)	; $00E5 BYsS udlr, AXLR 0123

%DefineRam(Sa1Stack,				$0100, 256)
%DefineRam(Sa1StackBottom,			$01FF, 1)

!Sa1SFlag_N		= %10000000
!Sa1SFlag_V		= %01000000
!Sa1SFlag_Z		= %00100000
!Sa1SFlag_C		= %00010000
!Sa1CiwpMask		= %00001111

!Sa1TestRst		= 1
!Sa1TestJmp		= 2
!Sa1TestWai		= 3
!Sa1TestStp		= 4


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
