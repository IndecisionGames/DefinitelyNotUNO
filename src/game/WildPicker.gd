extends MarginContainer

onready var red = get_node("Buttons/Red")
onready var green = get_node("Buttons/Green")
onready var yellow = get_node("Buttons/Yellow")
onready var blue = get_node("Buttons/Blue")

var is_active = false

signal wild_pick(colour)

func _ready():
	hide()
	red.color = Types.red
	green.color = Types.green
	yellow.color = Types.yellow
	blue.color = Types.blue

func display_picker():
	is_active = true
	show()

func _on_RedButton_pressed():
	if is_active:
		emit_signal("wild_pick", Types.card_colour.RED)
		is_active = false
		hide()

func _on_GreenButton_pressed():
	if is_active:
		emit_signal("wild_pick", Types.card_colour.GREEN)
		is_active = false
		hide()

func _on_YellowButton_pressed():
	if is_active:
		emit_signal("wild_pick", Types.card_colour.YELLOW)
		is_active = false
		hide()

func _on_BlueButton_pressed():
	if is_active:
		emit_signal("wild_pick", Types.card_colour.BLUE)
		is_active = false
		hide()
