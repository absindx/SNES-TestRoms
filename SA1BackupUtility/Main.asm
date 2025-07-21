;--------------------------------------------------
; SA-1 backup detection utility
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
incsrc	"../Include/IOName_SA1.asm"

incsrc	"RamMap.asm"

;--------------------------------------------------
; Vectors
;--------------------------------------------------

	org $00FFE0
Vectors:
	dw	UnusedHandler				; $00FFE0 : Native (Reserved)
	dw	UnusedHandler				; $00FFE2 : Native (Reserved)
	dw	UnusedHandler				; $00FFE4 : Native COP
	dw	UnusedHandler				; $00FFE6 : Native BRK
	dw	UnusedHandler				; $00FFE8 : Native ABORT
	dw	NativeNMI				; $00FFEA : Native NMI
	dw	UnusedHandler				; $00FFEC : Native (Reserved)
	dw	NativeIRQ				; $00FFEE : Native IRQ
	dw	UnusedHandler				; $00FFF0 : Emulation (Reserved)
	dw	UnusedHandler				; $00FFF2 : Emulation (Reserved)
	dw	UnusedHandler				; $00FFF4 : Emulation COP
	dw	UnusedHandler				; $00FFF6 : Emulation (Reserved)
	dw	UnusedHandler				; $00FFF8 : Emulation ABORT
	dw	UnusedHandler				; $00FFFA : Emulation NMI
	dw	EmulationRESET				; $00FFFC : Emulation RESET
	dw	UnusedHandler				; $00FFFE : Emulation IRQ / BRK

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

		JSR	ScreenOn
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

UpdateJoypad:
		PHP
		SEP	#$30
		; .shortm, shortx

		LDA.b	#%00000001			;\
-		BIT	!CPU_HVBJOY			; | wait automatic controller reading
		BNE	-				;/

		REP	#$20
		; .longm, shortx
		LDA	!CPU_STDCNTRL1L			;\
		EOR.b	!JoypadInput			; | detect keydown
		AND	!CPU_STDCNTRL1L			; |
		STA.b	!JoypadPress			;/
		LDA	!CPU_STDCNTRL1L
		STA.b	!JoypadInput

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

		SEP	#$20
		LDA	!CPU_RDNMI

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

		;JSR	IrqMain

ExitIRQ:	REP	#$30
		; .longm, .longx
		PLB
		PLD
		PLY
		PLX
		PLA
		RTI

;--------------------------------------------------
; Common data

ZeroByte:
	db	$00, $00, $00, $00
ShiftTable:
	db	$00, $01, $02, $04, $08, $10, $20, $40, $80

; incsrc	"../Include/IncrementTable.asm"		; IncrementTable
incsrc	"../Include/HexAsciiTable.asm"		; HexAscii, HexAsciiHighNibble, HexAsciiLowNibble
incsrc	"PopcountTable.asm"			; PopcountTable

;--------------------------------------------------
; Routines

FrameMain:
		SEP	#$30
		; .shortm, .shortx
		LDA	!CPU_RDNMI

		;LDA.b	#$01
		;STA	!DuringNMI

		JSR	ScreenOff

		;JSR	UpdateScreen			;   only at initialization

.Exit
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

		SEP	#$30
		; .shortm, .shortx
		JSR	TestSnesInitialize
		JSR	UpdateScreen			;   only at initialization
		JSR	TestBwRamSize
		JSR	UpdateScreenBwRamSize

		JSR	TestSnesSetMemory

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

