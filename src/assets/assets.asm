
include "hardware.inc"

section "Tile assets", rom0

CardPalette::
incbin "assets/card.pal"
CardPaletteEnd::

HudPalette::
incbin "assets/hud.pal"
HudPaletteEnd::

GameObjPalette::
incbin "assets/game_obj.pal"
GameObjPaletteEnd::

GameBGTiles::
incbin "assets/game_bg.2bpp"
GameBGTilesEnd::

GameObjTiles::
incbin "assets/game_obj.2bpp"
GameObjTilesEnd::
