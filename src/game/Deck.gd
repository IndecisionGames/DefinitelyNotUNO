extends Node2D

const Card = preload("res://src/game/Card.tscn")

const NUM_EACH_CARD = 2
var cards = []

func _ready():
	generate()
	shuffle()

func generate():
	self.cards = []
	for colour in Types.standard_colours:
		for type in Types.standard_types:
			for i in range(NUM_EACH_CARD):
				var new_card = Card.instance()
				new_card.setup(colour, type)
				self.cards.append(new_card)

	for type in Types.wild_types:
		for i in range(NUM_EACH_CARD):
			var new_card = Card.instance()
			new_card.setup(Types.card_colour.WILD, type)
			self.cards.append(new_card)

func shuffle():
	self.cards.shuffle()
	
func draw():
	if len(cards) > 0:
		return cards.pop_front()
