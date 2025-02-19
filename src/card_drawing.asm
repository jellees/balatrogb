include "hardware.inc"
include "assets_def.inc"
include "vblank.inc"

export def CARD_RANK_MASK          equ %00001111
export def CARD_SUIT_MASK          equ %00110000
export def CARD_SEAL_MASK          equ %11000000
export def CARD_ENHA_MASK          equ %00001111
export def CARD_EDITION_MASK       equ %11110000

export def CARD_SUIT_SPADES        equ 0
export def CARD_SUIT_CLUBS         equ 1
export def CARD_SUIT_HEARTS        equ 2
export def CARD_SUIT_DIAMONDS      equ 3

export def CARD_ENHA_NONE          equ 0
export def CARD_ENHA_WILD          equ 1
export def CARD_ENHA_STEEL         equ 2
export def CARD_ENHA_BONUS         equ 3
export def CARD_ENHA_MULT          equ 4
export def CARD_ENHA_LUCKY         equ 5
export def CARD_ENHA_GOLD          equ 6

section "Card drawing ram", wram0

section "Card drawing code", rom0

; bc = card attributes.
; de = offset.
;
; A card's attributes are encoded in two bytes:
; 0-3 = rank
; 4-5 = suit
; 6-7 = seal
; 8-11 = enhanchement
; 12-15 = edition
DrawCard::
    ld a, d
    ld [wCardDrawOffset], a
    ld a, e
    ld [wCardDrawOffset+1], a
    ld hl, wCardBuffer

    ld a, b
    and CARD_RANK_MASK
    cp 9
    jp z, DrawFaceCard
    cp 10
    jp z, DrawFaceCard
    cp 11
    jp z, DrawFaceCard
    cp 12
    jp z, DrawAceCard


DrawNumberCard:
    ld de, CardRanks
    call GetByteAtOffset
    ld [hl+], a
    push af

    ; Draw enhancement tile.
    ld de, CardEnha
    ld a, c
    and CARD_ENHA_MASK
    call GetByteAtOffset
    ld [hl+], a
    push af

    ; Draw suit tile.
    ld de, CardSuits
    ld a, b
    and CARD_SUIT_MASK
    swap a
    call GetByteAtOffset
    ld d, a
    ld a, c
    and CARD_ENHA_MASK
    cp CARD_ENHA_WILD
    jr z, .wildCard
    ld a, d
    ld [hl+], a
    ld [hl+], a
    jr .drawEnhaBottomTile
.wildCard:
    ld a, CHAR_CARD_SUIT_WILD
    ld [hl+], a
    ld [hl+], a

.drawEnhaBottomTile:
    pop af
    ld [hl+], a
    pop af
    ld [hl+], a

    ; Draw attributes.
    ld a, b
    swap a
    and CARD_SUIT_MASK >> 4
    ld b, a
    call GetRankPalette
    ld [hl+], a
    push af
    ld a, b
    call GetSuitPalette
    or OAMF_YFLIP | OAMF_XFLIP
    ld [hl+], a
    and OAMF_PALMASK
    ld [hl+], a
    or OAMF_YFLIP | OAMF_XFLIP
    ld [hl+], a
    and OAMF_PALMASK
    ld [hl+], a
    pop af
    or OAMF_YFLIP | OAMF_XFLIP
    ld [hl+], a

    ld a, c
    and CARD_ENHA_MASK
    cp CARD_ENHA_WILD
    jr z, .wildPalette
    cp CARD_ENHA_LUCKY
    jr z, .luckyPalette
    cp CARD_ENHA_MULT
    jr z, .multPalette
    cp CARD_ENHA_NONE
    jp z, FinishDrawing

    ld de, CardEnhaAcePalettes
    call GetByteAtOffset
    ld hl, wCardBuffer + 6 + 4
    ld [hl], a
    ld hl, wCardBuffer + 6 + 1
    or OAMF_YFLIP | OAMF_XFLIP
    ld [hl], a
    jp FinishDrawing

