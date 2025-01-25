;--------------------------------------------------
; PPU multiplier utility
;--------------------------------------------------

asar 1.81

;--------------------------------------------------
; Cartridge header
;--------------------------------------------------

incsrc	"RomSetting.asm"

;--------------------------------------------------
; Library
;--------------------------------------------------

incsrc	"../Include/Library_Macro.asm"
incsrc	"../Include/Library_Debug.asm"
incsrc	"../Include/IOName_Standard.asm"

incsrc	"RamMap.asm"

;--------------------------------------------------
; Vectors
;--------------------------------------------------

	org $00FFE0
Vectors:
	dw	UnusedHandler				; $00FFE0 : Native (Reserved)
	dw	UnusedHandler				; $00FFE2 : Native (Reserved)
	dw	TestException				; $00FFE4 : Native COP
	dw	TestException				; $00FFE6 : Native BRK
	dw	UnusedHandler				; $00FFE8 : Native ABORT
	dw	NativeNMI				; $00FFEA : Native NMI
	dw	UnusedHandler				; $00FFEC : Native (Reserved)
	dw	NativeIRQ				; $00FFEE : Native IRQ
	dw	UnusedHandler				; $00FFF0 : Emulation (Reserved)
	dw	UnusedHandler				; $00FFF2 : Emulation (Reserved)
	dw	TestException				; $00FFF4 : Emulation COP
	dw	UnusedHandler				; $00FFF6 : Emulation (Reserved)
	dw	UnusedHandler				; $00FFF8 : Emulation ABORT
	dw	TestException				; $00FFFA : Emulation NMI
	dw	EmulationRESET				; $00FFFC : Emulation RESET
	dw	TestException				; $00FFFE : Emulation IRQ / BRK

;--------------------------------------------------
; Program
;--------------------------------------------------

	org !StartAddress
	optimize dp	always
	padbyte !BlankByte
EmulationRESET:
		SEI					;   for emulator vector detection
		REP	#$CB				;   nv??dIzc
		XCE
		SEP	#$34				;   nvMXdIzC
		; .shortm, .shortx

		STZ	!CPU_NMITIMEN			;   disable NMI
		STZ	!CPU_HDMAEN			;   disable HDMA

		REP	#$21				;\  nvmXdIzc
		; .longm, .shortx			; | set registers
		;LDA.w	#$1FFF				; |
		LDA.w	#$1FEF				; |
		TCS					; |   S  = #$1FEF
		LDA.w	#$0000				; |
		TCD					; |   D  = #$0000
		JML	.SetPBR				; |   PB = (PC Bank)
.SetPBR		PHK					; |
		PLB					;/    DB = (PC Bank)
		SEP	#$30
		; .shortm, .shortx

		; Set IO registers
		JSR	InitializeCpu
		JSR	InitializePpu

		; Clear WRAM ($000000-$002000)
		;   Do not subroutine because the stack area is also initialized
		STZ	!WRAM_WMADDL			;\
		REP	#$20				; | PPU WRAM access addr = $000000
		; .longm, .shortx			; |
		STZ	!WRAM_WMADDM			;/    with !WRAM_WMADDH

		LDA.w	#(%00001000)|(!WRAM_WMDATA<<8)	;\  DMA parameter = Bus: A to B / Address: Fixed / Transfer: 1 byte, 1 address
							; | B-Bus address = !WRAM_WMDATA
		STA	!DMA_DMAP0			;/    with !DMA_BBAD0
		LDA.w	#ZeroByte			;\
		STA	!DMA_A1T0L			; | A-Bus address = ZeroByte
		LDX.b	#(ZeroByte>>16)			; |
		STX	!DMA_A1B0			;/
		LDA.w	#$2000				;\  DMA size = $2000
		STA	!DMA_DAS0L			;/
		LDX.b	#$01				;\  Execute DMA #0
		STX	!CPU_MDMAEN			;/

		SEP	#$30
		; .shortm, .shortx

		; Clear VRAM
		JSR	ClearVram

		; Clear CGRAM
		JSR	ClearPalette
		JSR	TransferPalette

		; Clear OAM
		JSR	ClearOam
		JSR	TransferOam

		; Upload to sound driver
		; Clear SRAM
		; Don't do

		JSR	Initialize_Game
ResetInfLoop:	JSR	ScreenOn

		SEP	#$30
		; .shortm, .shortx

		CLI
.InfLoop	WAI
		BRA	.InfLoop

.RamInitialValue
	db	$00

InitializeCpu:
		; SNES Development Manual book1 - Chapter 26 Register Clear (Initial Settings)
		; .shortm, .shortx

		LDX.b	#$0D
