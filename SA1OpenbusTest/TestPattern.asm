;--------------------------------------------------
; SA-1 BW-RAM openbus test patterns
;--------------------------------------------------

includeonce

;--------------------------------------------------

; %NextTestPattern(<testID>)
; %TestPattern(<cpu>, <access>, <address>, <expectSave>, <expectNone>)

!__	= $00	; unused

	%NextTestPattern(1)							; Basic SA-1
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   SRAM: return $400000 ($AA)
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)			;   None: return BW-RAM openbus ($AA)

	%NextTestPattern(2)							; Basic SNES
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   SRAM: return $400000 ($AA)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)			;   None: return BW-RAM openbus ($AA)

	%NextTestPattern(3)							; Read unmapped SA-1
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   SRAM: return $400000 ($AA)
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)			;   None: return BW-RAM openbus ($AA)

	%NextTestPattern(4)							; Read unmapped SNES
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   SRAM: return SNES openbus (opr.B = $00)
		%TestPattern(SNES,Read,   $000800, $00, $00)			;   None: return SNES openbus (opr.B = $00)

	%NextTestPattern(5)							; Update BW-RAM openbus from SA-1
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)
		%TestPattern(SA_1,Write,  $400000, $BB, !__)			;   BW-RAM openbus = $BB
		%TestPattern(SA_1,Read,   $000800, $BB, $BB)

	%NextTestPattern(6)							; Update BW-RAM openbus from SNES
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SNES,Read,   $000800, $AA, $AA)
		%TestPattern(SNES,Write,  $400000, $BB, !__)			;   BW-RAM openbus = $BB
		%TestPattern(SNES,Read,   $000800, $BB, $BB)

	%NextTestPattern(7)							; No update BW-RAM openbus from SA-1
		%TestPattern(SA_1,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)
		%TestPattern(SA_1,Write,  !TestIRamWriteTarget, $BB, !__)	;   I-RAM does not update BW-RAM openbus
		%TestPattern(SA_1,Write,  $008000, $CC, !__)			;   ROM does not update BW-RAM openbus
		%TestPattern(SA_1,Write,  $002232, $DD, !__)			;   I/O does not update BW-RAM openbus ($2232: SDAL)
		%TestPattern(SA_1,Read,   $000800, $AA, $AA)

	%NextTestPattern(8)							; 
		%TestPattern(SNES,Write,  $400000, $AA, !__)			;   BW-RAM openbus = $AA
		%TestPattern(SNES,Read,   $008000, $AA, $AA)
		%TestPattern(SNES,Write,  !TestIRamWriteTarget, $BB, !__)	;   BW-RAM openbus = $BB
		%TestPattern(SNES,Write,  $008000, $CC, !__)			;   ROM does not update BW-RAM openbus
		%TestPattern(SNES,Write,  $002232, $DD, !__)			;   I/O does not update BW-RAM openbus ($2232: SDAL)
		%TestPattern(SNES,Read,   $008000, $BB, $BB)

;--------------------------------------------------