.wildPalette:
    ld hl, wCardBuffer + 6 + 2
    ld a, PALETTE_CARD_WILD
    ld [hl+], a
    inc hl
    ld [hl], a
    jp FinishDrawing

.luckyPalette:
    ld hl, wCardBuffer + 6
    ld d, 6
.luckyPaletteLoop
    ld a, [hl]
    and ~OAMF_PALMASK
    or PALETTE_CARD_LUCKY
    ld [hl+], a
    dec d
    jr nz, .luckyPaletteLoop
    jp FinishDrawing

.multPalette:
    ld hl, wCardBuffer + 6 + 4
    ld a, PALETTE_CARD_MULT_BOTTOM
    ld [hl], a
    ld hl, wCardBuffer + 6 + 1
    ld a, OAMF_YFLIP | OAMF_XFLIP | PALETTE_CARD_MULT_TOP
    ld [hl], a

    jp FinishDrawing


DrawFaceCard:

    jp FinishDrawing


DrawAceCard:
    ld a, CHAR_CARD_RANK_A
    ld [hl+], a

    ; Draw enhancement tile.
    ld de, CardEnha
    ld a, c
    and CARD_ENHA_MASK
    call GetByteAtOffset
    cp CHAR_CARD_ENHA_WILD
    push af
    jr nz, .notWildTile
    ld a, CHAR_CARD_ENHA_NONE
.notWildTile:
    ld [hl+], a

    ; Draw suit tile.
    ld de, CardSuitsAce
    ld a, b
    and CARD_SUIT_MASK
    swap a
    call GetByteAtOffset
    ld d, a
    ld a, c
    and CARD_ENHA_MASK
    cp CARD_ENHA_WILD
    jr z, .wildCard
    ld a, d
    ld [hl+], a
    ld [hl+], a
    jr .drawEnhaBottomTile
.wildCard:
    ld a, CHAR_CARD_SUIT_WILD_ACE
    ld [hl+], a
    ld a, d
    ld [hl+], a

.drawEnhaBottomTile:
    pop af
    ld [hl+], a
    ld a, CHAR_CARD_RANK_A
    ld [hl+], a

    ; Draw ace attributes.
    ld a, b
    swap a
    and CARD_SUIT_MASK >> 4
    ld b, a
    call GetRankPalette
    ld [hl+], a
    push af
    ld a, b
    call GetSuitPalette
    or OAMF_YFLIP | OAMF_XFLIP
    ld [hl+], a
    and OAMF_PALMASK
    ld [hl+], a
    or OAMF_XFLIP
    ld [hl+], a
    and OAMF_PALMASK
    ld [hl+], a
    pop af
    or OAMF_YFLIP | OAMF_XFLIP
    ld [hl+], a

    ld a, c
    and CARD_ENHA_MASK
    cp CARD_ENHA_WILD
    jr z, .wildPalette
    cp CARD_ENHA_LUCKY
    jr z, .luckyPalette
    cp CARD_ENHA_MULT
    jr z, .multPalette
    cp CARD_ENHA_NONE
    jr z, FinishDrawing

    ld de, CardEnhaAcePalettes
    call GetByteAtOffset
    ld hl, wCardBuffer + 6 + 4
    ld [hl], a
    ld hl, wCardBuffer + 6 + 1
    or OAMF_YFLIP | OAMF_XFLIP
    ld [hl], a
    jr FinishDrawing

.wildPalette:
    ld hl, wCardBuffer + 6 + 2
    ld a, PALETTE_CARD_WILD
    ld [hl+], a
    inc hl
    ld [hl], a
    jr FinishDrawing

.luckyPalette:
    ld hl, wCardBuffer + 6
    ld d, 6
.luckyPaletteLoop
    ld a, [hl]
    and ~OAMF_PALMASK
    or PALETTE_CARD_LUCKY
    ld [hl+], a
    dec d
    jr nz, .luckyPaletteLoop
    jr FinishDrawing

