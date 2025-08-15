;--------------------------------------------------
; SA-1 BW-RAM openbus test patterns
;--------------------------------------------------

includeonce

;--------------------------------------------------
;
; At the beginning of each test pattern, the state of the I/Os is reset.
; See subroutine below for details.
;   ResetSnesStatus:
;   ResetSa1Status:
;   (internal status)
;     BW-RAM history[0]   = $400000
;     BW-RAM history[1]   = $400000
;     BW-RAM openbus      = $00
;
; The test pattern is defined by the following macro
;   %NextTestPattern(<testID>)
;   %TestPattern(<cpu>, <access>, <address>, <expectSave>, <expectNone>)
;     <cpu>
;       SNES		; !TestPattern_CPU_SNES
;       SA_1		; !TestPattern_CPU_SA_1
;     <access>
;       Read		; !TestPattern_Access_Read
;       Write		; !TestPattern_Access_Write
;       WAI		; !TestPattern_Access_WAI
;       STP		; !TestPattern_Access_STP
;       ReadyWait	; !TestPattern_Access_ReadyWait
;       DebugBreak	; !TestPattern_Access_DebugBreak
;     <address>
;       address to access
;     <expectSave>
;       when <access> is "Read":  expected value when having BW-RAM
;       when <access> is "Write": value to be written to address
;     <expectNone>
;       when <access> is "Read":  expected value when not having BW-RAM
;       when <access> is "Write": unused
;   %TestBreak()
;
; BW-RAM openbus status is commented on the test pattern.
;   "SRAM" = Has BW-RAM
;   "None" = None BW-RAM
;
;--------------------------------------------------

; Defines
!__	= $00	; unused
; !TestIRamOffset		; $042
; !TestBwRamOffset		; $042
; !TestIRamTarget		; $003042
; !TestBWRamTarget		; $400042

