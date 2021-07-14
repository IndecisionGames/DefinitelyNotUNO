extends Node

const red = Color(0.7,0.13,0.13,1)
const green = Color(0.18,0.55,0.34,1)
const yellow = Color(0.85,0.65,0.13,1)
const blue = Color(0.1,0.1,0.44,1)
const wild = Color(0.44,0.5,0.56,1)
const facedown = Color(0,0,0,1)

enum card_colour {
	RED, 
	GREEN, 
	BLUE, 
	YELLOW, 
	WILD,
}

enum card_type {
	CARD_0, 
	CARD_1, 
	CARD_2, 
	CARD_3, 
	CARD_4, 
	CARD_5, 
	CARD_6, 
	CARD_7, 
	CARD_8, 
	CARD_9, 
	CARD_SKIP, 
	CARD_REVERSE, 
	CARD_PLUS2, 
	CARD_PLUS4, 
	CARD_WILD,
}

static func card_type_to_string(type) -> String:
	match type:
		card_type.CARD_0:
			return "0"
		card_type.CARD_1:
			return "1"
		card_type.CARD_2:
			return "2"
		card_type.CARD_4:
			return "4"
		card_type.CARD_5:
			return "5"
		card_type.CARD_6:
			return "6"
		card_type.CARD_7:
			return "7"
		card_type.CARD_8:
			return "8"
		card_type.CARD_9:
			return "9"
		card_type.CARD_SKIP:
			return "Skip"
		card_type.CARD_REVERSE:
			return "No U"
		card_type.CARD_PLUS2:
			return "+2"
		card_type.CARD_PLUS4:
			return "+4"
		card_type.CARD_WILD:
			return "Wild"
	return ""

static func card_colour_to_colour(colour) -> Color:
	match colour:
		card_colour.RED:
			return red
		card_colour.GREEN:
			return green
		card_colour.BLUE:
			return blue
		card_colour.YELLOW:
			return yellow
	return wild
