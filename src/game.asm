

include "hardware.inc"
include "assets_def.inc"

section "Game ram", wram0

wJokerCount:        ds 1
wJokerMax:          ds 1
wTarotCount:        ds 1
wTarotMax:          ds 1

section "Game code", rom0

def JOKER_COUNT_SCREEN_OFFSET       equ 1
def JOKER_MAX_DEFAULT               equ 5
def TAROT_COUNT_SCREEN_OFFSET       equ 14
def TAROT_MAX_DEFAULT               equ 2

def HUD_PALETTE_CHANGE_LINE         equ 102
def HUD_SCREEN_OFFSET               equ 13 * 32
def HUD_SCREEN_HAND_OFFSET          equ HUD_SCREEN_OFFSET
def HUD_SCREEN_HAND_LENGTH          equ 13
def HUD_SCREEN_ANTE_OFFSET          equ HUD_SCREEN_OFFSET + 13
def HUD_SCREEN_ANTE_LENGTH          equ 5
def HUD_SCREEN_CHIPS_MULT_OFFSET    equ HUD_SCREEN_OFFSET + 32
def HUD_SCREEN_CHIPS_LENGTH         equ 6
def HUD_SCREEN_MULT_LENGTH          equ 6
def HUD_SCREEN_GOAL_OFFSET          equ HUD_SCREEN_OFFSET + 96
def HUD_SCREEN_GOAL_LENGTH          equ 8
def HUD_SCREEN_SCORE_OFFSET         equ HUD_SCREEN_OFFSET + 128
def HUD_SCREEN_SCORE_LENGTH         equ 8
def HUD_SCREEN_MOVE_OFFSET          equ HUD_SCREEN_OFFSET + 105
def HUD_SCREEN_SELL_OFFSET          equ HUD_SCREEN_OFFSET + 137

InitGame::
    ld a, STATF_LYC
    ld [rSTAT], a
    ld a, HUD_PALETTE_CHANGE_LINE
    ld [rLYC], a
    ld a, IEF_VBLANK | IEF_STAT
    ld [rIE], a
    call InitVariables
    call InitPalette
    call LoadTiles
    call SetupMap
    ret

InitVariables:
    xor a
    ld [wJokerCount], a
    ld [wTarotCount], a
    ld a, JOKER_MAX_DEFAULT
    ld [wJokerMax], a
    ld a, TAROT_MAX_DEFAULT
    ld [wTarotMax], a
    ret

InitPalette:
    ld a, BCPSF_AUTOINC | 0
    ld [rBCPS], a
    ld hl, CardPalette
    ld b, CardPaletteEnd - CardPalette
.bgPaletteLoop
    ld a, [hl+]
    ld [rBCPD], a
    dec b
    jr nz, .bgPaletteLoop
    ld a, OCPSF_AUTOINC | 0
    ld [rOCPS], a
    ld hl, GameObjPalette
    ld b, GameObjPaletteEnd - GameObjPalette
.objPaletteLoop
    ld a, [hl+]
    ld [rOCPD], a
    dec b
    jr nz, .objPaletteLoop
    ret

LoadTiles:
    xor a
    ld [rVBK], a
    call LoadMemory
    ld hl, _VRAM + $1000
    ld de, GameBGTiles
    ld bc, GameBGTilesEnd - GameBGTiles
    call LoadMemory
    ld hl, _VRAM
    ld de, GameObjTiles
    ld bc, GameObjTilesEnd - GameObjTiles
    call LoadMemory
    ret

SetupMap:
    xor a
    ld [rVBK], a
    ; Fill background.
    ld hl, _SCRN0
    ld bc, $01A0
    ld a, CHAR_CLEAR_OFFSET
    call FillMemory
    ld hl, _SCRN0 + $01A0
    ld bc, $0140
    ld a, CHAR_BLACK_OFFSET
    call FillMemory
    call DrawHudTiles
    call DrawScreenAttributes
    ret

