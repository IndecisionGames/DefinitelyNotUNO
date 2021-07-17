extends Node2D

onready var deck = get_node("Deck")
onready var play_pile = get_node("PlayPile")
onready var player_hand = get_node("PlayerHand")
onready var game_info = get_node("GameInfo")

func _ready():
	player_hand.connect("play", self, "play_card")
	var drawn_card = deck.draw()
	GameState.current_card_type = drawn_card.type
	GameState.current_card_colour = drawn_card.colour
	play_pile.add_card(drawn_card)
	player_hand.update_playable()
	

func _input(event):
	pass


func play_card(player: int, card: Card) -> bool:
	if !GameState.is_playable(player, card):
		print("this card can not be played")
		return false
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

		if GameState.current_card_colour == Types.card_type.CARD_PLUS4:
			GameState.active_pickup_type = Types.pickup_type.PLUS4
			GameState.required_pickup_count += 4

	if GameState.current_card_colour == Types.card_colour.WILD:
		# TODO: Add WILD pick colour logic
		pass

	# Update Card States

	player_hand.remove_card(card)
	play_pile.add_card(card)
	_turn_end()
	return true

func pass_turn():
	GameState.skip_required = false
	GameState.pickup_required = false
	GameState.active_pickup_type = Types.pickup_type.NULL
	GameState.required_pickup_count = 0
	_turn_end()

func _turn_end():
	var turn_increment = 1

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

	print("=============START=============")
	print("Player Turn: %s" % GameState.current_player)
	print("Current Card: Colour %s, Type %s" % [GameState.current_card_colour, GameState.current_card_type])
	print("Pickup Require: %s,  Active Pickup Type: %s, Pickup Count %s" % [GameState.pickup_required, GameState.active_pickup_type, GameState.required_pickup_count])
	print("Player Order: %s" % GameState.play_order_clockwise)
	print("==============END==============")


func _on_DrawButton_pressed():
	for i in range(max(1,GameState.required_pickup_count)):
		var drawn_card = deck.draw()
		if !drawn_card:
			print("out of cards")
			return
		player_hand.add_card(drawn_card)
	pass_turn()
