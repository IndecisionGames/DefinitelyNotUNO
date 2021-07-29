extends Node

const CardBase = preload("res://src/game/card/CardBase.gd")

func _ready():
	GameState.connect("play_request", self, "_play_card")
	GameState.connect("draw_request", self, "_draw_cards")
	GameState.connect("uno_request", self, "_on_uno_request")
	GameState.connect("wild_pick", self, "_on_wild_pick")

func start_game():
	_generate_deck()
	for _i in range(Rules.STARTING_HAND_SIZE):
		for i in range(Rules.NUM_PLAYERS):
			GameState.add_card_to_player(i, _draw())

	# TODO: Fix opening card on wild
	_play_card(-1, _draw(), true)
	GameState.emit_game_start()

func _play_card(player, card: CardBase, opening_card = false):
	if GameState.play_in_progress:
		return
	if !GameState.is_playable(player, card) and !opening_card:
		print("this card can not be played")
		return
	GameState.play_in_progress = true
	GameState.current_player = player

	GameState.current_card_type  = card.type
	GameState.current_card_colour = card.colour

	# Card specific OnPlay effects
	if GameState.current_card_type == Types.card_type.CARD_SKIP:
		GameState.skip_required = true

	if GameState.current_card_type == Types.card_type.CARD_REVERSE:
		GameState.play_order_clockwise = !GameState.play_order_clockwise

	if GameState.current_card_type == Types.card_type.CARD_PLUS2 or GameState.current_card_type == Types.card_type.CARD_PLUS4:
		GameState.pickup_required = true

		if GameState.current_card_type == Types.card_type.CARD_PLUS2:
			GameState.pickup_type = Types.pickup_type.PLUS2
			GameState.required_pickup_count += 2

		if GameState.current_card_type == Types.card_type.CARD_PLUS4:
			GameState.pickup_type = Types.pickup_type.PLUS4
			GameState.required_pickup_count += 4

	if GameState.current_card_colour == Types.card_colour.WILD:
		GameState.request_wild_pick(player)
		GameState.waiting_action = true
		GameState.emit_game_state_update()

	if !opening_card:
		GameState.remove_card_from_player(Server.player_id, card)
	GameState.play_pile.append(card)
	_turn_end()

func _draw_cards(player):
	for _i in range(max(1,GameState.required_pickup_count)):
		GameState.add_card_to_player(player, _draw())
	
	GameState.pickup_required = false
	GameState.pickup_type = Types.pickup_type.NULL
	GameState.required_pickup_count = 0
	_turn_end()

func _turn_end():
	# Prevent turn end if waiting for input
	if GameState.waiting_action:
		return

	if GameState.player_states[GameState.current_player].cards.size() == 1 && !GameState.player_states[GameState.current_player].uno_status:
		for i in range(Rules.UNO_CARD_PENALTY):
			GameState.add_card_to_player(i, _draw())

	var turn_increment = 1

	# Card specific OnTurnEnd effects
	if GameState.skip_required:
		GameState.skip_required = false
		turn_increment = 2

	for _i in range(turn_increment):
		if GameState.play_order_clockwise:
			GameState.current_player += 1
		else:
			GameState.current_player -= 1

		if GameState.current_player >= Rules.NUM_PLAYERS:
			GameState.current_player -= Rules.NUM_PLAYERS
		if GameState.current_player < 0:
			GameState.current_player += Rules.NUM_PLAYERS

	GameState.emit_game_state_update()
	GameState.emit_new_turn()
	GameState.play_in_progress = false

# Deck
func _generate_deck():
	GameState.deck = []
	for colour in Rules.standard_colours:
		for type in Rules.standard_types:
			for _i in range(Rules.NUM_EACH_CARD):
				var new_card = CardBase.new()
				new_card.setup(colour, type)
				GameState.deck.append(new_card)

	for type in Rules.wild_types:
		for _i in range(Rules.NUM_EACH_WILD_CARD):
			var new_card = CardBase.new()
			new_card.setup(Types.card_colour.WILD, type)
			GameState.deck.append(new_card)

	GameState.deck.shuffle()

func _draw():
	# Refresh cards with PlayPile if running out
	if len(GameState.deck) <= 1:
		while GameState.play_pile.size() > 1:
			GameState.deck.append(GameState.play_pile.pop_front())
		GameState.deck.shuffle()

	return GameState.deck.pop_front()

# Player Signals
func _on_wild_pick(colour):
	GameState.waiting_action = false
	GameState.current_card_colour = colour
	_turn_end()

func _on_uno_request(player):
	GameState.player_states[player].uno_status = true
	GameState.emit_game_state_update()