DrawHudTiles:
    xor a
    ld [rVBK], a
    ; Hand title.
    ld a, CHAR_HUD_TILE_OFFSET
    ld hl, _SCRN0 + HUD_SCREEN_HAND_OFFSET
    ld b, HUD_SCREEN_HAND_LENGTH
    ld [hl+], a
    dec b
    jr nz, @-2
    ; Ante status.
    ld hl, _SCRN0 + HUD_SCREEN_ANTE_OFFSET
    ld a, CHAR_ANTE_OFFSET
    ld [hl+], a
    inc a
    ld [hl+], a
    ld a, CHAR_NUMBERS_OFFSET + 1
    ld [hl+], a
    ld a, CHAR_DASH_SYMBOL_OFFSET
    ld [hl+], a
    ld a, CHAR_NUMBERS_OFFSET + 8
    ld [hl+], a
    ; Chips & mult score.
    ld hl, _SCRN0 + HUD_SCREEN_CHIPS_MULT_OFFSET
    ld a, CHAR_HUD_TILE_OFFSET
    ld b, HUD_SCREEN_CHIPS_LENGTH
    ld [hl+], a
    dec b
    jr nz, @-2
    ld a, CHAR_MULTIPLIER_OFFSET
    ld [hl+], a
    ld a, CHAR_HUD_TILE_OFFSET
    ld b, HUD_SCREEN_MULT_LENGTH
    ld [hl+], a
    dec b
    jr nz, @-2
    ; Goal score.
    ld hl, _SCRN0 + HUD_SCREEN_GOAL_OFFSET
    ld a, CHAR_ARROW_OFFSET
    ld [hl+], a
    ld a, CHAR_HUD_TILE_OFFSET
    ld b, HUD_SCREEN_GOAL_LENGTH - 1
    ld [hl+], a
    dec b
    jr nz, @-2
    ; Current score.
    ld hl, _SCRN0 + HUD_SCREEN_SCORE_OFFSET
    ld a, CHAR_HUD_TILE_OFFSET
    ld b, HUD_SCREEN_SCORE_LENGTH
    ld [hl+], a
    dec b
    jr nz, @-2
    ; Move.
    ld hl, _SCRN0 + HUD_SCREEN_MOVE_OFFSET
    ld a, CHAR_LETTER_A_OFFSET
    ld [hl+], a
    ld a, CHAR_DPAD_OFFSET
    ld [hl+], a
    inc hl
    ld a, CHAR_LETTER_M_OFFSET
    ld [hl+], a
    ld a, CHAR_LETTER_O_OFFSET
    ld [hl+], a
    ld a, CHAR_LETTER_V_OFFSET
    ld [hl+], a
    ld a, CHAR_LETTER_E_OFFSET
    ld [hl+], a
    ; Sell.
    ld hl, _SCRN0 + HUD_SCREEN_SELL_OFFSET
    ld a, CHAR_SELECT_OFFSET
    ld [hl+], a
    inc a
    ld [hl+], a
    inc hl
    ld a, CHAR_LETTER_S_OFFSET
    ld [hl+], a
    ld a, CHAR_LETTER_E_OFFSET
    ld [hl+], a
    ld a, CHAR_LETTER_L_OFFSET
    ld [hl+], a
    ld [hl+], a
    ret

DrawScreenAttributes:
    ld a, 1
    ld [rVBK], a
    ; Fill background
    ld hl, _SCRN0
    ld bc, $01A0
    ld a, PALETTE_HUD_DEFAULT
    call FillMemory
    ld hl, _SCRN0 + $01A0
    ld bc, $0140
    ld a, PALETTE_HUD_DEFAULT
    call FillMemory
    ; Hand title.
    ld hl, _SCRN0 + HUD_SCREEN_HAND_OFFSET
    ld a, PALETTE_HUD_HAND
    ld b, HUD_SCREEN_HAND_LENGTH
    ld [hl+], a
    dec b
    jr nz, @-2
    ; Chips & mult score.
    ld hl, _SCRN0 + HUD_SCREEN_CHIPS_MULT_OFFSET
    ld a, PALETTE_HUD_CHIPS
    ld b, HUD_SCREEN_CHIPS_LENGTH
    ld [hl+], a
    dec b
    jr nz, @-2
    inc hl
    ld a, PALETTE_HUD_MULT
    ld b, HUD_SCREEN_MULT_LENGTH
    ld [hl+], a
    dec b
    jr nz, @-2
    ret

