include "hardware.inc"
include "assets_def.inc"

def CARD_MEMORY_SIZE                equ 2

def DECK_MEMORY_MAX                 equ 64

def HAND_MEMORY_MAX                 equ 16
def PLAY_MEMORY_MAX                 equ 5

def HAND_DEFAULT                    equ 6
def PLAYS_DEFAULT                   equ 3
def DISCARDS_DEFAULT                equ 3

def JOKER_COUNT_SCREEN_OFFSET       equ 1
def JOKER_MAX_DEFAULT               equ 5
def TAROT_COUNT_SCREEN_OFFSET       equ 14
def TAROT_MAX_DEFAULT               equ 2

def HUD_PALETTE_CHANGE_LINE         equ 102

def GAME_STATE_LAY_HAND             equ 0
def GAME_STATE_SELECT_CARDS         equ 0
def GAME_STATE_LAY_PLAYED_CARDS     equ 0
def GAME_STATE_UPDATE_SCORE         equ 0

section "Game ram", wram0

; Card encoding. 2 bytes.
; Bits:
; 0-3 = rank
; 4-5 = suit
; 6-7 = seal
; 8-11 = enhanchement
; 12-15 = edition

wDeck:              ds CARD_MEMORY_SIZE * DECK_MEMORY_MAX
wDeckMask:          ds DECK_MEMORY_MAX

; How long the current hand is.
wHandCount:         ds 1
wHandCards:         ds CARD_MEMORY_SIZE * HAND_MEMORY_MAX
; A mask to see which cards are actually there or not.
wHandCardsMask:     ds HAND_MEMORY_MAX
; How many cards are played.
wPlayCount:         ds 1
wPlayCards:         ds CARD_MEMORY_SIZE * PLAY_MEMORY_MAX

wJokerCount:        ds 1
wJokerMax:          ds 1
wTarotCount:        ds 1
wTarotMax:          ds 1

wPlays:             ds 1
wDiscards:          ds 1

wAnte:              ds 1

wGameState:         ds 1

section "Game code", rom0

InitGame::
    ld a, STATF_LYC
    ld [rSTAT], a
    ld a, HUD_PALETTE_CHANGE_LINE
    ld [rLYC], a
    ld a, IEF_VBLANK | IEF_STAT
    ld [rIE], a
    call InitVariables
    call DrawInitialScreen
    call InitDeck
    ret

InitVariables:
    xor a
    ld [wPlayCount], a
    ld [wJokerCount], a
    ld [wTarotCount], a
    ld a, JOKER_MAX_DEFAULT
    ld [wJokerMax], a
    ld a, TAROT_MAX_DEFAULT
    ld [wTarotMax], a
    ld a, PLAYS_DEFAULT
    ld [wPlays], a
    ld a, DISCARDS_DEFAULT
    ld [wDiscards], a
    ld a, HAND_DEFAULT
    ld [wHandCount], a
    ld a, 1
    ld [wAnte], a
    ld a, GAME_STATE_LAY_HAND
    ld [wGameState], a
    ret

InitDeck:
    ld hl, wDeck
    xor a
    ld b, a
.loop
    ld a, b
    ld [hl+], a
    ld [hl], 0
    inc hl
    inc b
    ld a, b
    and %1111
    cp 13
    jr nz, .loop
    ld a, b
    add 3
    ld b, a
    cp $40
    jr nz, .loop
    ret


StartGame::
.loop
    ld a, [wGameState]
    cp GAME_STATE_LAY_HAND
    jr z, GameStateLayHand
    halt
    jr .loop
    ret

GameStateLayHand:
    ld a, [wHandCount]
    ld b, a
    ld hl, wHandCards
    ret
