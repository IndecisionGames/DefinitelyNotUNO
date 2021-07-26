extends Control

onready var active_panel = find_node("ActivePanel")
onready var ready_on = find_node("ReadyON")
onready var name_label = find_node("NameLabel")
onready var highlight_panel = find_node("HighlightPanel")

var is_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ready_on.visible = is_ready
	name_label.text = "Player"
	active_panel.visible = false
	highlight_panel.visible = false

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
	highlight_panel.visible = false

func get_is_ready():
	return is_ready

func toggle_ready():
	if active_panel.visible:
		is_ready = !is_ready;
		ready_on.visible = is_ready

func set_highlight(b):
	highlight_panel.visible = b
