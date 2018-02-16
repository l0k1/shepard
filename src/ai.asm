; AI routines

   SECTION "AI",ROM0

AI:
   ; check if we have any parasites
   ; max 4 parasites
   ld A,[PARA_COUNT]
   cp $04
   jr nc,.no_load_parasite
   or $00
   jr z,.load_parasite

   ; check random, $01/$FF chance to load a parasite
   ; destroys B
   call Get_Random
   cp $02
   jr nc,.no_load_parasite

.load_parasite
   ld A,[OAM_POINTER]
   ld H,$DF
   ld L,A

   call Get_Random

   ; y pos = random
   ld [HL+],A
   ; x pos = 0 for now
   xor A
   ld [HL+],A
   ; tile, parasite = 4
   ld A,$04
   ld [HL+],A
   ; attribs
   xor A
   ld [HL+],A

   ld A,L
   ld [OAM_POINTER],A

   ld HL,PARA_COUNT
   inc [HL]

.no_load_parasite

; cow loading

; movement



   ret