;--------------------------------------------------

	;--------------------------------------------------
	; Basic

	%NextTestPattern(1)							; SA-1: Basic
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   (repeat)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   (repeat)

	%NextTestPattern(2)							; SNES: Basic
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   (repeat)
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   (repeat)

	;--------------------------------------------------
	; SA-1 Write BW-RAM address

	%NextTestPattern(3)							; SA-1: Write BW-RAM address (same -> same address: $400000 -> $400000 -> $400000)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $000801, $AA, $AA)			;   (repeat)
		%TestPattern(SA_1,Write,  $400000, $BB, !__)			;   SRAM      : BW-RAM $400000 = $BB
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400000 = $BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400000 = $BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   (repeat)

	%NextTestPattern(4)							; SA-1: Write BW-RAM address (different -> same address: $400000 -> $400001 -> $400001)
		%TestPattern(SA_1,Write,  $400001, $AA, !__)			;   SRAM      : BW-RAM $400001 = $AA
										;   SRAM, None: BW-RAM history = [$400001, $400000]
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus ($00) * read BW-RAM history[1] value ($400000 = $00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   SRAM      : return BW-RAM openbus ($00) * read BW-RAM history[1] value ($400000 = $00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM, None: BW-RAM history = [$400001, $400001]
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400001 = $BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400001 = $BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   (repeat)

	%NextTestPattern(5)							; SA-1: Write BW-RAM address (different -> different address: $400000 -> $400001 -> $400000)
		%TestPattern(SA_1,Write,  $400001, $AA, !__)			;   SRAM      : BW-RAM $400001 = $AA
										;   SRAM, None: BW-RAM history = [$400001, $400000]
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus ($00) * read BW-RAM history[1] value ($400000 = $00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   SRAM      : return BW-RAM openbus ($00) * read BW-RAM history[1] value ($400000 = $00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Write,  $400000, $BB, !__)			;   SRAM      : BW-RAM $400000 = $BB
										;   SRAM, None: BW-RAM history = [$400000, $400001]
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400001 = $AA)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $AA, $BB)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400001 = $AA)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $000801, $AA, $BB)			;   (repeat)

	%NextTestPattern(6)							; SA-1: Write BW-RAM address (alternate address: $400000 -> $400000 -> $400001 -> $40000 -> $400001)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM, None: BW-RAM history = [$400001, $400000]
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Write,  $400000, $CC, !__)			;   SRAM      : BW-RAM $400000 = $CC
										;   SRAM, None: BW-RAM history = [$400000, $400001]
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400001 = $BB)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Write,  $400001, $DD, !__)			;   SRAM      : BW-RAM $400001 = $DD
										;   SRAM, None: BW-RAM history = [$400001, $400000]
		%TestPattern(SA_1,Read,   $000800, $CC, $DD)			;   SRAM      : return BW-RAM openbus ($CC) * read BW-RAM history[1] value ($400000 = $CC)
										;         None: return BW-RAM openbus ($DD) * floating databus value

	%NextTestPattern(7)							; SA-1: Write BW-RAM address (even address: $400000 -> $400000 -> $400002 -> $40000 -> $400002)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  $400002, $BB, !__)			;   SRAM      : BW-RAM $400002 = $BB
										;   SRAM, None: BW-RAM history = [$400002, $400000]
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Write,  $400000, $CC, !__)			;   SRAM      : BW-RAM $400000 = $CC
										;   SRAM, None: BW-RAM history = [$400000, $400002]
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400002 = $BB)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Write,  $400002, $DD, !__)			;   SRAM      : BW-RAM $400002 = $DD
										;   SRAM, None: BW-RAM history = [$400002, $400000]
		%TestPattern(SA_1,Read,   $000800, $CC, $DD)			;   SRAM      : return BW-RAM openbus ($CC) * read BW-RAM history[1] value ($400000 = $CC)
										;         None: return BW-RAM openbus ($DD) * floating databus value

	%NextTestPattern(8)							; SA-1: Write BW-RAM address (odd address: $400000 -> $400001 -> $400003 -> $40001 -> $400003)
		%TestPattern(SA_1,Write,  $400001, $AA, !__)			;   SRAM      : BW-RAM $400001 = $AA
										;   SRAM, None: BW-RAM history = [$400001, $400000]
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus ($00) * read BW-RAM history[1] value ($400000 = $00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  $400003, $BB, !__)			;   SRAM      : BW-RAM $400003 = $BB
										;   SRAM, None: BW-RAM history = [$400003, $400001]
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400001 = $AA)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Write,  $400001, $CC, !__)			;   SRAM      : BW-RAM $400001 = $CC
										;   SRAM, None: BW-RAM history = [$400001, $400003]
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400003 = $BB)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Write,  $400003, $DD, !__)			;   SRAM      : BW-RAM $400003 = $DD
										;   SRAM, None: BW-RAM history = [$400003, $400001]
		%TestPattern(SA_1,Read,   $000800, $CC, $DD)			;   SRAM      : return BW-RAM openbus ($CC) * read BW-RAM history[1] value ($400001 = $CC)
										;         None: return BW-RAM openbus ($DD) * floating databus value

	%NextTestPattern(9)							; SA-1: Write BW-RAM address (increment address: $400000 -> $400000 -> $400001 -> $400002 -> $40003)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM, None: BW-RAM history = [$400001, $400000]
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Write,  $400002, $CC, !__)			;   SRAM      : BW-RAM $400002 = $CC
										;   SRAM, None: BW-RAM history = [$400002, $400001]
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400001 = $BB)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Write,  $400003, $DD, !__)			;   SRAM      : BW-RAM $400003 = $DD
										;   SRAM, None: BW-RAM history = [$400003, $400002]
		%TestPattern(SA_1,Read,   $000800, $CC, $DD)			;   SRAM      : return BW-RAM openbus ($CC) * read BW-RAM history[1] value ($400002 = $CC)
										;         None: return BW-RAM openbus ($DD) * floating databus value

	%NextTestPattern(10)							; SA-1: Write BW-RAM address (decrement address: $400000 -> $400003 -> $400002 -> $400001 -> $40000)
		%TestPattern(SA_1,Write,  $400003, $AA, !__)			;   SRAM      : BW-RAM $400003 = $AA
										;   SRAM, None: BW-RAM history = [$400003, $400000]
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus ($00) * read BW-RAM history[1] value ($400000 = $00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  $400002, $BB, !__)			;   SRAM      : BW-RAM $400002 = $BB
										;   SRAM, None: BW-RAM history = [$400002, $400003]
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400003 = $AA)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Write,  $400001, $CC, !__)			;   SRAM      : BW-RAM $400001 = $CC
										;   SRAM, None: BW-RAM history = [$400001, $400002]
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400002 = $BB)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Write,  $400000, $DD, !__)			;   SRAM      : BW-RAM $400000 = $DD
										;   SRAM, None: BW-RAM history = [$400000, $400001]
		%TestPattern(SA_1,Read,   $000800, $CC, $DD)			;   SRAM      : return BW-RAM openbus ($CC) * read BW-RAM history[1] value ($400001 = $CC)
										;         None: return BW-RAM openbus ($DD) * floating databus value

	%NextTestPattern(11)							; SA-1: Read other BW-RAM address
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM, None: BW-RAM history = [$400001, $400000]
		%TestPattern(SA_1,Write,  $400002, $CC, !__)			;   SRAM      : BW-RAM $400002 = $CC
										;   SRAM, None: BW-RAM history = [$400002, $400001]
		%TestPattern(SA_1,Read,   $400000, $AA, $CC)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400001 = $BB)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Read,   $400001, $BB, $CC)			;   SRAM      : return BW-RAM $400001 ($BB)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400001 = $BB)
										;         None: return BW-RAM openbus ($CC) * floating databus value

	%NextTestPattern(12)							; SA-1: Write BW-RAM openbus
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Write,  $000800, $BB, !__)			;   SRAM, None: NOP
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  $400001, $CC, !__)			;   SRAM      : BW-RAM $400001 = $CC
										;   SRAM, None: BW-RAM history = [$400001, $400000]
		%TestPattern(SA_1,Write,  $000801, $DD, !__)			;   SRAM, None: NOP
		%TestPattern(SA_1,Read,   $000800, $AA, $CC)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Read,   $000801, $AA, $CC)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($CC) * floating databus value

	;--------------------------------------------------
	; SNES Write BW-RAM address

	%NextTestPattern(13)							; SNES: Write BW-RAM address (same -> same address: $400000 -> $400000 -> $400000)
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Read,   $000801, $00, $00)			;   SRAM, None: return W-RAM $7E0801 ($00)
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SNES,Write,  $400000, $BB, !__)			;   SRAM      : BW-RAM $400000 = $BB
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Read,   $000801, $00, $00)			;   SRAM, None: return W-RAM $7E0801 ($00)
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $BB, $BB)			;   SRAM      : return BW-RAM $400000 ($BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value

	%NextTestPattern(14)							; SNES: Write BW-RAM address (alternate address: $400000 -> $400000 -> $400001 -> $40000 -> $400001)
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SNES,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $400000, $AA, $BB)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SNES,Write,  $400000, $CC, !__)			;   SRAM      : BW-RAM $400000 = $CC
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $400000, $CC, $CC)			;   SRAM      : return BW-RAM $400000 ($CC)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SNES,Write,  $400001, $DD, !__)			;   SRAM      : BW-RAM $400001 = $DD
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Read,   $400000, $CC, $DD)			;   SRAM      : return BW-RAM $400000 ($CC)
										;         None: return BW-RAM openbus ($DD) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $CC, $DD)			;   SRAM      : return BW-RAM $400000 ($BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value

	%NextTestPattern(15)							; SNES: Write BW-RAM address (increment address: $400000 -> $400000 -> $400001 -> $400002 -> $40003)
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Write,  $400002, $CC, !__)			;   SRAM      : BW-RAM $400002 = $CC
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Write,  $400003, $DD, !__)			;   SRAM      : BW-RAM $400003 = $DD
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SA_1,Read,   $000800, $AA, $DD)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($DD) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $AA, $DD)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($DD) * floating databus value

	%NextTestPattern(16)							; SNES: Write BW-RAM address (decrement address: $400000 -> $400003 -> $400002 -> $400001 -> $40000)
		%TestPattern(SNES,Write,  $400003, $AA, !__)			;   SRAM      : BW-RAM $400003 = $AA
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Write,  $400002, $BB, !__)			;   SRAM      : BW-RAM $400002 = $BB
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Write,  $400001, $CC, !__)			;   SRAM      : BW-RAM $400001 = $CC
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Write,  $400000, $DD, !__)			;   SRAM      : BW-RAM $400000 = $DD
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SA_1,Read,   $000800, $DD, $DD)			;   SRAM      : return BW-RAM openbus ($DD) * read BW-RAM history[1] value ($400000 = $DD)
										;         None: return BW-RAM openbus ($DD) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $DD, $DD)			;   SRAM      : return BW-RAM $400000 ($DD)
										;         None: return BW-RAM openbus ($DD) * floating databus value

	%NextTestPattern(17)							; SNES: Read other BW-RAM address
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Write,  $400002, $CC, !__)			;   SRAM      : BW-RAM $400002 = $CC
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $400000, $AA, $CC)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Read,   $400001, $BB, $CC)			;   SRAM      : return BW-RAM $400001 ($BB)
										;         None: return BW-RAM openbus ($DD) * floating databus value
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SA_1,Read,   $000800, $AA, $CC)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $AA, $CC)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($DD) * floating databus value

	%NextTestPattern(18)							; SNES: Write BW-RAM openbus
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Write,  $000800, $BB, !__)			;   SRAM, None: W-RAM $7E0800 = $BB
		%TestPattern(SNES,Read,   $000800, $BB, $BB)			;   SRAM, None: return W-RAM $7E0800 ($BB)
		%TestPattern(SNES,Write,  $400001, $CC, !__)			;   SRAM      : BW-RAM $400001 = $CC
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Write,  $000801, $DD, !__)			;   SRAM, None: W-RAM $7E0800 = $DD
		%TestPattern(SNES,Read,   $000800, $BB, $BB)			;   SRAM, None: return W-RAM $7E0800 ($BB)
		%TestPattern(SNES,Read,   $000801, $DD, $DD)			;   SRAM, None: return W-RAM $7E0800 ($DD)
		%TestPattern(SA_1,Read,   $000800, $AA, $CC)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $AA, $CC)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($CC) * floating databus value

	;--------------------------------------------------
	; Write I-RAM address (no BW-RAM openbus update)

	%NextTestPattern(19)							; SA-1: Write other region
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  !TestIRamTarget, $BB, !__)		;   SRAM, None: I-RAM does not update BW-RAM history
		%TestPattern(SA_1,Write,  $008000, $CC, !__)			;   SRAM, None: ROM does not update BW-RAM history
		%TestPattern(SA_1,Write,  $002232, $DD, !__)			;   SRAM, None: I/O does not update BW-RAM history ($2232: SDAL)
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $400001, $00, $AA)			;   SRAM      : return BW-RAM $400001 ($00)
										;         None: return BW-RAM openbus ($AA) * floating databus value

	%NextTestPattern(20)							; SA-1: Write I-RAM
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  $000000|!TestIRamOffset, $11, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($000042)
		%TestPattern(SA_1,Write,  $003000|!TestIRamOffset, $22, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($003042)
		%TestPattern(SA_1,Write,  $3F0000|!TestIRamOffset, $33, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($3F0042)
		%TestPattern(SA_1,Write,  $3F3000|!TestIRamOffset, $44, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($3F3042)
		%TestPattern(SA_1,Write,  $800000|!TestIRamOffset, $55, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($800042)
		%TestPattern(SA_1,Write,  $803000|!TestIRamOffset, $66, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($803042)
		%TestPattern(SA_1,Write,  $BF0000|!TestIRamOffset, $77, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($BF0042)
		%TestPattern(SA_1,Write,  $BF3000|!TestIRamOffset, $88, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($BF3042)
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value

	%NextTestPattern(21)							; SNES: Write BW-RAM openbus
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Write,  !TestIRamTarget, $BB, !__)		;   SRAM, None: I-RAM does not update BW-RAM openbus
		%TestPattern(SNES,Write,  $008000, $CC, !__)			;   SRAM, None: ROM does not update BW-RAM openbus
		%TestPattern(SNES,Write,  $002232, $DD, !__)			;   SRAM, None: I/O does not update BW-RAM openbus ($2232: SDAL)
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SNES,Read,   $400001, $00, $AA)			;   SRAM      : return BW-RAM $400000 ($00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value

	%NextTestPattern(22)							; SNES: Write I-RAM, W-RAM
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)
		%TestPattern(SNES,Write,  $000000|!TestIRamOffset, $11, !__)	;   SRAM, None: W-RAM does not update BW-RAM openbus ($000042)
		%TestPattern(SNES,Write,  $003000|!TestIRamOffset, $22, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($003042)
		%TestPattern(SNES,Write,  $3F0000|!TestIRamOffset, $33, !__)	;   SRAM, None: W-RAM does not update BW-RAM openbus ($3F0042)
		%TestPattern(SNES,Write,  $3F3000|!TestIRamOffset, $44, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($3F3042)
		%TestPattern(SNES,Write,  $800000|!TestIRamOffset, $55, !__)	;   SRAM, None: W-RAM does not update BW-RAM openbus ($800042)
		%TestPattern(SNES,Write,  $803000|!TestIRamOffset, $66, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($803042)
		%TestPattern(SNES,Write,  $BF0000|!TestIRamOffset, $77, !__)	;   SRAM, None: W-RAM does not update BW-RAM openbus ($BF0042)
		%TestPattern(SNES,Write,  $BF3000|!TestIRamOffset, $88, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($BF3042)
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM, None: return W-RAM $7E0800 ($00)

	%NextTestPattern(23)							; SNES: Write I-RAM, W-RAM
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: SNES side BW-RAM write does not update BW-RAM history
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SNES,Write,  $000000|!TestIRamOffset, $11, !__)	;   SRAM, None: W-RAM does not update BW-RAM openbus ($000042)
		%TestPattern(SNES,Write,  $003000|!TestIRamOffset, $22, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($003042)
		%TestPattern(SNES,Write,  $3F0000|!TestIRamOffset, $33, !__)	;   SRAM, None: W-RAM does not update BW-RAM openbus ($3F0042)
		%TestPattern(SNES,Write,  $3F3000|!TestIRamOffset, $44, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($3F3042)
		%TestPattern(SNES,Write,  $800000|!TestIRamOffset, $55, !__)	;   SRAM, None: W-RAM does not update BW-RAM openbus ($800042)
		%TestPattern(SNES,Write,  $803000|!TestIRamOffset, $66, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($803042)
		%TestPattern(SNES,Write,  $BF0000|!TestIRamOffset, $77, !__)	;   SRAM, None: W-RAM does not update BW-RAM openbus ($BF0042)
		%TestPattern(SNES,Write,  $BF3000|!TestIRamOffset, $88, !__)	;   SRAM, None: I-RAM does not update BW-RAM openbus ($BF3042)
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM      : return BW-RAM openbus ($AA) * read BW-RAM history[1] value ($400000 = $AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value

	;--------------------------------------------------
	; Write BW-RAM mirror address

	%NextTestPattern(24)							; SA-1: Write BW-RAM mirror address ($440000, $006000, $3F6000, $806000, $BF6000)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Write,  $440000, $BB, !__)			;   SRAM      : BW-RAM $400000 = $BB
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400000 = $BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Write,  $480001, $CC, !__)			;   SRAM      : BW-RAM $400001 = $CC
										;   SRAM, None: BW-RAM history = [$400001, $400000]
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400000 = $BB)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Write,  $4C0002, $DD, !__)			;   SRAM      : BW-RAM $400002 = $DD
										;   SRAM, None: BW-RAM history = [$400002, $400001]
		%TestPattern(SA_1,Read,   $000800, $CC, $DD)			;   SRAM      : return BW-RAM openbus ($CC) * read BW-RAM history[1] value ($400001 = $CC)
										;         None: return BW-RAM openbus ($DD) * floating databus value

	%NextTestPattern(25)							; SA-1: Write BW-RAM mirror address ($440000, $006000, $3F6000, $806000, $BF6000)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Write,  $440000, $BB, !__)			;   SRAM      : BW-RAM $400000 = $BB
										;   SRAM, None: BW-RAM history = [$440000, $400000]
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($400000 = $BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Write,  $006000, $CC, !__)			;   SRAM      : BW-RAM $400000 = $CC
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $CC, $CC)			;   SRAM      : return BW-RAM openbus ($CC) * read BW-RAM history[1] value ($400000 = $CC)
										;         None: return BW-RAM openbus ($CC) * floating databus value
		%TestPattern(SA_1,Write,  $006000, $DD, !__)			;   SRAM      : BW-RAM $400000 = $DD
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $DD, $DD)			;   SRAM      : return BW-RAM openbus ($DD) * read BW-RAM history[1] value ($400000 = $DD)
										;         None: return BW-RAM openbus ($DD) * floating databus value
		%TestPattern(SA_1,Write,  $806000, $EE, !__)			;   SRAM      : BW-RAM $400000 = $EE
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $EE, $EE)			;   SRAM      : return BW-RAM openbus ($EE) * read BW-RAM history[1] value ($400000 = $EE)
										;         None: return BW-RAM openbus ($EE) * floating databus value
		%TestPattern(SA_1,Write,  $806000, $FF, !__)			;   SRAM      : BW-RAM $400000 = $FF
										;   SRAM, None: BW-RAM history = [$400000, $400000]
		%TestPattern(SA_1,Read,   $000800, $FF, $FF)			;   SRAM      : return BW-RAM openbus ($FF) * read BW-RAM history[1] value ($400000 = $FF)
										;         None: return BW-RAM openbus ($FF) * floating databus value

	%NextTestPattern(26)							; SA-1: Write BW-RAM mapping address ($402000)
		%TestPattern(SA_1,Write,  !SA1_BMAP, $01, !__)			;   SRAM, None: BMAP = $01 ($006000: BW-RAM $402000-$403FFF)
		%TestPattern(SA_1,Write,  $006000, $AA, !__)			;   SRAM      : BW-RAM $402000 = $AA
										;   SRAM, None: BW-RAM history = [$402000, $400000]
		%TestPattern(SA_1,Read,   $400000, $00, $AA)			;   SRAM      : return BW-RAM $400000 ($00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $402000, $AA, $AA)			;   SRAM      : return BW-RAM $402000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus ($00) * read BW-RAM history[1] value ($400000 = $00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  $3F6000, $BB, !__)			;   SRAM      : BW-RAM $402000 = $BB
										;   SRAM, None: BW-RAM history = [$402000, $402000]
		%TestPattern(SA_1,Read,   $400000, $00, $BB)			;   SRAM      : return BW-RAM $400000 ($00)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $402000, $BB, $BB)			;   SRAM      : return BW-RAM $402000 ($BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($402000 = $BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value

	%NextTestPattern(27)							; SA-1: Write BW-RAM mapping address ($402000)
		%TestPattern(SA_1,Write,  !SA1_BMAP, $01, !__)			;   SRAM, None: BMAP = $01 ($006000: BW-RAM $402000-$403FFFFF)
		%TestPattern(SA_1,Write,  $806000, $AA, !__)			;   SRAM      : BW-RAM $402000 = $AA
										;   SRAM, None: BW-RAM history = [$402000, $400000]
		%TestPattern(SA_1,Read,   $400000, $00, $AA)			;   SRAM      : return BW-RAM $400000 ($00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $402000, $AA, $AA)			;   SRAM      : return BW-RAM $402000 ($AA)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus ($00) * read BW-RAM history[1] value ($400000 = $00)
										;         None: return BW-RAM openbus ($AA) * floating databus value
		%TestPattern(SA_1,Write,  $BF6000, $BB, !__)			;   SRAM      : BW-RAM $402000 = $BB
										;   SRAM, None: BW-RAM history = [$402000, $402000]
		%TestPattern(SA_1,Read,   $400000, $00, $BB)			;   SRAM      : return BW-RAM $400000 ($00)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $402000, $BB, $BB)			;   SRAM      : return BW-RAM $402000 ($BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus ($BB) * read BW-RAM history[1] value ($402000 = $BB)
										;         None: return BW-RAM openbus ($BB) * floating databus value



	;--------------------------------------------------

	; TODO: mirror
	; TODO: bank
	; TODO: map
	; TODO: bitmap
	; TODO: protect + ^
	; TODO: io register(read)

;--------------------------------------------------
