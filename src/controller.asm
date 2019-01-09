;this handles all functions related to inputs from the Human
;as the player character is walking around the world

INCLUDE "defines.asm"

   SECTION "World Interfacing",ROM0
Controller::
   ld A,%00100000
   ld [rP1],A                 ; check P14 first
   ld A,[rP1]
   ld A,[rP1]                 ; wait a few cycles due to bounce
   cpl
   and $0F                    ; keep only LSB
   swap A
   ld B,A                     ; store it in B
   ld A,%00010000
   ld [rP1],A                 ; now check P15
   swap [HL]                  ; save a couple bytes, vs using
   swap [HL]                  ; the traditional ld A,[rP1]
   swap [HL]
   swap [HL]
   ld A,[rP1]
   ld A,[rP1]                 ; bounce is compensated for
   cpl
   and $0F                    ; keep LSB again
   or B                       ; combine A and B into A
   ld B,A                     ; save it in B
   ld A,%00110000             ; deselect the registers
   ld [rP1],A
   
   ;bit J_A,A
   ;bit J_B,A
   ld A,B
   bit J_DOWN,A
   jr z,.check_up
   ld HL,PLAYER_Y
   ld A,[HL]
   cp $98
   jr z,.check_up
   dec [HL]

;.check_left
;   ld A,B
;   bit J_LEFT,A
;   jr z,.check_up
;   ld HL,PLAYER_Y
;   ld A,[HL]
;   cp $08
;  jr z,.check_up
;  dec [HL]

.check_up
   ld A,B
   bit J_UP,A
   jr z,.check_right
   ld HL,VIRTUAL_PLAYER_X
   ld A,[HL]
   cp $10
   jr z,.check_right
   inc [HL]

.check_right
   ld A,B
   bit J_RIGHT,A
   jr z,.end_joypad_update
   ld HL,PLAYER_Y
   ld A,[HL]
   cp $A0
   jr z,.end_joypad_update
   inc [HL]

   ;bit J_SELECT,A
   ;bit J_START,A
.end_joypad_update
   ret
