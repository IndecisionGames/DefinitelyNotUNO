extends Node2D

const Card = preload("res://src/game/card/Card.tscn")

var cards = []

signal out_of_cards(deck)

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
	if len(cards) <= 1:
		emit_signal("out_of_cards", self)
	return cards.pop_front()
	
# Called by PlayPile to cycle cards
func add_card(card: Card):
	# Reset the wild colour chosen
	if Rules.wild_types.has(card.type):
		card.colour = Types.card_colour.WILD
	cards.append(card)
