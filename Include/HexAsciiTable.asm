;--------------------------------------------------
; Ascii lookup table
;--------------------------------------------------

includeonce

	skip align 256
HexAsciiHighNibble:
		db	"0000000000000000"
		db	"1111111111111111"
		db	"2222222222222222"
		db	"3333333333333333"
		db	"4444444444444444"
		db	"5555555555555555"
		db	"6666666666666666"
		db	"7777777777777777"
		db	"8888888888888888"
		db	"9999999999999999"
		db	"AAAAAAAAAAAAAAAA"
		db	"BBBBBBBBBBBBBBBB"
		db	"CCCCCCCCCCCCCCCC"
		db	"DDDDDDDDDDDDDDDD"
		db	"EEEEEEEEEEEEEEEE"
		db	"FFFFFFFFFFFFFFFF"

HexAscii:
HexAsciiLowNibble:
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
		db	"0123456789ABCDEF"