-		LDA	.InitializeValue, X
		STA	!CPU_NMITIMEN, X
		DEX
		BPL	-

		RTS

.InitializeValue
	;	$00, $01, $02, $03, $04, $05, $06
	db	$00, $FF, $00, $00, $00, $00, $00	; $4200
	;	$07, $08, $09, $0A, $0B, $0C, $0D
	db	$00, $00, $00, $00, $00, $00, $00	; $4207

InitializePpu:
		; SNES Development Manual book1 - Chapter 26 Register Clear (Initial Settings)
		; .shortm, .shortx

		LDX.b	#$33				;\
-		STZ	!PPU_INIDISP, X			; | clear to zero
		DEX					; |
		BNE	-				;/  no $2100 required

		LDX.b	#$07				;\
-		STZ	!PPU_BG1HOFS, X			; | set the second byte of the double write register
		STZ	!PPU_BG1HOFS, X			; |
		LDA	.InitializeValue, X		; |
		STZ	!PPU_M7A, X			; |
		STA	!PPU_M7A, X			; |
		DEX					; |
		BPL	-				;/

		; reconfigure non-zero registers
		LDA.b	#$8F				;   forced blank
		STA	!PPU_INIDISP
		LDA.b	#$80				;   increment after access $2119 or $213A
		STA	!PPU_VMAINC
		LDA.b	#$30				;   disable color math
		STA	!PPU_CGSWSEL
		LDA.b	#$E0				;   write RGB
		STA	!PPU_COLDATA

		RTS

.InitializeValue
	; reset $2121 to reuse the loop (8 bytes)
	;	$1B, $1C, $1D, $1E, $1F, $20, $21, $22
	db	$01, $00, $00, $01, $00, $00, $00, $00	; $211B

ClearVram:
		; Transfer zero to VRAM $0000 - $FFFF

		PHP
		REP	#$20
		SEP	#$10
		; .longm, .shortx
		STZ	!PPU_VMADDL
		LDA.w	#(%00001001)|(!PPU_VMDATAL<<8)	;\  DMA parameter = Bus: A to B / Address: Fixed / Transfer: 2 bytes, 2 addresses
							; | B-Bus address = !PPU_VMDATAL
		STA	!DMA_DMAP0			;/    with !WRAM_WMADDH
		LDA.w	#ZeroByte			;\
		STA	!DMA_A1T0L			; | A-Bus address = ZeroByte
		LDX.b	#(ZeroByte>>16)			; |
		STX	!DMA_A1B0			;/
		LDA.w	#$0000				;\  DMA size = $10000
		STA	!DMA_DAS0L			;/
		LDX.b	#$01				;\  Execute DMA #0
		STX	!CPU_MDMAEN			;/
		PLP
		RTS

ClearPalette:
		; Clear WRAM (!PaletteBuffer 512 bytes)

		PHP
		REP	#$20
		SEP	#$10
		; .longm, .shortx

		LDA.w	#!PaletteBuffer			;\
		STA	!WRAM_WMADDL			; | PPU WRAM access addr = !PaletteBuffer
		LDX.b	#(!PaletteBuffer>>16)&1		; |
		STX	!WRAM_WMADDH			;/

		LDA.w	#(%00001000)|(!WRAM_WMDATA<<8)	;\  DMA parameter = Bus: A to B / Address: Fixed / Transfer: 1 byte, 1 address
							; | B-Bus address = !WRAM_WMDATA
		STA	!DMA_DMAP0			;/    with !DMA_BBAD0
		LDA.w	#ZeroByte			;\
		STA	!DMA_A1T0L			; | A-Bus address = ZeroByte
		LDX.b	#(ZeroByte>>16)			; |
		STX	!DMA_A1B0			;/
		LDA.w	#$0200				;\  DMA size = $0200
		STA	!DMA_DAS0L			;/
		LDX.b	#$01				;\  Execute DMA #0
		STX	!CPU_MDMAEN			;/

		PLP
		RTS

TransferPalette:
		PHP
		REP	#$20
		SEP	#$10
		; .longm, .shortx

		LDA.w	#(%00000010)|(!PPU_CGDATA<<8)	;\  DMA parameter = Bus: A to B / Address: Increment A / Transfer: 2 byte, 1 address
							; | B-Bus address = !PPU_CGDATA
		STA	!DMA_DMAP0			;/    with !DMA_BBAD0
		LDA.w	#!PaletteBuffer			;\
		STA	!DMA_A1T0L			; | A-Bus address = !PaletteBuffer
		LDX.b	#(!PaletteBuffer>>16)		; |
		STX	!DMA_A1B0			;/
		LDA.w	#$0200				;\  DMA size = $0200
		STA	!DMA_DAS0L			;/
		LDX.b	#$00				;\  Set CGRAM address = $00
		STX	!PPU_CGADD			;/
		INX					;\  Execute DMA #0
		STX	!CPU_MDMAEN			;/

		PLP
		RTS

