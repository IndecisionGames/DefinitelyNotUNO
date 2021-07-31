extends Node

const CardBase = preload("res://src/game/card/CardBase.gd")

class_name Card

onready var background = get_node("Colour")
onready var card_image = get_node("CardImage")
# onready var border = get_node("Border")

var base: CardBase
var is_face_up: bool
var is_playable: bool
var is_hovered: bool
var is_in_hand: bool

func setup(colour, type):
	base = CardBase.new()
	base.setup(colour, type)

func _ready():
	is_playable = false
	is_hovered = false
	_set_border_color()
	_set_face_down()
	_set_card_asset()

func set_in_hand():
	is_in_hand = true
	_set_face_up()
	_set_card_asset()

func set_in_play():
	is_in_hand = false
	is_hovered = false
	is_playable = false
	_set_face_up()
	_set_card_asset()

func set_playable(playable: bool):
	is_playable = playable
	_set_border_color()

func _set_face_up():
	is_face_up = true
	var card_string = base.type()

	_set_card_colour()
	_set_border_color()
	_set_card_asset()

func _set_face_down():
	# TODO: add facedown asset
	is_face_up = false
	background.color = Values.facedown
	# border.border_color = Values.facedown

func _set_card_colour():
	match base.colour:
		Types.card_colour.RED:
			background.color = Values.red
		Types.card_colour.GREEN:
			background.color = Values.green
		Types.card_colour.BLUE:
			background.color = Values.blue
		Types.card_colour.YELLOW:
			background.color = Values.yellow
		Types.card_colour.WILD:
			background.color = Values.wild

func _set_border_color():
	# TODO: Add border
	pass
	# if !is_in_hand:
	# 	border.border_color = Values.facedown
	# elif is_hovered:
	# 	border.border_color = Values.hover
	# elif is_playable:
	# 	border.border_color = Values.playable
	# else:
	# 	border.border_color = Values.facedown

func _set_card_asset():
	card_image.set_texture(base.card_asset())

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
		Server.request_play_card(base)
