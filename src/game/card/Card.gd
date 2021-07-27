extends MarginContainer

const CardBase = preload("res://src/game/card/CardBase.gd")

class_name Card

onready var background = get_node("Background")
onready var border = get_node("Border")
onready var top_label = get_node("Text/Top/Label")
onready var mid_label = get_node("Text/Middle/Label")
onready var bot_label = get_node("Text/Bottom/Label")

var base: CardBase
var is_face_up: bool
var is_playable: bool
var is_hovered: bool
var is_in_hand: bool

signal play(card)

func setup(colour, type):
	base = CardBase.new()
	base.setup(colour, type)

func _ready():
	is_playable = false
	is_hovered = false
	_set_border_color()
	_set_face_down()

func set_in_hand():
	is_in_hand = true
	_set_face_up()

func set_in_play():
	is_in_hand = false
	is_hovered = false
	is_playable = false
	_set_face_up()

func set_playable(playable: bool):
	is_playable = playable
	_set_border_color()

func _set_face_up():
	is_face_up = true
	var card_string = base.type()

	top_label.text = card_string
	mid_label.text = card_string
	bot_label.text = card_string
	background.color = base.colour()
	_set_border_color()

func _set_face_down():
	is_face_up = false

	top_label.text = ""
	mid_label.text = "Uno"
	bot_label.text = ""
	background.color = Types.facedown
	_set_border_color()

func _set_border_color():
	if !is_in_hand:
		border.border_color = Types.facedown
	elif is_hovered:
		border.border_color = Types.hover
	elif is_playable:
		border.border_color = Types.playable
	else:
		border.border_color = Types.facedown

func _on_Interact_mouse_entered():
	if is_in_hand:
		is_hovered = true
		_set_border_color()

func _on_Interact_mouse_exited():
	if is_in_hand:
		is_hovered = false
		_set_border_color()

func _on_Interact_pressed():
	if is_playable:
		emit_signal("play", self)
