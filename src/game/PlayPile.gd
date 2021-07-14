extends Node2D

const Card = preload("res://src/game/card/Card.tscn")

var cards = []

func _ready():
	pass

func add_card(card: Card):
	add_child(card)
	card.set_position(Vector2(0,0))
	card.flip()
	self.cards.append(card)
