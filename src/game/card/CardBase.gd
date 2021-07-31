extends Node
# The following code should be identical in both the client and server

var colour: int
var type: int

func setup(card_colour, card_type):
	self.colour = card_colour
	self.type = card_type

func is_in(cards):
	for i in range(cards.size()):
		if colour == cards[i].colour and type == cards[i].type:
			return i
	return -1

func _to_string():
	var colour_string = ""
	match self.colour:
		Types.card_colour.RED:
			colour_string = "red"
		Types.card_colour.GREEN:
			colour_string = "green"
		Types.card_colour.BLUE:
			colour_string = "blue"
		Types.card_colour.YELLOW:
			colour_string = "yellow"
		Types.card_colour.WILD:
			colour_string = "wild"
	return "%s %s" % [colour_string, type()]

func type() -> String:
	match self.type:
		Types.card_type.CARD_0:
			return "0"
		Types.card_type.CARD_1:
			return "1"
		Types.card_type.CARD_2:
			return "2"
		Types.card_type.CARD_3:
			return "2"
		Types.card_type.CARD_4:
			return "4"
		Types.card_type.CARD_5:
			return "5"
		Types.card_type.CARD_6:
			return "6"
		Types.card_type.CARD_7:
			return "7"
		Types.card_type.CARD_8:
			return "8"
		Types.card_type.CARD_9:
			return "9"
		Types.card_type.CARD_SKIP:
			return "Skip"
		Types.card_type.CARD_REVERSE:
			return "REVERSE"
		Types.card_type.CARD_PLUS2:
			return "+2"
		Types.card_type.CARD_PLUS4:
			return "+4"
		Types.card_type.CARD_WILD:
			return "Wild"
	return ""

func card_asset() -> Texture:
	match self.type:
		Types.card_type.CARD_0:
			return CardAssets.card_0_asset
		Types.card_type.CARD_1:
			return CardAssets.card_1_asset
		Types.card_type.CARD_2:
			return CardAssets.card_2_asset
		Types.card_type.CARD_3:
			return CardAssets.card_3_asset
		Types.card_type.CARD_4:
			return CardAssets.card_4_asset
		Types.card_type.CARD_5:
			return CardAssets.card_5_asset
		Types.card_type.CARD_6:
			return CardAssets.card_6_asset
		Types.card_type.CARD_7:
			return CardAssets.card_7_asset
		Types.card_type.CARD_8:
			return CardAssets.card_8_asset
		Types.card_type.CARD_9:
			return CardAssets.card_9_asset
		Types.card_type.CARD_SKIP:
			return CardAssets.card_skip_asset
		Types.card_type.CARD_REVERSE:
			return CardAssets.card_reverse_asset
		Types.card_type.CARD_PLUS2:
			return CardAssets.card_plus2_asset
		Types.card_type.CARD_PLUS4:
			return CardAssets.card_plus4_asset
		Types.card_type.CARD_WILD:
			return CardAssets.card_wild_asset
	return null
