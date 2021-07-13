extends Node2D

onready var play_pile = get_node("PlayPile")
onready var deck = get_node("Deck")

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		var drawn_card = deck.draw()
		play_pile.add_child(drawn_card)
		drawn_card.set_position(Vector2(0,0))
		drawn_card.flip()

	if Input.is_action_just_pressed("right_click"):
		var drawn_card = deck.draw()
		play_pile.add_child(drawn_card)
		drawn_card.set_position(Vector2(0,0))
