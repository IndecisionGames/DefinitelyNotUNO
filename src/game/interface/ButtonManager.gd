extends Control

onready var draw = get_node("Draw")
onready var uno = get_node("Uno")
onready var wild_picker = get_node("WildPicker")

func _ready():
	Server.connect("wild_pick_request", self, "_on_wild_pick_request")
	draw.hide()
	uno.hide()
	wild_picker.hide()

func enable_draw_button(enable: bool):
	if enable:
		draw.show()
	else:
		draw.hide()

func enable_uno_button(enable: bool):
	if enable:
		uno.show()
	else:
		uno.hide()

func _on_wild_pick_request():
	wild_picker.show()

func _on_DrawButton_pressed():
	Server.request_draw_card()
	draw.hide()

func _on_UnoButton_pressed():
	Server.request_uno()
	uno.hide()

func _on_RedButton_pressed():
	Server.emit_wild_pick(Types.card_colour.RED)
	wild_picker.hide()

func _on_GreenButton_pressed():
	Server.emit_wild_pick(Types.card_colour.GREEN)
	wild_picker.hide()

func _on_YellowButton_pressed():
	Server.emit_wild_pick(Types.card_colour.YELLOW)
	wild_picker.hide()

func _on_BlueButton_pressed():
	Server.emit_wild_pick(Types.card_colour.BLUE)
	wild_picker.hide()
