extends Node2D

onready var deck = get_node("Deck")
onready var play_pile = get_node("PlayPile")
onready var player_hand = get_node("PlayerHand")

func _input(event):
	# Force Play from Deck
	if Input.is_action_just_pressed("ui_left"):
		var drawn_card = deck.draw()

		GameState.current_card_type = drawn_card.type
		GameState.current_card_colour = drawn_card.colour
		play_pile.add_card(drawn_card)
		player_hand.update_cards()

	# Force Draw
	if Input.is_action_just_pressed("ui_right"):
		var drawn_card = deck.draw()
		player_hand.add_card(drawn_card)
		player_hand.update_cards()


func play_card(player: int, card: Card):
	if !GameState.is_playable(player, card):
		print("this card can not be played")
		return

	GameState.current_card_type  = card.type
	GameState.current_card_colour = card.colour

	# Card specific OnPlay effects
	if GameState.current_card_type == Types.card_type.CARD_SKIP:
		GameState.skip_required = true

	if GameState.current_card_type == Types.card_type.CARD_REVERSE:
		GameState.play_order_clockwise = !GameState.play_order_clockwise

	if GameState.current_card_colour == Types.card_type.CARD_PLUS2 or GameState.current_card_colour == Types.card_type.CARD_PLUS4:
		GameState.pickup_required = true

		if GameState.current_card_colour == Types.card_type.CARD_PLUS2:
			GameState.active_pickup_type = Types.pickup_type.PLUS2
			GameState.current_pickup_count += 2

		if GameState.current_card_colour == Types.card_type.CARD_PLUS4:
			GameState.active_pickup_type = Types.pickup_type.PLUS4
			GameState.current_pickup_count += 4

	if GameState.current_card_colour == Types.card_colour.WILD:
		# TODO: Add WILD pick colour logic
		pass

	_turn_end()

func skip_turn():
	GameState.skip_required = false
	GameState.pickup_required = false
	GameState.active_pickup_type = Types.pickup_type.NULL
	GameState.current_pickup_count = 0
	_turn_end()

func _turn_end():
	var turn_increment = 1

	# Card specific OnTurnEnd effects
	if GameState.skip_required:
		GameState.skip_required = false
		turn_increment = 2


	if GameState.play_order_clockwise:
		GameState.current_player += turn_increment
	else:
		GameState.current_player -= turn_increment

	if GameState.current_player >= Rules.NUM_PLAYERS:
		GameState.current_player -= Rules.NUM_PLAYERS
	if GameState.current_player < 0:
		GameState.current_player += Rules.NUM_PLAYERS
