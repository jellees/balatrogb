
INCLUDE "hardware.inc"
    rev_Check_hardware_inc 4.0
    
section "Interrupt VBlank", ROM0[$40]
    jp ExecVBlank

section	"Interrupt stat", ROM0[$48]
    jp ExecHBlank

SECTION "Header", ROM0[$100]

    ; This is your ROM's entry point
    ; You have 4 bytes of code to do... something
    di
    jp EntryPoint

    ; Make sure to allocate some space for the header, so no important
    ; code gets put there and later overwritten by RGBFIX.
    ; RGBFIX is designed to operate over a zero-filled header, so make
    ; sure to put zeros regardless of the padding value. (This feature
    ; was introduced in RGBDS 0.4.0, but the -MG etc flags were also
    ; introduced in that version.)
    ds $150 - @, 0

SECTION "Entry point", ROM0

EntryPoint:
    ld sp, $E000
    
    call StopLCD
    
    call DoubleSpeedMode
    call InitHardware
    ld bc, $1258
    call InitPRNG
    call InitGame

    ; ld bc, $0300
    ; ld hl, _SCRN0 + $A0 + 4
    ; call DrawCard

    ; ld bc, $0401
    ; ld hl, _SCRN0 + $A0 + 7
    ; call DrawCard

    ; ld bc, $0802
    ; ld hl, _SCRN0 + $A0 + 10
    ; call DrawCard

    ; ld bc, $0A03
    ; ld hl, _SCRN0 + $A0 + 13
    ; call DrawCard
    
    ei
    ld a, LCDCF_ON | LCDCF_OBJ8 | LCDCF_OBJON | LCDCF_BGON
    ld [rLCDC], a
    
    call StartGame

.loop
    halt 
    jr .loop

InitHardware:
    ld hl, _VRAM 
    ld bc, $2000
    call ClearMemory
    
    ld hl, _RAM
    ld bc, $1FF0
    call ClearMemory
    
    ld hl, _OAMRAM
    ld bc, $00A0
    call ClearMemory

    ld	hl,_HRAM
    ld	bc,$007B
    call ClearMemory	
    
    xor a
    ld	[rSB], a			; $FF01 Serial Transfer Data
    ld	[rSC], a			; $FF02 Serial IO Control
    ld	[rTIMA], a			; $FF05 Timer Counter
    ld	[rTMA], a			; $FF06 Timer Modulo
    ld	[rTAC], a			; $FF07 Timer Control
    ld	[rIF], a			; $FF0F Interrupt Flag
    ld	[rAUDENA], a		; $FF26	Sound On / Off
    ld	[rSCY], a			; $FF42	Screen Scroll Y
    ld	[rSCX], a			; $FF43	Screen Scroll X
    ret

ExecVBlank:
	push af
	push hl
	push bc

    ld a, BCPSF_AUTOINC | 0
    ld [rBCPS], a
    ld hl, CardPalette
    ld b, CardPaletteEnd - CardPalette
.bgPaletteLoop
    ld a, [hl+]
    ld [rBCPD], a
    dec b
    jr nz, .bgPaletteLoop

    pop bc
    pop hl
    pop af

    reti

ExecHBlank:
	push af
	push hl
	push bc

    ld a, BCPSF_AUTOINC | 0
    ldh [rBCPS], a

    ld hl, HudPalette
    ld bc, (STATF_LCD << 8) | LOW(rBCPD)
.waitHBlank:
    ldh a, [rSTAT]
    and b
    jr nz, .waitHBlank
    
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a

.waitHBlank2:
    ldh a, [rSTAT]
    and b
    jr nz, .waitHBlank2
    
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a
    ld a, [hl+]
    ldh [c], a

    pop bc
    pop hl
    pop af
    reti

DoubleSpeedMode:
    ld a,[rKEY1]
    rlca                ; Is GBC already in double speed mode?
    ret c               ; yes, exit
    ld hl, rIE
    ld a, [hl]
    push af
    xor a
    ld [hl], a          ;disable interrupts
    ld [rIF], a
    ld a, $30
    ld [rP1], a
    ld a, 1
    ld [rKEY1], a
    stop
    nop
    pop af
    ld [hl], a
    ret

; Experimental, please delete
; b = rank
; c = color
; hl = position in vram
DrawCard:
    push bc
    push de
    push hl

    push hl
    xor a
    ld [rVBK], a

    dec b
    ld [hl], b
    inc hl
    ld a, $12
    ld [hl], a
    ld de, $1F
    add hl, de
    ld a, c
    add $0e
    ld [hl+], a
    ld [hl], a
    add hl, de
    ld a, $12
    ld [hl], a
    inc hl
    ld a, b
    ld [hl], a

    pop hl
    ld a, 1 
    ld [rVBK], a

    ld a, c
    and 1 ; Select palette 1 if number is uneven.
    xor 1
    ld [hl+], a
    ld [hl], a
    add hl, de
    ld [hl+], a
    or OAMF_YFLIP | OAMF_XFLIP
    ld [hl], a
    add hl, de
    ld [hl+], a
    ld [hl], a

    pop hl
    pop de
    pop bc
    ret
