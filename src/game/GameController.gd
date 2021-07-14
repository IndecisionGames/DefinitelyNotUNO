extends GameState

onready var deck = get_node("Deck")
onready var play_pile = get_node("PlayPile")
onready var player_hand = get_node("PlayerHand")

func _input(event):
	if Input.is_action_just_pressed("right_click"):
		var drawn_card = deck.draw()
		play_pile.add_card(drawn_card)

	if Input.is_action_just_pressed("left_click"):
		var drawn_card = deck.draw()
		player_hand.add_card(drawn_card)


func play_card(player: int, card: CardBase):
	if !is_playable(player, card):
		print("this card can not be played")
		return
	
	current_card_type  = card.type
	current_card_colour = card.colour
	
	# Card specific OnPlay effects 
	if current_card_type == Types.card_type.CARD_SKIP:
		skip_required = true

	if current_card_type == Types.card_type.CARD_REVERSE:
		play_order_clockwise = !play_order_clockwise

	if current_card_colour == Types.card_type.CARD_PLUS2 or current_card_colour == Types.card_type.CARD_PLUS4:
		pickup_required = true

		if current_card_colour == Types.card_type.CARD_PLUS2:
			active_pickup_type = pickup_type.PLUS2
			current_pickup_count += 2

		if current_card_colour == Types.card_type.CARD_PLUS4:
			active_pickup_type = pickup_type.PLUS4
			current_pickup_count += 4

	if current_card_colour == Types.card_colour.WILD:
		# TODO: Add WILD pick colour logic
		pass

	_turn_end()

func skip_turn():
	skip_required = false
	pickup_required = false
	active_pickup_type = pickup_type.NULL
	current_pickup_count = 0
	_turn_end()

func _turn_end():
	var turn_increment = 1

	# Card specific OnTurnEnd effects 
	if skip_required:
		skip_required = false
		turn_increment = 2
	
	
	if play_order_clockwise:
		current_player += turn_increment
	else:
		current_player -= turn_increment

	if current_player >= Rules.NUM_PLAYERS:
		current_player -= Rules.NUM_PLAYERS
	if current_player < 0:
		current_player += Rules.NUM_PLAYERS
