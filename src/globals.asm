   SECTION "Globals",WRAM0
RANDOM:: DS 1
; Loop flag - only want to run the main loop once per frame
L_FLAG:: DS 1
; OAM Pointer
OAM_POINTER:: DS 1
; Sheep count
SHEEP_COUNT:: DS 1
; Hunter count
HUNTER_COUNT:: DS 1

PARA_X:: DS 1
PARA_Y:: DS 1
ORIG_X:: DS 1
ORIG_Y:: DS 1
DEST_X:: DS 1
DEST_Y:: DS 1
VIRTUAL_PLAYER_X:: DS 1

BG_ADDR_REF:: DS 1
BG_RUNTHRU:: DS 1

;GFX update flags
;if bit 0 = 1, perform DMA update.
GFX_UPDATE_FLAGS:: DS 1

   SECTION "OAM Mirror",WRAM0,ALIGN[8]
;OAM Mirror. Put sprite updates here.
PLAYER_Y:: DS 1
PLAYER_X:: DS 1
PLAYER_SPRITE:: DS 1
PLAYER_FLAGS:: DS 1
OAM_MIRROR:: DS $9C
