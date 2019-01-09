; the bg will have a bar at the bottom showing the players progression
; we require 2 counters/2 bytes of ram
; 1 counter will keep track of the bg memory location we are writing to.
; the other counter will keep track of if we are at 1, 2, or 3
; i may extend this to a 3rd counter going up a tile. not sure yet.


INCLUDE "defines.asm"

   SECTION "BG",ROM0
Inc_BG::
   ; call this function to increment the background scroller
   push AF
   push HL
   ld A,[BG_ADDR_REF]
   ld H,$9A
   ld L,A
