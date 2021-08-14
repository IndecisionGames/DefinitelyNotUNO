extends Control

const Card = preload("res://src/game/card/DummyCard.tscn")

const CARD_WIDTH = 67
const BASE_SEPERATION = 30
const MAX_WIDTH = 360
const NUM_AT_MAX = 13

onready var name_label = get_node("Name")
onready var card_count_label = get_node("CardCount")

var cards = []
var card_no = 0

func update_hand(name, card_count, is_current_player, is_uno):
	var text = ""
	if is_current_player:
		text = "> %s <" % name
	else:
		text = name

	# TODO: Move to own Label
	if is_uno:
		text += "(UNO)"

	name_label.text = text
	card_no = card_count
	_update_cards()

func _update_cards():
	card_count_label.text = str(card_no)
	while cards.size() < card_no:
		var card_instance = Card.instance()
		cards.append(card_instance)
		add_child(card_instance)

	while cards.size() > card_no:
		remove_child(cards.pop_front())

	if cards.size() < 1:
		return 

	var card_seperation = BASE_SEPERATION
	if card_no > NUM_AT_MAX:
		card_seperation = float(MAX_WIDTH)/float(self.cards.size()-1)

	for i in range(self.cards.size()):
		cards[i].set_position(Vector2(-CARD_WIDTH/2-card_seperation/2*(self.cards.size()-1)+i*card_seperation,-30))