ClearOam:
		PHP
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#$E0
		LDX.b	#$7C
.Loop		STA	!OamBuffer+$0001, X
		STA	!OamBuffer+$0081, X
		STA	!OamBuffer+$0101, X
		STA	!OamBuffer+$0181, X
		DEX
		DEX
		DEX
		DEX
		BPL	.Loop

		PLP
		RTS

TransferOam:
		PHP
		REP	#$20
		; .longm, .shortx

		STZ	!PPU_OAMADDL
		LDA.w	#(%00000010)|(!PPU_OAMDATA<<8)	;\  DMA parameter = Bus: A to B / Address: Increment A / Transfer: 2 bytes, 1 address
							; | B-Bus address = !PPU_OAMDATA
		STA	!DMA_DMAP0			;/    with !WRAM_WMADDH
		LDA.w	#!OamBuffer			;\
		STA	!DMA_A1T0L			; | A-Bus address = !OamBuffer
		STZ	!DMA_A1B0			;/
		LDA.w	#$0220				;\  DMA size = $0220 (Low 512 bytes + High 32 bytes)
		STA	!DMA_DAS0L			;/
		LDX.b	#$01				;\  Execute DMA #0
		STX	!CPU_MDMAEN			;/

		PLP
		RTS

;--------------------------------------------------

NativeNMI:
		SEI
		REP	#$30
		; .longm, .longx
		PHA
		PHX
		PHY
		PHD
		PHB

		JML	.SetPBR				;\  set registers
.SetPBR		PHK					; |   D  = #$0000
		PLB					; |   PB = (PC Bank)
		PEA	$0000				; |   DB = (PC Bank)
		PLD					;/

		JSR	FrameMain

		REP	#$30
		; .longm, .longx
		PLB
		PLD
		PLY
		PLX
		PLA
		CLI
		RTI

NativeIRQ:
		REP	#$30
		; .longm, .longx
		PHA
		PHX
		PHY
		PHD
		PHB

		JML	.SetPBR				;\  set registers
.SetPBR		PHK					; |   D  = #$0000
		PLB					; |   PB = (PC Bank)
		PEA	$0000				; |   DB = (PC Bank)
		PLD					;/

		SEP	#$30
		; .shortm, .shortx

		LDA	!CPU_TIMEUP			;   clear timer IRQ flag
		LDA	!CpuMirror_NMITIMEN		;\
		AND.b	#%11001111			; | clear timer IRQ request
		STA	!CPU_NMITIMEN			; |
		STA	!CpuMirror_NMITIMEN		;/

		JSR	IrqMain

ExitIRQ:	REP	#$30
		; .longm, .longx
		PLB
		PLD
		PLY
		PLX
		PLA
		RTI

TestException:
		SEP	#$14				;   ???X?I??
		REP	#$EB				;   nvmXdIzc
		XCE
		; .longm, .shortx

		LDA.w	#$1FEF				;\  set registers
		TCS					; |   S  = #$1FEF
		LDA.w	#$0000				; |
		TCD					; |   D  = #$0000
		JML	.SetPBR				; |   PB = (PC Bank)
.SetPBR		PHK					; |
		PLB					;/    DB = (PC Bank)

		JSR	FailedMultiplierTest
		JMP	ResetInfLoop

;--------------------------------------------------
; Common data

ZeroByte:
	db	$00, $00, $00, $00
ShiftTable:
	db	$00, $01, $02, $04, $08, $10, $20, $40, $80

; incsrc	"../Include/IncrementTable.asm"		; IncrementTable
incsrc	"../Include/HexAsciiTable.asm"		; HexAscii, HexAsciiHighNibble, HexAsciiLowNibble

;--------------------------------------------------
; Routines

FrameMain:
		SEP	#$30
		; .shortm, .shortx
		LDA	!CPU_RDNMI

		;LDA.b	#$01
		;STA	!DuringNMI

		JSR	ScreenOff

		JSR	UpdateScreen

		SEP	#$30
		; .shortm, .shortx

		;STZ	!DuringNMI
		JSR	ScreenOn

		RTS

macro	SetMirroPPU(name)
		LDA	!PpuMirror_<name>
		STA	!PPU_<name>
endmacro

ScreenOff:
		PHP
		SEP	#$20
		; .shortm

		LDA	!CpuMirror_NMITIMEN		;\
		AND.b	#%01111111			; | Disable NMI, Joypad auto-read
		STA	!CpuMirror_NMITIMEN		; |
		STA	!CPU_NMITIMEN			;/

		LDA.b	#$8F
		STA	!PPU_INIDISP
		PLP
		RTS

