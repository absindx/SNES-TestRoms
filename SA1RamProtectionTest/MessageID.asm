;--------------------------------------------------
; Define SA-1 to SNES message ID
;--------------------------------------------------

includeonce

;--------------------------------------------------
; SNES -> SA-1 Status

!SNESStatus_Idle			= 0
!SNESStatus_TestRunning			= 1
!SNESStatus_TestFinished		= 2
!SNESStatus_BootFailed			= 15

;--------------------------------------------------
; SA-1 -> SNES Message

!Message_Boot_SPL			= 0	; Message byte: Initial SA-1 stack pointer low byte
!Message_Boot_SPH			= 1	; Message byte: Initial SA-1 stack pointer high byte
!Message_TestReady			= 2	; Message byte: TestID
!Message_TestSa1Expected		= 3	; Message byte: Test SA-1 expected value
!Message_TestSa1Actual			= 4	; Message byte: Test SA-1 actual value
!Message_TestSa1IRamExpected		= 5	; Message byte: Test SA-1 expected value
!Message_TestSa1IRamActual		= 6	; Message byte: Test SA-1 actual value
!Message_TestSa1BwRamExpectedE		= 7	; Message byte: Test SA-1 expected value (CBWE)
!Message_TestSa1BwRamExpectedA		= 8	; Message byte: Test SA-1 expected value (BWPA)
!Message_TestSa1BwRamActualE		= 9	; Message byte: Test SA-1 actual value (CBWE)
!Message_TestSa1BwRamActualA		= 10	; Message byte: Test SA-1 actual value (BWPA)
!Message_TestSnesExecute		= 11	; Message byte: Test SNES expected value
!Message_TestCheck			= 12	; Message byte: ---
;!Message_TestFail			= 13	; Message byte: ---
;!Message_TestUndefined			= 14	; Message byte: ---
!Message_TestFinished			= 15	; Message byte: ---

;--------------------------------------------------
; Test ID

; Boot						; TARGET  MEMORY  SNES/SA-1  ADDRESS	DESCRIPTION
!TestID_SNES_IRamProtection_Boot	= 1	;  SNES   I-RAM    $00/$00   $003000	Boot I-RAM protection (SNES)
!TestID_SNES_BwRamProtection_Boot	= 2	;  SNES   BW-RAM  $0FF/$0FF  $400000	Boot BW-RAM protection (SNES)
!TestID_SA1_Boot_SPL			= 3	;  SA-1   	 		 	Boot stack pointer
!TestID_SA1_Boot_SPH			= 4	;  SA-1   	 		 	Boot stack pointer
!TestID_SA1_IRamProtection_Boot		= 5	;  SA-1   I-RAM    $00/$00   $003000	Boot I-RAM protection (SA-1)
!TestID_SA1_BwRamProtection_Boot	= 6	;  SA-1   BW-RAM  $0FF/$0FF  $400000	Boot BW-RAM protection (SA-1)

