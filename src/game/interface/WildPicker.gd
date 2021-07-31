extends MarginContainer

onready var red = get_node("Buttons/Red")
onready var green = get_node("Buttons/Green")
onready var yellow = get_node("Buttons/Yellow")
onready var blue = get_node("Buttons/Blue")

func _ready():
	red.color = Values.red
	green.color = Values.green
	yellow.color = Values.yellow
	blue.color = Values.blue
