extends Control

const Card = preload("res://src/game/card/DummyCard.tscn")
onready var name_label = get_node("Name")
onready var card_count_label = get_node("CardCount")

var cards = []
var card_no = 0

func _set_name(name):
	name_label.text = name

func _update():
	card_count_label.text = str(card_no)
	while len(cards) < card_no:
		var card_instance = Card.instance()
		cards.append(card_instance)
		add_child(card_instance)

	while len(cards) > card_no:
		var card_instance = cards[0]
		cards.remove(0)
		remove_child(card_instance)

	if len(cards) < 1:
		return 

	var original_card_width = 67
	var scaling_factor = 4.78
	var card_width = original_card_width/scaling_factor

	var seperation_factor = 0.7
	if card_no > 5 and card_no <= 15:
		seperation_factor = range_lerp(card_no, 5, 15, 0.7, 0.4)
		
	if card_no > 15:
		var max_width = 6 * card_width
		seperation_factor = max_width / (card_no * card_width)

	var center_amount = - 0.5 * (card_no * card_width * seperation_factor * scaling_factor)

	if card_no > 13:
		center_amount -= ((card_no - 13) * card_width * seperation_factor * 0.7)

	for i in range(cards.size()):
		cards[i].set_position(Vector2(40+center_amount + ((i-1) * card_width * seperation_factor * scaling_factor), -30))
