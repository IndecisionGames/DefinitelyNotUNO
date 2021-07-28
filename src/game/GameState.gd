extends Node

# Player State
# TODO: Move to own file?
class PlayerState:
	var name: String
	var cards = []
	var uno_status: bool

var player_states = []

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


# Server to Client
signal add_card(player, card)
signal remove_card(player, card)
signal new_turn()
signal refresh()

# Client to Server
signal play_card(player, card)

func is_playable(player: int, proposed_card: CardBase) -> bool:
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

# TODO: find a better place to put this
func matching_card(card: CardBase, cards):
	for i in range(cards.size()):
		if card.colour == cards[i].colour and card.type == cards[i].type:
			return i
	return -1

# Used by Player/Card Only
func request_play_card(player, card: CardBase):
	emit_signal("play_card", player, card)

# Used by GameController Only
func add_card_to_player(player, card: CardBase):
	emit_signal("add_card", player, card)
	player_states[player].cards.append(card)

func remove_card_from_player(player, card: CardBase):
	emit_signal("remove_card", player, card)
	var idx = matching_card(card, player_states[player].cards)
	player_states[player].cards.remove(idx)

func emit_new_turn():
	emit_signal("new_turn")

func emit_refresh():
	emit_signal("refresh")