; Argument:
;   A = draw value (16bit)
;   P.M = 0
;   P.X = 1
DrawDecimal4digit:
		; .longm, .shortx

		; vwxy / 10 = vwx.y
		STA	!CPU_WRDIVL
		LDY.b	#10
		STY	!CPU_WRDIVB
		LDY.b	#100				; 2
		NOP					; 4
		NOP					; 6
		NOP					; 8
		NOP					; 10
		REP	#0				; 13 NOP
		LDA	!CPU_RDDIVL			; 17, 18
		LDX	!CPU_RDMPYL			;   remainder

		; vwx / 100 = v.wx
		STA	!CPU_WRDIVL
		STY	!CPU_WRDIVB
		LDY.b	#10				; 2
		TXA					; 4
		AND.w	#$00FF				; 7
		ORA.w	#$0030				; 10
		TAX					; 12
		PHX					; 15
		LDX	!CPU_RDDIVL			; 19
		LDA	!CPU_RDMPYL			;   remainder

		; wx / 10 = w.x
		STA	!CPU_WRDIVL
		STY	!CPU_WRDIVB
		SEP	#$30				; 3
		TXA					; 5
		ORA.b	#$30				; 7
		STA	!DrawHex_Target			; 11
		PLY					; 15
		LDA	!CPU_RDDIVL			; 19
		ORA.b	#$30
		STA	!DrawHex_Target

		LDA	!CPU_RDMPYL			;   remainder
		ORA.b	#$30
		STA	!DrawHex_Target

		TYA
		ORA.b	#$30
		STA	!DrawHex_Target

		REP	#$20
		; .longm, .shortx

		RTS

; Argument:
;   A = draw value (8bit)
;   P.M = 0
;   P.X = 1
DrawDecimalByte:
		; .longm, .shortx

		; vwx / 100 = v.wx
		STA	!CPU_WRDIVL
		LDY.b	#100
		STY	!CPU_WRDIVB
		LDY.b	#10				; 2
		SEP	#$20				; 5
		NOP					; 7
		NOP					; 9
		NOP					; 11
		NOP					; 13
		LDA	!CPU_RDDIVL			; 17
		LDX	!CPU_RDMPYL			;   remainder

		; wx / 10 = w.x
		STZ	!CPU_WRDIVH
		STX	!CPU_WRDIVL
		STY	!CPU_WRDIVB
		ORA.b	#$30				; 2
		STA	!DrawHex_Target			; 6
		NOP					; 8
		NOP					; 10
		NOP					; 12
		NOP					; 14
		LDA	!CPU_RDDIVL			; 18
		ORA.b	#$30
		STA	!DrawHex_Target

		LDA	!CPU_RDMPYL			;   remainder
		ORA.b	#$30
		STA	!DrawHex_Target

		RTS


;--------------------------------------------------

UpdateScreen:
		; update screen buffer
		JSR	UpdateSaveResult
		JSR	UpdateIRamDump
		JSR	UpdateBwRamDump

		JMP	TransferTilemap_Main

UpdateScreenBwRamSize:
		JSR	UpdateBwRamSize
		JMP	TransferTilemap_Main


!UpdateWmaddrBase	= (!TilemapBufferWram+!TilemapOffset)&$01FFFF

macro	PatchValue(x, y, digit, value)
		pushpc
		org	Tilemap_Main+(<y>*$20)+(<x>)
		%DataAsciiNumber((<value>), <digit>, Zero)
		pullpc
endmacro
macro	PatchDumpAddress(y, value)
		pushpc
		org	Tilemap_Main+(<y>*$20)+($03)
		%DataAsciiHex((<value>), 3, Zero)
		pullpc
endmacro

		; patch denominator
		%PatchValue($15, $08, 3, $100)
		%PatchValue($14, $09, 4, $800)
		%PatchValue($15, $0A, 3, $100)
		%PatchValue($14, $0B, 4, $800)

		; patch dump address
		%PatchDumpAddress($12, !BackupTestIRam+$00)
		%PatchDumpAddress($13, !BackupTestIRam+$08)
		%PatchDumpAddress($14, !BackupTestIRam+$10)
		%PatchDumpAddress($15, !BackupTestIRam+$18)
		%PatchDumpAddress($18, !BackupTestBwRam+$00)
		%PatchDumpAddress($19, !BackupTestBwRam+$08)
		%PatchDumpAddress($1A, !BackupTestBwRam+$10)
		%PatchDumpAddress($1B, !BackupTestBwRam+$18)

