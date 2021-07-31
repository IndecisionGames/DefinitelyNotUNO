extends Node

onready var hand = get_node("Hand")

func _ready():
	if !Server.is_local:
		Server.client_ready()
	else:
		var local_server = load("res://src/game/common/GameServer.gd").new()
		add_child(local_server)
		local_server.start_game()

func _input(event):
	if Server.is_local:
		# Change Players
		if Input.is_action_just_pressed("ui_right") :
			Server.player_id += 1
			if Server.player_id >= Rules.NUM_PLAYERS:
				Server.player_id = 0
			hand._load()
			Server.emit_game_update()
