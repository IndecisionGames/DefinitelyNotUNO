extends Node

const CardBase = preload("res://src/game/common/CardBase.gd")

var player_name: String
var player_id: int
var is_host: bool

var is_local: bool

# Networking
var network = NetworkedMultiplayerENet.new()
var port = 31416
const default_ip = "127.0.0.1"

func connect_to_server(name, ip):
	if ip == "":
		ip = default_ip
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

remote func join_server(players, host=false):
	Server.is_host = host
	if Server.is_host: 
		print("You are the Host")

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

func update_rules(rules):
	rpc_id(1, "update_rules", rules)

remote func sync_rules(rules):
	get_node("/root/Lobby").find_node("RuleSettings").sync_rules(rules)


# Game Setup
func server_start_game():
	rpc_id(1, "start_game")

func client_ready():
	emit_signal("game_start")

remote func set_player(player):
	player_id = player

# Server to Client
signal game_start()
signal game_update()
signal game_won(player)
signal cards_drawn(player, cards)
signal card_played(player, card)
signal event(event_type, player)
signal wild_pick_request(player)

remote func emit_game_start(rules={}, game_state={}):
	if !Server.is_local:
		Rules.load_from_dict(rules)
		GameState.load_from_dict(game_state)
		SceneManager.goto_scene("res://src/game/Game.tscn", false)
		# wait for client_ready()
	else:
		emit_signal("game_start")

remote func emit_game_won(player):
	emit_signal("game_won", player)

remote func emit_game_update(game_state={}):
	if !Server.is_local:
		GameState.load_from_dict(game_state)
	emit_signal("game_update")

remote func emit_cards_drawn(player, cards):
	if !Server.is_local: # card is passed as dictionary via network
		var drawn_cards = []
		for card in cards:
			drawn_cards.append(CardBase.new().load_from_dict(card))
		emit_signal("cards_drawn", player, drawn_cards)
	else:
		emit_signal("cards_drawn", player, cards)

remote func emit_card_played(player, card):
	if !Server.is_local: # card is passed as dictionary via network
		emit_signal("card_played", player, CardBase.new().load_from_dict(card))
	else:
		emit_signal("card_played", player, card)

remote func emit_event(event_type, player):
	emit_signal("event", event_type, player)

remote func request_wild_pick(player):
	emit_signal("wild_pick_request")

# Client to Server
signal play_request(player, card)
signal draw_request(player)
signal uno_request(player)
signal wild_pick(colour)

func request_play_card(card):
	if !Server.is_local:
		rpc_id(1, "request_play_card", player_id, card.to_dict())
	else:
		emit_signal("play_request", player_id, card)

func request_draw_card():
	if !Server.is_local:
		rpc_id(1, "request_draw_card", player_id)
	else:
		emit_signal("draw_request", player_id)

func request_uno():
	if !Server.is_local:
		rpc_id(1, "request_uno", player_id)
	else:
		emit_signal("uno_request", player_id)

func emit_wild_pick(colour):
	if !Server.is_local:
		rpc_id(1, "wild_pick", colour)
	else:
		emit_signal("wild_pick", colour)
