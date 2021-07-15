extends CardBase

class_name Card

onready var background = get_node("Background")
onready var border = get_node("Border")
onready var top_label = get_node("Text/Top/Label")
onready var mid_label = get_node("Text/Middle/Label")
onready var bot_label = get_node("Text/Bottom/Label")

var is_face_up: bool
var is_playable: bool
var is_hovered: bool

func setup(colour, type):
	self.colour = colour
	self.type = type

func _ready():
	is_playable = false
	is_hovered = false
	_set_border_color()
	set_face_down()

func flip():
	if is_face_up:
		set_face_down()
	else:
		set_face_up()

func set_face_up():
	is_face_up = true
	var card_string = Types.card_type_to_string(type)

	top_label.text = card_string
	mid_label.text = card_string
	bot_label.text = card_string
	background.color = Types.card_colour_to_colour(colour)

func set_face_down():
	is_face_up = false

	top_label.text = ""
	mid_label.text = "Uno"
	bot_label.text = ""
	background.color = Types.facedown

func set_playable(playable: bool):
	is_playable = playable
	_set_border_color()

func _on_Interact_mouse_entered():
	is_hovered = true
	_set_border_color()

func _on_Interact_mouse_exited():
	is_hovered = false
	_set_border_color()

func _set_border_color():
	if is_hovered:
		border.border_color = Types.hover
	elif is_playable:
		border.border_color = Types.playable
	else:
		border.border_color = Types.facedown
