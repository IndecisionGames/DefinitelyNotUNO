extends Node

var player_id: int

var network = NetworkedMultiplayerENet.new()
var port = 31416
var ip = "127.0.0.1"

var player_name

func connect_to_server(name):
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("server_disconnected", self, "_server_disconnected")

	player_name = name

func _on_connection_failed():
	print("Failed to connect to server")

func _on_connection_succeeded():
	print("Successfully connected to server")

remote func join_server(players):
	print("Joining server with " + str(players) + " other players")
	SceneManager.goto_scene("res://src/lobby/Lobby.tscn", false)

func _server_disconnected():
	pass

 #### LOBBY ####
func join_lobby():
	rpc_id(1, "add_to_lobby", player_name)

func leave_lobby():
	rpc_id(1, "remove_from_lobby")

remote func update_lobby(pos, player_names):
	get_node("/root/Lobby").update_lobby(pos, player_names)
	
 #### Game Setup ####
func server_start_game():
	rpc_id(1, "start_game")

remote func set_rules(rules={}):
	Rules.set_rules(rules)

remote func set_game_state(player):
	player_id = player

remote func start_game():
	SceneManager.goto_scene("res://src/game/Game.tscn", false)
