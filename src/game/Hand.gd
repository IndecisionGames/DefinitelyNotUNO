extends Node2D

const Card = preload("res://src/game/card/Card.tscn")
onready var buttons = get_node("../ButtonManager")

var cards = []
var card_bases = []
var has_playable_card = false

func _ready():
	GameState.connect("game_start", self, "_load")
	GameState.connect("new_turn", self, "_new_turn")
	GameState.connect("add_card_request", self, "_on_add_card_request")
	GameState.connect("remove_card_request", self, "_on_remove_card_request")

func _load():
	while card_bases.size() > 0:
		_on_remove_card_request(card_bases[0])
	for card in GameState.player_states[Server.player_id].cards:
		_on_add_card_request(card)

	_update_playable()
	_update_options()

func _new_turn():
	_update_playable()
	_update_options()

func _on_add_card_request(card: CardBase):
	var card_instance = Card.instance()
	card_instance.setup(card.colour, card.type)
	add_child(card_instance)
	card_instance.set_in_hand()
	
	card_bases.append(card_instance.base)
	cards.append(card_instance)

	_update_playable()
	_update_card_positions()

func _on_remove_card_request(card: CardBase):
	var idx = GameState.matching_card(card, card_bases)
	card_bases.remove(idx)
	
	var card_instance = cards[idx]
	cards.remove(idx)
	remove_child(card_instance)
	_update_card_positions()

func _update_options():
	if GameState.current_player == Server.player_id:
		buttons.enable_draw_button(!has_playable_card)
		buttons.enable_uno_button(cards.size() == 2 && has_playable_card)
	else:
		buttons.enable_draw_button(false)
		buttons.enable_uno_button(false)

func _update_playable():
	has_playable_card = false
	for card in cards:
		var is_playable = GameState.is_playable(Server.player_id, card.base)
		card.set_playable(is_playable)
		has_playable_card = has_playable_card || is_playable

func _update_card_positions():
	var card_seperation = 260
	if self.cards.size() > 7:
		card_seperation = float(1600)/float(self.cards.size()-1)

	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(-card_seperation/2*(self.cards.size()-1)+i*card_seperation,0))
