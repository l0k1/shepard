;* This file contains global constants.

; THIS FILE DESPERATELY NEEDS CLEANING.

; Make sure all this data is only loaded once.
   IF !DEF(GLOBALS_ASM)
GLOBALS_ASM SET 1

RANDOM   EQU $C000
; Loop flag - only want to run the main loop once per frame
L_FLAG   EQU $C001
; OAM Pointer
OAM_POINTER EQU $C002
; Cow count
COW_COUNT   EQU $C003
; Parasite count
PARA_COUNT  EQU $C004

PLAYER_X EQU $DF00
PLAYER_Y EQU $DF01

;OAM Mirror. Put sprite updates here.
OAM_MIRROR EQU $DF00
;same as OAM_MIRROR, but for use in the DMA routine.
OAM_MIRROR_DMA EQU $DF
;GFX update flags
;if bit 0 = 1, perform DMA update.
GFX_UPDATE_FLAGS EQU $DFA0

;* Hardware definitions
;Joypad stuff
J_DOWN   EQU 7
J_UP     EQU 6
J_LEFT   EQU 5
J_RIGHT  EQU 4
J_START  EQU 3
J_SELECT EQU 2
J_B      EQU 1
J_A      EQU 0

;Slimmed down and modified from Jeff Frohwein's include files.
;Global constants

TDT1          EQU  $8000
TDT2          EQU  $8800
TDT2_NO_OVER  EQU  $9000  ; tile data table 2, but with no overlap (all values are positive)

_HW           EQU  $FF00

_VRAM         EQU  $8000 ; $8000->$A000
_SCRN0        EQU  $9800 ; $9800->$9BFF
_SCRN1        EQU  $9C00 ; $9C00->$9FFF
_RAM          EQU  $C000 ; $C000->$E000
_OAMRAM       EQU  $FE00 ; $FE00->$FE9F
_AUD3WAVERAM  EQU  $FF30 ; $FF30->$FF3F
_HRAM         EQU  $FF80 ; $FF80->$FFFE
_WPRAM        EQU  _AUD3WAVERAM


; *** MBC5 Equates ***

rRAMG         EQU  $0000 ; $0000->$1fff
rROMB0        EQU  $2000 ; $2000->$2fff
rROMB1        EQU  $3000 ; $3000->$3fff
rRAMB         EQU  $4000 ; $4000->$5fff

SRAM_ENABLE   EQU  $A0
SRAM_DISBALE  EQU  $00

;* Custom registers

; -- Register for reading joy pad info.    (R/W)
rP1 EQU $FF00

; -- Serial Transfer Data (R/W)
rSB EQU $FF01

; -- Serial I/O Control (R/W)
rSC EQU $FF02

; -- Divider register (R/W)
rDIV EQU $FF04

; -- Timer counter (R/W)
rTIMA EQU $FF05

; -- Timer modulo (R/W)
rTMA EQU $FF06

; -- Timer control (R/W)
rTAC EQU $FF07

; -- Interrupt Flag (R/W)
rIF EQU $FF0F

; -- LCD Control (R/W)
rLCDC EQU $FF40

; -- LCDC Status   (R/W)
rSTAT EQU $FF41

; -- Scroll Y (R/W)
rSCY  EQU $FF42

; -- Scroll X (R/W)
rSCX  EQU $FF43

; -- LCDC Y-Coordinate (R)
rLY EQU $FF44

; -- LY Compare (R/W)
rLYC  EQU $FF45

; -- DMA Transfer and Start Address (W)
rDMA  EQU $FF46

; -- BG Palette Data (W)
rBGP  EQU $FF47

; -- Object Palette 0 Data (W)
rOBP0 EQU $FF48

; -- Object Palette 1 Data (W)
rOBP1 EQU $FF49

; -- Window Y Position (R/W)
rWY EQU $FF4A

; -- Window X Position (R/W)
rWX EQU $FF4B

; -- Interrupt Enable (R/W)
rIE EQU $FFFF

;* Screen related
SCRN_X     EQU  160 ; Width of screen in pixels
SCRN_Y     EQU  144 ; Height of screen in pixels
SCRN_X_B   EQU  20  ; Width of screen in bytes
SCRN_Y_B   EQU  18  ; Height of screen in bytes

SCRN_VX    EQU  256 ; Virtual width of screen in pixels
SCRN_VY    EQU  256 ; Virtual height of screen in pixels
SCRN_VX_B  EQU  32  ; Virtual width of screen in bytes
SCRN_VY_B  EQU  32  ; Virtual height of screen in bytes

ENDC
