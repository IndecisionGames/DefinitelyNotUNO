extends Control

const CardBase = preload("res://src/game/common/CardBase.gd")

onready var background = get_node("Colour")
onready var card_image = get_node("CardImage")
onready var move_tween = get_node("MovementTween")
onready var rotate_tween = get_node("RotationTween")

var base: CardBase

func setup(colour, type, global_pos, rot):
	base = CardBase.new()
	base.setup(colour, type)
	_set_card_colour()
	_set_card_asset()
	set_global_position(global_pos)
	set_rotation(rot)

# debug
func _input(event):
	if event is InputEventMouseButton:
		move_to(event.global_position)
		print("moving to ", event.global_position)
	elif event is InputEventKey and event.pressed:
		if event.scancode == KEY_Q:
			rect_rotation += 5
		if event.scancode == KEY_E:
			rect_rotation -= 5

func move_to(pos):
	move_tween.interpolate_property(self, "rect_global_position", 
		rect_global_position, pos, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	move_tween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	rotate_tween.interpolate_property(self, "rect_rotation", 
		rect_rotation, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	rotate_tween.start()

func _set_card_colour():
	match base.colour:
		Types.card_colour.RED:
			background.color = Values.red
		Types.card_colour.GREEN:
			background.color = Values.green
		Types.card_colour.BLUE:
			background.color = Values.blue
		Types.card_colour.YELLOW:
			background.color = Values.yellow
		Types.card_colour.WILD:
			background.color = Values.wild

func _set_card_asset():
	card_image.set_texture(CardAssets.card_asset(base.type))
