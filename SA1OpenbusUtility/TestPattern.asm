;--------------------------------------------------
; Test pattern
;--------------------------------------------------

!TestAddressMode	= 1
!TestBitmapMode		= %00000000	; $223F SA-1 BBF $00=16 color mode, $80=4 color mode
TestAddressList:
if !TestAddressMode == 1
		dl	$000000
		dl	$002000
		dl	$002100	; PPU write registers
		dl	$002140	; after PPU registers
		dl	$002200	; SA-1 write registers
		dl	$003000	; SA-1 I-RAM
		dl	$003800	; after SA-1 I-RAM
		dl	$004000	; MMIO registers
		dl	$004100
		dl	$004200	; MMIO write registers
		dl	$004220	; after MMIO registers
		dl	$004380	; after DMA registers
		dl	$005000
		dl	$400000	; SA-1 BW-RAM
		dl	$500000	; SA-1 BW-RAM (mirror)
		dl	$600000	; SA-1 BW-RAM (bitmap)
		dl	$700000	; SA-1 BW-RAM (bitmap mirror)
		dl	$7E0000	; SNES WRAM

elseif !TestAddressMode == 2
		dl	$400000
		dl	$400001
		dl	$43FFFF
		dl	$440000
		dl	$4FFFFF
		dl	$500000
		dl	$500001
		dl	$53FFFF
		dl	$540000
		dl	$5FFFFF
		dl	$600000
		dl	$63FFFF
		dl	$640000
		dl	$6FFFFF
		dl	$700000
		dl	$7E0000
		dl	$7E0001
		dl	$7FFFFF

elseif !TestAddressMode == 3
		dl	$002000
		dl	$0021FF
		dl	$003800
		dl	$004000
		dl	$005FFF
		dl	$006000
		dl	$007FFF
		dl	$3F7FFF
		dl	$7DFFFF
		dl	$802000
		dl	$8021FF
		dl	$803800
		dl	$804000
		dl	$805FFF
		dl	$806000
		dl	$807FFF
		dl	$BF7FFF
		dl	$FDFFFF

else
	error	"Invalid value: !TestAddressMode"
endif
