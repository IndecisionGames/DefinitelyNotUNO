extends Node

var NUM_PLAYERS: int

var INTERRUPT: bool
var UNO_CARD_PENALTY : int
# Not implemented
const PICKUP_STACKING = false
const PLAY_AFTER_DRAW = false
const DRAW_UNTIL_PLAY = false

func set_rules(rules={}):
	seed(rules.get("SEED", 0))
	NUM_PLAYERS = rules.get("NUM_PLAYERS", 3)
	INTERRUPT = rules.get("INTERRUPT", false)
	UNO_CARD_PENALTY = rules.get("UNO_CARD_PENALTY", 1)

# Generation Rules
const STARTING_HAND_SIZE = 7
const NUM_EACH_CARD = 2
const NUM_EACH_WILD_CARD = 4

const standard_types = [
	Types.card_type.CARD_0, 
	Types.card_type.CARD_1, 
	Types.card_type.CARD_2, 
	Types.card_type.CARD_3, 
	Types.card_type.CARD_4, 
	Types.card_type.CARD_5, 
	Types.card_type.CARD_6, 
	Types.card_type.CARD_7, 
	Types.card_type.CARD_8, 
	Types.card_type.CARD_9, 
	Types.card_type.CARD_SKIP, 
	Types.card_type.CARD_REVERSE, 
	Types.card_type.CARD_PLUS2
]
const standard_colours = [
	Types.card_colour.RED, 
	Types.card_colour.GREEN, 
	Types.card_colour.BLUE, 
	Types.card_colour.YELLOW
]
const wild_types = [
	Types.card_type.CARD_PLUS4, 
	Types.card_type.CARD_WILD
]
