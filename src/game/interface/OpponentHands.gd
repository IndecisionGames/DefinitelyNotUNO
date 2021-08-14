extends Node

# Player hand positions (e.g. p2 = positions for a 2 player game)
onready var p2 = get_node("2P")
onready var p3 = get_node("3P")
onready var p4 = get_node("4P")
onready var p5 = get_node("5P")
onready var p6 = get_node("6P")
onready var p7 = get_node("7P")
onready var p8 = get_node("8P")

var player_hands = []

func _ready():
	Server.connect("game_start", self, "_update")
	Server.connect("game_update", self, "_update")
	p2.hide()
	p3.hide()
	p4.hide()
	p5.hide()
	p6.hide()
	p7.hide()
	p8.hide()
	_load_hands()

func _load_hands():
	var position_node = p2

	match Rules.NUM_PLAYERS:
		2:
			position_node = p2
		3:
			position_node = p3
		4:
			position_node = p4
		5:
			position_node = p5
		6:
			position_node = p6
		7:
			position_node = p7
		8:
			position_node = p8

	for i in Rules.NUM_PLAYERS:
		if i == 0:
			continue
		player_hands.append(position_node.get_node(str(i) + "/Hand"))

	position_node.show()

func _update():
	for i in Rules.NUM_PLAYERS:
		if i == Server.player_id:
			continue

		var pos = _player_to_position(i)
		player_hands[pos].update_hand(GameState.players[i].name, GameState.players[i].cards.size(), i == GameState.current_player, GameState.players[i].uno_status)

func _player_to_position(player):
	var pos = player - Server.player_id - 1
	if pos < 0:
		pos += Rules.NUM_PLAYERS
	return pos

func get_player_position(player):
	return player_hands[_player_to_position(player)].rect_global_position

func get_player_rotation(player):
	return player_hands[_player_to_position(player)].get_parent().rect_rotation
