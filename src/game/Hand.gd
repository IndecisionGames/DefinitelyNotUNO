extends Node2D

const Card = preload("res://src/game/card/Card.tscn")

const CARD_WIDTH = 200
const BASE_SEPERATION = 140
const MAX_WIDTH = 1600
const NUM_AT_MAX = 13

onready var buttons = get_node("../ButtonManager")
onready var draw_anim = get_node("DrawAnim")
onready var draw_card_layer = get_node("../PlaySpace/Deck/TopDeckLayer/TopDeckLayer2")

var cards = []
var card_bases = []
var has_playable_card = false

func _ready():
	Server.connect("game_start", self, "_load")
	Server.connect("game_update", self, "_on_game_update")
	Server.connect("cards_drawn", self, "_on_cards_drawn")

func _load():
	while card_bases.size() > 0:
		on_card_played(Server.player_id, card_bases[0])

	_on_cards_drawn(Server.player_id, GameState.players[Server.player_id].cards, true)

	_update_playable()
	_update_options()
	_update_card_positions()

func _on_game_update():
	_update_playable()
	_update_options()

func _process(_delta):
	if draw_anim.is_playing():
		draw_card_layer.set_layer(2)
	else:
		draw_card_layer.set_layer(4)

func _on_cards_drawn(player, drawn_cards, loading=false):
	if player != Server.player_id:
		return
	
	for card in drawn_cards:
		if not loading:
			draw_anim.play("PlayerDraw")
		var card_instance = Card.instance()
		card_instance.setup(card.colour, card.type)
		add_child(card_instance)
		
		card_bases.append(card_instance.base)
		cards.append(card_instance)

	_update_playable()
	_update_options()
	_update_card_positions()

# Called by PlayPile
func get_card_position(card):
	var idx = card.is_in(card_bases)
	return cards[idx].rect_global_position

# Called by PlayPile
func on_card_played(player, card):
	if player != Server.player_id:
		return

	var idx = card.is_in(card_bases)
	card_bases.remove(idx)
	
	var card_instance = cards[idx]
	cards.remove(idx)

	remove_child(card_instance)
	_update_card_positions()

func _update_options():
	if GameState.current_player == Server.player_id:
		buttons.enable_draw_button(!has_playable_card && !GameState.waiting_action)
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
	var card_seperation = BASE_SEPERATION
	if self.cards.size() > NUM_AT_MAX:
		card_seperation = float(MAX_WIDTH)/float(self.cards.size()-1)

	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(-CARD_WIDTH/2-card_seperation/2*(self.cards.size()-1)+i*card_seperation,0))
