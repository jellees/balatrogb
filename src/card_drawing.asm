include "hardware.inc"
include "assets_def.inc"
include "vblank.inc"

section "Card drawing ram", wram0

section "Card drawing code", rom0

; a = offset.
; bc = card attributes.
;
; A card's attributes are encoded in two bytes:
; 0-3 = rank
; 4-5 = suit
; 6-7 = seal
; 8-11 = enhanchement
; 12-15 = edition
DrawCard::
    ld [wCardDrawOffset], a
    ld hl, wCardBuffer

    ld de, CardRanks
    ld a, b
    and $0f
    add e
    ld e, a
    ld a, d
    adc 0
    ld d, a
    ld a, [de]
    ld [hl+], a
    push af

    ld a, b
    call GetEnhanchmentTile
    ld [hl+], a
    push af

    ld a, b
    call GetSuitTile
    ld [hl+], a
    ld [hl+], a

    pop af
    ld [hl+], a

    pop af
    ld [hl+], a

    call DrawAttributes

    ld hl, wVblankRequestFlags
    ld a, [hl]
    or VBLANK_REQUEST_FLAG_DRAW_CARD | VBLANK_REQUEST_FLAG_UPDATE_PALETTE
    ld [hl], a
    ret

DrawAttributes:
    ld a, 3
    ld [hl+], a
    ld a, OAMF_YFLIP | OAMF_XFLIP | 3
    ld [hl+], a
    ld a, 3
    ld [hl+], a
    ld a, b
    and $0F
    cp 12
    jr z, .aceCard
    ld a, OAMF_YFLIP | OAMF_XFLIP | 3
    jr .write
.aceCard:
    ld a, OAMF_XFLIP | 3
.write:
    ld [hl+], a
    ld a, 3
    ld [hl+], a
    ld a, OAMF_YFLIP | OAMF_XFLIP | 3
    ld [hl+], a
    ret

GetEnhanchmentTile:
    and $0f
    cp 9
    jr z, .faceCard
    cp 10
    jr z, .faceCard
    cp 11
    jr z, .faceCard
    ld a, CHAR_CARD_ENHA_NONE
    ret
.faceCard:
    ld a, CHAR_CARD_ENHA_NONE_FACE
    ret

GetSuitTile:
    and $0f
    cp 9
    jr z, .faceCard
    cp 10
    jr z, .faceCard
    cp 11
    jr z, .faceCard
    cp 12
    jr z, .aceCard
    ld de, CardSuits
    jr .retreive
.faceCard:
    ld de, CardSuitsFace
    jr .retreive
.aceCard:
    ld de, CardSuitsAce
.retreive:
    swap a
    and $0f
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
