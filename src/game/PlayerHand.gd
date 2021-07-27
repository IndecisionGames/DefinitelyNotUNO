extends Node2D

const Card = preload("res://src/game/card/Card.tscn")
onready var draw = get_node("../../Draw")
onready var uno = get_node("../../Uno")

var cards = []
var card_bases = []

var player: int
var has_playable_card = false

signal play(player, card)

func setup(player):
	self.player = player

func _ready():
	GameState.connect("new_turn", self, "_new_turn")
	hide()

func add_card(card: CardBase):
	var card_instance = Card.instance()
	card_instance.setup(card.colour, card.type)
	add_child(card_instance)
	card_instance.set_in_hand()
	card_instance.connect("play", self, "_play")
	
	card_bases.append(card_instance.base)
	cards.append(card_instance)

	_update_playable()
	_update_card_positions()

func remove_card(card: CardBase):
	var idx = card_bases.find(card)
	card_bases.remove(idx)
	
	var card_instance = cards[idx]
	cards.remove(idx)
	card_instance.disconnect("play", self, "_play")
	remove_child(card_instance)
	_update_card_positions()

func make_active(active: bool):
	_toggle_options()
	if active:
		show()
	else:
		hide()

func _new_turn():
	_update_playable()
	_toggle_options()

# Used when on turn change to enable interface if it is players turn
func _toggle_options():
	if Server.player_id == player and GameState.current_player == player:
		draw.enable_button(!has_playable_card)
	else:
		draw.enable_button(false)

	if Server.player_id == player and GameState.current_player == player:
		uno.enable_button(cards.size() == 2 && has_playable_card)
	else:
		uno.enable_button(false)

func _update_playable():
	has_playable_card = false
	for card in cards:
		var is_playable = GameState.is_playable(player, card.base)
		card.set_playable(is_playable)
		has_playable_card = has_playable_card || is_playable

func _update_card_positions():
	var card_seperation = 260
	if self.cards.size() > 7:
		card_seperation = float(1600)/float(self.cards.size()-1)

	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(-card_seperation/2*(self.cards.size()-1)+i*card_seperation,0))

func _play(card: Card):
	emit_signal("play", player, card.base)
