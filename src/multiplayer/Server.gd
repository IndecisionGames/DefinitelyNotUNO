extends Node

const CardBase = preload("res://src/game/common/CardBase.gd")

var player_id: int
var is_local: bool

var player_name: String
var lobby_code: String
var is_host: bool

# Networking
const PORT = 31416
const DEFAULT_IP = "127.0.0.1"
var socket = WebSocketPeer.new()

func _ready():
	pass

func _process(_delta):
	if socket:
		socket.poll()
		var state = socket.get_ready_state()
		if (state == WebSocketPeer.STATE_CONNECTING || state == WebSocketPeer.STATE_OPEN):
			# TODO - do stuff
			pass

@rpc("any_peer") func error(msg):
	get_node("/root/Main").set_error(msg)

# Connecting
func connect_to_server(ip):
	if ip == "":
		ip = DEFAULT_IP
	var url = "ws://" + ip + ":" + str(PORT)
	socket.connect_to_url(url)
	get_tree().set_multiplayer_peer(socket)

# Lobby
func join_lobby(p_name, join_code):
	player_name = p_name
	rpc_id(1, "join_lobby", player_name, join_code)

func host_lobby(p_name):
	player_name = p_name
	rpc_id(1, "host_lobby", player_name)

func client_lobby_ready():
	rpc_id(1, "client_lobby_ready")

func return_to_lobby():
	rpc_id(1, "return_to_lobby")

@rpc("any_peer") func start_lobby(code, host):
	lobby_code = code
	is_host = host
	SceneManager.goto_scene("res://src/lobby/Lobby.tscn")

# Lobby
func update_rules(rules):
	rpc_id(1, "update_rules", rules)

@rpc("any_peer") func sync_lobby(players, rules):
	get_node("/root/Lobby").sync_lobby(players, rules)

# Game Setup
func server_start_game():
	rpc_id(1, "start_game")

@rpc("any_peer") func request_start(rules={}):
	Rules.load_from_dict(rules)
	SceneManager.goto_scene("res://src/game/Game.tscn", false)

func client_game_ready():
	rpc_id(1, "client_game_ready")

@rpc("any_peer") func set_player(player):
	player_id = player

# Server to Client
signal game_start()
signal game_update()
signal game_won(player)
signal cards_drawn(player, cards)
signal card_played(player, card)
signal event(event_type, player)
signal wild_pick_request(player)

@rpc("any_peer") func emit_game_start(game_state={}):
	if !Server.is_local:
		GameState.load_from_dict(game_state)
	emit_signal("game_start")

@rpc("any_peer") func emit_game_won(player):
	emit_signal("game_won", player)

@rpc("any_peer") func emit_game_update(game_state={}):
	if !Server.is_local:
		GameState.load_from_dict(game_state)
	emit_signal("game_update")

@rpc("any_peer") func emit_cards_drawn(player, cards):
	if !Server.is_local: # card is passed as dictionary via network
		var drawn_cards = []
		for card in cards:
			drawn_cards.append(CardBase.new().load_from_dict(card))
		emit_signal("cards_drawn", player, drawn_cards)
	else:
		emit_signal("cards_drawn", player, cards)

@rpc("any_peer") func emit_card_played(player, card):
	if !Server.is_local: # card is passed as dictionary via network
		emit_signal("card_played", player, CardBase.new().load_from_dict(card))
	else:
		emit_signal("card_played", player, card)

@rpc("any_peer") func emit_event(event_type, player):
	emit_signal("event", event_type, player)

@rpc("any_peer") func request_wild_pick(_player):
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
