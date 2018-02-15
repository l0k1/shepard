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

INCLUDE "globals.asm"
EXPORT Controller
EXPORT V_Blank_Int

   SECTION "Controller Status",ROM0
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

   SECTION "V Blank Interrupt",ROM0
   ; DMA and Background_Update are both in lcd_interface.asm
   ; VBlank lasts ~4530 cycles
   ; All code in the interrupt must be less than 4530 cycles
   ; If my counting is right, this is currently at a maximum
   ; of 2552 cycles if all code is ran.
   
                                 ; initial call is 24 cycles
V_Blank_Int:
   push AF                       ; 64 cycles for pushing
   push BC
   push DE
   push HL
   
   ld A,[GFX_UPDATE_FLAGS]       ; 16 cycles
   bit 0,A                       ; 8 cycles
   call nz,DMA                   ; 24 if condition - routine is 556 cycles
   xor A                         ; 4 cycles
   ld [GFX_UPDATE_FLAGS],A       ; 16 cycles
   
   pop HL                        ; 48 cycles for popping
   pop DE
   pop BC
   pop AF
   
   ret                           ; 16 + 16 for reti in main.asm
