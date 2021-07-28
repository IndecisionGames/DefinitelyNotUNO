extends Node2D

const PlayerHand = preload("res://src/game/PlayerHand.gd")

onready var deck = get_node("PlaySpace/Deck")
onready var play_pile = get_node("PlaySpace/PlayPile")
onready var player_hand = get_node("PlayerHand")

onready var wild_picker = get_node("WildPicker")

func _ready():
	for player in range(Rules.NUM_PLAYERS):
		GameState.player_states.append(GameState.PlayerState.new())

	player_hand.setup(Server.player_id, [])
	player_hand.connect("play", self, "play_card")
	start_game()

func _input(event):
	# Change Players
	if Input.is_action_just_pressed("ui_right"):
		Server.player_id += 1
		if Server.player_id >= Rules.NUM_PLAYERS:
			Server.player_id = 0
		player_hand.setup(Server.player_id, GameState.player_states[Server.player_id].cards)
		GameState.emit_refresh()

func start_game():
	for _i in range(Rules.STARTING_HAND_SIZE):
		for i in range(Rules.NUM_PLAYERS):
			var drawn_card = deck.draw()
			GameState.add_card_to_player(i, drawn_card)

	# TODO: Fix opening card on wild
	play_card(-1, deck.draw(), true)

func play_card(player: int, card: CardBase, opening_card = false) -> bool:
	if GameState.play_in_progress:
		return false
	if !GameState.is_playable(player, card) and !opening_card:
		print("this card can not be played")
		return false
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
		wild_picker.display_picker()
		GameState.waiting_action = true

	# Update Card States
	if !opening_card:
		GameState.remove_card_from_player(Server.player_id, card)
	play_pile.add_card(card)
	_turn_end()
	return true

func pass_turn():
	GameState.waiting_action = false
	GameState.skip_required = false
	GameState.pickup_required = false
	GameState.pickup_type = Types.pickup_type.NULL
	GameState.required_pickup_count = 0
	_turn_end()

func _turn_end():
	if GameState.player_states[GameState.current_player].cards.size() == 1 && !GameState.player_states[GameState.current_player].uno_status:
		for i in range(Rules.UNO_CARD_PENALTY):
			var drawn_card = deck.draw()
			GameState.add_card_to_player(i, drawn_card)

	var turn_increment = 1
	# Prevent turn end if waiting for input
	if GameState.waiting_action:
		return

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

	_turn_start()

func _turn_start():
	GameState.emit_new_turn()
	GameState.play_in_progress = false

func _on_DrawButton_pressed():
	for _i in range(max(1,GameState.required_pickup_count)):
		var drawn_card = deck.draw()
		GameState.add_card_to_player(Server.player_id, drawn_card)
	pass_turn()

func _on_WildPicker_wild_pick(colour):
	GameState.waiting_action = false
	GameState.current_card_colour = colour
	_turn_end()

func _on_UnoButton_pressed():
	GameState.player_states[GameState.current_player].uno_status = true
	GameState.emit_refresh()
