include "hardware.inc"
include "assets_def.inc"
include "vblank.inc"

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
def GAME_STATE_SELECT_CARDS         equ 1
def GAME_STATE_LAY_PLAYED_CARDS     equ 2
def GAME_STATE_UPDATE_SCORE         equ 3

section "Game ram", wram0

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
    ld hl, wDeckMask
    ld a, 1
    ld b, DECK_MEMORY_MAX
.maskLoop
    ld [hl+], a
    dec b
    jr nz, .maskLoop
    ret

StartGame::
.loop
    ld a, VBLANK_REQUEST_FLAG_UPDATE_PALETTE
    ld [wVblankRequestFlags], a
    ld a, [wGameState]
    cp GAME_STATE_LAY_HAND
    call z, GameStateLayHand
    halt
    jr .loop
    ret

def SETTINGS equ $2000

GameStateLayHand:
    ld a, [wHandCount]
    ld b, a
    ld hl, wHandCards

    ld de, 0
    ld b, $00
    ld c, 0
    call DrawCard
    halt
    halt

    ld de, 2
    ld b, $11
    ld c, 0
    call DrawCard
    halt
    halt

    ld de, 4
    ld b, $22
    ld c, 0
    call DrawCard
    halt
    halt

    ld de, 6
    ld b, $33
    ld c, CARD_ENHA_WILD
    call DrawCard
    halt
    halt

    ld de, 8
    ld b, 4
    ld c, CARD_ENHA_STEEL
    call DrawCard
    halt
    halt

    ld de, 10
    ld b, 5
    ld c, CARD_ENHA_BONUS
    call DrawCard
    halt
    halt

    ld de, 12
    ld b, 6
    ld c, CARD_ENHA_MULT
    call DrawCard
    halt
    halt

    ld de, 14
    ld b, 7
    ld c, CARD_ENHA_LUCKY
    call DrawCard
    halt
    halt

    ld de, 16
    ld b, 8
    ld c, CARD_ENHA_GOLD
    call DrawCard
    halt
    halt

    ld de, 288
    ld b, $0C
    ld c, CARD_ENHA_WILD
    call DrawCard
    halt
    halt

    ld de, 288 + 2
    ld b, $1C
    ld c, CARD_ENHA_STEEL
    call DrawCard
    halt
    halt

    ld de, 288 + 4
    ld b, $2C
    ld c, CARD_ENHA_BONUS
    call DrawCard
    halt
    halt

    ld de, 288 + 6
    ld b, $3C
    ld c, CARD_ENHA_MULT
    call DrawCard
    halt
    halt

    ld de, 288 + 8
    ld b, $3C
    ld c, CARD_ENHA_LUCKY
    call DrawCard
    halt
    halt

    ld de, 288 + 10
    ld b, $3C
    ld c, CARD_ENHA_GOLD
    call DrawCard
    halt
    halt

    ld a, GAME_STATE_LAY_PLAYED_CARDS
    ld [wGameState], a

    ret

LayHandCard:
    ret
