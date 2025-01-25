;--------------------------------------------------
; SA-1 BW-RAM openbus test patterns
;--------------------------------------------------

includeonce

;--------------------------------------------------

; %NextTestPattern(<testID>)
; %TestPattern(<cpu>, <access>, <address>, <expectSave>, <expectNone>)

	%NextTestPattern(1)
		%TestPattern(SA_1,Write,  $400000, $AA, $AA)
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)
		%TestPattern(SA_1,Read,   $400000, $AA, $AA)

	%NextTestPattern(2)
		%TestPattern(SNES,Write,  $400000, $AA, $AA)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)
		%TestPattern(SNES,Read,   $400000, $AA, $AA)

	%NextTestPattern(3)
		%TestPattern(SA_1,Write,  $400000, $AA, $AA)
		%TestPattern(SA_1,Read,   $008000, $AA, $AA)
		%TestPattern(SA_1,Read,   $008000, $AA, $AA)

	%NextTestPattern(4)
		%TestPattern(SNES,Write,  $400000, $AA, $AA)
		%TestPattern(SNES,Read,   $008000, $AA, $AA)
		%TestPattern(SNES,Read,   $008000, $AA, $AA)

	%NextTestPattern(5)
		%TestPattern(SA_1,Write,  $400000, $AA, $AA)
		%TestPattern(SA_1,Read,   $008000, $AA, $AA)
		%TestPattern(SA_1,Read,   $008000, $AA, $AA)

;--------------------------------------------------
