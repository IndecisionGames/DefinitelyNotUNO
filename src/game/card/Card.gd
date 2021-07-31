extends Control

const CardBase = preload("res://src/game/common/CardBase.gd")

class_name Card

onready var background = get_node("Colour")
onready var card_image = get_node("CardImage")
onready var border = get_node("Border")

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
	_set_border()
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
	_set_border()

func _set_face_up():
	is_face_up = true

	_set_card_colour()
	_set_border()
	_set_card_asset()

func _set_face_down():
	is_face_up = false
	card_image.set_texture(CardAssets.card_back_asset)
	border.set("custom_styles/panel", CardAssets.normal_border)

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

func _set_border():
	if !is_in_hand:
		border.set("custom_styles/panel", CardAssets.normal_border)
	elif is_hovered:
		border.set("custom_styles/panel", CardAssets.hover_border)
	elif is_playable:
		border.set("custom_styles/panel", CardAssets.playable_border)
	else:
		border.set("custom_styles/panel", CardAssets.normal_border)

func _set_card_asset():
	card_image.set_texture(CardAssets.card_asset(base.type))

func _move_up():
	set_position(Vector2(rect_position.x, -40))

func _move_down():
	set_position(Vector2(rect_position.x, 0))

func _on_Interact_mouse_entered():
	if is_in_hand:
		is_hovered = true
		_set_border()
		_move_up()

func _on_Interact_mouse_exited():
	if is_in_hand:
		is_hovered = false
		_set_border()
		_move_down()

func _on_Interact_pressed():
	if is_playable:
		Server.request_play_card(base)
