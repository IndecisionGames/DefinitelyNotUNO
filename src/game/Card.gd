extends MarginContainer

class_name Card

const Types = preload("res://src/game/Types.gd")

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
	
	top_label.text = "%s" % self.type
	mid_label.text = "%s" % self.type
	bot_label.text = "%s" % self.type
	background.color = Types.card_colour_to_colour(self.colour)
	
func set_face_down():
	is_face_up = false
	
	top_label.text = ""
	mid_label.text = "Uno"
	bot_label.text = ""
	background.color = Types.facedown
