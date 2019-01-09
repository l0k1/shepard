;***************************************** SHEPARD
; The goal is to keep EVERYTHING under $400 bytes.
; In pursuit of this goal, I may be doing some stupid stuff.
; I'm not optimizing for CPU time, I'm optimizing for byte size.
; If you see heresy, there's probably a reason.


INCLUDE  "defines.asm"

;   SECTION  "Org $00",ROM0[$00]
;RST_00:  
;   jp $100
;
;   SECTION  "Org $08",ROM0[$08]
;RST_08:  
;   jp $100
;
;   SECTION  "Org $10",ROM0[$10]
;RST_10:
;   jp $100
;
;   SECTION  "Org $18",ROM0[$18]
;RST_18:
;   jp $100
;
;   SECTION  "Org $20",ROM0[$20]
;RST_20:
;   jp $100
;
;   SECTION  "Org $28",ROM0[$28]
;RST_28:
;   jp $100
;
;   SECTION  "Org $30",ROM0[$30]
;RST_30:
;   jp $100
;
;   SECTION  "Org $38",ROM0[$38]
;RST_38:
;   jp $100

   SECTION  "V-Blank IRQ Vector",ROM0[$40]
VBL_VECT:
   ; this runs over the LCD, and TIMER interrupts. don't use those.
   push AF
   push BC
   push DE
   push HL
   
   ; set the flag that lets the main loop run again.
   ld HL,L_FLAG
   set 0,[HL]

   call DMA

   pop HL
   pop DE
   pop BC
   pop AF

   reti
   
;   SECTION  "LCD IRQ Vector",ROM0[$48]
;LCD_VECT:
;   reti

;   SECTION  "Timer IRQ Vector",ROM0[$50]
;TIMER_VECT:
;   reti

;   SECTION  "Serial IRQ Vector",ROM0[$58]
;SERIAL_VECT:
;   reti

;   SECTION  "Joypad IRQ Vector",ROM0[$60]
;JOYPAD_VECT:
;   reti
   
   SECTION  "Start",ROM0[$100]
   nop
   jp Main

   ; $0104-$0133 (Nintendo logo - do _not_ modify the logo data here or the GB will not run the program)
   DB $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
   DB $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
   DB $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

   ; $0134-$013E (Game title - up to 11 upper case ASCII characters; pad with $00)
   DB "SHEPARD0000"
      ;0123456789A

   ; $013F-$0142 (Product code - 4 ASCII characters, assigned by Nintendo, just leave blank)
   DB "    "
      ;0123

   ; $0143 (Color GameBoy compatibility code)
   DB $00   ; $00 - DMG 
         ; $80 - DMG/GBC
         ; $C0 - GBC Only cartridge

   ; $0144 (High-nibble of license code - normally $00 if $014B != $33)
   DB $0F

   ; $0145 (Low-nibble of license code - normally $00 if $014B != $33)
   DB $0F

   ; $0146 (GameBoy/Super GameBoy indicator)
   DB $00   ; $00 - GameBoy

   ; $0147 (Cartridge type - all Color GameBoy cartridges are at least $19)
   DB $00   ; ROM only

   ; $0148 (ROM size)
   DB $00   ; 32KiB - 2 banks

   ; $0149 (RAM size)
   DB $00   ; No RAM

   ; $014A (Destination code)
   DB $01   ; $01 - All others
         ; $00 - Japan 

   ; $014B (Licensee code - this _must_ be $33)
   DB $33   ; $33 - Check $0144/$0145 for Licensee code.

   ; $014C (Mask ROM version - handled by RGBFIX)
   DB $00

   ; $014D (Complement check - handled by RGBFIX)
   DB $00

   ; $014E-$014F (Cartridge checksum - handled by RGBFIX)
   DW $00


;***************************************** INITIALIZATION

   SECTION "Initialization",ROM0[$0150]
Main:

   di

   ld SP, $DEFE      ;init the stack pointer
   ld A,%11100100    ;set the pallete color to standard.
   ld [rBGP],A
   ld [rOBP0],A
   ld [rOBP1],A

   ;ld A,%11010111    ; LCDC settings
   ;ld [rLCDC],A

   xor A
   ld [rSCX],A
   ld [rSCY],A
   ld [rIF],A
   
   ; smaller to init ram this way vs individually
   ld E,$FF                ; 2 bytes
   ld HL,$C001             ; 3 bytes
.clear_ram_loop
   ld [HL+],A              ; 1 byte
   dec E                   ; 1 byte
   jr nz,.clear_ram_loop   ; 2 bytes

   ; turn off the LCD
   ld HL,rLY
.wait_vblank_beginning_loop
   ld A,[HL]
   cp $90
   jr nz,.wait_vblank_beginning_loop

   ld A,%01010011
   ld [rLCDC],A

   ; load the sprites into TDT1
   ld HL,Shepard
   ld DE,TDT1+$10       ; leave the first tile alone (it's blank)
.copy_to_tdt
   ld A,[HL+]
   ld [DE],A
   inc DE
   ld A,E
   cp $60               ; because the TDT is $xx00, and we want to load $40 tiles, we can just check for when our TDT-pointing register has $40 in the least significant register.
   jr nz,.copy_to_tdt

   ; clear out the bg map from 9904 to 992F (nintendo logo)
   ld HL,$9904
.clear_bg_map
   xor A
   ld [HL+],A
   ld A,L
   cp $30
   jr nz,.clear_bg_map

   ; set up for our first DMA
   ld HL,PLAYER_Y
   ld A,$50          ; player Y
   ld [HL+],A
   ld A,$40          ; player X
   ld [HL+],A
   ld A,$01          ; player sprite
   ld [HL+],A
.loop                ; clean out the rest of OAM
   xor A
   ld [HL+],A
   ld A,L
   cp $A0
   jr nz,.loop
   
   ld A,$04
   ld [OAM_POINTER],A

   ld A,$20
   ld [BG_ADDR_REF],A
 
   ld A,%00000001
   ld [rIE],A        ; joypad and v-blank interrupts, yo 

   ld A,%11010011    ; re enable the LCD
   ld [rLCDC],A

   ei

.main

   ; only run the main loop once per frame
   ld HL,L_FLAG
   bit 0,[HL]
   jr z,.skip
   set 0,[HL]
   
   call Controller
   ; call AI   

.skip
   halt
   nop
   jr .main

