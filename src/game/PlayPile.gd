extends Node2D

const Card = preload("res://src/game/card/Card.tscn")

onready var deck = get_parent().get_node("Deck")

var cards = []
var current_card

func _ready():
	pass

func add_card(card: CardBase):
	cards.append(card)
	if current_card:
		remove_child(current_card)

	var new_card = Card.instance()
	new_card.setup(card.colour, card.type)
	add_child(new_card)
	new_card.set_position(Vector2(0,0))
	new_card.set_in_play()

	current_card = new_card

# Called by Deck Only
func cycle_cards():
	while cards.size() > 1:
		var card = cards.pop_front()
		cards.erase(card)
		deck.add_card(card)

func _on_WildPicker_wild_pick(colour):
	if Rules.wild_types.has(current_card.base.type):
		current_card.base.colour = colour
		current_card.set_in_play()
