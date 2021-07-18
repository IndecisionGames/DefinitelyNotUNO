extends MarginContainer

onready var red = get_node("DrawButton")

func _ready():
	hide()

func allow_draw(enable: bool):
	if enable:
		show()
	else:
		hide()
