extends Node

class_name GameState

const Card = preload("res://src/game/Card.tscn")

enum pickup_type {NULL, PLUS2, PLUS4}

var num_players = 1
var play_order_clockwise = true

# Used in Play Checks
var current_player = 0
var current_card_type: int
var current_card_colour: int

var pickup_required = false
var active_pickup_type = pickup_type.NULL
var current_pickup_count = 0

# Other
var skip_required = false

func is_playable(player: int, proposed_card: Card) -> bool:
	# Check Player
	if player != current_player:
		if Rules.INTERRUPT:
			# TODO: Stop from affecting player who has started turn. Otherwise someone could play mid/post draw
			if proposed_card.type == current_card_type and proposed_card.colour == current_card_colour:
				return true
		return false

	if pickup_required:
		# Require matching Plus 2
		if active_pickup_type == pickup_type.PLUS2:
			if proposed_card.type == Types.card_type.CARD_PLUS2:
				if proposed_card.colour == current_card_colour or proposed_card.type == Types.card_colour.WILD:
					return true
		# Require matching Plus 4
		if active_pickup_type == pickup_type.PLUS4:
			if proposed_card.type == Types.card_type.CARD_PLUS4:
				if proposed_card.colour == current_card_colour or proposed_card.type == Types.card_colour.WILD:
					return true
		return false

	if proposed_card.type == current_card_type:
		return true
	if proposed_card.colour == current_card_colour or proposed_card.colour == Types.card_colour.WILD:
		return true

	return false


# TODO: Add WILD pick colour logic
func play_card(player: int, card: Card):
	if !is_playable(player, card):
		print("this card can not be played")
		return
	
	current_card_type  = card.type
	current_card_colour = card.colour

	if current_card_type == Types.card_type.CARD_REVERSE:
		play_order_clockwise = !play_order_clockwise

	if current_card_type == Types.card_type.CARD_SKIP:
		skip_required = true

	if current_card_colour == Types.card_type.CARD_PLUS2 or current_card_colour == Types.card_type.CARD_PLUS4:
		pickup_required = true

		if current_card_colour == Types.card_type.CARD_PLUS2:
			active_pickup_type = pickup_type.PLUS2
			current_pickup_count += 2

		if current_card_colour == Types.card_type.CARD_PLUS4:
			active_pickup_type = pickup_type.PLUS4
			current_pickup_count += 4

	_next_turn()

func skip_turn():
	skip_required = false
	pickup_required = false
	active_pickup_type = pickup_type.NULL
	current_pickup_count = 0
	_next_turn()

func _next_turn():
	var turn_increment = 1

	if skip_required:
		skip_required = false
		turn_increment = 2

	if play_order_clockwise:
		current_player += turn_increment
	else:
		current_player -= turn_increment

	if current_player >= num_players:
		current_player -= num_players
	if current_player < 0:
		current_player += num_players
