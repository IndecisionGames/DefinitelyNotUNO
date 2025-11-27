extends Control

@onready var version_text = find_child("VersionLabel")
@onready var version_file = "res://version"

@onready var msg_text = find_child("Message")

@onready var server_connect = find_child("ServerConnect")
@onready var server_option = find_child("ServerOption")
@onready var address_input = find_child("AddressInput")

@onready var lobby_connect = find_child("LobbyConnect")
@onready var host_toggle = find_child("HostToggle")
@onready var join_code_input = find_child("JoinCodeInput")
@onready var name_input = find_child("NameInput")
@onready var join_button = find_child("Join")

const EUROPE_SERVER = "35.211.109.121"

func _ready():
	Server.socket.connect("connection_succeeded", Callable(self, "_on_connection_succeeded"))
	Server.socket.connect("connection_failed", Callable(self, "_on_connection_failed"))

	msg_text.text = ""
	_set_version()
	lobby_connect.hide()
	
	server_option.add_item("Custom", 0)
	server_option.add_item("Europe", 1)
	server_option.select(1)
	address_input.hide()
	server_connect.show()

func _set_version():
	var file = FileAccess.open(version_file, FileAccess.READ)
	var version_number = file.get_as_text()
	version_text.text = "v" + version_number

func _on_Debug_pressed():
	Server.is_local = true
	Server.is_host = true
	SceneManager.goto_scene("res://src/game/Game.tscn", false)

# Server Connect
func _on_connection_succeeded():
	set_status("Connected to Server")
	server_connect.hide()
	lobby_connect.show()

func _on_connection_failed():
	set_error("Failed to Connect to Server")

func _on_ServerOption_item_selected(index):
	if index == 0:
		address_input.show()
	else:
		address_input.hide()

func _on_Connect_pressed():
	var ip = ""
	if server_option.selected == 0:
		ip = address_input.text.strip_edges()
	else:
		ip = EUROPE_SERVER
	Server.connect_to_server(ip)

# Lobby Connect
func _on_HostToggle_toggled(button_pressed):
	if button_pressed:
		join_code_input.hide()
		join_button.set_text("Host")
	else:
		join_code_input.show()
		join_button.set_text("Join")

func _on_Join_pressed():
	var p_name = name_input.text.strip_edges()
	if not _check_name(p_name):
		return
	if host_toggle.pressed:
		Server.host_lobby(p_name)
	else:
		var join_code = join_code_input.text.strip_edges()
		if not _check_join_code(join_code):
			return
		Server.join_lobby(p_name, join_code)

func _check_name(p_name):
	if p_name.length() == 0:
		set_error("Please enter a name")
		return false
	set_status("")
	return true

func _check_join_code(p_name):
	if p_name.length() == 0:
		set_error("Please enter a Join Code")
		return false
	set_status("")
	return true

# General
func set_error(text):
	msg_text.text = text
	msg_text.set("theme_override_colors/font_color", Values.red)

func set_status(text):
	msg_text.text = text
	msg_text.set("theme_override_colors/font_color", Values.green)
