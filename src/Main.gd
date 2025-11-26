extends Control

onready var version_text = find_node("VersionLabel")
onready var version_file = "res://version"

onready var msg_text = find_node("Message")

onready var server_connect = find_node("ServerConnect")
onready var server_option = find_node("ServerOption")
onready var address_input = find_node("AddressInput")

onready var lobby_connect = find_node("LobbyConnect")
onready var host_toggle = find_node("HostToggle")
onready var join_code_input = find_node("JoinCodeInput")
onready var name_input = find_node("NameInput")
onready var join_button = find_node("Join")

const EUROPE_SERVER = "35.211.109.121"

func _ready():
	Server.network.connect("connection_succeeded", self, "_on_connection_succeeded")
	Server.network.connect("connection_failed", self, "_on_connection_failed")

	msg_text.text = ""
	_set_version()
	lobby_connect.hide()
	
	server_option.add_item("Custom", 0)
	server_option.add_item("Europe", 1)
	server_option.select(1)
	address_input.hide()
	server_connect.show()

func _set_version():
	var f = File.new()
	f.open(version_file, File.READ)
	var line = f.get_line()
	version_text.text = "v" + str(line)
	f.close()

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
	var name = name_input.text.strip_edges()
	if not _check_name(name):
		return
	if host_toggle.pressed:
		Server.host_lobby(name)
	else:
		var join_code = join_code_input.text.strip_edges()
		if not _check_join_code(join_code):
			return
		Server.join_lobby(name, join_code)

func _check_name(name):
	if name.length() == 0:
		set_error("Please enter a name")
		return false
	set_status("")
	return true

func _check_join_code(name):
	if name.length() == 0:
		set_error("Please enter a Join Code")
		return false
	set_status("")
	return true

# General
func set_error(text):
	msg_text.text = text
	msg_text.set("custom_colors/font_color", Values.red)

func set_status(text):
	msg_text.text = text
	msg_text.set("custom_colors/font_color", Values.green)
