if !def(ASSETS_DEF_INC)
def ASSETS_DEF_INC equ 1

def CHAR_CARD_RANK_2                equ 0
def CHAR_CARD_RANK_3                equ 1
def CHAR_CARD_RANK_4                equ 2
def CHAR_CARD_RANK_5                equ 3
def CHAR_CARD_RANK_6                equ 4
def CHAR_CARD_RANK_7                equ 5
def CHAR_CARD_RANK_8                equ 6
def CHAR_CARD_RANK_9                equ 7
def CHAR_CARD_RANK_10               equ 8
def CHAR_CARD_RANK_J                equ 9
def CHAR_CARD_RANK_Q                equ 10
def CHAR_CARD_RANK_K                equ 11
def CHAR_CARD_RANK_A                equ 12

def CHAR_CARD_RANK_J_UNKNOWN        equ 30
def CHAR_CARD_RANK_Q_UNKNOWN        equ 31
def CHAR_CARD_RANK_K_UNKNOWN        equ 32

def CHAR_CARD_SUIT_SPADES_FACE      equ 13
def CHAR_CARD_SUIT_CLUBS_FACE       equ 14
def CHAR_CARD_SUIT_HEARTS_FACE      equ 34
def CHAR_CARD_SUIT_DIAMONDS_FACE    equ 35

def CHAR_CARD_SUIT_SPADES           equ 22
def CHAR_CARD_SUIT_CLUBS            equ 23
def CHAR_CARD_SUIT_HEARTS           equ 24
def CHAR_CARD_SUIT_DIAMONDS         equ 25

def CHAR_CARD_SUIT_SPADES_ACE       equ 26
def CHAR_CARD_SUIT_CLUBS_ACE        equ 27
def CHAR_CARD_SUIT_HEARTS_ACE       equ 28
def CHAR_CARD_SUIT_DIAMONDS_ACE     equ 29

def CHAR_CARD_SUIT_WILD_FACE        equ 15
def CHAR_CARD_SUIT_WILD             equ 16
def CHAR_CARD_SUIT_WILD_ACE         equ 88

def CHAR_CARD_ENHA_WILD             equ 37
def CHAR_CARD_ENHA_STEEL            equ 17
def CHAR_CARD_ENHA_GOLD             equ 17
def CHAR_CARD_ENHA_BONUS            equ 18
def CHAR_CARD_ENHA_MULT             equ 19
def CHAR_CARD_ENHA_LUCKY            equ 20
def CHAR_CARD_ENHA_NONE             equ 33
def CHAR_CARD_ENHA_NONE_FACE        equ 36
def CHAR_CARD_ENHA_WILD_FACE        equ CHAR_CARD_ENHA_NONE_FACE
def CHAR_CARD_ENHA_STEEL_FACE       equ 38
def CHAR_CARD_ENHA_GOLD_FACE        equ 38
def CHAR_CARD_ENHA_BONUS_FACE       equ 39
def CHAR_CARD_ENHA_MULT_FACE        equ 40
def CHAR_CARD_ENHA_LUCKY_FACE       equ 41

def CHAR_CARD_STONE_TOP             equ 89
def CHAR_CARD_STONE_MIDDLE          equ 90
def CHAR_CARD_STONE_BOTTOM          equ 91

def CHAR_CLEAR_OFFSET           equ $15
def CHAR_BLACK_OFFSET           equ $3B
def CHAR_HUD_TILE_OFFSET        equ $39
def CHAR_NUMBERS_OFFSET         equ $49
def CHAR_ANTE_OFFSET            equ $47
def CHAR_ARROW_OFFSET           equ $53
def CHAR_MULTIPLIER_OFFSET      equ $54
def CHAR_DASH_SYMBOL_OFFSET     equ $57
def CHAR_CASH_SYMBOL_OFFSET     equ $55
def CHAR_DPAD_OFFSET            equ $56
def CHAR_SELECT_OFFSET          equ $37

def CHAR_LETTER_A_OFFSET        equ 42
def CHAR_LETTER_B_OFFSET        equ 43
def CHAR_LETTER_C_OFFSET        equ 44
def CHAR_LETTER_D_OFFSET        equ 45
def CHAR_LETTER_E_OFFSET        equ 46
def CHAR_LETTER_F_OFFSET        equ 47
def CHAR_LETTER_G_OFFSET        equ 48
def CHAR_LETTER_H_OFFSET        equ 49
def CHAR_LETTER_I_OFFSET        equ 50
def CHAR_LETTER_J_OFFSET        equ 51
def CHAR_LETTER_K_OFFSET        equ 52
def CHAR_LETTER_L_OFFSET        equ 53
def CHAR_LETTER_M_OFFSET        equ 54
def CHAR_LETTER_N_OFFSET        equ 58
def CHAR_LETTER_O_OFFSET        equ 73
def CHAR_LETTER_P_OFFSET        equ 60
def CHAR_LETTER_Q_OFFSET        equ 61
def CHAR_LETTER_R_OFFSET        equ 62
def CHAR_LETTER_S_OFFSET        equ 63
def CHAR_LETTER_T_OFFSET        equ 64
def CHAR_LETTER_U_OFFSET        equ 65
def CHAR_LETTER_V_OFFSET        equ 66
def CHAR_LETTER_W_OFFSET        equ 67
def CHAR_LETTER_X_OFFSET        equ 68
def CHAR_LETTER_Y_OFFSET        equ 69
def CHAR_LETTER_Z_OFFSET        equ 70

def PALETTE_CARD_RED_NUMBERS    equ 0
def PALETTE_CARD_FACE           equ 3
def PALETTE_CARD_SPADES         equ 1
def PALETTE_CARD_CLUBS          equ 2
def PALETTE_CARD_DIAMONDS       equ 3
def PALETTE_CARD_HEARTS         equ 3
def PALETTE_CARD_BONUS          equ 3
def PALETTE_CARD_MULT_TOP       equ 0
def PALETTE_CARD_MULT_BOTTOM    equ 1
def PALETTE_CARD_WILD           equ 3
def PALETTE_CARD_LUCKY          equ 4
def PALETTE_CARD_STONE          equ 1
def PALETTE_CARD_STEEL          equ 1
def PALETTE_CARD_GOLD           equ 4

def PALETTE_HUD_HAND            equ 0
def PALETTE_HUD_CHIPS           equ 1
def PALETTE_HUD_MULT            equ 2
def PALETTE_HUD_MONEY           equ 3
def PALETTE_HUD_DEFAULT         equ 4
def PALETTE_HUD_GOAL            equ 5
def PALETTE_HUD_MOVE_SELL       equ 6

endc