ScreenOn:
		PHP
		REP	#$10
		SEP	#$20
		; .shortm, .longx

		; Set fixed color data
		;   xBBB BBGG GGGR RRRR
		;             001R RRRR => R
		;   010G GGGG           => G
		;   100B BBBB           => B
		LDA	!PpuMirror_COLDATAL		;\
		AND.b	#$1F				; | Fixed color R
		ORA.b	#$20				; |
		STA	!PPU_COLDATA			;/
		REP	#$30				;\
		; .longm, .longx			; | Fixed color G
		LDA	!PpuMirror_COLDATA		; |
		ASL	A				; |
		ASL	A				; |
		ASL	A				; |
		XBA					; |
		SEP	#$20				; |
		; .shortm, .longx			; |
		AND.b	#$1F				; |
		ORA.b	#$40				; |
		STA	!PPU_COLDATA			;/
		LDA	!PpuMirror_COLDATAH		;\
		LSR	A				; | Fixed color B
		LSR	A				; |
		AND.b	#$1F				; |
		ORA.b	#$80				; |
		STA	!PPU_COLDATA			;/

		%SetMirroPPU(INIDISP)
		;%SetMirroPPU(OBJSEL)
		%SetMirroPPU(BGMODE)
		%SetMirroPPU(MOSAIC)
		%SetMirroPPU(CGSWSEL)
		%SetMirroPPU(CGADSUB)
		%SetMirroPPU(TM)
		%SetMirroPPU(TS)
		%SetMirroPPU(TMW)
		%SetMirroPPU(TSW)
		%SetMirroPPU(BG12NBA)
		%SetMirroPPU(BG1SC)
		%SetMirroPPU(BG2SC)
		%SetMirroPPU(BG34NBA)
		%SetMirroPPU(SETINI)

		LDA.b	#$0F
		STA	!PPU_INIDISP

		LDA	!CpuMirror_NMITIMEN		;\
		ORA.b	#%10000001			; | Enable NMI, Joypad auto-read
		STA	!CpuMirror_NMITIMEN		; |
		STA	!CPU_NMITIMEN			;/

		PLP
		RTS

;--------------------------------------------------

Initialize_Game:
		PHP
		REP	#$20
		SEP	#$10
		; .longm, .shortx

if !Release
		LDA.w	#MakeWordColor(0, 2, 6)
else
		LDA.w	#MakeWordColor(8, 2, 0)
endif
		STA	!PpuMirror_COLDATAL

		LDX.b	#$0F
		STX	!PpuMirror_INIDISP

		LDX.b	#%00000001
		STX	!PpuMirror_BGMODE

		LDX.b	#%00000010			;   Add subscreen
		STX	!PpuMirror_CGSWSEL
		LDX.b	#%00100000
		STX	!PpuMirror_CGADSUB

		LDX.b	#%00000001
		STX	!PpuMirror_TM
		STX	!PpuMirror_TMW
		LDX.b	#%00000000
		STX	!PpuMirror_TS
		STX	!PpuMirror_TSW

		LDX.b	#(!VRAM_CommonGraphics>>9&$F0)|(!VRAM_CommonGraphics>>13&$0F)
		STX	!PpuMirror_BG12NBA
		LDX.b	#(!VRAM_Layer1Tilemap>>9&$FC)|(%00)
		STX	!PpuMirror_BG1SC
		LDX.b	#(!VRAM_Layer2Tilemap>>9&$FC)|(%00)
		STX	!PpuMirror_BG2SC

		LDX.b	#%00000000
		;LDX.b	#%00000100			;   Overscan
		STX	!PpuMirror_SETINI

		JSR	TransferPalette_PalMain
		JSR	TransferGraphics_Font
		JSR	InitializeTilemap_Main
		; .longm, .shortx

		SEP	#$30
		; .shortm, .shortx

		JSR	TestSnesInitialize

		PLP
		RTS

TransferPalette_PalMain:
		; .longm, .shortx

		LDA.w	#(%00000010)|(!PPU_CGDATA<<8)	;\  DMA parameter = Bus: A to B / Address: Increment A / Transfer: 2 byte, 1 address
							; | B-Bus address = !PPU_CGDATA
		STA	!DMA_DMAP0			;/    with !DMA_BBAD0
		LDA.w	#.Palette			;\
		STA	!DMA_A1T0L			; | A-Bus address = .Palette
		LDX.b	#(.Palette>>16)			; |
		STX	!DMA_A1B0			;/
		LDA.w	#$0200				;\  DMA size = $0200
		STA	!DMA_DAS0L			;/
		LDX.b	#$00				;\  Set CGRAM address = $00
		STX	!PPU_CGADD			;/
		INX					;\  Execute DMA #0
		STX	!CPU_MDMAEN			;/

		RTS

