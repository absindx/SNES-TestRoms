;--------------------------------------------------
; ROM setting
;--------------------------------------------------

;--------------------------------------------------
; General setting
;--------------------------------------------------

!RomSize	= 32*1024				; LoROM, 1 bank
!RamSize	= 128*1024
!RomType	= 0					; 0=LoROM / 1=HiROM
;!DEBUG		= 1					; Release build with comment out

!VersionMajor	= 1
!VersionMinor	= 0

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

	!RomStart	= $808000
	!StartAddress	= $008000
	!BankSize	= $008000
	!EofAddress	= ((!RomSize)*2)+!RomStart
else
	print	"ROM Type: HiROM"
	hirom
	!LoROM	= 0
	!HiROM	= 1

	!RomStart	= $C00000
	!StartAddress	= $008000
	!BankSize	= $010000
	!EofAddress	= (!RomSize)+!RomStart
endif

	print	"ROM Size: ", dec(!RomSize/1024), "KiB"
	print	"RAM Size: ", dec(!RamSize/1024), "KiB"

if defined("DEBUG")
	print	"Build: Debug"
else
	print	"Build: Release"
endif

	!BlankByte	= select(defined("DEBUG"), $FF, $00)
	padbyte	!BlankByte
	check bankcross off
	org	!RomStart
	pad	!EofAddress
	check bankcross on

;--------------------------------------------------
; ROM header
;--------------------------------------------------

	org $00FFB0
	padbyte $00
AdditionalCartridgeInformation:
	db	"HK"					; $00FFB0 : Maker code
	db	"11SB"					; $00FFB2 : Game code
	db	0,0,0,0,0,0				; $00FFB6 : Reserved
	db	$00					; $00FFBC : Expansion flash size
	db	$00					; $00FFBD : Expansion Ram size
	db	$00					; $00FFBE : Special version
	db	$00					; $00FFBF : Chipset subtype

	org $00FFC0
	padbyte $20
CartridgeInformation:
	;	 0123456789ABCDEF01234
	db	"SA-1 BACKUP DETECTION"			; $00FFC0 : Game title
	pad $00FFD5
	db	$20|!RomType				; $00FFD5 : Map mode (Slow 2.68 MHz)
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

;	org $00FFE0
;Vectors:
;	dw	UnusedHandler				; $00FFE0 : Native (Reserved)
;	dw	UnusedHandler				; $00FFE2 : Native (Reserved)
;	dw	UnusedHandler				; $00FFE4 : Native COP
;	dw	UnusedHandler				; $00FFE6 : Native BRK
;	dw	UnusedHandler				; $00FFE8 : Native ABORT
;	dw	UnusedHandler				; $00FFEA : Native NMI
;	dw	UnusedHandler				; $00FFEC : Native (Reserved)
;	dw	UnusedHandler				; $00FFEE : Native IRQ
;	dw	UnusedHandler				; $00FFF0 : Emulation (Reserved)
;	dw	UnusedHandler				; $00FFF2 : Emulation (Reserved)
;	dw	UnusedHandler				; $00FFF4 : Emulation COP
;	dw	UnusedHandler				; $00FFF6 : Emulation (Reserved)
;	dw	UnusedHandler				; $00FFF8 : Emulation ABORT
;	dw	UnusedHandler				; $00FFFA : Emulation NMI
;	dw	EmulationRESET				; $00FFFC : Emulation RESET
;	dw	UnusedHandler				; $00FFFE : Emulation IRQ / BRK

;--------------------------------------------------
; Interrupt handler
;--------------------------------------------------

	org $00FFAF
UnusedHandler:
		RTI
