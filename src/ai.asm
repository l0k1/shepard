; AI routines

INCLUDE "globals.asm"

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
   ld HL,OAM_MIRROR + $03   ; skip the player sprite in the OAM_MIRROR
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
   ld HL,OAM_MIRROR + $03
.movement
   dec E
   ld A,E
   or $00
   jp nz,.ret              ; cancel when we reach the end of the sprites
   ld A,L
   add $04
   ld L,A                  ; inc HL by 4 to check the next sprite
   ld A,[HL]
   cp $02
   jp z,.cow_movement
   cp $03
   jr z,.parasite_movement
   jr .movement            ; if not a parasite or cow, skip it

.parasite_movement
   push DE                 ; our main loop needs these two
   push HL
   
   dec HL                  ; point HL at Y pos
   dec HL
   
   ld E,$0                 ; use E to keep track of our negatives/positives
   
   ; calculate the deltas
   ; deltay = player_y - parasite_y
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; change PLAYER_X and PLAYER_Y to whatever target coords we want.
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ld A,[HL+]
   ld B,A
   ld [PARA_Y],A            ; save the Y for later
   ld A,[PLAYER_Y]
   sub B
   ld B,A
   jr nc,.skip_delta_y_neg
   set 0,E                 ; e%0 = dy is negative
.skip_delta_y_neg
   
   ; deltax = player_x - parasite_x
   ld A,[HL]
   ld C,A
   ld [PARA_X],A
   ld A,[PLAYER_X]
   sub C
   ld C,A
   jr nc,.skip_delta_x_neg
   set 1,E                 ; e%1 = dx is negative
.skip_delta_x_neg

   ; b has delta_y, c has delta_x
   ; get absolute values for b/c
   push BC
   
   bit 0,E
   jr z,.abs_x
   ld A,B
   cpl
   ld B,A
.abs_x
   bit 1,E
   jr z,.skip_abs_x
   ld A,C
   cpl
   ld C,A
.skip_abs_x

   ; if C >= B, then X axis is major
   ; else, Y
   ld A,B
   sub C
   pop BC                  ; restore BC before jumping to save a couple bytes
   jr c,.y_major
.x_major
   ; calculate error margin
   ; error = 2 * B - C
   rlc B
   ld A,B
   sub C
   jr c,.skip_neg_error
   set 2,E                 ; e%2 has if error is negative (0 is dy and 1 is dx) - 1 is negative, 0 is positive
.skip_neg_error
   
   ld HL,PARA_X
   bit 1,E                 ; if delta_x > 0 then x = x + 1
   jr nz,.x_is_right
   inc [HL]
.x_is_right                ; else x = x - 1
   dec [HL]
   
   
   bit 0,E                 ; if delta_y > 0 and error > 0 then
   jr nz,.check_dy
   bit 2,E
   jr nz,.check_dy
   ld HL,PARA_Y            ; y = parasite_y + 1
   inc [HL]
   
.check_dy
   bit 0,E                 ; if delta_y < 0 and error < 0 then
   jr z,.ret
   bit 2,E
   jr z,.ret
   ld HL,PARA_Y            ; y = parasite_y - 1
   dec [HL]
   

.y_major
   ; calculate error margin
   ; error = 2 * C - B
   rlc C
   ld A,C
   sub B
   jr c,.skip_neg_error_y
   set 2,E                 ; e%2 has if error is negative (0 is dy and 1 is dx) - 1 is negative, 0 is positive
.skip_neg_error_y
   
   ld HL,PARA_Y
   bit 0,E                 ; if delta_y > 0 then y = y + 1
   jr nz,.y_is_up
   inc [HL]
.y_is_up                   ; else y = y - 1
   dec [HL]
   
   bit 1,E                 ; if delta_x > 0 and error > 0 then
   jr nz,.check_dx
   bit 2,E
   jr nz,.check_dx
   ld HL,PARA_X            ; x = parasite_x + 1
   inc [HL]
   
.check_dx
   bit 1,E                 ; if delta_y < 0 and error < 0 then
   jr z,.ret
   bit 2,E
   jr z,.ret
   ld HL,PARA_X            ; x = parasite_x - 1
   dec [HL]

.cow_movement
.ret

   ret
