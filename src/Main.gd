extends Control

onready var name_text = find_node("NameText")
onready var address_text = find_node("AddressText")
onready var error_text = find_node("Error")
onready var version_text = find_node("VersionLabel")
onready var version_file = "res://version"

func _ready():
	error_text.text = ""
	_set_version()

func _set_version():
	var f = File.new()
	f.open(version_file, File.READ)
	var line = f.get_line()
	version_text.text = "v" + str(line)
	f.close()

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
	Server.is_host = true
	SceneManager.goto_scene("res://src/game/Game.tscn", false)

func set_error_text(txt):
	error_text.text = txt
