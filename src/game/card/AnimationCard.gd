extends Control

const CardBase = preload("res://src/game/common/CardBase.gd")

const POSITION_VARIANCE = 10
const ROTATION_VARIANCE = 10
const DECK_POSITION = Vector2(587,487)

@onready var background = get_node("Colour")
@onready var card_image = get_node("CardImage")

var base: CardBase

func setup_draw():
	set_global_position(DECK_POSITION)
	set_rotation(0)
	set_card_asset(CardAssets.card_back_asset)

func setup(colour, type, global_pos, rot):
	base = CardBase.new()
	base.setup(colour, type)
	set_colour(colour)
	set_card_asset(CardAssets.card_asset(base.type))
	set_global_position(global_pos)
	set_rotation(rot)

func draw_to(pos, rot):
	var rotate_tween = get_tree().create_tween()
	var move_tween = get_tree().create_tween()
	rotate_tween.tween_property(self, "rotation", rot, 0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	move_tween.tween_property(self, "global_position", pos, 0.30).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	move_tween.tween_callback(get_parent().remove_child.bind(self))
	move_tween.tween_callback(self.queue_free)
	
	#rotate_tween.interpolate_property(self, "rotation", 
		#rot, 0, 0.25, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	#rotate_tween.start()
	#move_tween.interpolate_property(self, "global_position", 
		#global_position, pos, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#move_tween.start()
	#await get_tree().create_timer(0.3).timeout
	#get_parent().remove_child(self)
	#queue_free()

func move_to(pos):
	if (global_position.x - pos.x == 0 and global_position.y - pos.y == 0):
		return
	pos = Vector2(randf_range(pos.x - POSITION_VARIANCE, pos.x + POSITION_VARIANCE),
		randf_range(pos.y - POSITION_VARIANCE, pos.y + POSITION_VARIANCE))
	var rot = randf_range(-ROTATION_VARIANCE, ROTATION_VARIANCE)

	move_tween.interpolate_property(self, "global_position", 
		global_position, pos, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	move_tween.start()
	await get_tree().create_timer(0.2).timeout

	var original_rot = rotation
	if original_rot != 0:
		original_rot = wrapf(original_rot, 0, 360)
		rot = wrapf(rot, 0, 360)

	rotate_tween.interpolate_property(self, "rotation", 
		original_rot, rot, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
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

func set_card_asset(asset):
	card_image.set_texture(asset)

func flip():
	set_scale(Vector2(-1, -1))
