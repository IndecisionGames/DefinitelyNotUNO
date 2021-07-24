extends MarginContainer

func _ready():
	hide()

func enable_button(enable: bool):
	if enable:
		show()
	else:
		hide()

func _on_UnoButton_pressed():
	hide()
