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

; Boot						; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_IRamProtection_Boot	= 1	;  SNES   I-RAM     $00/$00    $003000	Boot I-RAM protection (SNES)
!TestID_SNES_BwRamProtection_Boot	= 2	;  SNES   BW-RAM  $00FF/$00FF  $400000	Boot BW-RAM protection (SNES)
!TestID_SA1_Boot_SPL			= 3	;  SA-1                               	Boot stack pointer
!TestID_SA1_Boot_SPH			= 4	;  SA-1                               	Boot stack pointer
!TestID_SA1_IRamProtection_Boot		= 5	;  SA-1   I-RAM     $00/$00    $003000	Boot I-RAM protection (SA-1)
!TestID_SA1_BwRamProtection_Boot	= 6	;  SA-1   BW-RAM  $00FF/$00FF  $400000	Boot BW-RAM protection (SA-1)

; I-RAM Protection				; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_IRamProtection_Unprotect	= 7	;  SNES   I-RAM     $FF/$FF    $003000	Unprotect both (SNES)
!TestID_SA1_IRamProtection_Unprotect	= 8	;  SA-1   I-RAM     $FF/$FF    $003000	Unprotect both (SA-1)
!TestID_SNES_IRamProtection_SNES	= 9	;  SNES   I-RAM     $00/$FF    $003000	SNES only protection (SNES)
!TestID_SA1_IRamProtection_SNES		= 10	;  SA-1   I-RAM     $00/$FF    $003000	SNES only protection (SA-1)
!TestID_SNES_IRamProtection_SA1		= 11	;  SNES   I-RAM     $FF/$00    $003000	SA-1 only protection (SNES)
!TestID_SA1_IRamProtection_SA1		= 12	;  SA-1   I-RAM     $FF/$00    $003000	SA-1 only protection (SA-1)
!TestID_SNES_IRamProtection_Protect	= 13	;  SNES   I-RAM     $00/$00    $003000	Both protection (SNES)
!TestID_SA1_IRamProtection_Protect	= 14	;  SA-1   I-RAM     $00/$00    $003000	Both protection (SA-1)
!TestID_SNES_IRamProtection_D0		= 15	;  SNES   I-RAM     $01/$FF    $003000	SIWP = %00000001
!TestID_SNES_IRamProtection_D1		= 16	;  SNES   I-RAM     $02/$FF    $003000	SIWP = %00000010
!TestID_SNES_IRamProtection_D2		= 17	;  SNES   I-RAM     $04/$FF    $003000	SIWP = %00000100
!TestID_SNES_IRamProtection_D3		= 18	;  SNES   I-RAM     $08/$FF    $003000	SIWP = %00001000
!TestID_SNES_IRamProtection_D4		= 19	;  SNES   I-RAM     $10/$FF    $003000	SIWP = %00010000
!TestID_SNES_IRamProtection_D5		= 20	;  SNES   I-RAM     $20/$FF    $003000	SIWP = %00100000
!TestID_SNES_IRamProtection_D6		= 21	;  SNES   I-RAM     $40/$FF    $003000	SIWP = %01000000
!TestID_SNES_IRamProtection_D7		= 22	;  SNES   I-RAM     $80/$FF    $003000	SIWP = %10000000
!TestID_SNES_IRamProtection_DMulti	= 23	;  SNES   I-RAM     $35/$FF    $003000	SIWP = %00110101
!TestID_SA1_IRamProtection_D0		= 24	;  SA-1   I-RAM     $FF/$01    $003000	CIWP = %00000001
!TestID_SA1_IRamProtection_D1		= 25	;  SA-1   I-RAM     $FF/$02    $003000	CIWP = %00000010
!TestID_SA1_IRamProtection_D2		= 26	;  SA-1   I-RAM     $FF/$04    $003000	CIWP = %00000100
!TestID_SA1_IRamProtection_D3		= 27	;  SA-1   I-RAM     $FF/$08    $003000	CIWP = %00001000
!TestID_SA1_IRamProtection_D4		= 28	;  SA-1   I-RAM     $FF/$10    $003000	CIWP = %00010000
!TestID_SA1_IRamProtection_D5		= 29	;  SA-1   I-RAM     $FF/$20    $003000	CIWP = %00100000
!TestID_SA1_IRamProtection_D6		= 30	;  SA-1   I-RAM     $FF/$40    $003000	CIWP = %01000000
!TestID_SA1_IRamProtection_D7		= 31	;  SA-1   I-RAM     $FF/$80    $003000	CIWP = %10000000
!TestID_SA1_IRamProtection_DMulti	= 32	;  SA-1   I-RAM     $FF/$CA    $003000	CIWP = %11001010

