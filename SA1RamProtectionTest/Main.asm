;--------------------------------------------------
; SA-1 RAM protection test
;--------------------------------------------------

;--------------------------------------------------
; General setting
;--------------------------------------------------

!RomSize	= 32*1024
if defined("NOSRAM")
!RamSize	= 0*1024
else
!RamSize	= 128*1024
endif
!RomType	= 0					; 0=LoROM / 1=HiROM
;!DEBUG		= 1					; Release build with comment out

!VersionMajor	= 0
!VersionMinor	= 81

;--------------------------------------------------
; ROM setting
;--------------------------------------------------

	arch	65816

	math	round on
	math	pri on

if !RomType == 0
	print	"ROM Type: LoROM"
	lorom
	!LoROM	= 1
	!HiROM	= 0

	!EofAddress	= !RomSize*2+$808000
	org	$808000
else
	print	"ROM Type: HiROM"
	hirom
	!LoROM	= 0
	!HiROM	= 1

	!EofAddress	= !RomSize+$C00000
	org	$C00000
endif
	print	"ROM Size: ", dec(!RomSize/1024), "KiB"
	print	"RAM Size: ", dec(!RamSize/1024), "KiB"

if defined("DEBUG")
	print	"Build: Debug"
else
	print	"Build: Release"
endif
	print	"EOF Address:  $", hex(!EofAddress)

	check bankcross off

	!BlankByte	= select(defined("DEBUG"), $FF, $00)
	padbyte	!BlankByte

	pad	!EofAddress
	check bankcross on

	optimize dp always

;--------------------------------------------------
; Library
;--------------------------------------------------

incsrc	"../Include/Library_Macro.asm"
incsrc	"../Include/Library_Debug.asm"
incsrc	"../Include/IOName_Standard.asm"
incsrc	"../Include/IOName_SA1.asm"

incsrc	"RamMap.asm"
incsrc	"MessageID.asm"

;--------------------------------------------------
; ROM header
;--------------------------------------------------

	org $00FFB0
	padbyte $00
AdditionalCartridgeInformation:
	db	"HK"					; $00FFB0 : Maker code
	db	"05SR"					; $00FFB2 : Game code
	db	0,0,0,0,0,0				; $00FFB6 : Reserved
	db	$00					; $00FFBC : Expansion flash size
	db	$00					; $00FFBD : Expansion Ram size
	db	$00					; $00FFBE : Special version
	db	$00					; $00FFBF : Chipset subtype

	org $00FFC0
	padbyte $20
CartridgeInformation:
	;	 0123456789ABCDEF01234
	db	"SA-1 RAM PROTECT TEST"			; $00FFC0 : Game title
	pad $00FFD5
	db	$23|!RomType				; $00FFD5 : Map mode (Slow 2.68 MHz)
	if !RamSize > 0
	db	$35					; $00FFD6 : Cartridge type (ROM + RAM + Battery + SA-1)
	else
	db	$33					; $00FFD6 : Cartridge type (ROM + SA-1)
	endif
	db	log2(!RomSize/1024)			; $00FFD7 : Rom size
	db	log2(!RamSize/1024)			; $00FFD8 : Ram size
	db	$00					; $00FFD9 : Destination code (Japan)
	db	$33					; $00FFDA : Fixed value
	db	$00					; $00FFDB : Mask rom version
	dw	$FFFF					; $00FFDC : Complement check
	dw	$0000					; $00FFDE : Check sum

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
; Interrupt handler
;--------------------------------------------------

	org $00FFAF
UnusedHandler:
		RTI

;--------------------------------------------------
; ROM signature
;--------------------------------------------------

if !LoROM
	org	$008000
else
	org	$C00000
endif

	;	 0123456789ABCDEF
	db	"SA-1 RAM PROTECTION TEST"
	%NewLine(CRLF, 1)
	db	"ver "
	%DataAsciiNumber(!VersionMajor, 1, None)
	db	"."
	%DataAsciiNumber(!VersionMinor, 2, Zero)
	%NewLine(CRLF, 2)

if !HiROM
	org	$008000	; HiROM
endif

	skip align	16

;--------------------------------------------------
; Program
;--------------------------------------------------

	padbyte $00
;	org $008000
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
		TSC
		STA	!SnesInitialStackPointer
		LDA.w	#$1FFF				; |
		TCS					; |   S  = #$1FFF
		LDA.w	#$0000				; |
		TCD					; |   D  = #$0000
		JML	.SetPBR				; |   PB = (PC Bank)
.SetPBR		PHK					; |
		PLB					; /   DB = (PC Bank)
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

		; Clear VRAM
		JSR	ClearVram

		; Clear CGRAM
		JSR	ClearPalette
		JSR	TransferPalette

		; Clear OAM
		JSR	ClearOam
		JSR	TransferOam

		; Upload to sound driver
		; TODO : Implements

		; Clear SRAM
		; Don't do

		; .longm, .shortx
		LDA	!SnesInitialStackPointer
		STA	!TestSnesStackPointerBoot

		SEP	#$30
		; .shortm, .shortx

		JSR	Initialize_Game

		JSR	ScreenOn
		;LDA.b	#%10000001			;\  Enable NMI, Joypad auto-read
		;STA	!CPU_NMITIMEN			;/

		REP	#$20
		; .longm, .shortx
		LDA.w	#!StopSP_SNES
		TCS
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

		INC	!FrameCounter
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

;--------------------------------------------------
; Common data

ZeroByte:
	db	$00, $00, $00, $00
ShiftTable:
	db	$00, $01, $02, $04, $08, $10, $20, $40, $80

