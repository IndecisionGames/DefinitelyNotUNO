extends Node2D

const GameState = preload("res://src/game/GameState.gd")

onready var deck = get_node("Deck")
onready var play_pile = get_node("PlayPile")
onready var player_hand = get_node("PlayerHand")

func _input(event):
	if Input.is_action_just_pressed("right_click"):
		var drawn_card = deck.draw()
		play_pile.add_child(drawn_card)

	if Input.is_action_just_pressed("left_click"):
		var drawn_card = deck.draw()
		player_hand.add_card(drawn_card)
		
	if Input.is_action_just_pressed("ui_accept"):
		var drawn_card = deck.draw()
		player_hand.add_card(drawn_card)