; BW-RAM Protection				; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_BwRamProtection_Unprotect	= 33	;  SNES   BW-RAM  $8000/$80--  $400000	Unprotect both (SNES)
!TestID_SA1_BwRamProtection_Unprotect	= 34	;  SA-1   BW-RAM  $8000/$80--  $400000	Unprotect both (SA-1)
!TestID_SNES_BwRamProtection_SNES	= 35	;  SNES   BW-RAM  $00FF/$80--  $400000	SNES only protection (SNES) * Expect write valid. If one side is write-enabled, the other can also be written to.
!TestID_SA1_BwRamProtection_SNES	= 36	;  SA-1   BW-RAM  $00FF/$80--  $400000	SNES only protection (SA-1)
!TestID_SNES_BwRamProtection_SA1	= 37	;  SNES   BW-RAM  $8000/$00--  $400000	SA-1 only protection (SNES)
!TestID_SA1_BwRamProtection_SA1		= 38	;  SA-1   BW-RAM  $8000/$00--  $400000	SA-1 only protection (SA-1) * Expect write valid. If one side is write-enabled, the other can also be written to.
!TestID_SNES_BwRamProtection_Protect	= 39	;  SNES   BW-RAM  $00FF/$00--  $400000	Both protection (SNES)
!TestID_SA1_BwRamProtection_Protect	= 40	;  SA-1   BW-RAM  $00FF/$00--  $400000	Both protection (SA-1)
!TestID_SNES_BwRamProtection_D00	= 41	;  SNES   BW-RAM  $0000/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $00 ($400000-$4000FF)
!TestID_SNES_BwRamProtection_D01	= 42	;  SNES   BW-RAM  $0001/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $01 ($400000-$4001FF)
!TestID_SNES_BwRamProtection_D02	= 43	;  SNES   BW-RAM  $0002/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $02 ($400000-$4003FF)
!TestID_SNES_BwRamProtection_D03	= 44	;  SNES   BW-RAM  $0003/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $03 ($400000-$4007FF)
!TestID_SNES_BwRamProtection_D04	= 45	;  SNES   BW-RAM  $0004/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $04 ($400000-$400FFF)
!TestID_SNES_BwRamProtection_D05	= 46	;  SNES   BW-RAM  $0005/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $05 ($400000-$401FFF)
!TestID_SNES_BwRamProtection_D06	= 47	;  SNES   BW-RAM  $0006/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $06 ($400000-$403FFF)
!TestID_SNES_BwRamProtection_D07	= 48	;  SNES   BW-RAM  $0007/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $07 ($400000-$407FFF)
!TestID_SNES_BwRamProtection_D08	= 49	;  SNES   BW-RAM  $0008/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $08 ($400000-$40FFFF)
!TestID_SNES_BwRamProtection_D09	= 50	;  SNES   BW-RAM  $0009/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $09 ($400000-$41FFFF)
!TestID_SNES_BwRamProtection_D0A	= 51	;  SNES   BW-RAM  $000A/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0A ($400000-$43FFFF) * The test routine checks whether the address beyond the area is valid for writing, so it is reported as $0F.
!TestID_SNES_BwRamProtection_D0B	= 52	;  SNES   BW-RAM  $000B/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0B ($400000-$47FFFF) * Undocumented
!TestID_SNES_BwRamProtection_D0C	= 53	;  SNES   BW-RAM  $000C/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0C ($400000-$4FFFFF) * Undocumented
!TestID_SNES_BwRamProtection_D0D	= 54	;  SNES   BW-RAM  $000D/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0D ($400000-$5FFFFF) * Undocumented
!TestID_SNES_BwRamProtection_D0E	= 55	;  SNES   BW-RAM  $000E/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0E ($400000-$7FFFFF) * Undocumented $7E0000=WRAM
!TestID_SNES_BwRamProtection_D0F	= 56	;  SNES   BW-RAM  $000F/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0F ($400000-$FFFFFF) * Undocumented
!TestID_SNES_BwRamProtection_D10	= 57	;  SNES   BW-RAM  $0010/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $10 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_D11	= 58	;  SNES   BW-RAM  $0011/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $11 ($400000-$4001FF) * Undocumented
!TestID_SNES_BwRamProtection_D20	= 59	;  SNES   BW-RAM  $0020/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $20 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_D21	= 60	;  SNES   BW-RAM  $0021/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $21 ($400000-$4001FF) * Undocumented
!TestID_SNES_BwRamProtection_D30	= 61	;  SNES   BW-RAM  $0030/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $30 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_D31	= 62	;  SNES   BW-RAM  $0031/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $31 ($400000-$4001FF) * Undocumented
!TestID_SNES_BwRamProtection_D40	= 63	;  SNES   BW-RAM  $0040/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $40 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_D41	= 64	;  SNES   BW-RAM  $0041/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $41 ($400000-$4001FF) * Undocumented
!TestID_SNES_BwRamProtection_D80	= 65	;  SNES   BW-RAM  $0080/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $80 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_D81	= 66	;  SNES   BW-RAM  $0081/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $81 ($400000-$4001FF) * Undocumented
!TestID_SNES_BwRamProtection_E00	= 67	;  SNES   BW-RAM  $8000/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $00 ($400000-$4000FF)
!TestID_SNES_BwRamProtection_E01	= 68	;  SNES   BW-RAM  $8001/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $01 ($400000-$4001FF)
!TestID_SNES_BwRamProtection_E02	= 69	;  SNES   BW-RAM  $8002/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $02 ($400000-$4003FF)
!TestID_SNES_BwRamProtection_E03	= 70	;  SNES   BW-RAM  $8003/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $03 ($400000-$4007FF)
!TestID_SNES_BwRamProtection_E04	= 71	;  SNES   BW-RAM  $8004/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $04 ($400000-$400FFF)
!TestID_SNES_BwRamProtection_E05	= 72	;  SNES   BW-RAM  $8005/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $05 ($400000-$401FFF)
!TestID_SNES_BwRamProtection_E06	= 73	;  SNES   BW-RAM  $8006/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $06 ($400000-$403FFF)
!TestID_SNES_BwRamProtection_E07	= 74	;  SNES   BW-RAM  $8007/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $07 ($400000-$407FFF)
!TestID_SNES_BwRamProtection_E08	= 75	;  SNES   BW-RAM  $8008/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $08 ($400000-$40FFFF)
!TestID_SNES_BwRamProtection_E09	= 76	;  SNES   BW-RAM  $8009/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $09 ($400000-$41FFFF)
!TestID_SNES_BwRamProtection_E0A	= 77	;  SNES   BW-RAM  $800A/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0A ($400000-$43FFFF)
!TestID_SNES_BwRamProtection_E0B	= 78	;  SNES   BW-RAM  $800B/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0B ($400000-$47FFFF) * Undocumented
!TestID_SNES_BwRamProtection_E0C	= 79	;  SNES   BW-RAM  $800C/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0C ($400000-$4FFFFF) * Undocumented
!TestID_SNES_BwRamProtection_E0D	= 80	;  SNES   BW-RAM  $800D/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0D ($400000-$5FFFFF) * Undocumented
!TestID_SNES_BwRamProtection_E0E	= 81	;  SNES   BW-RAM  $800E/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0E ($400000-$7FFFFF) * Undocumented $7E0000=WRAM
!TestID_SNES_BwRamProtection_E0F	= 82	;  SNES   BW-RAM  $800F/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0F ($400000-$FFFFFF) * Undocumented
!TestID_SNES_BwRamProtection_E10	= 83	;  SNES   BW-RAM  $8010/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $10 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_E11	= 84	;  SNES   BW-RAM  $8011/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $11 ($400000-$4001FF) * Undocumented
!TestID_SNES_BwRamProtection_E20	= 85	;  SNES   BW-RAM  $8020/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $20 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_E21	= 86	;  SNES   BW-RAM  $8021/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $21 ($400000-$4001FF) * Undocumented
!TestID_SNES_BwRamProtection_E30	= 87	;  SNES   BW-RAM  $8030/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $30 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_E31	= 88	;  SNES   BW-RAM  $8031/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $31 ($400000-$4001FF) * Undocumented
!TestID_SNES_BwRamProtection_E40	= 89	;  SNES   BW-RAM  $8040/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $40 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_E41	= 90	;  SNES   BW-RAM  $8041/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $41 ($400000-$4001FF) * Undocumented
!TestID_SNES_BwRamProtection_E80	= 91	;  SNES   BW-RAM  $8080/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $80 ($400000-$4000FF) * Undocumented
!TestID_SNES_BwRamProtection_E81	= 92	;  SNES   BW-RAM  $8081/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $81 ($400000-$4001FF) * Undocumented
!TestID_SA1_BwRamProtection_D00		= 93	;  SA-1   BW-RAM  $8000/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $00 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D01		= 94	;  SA-1   BW-RAM  $8001/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $01 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D02		= 95	;  SA-1   BW-RAM  $8002/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $02 ($400000-$4003FF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D03		= 96	;  SA-1   BW-RAM  $8003/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $03 ($400000-$4007FF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D04		= 97	;  SA-1   BW-RAM  $8004/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $04 ($400000-$400FFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D05		= 98	;  SA-1   BW-RAM  $8005/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $05 ($400000-$401FFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D06		= 99	;  SA-1   BW-RAM  $8006/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $06 ($400000-$403FFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D07		= 100	;  SA-1   BW-RAM  $8007/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $07 ($400000-$407FFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D08		= 101	;  SA-1   BW-RAM  $8008/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $08 ($400000-$40FFFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D09		= 102	;  SA-1   BW-RAM  $8009/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $09 ($400000-$41FFFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_D0A		= 103	;  SA-1   BW-RAM  $800A/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0A ($400000-$43FFFF) * BWPA is SNES CPU only, but it also affects SA-1. The test routine checks whether the address beyond the area is valid for writing, so it is reported as $0F.
!TestID_SA1_BwRamProtection_D0B		= 104	;  SA-1   BW-RAM  $800B/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0B ($400000-$47FFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D0C		= 105	;  SA-1   BW-RAM  $800C/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0C ($400000-$4FFFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D0D		= 106	;  SA-1   BW-RAM  $800D/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0D ($400000-$5FFFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D0E		= 107	;  SA-1   BW-RAM  $800E/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0E ($400000-$7FFFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented $7E0000=WRAM
!TestID_SA1_BwRamProtection_D0F		= 108	;  SA-1   BW-RAM  $800F/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $0F ($400000-$FFFFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D10		= 109	;  SA-1   BW-RAM  $8010/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $10 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D11		= 110	;  SA-1   BW-RAM  $8011/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $11 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D20		= 111	;  SA-1   BW-RAM  $8020/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $20 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D21		= 112	;  SA-1   BW-RAM  $8021/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $21 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D30		= 113	;  SA-1   BW-RAM  $8030/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $30 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D31		= 114	;  SA-1   BW-RAM  $8031/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $31 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D40		= 115	;  SA-1   BW-RAM  $8040/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $40 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D41		= 116	;  SA-1   BW-RAM  $8041/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $41 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D80		= 117	;  SA-1   BW-RAM  $8080/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $80 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_D81		= 118	;  SA-1   BW-RAM  $8081/$00--  $400000	SWEN = 0, CWEN = 0, BWPA = $81 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E00		= 119	;  SA-1   BW-RAM  $8000/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $00 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E01		= 120	;  SA-1   BW-RAM  $8001/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $01 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E02		= 121	;  SA-1   BW-RAM  $8002/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $02 ($400000-$4003FF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E03		= 122	;  SA-1   BW-RAM  $8003/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $03 ($400000-$4007FF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E04		= 123	;  SA-1   BW-RAM  $8004/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $04 ($400000-$400FFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E05		= 124	;  SA-1   BW-RAM  $8005/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $05 ($400000-$401FFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E06		= 125	;  SA-1   BW-RAM  $8006/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $06 ($400000-$403FFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E07		= 126	;  SA-1   BW-RAM  $8007/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $07 ($400000-$407FFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E08		= 127	;  SA-1   BW-RAM  $8008/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $08 ($400000-$40FFFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E09		= 128	;  SA-1   BW-RAM  $8009/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $09 ($400000-$41FFFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E0A		= 129	;  SA-1   BW-RAM  $800A/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0A ($400000-$43FFFF) * BWPA is SNES CPU only, but it also affects SA-1.
!TestID_SA1_BwRamProtection_E0B		= 130	;  SA-1   BW-RAM  $800B/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0B ($400000-$47FFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E0C		= 131	;  SA-1   BW-RAM  $800C/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0C ($400000-$4FFFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E0D		= 132	;  SA-1   BW-RAM  $800D/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0D ($400000-$5FFFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E0E		= 133	;  SA-1   BW-RAM  $800E/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0E ($400000-$7FFFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented $7E0000=WRAM
!TestID_SA1_BwRamProtection_E0F		= 134	;  SA-1   BW-RAM  $800F/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $0F ($400000-$FFFFFF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E10		= 135	;  SA-1   BW-RAM  $8010/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $10 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E11		= 136	;  SA-1   BW-RAM  $8011/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $11 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E20		= 137	;  SA-1   BW-RAM  $8020/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $20 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E21		= 138	;  SA-1   BW-RAM  $8021/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $21 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E30		= 139	;  SA-1   BW-RAM  $8030/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $30 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E31		= 140	;  SA-1   BW-RAM  $8031/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $31 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E40		= 141	;  SA-1   BW-RAM  $8040/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $40 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E41		= 142	;  SA-1   BW-RAM  $8041/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $41 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E80		= 143	;  SA-1   BW-RAM  $8080/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $80 ($400000-$4000FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented
!TestID_SA1_BwRamProtection_E81		= 144	;  SA-1   BW-RAM  $8081/$80--  $400000	SWEN = 1, CWEN = 1, BWPA = $81 ($400000-$4001FF) * BWPA is SNES CPU only, but it also affects SA-1. Undocumented

; I-RAM Mirroring				; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_IRamMirror_003000		= 145	;  SNES   I-RAM     $FF/$FF    $003000	ADDR -> (SNES)                  $80-BF:3000-37FF / (SA-1) $00-3F:0000-07FF,$00-3F:3000-37FF,$80-BF:0000-07FF,$80-BF:3000-37FF	; see !IRamMirror_Area_<addr>
!TestID_SNES_IRamMirror_803000		= 146	;  SNES   I-RAM     $FF/$FF    $003000	ADDR -> (SNES) $00-3F:3000-37FF                  / (SA-1) $00-3F:0000-07FF,$00-3F:3000-37FF,$80-BF:0000-07FF,$80-BF:3000-37FF
!TestID_SA1_IRamMirror_000000		= 147	;  SA-1   I-RAM     $FF/$FF    $000000	ADDR -> (SNES) $00-3F:3000-37FF,$80-BF:3000-37FF / (SA-1)                  $00-3F:3000-37FF,$80-BF:0000-07FF,$80-BF:3000-37FF
!TestID_SA1_IRamMirror_003000		= 148	;  SA-1   I-RAM     $FF/$FF    $003000	ADDR -> (SNES) $00-3F:3000-37FF,$80-BF:3000-37FF / (SA-1) $00-3F:0000-07FF,                 $80-BF:0000-07FF,$80-BF:3000-37FF
!TestID_SA1_IRamMirror_800000		= 149	;  SA-1   I-RAM     $FF/$FF    $800000	ADDR -> (SNES) $00-3F:3000-37FF,$80-BF:3000-37FF / (SA-1) $00-3F:0000-07FF,$00-3F:3000-37FF,                 $80-BF:3000-37FF
!TestID_SA1_IRamMirror_803000		= 150	;  SA-1   I-RAM     $FF/$FF    $803000	ADDR -> (SNES) $00-3F:3000-37FF,$80-BF:3000-37FF / (SA-1) $00-3F:0000-07FF,$00-3F:3000-37FF,$80-BF:0000-07FF

; I-RAM Mirroring Protection			; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_IRamProtectMirror_803000	= 151	;  SNES   I-RAM     $3F/$00    $803000	(SNES) ADDR -> $003000
!TestID_SA1_IRamProtectMirror_000000	= 152	;  SA-1   I-RAM     $00/$03    $000000	(SA-1) ADDR -> $003000
!TestID_SA1_IRamProtectMirror_800000	= 153	;  SA-1   I-RAM     $00/$07    $800000	(SA-1) ADDR -> $003000
!TestID_SA1_IRamProtectMirror_803000	= 154	;  SA-1   I-RAM     $00/$1F    $803000	(SA-1) ADDR -> $003000

; BW-RAM Mirroring				; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_BwRamMirror_400000		= 155	;  SNES   BW-RAM  $8000/$80--  $400000	(SNES) ADDR -> (SNES) $00-3F:6000,$80-BF:6000              / (SA-1) $00-3F:6000,$80-BF:6000, $40-5F:0000			; see !BwRamMirror_Area_<addr>
!TestID_SNES_BwRamMirror_500000		= 156	;  SNES   BW-RAM  $8000/$80--  $500000	(SNES) ADDR -> (SNES) $00-3F:6000,$80-BF:6000              / (SA-1) $00-3F:6000,$80-BF:6000, $40-5F:0000
!TestID_SNES_BwRamMirror_006000		= 157	;  SNES   BW-RAM  $8000/$80--  $006000	(SNES) ADDR -> (SNES)             $80-BF:6000, $40-5F:0000 / (SA-1) $00-3F:6000,$80-BF:6000, $40-5F:0000
!TestID_SNES_BwRamMirror_806000		= 158	;  SNES   BW-RAM  $8000/$80--  $806000	(SNES) ADDR -> (SNES) $00-3F:6000              $40-5F:0000 / (SA-1) $00-3F:6000,$80-BF:6000, $40-5F:0000
!TestID_SA1_BwRamMirror_400000		= 159	;  SA-1   BW-RAM  $8000/$80--  $400000	(SA-1) ADDR -> (SNES) $00-3F:6000,$80-BF:6000, $40-5F:0000 / (SA-1) $00-3F:6000,$80-BF:6000
!TestID_SA1_BwRamMirror_500000		= 160	;  SA-1   BW-RAM  $8000/$80--  $500000	(SA-1) ADDR -> (SNES) $00-3F:6000,$80-BF:6000, $40-5F:0000 / (SA-1) $00-3F:6000,$80-BF:6000
!TestID_SA1_BwRamMirror_006000		= 161	;  SA-1   BW-RAM  $8000/$80--  $006000	(SA-1) ADDR -> (SNES) $00-3F:6000,$80-BF:6000, $40-5F:0000 / (SA-1)             $80-BF:6000, $40-5F:0000
!TestID_SA1_BwRamMirror_806000		= 162	;  SA-1   BW-RAM  $8000/$80--  $806000	(SA-1) ADDR -> (SNES) $00-3F:6000,$80-BF:6000, $40-5F:0000 / (SA-1) $00-3F:6000,             $40-5F:0000

; BW-RAM Mirroring Protection			; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_BwRamProtectMirror_006000	= 163	;  SNES   BW-RAM  $0001/$00--  $006000	(SNES) protect $00-3F:6000-60FF, unprotect $00-3F:6100-7FFF
!TestID_SNES_BwRamProtectMirror_806000	= 164	;  SNES   BW-RAM  $0001/$00--  $806000	(SNES) protect $80-BF:6000-60FF, unprotect $80-BF:6100-7FFF
!TestID_SA1_BwRamProtectMirror_006000	= 165	;  SA-1   BW-RAM  $0001/$00--  $006000	(SA-1) protect $00-3F:6000-60FF, unprotect $00-3F:6100-7FFF
!TestID_SA1_BwRamProtectMirror_806000	= 166	;  SA-1   BW-RAM  $0001/$00--  $806000	(SA-1) protect $80-BF:6000-60FF, unprotect $80-BF:6100-7FFF

!TestID_SNES_BwRamProtectMapping_Enable	= 167	;  SNES   BW-RAM  $8000/$80--  $006000	BMAPS = $00, ADDR -> $400000
!TestID_SNES_BwRamProtectMapping_M00P	= 168	;  SNES   BW-RAM  $0000/$00--  $006000	BMAPS = $00, ADDR -> $400000 * protected
!TestID_SNES_BwRamProtectMapping_M00E	= 169	;  SNES   BW-RAM  $0000/$00--  $006100	BMAPS = $00, ADDR -> $400100
!TestID_SNES_BwRamProtectMapping_M01	= 170	;  SNES   BW-RAM  $0000/$00--  $006000	BMAPS = $01, ADDR -> $400000
!TestID_SA1_BwRamProtectMapping_Enable	= 171	;  SA-1   BW-RAM  $8000/$80--  $006000	BMAP  = $00, ADDR -> $400000
!TestID_SA1_BwRamProtectMapping_M00P	= 172	;  SA-1   BW-RAM  $0000/$00--  $006000	BMAP  = $00, ADDR -> $400000 * protected
!TestID_SA1_BwRamProtectMapping_M00E	= 173	;  SA-1   BW-RAM  $0000/$00--  $006100	BMAP  = $00, ADDR -> $400100
!TestID_SA1_BwRamProtectMapping_M01	= 174	;  SA-1   BW-RAM  $0000/$00--  $006000	BMAP  = $01, ADDR -> $400000

; Write order					; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_IRamProtectionOrder_CS	= 175	;  SNES   I-RAM     $35/$53    $003000	SA-1 CIWP -> SNES SIWP
!TestID_SNES_IRamProtectionOrder_SC	= 176	;  SNES   I-RAM     $CA/$AC    $003000	SNES SIWP -> SA-1 CIWP
!TestID_SA1_IRamProtectionOrder_CS	= 177	;  SA-1   I-RAM     $33/$55    $003000	SA-1 CIWP -> SNES SIWP
!TestID_SA1_IRamProtectionOrder_SC	= 178	;  SA-1   I-RAM     $CC/$AA    $003000	SNES SIWP -> SA-1 CIWP
!TestID_SNES_BwRamProtectOrder_CSB	= 179	;  SNES   BW-RAM  $0001/$00--  $400000	SA-1 CBWE -> SNES SBWE -> SNES BWPA
!TestID_SNES_BwRamProtectOrder_CBS	= 180	;  SNES   BW-RAM  $0002/$00--  $400000	SNES SBWE -> SNES BWPA -> SA-1 CBWE
!TestID_SNES_BwRamProtectOrder_SCB	= 181	;  SNES   BW-RAM  $0003/$00--  $400000	SNES SBWE -> SA-1 CBWE -> SNES BWPA
!TestID_SNES_BwRamProtectOrder_SBC	= 182	;  SNES   BW-RAM  $0004/$00--  $400000	SNES SBWE -> SNES BWPA -> SA-1 CBWE
!TestID_SNES_BwRamProtectOrder_BCS	= 183	;  SNES   BW-RAM  $0005/$00--  $400000	SNES BWPA -> SA-1 CBWE -> SNES SBWE
!TestID_SNES_BwRamProtectOrder_BSC	= 184	;  SNES   BW-RAM  $0006/$00--  $400000	SNES BWPA -> SNES SBWE -> SA-1 CBWE
!TestID_SA1_BwRamProtectOrder_CSB	= 185	;  SA-1   BW-RAM  $0001/$00--  $400000	SA-1 CBWE -> SNES SBWE -> SNES BWPA
!TestID_SA1_BwRamProtectOrder_CBS	= 186	;  SA-1   BW-RAM  $0002/$00--  $400000	SNES SBWE -> SNES BWPA -> SA-1 CBWE
!TestID_SA1_BwRamProtectOrder_SCB	= 187	;  SA-1   BW-RAM  $0003/$00--  $400000	SNES SBWE -> SA-1 CBWE -> SNES BWPA
!TestID_SA1_BwRamProtectOrder_SBC	= 188	;  SA-1   BW-RAM  $0004/$00--  $400000	SNES SBWE -> SNES BWPA -> SA-1 CBWE
!TestID_SA1_BwRamProtectOrder_BCS	= 189	;  SA-1   BW-RAM  $0005/$00--  $400000	SNES BWPA -> SA-1 CBWE -> SNES SBWE
!TestID_SA1_BwRamProtectOrder_BSC	= 190	;  SA-1   BW-RAM  $0006/$00--  $400000	SNES BWPA -> SNES SBWE -> SA-1 CBWE

; Wrong register				; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_CIWP			= 191	;  SNES   I-RAM     $00/$00    $003000	SNES -> SA-1 register CIWP = $FF
!TestID_SNES_CBWE			= 192	;  SNES   BW-RAM  $00FF/$00--  $400000	SNES -> SA-1 register CBWE = $80
!TestID_SA1_SIWP			= 193	;  SA-1   I-RAM     $00/$00    $003000	SA-1 -> SNES register SIWP = $FF
!TestID_SA1_SBWE			= 194	;  SA-1   BW-RAM  $00FF/$00--  $400000	SA-1 -> SNES register SBWE = $80
!TestID_SA1_BWPA			= 195	;  SA-1   BW-RAM  $00FF/$00--  $400000	SA-1 -> SNES register BWPA = $02

; STP, RDY, Reset				; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_IRamProtectStop		= 196	;  SNES   I-RAM     $00/$33    $003000	change protection at SA-1 STP (set SA-1 protection before STP)
!TestID_SNES_IRamProtectStop_Change	= 197	;  SNES   I-RAM     $11/$33    $003000	change protection at SA-1 STP
!TestID_SNES_BwRamProtectStop_Disable	= 198	;  SNES   BW-RAM  $0000/$00--  $400000	change protection at SA-1 STP			; C=Disable, S=Disable
!TestID_SNES_BwRamProtectStop_ChangeA	= 199	;  SNES   BW-RAM  $0002/$00--  $400000	change protection at SA-1 STP
!TestID_SNES_BwRamProtectStop_ChangeE	= 200	;  SNES   BW-RAM  $8000/$00--  $400000	change protection at SA-1 STP			; C=Disable, S=Enable

!TestID_SNES_IRamProtectReady		= 201	;  SNES   I-RAM     $00/$33    $003000	change protection at SA-1 Ready (CCNT = $40)
!TestID_SNES_IRamProtectReady_Change	= 202	;  SNES   I-RAM     $55/$33    $003000	change protection at SA-1 Ready (CCNT = $40)
!TestID_SNES_BwRamProtectReady_Disable	= 203	;  SNES   BW-RAM  $0000/$00--  $400000	change protection at SA-1 Ready (CCNT = $40)
!TestID_SNES_BwRamProtectReady_ChangeA	= 204	;  SNES   BW-RAM  $0002/$00--  $400000	change protection at SA-1 Ready (CCNT = $40)
!TestID_SNES_BwRamProtectReady_ChangeE	= 205	;  SNES   BW-RAM  $8000/$00--  $400000	change protection at SA-1 Ready (CCNT = $40)

!TestID_SNES_IRamProtectReset		= 206	;  SNES   I-RAM     $00/$33    $003000	change protection at SA-1 Reset (CCNT = $20)
!TestID_SNES_IRamProtectReset_Change	= 207	;  SNES   I-RAM     $AA/$33    $003000	change protection at SA-1 Reset (CCNT = $20)
!TestID_SNES_BwRamProtectReset_Disable	= 208	;  SNES   BW-RAM  $0000/$00--  $400000	change protection at SA-1 Reset (CCNT = $20)
!TestID_SNES_BwRamProtectReset_ChangeA	= 209	;  SNES   BW-RAM  $0002/$00--  $400000	change protection at SA-1 Reset (CCNT = $20)
!TestID_SNES_BwRamProtectReset_ChangeE	= 210	;  SNES   BW-RAM  $8000/$00--  $400000	change protection at SA-1 Reset (CCNT = $20)

!TestID_SNES_BwRamProtectStop_CeSd	= 211	;  SNES   BW-RAM  $0000/$80--  $400000	change protection at SA-1 STP (reboot set)	; C=Enable, S=Disable
!TestID_SNES_BwRamProtectStop_CeSe	= 212	;  SNES   BW-RAM  $8000/$80--  $400000	change protection at SA-1 STP			; C=Enable, S=Enable
!TestID_SNES_BwRamProtectReady_CeSd	= 213	;  SNES   BW-RAM  $0000/$80--  $400000	change protection at SA-1 Ready (CCNT = $40)
!TestID_SNES_BwRamProtectReady_CeSe	= 214	;  SNES   BW-RAM  $8000/$80--  $400000	change protection at SA-1 Ready (CCNT = $40)
!TestID_SNES_BwRamProtectReset_CeSd	= 215	;  SNES   BW-RAM  $0000/$80--  $400000	change protection at SA-1 Reset (CCNT = $20)
!TestID_SNES_BwRamProtectReset_CeSe	= 216	;  SNES   BW-RAM  $8000/$80--  $400000	change protection at SA-1 Reset (CCNT = $20)

; SA-1 Reboot					; TARGET  MEMORY   SNES/SA-1   ADDRESS	DESCRIPTION
!TestID_SNES_IRamProtection_Reboot	= 217	;  SNES   I-RAM     $AA/$33    $003000	(set protection at before reboot) Reboot protection (SNES)
!TestID_SNES_BwRamProtection_Reboot	= 218	;  SNES   BW-RAM  $0002/$80--  $400000	(set protection at before reboot) Reboot protection (SNES)
!TestID_SA1_Reboot_SPL			= 219	;  SA-1                               	(set SP at before reboot)         Reboot stack pointer
!TestID_SA1_Reboot_SPH			= 220	;  SA-1                               	(set SP at before reboot)         Reboot stack pointer
!TestID_SA1_IRamProtection_Reboot	= 221	;  SA-1   I-RAM     $AA/$33    $003000	(set protection at before reboot) Reboot protection (SA-1)
!TestID_SA1_BwRamProtection_Reboot	= 222	;  SA-1   BW-RAM  $0002/$80--  $400000	(set protection at before reboot) Reboot protection (SA-1)

;--------------------------------------------------

!TestID_Count				= 222

;--------------------------------------------------

!StopSP_SNES				= $01FF
!StopSP_SA1				= $01FF

;--------------------------------------------------