.Palette
incbin	"../Graphics/Palette_Main.bin"

TransferGraphics_Font:
		; .longm, .shortx

		LDX.b	#%10000000			;   Increment at $2119, No remap, Increment 1 word
		STX	!PPU_VMAINC

		LDA.w	#!VRAM_CommonGraphics/2
		STA	!PPU_VMADDL			;   Set VRAM address

		LDA.w	#(%00000001)|(!PPU_VMDATAL<<8)	;\  DMA parameter = Bus: A to B / Address: Increment A / Transfer: 2 byte, 2 address
							; | B-Bus address = !PPU_VMDATAL
		STA	!DMA_DMAP0			;/    with !DMA_BBAD0
		LDA.w	#.Graphics			;\
		STA	!DMA_A1T0L			; | A-Bus address = .Graphics
		LDX.b	#(.Graphics>>16)		; |
		STX	!DMA_A1B0			;/
		LDA.w	#$1000				;\  DMA size = $1000
		STA	!DMA_DAS0L			;/
		INX					;\  Execute DMA #0
		STX	!CPU_MDMAEN			;/

		RTS

.Graphics
incbin	"../Graphics/GFX_Font_4BPP_Gradation.bin"

!TilemapOffset	= 32	; overscan off mode (224px)

TransferTilemap_Main:
		PHP
		REP	#$20
		SEP	#$10
		; .longm, .shortx

		LDX.b	#%00000000			;   Increment at $2118, No remap, Increment 1 word
		STX	!PPU_VMAINC

		LDA.w	#!VRAM_Layer1Tilemap/2
		STA	!PPU_VMADDL			;   Set VRAM address

		LDA.w	#(%00000000)|(!PPU_VMDATAL<<8)	;\  DMA parameter = Bus: A to B / Address: Increment A / Transfer: 1 byte, 1 address
							; | B-Bus address = !PPU_VMDATAL
		STA	!DMA_DMAP0			;/    with !DMA_BBAD0
		LDA.w	#(!TilemapBufferWram+!TilemapOffset)			;\
		STA	!DMA_A1T0L						; | A-Bus address = !PPU_WMDATA
		LDX.b	#(!TilemapBufferWram+!TilemapOffset)>>16		; |
		STX	!DMA_A1B0						;/
		LDA.w	#$03C0				;\  DMA size = $03C0
		STA	!DMA_DAS0L			;/
		LDX.b	#$01				;\  Execute DMA #0
		STX	!CPU_MDMAEN			;/

		PLP
		RTS

InitializeTilemap_Main:
		PHP
		PHB

		REP	#$30
		; .longm, .longx

		LDA.w	#$03C0-1
		LDX.w	#.Tilemap
		LDY.w	#!TilemapBufferWram
		MVN	bank(!TilemapBufferWram), bank(.Tilemap)	; dst, src

		PLB
		PLP
		RTS

.Tilemap
Tilemap_Main:
incbin	"Tilemap/Tilemap_Main.bin"

		; patch version
		pushpc
		org	Tilemap_Main+$09A
		%DataAsciiNumber(!VersionMajor, 1, Zero)
		db	"."
		%DataAsciiNumber(!VersionMinor, 2, Zero)
		pullpc


;!DrawHex_Target	= !PPU_VMDATAL
!DrawHex_Target	= !WRAM_WMDATA
DrawHex:	; .shortm, .shortx
DrawHexA:	TAX
DrawHexX:	LDA	HexAsciiHighNibble, X
		STA	!DrawHex_Target
		LDA	HexAsciiLowNibble, X
		STA	!DrawHex_Target
		RTS



;--------------------------------------------------

UpdateScreen:
		; TODO: update screen buffer
;		SEP	#$30

		;JSR	WriteMemoryLines
		JMP	TransferTilemap_Main

