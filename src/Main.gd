extends Control

onready var nameText = find_node("NameText")
onready var playButton = find_node("Play")
onready var errorText = find_node("Error")

func _ready():
	errorText.text = ""

func _on_Play_pressed():
	var name = nameText.text.strip_edges()
	var check = check_name(name)
	
	if check:
		Server.connect_to_server(name)

func check_name(name):
	if name.length() == 0:
		errorText.text = "Please enter a name"
		return false
	errorText.text = ""
	return true

func _on_Debug_pressed():
	Server.is_local = true
	randomize()
	SceneManager.goto_scene("res://src/game/Game.tscn", false)

func set_error_text(txt):
	errorText.text = txt
