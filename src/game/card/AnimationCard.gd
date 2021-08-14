extends Control

const CardBase = preload("res://src/game/common/CardBase.gd")

const POSITION_VARIANCE = 10
const ROTATION_VARIANCE = 10

onready var background = get_node("Colour")
onready var card_image = get_node("CardImage")
onready var move_tween = get_node("MovementTween")
onready var rotate_tween = get_node("RotationTween")

var base: CardBase

func setup(colour, type, global_pos, rot):
	base = CardBase.new()
	base.setup(colour, type)
	set_colour(colour)
	_set_card_asset()
	set_global_position(global_pos)
	set_rotation(rot)

func move_to(pos):
	pos = Vector2(rand_range(pos.x - POSITION_VARIANCE, pos.x + POSITION_VARIANCE),
		rand_range(pos.y - POSITION_VARIANCE, pos.y + POSITION_VARIANCE))
	var rot = rand_range(-ROTATION_VARIANCE, ROTATION_VARIANCE)

	move_tween.interpolate_property(self, "rect_global_position", 
		rect_global_position, pos, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	move_tween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	rotate_tween.interpolate_property(self, "rect_rotation", 
		rect_rotation, rot, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	rotate_tween.start()

func set_colour(colour):
	match colour:
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
