extends MarginContainer

onready var red = get_node("Buttons/Red")
onready var green = get_node("Buttons/Green")
onready var yellow = get_node("Buttons/Yellow")
onready var blue = get_node("Buttons/Blue")

signal wild_pick(colour)

func _ready():
	hide()
	red.color = Types.red
	green.color = Types.green
	yellow.color = Types.yellow
	blue.color = Types.blue

func display_picker():
	show()

func _on_RedButton_pressed():
	emit_signal("wild_pick", Types.card_colour.RED)
	hide()

func _on_GreenButton_pressed():
	emit_signal("wild_pick", Types.card_colour.GREEN)
	hide()

func _on_YellowButton_pressed():
	emit_signal("wild_pick", Types.card_colour.YELLOW)
	hide()

func _on_BlueButton_pressed():
	emit_signal("wild_pick", Types.card_colour.BLUE)
	hide()