UpdateSaveResult:
		REP	#$20
		STZ	!WRAM_WMADDH

		;REP	#$20							;\
		; .longm, .shortx						; | I-RAM save bytes
		LDA.w	#ScreenVramAddress(!UpdateWmaddrBase, $20, $10, $07)	; |
		STA	!WRAM_WMADDL						; |
		SEP	#$10							; |
		LDA	!TestIRamSaveBytes					; |
		JSR	DrawDecimalByte						;/

		REP	#$20							;\
		; .longm, .shortx						; | I-RAM save bits
		LDA.w	#ScreenVramAddress(!UpdateWmaddrBase, $20, $0F, $08)	; |
		STA	!WRAM_WMADDL						; |
		LDA	!TestIRamSaveBits					; |
		JSR	DrawDecimal4digit					;/

		;REP	#$20							;\
		; .longm, .shortx						; | BW-RAM save bytes
		LDA.w	#ScreenVramAddress(!UpdateWmaddrBase, $20, $10, $09)	; |
		STA	!WRAM_WMADDL						; |
		SEP	#$10							; |
		LDA	!TestBwRamSaveBytes					; |
		JSR	DrawDecimalByte						;/

		REP	#$20							;\
		; .longm, .shortx						; | BW-RAM save bits
		LDA.w	#ScreenVramAddress(!UpdateWmaddrBase, $20, $0F, $0A)	; |
		STA	!WRAM_WMADDL						; |
		LDA	!TestBwRamSaveBits					; |
		JMP	DrawDecimal4digit					;/

UpdateBwRamSize:
		REP	#$20
		; .longm, .shortx
		LDA.w	#ScreenVramAddress(!UpdateWmaddrBase, $20, $12, $0B)
		STA	!WRAM_WMADDL
		SEP	#$20
		; .shortm, .shortx
		LDX	!TestSramSizeB
		JSR	DrawHexX
		LDX	!TestSramSizeH
		JSR	DrawHexX
		LDX	!TestSramSizeL
		JMP	DrawHexX


UpdateIRamDump:
%DefineLocal(target, ScratchMemory+0, 2)
%DefineLocal(column, ScratchMemory+2, 1)

		REP	#$21
		LDA.w	#ScreenVramAddress(!UpdateWmaddrBase, $20, $07, $11)
		STA	.target

		SEP	#$30
		; .longm, .shortx, CLC

		STZ	!WRAM_WMADDH

		LDX.b	#$00
.DrawLine	LDA.b	#$07				;   CLC
		STA	.column
		LDA	.target+1
		STA	!WRAM_WMADDM
		LDA	.target
		STA	!WRAM_WMADDL
		ADC.b	#$20
		STA	.target
.DrawColumn	LDY	!BackupTestIRamMapping, X
		INX
		LDA	HexAsciiHighNibble, Y
		STA	!WRAM_WMDATA
		LDA	HexAsciiLowNibble, Y
		STA	!WRAM_WMDATA
		LDA	!WRAM_WMDATA			;   dummy
		DEC	.column
		BPL	.DrawColumn
		CPX.b	#!MemoryDumpSize
		BCC	.DrawLine
.Return		RTS

UpdateBwRamDump:
%DefineLocal(target, ScratchMemory+0, 2)
%DefineLocal(column, ScratchMemory+2, 1)

		REP	#$21
		LDA.w	#ScreenVramAddress(!UpdateWmaddrBase, $20, $07, $17)
		STA	.target

		SEP	#$30
		; .longm, .shortx, CLC

		LDX.b	#$00
.DrawLine	LDA.b	#$07				;   CLC
		STA	.column
		LDA	.target+1
		STA	!WRAM_WMADDM
		LDA	.target
		STA	!WRAM_WMADDL
		ADC.b	#$20
		STA	.target
