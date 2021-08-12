extends Node2D

const Card = preload("res://src/game/card/Card.tscn")
const AnimationCard = preload("res://src/game/card/AnimationCard.tscn")
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
	Server.connect("card_played", self, "_on_card_played")

func _load():
	while card_bases.size() > 0:
		_on_card_played(Server.player_id, card_bases[0])

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

func _on_cards_drawn(player, drawn_cards, initial=false):
	if player != Server.player_id:
		return
	
	for card in drawn_cards:
		if not initial:
			draw_anim.play("PlayerDraw")
		var card_instance = Card.instance()
		card_instance.setup(card.colour, card.type)
		add_child(card_instance)
		card_instance.set_in_hand()
		
		card_bases.append(card_instance.base)
		cards.append(card_instance)

	_update_playable()
	_update_options()
	_update_card_positions()

func _on_card_played(player, card):
	if player != Server.player_id:
		return

	var idx = card.is_in(card_bases)
	card_bases.remove(idx)
	
	var card_instance = cards[idx]
	cards.remove(idx)

	var play_card_instance = AnimationCard.instance()
	add_child(play_card_instance)
	play_card_instance.setup(card_instance.base.colour, card_instance.base.type, card_instance.rect_global_position, card_instance.rect_rotation)
	play_card_instance.move_to(Vector2(963,520))

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
	var card_seperation = 140
	if self.cards.size() > 13:
		card_seperation = float(1600)/float(self.cards.size()-1)

	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(-card_seperation/2*(self.cards.size()-1)+i*card_seperation,0))
