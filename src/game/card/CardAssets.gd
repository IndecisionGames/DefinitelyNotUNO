extends Node

var card_0_asset = preload("res://assets/cards/0.png")
var card_1_asset = preload("res://assets/cards/1.png")
var card_2_asset = preload("res://assets/cards/2.png")
var card_3_asset = preload("res://assets/cards/3.png")
var card_4_asset = preload("res://assets/cards/4.png")
var card_5_asset = preload("res://assets/cards/5.png")
var card_6_asset = preload("res://assets/cards/6.png")
var card_7_asset = preload("res://assets/cards/7.png")
var card_8_asset = preload("res://assets/cards/8.png")
var card_9_asset = preload("res://assets/cards/9.png")
var card_skip_asset = preload("res://assets/cards/skip.png")
var card_reverse_asset = preload("res://assets/cards/NoU.png")
var card_plus2_asset = preload("res://assets/cards/plus2.png")
var card_plus4_asset = preload("res://assets/cards/plus4.png")
var card_wild_asset = preload("res://assets/cards/wild.png")
var card_back_asset = preload("res://assets/cards/back.png")

func card_asset(type) -> Texture2D:
	match type:
		Types.card_type.CARD_0:
			return card_0_asset
		Types.card_type.CARD_1:
			return card_1_asset
		Types.card_type.CARD_2:
			return card_2_asset
		Types.card_type.CARD_3:
			return card_3_asset
		Types.card_type.CARD_4:
			return card_4_asset
		Types.card_type.CARD_5:
			return card_5_asset
		Types.card_type.CARD_6:
			return card_6_asset
		Types.card_type.CARD_7:
			return card_7_asset
		Types.card_type.CARD_8:
			return card_8_asset
		Types.card_type.CARD_9:
			return card_9_asset
		Types.card_type.CARD_SKIP:
			return card_skip_asset
		Types.card_type.CARD_REVERSE:
			return card_reverse_asset
		Types.card_type.CARD_PLUS2:
			return card_plus2_asset
		Types.card_type.CARD_PLUS4:
			return card_plus4_asset
		Types.card_type.CARD_WILD:
			return card_wild_asset
	return null

var normal_border = StyleBoxFlat.new()
var playable_border = StyleBoxFlat.new()

func _ready():
	normal_border.bg_color = Color(0,0,0,0)
	normal_border.border_color = Values.normal
	normal_border.set_border_width_all(2)
	normal_border.set_corner_radius(CORNER_TOP_LEFT, 15)
	normal_border.set_corner_radius(CORNER_TOP_RIGHT, 15)
	normal_border.set_corner_radius(CORNER_BOTTOM_LEFT, 12)
	normal_border.set_corner_radius(CORNER_BOTTOM_RIGHT, 13)

	playable_border.bg_color = Color(0,0,0,0)
	playable_border.border_color = Values.playable
	playable_border.set_border_width_all(5)
	playable_border.set_corner_radius(CORNER_TOP_LEFT, 15)
	playable_border.set_corner_radius(CORNER_TOP_RIGHT, 15)
	playable_border.set_corner_radius(CORNER_BOTTOM_LEFT, 12)
	playable_border.set_corner_radius(CORNER_BOTTOM_RIGHT, 13)
