extends MarginContainer

onready var turn_indicator = get_node("Turn")

func _ready():
	GameState.connect("new_turn", self, "_update")
	GameState.connect("refresh", self, "_update")
	
func _update():
	if Server.player_id == GameState.current_player:
		 turn_indicator.text = "Your Turn"
	else:
		turn_indicator.text = "Player %s's Turn" % GameState.current_player
