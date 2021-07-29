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
signal add_card_request(card)
signal remove_card_request(card)
signal wild_pick_request(player)
signal new_turn()
signal refresh()

# Client to Server
signal play_request(player, card)
signal draw_request(player)
signal uno_request(player)
signal wild_pick(colour)

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

# TODO: find a better place to put this
func matching_card(card: CardBase, cards):
	for i in range(cards.size()):
		if card.colour == cards[i].colour and card.type == cards[i].type:
			return i
	return -1

# Used by Player/Card Only
func request_play_card(player, card: CardBase):
	emit_signal("play_request", player, card)

func request_draw_card(player):
	emit_signal("draw_request", player)

func request_uno(player):
	emit_signal("uno_request", player)

func emit_wild_pick(colour):
	emit_signal("wild_pick", colour)

# Used by GameController Only
func add_card_to_player(player, card: CardBase):
	player_states[player].cards.append(card)
	emit_signal("add_card_request", card)

func remove_card_from_player(player, card: CardBase):
	var idx = matching_card(card, player_states[player].cards)
	player_states[player].cards.remove(idx)
	emit_signal("remove_card_request", card)

func request_wild_pick(player):
	emit_signal("wild_pick_request", player)

func emit_new_turn():
	emit_signal("new_turn")

func emit_refresh():
	emit_signal("refresh")
