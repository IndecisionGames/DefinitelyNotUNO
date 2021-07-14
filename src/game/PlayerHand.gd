extends Node2D

const Card = preload("res://src/game/Card.tscn")

var cards = []

func _ready():
	pass

func add_card(card: Card):
	add_child(card)
	card.set_position(Vector2(0,0))
	card.flip()
	self.cards.append(card)
	self._update_card_positions()
	
func remove_card():
	pass
	
func _update_card_positions():
	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(0+i*260,0))
