;--------------------------------------------------
; SA-1 BW-RAM openbus test patterns
;--------------------------------------------------

includeonce

;--------------------------------------------------

; %NextTestPattern(<testID>)
; %TestPattern(<cpu>, <access>, <address>, <expectSave>, <expectNone>)

	%NextTestPattern(1)					; Basic SA-1
		%TestPattern(SA_1,Write,  $400000, $AA, $AA)	;   BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)	;   SRAM: return $400000 ($AA)
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)	;   None: return BW-RAM openbus ($AA)

	%NextTestPattern(2)					; Basic SNES
		%TestPattern(SNES,Write,  $400000, $AA, $AA)	;   BW-RAM openbus = $AA
		%TestPattern(SNES,Read,   $400000, $AA, $AA)	;   SRAM: return $400000 ($AA)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)	;   None: return BW-RAM openbus ($AA)

	%NextTestPattern(3)					; Read unmapped SA-1
		%TestPattern(SA_1,Write,  $400000, $AA, $AA)	;   BW-RAM openbus = $AA
		%TestPattern(SA_1,Read,   $008000, $AA, $AA)	;   SRAM: return $400000 ($AA)
		%TestPattern(SA_1,Read,   $008000, $AA, $AA)	;   None: return BW-RAM openbus ($AA)

	%NextTestPattern(4)					; Read unmapped SNES
		%TestPattern(SNES,Write,  $400000, $AA, $AA)	;   BW-RAM openbus = $AA
		%TestPattern(SNES,Read,   $008000, $00, $00)	;   SRAM: return SNES openbus (opr.B = $00)
		%TestPattern(SNES,Read,   $008000, $00, $00)	;   None: return SNES openbus (opr.B = $00)

	%NextTestPattern(5)
		%TestPattern(SA_1,Write,  $400000, $AA, $AA)
		%TestPattern(SA_1,Read,   $008000, $AA, $AA)
		%TestPattern(SA_1,Read,   $008000, $AA, $AA)

;--------------------------------------------------
