include "hardware.inc"

section "Random ram", WRAM0

; Stored as big endian!
wSeed:                  ds 2

section "Random code", ROM0

; ------------------------------------
; Initialize the random generator.
; bc = seed.
; ------------------------------------
InitPRNG::

    ld hl, wSeed
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl], a

    ret

; ------------------------------------
; Returns a random number between 1 and 255
; ------------------------------------
PRNG::
    
    ld hl, wSeed
    ld b, 8
    ld a, [hl+]

.loop
    sla a
    rl [hl]
    jr nc, .end
    xor $39

.end
    dec b
    jr nz, .loop
    dec hl
    ld [hl], a

    ret
