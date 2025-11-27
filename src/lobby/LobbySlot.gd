extends Control

@onready var active_panel = find_child("ActivePanel")
@onready var ready_on = find_child("ReadyON")
@onready var name_label = find_child("NameLabel")
@onready var highlight_panel = find_child("HighlightPanel")

var is_ready = false

func _ready():
	ready_on.visible = is_ready
	name_label.text = "Player"
	active_panel.visible = false
	highlight_panel.visible = false

func add_player(name):
	name_label.text = name
	active_panel.visible = true

func remove_player():
	active_panel.visible = false
	is_ready = false
	ready_on.visible = is_ready
	highlight_panel.visible = false

func toggle_ready():
	if active_panel.visible:
		is_ready = !is_ready;
		ready_on.visible = is_ready

func highlight():
	highlight_panel.visible = true
