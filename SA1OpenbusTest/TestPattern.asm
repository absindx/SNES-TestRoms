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
;     BW-RAM openbus = $0000
;     BW-RAM latch   = 0 (even)		* TODO: even/odd status still seems inaccurate
;
; The test pattern is defined by the following macro
;   %NextTestPattern(<testID>)
;   %TestPattern(<cpu>, <access>, <address>, <expectSave>, <expectNone>)
;     <cpu>
;       SNES	; !TestPattern_CPU_SNES
;       SA_1	; !TestPattern_CPU_SA_1
;     <access>
;       Read	; !TestPattern_Access_Read
;       Write	; !TestPattern_Access_Write
;     <address>
;       address to access
;     <expectSave>
;       when <access> is "Read":  expected value when having BW-RAM
;       when <access> is "Write": value to be written to address
;     <expectNone>
;       when <access> is "Read":  expected value when not having BW-RAM
;       when <access> is "Write": unused
;
; BW-RAM openbus status is commented on the test pattern.
;   "SRAM" = Has BW-RAM
;   "None" = None BW-RAM
;
;--------------------------------------------------

!__	= $00	; unused
; !TestIRamWriteTarget		; $003042
; !TestBWRamWriteTarget		; $400042

;--------------------------------------------------

	%NextTestPattern(1)							; SA-1: Basic
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM      : BW-RAM openbus = $00AA, BW-RAM latch = 1 (odd)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always even ?)
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0

	%NextTestPattern(2)							; SNES: Basic
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM      : BW-RAM openbus = $00AA, BW-RAM latch = 1 (odd)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always even ?)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0

	%NextTestPattern(3)							; SA-1: Write BW-RAM address (even)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM      : BW-RAM openbus = $00AA, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus.H ($00)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   SRAM      : return BW-RAM openbus.H ($00)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Write,  $400000, $BB, !__)			;   SRAM      : BW-RAM $400000 = $BB
										;   SRAM      : BW-RAM openbus = $00BB, BW-RAM latch = 0 (L)  * write: L -> L
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   SRAM      : return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   (repeat)

	; TODO: fails with BW-RAM, there are more detailed status
	%NextTestPattern(4)							; SA-1: Write BW-RAM address (odd, latch = 1)
		%TestPattern(SA_1,Write,  $400001, $AA, !__)			;   SRAM      : BW-RAM $400001 = $AA
										;   SRAM      : BW-RAM openbus = $AA00, BW-RAM latch = 1 (H)  * write: H -> H
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus.H ($AA)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   SRAM      : return BW-RAM openbus.H ($00)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM      : BW-RAM openbus = $BB00, BW-RAM latch = 1 (H)  * write: H -> H
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus.H ($BB)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   SRAM      : return BW-RAM openbus.H ($BB)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   (repeat)



	%NextTestPattern(5)							; SA-1: Write BW-RAM address (odd, latch = 0)
		%TestPattern(SA_1,Write,  $400000, $00, !__)			;   SRAM      : BW-RAM $400000 = $00
										;   SRAM      : BW-RAM openbus = $0000, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $0000, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Write,  $400001, $AA, !__)			;   SRAM      : BW-RAM $400001 = $AA
										;   SRAM      : BW-RAM openbus = $AA00, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus.L ($00)   * BW-RAM latch = 0
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   SRAM      : return BW-RAM openbus.L ($00)   * BW-RAM latch = 0
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000801, $00, $AA)			;   (repeat)
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM      : BW-RAM openbus = $BB00, BW-RAM latch = 1 (H)  * write: H -> H
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM      : return BW-RAM openbus.H ($BB)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   SRAM      : return BW-RAM openbus.H ($BB)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   (repeat)

	%NextTestPattern(6)							; SA-1: Write BW-RAM address (alternating)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM      : BW-RAM openbus = $00AA, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus.H ($00)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM      : BW-RAM openbus = $BBAA, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SA_1,Write,  $400000, $CC, !__)			;   SRAM      : BW-RAM $400000 = $CC
										;   SRAM      : BW-RAM openbus = $BBCC, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00CC, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus.H ($BB)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0
		%TestPattern(SA_1,Write,  $400001, $DD, !__)			;   SRAM      : BW-RAM $400001 = $DD
										;   SRAM      : BW-RAM openbus = $DDCC, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00DD, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $CC, $DD)			;   SRAM      : return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0
										;         None: return BW-RAM openbus.L ($DD)   * BW-RAM latch = 0

	%NextTestPattern(7)							; SA-1: Write BW-RAM address (increment)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM      : BW-RAM openbus = $00AA, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $00, $AA)			;   SRAM      : return BW-RAM openbus.H ($00)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM      : BW-RAM openbus = $BBAA, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SA_1,Write,  $400002, $CC, !__)			;   SRAM      : BW-RAM $400002 = $CC
										;   SRAM      : BW-RAM openbus = $BBCC, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00CC, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;   SRAM      : return BW-RAM openbus.H ($BB)   * BW-RAM latch = 1
										;         None: return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0
		%TestPattern(SA_1,Write,  $400003, $DD, !__)			;   SRAM      : BW-RAM $400003 = $DD
										;   SRAM      : BW-RAM openbus = $DDCC, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00DD, BW-RAM latch = 0 (always L ?)
		%TestPattern(SA_1,Read,   $000800, $CC, $DD)			;   SRAM      : return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0
										;         None: return BW-RAM openbus.L ($DD)   * BW-RAM latch = 0

	%NextTestPattern(8)							; SNES: Write BW-RAM address (even)
		%TestPattern(SNES,Write,  $000800, $11, !__)			;   SRAM, None: W-RAM $7E0800 = $00
		%TestPattern(SNES,Write,  $000801, $22, !__)			;   SRAM, None: W-RAM $7E0801 = $00
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM      : BW-RAM openbus = $00AA, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $000800, $11, $11)			;   SRAM, None: return W-RAM $7E0800 ($11)
		%TestPattern(SNES,Read,   $000801, $22, $22)			;   SRAM, None: return W-RAM $7E0801 ($22)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $00, $AA)			;   SRAM      : return BW-RAM $400001 ($00)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SNES,Write,  $400000, $BB, !__)			;   SRAM      : BW-RAM $400000 = $BB
										;   SRAM      : BW-RAM openbus = $00BB, BW-RAM latch = 0 (L)  * write: L -> L
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $BB, $BB)			;   SRAM      : return BW-RAM $400000 ($BB)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $00, $BB)			;   SRAM      : return BW-RAM $400001 ($00)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0

	%NextTestPattern(9)							; SNES: Write BW-RAM address (odd, latch = 1)
		%TestPattern(SNES,Write,  $000800, $11, !__)			;   SRAM, None: W-RAM $7E0800 = $00
		%TestPattern(SNES,Write,  $000801, $22, !__)			;   SRAM, None: W-RAM $7E0801 = $00
		%TestPattern(SNES,Write,  $400001, $AA, !__)			;   SRAM      : BW-RAM $400001 = $AA
										;   SRAM      : BW-RAM openbus = $AA00, BW-RAM latch = 1 (H)  * write: H -> H
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $000800, $11, $11)			;   SRAM, None: return W-RAM $7E0800 ($11)
		%TestPattern(SNES,Read,   $000801, $22, $22)			;   SRAM, None: return W-RAM $7E0801 ($22)
		%TestPattern(SNES,Read,   $400000, $00, $AA)			;   SRAM      : return BW-RAM $400000 ($00)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $AA, $AA)			;   SRAM      : return BW-RAM $400001 ($AA)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SNES,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM      : BW-RAM openbus = $00BB, BW-RAM latch = 0 (L)  * write: L -> L
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $00, $BB)			;   SRAM      : return BW-RAM $400000 ($00)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $BB, $BB)			;   SRAM      : return BW-RAM $400001 ($BB)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0

	%NextTestPattern(10)							; SNES: Write BW-RAM address (odd, latch = 0)
		%TestPattern(SNES,Write,  $000800, $11, !__)			;   SRAM, None: W-RAM $7E0800 = $00
		%TestPattern(SNES,Write,  $000801, $22, !__)			;   SRAM, None: W-RAM $7E0801 = $00
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM      : BW-RAM openbus = $00AA, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM      : BW-RAM openbus = $BBAA, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $000800, $11, $11)			;   SRAM, None: return W-RAM $7E0800 ($11)
		%TestPattern(SNES,Read,   $000801, $22, $22)			;   SRAM, None: return W-RAM $7E0801 ($22)
		%TestPattern(SNES,Read,   $400000, $AA, $BB)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $BB, $BB)			;   SRAM      : return BW-RAM $400001 ($BB)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SNES,Write,  $400001, $CC, !__)			;   SRAM      : BW-RAM $400001 = $CC
										;   SRAM      : BW-RAM openbus = $CCAA, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00CC, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $AA, $CC)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $CC, $CC)			;   SRAM      : return BW-RAM $400001 ($CC)
										;         None: return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0

	%NextTestPattern(11)							; SNES: Write BW-RAM address (alternating)
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM      : BW-RAM openbus = $00AA, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SNES,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM      : BW-RAM openbus = $BBAA, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $AA, $BB)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $BB, $BB)			;   SRAM      : return BW-RAM $400001 ($BB)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SNES,Write,  $400000, $CC, !__)			;   SRAM      : BW-RAM $400000 = $CC
										;   SRAM      : BW-RAM openbus = $BBCC, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00CC, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $CC, $CC)			;   SRAM      : return BW-RAM $400000 ($CC)
										;         None: return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $BB, $CC)			;   SRAM      : return BW-RAM $400001 ($BB)
										;         None: return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0
		%TestPattern(SNES,Write,  $400001, $DD, !__)			;   SRAM      : BW-RAM $400001 = $DD
										;   SRAM      : BW-RAM openbus = $DDCC, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00DD, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $CC, $DD)			;   SRAM      : return BW-RAM $400000 ($CC)
										;         None: return BW-RAM openbus.L ($DD)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $DD, $DD)			;   SRAM      : return BW-RAM $400001 ($DD)
										;         None: return BW-RAM openbus.L ($DD)   * BW-RAM latch = 0

	%NextTestPattern(12)							; SNES: Write BW-RAM address (increment)
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM      : BW-RAM $400000 = $AA
										;   SRAM      : BW-RAM openbus = $00AA, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00AA, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($AA)   * BW-RAM latch = 0
		%TestPattern(SNES,Write,  $400001, $BB, !__)			;   SRAM      : BW-RAM $400001 = $BB
										;   SRAM      : BW-RAM openbus = $BBAA, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00BB, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $AA, $BB)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400001, $BB, $BB)			;   SRAM      : return BW-RAM $400001 ($BB)
										;         None: return BW-RAM openbus.L ($BB)   * BW-RAM latch = 0
		%TestPattern(SNES,Write,  $400002, $CC, !__)			;   SRAM      : BW-RAM $400002 = $CC
										;   SRAM      : BW-RAM openbus = $BBCC, BW-RAM latch = 1 (H)
										;         None: BW-RAM openbus = $00CC, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $AA, $CC)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400002, $CC, $CC)			;   SRAM      : return BW-RAM $400002 ($CC)
										;         None: return BW-RAM openbus.L ($CC)   * BW-RAM latch = 0
		%TestPattern(SNES,Write,  $400003, $DD, !__)			;   SRAM      : BW-RAM $400003 = $DD
										;   SRAM      : BW-RAM openbus = $DDCC, BW-RAM latch = 0 (L)
										;         None: BW-RAM openbus = $00DD, BW-RAM latch = 0 (always L ?)
		%TestPattern(SNES,Read,   $400000, $AA, $DD)			;   SRAM      : return BW-RAM $400000 ($AA)
										;         None: return BW-RAM openbus.L ($DD)   * BW-RAM latch = 0
		%TestPattern(SNES,Read,   $400003, $DD, $DD)			;   SRAM      : return BW-RAM $400003 ($DD)
										;         None: return BW-RAM openbus.L ($DD)   * BW-RAM latch = 0




