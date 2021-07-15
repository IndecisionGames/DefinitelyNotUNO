extends Control

onready var active_panel = find_node("ActivePanel")
onready var ready_on = find_node("ReadyON")
onready var name_label = find_node("NameLabel")

var is_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ready_on.visible = is_ready
	name_label.text = "Player"
	active_panel.visible = false

# DEBUG===========================================
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_I:
			toggle_ready()
		if event.pressed and event.scancode == KEY_O:
			add_player("ExodusIV")
		if event.pressed and event.scancode == KEY_P:
			remove_player()
# ================================================

func add_player(name):
	name_label.text = name
	active_panel.visible = true

func remove_player():
	active_panel.visible = false
	is_ready = false
	ready_on.visible = is_ready

func get_is_ready():
	return is_ready

func toggle_ready():
	if active_panel.visible:
		is_ready = !is_ready;
		ready_on.visible = is_ready

func transfer_slot(another_slot):
	ready_on.visible = another_slot.ready_on.visible
	name_label.text = another_slot.name_label.text
	active_panel.visible = another_slot.active_panel.visible
