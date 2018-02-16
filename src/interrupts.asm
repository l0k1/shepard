; interrupt functions.
; for now, only using the controller interrupt.


INCLUDE "globals.asm"
EXPORT Controller
EXPORT DMA

   SECTION "Controller Status",ROM0
   
   ;Controller routines
   ;dulr - stseba
   ;JOYPAD data is stored as:
   ;   1 - pressed, 0 - not pressed
   ;   Bit 7 - Down
   ;   Bit 6 - Up
   ;   Bit 5 - Left
   ;   Bit 4 - Right
   ;   Bit 3 - Start
   ;   Bit 2 - Select
   ;   Bit 1 - B-button
   ;   Bit 0 - A-button
   
Controller:
   push AF           ;Push AF onto the stack to restore later.
   push BC           ;Push B onto the stack to restore later.
   ld A,%00100000    ;Load 0010 0000 into A.
   ld [rP1],A        ;We are checking P14 first.
   ld A,[rP1]
   ld A,[rP1]        ;Wait a few cycles, compensate for bounce.
   cpl               ;Complement A.
   and $0F           ;Only keep the LSB.
   swap A            ;Move those 4 bits up front.
   ld B,A            ;Store it in B
   ld A,%00010000    ;Load 0001 0000 into A.
   ld [rP1],A        ;Now check P15.
   ld A,[rP1]
   ld A,[rP1]
   ld A,[rP1]
   ld A,[rP1]
   ld A,[rP1]
   ld A,[rP1]        ;Wait a few cycles to compensate for bounce.
   cpl               ;Complement A.
   and $0F           ;Keep only the LSB.
   or B              ;Combine registers A and B into A.
   ld [JOYPAD],A     ;JOYPAD is a constant set in globals.asm
   ld A,%00110000    ;Deselect both P14 and P15.
   ld [rP1],A        ;Reset joypad.
   pop BC            ;Restore B.
   pop AF            ;Restore AF.
   ret               ;Exit
   
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
