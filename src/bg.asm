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
   ; the call nc,.int_h in here are much slower, but smaller, vs using jr's
   ld H,$90
   ; add $10 - first tile should be blank for the rest of the background
   add $10
   ; multiply by $10
   rlca
   call nc,.inc_h
   rlca
   call nc,.inc_h
   ; add either 18 or 19 depending on the runthru
   ld D,A
   ld A,[BG_RUNTHRU]
   ld E,A
   cp $02
   jr z,.addE
   ld A,D
   add $F
   jr .cont
.addE
   ld D,A
   add $E
.cont
   call c,.inc_h
   ld L,A
   ; HL should now, in theory, point to the bg tile to update
   ld A,E

.inc_h
   inc H
   ret
