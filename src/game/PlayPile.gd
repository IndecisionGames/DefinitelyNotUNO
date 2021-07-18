extends Node2D

const Card = preload("res://src/game/card/Card.tscn")

var cards = []

func _ready():
	pass

func add_card(card: Card):
	add_child(card)
	card.set_position(Vector2(0,0))
	card.set_in_play()
	cards.append(card)

func cycle_cards(deck):
	while cards.size() > 1:
		var card = cards.pop_front()
		remove_child(card)
		cards.erase(card)
		deck.add_card(card)
	deck.shuffle()

func _on_WildPicker_wild_pick(colour):
	var card = cards[cards.size()-1]
	if Rules.wild_types.has(card.type):
		card.colour = colour
		card.set_in_play()