; Argument:
;   !TestPattern = row index
!UpdateWmaddrBase	= (!TilemapBufferWram+!TilemapOffset)&$01FFFF
UpdateRow:
%DefineLocal(target, ScratchMemory+0, 2)
		REP	#$20
		; .longm, .shortx

		LDA	!TestIndex
		AND	#$00FF
		ASL	A
		ASL	A
		ASL	A
		ASL	A
		ASL	A
		STA	.target

		;LDA	.target
		ADC.w	#ScreenVramAddress(!UpdateWmaddrBase, $20, 2, 8)
		STA	!WRAM_WMADDL
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#(!UpdateWmaddrBase>>16)
		STA	!WRAM_WMADDH

		LDX	!ResultTemporary_Offset		;\
		LDA	.OffsetName, X			; | offset name
		STA	!WRAM_WMDATA			;/

		LDA	!WRAM_WMDATA			;\
		LDA	!WRAM_WMDATA			; | M7A
		LDX	!ResultTemporary_M7AH		; |   dummy read * 2
		JSR	DrawHexX			; |
		LDX	!ResultTemporary_M7AL		; |
		JSR	DrawHexX			;/

		LDA	!WRAM_WMDATA			;\
		LDA	!WRAM_WMDATA			; | M7B
		LDX	!ResultTemporary_WriteM7B	; |   dummy read * 2
		JSR	DrawHexX			;/

		LDA	!WRAM_WMDATA			;\  result: 6 master cycle
		LDA	!WRAM_WMDATA			; |   dummy read * 3
		LDA	!WRAM_WMDATA			;/

.DrawValueB	LDX	!ResultTemporary_SignatureB	;\
		CPX.b	#!ResultSignature		; | if(signature){
		BNE	.ErrorB				; |   write(ascii(value));
		LDX	!ResultTemporary_ValueB		; | else{
		JSR	DrawHexX			; |   write('?');
		BRA	.DrawValueH			; | }
.ErrorB		LDA.b	#!DisplayErrorSignature		; |
		STA	!WRAM_WMDATA			; |
		STA	!WRAM_WMDATA			;/

.DrawValueH	LDX	!ResultTemporary_SignatureH	;\
		CPX.b	#!ResultSignature		; | if(signature){
		BNE	.ErrorH				; |   write(ascii(value));
		LDX	!ResultTemporary_ValueH		; | else{
		JSR	DrawHexX			; |   write('?');
		BRA	.DrawValueL			; | }
.ErrorH		LDA.b	#!DisplayErrorSignature		; |
		STA	!WRAM_WMDATA			; |
		STA	!WRAM_WMDATA			;/

.DrawValueL	LDX	!ResultTemporary_SignatureL	;\
		CPX.b	#!ResultSignature		; | if(signature){
		BNE	.ErrorL				; |   write(ascii(value));
		LDX	!ResultTemporary_ValueL		; | else{
		JSR	DrawHexX			; |   write('?');
		BRA	.DrawValueEnd			; | }
.ErrorL		LDA.b	#!DisplayErrorSignature		; |
		STA	!WRAM_WMDATA			; |
		STA	!WRAM_WMDATA			;/

.DrawValueEnd
		LDA	!WRAM_WMDATA			;\  result: actual (6+ master cycle)
		LDA	!WRAM_WMDATA			;/    dummy read * 2

		LDX	!ResultTemporary_WaitB
		JSR	DrawHexX
		LDX	!ResultTemporary_WaitH
		JSR	DrawHexX
		LDX	!ResultTemporary_WaitL
		JSR	DrawHexX

		RTS


.OffsetName
	db	'L','M','H'



;--------------------------------------------------

TestSnesInitialize:
		SEP	#$30
		; .shortm, .shortx

		STZ	!TestIndex
		STZ	!TestOffset

		;RTS					;   fallthrough


!TestIrqV		= 10				;   0-339
!TestIrqH		= 200				;   0-261

SetMultiplierTest:
		JSR	GenerateLandingRoutines

		REP	#$20
		; .longm, .shortx

		; initialize result
		STZ	!ResultTemporary+0

		; set irq
		LDA.w	#!TestIrqV
		STA	!CPU_VTIMEL
		LDA.w	#!TestIrqH
		STA	!CPU_HTIMEL

		SEP	#$30
		; .shortm, .shortx

		LDA	!CpuMirror_NMITIMEN
		ORA.b	#%00110000
		STA	!CpuMirror_NMITIMEN
		STA	!CPU_NMITIMEN

		RTS

!LandingBaseLength	= 16
!LandingPatchOffset1	= $01
!LandingPatchOffset2	= $0D

LandingRamBase:
		base	$00F0
.Routine
		LDX.w	#(!ResultSignature<<8)
		JML	ReturnMultiplierTest

		skip	5
		dw	.Routine
		skip	2
		base	off

; A2 xx AA 5C aa aa 00 __ __ __ __ __ F0 xx __ __

GenerateLandingRoutines:
%DefineLocal(pointer, ScratchMemory+0, 2)

		SEP	#$30
		; .shortm, .shortx

		; generate routine
		LDA.b	#$1F				;\
		STA	.pointer+1			; | .pointer = $1FF0
		LDA.b	#$F0				; |
		STA	.pointer+0			;/

.LoopCall	JSR	GenerateLanding
		DEC	.pointer+1
		BPL	.LoopCall

		RTS