; I-RAM Protection				; TARGET  MEMORY  SNES/SA-1  ADDRESS	DESCRIPTION
!TestID_SNES_IRamProtection_SNES	= 7	;  SNES   I-RAM    $00/$FF  		SNES only protection (SNES)
!TestID_SNES_IRamProtection_SA1		= 8	;  SA-1   I-RAM    $00/$FF  		SNES only protection (SA-1)
!TestID_SA1_IRamProtection_SNES		= 9	;  SNES   I-RAM    $FF/$00  		SA-1 only protection (SNES)
!TestID_SA1_IRamProtection_SA1		= 10	;  SA-1   I-RAM    $FF/$00  		SA-1 only protection (SA-1)
!TestID_SNES_IRamProtection_D0		= 11	;  SNES   I-RAM    $01/$FF   $003000	SIWP = %00000001
!TestID_SNES_IRamProtection_D1		= 12	;  SNES   I-RAM    $02/$FF   $003000	SIWP = %00000010
!TestID_SNES_IRamProtection_D2		= 13	;  SNES   I-RAM    $04/$FF   $003000	SIWP = %00000100
!TestID_SNES_IRamProtection_D3		= 14	;  SNES   I-RAM    $08/$FF   $003000	SIWP = %00001000
!TestID_SNES_IRamProtection_D4		= 15	;  SNES   I-RAM    $10/$FF   $003000	SIWP = %00010000
!TestID_SNES_IRamProtection_D5		= 16	;  SNES   I-RAM    $20/$FF   $003000	SIWP = %00100000
!TestID_SNES_IRamProtection_D6		= 17	;  SNES   I-RAM    $40/$FF   $003000	SIWP = %01000000
!TestID_SNES_IRamProtection_D7		= 18	;  SNES   I-RAM    $80/$FF   $003000	SIWP = %10000000
!TestID_SNES_IRamProtection_DMulti	= 19	;  SNES   I-RAM    $35/$FF   $003000	SIWP = %00110101
!TestID_SA1_IRamProtection_D0		= 20	;  SA-1   I-RAM    $FF/$01   $003000	CIWP = %00000001
!TestID_SA1_IRamProtection_D1		= 21	;  SA-1   I-RAM    $FF/$02   $003000	CIWP = %00000010
!TestID_SA1_IRamProtection_D2		= 22	;  SA-1   I-RAM    $FF/$04   $003000	CIWP = %00000100
!TestID_SA1_IRamProtection_D3		= 23	;  SA-1   I-RAM    $FF/$08   $003000	CIWP = %00001000
!TestID_SA1_IRamProtection_D4		= 24	;  SA-1   I-RAM    $FF/$10   $003000	CIWP = %00010000
!TestID_SA1_IRamProtection_D5		= 25	;  SA-1   I-RAM    $FF/$20   $003000	CIWP = %00100000
!TestID_SA1_IRamProtection_D6		= 26	;  SA-1   I-RAM    $FF/$40   $003000	CIWP = %01000000
!TestID_SA1_IRamProtection_D7		= 27	;  SA-1   I-RAM    $FF/$80   $003000	CIWP = %10000000
!TestID_SA1_IRamProtection_DMulti	= 28	;  SA-1   I-RAM    $FF/$CA   $003000	CIWP = %11001010

