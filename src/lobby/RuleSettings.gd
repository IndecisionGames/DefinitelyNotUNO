extends Control

onready var rule1_bg = get_node("VBoxContainer/Rule1")
onready var rule1_name = get_node("VBoxContainer/Rule1/Name") 
onready var rule2_bg = get_node("VBoxContainer/Rule2")
onready var rule2_name = get_node("VBoxContainer/Rule2/Name") 
onready var rule3_bg = get_node("VBoxContainer/Rule3")
onready var rule3_name = get_node("VBoxContainer/Rule3/Name")

var rule1 = false
var rule2 = false
var rule3 = false

func _ready():
	rule1_name.text = "PLAY_AFTER_DRAW"
	rule2_name.text = "JUMP_IN"
	rule3_name.text = "STACK_PLUS4_ON_PLUS2"
	_update_colours()

func sync_rules(rules={}):
	rule1 = rules.get("PLAY_AFTER_DRAW", rule1)
	rule2 = rules.get("JUMP_IN", rule2)
	rule3 = rules.get("STACK_PLUS4_ON_PLUS2", rule3)
	_update_colours()

func _rules():
	return {
		"PLAY_AFTER_DRAW": rule1, 
		"JUMP_IN": rule2,
		"STACK_PLUS4_ON_PLUS2": rule3,
	}

func _on_Rule1_Button_toggled(button_pressed):
	if Server.is_host:
		rule1 = button_pressed
		_update_colours()
		Server.update_rules(_rules())

func _on_Rule2_Button_toggled(button_pressed):
	if Server.is_host:
		rule2 = button_pressed
		_update_colours()
		Server.update_rules(_rules())

func _on_Rule3_Button_toggled(button_pressed):
	if Server.is_host:
		rule3 = button_pressed
		_update_colours()
		Server.update_rules(_rules())

func _update_colours():
	rule1_bg.color = Values.green if rule1 else Values.red
	rule2_bg.color = Values.green if rule2 else Values.red
	rule3_bg.color = Values.green if rule3 else Values.red
