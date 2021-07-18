extends Node2D

const Card = preload("res://src/game/card/Card.tscn")

var cards = []
var player: int

onready var draw = get_node("../../Draw")

signal play(player, card)

func _ready():
	player = 0

func add_card(card: Card):
	add_child(card)
	card.set_in_hand()
	card.connect("play", self, "_play")
	cards.append(card)
	update_playable()
	_update_card_positions()

func remove_card(card: Card):
	cards.erase(card)
	card.disconnect("play", self, "_play")
	remove_child(card)
	update_playable()
	_update_card_positions()

func update_playable():
	var has_playable_card = false
	for card in cards:
		var is_playable = GameState.is_playable(player, card)
		card.set_playable(is_playable)
		has_playable_card = has_playable_card || is_playable
	
	draw.allow_draw(!has_playable_card)

func _update_card_positions():
	var card_seperation = 260
	if self.cards.size() > 7:
		card_seperation = float(1600)/float(self.cards.size()-1)

	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(-card_seperation/2*(self.cards.size()-1)+i*card_seperation,0))

func _play(card: Card):
	emit_signal("play", player, card)