.multPalette:
    ld hl, wCardBuffer + 6 + 4
    ld a, PALETTE_CARD_MULT_BOTTOM
    ld [hl], a
    ld hl, wCardBuffer + 6 + 1
    ld a, OAMF_YFLIP | OAMF_XFLIP | PALETTE_CARD_MULT_TOP
    ld [hl], a


FinishDrawing:
    ld hl, wVblankRequestFlags
    ld a, [hl]
    or VBLANK_REQUEST_FLAG_DRAW_CARD | VBLANK_REQUEST_FLAG_UPDATE_PALETTE
    ld [hl], a
    ret


GetRankPalette:
    cp CARD_SUIT_SPADES
    jr z, .spades
    cp CARD_SUIT_CLUBS
    jr z, .clubs
    ld a, PALETTE_CARD_RED_NUMBERS
    ret
.spades:
    ld a, PALETTE_CARD_SPADES
    ret
.clubs:
    ld a, PALETTE_CARD_CLUBS
    ret


GetSuitPalette:
    cp CARD_SUIT_SPADES
    jr z, .spades
    cp CARD_SUIT_CLUBS
    jr z, .clubs
    ld a, PALETTE_CARD_HEARTS ; & PALETTE_CARD_DIAMONDS
    ret
.spades:
    ld a, PALETTE_CARD_SPADES
    ret
.clubs:
    ld a, PALETTE_CARD_CLUBS
    ret

; a = offset;
; de = address.
GetByteAtOffset:
    add e
    ld e, a
    ld a, d
    adc 0
    ld d, a
    ld a, [de]
    ret

CardRanks:
    db CHAR_CARD_RANK_2
    db CHAR_CARD_RANK_3
    db CHAR_CARD_RANK_4
    db CHAR_CARD_RANK_5
    db CHAR_CARD_RANK_6
    db CHAR_CARD_RANK_7
    db CHAR_CARD_RANK_8
    db CHAR_CARD_RANK_9
    db CHAR_CARD_RANK_10
    db CHAR_CARD_RANK_J
    db CHAR_CARD_RANK_Q
    db CHAR_CARD_RANK_K
    db CHAR_CARD_RANK_A

CardSuits:
    db CHAR_CARD_SUIT_SPADES
    db CHAR_CARD_SUIT_CLUBS
    db CHAR_CARD_SUIT_HEARTS
    db CHAR_CARD_SUIT_DIAMONDS

CardSuitsFace:
    db CHAR_CARD_SUIT_SPADES_FACE
    db CHAR_CARD_SUIT_CLUBS_FACE
    db CHAR_CARD_SUIT_HEARTS_FACE
    db CHAR_CARD_SUIT_DIAMONDS_FACE

CardSuitsAce:
    db CHAR_CARD_SUIT_SPADES_ACE
    db CHAR_CARD_SUIT_CLUBS_ACE
    db CHAR_CARD_SUIT_HEARTS_ACE
    db CHAR_CARD_SUIT_DIAMONDS_ACE

CardEnha:
    db CHAR_CARD_ENHA_NONE
    db CHAR_CARD_ENHA_WILD
    db CHAR_CARD_ENHA_STEEL
    db CHAR_CARD_ENHA_BONUS
    db CHAR_CARD_ENHA_MULT
    db CHAR_CARD_ENHA_LUCKY
    db CHAR_CARD_ENHA_GOLD

CardEnhaFace:
    db CHAR_CARD_ENHA_NONE_FACE
    db CHAR_CARD_ENHA_WILD_FACE
    db CHAR_CARD_ENHA_STEEL_FACE
    db CHAR_CARD_ENHA_BONUS_FACE
    db CHAR_CARD_ENHA_MULT_FACE
    db CHAR_CARD_ENHA_LUCKY_FACE
    db CHAR_CARD_ENHA_GOLD_FACE

CardEnhaAcePalettes:
    db PALETTE_CARD_RED_NUMBERS
    db PALETTE_CARD_WILD
    db PALETTE_CARD_STEEL
    db PALETTE_CARD_BONUS
    db PALETTE_CARD_MULT_TOP
    db PALETTE_CARD_LUCKY
    db PALETTE_CARD_GOLD
