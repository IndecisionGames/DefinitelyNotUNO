extends Node

var player_name: String
var player_id: int
var is_local: bool

# Networking
var network = NetworkedMultiplayerENet.new()
var port = 31416
var ip = "127.0.0.1"

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

# Lobby
func join_lobby():
	rpc_id(1, "add_to_lobby", player_name)

func leave_lobby():
	rpc_id(1, "remove_from_lobby")

remote func update_lobby(pos, player_names):
	get_node("/root/Lobby").update_lobby(pos, player_names)

# Game Setup
func server_start_game():
	rpc_id(1, "start_game")

remote func set_player(player):
	player_id = player

# Server to Client
signal game_start()
signal game_update()
signal card_added(card)
signal card_removed(card)
signal wild_pick_request(player)

remote func emit_game_start(rules={}, game_state={}):
	if !Server.is_local:
		pass
		SceneManager.goto_scene("res://src/game/Game.tscn", false)
	emit_signal("game_start")

remote func emit_game_update(game_state={}):
	if !Server.is_local:
		pass
	emit_signal("game_update")

remote func emit_card_added(player, card: CardBase):
	emit_signal("card_added", card)

remote func emit_card_removed(player, card: CardBase):
	emit_signal("card_removed", card)

remote func request_wild_pick(player):
	emit_signal("wild_pick_request")

# Client to Server
signal play_request(player, card)
signal draw_request(player)
signal uno_request(player)
signal wild_pick(colour)

func request_play_card(card: CardBase):
	if !Server.is_local:
		pass
	else:
		emit_signal("play_request", player_id, card)

func request_draw_card():
	if !Server.is_local:
		pass
	else:
		emit_signal("draw_request", player_id)

func request_uno():
	if !Server.is_local:
		pass
	else:
		emit_signal("uno_request", player_id)

func emit_wild_pick(colour):
	if !Server.is_local:
		pass
	else:
		emit_signal("wild_pick", colour)
