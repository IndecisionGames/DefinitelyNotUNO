extends Control

onready var rule1_name = get_node("VBoxContainer/Rule1/HBoxContainer/RuleName") 
onready var rule1_value = get_node("VBoxContainer/Rule1/HBoxContainer/Input")
onready var rule2_name = get_node("VBoxContainer/Rule2/HBoxContainer/RuleName") 
onready var rule2_value = get_node("VBoxContainer/Rule2/HBoxContainer/Input")
onready var rule3_name = get_node("VBoxContainer/Rule3/HBoxContainer/RuleName") 
onready var rule3_value = get_node("VBoxContainer/Rule3/HBoxContainer/Input")

func _ready():
	rule1_name.text = "PLAY_AFTER_DRAW"
	rule2_name.text = "JUMP_IN"
	rule3_name.text = "STACK_PLUS4_ON_PLUS2"

func get_rules():
	return {
		"PLAY_AFTER_DRAW": rule1_value.pressed, 
		"JUMP_IN": rule2_value.pressed,
		"STACK_PLUS4_ON_PLUS2": rule3_value.pressed,
	}
