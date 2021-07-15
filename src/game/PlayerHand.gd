extends Node2D

const Card = preload("res://src/game/card/Card.tscn")

var cards = []
var player: int

func _ready():
	player = 0

func add_card(card: Card):
	add_child(card)
	card.set_position(Vector2(0,0))
	card.flip()
	cards.append(card)
	_update_card_positions()


func remove_card(card: Card):
	cards.erase(card)
	_update_card_positions()

func update_cards():
	for card in cards:
		card.set_playable(GameState.is_playable(player, card))

func _update_card_positions():
	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(-25-100*(self.cards.size())+i*200,0))
