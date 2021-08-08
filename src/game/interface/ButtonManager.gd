extends Control

onready var draw = get_node("Draw")
onready var uno = get_node("Uno")
onready var wild_picker = get_node("WildPicker")
onready var top_deck = get_node("../PlaySpace/Deck/TopDeckLayer/TopDeckLayer2/TopDeckCard2")
onready var tween = get_node("Draw/Tween")
onready var ripple_anim = get_node("Draw/Ripple")
onready var ripple_anim2 = get_node("Draw/Ripple2")
onready var highlight1 = get_node("Draw/Highlight")
onready var highlight2 = get_node("Draw/Highlight2")

var draw_card_position
var ripple_playing = false

func _ready():
	Server.connect("wild_pick_request", self, "_on_wild_pick_request")
	# draw.hide()
	uno.hide()
	wild_picker.hide()
	draw_card_position = top_deck.rect_position
	play_ripple_anim()

func enable_draw_button(enable: bool):
	if enable:
		draw.show()
	else:
		reset_top_deck_position()
		# draw.hide()

func enable_uno_button(enable: bool):
	if enable:
		uno.show()
	else:
		uno.hide()

func _on_wild_pick_request():
	wild_picker.show()

func _on_DrawButton_pressed():
	Server.request_draw_card()
	reset_top_deck_position()
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

func _on_DrawButton_mouse_entered():
	tween.interpolate_property(top_deck, "rect_position", null, draw_card_position + Vector2(0, 40), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _on_DrawButton_mouse_exited():
	reset_top_deck_position()

func reset_top_deck_position():
	tween.interpolate_property(top_deck, "rect_position", null, draw_card_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func play_ripple_anim():
	ripple_playing = true
	ripple_anim.play("DrawRipple")
	yield(get_tree().create_timer(1), "timeout")
	if ripple_playing:
		ripple_anim2.play("DrawRipple2")

func stop_ripple_anim():
	ripple_playing = false
	ripple_anim.stop()
	ripple_anim2.stop()
