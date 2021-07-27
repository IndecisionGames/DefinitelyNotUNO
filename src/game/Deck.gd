extends Node2D

const CardBase = preload("res://src/game/card/CardBase.gd")

onready var play_pile = get_parent().get_node("PlayPile")

var cards = []

func _ready():
	generate()
	shuffle()

func generate():
	cards = []
	
	for colour in Rules.standard_colours:
		for type in Rules.standard_types:
			for _i in range(Rules.NUM_EACH_CARD):
				var new_card = CardBase.new()
				new_card.setup(colour, type)
				cards.append(new_card)

	for type in Rules.wild_types:
		for _i in range(Rules.NUM_EACH_WILD_CARD):
			var new_card = CardBase.new()
			new_card.setup(Types.card_colour.WILD, type)
			cards.append(new_card)

func shuffle():
	cards.shuffle()

func draw():
	if len(cards) <= 1:
		play_pile.cycle_cards()
		shuffle()
	return cards.pop_front()

# Called by PlayPile Only
func add_card(card: CardBase):
	cards.append(card)
