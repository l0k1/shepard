;LCD Interface and Graphics routines.

INCLUDE "globals.asm"

EXPORT   DMA

   SECTION "DMA",ROM0
   ;DMA: copies a dma routine to HRAM [$FF80], and then calls that routine.
   ;Interrupts are not enabled/disabled here.
   ;This routine destroys all registers.
   ;This routine overwrites $FF80 to $FF8A of HRAM.
   ;OAM_MIRROR_DMA is defined in globals.asm.
   ;556 cycles
DMA:
   ld HL,_HRAM
   ld BC,.dma_routine      ;we want the address that .dma_routine is at
   ld D,$0A                ;number of bytes in the .dma_routine
.load_dma_loop
   ld A,[BC]               ;copy .dma_loop to HRAM
   ld [HL+],A
   inc BC
   dec D
   jr nz,.load_dma_loop
   call _HRAM              ;call the DMA routine.
   ret
   
.dma_routine               ;this is the routine which will be copied to $FF80+
   ld A,OAM_MIRROR_DMA     ;2 bytes - this routine shouldn't be called directly.
   ldh [$46],A             ;2 bytes - need to be explicit with the "ldh". this is [rDMA]
   ld A,$28                ;2 bytes - waiting loop, 160 *micro*seconds
   dec A                   ;1 byte  -
   DB $20,$FD              ;2 bytes - opcode for jr nz,(go back to dec A) 
   ret                     ;1 byte