; BW-RAM Protection				; TARGET  MEMORY  SNES/SA-1  ADDRESS	DESCRIPTION
!TestID_SNES_BwRamProtection_SNES	= 29	;  SNES   BW-RAM  $0FF/$800  $400000	SNES only protection (SNES)
!TestID_SNES_BwRamProtection_SNES	= 30	;  SA-1   BW-RAM  $0FF/$800  $400000	SNES only protection (SA-1)
!TestID_SA1_BwRamProtection_SNES	= 31	;  SNES   BW-RAM  $800/$0FF  $400000	SA-1 only protection (SNES)
!TestID_SA1_BwRamProtection_SA1		= 32	;  SA-1   BW-RAM  $800/$0FF  $400000	SA-1 only protection (SA-1)
!TestID_SNES_BwRamProtection_W00	= 33	;  SNES   BW-RAM  $000/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF)
!TestID_SNES_BwRamProtection_W01	= 34	;  SNES   BW-RAM  $001/$800  $400000	SWEN = 0, BWPA = $01 ($400000-$4001FF)
!TestID_SNES_BwRamProtection_W02	= 35	;  SNES   BW-RAM  $002/$800  $400000	SWEN = 0, BWPA = $02 ($400000-$4003FF)
!TestID_SNES_BwRamProtection_W03	= 36	;  SNES   BW-RAM  $003/$800  $400000	SWEN = 0, BWPA = $03 ($400000-$4007FF)
!TestID_SNES_BwRamProtection_W04	= 37	;  SNES   BW-RAM  $004/$800  $400000	SWEN = 0, BWPA = $04 ($400000-$400FFF)
!TestID_SNES_BwRamProtection_W05	= 38	;  SNES   BW-RAM  $005/$800  $400000	SWEN = 0, BWPA = $05 ($400000-$401FFF)
!TestID_SNES_BwRamProtection_W06	= 39	;  SNES   BW-RAM  $006/$800  $400000	SWEN = 0, BWPA = $06 ($400000-$403FFF)
!TestID_SNES_BwRamProtection_W07	= 40	;  SNES   BW-RAM  $007/$800  $400000	SWEN = 0, BWPA = $07 ($400000-$407FFF)
!TestID_SNES_BwRamProtection_W08	= 41	;  SNES   BW-RAM  $008/$800  $400000	SWEN = 0, BWPA = $08 ($400000-$40FFFF)
!TestID_SNES_BwRamProtection_W09	= 42	;  SNES   BW-RAM  $009/$800  $400000	SWEN = 0, BWPA = $09 ($400000-$41FFFF)
!TestID_SNES_BwRamProtection_W0A	= 43	;  SNES   BW-RAM  $00A/$800  $400000	SWEN = 0, BWPA = $0A ($400000-$43FFFF)
!TestID_SNES_BwRamProtection_W0B	= 44	;  SNES   BW-RAM  $00B/$800  $400000	SWEN = 0, BWPA = $0B ($400000-$47FFFF) * undocumented
!TestID_SNES_BwRamProtection_W0C	= 45	;  SNES   BW-RAM  $00C/$800  $400000	SWEN = 0, BWPA = $0C ($400000-$4FFFFF) * undocumented
!TestID_SNES_BwRamProtection_W0D	= 46	;  SNES   BW-RAM  $00D/$800  $400000	SWEN = 0, BWPA = $0D ($400000-$5FFFFF) * undocumented
!TestID_SNES_BwRamProtection_W0E	= 47	;  SNES   BW-RAM  $00E/$800  $400000	SWEN = 0, BWPA = $0E ($400000-$7DFFFF) * undocumented
!TestID_SNES_BwRamProtection_W0F	= 48	;  SNES   BW-RAM  $00F/$800  $400000	SWEN = 0, BWPA = $0F ($400000-$FFFFFF) * undocumented
!TestID_SNES_BwRamProtection_W10	= 49	;  SNES   BW-RAM  $010/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SNES_BwRamProtection_W11	= 50	;  SNES   BW-RAM  $011/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SNES_BwRamProtection_W20	= 51	;  SNES   BW-RAM  $020/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SNES_BwRamProtection_W21	= 52	;  SNES   BW-RAM  $021/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SNES_BwRamProtection_W30	= 53	;  SNES   BW-RAM  $030/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SNES_BwRamProtection_W31	= 54	;  SNES   BW-RAM  $031/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SNES_BwRamProtection_W40	= 55	;  SNES   BW-RAM  $040/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SNES_BwRamProtection_W41	= 56	;  SNES   BW-RAM  $041/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SNES_BwRamProtection_W80	= 57	;  SNES   BW-RAM  $080/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SNES_BwRamProtection_W81	= 58	;  SNES   BW-RAM  $081/$800  $400000	SWEN = 0, BWPA = $00 ($400000-$4000FF) * undocumented
!TestID_SA1_BwRamProtection_SWCW00	= 59	;  SA-1   BW-RAM  $800/$000  $400000	SWEN = 1/0, BWPA = $00 ($400000-$4000FF) ; NOTE: BWPA is SNES CPU only
!TestID_SA1_BwRamProtection_SWCW01	= 60	;  SA-1   BW-RAM  $800/$001  $400000	SWEN = 1/0, BWPA = $01 ($400000-$4001FF)
!TestID_SA1_BwRamProtection_SPCW00	= 61	;  SA-1   BW-RAM  $000/$000  $400000	SWEN = 0/0, BWPA = $00 ($400000-$4000FF)
!TestID_SA1_BwRamProtection_SPCW01	= 62	;  SA-1   BW-RAM  $000/$001  $400000	SWEN = 0/0, BWPA = $01 ($400000-$4001FF)

