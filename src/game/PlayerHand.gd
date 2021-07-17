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
	card.connect("play", self, "_play")
	update_playable()
	_update_card_positions()


func remove_card(card: Card):
	card.disconnect("play", self, "_play")
	cards.erase(card)
	remove_child(card)
	_update_card_positions()

func update_playable():
	for card in cards:
		card.set_playable(GameState.is_playable(player, card))

func _update_card_positions():
	var card_seperation = 260
	if self.cards.size() > 7:
		card_seperation = float(1600)/float(self.cards.size()-1)

	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(-card_seperation/2*(self.cards.size()-1)+i*card_seperation,0))


func _play(card: Card):
	emit_signal("play", player, card)
