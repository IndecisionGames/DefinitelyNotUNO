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
		join_server(name, "localhost", "default")

func join_server(name, ip, port):
	Net.join_server(name, ip, port)

func check_name(name):
	if name.length() == 0:
		errorText.text = "Please enter a name"
		return false
	errorText.text = ""
	return true

func _process(_delta):
	if Net.status == 1:
		errorText.text = "Connecting..."
	if Net.status == -1:
		errorText.text = "Failed to connect, make sure the server address is correct."

func _on_Debug_pressed():
	SceneManager.goto_scene("res://src/game/Game.tscn", false)