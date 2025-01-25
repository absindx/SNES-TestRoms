;--------------------------------------------------
; RAM Map
;--------------------------------------------------

includeonce

incsrc "../Include/Library_Macro.asm"

pushpc

;--------------------------------------------------

;%DefineRam(ScratchMemory,	$0000, 16)
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
%DefineRamNext(CpuMirror_NMITIMEN,	1)	; $1E4D : !SystemMemory+45

%DefineRam(VramBuffer,				$7F0000, $2000)
%DefineRam(PaletteBuffer,			$7F0000, 512)	; Temporary buffer

%DefineRam(TilemapBuffer,			$2000, $3C0)
!TilemapBufferWram	= $7E0000+!TilemapBuffer

;--------------------------------------------------

	org	$0000
%DefineRamNext(TestFinished,			1)	; $0000 0=Running, 1=Finished
%DefineRamNext(TestIndex,			1)	; $0001
%DefineRamNext(TestOffset,			1)	; $0002 $00 or $80
%DefineRamNext(TestReserved_0003,		1)	; $0003
%DefineRamNext(TestReserved_0004,		1)	; $0004
%DefineRamNext(OpenbusManipulation,		1)	; $0005 $FC=JSR (abs, X)

macro DefineResult(name, addr)
	org	<addr>
	%DefineRam(<name>,			<addr>, 1)
	%DefineRamNext(<name>_Offset,		1)	; +$00 (L=0, M=1, H=2)
	%DefineRamNext(<name>_M7A,		2)	; +$01
	%DefineRamNext(<name>_PrevM7B,		1)	; +$03
	%DefineRamNext(<name>_WriteM7B,		1)	; +$04
	%DefineRamNext(<name>_Value,		3)	; +$05
	%DefineRamNext(<name>_Wait,		3)	; +$08
	%DefineRamNext(<name>_Signature,	3)	; +$0B
endmacro

	org	$0010
%DefineResult(ResultTemporary,			$0010)
	org	$0200
%DefineResult(Result01,				$0200)
%DefineResult(Result02,				$0210)
%DefineResult(Result03,				$0220)
%DefineResult(Result04,				$0230)
%DefineResult(Result05,				$0240)
%DefineResult(Result06,				$0250)
%DefineResult(Result07,				$0260)
%DefineResult(Result08,				$0270)
%DefineResult(Result09,				$0280)
%DefineResult(Result10,				$0290)
%DefineResult(Result11,				$02A0)
%DefineResult(Result12,				$02B0)
%DefineResult(Result13,				$02C0)
%DefineResult(Result14,				$02D0)
%DefineResult(Result15,				$02E0)
%DefineResult(Result16,				$02F0)
%DefineResult(Result17,				$0300)
%DefineResult(Result18,				$0310)
%DefineResult(Result19,				$0320)

!ResultValueOffset	= 3
!ResultSignatureOffset	= 6
!ResultMaxCount		= 19

	org	$00C0
%DefineRamNext(ScratchMemory,			16)	; $00C0
	;org	$00D0
%DefineRamNext(StackTeporary,			2)	; $00D0
	;org	$00F0
;LandingCode

	org	$0200
;%DefineRamNext(Initialized,		1)
;%DefineRamNext(DuringNMI,		1)

!ResultSignature	= $AA
!ErrorSignature		= $BB
!DisplayErrorSignature	= '?'

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
