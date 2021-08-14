extends Control

const CardBase = preload("res://src/game/common/CardBase.gd")

class_name Card

onready var background = get_node("Colour")
onready var card_image = get_node("CardImage")
onready var border = get_node("Border")
onready var tween = get_node("Tween")

var base: CardBase
var is_playable: bool

func setup(colour, type):
	is_playable = false
	base = CardBase.new()
	base.setup(colour, type)

func _ready():
	_set_border()
	_set_card_colour()
	_set_border()
	_set_card_asset()

func set_playable(playable: bool):
	is_playable = playable
	_set_border()

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
	if is_playable:
		border.set("custom_styles/panel", CardAssets.playable_border)
	else:
		border.set("custom_styles/panel", CardAssets.normal_border)

func _set_card_asset():
	card_image.set_texture(CardAssets.card_asset(base.type))

func _move_up():
	tween.interpolate_property(self, "rect_position", null, Vector2(rect_position.x, -80), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _move_down():
	tween.interpolate_property(self, "rect_position", null, Vector2(rect_position.x, 0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_Interact_mouse_entered():
	_set_border()
	_move_up()

func _on_Interact_mouse_exited():
	_set_border()
	_move_down()

func _on_Interact_pressed():
	if is_playable:
		Server.request_play_card(base)
