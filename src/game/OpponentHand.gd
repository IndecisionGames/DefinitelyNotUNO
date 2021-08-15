extends Control

const Card = preload("res://src/game/card/DummyCard.tscn")
const AnimationCard = preload("res://src/game/card/AnimationCard.tscn")

const CARD_WIDTH = 67
const BASE_SEPERATION = 30
const MAX_WIDTH = 360
const NUM_AT_MAX = 13

onready var name_label = get_node("Name")
onready var card_count_label = get_node("CardCount")

var cards = []
var card_no = 0

func update_hand(name, card_count, is_current_player, is_uno):
	var text = name
	var count_text = str(card_count)
	if is_current_player:
		name_label.set("custom_colors/font_color", Values.current_player)
		name_label.set_scale(Vector2(1.5, 1.5))
	else:
		name_label.set("custom_colors/font_color", Values.white)
		name_label.set_scale(Vector2(1, 1))

	if is_uno:
		card_count_label.set("custom_colors/font_color", Values.red)
		count_text = "UNO"
	else:
		card_count_label.set("custom_colors/font_color", Values.white)


	name_label.text = text
	card_no = card_count
	card_count_label.text = count_text
	_update_cards()

func _update_cards():
	
	if cards.size() < card_no:
		var drawing = card_no - cards.size()
		play_draw_animation(drawing)
		var timeout = drawing * 0.22
		yield(get_tree().create_timer(timeout), "timeout")

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

func play_draw_animation(n):
	var target_position = get_parent().rect_position
	var initial_rotation = get_parent().rect_rotation * -1
	for _i in range(n):
		var draw_card_instance = AnimationCard.instance()
		add_child(draw_card_instance)
		draw_card_instance.setup_draw()
		draw_card_instance.draw_to(target_position,initial_rotation)
		yield(get_tree().create_timer(0.2), "timeout")