GenerateLanding:
%DefineLocal(pointer, ScratchMemory+0, 2)
		; .shortm, .shortx

		LDY.b	#!LandingBaseLength-1
.LoopCopy	LDA	LandingRamBase, Y
		STA.b	(.pointer), Y
		DEY
		BPL	.LoopCopy
		LDA	.pointer+1
		LDY.b	#!LandingPatchOffset1
		STA.b	(.pointer), Y
		LDY.b	#!LandingPatchOffset2
		STA.b	(.pointer), Y
		RTS

!TestPatternOffset_Offset	= 0
!TestPatternOffset_Address	= 1
!TestPatternOffset_M7A		= 3
!TestPatternOffset_PrevM7B	= 5
!TestPatternOffset_WriteM7B	= 6
!TestCount	= 0	; max = 19
; TestPattern:
;   00 01 02 03 04 05 06 07
;   |  |  |  |  |  |  |  +-- unused
;   |  |  |  |  |  |  +----- write M7B (PC.L)
;   |  |  |  |  |  +-------- previous set: M7B (MPY manipulate)
;   |  |  |  +--+----------- previous set: M7A
;   |  +--+----------------- test routine address
;   +----------------------- test offset (L=0, M=1, H=2)

macro	DefinePattern_L(m7a, m7b)
!TestCount	:= !TestCount+1
	db	$00
	dw	TestMultiplier_L, <m7a>
	db	<m7b>, $34, $00
endmacro
macro	DefinePattern_M(m7aH)
!TestCount	:= !TestCount+1
	db	$01
	dw	TestMultiplier_M, (<m7aH><<8)+$FC
	db	$01, $35, $00
endmacro
macro	DefinePattern_H()
!TestCount	:= !TestCount+1
	db	$02
	dw	TestMultiplier_H, $FCFC
	db	$01, $36, $00
endmacro

TestPattern:
	incsrc	"TestPattern.asm"

if !TestCount > !ResultMaxCount
	warn	"The number of test patterns has exceeded the limit. They cannot all be displayed on the screen."
endif

IrqMain:
		; .shortm, .shortx

		; Adjust the timing if necessary
		; NOP

		; setup
		LDA.b	#$FC				; JSR (abx, X)
		STA	$05				; ORA ; => $05

		REP	#$30				;\
		; .longm, .longx			; | save stack
		TSX					; |
		STX	!StackTeporary			;/
		LDX.w	#!PPU_M7B+1			;\  manipulate stack
		TXS					;/

		LDA	!TestOffset-1
		AND.w	#$FF00
		TAY

		SEP	#$20
		; .shortm, .longx

		TDC					;\
		LDA	!TestIndex			; | X = TestIndex * 8
		ASL					; |   8 = .TestPattern size
		ASL					; |
		ASL					; |
		TAX					;/

		LDA	TestPattern+!TestPatternOffset_Offset, X
		STA	!ResultTemporary_Offset
		LDA	TestPattern+!TestPatternOffset_PrevM7B, X
		STA	!ResultTemporary_PrevM7B
		LDA	TestPattern+!TestPatternOffset_WriteM7B, X
		STA	!ResultTemporary_WriteM7B

		LDA	TestPattern+!TestPatternOffset_M7A+0, X
		STA	!PPU_M7A
		STA	!ResultTemporary_M7AL
		LDA	TestPattern+!TestPatternOffset_M7A+1, X
		STA	!PPU_M7A
		STA	!ResultTemporary_M7AH
		LDA	TestPattern+!TestPatternOffset_PrevM7B, X
		STA	!PPU_M7B

		SEP	#$20
		; .shortm, .longx
		JMP	(TestPattern+!TestPatternOffset_Address, X)


TestMultiplier_L:
		TYX
		JML	$050000+!PPU_MPYL-4

TestMultiplier_M:
		TYX
		JML	$050000+!PPU_MPYL-3

TestMultiplier_H:
		LDA	!PPU_MPYL
		LDA	!PPU_MPYM
		LDA	!PPU_MPYH

		TYX
		JML	$050000+!PPU_MPYL-2


;JML $052130
;  [FetchOpcode ] $008006 = $5C @ Slow
;  [FetchOperand] $008007 = $30 @ Slow
;  [FetchOperand] $008008 = $21 @ Slow
;  [FetchOperand] $008009 = $05 @ Slow
;ORA $05 @ $000005 => $FC
;  [FetchOpcode ] $052130 = $05 @ Fast
;  [FetchOperand] $052131 = $05 @ Fast
;  [Read        ] $000005 = $FC @ Slow
;JSR ($??FC, X) @ $05??FC > $05????
;  [FetchOpcode ] $052132 = $FC @ Fast
;  [FetchOperand] $052133 = $FC @ Fast
;  [PushStack   ] $00211D = $21 @ Fast
;  [PushStack   ] $00211C = $34 @ Fast
;  [FetchOperand] $052134 = $?? @ Fast
;  [ReadDummy   ] $052134 = $?? @ Fast
;  [ReadIndirect] $05??FC = $?? @ Slow/Fast
;  [ReadIndirect] $05??FD = $?? @ Slow/Fast

