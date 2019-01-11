; the bg will have a bar at the bottom showing the players progression
; we require 2 counters/2 bytes of ram
; 1 counter will keep track of the bg memory location we are writing to.
; the other counter will keep track of if we are at 1, 2, or 3
; i may extend this to a 3rd counter going up a tile. not sure yet.


INCLUDE "defines.asm"

   SECTION "BG",ROM0
Inc_BG::
   ; call this function to increment the background scroller
   
   ; get bg addr into HL
   push AF
   push BC
   push DE
   push HL
   ld A,[BG_ADDR_REF]
   ld L,A
   ld H,$9A
   ld A,[HL]
   
   ; the actual tile will be at $9000 + bg_addr_ref * $10 + 18 or 19
   ld H,$90
   ; multiply by $10
   swap A
   ld D,A
   and $0F
   cp $00
   jr z,.no_inc_h
   inc H
.no_inc_h
   ld A,D
   and $F0
   ; add either E or F depending on the runthru
   ld D,A
   ld A,[BG_RUNTHRU]
   ld E,A
   cp $01
   jr z,.addE
   ld A,D
   add $F
   jr .cont0
.addE
   ld D,A
   add $E
.cont0
   ld L,A
   ; HL should now, in theory, point to the bg tile to update
   ; if bg_runthru/a is 0, then [hl] should progressively bit-shift right with 1's at MSB and [hl+1] should bitshift right with 0's
   ; if a is 0 or 1, then [hl] should bitshift right with 1's, and [hl-1] should bitshift right with 0's
   ; if a is 2, then [hl] should bitshift right with 1's
   ld A,E
   scf
   rr [HL]
   cp $00
   jr nz,.cont3
   inc [HL]
   srl [HL]
   dec [HL]
   jr .cont1
.cont3
   cp $01
   jr nz,.cont1
   dec HL
   srl [HL]
   inc HL
.cont1
   ; if HL == $FF, then we need to inc BG_ADDR_REF
   ld A,[HL]
   cp $FF
   jr nz,.cont2
   ld HL,BG_ADDR_REF
   ld A,[HL]
   inc A
   ; if BG_ADDR_REF > $33, set it back to $20 and inc BG_RUNTHRU
   cp $33
   jr nc,.cont2
   ld A,$20
   ld [HL],A
   ld A,[BG_RUNTHRU]
   inc A
   cp $03
   jr nc,.cont2
   ld A,$00
.cont2
   ; i think that's everything?
   ret