.DrawColumn	LDY	!BackupTestBwRamMapping, X
		INX
		LDA	HexAsciiHighNibble, Y
		STA	!WRAM_WMDATA
		LDA	HexAsciiLowNibble, Y
		STA	!WRAM_WMDATA
		LDA	!WRAM_WMDATA			;   dummy
		DEC	.column
		BPL	.DrawColumn
		CPX.b	#!MemoryDumpSize
		BCC	.DrawLine
.Return		RTS



;--------------------------------------------------

TestSnesInitialize:
%DefineLocal(bitsSum, !ScratchMemory+0, 2)

		SEP	#$20
		REP	#$10
		; .shortm, .longx

		STZ	!SA1_BMAPS

		LDX.w	#$00FF				;\
		LDY.w	#$0000				; |
		TYA					; |
.LoopIRamBytes	LDA	MemoryTestIRam, X		; |
		CMP	!BackupTestIRamMapping, X	; |
		BNE	+				; |
		INY					; |
+		DEX					; |
		BPL	.LoopIRamBytes			; |
		STY	!TestIRamSaveBytes		;/

		LDX.w	#$00FF				;\
		LDY.w	#$0000				; |
.LoopBwRamBytes	LDA	MemoryTestBwRam, X		; |
		CMP	!BackupTestBwRamMapping, X	; |
		BNE	+				; |
		INY					; |
+		DEX					; |
		BPL	.LoopBwRamBytes			; |
		STY	!TestBwRamSaveBytes		;/

		REP	#$20
		; .longm, .longx
		STZ	.bitsSum			;\
		LDX.w	#$00FF				; |
.LoopIRamBits	LDA	MemoryTestIRam, X		; |
		EOR	!BackupTestIRamMapping, X	; |
		AND.w	#$00FF				; |
		TAY					; |
		LDA	Popcount, Y			; |
		AND.w	#$00FF				; |
		CLC					; |
		ADC	.bitsSum			; |
		STA	.bitsSum			; |
		DEX					; |
		BPL	.LoopIRamBits			; |
		SEC					; |
		LDA.w	#!TestMemoryBits		; |
		SBC	.bitsSum			; |
		STA	!TestIRamSaveBits		;/

		STZ	.bitsSum			;\
		LDX.w	#$00FF				; |
.LoopBwRamBits	LDA	MemoryTestBwRam, X		; |
		EOR	!BackupTestBwRamMapping, X	; |
		AND.w	#$00FF				; |
		TAY					; |
		LDA	Popcount, Y			; |
		AND.w	#$00FF				; |
		CLC					; |
		ADC	.bitsSum			; |
		STA	.bitsSum			; |
		DEX					; |
		BPL	.LoopBwRamBits			; |
		SEC					; |
		LDA.w	#!TestMemoryBits		; |
		SBC	.bitsSum			; |
		STA	!TestBwRamSaveBits		;/

		RTS

TestSnesSetMemory:
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#$80				;\  unlock BW-RAM protection from SNES-CPU
		STA	!SA1_SBWE			;/
		LDA.b	#$FF				;\  unlock I-RAM protection from SNES-CPU
		STA	!SA1_SIWP			;/

		REP	#$30
		; .longm, .longx

		PHB
		LDA.w	#!TestMemorySize-1
		LDX.w	#MemoryTestIRam
		LDY.w	#!BackupTestIRamMapping
		MVN	bank(!BackupTestIRamMapping), bank(MemoryTestIRam)
		;PLB

		;PHB
		LDA.w	#!TestMemorySize-1
		LDX.w	#MemoryTestBwRam
		LDY.w	#!BackupTestBwRamMapping
		MVN	bank(!BackupTestBwRamMapping), bank(MemoryTestBwRam)
		PLB

		RTS

;--------------------------------------------------

macro	TestMemory(addr, access)
		LDA.<access>	<addr>
		EOR.b		#$FF
		STA.<access>	<addr>
		CMP.<access>	<addr>
endmacro

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

;--------------------------------------------------

incsrc	"TestPattern.asm"


