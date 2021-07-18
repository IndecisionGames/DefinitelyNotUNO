extends Node2D

onready var deck = get_node("Deck")
onready var play_pile = get_node("PlayPile")
onready var player_hand = get_node("Hands/PlayerHand")
onready var game_info = get_node("GameInfo")
onready var wild_picker = get_node("WildPicker")

func _ready():
	player_hand.connect("play", self, "play_card")
	deck.connect("out_of_cards", play_pile, "cycle_cards")
	start_game()

func _input(event):
	# Force Draw for debugging
	if Input.is_action_just_pressed("ui_right"):
		_on_DrawButton_pressed()

func start_game():
	for i in range(Rules.STARTING_HAND_SIZE):
		player_hand.add_card(deck.draw())

	# TODO: Fix opening card on wild
	play_card(-1, deck.draw(), true)

func play_card(player: int, card: Card, opening_card = false) -> bool:
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
			GameState.active_pickup_type = Types.pickup_type.PLUS2
			GameState.required_pickup_count += 2

		if GameState.current_card_type == Types.card_type.CARD_PLUS4:
			GameState.active_pickup_type = Types.pickup_type.PLUS4
			GameState.required_pickup_count += 4

	if GameState.current_card_colour == Types.card_colour.WILD:
		wild_picker.display_picker()
		GameState.waiting_action = true

	# Update Card States
	if !opening_card:
		player_hand.remove_card(card)
	play_pile.add_card(card)
	_turn_end()
	return true

func pass_turn():
	GameState.waiting_action = false
	GameState.skip_required = false
	GameState.pickup_required = false
	GameState.active_pickup_type = Types.pickup_type.NULL
	GameState.required_pickup_count = 0
	_turn_end()

func _turn_end():
	var turn_increment = 1
	# Prevent turn end if waiting for input
	if GameState.waiting_action:
		return

	# Card specific OnTurnEnd effects
	if GameState.skip_required:
		GameState.skip_required = false
		turn_increment = 2

	for i in range(turn_increment):
		if GameState.play_order_clockwise:
			GameState.current_player += 1
		else:
			GameState.current_player -= 1

		if GameState.current_player >= Rules.NUM_PLAYERS:
			GameState.current_player -= Rules.NUM_PLAYERS
		if GameState.current_player < 0:
			GameState.current_player += Rules.NUM_PLAYERS

	player_hand.update_playable()
	game_info.update()
	GameState.play_in_progress = false

	print("=============START=============")
	print("Player Turn: %s" % GameState.current_player)
	print("Current Card: Colour %s, Type %s" % [GameState.current_card_colour, GameState.current_card_type])
	print("Pickup Require: %s,  Active Pickup Type: %s, Pickup Count %s" % [GameState.pickup_required, GameState.active_pickup_type, GameState.required_pickup_count])
	print("Player Order: %s" % GameState.play_order_clockwise)
	print("Cards in Deck: %s, PlayPile: %s" % [deck.cards.size(), play_pile.cards.size()])
	print("==============END==============")

func _on_DrawButton_pressed():
	for i in range(max(1,GameState.required_pickup_count)):
		var drawn_card = deck.draw()
		player_hand.add_card(drawn_card)
	pass_turn()

func _on_WildPicker_wild_pick(colour):
	GameState.waiting_action = false
	GameState.current_card_colour = colour
	_turn_end()
