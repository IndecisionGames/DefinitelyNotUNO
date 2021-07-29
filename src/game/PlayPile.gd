extends Control

const Card = preload("res://src/game/card/Card.tscn")

var card

func _ready():
	GameState.connect("game_state_update", self, "_on_game_state_update")
	card = Card.instance()
	card.setup(0, 0)
	add_child(card)
	card.set_position(Vector2(0,0))
	card.set_in_play()

func _on_game_state_update():
	card.base.type = GameState.current_card_type
	card.base.colour = GameState.current_card_colour
	card.set_in_play()
