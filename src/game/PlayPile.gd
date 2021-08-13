extends Control

const Card = preload("res://src/game/card/Card.tscn")
const AnimationCard = preload("res://src/game/card/AnimationCard.tscn")

onready var hand = get_parent().get_parent().get_node("Hand")
onready var opponent_hands = get_parent().get_parent().get_node("OpponentHands")

var card

func _ready():
	Server.connect("game_start", self, "_on_game_update")
	Server.connect("game_update", self, "_on_game_update")
	Server.connect("card_played", self, "_on_card_played")
	card = Card.instance()
	card.setup(0, 0)
	add_child(card)
	card.set_position(Vector2(0,0))
	card.set_in_play()

func _on_game_update():
	card.base.type = GameState.current_card_type
	card.base.colour = GameState.current_card_colour
	card.set_in_play()

# TODO: Scale and rotate cards from other hands
func _on_card_played(player, card):
	var play_card_instance = AnimationCard.instance()
	add_child(play_card_instance)

	var start_position
	if player == Server.player_id:
		start_position = hand.get_card_position(card)
		hand.on_card_played(player, card)
	else:
		start_position = opponent_hands.get_player_position(player)

	play_card_instance.setup(card.colour, card.type, start_position, 0)
	play_card_instance.move_to(Vector2(963,520))
