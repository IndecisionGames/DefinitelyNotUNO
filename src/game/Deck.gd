extends Node2D

const Card = preload("res://src/game/card/Card.tscn")

var cards = []

func _ready():
	generate()
	shuffle()

func generate():
	cards = []
	for colour in Rules.standard_colours:
		for type in Rules.standard_types:
			for i in range(Rules.NUM_EACH_CARD):
				var new_card = Card.instance()
				new_card.setup(colour, type)
				cards.append(new_card)

	for type in Rules.wild_types:
		for i in range(Rules.NUM_EACH_CARD):
			var new_card = Card.instance()
			new_card.setup(Types.card_colour.WILD, type)
			cards.append(new_card)

func shuffle():
	cards.shuffle()

func draw():
	if len(cards) > 0:
		return cards.pop_front()
