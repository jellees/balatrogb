
include "hardware.inc"

section "Utility ram", wram0

wInput::				ds 1
wInputUp::				ds 1
wInputDown::			ds 1

section "Utility code", rom0
    

; -----------------------------
; loads memory to another destination.
; hl = destination memory
; de = source data
; bc = data length
; -----------------------------
LoadMemory::

    inc b 
    inc c 
    jr .skip

.loop
    ld	a,[de]
    inc	de
    ld	[hl+],a
    
.skip
    dec	c
    jr	nz, .loop
    dec	b 
    jr	nz, .loop
    
    ret	
    
    
; -----------------------------
; loads memory to another destination. is only able to transfer 255 bytes per call.
; hl = destination memory
; de = source data
; c = data length
; -----------------------------
LoadMemoryFast::

    inc c 
    jr .skip

.loop
    ld	a,[de]
    inc	de
    ld	[hl+],a
    
.skip
    dec	c
    jr	nz, .loop
    
    ret
    
    
; ----------------------------- 
; Loads memory to the vram safely. Safe for vram operations. 
;
; hl = destination memory
;
; de = source data
;
; bc = data length
; -----------------------------
LoadMemoryVram::

    inc b 
    inc c 
    jr .skip

.loop
    ld      a,[rSTAT]       ; <---+
    and     STATF_BUSY      ;     |
    jr      nz, @-4     	; ----+

    ld	a,[de]
    inc	de
    ld	[hl+],a
    
.skip
    dec	c
    jr	nz, .loop
    dec	b 
    jr	nz, .loop
    
    ret	
    
    
; -----------------------------
; loads memory to a specified destination in groups of 16 (faster).
; hl = destination memory
; de = destination memory
; c = data length
; -----------------------------
LoadMemory16::	

    ld a, [hl+]	
    ld [de], a 	
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    ld a, [hl+]
    ld [de], a 
    inc e 
    
    dec c
    jr nz, LoadMemory16
        
    ret
    
    
; -----------------------------
; clears memory at the specified destination.
; hl = destination memory
; bc = data length
; -----------------------------
ClearMemory::

    xor a 

    inc b 
    inc c 
    jr .skip

.loop
    ld	[hl+],a

.skip
    dec	c
    jr	nz, .loop
    dec	b
    jr	nz, .loop
    
    ret

    
; -----------------------------
; fills memory with a byte at the specified destination. safe for vram operations.
; hl = destination memory
; bc = data length
; a = byte to fill with 
; -----------------------------
FillMemory::

    inc b 
    inc c 
    jr .skip

.loop
    push af

    ld      a,[rSTAT]       ; <---+
    and     STATF_BUSY      ;     |
    jr      nz, @-4     	; ----+
    
    pop af 

    ld [hl+], a 
    
.skip
    dec	c
    jr	nz, .loop
    dec	b
    jr	nz, .loop
    
    ret	
    
    
; -----------------------------
; Stops the LCD.
; -----------------------------
StopLCD::

    xor a
    ld [rIE], a 
    
.loop
    ld	a,[rLY]				; load current refresh line
    cp	145
    jr	nz, .loop			; if its not 145, then loop
    
    xor	a
    ld	[rLCDC],a			; shut everything off
    
    ret

; -----------------------------
; Synchronious fade in.
; 
; b = fade delay in frames
; -----------------------------
FadeIn::

    xor a 
.loop1:
    halt 
    inc a
    cp b
    jr nz,.loop1
    
    ld a, %00000001
    ld [rBGP], a
    xor a 

.loop2:
    halt
    inc a
    cp b 
    jr nz,.loop2
    
    ld a, %00000110
    ld [rBGP], a
    xor a 

.loop3:
    halt
    inc a 
    cp b	
    jr nz,.loop3
    
    ld a, %00011011
    ld [rBGP], a
    
    ret
    
; -----------------------------
; Synchronious fade out.
; 
; b = fade delay
; -----------------------------
FadeOut::

    ld a, $FF
    
    ld	c, 3
.loop
    halt 
    inc a 
    cp	b
    jp	nz, .loop

    ld a, [rBGP]
    srl a 
    srl a
    ld [rBGP], a
    
    xor a
    dec	c
    jr nz, .loop
    
    ret
    
    
; -----------------------------
; Gets the input and stores it.
; This code comes from the tuff game.
; -----------------------------
PollInput::
    
    ; store old state into d and reset new state
    ld a, [wInput]
    ld d, a
    xor a
    ld [wInput], a 
    
    ; toggle d-pad lines on
    ld      a,%00100000
    ld      [rP1],a

    ; read dpad data
    ld      a,[rP1]
    ld      a,[rP1]
    ld      a,[rP1]
    ld      a,[rP1]
    and     %00001111
    swap    a               
    ld      b,a ; store d-pad data into the high bits

    ; toggle button lines on
    ld      a,%00010000
    ld      [rP1],a
    
    ; read button data
    ld      a,[rP1]
    ld      a,[rP1]
    ld      a,[rP1]
    ld      a,[rP1]
    ld      a,[rP1]
    ld      a,[rP1]
    and     %00001111; just keep the button data
    or      b; combine with dpad data
    cpl     ; invert the data so active buttons are read as 1 

    ; store new state
    ld      [wInput],a
    ld      c,a ; store a copy of the current button state
            
    ; reset the joypad by activating both buttons and dpad
    ld      a,%00110000
    ld      [rP1],a

    ; get the buttons which were initially pressed on this frame
    ld      a,c; load the current state
    xor     d; first XOR with the old state to get the state difference
    and     c; now AND with the current state to only get inputs
    ld      [wInputDown],a

    ; get the buttons released on this frame
    ld      a,c ; load the current state
    xor     d; first XOR with the old state to get the state difference
    and     d; now AND with the current state to only get inputs 
    ld      [wInputUp],a

    ; a = [Down][Up][Left][Right][Start][Select][B][A]
    
    ret 
    
    