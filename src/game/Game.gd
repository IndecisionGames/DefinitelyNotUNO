extends Node

onready var hand = get_node("Hand")
onready var turn_indicator = get_node("TurnIndicator")
onready var turn_indicator_anim = get_node("TurnIndicator/AnimationPlayer")

var clockwise_play = true

func _ready():
	if !Server.is_local:
		randomize()
		Server.client_ready()
	else:
		var local_server = load("res://src/game/common/GameServer.gd").new()
		add_child(local_server)
		
		var local_names = ["Alice", "Bob", "Charlie", "Delta"]
		for i in range(Rules.NUM_PLAYERS):
			GameState.players.append(GameState.Player.new())
			GameState.players[i].name = local_names[i]
		local_server.start_game()
	turn_indicator_anim.play("Clockwise")

func _input(event):
	if Server.is_local:
		# Change Players
		if Input.is_action_just_pressed("ui_right") :
			Server.player_id += 1
			if Server.player_id >= Rules.NUM_PLAYERS:
				Server.player_id = 0
			hand._load()
			Server.emit_game_update()

func _process(_delta):
	if clockwise_play != GameState.play_order_clockwise:
		clockwise_play = GameState.play_order_clockwise
		if GameState.play_order_clockwise:
			turn_indicator.set_flip_v(false)
			turn_indicator_anim.play("Clockwise")
		else:
			turn_indicator.set_flip_v(true)
			turn_indicator_anim.play_backwards("Clockwise")