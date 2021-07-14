extends MarginContainer

class_name Card

onready var background = get_node("Background")
onready var top_label = get_node("Text/Top/Label")
onready var mid_label = get_node("Text/Middle/Label")
onready var bot_label = get_node("Text/Bottom/Label")

var colour: int
var type: int

var is_face_up: bool

func setup(colour, type):
	self.colour = colour
	self.type = type

func _ready():
	set_face_down()
	
func flip():
	if is_face_up:
		set_face_down()
	else:
		set_face_up()

func set_face_up():
	is_face_up = true
	var card_string = Types.card_type_to_string(self.type)
	
	top_label.text = card_string
	mid_label.text = card_string
	bot_label.text = card_string
	background.color = Types.card_colour_to_colour(self.colour)
	
func set_face_down():
	is_face_up = false
	
	top_label.text = ""
	mid_label.text = "Uno"
	bot_label.text = ""
	background.color = Types.facedown
