extends MarginContainer

var colour: int
var type: int

func _to_string():
	return "%s %s" % [colour(), type()]

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
			return "No U"
		Types.card_type.CARD_PLUS2:
			return "+2"
		Types.card_type.CARD_PLUS4:
			return "+4"
		Types.card_type.CARD_WILD:
			return "Wild"
	return ""

func colour() -> Color:
	match self.colour:
		Types.card_colour.RED:
			return Types.red
		Types.card_colour.GREEN:
			return Types.green
		Types.card_colour.BLUE:
			return Types.blue
		Types.card_colour.YELLOW:
			return Types.yellow
	return Types.wild
	