;--------------------------------------------------

; test

	%NextTestPattern(13)							; SA-1: Write unmapped address
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   $00AA, latch = 1
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   $BBAA, latch = 0
		%TestPattern(SA_1,Write,  $400002, $CC, !__)			;   $BBCC, latch = 1
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;
		%TestPattern(SA_1,Write,  $000800, $11, !__)			;   latch = 1
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;
		%TestPattern(SA_1,Write,  $000801, $22, !__)			;   latch = 1
		%TestPattern(SA_1,Read,   $000800, $BB, $CC)			;
	; => pass

	%NextTestPattern(14)							; SA-1: Write unmapped address
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   $00AA, latch = 1
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   $BBAA, latch = 0
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;
		%TestPattern(SA_1,Write,  $000800, $11, !__)			;   latch = 0
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;
		%TestPattern(SA_1,Write,  $000801, $22, !__)			;   latch = 0
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;
	; => pass

;--------------------------------------------------

; needs a rewrite

;	%NextTestPattern(5)							; SNES: Read mapped address
;		%TestPattern(SNES,Write,  $7E0800, $AA, !__)			;   SRAM, None: SNES WRAM $7E0800 = $EE
;		%TestPattern(SNES,Write,  $400000, $BB, !__)			;   SRAM, None: BW-RAM openbus = $00BB, BW-RAM latch = 1 (H)
;		%TestPattern(SNES,Read,   $000800, $AA, $AA)			;   SRAM, None: return SNES WRAM $7E0800 ($AA)
;		%TestPattern(SNES,Read,   $000800, $AA, $AA)			;   (repeat)
;
;	%NextTestPattern(6)							; SA-1: Update BW-RAM openbus
;		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM, None: BW-RAM openbus = $AA
;		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM, None: return BW-RAM openbus ($AA)
;		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return $400000 ($AA)
;										;         None: return BW-RAM openbus ($AA)
;		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM, None: BW-RAM openbus = $BB
;		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM, None: return BW-RAM openbus ($BB)
;		%TestPattern(SA_1,Read,   $400000, $AA, $BB)			;   SRAM      : return $400000 ($AA)
;										;   SRAM      : BW-RAM openbus = $AA
;										;         None: return BW-RAM openbus ($BB)
;		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus ($AA)
;										;         None: return BW-RAM openbus ($BB)
;
;	%NextTestPattern(7)							; SNES: Update BW-RAM openbus
;		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM, None: BW-RAM openbus = $AA
;		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return $400000 ($AA)
;										;         None: return BW-RAM openbus ($AA)
;		%TestPattern(SNES,Write,  $400001, $BB, !__)			;   SRAM, None: BW-RAM openbus = $BB
;		%TestPattern(SNES,Read,   $400000, $AA, $BB)			;   SRAM      : return $400000 ($AA)
;										;         None: return BW-RAM openbus ($BB)
;		%TestPattern(SNES,Read,   $400001, $BB, $BB)			;   SRAM      : return $400001 ($BB)
;										;         None: return BW-RAM openbus ($BB)
;
;	%NextTestPattern(8)							; No update BW-RAM openbus from SA-1
;		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
;		%TestPattern(SA_1,Read,   $000800, $AA, $AA)
;		%TestPattern(SA_1,Write,  !TestIRamWriteTarget, $BB, !__)	;   I-RAM does not update BW-RAM openbus
;		%TestPattern(SA_1,Write,  $008000, $CC, !__)			;   ROM does not update BW-RAM openbus
;		%TestPattern(SA_1,Write,  $002232, $DD, !__)			;   I/O does not update BW-RAM openbus ($2232: SDAL)
;		%TestPattern(SA_1,Read,   $000800, $AA, $AA)
;
;	%NextTestPattern(9)							; 
;		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
;		%TestPattern(SNES,Read,   $000800, $AA, $AA)
;		%TestPattern(SNES,Write,  !TestIRamWriteTarget, $BB, !__)	;   BW-RAM openbus = $BB
;		%TestPattern(SNES,Write,  $008000, $CC, !__)			;   ROM does not update BW-RAM openbus
;		%TestPattern(SNES,Write,  $002232, $DD, !__)			;   I/O does not update BW-RAM openbus ($2232: SDAL)
;		%TestPattern(SNES,Read,   $000800, $BB, $BB)

;--------------------------------------------------
