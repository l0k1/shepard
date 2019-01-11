; Math functions

INCLUDE  "defines.asm"

   SECTION "Get Random",ROM0
   ; update the random seed with DIV
   ; outputs into A
Get_Random::
   ld A,[RANDOM]
   ld B,A
   ld A,[rDIV]
   xor B
   ld [RANDOM],A
   ret
