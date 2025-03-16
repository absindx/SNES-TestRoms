;--------------------------------------------------
; SA-1 BW-RAM openbus test patterns
;--------------------------------------------------

includeonce

;--------------------------------------------------

; %NextTestPattern(<testID>)
; %TestPattern(<cpu>, <access>, <address>, <expectSave>, <expectNone>)
; "SRAM" = Has BW-RAM
; "None" = None BW-RAM

!__	= $00	; unused

	%NextTestPattern(1)							; SA-1: Basic
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM, None: BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return $400000 ($AA)
										;         None: return BW-RAM openbus ($AA)
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   (repeat)

	%NextTestPattern(2)							; SNES: Basic
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM, None: BW-RAM openbus = $AA
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return $400000 ($AA)
										;         None: return BW-RAM openbus ($AA)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   (repeat)

	%NextTestPattern(3)							; SA-1: Read unmapped address (even)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM, None: BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM, None: return BW-RAM openbus ($AA)
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $AA, $AA)			;   SRAM, None: return BW-RAM openbus ($AA)
		%TestPattern(SA_1,Read,   $000801, $AA, $AA)			;   (repeat)

	%NextTestPattern(4)							; SA-1: Read unmapped address (odd)
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM, None: BW-RAM openbus = $AA
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM, None: BW-RAM openbus = $BB
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM, None: return BW-RAM openbus ($BB)
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   (repeat)
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   SRAM, None: return BW-RAM openbus ($BB)
		%TestPattern(SA_1,Read,   $000801, $BB, $BB)			;   (repeat)

	%NextTestPattern(5)							; SNES: Read mapped address
		%TestPattern(SNES,Write,  $7E0800, $AA, !__)			;   SRAM, None: SNES WRAM $7E0800 = $EE
		%TestPattern(SNES,Write,  $400000, $BB, !__)			;   SRAM, None: BW-RAM openbus = $BB
		%TestPattern(SNES,Read,   $000800, $AA, $AA)			;   SRAM, None: return SNES WRAM $7E0800 ($AA)
		%TestPattern(SNES,Read,   $000800, $AA, $AA)			;   (repeat)

	%NextTestPattern(6)							; SA-1: Update BW-RAM openbus
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   SRAM, None: BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM, None: return BW-RAM openbus ($AA)
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM      : return $400000 ($AA)
										;         None: return BW-RAM openbus ($AA)
		%TestPattern(SA_1,Write,  $400001, $BB, !__)			;   SRAM, None: BW-RAM openbus = $BB
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)			;   SRAM, None: return BW-RAM openbus ($BB)
		%TestPattern(SA_1,Read,   $400000, $AA, $BB)			;   SRAM      : return $400000 ($AA)
										;   SRAM      : BW-RAM openbus = $AA
										;         None: return BW-RAM openbus ($BB)
		%TestPattern(SA_1,Read,   $000800, $AA, $BB)			;   SRAM      : return BW-RAM openbus ($AA)
										;         None: return BW-RAM openbus ($BB)

	%NextTestPattern(7)							; SNES: Update BW-RAM openbus
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   SRAM, None: BW-RAM openbus = $AA
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM      : return $400000 ($AA)
										;         None: return BW-RAM openbus ($AA)
		%TestPattern(SNES,Write,  $400001, $BB, !__)			;   SRAM, None: BW-RAM openbus = $BB
		%TestPattern(SNES,Read,   $400000, $AA, $BB)			;   SRAM      : return $400000 ($AA)
										;         None: return BW-RAM openbus ($BB)
		%TestPattern(SNES,Read,   $400001, $BB, $BB)			;   SRAM      : return $400001 ($BB)
										;         None: return BW-RAM openbus ($BB)

	%NextTestPattern(8)							; No update BW-RAM openbus from SA-1
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)
		%TestPattern(SA_1,Write,  !TestIRamWriteTarget, $BB, !__)	;   I-RAM does not update BW-RAM openbus
		%TestPattern(SA_1,Write,  $008000, $CC, !__)			;   ROM does not update BW-RAM openbus
		%TestPattern(SA_1,Write,  $002232, $DD, !__)			;   I/O does not update BW-RAM openbus ($2232: SDAL)
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)

	%NextTestPattern(9)							; 
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SNES,Read,   $008000, $AA, $AA)
		%TestPattern(SNES,Write,  !TestIRamWriteTarget, $BB, !__)	;   BW-RAM openbus = $BB
		%TestPattern(SNES,Write,  $008000, $CC, !__)			;   ROM does not update BW-RAM openbus
		%TestPattern(SNES,Write,  $002232, $DD, !__)			;   I/O does not update BW-RAM openbus ($2232: SDAL)
		%TestPattern(SNES,Read,   $008000, $BB, $BB)

;--------------------------------------------------
