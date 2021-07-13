extends Node

const Types = preload("res://src/game/Types.gd")

var Card = preload("res://src/game/Card.tscn")

onready var cards_node = get_node("../Cards")

const num_each_card = 2
var cards = []

func _ready():
	generate()
	shuffle()

# TODO: Move out of deck, replace with draw funcion
func _input(event):
	if Input.is_action_just_pressed("left_click"):
		var spawn_card = cards[0]
		cards_node.add_child(spawn_card)
		spawn_card.flip()
		cards.pop_front()
	if Input.is_action_just_pressed("right_click"):
		var spawn_card = cards[0]
		cards_node.add_child(spawn_card)
		cards.pop_front()

func generate():
	self.cards = []
	for colour in Types.card_colour:
		for type in Types.card_type:
			for i in range(num_each_card):
				var new_card = Card.instance()
				new_card.setup(Types.card_colour[colour], Types.card_type[type])
				self.cards.append(new_card)

func shuffle():
	self.cards.shuffle()
