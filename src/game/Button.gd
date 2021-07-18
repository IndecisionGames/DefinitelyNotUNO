extends MarginContainer

func _ready():
	hide()

func enable_button(enable: bool):
	if enable:
		show()
	else:
		hide()
