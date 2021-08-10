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
var player_hands_map = {}

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

	load_hands()


func load_hands():
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

	assign_players_to_hands()
	position_node.show()

func assign_players_to_hands():
	var me = Server.player_id
	var counter = 0

	if me < Rules.NUM_PLAYERS - 1:
		for i in range(me+1, Rules.NUM_PLAYERS): # Players after me
			print("Adding player " + str(i) + " to hand " + str(i-me-1))
			player_hands_map[i] = player_hands[i - me -1]
			counter += 1

	print("next")
	for i in range(me): # Players before me
		print("Adding player " + str(i) + " to hand " + str(i+counter))
		player_hands_map[i] = player_hands[i + counter]
	
	for i in Rules.NUM_PLAYERS:
		if i == me:
			continue
		player_hands_map[i]._set_name("Player-" + str(i))


func _update():
	for i in Rules.NUM_PLAYERS:
		if i == Server.player_id:
			continue
		
		var text = ""
		if i == GameState.current_player:
			text = ">"

		text += GameState.players[i].name

		if i == GameState.current_player:
			text += "<"

		if GameState.players[i].uno_status:
			text += " (UNO)"
		
		player_hands_map[i]._set_name(text)
		player_hands_map[i].card_no = GameState.players[i].cards.size()
		player_hands_map[i]._update()
