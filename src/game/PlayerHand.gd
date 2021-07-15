extends Node2D

const Card = preload("res://src/game/card/Card.tscn")

var cards = []
var player: int

signal play(player, card)

func _ready():
	player = 0

func add_card(card: Card):
	add_child(card)
	card.set_position(Vector2(0,0))
	card.set_in_hand()
	cards.append(card)
	_update_card_positions()
	card.connect("play", self, "_play")


func remove_card(card: Card):
	card.disconnect("play", self, "_play")
	cards.erase(card)
	remove_child(card)
	_update_card_positions()

func update():
	for card in cards:
		card.set_playable(GameState.is_playable(player, card))

func _update_card_positions():
	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(-25-100*(self.cards.size())+i*200,0))


func _play(card: Card):
	emit_signal("play", player, card)
