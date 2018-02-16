;this handles all functions related to inputs from the Human
;as the player character is walking around the world

INCLUDE "globals.asm"

Export World_Interface
   
   SECTION "World Interfacing",ROM0
World_Interface:
   ld A,[JOYPAD]              ;get joypad data
   bit J_A,A                  ;check each button, and process accordingly
   call nz,.a_pressed         ;all these calls are ugly to me
   bit J_B,A                  ;but its the best way to get the functionality
   call nz,.b_pressed         ;that i want
   bit J_DOWN,A
   call nz,.down_pressed
   bit J_LEFT,A
   call nz,.left_pressed
   bit J_UP,A
   call nz,.up_pressed
   bit J_RIGHT,A
   call nz,.right_pressed
   bit J_SELECT,A
   call nz,.select_pressed
   bit J_START,A
   call nz,.start_pressed
.end_joypad_update
   ret                        ;after calls, this will be the end point
   
.a_pressed
   ret
   
.b_pressed
   ret
   
.down_pressed
   push AF
   ld HL,$DF00    ; player 
   ld A,[HL]
   cp $98         ; bottom of the screen
   jr z,.skip_down
   inc [HL]
.skip_down
   pop AF
   ret
   
.up_pressed
   push AF
   ld HL,$DF00    ; player Y
   ld A,[HL]
   cp $10         ; top of the screen
   jr z,.skip_up
   dec [HL]
.skip_up
   pop AF
   ret
   
.left_pressed
   push AF
   ld HL,$DF01    ; player X
   ld A,[HL]
   cp $08         ; leftmost of the screen
   jr z,.skip_left
   dec [HL]
.skip_left
   pop AF
   ret

.right_pressed
   push AF
   ld HL,$DF01    ; player X
   ld A,[HL]
   cp $A0
   jr z,.skip_right
   inc [HL]
.skip_right
   pop AF
   ret
   
.select_pressed
   ret
   
.start_pressed
   ret
   
.return_early                 ;if we need to return early after a button press,
   inc SP                     ;and stop processing other buttons
   inc SP                     ;manipulate the stack to get rid of the push
   jp .end_joypad_update      ;that the original call did.