incsrc	"../Include/IncrementTable.asm"	; IncrementTable
incsrc	"../Include/HexAsciiTable.asm"	; HexAscii, HexAsciiHighNibble, HexAsciiLowNibble

;--------------------------------------------------
; IRQ(From SA-1)

	skip align	256
NativeIRQ:
		; NOP slide
		;	$00 $01 $02 $03 $04 $05 $06 $07 $08 $09 $0A $0B $0C $0D $0E $0F
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $00
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $10
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $20
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $30
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $40
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $50
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $60
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $70
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $80
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $90
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $A0
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $B0
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $C0
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $D0
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF	; $E0
		db	$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$CD,$EA,$EA	; $F0
		; $00-$FB:    CF (CMP long) * 252
		; $FC-$FF:    CF CD EA EA (CMP long : CMP abs : NOP : NOP)
		; save cycle: EA EA (NOP : NOP) -> 42 EA (WDM #imm : NOP)

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
		LDA.w	#$0000				; |   DB = (PC Bank)
		TCD					;/

		SEP	#$30
		; .shortm, .shortx
		LDA.b	#%10000000			;\  clear IRQ
		STA	!SA1_SIC			;/
		LDA	!SA1_SFR			;\
		AND.b	#$0F				; | message from SA-1
		TAX					;/
		LDA	$00FFEE				;   IRQ vector address(low) -> additional message byte
		JSR	SNESProcessMessage

		REP	#$30
		; .longm, .longx
		PLB
		PLD
		PLY
		PLX
		PLA
		RTI

;--------------------------------------------------
; Routines

FrameMain:
		SEP	#$30
		; .shortm, .shortx

		LDA.b	#$01
		STA	!DuringNMI

		JSR	ScreenOff

		JSR	UpdateScreen

.Exit
		SEP	#$30
		; .shortm, .shortx

		STZ	!DuringNMI
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

		LDA.b	#%00000001			;\  Disable NMI, Joypad auto-read
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

		LDA.b	#%10000001			;\  Enable NMI, Joypad auto-read
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
		STX	!PpuMirror_SETINI

		JSR	TransferPalette_PalMain
		JSR	TransferGraphics_Font
		JSR	TransferTilemap_Main
		; .longm, .shortx

		SEP	#$30
		; .shortm, .shortx
		;LDA.b	!SNESStatus_Idle
		;JSR	SetSnesStatus

		JSR	TestInitial

		; Initialize SA-1
		JSR	InitializeSA1

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

TransferTilemap_Main:
		; .longm, .shortx

		LDX.b	#%00000000			;   Increment at $2118, No remap, Increment 1 word
		STX	!PPU_VMAINC

		LDA.w	#!VRAM_Layer1Tilemap/2
		STA	!PPU_VMADDL			;   Set VRAM address

		LDA.w	#(%00000000)|(!PPU_VMDATAL<<8)	;\  DMA parameter = Bus: A to B / Address: Increment A / Transfer: 1 byte, 1 address
							; | B-Bus address = !PPU_VMDATAL
		STA	!DMA_DMAP0			;/    with !DMA_BBAD0
		LDA.w	#(.Tilemap+32)			;\
		STA	!DMA_A1T0L			; | A-Bus address = .Tilemap
		LDX.b	#((.Tilemap+32)>>16)		; |
		STX	!DMA_A1B0			;/
		LDA.w	#$03C0				;\  DMA size = $03C0
		STA	!DMA_DAS0L			;/
		INX					;\  Execute DMA #0
		STX	!CPU_MDMAEN			;/

		RTS

.Tilemap
incbin	"Tilemap/Tilemap_Main.bin"

		; patch version
		pushpc
		org	.Tilemap+$09A
		%DataAsciiNumber(!VersionMajor, 1, Zero)
		db	"."
		%DataAsciiNumber(!VersionMinor, 2, Zero)
		pullpc

DrawHex:	; .shortm, .shortx
DrawHexA:	TAX
DrawHexX:	LDA	HexAsciiHighNibble, X
		STA	!PPU_VMDATAL
		LDA	HexAsciiLowNibble, X
		STA	!PPU_VMDATAL
		RTS

;--------------------------------------------------
; SA-1 Routines

SA1RESET:
		SEI					;   for emulator vector detection
		REP	#$CB				;   nv??dIzc
		XCE
		REP	#$31				;   nvmxdIzc
		; .longm, .longx
		LDA.w	#$0000
		TCD
		TSX					;   save SP for !TestID_SA1_Boot

		JML	.SetPBR				;\  PB = $00
.SetPBR		LDA.w	#ZeroByte			; | DB = $00
		TCS					; |
		PLB					;/
		SEP	#$20
		; .shortm, .longx

		LDA.b	#%11110000			;\  clear SA-1 IRQ
		STA	!SA1_CIC			;/

		LDA.b	#%01000000			;\
		STA	!SA1_SCNT			; | override SNES IRQ vector
		LDA.b	#(NativeIRQ>>8)			; | set SA-1 -> SNES IRQ high byte
		STA	!SA1_SIVH			;/

		JMP	SA1TestMain

SA1NMI:
		RTI

SA1IRQ:
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
		LDA.w	#$0000				; |   DB = (PC Bank)
		TCD					;/

		SEP	#$30
		; .shortm, .shortx
		LDA.b	#%11110000			;\  clear SA-1 IRQ
		STA	!SA1_CIC			;/
		JSR	SA1ProcessMessage

		REP	#$30
		; .longm, .longx
		PLB
		PLD
		PLY
		PLX
		PLA
		RTI

incsrc	"TestRoutines.asm"

;--------------------------------------------------

print	"Last address: $", pc
