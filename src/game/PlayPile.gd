extends Control

const Card = preload("res://src/game/card/Card.tscn")
const AnimationCard = preload("res://src/game/card/AnimationCard.tscn")

const MAX_CARDS = 20

@onready var hand = get_parent().get_parent().get_node("Hand")
@onready var opponent_hands = get_parent().get_parent().get_node("OpponentHands")

var pos = Vector2(963,520)
var cards = []

func _ready():
	Server.connect("game_start", Callable(self, "_on_game_start"))
	Server.connect("card_played", Callable(self, "_on_card_played"))
	Server.connect("game_update", Callable(self, "_on_game_update"))

func _on_game_start():
	var play_card_instance = AnimationCard.instance()
	add_child(play_card_instance)
	play_card_instance.setup(GameState.current_card_colour, GameState.current_card_type, pos, 0)
	play_card_instance.move_to(pos)

# TODO: Scale and rotate cards from other hands
func _on_card_played(player, card):
	var play_card_instance = AnimationCard.instance()
	add_child(play_card_instance)

	var start_position
	var start_rotation = 0
	if player == Server.player_id:
		start_position = hand.get_card_position(card)
		hand.on_card_played(player, card)
	else:
		start_position = opponent_hands.get_player_position(player)
		start_rotation = opponent_hands.get_player_rotation(player) # -90 (left), 0 (top), 90 (right)

		if start_rotation == 0:
			play_card_instance.flip()

	play_card_instance.setup(card.colour, card.type, start_position, start_rotation)
	play_card_instance.move_to(pos)
	_update_cards(play_card_instance)

func _on_game_update():
	if cards:
		cards[cards.size()-1].set_colour(GameState.current_card_colour)

func _update_cards(card):
	cards.append(card)
	if cards.size() > MAX_CARDS:
		remove_child(cards.pop_front())
