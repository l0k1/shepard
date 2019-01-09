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
   ld H,$9A
   ld L,A
   ld A,[HL]
   
   ; the actual tile will be at $9000 + (bg_addr_ref - $20) * $10 + 18 or 19
   sub $20
   ; multiply by $10
   rlca
   rlca
   ; subtract by either 1 or 2 depending on the runthru
   ld D,A
   ld A,[BG_RUNTHRU]
   cp $00
   jr z,.add18
   cp $02
   jr z,.add18
   add $19
   jr .cont
.add18
   sub $18
.cont
   ; check for carry
   
   
