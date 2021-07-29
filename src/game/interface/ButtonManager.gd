extends Control

onready var draw = get_node("Draw")
onready var uno = get_node("Uno")
onready var wild_picker = get_node("WildPicker")

func _ready():
	GameState.connect("wild_pick_request", self, "_enable_wild_picker")
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

func _enable_wild_picker(player):
	if player == Server.player_id:
		wild_picker.show()

func _on_DrawButton_pressed():
	GameState.request_draw_card(Server.player_id)
	draw.hide()

func _on_UnoButton_pressed():
	GameState.request_uno(Server.player_id)
	uno.hide()

func _on_RedButton_pressed():
	GameState.emit_wild_pick(Types.card_colour.RED)
	wild_picker.hide()

func _on_GreenButton_pressed():
	GameState.emit_wild_pick(Types.card_colour.GREEN)
	wild_picker.hide()

func _on_YellowButton_pressed():
	GameState.emit_wild_pick(Types.card_colour.YELLOW)
	wild_picker.hide()

func _on_BlueButton_pressed():
	GameState.emit_wild_pick(Types.card_colour.BLUE)
	wild_picker.hide()