FailedMultiplierTest:
		SEP	#$30
		; .shortm, .shortx

		LDA	!PPU_MPYL			;\
		STA	!ResultTemporary_WaitL		; | save wait results
		LDA	!PPU_MPYM			; |
		STA	!ResultTemporary_WaitH		; |
		LDA	!PPU_MPYH			; |
		STA	!ResultTemporary_WaitB		;/

		LDA	!TestOffset
		EOR.b	#$80
		STA	!TestOffset

		JMP	NextTest

ReturnMultiplierTest:
		REP	#$30
		; .longm, .longx

		LDA	!StackTeporary
		TCS

		LDA	!PPU_MPYL			;\
		STA	!ResultTemporary_WaitL		; | save wait results
		LDA	!PPU_MPYM			; |
		STA	!ResultTemporary_WaitH		; |
		;LDA	!PPU_MPYH			; |
		;STA	!ResultTemporary_WaitB		;/

		TXA
		SEP	#$30
		; .shortm, .shortx

		LDY	!ResultTemporary_Offset
		EOR	!TestOffset
		STA.w	!ResultTemporary_ValueL, Y	;\
		XBA					; | save results
		STA.w	!ResultTemporary_SignatureL, Y	;/

		CMP.b	#!ResultSignature
		BEQ	.Success
.Failed		LDA	!TestOffset
		EOR.b	#$80
		STA	!TestOffset
		BEQ	.Success			;   retry out
		BRA	NextTest

.Success
		STZ	!TestOffset

NextTest:
		JSR	UpdateRow			;   update screen
		;SEP	#$30
		; .shortm, .shortx

		LDA	!TestIndex			;\
		INC	A				; | Y = (!TestIndex+1) * 16 - 1
		ASL	A				; |
		ASL	A				; |
		ASL	A				; |
		ASL	A				; |
		DEC	A				; |
		TAY					;/
		LDX.b	#$10-2

		REP	#$30
		; .longm, .longx
.LoopCopy	LDA	!ResultTemporary, X
		STA.w	!Result01, Y
		STZ	!ResultTemporary, X		;   with clear
		DEY
		DEY
		DEX
		DEX
		BPL	.LoopCopy
		SEP	#$30
		; .shortm, .shortx

.SkipCopy
		; .shortm, .shortx
		LDA	!TestOffset
		BNE	.Retry
		INC	!TestIndex
		LDA	!TestIndex
		CMP.b	#!TestCount
		BCS	FinishTest
.Retry
		JMP	SetMultiplierTest

FinishTest:
		LDA.b	#$01
		STA	!TestFinished

		RTS

;--------------------------------------------------

		org	$058000
		fillbyte	$00
		fill		$8000

macro	GenerateMultiplierLanding(page)
	pushpc
		org	$050000+<page>+$FC
		dw	?Routine
		BRA	?Error

		org	$050000+<page>+$F0
#?Routine:
		LDX.w	#(!ResultSignature<<8)+((<page>)>>8)
#?Jump:		JML	ReturnMultiplierTest
#?Error:	LDX.w	#(!ErrorSignature<<8)+((<page>)>>8)
		BRA	?Jump
	pullpc
endmacro

macro	GenerateMultiplierLanding_004(page)
		%GenerateMultiplierLanding(<page>+$0000)
		%GenerateMultiplierLanding(<page>+$0100)
		%GenerateMultiplierLanding(<page>+$0200)
		%GenerateMultiplierLanding(<page>+$0300)
endmacro
macro	GenerateMultiplierLanding_016(page)
		%GenerateMultiplierLanding_004(<page>+$0000)
		%GenerateMultiplierLanding_004(<page>+$0400)
		%GenerateMultiplierLanding_004(<page>+$0800)
		%GenerateMultiplierLanding_004(<page>+$0C00)
endmacro

		%GenerateMultiplierLanding_016($8000)
		%GenerateMultiplierLanding_016($9000)
		%GenerateMultiplierLanding_016($A000)
		%GenerateMultiplierLanding_016($B000)
		%GenerateMultiplierLanding_016($C000)
		%GenerateMultiplierLanding_016($D000)
		%GenerateMultiplierLanding_016($E000)
		%GenerateMultiplierLanding_016($F000)


;--------------------------------------------------


