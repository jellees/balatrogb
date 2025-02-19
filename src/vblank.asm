include "hardware.inc"
include "assets_def.inc"
include "vblank.inc"

section "Vblank ram", wram0

wVblankRequestFlags::       ds 1

wCardRemoveOffset:          ds 1
wCardDrawOffset::           ds 2
wCardBuffer::               ds 6 * 2        ; There are six tiles for each card, double for attributes.

section "Vblank code", rom0

ExecVBlank::
	push af
	push hl
	push bc

.updatePalette:
    ld a, [wVblankRequestFlags]
    and VBLANK_REQUEST_FLAG_UPDATE_PALETTE
    jr z, .removeCard
    
    ld a, BCPSF_AUTOINC | 0
    ld [rBCPS], a
    ld hl, CardPalette
    ld b, CardPaletteEnd - CardPalette
.bgPaletteLoop
    ld a, [hl+]
    ld [rBCPD], a
    dec b
    jr nz, .bgPaletteLoop

.removeCard:
    ld a, [wVblankRequestFlags]
    and VBLANK_REQUEST_FLAG_REMOVE_CARD
    jr z, .drawCard

    xor a
    ld [rVBK], a
    ld hl, _SCRN0
    ld b, 0
    ld a, [wCardRemoveOffset]
    ld c, a
    add hl, bc
    ld bc, $1F
    ld a, CHAR_CLEAR_OFFSET
    ld [hl+], a
    ld [hl], a
    add hl, bc
    ld [hl+], a
    ld [hl], a
    add hl, bc
    ld [hl+], a
    ld [hl], a

.drawCard:
    ld a, [wVblankRequestFlags]
    and VBLANK_REQUEST_FLAG_DRAW_CARD
    jr z, .end

    push de

    xor a
    ld [rVBK], a
    ld hl, _SCRN0
    ld a, [wCardDrawOffset]
    ld b, a
    ld a, [wCardDrawOffset+1]
    ld c, a
    add hl, bc
    push hl
    ld bc, $1F
    ld de, wCardBuffer
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl], a
    add hl, bc
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl], a
    add hl, bc
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl], a
    inc de
    pop hl
    ld a, 1
    ld [rVBK], a
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl], a
    add hl, bc
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl], a
    add hl, bc
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    ld a, [de]
    ld [hl], a

    pop de

.end:
    xor a
    ld [wVblankRequestFlags], a

    pop bc
    pop hl
    pop af

    reti
