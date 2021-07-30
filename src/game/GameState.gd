extends Node
# The following code should be identical in both the client and server

class Player:
	var name: String
	var cards = []
	var uno_status: bool

var players = []
var deck = []
var play_pile = []

# Play Checks
var current_player: int
var current_card_type: int
var current_card_colour: int
var play_in_progress = false

# Wild
var waiting_action = false
# Reverse
var play_order_clockwise = true
# Skip
var skip_required = false
# Plus2 / Plus4
var pickup_required = false
var pickup_type = 0
var required_pickup_count = 0

func is_playable(player, proposed_card: CardBase) -> bool:
	if player != current_player:
		if Rules.INTERRUPT:
			# TODO: Stop from affecting player who has started turn. Otherwise someone could play mid/post draw
			if proposed_card.type == current_card_type and proposed_card.colour == current_card_colour:
				return true
		return false

	if pickup_required:
		# Require matching Plus 2
		if pickup_type == Types.pickup_type.PLUS2:
			if proposed_card.type == Types.card_type.CARD_PLUS2:
				return true
		# Require matching Plus 4
		if pickup_type == Types.pickup_type.PLUS4:
			if proposed_card.type == Types.card_type.CARD_PLUS4:
				return true
		return false

	if proposed_card.type == current_card_type:
		return true
	if proposed_card.colour == current_card_colour or proposed_card.colour == Types.card_colour.WILD:
		return true

	return false

func get_current_player():
	return players[current_player]