; I-RAM Mirroring				; TARGET  MEMORY  SNES/SA-1  ADDRESS	DESCRIPTION
!TestID_SA1_IRamMirror_000000		= 63	;  SA-1   I-RAM    $FF/$FF   $000000	ADDR -> (SNES) $00-3F,$80-BF:3000 / (SA-1) $00-3F,$80-BF:0000,3000
!TestID_SA1_IRamMirror_003000		= 64	;  SA-1   I-RAM    $FF/$FF   $003000	ADDR -> (SNES) $00-3F,$80-BF:3000 / (SA-1) $00-3F,$80-BF:0000,3000
!TestID_SA1_IRamMirror_800000		= 65	;  SA-1   I-RAM    $FF/$FF   $800000	ADDR -> (SNES) $00-3F,$80-BF:3000 / (SA-1) $00-3F,$80-BF:0000,3000
!TestID_SA1_IRamMirror_803000		= 66	;  SA-1   I-RAM    $FF/$FF   $803000	ADDR -> (SNES) $00-3F,$80-BF:3000 / (SA-1) $00-3F,$80-BF:0000,3000
!TestID_SNES_IRamMirror_003000		= 67	;  SNES   I-RAM    $FF/$FF   $003000	ADDR ->                             (SA-1) $00-3F,$80-BF:0000,3000

; I-RAM Mirroring Protection			; TARGET  MEMORY  SNES/SA-1  ADDRESS	DESCRIPTION
!TestID_SA1_IRamProtectMirror_003000	= 68	;  SA-1   I-RAM    $00/$FF   $003000	$000000 -> ADDR
!TestID_SA1_IRamProtectMirror_800000	= 69	;  SA-1   I-RAM    $00/$FF   $800000	$000000 -> ADDR
!TestID_SA1_IRamProtectMirror_803000	= 70	;  SA-1   I-RAM    $00/$FF   $803000	$000000 -> ADDR

; BW-RAM Mirroring				; TARGET  MEMORY  SNES/SA-1  ADDRESS	DESCRIPTION
; $400000 -> $C00000

; I-RAM Mirroring Protection			; TARGET  MEMORY  SNES/SA-1  ADDRESS	DESCRIPTION
; $400000 -> $C00000, $006000, $806000
; $006000 (protected section)
; $400000 $FF -> $C00000, $806000		; if not $C0's protection mirrored (protect = $400000 + ($100 * (2 ^ BWPA) - 1))


; SA-1 STP					; TARGET  MEMORY  SNES/SA-1  ADDRESS	DESCRIPTION
						;  SNES   I-RAM    $00/$??   $003000	change protection at SA-1 STP (set SA-1 protection before STP)
						;  SNES   I-RAM    $55/$??   $003000	change protection at SA-1 STP
						;  SNES   BW-RAM  $800/$???  $400000	change protection at SA-1 STP
						;  SNES   BW-RAM  $002/$???  $400000	change protection at SA-1 STP

; SA-1 STP -> Reboot				; TARGET  MEMORY  SNES/SA-1  ADDRESS	DESCRIPTION
!TestID_SNES_IRamProtection_Reboot	= 1	;  SNES   I-RAM    $55/$33   $003000	(set protection at before reboot) Reboot protection (SNES)
!TestID_SNES_BwRamProtection_Reboot	= 1	;  SNES   BW-RAM  $002/$800  $400000	(set protection at before reboot) Reboot protection (SNES)
!TestID_SA1_Reboot_SPL			= 1	;  SA-1   	 	 		(set SP at before reboot)         Reboot stack pointer
!TestID_SA1_Reboot_SPH			= 1	;  SA-1   	 	 		(set SP at before reboot)         Reboot stack pointer
!TestID_SA1_IRamProtection_Reboot	= 1	;  SA-1   I-RAM    $55/$33   $003000	(set protection at before reboot) Reboot protection (SA-1)
!TestID_SA1_BwRamProtection_Reboot	= 1	;  SA-1   BW-RAM  $002/$800  $400000	(set protection at before reboot) Reboot protection (SA-1)

;--------------------------------------------------

!StopSP_SNES				= $01FF
!StopSP_SA1				= $01FF

;--------------------------------------------------
