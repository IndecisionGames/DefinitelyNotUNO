extends Node
# The following code should be identical in both the client and server

const CardBase = preload("res://src/game/card/CardBase.gd")

var wild_opening: bool

func _ready():
	Server.connect("play_request", self, "_play_card")
	Server.connect("draw_request", self, "_draw_cards")
	Server.connect("uno_request", self, "_on_uno_request")
	Server.connect("wild_pick", self, "_on_wild_pick")

# Generation
func start_game():
	_generate_deck()
	_generate_hands()

	_play_card(0, _draw(), true)
	Server.emit_game_start()

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

func _generate_hands():
	for _i in range(Rules.NUM_PLAYERS):
		GameState.players.append(GameState.Player.new())
	for _i in range(Rules.STARTING_HAND_SIZE):
		for i in range(Rules.NUM_PLAYERS):
			GameState.players[i].cards.append(_draw())

# Game
func _play_card(player, card: CardBase, opening_card = false):
	if !opening_card and !GameState.play_in_progress and !GameState.is_playable(player, card):
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
		Server.request_wild_pick(player)
		GameState.waiting_action = true
		Server.emit_game_state_update()

	GameState.play_pile.append(card)
	
	if opening_card:
		# Special cases
		if GameState.skip_required: # Skip shoud move to the next turn but only skip 1 player
			GameState.skip_required = false
			_turn_end()
		if GameState.current_card_colour == Types.card_colour.WILD: # Picking Wild should not end the turn
			wild_opening = true
		return

	var idx = Types.matching_card(card, GameState.get_current_player().cards)
	GameState.get_current_player().cards.remove(idx)
	Server.emit_card_removed(GameState.current_player, card)
	_turn_end()

func _draw_cards(player):
	for _i in range(max(1,GameState.required_pickup_count)):
		var card = _draw()
		GameState.players[player].cards.append(card)
		Server.emit_card_added(player, card)
	
	GameState.pickup_required = false
	GameState.pickup_type = Types.pickup_type.NULL
	GameState.required_pickup_count = 0
	_turn_end()

func _turn_end():
	# Prevent turn end if waiting for input
	if GameState.waiting_action:
		return

	# Automatic Uno Penalty 
	if GameState.get_current_player().cards.size() == 1 && !GameState.get_current_player().uno_status:
		for _i in range(Rules.UNO_CARD_PENALTY):
			var card = _draw()
			GameState.get_current_player().cards.append(card)
			Server.emit_card_added(GameState.current_player, card)

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

	Server.emit_game_state_update()
	Server.emit_new_turn()
	GameState.play_in_progress = false

func _draw():
	# Refresh cards with PlayPile if running out
	if len(GameState.deck) <= 1:
		while GameState.play_pile.size() > 1:
			GameState.deck.append(GameState.play_pile.pop_front())
		GameState.deck.shuffle()

	return GameState.deck.pop_front()

# Player signals
func _on_wild_pick(colour):
	GameState.waiting_action = false
	GameState.current_card_colour = colour
	if wild_opening:
		wild_opening = false
		Server.emit_game_state_update()
		return
	_turn_end()

func _on_uno_request(player):
	GameState.players[player].uno_status = true
	Server.emit_game_state_update()
