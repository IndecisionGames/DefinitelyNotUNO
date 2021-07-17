extends Node2D

# Play Checks
var current_player = 0
var current_card_type: int
var current_card_colour: int

# Card Effects
var play_order_clockwise = true
var skip_required = false
var pickup_required = false
var active_pickup_type: int
var required_pickup_count = 0

func is_playable(player: int, proposed_card: CardBase) -> bool:
	if player != current_player:
		if Rules.INTERRUPT:
			# TODO: Stop from affecting player who has started turn. Otherwise someone could play mid/post draw
			if proposed_card.type == current_card_type and proposed_card.colour == current_card_colour:
				return true
		return false

	if pickup_required:
		# Require matching Plus 2
		if active_pickup_type == Types.pickup_type.PLUS2:
			if proposed_card.type == Types.card_type.CARD_PLUS2:
				return true
		# Require matching Plus 4
		if active_pickup_type == Types.pickup_type.PLUS4:
			if proposed_card.type == Types.card_type.CARD_PLUS4:
				return true
		return false

	if proposed_card.type == current_card_type:
		return true
	if proposed_card.colour == current_card_colour or proposed_card.colour == Types.card_colour.WILD:
		return true

	return false
