;--------------------------------------------------
; Define SNES and SA-1 IRQ message ID
;--------------------------------------------------

includeonce

;--------------------------------------------------
; SNES -> SA-1 Message

!Message_SNES_SA1_NOP			= 0	; to leave WAI
!Message_SNES_SA1_ResetStatus		= 1
!Message_SNES_SA1_ExecuteWAI		= 2
!Message_SNES_SA1_ExecuteSTP		= 3
!Message_SNES_SA1_TestExecute		= 4

;--------------------------------------------------
; SA-1 -> SNES Message

!Message_SA1_SNES_Boot			= 0
!Message_SA1_SNES_Idle			= 1
!Message_SA1_SNES_Running		= 2
;!Message_SA1_SNES_Finished		= 15

;--------------------------------------------------
