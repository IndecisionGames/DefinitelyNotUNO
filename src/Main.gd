extends Control

onready var name_text = find_node("NameText")
onready var address_text = find_node("AddressText")
onready var error_text = find_node("Error")

func _ready():
	error_text.text = ""

func _on_Play_pressed():
	var name = name_text.text.strip_edges()
	var check = check_name(name)
	var ip = address_text.text.strip_edges()
	
	if check:
		Server.connect_to_server(name, ip)

func check_name(name):
	if name.length() == 0:
		error_text.text = "Please enter a name"
		return false
	error_text.text = ""
	return true

func _on_Debug_pressed():
	Server.is_local = true
	randomize()
	SceneManager.goto_scene("res://src/game/Game.tscn", false)

func set_error_text(txt):
	error_text.text = txt
