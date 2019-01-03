; AI routines
; hunters make a beeline for the player
; sheep follow around the player
; the player can only move up and down, not back
; plasma balls go in a straight line horizontally

INCLUDE "defines.asm"

   SECTION "AI",ROM0

AI::
   ; check if we have any hunters
   ; max 4 hunters
   ld A,[HUNTER_COUNT]
   cp $04
   jr nc,.no_load_hunter
   or $00
   jr z,.load_hunter

   ; check random, $01/$FF chance to load a hunter
   ; destroys B
   call Get_Random
   cp $02
   jr nc,.no_load_hunter

.load_hunter
   ; find the first unused sprite
   ld HL,OAM_MIRROR
   ld E,$28
   ; point HL at the tile
   ; 40 possible sprites
.find_unused_tile_hunter
   dec E
   ld A,E
   or $00
   jr z,.no_load_hunter
   ld A,L
   add $04
   ld L,A
   ld A,[HL]
   cp $00
   jr nz,.find_unused_tile_hunter

   ; point HL at the y attrib for that sprite
   dec HL
   dec HL
   dec HL

   call Get_Random

   ; y pos = random
   ld [HL+],A
   ; x pos = 0 for now
   xor A
   ld [HL+],A
   ; tile, hunter = 4
   ld A,$03
   ld [HL+],A
   ; attribs
   xor A
   ld [HL+],A

   ld HL,HUNTER_COUNT
   inc [HL]

.no_load_hunter

; sheep loading

; movement
; do this one sprite at a time
   ld E,$28
   ld HL,OAM_MIRROR + $02
.movement
   dec E
   ld A,E
   or $00
   jp z,.ret              ; cancel when we reach the end of the sprites
   ld A,L
   add $04
   ld L,A                  ; inc HL by 4 to check the next sprite
   ld A,[HL]
   cp $02
   jp z,.sheep_movement
   cp $03
   jr z,.hunter_movement
   jr .movement            ; if not a hunter or sheep, skip it

.hunter_movement
.sheep_movement
.ret

   ret

   SECTION "Sprite Handling",ROM0
   ; find first unused sprite
Find_Unused_Tile:
   ; find the first unused sprite
   ld HL,OAM_MIRROR
   ld E,$27
   ; point HL at the tile
   ; 39 possible sprites not including the player
   ; HL will be 0 if none found
   ; else HL will have Y attrib of the sprite
.loop
   dec E
   ld A,E
   or $00
   jr z,.none_found
   ld A,L
   add $04
   ld L,A
   ld A,[HL]
   cp $00
   jr nz,.loop
   ld A,L
   sub $02
   ld L,A
   jr nc,.retu
   dec H
   ret
.none_found
   ld HL,$0000
.retu
   ret

   SECTION "Pathing",ROM0

Get_Step:
   ; needs ORIG_X and ORIG_Y set to the sprites location
   ; needs DEST_X and DEST_Y set to the destination
   ; returns flags in E, such that:
   ;     0 - x is up
   ;     1 - y is left
   ;     2 - move in the x plane
   ;     3 - move in the y plane
   
   ; this isn't a perfect algorithm, but its small and fast.
   ; it can be made smaller by removing the *4 checks, and leaving the *2
; reset move flags
   ld E,0

; get x slope
   ld A,[DEST_X]
   ld B,A
   ld A,[ORIG_X]
   sub B
   jr nc,.skip_x_neg
   cpl
   inc A
   set 0,E
.skip_x_neg
   ld B,A
   
; get y slope
   ld A,[DEST_Y]
   ld C,A
   ld A,[ORIG_Y]
   sub C
   jr nc,.skip_y_neg
   cpl
   inc A
   set 1,E
.skip_y_neg
   ld C,A
      
   ; if slope_x = slope_y, move both x and y
   cp B
   jr z,.set_2_3
   
   ; if slope_y * 2 = slope_x, move both x and y
.check_mult_y_2
   rlca
   cp B
   jr z,.set_2_3
   
   ; if slope_y * 4 = slope_x, move both x and y
.check_mult_y_4
   rlca
   cp B
   jr z,.set_2_3
   
   ; if slope_x * 2 = slope_y, move both x and y
.check_mult_x_2
   ld A,B
   rlca
   cp C
   jr z,.set_2_3

   ; if slope_x * 4 = slope_y, move both x and y
.check_mult_x_4
   rlca
   cp C
   jr z,.set_2_3
   
   ; else move the larger one
.check_greater
   ; b is x
   ; c is y
   ld A,B
   cp C
   jr c,.inc_y
   set 2,E
   ret
.inc_y
   set 3,E
   ret

.set_2_3
   set 2,E
   set 3,E
   ret
