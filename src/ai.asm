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
   ; find the first unused sprite
   ld HL,[OAM_MIRROR + $03]   ; skip the player sprite
   ld E,$28
   ; point HL at the tile
   ; 40 possible sprites
.find_unused_tile_parasite
   dec E
   ld A,E
   or $00
   jr z,.no_load_parasite
   ld A,L
   add $04
   ld L,A
   ld A,[HL]
   cp $00
   jr nz,.find_unused_tile_parasite

   ; point HL at the y attrib for that sprite
   dec HL
   dec HL

   call Get_Random

   ; y pos = random
   ld [HL+],A
   ; x pos = 0 for now
   xor A
   ld [HL+],A
   ; tile, parasite = 4
   ld A,$03
   ld [HL+],A
   ; attribs
   xor A
   ld [HL+],A

   ld HL,PARA_COUNT
   inc [HL]

.no_load_parasite

; cow loading

; movement
; do this one sprite at a time
   ld E,$28
   ld HL,[OAM_MIRROR + $03]
.movement
   dec E
   ld A,E
   or $00
   jr nz,.ret              ; cancel when we reach the end of the sprites
   ld A,L
   add $04
   ld L,A                  ; inc HL by 4 to check the next sprite
   ld A,[HL]
   cp $02
   jr z,.cow_movement
   cp $03
   jr z,.parasite_movement
   jr .movement            ; if not a parasite or cow, skip it

.parasite_movement
   push DE                 ; our main loop needs these two
   push HL

   

.ret
   ret
